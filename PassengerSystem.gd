extends Node

# ============================================================================
# PASSENGER TRANSPORT SYSTEM
# ============================================================================
# Manages passenger transport (Tourists, Workers, VIPs, Travelers, Public Transport)
# Passengers have needs, pay for transport, affect reputation

signal passenger_boarded(passenger_id: String, ship_id: String)
signal passenger_delivered(passenger_id: String, destination: String, payment: float)
signal passenger_died(passenger_id: String, ship_id: String)
signal passenger_unhappy(passenger_id: String, reason: String)

# Passenger Types
enum PassengerType {
	TOURIST,          # Sightseeing, low pay, flexible
	WORKER,           # Commuters, regular schedules, medium pay
	VIP,              # High-value, demanding, high pay
	TRAVELER,         # Long-distance, medium pay, patient
	PUBLIC_TRANSPORT  # Mass transit, low pay per person, high volume
}

# Passenger Status
enum PassengerStatus {
	WAITING,       # Waiting at station
	BOARDED,       # On ship
	IN_TRANSIT,    # Traveling
	DELIVERED,     # Successfully delivered
	DIED,          # Died in transit (combat, accidents)
	ABANDONED      # Left behind / missed transport
}

# Passenger Class
class Passenger:
	var passenger_id: String = ""
	var passenger_name: String = ""
	var passenger_type: PassengerType = PassengerType.TOURIST
	var status: PassengerStatus = PassengerStatus.WAITING

	# Location
	var current_location: String = ""  # station_id or ship_id
	var origin: String = ""
	var destination: String = ""
	var destination_type: String = ""  # "station" or "planet"

	# Stats
	var comfort_level: float = 100.0  # 0-100, affects happiness
	var patience: float = 100.0       # Decreases while waiting
	var credits: float = 1000.0       # Payment amount

	# Requirements
	var required_cabin_class: int = 1  # 1=Economy, 2=Business, 3=First Class
	var required_amenities: Array[String] = []  # ["meals", "entertainment", "privacy"]
	var max_travel_time: float = 3600.0  # Max seconds in transit

	# Timing
	var boarding_time: float = 0.0
	var arrival_deadline: float = 0.0  # Must arrive before this (0 = no deadline)

	# Faction/Reputation
	var faction_id: String = "neutral"
	var reputation_value: int = 5  # Reputation gain on successful delivery

	func _init(id: String, type: PassengerType, origin_id: String, dest_id: String):
		passenger_id = id
		passenger_type = type
		origin = origin_id
		destination = dest_id
		current_location = origin_id

		# Generate name
		passenger_name = generate_name(type)

		# Set type-specific attributes
		setup_passenger_type()

	func setup_passenger_type():
		"""Configure passenger based on type"""
		match passenger_type:
			PassengerType.TOURIST:
				credits = randf_range(500, 2000)
				patience = randf_range(80, 100)
				required_cabin_class = 1  # Economy OK
				required_amenities = ["entertainment"]
				max_travel_time = 7200.0  # 2 hours
				reputation_value = 2

			PassengerType.WORKER:
				credits = randf_range(200, 800)
				patience = randf_range(50, 80)
				required_cabin_class = 1  # Just needs to get there
				required_amenities = []
				max_travel_time = 1800.0  # 30 minutes (commute)
				reputation_value = 3
				arrival_deadline = Time.get_ticks_msec() / 1000.0 + max_travel_time

			PassengerType.VIP:
				credits = randf_range(10000, 50000)
				patience = randf_range(20, 50)  # VERY impatient
				required_cabin_class = 3  # First Class ONLY
				required_amenities = ["meals", "entertainment", "privacy", "luxury"]
				max_travel_time = 3600.0
				reputation_value = 20  # HUGE reputation impact

			PassengerType.TRAVELER:
				credits = randf_range(1000, 5000)
				patience = randf_range(90, 100)  # Very patient
				required_cabin_class = 2  # Business class
				required_amenities = ["meals", "entertainment"]
				max_travel_time = 14400.0  # 4 hours
				reputation_value = 5

			PassengerType.PUBLIC_TRANSPORT:
				credits = randf_range(50, 200)  # Low pay per person
				patience = randf_range(60, 90)
				required_cabin_class = 1
				required_amenities = []
				max_travel_time = 1800.0
				reputation_value = 1

	func generate_name(type: PassengerType) -> String:
		"""Generate passenger name based on type"""
		var first_names = ["John", "Jane", "Robert", "Mary", "Michael", "Sarah", "David", "Lisa", "James", "Emily"]
		var last_names = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez"]

		var name = "%s %s" % [first_names.pick_random(), last_names.pick_random()]

		match type:
			PassengerType.VIP:
				var titles = ["Dr.", "Prof.", "Ambassador", "Senator", "Admiral", "CEO"]
				name = "%s %s" % [titles.pick_random(), name]
			PassengerType.PUBLIC_TRANSPORT:
				return "Passenger Group (%d)" % randi_range(10, 50)

		return name

	func board_ship(ship_id: String):
		"""Board a ship"""
		current_location = ship_id
		status = PassengerStatus.BOARDED
		boarding_time = Time.get_ticks_msec() / 1000.0

	func update_comfort(delta: float, cabin_quality: float, has_amenities: bool):
		"""Update passenger comfort level"""
		var comfort_change = 0.0

		# Cabin quality affects comfort
		var quality_diff = cabin_quality - required_cabin_class
		if quality_diff < 0:
			comfort_change -= 5.0 * delta  # Poor cabin = unhappy
		else:
			comfort_change += 1.0 * delta  # Good cabin = happy

		# Amenities affect comfort
		if not has_amenities and required_amenities.size() > 0:
			comfort_change -= 3.0 * delta

		# VIPs lose comfort faster
		if passenger_type == PassengerType.VIP:
			comfort_change -= 2.0 * delta

		comfort_level = clamp(comfort_level + comfort_change, 0, 100)

	func update_patience(delta: float):
		"""Update patience while waiting"""
		if status == PassengerStatus.WAITING:
			patience -= 2.0 * delta  # Lose patience while waiting

			# VIPs lose patience MUCH faster
			if passenger_type == PassengerType.VIP:
				patience -= 5.0 * delta

	func is_happy() -> bool:
		return comfort_level > 50 and patience > 30

	func get_payment_amount() -> float:
		"""Calculate final payment based on service quality"""
		var payment = credits

		# Bonus for good service
		if comfort_level > 80:
			payment *= 1.2
		elif comfort_level < 30:
			payment *= 0.5  # Refund for bad service

		# Bonus for on-time delivery
		if arrival_deadline > 0:
			var current_time = Time.get_ticks_msec() / 1000.0
			if current_time < arrival_deadline:
				payment *= 1.5  # 50% bonus for on-time

		return payment

	func get_info() -> Dictionary:
		return {
			"passenger_id": passenger_id,
			"name": passenger_name,
			"type": PassengerType.keys()[passenger_type],
			"status": PassengerStatus.keys()[status],
			"origin": origin,
			"destination": destination,
			"comfort": comfort_level,
			"patience": patience,
			"credits": credits,
			"cabin_class": required_cabin_class,
			"amenities": required_amenities
		}

