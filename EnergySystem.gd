extends Node

# ============================================================================
# ENERGY & POWER MANAGEMENT SYSTEM
# ============================================================================
# Manages ship energy generation, distribution, and consumption
# Integrates with Temperature System (cooling requires energy)
# Grid Management with priority system

signal energy_depleted()
signal energy_low(amount: float)
signal generator_overload(generator_id: String)
signal grid_overload(consumption: float, capacity: float)
signal fuel_low(fuel_type: String, amount: float)
signal fuel_depleted(fuel_type: String)

# Generator types
enum GeneratorType {
	SOLAR,      # Free energy, low output, no fuel
	FUSION,     # Medium output, deuterium fuel
	FISSION,    # High output, uranium fuel, generates heat
	ANTIMATTER  # Very high output, exotic fuel, very expensive
}

# Power priority levels
enum PowerPriority {
	CRITICAL = 0,   # Life support, emergency systems
	HIGH = 1,       # Weapons, shields
	MEDIUM = 2,     # Mining, refining
	LOW = 3         # Sensors, comms
}

# Generator data structure
class Generator:
	var generator_id: String = ""
	var generator_name: String = ""
	var generator_type: GeneratorType = GeneratorType.SOLAR
	var tier: int = 1

	# Output stats
	var base_output: float = 100.0  # Energy per second
	var current_output: float = 100.0
	var max_output: float = 150.0  # Overload capacity

	# Fuel consumption
	var fuel_type: String = ""  # e.g., "deuterium", "uranium"
	var fuel_consumption_rate: float = 0.0  # Per second at 100% output

	# Heat generation
	var heat_per_second: float = 10.0

	# Efficiency
	var efficiency: float = 1.0  # 0.7-1.0 optimal range

	# State
	var is_active: bool = true
	var is_overloaded: bool = false
	var overload_timer: float = 0.0
	var max_overload_time: float = 60.0  # 60 seconds max overload

	func _init(id: String, name: String, type: GeneratorType, t: int = 1):
		generator_id = id
		generator_name = name
		generator_type = type
		tier = t

		# Set defaults based on type
		match generator_type:
			GeneratorType.SOLAR:
				base_output = 50.0
				max_output = 50.0  # Can't overload
				fuel_type = ""
				fuel_consumption_rate = 0.0
				heat_per_second = 0.0
			GeneratorType.FUSION:
				base_output = 200.0
				max_output = 300.0
				fuel_type = "deuterium"
				fuel_consumption_rate = 1.0
				heat_per_second = 15.0
			GeneratorType.FISSION:
				base_output = 500.0
				max_output = 750.0
				fuel_type = "uranium"
				fuel_consumption_rate = 0.5
				heat_per_second = 50.0
			GeneratorType.ANTIMATTER:
				base_output = 2000.0
				max_output = 3000.0
				fuel_type = "antimatter"
				fuel_consumption_rate = 0.1
				heat_per_second = 5.0

	func set_overload(enabled: bool) -> bool:
		"""Enable/disable overload mode"""
		if generator_type == GeneratorType.SOLAR:
			return false  # Solar can't overload

		if enabled and not is_overloaded:
			is_overloaded = true
			current_output = max_output
			overload_timer = 0.0
			return true
		elif not enabled and is_overloaded:
			is_overloaded = false
			current_output = base_output
			return true

		return false

	func update_overload(delta: float) -> bool:
		"""Update overload timer, returns true if overload limit reached"""
		if not is_overloaded:
			return false

		overload_timer += delta
		if overload_timer >= max_overload_time:
			# Force disable overload
			set_overload(false)
			return true

		return false

	func calculate_efficiency(load_percent: float) -> float:
		"""Calculate efficiency based on load (70-90% optimal)"""
		if load_percent < 0.5:
			# Too low load, inefficient
			efficiency = 0.7 + (load_percent * 0.3)
		elif load_percent >= 0.7 and load_percent <= 0.9:
			# Optimal range
			efficiency = 1.0
		elif load_percent > 0.9:
			# Overloaded, less efficient
			efficiency = 1.0 - ((load_percent - 0.9) * 2.0)
		else:
			efficiency = 0.85

		efficiency = clamp(efficiency, 0.5, 1.0)
		return efficiency

