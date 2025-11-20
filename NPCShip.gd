extends CharacterBody2D

# NPC Ship data
var ship_data = {
	"name": "NPC Test Ship",
	"mass": 40000.0,
	"cargo_general_capacity": 300.0,
	"cargo_ore_capacity": 1500.0,
	"cargo_mineral_capacity": 600.0,
	"cargo_ammo_capacity": 200.0,
	"cargo_build_capacity": 400.0,
	"cargo_gas_capacity": 800.0
}

# Cargo system (same as player)
enum CargoType { GENERAL, ORE, MINERAL, AMMO, BUILD, GAS }

var cargo_holds: Dictionary = {
	CargoType.GENERAL: {"items": {}, "used": 0.0},
	CargoType.ORE: {"items": {}, "used": 0.0},
	CargoType.MINERAL: {"items": {}, "used": 0.0},
	CargoType.AMMO: {"items": {}, "used": 0.0},
	CargoType.BUILD: {"items": {}, "used": 0.0},
	CargoType.GAS: {"items": {}, "used": 0.0}
}

@onready var sprite = $Sprite2D
@onready var label = $Label

func _ready():
	# Add to NPC group
	add_to_group("npc_ships")

	# Set ship name label
	if label:
		label.text = ship_data["name"]

	# Add some test cargo
	add_to_cargo_hold(CargoType.GENERAL, "test_item", 50.0)
	add_to_cargo_hold(CargoType.ORE, "ore_iron", 100.0)

func get_ship_info() -> Dictionary:
	"""Get ship information for UI"""
	return {
		"name": ship_data["name"],
		"mass": ship_data["mass"],
		"cargo_holds": cargo_holds.duplicate()
	}

func add_to_cargo_hold(cargo_type: CargoType, item_id: String, amount: float) -> float:
	"""Add item to specific cargo hold. Returns amount actually added."""
	var capacity_key = get_cargo_capacity_key(cargo_type)
	var max_capacity = ship_data.get(capacity_key, 0.0)
	var hold = cargo_holds[cargo_type]

	# Check available space
	var available = max_capacity - hold["used"]
	var to_add = min(amount, available)

	if to_add <= 0:
		return 0.0

	# Add to cargo (stackable)
	if hold["items"].has(item_id):
		hold["items"][item_id] += to_add
	else:
		hold["items"][item_id] = to_add

	hold["used"] += to_add
	return to_add

func remove_from_cargo_hold(cargo_type: CargoType, item_id: String, amount: float) -> float:
	"""Remove item from cargo hold. Returns amount actually removed."""
	var hold = cargo_holds[cargo_type]

	if not hold["items"].has(item_id):
		return 0.0

	var available = hold["items"][item_id]
	var to_remove = min(amount, available)

	hold["items"][item_id] -= to_remove
	if hold["items"][item_id] <= 0:
		hold["items"].erase(item_id)

	hold["used"] -= to_remove
	return to_remove

func get_cargo_capacity_key(cargo_type: CargoType) -> String:
	"""Get ship_data key for cargo capacity"""
	match cargo_type:
		CargoType.GENERAL:
			return "cargo_general_capacity"
		CargoType.ORE:
			return "cargo_ore_capacity"
		CargoType.MINERAL:
			return "cargo_mineral_capacity"
		CargoType.AMMO:
			return "cargo_ammo_capacity"
		CargoType.BUILD:
			return "cargo_build_capacity"
		CargoType.GAS:
			return "cargo_gas_capacity"
		_:
			return "cargo_general_capacity"

func get_cargo_hold_info(cargo_type: CargoType) -> Dictionary:
	"""Get cargo hold information"""
	var capacity_key = get_cargo_capacity_key(cargo_type)
	var max_capacity = ship_data.get(capacity_key, 0.0)
	var hold = cargo_holds[cargo_type]

	return {
		"used": hold["used"],
		"capacity": max_capacity,
		"items": hold["items"].duplicate()
	}
