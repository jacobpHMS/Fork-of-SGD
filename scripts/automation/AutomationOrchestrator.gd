extends Node

# ============================================================================
# AUTOMATION ORCHESTRATOR - Central AI & Automation Management
# ============================================================================
# X4-inspired automation system for massive NPC fleets and world simulation
# Orchestrates all AI subsystems with hierarchical command structures
#
# ARCHITECTURE:
# AutomationOrchestrator (this)
#   ├── NPCManager          (NPC ships, behaviors)
#   ├── FactionSystem       (factions, diplomacy)
#   ├── CommandHierarchy    (fleet command chains)
#   ├── PatrolSystem        (patrol routes)
#   ├── InformationNetwork  (visibility, sensors)
#   ├── CombatAI            (combat behaviors)
#   ├── TradeAI             (trading behaviors)
#   ├── StationAI           (station autonomy)
#   └── EscortSystem        (escort behaviors)

signal orchestrator_ready()
signal subsystem_loaded(system_name: String)
signal subsystem_error(system_name: String, error: String)
signal world_tick(tick: int)  # World simulation tick

# ============================================================================
# SUBSYSTEM REFERENCES
# ============================================================================

# Core Subsystems (loaded on demand)
var npc_manager: Node = null
var faction_system: Node = null
var command_hierarchy: Node = null
var patrol_system: Node = null
var information_network: Node = null
var combat_ai: Node = null
var trade_ai: Node = null
var station_ai: Node = null
var escort_system: Node = null

# NEW SYSTEMS
var security_system: Node = null
var passenger_system: Node = null
var planet_system: Node = null
var asteroid_field_manager: Node = null

# Subsystem Paths
const SUBSYSTEMS = {
	"NPCManager": "res://scripts/automation/NPCManager.gd",
	"FactionSystem": "res://scripts/automation/FactionSystem.gd",
	"CommandHierarchy": "res://scripts/automation/CommandHierarchy.gd",
	"PatrolSystem": "res://scripts/automation/PatrolSystem.gd",
	"InformationNetwork": "res://scripts/automation/InformationNetwork.gd",
	"CombatAI": "res://scripts/automation/CombatAI.gd",
	"TradeAI": "res://scripts/automation/TradeAI.gd",
	"StationAI": "res://scripts/automation/StationAI.gd",
	"EscortSystem": "res://scripts/automation/EscortSystem.gd",
	"SecurityLevelSystem": "res://scripts/SecurityLevelSystem.gd",
	"PassengerSystem": "res://scripts/PassengerSystem.gd",
	"PlanetSystem": "res://scripts/PlanetSystem.gd",
	"AsteroidFieldManager": "res://scripts/AsteroidFieldManager.gd"
}

# Subsystem Loading State
enum LoadState {
	NOT_LOADED,
	LOADING,
	LOADED,
	ERROR
}

var subsystem_states: Dictionary = {}  # system_name -> LoadState
var loaded_subsystems: Dictionary = {}  # system_name -> Node instance

# ============================================================================
# ORCHESTRATION STATE
# ============================================================================

# World simulation
var world_tick_counter: int = 0
var world_tick_rate: float = 1.0  # Ticks per second
var world_tick_timer: float = 0.0

# Performance settings
var max_npcs_per_tick: int = 100  # Max NPCs to update per tick
var enable_background_simulation: bool = true  # Simulate off-screen areas
var simulation_distance: float = 10000.0  # Distance for active simulation

# Orchestration modes
enum OrchestrationMode {
	DISABLED,      # No automation
	MINIMAL,       # Only player-relevant AI
	STANDARD,      # Standard world simulation
	FULL           # Full world simulation (heavy)
}

var current_mode: OrchestrationMode = OrchestrationMode.STANDARD

# System priorities (for performance management)
enum SystemPriority {
	CRITICAL = 0,  # Must run every tick
	HIGH = 1,      # Run most ticks
	MEDIUM = 2,    # Run periodically
	LOW = 3        # Run occasionally
}

const SYSTEM_PRIORITIES = {
	"NPCManager": SystemPriority.CRITICAL,
	"CombatAI": SystemPriority.CRITICAL,
	"CommandHierarchy": SystemPriority.HIGH,
	"InformationNetwork": SystemPriority.HIGH,
	"PatrolSystem": SystemPriority.MEDIUM,
	"TradeAI": SystemPriority.MEDIUM,
	"StationAI": SystemPriority.MEDIUM,
	"EscortSystem": SystemPriority.HIGH,
	"FactionSystem": SystemPriority.LOW,
	"SecurityLevelSystem": SystemPriority.LOW,
	"PassengerSystem": SystemPriority.MEDIUM,
	"PlanetSystem": SystemPriority.MEDIUM,
	"AsteroidFieldManager": SystemPriority.MEDIUM
}

