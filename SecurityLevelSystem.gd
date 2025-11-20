extends Node

# ============================================================================
# SECURITY LEVEL SYSTEM - EVE Online inspired Security Rating
# ============================================================================
# Manages security levels for star systems (1-30 scale)
# Higher security = safer, but poorer resources
# Lower security = dangerous, but richer resources

signal security_level_changed(system_id: String, new_level: int)
signal security_violation(violator_id: String, system_id: String, severity: float)

# Security Level Categories (EVE-Style adapted to 1-30 scale)
const HIGH_SEC_MIN = 25  # 25-30: High Security (Empire Space)
const MED_SEC_MIN = 15   # 15-24: Medium Security (Lowsec)
const LOW_SEC_MIN = 5    # 5-14: Low Security (Nullsec)
const NULL_SEC_MIN = 1   # 1-4: Null Security (Dangerous Space)

# Security level affects
const SECURITY_MULTIPLIERS = {
	# Resource richness (inverse of security)
	"resource_richness": {
		30: 0.3,   # High sec: 30% base resources
		25: 0.5,
		20: 0.7,
		15: 1.0,   # Medium sec: 100% base
		10: 1.5,
		5: 2.0,    # Low sec: 200% resources
		1: 3.0     # Null sec: 300% resources (EXTREME!)
	},
	# Rare ore spawn chance
	"rare_spawn_chance": {
		30: 0.01,  # 1% rare ores in high sec
		25: 0.05,
		20: 0.10,
		15: 0.20,
		10: 0.35,
		5: 0.50,
		1: 0.70   # 70% rare ores in null sec!
	},
	# NPC patrol density (police/military)
	"patrol_density": {
		30: 3.0,   # Heavy patrols in high sec
		25: 2.0,
		20: 1.5,
		15: 1.0,
		10: 0.5,
		5: 0.2,
		1: 0.0    # No law enforcement in null sec
	},
	# Pirate spawn rate
	"pirate_spawn_rate": {
		30: 0.0,   # No pirates in high sec
		25: 0.1,
		20: 0.3,
		15: 0.5,
		10: 1.0,
		5: 2.0,
		1: 5.0    # EXTREME pirate activity in null sec
	}
}

# System Security Data
class StarSystem:
	var system_id: String = ""
	var system_name: String = ""
	var position: Vector2 = Vector2.ZERO
	var security_level: int = 15  # Default: Medium Security
	var radius: float = 5000.0

	# System ownership
	var owning_faction: String = ""
	var planet_ids: Array[String] = []
	var station_ids: Array[String] = []

	# Dynamic security
	var security_violations: int = 0
	var last_violation_time: float = 0.0
	var security_response_active: bool = false

	# Resource data
	var asteroid_fields: Array[Dictionary] = []  # {position, richness, ore_types}
	var resource_richness: float = 1.0

	func _init(id: String, name: String, sec_level: int = 15):
		system_id = id
		system_name = name
		security_level = clamp(sec_level, 1, 30)
		update_resource_richness()

	func update_resource_richness():
		"""Calculate resource richness based on security level"""
		# Interpolate between security multipliers
		var keys = [30, 25, 20, 15, 10, 5, 1]
		var richness_mult = SECURITY_MULTIPLIERS["resource_richness"]

		# Find closest security levels for interpolation
		for i in range(keys.size() - 1):
			if security_level >= keys[i + 1] and security_level <= keys[i]:
				var low = keys[i + 1]
				var high = keys[i]
				if high == low:
					resource_richness = richness_mult[low]
					return
				var t = float(security_level - low) / float(high - low)
				resource_richness = lerp(richness_mult[low], richness_mult[high], t)
				return

		# Fallback
		if security_level >= HIGH_SEC_MIN:
			resource_richness = richness_mult[30]
		else:
			resource_richness = richness_mult[1]

	func get_security_category() -> String:
		if security_level >= HIGH_SEC_MIN: return "HIGH_SEC"
		elif security_level >= MED_SEC_MIN: return "MED_SEC"
		elif security_level >= LOW_SEC_MIN: return "LOW_SEC"
		else: return "NULL_SEC"

	func is_high_security() -> bool:
		return security_level >= HIGH_SEC_MIN

	func is_lawless() -> bool:
		return security_level < LOW_SEC_MIN

	func get_info() -> Dictionary:
		return {
			"system_id": system_id,
			"system_name": system_name,
			"security_level": security_level,
			"security_category": get_security_category(),
			"resource_richness": resource_richness,
			"owning_faction": owning_faction,
			"planets": planet_ids.size(),
			"stations": station_ids.size()
		}

# ============================================================================
# SYSTEM DATABASE
# ============================================================================

