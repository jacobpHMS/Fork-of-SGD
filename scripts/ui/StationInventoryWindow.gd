extends Window
class_name StationInventoryWindow
## StationInventoryWindow - Station cargo/inventory management
##
## Similar to CargoWindow but designed for space stations with:
## - Larger capacity (10,000+ m³)
## - Station info display (name, type, modules)
## - Grid/List view toggle
## - Drag & Drop between ship cargo and station hangar
## - Service access buttons
##
## Features:
## - Massive storage capacity
## - Station module display
## - Market access integration
## - Refinery services
## - Sci-Fi styled UI

# ============================================================================
# SIGNALS
# ============================================================================

signal items_changed
signal view_mode_changed(mode: String)
signal service_requested(service_name: String)
signal transfer_to_ship_requested(item_id: String, amount: float)
signal transfer_from_ship_requested(item_id: String, amount: float)

# ============================================================================
# EXPORTS
# ============================================================================

@export_group("Window Configuration")
@export var window_title: String = "Station Hangar"
@export var default_capacity: float = 10000.0  # m³ (10x ship capacity)
@export var show_services_panel: bool = true

# ============================================================================
# VIEW MODE
# ============================================================================

enum ViewMode { GRID, LIST }

# ============================================================================
# STATE
# ============================================================================

var current_view_mode: ViewMode = ViewMode.GRID
var station_data: Node = null  # Reference to Station node
var player_ship: Node = null  # Reference to player's ship

# UI References
var inventory_grid: InventoryGrid = null
var inventory_list: InventoryList = null
var view_toggle_button: Button = null
var station_info_panel: PanelContainer = null
var services_panel: PanelContainer = null
var capacity_bar: ProgressBar = null
var capacity_label: Label = null
var transfer_panel: PanelContainer = null

var theme: SciFiTheme = null

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	theme = SciFiTheme.new()

	# Window setup
	title = window_title
	size = Vector2i(900, 700)
	min_size = Vector2i(600, 400)
	position = Vector2i(200, 100)

	# Make draggable
	unresizable = false
	always_on_top = false

	# Apply theme
	_apply_window_theme()

	# Build UI
	_build_ui()

	# Setup drag & drop integration
	_setup_drag_drop()

	print("✅ StationInventoryWindow initialized")

func _apply_window_theme() -> void:
	"""Apply Sci-Fi theme to window"""
	# Window background
	var bg_style = theme.create_panel_style(SciFiTheme.PanelStyle.STANDARD, SciFiTheme.BorderGlow.MEDIUM)
	add_theme_stylebox_override("embedded_border", bg_style)

# ============================================================================
# UI BUILDING
# ============================================================================

func _build_ui():
	"""Build complete station inventory UI"""
	var main_vbox = VBoxContainer.new()
	main_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(main_vbox)

	# Header (Station info + View toggle)
	var header = _create_header()
	main_vbox.add_child(header)

	# Separator
	main_vbox.add_child(theme.create_separator())

	# Main content (HBox with inventory and services)
	var content_hbox = HBoxContainer.new()
	content_hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(content_hbox)

	# Left side: Inventory (Grid/List)
	var inventory_container = _create_inventory_section()
	inventory_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_hbox.add_child(inventory_container)

	# Right side: Services panel (if enabled)
	if show_services_panel:
		services_panel = _create_services_panel()
		services_panel.custom_minimum_size = Vector2(200, 0)
		content_hbox.add_child(services_panel)

	# Footer (Capacity + Transfer buttons)
	var footer = _create_footer()
	main_vbox.add_child(footer)