# ============================================================================
# INITIALIZATION
# ============================================================================

func _ready():
	print("╔════════════════════════════════════════════════════════╗")
	print("║  AUTOMATION ORCHESTRATOR - Initializing               ║")
	print("╚════════════════════════════════════════════════════════╝")

	# Initialize subsystem states
	for system_name in SUBSYSTEMS:
		subsystem_states[system_name] = LoadState.NOT_LOADED

	# Load core subsystems
	await load_core_subsystems()

	# Connect to PerformanceManager if available
	if has_node("/root/PerformanceManager"):
		var perf = get_node("/root/PerformanceManager")
		perf.register_system(
			"AutomationOrchestrator",
			_orchestration_update,
			perf.UpdatePriority.CRITICAL
		)
		print("✅ Registered with PerformanceManager")

	emit_signal("orchestrator_ready")
	print("✅ Automation Orchestrator ready!")

func load_core_subsystems():
	"""Load essential subsystems on startup"""
	print("\n⚙️  Loading core subsystems...")

	# Load in order of dependency
	await load_subsystem("SecurityLevelSystem")  # NEW: Security levels first
	await load_subsystem("FactionSystem")        # Base data
	await load_subsystem("PlanetSystem")         # NEW: Planets
	await load_subsystem("AsteroidFieldManager") # NEW: Asteroid fields
	await load_subsystem("NPCManager")           # NPC management
	await load_subsystem("PassengerSystem")      # NEW: Passengers
	await load_subsystem("CommandHierarchy")     # Fleet hierarchy
	await load_subsystem("InformationNetwork")   # Visibility
	await load_subsystem("CombatAI")             # Combat
	await load_subsystem("PatrolSystem")         # Patrols

	# Generate planets for all systems
	if planet_system:
		planet_system.generate_all_planets()

	# Generate asteroid fields for all systems
	if asteroid_field_manager:
		asteroid_field_manager.generate_all_fields()

	print("\n✅ Core subsystems loaded!")

func load_subsystem(system_name: String):
	"""Load a subsystem dynamically"""
	if subsystem_states.get(system_name, LoadState.ERROR) == LoadState.LOADED:
		print("  ℹ️  %s already loaded" % system_name)
		return

	subsystem_states[system_name] = LoadState.LOADING
	print("  ⏳ Loading %s..." % system_name)

	# Check if file exists
	var path = SUBSYSTEMS.get(system_name, "")
	if path == "" or not FileAccess.file_exists(path):
		print("  ❌ %s not found at %s" % [system_name, path])
		subsystem_states[system_name] = LoadState.ERROR
		emit_signal("subsystem_error", system_name, "File not found")
		return

	# Load and instantiate
	var script = load(path)
	if script == null:
		print("  ❌ Failed to load script: %s" % system_name)
		subsystem_states[system_name] = LoadState.ERROR
		emit_signal("subsystem_error", system_name, "Script load failed")
		return

	var instance = Node.new()
	instance.set_script(script)
	instance.name = system_name
	add_child(instance)

	# Store reference
	loaded_subsystems[system_name] = instance
	subsystem_states[system_name] = LoadState.LOADED

	# Set subsystem reference
	match system_name:
		"NPCManager": npc_manager = instance
		"FactionSystem": faction_system = instance
		"CommandHierarchy": command_hierarchy = instance
		"PatrolSystem": patrol_system = instance
		"InformationNetwork": information_network = instance
		"CombatAI": combat_ai = instance
		"TradeAI": trade_ai = instance
		"StationAI": station_ai = instance
		"EscortSystem": escort_system = instance
		"SecurityLevelSystem": security_system = instance
		"PassengerSystem": passenger_system = instance
		"PlanetSystem": planet_system = instance
		"AsteroidFieldManager": asteroid_field_manager = instance

	# Connect subsystem to orchestrator
	if instance.has_method("set_orchestrator"):
		instance.set_orchestrator(self)

	print("  ✅ %s loaded" % system_name)
	emit_signal("subsystem_loaded", system_name)

	# Small delay to avoid frame spikes
	await get_tree().create_timer(0.1).timeout

# ============================================================================
# ORCHESTRATION UPDATE
# ============================================================================

