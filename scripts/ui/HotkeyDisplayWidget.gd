extends PanelContainer
class_name HotkeyDisplayWidget
## HotkeyDisplayWidget - Display available hotkeys to the user
##
## Shows a compact, toggleable overlay of all available keyboard shortcuts.
## Can be toggled with a hotkey (default: H) or button click.
##
## Features:
## - Auto-discovery of WindowManager hotkeys
## - Categorized display (Windows, Widgets, Actions)
## - Sci-Fi styled
## - Toggleable overlay
## - Customizable position

# ============================================================================
# EXPORTS
# ============================================================================

@export_group("Display Configuration")
@export var auto_show_on_startup: bool = false
@export var fade_duration: float = 0.3
@export var display_position: Vector2 = Vector2(20, 100)  # Screen position

@export_group("Hotkey Configuration")
@export var toggle_hotkey: Key = KEY_H  # Press H to toggle help

# ============================================================================
# STATE
# ============================================================================

var theme: SciFiTheme = null
var is_visible_overlay: bool = false
var content_container: VBoxContainer = null
var hotkey_sections: Dictionary = {}  # section_name -> VBoxContainer

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	theme = SciFiTheme.new()

	# Apply styling
	_apply_theme()

	# Position
	position = display_position

	# Build UI
	_build_ui()

	# Connect to WindowManager for hotkey updates
	if WindowManager:
		WindowManager.widget_registered.connect(_on_widget_registered)

	# Initial visibility
	visible = auto_show_on_startup

	# Bind toggle hotkey
	if WindowManager:
		WindowManager.bind_hotkey_action(toggle_hotkey, "toggle_hotkey_display", _toggle_display)

	# Initial populate
	_populate_hotkeys()

	print("✅ HotkeyDisplayWidget initialized")

func _apply_theme() -> void:
	"""Apply Sci-Fi theme"""
	var stylebox = theme.create_panel_style(SciFiTheme.PanelStyle.HOLOGRAPHIC, SciFiTheme.BorderGlow.STRONG)
	add_theme_stylebox_override("panel", stylebox)

	custom_minimum_size = Vector2(300, 400)

# ============================================================================
# UI BUILDING
# ============================================================================

func _build_ui():
	"""Build hotkey display UI"""
	var main_vbox = VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 8)
	add_child(main_vbox)

	# Title bar
	var title_hbox = HBoxContainer.new()
	main_vbox.add_child(title_hbox)

	var title_label = Label.new()
	title_label.text = "⌨ KEYBOARD SHORTCUTS"
	theme.apply_title_style(title_label, theme.COLOR_ACCENT_CYAN)
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_hbox.add_child(title_label)

	var close_button = Button.new()
	close_button.text = "✕"
	close_button.custom_minimum_size = Vector2(30, 30)
	close_button.pressed.connect(_toggle_display)
	theme.apply_button_style(close_button, theme.COLOR_ACCENT_CYAN)
	title_hbox.add_child(close_button)

	# Separator
	main_vbox.add_child(theme.create_separator())

	# Scroll container for hotkeys
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	main_vbox.add_child(scroll)

	# Content container
	content_container = VBoxContainer.new()
	content_container.add_theme_constant_override("separation", 12)
	scroll.add_child(content_container)

	# Footer
	var footer_label = Label.new()
	footer_label.text = "Press %s to toggle this help" % OS.get_keycode_string(toggle_hotkey)
	footer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	theme.apply_small_style(footer_label)
	footer_label.add_theme_color_override("font_color", theme.COLOR_TEXT_DIM)
	main_vbox.add_child(footer_label)

# ============================================================================
# HOTKEY POPULATION
# ============================================================================

func _populate_hotkeys():
	"""Populate hotkey display with current bindings"""
	# Clear existing
	for child in content_container.get_children():
		child.queue_free()
	hotkey_sections.clear()

	# Widget Hotkeys Section
	_add_section("Widget Switching (F1-F8)")
	_add_hotkey("F1", "Mining Scanner")
	_add_hotkey("F2", "Spectral Scan")
	_add_hotkey("F3", "Quality Graph")
	_add_hotkey("F4", "Cargo Overview")
	_add_hotkey("F5", "Ship Modules")
	_add_hotkey("F6", "Tactical Display")
	_add_hotkey("F7", "Ship Overview")
	_add_hotkey("F8", "Ship Details")

	# Window Hotkeys Section
	if WindowManager:
		var window_hotkeys = WindowManager.get_all_hotkeys()
		if not window_hotkeys.is_empty():
			_add_section("Windows")
			for key in window_hotkeys.keys():
				var binding = window_hotkeys[key]
				if binding.type == "window":
					var key_name = OS.get_keycode_string(key)
					_add_hotkey(key_name, "Toggle " + binding.target.capitalize())

	# Common Actions Section
	_add_section("Common Actions")
	_add_hotkey("H", "Toggle this help")
	_add_hotkey("I", "Toggle Inventory (if bound)")
	_add_hotkey("M", "Toggle Map (if bound)")
	_add_hotkey("ESC", "Close windows/Cancel")

func _add_section(section_name: String) -> void:
	"""Add a section header"""
	var section_vbox = VBoxContainer.new()
	section_vbox.add_theme_constant_override("separation", 4)
	content_container.add_child(section_vbox)

	# Section header
	var header = Label.new()
	header.text = section_name
	theme.apply_header_style(header)
	header.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)
	section_vbox.add_child(header)

	# Store section for adding hotkeys
	hotkey_sections[section_name] = section_vbox

func _add_hotkey(key_text: String, description: String) -> void:
	"""Add a hotkey entry to the most recent section"""
	if hotkey_sections.is_empty():
		return

	var last_section = hotkey_sections.values()[-1]

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	last_section.add_child(hbox)

	# Key display (button-like)
	var key_panel = PanelContainer.new()
	var key_style = theme.create_panel_style(SciFiTheme.PanelStyle.TACTICAL, SciFiTheme.BorderGlow.SUBTLE)
	key_panel.add_theme_stylebox_override("panel", key_style)
	key_panel.custom_minimum_size = Vector2(60, 24)
	hbox.add_child(key_panel)

	var key_label = Label.new()
	key_label.text = key_text
	key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	key_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	theme.apply_body_style(key_label)
	key_label.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)
	key_panel.add_child(key_label)

	# Description
	var desc_label = Label.new()
	desc_label.text = description
	desc_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	theme.apply_body_style(desc_label)
	hbox.add_child(desc_label)

# ============================================================================
# DISPLAY CONTROL
# ============================================================================

func _toggle_display():
	"""Toggle visibility of hotkey display"""
	if visible:
		hide_display()
	else:
		show_display()

func show_display():
	"""Show hotkey display with animation"""
	visible = true
	is_visible_overlay = true

	# Refresh hotkeys
	_populate_hotkeys()

	# Animate in
	if WidgetAnimator:
		WidgetAnimator.fade_in(self, fade_duration)

	print("✅ Hotkey display shown")

func hide_display():
	"""Hide hotkey display with animation"""
	is_visible_overlay = false

	if WidgetAnimator:
		var tween = WidgetAnimator.fade_out(self, fade_duration)
		if tween:
			tween.finished.connect(func(): visible = false)
	else:
		visible = false

	print("✅ Hotkey display hidden")

# ============================================================================
# CALLBACKS
# ============================================================================

func _on_widget_registered(_widget_id: String):
	"""Refresh display when widgets are registered"""
	if visible:
		_populate_hotkeys()

# ============================================================================
# UTILITY
# ============================================================================

func refresh_hotkeys():
	"""Manually refresh hotkey display"""
	_populate_hotkeys()