var star_systems: Dictionary = {}  # system_id -> StarSystem
var systems_by_faction: Dictionary = {}  # faction_id -> Array[system_id]
var current_system_id: String = ""  # Player's current system

# Orchestrator reference
var orchestrator: Node = null

# ============================================================================
# INITIALIZATION
# ============================================================================

func _ready():
	print("🌟 Security Level System initialized")
	generate_default_systems()

func set_orchestrator(orch: Node):
	orchestrator = orch

# ============================================================================
# SYSTEM GENERATION
# ============================================================================

func generate_default_systems():
	"""Generate default star systems with varying security levels"""

	# High Security Systems (Capital regions)
	create_system("sol", "Sol System", Vector2(0, 0), 30, "military")
	create_system("alpha_centauri", "Alpha Centauri", Vector2(5000, 0), 28, "military")
	create_system("sirius", "Sirius", Vector2(-5000, 0), 27, "merchants")

	# Medium Security Systems (Trade routes)
	create_system("barnards_star", "Barnard's Star", Vector2(0, 7000), 20, "merchants")
	create_system("wolf_359", "Wolf 359", Vector2(7000, 7000), 18, "neutral")
	create_system("lalande", "Lalande 21185", Vector2(-7000, 7000), 16, "neutral")

	# Low Security Systems (Frontier)
	create_system("ross_154", "Ross 154", Vector2(10000, 10000), 10, "neutral")
	create_system("epsilon_eridani", "Epsilon Eridani", Vector2(-10000, 10000), 8, "pirates")
	create_system("tau_ceti", "Tau Ceti", Vector2(10000, -10000), 12, "neutral")

	# Null Security Systems (Lawless space)
	create_system("outer_rim_1", "Outer Rim Alpha", Vector2(15000, 15000), 3, "pirates")
	create_system("outer_rim_2", "Outer Rim Beta", Vector2(-15000, 15000), 2, "pirates")
	create_system("dark_zone", "Dark Zone", Vector2(0, 20000), 1, "pirates")

	print("✅ Generated %d star systems" % star_systems.size())

func create_system(id: String, name: String, pos: Vector2, sec_level: int, faction: String = "") -> StarSystem:
	"""Create a new star system"""
	var system = StarSystem.new(id, name, sec_level)
	system.position = pos
	system.owning_faction = faction

	# Generate asteroid fields based on security level
	generate_asteroid_fields(system)

	star_systems[id] = system

	# Add to faction index
	if faction != "":
		if not systems_by_faction.has(faction):
			systems_by_faction[faction] = []
		systems_by_faction[faction].append(id)

	emit_signal("security_level_changed", id, sec_level)

	return system

func generate_asteroid_fields(system: StarSystem):
	"""Generate asteroid fields for a system based on security level"""
	var field_count = randi_range(3, 8)
	var richness = system.resource_richness

	for i in range(field_count):
		var field = {
			"position": system.position + Vector2(
				randf_range(-system.radius, system.radius),
				randf_range(-system.radius, system.radius)
			),
			"richness": richness * randf_range(0.8, 1.2),
			"ore_types": get_ore_types_for_security(system.security_level),
			"asteroid_count": int(50 * richness)
		}
		system.asteroid_fields.append(field)

func get_ore_types_for_security(sec_level: int) -> Array[String]:
	"""Get available ore types based on security level"""
	var ores: Array[String] = []

	# Common ores available everywhere (from OreDatabase)
	ores.append_array(["Ferralite", "Cupreon", "Palestone"])

	# Uncommon ores (Medium sec and below)
	if sec_level <= 24:
		ores.append_array(["Titanex", "Densore", "Alumara"])

	# Rare ores (Low sec and below)
	if sec_level <= 14:
		ores.append_array(["Noblore", "Auralith", "Mirrorvein"])

	# Exotic ores (Null sec ONLY) - Ultra-rare from OreDatabase
	if sec_level <= 4:
		ores.append_array(["Fusionore", "Novaore", "Nexalith"])

	return ores

# ============================================================================
# SECURITY LEVEL QUERIES
# ============================================================================

func get_system(system_id: String) -> StarSystem:
	return star_systems.get(system_id, null)

func get_security_level(system_id: String) -> int:
	var system = get_system(system_id)
	return system.security_level if system else 15

func get_security_category(system_id: String) -> String:
	var system = get_system(system_id)
	return system.get_security_category() if system else "UNKNOWN"

func get_resource_richness(system_id: String) -> float:
	var system = get_system(system_id)
	return system.resource_richness if system else 1.0

