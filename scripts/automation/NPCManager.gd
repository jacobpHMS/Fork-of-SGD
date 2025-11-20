extends Node

# ============================================================================
# NPC MANAGER - Non-Player Character Ship Management
# ============================================================================
# Manages all NPC ships in the world (merchants, pirates, military, etc.)
# Handles spawning, behavior, and lifecycle

signal npc_spawned(npc_id: String, npc_data: Dictionary)
signal npc_destroyed(npc_id: String)
signal npc_behavior_changed(npc_id: String, new_behavior: String)

# NPC Types
enum NPCType {
	MERCHANT,      # Trader ships
	MINER,         # Mining ships
	MILITARY,      # Military patrol/defense
	PIRATE,        # Pirates/hostile
	CIVILIAN,      # Civilian traffic
	TRANSPORT,     # Cargo haulers
	SCOUT,         # Scout/recon ships
	CAPITAL        # Capital ships
}

# NPC Behaviors (State Machine)
enum NPCBehavior {
	IDLE,          # Doing nothing
	TRAVELING,     # Moving to destination
	TRADING,       # At station trading
	MINING,        # Mining asteroids
	PATROLLING,    # On patrol
	ATTACKING,     # In combat
	FLEEING,       # Running away
	DOCKED,        # Docked at station
	ESCORTING,     # Escorting another ship
	WAITING        # Waiting for orders
}

# NPC Ship class
class NPCShip:
	var npc_id: String = ""
	var npc_name: String = ""
	var npc_type: NPCType = NPCType.MERCHANT
	var faction_id: String = "neutral"

	# Position & movement
	var position: Vector2 = Vector2.ZERO
	var velocity: Vector2 = Vector2.ZERO
	var heading: float = 0.0
	var max_speed: float = 200.0

	# Stats
	var hull: float = 100.0
	var max_hull: float = 100.0
	var shields: float = 0.0
	var max_shields: float = 0.0
	var cargo_used: float = 0.0
	var cargo_capacity: float = 1000.0
	var credits: float = 10000.0

	# Behavior state
	var current_behavior: NPCBehavior = NPCBehavior.IDLE
	var behavior_data: Dictionary = {}  # Behavior-specific data

	# AI settings
	var aggression: float = 0.5  # 0.0 = passive, 1.0 = aggressive
	var intelligence: float = 0.5  # 0.0 = dumb, 1.0 = smart
	var trade_skill: float = 0.5
	var combat_skill: float = 0.5

	# Status
	var is_active: bool = true
	var is_visible: bool = false  # Visible to player
	var is_hostile: bool = false
	var target_id: String = ""  # Current target (combat, escort, etc.)
	var destination: Vector2 = Vector2.ZERO
	var home_station: String = ""

	# Command chain
	var commander_id: String = ""  # Part of fleet?
	var subordinates: Array[String] = []  # Commands these ships

	func _init(id: String, name: String, type: NPCType, faction: String = "neutral"):
		npc_id = id
		npc_name = name
		npc_type = type
		faction_id = faction

		# Set stats based on type
		match npc_type:
			NPCType.MERCHANT:
				max_hull = 150.0
				cargo_capacity = 5000.0
				max_speed = 150.0
				aggression = 0.1
			NPCType.MINER:
				max_hull = 100.0
				cargo_capacity = 3000.0
				max_speed = 120.0
				aggression = 0.0
			NPCType.MILITARY:
				max_hull = 300.0
				max_shields = 200.0
				max_speed = 250.0
				aggression = 0.7
				combat_skill = 0.8
			NPCType.PIRATE:
				max_hull = 200.0
				max_shields = 100.0
				max_speed = 280.0
				aggression = 0.9
				is_hostile = true
			NPCType.CIVILIAN:
				max_hull = 80.0
				cargo_capacity = 500.0
				max_speed = 180.0
				aggression = 0.0
			NPCType.TRANSPORT:
				max_hull = 250.0
				cargo_capacity = 10000.0
				max_speed = 140.0
				aggression = 0.2
			NPCType.SCOUT:
				max_hull = 80.0
				max_speed = 350.0
				aggression = 0.3
			NPCType.CAPITAL:
				max_hull = 1000.0
				max_shields = 500.0
				cargo_capacity = 20000.0
				max_speed = 100.0
				aggression = 0.6

		hull = max_hull
		shields = max_shields

	func set_behavior(behavior: NPCBehavior, data: Dictionary = {}):
		"""Change NPC behavior"""
		current_behavior = behavior
		behavior_data = data

	func take_damage(amount: float):
		"""Apply damage to NPC"""
		if shields > 0:
			shields -= amount
			if shields < 0:
				hull += shields  # Overflow to hull
				shields = 0
		else:
			hull -= amount

		hull = max(0, hull)

	func is_alive() -> bool:
		return hull > 0

	func is_in_combat() -> bool:
		return current_behavior == NPCBehavior.ATTACKING or target_id != ""

	func get_info() -> Dictionary:
		return {
			"npc_id": npc_id,
			"npc_name": npc_name,
			"type": NPCType.keys()[npc_type],
			"faction": faction_id,
			"position": {"x": position.x, "y": position.y},
			"behavior": NPCBehavior.keys()[current_behavior],
			"hull": hull,
			"hull_percent": (hull / max_hull) * 100.0,
			"shields": shields,
			"is_hostile": is_hostile,
			"is_active": is_active,
			"commander": commander_id,
			"subordinates": subordinates.size()
		}

