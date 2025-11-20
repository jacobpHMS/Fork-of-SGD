extends Node

# ============================================================================
# TEMPERATURE & COOLING SYSTEM
# ============================================================================
# Manages ship temperature, coolant consumption, and thermal limits
# Cross-references with Module System, Boost Modes, and Emergency Systems

signal temperature_warning(temp: float)  # Emitted at 80°C
signal temperature_critical(temp: float)  # Emitted at 95°C
signal temperature_damage(temp: float)  # Emitted at 100°C+
signal coolant_low(amount: float)  # Emitted at <100 units
signal coolant_depleted()  # Emitted at 0 units

# Temperature constants
const BASE_TEMP: float = 20.0  # °C - Space background temperature
const WARNING_TEMP: float = 80.0  # °C - Yellow warning
const CRITICAL_TEMP: float = 95.0  # °C - General critical threshold

# Component-specific temperature limits
const CPU_CRITICAL_TEMP: float = 95.0  # °C - CPU/Electronics critical
const ENGINE_CRITICAL_TEMP: float = 150.0  # °C - Engines can handle more
const SHIELD_CRITICAL_TEMP: float = 120.0  # °C - Shield systems
const ARMOR_BASE_TEMP: float = 200.0  # °C - Base armor tolerance (increases with quality)

const DAMAGE_TEMP: float = 200.0  # °C - Hull damage starts (armor-dependent)
const MAX_TEMP: float = 300.0  # °C - Absolute maximum

# Coolant constants
const COOLANT_EFFICIENCY: float = 100.0  # 1 unit = 100 ticks = ~10 minutes
const COOLANT_LOW_THRESHOLD: float = 100.0  # Warning threshold
const MAX_COOLANT_CAPACITY: float = 1000.0  # Standard capacity = ~16h operation

# Heat generation rates (per tick = 1/60s)
const HEAT_IDLE: float = 0.017  # ~1°C per minute idle
const HEAT_PER_MODULE: float = 0.1  # Per active module per tick
const HEAT_PER_WEAPON: float = 0.5  # Per weapon firing per tick
const HEAT_BOOST_MULTIPLIER: float = 3.0  # 3x heat in boost mode

# Cooling rates
const PASSIVE_COOLING_RATE: float = 0.05  # °C per tick (radiators)
const ACTIVE_COOLING_RATE: float = 0.5  # °C per tick with coolant
const HULL_COOLING_PRIORITY: float = 2.0  # Hull/Structure gets 2x cooling priority

# Current state
var current_temperature: float = BASE_TEMP
var coolant_amount: float = MAX_COOLANT_CAPACITY
var is_emergency_shutdown: bool = false
var active_modules_count: int = 0
var boost_mode_active: bool = false

# Armor quality (affects heat tolerance)
var armor_quality: float = 1.0  # 1.0 = standard, higher = better heat resistance
var armor_heat_bonus: float = 0.0  # Additional °C tolerance from armor

# Warning state tracking
var warning_triggered: bool = false
var critical_triggered: bool = false
var cpu_critical_triggered: bool = false

# Coolant type (for future tiers)
enum CoolantType {
	WATER,  # Tier 0 - Basic, +0.5°C cooling
	NITROGEN,  # Tier 1 - +1.0°C cooling
	HELIUM_3,  # Tier 2 - +1.5°C cooling
	EXOTIC  # Tier 3 - +2.0°C cooling
}

var current_coolant_type: CoolantType = CoolantType.WATER
var coolant_type_multiplier: float = 1.0

func _ready():
	update_coolant_multiplier()

func _process(delta):
	# Update temperature every frame
	update_temperature(delta)

	# Check for warnings
	check_temperature_warnings()

	# Apply damage if overheating
	if current_temperature >= DAMAGE_TEMP and not is_emergency_shutdown:
		apply_heat_damage(delta)

# ============================================================================
# TEMPERATURE CALCULATIONS
# ============================================================================

