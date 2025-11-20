extends Node

# ============================================================================
# CRAFTING SYSTEM - Production Chain Management
# ============================================================================
# Full production chain: Ore → Mineral → Pure Mineral → Components → Modules → Items
# Integrates with RefinerySystem for quality gates
# Cross-references with SkillManager for efficiency bonuses

signal crafting_started(recipe_id: String, quantity: int)
signal crafting_progress(recipe_id: String, progress: float)
signal crafting_complete(recipe_id: String, result: Dictionary)
signal crafting_failed(recipe_id: String, reason: String)
signal materials_insufficient(recipe_id: String, missing: Dictionary)

# Production tier levels
enum ProductionTier {
	TIER_0_ORE = 0,           # Raw ore (mined)
	TIER_1_MINERAL = 1,       # Refined minerals (standard quality)
	TIER_2_PURE_MINERAL = 2,  # Pure minerals (high quality)
	TIER_3_COMPONENT = 3,     # Basic components
	TIER_4_COMPLEX = 4,       # Complex components
	TIER_5_MODULE = 5,        # Ship modules
	TIER_6_ITEM = 6           # Final items (ships, weapons, etc.)
}

# Recipe data structure
class CraftingRecipe:
	var recipe_id: String = ""
	var recipe_name: String = ""
	var production_tier: ProductionTier = ProductionTier.TIER_3_COMPONENT

	# Input requirements
	var required_materials: Dictionary = {}  # material_id -> amount
	var required_quality: int = 0  # 0 = standard, 1 = pure (from RefinerySystem)

	# Output
	var output_id: String = ""
	var output_amount: float = 1.0
	var output_quality: int = 0

	# Production requirements
	var crafting_time: float = 10.0  # Seconds
	var energy_cost: float = 100.0   # Energy units
	var skill_required: String = ""  # e.g., "Engineering"
	var min_skill_level: int = 0

	# Station requirements
	var requires_station: bool = false
	var required_station_type: String = ""  # e.g., "refinery", "factory"

	func _init(id: String, name: String, tier: ProductionTier):
		recipe_id = id
		recipe_name = name
		production_tier = tier

	func get_info() -> Dictionary:
		return {
			"recipe_id": recipe_id,
			"recipe_name": recipe_name,
			"tier": ProductionTier.keys()[production_tier],
			"materials": required_materials,
			"required_quality": required_quality,
			"output_id": output_id,
			"output_amount": output_amount,
			"crafting_time": crafting_time,
			"energy_cost": energy_cost,
			"skill": skill_required,
			"min_level": min_skill_level
		}

# Crafting job structure
class CraftingJob:
	var job_id: String = ""
	var recipe: CraftingRecipe
	var quantity: int = 1
	var progress: float = 0.0
	var is_complete: bool = false
	var efficiency_multiplier: float = 1.0

	func _init(id: String, r: CraftingRecipe, qty: int = 1):
		job_id = id
		recipe = r
		quantity = qty

	func update_progress(delta: float) -> float:
		"""Update progress, returns progress percent (0.0-1.0)"""
		var effective_time = recipe.crafting_time / efficiency_multiplier
		progress += delta

		if progress >= effective_time:
			is_complete = true
			return 1.0

		return progress / effective_time

# Recipe database
var recipe_database: Dictionary = {}  # recipe_id -> CraftingRecipe

# Active crafting jobs (queue)
var crafting_queue: Array[CraftingJob] = []
var max_concurrent_jobs: int = 1  # Can be upgraded

# Player inventory reference (will be set from outside)
var player_inventory: Dictionary = {}

func _ready():
	print("🔧 Crafting System initialized")
	initialize_recipes()

func _process(delta):
	process_crafting_queue(delta)

# ============================================================================
# RECIPE DATABASE INITIALIZATION
# ============================================================================

