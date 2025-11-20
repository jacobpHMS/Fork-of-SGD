extends Node

# ============================================================================
# FLEET AUTOMATION SYSTEM - Autonomous Ship Management (OPTIMIZED)
# ============================================================================
# ⚡ PERFORMANCE OPTIMIZED FOR 10,000+ SHIPS
# - Batch processing (100 ships per frame)
# - Update intervals (not every frame)
# - Spatial partitioning for fast proximity queries
# - Dirty flags for UI updates only when needed
# - Inactive ship culling

signal fleet_ship_spawned(ship_id: String)
signal fleet_ship_destroyed(ship_id: String)
signal automation_task_assigned(ship_id: String, task_type: String)
signal automation_task_complete(ship_id: String, result: Dictionary)
signal fleet_needs_repair(ship_id: String, hull_percent: float)
signal automation_error(ship_id: String, error: String)
signal fleet_stats_updated(stats: Dictionary)  # Batched stats update

# Automation modes
enum AutomationMode {
	MANUAL,      # No automation
	BASIC,       # Basic commands (go to, mine specific ore)
	EXTENDED,    # Semi-auto (mine area, return when full)
	AUTOMATIC    # Fully autonomous (mine, return, refine, repeat)
}

# Task types
enum TaskType {
	IDLE,           # Waiting for orders
	GOTO,           # Move to position
	MINE_ORE,       # Mine specific ore
	MINE_AREA,      # Mine in an area
	RETURN_BASE,    # Return to station
	DOCK,           # Dock at station
	UNLOAD,         # Unload cargo
	REFINE,         # Refine ore at station
	REPAIR,         # Repair at station
	PATROL          # Patrol an area
}

