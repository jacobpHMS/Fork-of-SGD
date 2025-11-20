extends CharacterBody2D

# ============================================================================
# SIGNALS
# ============================================================================

# Mining signals
signal ore_mined(ore_name: String, amount: float, ore_id: String)

# Cargo signals
signal cargo_added(item_id: String, amount: float, cargo_type: int)
signal cargo_ejected(item_id: String, amount: float)
@warning_ignore("unused_signal")  # Emitted by CargoCrate when picked up
signal cargo_crate_picked_up(item_id: String, amount: float)

# Targeting signals
signal target_changed(new_target: Node2D)

# ============================================================================
# SHIP STATS
# ============================================================================

# Ship stats (Testdaten - später aus Datenbank)
var ship_data = {
	"name": "Test Mining Frigate",
	"mass": 50000.0,  # kg
	"max_thrust": 100000.0,  # Newton
	"turn_speed": 90.0,  # Grad/Sekunde
	"max_speed": 200.0,  # m/s
	"miner_slots": 2,
	"miner_range": 150.0,  # pixel/meter
	"miner_rate": 10.0,  # Einheiten/Sekunde
	"scanner_level": 1,  # 1-5 = Mk1-Mk5 Scanner
	"shield": 1000.0,
	"armor": 500.0,
	"hull_integrity": 100.0,
	"electronic_stability": 100.0,
	"fuel": 1000.0,
	"max_fuel": 1000.0,
	# Cargo capacities (m³) - Base ship stats
	"cargo_general_capacity": 500.0,
	"cargo_ore_capacity": 2000.0,
	"cargo_mineral_capacity": 800.0,
	"cargo_liquid_capacity": 1000.0,
	"cargo_gas_capacity": 1000.0,
	"cargo_ammo_capacity": 300.0,
	"cargo_build_capacity": 600.0,
	"cargo_components_capacity": 400.0,
	"cargo_hazmat_capacity": 100.0
}

# Autopilot system
enum AutopilotState { IDLE, ACCELERATING, CRUISING, DECELERATING, ARRIVED, ORBITING }
var autopilot_state = AutopilotState.IDLE
var target_position: Vector2 = Vector2.ZERO
var current_velocity: Vector2 = Vector2.ZERO
var rotation_speed: float = 0.0
var acceleration: float = 0.0
var deceleration_distance: float = 0.0

# Orbit system
var orbit_target: Node2D = null
var orbit_distance: float = 200.0
var orbit_speed: float = 50.0
var orbit_angle: float = 0.0

# Docking system
var docked_station: Node2D = null
var is_docked: bool = false

# Targeting system
var targeted_object: Node2D = null

# Mining
var miner_1_active: bool = false
var miner_2_active: bool = false
var mining_target: Node2D = null
var mining_range: float = 150.0
var auto_mining_mode: bool = false

# Mining Queue System
var mining_queue: Array[Node2D] = []  # Queue of asteroids to mine
var auto_queue_enabled: bool = true  # Auto-switch to next in queue

# Mining cycle system
var mining_cycle_time: float = 10.0  # Seconds per cycle
var mining_cycle_progress: float = 0.0  # Current progress (0.0 - 10.0)
var fuel_consumption_rate: float = 1.0  # Fuel per second while mining
var mining_locked: bool = false  # Lock miner for minimum duration

# Inventory - Separate cargo holds
enum CargoType { GENERAL, ORE, MINERAL, LIQUID, GAS, AMMO, BUILD, COMPONENTS, HAZMAT }

# Compression Module System
enum CompressionLevel { NONE, STANDARD, HIGH, EXTREME }
const COMPRESSION_VOLUME_REDUCTION = {
	CompressionLevel.NONE: 0.0,      # 0% reduction
	CompressionLevel.STANDARD: 0.30, # 30% reduction
	CompressionLevel.HIGH: 0.50,     # 50% reduction
	CompressionLevel.EXTREME: 0.70   # 70% reduction
}

# Stack System - Max stack sizes per item type
const MAX_STACK_SIZE = {
	"ore": -1,        # Infinite (stapelbar ohne Limit)
	"mineral": -1,    # Infinite
	"component": -1,  # Infinite
	"ammo": 100,      # Max 100 per stack
	"build": 100,     # Max 100 per stack
	"module": 1,      # Not stackable
	"ship": 1,        # Not stackable
	"default": 100    # Default for unknown types
}

func get_max_stack_size(item_id: String) -> int:
	"""Get maximum stack size for an item"""
	if item_id.begins_with("ore_"):
		return MAX_STACK_SIZE["ore"]
	elif item_id.begins_with("mineral_"):
		return MAX_STACK_SIZE["mineral"]
	elif item_id.begins_with("component_"):
		return MAX_STACK_SIZE["component"]
	elif item_id.begins_with("ammo_"):
		return MAX_STACK_SIZE["ammo"]
	elif item_id.begins_with("build_"):
		return MAX_STACK_SIZE["build"]
	elif item_id.begins_with("module_"):
		return MAX_STACK_SIZE["module"]
	elif item_id.begins_with("ship_"):
		return MAX_STACK_SIZE["ship"]
	else:
		return MAX_STACK_SIZE["default"]

