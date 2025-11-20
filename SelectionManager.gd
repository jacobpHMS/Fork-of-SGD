extends Node

# ============================================================================
# SELECTION MANAGER - Universal Selection & Interaction System
# ============================================================================
# Handles all object selection, context menus, drag & drop
# Supports: Click, Double-Click, Right-Click, Drag & Drop, Multi-Select

signal object_selected(object: Node)
signal object_deselected(object: Node)
signal selection_changed(selected_objects: Array)
signal context_menu_requested(object: Node, position: Vector2)
signal drag_started(object: Node)
signal drag_ended(object: Node, drop_target: Node)

# Selection modes
enum SelectionMode {
	SINGLE,      # Select one at a time
	MULTI,       # Select multiple (Ctrl+Click)
	BOX          # Box selection (drag box)
}

# Object types that can be selected
enum SelectableType {
	SHIP,
	ORE,
	STATION,
	ENEMY,
	FLEET_SHIP,
	OTHER
}

# Current selection state
var selected_objects: Array[Node] = []
var primary_selection: Node = null  # Main selected object
var selection_mode: SelectionMode = SelectionMode.SINGLE

# Hover state
var hovered_object: Node = null
var hover_time: float = 0.0
const HOVER_TOOLTIP_DELAY: float = 0.5  # Show tooltip after 0.5s

# Click handling
var last_click_time: float = 0.0
var last_clicked_object: Node = null
const DOUBLE_CLICK_TIME: float = 0.3  # 300ms for double-click

# Drag & Drop
var is_dragging: bool = false
var drag_object: Node = null
var drag_start_pos: Vector2 = Vector2.ZERO
var drag_threshold: float = 5.0  # Pixels before drag starts

# Box selection
var is_box_selecting: bool = false
var box_start_pos: Vector2 = Vector2.ZERO
var box_end_pos: Vector2 = Vector2.ZERO

# Context menu
var context_menu_visible: bool = false

# Camera reference (for world-to-screen conversions)
var camera: Camera2D = null

func _ready():
	print("🖱️ Selection Manager initialized")

func _process(delta):
	# Update hover time
	if hovered_object:
		hover_time += delta
	else:
		hover_time = 0.0

func _input(event):
	# Handle mouse button events
	if event is InputEventMouseButton:
		handle_mouse_button(event)

	# Handle mouse motion
	elif event is InputEventMouseMotion:
		handle_mouse_motion(event)

	# Handle keyboard shortcuts
	elif event is InputEventKey:
		handle_keyboard(event)

# ============================================================================
# MOUSE HANDLING
# ============================================================================

func handle_mouse_button(event: InputEventMouseButton):
	"""Handle mouse button events"""

	# Left click - Selection
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			handle_left_click_press(event)
		else:
			handle_left_click_release(event)

	# Right click - Context menu
	elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		handle_right_click(event)

func handle_left_click_press(event: InputEventMouseButton):
	"""Handle left mouse button press"""
	var click_pos = get_viewport().get_mouse_position()
	var world_pos = get_world_position(click_pos)

	# Check for object at click position
	var clicked_object = get_object_at_position(world_pos)

	if clicked_object:
		# Check for double-click
		var current_time = Time.get_ticks_msec() / 1000.0
		var is_double_click = (
			clicked_object == last_clicked_object and
			current_time - last_click_time < DOUBLE_CLICK_TIME
		)

		if is_double_click:
			handle_double_click(clicked_object)
		else:
			# Single click - start potential drag
			drag_object = clicked_object
			drag_start_pos = click_pos

		last_clicked_object = clicked_object
		last_click_time = current_time

	else:
		# Clicked on empty space
		if Input.is_key_pressed(KEY_CTRL) or Input.is_key_pressed(KEY_SHIFT):
			# Start box selection
			is_box_selecting = true
			box_start_pos = world_pos
			box_end_pos = world_pos
		else:
			# Deselect all
			clear_selection()