func update_temperature(delta: float):
	"""Update ship temperature based on activity"""
	var heat_generation = 0.0

	# Base idle heat
	heat_generation += HEAT_IDLE

	# Heat from active modules
	heat_generation += active_modules_count * HEAT_PER_MODULE

	# Boost mode multiplier
	if boost_mode_active:
		heat_generation *= HEAT_BOOST_MULTIPLIER

	# Apply heat generation
	current_temperature += heat_generation * delta * 60.0  # Convert to per-second

	# Cooling systems
	var cooling = 0.0

	# Passive cooling (always active)
	cooling += PASSIVE_COOLING_RATE

	# Active cooling (if coolant available)
	# HULL/STRUCTURE gets PRIORITY cooling (2x multiplier)
	if coolant_amount > 0 and not is_emergency_shutdown:
		var base_cooling = ACTIVE_COOLING_RATE * coolant_type_multiplier
		# Hull gets priority - effective 2x cooling
		cooling += base_cooling * HULL_COOLING_PRIORITY

		# Consume coolant
		var coolant_consumption = (delta * 60.0) / COOLANT_EFFICIENCY  # Per tick
		coolant_amount = max(0, coolant_amount - coolant_consumption)

		# Check coolant levels
		if coolant_amount <= 0:
			emit_signal("coolant_depleted")
			print("❌ COOLANT DEPLETED - Temperature rising rapidly!")
		elif coolant_amount < COOLANT_LOW_THRESHOLD and int(coolant_amount) % 10 == 0:
			emit_signal("coolant_low", coolant_amount)

	# Apply cooling
	current_temperature -= cooling * delta * 60.0

	# Clamp temperature
	current_temperature = clamp(current_temperature, BASE_TEMP, MAX_TEMP)

	# Emergency shutdown recovery
	if is_emergency_shutdown and current_temperature < WARNING_TEMP:
		is_emergency_shutdown = false
		print("✅ Temperature normalized - Systems back online")

func check_temperature_warnings():
	"""Check and emit temperature warnings (component-specific)"""

	# CPU CRITICAL at 95°C - Emergency shutdown for electronics
	if current_temperature >= CPU_CRITICAL_TEMP and not cpu_critical_triggered:
		cpu_critical_triggered = true
		critical_triggered = true
		warning_triggered = true
		emit_signal("temperature_critical", current_temperature)
		trigger_emergency_shutdown()
		print("🚨 CPU/ELECTRONICS CRITICAL: %.1f°C - Emergency shutdown!" % current_temperature)

	# General warning at 80°C
	elif current_temperature >= WARNING_TEMP and not warning_triggered:
		warning_triggered = true
		emit_signal("temperature_warning", current_temperature)
		print("⚠️ WARNING: Temperature at %.1f°C" % current_temperature)

	# Reset warnings when temperature drops
	if current_temperature < WARNING_TEMP:
		warning_triggered = false
		critical_triggered = false
		cpu_critical_triggered = false

func trigger_emergency_shutdown():
	"""Emergency shutdown at 95°C - disable all modules"""
	is_emergency_shutdown = true
	active_modules_count = 0  # Force all modules off
	boost_mode_active = false
	print("🚨 EMERGENCY SHUTDOWN - Temperature critical!")

func apply_heat_damage(delta: float):
	"""Apply damage when temperature exceeds armor-dependent threshold"""
	# Calculate armor-adjusted damage threshold
	var damage_threshold = DAMAGE_TEMP + armor_heat_bonus

	# Only apply damage if above threshold
	if current_temperature < damage_threshold:
		return

	var damage_per_second = 10.0  # 10 HP/s base
	var excess_temp = current_temperature - damage_threshold
	var actual_damage = damage_per_second * (1.0 + excess_temp * 0.1) * delta

	# Armor quality reduces damage
	actual_damage /= armor_quality

	emit_signal("temperature_damage", actual_damage)
	print("🔥 HEAT DAMAGE: %.1f HP/s at %.1f°C (Armor: %.1fx)" % [actual_damage, current_temperature, armor_quality])

# ============================================================================
# MODULE INTERACTION
# ============================================================================

func register_module_activation(count: int = 1):
	"""Called when a module is activated"""
	if is_emergency_shutdown:
		print("❌ Emergency shutdown active - Cannot activate modules")
		return false

	active_modules_count += count
	return true

func register_module_deactivation(count: int = 1):
	"""Called when a module is deactivated"""
	active_modules_count = max(0, active_modules_count - count)

func set_boost_mode(enabled: bool):
	"""Enable/disable boost mode (3x heat generation)"""
	boost_mode_active = enabled
	if enabled:
		print("⚡ BOOST MODE ACTIVE - Heat generation increased!")

func set_armor_quality(quality: float, material_purity: float = 1.0):
	"""Set armor quality (affects heat tolerance)"""
	armor_quality = quality
	# Higher purity materials increase heat tolerance
	# Example: Pure minerals give +50°C, standard give +0°C
	armor_heat_bonus = (material_purity - 1.0) * 50.0 if material_purity > 1.0 else 0.0

	print("🛡️ Armor quality set: %.1fx (Heat bonus: +%.0f°C)" % [armor_quality, armor_heat_bonus])