var cargo_holds: Dictionary = {
	CargoType.GENERAL: {"items": {}, "used": 0.0, "compression": CompressionLevel.NONE},
	CargoType.ORE: {"items": {}, "used": 0.0, "compression": CompressionLevel.NONE},
	CargoType.MINERAL: {"items": {}, "used": 0.0, "compression": CompressionLevel.NONE},
	CargoType.LIQUID: {"items": {}, "used": 0.0, "compression": CompressionLevel.NONE},
	CargoType.GAS: {"items": {}, "used": 0.0, "compression": CompressionLevel.NONE},
	CargoType.AMMO: {"items": {}, "used": 0.0, "compression": CompressionLevel.NONE},
	CargoType.BUILD: {"items": {}, "used": 0.0, "compression": CompressionLevel.NONE},
	CargoType.COMPONENTS: {"items": {}, "used": 0.0, "compression": CompressionLevel.NONE},
	CargoType.HAZMAT: {"items": {}, "used": 0.0, "compression": CompressionLevel.NONE}
}

# Legacy compatibility (for old save files)
var cargo: Dictionary = {}
var cargo_used: float = 0.0

# Input handling
var click_timer: float = 0.0
var double_click_time: float = 0.3
var last_click_pos: Vector2 = Vector2.ZERO
var show_radial_menu: bool = false
var radial_menu_position: Vector2 = Vector2.ZERO

# References
@onready var sprite = $AnimatedSprite2D
@onready var laser1 = $MiningLaser1
@onready var laser2 = $MiningLaser2
@onready var collision_shape = $CollisionShape2D

# Systems
var temperature_system: Node = null

func _ready():
	rotation_speed = deg_to_rad(ship_data["turn_speed"])
	acceleration = ship_data["max_thrust"] / ship_data["mass"]
	mining_range = ship_data["miner_range"]

	# Set collision for bouncing
	set_collision_layer(1)
	set_collision_mask(1)

	# Initialize Temperature System
	temperature_system = Node.new()
	temperature_system.set_script(load("res://scripts/TemperatureSystem.gd"))
	add_child(temperature_system)

	# Connect temperature signals
	temperature_system.temperature_warning.connect(_on_temperature_warning)
	temperature_system.temperature_critical.connect(_on_temperature_critical)
	temperature_system.temperature_damage.connect(_on_temperature_damage)
	temperature_system.coolant_low.connect(_on_coolant_low)
	temperature_system.coolant_depleted.connect(_on_coolant_depleted)

func _process(delta):
	# Double click timer
	if click_timer > 0:
		click_timer -= delta

	# Handle mining
	if auto_mining_mode or miner_1_active or miner_2_active:
		# Consume fuel
		var active_miners = (1 if miner_1_active else 0) + (1 if miner_2_active else 0)
		var fuel_cost = fuel_consumption_rate * active_miners * delta

		if ship_data["fuel"] > fuel_cost:
			ship_data["fuel"] -= fuel_cost

			# Find mining target (but don't mine continuously)
			find_mining_target()

			# Update mining cycle progress
			mining_cycle_progress += delta
			if mining_cycle_progress >= mining_cycle_time:
				# Cycle completed - mine 10 units per active miner
				mine_ore_cycle(active_miners)
				mining_cycle_progress = 0.0
				mining_locked = false  # Unlock after first cycle

				# Check if target is depleted and switch to next in queue
				check_mining_target_depleted()
		else:
			# No fuel - stop mining
			miner_1_active = false
			miner_2_active = false
			mining_locked = false
			mining_cycle_progress = 0.0
			print("Out of fuel!")
	else:
		mining_target = null
		laser1.clear_points()
		laser2.clear_points()
		mining_cycle_progress = 0.0
		mining_locked = false

	# Update laser visuals
	update_mining_lasers()

	# Update ship animation based on speed
	update_ship_animation()

	# Update UI
	update_ship_ui()

func _physics_process(delta):
	# Autopilot movement
	if autopilot_state != AutopilotState.IDLE:
		autopilot_move(delta)
	else:
		# Passive drift/deceleration
		current_velocity *= 0.98

	# Apply velocity with collision bounce
	velocity = current_velocity
	var collision = move_and_collide(velocity * delta)

	# Bounce off collisions
	if collision:
		# Calculate bounce direction
		var bounce_velocity = velocity.bounce(collision.get_normal())
		current_velocity = bounce_velocity * 0.6  # Energy loss on bounce

