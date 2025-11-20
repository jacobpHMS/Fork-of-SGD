extends Node
# Station AI - Autonomous station management
var orchestrator: Node = null
func _ready(): print("🏭 Station AI initialized")
func set_orchestrator(orch: Node): orchestrator = orch
func _world_tick(tick: int): pass
func get_save_data() -> Dictionary: return {}
func load_save_data(data: Dictionary): pass
