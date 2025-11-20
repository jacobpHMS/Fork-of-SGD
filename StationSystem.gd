extends Node

# ============================================================================
# STATION SYSTEM (EVE Online-Inspired)
# ============================================================================
# Modular station system with socket-based module installation
# Station = Base + Installed Modules = Capabilities

signal station_deployed(station_id: String, owner: String)
signal module_installed(station_id: String, module_id: String)
signal module_uninstalled(station_id: String, module_id: String)
signal sockets_expanded(station_id: String, new_total: int)
signal docking_requested(ship_id: String, station_id: String)
signal docking_completed(ship_id: String, station_id: String)
signal access_denied(ship_id: String, station_id: String, reason: String)

# Station sizes (EVE-inspired naming: Raitaru, Astrahus, Fortizar)
enum StationSize {
	SMALL = 0,   # "Raitaru-Class" - Basic Operations
	MEDIUM = 1,  # "Astrahus-Class" - Advanced Operations
	LARGE = 2    # "Citadel/Keep-Class" - High-End (Player Endgame)
}

# Module categories
enum ModuleCategory {
	REFINERY,          # Ore Processing
	FACTORY,           # Component Manufacturing
	SHIPYARD,          # Ship Construction
	TRADING,           # Market & Commerce
	MILITARY,          # Combat Services
	UTILITY,           # Storage, Docking, etc.
	SOCKET_EXPANDER    # Unlocks more sockets!
}

# Base station configuration
const STATION_CONFIG = {
	StationSize.SMALL: {
		"base_sockets": 5,
		"docking_capacity": 10,
		"base_storage": 50000,
		"cost": 500000,
		"name": "Small Station"
	},
	StationSize.MEDIUM: {
		"base_sockets": 12,
		"docking_capacity": 30,
		"base_storage": 200000,
		"cost": 5000000,
		"name": "Medium Station"
	},
	StationSize.LARGE: {
		"base_sockets": 25,
		"docking_capacity": 100,
		"base_storage": 1000000,
		"cost": 50000000,
		"name": "Large Station"
	}
}

# ============================================================================
# STATION MODULE
# ============================================================================

class StationModule:
	"""A module that can be installed in a station socket"""
	var module_id: String = ""
	var module_name: String = ""
	var category: ModuleCategory = ModuleCategory.UTILITY
	var tier: int = 1  # 1-5 (higher = better)
	var sockets_required: int = 1
	var sockets_unlocked: int = 0  # For socket expanders

	# Module stats (depends on type)
	var processing_speed: float = 1.0
	var efficiency: float = 1.0
	var capacity: float = 0.0

	# Costs
	var installation_cost: float = 0.0
	var upgrade_cost: float = 0.0
	var required_materials: Dictionary = {}

	func _init(id: String, name: String, cat: ModuleCategory, socket_count: int = 1):
		module_id = id
		module_name = name
		category = cat
		sockets_required = socket_count

	func get_info() -> Dictionary:
		return {
			"module_id": module_id,
			"name": module_name,
			"category": ModuleCategory.keys()[category],
			"tier": tier,
			"sockets_required": sockets_required,
			"sockets_unlocked": sockets_unlocked,
			"processing_speed": processing_speed,
			"efficiency": efficiency,
			"capacity": capacity
		}

# ============================================================================
# STATION
# ============================================================================