# Power consumer data structure
class PowerConsumer:
	var consumer_id: String = ""
	var consumer_name: String = ""
	var power_draw: float = 0.0
	var priority: PowerPriority = PowerPriority.MEDIUM
	var is_active: bool = false
	var is_critical: bool = false

	func _init(id: String, name: String, draw: float, prio: PowerPriority):
		consumer_id = id
		consumer_name = name
		power_draw = draw
		priority = prio

# Current state
var generators: Dictionary = {}  # generator_id -> Generator
var power_consumers: Dictionary = {}  # consumer_id -> PowerConsumer

# Energy buffer (capacitor)
var energy_buffer: float = 1000.0
var max_energy_buffer: float = 1000.0
var energy_low_threshold: float = 200.0

# Fuel storage
var fuel_storage: Dictionary = {
	"deuterium": 1000.0,
	"uranium": 500.0,
	"antimatter": 10.0
}

var max_fuel_storage: Dictionary = {
	"deuterium": 5000.0,
	"uranium": 2000.0,
	"antimatter": 100.0
}

# Grid statistics
var total_generation: float = 0.0
var total_consumption: float = 0.0
var grid_load_percent: float = 0.0

func _ready():
	print("⚡ Energy System initialized")

func _process(delta):
	update_energy_grid(delta)

# ============================================================================
# ENERGY GRID MANAGEMENT
# ============================================================================

func update_energy_grid(delta: float):
	"""Update energy generation, consumption, and distribution"""

	# Calculate total generation
	total_generation = 0.0
	for gen_id in generators:
		var gen = generators[gen_id]
		if not gen.is_active:
			continue

		# Check fuel availability
		if gen.fuel_type != "" and fuel_storage.has(gen.fuel_type):
			var fuel_needed = gen.fuel_consumption_rate * delta
			if fuel_storage[gen.fuel_type] < fuel_needed:
				# Not enough fuel
				emit_signal("fuel_depleted", gen.fuel_type)
				gen.is_active = false
				continue

			# Consume fuel
			fuel_storage[gen.fuel_type] -= fuel_needed

			# Check fuel low threshold
			if fuel_storage[gen.fuel_type] < max_fuel_storage[gen.fuel_type] * 0.2:
				emit_signal("fuel_low", gen.fuel_type, fuel_storage[gen.fuel_type])

		# Update overload
		if gen.update_overload(delta):
			emit_signal("generator_overload", gen_id)
			print("🚨 Generator %s overload limit reached!" % gen.generator_name)

		# Add to total generation (with efficiency)
		total_generation += gen.current_output * gen.efficiency

	# Calculate total consumption
	total_consumption = 0.0
	for consumer_id in power_consumers:
		var consumer = power_consumers[consumer_id]
		if consumer.is_active:
			total_consumption += consumer.power_draw

	# Calculate grid load
	if total_generation > 0:
		grid_load_percent = total_consumption / total_generation
	else:
		grid_load_percent = 999.0  # No generation!

	# Update generator efficiency based on load
	for gen_id in generators:
		var gen = generators[gen_id]
		if gen.is_active:
			gen.calculate_efficiency(grid_load_percent)

	# Energy flow
	var net_energy = (total_generation - total_consumption) * delta

	# Update buffer
	energy_buffer += net_energy
	energy_buffer = clamp(energy_buffer, 0.0, max_energy_buffer)

	# Check for grid overload
	if total_consumption > total_generation:
		emit_signal("grid_overload", total_consumption, total_generation)

		# Drain buffer
		if energy_buffer <= 0:
			# Emergency power management
			emergency_power_distribution()

	# Check energy levels
	if energy_buffer <= 0:
		emit_signal("energy_depleted")
	elif energy_buffer < energy_low_threshold:
		emit_signal("energy_low", energy_buffer)