func _input(event):
	# Check if mouse is over UI - if so, ignore input
	if event is InputEventMouse:
		var viewport = get_viewport()
		var camera_2d = viewport.get_camera_2d()
		if camera_2d:
			# Check if mouse is hovering over any Control node
			var mouse_pos = viewport.get_mouse_position()
			var control_at_pos = _get_control_at_position(viewport, mouse_pos)
			if control_at_pos != null:
				return  # Mouse is over UI, ignore input

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Check for double click
			var current_pos = get_global_mouse_position()
			if click_timer > 0 and last_click_pos.distance_to(current_pos) < 20:
				# Double click detected
				on_double_click(current_pos)
				click_timer = 0
			else:
				# First click
				click_timer = double_click_time
				last_click_pos = current_pos

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			# Show radial menu - pass both world position and screen position
			var world_pos = get_global_mouse_position()
			var screen_pos = get_viewport().get_mouse_position()
			radial_menu_position = world_pos
			show_radial_menu = true
			get_tree().call_group("radial_menu", "show_menu", world_pos, screen_pos)

	# Keyboard shortcuts
	elif event is InputEventKey:
		if event.pressed and not event.echo:
			match event.keycode:
				KEY_1:
					toggle_miner(1)
				KEY_2:
					toggle_miner(2)

func on_double_click(click_position: Vector2):
	# Start autopilot to position
	start_autopilot_to_position(click_position)

func start_autopilot_to_position(pos: Vector2):
	target_position = pos
	autopilot_state = AutopilotState.ACCELERATING
	auto_mining_mode = false

func start_autopilot_to_ore(ore: Node2D):
	if is_instance_valid(ore):
		target_position = ore.global_position
		autopilot_state = AutopilotState.ACCELERATING
		auto_mining_mode = true
		mining_target = ore

func start_orbit(target: Node2D, distance: float = 200.0):
	"""Start orbiting around a target at specified distance"""
	if not is_instance_valid(target):
		return

	orbit_target = target
	orbit_distance = distance
	autopilot_state = AutopilotState.ORBITING
	auto_mining_mode = false

	# Calculate initial orbit angle based on current position
	var to_target = target.global_position - global_position
	orbit_angle = atan2(to_target.y, to_target.x)

func stop_orbit():
	"""Stop orbiting"""
	orbit_target = null
	autopilot_state = AutopilotState.IDLE

func target_object(obj: Node2D) -> void:
	"""
	Sets the currently targeted object for interaction.

	Used by context menu, scanner, targeting UI, and combat systems.
	Emits target_changed signal for UI updates.

	Args:
		obj: The Node2D to target (Ship, Station, Asteroid, etc.) or null to clear

	Emits:
		target_changed(obj) - When target changes

	Example:
		Player.target_object(nearest_asteroid)
		Player.target_object(null)  # Clear target
	"""
	targeted_object = obj
	if obj:
		print("Targeted: ", obj.name)  # TODO: Replace with Logger.debug
	else:
		print("Target cleared")  # TODO: Replace with Logger.debug

	# Emit signal for UI updates (PermanentInfoPanel, TargetingPanel, etc.)
	target_changed.emit(obj)

func get_targeted_object() -> Node2D:
	"""
	Returns the currently targeted object.

	Used by:
	- Main.gd context menu (lines 322, 345)
	- PermanentInfoPanel scanner (lines 239, 267, 327)
	- TargetingPanel display
	- Combat system for weapon targeting

	Returns:
		Currently targeted Node2D, or null if nothing targeted

	Example:
		var target = Player.get_targeted_object()
		if target and target is Asteroid:
			start_mining(target)
	"""
	return targeted_object

func eject_cargo(item_id: String, amount: float):
	"""Eject cargo into space"""
	# Check if we have this item
	var found = false
	var cargo_type_to_remove = CargoType.GENERAL

	# Find which cargo hold has this item
	for cargo_type in cargo_holds.keys():
		var current_hold = cargo_holds[cargo_type]
		if current_hold["items"].has(item_id) and current_hold["items"][item_id] >= amount:
			found = true
			cargo_type_to_remove = cargo_type
			break

	if not found:
		print("Cannot eject: Item not found or insufficient amount")
		return

	# Remove from cargo
	var hold = cargo_holds[cargo_type_to_remove]
	hold["items"][item_id] -= amount
	if hold["items"][item_id] <= 0:
		hold["items"].erase(item_id)
	hold["used"] -= amount

	# Update legacy cargo
	if cargo.has(item_id):
		cargo[item_id] -= amount
		if cargo[item_id] <= 0:
			cargo.erase(item_id)
	cargo_used -= amount

	# Spawn crate in space
	var CrateScene = load("res://scenes/CargoCrate.tscn")
	var crate = CrateScene.instantiate()

	# Position crate behind ship
	var eject_direction = Vector2(cos(rotation + PI), sin(rotation + PI))
	crate.global_position = global_position + eject_direction * 50.0

	# Set crate data
	crate.set_cargo_data(item_id, amount)

	# Add to scene
	get_parent().add_child(crate)

	print("Ejected: ", item_id, " x ", amount)

	# Emit signal for UI updates
	cargo_ejected.emit(item_id, amount)

