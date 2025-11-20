extends Control
class_name MapSystem

## Multi-layer map system with automatic zoom transitions (EVE-style)
## Layers: Local Space -> Solar System -> Constellation -> Galaxy

# ============================================================================
# MAP LAYERS
# ============================================================================

enum MapLayer {
	LOCAL,          # Current area (0-10km)
	SOLAR_SYSTEM,   # Full solar system (10-1000km)
	CONSTELLATION,  # Group of systems (1000-100,000km)
	GALAXY          # Full galaxy view (100,000km+)
}

# Zoom thresholds for layer transitions (in game units)
const LAYER_THRESHOLDS = {
	MapLayer.LOCAL: 10000.0,           # 10km
	MapLayer.SOLAR_SYSTEM: 1000000.0,  # 1,000km
	MapLayer.CONSTELLATION: 100000000.0 # 100,000km
}

# ============================================================================
# NODES
# ============================================================================

var header: HBoxContainer
var layer_name_label: Label
var zoom_label: Label
var map_canvas: Control
var legend_panel: VBoxContainer
var toggle_legend_button: Button

# ============================================================================
# STATE
# ============================================================================

var current_layer: MapLayer = MapLayer.LOCAL
var zoom_level: float = 1.0        # Visual zoom (camera zoom)
var view_range: float = 5000.0     # How much area we show
var player_node: Node2D = null
var camera_offset: Vector2 = Vector2.ZERO  # For panning

# Panning
var is_panning: bool = false
var pan_start_pos: Vector2 = Vector2.ZERO

# ============================================================================
# INITIALIZATION
# ============================================================================

func _ready():
	custom_minimum_size = Vector2(800, 600)
	_setup_ui()

func _setup_ui():
	"""Setup map window UI"""
	var vbox = VBoxContainer.new()
	add_child(vbox)

	# Header
	header = HBoxContainer.new()
	vbox.add_child(header)

	var title = Label.new()
	title.text = "Map System"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)

	layer_name_label = Label.new()
	layer_name_label.text = "Local Space"
	header.add_child(layer_name_label)

	zoom_label = Label.new()
	zoom_label.text = "Range: 5.0 km"
	header.add_child(zoom_label)

	toggle_legend_button = Button.new()
	toggle_legend_button.text = "Legend"
	toggle_legend_button.pressed.connect(_on_toggle_legend)
	header.add_child(toggle_legend_button)

	var close_button = Button.new()
	close_button.text = "✖"
	close_button.custom_minimum_size = Vector2(30, 30)
	close_button.pressed.connect(func(): hide())
	header.add_child(close_button)

	# Main content (map + legend)
	var content = HBoxContainer.new()
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(content)

	# Map canvas
	map_canvas = Control.new()
	map_canvas.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_canvas.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_canvas.draw.connect(_on_map_draw)
	map_canvas.gui_input.connect(_on_map_input)
	content.add_child(map_canvas)

	# Legend panel (collapsible)
	legend_panel = VBoxContainer.new()
	legend_panel.custom_minimum_size = Vector2(200, 0)
	_setup_legend()
	content.add_child(legend_panel)

	# Controls hint
	var controls_label = Label.new()
	controls_label.text = "Controls: Scroll=Zoom | Middle Mouse=Pan | L=Toggle Legend"
	controls_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(controls_label)

func _setup_legend():
	"""Setup legend/tactical overview"""
	var legend_title = Label.new()
	legend_title.text = "=== LEGEND ==="
	legend_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	legend_panel.add_child(legend_title)

	legend_panel.add_child(HSeparator.new())

	# Add symbol categories
	_add_legend_category("SHIPS", [
		[MapSymbols.ObjectType.PLAYER_SHIP, "Your Ship"],
		[MapSymbols.ObjectType.FRIENDLY_SHIP, "Friendly"],
		[MapSymbols.ObjectType.NEUTRAL_SHIP, "Neutral"],
		[MapSymbols.ObjectType.HOSTILE_SHIP, "Hostile"]
	])

	_add_legend_category("STATIONS", [
		[MapSymbols.ObjectType.STATION_OUTPOST, "Outpost"],
		[MapSymbols.ObjectType.STATION_STATION, "Station"],
		[MapSymbols.ObjectType.STATION_CITADEL, "Citadel"],
		[MapSymbols.ObjectType.STATION_KEEPSTAR, "Keepstar"]
	])

	_add_legend_category("RESOURCES", [
		[MapSymbols.ObjectType.ASTEROID_ORE, "Asteroid (Ore)"],
		[MapSymbols.ObjectType.ASTEROID_ICE, "Asteroid (Ice)"],
		[MapSymbols.ObjectType.MOON, "Moon"],
		[MapSymbols.ObjectType.PLANET, "Planet"]
	])

	_add_legend_category("CELESTIALS", [
		[MapSymbols.ObjectType.SUN, "Sun"],
		[MapSymbols.ObjectType.WORMHOLE, "Wormhole"],
		[MapSymbols.ObjectType.BEACON, "Beacon"]
	])

