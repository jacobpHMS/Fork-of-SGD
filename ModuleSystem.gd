extends Node

# ============================================================================
# MODULE SYSTEM - Ship Modules with Skill Integration
# ============================================================================
# Manages all ship modules (mining lasers, weapons, shields, etc.)
# Integrates with SkillManager for efficiency calculations
# Cross-references with Temperature, Energy, and CPU systems

signal module_installed(module_id: String, slot: int)
signal module_removed(module_id: String, slot: int)
signal module_activated(module_id: String)
signal module_deactivated(module_id: String)
signal module_overloaded(module_id: String)

# Module types
enum ModuleType {
	MINING_LASER,
	REFINERY,
	WEAPON,
	SHIELD,
	ARMOR_REPAIRER,
	CARGO_EXPANDER,
	SCANNER,
	WARP_DRIVE,
	ENERGY_GENERATOR,
	CPU_UPGRADE,
	HEAT_SINK
}

# Module categories for grouping
enum ModuleCategory {
	MINING,
	INDUSTRIAL,
	COMBAT,
	DEFENSE,
	UTILITY,
	PROPULSION,
	ENGINEERING
}

# Module data structure
class Module:
	var module_id: String = ""
	var module_name: String = ""
	var module_type: ModuleType
	var category: ModuleCategory
	var tier: int = 1  # 1-5
	var required_skill: String = ""  # References SkillManager skill
	var required_skill_level: int = 0  # Minimum level to use without penalties

	# Resource requirements
	var cpu_usage: float = 0.0
	var energy_usage: float = 0.0  # Per second when active
	var heat_generation: float = 0.0  # Per second when active

	# Module stats (varies by type)
	var stats: Dictionary = {}

	# Runtime state
	var is_active: bool = false
	var is_installed: bool = false
	var slot: int = -1

	# Efficiency modifiers (from SkillManager)
	var efficiency: Dictionary = {
		"output": 1.0,
		"energy_mult": 1.0,
		"cpu_mult": 1.0,
		"effective_tier": 1
	}

	func _init(id: String, name: String, type: ModuleType, cat: ModuleCategory, t: int = 1):
		module_id = id
		module_name = name
		module_type = type
		category = cat
		tier = t
		required_skill_level = t  # Default: tier = required level

	func calculate_effective_stats(skill_efficiency: Dictionary) -> Dictionary:
		"""Calculate actual stats with skill efficiency applied"""
		efficiency = skill_efficiency

		var effective_stats = stats.duplicate()

		# Apply output modifier
		if effective_stats.has("output"):
			effective_stats["output"] *= efficiency["output"]
		if effective_stats.has("mining_rate"):
			effective_stats["mining_rate"] *= efficiency["output"]
		if effective_stats.has("damage"):
			effective_stats["damage"] *= efficiency["output"]

		# Apply resource multipliers
		if effective_stats.has("energy_cost"):
			effective_stats["energy_cost"] *= efficiency["energy_mult"]
		if effective_stats.has("cpu_cost"):
			effective_stats["cpu_cost"] *= efficiency["cpu_mult"]

		return effective_stats

	func get_info() -> Dictionary:
		"""Get detailed module information"""
		return {
			"id": module_id,
			"name": module_name,
			"type": ModuleType.keys()[module_type],
			"category": ModuleCategory.keys()[category],
			"tier": tier,
			"required_skill": required_skill,
			"required_skill_level": required_skill_level,
			"cpu_usage": cpu_usage * efficiency["cpu_mult"],
			"energy_usage": energy_usage * efficiency["energy_mult"],
			"heat_generation": heat_generation,
			"stats": stats,
			"efficiency": efficiency,
			"is_active": is_active,
			"is_installed": is_installed,
			"slot": slot
		}

# Module database
var module_database: Dictionary = {}

# Installed modules (by slot)
var installed_modules: Dictionary = {}