class Station:
	"""A station with socket-based module system"""
	var station_id: String = ""
	var station_name: String = ""
	var station_size: StationSize = StationSize.SMALL
	var position: Vector2 = Vector2.ZERO
	var faction_id: String = ""
	var owner_id: String = ""  # Player or NPC ID

	# Module system
	var base_sockets: int = 5
	var total_sockets: int = 5  # Base + unlocked from expanders
	var available_sockets: int = 5
	var installed_modules: Array[StationModule] = []

	# Docking
	var docking_capacity: int = 10
	var docked_ships: Dictionary = {}  # dock_id -> ship_id

	# Storage
	var storage_capacity: float = 50000.0
	var stored_items: Dictionary = {}  # item_id -> amount

	# Access control
	var owner_access: bool = true
	var ally_access: bool = false
	var public_docking: bool = true
	var public_market: bool = false

	func _init(id: String, size: StationSize, pos: Vector2, faction: String):
		station_id = id
		station_size = size
		position = pos
		faction_id = faction

		# Initialize from config
		var config = STATION_CONFIG[size]
		base_sockets = config["base_sockets"]
		total_sockets = base_sockets
		available_sockets = base_sockets
		docking_capacity = config["docking_capacity"]
		storage_capacity = config["base_storage"]
		station_name = config["name"]

	func install_module(module: StationModule) -> bool:
		"""Install a module in available sockets"""
		if available_sockets < module.sockets_required:
			print("❌ Not enough sockets! Need %d, have %d" % [module.sockets_required, available_sockets])
			return false

		# Install module
		installed_modules.append(module)
		available_sockets -= module.sockets_required

		# Socket expander adds sockets
		if module.category == ModuleCategory.SOCKET_EXPANDER:
			total_sockets += module.sockets_unlocked
			available_sockets += module.sockets_unlocked
			print("✅ Socket Expander installed: +%d sockets (Total: %d)" % [module.sockets_unlocked, total_sockets])

		print("✅ Module installed: %s (%d sockets used, %d available)" % [module.module_name, module.sockets_required, available_sockets])
		return true

	func uninstall_module(module_id: String) -> bool:
		"""Uninstall a module and free sockets"""
		for i in range(installed_modules.size()):
			if installed_modules[i].module_id == module_id:
				var module = installed_modules[i]

				# Free sockets
				available_sockets += module.sockets_required

				# Remove unlocked sockets if socket expander
				if module.category == ModuleCategory.SOCKET_EXPANDER:
					total_sockets -= module.sockets_unlocked
					available_sockets -= module.sockets_unlocked

				installed_modules.remove_at(i)
				print("✅ Module uninstalled: %s (%d sockets freed)" % [module.module_name, module.sockets_required])
				return true

		print("❌ Module not found: %s" % module_id)
		return false

	func get_capabilities() -> Array[String]:
		"""Get station capabilities based on installed modules"""
		var capabilities = []

		for module in installed_modules:
			match module.category:
				ModuleCategory.REFINERY:
					if not capabilities.has("refining"):
						capabilities.append("refining")
				ModuleCategory.FACTORY:
					if not capabilities.has("crafting"):
						capabilities.append("crafting")
				ModuleCategory.SHIPYARD:
					if not capabilities.has("ship_construction"):
						capabilities.append("ship_construction")
				ModuleCategory.TRADING:
					if not capabilities.has("market"):
						capabilities.append("market")
				ModuleCategory.MILITARY:
					if not capabilities.has("defense"):
						capabilities.append("defense")

		return capabilities

	func get_module_count_by_category(category: ModuleCategory) -> int:
		"""Count modules of specific category"""
		var count = 0
		for module in installed_modules:
			if module.category == category:
				count += 1
		return count

	func get_info() -> Dictionary:
		"""Get detailed station information"""
		return {
			"station_id": station_id,
			"name": station_name,
			"size": StationSize.keys()[station_size],
			"position": position,
			"faction": faction_id,
			"owner": owner_id,
			"base_sockets": base_sockets,
			"total_sockets": total_sockets,
			"available_sockets": available_sockets,
			"used_sockets": total_sockets - available_sockets,
			"installed_modules": installed_modules.size(),
			"capabilities": get_capabilities(),
			"docking_capacity": docking_capacity,
			"docked_ships": docked_ships.size(),
			"storage_capacity": storage_capacity,
			"public_docking": public_docking,
			"public_market": public_market
		}

# ============================================================================
# GLOBAL STATION MANAGER
# ============================================================================

var stations: Dictionary = {}  # station_id -> Station
var next_station_id: int = 1

func _ready():
	print("🚢 Station System initialized (EVE-Style Modular)")

# ============================================================================
# STATION DEPLOYMENT
# ============================================================================

func deploy_player_station(position: Vector2, size: StationSize, faction_id: String, player_id: String, resources: Dictionary) -> String:
	"""Deploy a player-owned station"""
	var config = STATION_CONFIG[size]
	var cost = config["cost"]

	# Check resources
	var credits = resources.get("credits", 0.0)
	if credits < cost:
		print("❌ Insufficient credits: need %.0f, have %.0f" % [cost, credits])
		return ""

	# Create station
	var station_id = "station_%d" % next_station_id
	next_station_id += 1

	var station = Station.new(station_id, size, position, faction_id)
	station.owner_id = player_id
	stations[station_id] = station

	emit_signal("station_deployed", station_id, player_id)
	print("✅ Station deployed: %s at (%.0f, %.0f) - Cost: %.0f credits" % [config["name"], position.x, position.y, cost])

	return station_id

