extends Control

# UI References
@onready var title_label = $VBox/TitleLabel
@onready var info_text = $VBox/ScrollContainer/InfoLabel
@onready var back_btn = $VBox/BackBtn

func _ready():
	# Update UI with translations
	update_translations()

	# Connect signals
	back_btn.pressed.connect(_on_back_pressed)

	# Connect localization signal
	Localization.language_changed.connect(update_translations)

func update_translations():
	"""Update all UI text with current language"""
	title_label.text = Localization.translate("DEV_INFO_TITLE")
	back_btn.text = Localization.translate("MENU_BACK")

	# Build info text
	var info = ""
	info += Localization.translate("DEV_INFO_GAME") + "\n\n"
	info += Localization.translate("DEV_INFO_VERSION") + "\n"
	info += Localization.translate("DEV_INFO_ENGINE") + "\n"
	info += Localization.translate("DEV_INFO_DEVELOPER") + "\n\n"
	info += Localization.translate("DEV_INFO_DESCRIPTION") + "\n\n"
	info += "---\n\n"
	info += "Features:\n"
	info += "• Top-down space navigation\n"
	info += "• Autopilot system with double-click\n"
	info += "• Mining laser mechanics\n"
	info += "• Radial menu for actions\n"
	info += "• Multi-cargo system\n"
	info += "• Save/Load system (5 + 3 auto slots)\n"
	info += "• Multi-language support (EN/DE)\n"
	info += "• Draggable UI windows\n"

	info_text.text = info

func _on_back_pressed():
	"""Return to main menu"""
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