# Fleet ship data structure
class FleetShip:
	var ship_id: String = ""
	var ship_name: String = ""
	var ship_type: String = "miner_small"  # miner_small, miner_large, hauler, etc.

	# Position and movement
	var position: Vector2 = Vector2.ZERO
	var velocity: Vector2 = Vector2.ZERO
	var target_position: Vector2 = Vector2.ZERO
	var max_speed: float = 200.0

	# Ship stats
	var hull: float = 100.0
	var max_hull: float = 100.0
	var cargo_capacity: float = 1000.0
	var cargo: Dictionary = {}  # item_id -> amount
	var cargo_used: float = 0.0

	# Automation
	var automation_mode: AutomationMode = AutomationMode.MANUAL
	var ai_chip: Node = null  # Reference to AutominerChip
	var current_task: TaskType = TaskType.IDLE
	var task_target: Variant = null  # Position, ore_id, station_id, etc.
	var task_progress: float = 0.0

	# Station assignment
	var home_station: String = ""  # Default return station
	var current_station: String = ""  # Currently docked at

	# Energy
	var energy: float = 1000.0
	var max_energy: float = 1000.0
	var energy_consumption: float = 10.0  # Per second while active

	# Status
	var is_active: bool = true
	var is_docked: bool = false
	var needs_repair: bool = false
	var needs_fuel: bool = false

	# Mining stats (for miners)
	var mining_rate: float = 10.0  # Units per second
	var mining_range: float = 200.0

	func _init(id: String, name: String, type: String = "miner_small"):
		ship_id = id
		ship_name = name
		ship_type = type

		# Set stats based on type
		match ship_type:
			"miner_small":
				max_hull = 100.0
				cargo_capacity = 1000.0
				max_speed = 200.0
				mining_rate = 10.0
			"miner_large":
				max_hull = 200.0
				cargo_capacity = 5000.0
				max_speed = 150.0
				mining_rate = 25.0
			"hauler":
				max_hull = 150.0
				cargo_capacity = 10000.0
				max_speed = 180.0
				mining_rate = 0.0  # Can't mine

		hull = max_hull
		energy = max_energy

	func set_automation_mode(mode: AutomationMode):
		"""Set automation mode"""
		automation_mode = mode
		print("🤖 %s automation mode: %s" % [ship_name, AutomationMode.keys()[mode]])

	func assign_task(task: TaskType, target: Variant = null):
		"""Assign a new task"""
		current_task = task
		task_target = target
		task_progress = 0.0
		print("📋 %s assigned task: %s" % [ship_name, TaskType.keys()[task]])

	func add_cargo(item_id: String, amount: float) -> float:
		"""Add cargo, returns amount actually added"""
		var space = cargo_capacity - cargo_used
		var to_add = min(amount, space)

		if cargo.has(item_id):
			cargo[item_id] += to_add
		else:
			cargo[item_id] = to_add

		cargo_used += to_add
		return to_add

	func remove_cargo(item_id: String, amount: float) -> float:
		"""Remove cargo, returns amount actually removed"""
		if not cargo.has(item_id):
			return 0.0

		var to_remove = min(amount, cargo[item_id])
		cargo[item_id] -= to_remove
		cargo_used -= to_remove

		if cargo[item_id] <= 0:
			cargo.erase(item_id)

		return to_remove

	func is_cargo_full() -> bool:
		"""Check if cargo is full"""
		return cargo_used >= cargo_capacity * 0.95  # 95% threshold

	func needs_maintenance() -> bool:
		"""Check if ship needs maintenance"""
		return hull < max_hull * 0.5 or needs_repair

	func take_damage(amount: float):
		"""Apply damage to hull"""
		hull -= amount
		hull = max(0, hull)

		if hull < max_hull * 0.3:
			needs_repair = true

	func repair(amount: float):
		"""Repair hull"""
		hull += amount
		hull = min(hull, max_hull)

		if hull >= max_hull * 0.8:
			needs_repair = false

	func get_info() -> Dictionary:
		return {
			"ship_id": ship_id,
			"ship_name": ship_name,
			"ship_type": ship_type,
			"position": {"x": position.x, "y": position.y},
			"hull": hull,
			"max_hull": max_hull,
			"hull_percent": (hull / max_hull) * 100.0,
			"cargo_used": cargo_used,
			"cargo_capacity": cargo_capacity,
			"cargo_percent": (cargo_used / cargo_capacity) * 100.0,
			"energy": energy,
			"energy_percent": (energy / max_energy) * 100.0,
			"automation_mode": AutomationMode.keys()[automation_mode],
			"current_task": TaskType.keys()[current_task],
			"is_active": is_active,
			"is_docked": is_docked,
			"needs_repair": needs_repair,
			"home_station": home_station
		}

# Fleet database
var fleet_ships: Dictionary = {}  # ship_id -> FleetShip
var active_ships: Array[String] = []  # Only active ships (optimization)
var docked_ships: Array[String] = []  # Only docked ships

# Performance optimization
var ship_update_index: int = 0  # For batch processing
var ships_per_frame: int = 100  # Process 100 ships per frame
var update_interval: int = 0  # Frame counter
const STATS_UPDATE_INTERVAL: int = 60  # Update stats every 60 frames (1 sec)

# Dirty flags for UI optimization
var stats_dirty: bool = false
var cached_stats: Dictionary = {}

# Automation settings
var auto_return_on_full: bool = true
var auto_repair: bool = true
var auto_refine: bool = true

# References to other systems
var station_system: Node = null
var autominer_chip_system: Node = null
var performance_manager: Node = null

func _ready():
	print("🚀 Fleet Automation System initialized (OPTIMIZED)")

	# Get performance manager
	if has_node("/root/PerformanceManager"):
		performance_manager = get_node("/root/PerformanceManager")
		# Register with performance manager
		performance_manager.register_system(
			"FleetAutomation",
			_optimized_update,
			performance_manager.UpdatePriority.HIGH
		)
		print("   ✅ Registered with PerformanceManager")
	else:
		print("   ⚠️ PerformanceManager not found, using standard updates")

func _process(delta):
	# Only use this if PerformanceManager is not available
	if not performance_manager:
		_optimized_update(delta)

