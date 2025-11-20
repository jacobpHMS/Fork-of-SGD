extends RefCounted
class_name WidgetAnimator
## WidgetAnimator - Smooth animations for widgets and UI elements
##
## Provides pre-configured animation presets for common UI transitions:
## - Fade In/Out
## - Slide In/Out (from all 4 directions)
## - Scale In/Out
## - Bounce
## - Pulse
## - Glow effects
##
## Usage:
##   var animator = WidgetAnimator.new()
##   animator.fade_in(widget, 0.3)
##   animator.slide_in_from_left(widget, 0.5)

# ============================================================================
# ANIMATION PRESETS
# ============================================================================

## Fade in widget (opacity 0 → 1)
static func fade_in(node: Control, duration: float = 0.3, delay: float = 0.0) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	node.modulate.a = 0.0
	node.visible = true

	var tween = node.create_tween()
	if delay > 0:
		tween.tween_interval(delay)

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node, "modulate:a", 1.0, duration)

	return tween

## Fade out widget (opacity 1 → 0)
static func fade_out(node: Control, duration: float = 0.3, hide_on_complete: bool = true) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var tween = node.create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node, "modulate:a", 0.0, duration)

	if hide_on_complete:
		tween.tween_callback(func(): node.visible = false)

	return tween

## Slide in from left
static func slide_in_from_left(node: Control, duration: float = 0.4, distance: float = 200.0) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var original_pos = node.position
	node.position.x = original_pos.x - distance
	node.visible = true

	var tween = node.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "position:x", original_pos.x, duration)

	return tween

## Slide in from right
static func slide_in_from_right(node: Control, duration: float = 0.4, distance: float = 200.0) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var original_pos = node.position
	node.position.x = original_pos.x + distance
	node.visible = true

	var tween = node.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "position:x", original_pos.x, duration)

	return tween

## Slide in from top
static func slide_in_from_top(node: Control, duration: float = 0.4, distance: float = 200.0) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var original_pos = node.position
	node.position.y = original_pos.y - distance
	node.visible = true

	var tween = node.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "position:y", original_pos.y, duration)

	return tween

## Slide in from bottom
static func slide_in_from_bottom(node: Control, duration: float = 0.4, distance: float = 200.0) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var original_pos = node.position
	node.position.y = original_pos.y + distance
	node.visible = true

	var tween = node.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "position:y", original_pos.y, duration)

	return tween

## Slide out to left
static func slide_out_to_left(node: Control, duration: float = 0.3, distance: float = 200.0, hide_on_complete: bool = true) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var target_x = node.position.x - distance

	var tween = node.create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "position:x", target_x, duration)

	if hide_on_complete:
		tween.tween_callback(func(): node.visible = false)

	return tween

## Slide out to right
static func slide_out_to_right(node: Control, duration: float = 0.3, distance: float = 200.0, hide_on_complete: bool = true) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var target_x = node.position.x + distance

	var tween = node.create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "position:x", target_x, duration)

	if hide_on_complete:
		tween.tween_callback(func(): node.visible = false)

	return tween

## Scale in (from 0 → 1)
static func scale_in(node: Control, duration: float = 0.3, from_scale: float = 0.0) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	node.scale = Vector2(from_scale, from_scale)
	node.visible = true

	var tween = node.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "scale", Vector2.ONE, duration)

	return tween

## Scale out (from 1 → 0)
static func scale_out(node: Control, duration: float = 0.3, to_scale: float = 0.0, hide_on_complete: bool = true) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var tween = node.create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "scale", Vector2(to_scale, to_scale), duration)

	if hide_on_complete:
		tween.tween_callback(func(): node.visible = false)

	return tween

## Bounce animation (single bounce)
static func bounce(node: Control, duration: float = 0.5, bounce_height: float = 20.0) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var original_y = node.position.y

	var tween = node.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(node, "position:y", original_y - bounce_height, duration / 2)
	tween.tween_property(node, "position:y", original_y, duration / 2)

	return tween

## Pulse animation (scale up and down)
static func pulse(node: Control, duration: float = 0.6, scale_to: float = 1.1) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var tween = node.create_tween()
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "scale", Vector2(scale_to, scale_to), duration / 2)
	tween.tween_property(node, "scale", Vector2.ONE, duration / 2)

	return tween

## Pulse once (not looping)
static func pulse_once(node: Control, duration: float = 0.6, scale_to: float = 1.1) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var tween = node.create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "scale", Vector2(scale_to, scale_to), duration / 2)
	tween.tween_property(node, "scale", Vector2.ONE, duration / 2)

	return tween

