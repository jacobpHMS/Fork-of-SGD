extends Node

# Combat AI - Aggression Manager & Tactical AI
signal combat_initiated(attacker_id: String, target_id: String)
signal combat_ended(attacker_id: String, target_id: String)

enum AggressionLevel { PASSIVE, DEFENSIVE, NEUTRAL, AGGRESSIVE, BERSERK }
enum TacticalState { HOLD, ADVANCE, RETREAT, FLANK, REGROUP }

class CombatState:
	var ship_id: String
	var target_id: String = ""
	var aggression: AggressionLevel = AggressionLevel.NEUTRAL
	var tactical_state: TacticalState = TacticalState.HOLD
	var threat_level: float = 0.0  # 0-1 how threatened
	var morale: float = 1.0  # 0-1, affects fleeing
	
	func _init(id: String):
		ship_id = id
	
	func should_flee() -> bool:
		return morale < 0.3 or threat_level > 0.8

var combat_states: Dictionary = {}  # ship_id -> CombatState
var orchestrator: Node = null

func _ready():
	print("⚔️  Combat AI initialized")

func set_orchestrator(orch: Node):
	orchestrator = orch

func _orchestrated_update(delta: float):
	# Update combat states
	for ship_id in combat_states:
		var state = combat_states[ship_id]
		update_combat_state(state, delta)

func assign_combat_command(ship_id: String, command: Dictionary):
	if not combat_states.has(ship_id):
		combat_states[ship_id] = CombatState.new(ship_id)
	
	var state = combat_states[ship_id]
	state.target_id = command.get("target", "")
	state.aggression = command.get("aggression", AggressionLevel.NEUTRAL)

func update_combat_state(state: CombatState, delta: float):
	# Check if should flee
	if state.should_flee():
		state.tactical_state = TacticalState.RETREAT
		if orchestrator and orchestrator.npc_manager:
			var npc = orchestrator.npc_manager.get_npc(state.ship_id)
			if npc:
				npc.set_behavior(orchestrator.npc_manager.NPCBehavior.FLEEING)
	
	# Update threat level based on damage taken
	if orchestrator and orchestrator.npc_manager:
		var npc = orchestrator.npc_manager.get_npc(state.ship_id)
		if npc:
			var hull_percent = npc.hull / npc.max_hull
			state.threat_level = 1.0 - hull_percent
			state.morale = hull_percent * 0.8 + 0.2

func _world_tick(tick: int):
	pass

func get_save_data() -> Dictionary:
	return {"combat_states": combat_states.duplicate()}

func load_save_data(data: Dictionary):
	if data.has("combat_states"): combat_states = data["combat_states"]
