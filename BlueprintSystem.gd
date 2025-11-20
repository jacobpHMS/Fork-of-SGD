extends Node
class_name BlueprintSystem
## Manufacturing Chip System - Modular Socket-Based Production
##
## Konzept:
## - Blanko-Chips werden hergestellt und mit Software bespielt
## - Chips haben Datenintegrität (1-100%), bei 0% → neu aufladen
## - Qualitätsstufen (Q0-Q5): Jede Stufe -1 bis -5% Material & Zeit
## - Socket-System: Chips haben Sockel für Kristalle/Module
##   - Effizienz-Kristalle (Material/Zeit Reduktion)
##   - Produktions-Kristalle (Bonus-Eigenschaften)
##   - Produktionsmultiplikator (x2 Output, sehr selten, verbrauchbar)
##
## Usage:
## ```gdscript
## var chip = BlueprintSystem.create_blanko_chip(ChipTier.TIER_3)
## BlueprintSystem.load_software(chip_id, "SOFTWARE_FRIGATE_VENTURE")
## BlueprintSystem.socket_crystal(chip_id, 0, "CRYSTAL_EFFICIENCY_MATERIAL")
## BlueprintSystem.start_manufacturing(chip_id, 1, player_id, station_id)
## ```

# ============================================================================
# SIGNALS
# ============================================================================

signal chip_created(chip_id: String, tier: int)
signal software_loaded(chip_id: String, software_id: String)
signal crystal_socketed(chip_id: String, socket_index: int, crystal_id: String)
signal chip_integrity_depleted(chip_id: String)
signal chip_recharged(chip_id: String, credits_cost: int, materials_cost: Dictionary)
signal manufacturing_started(job_id: String, chip_id: String, runs: int)
signal manufacturing_completed(job_id: String, output_item_id: String, amount: int)
signal multiplier_activated(job_id: String)  # x2 production

# ============================================================================
# ENUMS
# ============================================================================

enum ChipTier {
	TIER_1 = 1,  # 1 Socket, 100 uses
	TIER_2 = 2,  # 2 Sockets, 200 uses
	TIER_3 = 3,  # 3 Sockets, 300 uses
	TIER_4 = 4,  # 4 Sockets, 500 uses
	TIER_5 = 5   # 5 Sockets, 1000 uses
}

enum QualityLevel {
	Q0 = 0,  # Standard (0% bonus)
	Q1 = 1,  # -1% Material & Zeit
	Q2 = 2,  # -2% Material & Zeit
	Q3 = 3,  # -3% Material & Zeit
	Q4 = 4,  # -4% Material & Zeit
	Q5 = 5   # -5% Material & Zeit (Meisterwerk)
}

enum CrystalType {
	EFFICIENCY_MATERIAL,    # -X% Material cost
	EFFICIENCY_TIME,        # -X% Production time
	PRODUCTION_QUALITY,     # Erhöht Quality Level chance
	PRODUCTION_MULTIPLIER   # x2 Output (verbrauchbar)
}

# ============================================================================
# CONSTANTS
# ============================================================================

const SOCKET_COUNT = {
	ChipTier.TIER_1: 1,
	ChipTier.TIER_2: 2,
	ChipTier.TIER_3: 3,
	ChipTier.TIER_4: 4,
	ChipTier.TIER_5: 5
}

const CAPACITY_LIMITS = {
	ChipTier.TIER_1: 100,
	ChipTier.TIER_2: 200,
	ChipTier.TIER_3: 300,
	ChipTier.TIER_4: 500,
	ChipTier.TIER_5: 1000
}

const QUALITY_BONUS = {
	QualityLevel.Q0: 0.0,
	QualityLevel.Q1: 0.01,  # 1%
	QualityLevel.Q2: 0.02,  # 2%
	QualityLevel.Q3: 0.03,  # 3%
	QualityLevel.Q4: 0.04,  # 4%
	QualityLevel.Q5: 0.05   # 5%
}

# Chip Recharge Costs (Station Module Service)
const RECHARGE_CREDITS_COST = {
	ChipTier.TIER_1: 5000,
	ChipTier.TIER_2: 15000,
	ChipTier.TIER_3: 40000,
	ChipTier.TIER_4: 100000,
	ChipTier.TIER_5: 250000
}

