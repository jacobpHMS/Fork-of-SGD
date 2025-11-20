extends PanelContainer
class_name Minimap

## Circular minimap showing local space (EVE-style)
## Collapsible window with radar-like display

# ============================================================================
# SETTINGS
# ============================================================================

@export var minimap_radius: float = 150.0  # Radius of circular minimap in pixels
@export var scan_range: float = 2000.0     # How far to scan in game units
@export var update_interval: float = 0.5   # Update frequency in seconds
@export var show_grid: bool = true          # Show range rings
@export var show_labels: bool = false       # Show object labels (can be cluttered)

# ============================================================================
# NODES
# ============================================================================

var map_container: Control
var map_canvas: Control
var toggle_button: Button
var range_label: Label

# ============================================================================
# STATE
# ============================================================================

var is_collapsed: bool = false
var player_node: Node2D = null
var tracked_objects: Array[Node2D] = []
var update_timer: float = 0.0

# Filter settings (what to show)
var show_ships: bool = true
var show_stations: bool = true
var show_resources: bool = true
var show_npcs: bool = true
var show_celestials: bool = true
var show_other: bool = true

# ============================================================================
# INITIALIZATION
# ============================================================================

func _ready():
	custom_minimum_size = Vector2(minimap_radius * 2 + 40, minimap_radius * 2 + 80)

	_setup_ui()

func _setup_ui():
	"""Setup minimap UI structure"""
	var vbox = VBoxContainer.new()
	add_child(vbox)

	# Header with toggle button
	var header = HBoxContainer.new()
	vbox.add_child(header)

	var title = Label.new()
	title.text = "Minimap"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)

	# Range display
	range_label = Label.new()
	range_label.text = "%.0f km" % (scan_range / 1000.0)
	header.add_child(range_label)

	toggle_button = Button.new()
	toggle_button.text = "−"  # Collapse symbol
	toggle_button.custom_minimum_size = Vector2(30, 30)
	toggle_button.pressed.connect(_on_toggle_pressed)
	header.add_child(toggle_button)

	# Map container (circular area)
	map_container = Control.new()
	map_container.custom_minimum_size = Vector2(minimap_radius * 2, minimap_radius * 2)
	vbox.add_child(map_container)

	# Canvas for drawing
	map_canvas = Control.new()
	map_canvas.custom_minimum_size = Vector2(minimap_radius * 2, minimap_radius * 2)
	map_canvas.draw.connect(_on_map_draw)
	map_container.add_child(map_canvas)

	# Filter buttons
	var filter_container = HBoxContainer.new()
	filter_container.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(filter_container)

	_add_filter_button(filter_container, "Ships", show_ships, func(v): show_ships = v)
	_add_filter_button(filter_container, "Stations", show_stations, func(v): show_stations = v)
	_add_filter_button(filter_container, "Resources", show_resources, func(v): show_resources = v)

func _add_filter_button(parent: HBoxContainer, label_text: String, initial_state: bool, callback: Callable):
	"""Add a filter toggle button"""
	var btn = Button.new()
	btn.text = label_text
	btn.toggle_mode = true
	btn.button_pressed = initial_state
	btn.custom_minimum_size = Vector2(60, 25)

	btn.toggled.connect(func(pressed):
		callback.call(pressed)
		map_canvas.queue_redraw()
	)

	parent.add_child(btn)

# ============================================================================
# UPDATE & DRAWING
# ============================================================================

func _process(delta):
	if is_collapsed:
		return

	update_timer += delta
	if update_timer >= update_interval:
		update_timer = 0.0
		_update_tracked_objects()
		map_canvas.queue_redraw()

func _update_tracked_objects():
	"""Find all objects in scan range"""
	if not player_node:
		return

	tracked_objects.clear()

	# Get main scene
	var main = get_tree().root.get_node_or_null("Main")
	if not main:
		return

	# Scan for objects
	var all_objects: Array[Node2D] = []

	# Get ores
	var ore_container = main.get_node_or_null("OreContainer")
	if ore_container:
		for child in ore_container.get_children():
			if is_instance_valid(child):
				all_objects.append(child)

	# Get stations (if they exist)
	var station_container = main.get_node_or_null("StationContainer")
	if station_container:
		for child in station_container.get_children():
			if is_instance_valid(child):
				all_objects.append(child)

	# Get NPC ships (from group)
	var npc_ships = get_tree().get_nodes_in_group("npc_ships")
	for npc in npc_ships:
		if is_instance_valid(npc) and npc is Node2D:
			all_objects.append(npc)

	# Get other ships (from ShipContainer if it exists)
	var ship_container = main.get_node_or_null("ShipContainer")
	if ship_container:
		for child in ship_container.get_children():
			if is_instance_valid(child):
				all_objects.append(child)

	# Filter by range
	for obj in all_objects:
		var distance = player_node.global_position.distance_to(obj.global_position)
		if distance <= scan_range:
			tracked_objects.append(obj)

func _on_map_draw():
	"""Draw the circular minimap"""
	if is_collapsed or not player_node:
		return

	var center = Vector2(minimap_radius, minimap_radius)

	# Draw background circle (dark)
	map_canvas.draw_circle(center, minimap_radius, Color(0.05, 0.05, 0.1, 0.9))

	# Draw border
	map_canvas.draw_arc(center, minimap_radius, 0, TAU, 64, Color(0.3, 0.5, 0.7, 1.0), 2.0)

	# Draw range rings if enabled
	if show_grid:
		_draw_range_rings(center)

	# Draw cardinal directions
	_draw_cardinal_marks(center)

	# Draw tracked objects
	for obj in tracked_objects:
		_draw_object(center, obj)

	# Draw player at center (always on top)
	_draw_player(center)

