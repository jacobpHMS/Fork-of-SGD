extends Node
class_name DialogSystem
## DialogSystem - Complete dialog and storyline system
##
## Features:
## - Dialog trees with branching choices
## - Condition evaluation (quest states, reputation, etc.)
## - Variable substitution ({PLAYER_NAME}, {FACTION}, etc.)
## - Localization support
## - Character personality system
## - Dialog history tracking
## - Dynamic dialog generation support (AI-ready)
##
## Usage:
## ```gdscript
## var dialog_id = "MISSION_INTRO_001"
## DialogSystem.start_dialog(dialog_id, npc_id, player_context)
## ```

# ============================================================================
# SIGNALS
# ============================================================================

signal dialog_started(dialog_id: String, npc_id: String)
signal dialog_line_displayed(line_data: Dictionary)
signal dialog_choices_available(choices: Array)
signal dialog_choice_selected(choice_index: int, choice_text: String)
signal dialog_ended(dialog_id: String, outcome: String)
signal variable_changed(var_name: String, value: Variant)

# ============================================================================
# ENUMS
# ============================================================================

enum DialogType {
	STANDARD,      # Normal conversation
	MISSION,       # Mission-related dialog
	TRADE,         # Trading dialog
	STORYLINE,     # Main storyline
	RANDOM_FLAVOR  # Random ambient dialog
}

enum ConditionType {
	REPUTATION,      # Check reputation level
	QUEST_STATE,     # Check quest completion
	HAS_ITEM,        # Check inventory
	SKILL_LEVEL,     # Check skill requirement
	FACTION_STANDING,# Check faction relationship
	VARIABLE         # Check custom variable
}

# ============================================================================
# CONSTANTS
# ============================================================================

const DIALOG_DATA_PATH = "res://data/dialogs/"
const MAX_HISTORY_ENTRIES = 100

# ============================================================================
# STATE
# ============================================================================

## Loaded dialog data: dialog_id -> DialogData
var dialog_database: Dictionary = {}

## Current active dialog
var current_dialog: DialogData = null
var current_node_index: int = 0

## Dialog history
var dialog_history: Array = []

## Global dialog variables (for quest tracking, etc.)
var dialog_variables: Dictionary = {}

## Character personalities: npc_id -> PersonalityData
var npc_personalities: Dictionary = {}

## Dialog seen tracker: dialog_id -> times_seen
var dialog_seen_count: Dictionary = {}

# ============================================================================
# DATA STRUCTURES
# ============================================================================

class DialogData:
	var dialog_id: String
	var dialog_type: DialogType
	var npc_speaker: String
	var nodes: Array[DialogNode]  # Dialog tree nodes
	var metadata: Dictionary  # Tags, categories, etc.

	func _init(p_id: String, p_type: DialogType = DialogType.STANDARD):
		dialog_id = p_id
		dialog_type = p_type
		nodes = []
		metadata = {}

class DialogNode:
	var node_id: int
	var speaker: String  # "NPC" or "PLAYER"
	var text_key: String  # Localization key
	var text_raw: String  # Raw text (if not localized)
	var choices: Array[DialogChoice]
	var conditions: Array[DialogCondition]
	var effects: Array[DialogEffect]
	var next_node: int  # -1 = end dialog

	func _init():
		node_id = 0
		speaker = "NPC"
		text_key = ""
		text_raw = ""
		choices = []
		conditions = []
		effects = []
		next_node = -1

class DialogChoice:
	var choice_id: int
	var text_key: String
	var text_raw: String
	var target_node: int
	var conditions: Array[DialogCondition]
	var effects: Array[DialogEffect]

	func _init():
		choice_id = 0
		text_key = ""
		text_raw = ""
		target_node = -1
		conditions = []
		effects = []

class DialogCondition:
	var condition_type: ConditionType
	var target: String  # What to check (faction name, item ID, etc.)
	var comparison: String  # ">=", "==", "<", etc.
	var value: Variant

	func _init(p_type: ConditionType, p_target: String, p_comparison: String, p_value: Variant):
		condition_type = p_type
		target = p_target
		comparison = p_comparison
		value = p_value