func _add_legend_category(category_name: String, items: Array):
	"""Add a category to the legend"""
	var category_label = Label.new()
	category_label.text = category_name
	category_label.add_theme_color_override("font_color", Color(0.7, 0.9, 1.0))
	legend_panel.add_child(category_label)

	for item in items:
		var obj_type = item[0]
		var display_name = item[1]

		var hbox = HBoxContainer.new()
		legend_panel.add_child(hbox)

		# Symbol
		var symbol_label = Label.new()
		symbol_label.text = MapSymbols.get_symbol(obj_type)
		symbol_label.custom_minimum_size = Vector2(20, 20)
		symbol_label.add_theme_color_override("font_color", MapSymbols.get_color(obj_type))
		hbox.add_child(symbol_label)

		# Name
		var name_label = Label.new()
		name_label.text = display_name
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(name_label)

	legend_panel.add_child(HSeparator.new())

# ============================================================================
# UPDATE & DRAWING
# ============================================================================

func _process(_delta):
	map_canvas.queue_redraw()
	_update_labels()

func _update_labels():
	"""Update header labels"""
	# Layer name
	match current_layer:
		MapLayer.LOCAL:
			layer_name_label.text = "📍 Local Space"
		MapLayer.SOLAR_SYSTEM:
			layer_name_label.text = "⭐ Solar System"
		MapLayer.CONSTELLATION:
			layer_name_label.text = "🌌 Constellation"
		MapLayer.GALAXY:
			layer_name_label.text = "🌠 Galaxy"

	# Zoom/range
	if view_range < 1000:
		zoom_label.text = "Range: %.0f m" % view_range
	elif view_range < 1000000:
		zoom_label.text = "Range: %.1f km" % (view_range / 1000.0)
	else:
		zoom_label.text = "Range: %.1f Mm" % (view_range / 1000000.0)

func _on_map_draw():
	"""Draw the current map layer"""
	if not player_node:
		return

	var canvas_size = map_canvas.size
	var center = canvas_size / 2.0

	# Draw background
	map_canvas.draw_rect(Rect2(Vector2.ZERO, canvas_size), Color(0.02, 0.02, 0.05, 1.0))

	# Draw grid
	_draw_grid(center, canvas_size)

	# Draw based on current layer
	match current_layer:
		MapLayer.LOCAL:
			_draw_local_layer(center, canvas_size)
		MapLayer.SOLAR_SYSTEM:
			_draw_solar_system_layer(center, canvas_size)
		MapLayer.CONSTELLATION:
			_draw_constellation_layer(center, canvas_size)
		MapLayer.GALAXY:
			_draw_galaxy_layer(center, canvas_size)

	# Draw center marker (player position reference)
	map_canvas.draw_circle(center, 3, Color(0.3, 1.0, 0.3, 0.5))

func _draw_grid(center: Vector2, canvas_size: Vector2):
	"""Draw background grid"""
	var grid_color = Color(0.1, 0.15, 0.2, 0.5)
	var grid_spacing = 50.0  # pixels

	# Vertical lines
	var x = fmod(camera_offset.x * zoom_level, grid_spacing)
	while x < canvas_size.x:
		map_canvas.draw_line(Vector2(x, 0), Vector2(x, canvas_size.y), grid_color, 1.0)
		x += grid_spacing

	# Horizontal lines
	var y = fmod(camera_offset.y * zoom_level, grid_spacing)
	while y < canvas_size.y:
		map_canvas.draw_line(Vector2(0, y), Vector2(canvas_size.x, y), grid_color, 1.0)
		y += grid_spacing

