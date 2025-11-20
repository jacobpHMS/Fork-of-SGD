extends RefCounted
class_name SciFiTheme
## Sci-Fi GUI Theme System
##
## Provides consistent sci-fi visual styling for all UI elements.
## Features:
## - Holographic panel designs with glowing borders
## - Color-coded status indicators (blue/cyan/green/yellow/red)
## - Animated effects (pulsing, breathing, scanlines)
## - Standardized spacing and sizing
## - Dark theme optimized for space environments
##
## Usage:
##   var theme = SciFiTheme.new()
##   panel.add_theme_stylebox_override("panel", theme.create_panel_style(SciFiTheme.PanelStyle.STANDARD))
##   label.add_theme_color_override("font_color", theme.COLOR_ACCENT_CYAN)

# ============================================================================
# COLOR PALETTE - Sci-Fi Inspired
# ============================================================================

## Primary background colors
const COLOR_BG_DARK: Color = Color(0.05, 0.05, 0.08, 0.95)        # Very dark blue-black
const COLOR_BG_MEDIUM: Color = Color(0.08, 0.08, 0.12, 0.9)       # Medium dark
const COLOR_BG_LIGHT: Color = Color(0.12, 0.12, 0.18, 0.85)       # Lighter bg

## Accent colors (holographic style)
const COLOR_ACCENT_CYAN: Color = Color(0.0, 0.8, 1.0, 1.0)        # Main accent (Cyan)
const COLOR_ACCENT_BLUE: Color = Color(0.2, 0.5, 1.0, 1.0)        # Secondary (Blue)
const COLOR_ACCENT_TEAL: Color = Color(0.0, 0.9, 0.8, 1.0)        # Tertiary (Teal)

## Status colors
const COLOR_STATUS_ACTIVE: Color = Color(0.2, 1.0, 0.3, 1.0)      # Green (active/good)
const COLOR_STATUS_WARNING: Color = Color(1.0, 0.8, 0.0, 1.0)     # Yellow (warning)
const COLOR_STATUS_DANGER: Color = Color(1.0, 0.2, 0.2, 1.0)      # Red (danger/critical)
const COLOR_STATUS_DISABLED: Color = Color(0.4, 0.4, 0.45, 1.0)   # Gray (inactive)
const COLOR_STATUS_INFO: Color = Color(0.5, 0.8, 1.0, 1.0)        # Light blue (info)

## Text colors
const COLOR_TEXT_PRIMARY: Color = Color(0.9, 0.95, 1.0, 1.0)      # White-ish
const COLOR_TEXT_SECONDARY: Color = Color(0.6, 0.7, 0.8, 1.0)     # Gray-ish
const COLOR_TEXT_DIM: Color = Color(0.4, 0.45, 0.5, 1.0)          # Dimmed
const COLOR_TEXT_HIGHLIGHT: Color = Color(1.0, 1.0, 1.0, 1.0)     # Pure white

## Quality tier colors (for mining)
const COLOR_QUALITY_Q0: Color = Color(0.5, 0.5, 0.5, 1.0)         # Gray
const COLOR_QUALITY_Q1: Color = Color(0.8, 0.8, 0.8, 1.0)         # Light Gray
const COLOR_QUALITY_Q2: Color = Color(0.6, 0.8, 1.0, 1.0)         # Light Blue
const COLOR_QUALITY_Q3: Color = Color(0.2, 0.8, 0.3, 1.0)         # Green
const COLOR_QUALITY_Q4: Color = Color(1.0, 0.8, 0.2, 1.0)         # Yellow
const COLOR_QUALITY_Q5: Color = Color(1.0, 0.5, 0.2, 1.0)         # Orange

# ============================================================================
# ENUMS
# ============================================================================

enum PanelStyle {
	STANDARD,       ## Normal panel with borders
	HOLOGRAPHIC,    ## Holographic effect (more transparent, glowing)
	TACTICAL,       ## Combat/tactical style (red accents)
	ENGINEERING,    ## Engineering/technical (yellow/orange)
	CRITICAL,       ## Critical status (red, pulsing)
	SUCCESS,        ## Success status (green)
	FLAT            ## Flat style, minimal borders
}