# ============================================================================
# PASSENGER DATABASE
# ============================================================================

var passengers: Dictionary = {}  # passenger_id -> Passenger
var passengers_by_location: Dictionary = {}  # location_id -> Array[passenger_id]
var waiting_passengers: Array[String] = []  # Passengers waiting at stations
var in_transit_passengers: Array[String] = []  # Passengers on ships

# Ship passenger capacity tracking
var ship_passengers: Dictionary = {}  # ship_id -> {capacity, current_count, cabin_class}

# Orchestrator reference
var orchestrator: Node = null

# Settings
var auto_generate_passengers: bool = true
var passenger_generation_interval: float = 30.0  # Generate every 30 seconds
var passenger_generation_timer: float = 0.0

# ============================================================================
# INITIALIZATION
# ============================================================================

func _ready():
	print("🚢 Passenger System initialized")

func set_orchestrator(orch: Node):
	orchestrator = orch

# ============================================================================
# PASSENGER SPAWNING
# ============================================================================

func generate_passenger(type: PassengerType, origin: String, destination: String) -> String:
	"""Generate a new passenger"""
	var passenger_id = "passenger_%s_%d" % [PassengerType.keys()[type].to_lower(), Time.get_ticks_msec()]

	var passenger = Passenger.new(passenger_id, type, origin, destination)

	# Add to database
	passengers[passenger_id] = passenger
	waiting_passengers.append(passenger_id)

	# Add to location index
	if not passengers_by_location.has(origin):
		passengers_by_location[origin] = []
	passengers_by_location[origin].append(passenger_id)

	print("🚶 Generated passenger: %s (%s -> %s)" % [passenger.passenger_name, origin, destination])

	return passenger_id

