extends Node

# ============================================================================
# ASTEROID FIELD MANAGER - Dynamic Asteroid Spawning
# ============================================================================
# Manages asteroid field generation based on Security Levels
# Spawns asteroids with varying richness and ore types

signal asteroid_field_created(field_id: String, system_id: String)
signal asteroid_spawned(asteroid_id: String, field_id: String)
signal asteroid_depleted(asteroid_id: String)

# Asteroid Field Data
class AsteroidField:
	var field_id: String = ""
	var field_name: String = ""
	var system_id: String = ""
	var position: Vector2 = Vector2.ZERO
	var radius: float = 2000.0

	# Field properties
	var richness: float = 1.0  # Multiplier from security level
	var ore_types: Array[String] = []  # Available ore types
	var asteroid_count: int = 50
	var density: float = 1.0  # Asteroids per unit area

	# Spawn settings
	var min_asteroid_size: float = 50.0
	var max_asteroid_size: float = 200.0
	var respawn_enabled: bool = true
	var respawn_time: float = 300.0  # 5 minutes

	# Runtime data
	var active_asteroids: Array[String] = []
	var depleted_asteroids: Dictionary = {}  # asteroid_id -> depletion_time

	func _init(id: String, name: String, sys_id: String):
		field_id = id
		field_name = name
		system_id = sys_id

	func get_info() -> Dictionary:
		return {
			"field_id": field_id,
			"field_name": field_name,
			"system_id": system_id,
			"position": {"x": position.x, "y": position.y},
			"richness": richness,
			"ore_types": ore_types,
			"asteroid_count": asteroid_count,
			"active_asteroids": active_asteroids.size(),
			"density": density
		}

# Asteroid Data
class Asteroid:
	var asteroid_id: String = ""
	var field_id: String = ""
	var ore_type: String = "iron"
	var position: Vector2 = Vector2.ZERO
	var size: float = 100.0  # Visual size
	var ore_amount: float = 1000.0  # Total ore
	var ore_remaining: float = 1000.0
	var is_depleted: bool = false

	# Mining stats
	var mining_difficulty: float = 1.0
	var optimal_laser_tier: int = 1

	func _init(id: String, field: String, type: String):
		asteroid_id = id
		field_id = field
		ore_type = type

	func mine(amount: float) -> float:
		"""Mine ore from asteroid, returns actual amount mined"""
		var mined = min(amount, ore_remaining)
		ore_remaining -= mined

		if ore_remaining <= 0:
			is_depleted = true
			ore_remaining = 0

		return mined

	func get_depletion_percent() -> float:
		if ore_amount <= 0:
			return 0.0
		return (ore_amount - ore_remaining) / ore_amount * 100.0

	func get_info() -> Dictionary:
		return {
			"asteroid_id": asteroid_id,
			"field_id": field_id,
			"ore_type": ore_type,
			"position": {"x": position.x, "y": position.y},
			"size": size,
			"ore_amount": ore_amount,
			"ore_remaining": ore_remaining,
			"depletion_percent": get_depletion_percent(),
			"is_depleted": is_depleted
		}

# ============================================================================
# DATABASE
# ============================================================================

var asteroid_fields: Dictionary = {}  # field_id -> AsteroidField
var fields_by_system: Dictionary = {}  # system_id -> Array[field_id]
var asteroids: Dictionary = {}  # asteroid_id -> Asteroid
var asteroids_by_field: Dictionary = {}  # field_id -> Array[asteroid_id]

# References
var orchestrator: Node = null
var security_system: Node = null
var ore_database: Node = null

# Spawning settings
var auto_spawn_asteroids: bool = true
var max_asteroids_per_field: int = 100
var respawn_check_interval: float = 60.0  # Check every minute
var respawn_timer: float = 0.0

