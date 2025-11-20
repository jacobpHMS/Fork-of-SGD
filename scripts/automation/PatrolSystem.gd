extends Node

# Patrol System - Manages patrol routes and behaviors
class PatrolRoute:
	var route_id: String
	var waypoints: Array[Vector2] = []
	var assigned_ships: Array[String] = []
	var is_loop: bool = true
	
	func _init(id: String):
		route_id = id

var patrol_routes: Dictionary = {}
var orchestrator: Node = null

func _ready():
	print("🛡️  Patrol System initialized")

func set_orchestrator(orch: Node):
	orchestrator = orch

func create_patrol_route(waypoints: Array[Vector2], loop: bool = true) -> String:
	var route_id = "patrol_%d" % Time.get_ticks_msec()
	var route = PatrolRoute.new(route_id)
	route.waypoints = waypoints
	route.is_loop = loop
	patrol_routes[route_id] = route
	return route_id

func assign_patrol(ship_id: String, route_id: String):
	if patrol_routes.has(route_id):
		patrol_routes[route_id].assigned_ships.append(ship_id)

func _world_tick(tick: int):
	pass

func get_save_data() -> Dictionary:
	return {"patrol_routes": patrol_routes.duplicate()}

func load_save_data(data: Dictionary):
	if data.has("patrol_routes"): patrol_routes = data["patrol_routes"]