func initialize_recipes():
	"""Initialize all crafting recipes"""

	# ========================================================================
	# TIER 1: ORE → MINERAL (Refining)
	# ========================================================================
	# This is handled by RefinerySystem, not here

	# ========================================================================
	# TIER 2: MINERAL → PURE MINERAL (Purification)
	# ========================================================================
	# This is also handled by RefinerySystem

	# ========================================================================
	# TIER 3: BASIC COMPONENTS
	# ========================================================================

	# Metal Plates (from refined minerals)
	var recipe_plates = CraftingRecipe.new("component_metal_plates", "Metal Plates", ProductionTier.TIER_3_COMPONENT)
	recipe_plates.required_materials = {"mineral_iron": 100.0}
	recipe_plates.required_quality = 0  # Standard quality OK
	recipe_plates.output_id = "component_metal_plates"
	recipe_plates.output_amount = 50.0
	recipe_plates.crafting_time = 30.0
	recipe_plates.energy_cost = 50.0
	recipe_plates.skill_required = "Engineering"
	recipe_plates.min_skill_level = 1
	register_recipe(recipe_plates)

	# Wiring (from copper)
	var recipe_wiring = CraftingRecipe.new("component_wiring", "Electrical Wiring", ProductionTier.TIER_3_COMPONENT)
	recipe_wiring.required_materials = {"mineral_copper": 50.0}
	recipe_wiring.required_quality = 0
	recipe_wiring.output_id = "component_wiring"
	recipe_wiring.output_amount = 100.0
	recipe_wiring.crafting_time = 20.0
	recipe_wiring.energy_cost = 30.0
	recipe_wiring.skill_required = "Engineering"
	recipe_wiring.min_skill_level = 1
	register_recipe(recipe_wiring)

	# Circuit Boards (from pure minerals)
	var recipe_circuits = CraftingRecipe.new("component_circuit_board", "Circuit Board", ProductionTier.TIER_3_COMPONENT)
	recipe_circuits.required_materials = {
		"mineral_copper_pure": 20.0,  # REQUIRES PURE
		"mineral_silicon_pure": 10.0
	}
	recipe_circuits.required_quality = 1  # Pure quality required
	recipe_circuits.output_id = "component_circuit_board"
	recipe_circuits.output_amount = 10.0
	recipe_circuits.crafting_time = 60.0
	recipe_circuits.energy_cost = 100.0
	recipe_circuits.skill_required = "Engineering"
	recipe_circuits.min_skill_level = 2
	register_recipe(recipe_circuits)

	# Hydraulics
	var recipe_hydraulics = CraftingRecipe.new("component_hydraulics", "Hydraulic System", ProductionTier.TIER_3_COMPONENT)
	recipe_hydraulics.required_materials = {
		"mineral_iron": 80.0,
		"mineral_aluminum": 40.0
	}
	recipe_hydraulics.required_quality = 0
	recipe_hydraulics.output_id = "component_hydraulics"
	recipe_hydraulics.output_amount = 5.0
	recipe_hydraulics.crafting_time = 45.0
	recipe_hydraulics.energy_cost = 80.0
	recipe_hydraulics.skill_required = "Engineering"
	recipe_hydraulics.min_skill_level = 2
	register_recipe(recipe_hydraulics)

	# ========================================================================
	# TIER 4: COMPLEX COMPONENTS
	# ========================================================================

	# Compressor (from components + minerals)
	var recipe_compressor = CraftingRecipe.new("component_compressor", "Cargo Compressor", ProductionTier.TIER_4_COMPLEX)
	recipe_compressor.required_materials = {
		"component_metal_plates": 20.0,
		"component_hydraulics": 5.0,
		"mineral_titanium": 50.0
	}
	recipe_compressor.required_quality = 0
	recipe_compressor.output_id = "component_compressor"
	recipe_compressor.output_amount = 1.0
	recipe_compressor.crafting_time = 120.0
	recipe_compressor.energy_cost = 200.0
	recipe_compressor.skill_required = "Engineering"
	recipe_compressor.min_skill_level = 3
	recipe_compressor.requires_station = true
	recipe_compressor.required_station_type = "factory"
	register_recipe(recipe_compressor)

	# Quantum Core (high-tier, requires pure materials)
	var recipe_quantum = CraftingRecipe.new("component_quantum_core", "Quantum Core", ProductionTier.TIER_4_COMPLEX)
	recipe_quantum.required_materials = {
		"component_circuit_board": 10.0,
		"mineral_exotic_pure": 5.0,
		"mineral_platinum_pure": 20.0
	}
	recipe_quantum.required_quality = 1  # Pure required
	recipe_quantum.output_id = "component_quantum_core"
	recipe_quantum.output_amount = 1.0
	recipe_quantum.crafting_time = 300.0
	recipe_quantum.energy_cost = 500.0
	recipe_quantum.skill_required = "Engineering"
	recipe_quantum.min_skill_level = 5
	recipe_quantum.requires_station = true
	recipe_quantum.required_station_type = "advanced_factory"
	register_recipe(recipe_quantum)

	# Shield Emitter
	var recipe_shield = CraftingRecipe.new("component_shield_emitter", "Shield Emitter", ProductionTier.TIER_4_COMPLEX)
	recipe_shield.required_materials = {
		"component_circuit_board": 5.0,
		"component_wiring": 50.0,
		"mineral_titanium_pure": 30.0
	}
	recipe_shield.required_quality = 1
	recipe_shield.output_id = "component_shield_emitter"
	recipe_shield.output_amount = 1.0
	recipe_shield.crafting_time = 180.0
	recipe_shield.energy_cost = 300.0
	recipe_shield.skill_required = "Engineering"
	recipe_shield.min_skill_level = 4
	recipe_shield.requires_station = true
	recipe_shield.required_station_type = "factory"
	register_recipe(recipe_shield)

	# ========================================================================
	# TIER 5: MODULES
	# ========================================================================

	# Mining Laser Module
	var recipe_mining_module = CraftingRecipe.new("module_mining_laser_t1", "Mining Laser T1", ProductionTier.TIER_5_MODULE)
	recipe_mining_module.required_materials = {
		"component_metal_plates": 30.0,
		"component_wiring": 50.0,
		"component_circuit_board": 3.0,
		"mineral_titanium": 100.0
	}
	recipe_mining_module.required_quality = 0
	recipe_mining_module.output_id = "module_mining_laser_t1"
	recipe_mining_module.output_amount = 1.0
	recipe_mining_module.crafting_time = 240.0
	recipe_mining_module.energy_cost = 400.0
	recipe_mining_module.skill_required = "Mining"
	recipe_mining_module.min_skill_level = 3
	recipe_mining_module.requires_station = true
	recipe_mining_module.required_station_type = "factory"
	register_recipe(recipe_mining_module)

	# Shield Module
	var recipe_shield_module = CraftingRecipe.new("module_shield_t1", "Shield Generator T1", ProductionTier.TIER_5_MODULE)
	recipe_shield_module.required_materials = {
		"component_shield_emitter": 2.0,
		"component_circuit_board": 5.0,
		"component_metal_plates": 50.0,
		"mineral_titanium_pure": 50.0
	}
	recipe_shield_module.required_quality = 1  # Pure materials for high-tier
	recipe_shield_module.output_id = "module_shield_t1"
	recipe_shield_module.output_amount = 1.0
	recipe_shield_module.crafting_time = 360.0
	recipe_shield_module.energy_cost = 600.0
	recipe_shield_module.skill_required = "Engineering"
	recipe_shield_module.min_skill_level = 5
	recipe_shield_module.requires_station = true
	recipe_shield_module.required_station_type = "advanced_factory"
	register_recipe(recipe_shield_module)

	# ========================================================================
	# TIER 6: FINAL ITEMS
	# ========================================================================

	# Small Mining Ship
	var recipe_mining_ship = CraftingRecipe.new("ship_miner_small", "Small Mining Vessel", ProductionTier.TIER_6_ITEM)
	recipe_mining_ship.required_materials = {
		"module_mining_laser_t1": 1.0,
		"component_metal_plates": 200.0,
		"component_hydraulics": 10.0,
		"component_circuit_board": 20.0,
		"mineral_titanium": 500.0,
		"mineral_iron": 1000.0
	}
	recipe_mining_ship.required_quality = 0
	recipe_mining_ship.output_id = "ship_miner_small"
	recipe_mining_ship.output_amount = 1.0
	recipe_mining_ship.crafting_time = 1800.0  # 30 minutes
	recipe_mining_ship.energy_cost = 2000.0
	recipe_mining_ship.skill_required = "Engineering"
	recipe_mining_ship.min_skill_level = 6
	recipe_mining_ship.requires_station = true
	recipe_mining_ship.required_station_type = "shipyard"
	register_recipe(recipe_mining_ship)

	# Ammunition (basic)
	var recipe_ammo = CraftingRecipe.new("ammo_ballistic_basic", "Ballistic Ammunition", ProductionTier.TIER_6_ITEM)
	recipe_ammo.required_materials = {
		"mineral_iron": 50.0,
		"mineral_copper": 20.0
	}
	recipe_ammo.required_quality = 0
	recipe_ammo.output_id = "ammo_ballistic_basic"
	recipe_ammo.output_amount = 100.0
	recipe_ammo.crafting_time = 30.0
	recipe_ammo.energy_cost = 50.0
	recipe_ammo.skill_required = "Combat"
	recipe_ammo.min_skill_level = 1
	register_recipe(recipe_ammo)

	print("✅ Loaded %d crafting recipes" % recipe_database.size())

