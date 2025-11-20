extends Node
## Black Hole Mechanics + Ship Personality

signal blackhole_entered(ship_id: String, blackhole_id: String)
signal time_dilation_active(ship_id: String, dilation_factor: float)
signal spaghettification_danger(ship_id: String, distance: float)
signal ship_personality_evolved(ship_id: String, trait: String)

var blackholes: Dictionary = {}  # blackhole_id -> BlackHoleData
var ship_personalities: Dictionary = {}  # ship_id -> PersonalityData

class BlackHoleData:
	var blackhole_id: String
	var position: Vector2
	var event_horizon_radius: float = 500.0
	var accretion_disk_radius: float = 2000.0
	var time_dilation_max: float = 0.5  # Time passes 50% slower

	func _init(p_id: String, p_pos: Vector2):
		blackhole_id = p_id
		position = p_pos

class ShipPersonalityData:
	var ship_id: String
	var traits: Dictionary = {}  # "brave": 0.5, "cautious": 0.3, etc.
	var relationship_with_player: float = 50.0
	var quirks: Array = []

	func _init(p_id: String):
		ship_id = p_id
		traits = {"brave": randf(), "loyal": randf(), "sarcastic": randf()}

func create_blackhole(blackhole_id: String, position: Vector2):
	var bh = BlackHoleData.new(blackhole_id, position)
	blackholes[blackhole_id] = bh
	print("🕳️ Black hole created: %s at %s" % [blackhole_id, position])

func calculate_time_dilation(ship_pos: Vector2, blackhole_id: String) -> float:
	if not blackholes.has(blackhole_id):
		return 1.0

	var bh = blackholes[blackhole_id]
	var distance = ship_pos.distance_to(bh.position)

	if distance < bh.event_horizon_radius:
		return 0.0  # Spaghettified

	var dilation = 1.0 - ((bh.event_horizon_radius / distance) * bh.time_dilation_max)
	return clamp(dilation, 0.1, 1.0)

func check_spaghettification(ship_id: String, distance: float):
	"""Too close = ship destroyed"""
	if distance < 100.0:
		spaghettification_danger.emit(ship_id, distance)
		print("💀 Spaghettification warning: %s at %.1fm" % [ship_id, distance])

func evolve_ship_personality(ship_id: String, experience: String):
	"""Ship develops personality based on player actions"""
	if not ship_personalities.has(ship_id):
		ship_personalities[ship_id] = ShipPersonalityData.new(ship_id)

	var personality = ship_personalities[ship_id]

	match experience:
		"combat_won":
			personality.traits["brave"] = min(1.0, personality.traits.get("brave", 0.5) + 0.1)
		"retreated":
			personality.traits["cautious"] = min(1.0, personality.traits.get("cautious", 0.5) + 0.1)

	ship_personality_evolved.emit(ship_id, experience)

func _ready():
	print("🕳️ BlackHoleSystem: Ready")
