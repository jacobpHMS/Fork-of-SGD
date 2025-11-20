extends CanvasLayer
class_name DebugOverlay

## Expert-level debug overlay system (F12 to toggle)
## Displays comprehensive game diagnostics and performance metrics

# ============================================================================
# DEBUG MODES
# ============================================================================

enum DebugMode {
	OFF,        # No debug info
	MINIMAL,    # FPS + basic info
	NORMAL,     # Common diagnostics
	EXPERT,     # All information
	PROFILER    # Performance profiling
}

# ============================================================================
# STATE
# ============================================================================

var current_mode: DebugMode = DebugMode.OFF
var player_node: Node2D = null
var main_scene: Node2D = null

# Performance tracking
var fps_history: Array[float] = []
var frame_time_history: Array[float] = []
const HISTORY_SIZE = 60  # 1 second at 60 FPS

var last_frame_time: int = 0
var frame_count: int = 0
var fps_update_timer: float = 0.0

# UI Elements
var debug_panel: PanelContainer
var debug_label: RichTextLabel
var mode_label: Label

# Console
var console_panel: PanelContainer
var console_output: RichTextLabel
var console_input: LineEdit
var console_visible: bool = false

# ============================================================================
# INITIALIZATION
# ============================================================================

func _ready():
	layer = 100  # Always on top
	_setup_ui()
	_setup_console()

func _setup_ui():
	"""Setup debug overlay UI"""
	# Main panel (top-left corner)
	debug_panel = PanelContainer.new()
	debug_panel.position = Vector2(10, 10)
	debug_panel.custom_minimum_size = Vector2(500, 400)
	debug_panel.modulate = Color(1, 1, 1, 0.9)
	add_child(debug_panel)

	var vbox = VBoxContainer.new()
	debug_panel.add_child(vbox)

	# Mode indicator
	mode_label = Label.new()
	mode_label.text = "DEBUG: OFF"
	mode_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mode_label.add_theme_font_size_override("font_size", 16)
	mode_label.add_theme_color_override("font_color", Color(1, 1, 0))
	vbox.add_child(mode_label)

	vbox.add_child(HSeparator.new())

	# Debug info display
	debug_label = RichTextLabel.new()
	debug_label.bbcode_enabled = true
	debug_label.fit_content = true
	debug_label.scroll_active = false
	debug_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	debug_label.add_theme_font_size_override("normal_font_size", 12)
	vbox.add_child(debug_label)

	# Start hidden
	debug_panel.hide()

func _setup_console():
	"""Setup debug console (Shift+F12)"""
	# Console panel (bottom half of screen)
	console_panel = PanelContainer.new()
	console_panel.position = Vector2(10, get_viewport().size.y - 410)
	console_panel.custom_minimum_size = Vector2(800, 400)
	console_panel.modulate = Color(1, 1, 1, 0.95)
	add_child(console_panel)

	var vbox = VBoxContainer.new()
	console_panel.add_child(vbox)

	# Title
	var title = Label.new()
	title.text = "=== DEBUG CONSOLE (type 'help' for commands) ==="
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 14)
	title.add_theme_color_override("font_color", Color(1, 0.5, 0))
	vbox.add_child(title)

	vbox.add_child(HSeparator.new())

	# Output area (scrollable)
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(scroll)

	console_output = RichTextLabel.new()
	console_output.bbcode_enabled = true
	console_output.scroll_following = true
	console_output.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	console_output.size_flags_vertical = Control.SIZE_EXPAND_FILL
	console_output.add_theme_font_size_override("normal_font_size", 12)
	scroll.add_child(console_output)

	# Initial text
	console_output.text = "[color=lime]Debug Console Ready[/color]\n"
	console_output.text += "[color=gray]Type 'help' to see available commands[/color]\n"
	console_output.text += "[color=gray]Examples: god_mode, spawn_asteroids 10, teleport 0 0[/color]\n\n"

	# Input area
	var input_container = HBoxContainer.new()
	vbox.add_child(input_container)

	var prompt_label = Label.new()
	prompt_label.text = ">"
	prompt_label.add_theme_color_override("font_color", Color(0, 1, 0))
	input_container.add_child(prompt_label)

	console_input = LineEdit.new()
	console_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	console_input.placeholder_text = "Enter command..."
	console_input.text_submitted.connect(_on_console_command)
	input_container.add_child(console_input)

	var submit_btn = Button.new()
	submit_btn.text = "Execute"
	submit_btn.pressed.connect(func(): _on_console_command(console_input.text))
	input_container.add_child(submit_btn)

	# Start hidden
	console_panel.hide()

