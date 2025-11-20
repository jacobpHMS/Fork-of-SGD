extends Node2D

# ============================================================================
# SPACE STATION - EVE-Style Module System
# ============================================================================

# Station Info
@export var station_name: String = "Unknown Station"
@export var faction: String = "Independent"
@export var station_level: int = 1

# Station Types
enum StationType {
	OUTPOST,        # Small station, basic services
	STATION,        # Medium station, full services
	CITADEL,        # Large station, advanced services
	KEEPSTAR        # Massive station, capital services
}

@export var station_type: StationType = StationType.STATION

# Module System
enum ModuleType {
	REFINERY,       # Ore refining
	MANUFACTURING,  # Component manufacturing
	MARKET,         # Trading hub
	HANGAR,         # Ship storage
	REPAIR,         # Ship repair services
	CLONING,        # Medical/Clone bay
	RESEARCH,       # Research lab
	DEFENSE         # Defensive systems
}

# Module Slots (EVE-Style)
const MAX_MODULE_SLOTS = {
	StationType.OUTPOST: 3,
	StationType.STATION: 6,
	StationType.CITADEL: 10,
	StationType.KEEPSTAR: 15
}

# Installed modules
var modules: Dictionary = {}  # slot_id → Module data
var module_slots: int = 3

# Docking System
var docked_ships: Array[Node2D] = []
var max_docked_ships: int = 20
var docking_range: float = 300.0

# Services
var services_available: Array[String] = []

# Signals
signal ship_docked(ship: Node2D)
signal ship_undocked(ship: Node2D)
signal module_installed(module_type: ModuleType, slot_id: int)
signal module_removed(slot_id: int)
signal service_accessed(service_name: String, ship: Node2D)

func _ready():
	# Set module slots based on station type
	module_slots = MAX_MODULE_SLOTS[station_type]

	# Initialize default modules based on type
	_initialize_default_modules()

	# Update available services
	_update_services()

	print("🏗️ Station initialized: %s (%s)" % [station_name, StationType.keys()[station_type]])
	print("   Module Slots: %d" % module_slots)
	print("   Services: %s" % str(services_available))

func _initialize_default_modules():
	"""Initialize station with default modules based on type"""
	match station_type:
		StationType.OUTPOST:
			# Basic services only
			install_module(0, ModuleType.HANGAR)
		StationType.STATION:
			# Full basic services
			install_module(0, ModuleType.HANGAR)
			install_module(1, ModuleType.MARKET)
			install_module(2, ModuleType.REFINERY)
		StationType.CITADEL:
			# Advanced services
			install_module(0, ModuleType.HANGAR)
			install_module(1, ModuleType.MARKET)
			install_module(2, ModuleType.REFINERY)
			install_module(3, ModuleType.MANUFACTURING)
			install_module(4, ModuleType.REPAIR)
		StationType.KEEPSTAR:
			# All services
			for i in range(8):
				install_module(i, i as ModuleType)

func install_module(slot_id: int, module_type: ModuleType) -> bool:
	"""Install a module in a specific slot"""
	if slot_id >= module_slots:
		print("❌ Invalid slot: %d (max: %d)" % [slot_id, module_slots])
		return false

	if modules.has(slot_id):
		print("⚠️ Slot %d already occupied" % slot_id)
		return false

	# Create module data
	var module_data = {
		"type": module_type,
		"name": get_module_name(module_type),
		"active": true,
		"health": 100.0,
		"power_usage": get_module_power_usage(module_type),
		"installed_time": Time.get_unix_time_from_system()
	}

	modules[slot_id] = module_data
	_update_services()

	module_installed.emit(module_type, slot_id)
	print("✅ Module installed: %s in slot %d" % [module_data["name"], slot_id])

	return true

func remove_module(slot_id: int) -> bool:
	"""Remove a module from a slot"""
	if not modules.has(slot_id):
		return false

	var module_data = modules[slot_id]
	modules.erase(slot_id)
	_update_services()

	module_removed.emit(slot_id)
	print("🗑️ Module removed: %s from slot %d" % [module_data["name"], slot_id])

	return true

func get_module_name(module_type: ModuleType) -> String:
	"""Get human-readable module name"""
	match module_type:
		ModuleType.REFINERY:
			return "Ore Refinery"
		ModuleType.MANUFACTURING:
			return "Manufacturing Plant"
		ModuleType.MARKET:
			return "Trading Hub"
		ModuleType.HANGAR:
			return "Hangar Bay"
		ModuleType.REPAIR:
			return "Repair Facility"
		ModuleType.CLONING:
			return "Clone Bay"
		ModuleType.RESEARCH:
			return "Research Lab"
		ModuleType.DEFENSE:
			return "Defense System"
		_:
			return "Unknown Module"

