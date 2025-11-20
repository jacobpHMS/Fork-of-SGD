extends Node

# ============================================================================
# REFINERY SYSTEM - Simplified Material Purification
# ============================================================================
# SIMPLIFIED SYSTEM: Only 2 quality levels
# - STANDARD: Normal minerals for regular production
# - PURE: Refined minerals for special/high-tier components
# Single refining step: Standard → Pure

signal refining_started(material: String, target_quality: String)
signal refining_progress(material: String, progress: float)
signal refining_complete(material: String, result: Dictionary)
signal waste_generated(waste_type: String, amount: float)

# Quality levels (SIMPLIFIED: only 2 levels)
enum QualityLevel {
	STANDARD = 0,  # Normal minerals - for regular production
	PURE = 1       # Pure minerals - for special/high-tier components
}

# Material loss for purification
const MATERIAL_LOSS_PERCENT = {
	QualityLevel.PURE: 30.0  # 30% loss → 70% yield when purifying
}

# Processing time (in seconds)
const PROCESSING_TIME = {
	QualityLevel.PURE: 300.0  # 5 minutes to purify
}

# Energy consumption (energy units per second)
const ENERGY_CONSUMPTION = {
	QualityLevel.PURE: 50.0  # Moderate energy cost
}

# Waste types
enum WasteType {
	IMPURITIES,  # Generic waste
	TOXIC,  # Toxic waste (requires special storage)
	RADIOACTIVE  # Radioactive waste (requires shielded storage)
}

# Material data structure
class MaterialData:
	var material_id: String = ""
	var amount: float = 0.0
	var quality: QualityLevel = QualityLevel.STANDARD

	func _init(id: String, amt: float, qual: QualityLevel = QualityLevel.STANDARD):
		material_id = id
		amount = amt
		quality = qual

	func is_pure() -> bool:
		return quality == QualityLevel.PURE

	func get_display_name() -> String:
		var base_name = material_id.replace("mineral_", "").capitalize()
		if is_pure():
			return "Pure " + base_name
		else:
			return base_name

# Refining job structure
class RefiningJob:
	var material: MaterialData
	var target_quality: QualityLevel
	var start_time: float
	var duration: float
	var progress: float = 0.0
	var energy_per_second: float

	func _init(mat: MaterialData):
		material = mat
		target_quality = QualityLevel.PURE  # Always purifying to PURE
		start_time = Time.get_ticks_msec() / 1000.0
		duration = PROCESSING_TIME[QualityLevel.PURE]
		energy_per_second = ENERGY_CONSUMPTION[QualityLevel.PURE]

	func update_progress(delta: float) -> float:
		progress += delta
		return progress / duration  # Return 0.0-1.0

	func is_complete() -> bool:
		return progress >= duration

# Current refining jobs (queue)
var refining_queue: Array[RefiningJob] = []
var max_concurrent_jobs: int = 1  # Can be upgraded

func _process(delta):
	# Process active refining jobs
	process_refining_queue(delta)

# ============================================================================
# REFINING OPERATIONS
# ============================================================================

func start_refining(material_id: String, amount: float) -> bool:
	"""Start a refining job to purify minerals (Standard → Pure)"""

	# Validate input
	if amount <= 0:
		print("❌ Invalid amount: %.2f" % amount)
		return false

	# Check queue capacity
	if refining_queue.size() >= max_concurrent_jobs:
		print("❌ Refinery queue full (max %d jobs)" % max_concurrent_jobs)
		return false

	# Create material (always starts as STANDARD)
	var material = MaterialData.new(material_id, amount, QualityLevel.STANDARD)

	# Create refining job
	var job = RefiningJob.new(material)
	refining_queue.append(job)

	emit_signal("refining_started", material_id, "PURE")
	print("🏭 Refining started: %s (%.0f units → Pure)" % [material_id, amount])

	return true

func process_refining_queue(delta: float):
	"""Process all active refining jobs"""
	var completed_jobs = []

	for i in range(refining_queue.size()):
		var job = refining_queue[i]

		# Update progress
		var progress_percent = job.update_progress(delta)
		emit_signal("refining_progress", job.material.material_id, progress_percent)

		# Check for completion
		if job.is_complete():
			completed_jobs.append(i)

			# Process completion
			var result = complete_refining(job)
			emit_signal("refining_complete", job.material.material_id, result)

	# Remove completed jobs (reverse order to preserve indices)
	for i in range(completed_jobs.size() - 1, -1, -1):
		refining_queue.remove_at(completed_jobs[i])

func complete_refining(job: RefiningJob) -> Dictionary:
	"""Complete a refining job and calculate outputs"""
	var input_amount = job.material.amount
	var loss_percent = MATERIAL_LOSS_PERCENT[QualityLevel.PURE]

	# Calculate output
	var output_amount = input_amount * (1.0 - loss_percent / 100.0)
	var waste_amount = input_amount - output_amount

	# Determine waste type based on material
	var waste_type = determine_waste_type(job.material.material_id)

	# Generate waste
	emit_signal("waste_generated", WasteType.keys()[waste_type], waste_amount)

	print("✅ Refining complete: %s" % job.material.material_id)
	print("   Input: %.2f units (Standard)" % input_amount)
	print("   Output: %.2f units (Pure)" % output_amount)
	print("   Waste: %.2f units (%s)" % [waste_amount, WasteType.keys()[waste_type]])

	return {
		"material_id": job.material.material_id + "_pure",  # Add _pure suffix
		"output_amount": output_amount,
		"quality": QualityLevel.PURE,
		"waste_amount": waste_amount,
		"waste_type": waste_type,
		"energy_consumed": job.duration * job.energy_per_second
	}