# ============================================================================
# UPDATE
# ============================================================================

func _process(delta):
	# Track performance
	_update_performance_metrics(delta)

	# Update display if active
	if current_mode != DebugMode.OFF:
		_update_debug_display()

func _update_performance_metrics(delta):
	"""Track FPS and frame time"""
	fps_update_timer += delta
	frame_count += 1

	var current_time = Time.get_ticks_msec()
	if last_frame_time > 0:
		var frame_time = current_time - last_frame_time
		frame_time_history.append(frame_time)
		if frame_time_history.size() > HISTORY_SIZE:
			frame_time_history.pop_front()

	last_frame_time = current_time

	# Update FPS history
	if fps_update_timer >= 0.1:  # Update every 100ms
		var current_fps = Engine.get_frames_per_second()
		fps_history.append(current_fps)
		if fps_history.size() > HISTORY_SIZE:
			fps_history.pop_front()
		fps_update_timer = 0.0

func _update_debug_display():
	"""Update debug information display"""
	var text = ""

	match current_mode:
		DebugMode.MINIMAL:
			text = _get_minimal_info()
		DebugMode.NORMAL:
			text = _get_normal_info()
		DebugMode.EXPERT:
			text = _get_expert_info()
		DebugMode.PROFILER:
			text = _get_profiler_info()

	debug_label.text = text

# ============================================================================
# DEBUG INFO GENERATORS
# ============================================================================

func _get_minimal_info() -> String:
	"""Minimal debug info - FPS + basics"""
	var fps = Engine.get_frames_per_second()
	var avg_fps = _get_average_fps()

	var text = "[color=yellow]═══ MINIMAL DEBUG ═══[/color]\n\n"
	text += "[color=lime]FPS:[/color] %d (avg: %.1f)\n" % [fps, avg_fps]
	text += "[color=lime]Frame Time:[/color] %.2f ms\n" % _get_average_frame_time()

	if player_node:
		text += "\n[color=cyan]Player Position:[/color] (%.0f, %.0f)\n" % [player_node.global_position.x, player_node.global_position.y]
		if "velocity" in player_node:
			text += "[color=cyan]Velocity:[/color] %.1f m/s\n" % player_node.velocity.length()

	return text

func _get_normal_info() -> String:
	"""Normal debug info - Common diagnostics"""
	var text = "[color=yellow]═══════════ DEBUG INFO ═══════════[/color]\n\n"

	# Performance
	text += "[color=orange]▸ PERFORMANCE[/color]\n"
	text += "  FPS: %d (avg: %.1f, min: %.0f, max: %.0f)\n" % [
		Engine.get_frames_per_second(),
		_get_average_fps(),
		_get_min_fps(),
		_get_max_fps()
	]
	text += "  Frame Time: %.2f ms (avg: %.2f ms)\n" % [
		_get_current_frame_time(),
		_get_average_frame_time()
	]
	text += "  Memory: %.2f MB\n" % (Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0)
	text += "  Objects: %d\n" % Performance.get_monitor(Performance.OBJECT_COUNT)
	text += "  Nodes: %d\n" % Performance.get_monitor(Performance.OBJECT_NODE_COUNT)

	# Player info
	if player_node:
		text += "\n[color=cyan]▸ PLAYER[/color]\n"
		text += "  Position: (%.0f, %.0f)\n" % [player_node.global_position.x, player_node.global_position.y]
		if "velocity" in player_node:
			var vel = player_node.velocity
			text += "  Velocity: %.1f m/s (%.1f, %.1f)\n" % [vel.length(), vel.x, vel.y]
		if player_node.has_method("get_ship_info"):
			var info = player_node.get_ship_info()
			text += "  Mass: %.0f kg\n" % info.mass
			text += "  Cargo: %.1f / %.0f m³\n" % [info.cargo_used, info.cargo_capacity]

	# Scene info
	if main_scene:
		text += "\n[color=lime]▸ SCENE[/color]\n"
		var ore_container = main_scene.get_node_or_null("OreContainer")
		if ore_container:
			text += "  Asteroids: %d\n" % ore_container.get_child_count()

		var ship_container = main_scene.get_node_or_null("ShipContainer")
		if ship_container:
			text += "  Ships: %d\n" % ship_container.get_child_count()

	# Camera info
	text += "\n[color=magenta]▸ CAMERA[/color]\n"
	if main_scene and "camera" in main_scene:
		var camera = main_scene.camera
		text += "  Position: (%.0f, %.0f)\n" % [camera.global_position.x, camera.global_position.y]
		text += "  Zoom: %.2f\n" % main_scene.zoom_level
		text += "  Free Mode: %s\n" % ("Yes" if main_scene.camera_free_mode else "No")
		text += "  Offset: (%.0f, %.0f)\n" % [main_scene.camera_follow_offset.x, main_scene.camera_follow_offset.y]

	return text

