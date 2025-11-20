extends Node

# ============================================================================
# AUTOMINER CHIP SYSTEM
# ============================================================================
# Manages Autominer CPU Chips for fleet automation
# Features separate skill pool from player (AUTOMINER_AI category)
# NO transfer cooldown - instant installation/removal
# Each chip can control limited number of modules

signal chip_created(chip_id: String, tier: int)
signal chip_installed(chip_id: String, ship_id: String)
signal chip_removed(chip_id: String, ship_id: String)
signal chip_upgraded(chip_id: String, new_tier: int)
signal mining_complete(chip_id: String, ore_id: String, amount: float)

# Chip tiers with escalating costs
enum ChipTier {
	BASIC = 1,     # 1 module, dumb AI
	STANDARD = 2,  # 2 modules, basic AI
	ADVANCED = 3,  # 3 modules, smart AI
	ELITE = 4,     # 4 modules, very smart AI
	QUANTUM = 5    # 5 modules, perfect AI
}

# AI Intelligence levels
enum AIIntelligence {
	DUMB,      # Random targeting, no optimization
	BASIC,     # Closest ore first
	SMART,     # Quality-aware, distance optimized
	VERY_SMART, # Advanced pathfinding, multi-ore planning
	PERFECT    # Optimal routes, predictive targeting
}

# Production costs (exponential scaling)
const PRODUCTION_COSTS = {
	ChipTier.BASIC: {
		"credits": 50000,
		"mineral_silicon": 100.0,
		"mineral_copper": 50.0
	},
	ChipTier.STANDARD: {
		"credits": 150000,
		"mineral_silicon": 300.0,
		"mineral_copper": 150.0,
		"mineral_gold": 20.0
	},
	ChipTier.ADVANCED: {
		"credits": 500000,
		"mineral_silicon": 1000.0,
		"mineral_gold": 100.0,
		"mineral_platinum": 50.0
	},
	ChipTier.ELITE: {
		"credits": 2000000,
		"mineral_silicon": 3000.0,
		"mineral_platinum": 200.0,
		"component_quantum_core": 10.0
	},
	ChipTier.QUANTUM: {
		"credits": 10000000,
		"mineral_platinum": 1000.0,
		"component_quantum_core": 50.0,
		"component_ai_matrix": 20.0
	}
}

# Module limits per tier
const MODULE_LIMITS = {
	ChipTier.BASIC: 1,
	ChipTier.STANDARD: 2,
	ChipTier.ADVANCED: 3,
	ChipTier.ELITE: 4,
	ChipTier.QUANTUM: 5
}

# Power draw per tier (energy/tick)
const POWER_DRAW = {
	ChipTier.BASIC: 10.0,
	ChipTier.STANDARD: 25.0,
	ChipTier.ADVANCED: 50.0,
	ChipTier.ELITE: 100.0,
	ChipTier.QUANTUM: 200.0
}

# AI intelligence mapping
const AI_INTELLIGENCE = {
	ChipTier.BASIC: AIIntelligence.DUMB,
	ChipTier.STANDARD: AIIntelligence.BASIC,
	ChipTier.ADVANCED: AIIntelligence.SMART,
	ChipTier.ELITE: AIIntelligence.VERY_SMART,
	ChipTier.QUANTUM: AIIntelligence.PERFECT
}

