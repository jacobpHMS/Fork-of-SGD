extends Node

# Universal Drag & Drop Manager
# Handles all drag & drop operations in the game
# Usage: DragManager.start_drag(data), DragManager.end_drag()

# Drag state
var is_dragging: bool = false
var drag_data: Dictionary = {}
var drag_source: Control = null
var drag_ghost: Control = null

# Drop zones
var drop_zones: Array = []
var current_drop_zone: Control = null

# Validation
var validation_callback: Callable = Callable()

# Signals
signal drag_started(data: Dictionary)
signal drag_ended(success: bool, drop_zone: Control)
signal drag_cancelled()

func _ready():
	# This is a singleton, ready to use
	print("DragManager initialized")

func _process(_delta):
	if is_dragging and drag_ghost:
		# Update ghost position to follow mouse
		drag_ghost.global_position = get_viewport().get_mouse_position() - drag_ghost.size / 2

		# Check which drop zone we're hovering over
		update_drop_zone_highlight()

func start_drag(data: Dictionary, source: Control, ghost_scene: PackedScene = null):
	"""Start a drag operation
	data: Dictionary with item info (item_id, amount, source_cargo_type, etc.)
	source: The Control that initiated the drag
	ghost_scene: Optional custom ghost visual (if null, creates default)
	"""
	if is_dragging:
		print("WARNING: Already dragging, cancelling previous drag")
		cancel_drag()

	is_dragging = true
	drag_data = data
	drag_source = source

	# Create ghost visual
	if ghost_scene:
		drag_ghost = ghost_scene.instantiate()
	else:
		drag_ghost = create_default_ghost(data)

	# Add ghost to scene
	var canvas_layer = get_tree().get_first_node_in_group("ui_layer")
	if not canvas_layer:
		# Fallback: add to root
		get_tree().root.add_child(drag_ghost)
	else:
		canvas_layer.add_child(drag_ghost)

	# Set ghost to follow mouse
	drag_ghost.global_position = get_viewport().get_mouse_position()

	# Make ghost non-interactive
	drag_ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE

	print("Drag started: ", data)
	drag_started.emit(data)

func end_drag():
	"""End drag operation - try to drop on current drop zone"""
	if not is_dragging:
		return

	var success = false

	# Check if we're over a valid drop zone
	if current_drop_zone and is_instance_valid(current_drop_zone):
		# Validate drop
		if can_drop(drag_data, current_drop_zone):
			# Perform drop
			success = perform_drop(drag_data, current_drop_zone)
		else:
			print("Drop not allowed here")

	# Clean up
	cleanup_drag(success)

	drag_ended.emit(success, current_drop_zone)

func cancel_drag():
	"""Cancel drag operation without dropping"""
	if not is_dragging:
		return

	print("Drag cancelled")
	cleanup_drag(false)
	drag_cancelled.emit()

func cleanup_drag(_success: bool):
	"""Clean up after drag operation"""
	is_dragging = false

	# Remove ghost
	if drag_ghost and is_instance_valid(drag_ghost):
		drag_ghost.queue_free()
	drag_ghost = null

	# Clear drop zone highlight
	if current_drop_zone:
		clear_drop_zone_highlight(current_drop_zone)
		current_drop_zone = null

	# Clear data
	drag_data = {}
	drag_source = null

func create_default_ghost(data: Dictionary) -> Control:
	"""Create default ghost visual for dragged item with amount slider"""
	var ghost = PanelContainer.new()
	ghost.custom_minimum_size = Vector2(200, 100)

	var vbox = VBoxContainer.new()
	ghost.add_child(vbox)

	# Item name label
	var label = Label.new()
	var item_name = data.get("display_name", data.get("item_id", "Unknown"))
	label.text = item_name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(label)

	# Amount slider
	var amount = data.get("amount", 0)
	var max_amount = amount  # Max = total amount in stack

	var slider = HSlider.new()
	slider.name = "AmountSlider"
	slider.min_value = 1
	slider.max_value = max(max_amount, 1)
	slider.value = max_amount
	slider.step = 1
	slider.custom_minimum_size = Vector2(180, 20)
	vbox.add_child(slider)

	# Amount display label
	var amount_label = Label.new()
	amount_label.name = "AmountLabel"
	amount_label.text = "Amount: %.1f / %.1f" % [max_amount, max_amount]
	amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	amount_label.add_theme_font_size_override("font_size", 10)
	vbox.add_child(amount_label)

	# Connect slider to update label
	slider.value_changed.connect(func(value):
		amount_label.text = "Amount: %.1f / %.1f" % [value, max_amount]
		# Update drag_data with new amount
		drag_data["drag_amount"] = value
	)

	# Set initial drag amount
	drag_data["drag_amount"] = max_amount

	# Semi-transparent
	ghost.modulate = Color(1, 1, 1, 0.9)

	return ghost