const RECHARGE_MATERIALS_COST = {
	ChipTier.TIER_1: {
		"mineral_iron_pure": 10,
		"liquid_coolant": 5,
		"component_storage_chip": 1
	},
	ChipTier.TIER_2: {
		"mineral_iron_pure": 25,
		"mineral_copper_pure": 10,
		"liquid_coolant": 15,
		"component_storage_chip": 2
	},
	ChipTier.TIER_3: {
		"mineral_iron_pure": 50,
		"mineral_copper_pure": 30,
		"mineral_titanium_pure": 15,
		"liquid_coolant": 30,
		"component_storage_chip": 5
	},
	ChipTier.TIER_4: {
		"mineral_iron_pure": 100,
		"mineral_copper_pure": 75,
		"mineral_titanium_pure": 50,
		"mineral_platinum_pure": 25,
		"liquid_coolant": 75,
		"component_storage_chip": 10
	},
	ChipTier.TIER_5: {
		"mineral_iron_pure": 200,
		"mineral_copper_pure": 150,
		"mineral_titanium_pure": 100,
		"mineral_platinum_pure": 75,
		"mineral_gold_pure": 50,
		"liquid_coolant": 150,
		"component_storage_chip": 25
	}
}

# ============================================================================
# STATE
# ============================================================================

## Software database: software_id -> SoftwareData
var software_database: Dictionary = {}

## Manufacturing chips: chip_id -> ManufacturingChip
var chips: Dictionary = {}

## Active manufacturing jobs: job_id -> ManufacturingJob
var active_jobs: Dictionary = {}

## Crystal definitions: crystal_id -> CrystalData
var crystal_database: Dictionary = {}

# ============================================================================
# DATA STRUCTURES
# ============================================================================

class SoftwareData:
	var software_id: String
	var software_name: String
	var output_item_id: String
	var output_amount: int
	var base_materials: Dictionary  # item_id -> amount
	var base_production_time: float  # Seconds
	var min_chip_tier: int = 1

	func _init(p_id: String, p_name: String, p_output: String, p_amount: int,
	           p_materials: Dictionary, p_time: float, p_min_tier: int = 1):
		software_id = p_id
		software_name = p_name
		output_item_id = p_output
		output_amount = p_amount
		base_materials = p_materials
		base_production_time = p_time
		min_chip_tier = p_min_tier

class ManufacturingChip:
	var chip_id: String
	var owner_id: String
	var tier: ChipTier
	var quality_level: QualityLevel
	var data_integrity: float = 100.0  # 0-100%
	var max_capacity: int
	var uses_remaining: int
	var loaded_software: String = ""  # software_id
	var sockets: Array = []  # Array of socket slots (null or crystal_id)

	func _init(p_id: String, p_owner: String, p_tier: ChipTier, p_quality: QualityLevel = QualityLevel.Q0):
		chip_id = p_id
		owner_id = p_owner
		tier = p_tier
		quality_level = p_quality
		max_capacity = CAPACITY_LIMITS[p_tier]
		uses_remaining = max_capacity

		# Initialize sockets
		var socket_count = SOCKET_COUNT[p_tier]
		for i in range(socket_count):
			sockets.append(null)

class CrystalData:
	var crystal_id: String
	var crystal_name: String
	var crystal_type: CrystalType
	var bonus_value: float  # e.g., 0.05 = 5% reduction
	var is_consumable: bool  # True for Multiplier

	func _init(p_id: String, p_name: String, p_type: CrystalType, p_bonus: float, p_consumable: bool = false):
		crystal_id = p_id
		crystal_name = p_name
		crystal_type = p_type
		bonus_value = p_bonus
		is_consumable = p_consumable

class ManufacturingJob:
	var job_id: String
	var chip_id: String
	var output_item_id: String
	var runs: int
	var station_id: String
	var player_id: String
	var start_time: float
	var completion_time: float
	var materials_consumed: Dictionary
	var has_multiplier: bool = false  # x2 output

	func _init(p_job_id: String, p_chip_id: String, p_output: String, p_runs: int,
	           p_station: String, p_player: String, p_duration: float, p_materials: Dictionary):
		job_id = p_job_id
		chip_id = p_chip_id
		output_item_id = p_output
		runs = p_runs
		station_id = p_station
		player_id = p_player
		start_time = Time.get_unix_time_from_system()
		completion_time = start_time + p_duration
		materials_consumed = p_materials

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	print("🔬 BlueprintSystem (Chip-based): Initializing...")
	_load_software_database()
	_load_crystal_database()
	print("✅ BlueprintSystem: Ready")

