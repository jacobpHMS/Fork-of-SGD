extends BaseWidget
class_name ShipDetailsWidget
## Ship Details Widget - Deep resource management view
##
## Displays power grid, CPU, thermal management, and module resource allocation
## with interactive sliders for power/cooling distribution

# ============================================================================
# INITIALIZATION
# ============================================================================

func initialize_widget() -> void:
	widget_id = "ship_details"
	widget_title = "Ship Resource Management"
	update_priority = WindowManager.WidgetUpdatePriority.MEDIUM
	panel_style = SciFiTheme.PanelStyle.ENGINEERING

# ============================================================================
# UPDATE
# ============================================================================

func update_widget_data() -> void:
	if not has_data_source():
		show_no_data_message("No Player Data")
		return

	var player = get_data_source()

	# Rebuild UI
	clear_content()
	var content = get_content_container()

	# System status overview
	if player.has_method("get_ship_systems_info"):
		var systems = player.get_ship_systems_info()

		# Power system
		var power_section = _create_system_section("POWER GRID", systems.get("power", {}))
		content.add_child(power_section)

		# CPU system
		var cpu_section = _create_system_section("CPU PROCESSING", systems.get("cpu", {}))
		content.add_child(cpu_section)

		# Heat system
		var heat_section = _create_system_section("THERMAL MANAGEMENT", systems.get("heat", {}))
		content.add_child(heat_section)

	content.add_child(create_separator())

	# Module resource allocation
	_create_module_allocation_section(content, player)

# ============================================================================
# SYSTEM SECTIONS
# ============================================================================

func _create_system_section(system_name: String, system_data: Dictionary) -> PanelContainer:
	"""Create system status section"""
	var panel = PanelContainer.new()
	var theme = get_theme()

	# Apply custom panel style
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.2, 0.8)
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_color = theme.COLOR_ACCENT_BLUE
	panel.add_theme_stylebox_override("panel", style)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	# Title
	var title = create_label(system_name, "header")
	title.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)
	vbox.add_child(title)

	# Progress bar
	var progress = create_progress_bar(0, system_data.get("max", 100.0), theme.COLOR_ACCENT_CYAN)
	progress.value = system_data.get("current", 0.0)
	progress.show_percentage = false
	vbox.add_child(progress)

	# Stats grid
	var grid = GridContainer.new()
	grid.columns = 2
	vbox.add_child(grid)

	if system_data.has("generation"):
		create_stat_row(grid, "Generation:", "%.1f/s" % system_data.generation)
	if system_data.has("consumption"):
		create_stat_row(grid, "Consumption:", "%.1f/s" % system_data.consumption)
	if system_data.has("dissipation"):
		create_stat_row(grid, "Dissipation:", "%.1f/s" % system_data.dissipation)

	var current_val = system_data.get("current", 0.0)
	var max_val = system_data.get("max", 100.0)
	create_stat_row(grid, "Available:", "%.1f / %.1f" % [current_val, max_val])

	return panel

# ============================================================================
# MODULE ALLOCATION
# ============================================================================

func _create_module_allocation_section(parent: Control, player: Node) -> void:
	"""Create module resource allocation controls"""
	var title = create_label("MODULE RESOURCE ALLOCATION", "header")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(title)

	if not player.has_method("get_ship_modules_info"):
		return

	var modules = player.get_ship_modules_info()

	for module in modules:
		# Skip passive modules
		if module.get("power_usage", 0) == 0 and module.get("power_generation", 0) == 0:
			continue

		var module_panel = _create_module_control_panel(module)
		parent.add_child(module_panel)

