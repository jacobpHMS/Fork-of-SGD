extends Node
## Extended Passenger System - VIP Escorts, Groups, Events

signal vip_mission_accepted(mission_id: String)
signal passenger_group_boarded(group_id: String, size: int)
signal refugee_event_triggered(event_id: String, location: String)

enum PassengerType { STANDARD, VIP, GROUP, REFUGEE, LUXURY }

var luxury_liner_ships = ["SHIP_LUXURY_LINER_I", "SHIP_LUXURY_LINER_II"]
var passenger_reputation: Dictionary = {}  # player_id -> reputation_level

func create_vip_escort_mission(destination: String, threat_level: int) -> Dictionary:
	return {
		"type": PassengerType.VIP,
		"destination": destination,
		"threat_level": threat_level,
		"reward_multiplier": 2.0 + threat_level * 0.5,
		"requires_security": true
	}

func create_passenger_group(size: int, group_type: String) -> Dictionary:
	return {
		"type": PassengerType.GROUP,
		"size": size,
		"group_type": group_type,  # "family", "delegation", "tourists"
		"cabin_requirements": ceil(size / 4.0)
	}

func trigger_refugee_event(system_id: String, count: int):
	"""War refugees need emergency transport"""
	refugee_event_triggered.emit("REF_" + system_id, system_id)
	print("🆘 Refugee event: %d passengers need transport from %s" % [count, system_id])

func increase_reputation(player_id: String, amount: float):
	passenger_reputation[player_id] = passenger_reputation.get(player_id, 0.0) + amount

func _ready():
	print("✈️ ExtendedPassengerSystem: Ready")