func deploy_npc_station(position: Vector2, size: StationSize, faction_id: String, station_name: String = "") -> String:
	"""Deploy an NPC-owned station"""
	var station_id = "station_%d" % next_station_id
	next_station_id += 1

	var station = Station.new(station_id, size, position, faction_id)
	station.owner_id = "npc_%s" % faction_id

	if station_name != "":
		station.station_name = station_name

	stations[station_id] = station

	emit_signal("station_deployed", station_id, station.owner_id)
	print("✅ NPC Station deployed: %s" % station.station_name)

	return station_id

# ============================================================================
# MODULE MANAGEMENT
# ============================================================================

func install_module(station_id: String, module_config: Dictionary) -> bool:
	"""Install a module on a station"""
	if not stations.has(station_id):
		print("❌ Station not found: %s" % station_id)
		return false

	var station = stations[station_id]

	# Create module from config
	var module = StationModule.new(
		module_config.get("id", "module_%d" % Time.get_ticks_msec()),
		module_config.get("name", "Unknown Module"),
		module_config.get("category", ModuleCategory.UTILITY),
		module_config.get("sockets_required", 1)
	)

	module.tier = module_config.get("tier", 1)
	module.sockets_unlocked = module_config.get("sockets_unlocked", 0)
	module.processing_speed = module_config.get("processing_speed", 1.0)
	module.efficiency = module_config.get("efficiency", 1.0)
	module.capacity = module_config.get("capacity", 0.0)

	# Install
	if station.install_module(module):
		emit_signal("module_installed", station_id, module.module_id)

		# Socket expansion signal
		if module.category == ModuleCategory.SOCKET_EXPANDER:
			emit_signal("sockets_expanded", station_id, station.total_sockets)

		return true

	return false

func uninstall_module(station_id: String, module_id: String) -> bool:
	"""Uninstall a module from a station"""
	if not stations.has(station_id):
		return false

	var station = stations[station_id]

	if station.uninstall_module(module_id):
		emit_signal("module_uninstalled", station_id, module_id)
		return true

	return false

func upgrade_module(station_id: String, module_id: String, new_tier: int) -> bool:
	"""Upgrade a module to higher tier"""
	if not stations.has(station_id):
		return false

	var station = stations[station_id]

	for module in station.installed_modules:
		if module.module_id == module_id:
			if new_tier <= module.tier:
				print("❌ New tier must be higher than current tier %d" % module.tier)
				return false

			module.tier = new_tier
			module.processing_speed *= 1.2  # +20% per tier
			module.efficiency *= 1.1        # +10% per tier

			print("✅ Module upgraded: %s → Tier %d" % [module.module_name, new_tier])
			return true

	print("❌ Module not found: %s" % module_id)
	return false

# ============================================================================
# DOCKING SYSTEM
# ============================================================================

func request_docking(station_id: String, ship_id: String) -> int:
	"""Request docking clearance, returns dock_id or -1"""
	if not stations.has(station_id):
		return -1

	var station = stations[station_id]

	# Check capacity
	if station.docked_ships.size() >= station.docking_capacity:
		print("❌ No free docking slots at %s" % station.station_name)
		return -1

	# Find free dock
	for dock_id in range(station.docking_capacity):
		if not station.docked_ships.has(dock_id):
			emit_signal("docking_requested", ship_id, station_id)
			return dock_id

	return -1

func dock_at_station(station_id: String, ship_id: String, dock_id: int) -> bool:
	"""Dock ship at station"""
	if not stations.has(station_id):
		return false

	var station = stations[station_id]

	if dock_id < 0 or dock_id >= station.docking_capacity:
		return false

	if station.docked_ships.has(dock_id):
		print("❌ Dock %d already occupied" % dock_id)
		return false

	station.docked_ships[dock_id] = ship_id
	emit_signal("docking_completed", ship_id, station_id)
	print("✅ Ship %s docked at %s (dock %d)" % [ship_id, station.station_name, dock_id])

	return true

