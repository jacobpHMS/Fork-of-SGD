extends Control
class_name InventoryGrid
## InventoryGrid - Grid-based inventory display
##
## Displays items in a grid layout with drag & drop support.
## Supports infinite items limited only by volume capacity.
##
## Features:
## - Dynamic grid sizing
## - Drag & Drop between grids
## - Visual capacity indicator
## - Sorting capabilities
## - Sci-Fi styled

# ============================================================================
# SIGNALS
# ============================================================================

signal item_moved(from_slot: ItemSlot, to_slot: ItemSlot)
signal item_added(item_id: String, amount: float)
signal item_removed(item_id: String, amount: float)
signal item_clicked(item_id: String, amount: float, button_index: int)
signal item_double_clicked(item_id: String, amount: float)
signal capacity_changed(used: float, max_capacity: float)
signal grid_sorted(sort_mode: String)

# ============================================================================
# EXPORTS
# ============================================================================

@export_group("Grid Configuration")
@export var columns: int = 8
@export var slot_size: Vector2 = Vector2(64, 64)
@export var slot_spacing: int = 4
@export var max_capacity: float = 1000.0  # m³
@export var allow_overflow: bool = false

@export_group("Features")
@export var show_capacity_bar: bool = true
@export var show_sort_buttons: bool = true
@export var allow_drag_drop: bool = true

# ============================================================================
# STATE
# ============================================================================

var items: Dictionary = {}  # item_id -> {amount, volume_per_unit, metadata}
var slots: Array[ItemSlot] = []
var used_capacity: float = 0.0

# UI References
var grid_container: GridContainer = null
var capacity_bar: ProgressBar = null
var capacity_label: Label = null
var sort_buttons_container: HBoxContainer = null
var scroll_container: ScrollContainer = null

var theme: SciFiTheme = null

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	theme = SciFiTheme.new()
	_build_ui()
	_update_capacity_display()

# ============================================================================
# UI BUILDING
# ============================================================================

func _build_ui():
	"""Build inventory grid UI"""
	var main_vbox = VBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(main_vbox)

	# Sort buttons (top)
	if show_sort_buttons:
		sort_buttons_container = _create_sort_buttons()
		main_vbox.add_child(sort_buttons_container)

	# Scroll container for grid
	scroll_container = ScrollContainer.new()
	scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	main_vbox.add_child(scroll_container)

	# Grid container
	grid_container = GridContainer.new()
	grid_container.columns = columns
	grid_container.add_theme_constant_override("h_separation", slot_spacing)
	grid_container.add_theme_constant_override("v_separation", slot_spacing)
	scroll_container.add_child(grid_container)

	# Capacity bar (bottom)
	if show_capacity_bar:
		var capacity_container = _create_capacity_bar()
		main_vbox.add_child(capacity_container)

func _create_sort_buttons() -> HBoxContainer:
	"""Create sorting buttons"""
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 4)

	var label = Label.new()
	label.text = "Sort:"
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", theme.COLOR_TEXT_SECONDARY)
	hbox.add_child(label)

	# Sort by Name
	var btn_name = _create_sort_button("Name", "name")
	hbox.add_child(btn_name)

	# Sort by Amount
	var btn_amount = _create_sort_button("Amount", "amount")
	hbox.add_child(btn_amount)

	# Sort by Volume
	var btn_volume = _create_sort_button("Volume", "volume")
	hbox.add_child(btn_volume)

	# Sort by Type
	var btn_type = _create_sort_button("Type", "type")
	hbox.add_child(btn_type)

	return hbox

func _create_sort_button(text: String, sort_mode: String) -> Button:
	"""Create a single sort button"""
	var btn = Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(60, 20)
	btn.add_theme_font_size_override("font_size", 9)

	# Apply sci-fi button style
	btn.add_theme_stylebox_override("normal", theme.create_button_style("normal", theme.COLOR_ACCENT_CYAN))
	btn.add_theme_stylebox_override("hover", theme.create_button_style("hover", theme.COLOR_ACCENT_CYAN))
	btn.add_theme_stylebox_override("pressed", theme.create_button_style("pressed", theme.COLOR_ACCENT_CYAN))

	btn.pressed.connect(_on_sort_button_pressed.bind(sort_mode))

	return btn

