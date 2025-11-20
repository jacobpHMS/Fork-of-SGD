extends Node

# ============================================================================
# FACTION SYSTEM - Faction Management & Diplomacy
# ============================================================================

signal faction_created(faction_id: String)
signal relationship_changed(faction_a: String, faction_b: String, new_value: float)
signal war_declared(faction_a: String, faction_b: String)
signal peace_signed(faction_a: String, faction_b: String)

# Relationship levels
const HOSTILE = -100.0
const UNFRIENDLY = -50.0
const NEUTRAL = 0.0
const FRIENDLY = 50.0
const ALLIED = 100.0

# Organization Types (NPC-Fraktionen)
enum OrganizationType {
	FREE_PLANET,         # Freier Planet (unabhängig)
	PLANETARY_ALLIANCE,  # Planetenverbund
	FEUDAL_SYSTEM,       # Feudalsystem (Lord/Vasallen)
	CORPORATION,         # Corporation (Megacorp)
	COMPANY,             # Firma (kleiner als Corp)
	MILITARY_JUNTA,      # Militärregierung
	DEMOCRATIC_UNION,    # Demokratische Union
	PIRATE_CLAN,         # Piratenclan
	RELIGIOUS_ORDER,     # Religiöse Ordnung
	AI_COLLECTIVE        # KI-Kollektiv
}

# Faction Size
enum FactionSize {
	TINY,      # 1-2 planets
	SMALL,     # 3-5 planets
	MEDIUM,    # 6-10 planets
	LARGE,     # 11-20 planets
	EMPIRE     # 20+ planets
}

class Faction:
	var faction_id: String = ""
	var faction_name: String = ""
	var description: String = ""
	var color: Color = Color.WHITE

	# Organization
	var organization_type: OrganizationType = OrganizationType.FREE_PLANET
	var faction_size: FactionSize = FactionSize.SMALL

	# Stats
	var credits: float = 1000000.0
	var total_ships: int = 0
	var total_stations: int = 0
	var total_planets: int = 0
	var military_power: float = 100.0
	var economic_power: float = 100.0
	var technology_level: int = 5  # 1-10

	# AI personality
	var aggression: float = 0.5
	var trade_focus: float = 0.5
	var expansion_focus: float = 0.5
	var diplomatic_openness: float = 0.5

	# Dynamic state
	var at_war_with: Array[String] = []  # faction_ids
	var allied_with: Array[String] = []
	var trade_agreements: Array[String] = []

	# Behavior modifiers based on organization type
	var can_declare_war: bool = true
	var can_form_alliances: bool = true
	var expansion_rate: float = 1.0

	func _init(id: String, name: String):
		faction_id = id
		faction_name = name
		setup_organization_modifiers()

	func setup_organization_modifiers():
		"""Configure behavior based on organization type"""
		match organization_type:
			OrganizationType.FREE_PLANET:
				can_declare_war = false
				expansion_rate = 0.0
				diplomatic_openness = 0.8

			OrganizationType.PLANETARY_ALLIANCE:
				can_form_alliances = true
				expansion_rate = 0.5
				trade_focus = 0.7

			OrganizationType.FEUDAL_SYSTEM:
				aggression = 0.6
				expansion_rate = 0.8
				diplomatic_openness = 0.3

			OrganizationType.CORPORATION:
				trade_focus = 0.9
				aggression = 0.3
				expansion_rate = 1.2  # Aggressive expansion

			OrganizationType.COMPANY:
				trade_focus = 0.8
				aggression = 0.2
				expansion_rate = 0.6

			OrganizationType.MILITARY_JUNTA:
				aggression = 0.8
				military_power *= 1.5
				trade_focus = 0.3

			OrganizationType.DEMOCRATIC_UNION:
				diplomatic_openness = 0.9
				can_form_alliances = true
				aggression = 0.3

			OrganizationType.PIRATE_CLAN:
				aggression = 0.9
				can_declare_war = true
				trade_focus = 0.1  # Plundering instead

			OrganizationType.RELIGIOUS_ORDER:
				diplomatic_openness = 0.5
				expansion_rate = 0.7
				aggression = 0.4

			OrganizationType.AI_COLLECTIVE:
				aggression = 0.7
				expansion_rate = 1.5  # Rapid expansion
				diplomatic_openness = 0.1  # Hard to negotiate with

	func update_faction_size():
		"""Update faction size based on planet count"""
		if total_planets <= 2:
			faction_size = FactionSize.TINY
		elif total_planets <= 5:
			faction_size = FactionSize.SMALL
		elif total_planets <= 10:
			faction_size = FactionSize.MEDIUM
		elif total_planets <= 20:
			faction_size = FactionSize.LARGE
		else:
			faction_size = FactionSize.EMPIRE

	func can_engage_in_large_scale_war() -> bool:
		"""Only large factions can declare major wars"""
		return faction_size >= FactionSize.MEDIUM and can_declare_war

