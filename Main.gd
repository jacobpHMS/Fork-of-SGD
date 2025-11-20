extends Node2D

# Preload scenes
const OreScene = preload("res://scenes/Ore.tscn")

# References
@onready var ore_container = $OreContainer
@onready var camera = $Camera2D
@onready var player = $Player
@onready var object_list = $CanvasLayer/UI/RightPanel/VBox/ObjectList
@onready var details_label = $CanvasLayer/UI/RightPanel/VBox/DetailsLabel

# Filter buttons
@onready var filter_all = $CanvasLayer/UI/RightPanel/VBox/FilterButtons/AllBtn
@onready var filter_ships = $CanvasLayer/UI/RightPanel/VBox/FilterButtons/ShipsBtn
@onready var filter_ores = $CanvasLayer/UI/RightPanel/VBox/FilterButtons/OresBtn
@onready var filter_stations = $CanvasLayer/UI/RightPanel/VBox/FilterButtons/StationsBtn
@onready var filter_enemies = $CanvasLayer/UI/RightPanel/VBox/FilterButtons/EnemiesBtn

# Mining UI
@onready var miner1_progress = $CanvasLayer/UI/BottomPanel/VBox/MinerPanel/Miner1Container/Miner1Progress
@onready var miner2_progress = $CanvasLayer/UI/BottomPanel/VBox/MinerPanel/Miner2Container/Miner2Progress

# Camera UI
@onready var camera_button = $CanvasLayer/UI/CameraButton

# Permanent Info Panel
@onready var permanent_info_panel = $CanvasLayer/UI/PermanentInfoPanel

# Map systems
var minimap: Minimap = null
var map_system: MapSystem = null

# Debug system
var debug_overlay: DebugOverlay = null

# Zoom settings
var zoom_level = 0.5
var zoom_min = 0.2
var zoom_max = 2.0
var zoom_speed = 0.1

# Camera settings
var camera_free_mode = false
var camera_move_speed = 500.0
var camera_follow_offset: Vector2 = Vector2.ZERO  # Offset from player (for multi-monitor)

# Mouse pan settings
var is_panning = false
var pan_start_mouse_pos = Vector2.ZERO
var pan_start_camera_pos = Vector2.ZERO

# Spawning settings
var spawn_radius = 1000.0
var ore_count = 5

# Current filter
var current_filter = "all"

# Context menu
var context_menu: PopupMenu = null
var context_menu_target: Node2D = null

# Performance: Object list update timer
var object_list_update_timer: float = 0.0
const OBJECT_LIST_UPDATE_INTERVAL: float = 1.0  # Update every 1 second instead of every frame

func _ready():
	# Add to group for RadialMenu to find
	add_to_group("main")

	# Load developer scenario if selected
	ScenarioManager.load_scenario(self)

	# Spawn ores randomly (only if no scenario loaded)
	if not _scenario_was_loaded():
		spawn_ores()

	# Connect filter buttons
	filter_all.pressed.connect(_on_filter_pressed.bind("all"))
	filter_ships.pressed.connect(_on_filter_pressed.bind("ships"))
	filter_ores.pressed.connect(_on_filter_pressed.bind("ores"))
	filter_stations.pressed.connect(_on_filter_pressed.bind("stations"))
	filter_enemies.pressed.connect(_on_filter_pressed.bind("enemies"))

	# Connect camera button
	camera_button.pressed.connect(toggle_camera_mode)

	# Connect object list selection
	object_list.item_selected.connect(_on_object_selected)

	# Setup context menu for object list
	setup_context_menu()

	# Initialize Permanent Info Panel with player reference
	if permanent_info_panel and player:
		permanent_info_panel.set_player_node(player)

	# Setup map systems
	setup_map_systems()

	# Setup debug overlay
	setup_debug_overlay()

	# Initial update
	update_object_list()

