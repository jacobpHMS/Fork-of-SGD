extends BaseWidget
class_name TacticalDisplayWidget
## Tactical Display Widget - Shows tactical situation overview
##
## Displays nearby threats, friendly ships, and tactical information
## TODO: Implement full tactical display in future version

# ============================================================================
# INITIALIZATION
# ============================================================================

func initialize_widget() -> void:
	widget_id = "tactical_display"
	widget_title = "Tactical Situation"
	update_priority = WindowManager.WidgetUpdatePriority.LOW
	panel_style = SciFiTheme.PanelStyle.TACTICAL

	_build_tactical_ui()

func _build_tactical_ui() -> void:
	"""Build tactical display UI"""
	var content = get_content_container()

	var placeholder = create_label("[Tactical Display]\nFuture Implementation:\n• Nearby ships radar\n• Threat assessment\n• Fleet positions\n• Combat status", "body")
	placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	placeholder.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	placeholder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	placeholder.add_theme_color_override("font_color", get_theme().COLOR_TEXT_DIM)
	content.add_child(placeholder)

# ============================================================================
# UPDATE
# ============================================================================

func update_widget_data() -> void:
	# TODO: Implement tactical display updates
	pass
