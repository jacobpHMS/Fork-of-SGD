extends Control

# UI References
@onready var title_label = $VBox/TitleLabel
@onready var resolution_label = $VBox/OptionsContainer/ResolutionLabel
@onready var resolution_option = $VBox/OptionsContainer/ResolutionOption
@onready var window_mode_label = $VBox/OptionsContainer/WindowModeLabel
@onready var window_mode_option = $VBox/OptionsContainer/WindowModeOption
@onready var language_label = $VBox/OptionsContainer/LanguageLabel
@onready var language_option = $VBox/OptionsContainer/LanguageOption
@onready var apply_btn = $VBox/ButtonsContainer/ApplyBtn
@onready var back_btn = $VBox/ButtonsContainer/BackBtn

# Available resolutions
var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]

# Window modes
enum WindowMode { FULLSCREEN, WINDOWED, BORDERLESS }

# Current settings
var current_resolution: Vector2i
var current_window_mode: WindowMode
var current_language: String

func _ready():
	# Get current settings
	current_resolution = DisplayServer.window_get_size()
	current_window_mode = get_current_window_mode()
	current_language = Localization.get_current_language()

	# Setup UI
	setup_resolution_options()
	setup_window_mode_options()
	setup_language_options()

	# Update UI with translations
	update_translations()

	# Connect signals
	apply_btn.pressed.connect(_on_apply_pressed)
	back_btn.pressed.connect(_on_back_pressed)
	resolution_option.item_selected.connect(_on_resolution_selected)
	window_mode_option.item_selected.connect(_on_window_mode_selected)
	language_option.item_selected.connect(_on_language_selected)

	# Connect localization signal
	Localization.language_changed.connect(update_translations)

func update_translations():
	"""Update all UI text with current language"""
	title_label.text = Localization.translate("OPTIONS_TITLE")
	resolution_label.text = Localization.translate("OPTIONS_RESOLUTION")
	window_mode_label.text = Localization.translate("OPTIONS_FULLSCREEN")
	language_label.text = Localization.translate("OPTIONS_LANGUAGE")
	apply_btn.text = Localization.translate("OPTIONS_APPLY")
	back_btn.text = Localization.translate("MENU_BACK")

	# Update window mode option texts
	window_mode_option.set_item_text(0, Localization.translate("OPTIONS_FULLSCREEN"))
	window_mode_option.set_item_text(1, Localization.translate("OPTIONS_WINDOWED"))
	window_mode_option.set_item_text(2, Localization.translate("OPTIONS_BORDERLESS"))

func setup_resolution_options():
	"""Setup resolution dropdown"""
	resolution_option.clear()

	var current_index = 0
	for i in range(resolutions.size()):
		var res = resolutions[i]
		resolution_option.add_item(str(res.x) + " x " + str(res.y))

		# Select current resolution
		if res == current_resolution:
			current_index = i

	resolution_option.select(current_index)

func setup_window_mode_options():
	"""Setup window mode dropdown"""
	window_mode_option.clear()
	window_mode_option.add_item(Localization.translate("OPTIONS_FULLSCREEN"))
	window_mode_option.add_item(Localization.translate("OPTIONS_WINDOWED"))
	window_mode_option.add_item(Localization.translate("OPTIONS_BORDERLESS"))
	window_mode_option.select(current_window_mode)

func setup_language_options():
	"""Setup language dropdown"""
	language_option.clear()

	var languages = Localization.get_available_languages()
	var current_index = 0

	for i in range(languages.size()):
		var lang = languages[i]
		var lang_name = get_language_name(lang)
		language_option.add_item(lang_name)

		if lang == current_language:
			current_index = i

	language_option.select(current_index)

func get_language_name(lang_code: String) -> String:
	"""Get display name for language code"""
	match lang_code:
		"en":
			return "English"
		"de":
			return "Deutsch"
		_:
			return lang_code

func get_current_window_mode() -> WindowMode:
	"""Get current window mode"""
	var mode = DisplayServer.window_get_mode()
	match mode:
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			return WindowMode.FULLSCREEN
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			return WindowMode.BORDERLESS
		_:
			return WindowMode.WINDOWED

func _on_resolution_selected(index: int):
	"""Resolution dropdown changed"""
	current_resolution = resolutions[index]

func _on_window_mode_selected(index: int):
	"""Window mode dropdown changed"""
	current_window_mode = index as WindowMode

func _on_language_selected(index: int):
	"""Language dropdown changed"""
	var languages = Localization.get_available_languages()
	current_language = languages[index]

func _on_apply_pressed():
	"""Apply settings"""
	# Apply resolution
	DisplayServer.window_set_size(current_resolution)

	# Apply window mode
	match current_window_mode:
		WindowMode.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		WindowMode.WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		WindowMode.BORDERLESS:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

	# Apply language
	Localization.change_language(current_language)

	print("Settings applied")

func _on_back_pressed():
	"""Return to main menu"""
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