class DialogEffect:
	var effect_type: String  # "SET_VARIABLE", "GIVE_ITEM", "START_QUEST", etc.
	var target: String
	var value: Variant

	func _init(p_type: String, p_target: String, p_value: Variant):
		effect_type = p_type
		target = p_target
		value = p_value

class PersonalityData:
	var npc_id: String
	var personality_traits: Dictionary  # "friendly": 0.8, "aggressive": 0.2, etc.
	var speech_patterns: Array  # Common phrases
	var greeting_variants: Array
	var farewell_variants: Array

	func _init(p_id: String):
		npc_id = p_id
		personality_traits = {"friendly": 0.5, "formal": 0.5, "humorous": 0.3}
		speech_patterns = []
		greeting_variants = ["Hello, {PLAYER_NAME}.", "Greetings.", "Welcome."]
		farewell_variants = ["Goodbye.", "Safe travels.", "Farewell."]

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	print("💬 DialogSystem: Initializing...")
	_load_dialog_database()
	_load_npc_personalities()
	print("✅ DialogSystem: Ready")

# ============================================================================
# DATABASE LOADING
# ============================================================================

func _load_dialog_database():
	"""Load all dialog files from disk"""
	# Create default dialogs if database doesn't exist
	_create_default_dialogs()

	print("💬 DialogSystem: Loaded %d dialogs" % dialog_database.size())

func _create_default_dialogs():
	"""Create some default dialogs for testing"""
	# Mission introduction dialog
	var mission_dialog = DialogData.new("MISSION_INTRO_001", DialogType.MISSION)

	var node0 = DialogNode.new()
	node0.node_id = 0
	node0.speaker = "NPC"
	node0.text_raw = "Greetings, {PLAYER_NAME}. I have a job for you."
	node0.next_node = 1
	mission_dialog.nodes.append(node0)

	var node1 = DialogNode.new()
	node1.node_id = 1
	node1.speaker = "NPC"
	node1.text_raw = "I need someone to transport cargo to the Amarr station. Are you interested?"

	var choice_yes = DialogChoice.new()
	choice_yes.choice_id = 0
	choice_yes.text_raw = "Yes, I'll take the job."
	choice_yes.target_node = 2
	choice_yes.effects.append(DialogEffect.new("START_QUEST", "CARGO_TRANSPORT_001", true))

	var choice_no = DialogChoice.new()
	choice_no.choice_id = 1
	choice_no.text_raw = "No, not interested."
	choice_no.target_node = 3

	node1.choices.append(choice_yes)
	node1.choices.append(choice_no)
	mission_dialog.nodes.append(node1)

	var node2 = DialogNode.new()
	node2.node_id = 2
	node2.speaker = "NPC"
	node2.text_raw = "Excellent! The cargo is waiting in the hangar. Don't keep them waiting."
	node2.next_node = -1
	mission_dialog.nodes.append(node2)

	var node3 = DialogNode.new()
	node3.node_id = 3
	node3.speaker = "NPC"
	node3.text_raw = "Suit yourself. Come back if you change your mind."
	node3.next_node = -1
	mission_dialog.nodes.append(node3)

	dialog_database["MISSION_INTRO_001"] = mission_dialog

	# Standard greeting dialog
	var greeting_dialog = DialogData.new("STANDARD_GREETING", DialogType.STANDARD)

	var greet_node = DialogNode.new()
	greet_node.node_id = 0
	greet_node.speaker = "NPC"
	greet_node.text_raw = "{GREETING} What can I do for you today?"
	greet_node.next_node = -1
	greeting_dialog.nodes.append(greet_node)

	dialog_database["STANDARD_GREETING"] = greeting_dialog

	# Trade dialog
	var trade_dialog = DialogData.new("TRADE_DIALOG", DialogType.TRADE)

	var trade_node = DialogNode.new()
	trade_node.node_id = 0
	trade_node.speaker = "NPC"
	trade_node.text_raw = "Looking to buy or sell? Check out my wares."
	trade_node.next_node = -1
	trade_dialog.nodes.append(trade_node)

	dialog_database["TRADE_DIALOG"] = trade_dialog

