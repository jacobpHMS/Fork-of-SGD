extends Node

# ============================================================================
# CARGO SPECIALIZATION SYSTEM (Corrected Version)
# ============================================================================
# Capacity comes from SHIP stats, not hold bonuses!
# Compression only for: GAS, LIQUID (1.6x), ORE, MINERAL (1.3x)
# Other types use capacity expansion modules instead

signal cargo_type_changed(hold_id: String, new_type: String)
signal compression_upgraded(hold_id: String, new_level: int)
signal hazmat_warning(material: String, requires_special: bool)
signal temperature_critical(hold_id: String, material: String)
signal capacity_module_installed(hold_id: String, cargo_type: String, bonus: float)
signal pressure_warning(hold_id: String, pressure_level: float)
signal pressure_critical(hold_id: String)
signal emergency_vent(hold_id: String, vented_amount: float)
signal cargo_explosion(hold_id: String, damage: float)

# Cargo types (matches Player.CargoType)
enum CargoType {
	GENERAL,      # Universal hold
	ORE,          # Raw ores
	MINERAL,      # Processed minerals
	LIQUID,       # Liquids (requires temperature control)
	GAS,          # Compressed gases
	AMMO,         # Ammunition
	BUILD,        # Building materials
	COMPONENTS,   # Components & Modules
	HAZMAT        # Radioactive/Toxic materials
}

# Compression technology levels
enum CompressionLevel {
	NONE = 0,      # Base capacity
	BASIC = 1,     # +20% or +10%
	ADVANCED = 2,  # +40% or +20%
	ELITE = 3      # +60% or +30%
}

# Pressure states (for Pressurized Compression)
enum PressureState {
	NORMAL,       # 0.8 - 1.0: Safe
	LOW,          # 0.5 - 0.8: Warning
	CRITICAL,     # 0.3 - 0.5: Danger
	FAILING,      # < 0.3: Imminent Failure
	CATASTROPHIC  # Explosion!
}

# Compression multipliers BY CARGO TYPE
const COMPRESSION_MULTIPLIER = {
	# Highly compressible (fluids)
	CargoType.GAS: {
		CompressionLevel.NONE: 1.0,
		CompressionLevel.BASIC: 1.2,     # +20%
		CompressionLevel.ADVANCED: 1.4,  # +40%
		CompressionLevel.ELITE: 1.6      # +60%
	},
	CargoType.LIQUID: {
		CompressionLevel.NONE: 1.0,
		CompressionLevel.BASIC: 1.2,     # +20%
		CompressionLevel.ADVANCED: 1.4,  # +40%
		CompressionLevel.ELITE: 1.6      # +60%
	},
	# Moderately compressible (solids)
	CargoType.ORE: {
		CompressionLevel.NONE: 1.0,
		CompressionLevel.BASIC: 1.1,     # +10%
		CompressionLevel.ADVANCED: 1.2,  # +20%
		CompressionLevel.ELITE: 1.3      # +30%
	},
	CargoType.MINERAL: {
		CompressionLevel.NONE: 1.0,
		CompressionLevel.BASIC: 1.1,     # +10%
		CompressionLevel.ADVANCED: 1.2,  # +20%
		CompressionLevel.ELITE: 1.3      # +30%
	},
	# NOT compressible - use capacity modules instead
	CargoType.AMMO: {
		CompressionLevel.NONE: 1.0,
		CompressionLevel.BASIC: 1.0,
		CompressionLevel.ADVANCED: 1.0,
		CompressionLevel.ELITE: 1.0
	},
	CargoType.BUILD: {
		CompressionLevel.NONE: 1.0,
		CompressionLevel.BASIC: 1.0,
		CompressionLevel.ADVANCED: 1.0,
		CompressionLevel.ELITE: 1.0
	},
	CargoType.COMPONENTS: {
		CompressionLevel.NONE: 1.0,
		CompressionLevel.BASIC: 1.0,
		CompressionLevel.ADVANCED: 1.0,
		CompressionLevel.ELITE: 1.0
	},
	CargoType.HAZMAT: {
		CompressionLevel.NONE: 1.0,
		CompressionLevel.BASIC: 1.0,
		CompressionLevel.ADVANCED: 1.0,
		CompressionLevel.ELITE: 1.0
	},
	CargoType.GENERAL: {
		CompressionLevel.NONE: 1.0,
		CompressionLevel.BASIC: 1.0,
		CompressionLevel.ADVANCED: 1.0,
		CompressionLevel.ELITE: 1.0
	}
}

