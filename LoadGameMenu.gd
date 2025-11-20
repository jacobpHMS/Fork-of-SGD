extends Control

# UI References
@onready var title_label = $VBox/TitleLabel
@onready var back_btn = $VBox/BackBtn
@onready var slots_container = $VBox/ScrollContainer/SlotsVBox

# Slot button scene (will be created dynamically)
const SLOT_BUTTON_HEIGHT = 80

func _ready():
	# Update UI with translations
	update_translations()

	# Connect signals
	back_btn.pressed.connect(_on_back_pressed)

	# Connect localization signal
	Localization.language_changed.connect(update_translations)

	# Populate save slots
	populate_save_slots()

func update_translations():
	"""Update all UI text with current language"""
	title_label.text = Localization.translate("MENU_LOAD_GAME")
	back_btn.text = Localization.translate("MENU_BACK")

func populate_save_slots():
	"""Create UI for all save slots"""
	# Clear existing slots
	for child in slots_container.get_children():
		child.queue_free()

	# Manual save slots (0-4)
	for i in range(SaveManager.MANUAL_SLOTS):
		create_slot_button(i, false)

	# Add separator
	var separator = HSeparator.new()
	separator.custom_minimum_size = Vector2(0, 20)
	slots_container.add_child(separator)

	# Auto-save slots (0-2)
	for i in range(SaveManager.AUTO_SLOTS):
		create_slot_button(i, true)

func create_slot_button(slot: int, is_auto: bool):
	"""Create a save slot button"""
	var container = HBoxContainer.new()
	container.custom_minimum_size = Vector2(0, SLOT_BUTTON_HEIGHT)
	slots_container.add_child(container)

	# Get save info
	var save_info = SaveManager.get_save_info(slot, is_auto)

	# Load button
	var load_btn = Button.new()
	load_btn.custom_minimum_size = Vector2(500, 0)
	load_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_child(load_btn)

	# Set button text
	if save_info["exists"]:
		var slot_name = ""
		if is_auto:
			slot_name = Localization.translate("SAVE_AUTO") + " " + str(slot + 1)
		else:
			slot_name = Localization.translate("SAVE_SLOT") + " " + str(slot + 1)

		var timestamp = save_info["timestamp"]
		var datetime = Time.get_datetime_dict_from_unix_time(timestamp)
		var date_string = "%04d-%02d-%02d %02d:%02d" % [
			datetime["year"],
			datetime["month"],
			datetime["day"],
			datetime["hour"],
			datetime["minute"]
		]

		load_btn.text = slot_name + "\n" + date_string
		load_btn.disabled = false
		load_btn.pressed.connect(_on_load_slot.bind(slot, is_auto))
	else:
		var slot_name = ""
		if is_auto:
			slot_name = Localization.translate("SAVE_AUTO") + " " + str(slot + 1)
		else:
			slot_name = Localization.translate("SAVE_SLOT") + " " + str(slot + 1)

		load_btn.text = slot_name + "\n" + Localization.translate("SAVE_EMPTY")
		load_btn.disabled = true

	# Delete button (only for non-empty slots)
	if save_info["exists"]:
		var delete_btn = Button.new()
		delete_btn.custom_minimum_size = Vector2(100, 0)
		delete_btn.text = Localization.translate("SAVE_DELETE")
		delete_btn.pressed.connect(_on_delete_slot.bind(slot, is_auto))
		container.add_child(delete_btn)

func _on_load_slot(slot: int, is_auto: bool):
	"""Load a save slot and start the game"""
	print("Loading slot: " + str(slot) + " (auto: " + str(is_auto) + ")")

	var success = false
	if is_auto:
		success = SaveManager.load_auto_save(slot)
	else:
		success = SaveManager.load_game(slot)

	if success:
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
	else:
		push_error("Failed to load save")

func _on_delete_slot(slot: int, is_auto: bool):
	"""Delete a save slot"""
	# TODO: Add confirmation dialog
	print("Deleting slot: " + str(slot) + " (auto: " + str(is_auto) + ")")

	var success = SaveManager.delete_save(slot, is_auto)
	if success:
		# Refresh the list
		populate_save_slots()

func _on_back_pressed():
	"""Return to main menu"""
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