func register_recipe(recipe: CraftingRecipe):
	"""Register a recipe in the database"""
	recipe_database[recipe.recipe_id] = recipe

# ============================================================================
# CRAFTING OPERATIONS
# ============================================================================

func can_craft(recipe_id: String, quantity: int = 1) -> Dictionary:
	"""Check if player can craft a recipe"""
	var result = {
		"can_craft": false,
		"reason": "",
		"missing_materials": {},
		"missing_quality": false,
		"insufficient_skill": false,
		"needs_station": false
	}

	if not recipe_database.has(recipe_id):
		result["reason"] = "Recipe not found"
		return result

	var recipe = recipe_database[recipe_id]

	# Check skill requirements
	if recipe.skill_required != "" and SkillManager:
		var player_skill_level = SkillManager.get_skill_level(recipe.skill_required)
		if player_skill_level < recipe.min_skill_level:
			result["reason"] = "Insufficient skill level"
			result["insufficient_skill"] = true
			return result

	# Check station requirements
	if recipe.requires_station:
		# TODO: Check if player is at required station type
		# For now, assume player is at correct station
		pass

	# Check materials
	for material_id in recipe.required_materials:
		var required = recipe.required_materials[material_id] * quantity
		var available = player_inventory.get(material_id, 0.0)

		if available < required:
			result["missing_materials"][material_id] = required - available

	# Check quality requirements (integrate with RefinerySystem)
	if recipe.required_quality > 0:
		# Check if materials are pure quality
		for material_id in recipe.required_materials:
			if not material_id.ends_with("_pure"):
				result["reason"] = "Pure materials required"
				result["missing_quality"] = true
				return result

	# Check if any missing materials
	if result["missing_materials"].size() > 0:
		result["reason"] = "Insufficient materials"
		return result

	# All checks passed
	result["can_craft"] = true
	return result