func autopilot_move(delta):
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
			# Accelerate towards target
			var forward = Vector2(cos(rotation), sin(rotation))
			current_velocity += forward * acceleration * delta

			# Limit max speed
			if current_velocity.length() > ship_data["max_speed"]:
				current_velocity = current_velocity.normalized() * ship_data["max_speed"]

			# Switch to decelerating if near target
			if distance < deceleration_distance or distance < 100:
				autopilot_state = AutopilotState.DECELERATING

		AutopilotState.DECELERATING:
			# Decelerate approaching target
			var decel_amount = acceleration * delta * 1.5
			current_velocity = current_velocity.move_toward(Vector2.ZERO, decel_amount)

			# Arrive at target
			if distance < 20 or current_velocity.length() < 5:
				autopilot_state = AutopilotState.ARRIVED
				current_velocity = Vector2.ZERO

				# If auto mining, activate miners
				if auto_mining_mode and mining_target:
					miner_1_active = true
					miner_2_active = true

		AutopilotState.ARRIVED:
			# Hold position
			current_velocity = Vector2.ZERO

			# If mining complete, return to idle
			if auto_mining_mode and not is_instance_valid(mining_target):
				autopilot_state = AutopilotState.IDLE
				miner_1_active = false
				miner_2_active = false

		AutopilotState.ORBITING:
			# Orbit around target
			if not is_instance_valid(orbit_target):
				# Target lost, stop orbiting
				autopilot_state = AutopilotState.IDLE
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
				angle_diff = wrapf(desired_rotation - rotation, -PI, PI)
				rotation += sign(angle_diff) * min(abs(angle_diff), rotation_speed * delta)

func toggle_miner(slot: int):
	# Check if we're trying to turn off during lock period
	var trying_to_disable = false

	if slot == 1:
		trying_to_disable = miner_1_active
		if not mining_locked or not trying_to_disable:
			var new_state = !miner_1_active

			# Check temperature system if activating
			if new_state and temperature_system:
				if not temperature_system.register_module_activation():
					print("❌ Cannot activate miner - Emergency shutdown active")
					return

			miner_1_active = new_state
			if miner_1_active:
				mining_locked = true
				mining_cycle_progress = 0.0
			else:
				if temperature_system:
					temperature_system.register_module_deactivation()

	elif slot == 2:
		trying_to_disable = miner_2_active
		if not mining_locked or not trying_to_disable:
			var new_state = !miner_2_active

			# Check temperature system if activating
			if new_state and temperature_system:
				if not temperature_system.register_module_activation():
					print("❌ Cannot activate miner - Emergency shutdown active")
					return

			miner_2_active = new_state
			if miner_2_active:
				mining_locked = true
				mining_cycle_progress = 0.0
			else:
				if temperature_system:
					temperature_system.register_module_deactivation()

	# If both miners off, reset lock
	if not miner_1_active and not miner_2_active:
		mining_locked = false
		mining_cycle_progress = 0.0

func find_mining_target():
	"""Find closest ore in range for mining"""
	# If auto mining mode, keep current target
	if auto_mining_mode and is_instance_valid(mining_target):
		return  # Keep existing target

	# Find closest ore in range
	var closest_ore = null
	var closest_distance = mining_range

	var ore_container = get_node("../OreContainer")
	if ore_container:
		for ore in ore_container.get_children():
			if is_instance_valid(ore):
				var distance = global_position.distance_to(ore.global_position)
				if distance < closest_distance:
					closest_ore = ore
					closest_distance = distance

	mining_target = closest_ore

func mine_ore_cycle(active_miners: int):
	"""Mine ore at the end of a mining cycle - 10 units per miner"""
	if not mining_target or not is_instance_valid(mining_target):
		return

	# Each miner extracts 10 units per cycle
	var mine_amount = 10.0 * active_miners

	if mining_target.has_method("mine"):
		var mined = mining_target.mine(mine_amount)
		if mined > 0:
			var ore_name = mining_target.ore_name if "ore_name" in mining_target else mining_target.ore_id
			add_to_cargo(mining_target.ore_id, mined)
			print("Mined %.1f units of %s" % [mined, mining_target.ore_id])

			# Emit signal for UI updates
			ore_mined.emit(ore_name, mined, mining_target.ore_id)

func update_mining_lasers():
	if mining_target and is_instance_valid(mining_target):
		var target_pos = mining_target.global_position

		if miner_1_active:
			laser1.clear_points()
			laser1.add_point(to_local(global_position))
			laser1.add_point(to_local(target_pos))
		else:
			laser1.clear_points()

		if miner_2_active:
			laser2.clear_points()
			laser2.add_point(to_local(global_position))
			laser2.add_point(to_local(target_pos + Vector2(5, 5)))
		else:
			laser2.clear_points()
	else:
		laser1.clear_points()
		laser2.clear_points()

func update_ship_animation():
	"""Update ship animation based on current velocity"""
	var speed = current_velocity.length()

	# Determine animation based on speed
	if speed < 10.0:
		# Idle/stationary
		if sprite.animation != "idle":
			sprite.animation = "idle"
			sprite.play()
	elif speed > ship_data["max_speed"] * 0.8:
		# Boost (80%+ of max speed)
		if sprite.animation != "boost":
			sprite.animation = "boost"
			sprite.play()
	else:
		# Normal movement
		if sprite.animation != "moving":
			sprite.animation = "moving"
			sprite.play()

# ============================================================================
# MINING QUEUE SYSTEM
# ============================================================================