# Autominer chip data structure
class AutominerChip:
	var chip_id: String = ""
	var tier: ChipTier = ChipTier.BASIC
	var ai_intelligence: AIIntelligence = AIIntelligence.DUMB

	# Skill emulation (separate from player skills)
	var emulated_skill_level: int = 0  # 0-10
	var emulated_skill_xp: float = 0.0

	# Installation state
	var is_installed: bool = false
	var installed_ship_id: String = ""

	# Module control
	var controlled_modules: Array = []  # Module IDs
	var max_modules: int = 1

	# Performance stats
	var total_mined: float = 0.0
	var mining_cycles: int = 0
	var efficiency_rating: float = 0.5  # 0.5 = 50% at level 0

	# Power consumption
	var power_draw: float = 10.0

	func _init(id: String, t: ChipTier):
		chip_id = id
		tier = t
		ai_intelligence = AI_INTELLIGENCE[t]
		max_modules = MODULE_LIMITS[t]
		power_draw = POWER_DRAW[t]
		emulated_skill_level = 0  # Always starts at level 0
		update_efficiency()

	func update_efficiency():
		"""Calculate efficiency based on emulated skill level"""
		if emulated_skill_level == 0:
			efficiency_rating = 0.5  # 50% at level 0
		else:
			# Linear scaling: 50% at L0 → 100% at L10
			efficiency_rating = 0.5 + (emulated_skill_level * 0.05)

	func add_xp(amount: float) -> bool:
		"""Add XP to chip's emulated skill (separate from player)"""
		if emulated_skill_level >= 10:
			return false

		emulated_skill_xp += amount
		var required = 100.0 * pow(2, emulated_skill_level)  # Same progression as SkillManager

		if emulated_skill_xp >= required:
			emulated_skill_xp -= required
			emulated_skill_level += 1
			update_efficiency()
			print("🤖 Autominer Chip Level Up! %s is now Level %d (%.0f%% efficiency)" % [chip_id, emulated_skill_level, efficiency_rating * 100])
			return true

		return false

	func can_control_module() -> bool:
		"""Check if chip can control another module"""
		return controlled_modules.size() < max_modules

	func add_module(module_id: String) -> bool:
		"""Add a module to chip control"""
		if not can_control_module():
			print("❌ Chip at module limit (%d/%d)" % [controlled_modules.size(), max_modules])
			return false

		controlled_modules.append(module_id)
		print("✅ Module %s added to chip control" % module_id)
		return true

	func remove_module(module_id: String) -> bool:
		"""Remove a module from chip control"""
		if module_id in controlled_modules:
			controlled_modules.erase(module_id)
			return true
		return false

	func get_info() -> Dictionary:
		"""Get detailed chip information"""
		return {
			"chip_id": chip_id,
			"tier": tier,
			"tier_name": "Tier %d" % tier,
			"ai_intelligence": AIIntelligence.keys()[ai_intelligence],
			"skill_level": emulated_skill_level,
			"skill_xp": emulated_skill_xp,
			"efficiency": efficiency_rating,
			"is_installed": is_installed,
			"ship_id": installed_ship_id,
			"controlled_modules": controlled_modules.size(),
			"max_modules": max_modules,
			"power_draw": power_draw,
			"total_mined": total_mined,
			"mining_cycles": mining_cycles
		}

# Chip inventory
var chip_inventory: Dictionary = {}  # chip_id -> AutominerChip
var next_chip_id: int = 1

# Ship assignments (ship_id -> chip_id)
var ship_assignments: Dictionary = {}

func _ready():
	print("🤖 Autominer Chip System initialized")

# ============================================================================
# CHIP PRODUCTION
# ============================================================================

func produce_chip(tier: ChipTier, player_resources: Dictionary) -> String:
	"""Produce a new autominer chip (checks resources)"""

	# Check production costs
	var costs = PRODUCTION_COSTS[tier]
	for resource in costs:
		var required = costs[resource]
		var available = player_resources.get(resource, 0.0)

		if available < required:
			print("❌ Insufficient %s: need %.0f, have %.0f" % [resource, required, available])
			return ""

	# Deduct resources (caller must handle this)
	# We just validate here

	# Create chip
	var chip_id = "chip_%04d" % next_chip_id
	next_chip_id += 1

	var chip = AutominerChip.new(chip_id, tier)
	chip_inventory[chip_id] = chip

	emit_signal("chip_created", chip_id, tier)
	print("🏭 Produced Autominer Chip: %s (Tier %d)" % [chip_id, tier])

	return chip_id