func undock_from_station(station_id: String, ship_id: String) -> bool:
	"""Undock ship from station"""
	if not stations.has(station_id):
		return false

	var station = stations[station_id]

	for dock_id in station.docked_ships:
		if station.docked_ships[dock_id] == ship_id:
			station.docked_ships.erase(dock_id)
			print("✅ Ship %s undocked from %s" % [ship_id, station.station_name])
			return true

	print("❌ Ship %s not found at station %s" % [ship_id, station.station_name])
	return false

# ============================================================================
# ACCESS CONTROL
# ============================================================================

func set_access_control(station_id: String, acl: Dictionary) -> bool:
	"""Set station access control list"""
	if not stations.has(station_id):
		return false

	var station = stations[station_id]

	station.public_docking = acl.get("public_docking", true)
	station.public_market = acl.get("public_market", false)
	station.ally_access = acl.get("ally_access", false)

	print("✅ Access control updated for %s" % station.station_name)
	return true

func can_dock(station_id: String, ship_faction: String) -> bool:
	"""Check if ship can dock at station"""
	if not stations.has(station_id):
		return false

	var station = stations[station_id]

	# Owner always allowed
	if ship_faction == station.faction_id:
		return true

	# Public docking
	if station.public_docking:
		return true

	# TODO: Check faction relations for ally access

	return false

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_station_info(station_id: String) -> Dictionary:
	"""Get detailed station information"""
	if not stations.has(station_id):
		return {}

	return stations[station_id].get_info()

func get_available_sockets(station_id: String) -> int:
	"""Get available module sockets"""
	if not stations.has(station_id):
		return 0

	return stations[station_id].available_sockets

func get_all_stations() -> Array:
	"""Get all station IDs"""
	return stations.keys()

func get_stations_by_faction(faction_id: String) -> Array:
	"""Get all stations owned by faction"""
	var result = []
	for station_id in stations:
		var station = stations[station_id]
		if station.faction_id == faction_id:
			result.append(station_id)
	return result

func get_nearest_station(position: Vector2, faction_id: String = "") -> String:
	"""Find nearest station, optionally filtered by faction"""
	var nearest_id = ""
	var nearest_dist = INF

	for station_id in stations:
		var station = stations[station_id]

		# Faction filter
		if faction_id != "" and station.faction_id != faction_id:
			continue

		var dist = position.distance_to(station.position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_id = station_id

	return nearest_id

# ============================================================================
# SAVE/LOAD
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export station data for saving"""
	var stations_data = {}

	for station_id in stations:
		var station = stations[station_id]
		var modules_data = []

		for module in station.installed_modules:
			modules_data.append(module.get_info())

		stations_data[station_id] = {
			"name": station.station_name,
			"size": station.station_size,
			"position": {"x": station.position.x, "y": station.position.y},
			"faction": station.faction_id,
			"owner": station.owner_id,
			"installed_modules": modules_data,
			"docked_ships": station.docked_ships.duplicate(),
			"stored_items": station.stored_items.duplicate(),
			"public_docking": station.public_docking,
			"public_market": station.public_market
		}

	return {
		"stations": stations_data,
		"next_station_id": next_station_id
	}

func load_save_data(data: Dictionary):
	"""Import station data from save"""
	stations.clear()

	next_station_id = data.get("next_station_id", 1)

	if data.has("stations"):
		for station_id in data["stations"]:
			var station_data = data["stations"][station_id]
			var pos = Vector2(station_data["position"]["x"], station_data["position"]["y"])

			var station = Station.new(
				station_id,
				station_data["size"],
				pos,
				station_data["faction"]
			)

			station.station_name = station_data["name"]
			station.owner_id = station_data["owner"]
			station.docked_ships = station_data.get("docked_ships", {})
			station.stored_items = station_data.get("stored_items", {})
			station.public_docking = station_data.get("public_docking", true)
			station.public_market = station_data.get("public_market", false)

			# Load modules
			for module_data in station_data.get("installed_modules", []):
				var module = StationModule.new(
					module_data["module_id"],
					module_data["name"],
					ModuleCategory[module_data["category"]],
					module_data["sockets_required"]
				)
				module.tier = module_data.get("tier", 1)
				module.sockets_unlocked = module_data.get("sockets_unlocked", 0)
				module.processing_speed = module_data.get("processing_speed", 1.0)
				module.efficiency = module_data.get("efficiency", 1.0)
				module.capacity = module_data.get("capacity", 0.0)

				station.install_module(module)

			stations[station_id] = station
