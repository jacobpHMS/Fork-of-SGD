extends Node

# Current language
var current_language: String = "en"

# Available languages
var available_languages: Array = ["en", "de", "fr", "es", "ru", "zh"]

# Translation dictionary
var translations: Dictionary = {}

# Dialog-specific translations: category -> key -> text
var dialog_translations: Dictionary = {}

# Flavor text pools: category -> Array[String]
var flavor_text_pools: Dictionary = {}

# Settings file path
const SETTINGS_PATH = "user://settings.cfg"

# Signals
signal language_changed

func _ready():
	print("🌐 Localization: Initializing...")
	# Load settings (including language preference)
	load_settings()
	# Load current language
	load_language(current_language)
	# Load dialog databases
	_load_dialog_translations()
	_load_flavor_text_pools()
	print("✅ Localization: Ready")

func load_language(lang_code: String):
	"""Load a language file from localization folder"""
	var file_path = "res://localization/" + lang_code + ".json"

	if not FileAccess.file_exists(file_path):
		push_error("Language file not found: " + file_path)
		return false

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Could not open language file: " + file_path)
		return false

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_string)

	if error != OK:
		push_error("JSON Parse Error in " + file_path + ": " + json.get_error_message())
		return false

	translations = json.data
	current_language = lang_code

	# Save language preference
	save_settings()

	# Emit signal to update all UI elements
	language_changed.emit()

	print("Language loaded: " + lang_code)
	return true

func translate(key: String) -> String:
	"""Translate a key to current language"""
	if translations.has(key):
		return translations[key]
	else:
		push_warning("Translation key not found: " + key)
		return key

func get_current_language() -> String:
	return current_language

func get_available_languages() -> Array:
	return available_languages

func change_language(lang_code: String):
	"""Change the current language"""
	if lang_code in available_languages:
		load_language(lang_code)
	else:
		push_error("Language not available: " + lang_code)

# Settings management
func save_settings():
	"""Save game settings including language"""
	var config = ConfigFile.new()
	config.set_value("general", "language", current_language)
	config.save(SETTINGS_PATH)

func load_settings():
	"""Load game settings including language"""
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)

	if err == OK:
		current_language = config.get_value("general", "language", "en")
	else:
		# Default to English if no settings file exists
		current_language = "en"

# ============================================================================
# DIALOG TRANSLATIONS
# ============================================================================

func _load_dialog_translations():
	"""Load dialog-specific translation databases"""
	# Standard greetings
	dialog_translations["greetings"] = {
		"formal": [
			"Greetings, {PLAYER_NAME}.",
			"Welcome aboard.",
			"State your business.",
			"Identification verified."
		],
		"friendly": [
			"Hey there, {PLAYER_NAME}!",
			"Good to see you!",
			"What brings you here?",
			"Welcome, friend!"
		],
		"casual": [
			"Yo!",
			"What's up?",
			"Hey.",
			"Sup, Captain?"
		],
		"hostile": [
			"What do you want?",
			"Make it quick.",
			"You again...",
			"State your business and leave."
		]
	}

	# Farewell phrases
	dialog_translations["farewells"] = {
		"formal": [
			"Safe travels, {PLAYER_NAME}.",
			"Farewell.",
			"Dismissed.",
			"May your journey be prosperous."
		],
		"friendly": [
			"See you around!",
			"Take care out there!",
			"Catch you later!",
			"Fly safe, friend!"
		],
		"casual": [
			"Later.",
			"Peace.",
			"Catch ya.",
			"Bye."
		]
	}

	# Mission-related
	dialog_translations["missions"] = {
		"accept": [
			"I'll take the job.",
			"Consider it done.",
			"You can count on me.",
			"I'm in."
		],
		"decline": [
			"Not interested.",
			"I'll pass.",
			"Maybe another time.",
			"Not right now."
		],
		"complete": [
			"Job's done.",
			"Mission accomplished.",
			"All finished.",
			"Task completed."
		]
	}

	print("🌐 Loaded dialog translations: %d categories" % dialog_translations.size())