# Ore rarity weights based on security level (uses OreDatabase names)
const ORE_WEIGHTS = {
	# Common ores (everywhere) - from OreDatabase
	"Ferralite": {"weight": 40, "min_security": 0},
	"Cupreon": {"weight": 30, "min_security": 0},
	"Palestone": {"weight": 20, "min_security": 0},

	# Uncommon ores (Med sec and below)
	"Titanex": {"weight": 15, "min_security": 0, "max_security": 24},
	"Densore": {"weight": 12, "min_security": 0, "max_security": 24},
	"Alumara": {"weight": 10, "min_security": 0, "max_security": 24},

	# Rare ores (Low sec and below)
	"Noblore": {"weight": 8, "min_security": 0, "max_security": 14},
	"Auralith": {"weight": 6, "min_security": 0, "max_security": 14},
	"Mirrorvein": {"weight": 5, "min_security": 0, "max_security": 14},

	# Exotic ores (Null sec ONLY) - Ultra-rare from OreDatabase
	"Fusionore": {"weight": 10, "min_security": 0, "max_security": 4},
	"Novaore": {"weight": 5, "min_security": 0, "max_security": 4},
	"Nexalith": {"weight": 3, "min_security": 0, "max_security": 4}
}

# ============================================================================
# INITIALIZATION
# ============================================================================

func _ready():
	print("☄️  Asteroid Field Manager initialized")

	# Get system references
	await get_tree().process_frame
	if has_node("/root/SecurityLevelSystem"):
		security_system = get_node("/root/SecurityLevelSystem")
	if has_node("/root/OreDatabase"):
		ore_database = get_node("/root/OreDatabase")

func set_orchestrator(orch: Node):
	orchestrator = orch

# ============================================================================
# FIELD GENERATION
# ============================================================================

func generate_fields_for_system(system_id: String):
	"""Generate asteroid fields for a star system"""
	if not security_system:
		print("⚠️  SecurityLevelSystem not found!")
		return

	var system = security_system.get_system(system_id)
	if not system:
		print("⚠️  System not found: %s" % system_id)
		return

	# Number of fields based on system
	var field_count = randi_range(3, 8)

	for i in range(field_count):
		var field_id = "%s_field_%d" % [system_id, i + 1]
		var field_name = "%s Asteroid Field %s" % [system.system_name, _number_to_letter(i)]

		var field = AsteroidField.new(field_id, field_name, system_id)
		field.position = system.position + Vector2(
			randf_range(-system.radius, system.radius),
			randf_range(-system.radius, system.radius)
		)
		field.radius = randf_range(1500, 3000)
		field.richness = system.resource_richness * randf_range(0.8, 1.2)
		field.ore_types = get_ore_types_for_security(system.security_level)
		field.asteroid_count = int(50 * field.richness)
		field.density = field.richness

		# Add to database
		asteroid_fields[field_id] = field

		if not fields_by_system.has(system_id):
			fields_by_system[system_id] = []
		fields_by_system[system_id].append(field_id)

		# Spawn asteroids in field
		if auto_spawn_asteroids:
			spawn_asteroids_in_field(field_id)

		emit_signal("asteroid_field_created", field_id, system_id)

	print("☄️  Generated %d asteroid fields in %s" % [field_count, system.system_name])

func generate_all_fields():
	"""Generate asteroid fields for all systems"""
	if not security_system:
		return

	for system_id in security_system.star_systems:
		generate_fields_for_system(system_id)

	print("✅ Generated asteroid fields for %d systems" % security_system.star_systems.size())

func get_ore_types_for_security(sec_level: int) -> Array[String]:
	"""Get available ore types based on security level"""
	var available_ores: Array[String] = []

	for ore_type in ORE_WEIGHTS:
		var ore_data = ORE_WEIGHTS[ore_type]
		var min_sec = ore_data.get("min_security", 0)
		var max_sec = ore_data.get("max_security", 30)

		if sec_level >= min_sec and sec_level <= max_sec:
			available_ores.append(ore_type)

	return available_ores

func _number_to_letter(num: int) -> String:
	"""Convert number to letter (0=A, 1=B, etc.)"""
	if num >= 0 and num < 26:
		return char(65 + num)  # ASCII 'A' = 65
	return str(num)

# ============================================================================
# ASTEROID SPAWNING
# ============================================================================

func spawn_asteroids_in_field(field_id: String):
	"""Spawn asteroids in a field"""
	var field = asteroid_fields.get(field_id)
	if not field:
		return

	var count = min(field.asteroid_count, max_asteroids_per_field)

	for i in range(count):
		spawn_asteroid(field_id)

