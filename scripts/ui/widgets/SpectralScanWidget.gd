extends BaseWidget
class_name SpectralScanWidget
## Spectral Scan Widget - Detailed scan view with single large mining circle
##
## Displays detailed spectral analysis of currently targeted asteroid

# ============================================================================
# REFERENCES
# ============================================================================

var target_info_label: Label = null
var scan_status_label: Label = null
var spectral_circle: Control = null

const MiningCircleScript = preload("res://scripts/MiningCircle.gd")

# ============================================================================
# INITIALIZATION
# ============================================================================

func initialize_widget() -> void:
	widget_id = "spectral_scan"
	widget_title = "Spectral Analysis"
	update_priority = WindowManager.WidgetUpdatePriority.HIGH
	panel_style = SciFiTheme.PanelStyle.HOLOGRAPHIC

	_build_spectral_ui()

func _build_spectral_ui() -> void:
	"""Build the spectral analysis UI"""
	var content = get_content_container()

	# Target info
	target_info_label = create_label("", "body")
	target_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(target_info_label)

	# Large spectral circle
	spectral_circle = Control.new()
	spectral_circle.set_script(MiningCircleScript)
	spectral_circle.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spectral_circle.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spectral_circle.custom_minimum_size = Vector2(300, 300)
	spectral_circle.name = "SpectralCircle"
	content.add_child(spectral_circle)

	# Scan status
	scan_status_label = create_label("", "small")
	scan_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	scan_status_label.add_theme_color_override("font_color", get_theme().COLOR_STATUS_ACTIVE)
	content.add_child(scan_status_label)

# ============================================================================
# UPDATE
# ============================================================================

func update_widget_data() -> void:
	if not has_data_source():
		show_no_data_message("No Player Data")
		return

	var player = get_data_source()

	if not player.has_method("get_targeted_object"):
		show_no_data_message("No Target Selected\nTarget an asteroid to see detailed scan")
		return

	var targeted = player.get_targeted_object()

	if not targeted or not is_instance_valid(targeted):
		show_no_data_message("No Target Selected\nTarget an asteroid to see detailed scan")
		return

	# Show target info
	_update_target_info(targeted)

	# Update spectral display
	_update_spectral_display(targeted)

func _update_target_info(targeted: Node) -> void:
	"""Update target information"""
	if not target_info_label:
		return

	var target_name = targeted.ore_name if "ore_name" in targeted else "Unknown"
	var target_amount = targeted.amount if "amount" in targeted else 0.0

	target_info_label.text = "Target: %s\nAmount: %.1f units" % [target_name, target_amount]
	target_info_label.visible = true

func _update_spectral_display(targeted: Node) -> void:
	"""Update spectral circle display"""
	if not spectral_circle:
		return

	# Get scan data or live data
	var distribution = {}

	if targeted.has_method("get_scan_data"):
		distribution = targeted.get_scan_data()
	elif targeted.has_method("get_quality_distribution"):
		distribution = targeted.get_quality_distribution()

	if distribution.size() > 0:
		spectral_circle.call("set_quality_distribution", distribution)

		# Show scan status
		if "is_scanned" in targeted and targeted.is_scanned and scan_status_label:
			var scanner_level = targeted.scanner_level if "scanner_level" in targeted else 1
			scan_status_label.text = "Scanned: Mk%d Scanner" % scanner_level
			scan_status_label.visible = true
		else:
			scan_status_label.visible = false
	else:
		if scan_status_label:
			scan_status_label.text = "No scan data available"
			scan_status_label.visible = true
