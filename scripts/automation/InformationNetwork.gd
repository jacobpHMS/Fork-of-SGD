extends Node

# Information Network - X4-style visibility & sensor system
# Navigation Satellites, Scout ships, Sensors

class SensorNode:
	var node_id: String
	var position: Vector2
	var sensor_range: float = 5000.0
	var faction_id: String = ""
	var node_type: String = "satellite"  # satellite, scout, station
	
	func _init(id: String, pos: Vector2, faction: String):
		node_id = id
		position = pos
		faction_id = faction

var sensor_nodes: Dictionary = {}  # node_id -> SensorNode
var visibility_cache: Dictionary = {}  # faction_id -> Array[visible_objects]
var orchestrator: Node = null

func _ready():
	print("📡 Information Network initialized")

func set_orchestrator(orch: Node):
	orchestrator = orch

func deploy_nav_satellite(position: Vector2, faction_id: String) -> String:
	var sat_id = "navsat_%d" % Time.get_ticks_msec()
	var sensor = SensorNode.new(sat_id, position, faction_id)
	sensor.sensor_range = 10000.0
	sensor_nodes[sat_id] = sensor
	print("📡 Navigation Satellite deployed at %v" % position)
	return sat_id

func register_scout(ship_id: String, position: Vector2, faction_id: String):
	if not sensor_nodes.has(ship_id):
		var sensor = SensorNode.new(ship_id, position, faction_id)
		sensor.node_type = "scout"
		sensor.sensor_range = 3000.0
		sensor_nodes[ship_id] = sensor

func query_visible_objects(position: Vector2, range: float) -> Array:
	var visible = []
	
	# Check what sensor nodes can see
	for node_id in sensor_nodes:
		var sensor = sensor_nodes[node_id]
		if sensor.position.distance_to(position) <= sensor.sensor_range + range:
			# This sensor can see the queried area
			if orchestrator and orchestrator.npc_manager:
				var nearby = orchestrator.npc_manager.get_ships_in_range(sensor.position, sensor.sensor_range)
				visible.append_array(nearby)
	
	return visible

func _world_tick(tick: int):
	# Update visibility cache
	if tick % 10 == 0:  # Every 10 ticks
		update_visibility_cache()

func update_visibility_cache():
	visibility_cache.clear()
	# Rebuild visibility for all factions
	pass

func get_save_data() -> Dictionary:
	return {"sensor_nodes": sensor_nodes.duplicate()}

func load_save_data(data: Dictionary):
	if data.has("sensor_nodes"): sensor_nodes = data["sensor_nodes"]