func _draw_local_layer(center: Vector2, canvas_size: Vector2):
	"""Draw local space (asteroids, ships, nearby objects)"""
	# Get all nearby objects
	var main = get_tree().root.get_node_or_null("Main")
	if not main:
		return

	var objects_to_draw: Array[Node2D] = []

	# Get ores
	var ore_container = main.get_node_or_null("OreContainer")
	if ore_container:
		for child in ore_container.get_children():
			if is_instance_valid(child):
				objects_to_draw.append(child)

	# Get stations
	var station_container = main.get_node_or_null("StationContainer")
	if station_container:
		for child in station_container.get_children():
			if is_instance_valid(child):
				objects_to_draw.append(child)

	# Draw each object
	for obj in objects_to_draw:
		_draw_map_object(center, obj)

	# Draw player
	_draw_player_on_map(center)

func _draw_solar_system_layer(center: Vector2, _canvas_size: Vector2):
	"""Draw solar system view (planets, moons, stations)"""
	# For now, show simplified system view
	# In full implementation, this would show:
	# - Central sun
	# - Planets with orbits
	# - Major stations
	# - Asteroid belts

	# Draw sun at center
	map_canvas.draw_circle(center, 20, Color(1.0, 1.0, 0.3, 1.0))

	# Draw placeholder orbits
	for i in range(3):
		var orbit_radius = 80.0 + (i * 60.0)
		map_canvas.draw_arc(
			center,
			orbit_radius,
			0, TAU,
			32,
			Color(0.3, 0.4, 0.5, 0.3),
			1.0
		)

		# Draw planet
		var planet_pos = center + Vector2(orbit_radius, 0).rotated(Time.get_ticks_msec() / 1000.0 * (i + 1) * 0.1)
		map_canvas.draw_circle(planet_pos, 8 + i * 2, Color(0.5, 0.6, 0.8 - i * 0.2, 1.0))

	# Draw player position indicator
	_draw_player_on_map(center)

func _draw_constellation_layer(center: Vector2, _canvas_size: Vector2):
	"""Draw constellation view (multiple solar systems)"""
	# Show multiple star systems connected by stargates
	# This is a simplified representation

	var system_positions = [
		Vector2(0, 0),           # Current system (center)
		Vector2(150, -100),
		Vector2(-120, 80),
		Vector2(100, 150),
		Vector2(-150, -50)
	]

	# Draw connections (stargate routes)
	for i in range(1, system_positions.size()):
		var start = center + system_positions[0]
		var end = center + system_positions[i]
		map_canvas.draw_line(start, end, Color(0.3, 0.5, 0.7, 0.5), 2.0)

	# Draw systems
	for i in range(system_positions.size()):
		var pos = center + system_positions[i]
		var is_current = (i == 0)

		# System star
		var star_color = Color(1.0, 0.9, 0.5, 1.0) if is_current else Color(0.8, 0.8, 0.9, 0.7)
		map_canvas.draw_circle(pos, 12 if is_current else 8, star_color)

		# System name
		var system_name = "Current System" if is_current else "System %d" % i
		map_canvas.draw_string(
			ThemeDB.fallback_font,
			pos + Vector2(-30, 25),
			system_name,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			10,
			Color(0.9, 0.9, 1.0)
		)

func _draw_galaxy_layer(center: Vector2, canvas_size: Vector2):
	"""Draw galaxy view (full galaxy map)"""
	# Show the entire galaxy as clusters of constellations

	# Draw galaxy disk (spiral shape approximation)
	var galaxy_radius = min(canvas_size.x, canvas_size.y) * 0.4

	# Draw spiral arms (simplified)
	for arm in range(4):
		var points: PackedVector2Array = []
		var arm_offset = (TAU / 4.0) * arm

		for i in range(50):
			var t = i / 50.0
			var angle = arm_offset + (t * TAU * 2.0)
			var radius = (t * galaxy_radius)
			var pos = center + Vector2(cos(angle), sin(angle)) * radius
			points.append(pos)

		if points.size() > 1:
			map_canvas.draw_polyline(points, Color(0.4, 0.5, 0.8, 0.3), 2.0)

	# Draw constellation clusters
	for i in range(20):
		var angle = randf() * TAU
		var distance = randf() * galaxy_radius
		var pos = center + Vector2(cos(angle), sin(angle)) * distance

		# Cluster
		map_canvas.draw_circle(pos, 3, Color(0.7, 0.8, 1.0, 0.8))

	# Draw "You are here" marker
	var player_galaxy_pos = center  # Simplified: player at center of galaxy
	map_canvas.draw_circle(player_galaxy_pos, 8, Color(0.3, 1.0, 0.3, 1.0))
	map_canvas.draw_string(
		ThemeDB.fallback_font,
		player_galaxy_pos + Vector2(-30, 25),
		"You are here",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		12,
		Color(0.3, 1.0, 0.3)
	)

