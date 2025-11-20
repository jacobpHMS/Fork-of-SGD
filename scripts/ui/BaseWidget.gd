extends PanelContainer
class_name BaseWidget
## Base class for all dashboard widgets
##
## Provides standardized interface for:
## - Data binding (connect to player or other data sources)
## - Automatic updates with configurable intervals
## - Sci-Fi themed styling
## - WindowManager integration
## - Performance optimization (update batching)
##
## Usage:
##   extend BaseWidget in your custom widget
##   override initialize_widget() and update_widget_data()
##   call bind_data_source(player) to connect data
##
## Example:
##   extends BaseWidget
##   class_name MyWidget
##
##   func initialize_widget() -> void:
##       widget_id = "my_widget"
##       widget_title = "My Widget"
##       update_priority = WindowManager.WidgetUpdatePriority.MEDIUM
##
##   func update_widget_data() -> void:
##       if not _data_source:
##           return
##       # Update UI based on _data_source data

# ============================================================================
# EXPORTS
# ============================================================================

@export_group("Widget Configuration")
@export var widget_id: String = ""
@export var widget_title: String = "Widget"
@export var update_priority: WindowManager.WidgetUpdatePriority = WindowManager.WidgetUpdatePriority.MEDIUM
@export var auto_register: bool = true  ## Auto-register with WindowManager on ready

@export_group("Theming")
@export var panel_style: SciFiTheme.PanelStyle = SciFiTheme.PanelStyle.STANDARD
@export var border_glow: SciFiTheme.BorderGlow = SciFiTheme.BorderGlow.SUBTLE
@export var show_title: bool = true

@export_group("Update Settings")
@export var manual_update_only: bool = false  ## If true, widget won't auto-update (call update_widget_data() manually)

@export_group("Animations")
@export var enable_animations: bool = true  ## Enable smooth animations
@export var animation_on_show: String = "fade_slide"  ## Animation when showing widget (fade, slide_left, slide_right, scale, fade_slide)
@export var animation_duration: float = 0.3  ## Animation duration in seconds

# ============================================================================
# INTERNAL STATE
# ============================================================================

var _data_source: Node = null
var _theme: SciFiTheme = null
var _is_initialized: bool = false
var _title_label: Label = null
var _content_container: Control = null

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	# Create theme
	_theme = SciFiTheme.new()

	# Apply base styling
	_apply_widget_theme()

	# Create UI structure
	_create_widget_structure()

	# Initialize widget (virtual method for subclasses)
	initialize_widget()

	# Register with WindowManager
	if auto_register and widget_id != "":
		WindowManager.register_widget(widget_id, self, update_priority)

	_is_initialized = true

	# Perform initial update
	if _data_source and not manual_update_only:
		update_widget_data()

func _exit_tree():
	# Unregister from WindowManager
	if widget_id != "":
		WindowManager.unregister_widget(widget_id)

# ============================================================================
# WIDGET STRUCTURE
# ============================================================================

func _create_widget_structure() -> void:
	"""Create basic widget structure (title + content container)"""
	# Clear existing children (if any)
	for child in get_children():
		child.queue_free()

	# Create main VBox
	var main_vbox = VBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(main_vbox)

	# Add title if enabled
	if show_title and widget_title != "":
		_title_label = Label.new()
		_title_label.text = widget_title
		_theme.apply_title_style(_title_label, _theme.COLOR_ACCENT_CYAN)
		main_vbox.add_child(_title_label)

		# Add separator
		var sep = _theme.create_separator()
		main_vbox.add_child(sep)

	# Create content container for subclass to use
	_content_container = VBoxContainer.new()
	_content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_content_container.name = "ContentContainer"
	main_vbox.add_child(_content_container)

# ============================================================================
# THEMING
# ============================================================================

func _apply_widget_theme() -> void:
	"""Apply sci-fi theme to widget panel"""
	var stylebox = _theme.create_panel_style(panel_style, border_glow)
	add_theme_stylebox_override("panel", stylebox)

func set_panel_style(style: SciFiTheme.PanelStyle, glow: SciFiTheme.BorderGlow = SciFiTheme.BorderGlow.SUBTLE) -> void:
	"""Change widget panel style"""
	panel_style = style
	border_glow = glow
	_apply_widget_theme()

func set_title_color(color: Color) -> void:
	"""Change title text color"""
	if _title_label:
		_title_label.add_theme_color_override("font_color", color)

# ============================================================================
# DATA BINDING
# ============================================================================

func bind_data_source(source: Node) -> void:
	"""Bind widget to a data source (e.g., Player node)"""
	_data_source = source

	if _is_initialized and not manual_update_only:
		update_widget_data()

func unbind_data_source() -> void:
	"""Remove data source binding"""
	_data_source = null

func get_data_source() -> Node:
	"""Get current data source"""
	return _data_source

