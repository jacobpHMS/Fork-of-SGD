# res://scripts/autoload/database_manager.gd
extends Node

# Data storage
var all_items: Array[Dictionary] = []  # All items from all databases
var components: Array[Dictionary] = []
var weapons: Array[Dictionary] = []
var ammunition: Array[Dictionary] = []
var ores: Array[Dictionary] = []
var materials: Array[Dictionary] = []
var gases: Array[Dictionary] = []
var waste: Array[Dictionary] = []
var mining_modules: Array[Dictionary] = []
var ship_modules: Array[Dictionary] = []  # 300 Ship Modules
var ships: Array[Dictionary] = []  # 155 Ships

# Lookup caches (by ID)
var item_lookup: Dictionary = {}

# Headers for TSV export
const STANDARD_HEADERS = [
	"DATABASE", "ID", "NAME", "TIER", "CATEGORY", "SIZE", "SUBCATEGORY",
	"MASS_KG", "VOLUME_M3", "BASE_PRICE", "PRODUCTION_TIME_SEC",
	"INPUT_1", "INPUT_1_QTY", "INPUT_2", "INPUT_2_QTY",
	"INPUT_3", "INPUT_3_QTY", "SPECIAL_NOTES"
]

# Signals
signal data_loaded
signal data_changed
signal database_error(error_message: String)

func _ready():
	print("DatabaseManager: Initializing...")
	load_all_data()

# ============================================================================
# LOAD SYSTEM
# ============================================================================

func load_all_data():
	"""Load all database files"""
	all_items.clear()
	components.clear()
	weapons.clear()
	ammunition.clear()
	ores.clear()
	materials.clear()
	gases.clear()
	waste.clear()
	mining_modules.clear()
	ship_modules.clear()
	ships.clear()
	item_lookup.clear()

	# Load from TSV files
	load_complete_database()
	load_components()
	load_weapons()
	load_ammunition()
	load_ship_modules()
	load_ships()

	# Build lookup cache
	rebuild_cache()

	print("DatabaseManager: Loaded %d total items" % all_items.size())
	data_loaded.emit()

func load_complete_database():
	"""Load COMPLETE_SPACE_GAME_DATABASE.tsv (Ores, Materials, Gases, Waste, Mining Modules)"""
	var file_path = "res://data/batch05/COMPLETE_SPACE_GAME_DATABASE.tsv"

	if not FileAccess.file_exists(file_path):
		push_error("COMPLETE_SPACE_GAME_DATABASE.tsv not found!")
		database_error.emit("Complete database file not found: " + file_path)
		return

	var entries = TSVParser.parse_file(file_path)

	# Categorize entries
	for entry in entries:
		var database = entry.get("DATABASE", "")

		match database:
			"ORES":
				ores.append(entry)
			"MATERIALS":
				materials.append(entry)
			"GASES":
				gases.append(entry)
			"WASTE":
				waste.append(entry)
			"MINING_MODULES":
				mining_modules.append(entry)

		all_items.append(entry)

	print("DatabaseManager: Loaded Complete Database - %d entries (Ores: %d, Materials: %d, Gases: %d, Waste: %d, Mining: %d)" % [
		entries.size(), ores.size(), materials.size(), gases.size(), waste.size(), mining_modules.size()
	])

func load_components():
	"""Load 06_COMPONENTS.tsv"""
	var file_path = "res://data/batch05/06_COMPONENTS.tsv"

	if not FileAccess.file_exists(file_path):
		push_error("06_COMPONENTS.tsv not found!")
		database_error.emit("Components file not found: " + file_path)
		return

	components = TSVParser.parse_file(file_path)
	all_items.append_array(components)

	print("DatabaseManager: Loaded Components - %d entries" % components.size())

func load_weapons():
	"""Load 07a_WEAPONS_PART1.tsv + 07b_WEAPONS_PART2.tsv"""
	var part1_path = "res://data/batch05/07a_WEAPONS_PART1.tsv"
	var part2_path = "res://data/batch05/07b_WEAPONS_PART2.tsv"

	if FileAccess.file_exists(part1_path):
		var part1 = TSVParser.parse_file(part1_path)
		weapons.append_array(part1)
		all_items.append_array(part1)
	else:
		push_error("07a_WEAPONS_PART1.tsv not found!")

	if FileAccess.file_exists(part2_path):
		var part2 = TSVParser.parse_file(part2_path)
		weapons.append_array(part2)
		all_items.append_array(part2)
	else:
		push_error("07b_WEAPONS_PART2.tsv not found!")

	print("DatabaseManager: Loaded Weapons - %d entries" % weapons.size())