func handle_left_click_release(event: InputEventMouseButton):
	"""Handle left mouse button release"""
	var click_pos = get_viewport().get_mouse_position()
	var world_pos = get_world_position(click_pos)

	# End dragging
	if is_dragging:
		end_drag(world_pos)
		is_dragging = false
		drag_object = null

	# End box selection
	elif is_box_selecting:
		end_box_selection()
		is_box_selecting = false

	# Normal click (not drag)
	elif drag_object:
		var clicked_object = get_object_at_position(world_pos)

		if clicked_object:
			# Multi-select with Ctrl/Shift
			if Input.is_key_pressed(KEY_CTRL) or Input.is_key_pressed(KEY_SHIFT):
				toggle_selection(clicked_object)
			else:
				select_object(clicked_object)

		drag_object = null

func handle_right_click(event: InputEventMouseButton):
	"""Handle right mouse button click"""
	var click_pos = get_viewport().get_mouse_position()
	var world_pos = get_world_position(click_pos)

	var clicked_object = get_object_at_position(world_pos)

	if clicked_object:
		# Show context menu for object
		emit_signal("context_menu_requested", clicked_object, click_pos)
		context_menu_visible = true
	else:
		# Show general context menu or command menu
		if not selected_objects.is_empty():
			# Command selected objects to move here, etc.
			command_move_to(world_pos)

func handle_double_click(object: Node):
	"""Handle double-click on object"""
	print("🖱️ Double-clicked: %s" % object.name)

	# Double-click actions based on object type
	var type = get_selectable_type(object)

	match type:
		SelectableType.SHIP, SelectableType.FLEET_SHIP:
			# Focus camera on ship
			focus_camera_on(object)

		SelectableType.STATION:
			# Open station UI
			open_station_ui(object)

		SelectableType.ORE:
			# Command selected ships to mine this ore
			if not selected_objects.is_empty():
				command_mine_ore(object)

func handle_mouse_motion(event: InputEventMouseMotion):
	"""Handle mouse motion"""
	var mouse_pos = event.position
	var world_pos = get_world_position(mouse_pos)

	# Update hover
	var new_hover = get_object_at_position(world_pos)
	if new_hover != hovered_object:
		hovered_object = new_hover
		hover_time = 0.0

	# Check if dragging
	if drag_object and not is_dragging:
		var drag_distance = mouse_pos.distance_to(drag_start_pos)
		if drag_distance > drag_threshold:
			start_drag(drag_object)

	# Update drag position
	if is_dragging:
		# Visual feedback for drag
		pass

	# Update box selection
	if is_box_selecting:
		box_end_pos = world_pos

func handle_keyboard(event: InputEventKey):
	"""Handle keyboard shortcuts"""
	if not event.pressed:
		return

	match event.keycode:
		KEY_ESCAPE:
			# Cancel selection/drag/box
			clear_selection()
			is_dragging = false
			is_box_selecting = false
			drag_object = null

		KEY_A:
			# Select all (Ctrl+A)
			if Input.is_key_pressed(KEY_CTRL):
				select_all()

		KEY_DELETE:
			# Delete selected objects
			delete_selected()

		KEY_F:
			# Focus on selected
			if not selected_objects.is_empty():
				focus_camera_on(primary_selection)

# ============================================================================
# SELECTION MANAGEMENT
# ============================================================================

func select_object(object: Node):
	"""Select a single object"""
	if object == null:
		return

	# Clear previous selection if not multi-select mode
	if selection_mode == SelectionMode.SINGLE:
		clear_selection()

	# Add to selection
	if not selected_objects.has(object):
		selected_objects.append(object)
		primary_selection = object

		# Visual feedback
		highlight_object(object, true)

		emit_signal("object_selected", object)
		emit_signal("selection_changed", selected_objects)

		print("📍 Selected: %s" % object.name)

func deselect_object(object: Node):
	"""Deselect an object"""
	if selected_objects.has(object):
		selected_objects.erase(object)

		# Update primary selection
		if primary_selection == object:
			primary_selection = selected_objects[0] if not selected_objects.is_empty() else null

		# Remove visual feedback
		highlight_object(object, false)

		emit_signal("object_deselected", object)
		emit_signal("selection_changed", selected_objects)

