# res://scripts/base/BaseShip.gd
class_name BaseShip
extends CharacterBody2D

## Universal Base Ship Class
## Provides movement, autopilot, and basic ship functionality for ALL ship types
## Stats loaded from DatabaseManager ship database

# ============================================================================
# SHIP IDENTIFICATION
# ============================================================================

@export var ship_id: String = ""  ## Ship ID in database (e.g., "SHIP_001")
@export var ship_database_category: String = "SHIP"  ## Database category

# ============================================================================
# SHIP DATA (Loaded from Database or Provided)
# ============================================================================

var ship_data: Dictionary = {}  ## Ship stats loaded from database or set externally

# Default ship data structure (if not loaded from database)
var default_ship_data = {
	"name": "Unknown Ship",
	"mass": 25000.0,  # kg
	"max_thrust": 100000.0,  # Newton
	"turn_speed": 135.0,  # Degrees/second
	"max_speed": 200.0,  # m/s
	"shield": 1000.0,
	"armor": 500.0,
	"hull_integrity": 100.0,
	"fuel": 1000.0,
	"max_fuel": 1000.0,
}

# ============================================================================
# MOVEMENT PHYSICS (Calculated from ship_data)
# ============================================================================

var rotation_speed: float = 0.0  ## Radians per second (calculated from turn_speed)
var acceleration: float = 0.0  ## m/s² (calculated from thrust/mass)

var current_velocity: Vector2 = Vector2.ZERO  ## Current ship velocity
var deceleration_distance: float = 0.0  ## Distance needed to stop

# ============================================================================
# AUTOPILOT SYSTEM
# ============================================================================

enum AutopilotState { IDLE, ACCELERATING, CRUISING, DECELERATING, ARRIVED, ORBITING }

var autopilot_state: int = AutopilotState.IDLE
var target_position: Vector2 = Vector2.ZERO
var autopilot_enabled: bool = false

# ============================================================================
# ORBIT SYSTEM
# ============================================================================

var orbit_target: Node2D = null
var orbit_distance: float = 200.0
var orbit_speed: float = 50.0
var orbit_angle: float = 0.0
var orbit_indicator: Node2D = null  ## Visual orbit circle

# ============================================================================
# SIGNALS
# ============================================================================

signal autopilot_state_changed(new_state: int)
signal ship_arrived_at_destination
signal orbit_started(target: Node2D, distance: float)
signal orbit_stopped

# ============================================================================
# INITIALIZATION
# ============================================================================

func _ready():
	# Load ship data from database if ship_id is set
	if not ship_id.is_empty():
		load_ship_data_from_database()
	else:
		# Use default data
		ship_data = default_ship_data.duplicate(true)

	# Calculate physics values
	calculate_physics_values()

	# Setup collision
	set_collision_layer(1)
	set_collision_mask(1)

	print("BaseShip [%s] initialized: %s" % [ship_id, ship_data.get("name", "Unknown")])

func load_ship_data_from_database():
	"""Load ship stats from DatabaseManager"""
	if not ship_id.is_empty() and DatabaseManager:
		var db_item = DatabaseManager.get_item_by_id(ship_id)

		if not db_item.is_empty():
			# Merge database data with defaults
			ship_data = default_ship_data.duplicate(true)

			# Map database fields to ship_data
			ship_data["name"] = db_item.get("NAME", "Unknown Ship")
			ship_data["mass"] = db_item.get("MASS_KG", default_ship_data["mass"])
			ship_data["max_thrust"] = db_item.get("MAX_THRUST", default_ship_data["max_thrust"])
			ship_data["turn_speed"] = db_item.get("TURN_SPEED", default_ship_data["turn_speed"])
			ship_data["max_speed"] = db_item.get("MAX_SPEED", default_ship_data["max_speed"])
			ship_data["shield"] = db_item.get("SHIELD_HP", default_ship_data["shield"])
			ship_data["armor"] = db_item.get("ARMOR_HP", default_ship_data["armor"])
			ship_data["hull_integrity"] = 100.0
			ship_data["fuel"] = db_item.get("FUEL_CAPACITY", default_ship_data["max_fuel"])
			ship_data["max_fuel"] = db_item.get("FUEL_CAPACITY", default_ship_data["max_fuel"])

			print("Loaded ship data from database: %s" % ship_id)
		else:
			push_warning("Ship ID %s not found in database, using defaults" % ship_id)
			ship_data = default_ship_data.duplicate(true)
	else:
		ship_data = default_ship_data.duplicate(true)

