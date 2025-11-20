extends BaseWidget
class_name ShipModulesWidget
## Ship Modules Widget - Display active ship modules status
##
## Shows mining modules, scanner modules, and ship stats

# ============================================================================
# INITIALIZATION
# ============================================================================

func initialize_widget() -> void:
	widget_id = "ship_modules"
	widget_title = "Ship Modules"
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

	# Mining Modules Section
	_create_mining_section(content, player)

	content.add_child(create_separator())

	# Scanner Module Section
	_create_scanner_section(content, player)

	content.add_child(create_separator())

	# Ship Stats Section
	_create_stats_section(content, player)

# ============================================================================
# SECTION BUILDERS
# ============================================================================

func _create_mining_section(parent: Control, player: Node) -> void:
	"""Create mining modules section"""
	var section_label = create_label("⛏ Mining Modules", "header")
	section_label.add_theme_color_override("font_color", get_theme().COLOR_ACCENT_TEAL)
	parent.add_child(section_label)

	# Miner 1
	var miner1_active = player.miner_1_active if "miner_1_active" in player else false
	var miner1_row = _create_module_row("Miner 1", miner1_active, "Mining" if miner1_active else "Offline")
	parent.add_child(miner1_row)

	# Miner 2
	var miner2_active = player.miner_2_active if "miner_2_active" in player else false
	var miner2_row = _create_module_row("Miner 2", miner2_active, "Mining" if miner2_active else "Offline")
	parent.add_child(miner2_row)

func _create_scanner_section(parent: Control, player: Node) -> void:
	"""Create scanner module section"""
	var section_label = create_label("🔍 Scanner Modules", "header")
	section_label.add_theme_color_override("font_color", get_theme().COLOR_ACCENT_CYAN)
	parent.add_child(section_label)

	var scanner_level = 1
	if "ship_data" in player and player.ship_data.has("scanner_level"):
		scanner_level = player.ship_data.scanner_level

	var scanner_row = _create_module_row("Scanner Mk%d" % scanner_level, true, "Active")
	parent.add_child(scanner_row)

func _create_stats_section(parent: Control, player: Node) -> void:
	"""Create ship stats section"""
	var section_label = create_label("📊 Ship Stats", "header")
	section_label.add_theme_color_override("font_color", get_theme().COLOR_STATUS_INFO)
	parent.add_child(section_label)

	if not "ship_data" in player:
		return

	var ship_data = player.ship_data

	# Create stats grid
	var stats_grid = GridContainer.new()
	stats_grid.columns = 2
	parent.add_child(stats_grid)

	# Add stats
	create_stat_row(stats_grid, "Mass:", "%.0f kg" % ship_data.get("mass", 0))
	create_stat_row(stats_grid, "Max Speed:", "%.0f m/s" % ship_data.get("max_speed", 0))
	create_stat_row(stats_grid, "Turn Speed:", "%.0f °/s" % ship_data.get("turn_speed", 0))
	create_stat_row(stats_grid, "Mining Range:", "%.0f m" % ship_data.get("miner_range", 0))

# ============================================================================
# MODULE ROW CREATION
# ============================================================================

func _create_module_row(module_name: String, is_active: bool, status_text: String) -> HBoxContainer:
	"""Create a module status row"""
	var hbox = HBoxContainer.new()
	var theme = get_theme()

	# Status indicator (colored circle)
	var status_dot = create_label("●", "body")
	status_dot.add_theme_color_override("font_color", theme.COLOR_STATUS_ACTIVE if is_active else theme.COLOR_STATUS_DISABLED)
	status_dot.custom_minimum_size = Vector2(20, 0)
	hbox.add_child(status_dot)

	# Module name
	var name_label = create_label(module_name, "body")
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(name_label)

	# Status text
	var status_label = create_label(status_text if is_active else "Offline", "small")
	status_label.add_theme_color_override("font_color", theme.COLOR_TEXT_DIM)
	hbox.add_child(status_label)

	return hbox