# Compression tech costs
const COMPRESSION_COSTS = {
	CompressionLevel.BASIC: {"credits": 100000, "mineral_titanium": 500.0},
	CompressionLevel.ADVANCED: {"credits": 500000, "mineral_titanium": 2000.0, "component_compressor": 10.0},
	CompressionLevel.ELITE: {"credits": 2000000, "component_compressor": 50.0, "component_quantum_core": 5.0}
}

# Pressurized compression costs (GAS/LIQUID only)
const PRESSURIZED_COMPRESSION_COST = {
	"credits": 500000,
	"component_quantum_core": 50
}

# Pressurized compression constants
const PRESSURIZED_MULTIPLIER = 1.2  # Additional +20% capacity on top of compression
const PRESSURIZED_ENERGY_CONSUMPTION = 50.0   # Power/s
const PRESSURIZED_FUEL_CONSUMPTION = 5.0      # Fuel/hour
const PRESSURIZED_HEAT_GENERATION = 30.0      # Heat/s

# Transfer rates (units per second at dock)
const BASE_TRANSFER_RATE = 100.0  # units/second
const LIQUID_TRANSFER_RATE = 50.0  # Slower for liquids
const GAS_TRANSFER_RATE = 150.0    # Faster for compressed gas
const HAZMAT_TRANSFER_RATE = 25.0  # Very slow for safety

# ============================================================================
# PRESSURIZED COMPRESSION MODULE (GAS/LIQUID only)
# ============================================================================

class PressurizedCompressionModule:
	"""Advanced compression system with pressure management and risk"""
	var active: bool = true
	var pressure_level: float = 1.0          # 0.0 - 1.0 (100%)
	var max_pressure_psi: float = 1000.0
	var has_safety_systems: bool = true

	# Resource consumption
	var energy_consumption: float = PRESSURIZED_ENERGY_CONSUMPTION  # Power/s
	var fuel_consumption: float = PRESSURIZED_FUEL_CONSUMPTION      # Fuel/hour
	var heat_generation: float = PRESSURIZED_HEAT_GENERATION        # Heat/s

	# Safety thresholds
	var auto_vent_threshold: float = 0.2    # Auto-vent at 20% pressure
	var alarm_threshold: float = 0.5        # Alarm at 50% pressure
	var warning_threshold: float = 0.8      # Warning at 80% pressure

	func get_pressure_state() -> PressureState:
		"""Get current pressure state"""
		if pressure_level >= 0.8:
			return PressureState.NORMAL
		elif pressure_level >= 0.5:
			return PressureState.LOW
		elif pressure_level >= 0.3:
			return PressureState.CRITICAL
		elif pressure_level > 0.0:
			return PressureState.FAILING
		else:
			return PressureState.CATASTROPHIC

	func get_capacity_multiplier() -> float:
		"""Get capacity multiplier (only applies when pressure is maintained)"""
		if pressure_level >= 0.8:
			return PRESSURIZED_MULTIPLIER  # 1.2x
		else:
			# Pressure loss = capacity loss
			return 1.0 + (PRESSURIZED_MULTIPLIER - 1.0) * (pressure_level / 0.8)

	func update_pressure(delta: float, has_energy: bool, has_fuel: bool, temperature: float):
		"""Update pressure based on system status"""
		if not active:
			pressure_level = max(0.0, pressure_level - 0.05 * delta)
			return

		# Energy failure
		if not has_energy:
			pressure_level -= 0.1 * delta

		# Fuel failure
		if not has_fuel:
			pressure_level -= 0.08 * delta

		# Overheat (temperature > 100°C)
		if temperature > 100.0:
			var overheat_factor = (temperature - 100.0) / 100.0
			pressure_level -= 0.05 * overheat_factor * delta

		# Stabilize if all systems nominal
		if has_energy and has_fuel and temperature <= 100.0:
			pressure_level = min(1.0, pressure_level + 0.02 * delta)

		# Clamp
		pressure_level = clamp(pressure_level, 0.0, 1.0)