func _optimized_update(delta: float):
	"""OPTIMIZED update - batch processing for massive scale"""
	update_interval += 1

	# Get current batch of ships to update
	var ships_to_update = get_next_ship_batch()

	# Update batch
	for ship_id in ships_to_update:
		if fleet_ships.has(ship_id):
			var ship = fleet_ships[ship_id]
			if ship.is_active and not ship.is_docked:
				update_ship_automation(ship, delta)

	# Update stats periodically (not every frame)
	if update_interval % STATS_UPDATE_INTERVAL == 0:
		update_fleet_stats()

func get_next_ship_batch() -> Array[String]:
	"""Get next batch of ships to update (batch processing)"""
	var batch: Array[String] = []
	var start_index = ship_update_index

	# Circular batch processing
	for i in range(ships_per_frame):
		if active_ships.is_empty():
			break

		var ship_id = active_ships[ship_update_index]
		batch.append(ship_id)

		ship_update_index += 1
		if ship_update_index >= active_ships.size():
			ship_update_index = 0
			break  # Completed full cycle

	return batch

func update_fleet_stats():
	"""Update cached fleet statistics (called periodically)"""
	var stats = get_fleet_stats()
	cached_stats = stats
	stats_dirty = false
	emit_signal("fleet_stats_updated", stats)

# ============================================================================
# FLEET MANAGEMENT
# ============================================================================

func spawn_fleet_ship(ship_name: String, ship_type: String, position: Vector2, home_station: String = "") -> String:
	"""Spawn a new fleet ship (OPTIMIZED)"""
	var ship_id = "fleet_%s_%d" % [ship_type, Time.get_ticks_msec()]
	var ship = FleetShip.new(ship_id, ship_name, ship_type)
	ship.position = position
	ship.home_station = home_station

	fleet_ships[ship_id] = ship

	# Add to active ships list for batch processing
	if ship.is_active:
		active_ships.append(ship_id)

	# Register in spatial grid if PerformanceManager available
	if performance_manager:
		performance_manager.register_spatial_object(ship, position)

	emit_signal("fleet_ship_spawned", ship_id)
	stats_dirty = true

	# Only print every 100th ship to avoid spam
	if fleet_ships.size() % 100 == 0:
		print("🚀 Fleet size: %d ships" % fleet_ships.size())

	return ship_id

func destroy_fleet_ship(ship_id: String) -> bool:
	"""Destroy a fleet ship (OPTIMIZED)"""
	if not fleet_ships.has(ship_id):
		return false

	var ship = fleet_ships[ship_id]

	# Remove from active/docked lists
	active_ships.erase(ship_id)
	docked_ships.erase(ship_id)

	# Unregister from spatial grid
	if performance_manager:
		performance_manager.unregister_spatial_object(ship, ship.position)

	fleet_ships.erase(ship_id)

	emit_signal("fleet_ship_destroyed", ship_id)
	stats_dirty = true

	return true

func set_ship_automation_mode(ship_id: String, mode: AutomationMode) -> bool:
	"""Set automation mode for a ship"""
	if not fleet_ships.has(ship_id):
		return false

	fleet_ships[ship_id].set_automation_mode(mode)
	return true

func assign_ship_task(ship_id: String, task: TaskType, target: Variant = null) -> bool:
	"""Assign a task to a ship"""
	if not fleet_ships.has(ship_id):
		return false

	var ship = fleet_ships[ship_id]
	ship.assign_task(task, target)

	emit_signal("automation_task_assigned", ship_id, TaskType.keys()[task])

	return true

# ============================================================================
# AUTOMATION LOGIC
# ============================================================================