func add_to_mining_queue(target: Node2D) -> bool:
	"""Add asteroid to mining queue"""
	if not target or not is_instance_valid(target):
		return false

	# Don't add duplicates
	if target in mining_queue:
		print("⚠️ Target already in queue")
		return false

	# Don't add current mining target
	if target == mining_target:
		print("⚠️ Already mining this target")
		return false

	mining_queue.append(target)
	print("📋 Added to mining queue: %s (Queue size: %d)" % [target.name, mining_queue.size()])
	return true

func remove_from_mining_queue(target: Node2D) -> bool:
	"""Remove asteroid from mining queue"""
	if target in mining_queue:
		mining_queue.erase(target)
		print("📋 Removed from mining queue: %s" % target.name)
		return true
	return false

func clear_mining_queue():
	"""Clear entire mining queue"""
	mining_queue.clear()
	print("📋 Mining queue cleared")

func get_next_queue_target() -> Node2D:
	"""Get next valid target from queue"""
	# Clean up invalid targets
	var valid_queue: Array[Node2D] = []
	for target in mining_queue:
		if is_instance_valid(target):
			# Check if asteroid still has ore
			if "amount" in target and target.amount > 0:
				valid_queue.append(target)

	mining_queue = valid_queue

	# Return first valid target
	if mining_queue.size() > 0:
		return mining_queue[0]

	return null

func switch_to_next_queue_target():
	"""Switch to next target in mining queue"""
	if not auto_queue_enabled:
		return

	var next_target = get_next_queue_target()
	if next_target:
		# Remove from queue
		mining_queue.erase(next_target)

		# Set as new mining target
		mining_target = next_target
		target_object(next_target)

		print("⛏️ Switched to next queue target: %s (Remaining: %d)" % [next_target.name, mining_queue.size()])

		# Start autopilot to new target
		if auto_mining_mode:
			start_orbit(next_target)
	else:
		# Queue empty - stop mining
		mining_target = null
		miner_1_active = false
		miner_2_active = false
		mining_locked = false
		autopilot_state = AutopilotState.IDLE
		print("📋 Mining queue empty - mining stopped")

func check_mining_target_depleted():
	"""Check if current mining target is depleted"""
	if mining_target and is_instance_valid(mining_target):
		if "amount" in mining_target:
			if mining_target.amount <= 0:
				print("⛏️ Target depleted: %s" % mining_target.name)
				switch_to_next_queue_target()
				return true
	elif mining_target:
		# Invalid target
		print("⚠️ Mining target became invalid")
		switch_to_next_queue_target()
		return true
	return false

func get_mining_queue_info() -> Array[Dictionary]:
	"""Get mining queue info for UI"""
	var info: Array[Dictionary] = []
	for target in mining_queue:
		if is_instance_valid(target):
			info.append({
				"name": target.name,
				"ore_id": target.ore_id if "ore_id" in target else "unknown",
				"amount": target.amount if "amount" in target else 0.0,
				"distance": global_position.distance_to(target.global_position)
			})
	return info

func add_to_cargo(ore_id: String, amount: float):
	# Determine cargo type based on item ID
	var cargo_type = get_cargo_type_for_item(ore_id)

	# Try to add to specific cargo hold first
	var added = add_to_cargo_hold(cargo_type, ore_id, amount)

	# If specific hold is full, try general cargo (if not already general)
	if added < amount and cargo_type != CargoType.GENERAL:
		var remaining = amount - added
		add_to_cargo_hold(CargoType.GENERAL, ore_id, remaining)

func add_to_cargo_hold(cargo_type: CargoType, item_id: String, amount: float) -> float:
	"""Add item to specific cargo hold. Returns amount actually added."""
	# Use effective capacity (includes compression bonus)
	var max_capacity = get_effective_capacity(cargo_type)
	var hold = cargo_holds[cargo_type]

	# Check available space
	var available = max_capacity - hold["used"]
	var to_add = min(amount, available)

	if to_add <= 0:
		return 0.0

	# Add to cargo (stackable)
	if hold["items"].has(item_id):
		hold["items"][item_id] += to_add
	else:
		hold["items"][item_id] = to_add

	hold["used"] += to_add

	# Update legacy cargo for compatibility
	if cargo.has(item_id):
		cargo[item_id] += to_add
	else:
		cargo[item_id] = to_add
	cargo_used += to_add

	# Emit signal for UI updates
	cargo_added.emit(item_id, to_add, cargo_type)

	return to_add

func remove_from_cargo_hold(cargo_type: CargoType, item_id: String, amount: float) -> float:
	"""Remove item from specific cargo hold. Returns amount actually removed."""
	var hold = cargo_holds[cargo_type]

	if not hold["items"].has(item_id):
		return 0.0

	var available = hold["items"][item_id]
	var to_remove = min(amount, available)

	hold["items"][item_id] -= to_remove
	if hold["items"][item_id] <= 0:
		hold["items"].erase(item_id)

	hold["used"] -= to_remove

	# Update legacy cargo
	if cargo.has(item_id):
		cargo[item_id] -= to_remove
		if cargo[item_id] <= 0:
			cargo.erase(item_id)
	cargo_used -= to_remove

	return to_remove

