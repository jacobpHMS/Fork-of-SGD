extends Node

# ============================================================================
# PLANET SYSTEM
# ============================================================================
# Manages planets, landing, surface facilities, passenger destinations

signal planet_created(planet_id: String)
signal ship_landed(ship_id: String, planet_id: String)
signal ship_departed(ship_id: String, planet_id: String)
signal planet_ownership_changed(planet_id: String, new_faction: String)

# Planet Types
enum PlanetType {
	TERRESTRIAL,     # Earth-like, habitable
	OCEANIC,         # Water worlds
	DESERT,          # Arid, Tatooine-style
	ICE,             # Frozen worlds
	VOLCANIC,        # Lava planets
	GAS_GIANT,       # Gas giants (orbital stations only)
	BARREN,          # Rocky, no atmosphere
	TOXIC            # Poisonous atmosphere
}

# Planet Class
enum PlanetClass {
	CLASS_M,    # Habitable (Earth-like)
	CLASS_H,    # Desert worlds
	CLASS_J,    # Gas giants
	CLASS_K,    # Adaptable
	CLASS_L,    # Marginal
	CLASS_D     # Barren
}

# Government Types (matches faction organization types)
enum GovernmentType {
	INDEPENDENT,       # Free planet
	FEDERATION,        # Part of federation
	CORPORATE,         # Corporation-owned
	FEUDAL,            # Feudal system
	MILITARY,          # Military dictatorship
	DEMOCRACY,         # Democratic government
	ANARCHIST          # No government
}

# Planet Data
class Planet:
	var planet_id: String = ""
	var planet_name: String = ""
	var planet_type: PlanetType = PlanetType.TERRESTRIAL
	var planet_class: PlanetClass = PlanetClass.CLASS_M

	# Location
	var system_id: String = ""
	var position: Vector2 = Vector2.ZERO
	var orbit_radius: float = 2000.0
	var orbit_speed: float = 0.1

	# Stats
	var radius: float = 500.0  # Visual size
	var population: int = 1000000
	var development_level: int = 5  # 1-10 scale

	# Ownership
	var owning_faction: String = "neutral"
	var government_type: GovernmentType = GovernmentType.INDEPENDENT

	# Economy
	var gdp: float = 1000000.0
	var trade_volume: float = 100000.0
	var primary_export: String = "minerals"
	var primary_import: String = "food"

	# Services
	var has_spaceport: bool = true
	var has_shipyard: bool = false
	var has_refinery: bool = false
	var has_trading_hub: bool = true
	var has_passenger_terminal: bool = true

	# Landing
	var landing_pads: int = 10
	var occupied_pads: int = 0
	var landing_fee: float = 100.0
	var docked_ships: Array[String] = []

	# Passengers
	var passenger_demand: int = 100  # How many passengers want to leave
	var passenger_arrivals: int = 50  # How many passengers arrive

	# Defenses
	var defense_rating: float = 5.0  # 0-10, affects security
	var has_military_base: bool = false

	func _init(id: String, name: String, type: PlanetType, sys_id: String = ""):
		planet_id = id
		planet_name = name
		planet_type = type
		system_id = sys_id

		# Set defaults based on type
		setup_planet_type()

	func setup_planet_type():
		"""Configure planet based on type"""
		match planet_type:
			PlanetType.TERRESTRIAL:
				planet_class = PlanetClass.CLASS_M
				population = randi_range(1000000, 10000000)
				development_level = randi_range(6, 10)
				radius = randf_range(400, 600)
				has_passenger_terminal = true
				passenger_demand = randi_range(100, 500)

			PlanetType.OCEANIC:
				planet_class = PlanetClass.CLASS_M
				population = randi_range(500000, 5000000)
				development_level = randi_range(5, 8)
				radius = randf_range(450, 550)
				primary_export = "water"

			PlanetType.DESERT:
				planet_class = PlanetClass.CLASS_H
				population = randi_range(100000, 1000000)
				development_level = randi_range(3, 6)
				radius = randf_range(350, 500)
				primary_import = "water"

			PlanetType.ICE:
				planet_class = PlanetClass.CLASS_L
				population = randi_range(10000, 500000)
				development_level = randi_range(2, 5)
				radius = randf_range(300, 450)
				primary_export = "ice"

			PlanetType.VOLCANIC:
				planet_class = PlanetClass.CLASS_K
				population = randi_range(5000, 100000)
				development_level = randi_range(3, 6)
				radius = randf_range(300, 450)
				primary_export = "rare_minerals"
				has_refinery = true

			PlanetType.GAS_GIANT:
				planet_class = PlanetClass.CLASS_J
				population = 0  # Only orbital stations
				development_level = 0
				radius = randf_range(800, 1200)
				has_spaceport = false  # Only orbital stations

			PlanetType.BARREN:
				planet_class = PlanetClass.CLASS_D
				population = randi_range(0, 50000)
				development_level = randi_range(1, 3)
				radius = randf_range(200, 400)
				primary_export = "minerals"

			PlanetType.TOXIC:
				planet_class = PlanetClass.CLASS_K
				population = randi_range(0, 10000)
				development_level = randi_range(1, 4)
				radius = randf_range(300, 500)
				primary_export = "chemicals"

	func can_land() -> bool:
		"""Check if landing is possible"""
		return has_spaceport and occupied_pads < landing_pads

	func land_ship(ship_id: String) -> bool:
		"""Land a ship on planet"""
		if not can_land():
			return false

		docked_ships.append(ship_id)
		occupied_pads += 1
		return true

	func depart_ship(ship_id: String):
		"""Ship departs from planet"""
		if docked_ships.has(ship_id):
			docked_ships.erase(ship_id)
			occupied_pads = max(0, occupied_pads - 1)

	func update_orbit(delta: float):
		"""Update orbital position"""
		var angle = orbit_speed * delta
		position = position.rotated(angle)

	func get_info() -> Dictionary:
		return {
			"planet_id": planet_id,
			"name": planet_name,
			"type": PlanetType.keys()[planet_type],
			"class": PlanetClass.keys()[planet_class],
			"system": system_id,
			"population": population,
			"development": development_level,
			"faction": owning_faction,
			"government": GovernmentType.keys()[government_type],
			"landing_pads": landing_pads,
			"occupied_pads": occupied_pads,
			"landing_fee": landing_fee,
			"services": {
				"spaceport": has_spaceport,
				"shipyard": has_shipyard,
				"refinery": has_refinery,
				"trading": has_trading_hub,
				"passengers": has_passenger_terminal
			}
		}