func get_production_cost(tier: ChipTier) -> Dictionary:
	"""Get production cost for a specific tier"""
	return PRODUCTION_COSTS[tier].duplicate()

# ============================================================================
# CHIP INSTALLATION (NO COOLDOWN!)
# ============================================================================

func install_chip(chip_id: String, ship_id: String) -> bool:
	"""Install chip on a ship (instant, no cooldown)"""

	# Validate chip exists
	if not chip_inventory.has(chip_id):
		print("❌ Chip not found: %s" % chip_id)
		return false

	var chip = chip_inventory[chip_id]

	# Check if chip is already installed
	if chip.is_installed:
		print("❌ Chip already installed on %s" % chip.installed_ship_id)
		return false

	# Check if ship already has a chip
	if ship_assignments.has(ship_id):
		print("❌ Ship %s already has chip %s installed" % [ship_id, ship_assignments[ship_id]])
		return false

	# Install chip (INSTANT - no cooldown!)
	chip.is_installed = true
	chip.installed_ship_id = ship_id
	ship_assignments[ship_id] = chip_id

	emit_signal("chip_installed", chip_id, ship_id)
	print("✅ Chip installed: %s → %s (INSTANT)" % [chip_id, ship_id])

	return true

func remove_chip(ship_id: String) -> String:
	"""Remove chip from a ship (instant, no cooldown)"""

	# Check if ship has a chip
	if not ship_assignments.has(ship_id):
		print("❌ Ship %s has no chip installed" % ship_id)
		return ""

	var chip_id = ship_assignments[ship_id]
	var chip = chip_inventory[chip_id]

	# Remove chip (INSTANT - no cooldown!)
	chip.is_installed = false
	chip.installed_ship_id = ""
	chip.controlled_modules.clear()
	ship_assignments.erase(ship_id)

	emit_signal("chip_removed", chip_id, ship_id)
	print("✅ Chip removed: %s from %s (INSTANT)" % [chip_id, ship_id])

	return chip_id

func transfer_chip(from_ship_id: String, to_ship_id: String) -> bool:
	"""Transfer chip between ships (instant, no cooldown)"""

	var chip_id = remove_chip(from_ship_id)
	if chip_id == "":
		return false

	return install_chip(chip_id, to_ship_id)

# ============================================================================
# AI BEHAVIOR LOGIC
# ============================================================================

func get_mining_target(chip_id: String, available_ores: Array, ship_position: Vector2) -> Node2D:
	"""AI logic to select best mining target based on intelligence"""

	if not chip_inventory.has(chip_id):
		return null

	var chip = chip_inventory[chip_id]
	if available_ores.is_empty():
		return null

	match chip.ai_intelligence:
		AIIntelligence.DUMB:
			# Random selection
			return available_ores[randi() % available_ores.size()]

		AIIntelligence.BASIC:
			# Closest ore first
			return get_closest_ore(available_ores, ship_position)

		AIIntelligence.SMART:
			# Quality-aware, distance optimized
			return get_best_quality_distance_ore(available_ores, ship_position)

		AIIntelligence.VERY_SMART:
			# Advanced pathfinding, multi-ore planning
			return get_optimal_route_ore(available_ores, ship_position)

		AIIntelligence.PERFECT:
			# Perfect optimization (predictive)
			return get_perfect_target(available_ores, ship_position, chip)

	return null

func get_closest_ore(ores: Array, position: Vector2) -> Node2D:
	"""Find closest ore"""
	var closest = null
	var min_distance = INF

	for ore in ores:
		if not is_instance_valid(ore):
			continue

		var distance = position.distance_to(ore.global_position)
		if distance < min_distance:
			min_distance = distance
			closest = ore

	return closest