func _create_capacity_bar() -> VBoxContainer:
	"""Create capacity indicator"""
	var vbox = VBoxContainer.new()

	# Capacity label
	capacity_label = Label.new()
	capacity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	capacity_label.add_theme_font_size_override("font_size", 10)
	capacity_label.add_theme_color_override("font_color", theme.COLOR_TEXT_SECONDARY)
	vbox.add_child(capacity_label)

	# Progress bar
	var progress_styles = theme.create_progressbar_style(theme.COLOR_ACCENT_CYAN)
	capacity_bar = ProgressBar.new()
	capacity_bar.min_value = 0
	capacity_bar.max_value = max_capacity
	capacity_bar.value = 0
	capacity_bar.show_percentage = false
	capacity_bar.add_theme_stylebox_override("background", progress_styles.background)
	capacity_bar.add_theme_stylebox_override("fill", progress_styles.fill)
	vbox.add_child(capacity_bar)

	return vbox

# ============================================================================
# ITEM MANAGEMENT
# ============================================================================

func add_item(item_id: String, amount: float, volume_per_unit: float, metadata: Dictionary = {}) -> bool:
	"""Add item to inventory

	Returns true if successful, false if capacity exceeded
	"""
	var total_volume = amount * volume_per_unit
	var new_used = used_capacity + total_volume

	# Check capacity
	if not allow_overflow and new_used > max_capacity:
		push_warning("InventoryGrid: Capacity exceeded (%.1f/%.1f m³)" % [new_used, max_capacity])
		return false

	# Add to existing stack or create new
	if items.has(item_id):
		items[item_id].amount += amount
	else:
		items[item_id] = {
			"amount": amount,
			"volume_per_unit": volume_per_unit,
			"metadata": metadata
		}

	used_capacity = new_used

	# Rebuild grid
	_rebuild_grid()

	item_added.emit(item_id, amount)
	capacity_changed.emit(used_capacity, max_capacity)

	return true

func remove_item(item_id: String, amount: float) -> bool:
	"""Remove item from inventory

	Returns true if successful, false if not enough items
	"""
	if not items.has(item_id):
		return false

	var item = items[item_id]
	if item.amount < amount:
		return false

	var removed_volume = amount * item.volume_per_unit

	item.amount -= amount
	used_capacity -= removed_volume

	# Remove entry if empty
	if item.amount <= 0:
		items.erase(item_id)

	# Rebuild grid
	_rebuild_grid()

	item_removed.emit(item_id, amount)
	capacity_changed.emit(used_capacity, max_capacity)

	return true

func has_item(item_id: String, required_amount: float = 0.0) -> bool:
	"""Check if inventory has item (and optionally enough amount)"""
	if not items.has(item_id):
		return false

	if required_amount > 0:
		return items[item_id].amount >= required_amount

	return true

func get_item_amount(item_id: String) -> float:
	"""Get amount of specific item"""
	if items.has(item_id):
		return items[item_id].amount
	return 0.0

func get_all_items() -> Dictionary:
	"""Get all items as dictionary"""
	return items.duplicate(true)

func clear_all() -> void:
	"""Remove all items"""
	items.clear()
	used_capacity = 0.0
	_rebuild_grid()
	capacity_changed.emit(used_capacity, max_capacity)

# ============================================================================
# GRID BUILDING
# ============================================================================

func _rebuild_grid():
	"""Rebuild grid with current items"""
	# Clear existing slots
	for slot in slots:
		slot.queue_free()
	slots.clear()

	# Create slots for each item
	var item_list = items.keys()

	for item_id in item_list:
		var item = items[item_id]
		var slot = _create_slot(item_id, item.amount, item.volume_per_unit, item.metadata)
		slots.append(slot)
		grid_container.add_child(slot)

	# Add empty slots to fill grid (optional, for visual consistency)
	# var min_slots = columns * 4  # At least 4 rows
	# while slots.size() < min_slots:
	# 	var empty_slot = _create_empty_slot()
	# 	slots.append(empty_slot)
	# 	grid_container.add_child(empty_slot)

	_update_capacity_display()

func _create_slot(item_id: String, amount: float, volume_per_unit: float, metadata: Dictionary) -> ItemSlot:
	"""Create an item slot"""
	var slot = ItemSlot.new()
	slot.slot_size = slot_size
	slot.allow_drag = allow_drag_drop
	slot.allow_drop = allow_drag_drop

	slot.set_item(item_id, amount, volume_per_unit, metadata)

	# Connect signals
	slot.slot_clicked.connect(_on_slot_clicked.bind(slot))
	slot.slot_double_clicked.connect(_on_slot_double_clicked.bind(slot))
	slot.slot_right_clicked.connect(_on_slot_right_clicked.bind(slot))
	slot.item_dropped.connect(_on_item_dropped.bind(slot))

	return slot