func _process(_delta: float):
	_process_manufacturing_jobs()

# ============================================================================
# DATABASE LOADING
# ============================================================================

func _load_software_database():
	"""Load manufacturing software database"""
	# Ship Software
	var sw_mining_frigate = SoftwareData.new(
		"SOFTWARE_SHIP_MINING_FRIGATE",
		"Mining Frigate Construction OS",
		"ship_miner_small",
		1,
		{"mineral_iron": 10000, "mineral_copper": 2000, "component_battery": 50},
		3600.0,  # 1 hour
		2  # Requires Tier 2 chip minimum
	)
	software_database["SOFTWARE_SHIP_MINING_FRIGATE"] = sw_mining_frigate

	# Module Software
	var sw_miner = SoftwareData.new(
		"SOFTWARE_MODULE_MINING_LASER",
		"Mining Laser Production OS",
		"module_mining_laser_t1",
		1,
		{"mineral_iron": 100, "component_circuit_board": 5},
		600.0,  # 10 minutes
		1  # Tier 1 OK
	)
	software_database["SOFTWARE_MODULE_MINING_LASER"] = sw_miner

	# Ammunition Software
	var sw_ammo = SoftwareData.new(
		"SOFTWARE_AMMO_BALLISTIC",
		"Ballistic Ammunition OS",
		"ammo_ballistic_basic",
		10000,  # 10000 rounds per run
		{"mineral_iron": 500},
		300.0,  # 5 minutes
		1
	)
	software_database["SOFTWARE_AMMO_BALLISTIC"] = sw_ammo

	# Special Ammunition Software (produces less)
	var sw_ammo_emp = SoftwareData.new(
		"SOFTWARE_AMMO_EMP",
		"EMP Ammunition OS",
		"ammo_emp_round",
		2000,  # 2000 rounds per run (special)
		{"mineral_iron": 300, "mineral_copper": 50, "component_circuit_board": 10},
		450.0,  # 7.5 minutes
		2  # Requires Tier 2
	)
	software_database["SOFTWARE_AMMO_EMP"] = sw_ammo_emp

	var sw_ammo_plasma = SoftwareData.new(
		"SOFTWARE_AMMO_PLASMA",
		"Plasma Ammunition OS",
		"ammo_plasma_bolt",
		1500,  # 1500 rounds per run (special)
		{"mineral_copper": 200, "mineral_titanium": 100, "component_shield_emitter": 20},
		600.0,  # 10 minutes
		3  # Requires Tier 3
	)
	software_database["SOFTWARE_AMMO_PLASMA"] = sw_ammo_plasma

	print("🔬 Loaded %d software packages" % software_database.size())

func _load_crystal_database():
	"""Load crystal/module database (IDs match ItemDatabase)"""
	# Effizienz-Kristalle (Material)
	var crystal_mat_5 = CrystalData.new(
		"crystal_efficiency_material_5",
		"Material Efficiency Crystal I",
		CrystalType.EFFICIENCY_MATERIAL,
		0.05  # 5% reduction
	)
	crystal_database["crystal_efficiency_material_5"] = crystal_mat_5

	var crystal_mat_10 = CrystalData.new(
		"crystal_efficiency_material_10",
		"Material Efficiency Crystal II",
		CrystalType.EFFICIENCY_MATERIAL,
		0.10  # 10% reduction
	)
	crystal_database["crystal_efficiency_material_10"] = crystal_mat_10

	# Effizienz-Kristalle (Zeit)
	var crystal_time_5 = CrystalData.new(
		"crystal_efficiency_time_5",
		"Time Efficiency Crystal I",
		CrystalType.EFFICIENCY_TIME,
		0.05
	)
	crystal_database["crystal_efficiency_time_5"] = crystal_time_5

	var crystal_time_10 = CrystalData.new(
		"crystal_efficiency_time_10",
		"Time Efficiency Crystal II",
		CrystalType.EFFICIENCY_TIME,
		0.10
	)
	crystal_database["crystal_efficiency_time_10"] = crystal_time_10

	# Qualitäts-Kristall
	var crystal_quality = CrystalData.new(
		"crystal_production_quality",
		"Quality Enhancement Matrix",
		CrystalType.PRODUCTION_QUALITY,
		0.15  # 15% chance to increase quality level
	)
	crystal_database["crystal_production_quality"] = crystal_quality

	# Produktionsmultiplikator (SEHR SELTEN)
	var crystal_multiplier = CrystalData.new(
		"crystal_production_multiplier",
		"Production Multiplier Core",
		CrystalType.PRODUCTION_MULTIPLIER,
		2.0,  # x2 output
		true  # Consumable
	)
	crystal_database["crystal_production_multiplier"] = crystal_multiplier

	print("🔬 Loaded %d crystal types" % crystal_database.size())