func spawn_asteroid(field_id: String, specific_ore: String = "") -> String:
	"""Spawn a single asteroid in a field"""
	var field = asteroid_fields.get(field_id)
	if not field:
		return ""

	var asteroid_id = "%s_asteroid_%d" % [field_id, Time.get_ticks_msec()]

	# Select ore type
	var ore_type = specific_ore
	if ore_type == "":
		ore_type = select_weighted_ore(field)

	# Use default ore if empty
	if ore_type == "":
		ore_type = "Ferralite"

	var asteroid = Asteroid.new(asteroid_id, field_id, ore_type)

	# Position in field (circular distribution)
	var angle = randf() * TAU
	var distance = randf() * field.radius
	asteroid.position = field.position + Vector2(cos(angle), sin(angle)) * distance

	# Size based on richness
	asteroid.size = randf_range(field.min_asteroid_size, field.max_asteroid_size) * field.richness

	# Ore amount based on size and richness
	asteroid.ore_amount = asteroid.size * 10.0 * field.richness
	asteroid.ore_remaining = asteroid.ore_amount

	# Mining difficulty based on ore type
	asteroid.mining_difficulty = get_ore_difficulty(ore_type)
	asteroid.optimal_laser_tier = get_optimal_tier_for_ore(ore_type)

	# Add to database
	asteroids[asteroid_id] = asteroid
	field.active_asteroids.append(asteroid_id)

	if not asteroids_by_field.has(field_id):
		asteroids_by_field[field_id] = []
	asteroids_by_field[field_id].append(asteroid_id)

	emit_signal("asteroid_spawned", asteroid_id, field_id)

	return asteroid_id

func select_weighted_ore(field: AsteroidField) -> String:
	"""Select ore type based on weights and field ore types"""
	var available_ores = field.ore_types
	if available_ores.is_empty():
		return "iron"  # Fallback

	# Build weighted list
	var weights: Array[float] = []
	var total_weight: float = 0.0

	for ore_type in available_ores:
		var weight = ORE_WEIGHTS.get(ore_type, {}).get("weight", 1.0)
		weights.append(weight)
		total_weight += weight

	# Random selection
	var roll = randf() * total_weight
	var cumulative: float = 0.0

	for i in range(available_ores.size()):
		cumulative += weights[i]
		if roll <= cumulative:
			return available_ores[i]

	return available_ores[0]  # Fallback

func get_ore_difficulty(ore_type: String) -> float:
	"""Get mining difficulty for ore type"""
	match ore_type:
		"Ferralite", "Cupreon", "Palestone": return 1.0
		"Titanex", "Densore", "Alumara": return 1.5
		"Noblore", "Auralith", "Mirrorvein": return 2.0
		"Fusionore", "Novaore", "Nexalith": return 3.0
		_: return 1.0

func get_optimal_tier_for_ore(ore_type: String) -> int:
	"""Get optimal laser tier for ore"""
	match ore_type:
		"Ferralite", "Cupreon", "Palestone": return 1
		"Titanex", "Densore", "Alumara": return 2
		"Noblore", "Auralith", "Mirrorvein": return 3
		"Fusionore", "Novaore", "Nexalith": return 5
		_: return 1

# ============================================================================
# ASTEROID DEPLETION & RESPAWN
# ============================================================================

func deplete_asteroid(asteroid_id: String):
	"""Mark asteroid as depleted"""
	var asteroid = asteroids.get(asteroid_id)
	if not asteroid:
		return

	asteroid.is_depleted = true

	var field = asteroid_fields.get(asteroid.field_id)
	if field:
		field.active_asteroids.erase(asteroid_id)

		if field.respawn_enabled:
			field.depleted_asteroids[asteroid_id] = Time.get_ticks_msec() / 1000.0

	emit_signal("asteroid_depleted", asteroid_id)

func check_respawns():
	"""Check for asteroid respawns"""
	var current_time = Time.get_ticks_msec() / 1000.0

	for field_id in asteroid_fields:
		var field = asteroid_fields[field_id]

		if not field.respawn_enabled:
			continue

		var to_respawn: Array[String] = []

		for asteroid_id in field.depleted_asteroids:
			var depletion_time = field.depleted_asteroids[asteroid_id]

			if current_time - depletion_time >= field.respawn_time:
				to_respawn.append(asteroid_id)

		# Respawn asteroids
		for asteroid_id in to_respawn:
			respawn_asteroid(asteroid_id)
			field.depleted_asteroids.erase(asteroid_id)