func has_data_source() -> bool:
	"""Check if data source is bound"""
	return _data_source != null and is_instance_valid(_data_source)

# ============================================================================
# CONTENT MANAGEMENT
# ============================================================================

func get_content_container() -> Control:
	"""Get the content container for adding custom widgets"""
	return _content_container

func clear_content() -> void:
	"""Clear all content from widget"""
	if _content_container:
		for child in _content_container.get_children():
			child.queue_free()

# ============================================================================
# VIRTUAL METHODS (Override in subclasses)
# ============================================================================

func initialize_widget() -> void:
	"""
	Called once when widget is created.
	Override this to set up your widget's UI and configuration.

	Example:
		func initialize_widget() -> void:
			widget_id = "my_widget"
			widget_title = "My Widget Title"
			# Create your custom UI here
	"""
	pass

func update_widget_data() -> void:
	"""
	Called regularly to update widget display.
	Override this to update your widget based on _data_source.

	Example:
		func update_widget_data() -> void:
			if not has_data_source():
				return
			var player = get_data_source()
			my_label.text = "HP: %d" % player.health
	"""
	pass

# ============================================================================
# HELPER METHODS FOR SUBCLASSES
# ============================================================================

func create_label(text: String = "", style: String = "body") -> Label:
	"""Create a themed label"""
	var label = Label.new()
	label.text = text

	match style:
		"title":
			_theme.apply_title_style(label)
		"header":
			_theme.apply_header_style(label)
		"body":
			_theme.apply_body_style(label)
		"small":
			_theme.apply_small_style(label)

	return label

func create_status_label(status: String) -> Label:
	"""Create a status indicator label with colored dot"""
	return _theme.create_status_indicator(status)

func create_progress_bar(min_val: float = 0.0, max_val: float = 100.0, color: Color = Color.TRANSPARENT) -> ProgressBar:
	"""Create a themed progress bar"""
	var progress = ProgressBar.new()
	progress.min_value = min_val
	progress.max_value = max_val

	# Use theme color if not specified
	var fill_color = color if color != Color.TRANSPARENT else _theme.COLOR_ACCENT_CYAN
	var styles = _theme.create_progressbar_style(fill_color)

	progress.add_theme_stylebox_override("background", styles.background)
	progress.add_theme_stylebox_override("fill", styles.fill)

	return progress

func create_stat_row(parent: Control, label_text: String, value_text: String, columns: int = 2) -> void:
	"""Create a stat row in a grid container"""
	if not parent is GridContainer:
		push_error("create_stat_row requires parent to be GridContainer")
		return

	var grid = parent as GridContainer
	if grid.columns != columns:
		grid.columns = columns

	var label = create_label(label_text, "small")
	grid.add_child(label)

	var value = create_label(value_text, "small")
	value.add_theme_color_override("font_color", _theme.COLOR_TEXT_HIGHLIGHT)
	grid.add_child(value)

func create_separator() -> HSeparator:
	"""Create a themed separator"""
	return _theme.create_separator()

func get_theme() -> SciFiTheme:
	"""Get reference to SciFiTheme instance"""
	return _theme

# ============================================================================
# STATUS DISPLAY
# ============================================================================

func show_no_data_message(message: String = "No Data Available") -> void:
	"""Display a 'no data' message in the widget"""
	clear_content()

	var label = create_label(message, "body")
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.add_theme_color_override("font_color", _theme.COLOR_TEXT_DIM)

	_content_container.add_child(label)

func show_error_message(error: String) -> void:
	"""Display an error message in the widget"""
	clear_content()

	var label = create_label("⚠ " + error, "body")
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.add_theme_color_override("font_color", _theme.COLOR_STATUS_DANGER)

	_content_container.add_child(label)

# ============================================================================
# ANIMATIONS
# ============================================================================

func show_animated() -> void:
	"""Show widget with animation"""
	if not enable_animations:
		visible = true
		return

	WidgetAnimator.open_panel(self, animation_on_show)

func hide_animated() -> void:
	"""Hide widget with animation"""
	if not enable_animations:
		visible = false
		return

	WidgetAnimator.close_panel(self, "fade")

func pulse_notification() -> void:
	"""Pulse widget once (for notifications)"""
	if enable_animations:
		WidgetAnimator.pulse_once(self, 0.4, 1.05)

func flash_notification() -> void:
	"""Flash widget (for alerts)"""
	if enable_animations:
		WidgetAnimator.flash(self, 0.3, 2)

func shake_error() -> void:
	"""Shake widget (for errors)"""
	if enable_animations:
		WidgetAnimator.shake(self, 0.4, 5.0)

# ============================================================================
# DEBUG
# ============================================================================

func _to_string() -> String:
	return "[BaseWidget:%s:%s]" % [widget_id, widget_title]
