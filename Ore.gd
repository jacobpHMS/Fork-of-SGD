extends Area2D

# ============================================================================
# SIGNALS
# ============================================================================

signal ore_scanned(ore_name: String, scanner_level: int)

# ============================================================================
# ORE DATA
# ============================================================================

# Ore data
var ore_id: String = "ORE_T1_001"
var ore_name: String = "Ferralite"
var quality_code: String = ""
var quality_tier: String = "Q2"
var amount: float = 100.0  # Units
var max_amount: float = 100.0

# Asteroid rotation
var rotation_speed: float = 0.0  # Degrees per second

# Scanner system - Scan data persistence
var is_scanned: bool = false
var scan_data: Dictionary = {}
var scanner_level: int = 0  # 0 = not scanned, 1-5 = Mk1-Mk5
var scan_timestamp: float = 0.0

# Visual references
@onready var label = $Label
@onready var sprite = $Sprite2D

# Ore database reference (will be loaded from JSON later)
var ore_database = {}

func _ready():
	# Randomize ore type from database
	randomize_ore()
	update_visual()

	# Set random initial rotation and rotation speed
	rotation_degrees = randf_range(0, 360)
	rotation_speed = randf_range(0.5, 2.0)  # 0.5 to 2.0 degrees per second

func _process(delta):
	# Apply asteroid rotation
	rotation_degrees += rotation_speed * delta

func randomize_ore():
	# Get random ore from database
	var ore_data = OreDatabase.get_random_ore()

	if ore_data.size() > 0:
		ore_id = ore_data.get("ore_id", "ORE_T1_001")
		ore_name = ore_data.get("ore_name", "Unknown Ore")
		quality_code = ore_data.get("quality_code", "")
		quality_tier = ore_data.get("quality_tier", "Q2")
	else:
		# Fallback if database not loaded
		ore_id = "ORE_T1_001"
		ore_name = "Ferralite"
		quality_tier = "Q2"

	# Random amount
	amount = randf_range(50.0, 150.0)
	max_amount = amount

func update_visual():
	if label:
		label.text = "%s\n%.0fu" % [ore_name, amount]

	# Keep asteroid fully visible until depleted (no fade during mining)
	if sprite:
		sprite.modulate = Color(1, 1, 1, 1.0)  # Always fully visible

func mine(mine_amount: float) -> float:
	if amount <= 0:
		queue_free()
		return 0.0

	var mined = min(mine_amount, amount)
	amount -= mined

	update_visual()

	# Change rotation speed slightly on each mining cycle
	on_mining_cycle_complete()

	if amount <= 0:
		queue_free()

	return mined

func on_mining_cycle_complete():
	"""Called when a mining cycle completes - slightly changes rotation speed"""
	var change = randf_range(-0.05, 0.05)  # -5% to +5%
	rotation_speed += rotation_speed * change
	rotation_speed = clamp(rotation_speed, 0.5, 2.0)  # Keep within limits

func get_ore_info() -> Dictionary:
	return {
		"id": ore_id,
		"name": ore_name,
		"quality": quality_tier,
		"amount": amount,
		"max_amount": max_amount
	}

func get_ore_name() -> String:
	return ore_name

# ============================================================================
# SCANNER SYSTEM
# ============================================================================

func get_quality_distribution() -> Dictionary:
	"""Generate quality distribution for scanner based on ore's primary quality tier"""
	# Extract tier number from quality_tier (e.g., "Q2" -> 2)
	var tier_num = int(quality_tier.substr(1, 1))

	# Generate bell-curve distribution centered on tier_num
	var distribution = {
		"Q0": 0.0,
		"Q1": 0.0,
		"Q2": 0.0,
		"Q3": 0.0,
		"Q4": 0.0,
		"Q5": 0.0
	}

	# Bell curve: Peak at tier_num, falloff on sides
	# Peak tier gets 40-50%, adjacent tiers get 20-25% each, others get remaining
	match tier_num:
		0:
			distribution = {"Q0": 60.0, "Q1": 25.0, "Q2": 10.0, "Q3": 3.0, "Q4": 1.5, "Q5": 0.5}
		1:
			distribution = {"Q0": 20.0, "Q1": 45.0, "Q2": 25.0, "Q3": 7.0, "Q4": 2.5, "Q5": 0.5}
		2:
			distribution = {"Q0": 5.0, "Q1": 15.0, "Q2": 40.0, "Q3": 28.0, "Q4": 9.0, "Q5": 3.0}
		3:
			distribution = {"Q0": 2.0, "Q1": 8.0, "Q2": 20.0, "Q3": 42.0, "Q4": 20.0, "Q5": 8.0}
		4:
			distribution = {"Q0": 0.5, "Q1": 2.5, "Q2": 10.0, "Q3": 22.0, "Q4": 45.0, "Q5": 20.0}
		5:
			distribution = {"Q0": 0.5, "Q1": 1.5, "Q2": 5.0, "Q3": 10.0, "Q4": 23.0, "Q5": 60.0}
		_:
			# Default to Q2 distribution
			distribution = {"Q0": 5.0, "Q1": 15.0, "Q2": 40.0, "Q3": 28.0, "Q4": 9.0, "Q5": 3.0}

	# Add some randomness (±3% variation)
	for tier in distribution.keys():
		var variation = randf_range(-3.0, 3.0)
		distribution[tier] = max(0.0, distribution[tier] + variation)

	# Normalize to ensure total = 100%
	var total = 0.0
	for tier in distribution.keys():
		total += distribution[tier]

	if total > 0:
		for tier in distribution.keys():
			distribution[tier] = (distribution[tier] / total) * 100.0

	return distribution

func mark_as_scanned(distribution: Dictionary, new_scanner_level: int):
	"""Mark asteroid as scanned with scanner data
	If already scanned with better scanner, don't downgrade data
	"""
	# Only update if new scanner is better or equal
	if new_scanner_level >= scanner_level:
		is_scanned = true
		scan_data = distribution.duplicate()
		scanner_level = new_scanner_level
		scan_timestamp = Time.get_unix_time_from_system()

		# Also set metadata for compatibility
		set_meta("scanned", true)
		set_meta("scan_data", distribution)
		set_meta("scanner_level", new_scanner_level)

		# Emit signal for UI/History updates
		ore_scanned.emit(ore_name, scanner_level)

		print("Asteroid scanned: %s (Level Mk%d)" % [ore_name, scanner_level])
	else:
		print("Asteroid already scanned with better scanner (Mk%d). Current: Mk%d" % [scanner_level, new_scanner_level])

func get_scan_data() -> Dictionary:
	"""Get stored scan data if available"""
	if is_scanned:
		return scan_data.duplicate()
	else:
		# Return live distribution if not scanned
		return get_quality_distribution()

func is_ore_scanned() -> bool:
	"""Check if ore has been scanned"""
	return is_scanned

func get_scanner_level() -> int:
	"""Get scanner level used to scan this ore"""
	return scanner_level
