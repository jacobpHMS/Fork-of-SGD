extends Node

# ============================================================================
# TRANSLATION MANAGER - Multilanguage Support
# ============================================================================
# Manages game translations and language switching

signal language_changed(new_language: String)

# Available languages
enum Language {
	ENGLISH,
	GERMAN
}

const LANGUAGE_CODES = {
	Language.ENGLISH: "en",
	Language.GERMAN: "de"
}

const LANGUAGE_NAMES = {
	Language.ENGLISH: "English",
	Language.GERMAN: "Deutsch"
}

# Current language
var current_language: Language = Language.ENGLISH

# Translation file path
const TRANSLATION_FILE = "res://translations/game_strings.csv"

func _ready():
	print("🌍 Translation Manager initialized")

	# Load translations
	load_translations()

	# Set default language (from system or settings)
	var system_locale = OS.get_locale()
	if system_locale.begins_with("de"):
		set_language(Language.GERMAN)
	else:
		set_language(Language.ENGLISH)

func load_translations():
	"""Load translation files"""
	# Godot automatically loads .csv translation files
	# Just need to ensure they're added to project settings

	# Check if translation file exists
	if FileAccess.file_exists(TRANSLATION_FILE):
		print("✅ Translation file found: %s" % TRANSLATION_FILE)
	else:
		print("⚠️ Translation file not found: %s" % TRANSLATION_FILE)

func set_language(lang: Language):
	"""Set current language"""
	current_language = lang
	var lang_code = LANGUAGE_CODES[lang]

	# Set Godot's locale
	TranslationServer.set_locale(lang_code)

	print("🌍 Language set to: %s (%s)" % [LANGUAGE_NAMES[lang], lang_code])

	emit_signal("language_changed", lang_code)

func get_current_language() -> Language:
	"""Get current language"""
	return current_language

func get_current_language_code() -> String:
	"""Get current language code"""
	return LANGUAGE_CODES[current_language]

func get_current_language_name() -> String:
	"""Get current language name"""
	return LANGUAGE_NAMES[current_language]

func translate_key(key: String) -> String:
	"""Translate a key (wrapper for TranslationServer)"""
	return TranslationServer.translate(key)

# ============================================================================
# CONVENIENCE FUNCTIONS
# ============================================================================

func tr_ui(key: String) -> String:
	"""Translate UI string"""
	return translate_key("ui_" + key)

func tr_skill(key: String) -> String:
	"""Translate skill string"""
	return translate_key("skill_" + key)

func tr_temp(key: String) -> String:
	"""Translate temperature string"""
	return translate_key("temp_" + key)

func tr_energy(key: String) -> String:
	"""Translate energy string"""
	return translate_key("energy_" + key)

func tr_craft(key: String) -> String:
	"""Translate crafting string"""
	return translate_key("craft_" + key)

func tr_station(key: String) -> String:
	"""Translate station string"""
	return translate_key("station_" + key)

func tr_fleet(key: String) -> String:
	"""Translate fleet string"""
	return translate_key("fleet_" + key)

func tr_ore(key: String) -> String:
	"""Translate ore string"""
	return translate_key("ore_" + key)

# ============================================================================
# LANGUAGE CYCLING
# ============================================================================

func cycle_language():
	"""Cycle to next language"""
	var next_lang = (current_language + 1) % Language.size()
	set_language(next_lang)

func get_available_languages() -> Array:
	"""Get list of available languages"""
	var languages = []
	for lang in Language.values():
		languages.append({
			"code": LANGUAGE_CODES[lang],
			"name": LANGUAGE_NAMES[lang],
			"enum": lang
		})
	return languages

# ============================================================================
# NUMBER FORMATTING
# ============================================================================

func format_number(number: float, decimals: int = 0) -> String:
	"""Format number with localized thousands separator"""
	var separator = "," if current_language == Language.ENGLISH else "."
	var decimal_sep = "." if current_language == Language.ENGLISH else ","

	var number_str = str(number) if decimals == 0 else ("%.{0}f" % decimals).format([number])

	# Add thousands separator
	# (Simple implementation, can be improved)
	return number_str

func format_time(seconds: float) -> String:
	"""Format time duration"""
	var sec_int = int(seconds)
	if sec_int < 60:
		return "%ds" % sec_int
	elif sec_int < 3600:
		return "%dm %ds" % [sec_int / 60, sec_int % 60]
	else:
		return "%dh %dm" % [sec_int / 3600, (sec_int % 3600) / 60]

func format_percent(value: float) -> String:
	"""Format percentage"""
	return "%.1f%%" % value

func format_distance(meters: float) -> String:
	"""Format distance"""
	if meters < 1000:
		return "%.0f %s" % [meters, translate_key("measure_meters")]
	else:
		return "%.1f %s" % [meters / 1000.0, translate_key("measure_kilometers")]

# ============================================================================
# SAVE/LOAD INTEGRATION
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export language settings for saving"""
	return {
		"current_language": current_language
	}

func load_save_data(data: Dictionary):
	"""Import language settings from save file"""
	if data.has("current_language"):
		set_language(data["current_language"])