func start_crafting(recipe_id: String, quantity: int = 1) -> bool:
	"""Start a crafting job"""

	# Check if can craft
	var check = can_craft(recipe_id, quantity)
	if not check["can_craft"]:
		emit_signal("crafting_failed", recipe_id, check["reason"])
		if check["missing_materials"].size() > 0:
			emit_signal("materials_insufficient", recipe_id, check["missing_materials"])
		print("❌ Cannot craft %s: %s" % [recipe_id, check["reason"]])
		return false

	# Check queue capacity
	if crafting_queue.size() >= max_concurrent_jobs:
		emit_signal("crafting_failed", recipe_id, "Queue full")
		print("❌ Crafting queue full (max %d jobs)" % max_concurrent_jobs)
		return false

	var recipe = recipe_database[recipe_id]

	# Consume materials
	for material_id in recipe.required_materials:
		var required = recipe.required_materials[material_id] * quantity
		player_inventory[material_id] -= required

	# Create crafting job
	var job_id = "job_%s_%d" % [recipe_id, Time.get_ticks_msec()]
	var job = CraftingJob.new(job_id, recipe, quantity)

	# Calculate efficiency from skill system
	if recipe.skill_required != "" and SkillManager:
		var efficiency_data = SkillManager.calculate_module_efficiency(recipe.min_skill_level, recipe.skill_required)
		job.efficiency_multiplier = efficiency_data["output"]

	crafting_queue.append(job)

	emit_signal("crafting_started", recipe_id, quantity)
	print("🔧 Crafting started: %s x%d (%.0fs)" % [recipe.recipe_name, quantity, recipe.crafting_time])

	return true