func _process(delta):
	# Only update if not using PerformanceManager
	if not has_node("/root/PerformanceManager"):
		_orchestration_update(delta)

	# World tick timer
	world_tick_timer += delta
	if world_tick_timer >= (1.0 / world_tick_rate):
		world_tick_timer = 0.0
		world_tick_counter += 1
		emit_signal("world_tick", world_tick_counter)

		# Update subsystems based on priority
		update_subsystems_by_priority()

func _orchestration_update(delta: float):
	"""Main orchestration update loop"""
	# Update critical systems every frame
	if npc_manager:
		npc_manager._orchestrated_update(delta)

	if combat_ai:
		combat_ai._orchestrated_update(delta)

func update_subsystems_by_priority():
	"""Update subsystems based on priority and world tick"""
	for system_name in loaded_subsystems:
		var system = loaded_subsystems[system_name]
		var priority = SYSTEM_PRIORITIES.get(system_name, SystemPriority.MEDIUM)

		# Decide if system should update this tick
		var should_update = false

		match priority:
			SystemPriority.CRITICAL:
				should_update = true  # Every tick
			SystemPriority.HIGH:
				should_update = (world_tick_counter % 2 == 0)  # Every 2 ticks
			SystemPriority.MEDIUM:
				should_update = (world_tick_counter % 5 == 0)  # Every 5 ticks
			SystemPriority.LOW:
				should_update = (world_tick_counter % 10 == 0)  # Every 10 ticks

		if should_update and system.has_method("_world_tick"):
			system._world_tick(world_tick_counter)

# ============================================================================
# ORCHESTRATION COMMANDS
# ============================================================================

func set_orchestration_mode(mode: OrchestrationMode):
	"""Set orchestration mode (performance vs simulation depth)"""
	current_mode = mode

	match mode:
		OrchestrationMode.DISABLED:
			print("⏸️  Automation DISABLED")
			world_tick_rate = 0.0

		OrchestrationMode.MINIMAL:
			print("🔽 Automation MINIMAL (player-relevant only)")
			world_tick_rate = 0.5
			max_npcs_per_tick = 50

		OrchestrationMode.STANDARD:
			print("▶️  Automation STANDARD")
			world_tick_rate = 1.0
			max_npcs_per_tick = 100

		OrchestrationMode.FULL:
			print("🔼 Automation FULL (heavy)")
			world_tick_rate = 2.0
			max_npcs_per_tick = 200

func pause_orchestration():
	"""Pause all automation"""
	set_orchestration_mode(OrchestrationMode.DISABLED)

func resume_orchestration():
	"""Resume automation"""
	set_orchestration_mode(OrchestrationMode.STANDARD)

# ============================================================================
# SUBSYSTEM ACCESS
# ============================================================================

func get_subsystem(system_name: String) -> Node:
	"""Get a loaded subsystem"""
	return loaded_subsystems.get(system_name, null)

func is_subsystem_loaded(system_name: String) -> bool:
	"""Check if subsystem is loaded"""
	return subsystem_states.get(system_name, LoadState.NOT_LOADED) == LoadState.LOADED

func reload_subsystem(system_name: String):
	"""Reload a subsystem"""
	if loaded_subsystems.has(system_name):
		var system = loaded_subsystems[system_name]
		system.queue_free()
		loaded_subsystems.erase(system_name)
		subsystem_states[system_name] = LoadState.NOT_LOADED

	await load_subsystem(system_name)

# ============================================================================
# COMMAND DISPATCH
# ============================================================================

func dispatch_command(ship_id: String, command: Dictionary):
	"""Dispatch a command to a ship through appropriate subsystem"""
	# Route command to correct subsystem based on type
	var command_type = command.get("type", "")

	match command_type:
		"attack", "defend", "engage":
			if combat_ai:
				combat_ai.assign_combat_command(ship_id, command)

		"patrol", "guard":
			if patrol_system:
				patrol_system.assign_patrol(ship_id, command)

		"escort", "follow":
			if escort_system:
				escort_system.assign_escort(ship_id, command)

		"trade", "mine", "haul":
			if trade_ai:
				trade_ai.assign_trade_command(ship_id, command)

		_:
			print("⚠️  Unknown command type: %s" % command_type)

func dispatch_fleet_command(fleet_id: String, command: Dictionary):
	"""Dispatch command to entire fleet"""
	if command_hierarchy:
		command_hierarchy.command_fleet(fleet_id, command)

# ============================================================================
# WORLD QUERIES
# ============================================================================

func get_visible_objects(position: Vector2, range: float) -> Array:
	"""Get visible objects at position (via InformationNetwork)"""
	if information_network:
		return information_network.query_visible_objects(position, range)
	return []

