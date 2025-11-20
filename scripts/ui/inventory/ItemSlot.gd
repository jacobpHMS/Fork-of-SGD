extends PanelContainer
class_name ItemSlot
## ItemSlot - Individual inventory slot for grid/list view
##
## Represents a single slot that can hold an item stack.
## Supports drag & drop, visual feedback, and item information display.
##
## Features:
## - Holds item_id, amount, and metadata
## - Visual feedback (hover, selected, occupied)
## - Drag & Drop support
## - Tooltip with item info
## - Sci-Fi styled

# ============================================================================
# SIGNALS
# ============================================================================

signal slot_clicked(slot: ItemSlot, button_index: int)
signal slot_double_clicked(slot: ItemSlot)
signal slot_right_clicked(slot: ItemSlot)
signal item_dragged(slot: ItemSlot, item_data: Dictionary)
signal item_dropped(slot: ItemSlot, item_data: Dictionary)
signal item_hover_started(slot: ItemSlot)
signal item_hover_ended(slot: ItemSlot)

# ============================================================================
# EXPORTS
# ============================================================================

@export_group("Slot Configuration")
@export var slot_size: Vector2 = Vector2(64, 64)
@export var show_amount: bool = true
@export var show_volume: bool = true
@export var allow_drag: bool = true
@export var allow_drop: bool = true

@export_group("Visual")
@export var highlight_on_hover: bool = true
@export var show_empty_slot: bool = true

# ============================================================================
# ITEM DATA
# ============================================================================

var item_id: String = ""
var amount: float = 0.0
var volume_per_unit: float = 0.0
var metadata: Dictionary = {}

# ============================================================================
# REFERENCES
# ============================================================================

var icon_texture: TextureRect = null
var amount_label: Label = null
var volume_label: Label = null
var selection_overlay: Panel = null

# State
var is_hovered: bool = false
var is_selected: bool = false
var theme: SciFiTheme = null

# Drag & Drop
var is_dragging: bool = false
var drag_preview: Control = null

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	theme = SciFiTheme.new()

	custom_minimum_size = slot_size

	# Apply slot styling
	_apply_slot_theme()

	# Build UI
	_build_slot_ui()

	# Connect mouse events
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	# Update display
	_update_display()

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		var mb = event as InputEventMouseButton

		if mb.pressed:
			if mb.button_index == MOUSE_BUTTON_LEFT:
				if mb.double_click:
					slot_double_clicked.emit(self)
				else:
					slot_clicked.emit(self, MOUSE_BUTTON_LEFT)

					# Start drag if item exists and drag allowed
					if has_item() and allow_drag:
						_start_drag()

			elif mb.button_index == MOUSE_BUTTON_RIGHT:
				slot_right_clicked.emit(self)
				slot_clicked.emit(self, MOUSE_BUTTON_RIGHT)

# ============================================================================
# UI BUILDING
# ============================================================================

func _build_slot_ui():
	"""Build slot UI structure"""
	# Main container
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 2)
	margin.add_theme_constant_override("margin_right", 2)
	margin.add_theme_constant_override("margin_top", 2)
	margin.add_theme_constant_override("margin_bottom", 2)
	add_child(margin)

	# Overlay for all content
	var overlay = Control.new()
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(overlay)

	# Icon
	icon_texture = TextureRect.new()
	icon_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_texture.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	icon_texture.size_flags_vertical = Control.SIZE_EXPAND_FILL
	overlay.add_child(icon_texture)

	# Amount label (bottom-right)
	amount_label = Label.new()
	amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	amount_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	amount_label.add_theme_font_size_override("font_size", 10)
	amount_label.add_theme_color_override("font_color", Color.WHITE)
	amount_label.add_theme_color_override("font_outline_color", Color.BLACK)
	amount_label.add_theme_constant_override("outline_size", 2)
	amount_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	amount_label.anchors_preset = Control.PRESET_BOTTOM_RIGHT
	amount_label.offset_left = -50
	amount_label.offset_top = -20
	amount_label.offset_right = -2
	amount_label.offset_bottom = -2
	overlay.add_child(amount_label)

	# Volume label (top-right)
	volume_label = Label.new()
	volume_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	volume_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	volume_label.add_theme_font_size_override("font_size", 8)
	volume_label.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)
	volume_label.add_theme_color_override("font_outline_color", Color.BLACK)
	volume_label.add_theme_constant_override("outline_size", 1)
	volume_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	volume_label.anchors_preset = Control.PRESET_TOP_RIGHT
	volume_label.offset_left = -50
	volume_label.offset_top = 2
	volume_label.offset_right = -2
	volume_label.offset_bottom = 15
	overlay.add_child(volume_label)

	# Selection overlay
	selection_overlay = Panel.new()
	selection_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	selection_overlay.visible = false
	selection_overlay.anchors_preset = Control.PRESET_FULL_RECT

	var selection_style = StyleBoxFlat.new()
	selection_style.bg_color = Color(0.0, 0.8, 1.0, 0.3)
	selection_style.border_width_all = 2
	selection_style.border_color = theme.COLOR_ACCENT_CYAN
	selection_overlay.add_theme_stylebox_override("panel", selection_style)

	overlay.add_child(selection_overlay)