# Cargo hold data structure
class CargoHold:
	var hold_id: String = ""
	var cargo_type: CargoType = CargoType.GENERAL
	var compression_level: CompressionLevel = CompressionLevel.NONE

	# Ship reference (for getting base capacity)
	var ship_node: Node = null

	# Current storage
	var stored_items: Dictionary = {}  # item_id -> amount
	var used_capacity: float = 0.0

	# Capacity bonuses from modules (additive, in m³)
	var capacity_bonus: float = 0.0

	# Temperature control (for liquids)
	var has_temperature_control: bool = false
	var current_temperature: float = 20.0  # °C
	var target_temperature: float = 20.0   # °C

	# Hazmat handling
	var has_hazmat_shielding: bool = false
	var radiation_level: float = 0.0  # Current radiation exposure

	# Pressurized compression (GAS/LIQUID only)
	var pressurized_module: PressurizedCompressionModule = null

	func _init(id: String, type: CargoType, ship_ref: Node):
		hold_id = id
		cargo_type = type
		ship_node = ship_ref

	func get_base_capacity() -> float:
		"""Get base capacity from ship stats"""
		if not ship_node or not "ship_data" in ship_node:
			return 0.0

		var ship_data = ship_node.ship_data

		match cargo_type:
			CargoType.GENERAL:
				return ship_data.get("cargo_general_capacity", 0.0)
			CargoType.ORE:
				return ship_data.get("cargo_ore_capacity", 0.0)
			CargoType.MINERAL:
				return ship_data.get("cargo_mineral_capacity", 0.0)
			CargoType.LIQUID:
				return ship_data.get("cargo_liquid_capacity", 0.0)
			CargoType.GAS:
				return ship_data.get("cargo_gas_capacity", 0.0)
			CargoType.AMMO:
				return ship_data.get("cargo_ammo_capacity", 0.0)
			CargoType.BUILD:
				return ship_data.get("cargo_build_capacity", 0.0)
			CargoType.COMPONENTS:
				return ship_data.get("cargo_components_capacity", 0.0)
			CargoType.HAZMAT:
				return ship_data.get("cargo_hazmat_capacity", 0.0)
			_:
				return 0.0

	func get_compression_multiplier() -> float:
		"""Get compression multiplier for this cargo type"""
		if not COMPRESSION_MULTIPLIER.has(cargo_type):
			return 1.0

		var type_multipliers = COMPRESSION_MULTIPLIER[cargo_type]
		return type_multipliers.get(compression_level, 1.0)

	func get_effective_capacity() -> float:
		"""Calculate total capacity with all modifiers"""
		var base = get_base_capacity()
		var compression = get_compression_multiplier()
		var pressurized = 1.0

		# Pressurized compression bonus (GAS/LIQUID only)
		if pressurized_module != null:
			pressurized = pressurized_module.get_capacity_multiplier()

		# Formula: (Base + Bonuses) * Compression * Pressurized
		return (base + capacity_bonus) * compression * pressurized

	func can_store(item_id: String, amount: float, item_type: CargoType) -> bool:
		"""Check if item can be stored"""
		var effective_cap = get_effective_capacity()
		var available = effective_cap - used_capacity

		if amount > available:
			return false

		# Type compatibility - only exact match allowed (no GENERAL fallback)
		if cargo_type != item_type:
			print("⚠️ Type mismatch: Hold is %s, item is %s" % [CargoType.keys()[cargo_type], CargoType.keys()[item_type]])
			return false

		return true

	func store_item(item_id: String, amount: float, item_type: CargoType) -> float:
		"""Store item in hold, returns amount actually stored"""
		if not can_store(item_id, amount, item_type):
			var effective_cap = get_effective_capacity()
			var available = effective_cap - used_capacity
			amount = min(amount, available)

			if amount <= 0:
				return 0.0

		# Add to storage
		if stored_items.has(item_id):
			stored_items[item_id] += amount
		else:
			stored_items[item_id] = amount

		used_capacity += amount
		return amount

	func remove_item(item_id: String, amount: float) -> float:
		"""Remove item from hold, returns amount actually removed"""
		if not stored_items.has(item_id):
			return 0.0

		var available = stored_items[item_id]
		var to_remove = min(amount, available)

		stored_items[item_id] -= to_remove
		if stored_items[item_id] <= 0:
			stored_items.erase(item_id)

		used_capacity -= to_remove
		return to_remove

	func can_upgrade_compression() -> bool:
		"""Check if compression upgrade is possible for this cargo type"""
		# Only GAS, LIQUID, ORE, MINERAL can be compressed
		return cargo_type in [CargoType.GAS, CargoType.LIQUID, CargoType.ORE, CargoType.MINERAL]

	func upgrade_compression(new_level: CompressionLevel) -> bool:
		"""Upgrade compression technology"""
		if new_level <= compression_level:
			return false

		if not can_upgrade_compression():
			print("❌ Compression not available for %s" % CargoType.keys()[cargo_type])
			return false

		compression_level = new_level
		var multiplier = get_compression_multiplier()
		print("✅ Compression upgraded to level %d (%.1fx capacity)" % [new_level, multiplier])
		return true

	func add_capacity_bonus(bonus: float):
		"""Add capacity bonus from modules (in m³)"""
		capacity_bonus += bonus
		print("✅ Capacity bonus added: +%.0f m³ (Total bonus: %.0f m³)" % [bonus, capacity_bonus])

	func get_info() -> Dictionary:
		"""Get detailed hold information"""
		var info = {
			"hold_id": hold_id,
			"cargo_type": CargoType.keys()[cargo_type],
			"base_capacity": get_base_capacity(),
			"capacity_bonus": capacity_bonus,
			"compression_level": compression_level,
			"compression_multiplier": get_compression_multiplier(),
			"effective_capacity": get_effective_capacity(),
			"used_capacity": used_capacity,
			"free_capacity": get_effective_capacity() - used_capacity,
			"percent_full": (used_capacity / get_effective_capacity()) * 100.0 if get_effective_capacity() > 0 else 0.0,
			"has_temperature_control": has_temperature_control,
			"has_hazmat_shielding": has_hazmat_shielding,
			"can_compress": can_upgrade_compression(),
			"item_count": stored_items.size()
		}

		# Pressurized compression info
		if pressurized_module != null:
			info["has_pressurized"] = true
			info["pressure_level"] = pressurized_module.pressure_level
			info["pressure_state"] = PressureState.keys()[pressurized_module.get_pressure_state()]
			info["pressurized_multiplier"] = pressurized_module.get_capacity_multiplier()
		else:
			info["has_pressurized"] = false

		return info