# ============================================================================
# PLANET DATABASE
# ============================================================================

var planets: Dictionary = {}  # planet_id -> Planet
var planets_by_system: Dictionary = {}  # system_id -> Array[planet_id]
var planets_by_faction: Dictionary = {}  # faction_id -> Array[planet_id]

# Orchestrator reference
var orchestrator: Node = null
var security_system: Node = null

# ============================================================================
# INITIALIZATION
# ============================================================================

func _ready():
	print("🌍 Planet System initialized")

	# Get SecurityLevelSystem reference
	await get_tree().process_frame
	if has_node("/root/SecurityLevelSystem"):
		security_system = get_node("/root/SecurityLevelSystem")

func set_orchestrator(orch: Node):
	orchestrator = orch

# ============================================================================
# PLANET CREATION
# ============================================================================

func create_planet(id: String, name: String, type: PlanetType, system_id: String, faction: String = "neutral") -> Planet:
	"""Create a new planet"""
	var planet = Planet.new(id, name, type, system_id)
	planet.owning_faction = faction

	# Set position in system
	if security_system and security_system.star_systems.has(system_id):
		var system = security_system.star_systems.get(system_id)
		if system:
			planet.position = system.position + Vector2(planet.orbit_radius, 0).rotated(randf() * TAU)
		else:
			planet.position = Vector2(randf_range(-10000, 10000), randf_range(-10000, 10000))
	else:
		planet.position = Vector2(randf_range(-10000, 10000), randf_range(-10000, 10000))

	# Set government based on faction
	planet.government_type = get_government_type_for_faction(faction)

	# Add to databases
	planets[id] = planet

	if not planets_by_system.has(system_id):
		planets_by_system[system_id] = []
	planets_by_system[system_id].append(id)

	if not planets_by_faction.has(faction):
		planets_by_faction[faction] = []
	planets_by_faction[faction].append(id)

	# Register with security system
	if security_system and security_system.star_systems.has(system_id):
		var system = security_system.star_systems.get(system_id)
		if system:
			system.planet_ids.append(id)

	emit_signal("planet_created", id)

	print("🌍 Created planet: %s in system %s" % [name, system_id])

	return planet

func get_government_type_for_faction(faction_id: String) -> GovernmentType:
	"""Determine government type based on faction"""
	match faction_id:
		"military": return GovernmentType.MILITARY
		"merchants": return GovernmentType.CORPORATE
		"pirates": return GovernmentType.ANARCHIST
		"neutral": return GovernmentType.INDEPENDENT
		_: return GovernmentType.DEMOCRACY

func generate_planets_for_system(system_id: String):
	"""Generate planets for a star system"""
	if not security_system or not security_system.star_systems.has(system_id):
		return

	var system = security_system.star_systems.get(system_id)
	if not system:
		return

	var planet_count = randi_range(2, 6)

	for i in range(planet_count):
		var planet_type = get_random_planet_type()
		var planet_name = "%s %s" % [system.system_name, romanize(i + 1)]
		var planet_id = "%s_planet_%d" % [system_id, i + 1]

		create_planet(planet_id, planet_name, planet_type, system_id, system.owning_faction)

func get_random_planet_type() -> PlanetType:
	"""Get random planet type weighted by distribution"""
	var roll = randf()

	if roll < 0.15: return PlanetType.TERRESTRIAL
	elif roll < 0.25: return PlanetType.OCEANIC
	elif roll < 0.35: return PlanetType.DESERT
	elif roll < 0.45: return PlanetType.ICE
	elif roll < 0.55: return PlanetType.VOLCANIC
	elif roll < 0.65: return PlanetType.GAS_GIANT
	elif roll < 0.85: return PlanetType.BARREN
	else: return PlanetType.TOXIC