func get_best_quality_distance_ore(ores: Array, position: Vector2) -> Node2D:
	"""Find best ore considering quality and distance"""
	var best_ore = null
	var best_score = -INF

	for ore in ores:
		if not is_instance_valid(ore):
			continue

		var distance = position.distance_to(ore.global_position)
		var quality_value = ore.get("quality_tier", 1) * 100.0  # Higher tier = better

		# Score: quality value - distance penalty
		var score = quality_value - (distance * 0.1)

		if score > best_score:
			best_score = score
			best_ore = ore

	return best_ore

func get_optimal_route_ore(ores: Array, position: Vector2) -> Node2D:
	"""Advanced AI: Plan multi-ore route"""
	# TODO: Implement TSP-like optimization
	return get_best_quality_distance_ore(ores, position)

func get_perfect_target(ores: Array, position: Vector2, chip: AutominerChip) -> Node2D:
	"""Perfect AI: Predictive targeting"""
	# TODO: Implement machine learning / perfect optimization
	return get_optimal_route_ore(ores, position)

# ============================================================================
# XP & PROGRESSION
# ============================================================================

func record_mining_cycle(chip_id: String, ore_id: String, amount: float):
	"""Record completed mining cycle and award XP"""

	if not chip_inventory.has(chip_id):
		return

	var chip = chip_inventory[chip_id]
	chip.total_mined += amount
	chip.mining_cycles += 1

	# Award XP (scaled by amount mined)
	var xp = amount * 0.1  # 0.1 XP per unit
	chip.add_xp(xp)

	emit_signal("mining_complete", chip_id, ore_id, amount)

# ============================================================================
# SAVE/LOAD INTEGRATION
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export chip data for saving"""
	var chips_data = {}

	for chip_id in chip_inventory:
		var chip = chip_inventory[chip_id]
		chips_data[chip_id] = {
			"tier": chip.tier,
			"skill_level": chip.emulated_skill_level,
			"skill_xp": chip.emulated_skill_xp,
			"is_installed": chip.is_installed,
			"ship_id": chip.installed_ship_id,
			"controlled_modules": chip.controlled_modules.duplicate(),
			"total_mined": chip.total_mined,
			"mining_cycles": chip.mining_cycles
		}

	return {
		"chips": chips_data,
		"ship_assignments": ship_assignments.duplicate(),
		"next_chip_id": next_chip_id
	}

func load_save_data(data: Dictionary):
	"""Import chip data from save file"""
	chip_inventory.clear()
	ship_assignments.clear()

	# Restore chips
	if data.has("chips"):
		for chip_id in data["chips"]:
			var chip_data = data["chips"][chip_id]
			var chip = AutominerChip.new(chip_id, chip_data["tier"])
			chip.emulated_skill_level = chip_data["skill_level"]
			chip.emulated_skill_xp = chip_data["skill_xp"]
			chip.is_installed = chip_data["is_installed"]
			chip.installed_ship_id = chip_data["ship_id"]
			chip.controlled_modules = chip_data["controlled_modules"].duplicate()
			chip.total_mined = chip_data["total_mined"]
			chip.mining_cycles = chip_data["mining_cycles"]
			chip.update_efficiency()
			chip_inventory[chip_id] = chip

	# Restore assignments
	if data.has("ship_assignments"):
		ship_assignments = data["ship_assignments"].duplicate()

	next_chip_id = data.get("next_chip_id", 1)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_chip_info(chip_id: String) -> Dictionary:
	"""Get detailed chip information"""
	if not chip_inventory.has(chip_id):
		return {}

	return chip_inventory[chip_id].get_info()

func get_ship_chip(ship_id: String) -> String:
	"""Get chip ID for a ship"""
	return ship_assignments.get(ship_id, "")

func list_all_chips() -> Array:
	"""Get list of all chips"""
	var result = []
	for chip_id in chip_inventory:
		result.append(chip_inventory[chip_id].get_info())
	return result

func get_available_chips() -> Array:
	"""Get list of uninstalled chips"""
	var result = []
	for chip_id in chip_inventory:
		var chip = chip_inventory[chip_id]
		if not chip.is_installed:
			result.append(chip.get_info())
	return result