func move_cargo_between_holds(item_id: String, amount: float, source_type: CargoType, target_type: CargoType) -> bool:
	"""Move cargo between different holds"""
	# Remove from source hold
	var removed = remove_from_cargo_hold(source_type, item_id, amount)

	if removed > 0:
		# Try to add to target hold
		var added = add_to_cargo_hold(target_type, item_id, removed)

		if added < removed:
			# Not all fit - put remainder back in source
			var remainder = removed - added
			add_to_cargo_hold(source_type, item_id, remainder)
			print("⚠️ Only moved %.1f/%.1f (capacity limit)" % [added, amount])
			return added > 0
		else:
			print("✅ Moved %.1f kg of %s from %d to %d" % [removed, item_id, source_type, target_type])
			return true

	return false

func get_cargo_type_for_item(item_id: String) -> CargoType:
	"""Determine which cargo type an item belongs to"""
	# Check item ID prefix or type
	if item_id.begins_with("ore_"):
		return CargoType.ORE
	elif item_id.begins_with("mineral_"):
		return CargoType.MINERAL
	elif item_id.begins_with("ammo_"):
		return CargoType.AMMO
	elif item_id.begins_with("build_"):
		return CargoType.BUILD
	elif item_id.begins_with("gas_"):
		return CargoType.GAS
	else:
		return CargoType.GENERAL

func get_cargo_capacity_key(cargo_type: CargoType) -> String:
	"""Get ship_data key for cargo capacity"""
	match cargo_type:
		CargoType.GENERAL:
			return "cargo_general_capacity"
		CargoType.ORE:
			return "cargo_ore_capacity"
		CargoType.MINERAL:
			return "cargo_mineral_capacity"
		CargoType.AMMO:
			return "cargo_ammo_capacity"
		CargoType.BUILD:
			return "cargo_build_capacity"
		CargoType.GAS:
			return "cargo_gas_capacity"
		_:
			return "cargo_general_capacity"

func get_cargo_hold_info(cargo_type: CargoType) -> Dictionary:
	"""Get cargo hold information"""
	var capacity_key = get_cargo_capacity_key(cargo_type)
	var max_capacity = ship_data.get(capacity_key, 0.0)
	var hold = cargo_holds[cargo_type]

	return {
		"used": hold["used"],
		"capacity": max_capacity,
		"items": hold["items"].duplicate(),
		"compression": hold.get("compression", CompressionLevel.NONE)
	}

# ============================================================================
# PRESSURIZED COMPRESSION MODULE SYSTEM
# ============================================================================

func install_compression_module(cargo_type: CargoType, level: CompressionLevel) -> bool:
	"""Install or upgrade compression module for a cargo hold"""
	if not cargo_holds.has(cargo_type):
		return false

	var hold = cargo_holds[cargo_type]
	var old_level = hold.get("compression", CompressionLevel.NONE)

	# Install/upgrade
	hold["compression"] = level

	# Recalculate compressed volumes
	_recalculate_cargo_volumes(cargo_type)

	print("✅ Compression module %s installed on %s (Level %d → %d)" % [
		get_compression_level_name(level),
		get_cargo_type_name(cargo_type),
		old_level,
		level
	])

	return true

func get_compression_level(cargo_type: CargoType) -> CompressionLevel:
	"""Get current compression level for cargo hold"""
	var hold = cargo_holds.get(cargo_type, {})
	return hold.get("compression", CompressionLevel.NONE)

func get_effective_capacity(cargo_type: CargoType) -> float:
	"""Get effective capacity with compression bonus"""
	var base_capacity = ship_data.get(get_cargo_capacity_key(cargo_type), 0.0)
	var compression = get_compression_level(cargo_type)
	var reduction = COMPRESSION_VOLUME_REDUCTION.get(compression, 0.0)

	# Compression reduces volume, increasing effective capacity
	# Example: 50% reduction = items take 50% less space = 2x capacity
	if reduction > 0:
		return base_capacity / (1.0 - reduction)
	return base_capacity

func _recalculate_cargo_volumes(cargo_type: CargoType):
	"""Recalculate cargo volumes after compression change"""
	# When compression changes, the "used" value represents compressed space
	# This is automatically handled since we calculate against effective capacity
	var hold = cargo_holds[cargo_type]
	var compression = hold.get("compression", CompressionLevel.NONE)

	print("📦 Cargo hold %s: Compression %s (Effective capacity: %.0f m³)" % [
		get_cargo_type_name(cargo_type),
		get_compression_level_name(compression),
		get_effective_capacity(cargo_type)
	])

func get_compression_level_name(level: CompressionLevel) -> String:
	"""Get human-readable compression level name"""
	match level:
		CompressionLevel.NONE:
			return "None"
		CompressionLevel.STANDARD:
			return "Standard (-30%)"
		CompressionLevel.HIGH:
			return "High (-50%)"
		CompressionLevel.EXTREME:
			return "Extreme (-70%)"
		_:
			return "Unknown"

