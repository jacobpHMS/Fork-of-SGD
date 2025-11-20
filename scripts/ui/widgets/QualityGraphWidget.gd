extends BaseWidget
class_name QualityGraphWidget
## Quality Distribution Widget - Bar chart visualization of ore quality
##
## Displays quality distribution (Q0-Q5) as horizontal bar chart

# ============================================================================
# REFERENCES
# ============================================================================

var target_name_label: Label = null
var chart_container: VBoxContainer = null

# ============================================================================
# INITIALIZATION
# ============================================================================

func initialize_widget() -> void:
	widget_id = "quality_graph"
	widget_title = "Quality Distribution"
	update_priority = WindowManager.WidgetUpdatePriority.MEDIUM
	panel_style = SciFiTheme.PanelStyle.STANDARD

	_build_graph_ui()

func _build_graph_ui() -> void:
	"""Build the quality graph UI"""
	var content = get_content_container()

	# Target name
	target_name_label = create_label("", "body")
	target_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(target_name_label)

	# Chart container
	chart_container = VBoxContainer.new()
	chart_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(chart_container)

# ============================================================================
# UPDATE
# ============================================================================

func update_widget_data() -> void:
	if not has_data_source():
		show_no_data_message("No Player Data")
		return

	var player = get_data_source()

	if not player.has_method("get_targeted_object"):
		show_no_data_message("No Target Selected\nTarget and scan an asteroid")
		return

	var targeted = player.get_targeted_object()

	if not targeted or not is_instance_valid(targeted):
		show_no_data_message("No Target Selected\nTarget and scan an asteroid")
		return

	# Get quality distribution
	var distribution = {}

	if targeted.has_method("get_scan_data"):
		distribution = targeted.get_scan_data()
	elif targeted.has_method("get_quality_distribution"):
		distribution = targeted.get_quality_distribution()

	if distribution.size() == 0:
		show_no_data_message("No Quality Data\nTarget and scan an asteroid")
		return

	# Update display
	_update_quality_chart(targeted, distribution)

func _update_quality_chart(targeted: Node, distribution: Dictionary) -> void:
	"""Update quality chart display"""
	# Clear existing chart
	for child in chart_container.get_children():
		child.queue_free()

	# Update target name
	var target_name = targeted.ore_name if "ore_name" in targeted else "Unknown"
	target_name_label.text = "Target: %s" % target_name

	# Create bars for each quality level
	var quality_levels = ["Q0", "Q1", "Q2", "Q3", "Q4", "Q5"]
	var theme = get_theme()

	for quality in quality_levels:
		var percentage = distribution.get(quality, 0.0)

		# HBox for quality label + bar + percentage
		var hbox = HBoxContainer.new()
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		chart_container.add_child(hbox)

		# Quality label
		var qlabel = create_label(quality, "small")
		qlabel.custom_minimum_size = Vector2(30, 0)
		hbox.add_child(qlabel)

		# Progress bar
		var bar = create_progress_bar(0, 100, theme.get_quality_color(quality))
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bar.value = percentage
		bar.show_percentage = false
		hbox.add_child(bar)

		# Percentage label
		var plabel = create_label("%.1f%%" % percentage, "small")
		plabel.custom_minimum_size = Vector2(50, 0)
		plabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		hbox.add_child(plabel)