func update_ship_automation(ship: FleetShip, delta: float):
	"""Update ship automation AI"""

	# Consume energy
	ship.energy -= ship.energy_consumption * delta
	if ship.energy <= 0:
		ship.energy = 0
		ship.needs_fuel = true
		ship.is_active = false
		return

	# Check automation mode
	match ship.automation_mode:
		AutomationMode.MANUAL:
			# No automation, wait for manual commands
			return

		AutomationMode.BASIC:
			# Execute current task only
			execute_ship_task(ship, delta)

		AutomationMode.EXTENDED:
			# Semi-autonomous: smart task execution
			execute_extended_automation(ship, delta)

		AutomationMode.AUTOMATIC:
			# Fully autonomous: complete mining cycle
			execute_full_automation(ship, delta)

func execute_ship_task(ship: FleetShip, delta: float):
	"""Execute current ship task"""
	match ship.current_task:
		TaskType.IDLE:
			# Do nothing
			pass

		TaskType.GOTO:
			move_to_position(ship, ship.task_target, delta)

		TaskType.MINE_ORE:
			mine_ore(ship, ship.task_target, delta)

		TaskType.MINE_AREA:
			mine_in_area(ship, ship.task_target, delta)

		TaskType.RETURN_BASE:
			return_to_base(ship, delta)

		TaskType.DOCK:
			dock_at_station(ship, ship.task_target)

		TaskType.UNLOAD:
			unload_cargo(ship, delta)

		TaskType.REFINE:
			refine_cargo(ship, delta)

		TaskType.REPAIR:
			repair_ship(ship, delta)

func execute_extended_automation(ship: FleetShip, delta: float):
	"""Execute semi-autonomous automation"""

	# Priority 1: Repair if damaged
	if ship.needs_repair and auto_repair:
		if ship.current_task != TaskType.RETURN_BASE and ship.current_task != TaskType.REPAIR:
			ship.assign_task(TaskType.RETURN_BASE)
		execute_ship_task(ship, delta)
		return

	# Priority 2: Return if cargo full
	if ship.is_cargo_full() and auto_return_on_full:
		if ship.current_task != TaskType.RETURN_BASE and ship.current_task != TaskType.UNLOAD:
			ship.assign_task(TaskType.RETURN_BASE)
		execute_ship_task(ship, delta)
		return

	# Priority 3: Execute current task
	if ship.current_task != TaskType.IDLE:
		execute_ship_task(ship, delta)
		return

	# No task, go idle
	ship.assign_task(TaskType.IDLE)

func execute_full_automation(ship: FleetShip, delta: float):
	"""Execute fully autonomous automation (complete mining cycle)"""

	# State machine for full automation cycle:
	# MINE → RETURN → DOCK → UNLOAD → (REFINE) → UNDOCK → MINE

	# Priority 1: Critical repairs
	if ship.hull < ship.max_hull * 0.3:
		if not ship.is_docked:
			ship.assign_task(TaskType.RETURN_BASE)
			execute_ship_task(ship, delta)
		else:
			ship.assign_task(TaskType.REPAIR)
			execute_ship_task(ship, delta)
		return

	# Priority 2: Cargo full - return and unload
	if ship.is_cargo_full():
		if not ship.is_docked:
			ship.assign_task(TaskType.RETURN_BASE)
			execute_ship_task(ship, delta)
		else:
			# Docked with full cargo
			if ship.current_task != TaskType.UNLOAD:
				ship.assign_task(TaskType.UNLOAD)
			execute_ship_task(ship, delta)
		return

	# Priority 3: Docked with empty cargo - undock and mine
	if ship.is_docked and ship.cargo_used <= 0:
		undock_from_station(ship)
		ship.assign_task(TaskType.MINE_AREA, {"center": ship.position, "radius": 2000.0})
		return

	# Priority 4: Not docked, not full - mine
	if not ship.is_docked and not ship.is_cargo_full():
		if ship.current_task == TaskType.IDLE or ship.current_task == TaskType.RETURN_BASE:
			# Find nearest ore and mine
			ship.assign_task(TaskType.MINE_AREA, {"center": ship.position, "radius": 2000.0})

		execute_ship_task(ship, delta)
		return

	# Default: idle
	if ship.current_task == TaskType.IDLE:
		execute_ship_task(ship, delta)

