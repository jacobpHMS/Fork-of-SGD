extends BaseWidget
class_name CargoOverviewWidget
## Cargo Overview Widget - Summary of all cargo holds with progress bars
##
## Displays all 6 cargo holds with capacity bars and clickable buttons
## to open detailed cargo windows

# ============================================================================
# CONSTANTS
# ============================================================================

const CargoWindowScene = preload("res://scenes/CargoWindow.tscn")
const CARGO_TYPE_COUNT: int = 6

# ============================================================================
# STATE
# ============================================================================

var cargo_windows: Array = []
var cargo_rows: Array = []  # Store references to each cargo row for updates

# ============================================================================
# INITIALIZATION
# ============================================================================

func initialize_widget() -> void:
	widget_id = "cargo_overview"
	widget_title = "Cargo Holds"
	update_priority = WindowManager.WidgetUpdatePriority.MEDIUM
	panel_style = SciFiTheme.PanelStyle.STANDARD

	_build_cargo_ui()

func _build_cargo_ui() -> void:
	"""Build cargo overview UI"""
	var content = get_content_container()

	# Create cargo hold rows
	cargo_rows.clear()

	for i in range(CARGO_TYPE_COUNT):
		var row = _create_cargo_row(i)
		cargo_rows.append(row)
		content.add_child(row.container)

# ============================================================================
# CARGO ROW CREATION
# ============================================================================

func _create_cargo_row(cargo_type: int) -> Dictionary:
	"""Create a single cargo row with button, progress bar, and label"""
	var hbox = HBoxContainer.new()
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Cargo type button
	var cargo_btn = Button.new()
	cargo_btn.text = _get_cargo_type_name(cargo_type)
	cargo_btn.custom_minimum_size = Vector2(120, 0)
	cargo_btn.add_theme_font_size_override("font_size", 10)
	cargo_btn.pressed.connect(_on_cargo_hold_clicked.bind(cargo_type))

	# Apply sci-fi button style
	var theme = get_theme()
	cargo_btn.add_theme_stylebox_override("normal", theme.create_button_style("normal", theme.COLOR_ACCENT_CYAN))
	cargo_btn.add_theme_stylebox_override("hover", theme.create_button_style("hover", theme.COLOR_ACCENT_CYAN))
	cargo_btn.add_theme_stylebox_override("pressed", theme.create_button_style("pressed", theme.COLOR_ACCENT_CYAN))

	hbox.add_child(cargo_btn)

	# Progress bar
	var progress = create_progress_bar(0, 1000, theme.COLOR_ACCENT_CYAN)
	progress.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	progress.show_percentage = false
	hbox.add_child(progress)

	# Info label
	var info_label = create_label("0/0 m³", "small")
	info_label.custom_minimum_size = Vector2(80, 0)
	info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hbox.add_child(info_label)

	return {
		"container": hbox,
		"button": cargo_btn,
		"progress": progress,
		"label": info_label
	}

# ============================================================================
# UPDATE
# ============================================================================

func update_widget_data() -> void:
	if not has_data_source():
		show_no_data_message("No Player Data")
		return

	var player = get_data_source()

	if not player.has_method("get_cargo_hold_info"):
		show_error_message("Player missing get_cargo_hold_info() method")
		return

	# Update each cargo row
	for i in range(CARGO_TYPE_COUNT):
		if i < cargo_rows.size():
			_update_cargo_row(i, player)

func _update_cargo_row(cargo_type: int, player: Node) -> void:
	"""Update a single cargo row"""
	var row = cargo_rows[cargo_type]

	var cargo_info = player.get_cargo_hold_info(cargo_type)
	var used = cargo_info.get("used", 0.0)
	var capacity = cargo_info.get("capacity", 1000.0)

	# Update progress bar
	row.progress.max_value = capacity
	row.progress.value = used

	# Update label
	row.label.text = "%.0f/%.0f m³" % [used, capacity]

	# Color code based on fullness
	var percent = (used / capacity * 100.0) if capacity > 0 else 0.0
	var theme = get_theme()

	if percent > 90.0:
		row.label.add_theme_color_override("font_color", theme.COLOR_STATUS_DANGER)
	elif percent > 75.0:
		row.label.add_theme_color_override("font_color", theme.COLOR_STATUS_WARNING)
	else:
		row.label.add_theme_color_override("font_color", theme.COLOR_STATUS_ACTIVE)

# ============================================================================
# CARGO WINDOW MANAGEMENT
# ============================================================================

func _on_cargo_hold_clicked(cargo_type: int) -> void:
	"""Handle cargo button click - open cargo window"""
	# Ensure cargo_windows array is large enough
	while cargo_windows.size() <= cargo_type:
		cargo_windows.append(null)

	# Check if window already exists
	if cargo_windows[cargo_type] and is_instance_valid(cargo_windows[cargo_type]):
		# Window exists, just show it
		cargo_windows[cargo_type].visible = true
		cargo_windows[cargo_type].move_to_front()
	else:
		# Create new cargo window
		var window = CargoWindowScene.instantiate()
		window.set_cargo_type(cargo_type)
		window.set_player_node(get_data_source())

		# Position window (offset based on cargo type to avoid overlap)
		window.position = Vector2(200 + cargo_type * 50, 100 + cargo_type * 30)

		# Add to scene tree (add to UI layer)
		var ui_node = get_tree().root.get_node_or_null("Main/UI")
		if ui_node:
			ui_node.add_child(window)
		else:
			# Fallback: add to root
			get_tree().root.add_child(window)

		# Store reference
		cargo_windows[cargo_type] = window

# ============================================================================
# HELPERS
# ============================================================================

func _get_cargo_type_name(cargo_type: int) -> String:
	"""Get localized cargo type name"""
	match cargo_type:
		0: return "General"
		1: return "Ore"
		2: return "Minerals"
		3: return "Ammo"
		4: return "Build"
		5: return "Gas"
	return "Unknown"
