extends Node
class_name DistanceHelper

## Helper class for calculating distances using bounding boxes

static func get_distance_to_bounds(from: Node2D, to: Node2D) -> float:
	"""Calculate distance from one object's edge to another's edge"""

	if not is_instance_valid(from) or not is_instance_valid(to):
		return INF

	# Get bounding box sizes
	var from_size = get_bounding_box_size(from)
	var to_size = get_bounding_box_size(to)

	# Calculate center-to-center distance
	var center_distance = from.global_position.distance_to(to.global_position)

	# Calculate radii (half sizes)
	var from_radius = from_size / 2.0
	var to_radius = to_size / 2.0

	# Calculate edge-to-edge distance
	var edge_distance = center_distance - from_radius - to_radius

	# Clamp to 0 minimum (objects are overlapping if negative)
	return max(0.0, edge_distance)

static func get_bounding_box_size(node: Node2D) -> float:
	"""Get approximate bounding box size (radius) of a node"""

	# Check for CollisionShape2D
	for child in node.get_children():
		if child is CollisionShape2D:
			var shape = child.shape
			if shape is CircleShape2D:
				return shape.radius * 2.0
			elif shape is RectangleShape2D:
				var size = shape.size
				return max(size.x, size.y)
			elif shape is CapsuleShape2D:
				return max(shape.radius * 2.0, shape.height)

	# Check for Sprite2D
	for child in node.get_children():
		if child is Sprite2D and child.texture:
			var texture_size = child.texture.get_size()
			var scale = child.scale
			var scaled_size = texture_size * scale
			return max(scaled_size.x, scaled_size.y)

	# Default fallback size
	return 40.0

static func get_closest_point_on_bounds(from: Node2D, to: Node2D) -> Vector2:
	"""Get closest point on 'to' object's bounds from 'from' object"""

	if not is_instance_valid(from) or not is_instance_valid(to):
		return Vector2.ZERO

	# Direction from 'from' to 'to'
	var direction = (to.global_position - from.global_position).normalized()

	# Get 'to' object's radius
	var to_radius = get_bounding_box_size(to) / 2.0

	# Calculate closest point on bounds
	var closest_point = to.global_position - direction * to_radius

	return closest_point