# ============================================================================
# CHIP MANAGEMENT
# ============================================================================

func create_blanko_chip(tier: ChipTier, owner_id: String, quality: QualityLevel = QualityLevel.Q0) -> String:
	"""Create a blanko manufacturing chip"""
	var chip_id = "CHIP_%d_%s" % [Time.get_unix_time_from_system(), owner_id]
	var chip = ManufacturingChip.new(chip_id, owner_id, tier, quality)

	chips[chip_id] = chip
	chip_created.emit(chip_id, tier)

	print("🔬 Blanko chip created: %s (Tier %d, Q%d, %d sockets, %d uses)" %
	      [chip_id, tier, quality, SOCKET_COUNT[tier], CAPACITY_LIMITS[tier]])

	return chip_id

func load_software(chip_id: String, software_id: String) -> bool:
	"""Load software onto a blanko chip"""
	if not chips.has(chip_id):
		push_error("Chip not found: " + chip_id)
		return false

	if not software_database.has(software_id):
		push_error("Software not found: " + software_id)
		return false

	var chip = chips[chip_id]
	var software = software_database[software_id]

	# Check chip tier requirement
	if chip.tier < software.min_chip_tier:
		push_error("Chip tier too low. Requires Tier %d, have Tier %d" % [software.min_chip_tier, chip.tier])
		return false

	# Check if already loaded
	if chip.loaded_software != "":
		push_error("Chip already has software loaded: " + chip.loaded_software)
		return false

	chip.loaded_software = software_id
	software_loaded.emit(chip_id, software_id)

	print("💾 Software loaded: %s → %s" % [software.software_name, chip_id])

	return true

func recharge_chip(chip_id: String, station_id: String) -> Dictionary:
	"""
	Recharge chip data integrity at station module
	Returns: {success: bool, credits_cost: int, materials_cost: Dictionary, error: String}
	"""
	var result = {
		"success": false,
		"credits_cost": 0,
		"materials_cost": {},
		"error": ""
	}

	if not chips.has(chip_id):
		result.error = "Chip not found"
		return result

	var chip = chips[chip_id]

	# Calculate costs based on tier
	var credits_cost = RECHARGE_CREDITS_COST[chip.tier]
	var materials_cost = RECHARGE_MATERIALS_COST[chip.tier].duplicate()

	result.credits_cost = credits_cost
	result.materials_cost = materials_cost

	# TODO: Verify player has credits
	# TODO: Verify player has materials
	# TODO: Verify station has recharge module installed

	# Recharge chip
	chip.data_integrity = 100.0
	chip.uses_remaining = chip.max_capacity

	# TODO: Deduct credits and materials from player

	chip_recharged.emit(chip_id, credits_cost, materials_cost)

	result.success = true

	print("🔋 Chip recharged: %s (Tier %d) - Cost: %d credits + materials" %
	      [chip_id, chip.tier, credits_cost])

	return result

func reload_chip(chip_id: String, software_id: String) -> bool:
	"""Reload chip with new software (clears old software, does NOT restore integrity)"""
	if not chips.has(chip_id):
		return false

	var chip = chips[chip_id]

	# Clear old software only
	chip.loaded_software = ""

	# Load new software
	return load_software(chip_id, software_id)

