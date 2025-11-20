extends Node
class_name ScenarioManager

## Manages developer test scenarios
## Creates specific setups for testing different game features

# ============================================================================
# SCENARIO SETUP
# ============================================================================

static func load_scenario(main_scene: Node2D) -> void:
	"""Load and setup a developer scenario if one is selected"""
	var file = FileAccess.open("user://dev_scenario.json", FileAccess.READ)
	if not file:
		print("No dev scenario selected - loading normal game")
		return

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		print("Failed to parse scenario JSON")
		return

	var scenario = json.data
	if not scenario.get("enabled", false):
		return

	print("📋 Loading scenario: %s" % scenario.get("name", "Unknown"))
	var setup_id = scenario.get("setup", "")

	# Call appropriate setup function
	match setup_id:
		"basic_mining":
			setup_basic_mining(main_scene)
		"mining_queue":
			setup_mining_queue(main_scene)
		"cargo_management":
			setup_cargo_management(main_scene)
		"compression":
			setup_compression(main_scene)
		"stack_splitting":
			setup_stack_splitting(main_scene)
		"station_docking":
			setup_station_docking(main_scene)
		"map_system":
			setup_map_system(main_scene)
		"combat_basic":
			setup_combat_basic(main_scene)
		"performance":
			setup_performance(main_scene)
		"full_gameplay":
			setup_full_gameplay(main_scene)
		"multimonitor":
			setup_multimonitor(main_scene)
		"minimap":
			setup_minimap(main_scene)
		"ore_types":
			setup_ore_types(main_scene)
		"scanner_levels":
			setup_scanner_levels(main_scene)
		"autopilot":
			setup_autopilot(main_scene)
		"orbit":
			setup_orbit(main_scene)
		"module_fitting":
			setup_module_fitting(main_scene)
		"refinery":
			setup_refinery(main_scene)
		"empty_space":
			setup_empty_space(main_scene)
		"dense_field":
			setup_dense_field(main_scene)
		"perf_100_ships":
			setup_perf_ships(main_scene, 100)
		"perf_1000_ships":
			setup_perf_ships(main_scene, 1000)
		"perf_10000_ships":
			setup_perf_ships(main_scene, 10000)
		"perf_mixed":
			setup_perf_mixed(main_scene)
		_:
			print("Unknown scenario: %s" % setup_id)

	# Delete scenario file so it doesn't load again
	DirAccess.remove_absolute("user://dev_scenario.json")

# ============================================================================
# SCENARIO IMPLEMENTATIONS
# ============================================================================

static func setup_basic_mining(main: Node2D):
	"""3 asteroids nearby for basic mining testing"""
	print("Setting up: Basic Mining")
	var ore_container = main.get_node("OreContainer")
	var player = main.get_node("Player")

	# Clear existing ores
	for child in ore_container.get_children():
		child.queue_free()

	# Spawn 3 asteroids in a triangle formation
	var positions = [
		Vector2(300, 0),
		Vector2(-150, 250),
		Vector2(-150, -250)
	]

	var OreScene = load("res://scenes/Ore.tscn")
	for pos in positions:
		var ore = OreScene.instantiate()
		ore.global_position = player.global_position + pos
		ore_container.add_child(ore)

static func setup_mining_queue(main: Node2D):
	"""10 asteroids in a line for queue testing"""
	print("Setting up: Mining Queue")
	var ore_container = main.get_node("OreContainer")
	var player = main.get_node("Player")

	for child in ore_container.get_children():
		child.queue_free()

	var OreScene = load("res://scenes/Ore.tscn")
	for i in range(10):
		var ore = OreScene.instantiate()
		ore.global_position = player.global_position + Vector2(i * 200 + 300, 0)
		ore_container.add_child(ore)

