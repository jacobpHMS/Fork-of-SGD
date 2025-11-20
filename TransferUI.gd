extends PanelContainer

# References
var player_ship: Node = null
var target_ship: Node = null

# UI Elements
@onready var title_label = $VBox/TitleBar/TitleLabel
@onready var close_btn = $VBox/TitleBar/CloseBtn
@onready var player_cargo_list = $VBox/Content/HBox/PlayerSide/CargoList
@onready var target_cargo_list = $VBox/Content/HBox/TargetSide/CargoList
@onready var transfer_amount_input = $VBox/Content/TransferControls/AmountInput
@onready var transfer_to_target_btn = $VBox/Content/TransferControls/ToTargetBtn
@onready var transfer_to_player_btn = $VBox/Content/TransferControls/ToPlayerBtn

# Dragging
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

# Selected items
var selected_player_item: String = ""
var selected_target_item: String = ""

func _ready():
	# Connect signals
	close_btn.pressed.connect(_on_close_pressed)
	transfer_to_target_btn.pressed.connect(_on_transfer_to_target)
	transfer_to_player_btn.pressed.connect(_on_transfer_to_player)

	player_cargo_list.item_selected.connect(_on_player_item_selected)
	target_cargo_list.item_selected.connect(_on_target_item_selected)

func _gui_input(event):
	# Handle dragging
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var local_pos = event.position
				if local_pos.y < 40:
					is_dragging = true
					drag_offset = global_position - get_global_mouse_position()
			else:
				is_dragging = false

	elif event is InputEventMouseMotion:
		if is_dragging:
			global_position = get_global_mouse_position() + drag_offset
			clamp_to_screen()

func clamp_to_screen():
	var screen_size = get_viewport_rect().size
	var window_size = size

	global_position.x = clamp(global_position.x, 0, screen_size.x - window_size.x)
	global_position.y = clamp(global_position.y, 0, screen_size.y - window_size.y)

func show_transfer(player: Node, target: Node):
	"""Show transfer UI between two ships"""
	player_ship = player
	target_ship = target

	title_label.text = "Transfer Cargo"

	update_cargo_lists()
	visible = true

func update_cargo_lists():
	"""Update both cargo lists"""
	# Clear lists
	player_cargo_list.clear()
	target_cargo_list.clear()

	# Player cargo
	if player_ship:
		for cargo_type in player_ship.cargo_holds.keys():
			var hold = player_ship.cargo_holds[cargo_type]
			for item_id in hold["items"]:
				var amount = hold["items"][item_id]
				player_cargo_list.add_item("%s: %.1f" % [item_id, amount])
				player_cargo_list.set_item_metadata(player_cargo_list.get_item_count() - 1, {
					"item_id": item_id,
					"cargo_type": cargo_type
				})

	# Target cargo
	if target_ship:
		for cargo_type in target_ship.cargo_holds.keys():
			var hold = target_ship.cargo_holds[cargo_type]
			for item_id in hold["items"]:
				var amount = hold["items"][item_id]
				target_cargo_list.add_item("%s: %.1f" % [item_id, amount])
				target_cargo_list.set_item_metadata(target_cargo_list.get_item_count() - 1, {
					"item_id": item_id,
					"cargo_type": cargo_type
				})

func _on_player_item_selected(index: int):
	"""Player cargo item selected"""
	var metadata = player_cargo_list.get_item_metadata(index)
	if metadata:
		selected_player_item = metadata["item_id"]

func _on_target_item_selected(index: int):
	"""Target cargo item selected"""
	var metadata = target_cargo_list.get_item_metadata(index)
	if metadata:
		selected_target_item = metadata["item_id"]

func _on_transfer_to_target():
	"""Transfer from player to target"""
	if not selected_player_item or not player_ship or not target_ship:
		return

	var amount_text = transfer_amount_input.text
	if amount_text == "":
		return

	var amount = float(amount_text)
	if amount <= 0:
		return

	# Find item in player cargo
	for cargo_type in player_ship.cargo_holds.keys():
		var hold = player_ship.cargo_holds[cargo_type]
		if hold["items"].has(selected_player_item):
			# Remove from player
			var removed = player_ship.remove_from_cargo_hold(cargo_type, selected_player_item, amount) if player_ship.has_method("remove_from_cargo_hold") else 0.0

			# Add to target (determine target cargo type)
			var target_cargo_type = get_cargo_type_for_item(selected_player_item)
			if target_ship.has_method("add_to_cargo_hold"):
				target_ship.add_to_cargo_hold(target_cargo_type, selected_player_item, removed)

			print("Transferred %.1f %s to target ship" % [removed, selected_player_item])
			break

	# Update UI
	update_cargo_lists()

func _on_transfer_to_player():
	"""Transfer from target to player"""
	if not selected_target_item or not player_ship or not target_ship:
		return

	var amount_text = transfer_amount_input.text
	if amount_text == "":
		return

	var amount = float(amount_text)
	if amount <= 0:
		return

	# Find item in target cargo
	for cargo_type in target_ship.cargo_holds.keys():
		var hold = target_ship.cargo_holds[cargo_type]
		if hold["items"].has(selected_target_item):
			# Remove from target
			var removed = target_ship.remove_from_cargo_hold(cargo_type, selected_target_item, amount) if target_ship.has_method("remove_from_cargo_hold") else 0.0

			# Add to player
			if player_ship.has_method("add_to_cargo"):
				player_ship.add_to_cargo(selected_target_item, removed)

			print("Transferred %.1f %s to player ship" % [removed, selected_target_item])
			break

	# Update UI
	update_cargo_lists()

func get_cargo_type_for_item(item_id: String) -> int:
	"""Determine cargo type from item ID"""
	if item_id.begins_with("ore_"):
		return 1  # ORE
	elif item_id.begins_with("mineral_"):
		return 2  # MINERAL
	elif item_id.begins_with("ammo_"):
		return 3  # AMMO
	elif item_id.begins_with("build_"):
		return 4  # BUILD
	elif item_id.begins_with("gas_"):
		return 5  # GAS
	else:
		return 0  # GENERAL

func _on_close_pressed():
	"""Close transfer UI"""
	visible = false