func toggle_selection(object: Node):
	"""Toggle object selection (for multi-select)"""
	if selected_objects.has(object):
		deselect_object(object)
	else:
		selected_objects.append(object)
		if primary_selection == null:
			primary_selection = object
		highlight_object(object, true)
		emit_signal("object_selected", object)
		emit_signal("selection_changed", selected_objects)

func clear_selection():
	"""Clear all selections"""
	for obj in selected_objects:
		highlight_object(obj, false)

	selected_objects.clear()
	primary_selection = null
	emit_signal("selection_changed", selected_objects)

func select_all():
	"""Select all selectable objects"""
	clear_selection()

	var selectables = get_all_selectable_objects()
	for obj in selectables:
		select_object(obj)

func select_in_box(box_rect: Rect2):
	"""Select all objects in a box"""
	var selectables = get_all_selectable_objects()

	for obj in selectables:
		if "global_position" in obj:
			if box_rect.has_point(obj.global_position):
				if not selected_objects.has(obj):
					toggle_selection(obj)

# ============================================================================
# DRAG & DROP
# ============================================================================

func start_drag(object: Node):
	"""Start dragging an object"""
	is_dragging = true
	drag_object = object
	emit_signal("drag_started", object)
	print("🖱️ Started dragging: %s" % object.name)

func end_drag(drop_pos: Vector2):
	"""End dragging"""
	if not is_dragging or not drag_object:
		return

	# Find drop target
	var drop_target = get_object_at_position(drop_pos)

	emit_signal("drag_ended", drag_object, drop_target)

	# Handle drop based on object types
	if drop_target:
		handle_drop(drag_object, drop_target)

	print("🖱️ Ended drag: %s → %s" % [
		drag_object.name,
		drop_target.name if drop_target else "empty"
	])

	drag_object = null

func handle_drop(dragged: Node, target: Node):
	"""Handle dropping one object onto another"""
	var dragged_type = get_selectable_type(dragged)
	var target_type = get_selectable_type(target)

	# Examples of drag & drop interactions:
	# - Ore onto Ship → Command ship to mine ore
	# - Ship onto Station → Command ship to dock
	# - Cargo onto Station → Transfer cargo

	match [dragged_type, target_type]:
		[SelectableType.ORE, SelectableType.SHIP]:
			# Mine ore with ship
			command_mine_ore(dragged)

		[SelectableType.SHIP, SelectableType.STATION]:
			# Dock at station
			command_dock_at_station(target)

# ============================================================================
# BOX SELECTION
# ============================================================================

func end_box_selection():
	"""End box selection and select objects in box"""
	var box_rect = Rect2(box_start_pos, box_end_pos - box_start_pos).abs()

	# Select objects in box
	select_in_box(box_rect)

func get_box_selection_rect() -> Rect2:
	"""Get current box selection rectangle"""
	return Rect2(box_start_pos, box_end_pos - box_start_pos).abs()

# ============================================================================
# OBJECT QUERIES
# ============================================================================

func get_object_at_position(world_pos: Vector2) -> Node:
	"""Get selectable object at world position"""
	# Raycast or spatial query to find object
	# This should be optimized with spatial partitioning

	# For now, check all selectable objects
	var selectables = get_all_selectable_objects()
	var closest = null
	var closest_dist = INF
	const SELECT_RADIUS = 50.0  # Selection tolerance

	for obj in selectables:
		if "global_position" in obj:
			var dist = obj.global_position.distance_to(world_pos)
			if dist < SELECT_RADIUS and dist < closest_dist:
				closest = obj
				closest_dist = dist

	return closest

func get_all_selectable_objects() -> Array[Node]:
	"""Get all objects that can be selected"""
	var result: Array[Node] = []

	# Get objects from different groups
	result.append_array(get_tree().get_nodes_in_group("selectable"))
	result.append_array(get_tree().get_nodes_in_group("ships"))
	result.append_array(get_tree().get_nodes_in_group("ores"))
	result.append_array(get_tree().get_nodes_in_group("stations"))
	result.append_array(get_tree().get_nodes_in_group("fleet_ships"))

	return result