func load_ammunition():
	"""Load 08_AMMUNITION.tsv"""
	var file_path = "res://data/batch05/08_AMMUNITION.tsv"

	if not FileAccess.file_exists(file_path):
		push_error("08_AMMUNITION.tsv not found!")
		database_error.emit("Ammunition file not found: " + file_path)
		return

	ammunition = TSVParser.parse_file(file_path)
	all_items.append_array(ammunition)

	print("DatabaseManager: Loaded Ammunition - %d entries" % ammunition.size())

func load_ship_modules():
	"""Load Ship Modules from 6 TSV files (09a-09f)"""
	var module_files = [
		"res://data/batch05/09a_shields_armor.tsv",
		"res://data/batch05/09b_engines_power.tsv",
		"res://data/batch05/09c_cargo_sensors.tsv",
		"res://data/batch05/09d_ecm_mining.tsv",
		"res://data/batch05/09e_command_medical.tsv",
		"res://data/batch05/09f_utility_station.tsv"
	]

	for file_path in module_files:
		if FileAccess.file_exists(file_path):
			var entries = TSVParser.parse_file(file_path)
			ship_modules.append_array(entries)
			all_items.append_array(entries)
		else:
			push_error("Ship Module file not found: " + file_path)

	print("DatabaseManager: Loaded Ship Modules - %d entries" % ship_modules.size())

func load_ships():
	"""Load Ships from 5 TSV files (10a-10e)"""
	var ship_files = [
		"res://data/batch05/10a_frigates_destroyers.tsv",
		"res://data/batch05/10b_cruisers_battlecruisers.tsv",
		"res://data/batch05/10c_battleships_carriers.tsv",
		"res://data/batch05/10d_dreadnoughts_titans.tsv",
		"res://data/batch05/10e_industrial_special_civilian.tsv"
	]

	for file_path in ship_files:
		if FileAccess.file_exists(file_path):
			var entries = TSVParser.parse_file(file_path)
			ships.append_array(entries)
			all_items.append_array(entries)
		else:
			push_error("Ship file not found: " + file_path)

	print("DatabaseManager: Loaded Ships - %d entries" % ships.size())

func rebuild_cache():
	"""Rebuild ID lookup cache"""
	item_lookup.clear()

	for item in all_items:
		var id = item.get("ID", "")
		if not id.is_empty():
			item_lookup[id] = item

	print("DatabaseManager: Cache rebuilt - %d items indexed" % item_lookup.size())

# ============================================================================
# QUERY SYSTEM
# ============================================================================

func get_item_by_id(item_id: String) -> Dictionary:
	"""Get item by ID (O(1) lookup)"""
	return item_lookup.get(item_id, {})

func get_items_by_category(category: String) -> Array[Dictionary]:
	"""Get all items matching category"""
	var result: Array[Dictionary] = []
	for item in all_items:
		if item.get("CATEGORY", "") == category:
			result.append(item)
	return result

func get_items_by_database(database: String) -> Array[Dictionary]:
	"""Get all items from specific database (ORES, MATERIALS, WEAPONS, etc.)"""
	match database.to_upper():
		"ORES":
			return ores.duplicate()
		"MATERIALS":
			return materials.duplicate()
		"GASES":
			return gases.duplicate()
		"WASTE":
			return waste.duplicate()
		"MINING_MODULES":
			return mining_modules.duplicate()
		"COMPONENTS":
			return components.duplicate()
		"WEAPONS":
			return weapons.duplicate()
		"AMMUNITION":
			return ammunition.duplicate()
		"SHIP_MODULES", "MODULES":
			return ship_modules.duplicate()
		"SHIPS":
			return ships.duplicate()
		_:
			return []

func get_items_by_tier(tier: int) -> Array[Dictionary]:
	"""Get all items matching tier"""
	var result: Array[Dictionary] = []
	for item in all_items:
		if item.get("TIER", 0) == tier:
			result.append(item)
	return result