func _load_npc_personalities():
	"""Load NPC personality data"""
	# Create some default personalities
	var trader_personality = PersonalityData.new("TRADER_GENERIC")
	trader_personality.personality_traits = {"friendly": 0.8, "formal": 0.3, "greedy": 0.6}
	trader_personality.greeting_variants = [
		"Welcome to my shop!",
		"Looking to make a deal?",
		"Credits talk, everything else walks!"
	]
	npc_personalities["TRADER_GENERIC"] = trader_personality

	var officer_personality = PersonalityData.new("OFFICER_GENERIC")
	officer_personality.personality_traits = {"formal": 0.9, "authoritative": 0.8}
	officer_personality.greeting_variants = [
		"State your business.",
		"You have clearance to proceed.",
		"Identification verified. Welcome."
	]
	npc_personalities["OFFICER_GENERIC"] = officer_personality

	print("💬 DialogSystem: Loaded %d NPC personalities" % npc_personalities.size())

# ============================================================================
# DIALOG FLOW
# ============================================================================

func start_dialog(dialog_id: String, npc_id: String = "", context: Dictionary = {}) -> bool:
	"""Start a dialog sequence"""
	if not dialog_database.has(dialog_id):
		push_error("DialogSystem: Dialog not found: " + dialog_id)
		return false

	current_dialog = dialog_database[dialog_id]
	current_node_index = 0

	# Track dialog usage
	dialog_seen_count[dialog_id] = dialog_seen_count.get(dialog_id, 0) + 1

	# Apply context variables
	for key in context.keys():
		set_variable(key, context[key])

	dialog_started.emit(dialog_id, npc_id)

	# Display first node
	_display_current_node(npc_id)

	print("💬 Started dialog: %s (NPC: %s)" % [dialog_id, npc_id])

	return true

func _display_current_node(npc_id: String):
	"""Display current dialog node"""
	if not current_dialog or current_node_index >= current_dialog.nodes.size():
		end_dialog("COMPLETED")
		return

	var node = current_dialog.nodes[current_node_index]

	# Check conditions
	if not _evaluate_conditions(node.conditions):
		# Skip to next node if conditions not met
		current_node_index = node.next_node
		if current_node_index == -1:
			end_dialog("CONDITION_FAILED")
		else:
			_display_current_node(npc_id)
		return

	# Get text (localized or raw)
	var text = _get_dialog_text(node, npc_id)

	# Apply effects
	_apply_effects(node.effects)

	# Emit line displayed
	var line_data = {
		"speaker": node.speaker,
		"text": text,
		"has_choices": node.choices.size() > 0
	}
	dialog_line_displayed.emit(line_data)

	# Add to history
	_add_to_history(node.speaker, text)

	# Handle choices or continuation
	if node.choices.size() > 0:
		# Present choices
		var available_choices = []
		for choice in node.choices:
			if _evaluate_conditions(choice.conditions):
				var choice_text = _get_choice_text(choice, npc_id)
				available_choices.append({
					"id": choice.choice_id,
					"text": choice_text,
					"target_node": choice.target_node
				})

		dialog_choices_available.emit(available_choices)
	else:
		# Auto-advance to next node
		if node.next_node == -1:
			end_dialog("COMPLETED")
		else:
			current_node_index = node.next_node
			# Auto-display next (with small delay in practice)
			call_deferred("_display_current_node", npc_id)

func select_choice(choice_index: int):
	"""Player selects a dialog choice"""
	if not current_dialog or current_node_index >= current_dialog.nodes.size():
		return

	var node = current_dialog.nodes[current_node_index]

	if choice_index < 0 or choice_index >= node.choices.size():
		push_error("DialogSystem: Invalid choice index: %d" % choice_index)
		return

	var choice = node.choices[choice_index]

	# Apply choice effects
	_apply_effects(choice.effects)

	var choice_text = _get_choice_text(choice, "")
	dialog_choice_selected.emit(choice_index, choice_text)

	# Move to target node
	current_node_index = choice.target_node

	if current_node_index == -1:
		end_dialog("PLAYER_CHOICE")
	else:
		_display_current_node("")