# ============================================================================
# COOLANT MANAGEMENT
# ============================================================================

func add_coolant(amount: float) -> float:
	"""Add coolant to storage, returns amount actually added"""
	var space_available = MAX_COOLANT_CAPACITY - coolant_amount
	var to_add = min(amount, space_available)
	coolant_amount += to_add
	return to_add

func remove_coolant(amount: float) -> float:
	"""Remove coolant from storage, returns amount actually removed"""
	var to_remove = min(amount, coolant_amount)
	coolant_amount -= to_remove
	return to_remove

func set_coolant_type(type: CoolantType):
	"""Change coolant type (for upgrades)"""
	current_coolant_type = type
	update_coolant_multiplier()
	print("🧊 Coolant type changed to: %s" % CoolantType.keys()[type])

func update_coolant_multiplier():
	"""Update cooling efficiency based on coolant type"""
	match current_coolant_type:
		CoolantType.WATER:
			coolant_type_multiplier = 1.0
		CoolantType.NITROGEN:
			coolant_type_multiplier = 2.0
		CoolantType.HELIUM_3:
			coolant_type_multiplier = 3.0
		CoolantType.EXOTIC:
			coolant_type_multiplier = 4.0

func get_coolant_runtime_minutes() -> float:
	"""Calculate remaining runtime in minutes at current consumption"""
	if coolant_amount <= 0:
		return 0.0

	# Ticks per unit * units / ticks per minute (60 * 60)
	return (COOLANT_EFFICIENCY * coolant_amount) / (60.0 * 60.0)

# ============================================================================
# SAVE/LOAD INTEGRATION
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export temperature system data for saving"""
	return {
		"temperature": current_temperature,
		"coolant_amount": coolant_amount,
		"coolant_type": current_coolant_type,
		"is_emergency_shutdown": is_emergency_shutdown,
		"armor_quality": armor_quality,
		"armor_heat_bonus": armor_heat_bonus
	}

func load_save_data(data: Dictionary):
	"""Import temperature system data from save file"""
	current_temperature = data.get("temperature", BASE_TEMP)
	coolant_amount = data.get("coolant_amount", MAX_COOLANT_CAPACITY)
	current_coolant_type = data.get("coolant_type", CoolantType.WATER)
	is_emergency_shutdown = data.get("is_emergency_shutdown", false)
	armor_quality = data.get("armor_quality", 1.0)
	armor_heat_bonus = data.get("armor_heat_bonus", 0.0)
	update_coolant_multiplier()

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_temperature_status() -> String:
	"""Get human-readable temperature status"""
	if current_temperature >= CRITICAL_TEMP:
		return "CRITICAL"
	elif current_temperature >= WARNING_TEMP:
		return "WARNING"
	elif current_temperature > BASE_TEMP + 20:
		return "ELEVATED"
	else:
		return "NORMAL"

func get_temperature_color() -> Color:
	"""Get color for temperature display"""
	if current_temperature >= CRITICAL_TEMP:
		return Color.RED
	elif current_temperature >= WARNING_TEMP:
		return Color.YELLOW
	else:
		return Color.GREEN

func get_system_info() -> Dictionary:
	"""Get detailed system information"""
	return {
		"temperature": current_temperature,
		"temperature_status": get_temperature_status(),
		"cpu_critical_temp": CPU_CRITICAL_TEMP,
		"damage_threshold": DAMAGE_TEMP + armor_heat_bonus,
		"coolant_amount": coolant_amount,
		"coolant_capacity": MAX_COOLANT_CAPACITY,
		"coolant_runtime_minutes": get_coolant_runtime_minutes(),
		"coolant_type": CoolantType.keys()[current_coolant_type],
		"active_modules": active_modules_count,
		"boost_mode": boost_mode_active,
		"emergency_shutdown": is_emergency_shutdown,
		"armor_quality": armor_quality,
		"armor_heat_bonus": armor_heat_bonus
	}

func reset_system():
	"""Reset to default state (for testing)"""
	current_temperature = BASE_TEMP
	coolant_amount = MAX_COOLANT_CAPACITY
	is_emergency_shutdown = false
	active_modules_count = 0
	boost_mode_active = false
	warning_triggered = false
	critical_triggered = false
	print("🔄 Temperature system reset")