# Ship cargo holds
var cargo_holds: Dictionary = {}  # hold_id -> CargoHold

func _ready():
	print("📦 Cargo Specialization System initialized (Corrected Version)")

# ============================================================================
# CARGO HOLD MANAGEMENT
# ============================================================================

func create_cargo_hold(hold_id: String, type: CargoType, ship_ref: Node) -> bool:
	"""Create a new cargo hold linked to ship"""
	if cargo_holds.has(hold_id):
		print("❌ Hold already exists: %s" % hold_id)
		return false

	var hold = CargoHold.new(hold_id, type, ship_ref)
	cargo_holds[hold_id] = hold

	var base_cap = hold.get_base_capacity()
	print("✅ Cargo hold created: %s (%s, %.0f m³ base)" % [hold_id, CargoType.keys()[type], base_cap])
	return true

func change_cargo_type(hold_id: String, new_type: CargoType) -> bool:
	"""Change hold cargo type (must be empty)"""
	if not cargo_holds.has(hold_id):
		print("❌ Hold not found: %s" % hold_id)
		return false

	var hold = cargo_holds[hold_id]

	if hold.used_capacity > 0:
		print("❌ Cannot change cargo type - hold must be empty")
		return false

	hold.cargo_type = new_type
	hold.compression_level = CompressionLevel.NONE  # Reset compression
	emit_signal("cargo_type_changed", hold_id, CargoType.keys()[new_type])
	print("✅ Hold cargo type changed: %s → %s" % [hold_id, CargoType.keys()[new_type]])

	return true