func end_dialog(outcome: String = "COMPLETED"):
	"""End current dialog"""
	if not current_dialog:
		return

	var dialog_id = current_dialog.dialog_id
	current_dialog = null
	current_node_index = 0

	dialog_ended.emit(dialog_id, outcome)

	print("💬 Dialog ended: %s (Outcome: %s)" % [dialog_id, outcome])

# ============================================================================
# TEXT PROCESSING
# ============================================================================

func _get_dialog_text(node: DialogNode, npc_id: String) -> String:
	"""Get dialog text with variable substitution"""
	var text = ""

	# Use localized text if available
	if node.text_key != "" and Localization:
		text = Localization.translate(node.text_key)
	else:
		text = node.text_raw

	# Apply variable substitution
	text = _substitute_variables(text, npc_id)

	return text

func _get_choice_text(choice: DialogChoice, npc_id: String) -> String:
	"""Get choice text with variable substitution"""
	var text = ""

	if choice.text_key != "" and Localization:
		text = Localization.translate(choice.text_key)
	else:
		text = choice.text_raw

	text = _substitute_variables(text, npc_id)

	return text

func _substitute_variables(text: String, npc_id: String) -> String:
	"""Substitute variables in text"""
	var result = text

	# Player name
	result = result.replace("{PLAYER_NAME}", dialog_variables.get("PLAYER_NAME", "Captain"))

	# NPC name
	result = result.replace("{NPC_NAME}", npc_id)

	# Greeting (personality-based)
	if "{GREETING}" in result:
		result = result.replace("{GREETING}", _get_personality_greeting(npc_id))

	# Faction
	result = result.replace("{FACTION}", dialog_variables.get("FACTION", "Independent"))

	# Ship name
	result = result.replace("{SHIP_NAME}", dialog_variables.get("SHIP_NAME", "Venture"))

	# Credits
	result = result.replace("{CREDITS}", str(dialog_variables.get("CREDITS", 0)))

	# Custom variables
	for var_name in dialog_variables.keys():
		var placeholder = "{" + var_name + "}"
		if placeholder in result:
			result = result.replace(placeholder, str(dialog_variables[var_name]))

	return result

func _get_personality_greeting(npc_id: String) -> String:
	"""Get greeting based on NPC personality"""
	if npc_personalities.has(npc_id):
		var personality = npc_personalities[npc_id]
		if personality.greeting_variants.size() > 0:
			return personality.greeting_variants[randi() % personality.greeting_variants.size()]

	return "Hello"

# ============================================================================
# CONDITION EVALUATION
# ============================================================================

func _evaluate_conditions(conditions: Array) -> bool:
	"""Evaluate all conditions (AND logic)"""
	for condition in conditions:
		if not _evaluate_single_condition(condition):
			return false
	return true

func _evaluate_single_condition(condition: DialogCondition) -> bool:
	"""Evaluate a single condition"""
	match condition.condition_type:
		ConditionType.REPUTATION:
			# TODO: Check reputation system
			return true

		ConditionType.QUEST_STATE:
			# TODO: Check quest system
			return true

		ConditionType.HAS_ITEM:
			# TODO: Check inventory
			return true

		ConditionType.SKILL_LEVEL:
			# TODO: Check SkillManager
			return true

		ConditionType.FACTION_STANDING:
			# TODO: Check FactionSystem
			return true

		ConditionType.VARIABLE:
			return _evaluate_variable_condition(condition)

	return true

func _evaluate_variable_condition(condition: DialogCondition) -> bool:
	"""Evaluate a variable condition"""
	var var_value = dialog_variables.get(condition.target, null)

	if var_value == null:
		return false

	match condition.comparison:
		"==":
			return var_value == condition.value
		"!=":
			return var_value != condition.value
		">":
			return var_value > condition.value
		"<":
			return var_value < condition.value
		">=":
			return var_value >= condition.value
		"<=":
			return var_value <= condition.value

	return false

