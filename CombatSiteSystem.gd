extends Node
## Combat Sites - PvE Dungeons with Loot

signal combat_site_spawned(site_id: String, difficulty: int)
signal wave_cleared(site_id: String, wave: int)
signal loot_dropped(site_id: String, loot: Dictionary)

var active_sites: Dictionary = {}  # site_id -> CombatSiteData

class CombatSiteData:
	var site_id: String
	var difficulty: int  # 1-10
	var position: Vector2
	var current_wave: int = 0
	var total_waves: int = 5
	var loot_table: Array = []

	func _init(p_id: String, p_diff: int, p_pos: Vector2):
		site_id = p_id
		difficulty = p_diff
		position = p_pos
		total_waves = 3 + difficulty

func spawn_combat_site(difficulty: int, position: Vector2) -> String:
	var site_id = "SITE_%d" % Time.get_unix_time_from_system()
	var site = CombatSiteData.new(site_id, difficulty, position)

	# Generate loot table
	site.loot_table = _generate_loot(difficulty)

	active_sites[site_id] = site
	combat_site_spawned.emit(site_id, difficulty)

	print("⚔️ Combat site spawned: %s (Difficulty: %d)" % [site_id, difficulty])
	return site_id

func clear_wave(site_id: String):
	if not active_sites.has(site_id):
		return

	var site = active_sites[site_id]
	site.current_wave += 1

	wave_cleared.emit(site_id, site.current_wave)

	if site.current_wave >= site.total_waves:
		_drop_loot(site)
		active_sites.erase(site_id)

func _generate_loot(difficulty: int) -> Array:
	var loot = []
	for i in range(difficulty):
		loot.append({"item_id": "LOOT_BLUEPRINT_RANDOM", "chance": 0.1 * difficulty})
	return loot

func _drop_loot(site: CombatSiteData):
	var dropped = {}
	for loot_entry in site.loot_table:
		if randf() < loot_entry.chance:
			dropped[loot_entry.item_id] = 1

	loot_dropped.emit(site.site_id, dropped)

func _ready():
	print("⚔️ CombatSiteSystem: Ready")