func calculate_physics_values():
	"""Calculate physics values from ship_data"""
	rotation_speed = deg_to_rad(ship_data.get("turn_speed", 135.0))
	acceleration = ship_data.get("max_thrust", 100000.0) / ship_data.get("mass", 25000.0)

# ============================================================================
# PHYSICS PROCESSING
# ============================================================================

func _physics_process(delta):
	# Autopilot movement
	if autopilot_enabled and autopilot_state != AutopilotState.IDLE:
		autopilot_move(delta)
	else:
		# Passive drift/deceleration
		current_velocity *= 0.98

	# Apply velocity with collision bounce
	velocity = current_velocity
	var collision = move_and_collide(velocity * delta)

	# Bounce off collisions
	if collision:
		handle_collision(collision)

func handle_collision(collision: KinematicCollision2D):
	"""Handle collision with bounce physics"""
	var bounce_velocity = velocity.bounce(collision.get_normal())
	current_velocity = bounce_velocity * 0.6  # Energy loss on bounce

# ============================================================================
# AUTOPILOT MOVEMENT
# ============================================================================

func autopilot_move(delta):
	"""Execute autopilot movement logic"""
	var distance = global_position.distance_to(target_position)
	var direction = (target_position - global_position).normalized()

	# Calculate deceleration distance needed
	var current_speed = current_velocity.length()
	var decel_time = current_speed / acceleration
	deceleration_distance = current_speed * decel_time * 0.5

	# Rotate towards target (shortest path)
	var target_angle = direction.angle()
	var angle_diff = wrapf(target_angle - rotation, -PI, PI)

	if abs(angle_diff) > 0.05:
		var turn_amount = min(abs(angle_diff), rotation_speed * delta)
		rotation += sign(angle_diff) * turn_amount

	# State machine for autopilot
	match autopilot_state:
		AutopilotState.ACCELERATING:
			accelerate_towards_target(delta, distance)

		AutopilotState.DECELERATING:
			decelerate_to_target(delta, distance)

		AutopilotState.ARRIVED:
			hold_position()

		AutopilotState.ORBITING:
			orbit_around_target(delta)

func accelerate_towards_target(delta: float, distance: float):
	"""Accelerate towards target position"""
	var forward = Vector2(cos(rotation), sin(rotation))
	current_velocity += forward * acceleration * delta

	# Limit max speed
	if current_velocity.length() > ship_data["max_speed"]:
		current_velocity = current_velocity.normalized() * ship_data["max_speed"]

	# Switch to decelerating if near target
	if distance < deceleration_distance or distance < 100:
		set_autopilot_state(AutopilotState.DECELERATING)

func decelerate_to_target(delta: float, distance: float):
	"""Decelerate approaching target"""
	var decel_amount = acceleration * delta * 1.5
	current_velocity = current_velocity.move_toward(Vector2.ZERO, decel_amount)

	# Arrive at target
	if distance < 20 or current_velocity.length() < 5:
		set_autopilot_state(AutopilotState.ARRIVED)
		current_velocity = Vector2.ZERO
		ship_arrived_at_destination.emit()

func hold_position():
	"""Hold current position"""
	current_velocity = Vector2.ZERO

func orbit_around_target(delta: float):
	"""Orbit around target object"""
	if not is_instance_valid(orbit_target):
		# Target lost, stop orbiting
		stop_orbit()
		return

	# Update orbit angle
	orbit_angle += (orbit_speed / orbit_distance) * delta

	# Calculate desired position on orbit
	var target_pos = orbit_target.global_position
	var desired_pos = target_pos + Vector2(cos(orbit_angle), sin(orbit_angle)) * orbit_distance

	# Move towards desired position
	var to_desired = desired_pos - global_position
	var desired_velocity = to_desired.normalized() * orbit_speed

	# Smooth velocity change
	current_velocity = current_velocity.lerp(desired_velocity, delta * 2.0)

	# Face direction of movement
	if current_velocity.length() > 0.1:
		var desired_rotation = current_velocity.angle()
		rotation = lerp_angle(rotation, desired_rotation, delta * 3.0)

