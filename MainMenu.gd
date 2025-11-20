extends Control

# UI References
@onready var title_label = $VBox/TitleLabel
@onready var new_game_btn = $VBox/NewGameBtn
@onready var continue_btn = $VBox/ContinueBtn
@onready var load_game_btn = $VBox/LoadGameBtn
@onready var options_btn = $VBox/OptionsBtn
@onready var dev_info_btn = $VBox/DevInfoBtn
@onready var quit_btn = $VBox/QuitBtn

func _ready():
	# Update UI with translations
	update_translations()

	# Connect signals
	new_game_btn.pressed.connect(_on_new_game_pressed)
	continue_btn.pressed.connect(_on_continue_pressed)
	load_game_btn.pressed.connect(_on_load_game_pressed)
	options_btn.pressed.connect(_on_options_pressed)
	dev_info_btn.pressed.connect(_on_dev_info_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)

	# Connect localization signal
	Localization.language_changed.connect(update_translations)

	# Check if continue button should be enabled
	check_continue_available()

func update_translations():
	"""Update all UI text with current language"""
	title_label.text = Localization.translate("GAME_TITLE")
	new_game_btn.text = Localization.translate("MENU_NEW_GAME")
	continue_btn.text = Localization.translate("MENU_CONTINUE")
	load_game_btn.text = Localization.translate("MENU_LOAD_GAME")
	options_btn.text = Localization.translate("MENU_OPTIONS")
	dev_info_btn.text = Localization.translate("MENU_DEV_INFO")
	quit_btn.text = Localization.translate("MENU_QUIT")

func check_continue_available():
	"""Check if there's a most recent save to continue from"""
	# Will be implemented with save system
	continue_btn.disabled = not SaveManager.has_recent_save() if SaveManager else true

func _on_new_game_pressed():
	"""Start a new game"""
	print("Starting new game...")
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_continue_pressed():
	"""Continue from most recent save"""
	print("Continuing game...")
	if SaveManager:
		SaveManager.load_most_recent_save()
		get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_load_game_pressed():
	"""Open load game menu"""
	print("Opening load game menu...")
	get_tree().change_scene_to_file("res://scenes/LoadGameMenu.tscn")

func _on_options_pressed():
	"""Open options menu"""
	print("Opening options menu...")
	get_tree().change_scene_to_file("res://scenes/OptionsMenu.tscn")

func _on_dev_info_pressed():
	"""Open developer info screen / test scenarios"""
	print("Opening developer scenarios...")
	get_tree().change_scene_to_file("res://scenes/DeveloperMenu.tscn")

func _on_quit_pressed():
	"""Quit the game"""
	print("Quitting game...")
	get_tree().quit()