func generate_random_passengers(count: int = 5):
	"""Generate random passengers at stations"""
	# This would need StationSystem and PlanetSystem integration
	# For now, generate with placeholder locations
	for i in range(count):
		var type = get_random_passenger_type()
		var origin = "station_%d" % randi_range(1, 5)
		var destination = "station_%d" % randi_range(1, 5)

		if origin != destination:
			generate_passenger(type, origin, destination)

func get_random_passenger_type() -> PassengerType:
	"""Get random passenger type weighted by distribution"""
	var roll = randf()

	if roll < 0.15: return PassengerType.VIP
	elif roll < 0.35: return PassengerType.WORKER
	elif roll < 0.60: return PassengerType.TOURIST
	elif roll < 0.80: return PassengerType.TRAVELER
	else: return PassengerType.PUBLIC_TRANSPORT

# ============================================================================
# PASSENGER BOARDING & TRANSPORT
# ============================================================================

func board_passengers(ship_id: String, station_id: String, max_count: int = -1) -> Array[String]:
	"""Board waiting passengers at station onto ship"""
	var boarded: Array[String] = []

	if not passengers_by_location.has(station_id):
		return boarded

	var waiting = passengers_by_location[station_id].duplicate()
	var ship_capacity = get_ship_passenger_capacity(ship_id)
	var current_passengers = get_ship_passenger_count(ship_id)

	for passenger_id in waiting:
		if max_count > 0 and boarded.size() >= max_count:
			break

		if current_passengers >= ship_capacity:
			break

		var passenger = passengers.get(passenger_id)
		if not passenger:
			continue

		# Check if ship meets requirements
		if not ship_meets_requirements(ship_id, passenger):
			continue

		# Board passenger
		passenger.board_ship(ship_id)
		boarded.append(passenger_id)
		current_passengers += 1

		# Update tracking
		waiting_passengers.erase(passenger_id)
		in_transit_passengers.append(passenger_id)
		passengers_by_location[station_id].erase(passenger_id)

		if not ship_passengers.has(ship_id):
			ship_passengers[ship_id] = []
		ship_passengers[ship_id].append(passenger_id)

		emit_signal("passenger_boarded", passenger_id, ship_id)

	print("✅ Boarded %d passengers on ship %s" % [boarded.size(), ship_id])

	return boarded

func deliver_passengers(ship_id: String, location_id: String) -> Array[String]:
	"""Deliver passengers at their destination"""
	var delivered: Array[String] = []

	if not ship_passengers.has(ship_id):
		return delivered

	var passengers_on_ship = ship_passengers[ship_id].duplicate()

	for passenger_id in passengers_on_ship:
		var passenger = passengers.get(passenger_id)
		if not passenger:
			continue

		# Check if this is their destination
		if passenger.destination == location_id:
			# Calculate payment
			var payment = passenger.get_payment_amount()

			# Update status
			passenger.status = PassengerStatus.DELIVERED
			passenger.current_location = location_id

			# Remove from ship
			ship_passengers[ship_id].erase(passenger_id)
			in_transit_passengers.erase(passenger_id)

			delivered.append(passenger_id)

			emit_signal("passenger_delivered", passenger_id, location_id, payment)

			# Award reputation if passenger was happy
			if passenger.is_happy():
				# TODO: Award reputation to player/faction
				pass

			print("✅ Delivered passenger %s (Payment: %.0f cr)" % [passenger.passenger_name, payment])

	return delivered