## Glow pulse (modulate alpha)
static func glow_pulse(node: Control, duration: float = 2.0, min_alpha: float = 0.5, max_alpha: float = 1.0) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var tween = node.create_tween()
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "modulate:a", min_alpha, duration / 2)
	tween.tween_property(node, "modulate:a", max_alpha, duration / 2)

	return tween

## Shake animation (for errors, impacts)
static func shake(node: Control, duration: float = 0.5, intensity: float = 10.0) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var original_pos = node.position

	var tween = node.create_tween()

	# Shake left-right rapidly
	for i in range(6):
		var offset_x = randf_range(-intensity, intensity)
		var offset_y = randf_range(-intensity, intensity)
		tween.tween_property(node, "position", original_pos + Vector2(offset_x, offset_y), duration / 12.0)

	# Return to original position
	tween.tween_property(node, "position", original_pos, duration / 12.0)

	return tween

## Rotate in (360° spin while fading in)
static func rotate_in(node: Control, duration: float = 0.5) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	node.rotation = deg_to_rad(360)
	node.modulate.a = 0.0
	node.visible = true

	var tween = node.create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "rotation", 0.0, duration)
	tween.tween_property(node, "modulate:a", 1.0, duration)

	return tween

## Flash animation (quick opacity pulse for notifications)
static func flash(node: Control, duration: float = 0.3, flash_count: int = 3) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	var tween = node.create_tween()

	for i in range(flash_count):
		tween.tween_property(node, "modulate:a", 0.3, duration / (flash_count * 2.0))
		tween.tween_property(node, "modulate:a", 1.0, duration / (flash_count * 2.0))

	return tween

## Combine fade + slide in
static func fade_slide_in(node: Control, direction: String = "bottom", duration: float = 0.4, distance: float = 50.0) -> Tween:
	if not node or not is_instance_valid(node):
		return null

	node.modulate.a = 0.0

	match direction:
		"left":
			return _combine_animations(node, fade_in(node, duration), slide_in_from_left(node, duration, distance))
		"right":
			return _combine_animations(node, fade_in(node, duration), slide_in_from_right(node, duration, distance))
		"top":
			return _combine_animations(node, fade_in(node, duration), slide_in_from_top(node, duration, distance))
		"bottom":
			return _combine_animations(node, fade_in(node, duration), slide_in_from_bottom(node, duration, distance))

	return fade_in(node, duration)

static func _combine_animations(node: Control, _tween1: Tween, _tween2: Tween) -> Tween:
	# Since we're running them separately, just return one
	# They'll both execute
	return _tween1

# ============================================================================
# WIDGET-SPECIFIC ANIMATIONS
# ============================================================================

## Animate widget switching (fade out old, fade in new)
static func switch_widgets(old_widget: Control, new_widget: Control, duration: float = 0.3) -> void:
	if old_widget and is_instance_valid(old_widget):
		fade_out(old_widget, duration / 2, true)

	if new_widget and is_instance_valid(new_widget):
		await get_tree().create_timer(duration / 2).timeout
		fade_in(new_widget, duration / 2)

## Animate panel opening
static func open_panel(panel: Control, animation_type: String = "fade_slide") -> Tween:
	match animation_type:
		"fade":
			return fade_in(panel)
		"slide_left":
			return slide_in_from_left(panel)
		"slide_right":
			return slide_in_from_right(panel)
		"slide_top":
			return slide_in_from_top(panel)
		"slide_bottom":
			return slide_in_from_bottom(panel)
		"scale":
			return scale_in(panel)
		"fade_slide":
			return fade_slide_in(panel, "bottom")
		_:
			return fade_in(panel)

## Animate panel closing
static func close_panel(panel: Control, animation_type: String = "fade") -> Tween:
	match animation_type:
		"fade":
			return fade_out(panel)
		"slide_left":
			return slide_out_to_left(panel)
		"slide_right":
			return slide_out_to_right(panel)
		"scale":
			return scale_out(panel)
		_:
			return fade_out(panel)

# ============================================================================
# UTILITY
# ============================================================================

## Stop all tweens on a node
static func stop_all(node: Control) -> void:
	if not node or not is_instance_valid(node):
		return

	node.get_tree().create_tween().kill()

## Get SceneTree (helper for static functions)
static func get_tree() -> SceneTree:
	return Engine.get_main_loop() as SceneTree
