extends Node
## Social Hub - Walk in Stations, Player Housing

signal player_entered_station(player_id: String, station_id: String)
signal apartment_purchased(player_id: String, apartment_id: String)
signal emote_performed(player_id: String, emote_id: String)
signal killmail_generated(killmail_id: String, victim_id: String, attacker_id: String)

var player_apartments: Dictionary = {}  # player_id -> apartment_id
var killmail_database: Dictionary = {}  # killmail_id -> KillmailData

class KillmailData:
	var killmail_id: String
	var victim_id: String
	var victim_ship: String
	var attacker_id: String
	var attacker_ship: String
	var timestamp: float
	var location: String
	var isk_value: float

	func _init(p_id: String, p_victim: String, p_victim_ship: String, p_attacker: String, p_location: String):
		killmail_id = p_id
		victim_id = p_victim
		victim_ship = p_victim_ship
		attacker_id = p_attacker
		timestamp = Time.get_unix_time_from_system()
		location = p_location
		isk_value = 0.0

func enter_station_interior(player_id: String, station_id: String):
	"""Walk in Stations (WiS)"""
	player_entered_station.emit(player_id, station_id)
	print("🚪 %s entered station %s interior" % [player_id, station_id])

func purchase_apartment(player_id: String, station_id: String) -> String:
	var apartment_id = "APT_%s_%s" % [station_id, player_id]
	player_apartments[player_id] = apartment_id
	apartment_purchased.emit(player_id, apartment_id)
	print("🏠 Apartment purchased: %s → %s" % [player_id, apartment_id])
	return apartment_id

func perform_emote(player_id: String, emote_id: String):
	"""Social gestures: wave, salute, dance, etc."""
	emote_performed.emit(player_id, emote_id)

func generate_killmail(victim_id: String, victim_ship: String, attacker_id: String, location: String):
	var killmail_id = "KILL_%d" % Time.get_unix_time_from_system()
	var killmail = KillmailData.new(killmail_id, victim_id, victim_ship, attacker_id, location)
	killmail_database[killmail_id] = killmail
	killmail_generated.emit(killmail_id, victim_id, attacker_id)
	print("💀 Killmail: %s killed %s in %s" % [attacker_id, victim_id, location])

func _ready():
	print("🎭 SocialHubSystem: Ready")