# ============================================================================
# NPC DATABASE
# ============================================================================

var npcs: Dictionary = {}  # npc_id -> NPCShip
var npcs_by_faction: Dictionary = {}  # faction_id -> Array[npc_id]
var npcs_by_type: Dictionary = {}  # NPCType -> Array[npc_id]

# Performance optimization
var active_npcs: Array[String] = []  # NPCs actively simulated
var dormant_npcs: Array[String] = []  # NPCs in background simulation
var npc_update_index: int = 0
var npcs_per_frame: int = 100

# Spawning settings
var auto_spawn_enabled: bool = true
var target_npc_population: int = 500
var spawn_timer: float = 0.0
var spawn_interval: float = 5.0  # Spawn check every 5 seconds

# Orchestrator reference
var orchestrator: Node = null

# ============================================================================
# INITIALIZATION
# ============================================================================

func _ready():
	print("🤖 NPC Manager initialized")

	# Initialize faction lists
	for type in NPCType.values():
		npcs_by_type[type] = []

func set_orchestrator(orch: Node):
	"""Set orchestrator reference"""
	orchestrator = orch

func _orchestrated_update(delta: float):
	"""Update NPCs (called by orchestrator)"""
	# Batch update active NPCs
	var batch = get_next_npc_batch()

	for npc_id in batch:
		if npcs.has(npc_id):
			update_npc(npcs[npc_id], delta)

	# Auto-spawning
	if auto_spawn_enabled:
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			spawn_timer = 0.0
			check_spawn_population()

func _world_tick(tick: int):
	"""Called on world tick (slower update)"""
	# Background simulation for dormant NPCs
	for npc_id in dormant_npcs:
		if npcs.has(npc_id):
			background_simulate_npc(npcs[npc_id])

# ============================================================================
# NPC SPAWNING
# ============================================================================

func spawn_npc(npc_type: NPCType, faction_id: String, position: Vector2, name: String = "") -> String:
	"""Spawn a new NPC ship"""
	var npc_id = "npc_%s_%d" % [NPCType.keys()[npc_type].to_lower(), Time.get_ticks_msec()]

	if name == "":
		name = generate_npc_name(npc_type)

	var npc = NPCShip.new(npc_id, name, npc_type, faction_id)
	npc.position = position

	# Add to databases
	npcs[npc_id] = npc
	active_npcs.append(npc_id)

	# Add to faction list
	if not npcs_by_faction.has(faction_id):
		npcs_by_faction[faction_id] = []
	npcs_by_faction[faction_id].append(npc_id)

	# Add to type list
	npcs_by_type[npc_type].append(npc_id)

	# Assign initial behavior
	assign_initial_behavior(npc)

	emit_signal("npc_spawned", npc_id, npc.get_info())

	# Minimal logging
	if npcs.size() % 100 == 0:
		print("🤖 NPC population: %d" % npcs.size())

	return npc_id