func ship_meets_requirements(ship_id: String, passenger: Passenger) -> bool:
	"""Check if ship meets passenger requirements"""
	# TODO: Check ship's cabin class, amenities, etc.
	# For now, always return true
	return true

func get_ship_passenger_capacity(ship_id: String) -> int:
	"""Get passenger capacity of ship"""
	# TODO: Query ship stats
	# For now, return default
	return 10

func get_ship_passenger_count(ship_id: String) -> int:
	"""Get current passenger count on ship"""
	if not ship_passengers.has(ship_id):
		return 0
	return ship_passengers[ship_id].size()

# ============================================================================
# PASSENGER UPDATES
# ============================================================================

func _orchestrated_update(delta: float):
	"""Update passengers (called by orchestrator)"""

	# Update waiting passengers
	for passenger_id in waiting_passengers:
		if passengers.has(passenger_id):
			var passenger = passengers[passenger_id]
			passenger.update_patience(delta)

			# Abandon if patience runs out
			if passenger.patience <= 0:
				passenger.status = PassengerStatus.ABANDONED
				waiting_passengers.erase(passenger_id)
				print("❌ Passenger %s abandoned (no patience)" % passenger.passenger_name)

	# Update in-transit passengers
	for passenger_id in in_transit_passengers:
		if passengers.has(passenger_id):
			var passenger = passengers[passenger_id]

			# Update comfort (simplified - would need ship data)
			passenger.update_comfort(delta, 2.0, true)

			# Check if unhappy
			if not passenger.is_happy():
				emit_signal("passenger_unhappy", passenger_id, "Low comfort/patience")

	# Auto-generate passengers
	if auto_generate_passengers:
		passenger_generation_timer += delta
		if passenger_generation_timer >= passenger_generation_interval:
			passenger_generation_timer = 0.0
			generate_random_passengers(3)

func _world_tick(tick: int):
	"""Slow passenger updates"""
	pass

# ============================================================================
# QUERIES
# ============================================================================

func get_passenger(passenger_id: String) -> Passenger:
	return passengers.get(passenger_id, null)

func get_passengers_at_location(location_id: String) -> Array:
	return passengers_by_location.get(location_id, [])

func get_passengers_on_ship(ship_id: String) -> Array:
	return ship_passengers.get(ship_id, [])

func get_waiting_passenger_count() -> int:
	return waiting_passengers.size()

func get_in_transit_count() -> int:
	return in_transit_passengers.size()

# ============================================================================
# SAVE/LOAD
# ============================================================================

func get_save_data() -> Dictionary:
	var passengers_data = {}

	for passenger_id in passengers:
		var passenger = passengers[passenger_id]
		passengers_data[passenger_id] = {
			"name": passenger.passenger_name,
			"type": passenger.passenger_type,
			"status": passenger.status,
			"origin": passenger.origin,
			"destination": passenger.destination,
			"comfort": passenger.comfort_level,
			"patience": passenger.patience,
			"location": passenger.current_location
		}

	return {
		"passengers": passengers_data,
		"ship_passengers": ship_passengers
	}

func load_save_data(data: Dictionary):
	passengers.clear()
	waiting_passengers.clear()
	in_transit_passengers.clear()
	passengers_by_location.clear()

	if data.has("passengers"):
		for passenger_id in data["passengers"]:
			var p_data = data["passengers"][passenger_id]
			var passenger = Passenger.new(passenger_id, p_data["type"], p_data["origin"], p_data["destination"])
			passenger.passenger_name = p_data["name"]
			passenger.status = p_data["status"]
			passenger.comfort_level = p_data["comfort"]
			passenger.patience = p_data["patience"]
			passenger.current_location = p_data["location"]

			passengers[passenger_id] = passenger

			if passenger.status == PassengerStatus.WAITING:
				waiting_passengers.append(passenger_id)
			elif passenger.status == PassengerStatus.IN_TRANSIT:
				in_transit_passengers.append(passenger_id)

	if data.has("ship_passengers"):
		ship_passengers = data["ship_passengers"]