func upgrade_compression(hold_id: String, new_level: CompressionLevel, player_resources: Dictionary) -> bool:
	"""Upgrade compression technology"""
	if not cargo_holds.has(hold_id):
		return false

	var hold = cargo_holds[hold_id]

	# Check if cargo type can be compressed
	if not hold.can_upgrade_compression():
		print("❌ %s cargo cannot be compressed - use capacity modules instead" % CargoType.keys()[hold.cargo_type])
		return false

	# Check costs
	if not COMPRESSION_COSTS.has(new_level):
		print("❌ Invalid compression level")
		return false

	var costs = COMPRESSION_COSTS[new_level]
	for resource in costs:
		var required = costs[resource]
		var available = player_resources.get(resource, 0.0)

		if available < required:
			print("❌ Insufficient %s: need %.0f, have %.0f" % [resource, required, available])
			return false

	# Upgrade
	if hold.upgrade_compression(new_level):
		emit_signal("compression_upgraded", hold_id, new_level)
		return true

	return false

func install_capacity_module(hold_id: String, bonus_m3: float) -> bool:
	"""Install capacity expansion module (for non-compressible cargo)"""
	if not cargo_holds.has(hold_id):
		return false

	var hold = cargo_holds[hold_id]
	hold.add_capacity_bonus(bonus_m3)
	emit_signal("capacity_module_installed", hold_id, CargoType.keys()[hold.cargo_type], bonus_m3)
	return true

func install_temperature_control(hold_id: String, cost: float) -> bool:
	"""Install temperature control for liquids"""
	if not cargo_holds.has(hold_id):
		return false

	var hold = cargo_holds[hold_id]

	if hold.has_temperature_control:
		print("⚠️ Temperature control already installed")
		return false

	hold.has_temperature_control = true
	print("❄️ Temperature control installed on %s" % hold_id)
	return true

func install_hazmat_shielding(hold_id: String, cost: float) -> bool:
	"""Install hazmat shielding for radioactive/toxic materials"""
	if not cargo_holds.has(hold_id):
		return false

	var hold = cargo_holds[hold_id]

	if hold.has_hazmat_shielding:
		print("⚠️ Hazmat shielding already installed")
		return false

	hold.has_hazmat_shielding = true
	print("☢️ Hazmat shielding installed on %s" % hold_id)
	return true

func install_pressurized_compression(hold_id: String, player_resources: Dictionary, safety_systems: bool = true) -> bool:
	"""Install pressurized compression module (GAS/LIQUID only)"""
	if not cargo_holds.has(hold_id):
		print("❌ Hold not found: %s" % hold_id)
		return false

	var hold = cargo_holds[hold_id]

	# Check cargo type (only GAS/LIQUID allowed)
	if hold.cargo_type != CargoType.GAS and hold.cargo_type != CargoType.LIQUID:
		print("❌ Pressurized compression only available for GAS and LIQUID holds")
		return false

	# Check if already installed
	if hold.pressurized_module != null:
		print("⚠️ Pressurized compression already installed")
		return false

	# Check if compression is already ELITE
	if hold.compression_level != CompressionLevel.ELITE:
		print("❌ ELITE compression required before installing pressurized module")
		return false

	# Check costs
	for resource in PRESSURIZED_COMPRESSION_COST:
		var required = PRESSURIZED_COMPRESSION_COST[resource]
		var available = player_resources.get(resource, 0.0)

		if available < required:
			print("❌ Insufficient %s: need %.0f, have %.0f" % [resource, required, available])
			return false

	# Install module
	hold.pressurized_module = PressurizedCompressionModule.new()
	hold.pressurized_module.has_safety_systems = safety_systems

	print("⚠️ PRESSURIZED COMPRESSION INSTALLED on %s" % hold_id)
	print("   ⚡ Requires: %.0f Power/s" % PRESSURIZED_ENERGY_CONSUMPTION)
	print("   ⛽ Requires: %.0f Fuel/hour" % PRESSURIZED_FUEL_CONSUMPTION)
	print("   🌡️ Generates: %.0f Heat/s" % PRESSURIZED_HEAT_GENERATION)
	print("   💥 WARNING: EXPLOSION RISK IF SYSTEMS FAIL!")

	return true