static func setup_cargo_management(main: Node2D):
	"""Pre-fill cargo for drag & drop testing"""
	print("Setting up: Cargo Management")
	var player = main.get_node("Player")

	# Fill ore hold with various items
	player.add_to_cargo_hold(player.CargoType.ORE, "ore_veldspar", 5000)
	player.add_to_cargo_hold(player.CargoType.ORE, "ore_scordite", 3000)
	player.add_to_cargo_hold(player.CargoType.ORE, "ore_pyroxeres", 2000)

static func setup_compression(main: Node2D):
	"""Test compression modules"""
	print("Setting up: Compression Modules")
	var player = main.get_node("Player")

	# Install different compression levels
	player.install_compression_module(player.CargoType.ORE, player.CompressionLevel.STANDARD)
	player.install_compression_module(player.CargoType.MINERAL, player.CompressionLevel.HIGH)
	player.install_compression_module(player.CargoType.GENERAL, player.CompressionLevel.EXTREME)

	print("Compression installed - check effective capacities")

static func setup_stack_splitting(main: Node2D):
	"""Multiple full stacks for splitting test"""
	print("Setting up: Stack Splitting")
	var player = main.get_node("Player")

	# Add multiple stacks
	player.add_to_cargo_hold(player.CargoType.ORE, "ore_veldspar", 10000)
	player.add_to_cargo_hold(player.CargoType.ORE, "ore_scordite", 8000)
	player.add_to_cargo_hold(player.CargoType.GENERAL, "component_electronics", 100)
	player.add_to_cargo_hold(player.CargoType.GENERAL, "component_armor_plates", 50)

static func setup_station_docking(main: Node2D):
	"""4 stations of different types"""
	print("Setting up: Station Docking")
	# Note: Requires Station scene - will create placeholder
	print("⚠️ Station scene required - add manually")

static func setup_map_system(main: Node2D):
	"""Objects at various distances for map layer testing"""
	print("Setting up: Map System")
	var ore_container = main.get_node("OreContainer")
	var player = main.get_node("Player")

	for child in ore_container.get_children():
		child.queue_free()

	var OreScene = load("res://scenes/Ore.tscn")
	var distances = [500, 1000, 2000, 5000, 10000, 20000]

	for dist in distances:
		var angle = randf() * TAU
		var ore = OreScene.instantiate()
		ore.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * dist
		ore_container.add_child(ore)

static func setup_combat_basic(main: Node2D):
	"""3 hostile NPC ships"""
	print("Setting up: Basic Combat")
	print("⚠️ Combat system not fully implemented yet")

static func setup_performance(main: Node2D):
	"""100 asteroids, 20 ships"""
	print("Setting up: Performance Test")
	var ore_container = main.get_node("OreContainer")
	var player = main.get_node("Player")

	for child in ore_container.get_children():
		child.queue_free()

	var OreScene = load("res://scenes/Ore.tscn")
	for i in range(100):
		var ore = OreScene.instantiate()
		var angle = randf() * TAU
		var distance = randf_range(500, 5000)
		ore.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * distance
		ore_container.add_child(ore)

static func setup_full_gameplay(main: Node2D):
	"""Complete gameplay loop setup"""
	print("Setting up: Full Gameplay")
	setup_basic_mining(main)
	# Add station when available

static func setup_multimonitor(main: Node2D):
	"""Test multi-monitor camera offset"""
	print("Setting up: Multi-Monitor Test")
	print("Use Numpad 1-9 to test camera offsets")
	setup_basic_mining(main)

static func setup_minimap(main: Node2D):
	"""Many objects for minimap"""
	print("Setting up: Minimap Test")
	var ore_container = main.get_node("OreContainer")
	var player = main.get_node("Player")

	for child in ore_container.get_children():
		child.queue_free()

	var OreScene = load("res://scenes/Ore.tscn")
	for i in range(30):
		var ore = OreScene.instantiate()
		var angle = randf() * TAU
		var distance = randf_range(200, 2000)
		ore.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * distance
		ore_container.add_child(ore)