func _create_module_control_panel(module: Dictionary) -> PanelContainer:
	"""Create control panel for a module"""
	var panel = PanelContainer.new()
	var theme = get_theme()

	# Apply styled panel
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.15, 0.15, 0.15, 0.9)
	style.border_width_all = 1

	# Border color based on status
	var status = module.get("status", "offline")
	if status == "active":
		style.border_color = theme.COLOR_STATUS_ACTIVE
	elif status == "damaged":
		style.border_color = theme.COLOR_STATUS_DANGER
	elif status == "overloaded":
		style.border_color = theme.COLOR_STATUS_WARNING
	else:
		style.border_color = theme.COLOR_STATUS_DISABLED

	panel.add_theme_stylebox_override("panel", style)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	# Header
	var header = HBoxContainer.new()
	vbox.add_child(header)

	var name_label = create_label(module.get("name", "Module"), "body")
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(name_label)

	var status_label = create_label(status.to_upper(), "small")
	var status_color = theme.COLOR_STATUS_ACTIVE if status == "active" else theme.COLOR_STATUS_DISABLED
	status_label.add_theme_color_override("font_color", status_color)
	header.add_child(status_label)

	# Health bar
	var health_progress = create_progress_bar(0, 100, theme.COLOR_STATUS_ACTIVE)
	health_progress.value = (module.get("health", 100) / module.get("max_health", 100)) * 100.0
	health_progress.show_percentage = false
	vbox.add_child(health_progress)

	# Power allocation slider (if applicable)
	if module.has("power_allocation"):
		_add_allocation_slider(vbox, module, "power")

	# Cooling allocation slider (if applicable)
	if module.has("cooling_allocation"):
		_add_allocation_slider(vbox, module, "cooling")

	# Module stats
	var stats_grid = GridContainer.new()
	stats_grid.columns = 2
	vbox.add_child(stats_grid)

	if module.has("power_usage") and module.power_usage > 0:
		create_stat_row(stats_grid, "Power:", "%.0f GJ/s" % module.power_usage)
	if module.has("cpu_usage") and module.cpu_usage > 0:
		create_stat_row(stats_grid, "CPU:", "%.0f" % module.cpu_usage)
	if module.has("heat_generation") and module.heat_generation > 0:
		create_stat_row(stats_grid, "Heat:", "%.1f/s" % module.heat_generation)
	if module.has("temperature"):
		create_stat_row(stats_grid, "Temp:", "%.1f°C" % module.temperature)
	if module.has("efficiency"):
		create_stat_row(stats_grid, "Efficiency:", "%.0f%%" % (module.efficiency * 100.0))

	return panel

func _add_allocation_slider(parent: Control, module: Dictionary, type: String) -> void:
	"""Add allocation slider (power or cooling)"""
	var label_text = "Power Allocation" if type == "power" else "Cooling Priority"
	var value_key = "power_allocation" if type == "power" else "cooling_allocation"
	var current_value = module.get(value_key, 100.0)

	var label = create_label("%s: %.0f%%" % [label_text, current_value], "small")
	label.name = "AllocationLabel_" + module.get("id", "")
	parent.add_child(label)

	var slider = HSlider.new()
	slider.min_value = 50.0 if type == "power" else 0.0
	slider.max_value = 150.0 if type == "power" else 200.0
	slider.step = 5.0 if type == "power" else 10.0
	slider.value = current_value
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var module_id = module.get("id", "")
	if type == "power":
		slider.value_changed.connect(_on_power_allocation_changed.bind(module_id, label))
	else:
		slider.value_changed.connect(_on_cooling_allocation_changed.bind(module_id, label))

	parent.add_child(slider)

# ============================================================================
# SLIDER CALLBACKS
# ============================================================================

func _on_power_allocation_changed(value: float, module_id: String, label: Label) -> void:
	"""Handle power allocation slider change"""
	label.text = "Power Allocation: %.0f%%" % value

	var player = get_data_source()
	if player and player.has_method("set_module_power_allocation"):
		player.set_module_power_allocation(module_id, value)

func _on_cooling_allocation_changed(value: float, module_id: String, label: Label) -> void:
	"""Handle cooling allocation slider change"""
	label.text = "Cooling Priority: %.0f%%" % value

	var player = get_data_source()
	if player and player.has_method("set_module_cooling_allocation"):
		player.set_module_cooling_allocation(module_id, value)