func remove_pressurized_compression(hold_id: String) -> bool:
	"""Remove pressurized compression module"""
	if not cargo_holds.has(hold_id):
		return false

	var hold = cargo_holds[hold_id]

	if hold.pressurized_module == null:
		print("⚠️ No pressurized compression installed")
		return false

	hold.pressurized_module = null
	print("✅ Pressurized compression removed from %s" % hold_id)
	return true

# ============================================================================
# CARGO OPERATIONS
# ============================================================================

func store_cargo(hold_id: String, item_id: String, amount: float, item_type: CargoType) -> float:
	"""Store cargo in specific hold"""
	if not cargo_holds.has(hold_id):
		print("❌ Hold not found: %s" % hold_id)
		return 0.0

	var hold = cargo_holds[hold_id]

	# Check hazmat requirements
	if item_type == CargoType.HAZMAT and not hold.has_hazmat_shielding:
		emit_signal("hazmat_warning", item_id, true)
		print("❌ Hazmat shielding required for %s" % item_id)
		return 0.0

	# Check temperature requirements
	if item_type == CargoType.LIQUID and not hold.has_temperature_control:
		emit_signal("temperature_critical", hold_id, item_id)
		print("⚠️ Temperature control recommended for liquids")
		# Allow but with warning

	return hold.store_item(item_id, amount, item_type)

func remove_cargo(hold_id: String, item_id: String, amount: float) -> float:
	"""Remove cargo from specific hold"""
	if not cargo_holds.has(hold_id):
		return 0.0

	var hold = cargo_holds[hold_id]
	return hold.remove_item(item_id, amount)

func transfer_cargo(from_hold_id: String, to_hold_id: String, item_id: String, amount: float, item_type: CargoType) -> float:
	"""Transfer cargo between holds"""
	var removed = remove_cargo(from_hold_id, item_id, amount)
	if removed <= 0:
		return 0.0

	var stored = store_cargo(to_hold_id, item_id, removed, item_type)

	# Return unused amount to source
	if stored < removed:
		var unused = removed - stored
		var from_hold = cargo_holds[from_hold_id]
		from_hold.store_item(item_id, unused, item_type)

	return stored

# ============================================================================
# STATION DOCKING & TRANSFER
# ============================================================================

func calculate_transfer_rate(item_type: CargoType) -> float:
	"""Calculate transfer rate based on cargo type"""
	match item_type:
		CargoType.LIQUID:
			return LIQUID_TRANSFER_RATE
		CargoType.GAS:
			return GAS_TRANSFER_RATE
		CargoType.HAZMAT:
			return HAZMAT_TRANSFER_RATE
		_:
			return BASE_TRANSFER_RATE

func calculate_transfer_time(amount: float, item_type: CargoType) -> float:
	"""Calculate time required to transfer cargo (in seconds)"""
	var rate = calculate_transfer_rate(item_type)
	return amount / rate

# ============================================================================
# PRESSURE SYSTEM (Gas Storage & Pressurized Compression)
# ============================================================================

const MAX_PRESSURE_PSI = 1000.0  # Maximum safe pressure
const CRITICAL_PRESSURE_PSI = 950.0  # Warning threshold

func calculate_gas_pressure(hold_id: String) -> float:
	"""Calculate current pressure in gas hold"""
	if not cargo_holds.has(hold_id):
		return 0.0

	var hold = cargo_holds[hold_id]

	if hold.cargo_type != CargoType.GAS:
		return 0.0

	# Pressure = (used_capacity / effective_capacity) * MAX_PRESSURE
	var effective_cap = hold.get_effective_capacity()
	if effective_cap <= 0:
		return 0.0

	var pressure = (hold.used_capacity / effective_cap) * MAX_PRESSURE_PSI

	if pressure >= CRITICAL_PRESSURE_PSI:
		print("⚠️ WARNING: Gas pressure critical in %s (%.0f PSI)" % [hold_id, pressure])

	return pressure

