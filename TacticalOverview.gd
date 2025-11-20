extends PanelContainer

## Tactical Overview Panel - Draggable and Resizable

# UI References
@onready var title_label = $VBox/Title
@onready var object_list = $VBox/ObjectList
@onready var details_label = $VBox/DetailsLabel

# Dragging
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

# Resizing
var is_resizing: bool = false
var resize_start_size: Vector2 = Vector2.ZERO
var resize_start_mouse: Vector2 = Vector2.ZERO
var resize_handle_size: float = 20.0  # Size of resize handle area
var min_size: Vector2 = Vector2(300, 400)  # Minimum panel size

# Resize mode
enum ResizeMode { NONE, WIDTH, HEIGHT, BOTH }
var current_resize_mode: ResizeMode = ResizeMode.NONE

func _ready():
	# Enable mouse input
	mouse_filter = Control.MOUSE_FILTER_PASS

	# Set initial size
	custom_minimum_size = min_size

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var local_pos = event.position
				var panel_size = size

				# Check if clicking in resize area (bottom-right corner)
				var in_resize_width = local_pos.x <= resize_handle_size
				var in_resize_height = local_pos.y >= panel_size.y - resize_handle_size
				var in_title_bar = local_pos.y < 40 and local_pos.x > resize_handle_size

				if in_resize_width and in_resize_height:
					# Both width and height resize
					start_resize(ResizeMode.BOTH, event.global_position)
				elif in_resize_width:
					# Width only resize
					start_resize(ResizeMode.WIDTH, event.global_position)
				elif in_resize_height:
					# Height only resize
					start_resize(ResizeMode.HEIGHT, event.global_position)
				elif in_title_bar:
					# Start dragging
					is_dragging = true
					drag_offset = position - get_global_mouse_position()
			else:
				# Release
				is_dragging = false
				is_resizing = false
				current_resize_mode = ResizeMode.NONE

	elif event is InputEventMouseMotion:
		if is_dragging:
			# Update position while dragging
			position = get_global_mouse_position() + drag_offset
			clamp_to_screen()
		elif is_resizing:
			# Update size while resizing
			var mouse_delta = event.global_position - resize_start_mouse
			var new_size = resize_start_size

			match current_resize_mode:
				ResizeMode.WIDTH:
					# Resize width (left edge, so subtract delta)
					new_size.x = max(min_size.x, resize_start_size.x - mouse_delta.x)
					# Also adjust position to keep right edge fixed
					var size_diff = new_size.x - size.x
					position.x -= size_diff
				ResizeMode.HEIGHT:
					# Resize height (bottom edge)
					new_size.y = max(min_size.y, resize_start_size.y + mouse_delta.y)
				ResizeMode.BOTH:
					# Resize both
					new_size.x = max(min_size.x, resize_start_size.x - mouse_delta.x)
					new_size.y = max(min_size.y, resize_start_size.y + mouse_delta.y)
					var size_diff_x = new_size.x - size.x
					position.x -= size_diff_x

			custom_minimum_size = new_size
			size = new_size
		else:
			# Update cursor based on hover position
			update_cursor(event.position)

func start_resize(mode: ResizeMode, mouse_pos: Vector2):
	"""Start resize operation"""
	is_resizing = true
	current_resize_mode = mode
	resize_start_size = size
	resize_start_mouse = mouse_pos

func update_cursor(local_pos: Vector2):
	"""Update mouse cursor based on position"""
	var panel_size = size
	var in_resize_width = local_pos.x <= resize_handle_size
	var in_resize_height = local_pos.y >= panel_size.y - resize_handle_size

	if in_resize_width and in_resize_height:
		mouse_default_cursor_shape = Control.CURSOR_FDIAGSIZE  # Diagonal resize
	elif in_resize_width:
		mouse_default_cursor_shape = Control.CURSOR_HSIZE  # Horizontal resize
	elif in_resize_height:
		mouse_default_cursor_shape = Control.CURSOR_VSIZE  # Vertical resize
	else:
		mouse_default_cursor_shape = Control.CURSOR_ARROW

func clamp_to_screen():
	"""Keep panel within screen bounds"""
	var screen_size = get_viewport_rect().size
	var panel_size = size

	position.x = clamp(position.x, 0, screen_size.x - panel_size.x)
	position.y = clamp(position.y, 0, screen_size.y - panel_size.y)

func _draw():
	"""Draw resize handles"""
	var panel_size = size

	# Draw left edge resize handle
	draw_rect(Rect2(0, 0, resize_handle_size, panel_size.y), Color(0.3, 0.8, 1.0, 0.3))

	# Draw bottom edge resize handle
	draw_rect(Rect2(0, panel_size.y - resize_handle_size, panel_size.x, resize_handle_size), Color(0.3, 0.8, 1.0, 0.3))

	# Draw corner resize handle (both)
	draw_rect(Rect2(0, panel_size.y - resize_handle_size, resize_handle_size, resize_handle_size), Color(0.3, 0.8, 1.0, 0.5))