func get_faction_ships(faction_id: String) -> Array:
	"""Get all ships of a faction"""
	if npc_manager and faction_system:
		return npc_manager.get_ships_by_faction(faction_id)
	return []

func get_nearby_enemies(position: Vector2, faction_id: String, range: float) -> Array:
	"""Get nearby enemy ships"""
	if npc_manager and faction_system:
		var nearby = npc_manager.get_ships_in_range(position, range)
		var enemies = []

		for ship in nearby:
			var ship_faction = npc_manager.get_ship_faction(ship)
			if faction_system.are_hostile(faction_id, ship_faction):
				enemies.append(ship)

		return enemies
	return []

# ============================================================================
# STATISTICS & MONITORING
# ============================================================================

func get_orchestration_stats() -> Dictionary:
	"""Get orchestration statistics"""
	var stats = {
		"mode": OrchestrationMode.keys()[current_mode],
		"world_tick": world_tick_counter,
		"tick_rate": world_tick_rate,
		"loaded_subsystems": loaded_subsystems.size(),
		"subsystem_states": {}
	}

	# Subsystem stats
	for system_name in subsystem_states:
		stats["subsystem_states"][system_name] = LoadState.keys()[subsystem_states[system_name]]

	# Add subsystem-specific stats
	if npc_manager:
		stats["total_npcs"] = npc_manager.get_npc_count()

	if faction_system:
		stats["total_factions"] = faction_system.get_faction_count()

	if command_hierarchy:
		stats["total_fleets"] = command_hierarchy.get_fleet_count()

	return stats

func print_orchestration_report():
	"""Print detailed orchestration report"""
	print("\n╔════════════════════════════════════════════════════════╗")
	print("║         AUTOMATION ORCHESTRATOR REPORT                 ║")
	print("╠════════════════════════════════════════════════════════╣")

	var stats = get_orchestration_stats()

	print("║ Mode: %s" % stats["mode"])
	print("║ World Tick: %d" % stats["world_tick"])
	print("║ Tick Rate: %.1f ticks/sec" % stats["tick_rate"])
	print("║ Loaded Subsystems: %d/%d" % [stats["loaded_subsystems"], SUBSYSTEMS.size()])

	if stats.has("total_npcs"):
		print("║ Total NPCs: %d" % stats["total_npcs"])

	if stats.has("total_factions"):
		print("║ Total Factions: %d" % stats["total_factions"])

	if stats.has("total_fleets"):
		print("║ Total Fleets: %d" % stats["total_fleets"])

	print("╠════════════════════════════════════════════════════════╣")
	print("║ Subsystem Status:                                      ║")

	for system_name in subsystem_states:
		var state = LoadState.keys()[subsystem_states[system_name]]
		var icon = "✅" if state == "LOADED" else "❌"
		print("║   %s %s: %s" % [icon, system_name.pad_right(30), state])

	print("╚════════════════════════════════════════════════════════╝\n")

# ============================================================================
# SAVE/LOAD INTEGRATION
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export orchestrator state for saving"""
	var data = {
		"world_tick": world_tick_counter,
		"mode": current_mode,
		"subsystems": {}
	}

	# Save subsystem data
	for system_name in loaded_subsystems:
		var system = loaded_subsystems[system_name]
		if system.has_method("get_save_data"):
			data["subsystems"][system_name] = system.get_save_data()

	return data

func load_save_data(data: Dictionary):
	"""Import orchestrator state from save file"""
	world_tick_counter = data.get("world_tick", 0)
	current_mode = data.get("mode", OrchestrationMode.STANDARD)

	# Load subsystem data
	if data.has("subsystems"):
		for system_name in data["subsystems"]:
			if loaded_subsystems.has(system_name):
				var system = loaded_subsystems[system_name]
				if system.has_method("load_save_data"):
					system.load_save_data(data["subsystems"][system_name])

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_all_subsystems() -> Array:
	"""Get all loaded subsystem instances"""
	return loaded_subsystems.values()

func get_subsystem_names() -> Array:
	"""Get all subsystem names"""
	return SUBSYSTEMS.keys()

func is_orchestrator_ready() -> bool:
	"""Check if orchestrator is fully initialized"""
	# Check if core subsystems are loaded
	var core_systems = ["NPCManager", "FactionSystem", "CommandHierarchy"]

	for system_name in core_systems:
		if subsystem_states.get(system_name, LoadState.NOT_LOADED) != LoadState.LOADED:
			return false

	return true
