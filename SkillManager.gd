extends Node

# ============================================================================
# SKILL MANAGER - Global Skill System
# ============================================================================
# Handles all skill progression, datacard ownership, and efficiency calculations
# Cross-references with Module System, Mining, Combat, and Trading

# Skill categories
enum SkillCategory {
	MINING,
	REFINING,
	COMBAT,
	TRADING,
	ENGINEERING,
	NAVIGATION,
	AUTOMINER_AI  # Separate skill pool for Autominer Chips
}

# Skill data structure
class SkillData:
	var skill_name: String = ""
	var category: SkillCategory = SkillCategory.MINING
	var current_level: int = 0  # 0-10
	var current_xp: float = 0.0
	var datacard_owned: bool = false
	var datacard_cost: int = 0

	func _init(name: String, cat: SkillCategory, cost: int):
		skill_name = name
		category = cat
		datacard_cost = cost
		current_level = 0
		current_xp = 0.0
		datacard_owned = false

	func get_xp_required_for_next_level() -> float:
		# Exponential scaling: 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200
		if current_level >= 10:
			return 0.0  # Max level
		return 100.0 * pow(2, current_level)

	func add_xp(amount: float) -> bool:
		"""Add XP and return true if leveled up"""
		if not datacard_owned:
			# No datacard = no XP gain
			return false

		if current_level >= 10:
			return false  # Max level

		current_xp += amount
		var required = get_xp_required_for_next_level()

		if current_xp >= required:
			current_xp -= required
			current_level += 1
			print("🎉 Skill Level Up! %s is now Level %d" % [skill_name, current_level])
			return true

		return false

# All available skills
var skills: Dictionary = {}

# Skill definitions (name -> SkillData)
func _ready():
	initialize_skills()

func initialize_skills():
	"""Initialize all skill categories and their datacards"""
	# Mining Skills
	skills["mining_laser"] = SkillData.new("Mining Laser Operation", SkillCategory.MINING, 1000)
	skills["mining_efficiency"] = SkillData.new("Mining Efficiency", SkillCategory.MINING, 5000)
	skills["ore_detection"] = SkillData.new("Ore Detection", SkillCategory.MINING, 10000)

	# Refining Skills
	skills["basic_refining"] = SkillData.new("Basic Refining", SkillCategory.REFINING, 20000)
	skills["advanced_refining"] = SkillData.new("Advanced Refining", SkillCategory.REFINING, 50000)
	skills["purity_control"] = SkillData.new("Purity Control", SkillCategory.REFINING, 100000)

	# Combat Skills
	skills["weapon_operation"] = SkillData.new("Weapon Operation", SkillCategory.COMBAT, 15000)
	skills["shield_management"] = SkillData.new("Shield Management", SkillCategory.COMBAT, 25000)

	# Trading Skills
	skills["trading"] = SkillData.new("Trading", SkillCategory.TRADING, 5000)
	skills["negotiation"] = SkillData.new("Negotiation", SkillCategory.TRADING, 30000)

	# Engineering Skills
	skills["module_fitting"] = SkillData.new("Module Fitting", SkillCategory.ENGINEERING, 10000)
	skills["overclocking"] = SkillData.new("Overclocking", SkillCategory.ENGINEERING, 50000)
	skills["thermal_management"] = SkillData.new("Thermal Management", SkillCategory.ENGINEERING, 75000)

	# Navigation Skills
	skills["autopilot"] = SkillData.new("Autopilot", SkillCategory.NAVIGATION, 2000)
	skills["warp_drive"] = SkillData.new("Warp Drive Operation", SkillCategory.NAVIGATION, 100000)

	# Autominer AI Skills (separate pool, no transfer cooldown)
	skills["autominer_basic"] = SkillData.new("Autominer Basic AI", SkillCategory.AUTOMINER_AI, 50000)
	skills["autominer_advanced"] = SkillData.new("Autominer Advanced AI", SkillCategory.AUTOMINER_AI, 250000)
	skills["autominer_elite"] = SkillData.new("Autominer Elite AI", SkillCategory.AUTOMINER_AI, 500000)

# ============================================================================
# SKILL EFFICIENCY CALCULATIONS
# ============================================================================