func register_drop_zone(zone: Control, validation_func: Callable = Callable()):
	"""Register a control as a drop zone
	zone: The Control that can receive drops
	validation_func: Optional function to validate if drop is allowed
	  Should return bool and take (drag_data: Dictionary, drop_zone: Control)
	"""
	if not drop_zones.has(zone):
		drop_zones.append(zone)
		print("Drop zone registered: ", zone.name)

	# Store validation function in zone's metadata
	if validation_func.is_valid():
		zone.set_meta("drop_validation", validation_func)

func unregister_drop_zone(zone: Control):
	"""Unregister a drop zone"""
	drop_zones.erase(zone)
	if zone.has_meta("drop_validation"):
		zone.remove_meta("drop_validation")

func update_drop_zone_highlight():
	"""Check which drop zone mouse is over and highlight it"""
	var mouse_pos = get_viewport().get_mouse_position()

	# Find drop zone under mouse
	var found_zone: Control = null

	for zone in drop_zones:
		if not is_instance_valid(zone) or not zone.visible:
			continue

		var zone_rect = zone.get_global_rect()
		if zone_rect.has_point(mouse_pos):
			found_zone = zone
			break

	# Update highlight
	if found_zone != current_drop_zone:
		# Clear old highlight
		if current_drop_zone and is_instance_valid(current_drop_zone):
			clear_drop_zone_highlight(current_drop_zone)

		# Set new highlight
		current_drop_zone = found_zone
		if current_drop_zone:
			set_drop_zone_highlight(current_drop_zone, can_drop(drag_data, current_drop_zone))

func set_drop_zone_highlight(zone: Control, is_valid: bool):
	"""Highlight drop zone (green if valid, red if invalid)"""
	if not zone or not is_instance_valid(zone):
		return

	# Add/update highlight
	var color = Color.GREEN if is_valid else Color.RED
	color.a = 0.3  # Semi-transparent

	# Store original modulate if not stored
	if not zone.has_meta("original_modulate"):
		zone.set_meta("original_modulate", zone.modulate)

	zone.modulate = color

func clear_drop_zone_highlight(zone: Control):
	"""Remove highlight from drop zone"""
	if not zone or not is_instance_valid(zone):
		return

	# Restore original modulate
	if zone.has_meta("original_modulate"):
		zone.modulate = zone.get_meta("original_modulate")
		zone.remove_meta("original_modulate")

func can_drop(data: Dictionary, zone: Control) -> bool:
	"""Check if drop is allowed on this zone"""
	if not zone or not is_instance_valid(zone):
		return false

	# Check if zone has custom validation
	if zone.has_meta("drop_validation"):
		var validation_func = zone.get_meta("drop_validation")
		if validation_func is Callable and validation_func.is_valid():
			return validation_func.call(data, zone)

	# Default: allow drop
	return true

func perform_drop(data: Dictionary, zone: Control) -> bool:
	"""Perform the actual drop operation"""
	if not zone or not is_instance_valid(zone):
		return false

	# Check if zone has a drop handler
	if zone.has_method("on_item_dropped"):
		return zone.on_item_dropped(data)

	print("WARNING: Drop zone has no on_item_dropped() method: ", zone.name)
	return false

func get_drag_data() -> Dictionary:
	"""Get current drag data (empty if not dragging)"""
	return drag_data.duplicate()

func is_drag_active() -> bool:
	"""Check if a drag operation is in progress"""
	return is_dragging
