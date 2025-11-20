extends PanelContainer
class_name CargoWindow
## CargoWindow - Modern cargo hold management with Grid/List toggle
##
## Displays cargo inventory with toggle between Grid and List view.
## Supports drag & drop between cargo windows and stations.
##
## Features:
## - Grid/List view toggle
## - Drag & Drop support (via DragManager)
## - Sorting capabilities
## - Capacity management
## - Sci-Fi styled
## - Draggable window

# ============================================================================
# ENUMS
# ============================================================================

enum ViewMode {
	GRID,
	LIST
}

# ============================================================================
# STATE
# ============================================================================

var cargo_type: int = 0
var player_node: Node = null
var current_view_mode: ViewMode = ViewMode.GRID
var theme: SciFiTheme = null

# Window dragging
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

# UI References
var title_label: Label = null
var close_btn: Button = null
var capacity_label: Label = null
var view_toggle_button: Button = null
var inventory_grid: InventoryGrid = null
var inventory_list: InventoryList = null
var view_container: Control = null

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	theme = SciFiTheme.new()

	# Build UI
	_build_ui()

	# Apply theme
	_apply_cargo_theme()

	# Register as drop zone
	if DragManager:
		DragManager.register_drop_zone(self, _can_drop_item)

	# Load cargo data
	_load_cargo_data()

	print("✅ CargoWindow initialized: Type %d" % cargo_type)

func _process(_delta):
	# Regular cargo update (if player exists)
	if player_node:
		_sync_cargo_from_player()

func _gui_input(event):
	"""Handle window dragging"""
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Check if click is in title bar region
				var local_pos = event.position
				if local_pos.y < 50:  # Title bar area
					is_dragging = true
					drag_offset = global_position - get_global_mouse_position()
			else:
				is_dragging = false

	elif event is InputEventMouseMotion:
		if is_dragging:
			global_position = get_global_mouse_position() + drag_offset
			_clamp_to_screen()

func _clamp_to_screen():
	"""Keep window within screen bounds"""
	var screen_size = get_viewport_rect().size
	var window_size = size

	global_position.x = clamp(global_position.x, 0, screen_size.x - window_size.x)
	global_position.y = clamp(global_position.y, 0, screen_size.y - window_size.y)

# ============================================================================
# UI BUILDING
# ============================================================================

func _build_ui():
	"""Build cargo window UI"""
	custom_minimum_size = Vector2(600, 500)

	var main_vbox = VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 8)
	add_child(main_vbox)

	# Title bar
	var title_bar = _create_title_bar()
	main_vbox.add_child(title_bar)

	main_vbox.add_child(_create_separator())

	# Capacity label
	capacity_label = Label.new()
	capacity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	capacity_label.add_theme_font_size_override("font_size", 11)
	capacity_label.add_theme_color_override("font_color", theme.COLOR_STATUS_ACTIVE)
	main_vbox.add_child(capacity_label)

	# View toggle button
	view_toggle_button = Button.new()
	view_toggle_button.text = "Switch to List View"
	view_toggle_button.add_theme_stylebox_override("normal", theme.create_button_style("normal", theme.COLOR_ACCENT_CYAN))
	view_toggle_button.add_theme_stylebox_override("hover", theme.create_button_style("hover", theme.COLOR_ACCENT_CYAN))
	view_toggle_button.add_theme_stylebox_override("pressed", theme.create_button_style("pressed", theme.COLOR_ACCENT_CYAN))
	view_toggle_button.pressed.connect(_on_view_toggle_pressed)
	main_vbox.add_child(view_toggle_button)

	main_vbox.add_child(_create_separator())

	# View container (holds grid or list)
	view_container = Control.new()
	view_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	view_container.custom_minimum_size = Vector2(0, 300)
	main_vbox.add_child(view_container)

	# Create both views
	_create_grid_view()
	_create_list_view()

	# Show grid by default
	_switch_to_view(ViewMode.GRID)

func _create_title_bar() -> HBoxContainer:
	"""Create title bar with cargo type and close button"""
	var hbox = HBoxContainer.new()
	hbox.custom_minimum_size = Vector2(0, 40)

	title_label = Label.new()
	title_label.text = _get_cargo_type_name()
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.add_theme_font_size_override("font_size", 16)
	title_label.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hbox.add_child(title_label)

	close_btn = Button.new()
	close_btn.text = "✕"
	close_btn.custom_minimum_size = Vector2(40, 40)
	close_btn.add_theme_stylebox_override("normal", theme.create_button_style("normal", theme.COLOR_STATUS_DANGER))
	close_btn.add_theme_stylebox_override("hover", theme.create_button_style("hover", theme.COLOR_STATUS_DANGER))
	close_btn.add_theme_stylebox_override("pressed", theme.create_button_style("pressed", theme.COLOR_STATUS_DANGER))
	close_btn.pressed.connect(_on_close_pressed)
	hbox.add_child(close_btn)

	return hbox