func generate_npc_name(type: NPCType) -> String:
	"""Generate random NPC name"""
	var prefixes = ["USS", "HMS", "IMS", "FNS", "RNS", "CNS"]
	var names = ["Venture", "Prospect", "Enterprise", "Discovery", "Explorer", "Pioneer",
				 "Mercury", "Atlas", "Titan", "Orion", "Phoenix", "Dragon"]

	return "%s %s-%03d" % [prefixes.pick_random(), names.pick_random(), randi() % 1000]

func assign_initial_behavior(npc: NPCShip):
	"""Assign initial behavior based on NPC type"""
	match npc.npc_type:
		NPCType.MERCHANT:
			npc.set_behavior(NPCBehavior.TRADING)
		NPCType.MINER:
			npc.set_behavior(NPCBehavior.MINING)
		NPCType.MILITARY:
			npc.set_behavior(NPCBehavior.PATROLLING)
		NPCType.PIRATE:
			npc.set_behavior(NPCBehavior.PATROLLING)
		NPCType.CIVILIAN:
			npc.set_behavior(NPCBehavior.TRAVELING)
		NPCType.TRANSPORT:
			npc.set_behavior(NPCBehavior.TRAVELING)
		NPCType.SCOUT:
			npc.set_behavior(NPCBehavior.PATROLLING)
		_:
			npc.set_behavior(NPCBehavior.IDLE)

func check_spawn_population():
	"""Check if more NPCs should be spawned"""
	if npcs.size() >= target_npc_population:
		return

	# Spawn NPCs based on distribution
	var spawn_type = get_random_npc_type()
	var spawn_faction = get_random_faction()
	var spawn_pos = get_random_spawn_position()

	spawn_npc(spawn_type, spawn_faction, spawn_pos)

func get_random_npc_type() -> NPCType:
	"""Get random NPC type weighted by distribution"""
	var roll = randf()

	if roll < 0.3: return NPCType.MERCHANT
	elif roll < 0.5: return NPCType.MINER
	elif roll < 0.65: return NPCType.TRANSPORT
	elif roll < 0.75: return NPCType.MILITARY
	elif roll < 0.85: return NPCType.CIVILIAN
	elif roll < 0.95: return NPCType.PIRATE
	else: return NPCType.SCOUT

func get_random_faction() -> String:
	"""Get random faction ID"""
	# This would integrate with FactionSystem
	var factions = ["player_faction", "merchants_guild", "pirates", "military", "neutral"]
	return factions.pick_random()

func get_random_spawn_position() -> Vector2:
	"""Get random spawn position"""
	var radius = 10000.0
	var angle = randf() * TAU
	return Vector2(cos(angle), sin(angle)) * radius

# ============================================================================
# NPC UPDATE
# ============================================================================

func update_npc(npc: NPCShip, delta: float):
	"""Update a single NPC"""
	if not npc.is_active or not npc.is_alive():
		return

	# Update based on behavior
	match npc.current_behavior:
		NPCBehavior.IDLE:
			update_idle(npc, delta)
		NPCBehavior.TRAVELING:
			update_traveling(npc, delta)
		NPCBehavior.TRADING:
			update_trading(npc, delta)
		NPCBehavior.MINING:
			update_mining(npc, delta)
		NPCBehavior.PATROLLING:
			update_patrolling(npc, delta)
		NPCBehavior.ATTACKING:
			update_attacking(npc, delta)
		NPCBehavior.FLEEING:
			update_fleeing(npc, delta)

	# Update movement
	npc.position += npc.velocity * delta

func update_idle(npc: NPCShip, delta: float):
	"""Update idle behavior"""
	# Randomly decide to do something
	if randf() < 0.01 * delta:  # 1% chance per second
		assign_initial_behavior(npc)

func update_traveling(npc: NPCShip, delta: float):
	"""Update traveling behavior"""
	if npc.destination == Vector2.ZERO:
		npc.set_behavior(NPCBehavior.IDLE)
		return

	# Move towards destination
	var direction = (npc.destination - npc.position).normalized()
	npc.velocity = direction * npc.max_speed

	# Check arrival
	if npc.position.distance_to(npc.destination) < 100.0:
		npc.velocity = Vector2.ZERO
		npc.set_behavior(NPCBehavior.IDLE)

