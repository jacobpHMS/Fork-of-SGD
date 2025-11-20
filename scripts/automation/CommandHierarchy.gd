extends Node

# Command Hierarchy - Fleet command chains
signal fleet_created(fleet_id: String)
signal ship_assigned_to_fleet(ship_id: String, fleet_id: String)

class Fleet:
	var fleet_id: String
	var commander_id: String  # NPC or player ship
	var ships: Array[String] = []
	var orders: Dictionary = {}
	
	func _init(id: String, commander: String):
		fleet_id = id
		commander_id = commander

var fleets: Dictionary = {}
var orchestrator: Node = null

func _ready():
	print("🎖️  Command Hierarchy initialized")

func set_orchestrator(orch: Node):
	orchestrator = orch

func create_fleet(commander_id: String) -> String:
	var fleet_id = "fleet_%d" % Time.get_ticks_msec()
	var fleet = Fleet.new(fleet_id, commander_id)
	fleets[fleet_id] = fleet
	emit_signal("fleet_created", fleet_id)
	return fleet_id

func assign_ship_to_fleet(ship_id: String, fleet_id: String):
	if fleets.has(fleet_id):
		fleets[fleet_id].ships.append(ship_id)
		emit_signal("ship_assigned_to_fleet", ship_id, fleet_id)

func command_fleet(fleet_id: String, command: Dictionary):
	if fleets.has(fleet_id):
		fleets[fleet_id].orders = command
		# Propagate to all ships
		for ship_id in fleets[fleet_id].ships:
			if orchestrator and orchestrator.npc_manager:
				orchestrator.dispatch_command(ship_id, command)

func get_fleet_count() -> int:
	return fleets.size()

func _world_tick(tick: int):
	pass

func get_save_data() -> Dictionary:
	return {"fleets": fleets.duplicate()}

func load_save_data(data: Dictionary):
	if data.has("fleets"): fleets = data["fleets"]