func search_items(query: String) -> Array[Dictionary]:
	"""Search items by name (case-insensitive)"""
	var result: Array[Dictionary] = []
	var lower_query = query.to_lower()

	for item in all_items:
		var item_name = str(item.get("NAME", "")).to_lower()
		if lower_query in item_name:
			result.append(item)

	return result

# ============================================================================
# STATISTICS
# ============================================================================

func get_database_stats() -> Dictionary:
	"""Get statistics about loaded databases"""
	return {
		"total_items": all_items.size(),
		"ores": ores.size(),
		"materials": materials.size(),
		"gases": gases.size(),
		"waste": waste.size(),
		"mining_modules": mining_modules.size(),
		"components": components.size(),
		"weapons": weapons.size(),
		"ammunition": ammunition.size(),
		"ship_modules": ship_modules.size(),
		"ships": ships.size(),
		"cached_items": item_lookup.size()
	}

func print_database_stats():
	"""Print database statistics to console"""
	var stats = get_database_stats()
	print("\n========== DATABASE STATISTICS ==========")
	print("Total Items: %d" % stats["total_items"])
	print("  - Ores: %d" % stats["ores"])
	print("  - Materials: %d" % stats["materials"])
	print("  - Gases: %d" % stats["gases"])
	print("  - Waste: %d" % stats["waste"])
	print("  - Mining Modules: %d" % stats["mining_modules"])
	print("  - Components: %d" % stats["components"])
	print("  - Weapons: %d" % stats["weapons"])
	print("  - Ammunition: %d" % stats["ammunition"])
	print("  - Ship Modules: %d" % stats["ship_modules"])
	print("  - Ships: %d" % stats["ships"])
	print("  - Cached: %d" % stats["cached_items"])
	print("=========================================\n")

# ============================================================================
# CRUD OPERATIONS (For future Database Editor)
# ============================================================================

func add_item(item: Dictionary) -> bool:
	"""Add new item to database"""
	var id = item.get("ID", "")
	if id.is_empty():
		push_error("Cannot add item without ID")
		return false

	if item_lookup.has(id):
		push_error("Item with ID %s already exists" % id)
		return false

	# Add to appropriate array based on DATABASE field
	var database = item.get("DATABASE", "")
	match database:
		"ORES":
			ores.append(item)
		"MATERIALS":
			materials.append(item)
		"GASES":
			gases.append(item)
		"WASTE":
			waste.append(item)
		"MINING_MODULES":
			mining_modules.append(item)
		"COMPONENTS":
			components.append(item)
		"WEAPONS":
			weapons.append(item)
		"AMMUNITION":
			ammunition.append(item)
		"MODULE", "SHIP_MODULES":
			ship_modules.append(item)
		"SHIP":
			ships.append(item)

	all_items.append(item)
	item_lookup[id] = item
	data_changed.emit()
	return true

func update_item(item_id: String, updated_data: Dictionary) -> bool:
	"""Update existing item"""
	var item = get_item_by_id(item_id)
	if item.is_empty():
		push_error("Item with ID %s not found" % item_id)
		return false

	# Update fields
	for key in updated_data:
		item[key] = updated_data[key]

	data_changed.emit()
	return true

func delete_item(item_id: String) -> bool:
	"""Delete item from database"""
	var item = get_item_by_id(item_id)
	if item.is_empty():
		return false

	# Remove from all_items
	var index = all_items.find(item)
	if index >= 0:
		all_items.remove_at(index)

	# Remove from specific array
	var database = item.get("DATABASE", "")
	match database:
		"ORES":
			ores.erase(item)
		"MATERIALS":
			materials.erase(item)
		"GASES":
			gases.erase(item)
		"WASTE":
			waste.erase(item)
		"MINING_MODULES":
			mining_modules.erase(item)
		"COMPONENTS":
			components.erase(item)
		"WEAPONS":
			weapons.erase(item)
		"AMMUNITION":
			ammunition.erase(item)
		"MODULE", "SHIP_MODULES":
			ship_modules.erase(item)
		"SHIP":
			ships.erase(item)

	# Remove from cache
	item_lookup.erase(item_id)
	data_changed.emit()
	return true
