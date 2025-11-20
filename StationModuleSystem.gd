extends Node
class_name StationModuleSystem
## Station Module System - Infrastructure & Services
##
## Manages station modules and services including:
## - Chip Recharge Module (restore manufacturing chip integrity)
## - Manufacturing Facilities
## - Repair Facilities
## - Clone Facilities
## - Research Labs
##
## Usage:
## ```gdscript
## StationModuleSystem.install_module(station_id, ModuleType.CHIP_RECHARGER, 1)
## var result = StationModuleSystem.use_chip_recharger(station_id, chip_id, player_id)
## ```

# ============================================================================
# SIGNALS
# ============================================================================

signal module_installed(station_id: String, module_type: int, level: int)
signal module_upgraded(station_id: String, module_type: int, old_level: int, new_level: int)
signal service_used(station_id: String, module_type: int, player_id: String, cost: int)

# ============================================================================
# ENUMS
# ============================================================================

enum ModuleType {
	CHIP_RECHARGER = 0,     # Restore chip data integrity
	MANUFACTURING = 1,       # Manufacturing facilities
	REPAIR = 2,              # Ship repair
	CLONE_BAY = 3,           # Medical clone facility
	RESEARCH_LAB = 4,        # Tech research
	REFINERY = 5,            # Ore refining
	MARKET_HUB = 6           # Enhanced market features
}

# ============================================================================
# CONSTANTS
# ============================================================================

const MODULE_NAMES = {
	ModuleType.CHIP_RECHARGER: "Chip Recharge Facility",
	ModuleType.MANUFACTURING: "Manufacturing Plant",
	ModuleType.REPAIR: "Repair Facility",
	ModuleType.CLONE_BAY: "Clone Bay",
	ModuleType.RESEARCH_LAB: "Research Laboratory",
	ModuleType.REFINERY: "Ore Refinery",
	ModuleType.MARKET_HUB: "Market Hub"
}

const MAX_MODULE_LEVEL = 5

# Module installation costs (credits)
const INSTALLATION_COST = {
	ModuleType.CHIP_RECHARGER: 500000,
	ModuleType.MANUFACTURING: 1000000,
	ModuleType.REPAIR: 750000,
	ModuleType.CLONE_BAY: 2000000,
	ModuleType.RESEARCH_LAB: 3000000,
	ModuleType.REFINERY: 1500000,
	ModuleType.MARKET_HUB: 2500000
}

# ============================================================================
# STATE
# ============================================================================

## Station modules: station_id -> {module_type -> level}
var station_modules: Dictionary = {}

## Module upgrade queue: station_id -> Array of pending upgrades
var upgrade_queue: Dictionary = {}

# ============================================================================
# DATA STRUCTURES
# ============================================================================

class StationModule:
	var station_id: String
	var module_type: ModuleType
	var level: int = 1
	var installed_time: float
	var last_service_time: float = 0.0

	func _init(p_station: String, p_type: ModuleType, p_level: int = 1):
		station_id = p_station
		module_type = p_type
		level = p_level
		installed_time = Time.get_unix_time_from_system()

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	print("🏗️ StationModuleSystem: Initializing...")
	_load_initial_stations()
	print("✅ StationModuleSystem: Ready")

func _load_initial_stations():
	"""Load default station configurations"""
	# Example starter station with basic modules
	install_module("STATION_STARTER", ModuleType.CHIP_RECHARGER, 1)
	install_module("STATION_STARTER", ModuleType.MANUFACTURING, 1)
	install_module("STATION_STARTER", ModuleType.REPAIR, 1)

# ============================================================================
# MODULE MANAGEMENT
# ============================================================================

func install_module(station_id: String, module_type: ModuleType, level: int = 1) -> bool:
	"""Install a module at a station"""
	if not station_modules.has(station_id):
		station_modules[station_id] = {}

	if station_modules[station_id].has(module_type):
		push_error("Module already installed at station: %s" % MODULE_NAMES[module_type])
		return false

	var module = StationModule.new(station_id, module_type, level)
	station_modules[station_id][module_type] = module

	module_installed.emit(station_id, module_type, level)

	print("🏗️ Module installed: %s at %s (Level %d)" %
	      [MODULE_NAMES[module_type], station_id, level])

	return true

func upgrade_module(station_id: String, module_type: ModuleType) -> bool:
	"""Upgrade a module to next level"""
	if not has_module(station_id, module_type):
		push_error("Module not found at station")
		return false

	var module = station_modules[station_id][module_type]

	if module.level >= MAX_MODULE_LEVEL:
		push_error("Module already at max level")
		return false

	var old_level = module.level
	module.level += 1

	module_upgraded.emit(station_id, module_type, old_level, module.level)

	print("⬆️ Module upgraded: %s → Level %d" % [MODULE_NAMES[module_type], module.level])

	return true

func has_module(station_id: String, module_type: ModuleType) -> bool:
	"""Check if station has a specific module"""
	if not station_modules.has(station_id):
		return false

	return station_modules[station_id].has(module_type)

func get_module_level(station_id: String, module_type: ModuleType) -> int:
	"""Get module level (0 = not installed)"""
	if not has_module(station_id, module_type):
		return 0

	return station_modules[station_id][module_type].level

# ============================================================================
# CHIP RECHARGER SERVICE
# ============================================================================

func use_chip_recharger(station_id: String, chip_id: String, player_id: String) -> Dictionary:
	"""
	Use chip recharger service at station
	Returns: {success: bool, credits_cost: int, materials_cost: Dictionary, error: String}
	"""
	var result = {
		"success": false,
		"credits_cost": 0,
		"materials_cost": {},
		"error": ""
	}

	# Check station has recharger
	if not has_module(station_id, ModuleType.CHIP_RECHARGER):
		result.error = "Station does not have Chip Recharge Facility"
		return result

	# Get recharger level (affects cost reduction)
	var recharger_level = get_module_level(station_id, ModuleType.CHIP_RECHARGER)

	# Use BlueprintSystem to recharge
	var recharge_result = BlueprintSystem.recharge_chip(chip_id, station_id)

	if not recharge_result.success:
		result.error = recharge_result.error
		return result

	# Apply level discount (5% per level)
	var discount = 1.0 - (recharger_level - 1) * 0.05
	var final_credits = int(recharge_result.credits_cost * discount)

	result.success = true
	result.credits_cost = final_credits
	result.materials_cost = recharge_result.materials_cost

	# Track service usage
	var module = station_modules[station_id][ModuleType.CHIP_RECHARGER]
	module.last_service_time = Time.get_unix_time_from_system()

	service_used.emit(station_id, ModuleType.CHIP_RECHARGER, player_id, final_credits)

	print("🔋 Chip Recharge Service: %s at %s (Level %d, %d%% discount)" %
	      [chip_id, station_id, recharger_level, int((1.0 - discount) * 100)])

	return result

# ============================================================================
# QUERY API
# ============================================================================

func get_station_modules(station_id: String) -> Array:
	"""Get all modules at a station"""
	if not station_modules.has(station_id):
		return []

	return station_modules[station_id].values()

func get_all_stations_with_module(module_type: ModuleType) -> Array:
	"""Get all stations that have a specific module"""
	var stations = []

	for station_id in station_modules.keys():
		if has_module(station_id, module_type):
			stations.append(station_id)

	return stations

func get_installation_cost(module_type: ModuleType) -> int:
	"""Get installation cost for a module type"""
	return INSTALLATION_COST.get(module_type, 0)