# ============================================================================
# AUTOPILOT COMMANDS
# ============================================================================

func fly_to(position: Vector2):
	"""Fly to specified position"""
	target_position = position
	autopilot_enabled = true
	set_autopilot_state(AutopilotState.ACCELERATING)

func hold():
	"""Hold current position"""
	autopilot_enabled = false
	set_autopilot_state(AutopilotState.IDLE)
	current_velocity = Vector2.ZERO

func start_orbit(target: Node2D, distance: float = 200.0, speed: float = 50.0):
	"""Start orbiting around target"""
	if not is_instance_valid(target):
		push_warning("Cannot orbit: Invalid target")
		return

	orbit_target = target
	orbit_distance = distance
	orbit_speed = speed

	# Calculate starting angle based on current position
	var to_target = orbit_target.global_position - global_position
	orbit_angle = to_target.angle()

	autopilot_enabled = true
	set_autopilot_state(AutopilotState.ORBITING)

	# Create visual orbit indicator
	create_orbit_indicator()

	orbit_started.emit(target, distance)

func stop_orbit():
	"""Stop orbiting"""
	autopilot_enabled = false
	set_autopilot_state(AutopilotState.IDLE)
	orbit_target = null

	# Remove orbit indicator
	if is_instance_valid(orbit_indicator):
		orbit_indicator.queue_free()
		orbit_indicator = null

	orbit_stopped.emit()

func create_orbit_indicator():
	"""Create visual orbit circle indicator"""
	# Remove old indicator
	if is_instance_valid(orbit_indicator):
		orbit_indicator.queue_free()

	if not is_instance_valid(orbit_target):
		return

	# Create new indicator as child of orbit target
	orbit_indicator = Node2D.new()
	orbit_indicator.name = "OrbitIndicator"
	orbit_target.add_child(orbit_indicator)

	# Draw orbit circle with Line2D
	var circle = Line2D.new()
	circle.width = 2.0
	circle.default_color = Color(0.2, 0.8, 1.0, 0.5)  # Cyan, semi-transparent

	# Create circle points
	var points = PackedVector2Array()
	var segments = 64
	for i in range(segments + 1):
		var angle = (i / float(segments)) * TAU
		var point = Vector2(cos(angle), sin(angle)) * orbit_distance
		points.append(point)

	circle.points = points
	orbit_indicator.add_child(circle)

	# Add distance label
	var label = Label.new()
	label.text = "Orbit: %.0fm" % orbit_distance
	label.position = Vector2(-40, -orbit_distance - 20)
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(0.2, 0.8, 1.0))
	orbit_indicator.add_child(label)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func set_autopilot_state(new_state: int):
	"""Change autopilot state and emit signal"""
	if autopilot_state != new_state:
		autopilot_state = new_state
		autopilot_state_changed.emit(new_state)

func get_autopilot_status_text() -> String:
	"""Get human-readable autopilot status"""
	match autopilot_state:
		AutopilotState.IDLE:
			return "Idle"
		AutopilotState.ACCELERATING:
			return "Accelerating"
		AutopilotState.CRUISING:
			return "Cruising"
		AutopilotState.DECELERATING:
			return "Decelerating"
		AutopilotState.ARRIVED:
			return "Arrived"
		AutopilotState.ORBITING:
			return "Orbiting"
		_:
			return "Unknown"

func get_current_speed() -> float:
	"""Get current ship speed in m/s"""
	return current_velocity.length()

func get_distance_to_target() -> float:
	"""Get distance to current autopilot target"""
	return global_position.distance_to(target_position)

# ============================================================================
# EXTERNAL INTERFACE
# ============================================================================

func set_ship_data(data: Dictionary):
	"""Set ship data externally (for custom ships or NPCs)"""
	ship_data = data.duplicate(true)
	calculate_physics_values()

func get_ship_data() -> Dictionary:
	"""Get current ship data"""
	return ship_data.duplicate(true)