func _load_flavor_text_pools():
	"""Load pools of random flavor text"""
	# Station ambient chatter
	flavor_text_pools["station_ambient"] = [
		"Did you hear about the pirate raid near the jumpgate?",
		"The market prices have been crazy lately.",
		"I heard there's a new mining operation starting up.",
		"Watch out for那些 security patrols.",
		"Business has been slow this month.",
		"The refinery is backed up with orders.",
		"Someone found a rich asteroid field nearby.",
		"The faction war is heating up again.",
		"I'm saving up for a new ship.",
		"Have you tried the new auto-miner chips?",
		"The Amarr station has better prices.",
		"Be careful out there, lots of debris.",
		"I lost my cargo to pirates last week.",
		"The station needs more tritanium.",
		"Check out the mission board.",
		"That new pilot is making waves.",
		"The ore quality has been excellent.",
		"I heard they're building a new stargate.",
		"Fuel prices are through the roof.",
		"The corp is recruiting new members.",
		"Did you see that capital ship dock?",
		"Manufacturing times are getting longer.",
		"The market is crashing on minerals.",
		"Someone's manipulating the market.",
		"The alliance is planning something big.",
		"I need to upgrade my mining lasers.",
		"The security level dropped in this system.",
		"There's a new blueprint on the market.",
		"The shipyard is offering discounts.",
		"I made a fortune trading last month."
	]

	# NPC reactions to player actions
	flavor_text_pools["npc_reactions"] = [
		"Impressive ship you have there.",
		"You look like you've been in a fight.",
		"That's a lot of cargo you're hauling.",
		"Your reputation precedes you.",
		"I've heard good things about you.",
		"Be careful who you trust around here.",
		"You must be doing well for yourself.",
		"I could use a pilot like you.",
		"You're new around here, aren't you?",
		"I remember when I was just starting out.",
		"You've got guts coming here.",
		"The factions are watching you.",
		"You're making a name for yourself.",
		"I've seen worse pilots.",
		"You've got potential.",
		"Don't get too cocky out there.",
		"The universe is a dangerous place.",
		"Credits aren't everything.",
		"Experience is the best teacher.",
		"You'll learn the hard way."
	]

	# Trade-related
	flavor_text_pools["trade_talk"] = [
		"Buy low, sell high - that's the secret.",
		"The market is all about timing.",
		"I've got connections all over the galaxy.",
		"Quality goods at fair prices.",
		"I don't deal with pirates.",
		"Credits talk, everything else walks.",
		"I've been in this business for years.",
		"Trust is hard to come by.",
		"My prices are competitive.",
		"Bulk orders get discounts.",
		"No refunds, no exceptions.",
		"Payment upfront, no credit.",
		"I've got rare items in stock.",
		"The competition can't match my prices.",
		"Supply and demand, my friend.",
		"I know what things are worth.",
		"Don't try to haggle with me.",
		"My reputation speaks for itself.",
		"I've never had a dissatisfied customer.",
		"Business is business."
	]

	# Combat/danger warnings
	flavor_text_pools["danger_warnings"] = [
		"Pirates have been active in this sector.",
		"Watch your scanner at all times.",
		"Don't travel alone if you can help it.",
		"The outer systems are lawless.",
		"Security won't help you out there.",
		"I've lost good friends to ambushes.",
		"Always have an escape route planned.",
		"Don't carry more than you can afford to lose.",
		"The jumpgates are common ambush points.",
		"Trust your instincts.",
		"If it seems too good to be true, it probably is.",
		"Keep your weapons ready.",
		"Don't broadcast your cargo manifest.",
		"The galaxy doesn't forgive mistakes.",
		"I've seen entire fleets wiped out.",
		"Even allies can turn on you.",
		"Never let your guard down.",
		"The stars are beautiful but deadly.",
		"Fortune favors the prepared.",
		"Better paranoid than dead."
	]

	print("🌐 Loaded flavor text: %d pools, %d total lines" % [
		flavor_text_pools.size(),
		_count_flavor_text_lines()
	])

func _count_flavor_text_lines() -> int:
	"""Count total flavor text lines"""
	var total = 0
	for pool in flavor_text_pools.values():
		total += pool.size()
	return total

# ============================================================================
# DIALOG API
# ============================================================================

func get_dialog_text(category: String, subcategory: String = "") -> String:
	"""Get a random dialog text from a category"""
	if not dialog_translations.has(category):
		return ""

	var cat_data = dialog_translations[category]

	if subcategory != "" and cat_data is Dictionary:
		if cat_data.has(subcategory):
			var texts = cat_data[subcategory]
			if texts is Array and texts.size() > 0:
				return texts[randi() % texts.size()]
	elif cat_data is Array and cat_data.size() > 0:
		return cat_data[randi() % cat_data.size()]

	return ""

func get_flavor_text(pool_name: String) -> String:
	"""Get a random flavor text from a pool"""
	if not flavor_text_pools.has(pool_name):
		return ""

	var pool = flavor_text_pools[pool_name]
	if pool.size() > 0:
		return pool[randi() % pool.size()]

	return ""

func get_greeting(personality_type: String = "friendly") -> String:
	"""Get a random greeting based on personality"""
	return get_dialog_text("greetings", personality_type)

func get_farewell(personality_type: String = "friendly") -> String:
	"""Get a random farewell based on personality"""
	return get_dialog_text("farewells", personality_type)

# ============================================================================
# PLACEHOLDER SUPPORT
# ============================================================================

func substitute_placeholders(text: String, context: Dictionary) -> String:
	"""Substitute placeholders in text with context values"""
	var result = text

	for key in context.keys():
		var placeholder = "{" + key + "}"
		if placeholder in result:
			result = result.replace(placeholder, str(context[key]))

	return result