func _create_header() -> HBoxContainer:
	"""Create header with station info and controls"""
	var header = HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)

	# Station info panel
	station_info_panel = PanelContainer.new()
	var info_style = theme.create_panel_style(SciFiTheme.PanelStyle.TACTICAL, SciFiTheme.BorderGlow.SUBTLE)
	station_info_panel.add_theme_stylebox_override("panel", info_style)
	station_info_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(station_info_panel)

	var info_vbox = VBoxContainer.new()
	station_info_panel.add_child(info_vbox)

	var station_name_label = Label.new()
	station_name_label.name = "StationNameLabel"
	station_name_label.text = window_title
	theme.apply_title_style(station_name_label, theme.COLOR_ACCENT_CYAN)
	info_vbox.add_child(station_name_label)

	var station_type_label = Label.new()
	station_type_label.name = "StationTypeLabel"
	station_type_label.text = "Station Type: Unknown"
	theme.apply_small_style(station_type_label)
	info_vbox.add_child(station_type_label)

	# View toggle button
	view_toggle_button = Button.new()
	view_toggle_button.text = "Switch to List View"
	view_toggle_button.custom_minimum_size = Vector2(150, 40)
	theme.apply_button_style(view_toggle_button, theme.COLOR_ACCENT_CYAN)
	view_toggle_button.pressed.connect(_on_view_toggle_pressed)
	header.add_child(view_toggle_button)

	# Close button
	var close_btn = Button.new()
	close_btn.text = "✕ Close"
	close_btn.custom_minimum_size = Vector2(80, 40)
	theme.apply_button_style(close_btn, theme.COLOR_STATUS_DANGER)
	close_btn.pressed.connect(hide)
	header.add_child(close_btn)

	return header

func _create_inventory_section() -> VBoxContainer:
	"""Create inventory section with Grid and List views"""
	var vbox = VBoxContainer.new()

	# Grid view
	inventory_grid = InventoryGrid.new()
	inventory_grid.columns = 10  # Wider grid for stations
	inventory_grid.max_capacity = default_capacity
	inventory_grid.show_capacity_bar = false  # We'll show it in footer
	inventory_grid.visible = true
	inventory_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(inventory_grid)

	# List view
	inventory_list = InventoryList.new()
	inventory_list.max_capacity = default_capacity
	inventory_list.show_capacity_bar = false
	inventory_list.visible = false
	inventory_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(inventory_list)

	# Connect signals
	inventory_grid.capacity_changed.connect(_on_capacity_changed)
	inventory_list.capacity_changed.connect(_on_capacity_changed)

	return vbox

func _create_services_panel() -> PanelContainer:
	"""Create services panel (Market, Refinery, Repair, etc.)"""
	var panel = PanelContainer.new()
	var panel_style = theme.create_panel_style(SciFiTheme.PanelStyle.ENGINEERING, SciFiTheme.BorderGlow.SUBTLE)
	panel.add_theme_stylebox_override("panel", panel_style)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	panel.add_child(vbox)

	# Title
	var title = Label.new()
	title.text = "⚙ STATION SERVICES"
	theme.apply_header_style(title)
	title.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)
	vbox.add_child(title)

	vbox.add_child(theme.create_separator())

	# Services buttons
	var services = [
		{"name": "Market", "icon": "💰", "description": "Buy/Sell items"},
		{"name": "Refinery", "icon": "⚒", "description": "Refine ore"},
		{"name": "Manufacturing", "icon": "🏭", "description": "Craft items"},
		{"name": "Repair", "icon": "🔧", "description": "Repair ship"},
		{"name": "Hangar", "icon": "🚀", "description": "Store ships"},
		{"name": "Clone Bay", "icon": "🧬", "description": "Medical services"}
	]

	for service in services:
		var btn = _create_service_button(service.name, service.icon, service.description)
		vbox.add_child(btn)

	return panel

func _create_service_button(service_name: String, icon: String, description: String) -> Button:
	"""Create a service button"""
	var btn = Button.new()
	btn.text = "%s %s" % [icon, service_name]
	btn.tooltip_text = description
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.custom_minimum_size = Vector2(0, 35)

	# Apply theme
	var btn_color = theme.COLOR_ACCENT_CYAN
	btn.add_theme_stylebox_override("normal", theme.create_button_style("normal", btn_color))
	btn.add_theme_stylebox_override("hover", theme.create_button_style("hover", btn_color))
	btn.add_theme_stylebox_override("pressed", theme.create_button_style("pressed", btn_color))

	btn.pressed.connect(_on_service_button_pressed.bind(service_name))

	return btn

