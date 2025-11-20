extends Control

## Mining Circle Display - Shows quality tiers as concentric circles
## Displays Q0-Q5 quality distribution for an ore asteroid

# Quality distribution data
var quality_distribution: Dictionary = {
	"Q0": 5.0,   # 5%
	"Q1": 15.0,  # 15%
	"Q2": 35.0,  # 35%
	"Q3": 30.0,  # 30%
	"Q4": 12.0,  # 12%
	"Q5": 3.0    # 3%
}

# Mining state
var mining_active: bool = false
var mining_progress: float = 0.0  # 0.0 - 1.0
var selected_quality: String = "Q2"  # Default target quality

# Visual settings
var circle_center: Vector2 = Vector2.ZERO
var max_radius: float = 100.0
var min_radius: float = 10.0

# Quality tier colors
var quality_colors: Dictionary = {
	"Q0": Color(1.0, 0.0, 0.0),      # Red
	"Q1": Color(0.53, 0.53, 0.53),  # Gray
	"Q2": Color(0.0, 0.53, 1.0),    # Blue
	"Q3": Color(0.0, 1.0, 0.0),      # Green
	"Q4": Color(1.0, 0.67, 0.0),    # Dark Yellow
	"Q5": Color(1.0, 0.84, 0.0)      # Gold
}

func _ready():
	custom_minimum_size = Vector2(200, 200)
	mouse_filter = Control.MOUSE_FILTER_PASS

func _draw():
	if size.x == 0 or size.y == 0:
		return

	# Calculate center
	circle_center = size / 2.0
	max_radius = min(size.x, size.y) / 2.0 - 10.0

	# Draw concentric circles from outside to inside (Q0 to Q5)
	var quality_tiers = ["Q0", "Q1", "Q2", "Q3", "Q4", "Q5"]
	quality_tiers.reverse()  # Draw from Q5 (center) to Q0 (outside)

	var cumulative_percent = 0.0
	for tier in quality_tiers:
		cumulative_percent += quality_distribution.get(tier, 0.0)
		var radius = (cumulative_percent / 100.0) * max_radius
		radius = max(radius, min_radius)

		# Determine color
		var color = quality_colors.get(tier, Color.WHITE)

		# Highlight selected quality
		if tier == selected_quality:
			color = color.lightened(0.3)

		# Draw filled circle
		draw_circle(circle_center, radius, color)

		# Draw border
		draw_arc(circle_center, radius, 0, TAU, 64, Color.WHITE, 2.0)

	# Draw mining progress arc if active
	if mining_active and mining_progress > 0.0:
		var progress_color = Color(1.0, 1.0, 0.0, 0.8)  # Yellow
		var arc_end = mining_progress * TAU
		draw_arc(circle_center, max_radius + 5.0, 0, arc_end, 64, progress_color, 4.0)

	# Draw quality labels
	draw_quality_labels()

	# Draw center text
	var center_text = "%s Target" % selected_quality
	var font = get_theme_default_font()
	var font_size = 14
	var text_size = font.get_string_size(center_text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
	draw_string(font, circle_center - text_size / 2.0, center_text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color.WHITE)

func draw_quality_labels():
	"""Draw quality tier labels around circles"""
	var quality_tiers = ["Q0", "Q1", "Q2", "Q3", "Q4", "Q5"]
	var font = get_theme_default_font()
	var font_size = 12

	var cumulative_percent = 0.0
	for i in range(quality_tiers.size()):
		var tier = quality_tiers[i]
		var percent = quality_distribution.get(tier, 0.0)
		cumulative_percent += percent

		var radius = (cumulative_percent / 100.0) * max_radius
		radius = max(radius, min_radius)

		# Position label to the right of circle
		var label_pos = circle_center + Vector2(radius + 10, i * 15 - 40)
		var label_text = "%s: %.1f%%" % [tier, percent]

		draw_string(font, label_pos, label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, quality_colors.get(tier, Color.WHITE))

func set_quality_distribution(distribution: Dictionary):
	"""Update quality distribution data"""
	quality_distribution = distribution
	queue_redraw()

func set_mining_progress(progress: float):
	"""Update mining progress (0.0 - 1.0)"""
	mining_progress = clamp(progress, 0.0, 1.0)
	queue_redraw()

func set_mining_active(active: bool):
	"""Set mining active state"""
	mining_active = active
	queue_redraw()

func set_selected_quality(quality: String):
	"""Set target quality tier"""
	selected_quality = quality
	queue_redraw()

func _gui_input(event):
	"""Handle click to select quality tier"""
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# Calculate which quality tier was clicked
			var local_pos = event.position
			var distance = local_pos.distance_to(circle_center)

			# Find which tier corresponds to this distance
			var cumulative_percent = 0.0
			var quality_tiers = ["Q0", "Q1", "Q2", "Q3", "Q4", "Q5"]

			for tier in quality_tiers:
				var percent = quality_distribution.get(tier, 0.0)
				cumulative_percent += percent
				var radius = (cumulative_percent / 100.0) * max_radius

				if distance <= radius:
					set_selected_quality(tier)
					print("Selected quality tier: ", tier)
					break