# ============================================================================
# THEMING
# ============================================================================

func _apply_slot_theme():
	"""Apply Sci-Fi theme to slot"""
	var style = StyleBoxFlat.new()

	if has_item():
		# Occupied slot
		style.bg_color = Color(0.1, 0.15, 0.2, 0.9)
		style.border_color = theme.COLOR_ACCENT_CYAN
	else:
		# Empty slot
		if show_empty_slot:
			style.bg_color = Color(0.05, 0.05, 0.08, 0.7)
			style.border_color = Color(0.2, 0.25, 0.3, 1.0)
		else:
			style.bg_color = Color(0.05, 0.05, 0.08, 0.5)
			style.border_color = Color(0.15, 0.15, 0.2, 1.0)

	style.border_width_all = 1
	style.corner_radius_top_left = 2
	style.corner_radius_top_right = 2
	style.corner_radius_bottom_left = 2
	style.corner_radius_bottom_right = 2

	add_theme_stylebox_override("panel", style)

func _update_hover_style():
	"""Update style when hovering"""
	if not highlight_on_hover:
		return

	var style = StyleBoxFlat.new()

	if is_hovered:
		style.bg_color = Color(0.15, 0.2, 0.3, 0.95)
		style.border_color = theme.COLOR_ACCENT_CYAN.lightened(0.3)
		style.border_width_all = 2
	else:
		if has_item():
			style.bg_color = Color(0.1, 0.15, 0.2, 0.9)
			style.border_color = theme.COLOR_ACCENT_CYAN
		else:
			style.bg_color = Color(0.05, 0.05, 0.08, 0.7)
			style.border_color = Color(0.2, 0.25, 0.3, 1.0)
		style.border_width_all = 1

	style.corner_radius_top_left = 2
	style.corner_radius_top_right = 2
	style.corner_radius_bottom_left = 2
	style.corner_radius_bottom_right = 2

	add_theme_stylebox_override("panel", style)

# ============================================================================
# ITEM MANAGEMENT
# ============================================================================

func set_item(item_id_val: String, amount_val: float, volume_per_unit_val: float = 0.0, meta: Dictionary = {}) -> void:
	"""Set item in this slot"""
	item_id = item_id_val
	amount = amount_val
	volume_per_unit = volume_per_unit_val
	metadata = meta

	_update_display()
	_apply_slot_theme()

func clear_item() -> void:
	"""Remove item from slot"""
	item_id = ""
	amount = 0.0
	volume_per_unit = 0.0
	metadata.clear()

	_update_display()
	_apply_slot_theme()

func has_item() -> bool:
	"""Check if slot has an item"""
	return item_id != "" and amount > 0

func get_item_data() -> Dictionary:
	"""Get item data as dictionary"""
	return {
		"item_id": item_id,
		"amount": amount,
		"volume_per_unit": volume_per_unit,
		"total_volume": amount * volume_per_unit,
		"metadata": metadata.duplicate()
	}