func _process(delta):
	# Camera control
	if camera_free_mode:
		# Free camera movement with WASD
		var camera_velocity = Vector2.ZERO

		if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
			camera_velocity.y -= 1
		if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
			camera_velocity.y += 1
		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
			camera_velocity.x -= 1
		if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
			camera_velocity.x += 1

		if camera_velocity.length() > 0:
			camera_velocity = camera_velocity.normalized()
			camera.global_position += camera_velocity * camera_move_speed * delta / zoom_level

	else:
		# Camera follows player (with offset for multi-monitor)
		if player:
			camera.global_position = player.global_position + camera_follow_offset

	# Update mining progress bars
	if player:
		if player.miner_1_active or player.miner_2_active:
			miner1_progress.value = player.mining_cycle_progress
			miner2_progress.value = player.mining_cycle_progress
		else:
			miner1_progress.value = 0.0
			miner2_progress.value = 0.0

	# PERFORMANCE FIX: Update object list with timer instead of every frame
	object_list_update_timer += delta
	if object_list_update_timer >= OBJECT_LIST_UPDATE_INTERVAL:
		object_list_update_timer = 0.0
		update_object_list()

func _input(event):
	# Handle zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_out()
		# Handle middle mouse button for panning
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				# Automatically switch to free camera mode when panning starts
				if not camera_free_mode:
					camera_free_mode = true
					if camera_button:
						camera_button.text = "📷 Follow Ship (F)"
					print("Camera mode: Free (Pan started)")

				# Start panning
				is_panning = true
				pan_start_mouse_pos = get_viewport().get_mouse_position()
				pan_start_camera_pos = camera.global_position
			else:
				# Stop panning
				is_panning = false

	# Handle mouse motion for panning
	elif event is InputEventMouseMotion:
		if is_panning:
			# Calculate mouse delta in world space
			var current_mouse_pos = get_viewport().get_mouse_position()
			var mouse_delta = (pan_start_mouse_pos - current_mouse_pos) / zoom_level

			# Update camera position
			camera.global_position = pan_start_camera_pos + mouse_delta

	# Handle camera mode toggle
	elif event is InputEventKey:
		if event.pressed and not event.echo:
			if event.keycode == KEY_HOME or event.keycode == KEY_F:
				toggle_camera_mode()
			elif event.keycode == KEY_M:
				toggle_map_system()
			elif event.keycode == KEY_TAB:
				toggle_minimap()
			elif event.keycode == KEY_O:
				toggle_tactical_overview()
			# Camera offset presets (for multi-monitor)
			elif event.keycode == KEY_KP_5:  # Numpad 5 - Center
				set_camera_offset(Vector2.ZERO)
			elif event.keycode == KEY_KP_4:  # Numpad 4 - Left
				set_camera_offset(Vector2(-500, 0))
			elif event.keycode == KEY_KP_6:  # Numpad 6 - Right
				set_camera_offset(Vector2(500, 0))
			elif event.keycode == KEY_KP_8:  # Numpad 8 - Top
				set_camera_offset(Vector2(0, -300))
			elif event.keycode == KEY_KP_2:  # Numpad 2 - Bottom
				set_camera_offset(Vector2(0, 300))
			elif event.keycode == KEY_KP_7:  # Numpad 7 - Top-Left
				set_camera_offset(Vector2(-500, -300))
			elif event.keycode == KEY_KP_9:  # Numpad 9 - Top-Right
				set_camera_offset(Vector2(500, -300))
			elif event.keycode == KEY_KP_1:  # Numpad 1 - Bottom-Left
				set_camera_offset(Vector2(-500, 300))
			elif event.keycode == KEY_KP_3:  # Numpad 3 - Bottom-Right
				set_camera_offset(Vector2(500, 300))
			# Debug overlay toggle
			elif event.keycode == KEY_F12:
				if event.shift_pressed:
					toggle_debug_console()
				else:
					toggle_debug_overlay()

func zoom_in():
	zoom_level = min(zoom_level + zoom_speed, zoom_max)
	camera.zoom = Vector2(zoom_level, zoom_level)

func zoom_out():
	zoom_level = max(zoom_level - zoom_speed, zoom_min)
	camera.zoom = Vector2(zoom_level, zoom_level)