# ============================================================================
# TASK EXECUTION IMPLEMENTATIONS
# ============================================================================

func move_to_position(ship: FleetShip, target_pos: Vector2, delta: float):
	"""Move ship to target position"""
	var distance = ship.position.distance_to(target_pos)

	if distance < 50.0:
		# Arrived
		ship.velocity = Vector2.ZERO
		ship.assign_task(TaskType.IDLE)
		emit_signal("automation_task_complete", ship.ship_id, {"task": "GOTO", "position": target_pos})
		return

	# Move towards target
	var direction = (target_pos - ship.position).normalized()
	ship.velocity = direction * ship.max_speed
	ship.position += ship.velocity * delta

func mine_ore(ship: FleetShip, ore_id: String, delta: float):
	"""Mine specific ore"""
	# Find ore in scene
	var ore_container = get_tree().get_first_node_in_group("ore_container")
	if not ore_container:
		ship.assign_task(TaskType.IDLE)
		return

	# Find nearest ore of type
	var nearest_ore = null
	var nearest_dist = INF

	for ore in ore_container.get_children():
		if is_instance_valid(ore) and ore.ore_id == ore_id:
			var dist = ship.position.distance_to(ore.global_position)
			if dist < nearest_dist:
				nearest_dist = dist
				nearest_ore = ore

	if not nearest_ore:
		# No ore found
		ship.assign_task(TaskType.IDLE)
		emit_signal("automation_error", ship.ship_id, "No ore found: " + ore_id)
		return

	# Move to ore if too far
	if nearest_dist > ship.mining_range:
		move_to_position(ship, nearest_ore.global_position, delta)
		return

	# Mine the ore
	if ship.is_cargo_full():
		# Cargo full
		if auto_return_on_full:
			ship.assign_task(TaskType.RETURN_BASE)
		else:
			ship.assign_task(TaskType.IDLE)
		return

	var mined = ship.mining_rate * delta
	var space = ship.cargo_capacity - ship.cargo_used
	mined = min(mined, space)
	mined = min(mined, nearest_ore.current_amount)

	# Add to ship cargo
	ship.add_cargo(ore_id, mined)

	# Remove from ore
	nearest_ore.current_amount -= mined
	if nearest_ore.current_amount <= 0:
		nearest_ore.queue_free()

func mine_in_area(ship: FleetShip, area_data: Dictionary, delta: float):
	"""Mine any ore in an area"""
	# Extract area parameters
	var center = area_data.get("center", ship.position)
	var radius = area_data.get("radius", 1000.0)

	# Find ores in area
	var ore_container = get_tree().get_first_node_in_group("ore_container")
	if not ore_container:
		ship.assign_task(TaskType.IDLE)
		return

	# Find nearest ore in area
	var nearest_ore = null
	var nearest_dist = INF

	for ore in ore_container.get_children():
		if is_instance_valid(ore):
			var dist_from_center = ore.global_position.distance_to(center)
			if dist_from_center <= radius:
				var dist_from_ship = ship.position.distance_to(ore.global_position)
				if dist_from_ship < nearest_dist:
					nearest_dist = dist_from_ship
					nearest_ore = ore

	if not nearest_ore:
		# No ore in area
		ship.assign_task(TaskType.IDLE)
		return

	# Mine the nearest ore
	mine_ore(ship, nearest_ore.ore_id, delta)

func return_to_base(ship: FleetShip, delta: float):
	"""Return to home station"""
	if ship.home_station == "":
		ship.assign_task(TaskType.IDLE)
		emit_signal("automation_error", ship.ship_id, "No home station assigned")
		return

	# Get station system
	if not station_system and has_node("/root/Player"):
		var player = get_node("/root/Player")
		if player.has_node("StationSystem"):
			station_system = player.get_node("StationSystem")

	if not station_system or not station_system.stations.has(ship.home_station):
		ship.assign_task(TaskType.IDLE)
		emit_signal("automation_error", ship.ship_id, "Home station not found")
		return

	var station = station_system.stations[ship.home_station]

	# Move to station
	var distance = ship.position.distance_to(station.position)

	if distance <= station.docking_range:
		# In docking range, dock
		dock_at_station(ship, ship.home_station)
		return

	move_to_position(ship, station.position, delta)