func add_amount(delta: float) -> void:
	"""Add to item amount"""
	amount += delta
	if amount <= 0:
		clear_item()
	else:
		_update_display()

func can_stack_with(other_item_id: String) -> bool:
	"""Check if this slot can stack with another item"""
	if not has_item():
		return true  # Empty slot accepts anything
	return item_id == other_item_id

# ============================================================================
# DISPLAY UPDATE
# ============================================================================

func _update_display():
	"""Update visual display"""
	if not is_node_ready():
		return

	if has_item():
		# Show item icon (TODO: Load from AssetManager/ItemDatabase)
		icon_texture.visible = true
		# icon_texture.texture = AssetManager.get_item_icon(item_id)

		# Show amount
		if show_amount and amount_label:
			amount_label.visible = true
			amount_label.text = _format_amount(amount)

		# Show volume
		if show_volume and volume_label:
			volume_label.visible = true
			var total_volume = amount * volume_per_unit
			volume_label.text = "%.1f m³" % total_volume
	else:
		# Empty slot
		if icon_texture:
			icon_texture.visible = false
		if amount_label:
			amount_label.visible = false
		if volume_label:
			volume_label.visible = false

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
# SELECTION
# ============================================================================

func set_selected(selected: bool) -> void:
	"""Set selection state"""
	is_selected = selected
	if selection_overlay:
		selection_overlay.visible = selected

func toggle_selected() -> void:
	"""Toggle selection"""
	set_selected(not is_selected)

# ============================================================================
# MOUSE EVENTS
# ============================================================================

func _on_mouse_entered():
	is_hovered = true
	_update_hover_style()
	item_hover_started.emit(self)

	# Show tooltip
	if has_item():
		_show_tooltip()

func _on_mouse_exited():
	is_hovered = false
	_update_hover_style()
	item_hover_ended.emit(self)

	# Hide tooltip
	_hide_tooltip()

# ============================================================================
# DRAG & DROP
# ============================================================================

func _start_drag():
	"""Start dragging this item"""
	if not has_item() or not allow_drag:
		return

	var drag_data = get_item_data()
	drag_data["source_slot"] = self

	# Create drag preview
	drag_preview = _create_drag_preview()

	# Set drag data via DragManager if available
	if DragManager:
		DragManager.start_drag(drag_data, drag_preview)

	item_dragged.emit(self, drag_data)
	is_dragging = true

func _create_drag_preview() -> Control:
	"""Create visual preview for dragging"""
	var preview = PanelContainer.new()
	preview.custom_minimum_size = slot_size

	var style = theme.create_panel_style(SciFiTheme.PanelStyle.HOLOGRAPHIC, SciFiTheme.BorderGlow.STRONG)
	preview.add_theme_stylebox_override("panel", style)

	var icon = TextureRect.new()
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	# icon.texture = AssetManager.get_item_icon(item_id)
	preview.add_child(icon)

	return preview

func can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not allow_drop:
		return false

	if data is Dictionary and data.has("item_id"):
		# Check if we can stack
		return can_stack_with(data.item_id)

	return false

func drop_data(at_position: Vector2, data: Variant) -> void:
	if data is Dictionary and data.has("item_id"):
		item_dropped.emit(self, data)

# ============================================================================
# TOOLTIP
# ============================================================================

func _show_tooltip():
	"""Show item tooltip"""
	if not has_item():
		return

	# TODO: Implement tooltip system
	# For now, use native tooltip
	tooltip_text = _generate_tooltip_text()

func _hide_tooltip():
	"""Hide tooltip"""
	tooltip_text = ""

func _generate_tooltip_text() -> String:
	"""Generate tooltip text"""
	if not has_item():
		return ""

	var text = "[b]%s[/b]\n" % item_id.capitalize()
	text += "Amount: %s\n" % _format_amount(amount)
	text += "Volume: %.1f m³ per unit\n" % volume_per_unit
	text += "Total: %.1f m³" % (amount * volume_per_unit)

	return text

# ============================================================================
# UTILITY
# ============================================================================

func _to_string() -> String:
	if has_item():
		return "[ItemSlot:%s x%.1f]" % [item_id, amount]
	return "[ItemSlot:Empty]"