enum BorderGlow {
	NONE,           ## No glow
	SUBTLE,         ## Slight glow
	MEDIUM,         ## Medium glow
	STRONG,         ## Strong glow
	PULSING         ## Animated pulsing glow
}

# ============================================================================
# SIZING CONSTANTS
# ============================================================================

const BORDER_WIDTH_THIN: int = 1
const BORDER_WIDTH_MEDIUM: int = 2
const BORDER_WIDTH_THICK: int = 3

const CORNER_RADIUS_SMALL: int = 2
const CORNER_RADIUS_MEDIUM: int = 4
const CORNER_RADIUS_LARGE: int = 8

const PADDING_SMALL: int = 4
const PADDING_MEDIUM: int = 8
const PADDING_LARGE: int = 12

# ============================================================================
# PANEL STYLE CREATION
# ============================================================================

func create_panel_style(style: PanelStyle = PanelStyle.STANDARD, glow: BorderGlow = BorderGlow.SUBTLE) -> StyleBoxFlat:
	"""Create a styled panel background"""
	var stylebox = StyleBoxFlat.new()

	# Set base properties based on style
	match style:
		PanelStyle.STANDARD:
			_apply_standard_style(stylebox)
		PanelStyle.HOLOGRAPHIC:
			_apply_holographic_style(stylebox)
		PanelStyle.TACTICAL:
			_apply_tactical_style(stylebox)
		PanelStyle.ENGINEERING:
			_apply_engineering_style(stylebox)
		PanelStyle.CRITICAL:
			_apply_critical_style(stylebox)
		PanelStyle.SUCCESS:
			_apply_success_style(stylebox)
		PanelStyle.FLAT:
			_apply_flat_style(stylebox)

	# Apply glow effect
	_apply_glow_effect(stylebox, glow)

	return stylebox

func _apply_standard_style(stylebox: StyleBoxFlat) -> void:
	"""Standard sci-fi panel"""
	stylebox.bg_color = COLOR_BG_DARK
	stylebox.border_width_left = BORDER_WIDTH_MEDIUM
	stylebox.border_width_right = BORDER_WIDTH_MEDIUM
	stylebox.border_width_top = BORDER_WIDTH_MEDIUM
	stylebox.border_width_bottom = BORDER_WIDTH_MEDIUM
	stylebox.border_color = COLOR_ACCENT_CYAN
	stylebox.corner_radius_top_left = CORNER_RADIUS_SMALL
	stylebox.corner_radius_top_right = CORNER_RADIUS_SMALL
	stylebox.corner_radius_bottom_left = CORNER_RADIUS_SMALL
	stylebox.corner_radius_bottom_right = CORNER_RADIUS_SMALL
	stylebox.content_margin_left = PADDING_MEDIUM
	stylebox.content_margin_right = PADDING_MEDIUM
	stylebox.content_margin_top = PADDING_MEDIUM
	stylebox.content_margin_bottom = PADDING_MEDIUM

func _apply_holographic_style(stylebox: StyleBoxFlat) -> void:
	"""Holographic transparent panel"""
	stylebox.bg_color = Color(0.05, 0.15, 0.25, 0.7)  # More transparent
	stylebox.border_width_left = BORDER_WIDTH_MEDIUM
	stylebox.border_width_right = BORDER_WIDTH_MEDIUM
	stylebox.border_width_top = BORDER_WIDTH_MEDIUM
	stylebox.border_width_bottom = BORDER_WIDTH_MEDIUM
	stylebox.border_color = COLOR_ACCENT_TEAL
	stylebox.corner_radius_top_left = CORNER_RADIUS_MEDIUM
	stylebox.corner_radius_top_right = CORNER_RADIUS_MEDIUM
	stylebox.corner_radius_bottom_left = CORNER_RADIUS_MEDIUM
	stylebox.corner_radius_bottom_right = CORNER_RADIUS_MEDIUM
	stylebox.content_margin_left = PADDING_MEDIUM
	stylebox.content_margin_right = PADDING_MEDIUM
	stylebox.content_margin_top = PADDING_MEDIUM
	stylebox.content_margin_bottom = PADDING_MEDIUM