# Ship constraints
var max_module_slots: int = 10
var total_cpu_capacity: float = 100.0
var current_cpu_usage: float = 0.0

func _ready():
	initialize_module_database()

# ============================================================================
# MODULE DATABASE
# ============================================================================

func initialize_module_database():
	"""Initialize all available modules"""

	# MINING LASERS
	var mining_laser_mk1 = Module.new("mining_laser_mk1", "Mining Laser Mk1", ModuleType.MINING_LASER, ModuleCategory.MINING, 1)
	mining_laser_mk1.required_skill = "mining_laser"
	mining_laser_mk1.cpu_usage = 10.0
	mining_laser_mk1.energy_usage = 20.0
	mining_laser_mk1.heat_generation = 5.0
	mining_laser_mk1.stats = {
		"mining_rate": 10.0,  # Units per cycle
		"range": 150.0,
		"cycle_time": 10.0
	}
	module_database["mining_laser_mk1"] = mining_laser_mk1

	var mining_laser_mk2 = Module.new("mining_laser_mk2", "Mining Laser Mk2", ModuleType.MINING_LASER, ModuleCategory.MINING, 2)
	mining_laser_mk2.required_skill = "mining_laser"
	mining_laser_mk2.cpu_usage = 15.0
	mining_laser_mk2.energy_usage = 35.0
	mining_laser_mk2.heat_generation = 8.0
	mining_laser_mk2.stats = {
		"mining_rate": 20.0,
		"range": 200.0,
		"cycle_time": 8.0
	}
	module_database["mining_laser_mk2"] = mining_laser_mk2

	# REFINERIES
	var refinery_basic = Module.new("refinery_basic", "Basic Refinery", ModuleType.REFINERY, ModuleCategory.INDUSTRIAL, 1)
	refinery_basic.required_skill = "basic_refining"
	refinery_basic.cpu_usage = 20.0
	refinery_basic.energy_usage = 50.0
	refinery_basic.heat_generation = 15.0
	refinery_basic.stats = {
		"max_tier": 2,  # Can refine up to Q2
		"processing_speed": 1.0  # Speed multiplier
	}
	module_database["refinery_basic"] = refinery_basic

	var refinery_advanced = Module.new("refinery_advanced", "Advanced Refinery", ModuleType.REFINERY, ModuleCategory.INDUSTRIAL, 3)
	refinery_advanced.required_skill = "advanced_refining"
	refinery_advanced.cpu_usage = 40.0
	refinery_advanced.energy_usage = 150.0
	refinery_advanced.heat_generation = 35.0
	refinery_advanced.stats = {
		"max_tier": 4,  # Can refine up to Q4
		"processing_speed": 1.5
	}
	module_database["refinery_advanced"] = refinery_advanced

	# SHIELDS
	var shield_mk1 = Module.new("shield_mk1", "Shield Generator Mk1", ModuleType.SHIELD, ModuleCategory.DEFENSE, 1)
	shield_mk1.required_skill = "shield_management"
	shield_mk1.cpu_usage = 15.0
	shield_mk1.energy_usage = 30.0
	shield_mk1.heat_generation = 5.0
	shield_mk1.stats = {
		"shield_capacity": 1000.0,
		"recharge_rate": 10.0
	}
	module_database["shield_mk1"] = shield_mk1

	# WEAPONS
	var laser_cannon = Module.new("laser_cannon_mk1", "Laser Cannon Mk1", ModuleType.WEAPON, ModuleCategory.COMBAT, 1)
	laser_cannon.required_skill = "weapon_operation"
	laser_cannon.cpu_usage = 12.0
	laser_cannon.energy_usage = 50.0
	laser_cannon.heat_generation = 20.0
	laser_cannon.stats = {
		"damage": 100.0,
		"fire_rate": 2.0,  # Shots per second
		"range": 500.0
	}
	module_database["laser_cannon_mk1"] = laser_cannon

	# SCANNERS
	var scanner_mk1 = Module.new("scanner_mk1", "Scanner Mk1", ModuleType.SCANNER, ModuleCategory.UTILITY, 1)
	scanner_mk1.required_skill = "ore_detection"
	scanner_mk1.cpu_usage = 8.0
	scanner_mk1.energy_usage = 15.0
	scanner_mk1.heat_generation = 2.0
	scanner_mk1.stats = {
		"scan_range": 1000.0,
		"scan_resolution": 1,  # Scanner level
		"scan_time": 3.0
	}
	module_database["scanner_mk1"] = scanner_mk1

	# ENERGY GENERATORS
	var generator_fusion = Module.new("generator_fusion", "Fusion Generator", ModuleType.ENERGY_GENERATOR, ModuleCategory.ENGINEERING, 2)
	generator_fusion.required_skill = "module_fitting"
	generator_fusion.cpu_usage = 5.0
	generator_fusion.energy_usage = -100.0  # Negative = generates energy
	generator_fusion.heat_generation = 10.0
	generator_fusion.stats = {
		"output": 100.0,  # Energy per second
		"fuel_type": "deuterium",
		"fuel_consumption": 1.0  # Per second
	}
	module_database["generator_fusion"] = generator_fusion

	# HEAT SINKS
	var heat_sink = Module.new("heat_sink_mk1", "Heat Sink Mk1", ModuleType.HEAT_SINK, ModuleCategory.ENGINEERING, 1)
	heat_sink.required_skill = "thermal_management"
	heat_sink.cpu_usage = 5.0
	heat_sink.energy_usage = 10.0
	heat_sink.heat_generation = -15.0  # Negative = reduces heat
	heat_sink.stats = {
		"cooling_rate": 15.0
	}
	module_database["heat_sink_mk1"] = heat_sink

	print("📦 Module database initialized with %d modules" % module_database.size())

