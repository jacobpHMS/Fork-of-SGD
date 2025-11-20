extends Node

# Singleton for ore database management
# Usage: OreDatabase.get_ore_data("ORE_T1_001", "Q2")

var ore_database: Dictionary = {}
var loaded: bool = false

func _ready():
	load_database()

func load_database():
	var file_path = "res://data/ore_database.json"

	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()

			var json = JSON.new()
			var parse_result = json.parse(json_string)

			if parse_result == OK:
				var data = json.data
				if data and data.has("ore_types"):
					# Index by ore_id and quality_tier for fast lookup
					for ore in data["ore_types"]:
						var key = "%s_%s" % [ore["ore_id"], ore["quality_tier"]]
						ore_database[key] = ore

					loaded = true
					print("✓ Ore database loaded: %d entries" % ore_database.size())
				else:
					push_error("Invalid ore database format")
			else:
				push_error("Failed to parse ore database JSON")
	else:
		push_error("Ore database file not found: " + file_path)

func get_ore_data(ore_id: String, quality_tier: String = "Q2") -> Dictionary:
	var key = "%s_%s" % [ore_id, quality_tier]
	if ore_database.has(key):
		return ore_database[key]
	else:
		push_warning("Ore not found: " + key)
		return {}

func get_random_ore() -> Dictionary:
	if ore_database.size() == 0:
		return {}

	var keys = ore_database.keys()
	var random_key = keys[randi() % keys.size()]
	return ore_database[random_key]

func get_ore_list() -> Array:
	return ore_database.values()

func get_ore_by_tier(tier: String) -> Array:
	var result = []
	for ore in ore_database.values():
		if ore["quality_tier"] == tier:
			result.append(ore)
	return result

func get_ore_names() -> Array:
	var names = []
	var seen = {}
	for ore in ore_database.values():
		var ore_name = ore["ore_name"]
		if not seen.has(ore_name):
			names.append(ore_name)
			seen[ore_name] = true
	return names