func _draw_range_rings(center: Vector2):
	"""Draw concentric circles showing range"""
	var ring_count = 3
	for i in range(1, ring_count + 1):
		var ring_radius = (minimap_radius / ring_count) * i
		map_canvas.draw_arc(
			center,
			ring_radius,
			0, TAU,
			32,
			Color(0.2, 0.3, 0.4, 0.3),
			1.0
		)

func _draw_cardinal_marks(center: Vector2):
	"""Draw N/S/E/W marks"""
	var mark_distance = minimap_radius - 15
	var font_size = 12

	# North
	map_canvas.draw_string(
		ThemeDB.fallback_font,
		center + Vector2(-5, -mark_distance),
		"N",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size,
		Color(0.5, 0.7, 1.0)
	)

	# South
	map_canvas.draw_string(
		ThemeDB.fallback_font,
		center + Vector2(-5, mark_distance + 10),
		"S",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size,
		Color(0.5, 0.7, 1.0)
	)

	# East
	map_canvas.draw_string(
		ThemeDB.fallback_font,
		center + Vector2(mark_distance - 10, 5),
		"E",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size,
		Color(0.5, 0.7, 1.0)
	)

	# West
	map_canvas.draw_string(
		ThemeDB.fallback_font,
		center + Vector2(-mark_distance, 5),
		"W",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size,
		Color(0.5, 0.7, 1.0)
	)

func _draw_object(center: Vector2, obj: Node2D):
	"""Draw an object on the minimap"""
	if not is_instance_valid(obj) or not player_node:
		return

	# Get object type and check filters
	var obj_type = MapSymbols.detect_object_type(obj)
	var category = MapSymbols.get_category(obj_type)

	# Apply filters
	match category:
		"ships":
			if not show_ships: return
		"stations":
			if not show_stations: return
		"resources":
			if not show_resources: return
		"npcs":
			if not show_npcs: return
		"celestials":
			if not show_celestials: return
		_:
			if not show_other: return

	# Calculate position relative to player
	var relative_pos = obj.global_position - player_node.global_position

	# Scale to minimap
	var scale_factor = minimap_radius / scan_range
	var map_pos = center + (relative_pos * scale_factor)

	# Clamp to minimap bounds (circular)
	var offset = map_pos - center
	if offset.length() > minimap_radius - 5:
		offset = offset.normalized() * (minimap_radius - 5)
		map_pos = center + offset

	# Get symbol and color
	var symbol = MapSymbols.get_symbol(obj_type)
	var color = MapSymbols.get_color(obj_type)
	var size_mult = MapSymbols.get_size_multiplier(obj_type)

	# Draw icon (circle for now, can be replaced with actual symbols)
	var icon_size = 4.0 * size_mult
	map_canvas.draw_circle(map_pos, icon_size, color)

	# Draw symbol text
	if symbol != "?":
		map_canvas.draw_string(
			ThemeDB.fallback_font,
			map_pos + Vector2(-4, 4),
			symbol,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			10,
			color
		)

	# Draw label if enabled
	if show_labels:
		var label = obj.name
		map_canvas.draw_string(
			ThemeDB.fallback_font,
			map_pos + Vector2(8, 4),
			label,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			8,
			Color(0.8, 0.8, 0.8, 0.8)
		)

func _draw_player(center: Vector2):
	"""Draw player icon at center"""
	var player_color = MapSymbols.get_color(MapSymbols.ObjectType.PLAYER_SHIP)
	var player_symbol = MapSymbols.get_symbol(MapSymbols.ObjectType.PLAYER_SHIP)

	# Draw player icon (larger)
	map_canvas.draw_circle(center, 6.0, player_color)

	# Draw direction indicator (small line showing heading)
	if "velocity" in player_node:
		var velocity: Vector2 = player_node.velocity
		if velocity.length() > 0.1:
			var direction = velocity.normalized()
			var end_point = center + (direction * 12)
			map_canvas.draw_line(center, end_point, player_color, 2.0)

	# Draw symbol
	map_canvas.draw_string(
		ThemeDB.fallback_font,
		center + Vector2(-4, 4),
		player_symbol,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		12,
		player_color
	)

# ============================================================================
# CONTROLS
# ============================================================================

func _on_toggle_pressed():
	"""Toggle minimap collapse/expand"""
	is_collapsed = !is_collapsed

	if is_collapsed:
		toggle_button.text = "+"
		map_container.hide()
	else:
		toggle_button.text = "−"
		map_container.show()
		map_canvas.queue_redraw()

	custom_minimum_size.y = 40 if is_collapsed else minimap_radius * 2 + 80

func set_player_node(node: Node2D):
	"""Set the player node to track"""
	player_node = node

func set_scan_range(new_range: float):
	"""Change scan range"""
	scan_range = new_range
	range_label.text = "%.0f km" % (scan_range / 1000.0)
	map_canvas.queue_redraw()

func zoom_in():
	"""Decrease scan range (zoom in)"""
	scan_range = max(500.0, scan_range * 0.5)
	set_scan_range(scan_range)

func zoom_out():
	"""Increase scan range (zoom out)"""
	scan_range = min(10000.0, scan_range * 2.0)
	set_scan_range(scan_range)