func process_crafting_queue(delta: float):
	"""Process all active crafting jobs"""
	var completed_jobs = []

	for i in range(crafting_queue.size()):
		var job = crafting_queue[i]

		# Update progress
		var progress_percent = job.update_progress(delta)
		emit_signal("crafting_progress", job.recipe.recipe_id, progress_percent)

		# Check for completion
		if job.is_complete:
			completed_jobs.append(i)

			# Process completion
			var result = complete_crafting(job)
			emit_signal("crafting_complete", job.recipe.recipe_id, result)

	# Remove completed jobs (reverse order to preserve indices)
	for i in range(completed_jobs.size() - 1, -1, -1):
		crafting_queue.remove_at(completed_jobs[i])

func complete_crafting(job: CraftingJob) -> Dictionary:
	"""Complete a crafting job and give output"""
	var recipe = job.recipe

	# Calculate output amount (with efficiency bonus)
	var output_amount = recipe.output_amount * job.quantity * job.efficiency_multiplier

	# Add to inventory
	if player_inventory.has(recipe.output_id):
		player_inventory[recipe.output_id] += output_amount
	else:
		player_inventory[recipe.output_id] = output_amount

	print("✅ Crafting complete: %s x%.0f" % [recipe.recipe_name, output_amount])

	# Award XP
	if recipe.skill_required != "" and SkillManager:
		var xp_per_craft = 50 * recipe.min_skill_level
		SkillManager.add_xp(recipe.skill_required, xp_per_craft * job.quantity)

	return {
		"recipe_id": recipe.recipe_id,
		"output_id": recipe.output_id,
		"output_amount": output_amount,
		"quality": recipe.output_quality,
		"efficiency": job.efficiency_multiplier
	}

func cancel_crafting(job_index: int) -> bool:
	"""Cancel a crafting job and refund materials (50%)"""
	if job_index < 0 or job_index >= crafting_queue.size():
		return false

	var job = crafting_queue[job_index]
	var recipe = job.recipe

	# Refund 50% of materials
	for material_id in recipe.required_materials:
		var refund = (recipe.required_materials[material_id] * job.quantity) * 0.5
		if player_inventory.has(material_id):
			player_inventory[material_id] += refund
		else:
			player_inventory[material_id] = refund

	crafting_queue.remove_at(job_index)
	print("🚫 Crafting cancelled: %s (50%% materials refunded)" % recipe.recipe_name)

	return true

# ============================================================================
# BATCH CRAFTING
# ============================================================================

func craft_batch(recipe_id: String, quantity: int) -> int:
	"""Craft multiple items (returns number successfully queued)"""
	var crafted = 0

	for i in range(quantity):
		if start_crafting(recipe_id, 1):
			crafted += 1
		else:
			break  # Stop if failed

	return crafted