func get_cargo_type_name(cargo_type: int) -> String:
	"""Get human-readable cargo type name"""
	match cargo_type:
		CargoType.GENERAL:
			return "General Cargo"
		CargoType.ORE:
			return "Ore Cargo"
		CargoType.MINERAL:
			return "Mineral Cargo"
		CargoType.LIQUID:
			return "Liquid Cargo"
		CargoType.GAS:
			return "Gas Cargo"
		CargoType.AMMO:
			return "Ammunition"
		CargoType.BUILD:
			return "Build Materials"
		CargoType.COMPONENTS:
			return "Components"
		CargoType.HAZMAT:
			return "Hazmat"
		_:
			return "Unknown"

func get_autopilot_status_text() -> String:
	match autopilot_state:
		AutopilotState.IDLE:
			return "Status: Idle"
		AutopilotState.ACCELERATING:
			return "Status: Accelerating"
		AutopilotState.CRUISING:
			return "Status: Cruising"
		AutopilotState.DECELERATING:
			return "Status: Decelerating"
		AutopilotState.ARRIVED:
			if auto_mining_mode:
				return "Status: Mining"
			else:
				return "Status: Arrived"
		AutopilotState.ORBITING:
			return "Status: Orbiting (%.0fm)" % orbit_distance
		_:
			return "Status: Unknown"

func update_ship_ui():
	# Update all ship status displays
	var ship_status_node = get_node_or_null("../../CanvasLayer/UI/ShipStatus")
	if ship_status_node:
		var speed_label = ship_status_node.get_node_or_null("VBox/SpeedLabel")
		if speed_label:
			speed_label.text = "Speed: %.1f m/s" % current_velocity.length()

		var shield_label = ship_status_node.get_node_or_null("VBox/ShieldLabel")
		if shield_label:
			shield_label.text = "Shield: %.0f" % ship_data["shield"]

		var armor_label = ship_status_node.get_node_or_null("VBox/ArmorLabel")
		if armor_label:
			armor_label.text = "Armor: %.0f" % ship_data["armor"]

		var hull_label = ship_status_node.get_node_or_null("VBox/HullLabel")
		if hull_label:
			hull_label.text = "Hull: %.0f%%" % ship_data["hull_integrity"]

		var elec_label = ship_status_node.get_node_or_null("VBox/ElecLabel")
		if elec_label:
			elec_label.text = "Electronics: %.0f%%" % ship_data["electronic_stability"]

		var fuel_label = ship_status_node.get_node_or_null("VBox/FuelLabel")
		if fuel_label:
			fuel_label.text = "Fuel: %.0f / %.0f" % [ship_data["fuel"], ship_data["max_fuel"]]

		var status_label = ship_status_node.get_node_or_null("VBox/StatusLabel")
		if status_label:
			status_label.text = get_autopilot_status_text()

	# Update cargo
	var cargo_label = get_node_or_null("../../CanvasLayer/UI/BottomPanel/VBox/CargoInfo")
	if cargo_label:
		var total_used = 0.0
		for hold_type in cargo_holds:
			total_used += cargo_holds[hold_type]["used"]

		var total_capacity = ship_data["cargo_general_capacity"] + ship_data["cargo_ore_capacity"] + \
			ship_data["cargo_mineral_capacity"] + ship_data["cargo_ammo_capacity"] + \
			ship_data["cargo_build_capacity"] + ship_data["cargo_gas_capacity"]

		cargo_label.text = "%.1f / %.0f m³" % [total_used, total_capacity]

func get_ship_info() -> Dictionary:
	# Calculate total cargo capacity and usage
	var total_capacity = ship_data["cargo_general_capacity"] + ship_data["cargo_ore_capacity"] + \
		ship_data["cargo_mineral_capacity"] + ship_data["cargo_ammo_capacity"] + \
		ship_data["cargo_build_capacity"] + ship_data["cargo_gas_capacity"]

	var total_used = 0.0
	for hold_type in cargo_holds:
		total_used += cargo_holds[hold_type]["used"]

	return {
		"name": ship_data["name"],
		"mass": ship_data["mass"],
		"velocity": current_velocity,
		"speed": current_velocity.length(),
		"cargo_used": total_used,
		"cargo_capacity": total_capacity,
		"shield": ship_data["shield"],
		"armor": ship_data["armor"],
		"hull_integrity": ship_data["hull_integrity"],
		"electronic_stability": ship_data["electronic_stability"],
		"fuel": ship_data["fuel"]
	}

func _get_control_at_position(_viewport: Viewport, screen_pos: Vector2) -> Control:
	"""Check if there's a Control node at the given screen position"""
	var canvas_layers = []
	var root = get_tree().root

	# Collect all CanvasLayer nodes
	_collect_canvas_layers(root, canvas_layers)

	# Sort by layer (higher layers are on top)
	canvas_layers.sort_custom(func(a, b): return a.layer > b.layer)

	# Check each CanvasLayer from top to bottom
	for canvas_layer in canvas_layers:
		var control = _find_control_at_pos_recursive(canvas_layer, screen_pos)
		if control != null:
			return control

	return null

func _collect_canvas_layers(node: Node, result: Array):
	"""Recursively collect all CanvasLayer nodes"""
	if node is CanvasLayer:
		result.append(node)

	for child in node.get_children():
		_collect_canvas_layers(child, result)