func _get_expert_info() -> String:
	"""Expert debug info - Everything"""
	var text = "[color=yellow]═══════════════ EXPERT DEBUG ═══════════════[/color]\n\n"

	# Performance (detailed)
	text += "[color=orange]▸ PERFORMANCE METRICS[/color]\n"
	text += "  FPS: %d | Avg: %.1f | Min: %.0f | Max: %.0f\n" % [
		Engine.get_frames_per_second(),
		_get_average_fps(),
		_get_min_fps(),
		_get_max_fps()
	]
	text += "  Frame Time: %.2f ms (avg: %.2f, min: %.2f, max: %.2f)\n" % [
		_get_current_frame_time(),
		_get_average_frame_time(),
		_get_min_frame_time(),
		_get_max_frame_time()
	]
	text += "  Physics: %.2f fps | %.2f ms\n" % [
		Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS),
		Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000
	]
	text += "  Process: %.2f ms\n" % (Performance.get_monitor(Performance.TIME_PROCESS) * 1000)

	# Memory
	text += "\n[color=red]▸ MEMORY[/color]\n"
	text += "  Static: %.2f MB\n" % (Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0)
	text += "  Static Max: %.2f MB\n" % (Performance.get_monitor(Performance.MEMORY_STATIC_MAX) / 1048576.0)
	text += "  Message Queue: %.2f MB\n" % (Performance.get_monitor(Performance.MEMORY_MESSAGE_BUFFER_MAX) / 1048576.0)

	# Objects
	text += "\n[color=lime]▸ OBJECT COUNTS[/color]\n"
	text += "  Total Objects: %d\n" % Performance.get_monitor(Performance.OBJECT_COUNT)
	text += "  Resources: %d\n" % Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)
	text += "  Nodes: %d\n" % Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
	text += "  Orphan Nodes: %d\n" % Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)

	# Player (detailed)
	if player_node:
		text += "\n[color=cyan]▸ PLAYER STATE[/color]\n"
		text += "  Position: (%.2f, %.2f)\n" % [player_node.global_position.x, player_node.global_position.y]
		text += "  Rotation: %.2f rad (%.1f°)\n" % [player_node.rotation, rad_to_deg(player_node.rotation)]

		if "velocity" in player_node:
			var vel = player_node.velocity
			text += "  Velocity: %.2f m/s\n" % vel.length()
			text += "    X: %.2f | Y: %.2f\n" % [vel.x, vel.y]

		if player_node.has_method("get_ship_info"):
			var info = player_node.get_ship_info()
			text += "  Mass: %.0f kg\n" % info.mass
			text += "  Cargo: %.1f / %.0f m³ (%.1f%%)\n" % [
				info.cargo_used,
				info.cargo_capacity,
				(info.cargo_used / info.cargo_capacity) * 100 if info.cargo_capacity > 0 else 0
			]

		# Mining status
		if "miner_1_active" in player_node:
			text += "\n[color=yellow]▸ MINING[/color]\n"
			text += "  Miner 1: %s\n" % ("Active" if player_node.miner_1_active else "Inactive")
			text += "  Miner 2: %s\n" % ("Active" if player_node.miner_2_active else "Inactive")
			if "mining_cycle_progress" in player_node:
				text += "  Progress: %.1f%%\n" % (player_node.mining_cycle_progress * 10)
			if "mining_target" in player_node and player_node.mining_target:
				text += "  Target: %s\n" % player_node.mining_target.name

		# Mining queue
		if "mining_queue" in player_node:
			text += "  Queue: %d asteroids\n" % player_node.mining_queue.size()

		# Docking
		if "is_docked" in player_node:
			text += "\n[color=orange]▸ DOCKING[/color]\n"
			text += "  Docked: %s\n" % ("Yes" if player_node.is_docked else "No")
			if "docked_station" in player_node and player_node.docked_station:
				text += "  Station: %s\n" % player_node.docked_station.name

	# Scene objects
	if main_scene:
		text += "\n[color=lime]▸ SCENE OBJECTS[/color]\n"

		var ore_container = main_scene.get_node_or_null("OreContainer")
		if ore_container:
			text += "  Asteroids: %d\n" % ore_container.get_child_count()

		var ship_container = main_scene.get_node_or_null("ShipContainer")
		if ship_container:
			text += "  Ships: %d\n" % ship_container.get_child_count()

		var station_container = main_scene.get_node_or_null("StationContainer")
		if station_container:
			text += "  Stations: %d\n" % station_container.get_child_count()

	# Camera (detailed)
	if main_scene and "camera" in main_scene:
		text += "\n[color=magenta]▸ CAMERA[/color]\n"
		var camera = main_scene.camera
		text += "  Position: (%.2f, %.2f)\n" % [camera.global_position.x, camera.global_position.y]
		text += "  Zoom: %.3f (min: %.2f, max: %.2f)\n" % [
			main_scene.zoom_level,
			main_scene.zoom_min,
			main_scene.zoom_max
		]
		text += "  Mode: %s\n" % ("Free" if main_scene.camera_free_mode else "Follow")
		text += "  Offset: (%.2f, %.2f)\n" % [main_scene.camera_follow_offset.x, main_scene.camera_follow_offset.y]
		text += "  Panning: %s\n" % ("Yes" if main_scene.is_panning else "No")

	# Map systems
	if main_scene:
		text += "\n[color=aqua]▸ MAP SYSTEMS[/color]\n"
		if "minimap" in main_scene and main_scene.minimap:
			text += "  Minimap: %s\n" % ("Visible" if main_scene.minimap.visible else "Hidden")
		if "map_system" in main_scene and main_scene.map_system:
			text += "  Map: %s\n" % ("Open" if main_scene.map_system.visible else "Closed")

	# Rendering
	text += "\n[color=violet]▸ RENDERING[/color]\n"
	text += "  Draw Calls: %d\n" % Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	text += "  Objects Drawn: %d\n" % Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)
	text += "  Primitives: %d\n" % Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)

	# Physics
	text += "\n[color=green]▸ PHYSICS[/color]\n"
	text += "  Active Objects: %d\n" % Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS)
	text += "  Collision Pairs: %d\n" % Performance.get_monitor(Performance.PHYSICS_2D_COLLISION_PAIRS)
	text += "  Island Count: %d\n" % Performance.get_monitor(Performance.PHYSICS_2D_ISLAND_COUNT)

	return text