func craft_all_available(recipe_id: String) -> int:
	"""Craft maximum possible amount based on available materials"""
	if not recipe_database.has(recipe_id):
		return 0

	var recipe = recipe_database[recipe_id]

	# Calculate max craftable
	var max_craftable = 999999
	for material_id in recipe.required_materials:
		var required = recipe.required_materials[material_id]
		var available = player_inventory.get(material_id, 0.0)
		var possible = int(available / required)
		max_craftable = min(max_craftable, possible)

	if max_craftable <= 0:
		return 0

	return craft_batch(recipe_id, max_craftable)

# ============================================================================
# RECIPE QUERIES
# ============================================================================

func get_recipe(recipe_id: String) -> Dictionary:
	"""Get recipe information"""
	if not recipe_database.has(recipe_id):
		return {}

	return recipe_database[recipe_id].get_info()

func get_recipes_by_tier(tier: ProductionTier) -> Array:
	"""Get all recipes for a production tier"""
	var results = []
	for recipe_id in recipe_database:
		var recipe = recipe_database[recipe_id]
		if recipe.production_tier == tier:
			results.append(recipe.get_info())
	return results

func get_recipes_by_skill(skill_name: String) -> Array:
	"""Get all recipes for a skill"""
	var results = []
	for recipe_id in recipe_database:
		var recipe = recipe_database[recipe_id]
		if recipe.skill_required == skill_name:
			results.append(recipe.get_info())
	return results

func get_available_recipes() -> Array:
	"""Get all recipes player can currently craft"""
	var results = []
	for recipe_id in recipe_database:
		var check = can_craft(recipe_id, 1)
		if check["can_craft"]:
			results.append(recipe_database[recipe_id].get_info())
	return results

func get_craftable_amount(recipe_id: String) -> int:
	"""Get maximum craftable amount for a recipe"""
	if not recipe_database.has(recipe_id):
		return 0

	var recipe = recipe_database[recipe_id]
	var max_craftable = 999999

	for material_id in recipe.required_materials:
		var required = recipe.required_materials[material_id]
		var available = player_inventory.get(material_id, 0.0)
		var possible = int(available / required)
		max_craftable = min(max_craftable, possible)

	return max(0, max_craftable)

# ============================================================================
# SAVE/LOAD INTEGRATION
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export crafting system data for saving"""
	var jobs_data = []
	for job in crafting_queue:
		jobs_data.append({
			"job_id": job.job_id,
			"recipe_id": job.recipe.recipe_id,
			"quantity": job.quantity,
			"progress": job.progress,
			"efficiency": job.efficiency_multiplier
		})

	return {
		"crafting_queue": jobs_data
	}

func load_save_data(data: Dictionary):
	"""Import crafting system data from save file"""
	crafting_queue.clear()

	if data.has("crafting_queue"):
		for job_data in data["crafting_queue"]:
			var recipe_id = job_data["recipe_id"]
			if recipe_database.has(recipe_id):
				var recipe = recipe_database[recipe_id]
				var job = CraftingJob.new(job_data["job_id"], recipe, job_data["quantity"])
				job.progress = job_data["progress"]
				job.efficiency_multiplier = job_data.get("efficiency", 1.0)
				crafting_queue.append(job)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_queue_info() -> Array:
	"""Get information about current crafting queue"""
	var results = []
	for job in crafting_queue:
		var effective_time = job.recipe.crafting_time / job.efficiency_multiplier
		results.append({
			"job_id": job.job_id,
			"recipe_name": job.recipe.recipe_name,
			"quantity": job.quantity,
			"progress": job.progress / effective_time,
			"time_remaining": effective_time - job.progress
		})
	return results

func set_player_inventory(inventory: Dictionary):
	"""Set reference to player inventory"""
	player_inventory = inventory

func clear_queue():
	"""Clear all crafting jobs (for emergencies)"""
	crafting_queue.clear()
	print("🗑️ Crafting queue cleared")