func _create_empty_slot() -> ItemSlot:
	"""Create an empty slot"""
	var slot = ItemSlot.new()
	slot.slot_size = slot_size
	slot.allow_drag = false
	slot.allow_drop = allow_drag_drop
	slot.show_empty_slot = true

	return slot

# ============================================================================
# CAPACITY
# ============================================================================

func _update_capacity_display():
	"""Update capacity bar and label"""
	if capacity_bar:
		capacity_bar.value = used_capacity

	if capacity_label:
		var percent = (used_capacity / max_capacity * 100.0) if max_capacity > 0 else 0.0
		capacity_label.text = "Capacity: %.1f / %.1f m³ (%.0f%%)" % [used_capacity, max_capacity, percent]

		# Color code based on usage
		if percent > 90:
			capacity_label.add_theme_color_override("font_color", theme.COLOR_STATUS_DANGER)
		elif percent > 75:
			capacity_label.add_theme_color_override("font_color", theme.COLOR_STATUS_WARNING)
		else:
			capacity_label.add_theme_color_override("font_color", theme.COLOR_STATUS_ACTIVE)

func set_max_capacity(new_max: float) -> void:
	"""Set maximum capacity"""
	max_capacity = new_max
	if capacity_bar:
		capacity_bar.max_value = max_capacity
	_update_capacity_display()

func get_remaining_capacity() -> float:
	"""Get remaining capacity in m³"""
	return max(0.0, max_capacity - used_capacity)

func get_capacity_percent() -> float:
	"""Get capacity usage as percentage"""
	return (used_capacity / max_capacity * 100.0) if max_capacity > 0 else 0.0

# ============================================================================
# SORTING
# ============================================================================

func sort_items(sort_mode: String) -> void:
	"""Sort items by mode (name, amount, volume, type)"""
	var item_array = []

	# Convert dictionary to array for sorting
	for item_id in items.keys():
		var item = items[item_id]
		item_array.append({
			"id": item_id,
			"amount": item.amount,
			"volume_per_unit": item.volume_per_unit,
			"total_volume": item.amount * item.volume_per_unit,
			"metadata": item.metadata
		})

	# Sort based on mode
	match sort_mode:
		"name":
			item_array.sort_custom(func(a, b): return a.id < b.id)
		"amount":
			item_array.sort_custom(func(a, b): return a.amount > b.amount)
		"volume":
			item_array.sort_custom(func(a, b): return a.total_volume > b.total_volume)
		"type":
			# Sort by metadata type if available
			item_array.sort_custom(func(a, b):
				var type_a = a.metadata.get("type", "")
				var type_b = b.metadata.get("type", "")
				return type_a < type_b
			)

	# Rebuild items dictionary in sorted order
	# Note: Dictionaries in Godot 4 maintain insertion order
	items.clear()
	for item in item_array:
		items[item.id] = {
			"amount": item.amount,
			"volume_per_unit": item.volume_per_unit,
			"metadata": item.metadata
		}

	# Rebuild display
	_rebuild_grid()

	grid_sorted.emit(sort_mode)
	print("✅ InventoryGrid: Sorted by %s" % sort_mode)

func _on_sort_button_pressed(sort_mode: String) -> void:
	"""Handle sort button press"""
	sort_items(sort_mode)

# ============================================================================
# SLOT EVENTS
# ============================================================================

func _on_slot_clicked(slot: ItemSlot, button_index: int) -> void:
	"""Handle slot click"""
	if slot.has_item():
		item_clicked.emit(slot.item_id, slot.amount, button_index)

func _on_slot_double_clicked(slot: ItemSlot) -> void:
	"""Handle slot double click"""
	if slot.has_item():
		item_double_clicked.emit(slot.item_id, slot.amount)

func _on_slot_right_clicked(slot: ItemSlot) -> void:
	"""Handle slot right click"""
	if slot.has_item():
		# Show context menu (TODO)
		print("Right clicked: %s" % slot.item_id)

func _on_item_dropped(slot: ItemSlot, item_data: Dictionary) -> void:
	"""Handle item dropped on slot"""
	var source_slot = item_data.get("source_slot", null)
	if not source_slot:
		return

	# TODO: Implement item transfer logic
	print("Item dropped: %s -> %s" % [source_slot, slot])

# ============================================================================
# PUBLIC API
# ============================================================================

func get_item_count() -> int:
	"""Get number of different item types"""
	return items.size()

func is_full() -> bool:
	"""Check if inventory is at capacity"""
	return used_capacity >= max_capacity

func is_empty() -> bool:
	"""Check if inventory is empty"""
	return items.is_empty()
