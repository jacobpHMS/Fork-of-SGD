extends PanelContainer

# References
var player_ship: Node = null

# UI Elements
@onready var title_label = $VBox/TitleBar/TitleLabel
@onready var close_btn = $VBox/TitleBar/CloseBtn
@onready var cargo_list = $VBox/Content/CargoList
@onready var amount_label = $VBox/Content/AmountControls/Label
@onready var amount_input = $VBox/Content/AmountControls/AmountInput
@onready var amount_slider = $VBox/Content/AmountControls/AmountSlider
@onready var eject_btn = $VBox/Content/EjectBtn
@onready var eject_all_btn = $VBox/Content/EjectAllBtn

# Dragging
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

# Selected item
var selected_item_id: String = ""
var selected_cargo_type: int = 0
var selected_max_amount: float = 0.0

func _ready():
	# Connect signals
	close_btn.pressed.connect(_on_close_pressed)
	eject_btn.pressed.connect(_on_eject_pressed)
	eject_all_btn.pressed.connect(_on_eject_all_pressed)
	cargo_list.item_selected.connect(_on_item_selected)
	amount_slider.value_changed.connect(_on_slider_changed)
	amount_input.text_changed.connect(_on_text_changed)

	# Update translations
	update_translations()

	# Connect localization
	if Localization:
		Localization.language_changed.connect(update_translations)

func update_translations():
	"""Update UI text with current language"""
	if Localization:
		title_label.text = Localization.translate("EJECT_TITLE")
		amount_label.text = Localization.translate("EJECT_AMOUNT")
		eject_btn.text = Localization.translate("EJECT_BUTTON")
		eject_all_btn.text = Localization.translate("EJECT_ALL_BUTTON")

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

func show_eject_ui(player: Node):
	"""Show eject UI for player ship"""
	player_ship = player

	update_cargo_list()
	visible = true

	# Reset selection
	selected_item_id = ""
	amount_input.text = "10.0"
	amount_slider.value = 10.0
	eject_btn.disabled = true
	eject_all_btn.disabled = true

func update_cargo_list():
	"""Update cargo list with all items"""
	cargo_list.clear()

	if not player_ship:
		return

	# Iterate through all cargo holds
	for cargo_type in player_ship.cargo_holds.keys():
		var hold = player_ship.cargo_holds[cargo_type]
		var cargo_type_name = get_cargo_type_name(cargo_type)

		for item_id in hold["items"]:
			var amount = hold["items"][item_id]
			cargo_list.add_item("%s: %.1f (%s)" % [item_id, amount, cargo_type_name])
			cargo_list.set_item_metadata(cargo_list.get_item_count() - 1, {
				"item_id": item_id,
				"cargo_type": cargo_type,
				"amount": amount
			})

func get_cargo_type_name(cargo_type: int) -> String:
	"""Get display name for cargo type"""
	match cargo_type:
		0: return "General"
		1: return "Ore"
		2: return "Mineral"
		3: return "Ammo"
		4: return "Build"
		5: return "Gas"
		_: return "Unknown"

func _on_item_selected(index: int):
	"""Item selected in list"""
	var metadata = cargo_list.get_item_metadata(index)
	if not metadata:
		return

	selected_item_id = metadata["item_id"]
	selected_cargo_type = metadata["cargo_type"]
	selected_max_amount = metadata["amount"]

	# Update slider range
	amount_slider.max_value = selected_max_amount
	amount_slider.value = min(10.0, selected_max_amount)

	# Enable buttons
	eject_btn.disabled = false
	eject_all_btn.disabled = false

func _on_slider_changed(value: float):
	"""Slider value changed"""
	amount_input.text = "%.1f" % value

func _on_text_changed(new_text: String):
	"""Text input changed"""
	var value = float(new_text)
	if value > 0:
		amount_slider.value = clamp(value, 0.0, selected_max_amount)

func _on_eject_pressed():
	"""Eject button pressed"""
	if not player_ship or selected_item_id == "":
		return

	var amount = float(amount_input.text)
	if amount <= 0:
		return

	# Clamp to available amount
	amount = min(amount, selected_max_amount)

	# Call player eject function
	if player_ship.has_method("eject_cargo"):
		player_ship.eject_cargo(selected_item_id, amount)

	# Play sound
	if SoundManager:
		SoundManager.play_sfx("sfx_cargo_eject")

	# Update list
	update_cargo_list()

	# Reset selection if no more of this item
	if amount >= selected_max_amount:
		selected_item_id = ""
		eject_btn.disabled = true
		eject_all_btn.disabled = true

func _on_eject_all_pressed():
	"""Eject all button pressed"""
	if not player_ship or selected_item_id == "":
		return

	# Eject all of selected item
	if player_ship.has_method("eject_cargo"):
		player_ship.eject_cargo(selected_item_id, selected_max_amount)

	# Play sound
	if SoundManager:
		SoundManager.play_sfx("sfx_cargo_eject")

	# Update list
	update_cargo_list()

	# Reset selection
	selected_item_id = ""
	eject_btn.disabled = true
	eject_all_btn.disabled = true

func _on_close_pressed():
	"""Close button pressed"""
	visible = false