# ============================================================================
# MODULE INSTALLATION
# ============================================================================

func install_module(module_id: String, slot: int) -> bool:
	"""Install a module in a specific slot"""

	# Validate module exists
	if not module_database.has(module_id):
		print("❌ Module not found: %s" % module_id)
		return false

	# Validate slot
	if slot < 0 or slot >= max_module_slots:
		print("❌ Invalid slot: %d" % slot)
		return false

	# Check if slot is occupied
	if installed_modules.has(slot):
		print("❌ Slot %d already occupied" % slot)
		return false

	# Get module
	var module = module_database[module_id]

	# Calculate efficiency with SkillManager
	if SkillManager and module.required_skill != "":
		module.efficiency = SkillManager.calculate_module_efficiency(module.tier, module.required_skill)

	# Check CPU capacity
	var effective_cpu = module.cpu_usage * module.efficiency["cpu_mult"]
	if current_cpu_usage + effective_cpu > total_cpu_capacity:
		print("❌ Insufficient CPU: Need %.1f, available %.1f" % [effective_cpu, total_cpu_capacity - current_cpu_usage])
		return false

	# Install module
	module.is_installed = true
	module.slot = slot
	installed_modules[slot] = module
	current_cpu_usage += effective_cpu

	emit_signal("module_installed", module_id, slot)
	print("✅ Module installed: %s in slot %d (CPU: %.1f/%.1f)" % [module.module_name, slot, current_cpu_usage, total_cpu_capacity])

	return true

func remove_module(slot: int) -> bool:
	"""Remove a module from a slot"""

	if not installed_modules.has(slot):
		print("❌ No module in slot %d" % slot)
		return false

	var module = installed_modules[slot]

	# Deactivate if active
	if module.is_active:
		deactivate_module(slot)

	# Remove module
	var effective_cpu = module.cpu_usage * module.efficiency["cpu_mult"]
	current_cpu_usage -= effective_cpu
	module.is_installed = false
	module.slot = -1

	var module_id = module.module_id
	installed_modules.erase(slot)

	emit_signal("module_removed", module_id, slot)
	print("✅ Module removed: %s from slot %d" % [module.module_name, slot])

	return true

