extends Control

# Radial menu with 12 options
var menu_items = [
	{"icon": "↑", "text": "Fly To", "action": "fly_to"},
	{"icon": "⛏", "text": "Mine Ore", "action": "mine_ore"},
	{"icon": "🔄", "text": "Orbit", "action": "orbit"},
	{"icon": "⚓", "text": "Hold Position", "action": "hold_position"},
	{"icon": "⏸", "text": "Stop", "action": "stop"},
	{"icon": "📤", "text": "Eject", "action": "eject"},
	{"icon": "↔", "text": "Transfer", "action": "transfer"},
	{"icon": "🔍", "text": "Scan", "action": "scan"},
	{"icon": "⚡", "text": "Activate", "action": "activate"},
	{"icon": "🎯", "text": "Target", "action": "target"},
	{"icon": "📦", "text": "Pickup", "action": "pickup"},
	{"icon": "❌", "text": "Cancel", "action": "cancel"}
]

# Orbit submenu options
var orbit_distances = [50, 100, 150, 200, 250, 300, 350]
var showing_orbit_submenu = false

var menu_radius = 120.0
var button_size = 60.0
var is_visible_menu = false
var menu_position = Vector2.ZERO
var selected_target = null

@onready var buttons_container = $ButtonsContainer

func _ready():
	add_to_group("radial_menu")
	hide()
	create_menu_buttons()

func create_menu_buttons():
	# Create 12 buttons in a circle
	for i in range(12):
		var button = Button.new()
		button.custom_minimum_size = Vector2(button_size, button_size)
		button.text = menu_items[i]["icon"] + "\n" + menu_items[i]["text"]

		# Position in circle
		var angle = (i * TAU / 12.0) - (TAU / 4.0)  # Start at top
		var pos = Vector2(cos(angle), sin(angle)) * menu_radius
		button.position = pos + Vector2(200, 200) - Vector2(button_size/2, button_size/2)

		button.pressed.connect(_on_button_pressed.bind(menu_items[i]["action"]))
		buttons_container.add_child(button)

func show_menu(world_position: Vector2, screen_position: Vector2 = Vector2.ZERO):
	# Use world position for targeting
	menu_position = world_position

	# Use screen position for UI placement (or world_position if not provided for backwards compatibility)
	if screen_position == Vector2.ZERO:
		screen_position = world_position

	global_position = screen_position - Vector2(200, 200)
	is_visible_menu = true
	show()

	# Check what's under the cursor
	check_target_under_cursor()

func check_target_under_cursor():
	# Raycast or check for objects at menu position
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = menu_position
	var result = space_state.intersect_point(query, 10)

	if result.size() > 0:
		selected_target = result[0]["collider"]
	else:
		selected_target = null

func _on_button_pressed(action: String):
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		hide()
		is_visible_menu = false
		return

	match action:
		"fly_to":
			hide()
			is_visible_menu = false
			player.start_autopilot_to_position(menu_position)

		"mine_ore":
			hide()
			is_visible_menu = false
			# Find ore at position or closest ore
			var ore = find_ore_at_position(menu_position)
			if ore:
				player.start_autopilot_to_ore(ore)

		"orbit":
			# Show orbit distance submenu
			if not selected_target:
				print("No target to orbit")
				hide()
				is_visible_menu = false
			else:
				show_orbit_submenu()

		"hold_position":
			hide()
			is_visible_menu = false
			player.autopilot_state = player.AutopilotState.ARRIVED

		"stop":
			hide()
			is_visible_menu = false
			player.autopilot_state = player.AutopilotState.IDLE
			player.current_velocity = Vector2.ZERO

		"eject":
			hide()
			is_visible_menu = false
			# Show eject UI
			var eject_ui = get_node("/root/Main/CanvasLayer/UI/EjectUI")
			if eject_ui:
				eject_ui.show_eject_ui(player)
			else:
				print("EjectUI not found")

		"transfer":
			hide()
			is_visible_menu = false
			# Show transfer UI if target is a ship
			if selected_target and selected_target.is_in_group("npc_ships"):
				var transfer_ui = get_tree().get_first_node_in_group("transfer_ui")
				if not transfer_ui:
					transfer_ui = get_node("/root/Main/CanvasLayer/UI/TransferUI")
				if transfer_ui:
					transfer_ui.show_transfer(player, selected_target)
			else:
				print("No ship selected for transfer")

		"cancel":
			hide()
			is_visible_menu = false

		_:
			hide()
			is_visible_menu = false
			print("Action not implemented: ", action)

func find_ore_at_position(pos: Vector2) -> Node2D:
	var ore_container = get_tree().get_first_node_in_group("ore_container")
	if not ore_container:
		return null

	var closest_ore = null
	var closest_dist = 100.0

	for ore in ore_container.get_children():
		if is_instance_valid(ore):
			var dist = ore.global_position.distance_to(pos)
			if dist < closest_dist:
				closest_ore = ore
				closest_dist = dist

	return closest_ore

func show_orbit_submenu():
	"""Show submenu for selecting orbit distance"""
	# Clear existing buttons
	for child in buttons_container.get_children():
		child.queue_free()

	showing_orbit_submenu = true

	# Create buttons for each orbit distance
	for i in range(orbit_distances.size()):
		var button = Button.new()
		button.custom_minimum_size = Vector2(button_size, button_size)
		button.text = str(orbit_distances[i]) + "m"

		# Position in circle
		var angle = (i * TAU / orbit_distances.size()) - (TAU / 4.0)
		var pos = Vector2(cos(angle), sin(angle)) * menu_radius
		button.position = pos + Vector2(200, 200) - Vector2(button_size/2, button_size/2)

		button.pressed.connect(_on_orbit_distance_selected.bind(orbit_distances[i]))
		buttons_container.add_child(button)

	# Add cancel button in center
	var cancel_btn = Button.new()
	cancel_btn.custom_minimum_size = Vector2(button_size, button_size)
	cancel_btn.text = "Cancel"
	cancel_btn.position = Vector2(200, 200) - Vector2(button_size/2, button_size/2)
	cancel_btn.pressed.connect(_on_orbit_cancel)
	buttons_container.add_child(cancel_btn)

func _on_orbit_distance_selected(distance: float):
	"""Orbit distance selected from submenu"""
	hide()
	is_visible_menu = false
	showing_orbit_submenu = false

	var player = get_tree().get_first_node_in_group("player")
	if player and selected_target:
		player.start_orbit(selected_target, distance)

	# Recreate main menu for next time
	for child in buttons_container.get_children():
		child.queue_free()
	create_menu_buttons()

func _on_orbit_cancel():
	"""Cancel orbit submenu and return to main menu"""
	showing_orbit_submenu = false

	# Recreate main menu
	for child in buttons_container.get_children():
		child.queue_free()
	create_menu_buttons()

func _input(event):
	if is_visible_menu and event is InputEventMouseButton:
		# Close menu on mouse button press (left or right) if not over a button
		if event.pressed and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
			# Check if click is on a button
			var screen_pos = get_viewport().get_mouse_position()
			var clicked_on_button = false

			for button in buttons_container.get_children():
				if button is Button:
					var button_rect = Rect2(button.global_position, button.size)
					if button_rect.has_point(screen_pos):
						clicked_on_button = true
						break

			# If not clicking on a button, close the menu
			if not clicked_on_button:
				hide()
				is_visible_menu = false