func _apply_tactical_style(stylebox: StyleBoxFlat) -> void:
	"""Tactical/combat red style"""
	stylebox.bg_color = Color(0.1, 0.05, 0.05, 0.9)
	stylebox.border_width_left = BORDER_WIDTH_THICK
	stylebox.border_width_right = BORDER_WIDTH_THICK
	stylebox.border_width_top = BORDER_WIDTH_THICK
	stylebox.border_width_bottom = BORDER_WIDTH_THICK
	stylebox.border_color = COLOR_STATUS_DANGER
	stylebox.corner_radius_top_left = CORNER_RADIUS_SMALL
	stylebox.corner_radius_top_right = CORNER_RADIUS_SMALL
	stylebox.corner_radius_bottom_left = CORNER_RADIUS_SMALL
	stylebox.corner_radius_bottom_right = CORNER_RADIUS_SMALL
	stylebox.content_margin_left = PADDING_MEDIUM
	stylebox.content_margin_right = PADDING_MEDIUM
	stylebox.content_margin_top = PADDING_MEDIUM
	stylebox.content_margin_bottom = PADDING_MEDIUM

func _apply_engineering_style(stylebox: StyleBoxFlat) -> void:
	"""Engineering/technical yellow style"""
	stylebox.bg_color = Color(0.1, 0.08, 0.05, 0.9)
	stylebox.border_width_left = BORDER_WIDTH_MEDIUM
	stylebox.border_width_right = BORDER_WIDTH_MEDIUM
	stylebox.border_width_top = BORDER_WIDTH_MEDIUM
	stylebox.border_width_bottom = BORDER_WIDTH_MEDIUM
	stylebox.border_color = COLOR_STATUS_WARNING
	stylebox.corner_radius_top_left = CORNER_RADIUS_MEDIUM
	stylebox.corner_radius_top_right = CORNER_RADIUS_MEDIUM
	stylebox.corner_radius_bottom_left = CORNER_RADIUS_MEDIUM
	stylebox.corner_radius_bottom_right = CORNER_RADIUS_MEDIUM
	stylebox.content_margin_left = PADDING_MEDIUM
	stylebox.content_margin_right = PADDING_MEDIUM
	stylebox.content_margin_top = PADDING_MEDIUM
	stylebox.content_margin_bottom = PADDING_MEDIUM

func _apply_critical_style(stylebox: StyleBoxFlat) -> void:
	"""Critical status red style"""
	stylebox.bg_color = Color(0.15, 0.05, 0.05, 0.95)
	stylebox.border_width_left = BORDER_WIDTH_THICK
	stylebox.border_width_right = BORDER_WIDTH_THICK
	stylebox.border_width_top = BORDER_WIDTH_THICK
	stylebox.border_width_bottom = BORDER_WIDTH_THICK
	stylebox.border_color = COLOR_STATUS_DANGER
	stylebox.corner_radius_top_left = CORNER_RADIUS_SMALL
	stylebox.corner_radius_top_right = CORNER_RADIUS_SMALL
	stylebox.corner_radius_bottom_left = CORNER_RADIUS_SMALL
	stylebox.corner_radius_bottom_right = CORNER_RADIUS_SMALL
	stylebox.content_margin_left = PADDING_LARGE
	stylebox.content_margin_right = PADDING_LARGE
	stylebox.content_margin_top = PADDING_LARGE
	stylebox.content_margin_bottom = PADDING_LARGE

func _apply_success_style(stylebox: StyleBoxFlat) -> void:
	"""Success status green style"""
	stylebox.bg_color = Color(0.05, 0.1, 0.05, 0.9)
	stylebox.border_width_left = BORDER_WIDTH_MEDIUM
	stylebox.border_width_right = BORDER_WIDTH_MEDIUM
	stylebox.border_width_top = BORDER_WIDTH_MEDIUM
	stylebox.border_width_bottom = BORDER_WIDTH_MEDIUM
	stylebox.border_color = COLOR_STATUS_ACTIVE
	stylebox.corner_radius_top_left = CORNER_RADIUS_MEDIUM
	stylebox.corner_radius_top_right = CORNER_RADIUS_MEDIUM
	stylebox.corner_radius_bottom_left = CORNER_RADIUS_MEDIUM
	stylebox.corner_radius_bottom_right = CORNER_RADIUS_MEDIUM
	stylebox.content_margin_left = PADDING_MEDIUM
	stylebox.content_margin_right = PADDING_MEDIUM
	stylebox.content_margin_top = PADDING_MEDIUM
	stylebox.content_margin_bottom = PADDING_MEDIUM