func determine_waste_type(material_id: String) -> WasteType:
	"""Determine waste type based on material"""
	# Radioactive materials (uranium, plutonium, etc.)
	if material_id.contains("uranium") or material_id.contains("plutonium"):
		return WasteType.RADIOACTIVE

	# Toxic materials
	if material_id.contains("toxic") or material_id.contains("mercury"):
		return WasteType.TOXIC

	# Default to impurities
	return WasteType.IMPURITIES

# ============================================================================
# QUALITY GATES & CRAFTING VALIDATION
# ============================================================================

func can_craft_with_material(material_quality: QualityLevel, required_quality: QualityLevel) -> bool:
	"""Check if material quality is sufficient for crafting"""
	return material_quality >= required_quality

func requires_pure_material(component_name: String) -> bool:
	"""Check if a component requires pure minerals"""
	# Special/High-tier components require pure minerals
	var pure_required = [
		"quantum_core",
		"ai_matrix",
		"fusion_reactor",
		"warp_coil",
		"shield_emitter",
		"advanced_cpu",
		"precision_actuator"
	]

	for item in pure_required:
		if component_name.contains(item):
			return true

	return false

func get_crafting_requirements(component_name: String) -> Dictionary:
	"""Get material quality requirements for crafting"""
	var needs_pure = requires_pure_material(component_name)

	return {
		"required_quality": QualityLevel.PURE if needs_pure else QualityLevel.STANDARD,
		"quality_name": "Pure Minerals" if needs_pure else "Standard Minerals"
	}

# ============================================================================
# WASTE MANAGEMENT
# ============================================================================

class WasteStorage:
	var waste_type: WasteType
	var amount: float = 0.0
	var max_capacity: float = 1000.0

	func _init(type: WasteType, capacity: float = 1000.0):
		waste_type = type
		max_capacity = capacity

	func add_waste(amt: float) -> float:
		"""Add waste, returns amount that couldn't be stored"""
		var space = max_capacity - amount
		var to_add = min(amt, space)
		amount += to_add
		return amt - to_add

	func remove_waste(amt: float) -> float:
		"""Remove waste, returns amount actually removed"""
		var to_remove = min(amt, amount)
		amount -= to_remove
		return to_remove

	func is_full() -> bool:
		return amount >= max_capacity

# Waste storage containers
var waste_storage: Dictionary = {
	WasteType.IMPURITIES: WasteStorage.new(WasteType.IMPURITIES, 5000.0),
	WasteType.TOXIC: WasteStorage.new(WasteType.TOXIC, 1000.0),
	WasteType.RADIOACTIVE: WasteStorage.new(WasteType.RADIOACTIVE, 500.0)
}

func store_waste(waste_type: WasteType, amount: float) -> float:
	"""Store waste, returns overflow amount"""
	if not waste_storage.has(waste_type):
		print("❌ Unknown waste type: %d" % waste_type)
		return amount

	var overflow = waste_storage[waste_type].add_waste(amount)
	if overflow > 0:
		print("⚠️ Waste storage full! %.2f units overflow" % overflow)

	return overflow

func recycle_waste(waste_type: WasteType, amount: float) -> Dictionary:
	"""Recycle waste into usable resources (10% recovery)"""
	var storage = waste_storage[waste_type]
	var removed = storage.remove_waste(amount)
	var recovered = removed * 0.1  # 10% recovery rate

	print("♻️ Recycled %.2f units of %s → %.2f units recovered" % [removed, WasteType.keys()[waste_type], recovered])

	return {
		"recycled_amount": removed,
		"recovered_amount": recovered,
		"waste_type": waste_type
	}

# ============================================================================
# SAVE/LOAD INTEGRATION
# ============================================================================

func get_save_data() -> Dictionary:
	"""Export refinery data for saving"""
	var jobs_data = []
	for job in refining_queue:
		jobs_data.append({
			"material_id": job.material.material_id,
			"amount": job.material.amount,
			"quality": job.material.quality,
			"progress": job.progress
		})

	var waste_data = {}
	for waste_type in waste_storage:
		waste_data[WasteType.keys()[waste_type]] = waste_storage[waste_type].amount

	return {
		"refining_queue": jobs_data,
		"waste_storage": waste_data
	}

func load_save_data(data: Dictionary):
	"""Import refinery data from save file"""
	# Clear existing queue
	refining_queue.clear()

	# Restore refining jobs
	if data.has("refining_queue"):
		for job_data in data["refining_queue"]:
			var material = MaterialData.new(
				job_data["material_id"],
				job_data["amount"],
				job_data.get("quality", QualityLevel.STANDARD)
			)
			var job = RefiningJob.new(material)
			job.progress = job_data.get("progress", 0.0)
			refining_queue.append(job)

	# Restore waste storage
	if data.has("waste_storage"):
		for waste_name in data["waste_storage"]:
			var waste_type = WasteType.get(waste_name)
			if waste_storage.has(waste_type):
				waste_storage[waste_type].amount = data["waste_storage"][waste_name]

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_refinery_info() -> Dictionary:
	"""Get detailed refinery information"""
	var jobs_info = []
	for job in refining_queue:
		jobs_info.append({
			"material": job.material.material_id,
			"progress": job.progress / job.duration,
			"time_remaining": job.duration - job.progress
		})

	var waste_info = {}
	for waste_type in waste_storage:
		var storage = waste_storage[waste_type]
		waste_info[WasteType.keys()[waste_type]] = {
			"amount": storage.amount,
			"capacity": storage.max_capacity,
			"percent_full": (storage.amount / storage.max_capacity) * 100.0
		}

	return {
		"active_jobs": refining_queue.size(),
		"max_jobs": max_concurrent_jobs,
		"jobs": jobs_info,
		"waste": waste_info
	}