func emergency_power_distribution():
	"""Disable low-priority systems when energy depleted"""
	print("🚨 EMERGENCY: Low power - disabling non-critical systems")

	# Disable systems by priority (lowest first)
	for priority in range(PowerPriority.LOW, PowerPriority.CRITICAL - 1, -1):
		for consumer_id in power_consumers:
			var consumer = power_consumers[consumer_id]
			if consumer.priority == priority and not consumer.is_critical:
				consumer.is_active = false
				print("❌ Disabled: %s (Priority: %s)" % [consumer.consumer_name, PowerPriority.keys()[priority]])

		# Check if enough power now
		var new_consumption = 0.0
		for c_id in power_consumers:
			if power_consumers[c_id].is_active:
				new_consumption += power_consumers[c_id].power_draw

		if new_consumption <= total_generation:
			break  # Enough power now

# ============================================================================
# GENERATOR MANAGEMENT
# ============================================================================

func add_generator(generator_id: String, generator_type: GeneratorType, tier: int = 1) -> bool:
	"""Add a new generator to the grid"""
	if generators.has(generator_id):
		print("❌ Generator already exists: %s" % generator_id)
		return false

	var gen_name = "%s Generator Mk%d" % [GeneratorType.keys()[generator_type], tier]
	var gen = Generator.new(generator_id, gen_name, generator_type, tier)
	generators[generator_id] = gen

	print("✅ Generator added: %s (%.0f E/s)" % [gen_name, gen.base_output])
	return true

func remove_generator(generator_id: String) -> bool:
	"""Remove a generator from the grid"""
	if not generators.has(generator_id):
		return false

	generators.erase(generator_id)
	return true

func set_generator_active(generator_id: String, active: bool) -> bool:
	"""Enable/disable a generator"""
	if not generators.has(generator_id):
		return false

	generators[generator_id].is_active = active
	return true

func set_generator_overload(generator_id: String, enabled: bool) -> bool:
	"""Enable/disable generator overload mode"""
	if not generators.has(generator_id):
		return false

	return generators[generator_id].set_overload(enabled)

# ============================================================================
# POWER CONSUMER MANAGEMENT
# ============================================================================

func register_consumer(consumer_id: String, name: String, power_draw: float, priority: PowerPriority, critical: bool = false) -> bool:
	"""Register a power consumer"""
	if power_consumers.has(consumer_id):
		print("❌ Consumer already registered: %s" % consumer_id)
		return false

	var consumer = PowerConsumer.new(consumer_id, name, power_draw, priority)
	consumer.is_critical = critical
	power_consumers[consumer_id] = consumer

	print("✅ Power consumer registered: %s (%.0f E/s, Priority: %s)" % [name, power_draw, PowerPriority.keys()[priority]])
	return true

func unregister_consumer(consumer_id: String) -> bool:
	"""Unregister a power consumer"""
	if not power_consumers.has(consumer_id):
		return false

	power_consumers.erase(consumer_id)
	return true

func set_consumer_active(consumer_id: String, active: bool) -> bool:
	"""Enable/disable a power consumer"""
	if not power_consumers.has(consumer_id):
		return false

	# Check if enough power available
	if active:
		var consumer = power_consumers[consumer_id]
		var available_power = total_generation - total_consumption

		if available_power < consumer.power_draw:
			print("⚠️ Insufficient power for %s" % consumer.consumer_name)
			return false

	power_consumers[consumer_id].is_active = active
	return true

# ============================================================================
# FUEL MANAGEMENT
# ============================================================================

func add_fuel(fuel_type: String, amount: float) -> float:
	"""Add fuel to storage, returns amount actually added"""
	if not fuel_storage.has(fuel_type):
		fuel_storage[fuel_type] = 0.0
		max_fuel_storage[fuel_type] = 1000.0

	var space = max_fuel_storage[fuel_type] - fuel_storage[fuel_type]
	var to_add = min(amount, space)
	fuel_storage[fuel_type] += to_add

	return to_add

func remove_fuel(fuel_type: String, amount: float) -> float:
	"""Remove fuel from storage, returns amount actually removed"""
	if not fuel_storage.has(fuel_type):
		return 0.0

	var to_remove = min(amount, fuel_storage[fuel_type])
	fuel_storage[fuel_type] -= to_remove

	return to_remove

func get_fuel_amount(fuel_type: String) -> float:
	"""Get current fuel amount"""
	return fuel_storage.get(fuel_type, 0.0)