func _get_profiler_info() -> String:
	"""Performance profiler view"""
	var text = "[color=yellow]═══════════ PERFORMANCE PROFILER ═══════════[/color]\n\n"

	# FPS Graph (ASCII)
	text += "[color=lime]FPS History (last 60 frames):[/color]\n"
	text += _generate_ascii_graph(fps_history, 30, 120, 20, 5)

	# Frame Time Graph
	text += "\n[color=orange]Frame Time History (ms):[/color]\n"
	text += _generate_ascii_graph(frame_time_history, 0, 33.3, 20, 5)

	# Detailed stats
	text += "\n[color=cyan]▸ STATISTICS[/color]\n"
	text += "  FPS: Current: %d | Avg: %.1f | Min: %.0f | Max: %.0f\n" % [
		Engine.get_frames_per_second(),
		_get_average_fps(),
		_get_min_fps(),
		_get_max_fps()
	]
	text += "  Frame: Current: %.2f ms | Avg: %.2f ms | Min: %.2f ms | Max: %.2f ms\n" % [
		_get_current_frame_time(),
		_get_average_frame_time(),
		_get_min_frame_time(),
		_get_max_frame_time()
	]

	# Target frame times
	text += "\n[color=yellow]▸ TARGET BENCHMARKS[/color]\n"
	text += "  60 FPS = 16.67 ms\n"
	text += "  30 FPS = 33.33 ms\n"
	text += "  Current: %.2f ms (%s)\n" % [
		_get_average_frame_time(),
		"✓ 60FPS" if _get_average_frame_time() < 16.67 else ("✓ 30FPS" if _get_average_frame_time() < 33.33 else "⚠ SLOW")
	]

	return text

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func _get_average_fps() -> float:
	if fps_history.is_empty():
		return 0.0
	var sum = 0.0
	for fps in fps_history:
		sum += fps
	return sum / fps_history.size()