func toggle_camera_mode():
	"""Toggle between free camera and follow player mode"""
	camera_free_mode = !camera_free_mode

	if not camera_free_mode:
		# Stop panning when entering follow mode
		is_panning = false

		if player:
			# Return camera to player when exiting free mode
			camera.global_position = player.global_position

	# Update button text
	if camera_button:
		camera_button.text = "📷 Follow Ship (F)" if camera_free_mode else "📷 Free Camera (F)"

	print("Camera mode: ", "Free" if camera_free_mode else "Follow Player")

func spawn_ores():
	for i in range(ore_count):
		var ore = OreScene.instantiate()

		# Random position around origin
		var angle = randf() * TAU
		var distance = randf_range(300, spawn_radius)
		var pos = Vector2(cos(angle), sin(angle)) * distance

		ore.global_position = pos
		ore_container.add_child(ore)

func update_object_list():
	object_list.clear()

	# Add player ship
	if current_filter == "all" or current_filter == "ships":
		if player:
			var distance = 0  # Player is reference
			object_list.add_item("⬤ Your Ship (%.0fm)" % distance)
			object_list.set_item_metadata(object_list.get_item_count() - 1, {"type": "ship", "node": player})

	# Add ores
	if current_filter == "all" or current_filter == "ores":
		for ore in ore_container.get_children():
			if is_instance_valid(ore) and player:
				var distance = DistanceHelper.get_distance_to_bounds(player, ore)
				var ore_name = ore.ore_name if ore.has_method("get_ore_name") else "Unknown Ore"
				object_list.add_item("◆ %s (%.0fm)" % [ore_name, distance])
				object_list.set_item_metadata(object_list.get_item_count() - 1, {"type": "ore", "node": ore})

func _on_filter_pressed(filter_type: String):
	current_filter = filter_type

	# Update button states
	filter_all.button_pressed = (filter_type == "all")
	filter_ships.button_pressed = (filter_type == "ships")
	filter_ores.button_pressed = (filter_type == "ores")
	filter_stations.button_pressed = (filter_type == "stations")
	filter_enemies.button_pressed = (filter_type == "enemies")

	update_object_list()

func _on_object_selected(index: int):
	var metadata = object_list.get_item_metadata(index)
	if metadata and metadata.has("node"):
		var node = metadata["node"]
		if is_instance_valid(node):
			show_object_details(node, metadata["type"])

func show_object_details(node: Node, obj_type: String):
	var details = ""

	match obj_type:
		"ship":
			if node.has_method("get_ship_info"):
				var info = node.get_ship_info()
				details = "=== SHIP INFO ===\n"
				details += "Mass: %.0f kg\n" % info.mass
				details += "Speed: %.1f m/s\n" % info.velocity.length()
				details += "Cargo: %.1f / %.0f m³\n" % [info.cargo_used, info.cargo_capacity]
		"ore":
			if node.has_method("get_ore_info"):
				var info = node.get_ore_info()
				details = "=== ORE INFO ===\n"
				details += "Type: %s\n" % info.name
				details += "Quality: %s\n" % info.quality
				details += "Amount: %.0f units\n" % info.amount
				details += "Distance: %.0f m\n" % DistanceHelper.get_distance_to_bounds(player, node)

	details_label.text = details if details != "" else "No details available"
# ============================================================================
# CONTEXT MENU SYSTEM (from old branch)
# ============================================================================

func setup_context_menu():
	"""Setup right-click context menu for tactical overview"""
	context_menu = PopupMenu.new()
	context_menu.name = "ContextMenu"

	# Add menu items
	context_menu.add_item("🎯 Anvisieren (Target)", 0)
	context_menu.add_item("🔍 Scannen", 1)
	context_menu.add_separator()
	context_menu.add_item("✈️ Hinfliegen", 2)
	context_menu.add_item("🔄 Orbit", 3)
	context_menu.add_item("🚢 Andocken", 8)
	context_menu.add_separator()
	context_menu.add_item("📋 Zur Mining-Queue", 5)
	context_menu.add_item("❌ Aus Queue entfernen", 6)
	context_menu.add_item("🗑️ Queue leeren", 7)
	context_menu.add_separator()
	context_menu.add_item("ℹ️ Details", 4)

	# Connect menu item selection
	context_menu.id_pressed.connect(_on_context_menu_selected)

	# Add to UI
	$CanvasLayer/UI.add_child(context_menu)

	# Connect right-click to object list
	object_list.gui_input.connect(_on_object_list_input)

