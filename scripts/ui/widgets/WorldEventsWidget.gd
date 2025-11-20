extends BaseWidget
class_name WorldEventsWidget
## World Events Widget - Displays world events and notifications
##
## Shows important game events like market changes, PvP, warnings, etc.

# ============================================================================
# CONSTANTS
# ============================================================================

const MAX_EVENTS: int = 10

# ============================================================================
# STATE
# ============================================================================

var events_container: VBoxContainer = null

# ============================================================================
# INITIALIZATION
# ============================================================================

func initialize_widget() -> void:
	widget_id = "world_events"
	widget_title = "World Events"
	update_priority = WindowManager.WidgetUpdatePriority.BACKGROUND
	panel_style = SciFiTheme.PanelStyle.FLAT
	show_title = true

	_build_events_ui()

func _build_events_ui() -> void:
	"""Build events UI"""
	var content = get_content_container()

	# Events list
	events_container = VBoxContainer.new()
	events_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	events_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(events_container)

	# Add welcome event
	add_world_event("Welcome to SpaceGameDev", "info")

# ============================================================================
# EVENT MANAGEMENT
# ============================================================================

func add_world_event(event_text: String, event_type: String = "info") -> void:
	"""Add a new world event

	Args:
		event_text: The event message
		event_type: Type of event (info, warning, danger, market, pvp)
	"""
	var icon = _get_event_icon(event_type)
	var color = _get_event_color(event_type)

	var label = create_label("%s %s" % [icon, event_text], "small")
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	events_container.add_child(label)

	# Limit number of events
	while events_container.get_child_count() > MAX_EVENTS:
		var first_child = events_container.get_child(0)
		first_child.queue_free()

func clear_events() -> void:
	"""Clear all events"""
	for child in events_container.get_children():
		child.queue_free()

# ============================================================================
# UPDATE
# ============================================================================

func update_widget_data() -> void:
	# Events are event-driven, no regular updates needed
	pass

# ============================================================================
# HELPERS
# ============================================================================

func _get_event_icon(event_type: String) -> String:
	"""Get icon for event type"""
	match event_type.to_lower():
		"info":
			return "ℹ"
		"warning":
			return "⚠"
		"danger", "critical":
			return "🔴"
		"market":
			return "💰"
		"pvp", "combat":
			return "⚔"
		"discovery":
			return "🔍"
		"achievement":
			return "🏆"
		_:
			return "•"

func _get_event_color(event_type: String) -> Color:
	"""Get color for event type"""
	var theme = get_theme()

	match event_type.to_lower():
		"info":
			return theme.COLOR_STATUS_INFO
		"warning":
			return theme.COLOR_STATUS_WARNING
		"danger", "critical":
			return theme.COLOR_STATUS_DANGER
		"market":
			return theme.COLOR_ACCENT_CYAN
		"pvp", "combat":
			return theme.COLOR_STATUS_DANGER
		"discovery":
			return theme.COLOR_ACCENT_TEAL
		"achievement":
			return theme.COLOR_STATUS_ACTIVE
		_:
			return theme.COLOR_TEXT_SECONDARY
