## res://scripts/procedural/AsteroidIDGenerator.gd
## Generates unique IDs for asteroids and containers
## Ensures each object has deterministic seed while maintaining variance

class_name AsteroidIDGenerator
extends RefCounted

# ============================================================================
# COUNTER STORAGE
# ============================================================================

# Global counters per size category
var size_counters: Dictionary = {
	"small": 0,
	"medium": 0,
	"large": 0,
	"huge": 0
}

# Sector-based counters for spatial organization
# Format: "size_tier_quality_sector" → counter
var sector_counters: Dictionary = {}

# Container counters
var container_counters: Dictionary = {}

# ============================================================================
# ASTEROID ID GENERATION
# ============================================================================

func generate_asteroid_id(
	size_category: String,
	ore_tier: int,
	quality: int,
	sector_id: String = ""
) -> String:
	"""
	Generate unique ID for asteroid with stats embedded

	Format: ORE_[SIZE]_T[TIER]_Q[QUALITY]_[SECTOR]_[COUNTER]
	Example: ORE_SMALL_T1_Q2_A5_00042

	Args:
		size_category: "small", "medium", "large", "huge"
		ore_tier: 1-6 (T1-T6)
		quality: 0-5 (Q0-Q5)
		sector_id: Sector identifier (e.g., "A5")

	Returns:
		Unique asteroid ID
	"""
	var key = "%s_T%d_Q%d_%s" % [size_category.to_lower(), ore_tier, quality, sector_id]

	if not sector_counters.has(key):
		sector_counters[key] = 0
	sector_counters[key] += 1

	return "ORE_%s_T%d_Q%d_%s_%05d" % [
		size_category.to_upper(),
		ore_tier,
		quality,
		sector_id,
		sector_counters[key]
	]

func generate_simple_asteroid_id(size_category: String, ore_type: String) -> String:
	"""
	Generate simple asteroid ID without tier/quality

	Format: ORE_[SIZE]_[TYPE]_[COUNTER]
	Example: ORE_SMALL_IRON_00123
	"""
	if not size_counters.has(size_category):
		size_counters[size_category] = 0
	size_counters[size_category] += 1

	return "ORE_%s_%s_%05d" % [
		size_category.to_upper(),
		ore_type.to_upper(),
		size_counters[size_category]
	]

# ============================================================================
# CONTAINER ID GENERATION
# ============================================================================

func generate_container_id(
	container_type: String,
	content_type: String,
	sector_id: String = ""
) -> String:
	"""
	Generate unique ID for cargo container

	Format: CNT_[TYPE]_[CONTENT]_[SECTOR]_[COUNTER]
	Example: CNT_MINERAL_IRON_A5_00012

	Args:
		container_type: "mineral", "gas", "liquid", "ammo"
		content_type: "iron", "oxygen", "water", "missiles"
		sector_id: Sector identifier

	Returns:
		Unique container ID
	"""
	var key = "%s_%s_%s" % [container_type.to_lower(), content_type.to_lower(), sector_id]

	if not container_counters.has(key):
		container_counters[key] = 0
	container_counters[key] += 1

	return "CNT_%s_%s_%s_%05d" % [
		container_type.to_upper(),
		content_type.to_upper(),
		sector_id,
		container_counters[key]
	]

func generate_loot_container_id(source_id: String, drop_index: int) -> String:
	"""
	Generate container ID from loot source (e.g., destroyed ship)

	Format: CNT_LOOT_[SOURCE]_[INDEX]
	Example: CNT_LOOT_SHIP_PIRATE_001_00

	Args:
		source_id: ID of destroyed object (ship, station, etc.)
		drop_index: Index of this drop (0-n)

	Returns:
		Unique container ID
	"""
	return "CNT_LOOT_%s_%02d" % [source_id, drop_index]

# ============================================================================
# PARSING UTILITIES
# ============================================================================

func parse_asteroid_id(asteroid_id: String) -> Dictionary:
	"""
	Parse asteroid ID back to components

	Input: "ORE_SMALL_T1_Q2_A5_00042"
	Output: {
		"type": "asteroid",
		"size": "small",
		"tier": 1,
		"quality": 2,
		"sector": "A5",
		"counter": 42
	}
	"""
	var parts = asteroid_id.split("_")

	if parts.size() < 5 or parts[0] != "ORE":
		push_warning("Invalid asteroid ID: %s" % asteroid_id)
		return {}

	return {
		"type": "asteroid",
		"size": parts[1].to_lower(),
		"tier": int(parts[2].substr(1)),  # "T1" → 1
		"quality": int(parts[3].substr(1)),  # "Q2" → 2
		"sector": parts[4],
		"counter": int(parts[5]) if parts.size() > 5 else 0
	}

func parse_container_id(container_id: String) -> Dictionary:
	"""
	Parse container ID back to components

	Input: "CNT_MINERAL_IRON_A5_00012"
	Output: {
		"type": "container",
		"container_type": "mineral",
		"content": "iron",
		"sector": "A5",
		"counter": 12
	}
	"""
	var parts = container_id.split("_")

	if parts.size() < 4 or parts[0] != "CNT":
		push_warning("Invalid container ID: %s" % container_id)
		return {}

	return {
		"type": "container",
		"container_type": parts[1].to_lower(),
		"content": parts[2].to_lower(),
		"sector": parts[3] if parts.size() > 3 else "",
		"counter": int(parts[4]) if parts.size() > 4 else 0
	}

# ============================================================================
# BATCH OPERATIONS
# ============================================================================

func reset_sector_counters(sector_id: String):
	"""Reset all counters for specific sector"""
	var keys_to_remove = []

	for key in sector_counters.keys():
		if key.ends_with("_" + sector_id):
			keys_to_remove.append(key)

	for key in keys_to_remove:
		sector_counters.erase(key)

	for key in container_counters.keys():
		if key.ends_with("_" + sector_id):
			keys_to_remove.append(key)

	for key in keys_to_remove:
		container_counters.erase(key)

func get_counter_stats() -> Dictionary:
	"""Get statistics about generated IDs"""
	var total_asteroids = 0
	for count in sector_counters.values():
		total_asteroids += count

	var total_containers = 0
	for count in container_counters.values():
		total_containers += count

	return {
		"total_asteroids": total_asteroids,
		"total_containers": total_containers,
		"unique_asteroid_types": sector_counters.size(),
		"unique_container_types": container_counters.size()
	}

# ============================================================================
# SAVE/LOAD SUPPORT
# ============================================================================

func export_state() -> Dictionary:
	"""Export counters for savegame"""
	return {
		"size_counters": size_counters.duplicate(),
		"sector_counters": sector_counters.duplicate(),
		"container_counters": container_counters.duplicate()
	}

func import_state(state: Dictionary):
	"""Import counters from savegame"""
	if state.has("size_counters"):
		size_counters = state.size_counters.duplicate()
	if state.has("sector_counters"):
		sector_counters = state.sector_counters.duplicate()
	if state.has("container_counters"):
		container_counters = state.container_counters.duplicate()
