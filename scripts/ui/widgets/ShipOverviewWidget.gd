extends BaseWidget
class_name ShipOverviewWidget
## Ship Overview Widget - Visual module layout with clickable module boxes
##
## Displays ship modules in top-down view with status indicators

# ============================================================================
# STATE
# ============================================================================

var module_info_container: VBoxContainer = null

# ============================================================================
# INITIALIZATION
# ============================================================================

func initialize_widget() -> void:
	widget_id = "ship_overview"
	widget_title = "Ship Layout"
	update_priority = WindowManager.WidgetUpdatePriority.LOW
	panel_style = SciFiTheme.PanelStyle.ENGINEERING

	_build_overview_ui()

func _build_overview_ui() -> void:
	"""Build ship overview UI"""
	var content = get_content_container()

	# Main HBox: ship visual + module info
	var main_hbox = HBoxContainer.new()
	main_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(main_hbox)

	# Left: Ship visual
	var ship_visual = Control.new()
	ship_visual.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ship_visual.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ship_visual.custom_minimum_size = Vector2(250, 300)
	ship_visual.name = "ShipVisual"
	main_hbox.add_child(ship_visual)

	# Right: Module info
	module_info_container = VBoxContainer.new()
	module_info_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	module_info_container.name = "ModuleInfo"
	main_hbox.add_child(module_info_container)

	var info_title = create_label("MODULE INFORMATION", "header")
	info_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	module_info_container.add_child(info_title)

	var info_label = create_label("Click a module to view details", "body")
	info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	info_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	info_label.name = "InfoLabel"
	module_info_container.add_child(info_label)

# ============================================================================
# UPDATE
# ============================================================================

func update_widget_data() -> void:
	if not has_data_source():
		show_no_data_message("No Player Data")
		return

	var player = get_data_source()

	if not player.has_method("get_ship_modules_info"):
		show_error_message("Player missing get_ship_modules_info() method")
		return

	# Rebuild ship visual
	_rebuild_ship_visual(player)

func _rebuild_ship_visual(player: Node) -> void:
	"""Rebuild ship visual with module buttons"""
	var ship_visual = get_content_container().get_node_or_null("ContentContainer/HBoxContainer/ShipVisual")
	if not ship_visual:
		return

	# Clear existing modules
	for child in ship_visual.get_children():
		child.queue_free()

	var modules = player.get_ship_modules_info()
	var center = ship_visual.size / 2.0 if ship_visual.size.x > 0 else Vector2(125, 150)
	var theme = get_theme()

	for module in modules:
		var module_button = Button.new()
		module_button.text = _truncate_name(module.get("name", "Module"), 12)
		module_button.custom_minimum_size = Vector2(80, 30)

		# Position relative to center
		var pos = center + module.get("position", Vector2.ZERO)
		module_button.position = pos - Vector2(40, 15)  # Center the button

		# Color based on status
		var status = module.get("status", "offline")
		var button_color = theme.COLOR_STATUS_ACTIVE if status == "active" else theme.COLOR_STATUS_DISABLED

		if status == "damaged":
			button_color = theme.COLOR_STATUS_DANGER
		elif status == "overloaded":
			button_color = theme.COLOR_STATUS_WARNING

		# Apply styled button
		var normal_style = theme.create_button_style("normal", button_color)
		var hover_style = theme.create_button_style("hover", button_color)
		var pressed_style = theme.create_button_style("pressed", button_color)

		module_button.add_theme_stylebox_override("normal", normal_style)
		module_button.add_theme_stylebox_override("hover", hover_style)
		module_button.add_theme_stylebox_override("pressed", pressed_style)
		module_button.add_theme_font_size_override("font_size", 8)

		# Connect click handler
		var module_id = module.get("id", "")
		module_button.pressed.connect(_on_module_clicked.bind(module_id))

		ship_visual.add_child(module_button)

# ============================================================================
# MODULE SELECTION
# ============================================================================

func _on_module_clicked(module_id: String) -> void:
	"""Handle module button click"""
	var player = get_data_source()
	if not player or not player.has_method("get_module_by_id"):
		return

	var module = player.get_module_by_id(module_id)
	if module.is_empty():
		return

	# Display module info
	_display_module_info(module)

func _display_module_info(module: Dictionary) -> void:
	"""Display detailed module information"""
	# Clear existing info
	var info_label = module_info_container.get_node_or_null("InfoLabel")
	if info_label:
		info_label.queue_free()

	# Create detail display
	var detail_vbox = VBoxContainer.new()
	detail_vbox.name = "InfoLabel"
	detail_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	module_info_container.add_child(detail_vbox)

	# Module name
	var name_label = create_label(module.get("name", "Unknown"), "header")
	name_label.add_theme_color_override("font_color", get_theme().COLOR_ACCENT_CYAN)
	detail_vbox.add_child(name_label)

	detail_vbox.add_child(create_separator())

	# Stats grid
	var grid = GridContainer.new()
	grid.columns = 2
	detail_vbox.add_child(grid)

	create_stat_row(grid, "Status:", module.get("status", "unknown").capitalize())
	create_stat_row(grid, "Health:", "%.0f%%" % ((module.get("health", 100) / module.get("max_health", 100)) * 100.0))
	create_stat_row(grid, "Temperature:", "%.1f°C" % module.get("temperature", 0.0))

	if module.has("power_usage") and module.power_usage > 0:
		create_stat_row(grid, "Power:", "%.0f GJ/s" % module.power_usage)

	if module.has("efficiency"):
		create_stat_row(grid, "Efficiency:", "%.0f%%" % (module.efficiency * 100.0))

# ============================================================================
# HELPERS
# ============================================================================

func _truncate_name(name: String, max_length: int) -> String:
	"""Truncate name with ellipsis"""
	if name.length() <= max_length:
		return name
	return name.substr(0, max_length - 3) + "..."