static func setup_ore_types(main: Node2D):
	"""One of each ore type"""
	print("Setting up: All Ore Types")
	setup_basic_mining(main)

static func setup_scanner_levels(main: Node2D):
	"""Test different scanner levels"""
	print("Setting up: Scanner Levels")
	setup_basic_mining(main)

static func setup_autopilot(main: Node2D):
	"""Distant targets for autopilot"""
	print("Setting up: Autopilot System")
	var ore_container = main.get_node("OreContainer")
	var player = main.get_node("Player")

	for child in ore_container.get_children():
		child.queue_free()

	var OreScene = load("res://scenes/Ore.tscn")
	for i in range(5):
		var ore = OreScene.instantiate()
		ore.global_position = player.global_position + Vector2(i * 3000 + 5000, 0)
		ore_container.add_child(ore)

static func setup_orbit(main: Node2D):
	"""Large targets for orbit testing"""
	print("Setting up: Orbit Mechanics")
	setup_basic_mining(main)

static func setup_module_fitting(main: Node2D):
	"""Station module testing"""
	print("Setting up: Module Fitting")
	print("⚠️ Station required")

static func setup_refinery(main: Node2D):
	"""Refinery efficiency comparison"""
	print("Setting up: Refinery Test")
	setup_cargo_management(main)

static func setup_empty_space(main: Node2D):
	"""No objects - empty space"""
	print("Setting up: Empty Space")
	var ore_container = main.get_node("OreContainer")
	for child in ore_container.get_children():
		child.queue_free()

static func setup_dense_field(main: Node2D):
	"""50+ asteroids clustered"""
	print("Setting up: Dense Asteroid Field")
	var ore_container = main.get_node("OreContainer")
	var player = main.get_node("Player")

	for child in ore_container.get_children():
		child.queue_free()

	var OreScene = load("res://scenes/Ore.tscn")
	for i in range(50):
		var ore = OreScene.instantiate()
		var angle = randf() * TAU
		var distance = randf_range(100, 800)  # Close clustering
		ore.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * distance
		ore_container.add_child(ore)

static func setup_perf_ships(main: Node2D, ship_count: int):
	"""Performance test with many ships"""
	print("Setting up: Performance Test - %d ships" % ship_count)
	var player = main.get_node("Player")

	# Get or create ship container
	var ship_container = main.get_node_or_null("ShipContainer")
	if not ship_container:
		ship_container = Node2D.new()
		ship_container.name = "ShipContainer"
		main.add_child(ship_container)

	# Clear existing ships
	for child in ship_container.get_children():
		child.queue_free()

	var NPCShipScene = load("res://scenes/NPCShip.tscn")
	if not NPCShipScene:
		print("❌ NPCShip scene not found")
		return

	print("Spawning %d ships..." % ship_count)
	for i in range(ship_count):
		var ship = NPCShipScene.instantiate()
		var angle = randf() * TAU
		var distance = randf_range(500, 10000)
		ship.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * distance

		# Randomize ship color for variety
		ship.modulate = Color(randf(), randf(), randf())

		ship_container.add_child(ship)

		# Progress feedback every 100 ships
		if i % 100 == 0 and i > 0:
			print("  Spawned %d/%d ships..." % [i, ship_count])

	print("✅ Spawned %d ships" % ship_count)

static func setup_perf_mixed(main: Node2D):
	"""1000 ships + 500 asteroids"""
	print("Setting up: Mixed Performance Test")
	setup_perf_ships(main, 1000)

	# Add asteroids
	var ore_container = main.get_node("OreContainer")
	var player = main.get_node("Player")

	for child in ore_container.get_children():
		child.queue_free()

	var OreScene = load("res://scenes/Ore.tscn")
	print("Adding 500 asteroids...")
	for i in range(500):
		var ore = OreScene.instantiate()
		var angle = randf() * TAU
		var distance = randf_range(500, 10000)
		ore.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * distance
		ore_container.add_child(ore)

	print("✅ Mixed performance test ready")