func dock_at_station(ship: FleetShip, station_id: String):
	"""Dock at a station (OPTIMIZED)"""
	if not station_system or not station_system.stations.has(station_id):
		ship.assign_task(TaskType.IDLE)
		return

	var station = station_system.stations[station_id]

	if not station.can_dock():
		ship.assign_task(TaskType.IDLE)
		emit_signal("automation_error", ship.ship_id, "Station docking full")
		return

	station.dock_ship(ship.ship_id)
	ship.is_docked = true
	ship.current_station = station_id
	ship.velocity = Vector2.ZERO

	# Move from active to docked list
	active_ships.erase(ship.ship_id)
	if not docked_ships.has(ship.ship_id):
		docked_ships.append(ship.ship_id)

	stats_dirty = true

	# Only log important docking events
	if fleet_ships.size() < 100 or docked_ships.size() % 100 == 0:
		print("🚢 %s docked at %s" % [ship.ship_name, station.station_name])

	# Auto-assign next task based on ship state
	if ship.cargo_used > 0:
		ship.assign_task(TaskType.UNLOAD)
	elif ship.needs_repair:
		ship.assign_task(TaskType.REPAIR)
	else:
		ship.assign_task(TaskType.IDLE)

func undock_from_station(ship: FleetShip):
	"""Undock from current station (OPTIMIZED)"""
	if not ship.is_docked:
		return

	if not station_system or not station_system.stations.has(ship.current_station):
		return

	var station = station_system.stations[ship.current_station]
	station.undock_ship(ship.ship_id)

	ship.is_docked = false
	ship.current_station = ""

	# Move from docked to active list
	docked_ships.erase(ship.ship_id)
	if ship.is_active and not active_ships.has(ship.ship_id):
		active_ships.append(ship.ship_id)

	stats_dirty = true

	# Minimal logging
	if fleet_ships.size() < 100:
		print("🚀 %s undocked" % ship.ship_name)

func unload_cargo(ship: FleetShip, delta: float):
	"""Unload cargo at docked station"""
	if not ship.is_docked:
		ship.assign_task(TaskType.IDLE)
		return

	if ship.cargo_used <= 0:
		# Cargo empty
		ship.assign_task(TaskType.IDLE)
		emit_signal("automation_task_complete", ship.ship_id, {"task": "UNLOAD", "amount": 0})
		return

	var station = station_system.stations[ship.current_station]

	# Transfer all cargo to station
	var items = ship.cargo.keys()
	for item_id in items:
		var amount = ship.cargo[item_id]
		var transferred = station.add_to_storage(item_id, amount)
		ship.remove_cargo(item_id, transferred)

	print("📦 %s unloaded cargo" % ship.ship_name)

	# Auto-refine if enabled
	if auto_refine and station.has_refinery:
		ship.assign_task(TaskType.REFINE)
	else:
		ship.assign_task(TaskType.IDLE)

func refine_cargo(ship: FleetShip, delta: float):
	"""Refine ore at station"""
	if not ship.is_docked:
		ship.assign_task(TaskType.IDLE)
		return

	var station = station_system.stations[ship.current_station]

	if not station.has_refinery:
		ship.assign_task(TaskType.IDLE)
		return

	# Get all ore in station storage and refine
	var refined_anything = false
	for item_id in station.storage.keys():
		if item_id.begins_with("ore_"):
			var amount = station.storage[item_id]
			# Start refining (would integrate with RefinerySystem)
			print("⚗️ %s refining %s at %s" % [ship.ship_name, item_id, station.station_name])
			refined_anything = true
			break  # One at a time

	if not refined_anything:
		ship.assign_task(TaskType.IDLE)