func romanize(num: int) -> String:
	"""Convert number to Roman numerals"""
	var roman = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]
	if num > 0 and num <= roman.size():
		return roman[num - 1]
	return str(num)

func generate_all_planets():
	"""Generate planets for all systems"""
	if not security_system:
		return

	for system_id in security_system.star_systems:
		generate_planets_for_system(system_id)

	print("✅ Generated planets for %d systems" % security_system.star_systems.size())

# ============================================================================
# LANDING & DOCKING
# ============================================================================

func request_landing(ship_id: String, planet_id: String) -> Dictionary:
	"""Request landing clearance"""
	var planet = planets.get(planet_id, null)

	if not planet:
		return {"success": false, "reason": "Planet not found"}

	if not planet.can_land():
		return {"success": false, "reason": "No landing pads available"}

	# Check faction relations
	# TODO: Check if player is hostile to planet faction

	# Land ship
	if planet.land_ship(ship_id):
		emit_signal("ship_landed", ship_id, planet_id)
		return {
			"success": true,
			"landing_fee": planet.landing_fee,
			"pad_number": planet.occupied_pads
		}
	else:
		return {"success": false, "reason": "Landing failed"}

func depart_planet(ship_id: String, planet_id: String):
	"""Ship departs from planet"""
	var planet = planets.get(planet_id, null)

	if planet:
		planet.depart_ship(ship_id)
		emit_signal("ship_departed", ship_id, planet_id)

# ============================================================================
# PLANET UPDATES
# ============================================================================

func _orchestrated_update(delta: float):
	"""Fast planet updates"""
	# Update orbits (visual only)
	for planet_id in planets:
		var planet = planets[planet_id]
		planet.update_orbit(delta)

func _world_tick(tick: int):
	"""Slow planet updates"""
	# Economic updates, passenger generation, etc.
	for planet_id in planets:
		var planet = planets[planet_id]

		# Generate passenger demand
		if planet.has_passenger_terminal:
			planet.passenger_demand = int(planet.population * 0.0001)  # 0.01% of population travels

# ============================================================================
# FACTION & OWNERSHIP
# ============================================================================

func change_planet_ownership(planet_id: String, new_faction: String):
	"""Change planet ownership (conquest, diplomacy, etc.)"""
	var planet = planets.get(planet_id, null)

	if not planet:
		return

	var old_faction = planet.owning_faction

	# Update faction indices
	if planets_by_faction.has(old_faction):
		planets_by_faction[old_faction].erase(planet_id)

	if not planets_by_faction.has(new_faction):
		planets_by_faction[new_faction] = []
	planets_by_faction[new_faction].append(planet_id)

	# Update planet
	planet.owning_faction = new_faction
	planet.government_type = get_government_type_for_faction(new_faction)

	emit_signal("planet_ownership_changed", planet_id, new_faction)

	print("⚔️  Planet %s captured by %s" % [planet.planet_name, new_faction])

# ============================================================================
# QUERIES
# ============================================================================

func get_planet(planet_id: String) -> Planet:
	return planets.get(planet_id, null)

func get_planets_in_system(system_id: String) -> Array:
	return planets_by_system.get(system_id, [])

func get_planets_by_faction(faction_id: String) -> Array:
	return planets_by_faction.get(faction_id, [])

func get_nearest_planet(position: Vector2) -> Planet:
	"""Find nearest planet to position"""
	var nearest: Planet = null
	var nearest_distance = INF

	for planet_id in planets:
		var planet = planets[planet_id]
		var distance = position.distance_to(planet.position)

		if distance < nearest_distance:
			nearest = planet
			nearest_distance = distance

	return nearest

func get_habitable_planets() -> Array:
	"""Get all habitable planets"""
	var habitable = []

	for planet_id in planets:
		var planet = planets[planet_id]
		if planet.planet_type in [PlanetType.TERRESTRIAL, PlanetType.OCEANIC]:
			habitable.append(planet_id)

	return habitable

# ============================================================================
# SAVE/LOAD
# ============================================================================

func get_save_data() -> Dictionary:
	var planets_data = {}

	for planet_id in planets:
		var planet = planets[planet_id]
		planets_data[planet_id] = {
			"name": planet.planet_name,
			"type": planet.planet_type,
			"system": planet.system_id,
			"position": {"x": planet.position.x, "y": planet.position.y},
			"faction": planet.owning_faction,
			"government": planet.government_type,
			"population": planet.population,
			"docked_ships": planet.docked_ships
		}

	return {"planets": planets_data}

func load_save_data(data: Dictionary):
	planets.clear()
	planets_by_system.clear()
	planets_by_faction.clear()

	if data.has("planets"):
		for planet_id in data["planets"]:
			var p_data = data["planets"][planet_id]
			var planet = Planet.new(planet_id, p_data["name"], p_data["type"], p_data["system"])
			planet.position = Vector2(p_data["position"]["x"], p_data["position"]["y"])
			planet.owning_faction = p_data["faction"]
			planet.government_type = p_data["government"]
			planet.population = p_data["population"]
			planet.docked_ships = p_data.get("docked_ships", [])

			planets[planet_id] = planet