func get_selectable_type(object: Node) -> SelectableType:
	"""Get the type of a selectable object"""
	if object.is_in_group("ships"):
		return SelectableType.SHIP
	elif object.is_in_group("ores"):
		return SelectableType.ORE
	elif object.is_in_group("stations"):
		return SelectableType.STATION
	elif object.is_in_group("enemies"):
		return SelectableType.ENEMY
	elif object.is_in_group("fleet_ships"):
		return SelectableType.FLEET_SHIP
	else:
		return SelectableType.OTHER

# ============================================================================
# VISUAL FEEDBACK
# ============================================================================

func highlight_object(object: Node, highlighted: bool):
	"""Add/remove selection highlight from object"""
	if "modulate" in object:
		if highlighted:
			object.modulate = Color(1.5, 1.5, 1.5)  # Brighten
		else:
			object.modulate = Color(1.0, 1.0, 1.0)  # Normal

	# Or use outline shader if available
	if "material" in object and object.material:
		if "set_shader_parameter" in object.material:
			object.material.set_shader_parameter("outline_enabled", highlighted)

# ============================================================================
# COMMANDS
# ============================================================================

func command_move_to(world_pos: Vector2):
	"""Command selected ships to move to position"""
	for obj in selected_objects:
		if obj.is_in_group("ships") or obj.is_in_group("fleet_ships"):
			if obj.has_method("move_to"):
				obj.move_to(world_pos)
			print("📍 Commanding %s to move to %v" % [obj.name, world_pos])

func command_mine_ore(ore: Node):
	"""Command selected ships to mine ore"""
	for obj in selected_objects:
		if obj.is_in_group("ships") or obj.is_in_group("fleet_ships"):
			if obj.has_method("mine_ore"):
				obj.mine_ore(ore)
			print("⛏️ Commanding %s to mine %s" % [obj.name, ore.name])

func command_dock_at_station(station: Node):
	"""Command selected ships to dock at station"""
	for obj in selected_objects:
		if obj.is_in_group("ships") or obj.is_in_group("fleet_ships"):
			if obj.has_method("dock_at"):
				obj.dock_at(station)
			print("🚢 Commanding %s to dock at %s" % [obj.name, station.name])

func delete_selected():
	"""Delete selected objects (if allowed)"""
	for obj in selected_objects:
		if obj.has_method("destroy"):
			obj.destroy()
		else:
			obj.queue_free()

	clear_selection()

# ============================================================================
# CAMERA UTILITIES
# ============================================================================

func set_camera(cam: Camera2D):
	"""Set camera reference for world-to-screen conversion"""
	camera = cam

func get_world_position(screen_pos: Vector2) -> Vector2:
	"""Convert screen position to world position"""
	if camera:
		return camera.get_global_mouse_position()
	else:
		# Fallback without camera
		return get_viewport().get_mouse_position()

func focus_camera_on(object: Node):
	"""Focus camera on an object"""
	if camera and "global_position" in object:
		# Smooth camera transition
		var tween = create_tween()
		tween.tween_property(camera, "global_position", object.global_position, 0.3)
		print("🎥 Focused camera on %s" % object.name)

# ============================================================================
# UI INTEGRATION
# ============================================================================

func open_station_ui(station: Node):
	"""Open station UI"""
	# This would trigger the station UI to open
	print("🏭 Opening UI for station: %s" % station.name)
	# Emit signal that UI can listen to
	# emit_signal("station_ui_requested", station)

# ============================================================================
# PUBLIC INTERFACE
# ============================================================================

func get_selected_objects() -> Array[Node]:
	"""Get currently selected objects"""
	return selected_objects

func get_primary_selection() -> Node:
	"""Get primary selected object"""
	return primary_selection

func is_object_selected(object: Node) -> bool:
	"""Check if object is selected"""
	return selected_objects.has(object)

func get_selected_count() -> int:
	"""Get number of selected objects"""
	return selected_objects.size()