func _create_footer() -> VBoxContainer:
	"""Create footer with capacity bar and transfer buttons"""
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)

	# Capacity display
	capacity_label = Label.new()
	capacity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	theme.apply_body_style(capacity_label)
	vbox.add_child(capacity_label)

	var progress_styles = theme.create_progressbar_style(theme.COLOR_ACCENT_CYAN)
	capacity_bar = ProgressBar.new()
	capacity_bar.min_value = 0
	capacity_bar.max_value = default_capacity
	capacity_bar.value = 0
	capacity_bar.show_percentage = false
	capacity_bar.add_theme_stylebox_override("background", progress_styles.background)
	capacity_bar.add_theme_stylebox_override("fill", progress_styles.fill)
	vbox.add_child(capacity_bar)

	# Transfer buttons
	var transfer_hbox = HBoxContainer.new()
	transfer_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	transfer_hbox.add_theme_constant_override("separation", 8)
	vbox.add_child(transfer_hbox)

	var to_ship_btn = Button.new()
	to_ship_btn.text = "⬇ Transfer to Ship"
	to_ship_btn.custom_minimum_size = Vector2(150, 35)
	theme.apply_button_style(to_ship_btn, theme.COLOR_STATUS_ACTIVE)
	to_ship_btn.pressed.connect(_on_transfer_to_ship_pressed)
	transfer_hbox.add_child(to_ship_btn)

	var from_ship_btn = Button.new()
	from_ship_btn.text = "⬆ Transfer from Ship"
	from_ship_btn.custom_minimum_size = Vector2(150, 35)
	theme.apply_button_style(from_ship_btn, theme.COLOR_STATUS_ACTIVE)
	from_ship_btn.pressed.connect(_on_transfer_from_ship_pressed)
	transfer_hbox.add_child(from_ship_btn)

	_update_capacity_display()

	return vbox

# ============================================================================
# DRAG & DROP SETUP
# ============================================================================

func _setup_drag_drop():
	"""Setup drag & drop integration with DragManager"""
	if DragManager:
		# Connect to drag manager events
		pass  # DragManager integration via ItemSlot signals

# ============================================================================
# DATA MANAGEMENT
# ============================================================================

func set_station(station: Node) -> void:
	"""Bind window to a station node"""
	station_data = station

	if not station:
		return

	# Update UI with station info
	if station_info_panel:
		var name_label = station_info_panel.get_node_or_null("VBoxContainer/StationNameLabel")
		if name_label:
			name_label.text = station.station_name if station.has("station_name") else "Unknown Station"

		var type_label = station_info_panel.get_node_or_null("VBoxContainer/StationTypeLabel")
		if type_label and station.has("station_type"):
			var type_str = Station.StationType.keys()[station.station_type]
			type_label.text = "Station Type: %s" % type_str

	# Load station cargo data (if available)
	if station.has("cargo_items"):
		_load_cargo_data(station.cargo_items)

	print("✅ StationInventoryWindow bound to station: %s" % station.station_name if station.has("station_name") else "Unknown")

func set_player_ship(ship: Node) -> void:
	"""Set reference to player ship for transfers"""
	player_ship = ship

func _load_cargo_data(cargo_data: Dictionary):
	"""Load cargo data into both Grid and List views"""
	inventory_grid.clear_all()
	inventory_list.clear_all()

	for item_id in cargo_data.keys():
		var item = cargo_data[item_id]
		var amount = item.get("amount", 0.0)
		var volume = item.get("volume_per_unit", 1.0)
		var metadata = item.get("metadata", {})

		inventory_grid.add_item(item_id, amount, volume, metadata)
		inventory_list.add_item(item_id, amount, volume, metadata)

func get_cargo_data() -> Dictionary:
	"""Get current cargo as dictionary"""
	if current_view_mode == ViewMode.GRID:
		return inventory_grid.get_all_items()
	else:
		return inventory_list.get_all_items()

# ============================================================================
# VIEW SWITCHING
# ============================================================================

func _switch_to_view(mode: ViewMode):
	"""Switch between Grid and List view"""
	current_view_mode = mode

	if mode == ViewMode.GRID:
		# Sync data from List to Grid
		_sync_data_to_grid()
		inventory_grid.visible = true
		inventory_list.visible = false
		view_toggle_button.text = "Switch to List View"
	else:
		# Sync data from Grid to List
		_sync_data_to_list()
		inventory_grid.visible = false
		inventory_list.visible = true
		view_toggle_button.text = "Switch to Grid View"

	view_mode_changed.emit(ViewMode.keys()[mode])