func is_gas_hold_safe(hold_id: String) -> bool:
	"""Check if gas hold is within safe pressure limits"""
	var pressure = calculate_gas_pressure(hold_id)
	return pressure < MAX_PRESSURE_PSI

func update_pressurized_systems(delta: float, ship_ref: Node):
	"""Update all pressurized compression systems (call every frame)"""
	for hold_id in cargo_holds:
		var hold = cargo_holds[hold_id]

		if hold.pressurized_module == null:
			continue

		# Get ship systems status
		var has_energy = true
		var has_fuel = true
		var temperature = hold.current_temperature

		# Check ship systems if available
		if ship_ref and "ship_data" in ship_ref:
			var ship_data = ship_ref.ship_data
			has_energy = ship_data.get("energy", 0.0) > PRESSURIZED_ENERGY_CONSUMPTION * delta
			has_fuel = ship_data.get("fuel", 0.0) > 0.0

		# Update pressure
		var module = hold.pressurized_module
		var old_state = module.get_pressure_state()
		module.update_pressure(delta, has_energy, has_fuel, temperature)
		var new_state = module.get_pressure_state()

		# State change warnings
		if old_state != new_state:
			match new_state:
				PressureState.LOW:
					emit_signal("pressure_warning", hold_id, module.pressure_level)
					print("⚠️ Pressure WARNING in %s: %.1f%%" % [hold_id, module.pressure_level * 100.0])
				PressureState.CRITICAL:
					emit_signal("pressure_critical", hold_id)
					print("🚨 Pressure CRITICAL in %s: %.1f%%" % [hold_id, module.pressure_level * 100.0])
				PressureState.FAILING:
					print("💥 Pressure FAILING in %s: %.1f%% - EXPLOSION IMMINENT!" % [hold_id, module.pressure_level * 100.0])

		# Auto-vent if safety systems enabled
		if module.has_safety_systems and module.pressure_level <= module.auto_vent_threshold:
			perform_emergency_vent(hold_id)

		# Catastrophic failure
		if new_state == PressureState.CATASTROPHIC:
			catastrophic_failure(hold_id, ship_ref)

func perform_emergency_vent(hold_id: String) -> bool:
	"""Emergency vent - loses 50% cargo but saves ship"""
	if not cargo_holds.has(hold_id):
		return false

	var hold = cargo_holds[hold_id]

	if hold.pressurized_module == null:
		return false

	# Vent 50% of cargo
	var vented_amount = hold.used_capacity * 0.5
	hold.used_capacity *= 0.5

	# Reduce all stored items by 50%
	for item_id in hold.stored_items:
		hold.stored_items[item_id] *= 0.5

	# Stabilize pressure
	hold.pressurized_module.pressure_level = 0.3

	emit_signal("emergency_vent", hold_id, vented_amount)
	print("🌊 EMERGENCY VENT in %s: %.0f m³ lost, ship saved!" % [hold_id, vented_amount])

	return true

func catastrophic_failure(hold_id: String, ship_ref: Node):
	"""Catastrophic pressure failure - EXPLOSION!"""
	if not cargo_holds.has(hold_id):
		return

	var hold = cargo_holds[hold_id]

	# Calculate explosion damage based on cargo amount
	var explosion_damage = hold.used_capacity * 0.5

	# Clear all cargo
	hold.stored_items.clear()
	hold.used_capacity = 0.0

	# Destroy pressurized module
	hold.pressurized_module = null

	emit_signal("cargo_explosion", hold_id, explosion_damage)
	print("💥💥💥 CATASTROPHIC EXPLOSION in %s!" % hold_id)
	print("   💀 Damage: %.0f" % explosion_damage)
	print("   📦 All cargo LOST!")
	print("   🔧 Pressurized module DESTROYED!")

	# Apply damage to ship if reference exists
	if ship_ref and ship_ref.has_method("take_damage"):
		ship_ref.take_damage(explosion_damage)

