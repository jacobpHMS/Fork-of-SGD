extends Control
class_name InventoryList
## InventoryList - List-based inventory display
##
## Alternative to grid view. Displays items in a scrollable list
## with detailed information (name, amount, volume, actions).
##
## Features:
## - Compact list view with more info
## - Same drag & drop as grid
## - Sorting capabilities
## - Better for many items
## - Sci-Fi styled

# ============================================================================
# SIGNALS
# ============================================================================

signal item_clicked(item_id: String, amount: float, button_index: int)
signal item_double_clicked(item_id: String, amount: float)
signal item_added(item_id: String, amount: float)
signal item_removed(item_id: String, amount: float)
signal capacity_changed(used: float, max_capacity: float)
signal list_sorted(sort_mode: String)

# ============================================================================
# EXPORTS
# ============================================================================

@export_group("List Configuration")
@export var max_capacity: float = 1000.0  # m³
@export var allow_overflow: bool = false
@export var row_height: float = 32.0

@export_group("Features")
@export var show_capacity_bar: bool = true
@export var show_sort_buttons: bool = true
@export var show_icons: bool = true
@export var allow_drag_drop: bool = true

# ============================================================================
# STATE
# ============================================================================

var items: Dictionary = {}  # item_id -> {amount, volume_per_unit, metadata}
var list_items: Array = []  # Array of ListItemRow controls
var used_capacity: float = 0.0

# UI References
var list_container: VBoxContainer = null
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
	"""Build list UI"""
	var main_vbox = VBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(main_vbox)

	# Sort buttons (top)
	if show_sort_buttons:
		sort_buttons_container = _create_sort_buttons()
		main_vbox.add_child(sort_buttons_container)

	# Header row
	var header = _create_header_row()
	main_vbox.add_child(header)

	# Scroll container for list
	scroll_container = ScrollContainer.new()
	scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	main_vbox.add_child(scroll_container)

	# List container
	list_container = VBoxContainer.new()
	list_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_container.add_theme_constant_override("separation", 2)
	scroll_container.add_child(list_container)

	# Capacity bar (bottom)
	if show_capacity_bar:
		var capacity_container = _create_capacity_bar()
		main_vbox.add_child(capacity_container)

func _create_header_row() -> PanelContainer:
	"""Create header row with column labels"""
	var panel = PanelContainer.new()
	var style = theme.create_panel_style(SciFiTheme.PanelStyle.FLAT, SciFiTheme.BorderGlow.NONE)
	panel.add_theme_stylebox_override("panel", style)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 8)
	panel.add_child(hbox)

	if show_icons:
		var icon_label = Label.new()
		icon_label.text = ""
		icon_label.custom_minimum_size = Vector2(32, 0)
		hbox.add_child(icon_label)

	var name_label = _create_header_label("Item Name", 200)
	hbox.add_child(name_label)

	var amount_label = _create_header_label("Amount", 100)
	hbox.add_child(amount_label)

	var volume_label = _create_header_label("Volume", 100)
	hbox.add_child(volume_label)

	var total_label = _create_header_label("Total m³", 100)
	hbox.add_child(total_label)

	return panel

func _create_header_label(text: String, min_width: float) -> Label:
	"""Create header label"""
	var label = Label.new()
	label.text = text
	label.custom_minimum_size = Vector2(min_width, 0)
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)
	return label

func _create_sort_buttons() -> HBoxContainer:
	"""Create sorting buttons"""
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 4)

	var label = Label.new()
	label.text = "Sort:"
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", theme.COLOR_TEXT_SECONDARY)
	hbox.add_child(label)

	var btn_name = _create_sort_button("Name", "name")
	hbox.add_child(btn_name)

	var btn_amount = _create_sort_button("Amount", "amount")
	hbox.add_child(btn_amount)

	var btn_volume = _create_sort_button("Volume", "volume")
	hbox.add_child(btn_volume)

	var btn_type = _create_sort_button("Type", "type")
	hbox.add_child(btn_type)

	return hbox

