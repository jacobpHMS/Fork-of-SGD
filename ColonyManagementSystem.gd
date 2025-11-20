extends Node
## Colony Management + Terraforming

signal colony_established(colony_id: String, planet_id: String)
signal population_grew(colony_id: String, population: int)
signal terraforming_started(planet_id: String, phase: int)
signal orbital_bombardment(planet_id: String, attacker_id: String)

var colonies: Dictionary = {}  # colony_id -> ColonyData

class ColonyData:
	var colony_id: String
	var planet_id: String
	var owner_id: String
	var population: int = 1000
	var happiness: float = 50.0
	var defense_level: int = 0
	var terraforming_phase: int = 0  # 0-4

	func _init(p_id: String, p_planet: String, p_owner: String):
		colony_id = p_id
		planet_id = p_planet
		owner_id = p_owner

func establish_colony(planet_id: String, owner_id: String) -> String:
	var colony_id = "COL_%s" % planet_id
	var colony = ColonyData.new(colony_id, planet_id, owner_id)
	colonies[colony_id] = colony
	colony_established.emit(colony_id, planet_id)
	print("🌍 Colony established: %s on %s" % [colony_id, planet_id])
	return colony_id

func start_terraforming(planet_id: String, phase: int):
	"""Transform barren → terrestrial (4 phases: Atmosphere, Water, Life, Optimization)"""
	terraforming_started.emit(planet_id, phase)
	print("🌱 Terraforming %s: Phase %d/4" % [planet_id, phase])

func simulate_population_growth(colony_id: String):
	if not colonies.has(colony_id):
		return

	var colony = colonies[colony_id]
	var growth_rate = 0.01 * colony.happiness / 50.0
	colony.population = int(colony.population * (1.0 + growth_rate))
	population_grew.emit(colony_id, colony.population)

func bombard_from_orbit(planet_id: String, attacker_id: String):
	"""Orbital bombardment attack"""
	orbital_bombardment.emit(planet_id, attacker_id)
	# TODO: Reduce colony population/structures
	print("💥 Orbital bombardment: %s attacking %s" % [attacker_id, planet_id])

func _ready():
	print("🌍 ColonyManagementSystem: Ready")