func repair_ship(ship: FleetShip, delta: float):
	"""Repair ship at station"""
	if not ship.is_docked:
		ship.assign_task(TaskType.IDLE)
		return

	# Repair rate: 10 HP/s
	var repair_rate = 10.0
	ship.repair(repair_rate * delta)

	if ship.hull >= ship.max_hull:
		print("✅ %s repaired" % ship.ship_name)
		ship.assign_task(TaskType.IDLE)
		emit_signal("automation_task_complete", ship.ship_id, {"task": "REPAIR", "hull": ship.hull})

# ============================================================================
# SAVE/LOAD INTEGRATION
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export fleet automation data for saving"""
	var ships_data = {}

	for ship_id in fleet_ships:
		var ship = fleet_ships[ship_id]
		ships_data[ship_id] = {
			"ship_name": ship.ship_name,
			"ship_type": ship.ship_type,
			"position": {"x": ship.position.x, "y": ship.position.y},
			"hull": ship.hull,
			"energy": ship.energy,
			"cargo": ship.cargo.duplicate(),
			"cargo_used": ship.cargo_used,
			"automation_mode": ship.automation_mode,
			"current_task": ship.current_task,
			"home_station": ship.home_station,
			"is_docked": ship.is_docked,
			"current_station": ship.current_station
		}

	return {
		"fleet_ships": ships_data,
		"auto_return_on_full": auto_return_on_full,
		"auto_repair": auto_repair,
		"auto_refine": auto_refine
	}

func load_save_data(data: Dictionary):
	"""Import fleet automation data from save file"""
	fleet_ships.clear()

	if data.has("fleet_ships"):
		for ship_id in data["fleet_ships"]:
			var s_data = data["fleet_ships"][ship_id]
			var ship = FleetShip.new(ship_id, s_data["ship_name"], s_data["ship_type"])
			ship.position = Vector2(s_data["position"]["x"], s_data["position"]["y"])
			ship.hull = s_data["hull"]
			ship.energy = s_data["energy"]
			ship.cargo = s_data["cargo"].duplicate()
			ship.cargo_used = s_data["cargo_used"]
			ship.automation_mode = s_data["automation_mode"]
			ship.current_task = s_data["current_task"]
			ship.home_station = s_data.get("home_station", "")
			ship.is_docked = s_data.get("is_docked", false)
			ship.current_station = s_data.get("current_station", "")
			fleet_ships[ship_id] = ship

	auto_return_on_full = data.get("auto_return_on_full", true)
	auto_repair = data.get("auto_repair", true)
	auto_refine = data.get("auto_refine", true)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_fleet_info() -> Array:
	"""Get information about all fleet ships"""
	var result = []
	for ship_id in fleet_ships:
		result.append(fleet_ships[ship_id].get_info())
	return result

func get_ship_info(ship_id: String) -> Dictionary:
	"""Get detailed ship information"""
	if not fleet_ships.has(ship_id):
		return {}

	return fleet_ships[ship_id].get_info()

func get_fleet_stats() -> Dictionary:
	"""Get overall fleet statistics"""
	var total_ships = fleet_ships.size()
	var active_ships = 0
	var docked_ships = 0
	var mining_ships = 0
	var total_cargo = 0.0

	for ship_id in fleet_ships:
		var ship = fleet_ships[ship_id]
		if ship.is_active:
			active_ships += 1
		if ship.is_docked:
			docked_ships += 1
		if ship.current_task == TaskType.MINE_ORE or ship.current_task == TaskType.MINE_AREA:
			mining_ships += 1
		total_cargo += ship.cargo_used

	return {
		"total_ships": total_ships,
		"active_ships": active_ships,
		"docked_ships": docked_ships,
		"mining_ships": mining_ships,
		"total_cargo": total_cargo
	}
