extends Node
## Extended Map Features - Routes, Jumpgates, Fleet Tracking

signal route_calculated(route: Array)
signal jumpgate_activated(gate_id: String, destination: String)
signal bookmark_created(bookmark_id: String, position: Vector2)

var jumpgates: Dictionary = {}  # gate_id -> JumpgateData
var bookmarks: Dictionary = {}  # player_id -> Array[Bookmark]
var fleet_positions: Dictionary = {}  # fleet_id -> Vector2

class JumpgateData:
	var gate_id: String
	var position: Vector2
	var destination_system: String
	var construction_phase: int = 0  # 0-4
	var is_player_built: bool = false

	func _init(p_id: String, p_pos: Vector2, p_dest: String):
		gate_id = p_id
		position = p_pos
		destination_system = p_dest

class Bookmark:
	var bookmark_id: String
	var name: String
	var position: Vector2
	var category: String  # "mining", "combat", "trade"

	func _init(p_id: String, p_name: String, p_pos: Vector2, p_cat: String):
		bookmark_id = p_id
		name = p_name
		position = p_pos
		category = p_cat

func calculate_route(start: String, end: String) -> Array:
	"""A* pathfinding between systems"""
	# TODO: Implement A* algorithm
	var route = [start, end]  # Placeholder
	route_calculated.emit(route)
	return route

func build_jumpgate_phase(gate_id: String, phase: int):
	"""Progress jumpgate construction"""
	if jumpgates.has(gate_id):
		jumpgates[gate_id].construction_phase = phase
		print("🌀 Jumpgate %s: Phase %d/4 complete" % [gate_id, phase])

func create_bookmark(player_id: String, name: String, position: Vector2, category: String):
	if not bookmarks.has(player_id):
		bookmarks[player_id] = []

	var bookmark_id = "BM_%d" % Time.get_unix_time_from_system()
	var bookmark = Bookmark.new(bookmark_id, name, position, category)
	bookmarks[player_id].append(bookmark)
	bookmark_created.emit(bookmark_id, position)

func update_fleet_position(fleet_id: String, position: Vector2):
	fleet_positions[fleet_id] = position

func _ready():
	print("🗺️ ExtendedMapSystem: Ready")