func _sync_data_to_grid():
	"""Sync List data to Grid"""
	var list_items = inventory_list.get_all_items()
	inventory_grid.clear_all()

	for item_id in list_items.keys():
		var item = list_items[item_id]
		inventory_grid.add_item(item_id, item.amount, item.volume_per_unit, item.metadata)

func _sync_data_to_list():
	"""Sync Grid data to List"""
	var grid_items = inventory_grid.get_all_items()
	inventory_list.clear_all()

	for item_id in grid_items.keys():
		var item = grid_items[item_id]
		inventory_list.add_item(item_id, item.amount, item.volume_per_unit, item.metadata)

# ============================================================================
# CAPACITY DISPLAY
# ============================================================================

func _update_capacity_display():
	"""Update capacity bar and label"""
	var used = inventory_grid.used_capacity if current_view_mode == ViewMode.GRID else inventory_list.used_capacity
	var max_cap = inventory_grid.max_capacity if current_view_mode == ViewMode.GRID else inventory_list.max_capacity

	if capacity_bar:
		capacity_bar.value = used
		capacity_bar.max_value = max_cap

	if capacity_label:
		var percent = (used / max_cap * 100.0) if max_cap > 0 else 0.0
		capacity_label.text = "Station Hangar Capacity: %.1f / %.1f m³ (%.0f%%)" % [used, max_cap, percent]

		# Color code based on usage
		if percent > 90:
			capacity_label.add_theme_color_override("font_color", theme.COLOR_STATUS_DANGER)
		elif percent > 75:
			capacity_label.add_theme_color_override("font_color", theme.COLOR_STATUS_WARNING)
		else:
			capacity_label.add_theme_color_override("font_color", theme.COLOR_STATUS_ACTIVE)

# ============================================================================
# CALLBACKS
# ============================================================================

func _on_view_toggle_pressed():
	"""Handle view toggle button"""
	if current_view_mode == ViewMode.GRID:
		_switch_to_view(ViewMode.LIST)
	else:
		_switch_to_view(ViewMode.GRID)

func _on_capacity_changed(_used: float, _max: float):
	"""Handle capacity changes"""
	_update_capacity_display()
	items_changed.emit()

func _on_service_button_pressed(service_name: String):
	"""Handle service button press"""
	service_requested.emit(service_name)
	print("🏗️ Station service requested: %s" % service_name)

func _on_transfer_to_ship_pressed():
	"""Handle transfer to ship button"""
	# TODO: Implement transfer dialog/logic
	print("⬇ Transfer to ship requested")

func _on_transfer_from_ship_pressed():
	"""Handle transfer from ship button"""
	# TODO: Implement transfer dialog/logic
	print("⬆ Transfer from ship requested")

# ============================================================================
# PUBLIC API
# ============================================================================

func add_item(item_id: String, amount: float, volume_per_unit: float = 1.0, metadata: Dictionary = {}) -> bool:
	"""Add item to station hangar"""
	var success = false

	if current_view_mode == ViewMode.GRID:
		success = inventory_grid.add_item(item_id, amount, volume_per_unit, metadata)
		if success:
			inventory_list.add_item(item_id, amount, volume_per_unit, metadata)
	else:
		success = inventory_list.add_item(item_id, amount, volume_per_unit, metadata)
		if success:
			inventory_grid.add_item(item_id, amount, volume_per_unit, metadata)

	if success:
		items_changed.emit()

	return success

func remove_item(item_id: String, amount: float) -> bool:
	"""Remove item from station hangar"""
	var success = false

	if current_view_mode == ViewMode.GRID:
		success = inventory_grid.remove_item(item_id, amount)
		if success:
			inventory_list.remove_item(item_id, amount)
	else:
		success = inventory_list.remove_item(item_id, amount)
		if success:
			inventory_grid.remove_item(item_id, amount)

	if success:
		items_changed.emit()

	return success

func get_item_amount(item_id: String) -> float:
	"""Get amount of specific item"""
	if current_view_mode == ViewMode.GRID:
		return inventory_grid.get_item_amount(item_id)
	else:
		return inventory_list.get_item_amount(item_id)

func clear_all():
	"""Clear all items"""
	inventory_grid.clear_all()
	inventory_list.clear_all()
	items_changed.emit()
