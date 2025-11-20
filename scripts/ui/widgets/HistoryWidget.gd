extends BaseWidget
class_name HistoryWidget
## History Widget - Displays scrolling history log of player actions
##
## Shows timestamped messages of mining, cargo, scanning, etc.

# ============================================================================
# CONSTANTS
# ============================================================================

const MAX_HISTORY_MESSAGES: int = 100

# ============================================================================
# STATE
# ============================================================================

var history_messages: Array[String] = []
var history_container: VBoxContainer = null
var scroll_container: ScrollContainer = null

# ============================================================================
# INITIALIZATION
# ============================================================================

func initialize_widget() -> void:
	widget_id = "history_log"
	widget_title = "History Log"
	update_priority = WindowManager.WidgetUpdatePriority.BACKGROUND
	panel_style = SciFiTheme.PanelStyle.FLAT
	show_title = true

	_build_history_ui()

func _build_history_ui() -> void:
	"""Build history log UI"""
	var content = get_content_container()

	# Scroll container
	scroll_container = ScrollContainer.new()
	scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_container.follow_focus = true
	content.add_child(scroll_container)

	# History list
	history_container = VBoxContainer.new()
	history_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_container.add_child(history_container)

	# Add welcome message
	add_history_message("System initialized")

# ============================================================================
# HISTORY MANAGEMENT
# ============================================================================

func add_history_message(message: String) -> void:
	"""Add a new message to history log"""
	var timestamp = Time.get_time_string_from_system()
	var full_message = "[%s] %s" % [timestamp, message]

	history_messages.append(full_message)

	# Limit history size
	if history_messages.size() > MAX_HISTORY_MESSAGES:
		history_messages.pop_front()

	# Update display
	_refresh_history_display()

func clear_history() -> void:
	"""Clear all history messages"""
	history_messages.clear()
	_refresh_history_display()

# ============================================================================
# UPDATE
# ============================================================================

func update_widget_data() -> void:
	# History is event-driven, no regular updates needed
	pass

func _refresh_history_display() -> void:
	"""Refresh history display"""
	if not history_container:
		return

	# Clear existing
	for child in history_container.get_children():
		child.queue_free()

	# Add messages (newest first)
	var reversed = history_messages.duplicate()
	reversed.reverse()

	for msg in reversed:
		var label = create_label(msg, "small")
		label.add_theme_color_override("font_color", get_theme().COLOR_TEXT_SECONDARY)
		history_container.add_child(label)

# ============================================================================
# SIGNAL CONNECTIONS (Call these from PermanentInfoPanel)
# ============================================================================

func connect_player_signals(player: Node) -> void:
	"""Connect to player signals for automatic history updates"""
	if not player:
		return

	if player.has_signal("ore_mined"):
		if not player.ore_mined.is_connected(_on_ore_mined):
			player.ore_mined.connect(_on_ore_mined)

	if player.has_signal("cargo_ejected"):
		if not player.cargo_ejected.is_connected(_on_cargo_ejected):
			player.cargo_ejected.connect(_on_cargo_ejected)

	if player.has_signal("cargo_crate_picked_up"):
		if not player.cargo_crate_picked_up.is_connected(_on_cargo_picked_up):
			player.cargo_crate_picked_up.connect(_on_cargo_picked_up)

func _on_ore_mined(ore_name: String, amount: float, _ore_id: String) -> void:
	"""Handle ore mined signal"""
	add_history_message("Mined: %.1f units of %s" % [amount, ore_name])

func _on_cargo_ejected(item_id: String, amount: float) -> void:
	"""Handle cargo ejected signal"""
	add_history_message("Ejected: %.1f units of %s" % [amount, item_id])

func _on_cargo_picked_up(item_id: String, amount: float) -> void:
	"""Handle cargo picked up signal"""
	add_history_message("Picked up: %.1f units of %s" % [amount, item_id])
