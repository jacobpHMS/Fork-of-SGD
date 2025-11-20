extends PanelContainer

# References
var player_node: Node = null
var cargo_windows: Array = []

# Cargo window scene
const CargoWindowScene = preload("res://scenes/CargoWindow.tscn")

func _ready():
	# Find player
	await get_tree().process_frame
	player_node = get_tree().get_first_node_in_group("player")

	# Add cargo buttons
	add_cargo_buttons()

	# Create cargo windows
	create_cargo_windows()

func add_cargo_buttons():
	"""Add cargo toggle buttons to ShipStatus panel"""
	var vbox = $VBox
	if not vbox:
		return

	# Add separator before cargo buttons
	var separator = HSeparator.new()
	vbox.add_child(separator)

	# Add cargo label
	var cargo_label = Label.new()
	cargo_label.text = Localization.translate("UI_CARGO")
	cargo_label.add_theme_color_override("font_color", Color(0.3, 0.8, 1, 1))
	cargo_label.add_theme_font_size_override("font_size", 16)
	cargo_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(cargo_label)

	# Create button container
	var button_container = VBoxContainer.new()
	button_container.add_theme_constant_override("separation", 5)
	vbox.add_child(button_container)

	# Add cargo type buttons
	var cargo_types = [
		{"type": 0, "key": "UI_GENERAL_CARGO", "capacity_key": "cargo_general_capacity"},
		{"type": 1, "key": "UI_ORE_CARGO", "capacity_key": "cargo_ore_capacity"},
		{"type": 2, "key": "UI_MINERAL_CARGO", "capacity_key": "cargo_mineral_capacity"},
		{"type": 3, "key": "UI_AMMO_CARGO", "capacity_key": "cargo_ammo_capacity"},
		{"type": 4, "key": "UI_BUILD_CARGO", "capacity_key": "cargo_build_capacity"},
		{"type": 5, "key": "UI_GAS_CARGO", "capacity_key": "cargo_gas_capacity"}
	]

	for cargo_info in cargo_types:
		# Check if ship has this cargo type
		if not player_node or not player_node.ship_data.has(cargo_info["capacity_key"]):
			continue

		var capacity = player_node.ship_data[cargo_info["capacity_key"]]
		if capacity <= 0:
			continue  # Skip if no capacity

		var btn = Button.new()
		btn.text = Localization.translate(cargo_info["key"])
		btn.custom_minimum_size = Vector2(0, 30)
		btn.add_theme_font_size_override("font_size", 12)
		btn.pressed.connect(_on_cargo_button_pressed.bind(cargo_info["type"]))
		button_container.add_child(btn)

func create_cargo_windows():
	"""Create cargo windows for each type"""
	var canvas_layer = get_node("/root/Main/CanvasLayer")
	if not canvas_layer:
		return

	# Create 6 cargo windows (one for each type)
	for i in range(6):
		var window = CargoWindowScene.instantiate()
		window.set_cargo_type(i)
		window.set_player_node(player_node)
		window.visible = false
		canvas_layer.add_child(window)
		cargo_windows.append(window)

		# Position windows in a cascade
		window.global_position = Vector2(320 + i * 30, 220 + i * 30)

func _on_cargo_button_pressed(cargo_type: int):
	"""Toggle cargo window"""
	if cargo_type < cargo_windows.size():
		var window = cargo_windows[cargo_type]
		window.visible = not window.visible