func _on_object_list_input(event: InputEvent):
	"""Handle right-click on object list"""
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			# Get clicked item
			var clicked_index = object_list.get_item_at_position(event.position, true)
			if clicked_index >= 0:
				# Select the item
				object_list.select(clicked_index)

				# Get metadata
				var metadata = object_list.get_item_metadata(clicked_index)
				if metadata and metadata.has("node"):
					context_menu_target = metadata["node"]

					# Show context menu at mouse position
					var global_mouse_pos = object_list.get_global_mouse_position()
					context_menu.popup(Rect2(global_mouse_pos, Vector2(200, 0)))

func _on_context_menu_selected(id: int):
	"""Handle context menu selection"""
	if not context_menu_target or not is_instance_valid(context_menu_target):
		print("No valid target selected")
		return

	match id:
		0:  # Anvisieren (Target)
			if player and player.has_method("target_object"):
				player.target_object(context_menu_target)
				print("Targeting: ", context_menu_target.name)
		1:  # Scannen
			scan_object(context_menu_target)
		2:  # Hinfliegen
			fly_to_object(context_menu_target)
		3:  # Orbit
			orbit_object(context_menu_target)
		4:  # Details
			# Already shown via selection
			pass
		5:  # Zur Mining-Queue
			add_to_mining_queue(context_menu_target)
		6:  # Aus Queue entfernen
			remove_from_mining_queue(context_menu_target)
		7:  # Queue leeren
			clear_mining_queue()
		8:  # Andocken
			dock_at_object(context_menu_target)

func scan_object(obj: Node2D):
	"""Scan the targeted object"""
	if not player:
		return

	# Check if player has targeted this object
	if player.has_method("get_targeted_object"):
		var targeted = player.get_targeted_object()
		if targeted != obj:
			print("Object must be targeted before scanning")
			if player.has_method("target_object"):
				player.target_object(obj)  # Auto-target

	# Perform scan
	if obj.has_method("get_quality_distribution"):
		var distribution = obj.get_quality_distribution()
		print("Scan complete: ", obj.name)

		# Get player's scanner level
		var scanner_level = 1  # Default
		if player and player.ship_data.has("scanner_level"):
			scanner_level = player.ship_data["scanner_level"]

		# Connect ore_scanned signal if available
		if obj.has_signal("ore_scanned") and not obj.ore_scanned.is_connected(_on_ore_scanned):
			obj.ore_scanned.connect(_on_ore_scanned)

		# Mark as scanned
		if obj.has_method("mark_as_scanned"):
			obj.mark_as_scanned(distribution, scanner_level)
		else:
			# Add metadata for scanned objects
			obj.set_meta("scanned", true)
			obj.set_meta("scan_data", distribution)
			obj.set_meta("scanner_level", scanner_level)

		print("Object scanned successfully with Mk%d scanner" % scanner_level)
	else:
		print("Object cannot be scanned")

func fly_to_object(obj: Node2D):
	"""Fly to the object"""
	if player and player.has_method("start_autopilot_to_position"):
		player.start_autopilot_to_position(obj.global_position)
		print("Flying to: ", obj.name)

func orbit_object(obj: Node2D):
	"""Orbit around the object"""
	if player and player.has_method("start_orbit"):
		player.start_orbit(obj)
		print("Orbiting: ", obj.name)

func add_to_mining_queue(obj: Node2D):
	"""Add object to mining queue"""
	if player and player.has_method("add_to_mining_queue"):
		if player.add_to_mining_queue(obj):
			print("✅ Added to mining queue: ", obj.name)
		else:
			print("❌ Could not add to queue: ", obj.name)

