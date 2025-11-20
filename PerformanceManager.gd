extends Node

# ============================================================================
# PERFORMANCE MANAGER - Optimizes updates for 10,000+ objects
# ============================================================================
# Manages update batching, spatial partitioning, and frame budgets
# All systems should register with this manager for optimal performance

signal frame_budget_exceeded(system_name: String, time_ms: float)

# Frame budget settings
const TARGET_FPS: int = 60
const FRAME_TIME_MS: float = 16.67  # 60 FPS = 16.67ms per frame
const MAX_SYSTEM_TIME_MS: float = 2.0  # Max 2ms per system per frame

# Update intervals for different priorities
enum UpdatePriority {
	CRITICAL,   # Every frame
	HIGH,       # Every 2 frames
	MEDIUM,     # Every 5 frames
	LOW,        # Every 10 frames
	BACKGROUND  # Every 30 frames (0.5s at 60fps)
}

const UPDATE_INTERVALS = {
	UpdatePriority.CRITICAL: 1,
	UpdatePriority.HIGH: 2,
	UpdatePriority.MEDIUM: 5,
	UpdatePriority.LOW: 10,
	UpdatePriority.BACKGROUND: 30
}

# Registered systems
class ManagedSystem:
	var system_name: String = ""
	var update_callback: Callable
	var priority: UpdatePriority = UpdatePriority.MEDIUM
	var frame_counter: int = 0
	var last_update_time: float = 0.0
	var average_update_time: float = 0.0

	func should_update() -> bool:
		var interval = UPDATE_INTERVALS[priority]
		return frame_counter % interval == 0

var registered_systems: Array[ManagedSystem] = []

# Batch processing settings
const MAX_BATCH_SIZE: int = 100  # Process max 100 objects per frame per system

# Spatial partitioning grid (for fast proximity queries)
class SpatialGrid:
	var cell_size: float = 1000.0
	var cells: Dictionary = {}  # Vector2i -> Array[Object]

	func add(obj: Object, position: Vector2):
		var cell = get_cell(position)
		if not cells.has(cell):
			cells[cell] = []
		cells[cell].append(obj)

	func remove(obj: Object, position: Vector2):
		var cell = get_cell(position)
		if cells.has(cell):
			cells[cell].erase(obj)
			if cells[cell].is_empty():
				cells.erase(cell)

	func get_nearby(position: Vector2, radius: float) -> Array:
		var results = []
		var cell_radius = int(ceil(radius / cell_size))
		var center_cell = get_cell(position)

		for x in range(-cell_radius, cell_radius + 1):
			for y in range(-cell_radius, cell_radius + 1):
				var check_cell = center_cell + Vector2i(x, y)
				if cells.has(check_cell):
					results.append_array(cells[check_cell])

		return results

	func get_cell(position: Vector2) -> Vector2i:
		return Vector2i(
			int(floor(position.x / cell_size)),
			int(floor(position.y / cell_size))
		)

	func clear():
		cells.clear()

var spatial_grid: SpatialGrid = SpatialGrid.new()

# Frame statistics
var current_frame: int = 0
var total_update_time_ms: float = 0.0
var slowest_system: String = ""
var slowest_system_time: float = 0.0

# Performance monitoring
var performance_log: Array[Dictionary] = []
const MAX_LOG_ENTRIES: int = 60  # 1 second at 60fps

func _ready():
	print("⚡ Performance Manager initialized")
	print("   Target FPS: %d" % TARGET_FPS)
	print("   Frame Budget: %.2fms" % FRAME_TIME_MS)
	print("   Max System Time: %.2fms" % MAX_SYSTEM_TIME_MS)

func _process(delta):
	current_frame += 1
	total_update_time_ms = 0.0
	slowest_system = ""
	slowest_system_time = 0.0

	# Update all registered systems
	for system in registered_systems:
		if system.should_update():
			update_system(system, delta)
		system.frame_counter += 1

	# Log performance
	log_frame_performance()

func update_system(system: ManagedSystem, delta: float):
	"""Update a registered system with timing"""
	var start_time = Time.get_ticks_usec()

	# Call system update
	system.update_callback.call(delta)

	# Calculate update time
	var end_time = Time.get_ticks_usec()
	var update_time_ms = (end_time - start_time) / 1000.0

	# Update statistics
	system.last_update_time = update_time_ms
	system.average_update_time = lerp(system.average_update_time, update_time_ms, 0.1)

	total_update_time_ms += update_time_ms

	# Track slowest system
	if update_time_ms > slowest_system_time:
		slowest_system_time = update_time_ms
		slowest_system = system.system_name

	# Warn if exceeding budget
	if update_time_ms > MAX_SYSTEM_TIME_MS:
		emit_signal("frame_budget_exceeded", system.system_name, update_time_ms)
		if current_frame % 60 == 0:  # Only warn once per second
			print("⚠️ Performance: %s took %.2fms (budget: %.2fms)" % [
				system.system_name, update_time_ms, MAX_SYSTEM_TIME_MS
			])

# ============================================================================
# SYSTEM REGISTRATION
# ============================================================================