var factions: Dictionary = {}  # faction_id -> Faction
var relationships: Dictionary = {}  # "faction_a:faction_b" -> float (-100 to 100)

var orchestrator: Node = null

# Dynamic faction behavior
var war_declarations: Array[Dictionary] = []  # {attacker, defender, start_time}
var alliance_treaties: Array[Dictionary] = []  # {faction_a, faction_b, treaty_type}
var faction_events: Array[Dictionary] = []  # Recent events

# War & Diplomacy settings
var war_chance_per_tick: float = 0.01  # 1% chance per world tick
var alliance_chance_per_tick: float = 0.05  # 5% chance per world tick
var peace_negotiation_threshold: float = -30.0  # Relationship threshold for peace talks

func _ready():
	print("⚔️  Faction System initialized")
	create_default_factions()

func set_orchestrator(orch: Node):
	orchestrator = orch

func create_default_factions():
	"""Create default factions with organization types"""
	# Player
	var player_faction = create_faction("player", "Player Faction", Color.CYAN)
	player_faction.organization_type = OrganizationType.FREE_PLANET

	# Major Factions
	var merchants = create_faction("merchants", "Merchants Guild", Color.GOLD)
	merchants.organization_type = OrganizationType.CORPORATION
	merchants.faction_size = FactionSize.LARGE
	merchants.total_planets = 15

	var military = create_faction("military", "Federation Navy", Color.BLUE)
	military.organization_type = OrganizationType.DEMOCRATIC_UNION
	military.faction_size = FactionSize.EMPIRE
	military.total_planets = 25

	var pirates = create_faction("pirates", "Pirate Clans", Color.RED)
	pirates.organization_type = OrganizationType.PIRATE_CLAN
	pirates.faction_size = FactionSize.MEDIUM
	pirates.total_planets = 8

	# Minor Factions
	var independents = create_faction("neutral", "Independent Systems", Color.GRAY)
	independents.organization_type = OrganizationType.FREE_PLANET
	independents.faction_size = FactionSize.SMALL
	independents.total_planets = 3

	var feudal = create_faction("feudal_empire", "Feudal Empire", Color.PURPLE)
	feudal.organization_type = OrganizationType.FEUDAL_SYSTEM
	feudal.faction_size = FactionSize.LARGE
	feudal.total_planets = 12

	var megacorp = create_faction("megacorp", "MegaCorp Industries", Color.ORANGE)
	megacorp.organization_type = OrganizationType.CORPORATION
	megacorp.faction_size = FactionSize.MEDIUM
	megacorp.total_planets = 9

	# Set default relationships
	set_relationship("player", "merchants", FRIENDLY)
	set_relationship("player", "military", NEUTRAL)
	set_relationship("player", "pirates", HOSTILE)
	set_relationship("merchants", "pirates", HOSTILE)
	set_relationship("military", "pirates", HOSTILE)
	set_relationship("military", "feudal_empire", UNFRIENDLY)
	set_relationship("merchants", "megacorp", UNFRIENDLY)  # Competition