func _create_sort_button(text: String, sort_mode: String) -> Button:
	"""Create a single sort button"""
	var btn = Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(60, 20)
	btn.add_theme_font_size_override("font_size", 9)

	btn.add_theme_stylebox_override("normal", theme.create_button_style("normal", theme.COLOR_ACCENT_CYAN))
	btn.add_theme_stylebox_override("hover", theme.create_button_style("hover", theme.COLOR_ACCENT_CYAN))
	btn.add_theme_stylebox_override("pressed", theme.create_button_style("pressed", theme.COLOR_ACCENT_CYAN))

	btn.pressed.connect(_on_sort_button_pressed.bind(sort_mode))

	return btn

func _create_capacity_bar() -> VBoxContainer:
	"""Create capacity indicator"""
	var vbox = VBoxContainer.new()

	capacity_label = Label.new()
	capacity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	capacity_label.add_theme_font_size_override("font_size", 10)
	capacity_label.add_theme_color_override("font_color", theme.COLOR_TEXT_SECONDARY)
	vbox.add_child(capacity_label)

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
	"""Add item to inventory"""
	var total_volume = amount * volume_per_unit
	var new_used = used_capacity + total_volume

	if not allow_overflow and new_used > max_capacity:
		push_warning("InventoryList: Capacity exceeded (%.1f/%.1f m³)" % [new_used, max_capacity])
		return false

	if items.has(item_id):
		items[item_id].amount += amount
	else:
		items[item_id] = {
			"amount": amount,
			"volume_per_unit": volume_per_unit,
			"metadata": metadata
		}

	used_capacity = new_used
	_rebuild_list()

	item_added.emit(item_id, amount)
	capacity_changed.emit(used_capacity, max_capacity)

	return true

func remove_item(item_id: String, amount: float) -> bool:
	"""Remove item from inventory"""
	if not items.has(item_id):
		return false

	var item = items[item_id]
	if item.amount < amount:
		return false

	var removed_volume = amount * item.volume_per_unit

	item.amount -= amount
	used_capacity -= removed_volume

	if item.amount <= 0:
		items.erase(item_id)

	_rebuild_list()

	item_removed.emit(item_id, amount)
	capacity_changed.emit(used_capacity, max_capacity)

	return true

func get_all_items() -> Dictionary:
	"""Get all items"""
	return items.duplicate(true)

func clear_all() -> void:
	"""Remove all items"""
	items.clear()
	used_capacity = 0.0
	_rebuild_list()
	capacity_changed.emit(used_capacity, max_capacity)

# ============================================================================
# LIST BUILDING
# ============================================================================

func _rebuild_list():
	"""Rebuild list with current items"""
	# Clear existing rows
	for row in list_items:
		row.queue_free()
	list_items.clear()

	# Create row for each item
	for item_id in items.keys():
		var item = items[item_id]
		var row = _create_list_row(item_id, item.amount, item.volume_per_unit, item.metadata)
		list_items.append(row)
		list_container.add_child(row)

	_update_capacity_display()