func register_system(system_name: String, update_callback: Callable, priority: UpdatePriority = UpdatePriority.MEDIUM) -> void:
	"""Register a system for managed updates"""
	var system = ManagedSystem.new()
	system.system_name = system_name
	system.update_callback = update_callback
	system.priority = priority

	registered_systems.append(system)

	print("✅ Registered system: %s (Priority: %s)" % [
		system_name,
		UpdatePriority.keys()[priority]
	])

func unregister_system(system_name: String) -> bool:
	"""Unregister a system"""
	for i in range(registered_systems.size()):
		if registered_systems[i].system_name == system_name:
			registered_systems.remove_at(i)
			print("🗑️ Unregistered system: %s" % system_name)
			return true
	return false

# ============================================================================
# BATCH PROCESSING UTILITIES
# ============================================================================

func create_batch_iterator(items: Array, batch_size: int = MAX_BATCH_SIZE):
	"""Create an iterator for batch processing"""
	return BatchIterator.new(items, batch_size)

class BatchIterator:
	var items: Array
	var batch_size: int
	var current_index: int = 0

	func _init(items_arr: Array, size: int):
		items = items_arr
		batch_size = size

	func has_next() -> bool:
		return current_index < items.size()

	func get_next_batch() -> Array:
		var batch = []
		var end_index = min(current_index + batch_size, items.size())

		for i in range(current_index, end_index):
			batch.append(items[i])

		current_index = end_index
		return batch

	func reset():
		current_index = 0

# ============================================================================
# SPATIAL PARTITIONING
# ============================================================================

func register_spatial_object(obj: Object, position: Vector2):
	"""Register an object in spatial grid"""
	spatial_grid.add(obj, position)

func unregister_spatial_object(obj: Object, position: Vector2):
	"""Unregister an object from spatial grid"""
	spatial_grid.remove(obj, position)

func update_spatial_object(obj: Object, old_position: Vector2, new_position: Vector2):
	"""Update object position in spatial grid"""
	spatial_grid.remove(obj, old_position)
	spatial_grid.add(obj, new_position)

func query_nearby_objects(position: Vector2, radius: float) -> Array:
	"""Get objects near a position (fast)"""
	return spatial_grid.get_nearby(position, radius)

func clear_spatial_grid():
	"""Clear spatial grid"""
	spatial_grid.clear()

# ============================================================================
# PERFORMANCE MONITORING
# ============================================================================

func log_frame_performance():
	"""Log frame performance data"""
	var entry = {
		"frame": current_frame,
		"total_time_ms": total_update_time_ms,
		"slowest_system": slowest_system,
		"slowest_time_ms": slowest_system_time,
		"fps": Engine.get_frames_per_second()
	}

	performance_log.append(entry)

	# Keep only last 60 frames
	if performance_log.size() > MAX_LOG_ENTRIES:
		performance_log.remove_at(0)

func get_performance_stats() -> Dictionary:
	"""Get performance statistics"""
	if performance_log.is_empty():
		return {}

	var total_time = 0.0
	var total_fps = 0.0
	var system_times = {}

	for entry in performance_log:
		total_time += entry["total_time_ms"]
		total_fps += entry["fps"]

		var system = entry["slowest_system"]
		if system != "":
			if not system_times.has(system):
				system_times[system] = 0.0
			system_times[system] += entry["slowest_time_ms"]

	var count = performance_log.size()

	return {
		"average_frame_time_ms": total_time / count,
		"average_fps": total_fps / count,
		"frame_budget_used_percent": (total_time / count / FRAME_TIME_MS) * 100.0,
		"slowest_systems": system_times,
		"registered_systems_count": registered_systems.size()
	}

func print_performance_report():
	"""Print performance report to console"""
	var stats = get_performance_stats()

	if stats.is_empty():
		return

	print("\n╔════════════════════════════════════════╗")
	print("║     PERFORMANCE REPORT                 ║")
	print("╠════════════════════════════════════════╣")
	print("║ Average FPS: %.1f                      " % stats["average_fps"])
	print("║ Average Frame Time: %.2fms             " % stats["average_frame_time_ms"])
	print("║ Frame Budget Used: %.1f%%              " % stats["frame_budget_used_percent"])
	print("║ Registered Systems: %d                 " % stats["registered_systems_count"])
	print("╠════════════════════════════════════════╣")
	print("║ System Average Times:                  ║")

	for system in registered_systems:
		print("║   %s: %.2fms" % [system.system_name.rpad(30), system.average_update_time])

	print("╚════════════════════════════════════════╝\n")

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func is_performance_critical() -> bool:
	"""Check if performance is critical (low FPS)"""
	var stats = get_performance_stats()
	if stats.is_empty():
		return false
	return stats["average_fps"] < 30.0

func get_recommended_batch_size() -> int:
	"""Get recommended batch size based on current performance"""
	var stats = get_performance_stats()
	if stats.is_empty():
		return MAX_BATCH_SIZE

	if stats["average_fps"] < 30.0:
		return 50  # Reduce batch size
	elif stats["average_fps"] > 55.0:
		return 200  # Increase batch size
	else:
		return MAX_BATCH_SIZE

func should_skip_expensive_operation() -> bool:
	"""Check if expensive operations should be skipped this frame"""
	return total_update_time_ms > FRAME_TIME_MS * 0.8  # 80% budget used