func create_faction(id: String, name: String, color: Color = Color.WHITE) -> Faction:
	var faction = Faction.new(id, name)
	faction.color = color
	factions[id] = faction
	emit_signal("faction_created", id)
	return faction

func set_relationship(faction_a: String, faction_b: String, value: float):
	var key = get_relationship_key(faction_a, faction_b)
	relationships[key] = clamp(value, HOSTILE, ALLIED)
	emit_signal("relationship_changed", faction_a, faction_b, value)

func get_relationship(faction_a: String, faction_b: String) -> float:
	if faction_a == faction_b: return ALLIED
	var key = get_relationship_key(faction_a, faction_b)
	return relationships.get(key, NEUTRAL)

func are_hostile(faction_a: String, faction_b: String) -> bool:
	return get_relationship(faction_a, faction_b) <= UNFRIENDLY

func are_allies(faction_a: String, faction_b: String) -> bool:
	return get_relationship(faction_a, faction_b) >= FRIENDLY

func get_relationship_key(a: String, b: String) -> String:
	var arr = [a, b]
	arr.sort()
	return "%s:%s" % [arr[0], arr[1]]

func get_faction_count() -> int:
	return factions.size()

func _world_tick(tick: int):
	"""Slow faction updates - Dynamic faction behavior"""

	# Only large factions engage in wars/alliances
	var major_factions = get_major_factions()

	if major_factions.size() < 2:
		return

	# Random war declarations
	if randf() < war_chance_per_tick:
		try_declare_war(major_factions)

	# Random alliance formations
	if randf() < alliance_chance_per_tick:
		try_form_alliance(major_factions)

	# Check for peace negotiations
	check_peace_negotiations()

	# Update faction stats
	for faction_id in factions:
		var faction = factions[faction_id]
		faction.update_faction_size()

func get_major_factions() -> Array:
	"""Get factions capable of large-scale diplomacy"""
	var major = []

	for faction_id in factions:
		var faction = factions[faction_id]
		if faction.can_engage_in_large_scale_war():
			major.append(faction_id)

	return major

func try_declare_war(eligible_factions: Array):
	"""Attempt to declare war between factions"""
	if eligible_factions.size() < 2:
		return

	var attacker_id = eligible_factions.pick_random()
	var defender_id = eligible_factions.pick_random()

	# Don't attack self or existing enemies
	if attacker_id == defender_id:
		return

	var attacker = factions.get(attacker_id)
	if not attacker:
		return

	if attacker.at_war_with.has(defender_id):
		return

	# Check relationship
	var relationship = get_relationship(attacker_id, defender_id)

	# Only declare war if already hostile or based on aggression
	if relationship < UNFRIENDLY or (randf() < attacker.aggression * 0.5):
		declare_war(attacker_id, defender_id)

func declare_war(faction_a: String, faction_b: String):
	"""Officially declare war between factions"""
	var faction_a_obj = factions.get(faction_a)
	var faction_b_obj = factions.get(faction_b)

	if not faction_a_obj or not faction_b_obj:
		return

	# Update faction states
	faction_a_obj.at_war_with.append(faction_b)
	faction_b_obj.at_war_with.append(faction_a)

	# Set relationship to hostile
	set_relationship(faction_a, faction_b, HOSTILE)

	# Break alliances
	faction_a_obj.allied_with.erase(faction_b)
	faction_b_obj.allied_with.erase(faction_a)

	# Record war
	war_declarations.append({
		"attacker": faction_a,
		"defender": faction_b,
		"start_time": Time.get_ticks_msec() / 1000.0
	})

	# Record event
	faction_events.append({
		"type": "war_declared",
		"faction_a": faction_a,
		"faction_b": faction_b,
		"time": Time.get_ticks_msec() / 1000.0
	})

	emit_signal("war_declared", faction_a, faction_b)

	print("⚔️  WAR DECLARED: %s vs %s" % [faction_a_obj.faction_name, faction_b_obj.faction_name])