func remove_from_mining_queue(obj: Node2D):
	"""Remove object from mining queue"""
	if player and player.has_method("remove_from_mining_queue"):
		if player.remove_from_mining_queue(obj):
			print("✅ Removed from mining queue: ", obj.name)
		else:
			print("❌ Not in queue: ", obj.name)

func clear_mining_queue():
	"""Clear entire mining queue"""
	if player and player.has_method("clear_mining_queue"):
		player.clear_mining_queue()
		print("✅ Mining queue cleared")

func dock_at_object(obj: Node2D):
	"""Dock at a station"""
	if not player:
		return

	# Check if object is a station
	if not obj.has_method("dock_ship"):
		print("❌ Cannot dock: Not a station")
		return

	# Try to dock
	if player.has_method("dock_at_station"):
		if player.dock_at_station(obj):
			print("✅ Docked at station: ", obj.name)
		else:
			print("❌ Docking failed - check distance and station capacity")
	else:
		print("❌ Player ship does not support docking")

func _on_ore_scanned(ore_name: String, scanner_level: int):
	"""Called when ore is scanned - forward to PermanentInfoPanel"""
	if permanent_info_panel and permanent_info_panel.has_method("_on_ore_scanned_event"):
		permanent_info_panel._on_ore_scanned_event(ore_name, scanner_level)

# ============================================================================
# MAP SYSTEM
# ============================================================================

func setup_map_systems():
	"""Initialize minimap and map system"""
	var ui = $CanvasLayer/UI

	# Create Minimap (top-right corner)
	minimap = Minimap.new()
	minimap.position = Vector2(get_viewport().size.x - 360, 60)
	minimap.set_player_node(player)
	ui.add_child(minimap)

	# Create MapSystem (full-screen window, initially hidden)
	map_system = MapSystem.new()
	map_system.position = Vector2(100, 50)
	map_system.custom_minimum_size = Vector2(1200, 800)
	map_system.set_player_node(player)
	map_system.hide()
	ui.add_child(map_system)

	print("✅ Map systems initialized (M=Map, Tab=Minimap)")

func toggle_map_system():
	"""Toggle map system window (M key)"""
	if not map_system:
		return

	if map_system.visible:
		map_system.close_map()
		print("Map closed")
	else:
		map_system.open_map()
		print("Map opened (Scroll=Zoom, Middle Mouse=Pan, L=Legend)")

func toggle_minimap():
	"""Toggle minimap visibility (Tab key)"""
	if not minimap:
		return

	minimap.visible = !minimap.visible
	print("Minimap %s" % ("visible" if minimap.visible else "hidden"))

func toggle_tactical_overview():
	"""Toggle tactical overview panel (O key)"""
	var tactical_panel = $CanvasLayer/UI/RightPanel
	if tactical_panel:
		tactical_panel.visible = !tactical_panel.visible
		print("Tactical Overview %s" % ("visible" if tactical_panel.visible else "hidden"))

func set_camera_offset(offset: Vector2):
	"""Set camera offset from player (for multi-monitor setups)"""
	camera_follow_offset = offset
	if offset == Vector2.ZERO:
		print("📷 Camera centered on player")
	else:
		print("📷 Camera offset: (%.0f, %.0f)" % [offset.x, offset.y])

func _scenario_was_loaded() -> bool:
	"""Check if a dev scenario was loaded (to skip default spawn)"""
	# If ore_container has children, a scenario was loaded
	return ore_container.get_child_count() > 0

# ============================================================================
# DEBUG SYSTEM
# ============================================================================

func setup_debug_overlay():
	"""Initialize expert debug overlay"""
	debug_overlay = DebugOverlay.new()
	debug_overlay.set_player(player)
	debug_overlay.set_main_scene(self)
	add_child(debug_overlay)
	print("✅ Debug overlay initialized (F12 to toggle)")

func toggle_debug_overlay():
	"""Toggle debug overlay (F12 key)"""
	if debug_overlay:
		debug_overlay.toggle_mode()

func toggle_debug_console():
	"""Toggle debug console (Shift+F12 key)"""
	if debug_overlay:
		debug_overlay.toggle_console()
