extends PanelContainer
class_name DraggableWindow

## A draggable window UI component
## Can be toggled on/off and moved around the screen

# Window state
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var is_visible_state: bool = true

# References
@onready var title_bar: Control = null
@onready var close_button: Button = null

# Signals
signal window_closed
signal window_opened

func _ready():
	# Try to find title bar (first child that has "TitleBar" in name)
	for child in get_children():
		if "TitleBar" in child.name or "Title" in child.name:
			title_bar = child
			break

	# Try to find close button
	if title_bar:
		for child in title_bar.get_children():
			if child is Button and ("Close" in child.name or "X" in child.name):
				close_button = child
				close_button.pressed.connect(_on_close_pressed)
				break

	# Set initial visibility
	visible = is_visible_state

func _gui_input(event):
	# Check if clicking on title bar area
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Check if click is in title bar region (top 40 pixels)
				var local_pos = event.position
				if local_pos.y < 40:
					is_dragging = true
					drag_offset = global_position - get_global_mouse_position()
			else:
				is_dragging = false

	# Handle dragging
	elif event is InputEventMouseMotion:
		if is_dragging:
			global_position = get_global_mouse_position() + drag_offset
			# Clamp to screen bounds
			clamp_to_screen()

func clamp_to_screen():
	"""Keep window within screen bounds"""
	var screen_size = get_viewport_rect().size
	var window_size = size

	global_position.x = clamp(global_position.x, 0, screen_size.x - window_size.x)
	global_position.y = clamp(global_position.y, 0, screen_size.y - window_size.y)

func toggle_window():
	"""Toggle window visibility"""
	is_visible_state = not is_visible_state
	visible = is_visible_state

	if is_visible_state:
		window_opened.emit()
	else:
		window_closed.emit()

func show_window():
	"""Show the window"""
	is_visible_state = true
	visible = true
	window_opened.emit()

func hide_window():
	"""Hide the window"""
	is_visible_state = false
	visible = false
	window_closed.emit()

func _on_close_pressed():
	"""Close button clicked"""
	hide_window()

func set_window_title(title: String):
	"""Set window title text"""
	if title_bar:
		for child in title_bar.get_children():
			if child is Label:
				child.text = title
				return