func try_form_alliance(eligible_factions: Array):
	"""Attempt to form alliance between factions"""
	if eligible_factions.size() < 2:
		return

	var faction_a_id = eligible_factions.pick_random()
	var faction_b_id = eligible_factions.pick_random()

	# Don't ally with self
	if faction_a_id == faction_b_id:
		return

	var faction_a = factions.get(faction_a_id)
	var faction_b = factions.get(faction_b_id)

	if not faction_a or not faction_b:
		return

	# Already allied?
	if faction_a.allied_with.has(faction_b_id):
		return

	# At war?
	if faction_a.at_war_with.has(faction_b_id):
		return

	# Check relationship
	var relationship = get_relationship(faction_a_id, faction_b_id)

	# Need friendly relationship
	if relationship >= FRIENDLY:
		form_alliance(faction_a_id, faction_b_id)

func form_alliance(faction_a: String, faction_b: String):
	"""Form alliance between factions"""
	var faction_a_obj = factions.get(faction_a)
	var faction_b_obj = factions.get(faction_b)

	if not faction_a_obj or not faction_b_obj:
		return

	# Update faction states
	faction_a_obj.allied_with.append(faction_b)
	faction_b_obj.allied_with.append(faction_a)

	# Set relationship to allied
	set_relationship(faction_a, faction_b, ALLIED)

	# Record alliance
	alliance_treaties.append({
		"faction_a": faction_a,
		"faction_b": faction_b,
		"treaty_type": "mutual_defense",
		"start_time": Time.get_ticks_msec() / 1000.0
	})

	# Record event
	faction_events.append({
		"type": "alliance_formed",
		"faction_a": faction_a,
		"faction_b": faction_b,
		"time": Time.get_ticks_msec() / 1000.0
	})

	print("🤝 ALLIANCE FORMED: %s + %s" % [faction_a_obj.faction_name, faction_b_obj.faction_name])

func check_peace_negotiations():
	"""Check if any wars should end"""
	for war in war_declarations.duplicate():
		var attacker = war["attacker"]
		var defender = war["defender"]

		# Check if relationship has improved
		var relationship = get_relationship(attacker, defender)

		if relationship > peace_negotiation_threshold:
			end_war(attacker, defender)

func end_war(faction_a: String, faction_b: String):
	"""End war between factions (peace treaty)"""
	var faction_a_obj = factions.get(faction_a)
	var faction_b_obj = factions.get(faction_b)

	if not faction_a_obj or not faction_b_obj:
		return

	# Update faction states
	faction_a_obj.at_war_with.erase(faction_b)
	faction_b_obj.at_war_with.erase(faction_a)

	# Improve relationship slightly
	var current_rel = get_relationship(faction_a, faction_b)
	set_relationship(faction_a, faction_b, current_rel + 20.0)

	# Remove from war declarations
	for i in range(war_declarations.size() - 1, -1, -1):
		var war = war_declarations[i]
		if (war["attacker"] == faction_a and war["defender"] == faction_b) or \
		   (war["attacker"] == faction_b and war["defender"] == faction_a):
			war_declarations.remove_at(i)

	# Record event
	faction_events.append({
		"type": "peace_signed",
		"faction_a": faction_a,
		"faction_b": faction_b,
		"time": Time.get_ticks_msec() / 1000.0
	})

	emit_signal("peace_signed", faction_a, faction_b)

	print("🕊️  PEACE TREATY: %s <-> %s" % [faction_a_obj.faction_name, faction_b_obj.faction_name])

func get_save_data() -> Dictionary:
	return {"factions": factions.duplicate(), "relationships": relationships.duplicate()}

func load_save_data(data: Dictionary):
	if data.has("factions"): factions = data["factions"]
	if data.has("relationships"): relationships = data["relationships"]