func update_trading(npc: NPCShip, delta: float):
	"""Update trading behavior"""
	# Would integrate with TradeAI subsystem
	pass

func update_mining(npc: NPCShip, delta: float):
	"""Update mining behavior"""
	# Find nearest asteroid and mine
	pass

func update_patrolling(npc: NPCShip, delta: float):
	"""Update patrol behavior"""
	# Would integrate with PatrolSystem
	pass

func update_attacking(npc: NPCShip, delta: float):
	"""Update combat behavior"""
	# Would integrate with CombatAI
	pass

func update_fleeing(npc: NPCShip, delta: float):
	"""Update flee behavior"""
	# Run away from threat
	if npc.target_id != "" and npcs.has(npc.target_id):
		var threat = npcs[npc.target_id]
		var flee_direction = (npc.position - threat.position).normalized()
		npc.velocity = flee_direction * npc.max_speed

func background_simulate_npc(npc: NPCShip):
	"""Simplified background simulation for dormant NPCs"""
	# Simplified state updates without full simulation
	pass

# ============================================================================
# NPC DESTRUCTION
# ============================================================================

func destroy_npc(npc_id: String):
	"""Destroy an NPC ship"""
	if not npcs.has(npc_id):
		return

	var npc = npcs[npc_id]

	# Remove from all lists
	active_npcs.erase(npc_id)
	dormant_npcs.erase(npc_id)

	if npcs_by_faction.has(npc.faction_id):
		npcs_by_faction[npc.faction_id].erase(npc_id)

	npcs_by_type[npc.npc_type].erase(npc_id)

	npcs.erase(npc_id)

	emit_signal("npc_destroyed", npc_id)

# ============================================================================
# BATCH PROCESSING
# ============================================================================

func get_next_npc_batch() -> Array[String]:
	"""Get next batch of NPCs to update"""
	var batch: Array[String] = []

	for i in range(npcs_per_frame):
		if active_npcs.is_empty():
			break

		var npc_id = active_npcs[npc_update_index]
		batch.append(npc_id)

		npc_update_index += 1
		if npc_update_index >= active_npcs.size():
			npc_update_index = 0
			break

	return batch

# ============================================================================
# QUERIES
# ============================================================================

func get_npc(npc_id: String) -> NPCShip:
	return npcs.get(npc_id, null)

func get_npc_count() -> int:
	return npcs.size()

func get_ships_by_faction(faction_id: String) -> Array:
	return npcs_by_faction.get(faction_id, [])

func get_ships_by_type(type: NPCType) -> Array:
	return npcs_by_type.get(type, [])

func get_ships_in_range(position: Vector2, range: float) -> Array:
	"""Get NPCs in range of position"""
	var results = []

	for npc_id in active_npcs:
		var npc = npcs[npc_id]
		if npc.position.distance_to(position) <= range:
			results.append(npc_id)

	return results

func get_ship_faction(npc_id: String) -> String:
	if npcs.has(npc_id):
		return npcs[npc_id].faction_id
	return ""

# ============================================================================
# SAVE/LOAD
# ============================================================================

func get_save_data() -> Dictionary:
	var npcs_data = {}

	for npc_id in npcs:
		var npc = npcs[npc_id]
		npcs_data[npc_id] = {
			"name": npc.npc_name,
			"type": npc.npc_type,
			"faction": npc.faction_id,
			"position": {"x": npc.position.x, "y": npc.position.y},
			"hull": npc.hull,
			"behavior": npc.current_behavior,
			"commander": npc.commander_id
		}

	return {"npcs": npcs_data}

func load_save_data(data: Dictionary):
	npcs.clear()
	active_npcs.clear()

	if data.has("npcs"):
		for npc_id in data["npcs"]:
			var npc_data = data["npcs"][npc_id]
			var npc = NPCShip.new(npc_id, npc_data["name"], npc_data["type"], npc_data["faction"])
			npc.position = Vector2(npc_data["position"]["x"], npc_data["position"]["y"])
			npc.hull = npc_data["hull"]
			npc.current_behavior = npc_data["behavior"]
			npc.commander_id = npc_data.get("commander", "")

			npcs[npc_id] = npc
			active_npcs.append(npc_id)