func calculate_module_efficiency(module_tier: int, skill_name: String) -> Dictionary:
	"""
	Calculate efficiency modifiers for a module based on skill level
	Returns: {
		"output": float (0.2 - 1.25),
		"energy_mult": float (1.0 - 2.5),
		"cpu_mult": float (1.0 - 2.5),
		"effective_tier": int (modified tier)
	}
	"""
	var efficiency = {
		"output": 1.0,
		"energy_mult": 1.0,
		"cpu_mult": 1.0,
		"effective_tier": module_tier
	}

	# Check if skill exists
	if not skills.has(skill_name):
		print("⚠️ Warning: Unknown skill '%s', using default efficiency" % skill_name)
		return efficiency

	var skill = skills[skill_name]

	# If datacard not owned, severe penalty
	if not skill.datacard_owned:
		efficiency["output"] = 0.8  # 80% base efficiency without datacard
		efficiency["energy_mult"] = 1.5
		efficiency["cpu_mult"] = 1.5
		efficiency["effective_tier"] = max(1, module_tier - 1)  # Tier penalty
		return efficiency

	# Calculate level difference (required = module tier, actual = skill level)
	var required_level = module_tier
	var level_diff = skill.current_level - required_level

	if level_diff < 0:
		# NOOB MALUS: Missing levels
		var malus = abs(level_diff)
		efficiency["output"] = max(0.2, 1.0 - (malus * 0.2))  # -20% per missing level, min 20%
		efficiency["energy_mult"] = 1.0 + (malus * 0.5)  # +50% energy per missing level
		efficiency["cpu_mult"] = 1.0 + (malus * 0.5)  # +50% CPU per missing level
		efficiency["effective_tier"] = max(1, module_tier - 1)  # Tier penalty

	elif level_diff > 0:
		# MASTER BONUS: Extra levels
		var bonus = min(level_diff, 5)  # Cap at 5 extra levels
		efficiency["output"] = 1.0 + (bonus * 0.05)  # +5% per extra level, max +25%
		efficiency["energy_mult"] = max(0.75, 1.0 - (bonus * 0.05))  # -5% energy per level, min 75%
		efficiency["cpu_mult"] = max(0.75, 1.0 - (bonus * 0.05))  # -5% CPU per level, min 75%
		# No tier bonus, keep same tier

	return efficiency

func get_mining_xp_multiplier(skill_name: String) -> float:
	"""Calculate XP gain multiplier for mining activities"""
	if not skills.has(skill_name):
		return 0.0

	var skill = skills[skill_name]
	if not skill.datacard_owned:
		return 0.0  # No XP without datacard

	# Base XP multiplier (could be modified by other factors)
	return 1.0

# ============================================================================
# DATACARD SHOP INTEGRATION
# ============================================================================

func purchase_datacard(skill_name: String, credits: int) -> bool:
	"""Attempt to purchase a datacard with credits"""
	if not skills.has(skill_name):
		print("❌ Unknown skill: %s" % skill_name)
		return false

	var skill = skills[skill_name]

	if skill.datacard_owned:
		print("❌ Already own datacard for: %s" % skill_name)
		return false

	if credits < skill.datacard_cost:
		print("❌ Insufficient credits. Need %d, have %d" % [skill.datacard_cost, credits])
		return false

	# Purchase successful
	skill.datacard_owned = true
	print("✅ Purchased datacard: %s for %d credits" % [skill_name, skill.datacard_cost])
	return true

# ============================================================================
# XP GAIN TRACKING
# ============================================================================

func add_mining_xp(skill_name: String, base_xp: float):
	"""Add XP from mining activity"""
	if not skills.has(skill_name):
		return

	var multiplier = get_mining_xp_multiplier(skill_name)
	var final_xp = base_xp * multiplier

	if final_xp > 0:
		var leveled_up = skills[skill_name].add_xp(final_xp)
		if leveled_up:
			# Emit signal or trigger event (for UI updates)
			pass

# ============================================================================
# SAVE/LOAD INTEGRATION
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export all skill data for saving"""
	var save_data = {}

	for skill_name in skills:
		var skill = skills[skill_name]
		save_data[skill_name] = {
			"level": skill.current_level,
			"xp": skill.current_xp,
			"datacard_owned": skill.datacard_owned
		}

	return save_data

func load_save_data(save_data: Dictionary):
	"""Import skill data from save file"""
	for skill_name in save_data:
		if skills.has(skill_name):
			var data = save_data[skill_name]
			var skill = skills[skill_name]
			skill.current_level = data.get("level", 0)
			skill.current_xp = data.get("xp", 0.0)
			skill.datacard_owned = data.get("datacard_owned", false)
		else:
			print("⚠️ Warning: Unknown skill in save data: %s" % skill_name)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_skill_info(skill_name: String) -> Dictionary:
	"""Get detailed information about a skill"""
	if not skills.has(skill_name):
		return {}

	var skill = skills[skill_name]
	return {
		"name": skill.skill_name,
		"category": skill.category,
		"level": skill.current_level,
		"xp": skill.current_xp,
		"xp_required": skill.get_xp_required_for_next_level(),
		"datacard_owned": skill.datacard_owned,
		"datacard_cost": skill.datacard_cost
	}

func get_all_skills_by_category(category: SkillCategory) -> Array:
	"""Get all skills in a specific category"""
	var result = []
	for skill_name in skills:
		var skill = skills[skill_name]
		if skill.category == category:
			result.append({
				"id": skill_name,
				"info": get_skill_info(skill_name)
			})
	return result

func reset_all_skills():
	"""Reset all skills (for testing/debugging)"""
	for skill_name in skills:
		var skill = skills[skill_name]
		skill.current_level = 0
		skill.current_xp = 0.0
		skill.datacard_owned = false
	print("🔄 All skills reset")