# ============================================================================
# EFFECTS
# ============================================================================

func _apply_effects(effects: Array):
	"""Apply dialog effects"""
	for effect in effects:
		_apply_single_effect(effect)

func _apply_single_effect(effect: DialogEffect):
	"""Apply a single effect"""
	match effect.effect_type:
		"SET_VARIABLE":
			set_variable(effect.target, effect.value)

		"GIVE_ITEM":
			# TODO: Add item to player inventory
			print("💬 Effect: Give item %s x%s" % [effect.target, effect.value])

		"TAKE_ITEM":
			# TODO: Remove item from player inventory
			print("💬 Effect: Take item %s x%s" % [effect.target, effect.value])

		"START_QUEST":
			# TODO: Start quest
			print("💬 Effect: Start quest %s" % effect.target)

		"COMPLETE_QUEST":
			# TODO: Complete quest
			print("💬 Effect: Complete quest %s" % effect.target)

		"CHANGE_REPUTATION":
			# TODO: Change reputation
			print("💬 Effect: Change reputation %s by %s" % [effect.target, effect.value])

		"GIVE_CREDITS":
			# TODO: Add credits to player
			print("💬 Effect: Give %s credits" % effect.value)

# ============================================================================
# VARIABLES
# ============================================================================

func set_variable(var_name: String, value: Variant):
	"""Set a dialog variable"""
	dialog_variables[var_name] = value
	variable_changed.emit(var_name, value)

func get_variable(var_name: String, default_value: Variant = null) -> Variant:
	"""Get a dialog variable"""
	return dialog_variables.get(var_name, default_value)

func clear_variables():
	"""Clear all dialog variables"""
	dialog_variables.clear()

# ============================================================================
# HISTORY
# ============================================================================

func _add_to_history(speaker: String, text: String):
	"""Add dialog line to history"""
	dialog_history.append({
		"timestamp": Time.get_unix_time_from_system(),
		"speaker": speaker,
		"text": text
	})

	# Trim old history
	if dialog_history.size() > MAX_HISTORY_ENTRIES:
		dialog_history.pop_front()

func get_history() -> Array:
	"""Get dialog history"""
	return dialog_history

func clear_history():
	"""Clear dialog history"""
	dialog_history.clear()

# ============================================================================
# DYNAMIC DIALOG (AI-Ready)
# ============================================================================

func generate_dynamic_dialog(context: Dictionary) -> DialogData:
	"""Generate dynamic dialog (AI-ready framework)"""
	# This is a placeholder for AI-generated dialogs
	# Future: Integrate with AI text generation

	var dialog = DialogData.new("DYNAMIC_" + str(Time.get_unix_time_from_system()), DialogType.RANDOM_FLAVOR)

	var node = DialogNode.new()
	node.node_id = 0
	node.speaker = "NPC"
	node.text_raw = _generate_random_flavor_text(context)
	node.next_node = -1

	dialog.nodes.append(node)

	return dialog

func _generate_random_flavor_text(context: Dictionary) -> String:
	"""Generate random flavor text"""
	var templates = [
		"The markets have been volatile lately.",
		"I heard there's a new mining opportunity in the next system.",
		"Watch out for pirates near the jumpgate.",
		"Business has been good this month.",
		"Have you heard about the war in the outer systems?",
	]

	return templates[randi() % templates.size()]

# ============================================================================
# QUERY API
# ============================================================================

func get_dialog(dialog_id: String) -> DialogData:
	"""Get dialog data by ID"""
	return dialog_database.get(dialog_id, null)

func has_seen_dialog(dialog_id: String) -> bool:
	"""Check if player has seen a dialog"""
	return dialog_seen_count.has(dialog_id)

func get_dialog_seen_count(dialog_id: String) -> int:
	"""Get how many times a dialog has been seen"""
	return dialog_seen_count.get(dialog_id, 0)
