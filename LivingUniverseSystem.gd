extends Node
## Living Universe - NPC Corps, AI Wars, Economic Cycles

signal npc_corp_formed(corp_id: String)
signal war_declared(attacker_id: String, defender_id: String)
signal economic_cycle_changed(region: String, cycle: String)
signal tech_unlocked(tech_id: String)

var npc_corporations: Dictionary = {}  # corp_id -> NPCCorporation
var active_wars: Array = []
var galactic_tech_level: int = 1
var economic_cycles: Dictionary = {}  # region -> "boom" / "bust"

class NPCCorporation:
	var corp_id: String
	var corp_name: String
	var resources: float = 1000000.0
	var owned_systems: Array = []
	var ai_personality: String = "neutral"  # aggressive, peaceful, trading

	func _init(p_id: String, p_name: String):
		corp_id = p_id
		corp_name = p_name

func _ready():
	print("🌌 LivingUniverseSystem: Initializing...")
	_create_npc_corps()
	_start_economic_simulation()
	print("✅ LivingUniverseSystem: Ready")

func _create_npc_corps():
	for i in range(5):
		var corp_id = "NPC_CORP_%d" % i
		var corp = NPCCorporation.new(corp_id, "Corporation Alpha-%d" % i)
		corp.ai_personality = ["aggressive", "peaceful", "trading"][randi() % 3]
		npc_corporations[corp_id] = corp
		npc_corp_formed.emit(corp_id)

func _start_economic_simulation():
	economic_cycles["INNER_SYSTEMS"] = "boom"
	economic_cycles["OUTER_SYSTEMS"] = "stable"
	economic_cycles["FRONTIER"] = "bust"

func simulate_npc_decision_making():
	"""AI-driven corp decisions"""
	for corp in npc_corporations.values():
		if corp.ai_personality == "aggressive" and randf() < 0.1:
			_declare_war(corp.corp_id)

func _declare_war(aggressor_id: String):
	var target = npc_corporations.keys()[randi() % npc_corporations.size()]
	if target != aggressor_id:
		war_declared.emit(aggressor_id, target)
		print("⚔️ War: %s vs %s" % [aggressor_id, target])

func unlock_galactic_tech(tech_id: String):
	galactic_tech_level += 1
	tech_unlocked.emit(tech_id)
	print("🔬 Galactic tech unlocked: %s (Level %d)" % [tech_id, galactic_tech_level])