func respawn_asteroid(asteroid_id: String):
	"""Respawn a depleted asteroid"""
	var asteroid = asteroids.get(asteroid_id)
	if not asteroid:
		return

	asteroid.is_depleted = false
	asteroid.ore_remaining = asteroid.ore_amount

	var field = asteroid_fields.get(asteroid.field_id)
	if field:
		field.active_asteroids.append(asteroid_id)

	print("♻️  Asteroid respawned: %s" % asteroid_id)

# ============================================================================
# UPDATES
# ============================================================================

func _orchestrated_update(delta: float):
	"""Fast updates"""
	# Respawn checks
	if auto_spawn_asteroids:
		respawn_timer += delta
		if respawn_timer >= respawn_check_interval:
			respawn_timer = 0.0
			check_respawns()

func _world_tick(tick: int):
	"""Slow updates"""
	pass

# ============================================================================
# QUERIES
# ============================================================================

func get_field(field_id: String) -> AsteroidField:
	return asteroid_fields.get(field_id, null)

func get_fields_in_system(system_id: String) -> Array:
	return fields_by_system.get(system_id, [])

func get_asteroid(asteroid_id: String) -> Asteroid:
	return asteroids.get(asteroid_id, null)

func get_asteroids_in_field(field_id: String) -> Array:
	return asteroids_by_field.get(field_id, [])

func get_nearest_field(position: Vector2) -> AsteroidField:
	"""Find nearest asteroid field to position"""
	var nearest: AsteroidField = null
	var nearest_distance = INF

	for field_id in asteroid_fields:
		var field = asteroid_fields[field_id]
		var distance = position.distance_to(field.position)

		if distance < nearest_distance:
			nearest = field
			nearest_distance = distance

	return nearest

func get_asteroids_in_range(position: Vector2, range: float) -> Array:
	"""Get asteroids in range of position"""
	var results = []

	for asteroid_id in asteroids:
		var asteroid = asteroids[asteroid_id]
		if not asteroid.is_depleted and asteroid.position.distance_to(position) <= range:
			results.append(asteroid_id)

	return results

func get_total_asteroid_count() -> int:
	return asteroids.size()

func get_active_asteroid_count() -> int:
	var count = 0
	for asteroid_id in asteroids:
		if not asteroids[asteroid_id].is_depleted:
			count += 1
	return count

# ============================================================================
# SAVE/LOAD
# ============================================================================

func get_save_data() -> Dictionary:
	var fields_data = {}
	for field_id in asteroid_fields:
		var field = asteroid_fields[field_id]
		fields_data[field_id] = {
			"name": field.field_name,
			"system": field.system_id,
			"position": {"x": field.position.x, "y": field.position.y},
			"richness": field.richness,
			"ore_types": field.ore_types
		}

	var asteroids_data = {}
	for asteroid_id in asteroids:
		var asteroid = asteroids[asteroid_id]
		asteroids_data[asteroid_id] = {
			"field": asteroid.field_id,
			"ore_type": asteroid.ore_type,
			"position": {"x": asteroid.position.x, "y": asteroid.position.y},
			"ore_remaining": asteroid.ore_remaining,
			"is_depleted": asteroid.is_depleted
		}

	return {
		"fields": fields_data,
		"asteroids": asteroids_data
	}

func load_save_data(data: Dictionary):
	asteroid_fields.clear()
	asteroids.clear()
	fields_by_system.clear()
	asteroids_by_field.clear()

	if data.has("fields"):
		for field_id in data["fields"]:
			var f_data = data["fields"][field_id]
			var field = AsteroidField.new(field_id, f_data["name"], f_data["system"])
			field.position = Vector2(f_data["position"]["x"], f_data["position"]["y"])
			field.richness = f_data["richness"]
			field.ore_types = f_data["ore_types"]

			asteroid_fields[field_id] = field

	if data.has("asteroids"):
		for asteroid_id in data["asteroids"]:
			var a_data = data["asteroids"][asteroid_id]
			var asteroid = Asteroid.new(asteroid_id, a_data["field"], a_data["ore_type"])
			asteroid.position = Vector2(a_data["position"]["x"], a_data["position"]["y"])
			asteroid.ore_remaining = a_data["ore_remaining"]
			asteroid.is_depleted = a_data["is_depleted"]

			asteroids[asteroid_id] = asteroid