func get_fuel_runtime_hours(fuel_type: String) -> float:
	"""Calculate remaining runtime for a fuel type"""
	if not fuel_storage.has(fuel_type):
		return 0.0

	# Calculate total consumption rate for this fuel type
	var consumption_rate = 0.0
	for gen_id in generators:
		var gen = generators[gen_id]
		if gen.is_active and gen.fuel_type == fuel_type:
			consumption_rate += gen.fuel_consumption_rate

	if consumption_rate <= 0:
		return 999.0  # No consumption

	return fuel_storage[fuel_type] / (consumption_rate * 3600.0)

# ============================================================================
# SAVE/LOAD INTEGRATION
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export energy system data for saving"""
	var gens_data = {}
	for gen_id in generators:
		var gen = generators[gen_id]
		gens_data[gen_id] = {
			"type": gen.generator_type,
			"tier": gen.tier,
			"is_active": gen.is_active,
			"is_overloaded": gen.is_overloaded,
			"overload_timer": gen.overload_timer
		}

	var consumers_data = {}
	for consumer_id in power_consumers:
		var consumer = power_consumers[consumer_id]
		consumers_data[consumer_id] = {
			"name": consumer.consumer_name,
			"power_draw": consumer.power_draw,
			"priority": consumer.priority,
			"is_active": consumer.is_active,
			"is_critical": consumer.is_critical
		}

	return {
		"generators": gens_data,
		"consumers": consumers_data,
		"energy_buffer": energy_buffer,
		"fuel_storage": fuel_storage.duplicate()
	}

func load_save_data(data: Dictionary):
	"""Import energy system data from save file"""
	generators.clear()
	power_consumers.clear()

	# Restore generators
	if data.has("generators"):
		for gen_id in data["generators"]:
			var gen_data = data["generators"][gen_id]
			add_generator(gen_id, gen_data["type"], gen_data["tier"])
			var gen = generators[gen_id]
			gen.is_active = gen_data["is_active"]
			gen.is_overloaded = gen_data.get("is_overloaded", false)
			gen.overload_timer = gen_data.get("overload_timer", 0.0)

	# Restore consumers
	if data.has("consumers"):
		for consumer_id in data["consumers"]:
			var c_data = data["consumers"][consumer_id]
			register_consumer(
				consumer_id,
				c_data["name"],
				c_data["power_draw"],
				c_data["priority"],
				c_data.get("is_critical", false)
			)
			power_consumers[consumer_id].is_active = c_data["is_active"]

	energy_buffer = data.get("energy_buffer", max_energy_buffer)

	if data.has("fuel_storage"):
		fuel_storage = data["fuel_storage"].duplicate()

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_grid_info() -> Dictionary:
	"""Get detailed grid information"""
	return {
		"total_generation": total_generation,
		"total_consumption": total_consumption,
		"grid_load_percent": grid_load_percent * 100.0,
		"energy_buffer": energy_buffer,
		"max_energy_buffer": max_energy_buffer,
		"buffer_percent": (energy_buffer / max_energy_buffer) * 100.0,
		"active_generators": get_active_generator_count(),
		"active_consumers": get_active_consumer_count()
	}

func get_active_generator_count() -> int:
	var count = 0
	for gen_id in generators:
		if generators[gen_id].is_active:
			count += 1
	return count

func get_active_consumer_count() -> int:
	var count = 0
	for consumer_id in power_consumers:
		if power_consumers[consumer_id].is_active:
			count += 1
	return count

func get_generator_info(generator_id: String) -> Dictionary:
	"""Get detailed generator information"""
	if not generators.has(generator_id):
		return {}

	var gen = generators[generator_id]
	return {
		"id": gen.generator_id,
		"name": gen.generator_name,
		"type": GeneratorType.keys()[gen.generator_type],
		"tier": gen.tier,
		"base_output": gen.base_output,
		"current_output": gen.current_output,
		"max_output": gen.max_output,
		"efficiency": gen.efficiency,
		"fuel_type": gen.fuel_type,
		"fuel_consumption": gen.fuel_consumption_rate,
		"heat_generation": gen.heat_per_second,
		"is_active": gen.is_active,
		"is_overloaded": gen.is_overloaded,
		"overload_time_remaining": gen.max_overload_time - gen.overload_timer if gen.is_overloaded else 0.0
	}