func _apply_flat_style(stylebox: StyleBoxFlat) -> void:
	"""Flat minimal style"""
	stylebox.bg_color = COLOR_BG_MEDIUM
	stylebox.border_width_left = BORDER_WIDTH_THIN
	stylebox.border_width_right = BORDER_WIDTH_THIN
	stylebox.border_width_top = BORDER_WIDTH_THIN
	stylebox.border_width_bottom = BORDER_WIDTH_THIN
	stylebox.border_color = Color(0.2, 0.25, 0.3, 1.0)
	stylebox.corner_radius_top_left = 0
	stylebox.corner_radius_top_right = 0
	stylebox.corner_radius_bottom_left = 0
	stylebox.corner_radius_bottom_right = 0
	stylebox.content_margin_left = PADDING_SMALL
	stylebox.content_margin_right = PADDING_SMALL
	stylebox.content_margin_top = PADDING_SMALL
	stylebox.content_margin_bottom = PADDING_SMALL

func _apply_glow_effect(stylebox: StyleBoxFlat, glow: BorderGlow) -> void:
	"""Apply shadow/glow effect to borders"""
	match glow:
		BorderGlow.NONE:
			stylebox.shadow_size = 0
		BorderGlow.SUBTLE:
			stylebox.shadow_size = 2
			stylebox.shadow_color = Color(stylebox.border_color.r, stylebox.border_color.g, stylebox.border_color.b, 0.3)
		BorderGlow.MEDIUM:
			stylebox.shadow_size = 4
			stylebox.shadow_color = Color(stylebox.border_color.r, stylebox.border_color.g, stylebox.border_color.b, 0.5)
		BorderGlow.STRONG:
			stylebox.shadow_size = 6
			stylebox.shadow_color = Color(stylebox.border_color.r, stylebox.border_color.g, stylebox.border_color.b, 0.7)
		BorderGlow.PULSING:
			stylebox.shadow_size = 5
			stylebox.shadow_color = Color(stylebox.border_color.r, stylebox.border_color.g, stylebox.border_color.b, 0.6)
			# Note: Pulsing animation needs to be handled by widget itself

# ============================================================================
# BUTTON STYLES
# ============================================================================

func create_button_style(state: String = "normal", color: Color = COLOR_ACCENT_CYAN) -> StyleBoxFlat:
	"""Create button style (normal, hover, pressed, disabled)"""
	var stylebox = StyleBoxFlat.new()

	match state:
		"normal":
			stylebox.bg_color = Color(color.r * 0.2, color.g * 0.2, color.b * 0.2, 0.8)
			stylebox.border_color = color
		"hover":
			stylebox.bg_color = Color(color.r * 0.4, color.g * 0.4, color.b * 0.4, 0.9)
			stylebox.border_color = color.lightened(0.2)
		"pressed":
			stylebox.bg_color = Color(color.r * 0.6, color.g * 0.6, color.b * 0.6, 1.0)
			stylebox.border_color = color.lightened(0.4)
		"disabled":
			stylebox.bg_color = Color(0.1, 0.1, 0.1, 0.6)
			stylebox.border_color = COLOR_STATUS_DISABLED

	stylebox.border_width_left = BORDER_WIDTH_MEDIUM
	stylebox.border_width_right = BORDER_WIDTH_MEDIUM
	stylebox.border_width_top = BORDER_WIDTH_MEDIUM
	stylebox.border_width_bottom = BORDER_WIDTH_MEDIUM
	stylebox.corner_radius_top_left = CORNER_RADIUS_SMALL
	stylebox.corner_radius_top_right = CORNER_RADIUS_SMALL
	stylebox.corner_radius_bottom_left = CORNER_RADIUS_SMALL
	stylebox.corner_radius_bottom_right = CORNER_RADIUS_SMALL
	stylebox.content_margin_left = PADDING_MEDIUM
	stylebox.content_margin_right = PADDING_MEDIUM
	stylebox.content_margin_top = PADDING_SMALL
	stylebox.content_margin_bottom = PADDING_SMALL

	return stylebox

# ============================================================================
# PROGRESS BAR STYLES
# ============================================================================