# ============================================================================
# SAVE/LOAD INTEGRATION
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export cargo data for saving"""
	var holds_data = {}

	for hold_id in cargo_holds:
		var hold = cargo_holds[hold_id]
		var hold_data = {
			"cargo_type": hold.cargo_type,
			"compression_level": hold.compression_level,
			"capacity_bonus": hold.capacity_bonus,
			"stored_items": hold.stored_items.duplicate(),
			"used_capacity": hold.used_capacity,
			"has_temperature_control": hold.has_temperature_control,
			"has_hazmat_shielding": hold.has_hazmat_shielding,
			"current_temperature": hold.current_temperature,
			"radiation_level": hold.radiation_level
		}

		# Save pressurized module if present
		if hold.pressurized_module != null:
			hold_data["has_pressurized"] = true
			hold_data["pressure_level"] = hold.pressurized_module.pressure_level
			hold_data["pressurized_active"] = hold.pressurized_module.active
			hold_data["has_safety_systems"] = hold.pressurized_module.has_safety_systems
		else:
			hold_data["has_pressurized"] = false

		holds_data[hold_id] = hold_data

	return {
		"cargo_holds": holds_data
	}

func load_save_data(data: Dictionary, ship_ref: Node):
	"""Import cargo data from save file"""
	cargo_holds.clear()

	if data.has("cargo_holds"):
		for hold_id in data["cargo_holds"]:
			var hold_data = data["cargo_holds"][hold_id]
			var hold = CargoHold.new(hold_id, hold_data["cargo_type"], ship_ref)
			hold.compression_level = hold_data.get("compression_level", CompressionLevel.NONE)
			hold.capacity_bonus = hold_data.get("capacity_bonus", 0.0)
			hold.stored_items = hold_data["stored_items"].duplicate()
			hold.used_capacity = hold_data["used_capacity"]
			hold.has_temperature_control = hold_data.get("has_temperature_control", false)
			hold.has_hazmat_shielding = hold_data.get("has_hazmat_shielding", false)
			hold.current_temperature = hold_data.get("current_temperature", 20.0)
			hold.radiation_level = hold_data.get("radiation_level", 0.0)

			# Load pressurized module if present
			if hold_data.get("has_pressurized", false):
				hold.pressurized_module = PressurizedCompressionModule.new()
				hold.pressurized_module.pressure_level = hold_data.get("pressure_level", 1.0)
				hold.pressurized_module.active = hold_data.get("pressurized_active", true)
				hold.pressurized_module.has_safety_systems = hold_data.get("has_safety_systems", true)

			cargo_holds[hold_id] = hold

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_hold_info(hold_id: String) -> Dictionary:
	"""Get detailed hold information"""
	if not cargo_holds.has(hold_id):
		return {}

	return cargo_holds[hold_id].get_info()

func get_all_holds_info() -> Array:
	"""Get information for all holds"""
	var result = []
	for hold_id in cargo_holds:
		result.append(cargo_holds[hold_id].get_info())
	return result

func get_total_cargo_stats() -> Dictionary:
	"""Get total cargo statistics"""
	var total_capacity = 0.0
	var total_used = 0.0

	for hold_id in cargo_holds:
		var hold = cargo_holds[hold_id]
		total_capacity += hold.get_effective_capacity()
		total_used += hold.used_capacity

	return {
		"total_capacity": total_capacity,
		"total_used": total_used,
		"total_free": total_capacity - total_used,
		"percent_full": (total_used / total_capacity) * 100.0 if total_capacity > 0 else 0.0,
		"hold_count": cargo_holds.size()
	}

func find_best_hold_for_item(item_id: String, amount: float, item_type: CargoType) -> String:
	"""Find best cargo hold for storing an item"""
	# Only exact type match allowed now
	for hold_id in cargo_holds:
		var hold = cargo_holds[hold_id]

		if hold.cargo_type == item_type and hold.can_store(item_id, amount, item_type):
			return hold_id

	return ""  # No suitable hold found