func _draw_map_object(center: Vector2, obj: Node2D):
	"""Draw an object on the map"""
	if not is_instance_valid(obj) or not player_node:
		return

	# Calculate position relative to player (with camera offset)
	var relative_pos = obj.global_position - player_node.global_position
	relative_pos += camera_offset

	# Scale to map
	var scale_factor = map_canvas.size.x / (view_range * 2.0)
	var map_pos = center + (relative_pos * scale_factor)

	# Check if within view
	if map_pos.x < 0 or map_pos.x > map_canvas.size.x or map_pos.y < 0 or map_pos.y > map_canvas.size.y:
		return

	# Get object properties
	var obj_type = MapSymbols.detect_object_type(obj)
	var symbol = MapSymbols.get_symbol(obj_type)
	var color = MapSymbols.get_color(obj_type)
	var size_mult = MapSymbols.get_size_multiplier(obj_type)

	# Draw icon
	var icon_size = 5.0 * size_mult
	map_canvas.draw_circle(map_pos, icon_size, color)

	# Draw symbol
	map_canvas.draw_string(
		ThemeDB.fallback_font,
		map_pos + Vector2(-5, 5),
		symbol,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		12,
		color
	)

func _draw_player_on_map(center: Vector2):
	"""Draw player ship on map"""
	if not player_node:
		return

	var player_color = MapSymbols.get_color(MapSymbols.ObjectType.PLAYER_SHIP)
	var player_symbol = MapSymbols.get_symbol(MapSymbols.ObjectType.PLAYER_SHIP)

	# Player is always at center (map follows player)
	map_canvas.draw_circle(center, 8, player_color)

	# Draw heading indicator
	if "velocity" in player_node:
		var velocity: Vector2 = player_node.velocity
		if velocity.length() > 0.1:
			var direction = velocity.normalized()
			var end_point = center + (direction * 15)
			map_canvas.draw_line(center, end_point, player_color, 3.0)

	# Draw symbol
	map_canvas.draw_string(
		ThemeDB.fallback_font,
		center + Vector2(-6, 6),
		player_symbol,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		14,
		player_color
	)

# ============================================================================
# INPUT & CONTROLS
# ============================================================================

func _on_map_input(event: InputEvent):
	"""Handle map input (zoom, pan)"""
	# Zoom with mouse wheel
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_out()
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				is_panning = true
				pan_start_pos = event.position
			else:
				is_panning = false

	# Pan with middle mouse drag
	elif event is InputEventMouseMotion and is_panning:
		var delta = event.position - pan_start_pos
		camera_offset -= delta / zoom_level
		pan_start_pos = event.position

func _input(event: InputEvent):
	"""Handle global input"""
	if not visible:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_L:
			_on_toggle_legend()

func zoom_in():
	"""Zoom in (decrease view range)"""
	view_range = max(100.0, view_range * 0.7)
	_check_layer_transition()

func zoom_out():
	"""Zoom out (increase view range)"""
	view_range = min(1000000000.0, view_range * 1.4)
	_check_layer_transition()

func _check_layer_transition():
	"""Check if we should transition to a different map layer"""
	var old_layer = current_layer

	# Determine appropriate layer based on view range
	if view_range < LAYER_THRESHOLDS[MapLayer.LOCAL]:
		current_layer = MapLayer.LOCAL
	elif view_range < LAYER_THRESHOLDS[MapLayer.SOLAR_SYSTEM]:
		current_layer = MapLayer.SOLAR_SYSTEM
	elif view_range < LAYER_THRESHOLDS[MapLayer.CONSTELLATION]:
		current_layer = MapLayer.CONSTELLATION
	else:
		current_layer = MapLayer.GALAXY

	# Notify if layer changed
	if old_layer != current_layer:
		print("Map layer changed: %s -> %s" % [MapLayer.keys()[old_layer], MapLayer.keys()[current_layer]])

func _on_toggle_legend():
	"""Toggle legend visibility"""
	legend_panel.visible = !legend_panel.visible

# ============================================================================
# PUBLIC API
# ============================================================================

func set_player_node(node: Node2D):
	"""Set the player node to track"""
	player_node = node

func open_map():
	"""Open the map window"""
	show()

func close_map():
	"""Close the map window"""
	hide()