# ============================================================================
# MODULE ACTIVATION
# ============================================================================

func activate_module(slot: int) -> bool:
	"""Activate a module"""

	if not installed_modules.has(slot):
		print("❌ No module in slot %d" % slot)
		return false

	var module = installed_modules[slot]

	if module.is_active:
		print("⚠️ Module already active")
		return true

	# TODO: Check energy availability
	# TODO: Register with temperature system

	module.is_active = true
	emit_signal("module_activated", module.module_id)
	print("⚡ Module activated: %s" % module.module_name)

	return true

func deactivate_module(slot: int) -> bool:
	"""Deactivate a module"""

	if not installed_modules.has(slot):
		print("❌ No module in slot %d" % slot)
		return false

	var module = installed_modules[slot]

	if not module.is_active:
		print("⚠️ Module already inactive")
		return true

	module.is_active = false
	emit_signal("module_deactivated", module.module_id)
	print("🔌 Module deactivated: %s" % module.module_name)

	return true

# ============================================================================
# MODULE QUERIES
# ============================================================================

func get_installed_modules_by_type(type: ModuleType) -> Array:
	"""Get all installed modules of a specific type"""
	var result = []
	for slot in installed_modules:
		var module = installed_modules[slot]
		if module.module_type == type:
			result.append(module)
	return result

func get_active_modules() -> Array:
	"""Get all active modules"""
	var result = []
	for slot in installed_modules:
		var module = installed_modules[slot]
		if module.is_active:
			result.append(module)
	return result

func get_total_heat_generation() -> float:
	"""Calculate total heat generation from all active modules"""
	var total_heat = 0.0
	for module in get_active_modules():
		total_heat += module.heat_generation
	return total_heat

func get_total_energy_consumption() -> float:
	"""Calculate total energy consumption from all active modules"""
	var total_energy = 0.0
	for module in get_active_modules():
		var effective_energy = module.energy_usage * module.efficiency["energy_mult"]
		total_energy += effective_energy
	return total_energy

# ============================================================================
# SAVE/LOAD INTEGRATION
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export module data for saving"""
	var modules_data = {}

	for slot in installed_modules:
		var module = installed_modules[slot]
		modules_data[str(slot)] = {
			"module_id": module.module_id,
			"is_active": module.is_active
		}

	return {
		"installed_modules": modules_data,
		"current_cpu_usage": current_cpu_usage
	}

func load_save_data(data: Dictionary):
	"""Import module data from save file"""
	# Clear existing modules
	installed_modules.clear()
	current_cpu_usage = 0.0

	# Restore installed modules
	if data.has("installed_modules"):
		for slot_str in data["installed_modules"]:
			var slot = int(slot_str)
			var module_data = data["installed_modules"][slot_str]
			var success = install_module(module_data["module_id"], slot)

			if success and module_data["is_active"]:
				activate_module(slot)

	current_cpu_usage = data.get("current_cpu_usage", 0.0)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_system_info() -> Dictionary:
	"""Get detailed module system information"""
	return {
		"installed_count": installed_modules.size(),
		"max_slots": max_module_slots,
		"cpu_usage": current_cpu_usage,
		"cpu_capacity": total_cpu_capacity,
		"cpu_percent": (current_cpu_usage / total_cpu_capacity) * 100.0,
		"active_modules": get_active_modules().size(),
		"total_heat_generation": get_total_heat_generation(),
		"total_energy_consumption": get_total_energy_consumption()
	}

func get_module_info(slot: int) -> Dictionary:
	"""Get information about a specific module"""
	if not installed_modules.has(slot):
		return {}

	return installed_modules[slot].get_info()

func list_all_modules() -> Array:
	"""Get list of all available modules"""
	var result = []
	for module_id in module_database:
		result.append(module_database[module_id].get_info())
	return result