func get_rare_spawn_chance(system_id: String) -> float:
	var sec_level = get_security_level(system_id)
	var keys = [30, 25, 20, 15, 10, 5, 1]
	var chances = SECURITY_MULTIPLIERS["rare_spawn_chance"]

	# Find closest key
	for key in keys:
		if sec_level >= key:
			return chances[key]

	return chances[1]

func get_patrol_density(system_id: String) -> float:
	var sec_level = get_security_level(system_id)
	var keys = [30, 25, 20, 15, 10, 5, 1]
	var densities = SECURITY_MULTIPLIERS["patrol_density"]

	for key in keys:
		if sec_level >= key:
			return densities[key]

	return densities[1]

func get_pirate_spawn_rate(system_id: String) -> float:
	var sec_level = get_security_level(system_id)
	var keys = [30, 25, 20, 15, 10, 5, 1]
	var rates = SECURITY_MULTIPLIERS["pirate_spawn_rate"]

	for key in keys:
		if sec_level >= key:
			return rates[key]

	return rates[1]

func get_system_by_position(position: Vector2) -> StarSystem:
	"""Find which system a position is in"""
	var closest_system: StarSystem = null
	var closest_distance = INF

	for system_id in star_systems:
		var system = star_systems[system_id]
		var distance = position.distance_to(system.position)

		if distance < system.radius and distance < closest_distance:
			closest_system = system
			closest_distance = distance

	return closest_system

func get_systems_by_faction(faction_id: String) -> Array:
	return systems_by_faction.get(faction_id, [])

# ============================================================================
# SECURITY VIOLATIONS & ENFORCEMENT
# ============================================================================

func report_security_violation(violator_id: String, system_id: String, severity: float = 1.0):
	"""Report a crime/security violation in a system"""
	var system = get_system(system_id)
	if not system:
		return

	system.security_violations += 1
	system.last_violation_time = Time.get_ticks_msec() / 1000.0

	# High security systems respond IMMEDIATELY
	if system.is_high_security():
		trigger_security_response(system, violator_id, severity)

	emit_signal("security_violation", violator_id, system_id, severity)

func trigger_security_response(system: StarSystem, violator_id: String, severity: float):
	"""Trigger police/military response to violation"""
	system.security_response_active = true

	# Spawn security forces based on security level
	var response_strength = get_patrol_density(system.system_id) * severity

	print("🚨 SECURITY RESPONSE in %s: Strength %.1f" % [system.system_name, response_strength])

	# TODO: Spawn police/military NPCs to hunt violator
	# This would integrate with NPCManager

# ============================================================================
# DYNAMIC SECURITY CHANGES
# ============================================================================

func modify_security_level(system_id: String, delta: int):
	"""Dynamically change system security level"""
	var system = get_system(system_id)
	if not system:
		return

	var old_level = system.security_level
	system.security_level = clamp(system.security_level + delta, 1, 30)
	system.update_resource_richness()

	if old_level != system.security_level:
		emit_signal("security_level_changed", system_id, system.security_level)
		print("⚠️  Security level changed in %s: %d -> %d" % [system.system_name, old_level, system.security_level])

# ============================================================================
# WORLD TICK
# ============================================================================

func _world_tick(tick: int):
	"""Slow security system updates"""
	# Security violations decay over time
	for system_id in star_systems:
		var system = star_systems[system_id]

		if system.security_violations > 0:
			system.security_violations = max(0, system.security_violations - 1)

		# Security responses expire
		if system.security_response_active:
			var time_since_violation = (Time.get_ticks_msec() / 1000.0) - system.last_violation_time
			if time_since_violation > 300.0:  # 5 minutes
				system.security_response_active = false

# ============================================================================
# SAVE/LOAD
# ============================================================================

func get_save_data() -> Dictionary:
	var systems_data = {}

	for system_id in star_systems:
		var system = star_systems[system_id]
		systems_data[system_id] = {
			"name": system.system_name,
			"position": {"x": system.position.x, "y": system.position.y},
			"security_level": system.security_level,
			"owning_faction": system.owning_faction,
			"violations": system.security_violations
		}

	return {
		"systems": systems_data,
		"current_system": current_system_id
	}

func load_save_data(data: Dictionary):
	star_systems.clear()
	systems_by_faction.clear()

	if data.has("systems"):
		for system_id in data["systems"]:
			var sys_data = data["systems"][system_id]
			var system = StarSystem.new(system_id, sys_data["name"], sys_data["security_level"])
			system.position = Vector2(sys_data["position"]["x"], sys_data["position"]["y"])
			system.owning_faction = sys_data.get("owning_faction", "")
			system.security_violations = sys_data.get("violations", 0)

			star_systems[system_id] = system

	if data.has("current_system"):
		current_system_id = data["current_system"]