func socket_crystal(chip_id: String, socket_index: int, crystal_id: String) -> bool:
	"""Socket a crystal/module into chip"""
	if not chips.has(chip_id):
		return false

	if not crystal_database.has(crystal_id):
		return false

	var chip = chips[chip_id]

	# Validate socket index
	if socket_index < 0 or socket_index >= chip.sockets.size():
		push_error("Invalid socket index: %d (Chip has %d sockets)" % [socket_index, chip.sockets.size()])
		return false

	# Check if socket occupied
	if chip.sockets[socket_index] != null:
		push_error("Socket %d already occupied with: %s" % [socket_index, chip.sockets[socket_index]])
		return false

	# Socket crystal
	chip.sockets[socket_index] = crystal_id
	crystal_socketed.emit(chip_id, socket_index, crystal_id)

	var crystal = crystal_database[crystal_id]
	print("💎 Crystal socketed: %s → Chip %s Socket %d" % [crystal.crystal_name, chip_id, socket_index])

	return true

func unsocket_crystal(chip_id: String, socket_index: int) -> String:
	"""Remove crystal from socket"""
	if not chips.has(chip_id):
		return ""

	var chip = chips[chip_id]

	if socket_index < 0 or socket_index >= chip.sockets.size():
		return ""

	var crystal_id = chip.sockets[socket_index]
	chip.sockets[socket_index] = null

	print("💎 Crystal removed from Socket %d" % socket_index)

	return crystal_id

# ============================================================================
# MANUFACTURING
# ============================================================================

func start_manufacturing(chip_id: String, runs: int, player_id: String, station_id: String) -> String:
	"""Start manufacturing job using chip"""
	if not chips.has(chip_id):
		push_error("Chip not found")
		return ""

	var chip = chips[chip_id]

	if chip.loaded_software == "":
		push_error("Chip has no software loaded")
		return ""

	if chip.uses_remaining <= 0:
		push_error("Chip depleted (0% integrity)")
		chip_integrity_depleted.emit(chip_id)
		return ""

	if not software_database.has(chip.loaded_software):
		return ""

	var software = software_database[chip.loaded_software]

	# Calculate bonuses from quality + crystals
	var material_bonus = _calculate_material_bonus(chip)
	var time_bonus = _calculate_time_bonus(chip)
	var has_multiplier = _has_production_multiplier(chip)

	# Calculate final material costs
	var materials = _calculate_materials(software, runs, material_bonus)

	# Calculate production time
	var production_time = _calculate_production_time(software, runs, time_bonus)

	# TODO: Check player has materials
	# TODO: Consume materials from inventory

	# Consume chip usage
	chip.uses_remaining -= runs
	chip.data_integrity = (chip.uses_remaining / float(chip.max_capacity)) * 100.0

	if chip.uses_remaining <= 0:
		chip.data_integrity = 0.0
		chip_integrity_depleted.emit(chip_id)

	# Create job
	var job_id = "MFG_%d_%s" % [Time.get_unix_time_from_system(), player_id]
	var job = ManufacturingJob.new(job_id, chip_id, software.output_item_id, runs,
	                                 station_id, player_id, production_time, materials)
	job.has_multiplier = has_multiplier

	active_jobs[job_id] = job

	manufacturing_started.emit(job_id, chip_id, runs)

	if has_multiplier:
		multiplier_activated.emit(job_id)
		# Consume multiplier crystal
		_consume_multiplier_crystal(chip)

	print("🏭 Manufacturing started: %s → %d x %s (Time: %.1fs, Integrity: %.1f%%)" %
	      [software.software_name, runs * software.output_amount, software.output_item_id,
	       production_time, chip.data_integrity])

	return job_id

func _calculate_material_bonus(chip: ManufacturingChip) -> float:
	"""Calculate total material reduction bonus"""
	var bonus = QUALITY_BONUS[chip.quality_level]

	# Add crystal bonuses
	for crystal_id in chip.sockets:
		if crystal_id == null:
			continue

		if crystal_database.has(crystal_id):
			var crystal = crystal_database[crystal_id]
			if crystal.crystal_type == CrystalType.EFFICIENCY_MATERIAL:
				bonus += crystal.bonus_value

	return bonus

func _calculate_time_bonus(chip: ManufacturingChip) -> float:
	"""Calculate total time reduction bonus"""
	var bonus = QUALITY_BONUS[chip.quality_level]

	# Add crystal bonuses
	for crystal_id in chip.sockets:
		if crystal_id == null:
			continue

		if crystal_database.has(crystal_id):
			var crystal = crystal_database[crystal_id]
			if crystal.crystal_type == CrystalType.EFFICIENCY_TIME:
				bonus += crystal.bonus_value

	return bonus