func _create_list_row(item_id: String, amount: float, volume_per_unit: float, metadata: Dictionary) -> PanelContainer:
	"""Create a list row for an item"""
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, row_height)

	var style = theme.create_panel_style(SciFiTheme.PanelStyle.FLAT, SciFiTheme.BorderGlow.NONE)
	style.bg_color = Color(0.08, 0.08, 0.12, 0.8)
	panel.add_theme_stylebox_override("panel", style)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 8)
	panel.add_child(hbox)

	# Icon
	if show_icons:
		var icon = TextureRect.new()
		icon.custom_minimum_size = Vector2(24, 24)
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		# icon.texture = AssetManager.get_item_icon(item_id)
		hbox.add_child(icon)

	# Item name
	var name_label = Label.new()
	name_label.text = item_id.capitalize()
	name_label.custom_minimum_size = Vector2(200, 0)
	name_label.add_theme_font_size_override("font_size", 10)
	name_label.add_theme_color_override("font_color", theme.COLOR_TEXT_PRIMARY)
	hbox.add_child(name_label)

	# Amount
	var amount_label = Label.new()
	amount_label.text = _format_amount(amount)
	amount_label.custom_minimum_size = Vector2(100, 0)
	amount_label.add_theme_font_size_override("font_size", 10)
	amount_label.add_theme_color_override("font_color", theme.COLOR_TEXT_SECONDARY)
	hbox.add_child(amount_label)

	# Volume per unit
	var volume_label = Label.new()
	volume_label.text = "%.2f m³" % volume_per_unit
	volume_label.custom_minimum_size = Vector2(100, 0)
	volume_label.add_theme_font_size_override("font_size", 10)
	volume_label.add_theme_color_override("font_color", theme.COLOR_TEXT_SECONDARY)
	hbox.add_child(volume_label)

	# Total volume
	var total_volume = amount * volume_per_unit
	var total_label = Label.new()
	total_label.text = "%.1f m³" % total_volume
	total_label.custom_minimum_size = Vector2(100, 0)
	total_label.add_theme_font_size_override("font_size", 10)
	total_label.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)
	hbox.add_child(total_label)

	# Store item data for event handling
	panel.set_meta("item_id", item_id)
	panel.set_meta("amount", amount)

	# Connect mouse events
	panel.gui_input.connect(_on_row_gui_input.bind(panel))

	return panel

func _format_amount(val: float) -> String:
	"""Format amount for display"""
	if val >= 1000000:
		return "%.1fM" % (val / 1000000.0)
	elif val >= 1000:
		return "%.1fK" % (val / 1000.0)
	elif val >= 100:
		return "%.0f" % val
	else:
		return "%.1f" % val

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

# ============================================================================
# SORTING
# ============================================================================

func sort_items(sort_mode: String) -> void:
	"""Sort items by mode"""
	var item_array = []

	for item_id in items.keys():
		var item = items[item_id]
		item_array.append({
			"id": item_id,
			"amount": item.amount,
			"volume_per_unit": item.volume_per_unit,
			"total_volume": item.amount * item.volume_per_unit,
			"metadata": item.metadata
		})

	match sort_mode:
		"name":
			item_array.sort_custom(func(a, b): return a.id < b.id)
		"amount":
			item_array.sort_custom(func(a, b): return a.amount > b.amount)
		"volume":
			item_array.sort_custom(func(a, b): return a.total_volume > b.total_volume)
		"type":
			item_array.sort_custom(func(a, b):
				var type_a = a.metadata.get("type", "")
				var type_b = b.metadata.get("type", "")
				return type_a < type_b
			)

	items.clear()
	for item in item_array:
		items[item.id] = {
			"amount": item.amount,
			"volume_per_unit": item.volume_per_unit,
			"metadata": item.metadata
		}

	_rebuild_list()
	list_sorted.emit(sort_mode)

func _on_sort_button_pressed(sort_mode: String) -> void:
	"""Handle sort button press"""
	sort_items(sort_mode)

# ============================================================================
# ROW EVENTS
# ============================================================================

func _on_row_gui_input(event: InputEvent, panel: PanelContainer) -> void:
	"""Handle row input events"""
	if event is InputEventMouseButton:
		var mb = event as InputEventMouseButton

		if mb.pressed:
			var item_id = panel.get_meta("item_id", "")
			var amount = panel.get_meta("amount", 0.0)

			if mb.button_index == MOUSE_BUTTON_LEFT:
				if mb.double_click:
					item_double_clicked.emit(item_id, amount)
				else:
					item_clicked.emit(item_id, amount, MOUSE_BUTTON_LEFT)

			elif mb.button_index == MOUSE_BUTTON_RIGHT:
				item_clicked.emit(item_id, amount, MOUSE_BUTTON_RIGHT)