func get_module_power_usage(module_type: ModuleType) -> float:
	"""Get module power usage"""
	match module_type:
		ModuleType.REFINERY:
			return 500.0
		ModuleType.MANUFACTURING:
			return 750.0
		ModuleType.MARKET:
			return 100.0
		ModuleType.HANGAR:
			return 200.0
		ModuleType.REPAIR:
			return 300.0
		ModuleType.CLONING:
			return 150.0
		ModuleType.RESEARCH:
			return 400.0
		ModuleType.DEFENSE:
			return 600.0
		_:
			return 0.0

func _update_services():
	"""Update available services based on installed modules"""
	services_available.clear()

	for slot_id in modules:
		var module = modules[slot_id]
		if module["active"]:
			var service_name = get_service_name(module["type"])
			if service_name:
				services_available.append(service_name)

	services_available.sort()

func get_service_name(module_type: ModuleType) -> String:
	"""Get service name for a module type"""
	match module_type:
		ModuleType.REFINERY:
			return "Reprocessing"
		ModuleType.MANUFACTURING:
			return "Manufacturing"
		ModuleType.MARKET:
			return "Market"
		ModuleType.HANGAR:
			return "Hangar"
		ModuleType.REPAIR:
			return "Repair"
		ModuleType.CLONING:
			return "Clone Bay"
		ModuleType.RESEARCH:
			return "Research"
		_:
			return ""

# ============================================================================
# DOCKING SYSTEM
# ============================================================================

func can_dock(ship: Node2D) -> bool:
	"""Check if ship can dock"""
	# Check distance
	var distance = global_position.distance_to(ship.global_position)
	if distance > docking_range:
		return false

	# Check capacity
	if docked_ships.size() >= max_docked_ships:
		return false

	# Check if already docked
	if ship in docked_ships:
		return false

	return true

func dock_ship(ship: Node2D) -> bool:
	"""Dock a ship at this station"""
	if not can_dock(ship):
		return false

	docked_ships.append(ship)
	ship_docked.emit(ship)

	print("🚢 Ship docked: %s at %s" % [ship.name, station_name])
	print("   Available services: %s" % str(services_available))

	return true

func undock_ship(ship: Node2D) -> bool:
	"""Undock a ship from this station"""
	if not ship in docked_ships:
		return false

	docked_ships.erase(ship)
	ship_undocked.emit(ship)

	print("🚀 Ship undocked: %s from %s" % [ship.name, station_name])

	return true

func is_ship_docked(ship: Node2D) -> bool:
	"""Check if ship is docked"""
	return ship in docked_ships

# ============================================================================
# SERVICE ACCESS
# ============================================================================

func access_service(service_name: String, ship: Node2D) -> bool:
	"""Access a station service"""
	# Check if docked
	if not is_ship_docked(ship):
		print("❌ Must be docked to access services")
		return false

	# Check if service available
	if not service_name in services_available:
		print("❌ Service not available: %s" % service_name)
		return false

	service_accessed.emit(service_name, ship)
	print("✅ Service accessed: %s by %s" % [service_name, ship.name])

	return true

func get_refinery_efficiency() -> float:
	"""Get refinery efficiency (returns mineral output multiplier)"""
	# Check if refinery module installed
	for slot_id in modules:
		var module = modules[slot_id]
		if module["type"] == ModuleType.REFINERY and module["active"]:
			# Base efficiency + station level bonus
			return 0.7 + (station_level * 0.05)

	return 0.5  # No refinery = 50% efficiency

func get_manufacturing_speed() -> float:
	"""Get manufacturing speed multiplier"""
	for slot_id in modules:
		var module = modules[slot_id]
		if module["type"] == ModuleType.MANUFACTURING and module["active"]:
			return 1.0 + (station_level * 0.1)

	return 0.0  # No manufacturing

func get_repair_cost_multiplier() -> float:
	"""Get repair cost multiplier (lower = cheaper)"""
	for slot_id in modules:
		var module = modules[slot_id]
		if module["type"] == ModuleType.REPAIR and module["active"]:
			return 1.0 - (station_level * 0.05)

	return 1.5  # No repair facility = expensive

# ============================================================================
# DEBUG / INFO
# ============================================================================

func get_station_info() -> Dictionary:
	"""Get complete station information"""
	return {
		"name": station_name,
		"type": StationType.keys()[station_type],
		"faction": faction,
		"level": station_level,
		"module_slots": module_slots,
		"modules_installed": modules.size(),
		"services": services_available,
		"docked_ships": docked_ships.size(),
		"max_docked": max_docked_ships,
		"docking_range": docking_range
	}

func print_station_info():
	"""Print station information to console"""
	var info = get_station_info()
	print("\n═══════════════════════════════════════")
	print("🏗️  STATION: %s" % info["name"])
	print("═══════════════════════════════════════")
	print("Type: %s (Level %d)" % [info["type"], info["level"]])
	print("Faction: %s" % info["faction"])
	print("Modules: %d / %d slots" % [info["modules_installed"], info["module_slots"]])
	print("Services: %s" % str(info["services"]))
	print("Docked Ships: %d / %d" % [info["docked_ships"], info["max_docked"]])
	print("═══════════════════════════════════════\n")