func _get_min_fps() -> float:
	if fps_history.is_empty():
		return 0.0
	var min_val = fps_history[0]
	for fps in fps_history:
		if fps < min_val:
			min_val = fps
	return min_val

func _get_max_fps() -> float:
	if fps_history.is_empty():
		return 0.0
	var max_val = fps_history[0]
	for fps in fps_history:
		if fps > max_val:
			max_val = fps
	return max_val

func _get_current_frame_time() -> float:
	if frame_time_history.is_empty():
		return 0.0
	return frame_time_history[frame_time_history.size() - 1]

func _get_average_frame_time() -> float:
	if frame_time_history.is_empty():
		return 0.0
	var sum = 0.0
	for ft in frame_time_history:
		sum += ft
	return sum / frame_time_history.size()

func _get_min_frame_time() -> float:
	if frame_time_history.is_empty():
		return 0.0
	var min_val = frame_time_history[0]
	for ft in frame_time_history:
		if ft < min_val:
			min_val = ft
	return min_val

func _get_max_frame_time() -> float:
	if frame_time_history.is_empty():
		return 0.0
	var max_val = frame_time_history[0]
	for ft in frame_time_history:
		if ft > max_val:
			max_val = ft
	return max_val

func _generate_ascii_graph(data: Array, min_val: float, max_val: float, height: int, width_multiplier: int) -> String:
	"""Generate ASCII graph from data"""
	if data.is_empty():
		return "  [No data]\n"

	var graph = ""
	var bars = "▁▂▃▄▅▆▇█"

	# Scale data to graph height
	for value in data:
		var normalized = clamp((value - min_val) / (max_val - min_val), 0.0, 1.0)
		var bar_index = int(normalized * (bars.length() - 1))
		graph += bars[bar_index]

	return "  " + graph + "\n"

# ============================================================================
# PUBLIC API
# ============================================================================

func toggle_mode():
	"""Cycle through debug modes"""
	current_mode = (current_mode + 1) % (DebugMode.size())

	match current_mode:
		DebugMode.OFF:
			debug_panel.hide()
			mode_label.text = "DEBUG: OFF"
			print("Debug overlay: OFF")
		DebugMode.MINIMAL:
			debug_panel.show()
			debug_panel.custom_minimum_size = Vector2(400, 150)
			mode_label.text = "DEBUG: MINIMAL"
			print("Debug overlay: MINIMAL (F12 to cycle)")
		DebugMode.NORMAL:
			debug_panel.show()
			debug_panel.custom_minimum_size = Vector2(500, 400)
			mode_label.text = "DEBUG: NORMAL"
			print("Debug overlay: NORMAL (F12 to cycle)")
		DebugMode.EXPERT:
			debug_panel.show()
			debug_panel.custom_minimum_size = Vector2(600, 700)
			mode_label.text = "DEBUG: EXPERT"
			print("Debug overlay: EXPERT (F12 to cycle)")
		DebugMode.PROFILER:
			debug_panel.show()
			debug_panel.custom_minimum_size = Vector2(650, 500)
			mode_label.text = "DEBUG: PROFILER"
			print("Debug overlay: PROFILER (F12 to cycle)")

func set_player(node: Node2D):
	"""Set player node for tracking"""
	player_node = node

func set_main_scene(scene: Node2D):
	"""Set main scene for diagnostics"""
	main_scene = scene

func toggle_console():
	"""Toggle debug console (Shift+F12)"""
	console_visible = !console_visible

	if console_visible:
		console_panel.show()
		console_input.grab_focus()
		print("Debug console OPENED (Shift+F12 to close)")
	else:
		console_panel.hide()
		print("Debug console CLOSED")

func _on_console_command(command: String):
	"""Execute console command"""
	if command.is_empty():
		return

	# Display command
	console_output.text += "[color=yellow]> %s[/color]\n" % command

	# Execute via DebugCommands
	var result = DebugCommands.execute_command(command, player_node, main_scene)
	console_output.text += "%s\n\n" % result

	# Clear input
	console_input.text = ""
	console_input.grab_focus()