func _find_control_at_pos_recursive(node: Node, screen_pos: Vector2) -> Control:
	"""Recursively find a Control node at the given position"""
	# Check children first (they're on top)
	for child in node.get_children():
		var result = _find_control_at_pos_recursive(child, screen_pos)
		if result != null:
			return result

	# Check if this node is a visible Control at the position
	if node is Control:
		var control = node as Control
		# Only consider controls that actually stop mouse input (not MOUSE_FILTER_IGNORE)
		if control.visible and control.mouse_filter != Control.MOUSE_FILTER_IGNORE and control.get_global_rect().has_point(screen_pos):
			return control

	return null

# ============================================================================
# TEMPERATURE SYSTEM SIGNAL HANDLERS
# ============================================================================

func _on_temperature_warning(temp: float):
	"""Handle temperature warning at 80°C"""
	print("⚠️ TEMPERATURE WARNING: %.1f°C" % temp)
	# TODO: Show UI warning

func _on_temperature_critical(temp: float):
	"""Handle critical temperature at 95°C - emergency shutdown"""
	print("🚨 CRITICAL TEMPERATURE: %.1f°C - EMERGENCY SHUTDOWN!" % temp)
	# Force disable all miners
	miner_1_active = false
	miner_2_active = false
	mining_locked = false
	# TODO: Show UI critical alert

func _on_temperature_damage(damage: float):
	"""Handle heat damage at 100°C+"""
	# Apply damage to hull
	ship_data["hull_integrity"] = max(0, ship_data["hull_integrity"] - damage)
	if ship_data["hull_integrity"] <= 0:
		print("💀 SHIP DESTROYED BY HEAT DAMAGE!")
		# TODO: Handle ship destruction

func _on_coolant_low(amount: float):
	"""Handle low coolant warning"""
	print("⚠️ COOLANT LOW: %.0f units remaining" % amount)
	# TODO: Show UI warning

func _on_coolant_depleted():
	"""Handle coolant depletion"""
	print("❌ COOLANT DEPLETED - Temperature will rise rapidly!")
	# TODO: Show UI critical alert

# ============================================================================
# ADVANCED SHIP SYSTEMS (Stub Methods for PermanentInfoPanel Compatibility)
# ============================================================================
# These methods provide compatibility with PermanentInfoPanel's advanced panels
# (SHIP_OVERVIEW, SHIP_DETAILS) without implementing full BaseShip functionality.
# TODO: Integrate full Power/CPU/Heat management system from BaseShip in Phase 5

func get_ship_modules_info() -> Array:
	"""Get info about all ship modules - STUB"""
	# Returns empty array - advanced panels will show "No modules"
	# TODO: Implement module system when integrating BaseShip
	return []

func get_module_by_id(_module_id: String) -> Dictionary:
	"""Get specific module by ID - STUB"""
	# Returns empty dict - module details won't show
	# TODO: Implement module lookup when integrating BaseShip
	return {}

func get_ship_systems_info() -> Dictionary:
	"""Get ship systems status (Power/CPU/Heat) - STUB"""
	# Returns basic structure to prevent errors in SHIP_DETAILS panel
	# TODO: Integrate real systems from BaseShip
	return {
		"power": {
			"current": 0.0,
			"max": 100.0,
			"generation": 0.0,
			"consumption": 0.0
		},
		"cpu": {
			"current": 0.0,
			"max": 100.0,
			"consumption": 0.0
		},
		"heat": {
			"current": 20.0,  # Base temperature
			"max": 100.0,
			"generation": 0.0,
			"dissipation": 0.0
		}
	}

func set_module_power_allocation(_module_id: String, _value: float):
	"""Set power allocation for a module - STUB"""
	# No-op until module system is implemented
	# TODO: Implement power routing when integrating BaseShip
	pass

func set_module_cooling_allocation(_module_id: String, _value: float):
	"""Set cooling allocation for a module - STUB"""
	# No-op until cooling system is implemented
	# TODO: Implement cooling routing when integrating BaseShip
	pass

# ============================================================================
# DOCKING SYSTEM
# ============================================================================

func dock_at_station(station: Node2D) -> bool:
	"""Dock at a station"""
	if is_docked:
		print("❌ Already docked at %s" % docked_station.station_name)
		return false

	# Check if target is a station
	if not station.has_method("dock_ship"):
		print("❌ Target is not a station")
		return false

	# Attempt to dock
	if station.dock_ship(self):
		docked_station = station
		is_docked = true

		# Stop movement
		current_velocity = Vector2.ZERO
		autopilot_state = AutopilotState.IDLE

		print("✅ Docked at %s" % station.station_name)
		return true
	else:
		print("❌ Docking failed")
		return false

func undock_from_station() -> bool:
	"""Undock from current station"""
	if not is_docked or not docked_station:
		print("❌ Not docked")
		return false

	if docked_station.undock_ship(self):
		docked_station = null
		is_docked = false
		print("✅ Undocked")
		return true
	else:
		print("❌ Undocking failed")
		return false

func access_station_service(service_name: String) -> bool:
	"""Access a station service"""
	if not is_docked or not docked_station:
		print("❌ Not docked at any station")
		return false

	return docked_station.access_service(service_name, self)