func _create_separator() -> HSeparator:
	"""Create styled separator"""
	var sep = HSeparator.new()
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = theme.COLOR_ACCENT_CYAN
	stylebox.content_margin_top = 1
	stylebox.content_margin_bottom = 1
	sep.add_theme_stylebox_override("separator", stylebox)
	return sep

func _create_grid_view():
	"""Create grid inventory view"""
	inventory_grid = InventoryGrid.new()
	inventory_grid.columns = 8
	inventory_grid.slot_size = Vector2(64, 64)
	inventory_grid.slot_spacing = 4
	inventory_grid.show_capacity_bar = false  # We have our own
	inventory_grid.show_sort_buttons = true
	inventory_grid.allow_drag_drop = true
	inventory_grid.name = "InventoryGrid"
	inventory_grid.visible = false
	inventory_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inventory_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Connect signals
	inventory_grid.capacity_changed.connect(_on_capacity_changed)
	inventory_grid.item_double_clicked.connect(_on_item_double_clicked)

	view_container.add_child(inventory_grid)

func _create_list_view():
	"""Create list inventory view"""
	inventory_list = InventoryList.new()
	inventory_list.show_capacity_bar = false  # We have our own
	inventory_list.show_sort_buttons = true
	inventory_list.show_icons = true
	inventory_list.allow_drag_drop = true
	inventory_list.name = "InventoryList"
	inventory_list.visible = false
	inventory_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inventory_list.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Connect signals
	inventory_list.capacity_changed.connect(_on_capacity_changed)
	inventory_list.item_double_clicked.connect(_on_item_double_clicked)

	view_container.add_child(inventory_list)

# ============================================================================
# THEMING
# ============================================================================

func _apply_cargo_theme():
	"""Apply Sci-Fi theme to window"""
	var panel_style = theme.create_panel_style(SciFiTheme.PanelStyle.STANDARD, SciFiTheme.BorderGlow.MEDIUM)
	add_theme_stylebox_override("panel", panel_style)

# ============================================================================
# CARGO TYPE
# ============================================================================

func set_cargo_type(type: int):
	"""Set cargo type"""
	cargo_type = type
	if title_label:
		title_label.text = _get_cargo_type_name()

func set_player_node(player: Node):
	"""Set player reference"""
	player_node = player
	_load_cargo_data()

func _get_cargo_type_name() -> String:
	"""Get localized cargo type name"""
	match cargo_type:
		0: return "General Cargo" if not Localization else Localization.translate("UI_GENERAL_CARGO")
		1: return "Ore Cargo" if not Localization else Localization.translate("UI_ORE_CARGO")
		2: return "Mineral Cargo" if not Localization else Localization.translate("UI_MINERAL_CARGO")
		3: return "Ammo Cargo" if not Localization else Localization.translate("UI_AMMO_CARGO")
		4: return "Build Cargo" if not Localization else Localization.translate("UI_BUILD_CARGO")
		5: return "Gas Cargo" if not Localization else Localization.translate("UI_GAS_CARGO")
	return "Cargo"

# ============================================================================
# VIEW SWITCHING
# ============================================================================

func _switch_to_view(mode: ViewMode):
	"""Switch between grid and list view"""
	current_view_mode = mode

	if mode == ViewMode.GRID:
		if inventory_grid:
			inventory_grid.visible = true
		if inventory_list:
			inventory_list.visible = false
		view_toggle_button.text = "Switch to List View"
	else:
		if inventory_grid:
			inventory_grid.visible = false
		if inventory_list:
			inventory_list.visible = true
		view_toggle_button.text = "Switch to Grid View"

func _on_view_toggle_pressed():
	"""Handle view toggle button"""
	if current_view_mode == ViewMode.GRID:
		_switch_to_view(ViewMode.LIST)
		_sync_data_to_list()
	else:
		_switch_to_view(ViewMode.GRID)
		_sync_data_to_grid()

func _sync_data_to_grid():
	"""Sync data from list to grid"""
	if not inventory_list or not inventory_grid:
		return

	var items = inventory_list.get_all_items()
	inventory_grid.clear_all()

	for item_id in items.keys():
		var item = items[item_id]
		inventory_grid.add_item(item_id, item.amount, item.volume_per_unit, item.metadata)

func _sync_data_to_list():
	"""Sync data from grid to list"""
	if not inventory_list or not inventory_grid:
		return

	var items = inventory_grid.get_all_items()
	inventory_list.clear_all()

	for item_id in items.keys():
		var item = items[item_id]
		inventory_list.add_item(item_id, item.amount, item.volume_per_unit, item.metadata)

# ============================================================================
# CARGO DATA
# ============================================================================