func create_progressbar_style(fill_color: Color = COLOR_ACCENT_CYAN) -> Dictionary:
	"""Create progress bar styles (background + fill)"""
	var bg = StyleBoxFlat.new()
	bg.bg_color = COLOR_BG_DARK
	bg.border_width_left = BORDER_WIDTH_THIN
	bg.border_width_right = BORDER_WIDTH_THIN
	bg.border_width_top = BORDER_WIDTH_THIN
	bg.border_width_bottom = BORDER_WIDTH_THIN
	bg.border_color = Color(0.2, 0.25, 0.3, 1.0)

	var fill = StyleBoxFlat.new()
	fill.bg_color = fill_color
	fill.border_width_left = 0
	fill.border_width_right = 0
	fill.border_width_top = 0
	fill.border_width_bottom = 0

	return {
		"background": bg,
		"fill": fill
	}

# ============================================================================
# LABEL STYLES
# ============================================================================

func apply_title_style(label: Label, color: Color = COLOR_TEXT_PRIMARY) -> void:
	"""Apply title label styling"""
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func apply_header_style(label: Label, color: Color = COLOR_ACCENT_CYAN) -> void:
	"""Apply header label styling"""
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", color)

func apply_body_style(label: Label, color: Color = COLOR_TEXT_SECONDARY) -> void:
	"""Apply body text styling"""
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", color)

func apply_small_style(label: Label, color: Color = COLOR_TEXT_DIM) -> void:
	"""Apply small text styling"""
	label.add_theme_font_size_override("font_size", 8)
	label.add_theme_color_override("font_color", color)

# ============================================================================
# SEPARATOR STYLES
# ============================================================================

func create_separator() -> HSeparator:
	"""Create styled horizontal separator"""
	var sep = HSeparator.new()

	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = COLOR_ACCENT_CYAN
	stylebox.content_margin_top = 1
	stylebox.content_margin_bottom = 1

	sep.add_theme_stylebox_override("separator", stylebox)

	return sep

# ============================================================================
# STATUS INDICATOR
# ============================================================================

func get_status_color(status: String) -> Color:
	"""Get color for status text"""
	match status.to_lower():
		"active", "online", "operational", "good":
			return COLOR_STATUS_ACTIVE
		"warning", "degraded", "caution":
			return COLOR_STATUS_WARNING
		"critical", "danger", "offline", "failed":
			return COLOR_STATUS_DANGER
		"disabled", "inactive", "offline":
			return COLOR_STATUS_DISABLED
		_:
			return COLOR_STATUS_INFO

func create_status_indicator(status: String) -> Label:
	"""Create visual status indicator (colored dot + text)"""
	var label = Label.new()
	label.text = "● " + status.capitalize()
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", get_status_color(status))
	return label

# ============================================================================
# ANIMATION HELPERS
# ============================================================================

func create_pulse_animation(node: Control, property: String = "modulate:a", duration: float = 1.0) -> Tween:
	"""Create pulsing opacity animation"""
	var tween = node.create_tween()
	tween.set_loops()
	tween.tween_property(node, property, 0.5, duration / 2.0)
	tween.tween_property(node, property, 1.0, duration / 2.0)
	return tween

func create_glow_pulse_animation(node: Control, min_alpha: float = 0.3, max_alpha: float = 0.8, duration: float = 2.0) -> Tween:
	"""Create glowing pulse effect on modulate"""
	var tween = node.create_tween()
	tween.set_loops()
	tween.tween_property(node, "modulate:a", min_alpha, duration / 2.0).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "modulate:a", max_alpha, duration / 2.0).set_ease(Tween.EASE_IN_OUT)
	return tween

# ============================================================================
# QUALITY COLOR HELPERS
# ============================================================================

func get_quality_color(quality: String) -> Color:
	"""Get color for quality tier (Q0-Q5)"""
	match quality:
		"Q0": return COLOR_QUALITY_Q0
		"Q1": return COLOR_QUALITY_Q1
		"Q2": return COLOR_QUALITY_Q2
		"Q3": return COLOR_QUALITY_Q3
		"Q4": return COLOR_QUALITY_Q4
		"Q5": return COLOR_QUALITY_Q5
		_: return COLOR_TEXT_SECONDARY