func _has_production_multiplier(chip: ManufacturingChip) -> bool:
	"""Check if chip has production multiplier socketed"""
	for crystal_id in chip.sockets:
		if crystal_id == null:
			continue

		if crystal_database.has(crystal_id):
			var crystal = crystal_database[crystal_id]
			if crystal.crystal_type == CrystalType.PRODUCTION_MULTIPLIER:
				return true

	return false

func _consume_multiplier_crystal(chip: ManufacturingChip):
	"""Remove multiplier crystal after use (consumable)"""
	for i in range(chip.sockets.size()):
		var crystal_id = chip.sockets[i]
		if crystal_id == null:
			continue

		if crystal_database.has(crystal_id):
			var crystal = crystal_database[crystal_id]
			if crystal.crystal_type == CrystalType.PRODUCTION_MULTIPLIER:
				chip.sockets[i] = null
				print("💎 Multiplier crystal consumed")
				return

func _calculate_materials(software: SoftwareData, runs: int, bonus: float) -> Dictionary:
	"""Calculate required materials with bonuses"""
	var materials = {}
	var reduction = 1.0 - bonus

	for item_id in software.base_materials.keys():
		var base_amount = software.base_materials[item_id]
		var final_amount = ceil(base_amount * reduction * runs)
		materials[item_id] = final_amount

	return materials

func _calculate_production_time(software: SoftwareData, runs: int, bonus: float) -> float:
	"""Calculate production time with bonuses"""
	var reduction = 1.0 - bonus
	return software.base_production_time * reduction * runs

# ============================================================================
# JOB PROCESSING
# ============================================================================

func _process_manufacturing_jobs():
	"""Process active manufacturing jobs"""
	var current_time = Time.get_unix_time_from_system()
	var completed_jobs = []

	for job_id in active_jobs.keys():
		var job = active_jobs[job_id]
		if current_time >= job.completion_time:
			completed_jobs.append(job_id)

	for job_id in completed_jobs:
		var job = active_jobs[job_id]

		# Calculate output
		var software = software_database[chips[job.chip_id].loaded_software]
		var total_output = job.runs * software.output_amount

		# Apply multiplier
		if job.has_multiplier:
			total_output *= 2
			print("✨ Production Multiplier: x2 output!")

		# TODO: Add output items to player inventory

		manufacturing_completed.emit(job_id, job.output_item_id, total_output)
		print("✅ Manufacturing completed: %d x %s" % [total_output, job.output_item_id])

		active_jobs.erase(job_id)

# ============================================================================
# QUERY API
# ============================================================================

func get_chip(chip_id: String) -> ManufacturingChip:
	"""Get chip data"""
	return chips.get(chip_id, null)

func get_player_chips(player_id: String) -> Array:
	"""Get all chips owned by player"""
	var player_chips = []
	for chip in chips.values():
		if chip.owner_id == player_id:
			player_chips.append(chip)
	return player_chips

func get_active_jobs(player_id: String) -> Array:
	"""Get player's active jobs"""
	var jobs = []
	for job in active_jobs.values():
		if job.player_id == player_id:
			jobs.append(job)
	return jobs

func get_software_list() -> Array:
	"""Get all available software"""
	return software_database.values()

func get_crystal_list() -> Array:
	"""Get all available crystals"""
	return crystal_database.values()

func get_recharge_cost(chip_id: String) -> Dictionary:
	"""Get recharge cost for a specific chip"""
	var result = {
		"credits": 0,
		"materials": {}
	}

	if not chips.has(chip_id):
		return result

	var chip = chips[chip_id]
	result.credits = RECHARGE_CREDITS_COST[chip.tier]
	result.materials = RECHARGE_MATERIALS_COST[chip.tier].duplicate()

	return result

func get_recharge_cost_by_tier(tier: ChipTier) -> Dictionary:
	"""Get recharge cost for a specific tier"""
	return {
		"credits": RECHARGE_CREDITS_COST[tier],
		"materials": RECHARGE_MATERIALS_COST[tier].duplicate()
	}