func _load_cargo_data():
	"""Load cargo data from player"""
	if not player_node or not is_node_ready():
		return

	if not player_node.has_method("get_cargo_hold_info"):
		push_warning("CargoWindow: Player missing get_cargo_hold_info() method")
		return

	var cargo_info = player_node.get_cargo_hold_info(cargo_type)
	var capacity = cargo_info.get("capacity", 1000.0)

	# Set capacity for both views
	if inventory_grid:
		inventory_grid.set_max_capacity(capacity)
	if inventory_list:
		inventory_list.set_max_capacity(capacity)

	# Load items from player cargo
	_sync_cargo_from_player()

func _sync_cargo_from_player():
	"""Sync cargo from player (called regularly)"""
	if not player_node or not is_node_ready():
		return

	# TODO: Implement actual sync with player cargo system
	# For now this is a placeholder

func update_cargo_display():
	"""Update cargo display (legacy compatibility)"""
	_sync_cargo_from_player()

# ============================================================================
# DRAG & DROP (DragManager Integration)
# ============================================================================

func _can_drop_item(drag_data: Dictionary, _drop_zone: Control) -> bool:
	"""Check if item can be dropped here"""
	# Can't drop if same cargo type (no point)
	if drag_data.get("source_cargo_type", -1) == cargo_type:
		return false

	# Check if this cargo type can accept the item
	var item_id = drag_data.get("item_id", "")
	var target_type = player_node.get_cargo_type_for_item(item_id) if player_node and player_node.has_method("get_cargo_type_for_item") else -1

	# Can drop if:
	# 1. This is GENERAL cargo (accepts anything)
	# 2. This cargo type matches the item type
	return cargo_type == 0 or cargo_type == target_type

func on_item_dropped(drag_data: Dictionary) -> bool:
	"""Handle item dropped into this cargo hold"""
	if not player_node:
		return false

	var item_id = drag_data.get("item_id", "")
	var amount = drag_data.get("drag_amount", drag_data.get("amount", 0.0))
	var source_type = drag_data.get("source_cargo_type", -1)

	print("Attempting to move %.1f of %s from %d to %d" % [amount, item_id, source_type, cargo_type])

	# Move item between cargo holds
	if player_node.has_method("move_cargo_between_holds"):
		var success = player_node.move_cargo_between_holds(item_id, amount, source_type, cargo_type)
		if success:
			print("✅ Successfully moved cargo")
			_sync_cargo_from_player()
			return true
		else:
			print("❌ Failed to move cargo")
			return false

	return false

# ============================================================================
# ITEM EVENTS
# ============================================================================

func _on_capacity_changed(used: float, max_capacity: float):
	"""Handle capacity changed"""
	_update_capacity_label()

func _on_item_double_clicked(item_id: String, amount: float):
	"""Handle item double clicked"""
	print("CargoWindow: Item double clicked - %s x%.1f" % [item_id, amount])
	# TODO: Implement quick use/transfer action

# ============================================================================
# CAPACITY DISPLAY
# ============================================================================

func _update_capacity_label():
	"""Update capacity label"""
	if not capacity_label:
		return

	var active_inventory = inventory_grid if current_view_mode == ViewMode.GRID else inventory_list
	if not active_inventory:
		return

	var used = active_inventory.used_capacity
	var max_cap = active_inventory.max_capacity
	var percent = (used / max_cap * 100.0) if max_cap > 0 else 0.0

	capacity_label.text = "Capacity: %.1f / %.1f m³ (%.0f%%)" % [used, max_cap, percent]

	# Color code
	if percent > 90:
		capacity_label.add_theme_color_override("font_color", theme.COLOR_STATUS_DANGER)
	elif percent > 75:
		capacity_label.add_theme_color_override("font_color", theme.COLOR_STATUS_WARNING)
	else:
		capacity_label.add_theme_color_override("font_color", theme.COLOR_STATUS_ACTIVE)

# ============================================================================
# WINDOW CONTROL
# ============================================================================

func _on_close_pressed():
	"""Handle close button"""
	visible = false

# ============================================================================
# PUBLIC API
# ============================================================================

func add_item(item_id: String, amount: float, volume_per_unit: float, metadata: Dictionary = {}) -> bool:
	"""Add item to cargo"""
	var active_inventory = inventory_grid if current_view_mode == ViewMode.GRID else inventory_list
	if active_inventory:
		return active_inventory.add_item(item_id, amount, volume_per_unit, metadata)
	return false

func remove_item(item_id: String, amount: float) -> bool:
	"""Remove item from cargo"""
	var active_inventory = inventory_grid if current_view_mode == ViewMode.GRID else inventory_list
	if active_inventory:
		return active_inventory.remove_item(item_id, amount)
	return false

func get_all_items() -> Dictionary:
	"""Get all items in cargo"""
	var active_inventory = inventory_grid if current_view_mode == ViewMode.GRID else inventory_list
	if active_inventory:
		return active_inventory.get_all_items()
	return {}

func clear_cargo() -> void:
	"""Clear all cargo"""
	if inventory_grid:
		inventory_grid.clear_all()
	if inventory_list:
		inventory_list.clear_all()
