extends Node

# ============================================================================
# SHIP DATABASE - Complete Ship Registry & Templates
# ============================================================================
# Comprehensive database of all ship types for player and NPCs
# Includes: Stats, Equipment, AI Behaviors, Cargo Capacities
# Integrated with: ItemDatabase, CombatSystem, NPCManager

signal ship_spawned(ship_id: String, ship_data: Dictionary)

# Ship classifications
enum ShipClass {
	EXPLORER = 0,      # Player ships, versatile
	MINER = 1,         # Mining vessels
	FIGHTER = 2,       # Combat ships (small)
	CORVETTE = 3,      # Combat ships (medium)
	FRIGATE = 4,       # Combat ships (large)
	TRADER = 5,        # Cargo haulers
	TRANSPORT = 6,     # Bulk transport
	POLICE = 7,        # Law enforcement
	PIRATE = 8,        # Illegal operations
	SPECIAL = 9        # Unique/quest ships
}

# Ship sizes (affects collision, docking, etc.)
enum ShipSize {
	SMALL = 0,    # < 50m (fighters, miners)
	MEDIUM = 1,   # 50-150m (corvettes, traders)
	LARGE = 2,    # 150-500m (frigates, transports)
	CAPITAL = 3   # > 500m (battleships, carriers)
}

# AI behavior types
enum AIBehavior {
	NONE = 0,           # Player-controlled
	MINER = 1,          # Mining behavior loop
	TRADER = 2,         # Trading routes
	PATROL = 3,         # Patrol routes
	AGGRESSIVE = 4,     # Attack on sight
	DEFENSIVE = 5,      # Defend territory
	FLEE = 6,           # Run from danger
	ESCORT = 7,         # Follow and protect
	PIRATE = 8          # Opportunistic attacks
}

# Ship template data structure
class ShipTemplate:
	# Basic info
	var ship_id: String = ""
	var ship_name: String = ""
	var ship_class: ShipClass = ShipClass.EXPLORER
	var ship_size: ShipSize = ShipSize.SMALL
	var description: String = ""

	# Core stats
	var hull_max: int = 1000
	var shields_max: int = 500
	var energy_max: int = 1000
	var energy_regen: float = 10.0

	# Cargo & storage
	var cargo_capacity: float = 1000.0  # m³
	var ore_hold_capacity: float = 0.0  # Specialized ore hold
	var fuel_capacity: float = 500.0
	var ammo_capacity: int = 0

	# Movement
	var max_speed: float = 100.0        # m/s
	var acceleration: float = 20.0      # m/s²
	var turn_rate: float = 90.0         # degrees/s
	var mass: float = 10000.0           # kg

	# Equipment slots
	var weapon_slots: int = 0
	var module_slots: int = 4
	var utility_slots: int = 2

	# Pre-installed equipment
	var default_weapons: Array = []     # Array of module IDs
	var default_modules: Array = []     # Array of module IDs

	# AI behavior
	var ai_behavior: AIBehavior = AIBehavior.NONE
	var ai_aggression: float = 0.0      # 0.0-1.0
	var ai_courage: float = 0.5         # 0.0-1.0 (flee threshold)
	var ai_skill: float = 0.5           # 0.0-1.0 (accuracy, tactics)

	# Economy
	var base_price: int = 100000
	var craft_time: float = 3600.0      # Seconds
	var salvage_value: int = 50000      # 50% of price

	# Assets
	var sprite_path: String = ""
	var icon_path: String = ""
	var engine_particle: String = ""

	# Faction (for NPCs)
	var faction: String = "neutral"     # neutral, police, pirate, etc.

	func _init(id: String, name: String, cls: ShipClass):
		ship_id = id
		ship_name = name
		ship_class = cls

	func get_info() -> Dictionary:
		return {
			"id": ship_id,
			"name": ship_name,
			"class": ShipClass.keys()[ship_class],
			"size": ShipSize.keys()[ship_size],
			"description": description,
			"hull": hull_max,
			"shields": shields_max,
			"energy": energy_max,
			"cargo": cargo_capacity,
			"speed": max_speed,
			"weapons": weapon_slots,
			"modules": module_slots,
			"ai_behavior": AIBehavior.keys()[ai_behavior],
			"price": base_price,
			"faction": faction
		}

	func clone() -> ShipTemplate:
		"""Create a copy of this template"""
		var copy = ShipTemplate.new(ship_id, ship_name, ship_class)
		copy.ship_size = ship_size
		copy.description = description
		copy.hull_max = hull_max
		copy.shields_max = shields_max
		copy.energy_max = energy_max
		copy.energy_regen = energy_regen
		copy.cargo_capacity = cargo_capacity
		copy.ore_hold_capacity = ore_hold_capacity
		copy.fuel_capacity = fuel_capacity
		copy.ammo_capacity = ammo_capacity
		copy.max_speed = max_speed
		copy.acceleration = acceleration
		copy.turn_rate = turn_rate
		copy.mass = mass
		copy.weapon_slots = weapon_slots
		copy.module_slots = module_slots
		copy.utility_slots = utility_slots
		copy.default_weapons = default_weapons.duplicate()
		copy.default_modules = default_modules.duplicate()
		copy.ai_behavior = ai_behavior
		copy.ai_aggression = ai_aggression
		copy.ai_courage = ai_courage
		copy.ai_skill = ai_skill
		copy.base_price = base_price
		copy.craft_time = craft_time
		copy.salvage_value = salvage_value
		copy.sprite_path = sprite_path
		copy.icon_path = icon_path
		copy.engine_particle = engine_particle
		copy.faction = faction
		return copy

# Ship registry
var ship_registry: Dictionary = {}  # ship_id -> ShipTemplate

func _ready():
	print("🚀 Ship Database initializing...")
	initialize_all_ships()
	print("✅ Ship Database loaded: %d ship templates" % ship_registry.size())

# ============================================================================
# DATABASE INITIALIZATION
# ============================================================================

func initialize_all_ships():
	"""Initialize all ship templates"""
	initialize_player_ships()    # 3 player variants
	initialize_mining_ships()    # 3 mining vessels
	initialize_combat_ships()    # 4 combat vessels
	initialize_trader_ships()    # 2 trader vessels
	initialize_special_ships()   # 2 special vessels

# ============================================================================
# PLAYER SHIPS
# ============================================================================

func initialize_player_ships():
	"""Initialize player-controlled ships"""

	# EXPLORER-CLASS: Starting ship (balanced)
	var explorer = ShipTemplate.new("ship_player_explorer", "Explorer-Class Vessel", ShipClass.EXPLORER)
	explorer.ship_size = ShipSize.SMALL
	explorer.description = "Versatile exploration ship. Balanced stats for mining, trading, and light combat."
	explorer.hull_max = 1000
	explorer.shields_max = 500
	explorer.energy_max = 1000
	explorer.energy_regen = 15.0
	explorer.cargo_capacity = 1000.0
	explorer.fuel_capacity = 800.0
	explorer.max_speed = 120.0
	explorer.acceleration = 25.0
	explorer.turn_rate = 120.0
	explorer.mass = 8000.0
	explorer.weapon_slots = 2
	explorer.module_slots = 4
	explorer.utility_slots = 2
	explorer.default_modules = ["module_mining_laser_t1", "module_scanner_t1"]
	explorer.ai_behavior = AIBehavior.NONE
	explorer.base_price = 500000
	explorer.craft_time = 1800.0
	explorer.sprite_path = "res://assets/sprites/ships/ship_player_explorer_idle.png"
	explorer.icon_path = "res://assets/icons/ships/ship_player_explorer.png"
	explorer.engine_particle = "res://assets/particles/engine_blue.tres"
	explorer.faction = "player"
	register_ship(explorer)

	# PROSPECTOR-CLASS: Mining specialist
	var prospector = ShipTemplate.new("ship_player_prospector", "Prospector-Class Miner", ShipClass.MINER)
	prospector.ship_size = ShipSize.SMALL
	prospector.description = "Specialized mining vessel. Enhanced cargo hold and mining efficiency."
	prospector.hull_max = 1200
	prospector.shields_max = 400
	prospector.energy_max = 1200
	prospector.energy_regen = 18.0
	prospector.cargo_capacity = 2500.0
	prospector.ore_hold_capacity = 3000.0  # Bonus ore hold
	prospector.fuel_capacity = 1000.0
	prospector.max_speed = 90.0
	prospector.acceleration = 20.0
	prospector.turn_rate = 90.0
	prospector.mass = 12000.0
	prospector.weapon_slots = 1
	prospector.module_slots = 5
	prospector.utility_slots = 3
	prospector.default_modules = ["module_mining_laser_t2", "module_scanner_t1", "module_cargo_expander"]
	prospector.ai_behavior = AIBehavior.NONE
	prospector.base_price = 800000
	prospector.craft_time = 2400.0
	prospector.sprite_path = "res://assets/sprites/ships/ship_player_prospector_idle.png"
	prospector.icon_path = "res://assets/icons/ships/ship_player_prospector.png"
	prospector.engine_particle = "res://assets/particles/engine_yellow.tres"
	prospector.faction = "player"
	register_ship(prospector)

	# VANGUARD-CLASS: Combat specialist
	var vanguard = ShipTemplate.new("ship_player_vanguard", "Vanguard-Class Fighter", ShipClass.FIGHTER)
	vanguard.ship_size = ShipSize.SMALL
	vanguard.description = "Fast attack fighter. Superior weapons and shields, minimal cargo."
	vanguard.hull_max = 800
	vanguard.shields_max = 800
	vanguard.energy_max = 1500
	vanguard.energy_regen = 25.0
	vanguard.cargo_capacity = 400.0
	vanguard.fuel_capacity = 600.0
	vanguard.ammo_capacity = 2000
	vanguard.max_speed = 180.0
	vanguard.acceleration = 40.0
	vanguard.turn_rate = 180.0
	vanguard.mass = 6000.0
	vanguard.weapon_slots = 4
	vanguard.module_slots = 3
	vanguard.utility_slots = 2
	vanguard.default_weapons = ["module_weapon_laser_t1", "module_weapon_cannon_t1"]
	vanguard.default_modules = ["module_shield_t1"]
	vanguard.ai_behavior = AIBehavior.NONE
	vanguard.base_price = 1200000
	vanguard.craft_time = 3000.0
	vanguard.sprite_path = "res://assets/sprites/ships/ship_player_vanguard_idle.png"
	vanguard.icon_path = "res://assets/icons/ships/ship_player_vanguard.png"
	vanguard.engine_particle = "res://assets/particles/engine_red.tres"
	vanguard.faction = "player"
	register_ship(vanguard)

# ============================================================================
# MINING SHIPS (NPC)
# ============================================================================

func initialize_mining_ships():
	"""Initialize NPC mining vessels"""

	# SMALL MINING FRIGATE
	var miner_small = ShipTemplate.new("ship_miner_small", "Mining Frigate", ShipClass.MINER)
	miner_small.ship_size = ShipSize.SMALL
	miner_small.description = "Basic automated mining drone. Targets common ores."
	miner_small.hull_max = 800
	miner_small.shields_max = 200
	miner_small.energy_max = 800
	miner_small.energy_regen = 12.0
	miner_small.cargo_capacity = 1500.0
	miner_small.ore_hold_capacity = 2000.0
	miner_small.fuel_capacity = 500.0
	miner_small.max_speed = 70.0
	miner_small.acceleration = 15.0
	miner_small.turn_rate = 60.0
	miner_small.mass = 15000.0
	miner_small.weapon_slots = 0
	miner_small.module_slots = 2
	miner_small.default_modules = ["module_mining_laser_t1"]
	miner_small.ai_behavior = AIBehavior.MINER
	miner_small.ai_aggression = 0.0
	miner_small.ai_courage = 0.2  # Flees easily
	miner_small.ai_skill = 0.3
	miner_small.base_price = 300000
	miner_small.salvage_value = 150000
	miner_small.sprite_path = "res://assets/sprites/ships/ship_npc_miner_small_idle.png"
	miner_small.icon_path = "res://assets/icons/ships/ship_miner_small.png"
	miner_small.engine_particle = "res://assets/particles/engine_orange.tres"
	miner_small.faction = "miners_guild"
	register_ship(miner_small)

	# MEDIUM MINING BARGE
	var miner_medium = ShipTemplate.new("ship_miner_medium", "Mining Barge", ShipClass.MINER)
	miner_medium.ship_size = ShipSize.MEDIUM
	miner_medium.description = "Industrial mining vessel. Large ore capacity, dual lasers."
	miner_medium.hull_max = 1500
	miner_medium.shields_max = 400
	miner_medium.energy_max = 1200
	miner_medium.energy_regen = 15.0
	miner_medium.cargo_capacity = 3000.0
	miner_medium.ore_hold_capacity = 5000.0
	miner_medium.fuel_capacity = 1000.0
	miner_medium.max_speed = 50.0
	miner_medium.acceleration = 10.0
	miner_medium.turn_rate = 40.0
	miner_medium.mass = 35000.0
	miner_medium.weapon_slots = 0
	miner_medium.module_slots = 3
	miner_medium.default_modules = ["module_mining_laser_t1", "module_mining_laser_t1"]  # Dual lasers
	miner_medium.ai_behavior = AIBehavior.MINER
	miner_medium.ai_aggression = 0.0
	miner_medium.ai_courage = 0.3
	miner_medium.ai_skill = 0.5
	miner_medium.base_price = 1200000
	miner_medium.salvage_value = 600000
	miner_medium.sprite_path = "res://assets/sprites/ships/ship_npc_miner_medium_idle.png"
	miner_medium.icon_path = "res://assets/icons/ships/ship_miner_medium.png"
	miner_medium.engine_particle = "res://assets/particles/engine_orange.tres"
	miner_medium.faction = "miners_guild"
	register_ship(miner_medium)

	# LARGE MINING HAULER
	var miner_large = ShipTemplate.new("ship_miner_large", "Industrial Hauler", ShipClass.MINER)
	miner_large.ship_size = ShipSize.LARGE
	miner_large.description = "Massive mining operation. Extremely slow but enormous capacity."
	miner_large.hull_max = 3000
	miner_large.shields_max = 800
	miner_large.energy_max = 2000
	miner_large.energy_regen = 20.0
	miner_large.cargo_capacity = 8000.0
	miner_large.ore_hold_capacity = 15000.0
	miner_large.fuel_capacity = 2000.0
	miner_large.max_speed = 30.0
	miner_large.acceleration = 5.0
	miner_large.turn_rate = 20.0
	miner_large.mass = 80000.0
	miner_large.weapon_slots = 1
	miner_large.module_slots = 5
	miner_large.default_modules = ["module_mining_laser_t2", "module_mining_laser_t2"]
	miner_large.default_weapons = ["module_weapon_cannon_t1"]  # Self-defense
	miner_large.ai_behavior = AIBehavior.MINER
	miner_large.ai_aggression = 0.1
	miner_large.ai_courage = 0.4
	miner_large.ai_skill = 0.7
	miner_large.base_price = 3500000
	miner_large.salvage_value = 1750000
	miner_large.sprite_path = "res://assets/sprites/ships/ship_npc_miner_large_idle.png"
	miner_large.icon_path = "res://assets/icons/ships/ship_miner_large.png"
	miner_large.engine_particle = "res://assets/particles/engine_orange_large.tres"
	miner_large.faction = "miners_guild"
	register_ship(miner_large)

# ============================================================================
# COMBAT SHIPS (NPC)
# ============================================================================

func initialize_combat_ships():
	"""Initialize NPC combat vessels"""

	# LIGHT INTERCEPTOR (fast, fragile)
	var fighter_light = ShipTemplate.new("ship_fighter_light", "Interceptor-Class Fighter", ShipClass.FIGHTER)
	fighter_light.ship_size = ShipSize.SMALL
	fighter_light.description = "Fast attack fighter. Hit-and-run tactics, minimal armor."
	fighter_light.hull_max = 600
	fighter_light.shields_max = 400
	fighter_light.energy_max = 1200
	fighter_light.energy_regen = 20.0
	fighter_light.cargo_capacity = 200.0
	fighter_light.fuel_capacity = 400.0
	fighter_light.ammo_capacity = 1000
	fighter_light.max_speed = 200.0
	fighter_light.acceleration = 50.0
	fighter_light.turn_rate = 200.0
	fighter_light.mass = 4000.0
	fighter_light.weapon_slots = 3
	fighter_light.module_slots = 2
	fighter_light.default_weapons = ["module_weapon_laser_t1", "module_weapon_laser_t1"]
	fighter_light.ai_behavior = AIBehavior.AGGRESSIVE
	fighter_light.ai_aggression = 0.8
	fighter_light.ai_courage = 0.5
	fighter_light.ai_skill = 0.6
	fighter_light.base_price = 400000
	fighter_light.salvage_value = 200000
	fighter_light.sprite_path = "res://assets/sprites/ships/ship_npc_fighter_light_idle.png"
	fighter_light.icon_path = "res://assets/icons/ships/ship_fighter_light.png"
	fighter_light.engine_particle = "res://assets/particles/engine_blue_fast.tres"
	fighter_light.faction = "pirates"  # Can be police or pirate
	register_ship(fighter_light)

	# HEAVY FIGHTER (balanced)
	var fighter_heavy = ShipTemplate.new("ship_fighter_heavy", "Viper-Class Heavy Fighter", ShipClass.FIGHTER)
	fighter_heavy.ship_size = ShipSize.SMALL
	fighter_heavy.description = "Durable fighter. Balanced speed and firepower."
	fighter_heavy.hull_max = 1000
	fighter_heavy.shields_max = 600
	fighter_heavy.energy_max = 1500
	fighter_heavy.energy_regen = 22.0
	fighter_heavy.cargo_capacity = 300.0
	fighter_heavy.fuel_capacity = 600.0
	fighter_heavy.ammo_capacity = 1500
	fighter_heavy.max_speed = 150.0
	fighter_heavy.acceleration = 35.0
	fighter_heavy.turn_rate = 150.0
	fighter_heavy.mass = 7000.0
	fighter_heavy.weapon_slots = 4
	fighter_heavy.module_slots = 3
	fighter_heavy.default_weapons = ["module_weapon_cannon_t1", "module_weapon_laser_t1"]
	fighter_heavy.default_modules = ["module_shield_t1"]
	fighter_heavy.ai_behavior = AIBehavior.AGGRESSIVE
	fighter_heavy.ai_aggression = 0.7
	fighter_heavy.ai_courage = 0.6
	fighter_heavy.ai_skill = 0.7
	fighter_heavy.base_price = 800000
	fighter_heavy.salvage_value = 400000
	fighter_heavy.sprite_path = "res://assets/sprites/ships/ship_npc_fighter_heavy_idle.png"
	fighter_heavy.icon_path = "res://assets/icons/ships/ship_fighter_heavy.png"
	fighter_heavy.engine_particle = "res://assets/particles/engine_blue.tres"
	fighter_heavy.faction = "military"
	register_ship(fighter_heavy)

	# CORVETTE (small capital ship)
	var corvette = ShipTemplate.new("ship_corvette", "Corvette-Class Patrol Ship", ShipClass.CORVETTE)
	corvette.ship_size = ShipSize.MEDIUM
	corvette.description = "Patrol vessel. Heavy armor and weapons, slow movement."
	corvette.hull_max = 2000
	corvette.shields_max = 1000
	corvette.energy_max = 2000
	corvette.energy_regen = 25.0
	corvette.cargo_capacity = 500.0
	corvette.fuel_capacity = 1200.0
	corvette.ammo_capacity = 3000
	corvette.max_speed = 80.0
	corvette.acceleration = 15.0
	corvette.turn_rate = 60.0
	corvette.mass = 25000.0
	corvette.weapon_slots = 6
	corvette.module_slots = 5
	corvette.default_weapons = ["module_weapon_cannon_t1", "module_weapon_cannon_t1", "module_weapon_laser_t1"]
	corvette.default_modules = ["module_shield_t1", "module_armor_plating_t1"]
	corvette.ai_behavior = AIBehavior.PATROL
	corvette.ai_aggression = 0.5
	corvette.ai_courage = 0.8
	corvette.ai_skill = 0.8
	corvette.base_price = 2500000
	corvette.salvage_value = 1250000
	corvette.sprite_path = "res://assets/sprites/ships/ship_npc_corvette_idle.png"
	corvette.icon_path = "res://assets/icons/ships/ship_corvette.png"
	corvette.engine_particle = "res://assets/particles/engine_white.tres"
	corvette.faction = "police"
	register_ship(corvette)

	# PIRATE RAIDER (aggressive AI)
	var pirate = ShipTemplate.new("ship_pirate_raider", "Raider-Class Pirate Ship", ShipClass.PIRATE)
	pirate.ship_size = ShipSize.SMALL
	pirate.description = "Pirate vessel. Attacks traders, flees from military."
	pirate.hull_max = 800
	pirate.shields_max = 300
	pirate.energy_max = 1000
	pirate.energy_regen = 15.0
	pirate.cargo_capacity = 800.0
	pirate.fuel_capacity = 500.0
	pirate.ammo_capacity = 1200
	pirate.max_speed = 160.0
	pirate.acceleration = 40.0
	pirate.turn_rate = 160.0
	pirate.mass = 6000.0
	pirate.weapon_slots = 3
	pirate.module_slots = 2
	pirate.default_weapons = ["module_weapon_cannon_t1", "module_weapon_laser_t1"]
	pirate.ai_behavior = AIBehavior.PIRATE
	pirate.ai_aggression = 0.9  # Very aggressive
	pirate.ai_courage = 0.3     # But cowardly vs strong targets
	pirate.ai_skill = 0.5
	pirate.base_price = 600000
	pirate.salvage_value = 300000
	pirate.sprite_path = "res://assets/sprites/ships/ship_npc_pirate_raider_idle.png"
	pirate.icon_path = "res://assets/icons/ships/ship_pirate_raider.png"
	pirate.engine_particle = "res://assets/particles/engine_red.tres"
	pirate.faction = "pirates"
	register_ship(pirate)

# ============================================================================
# TRADER SHIPS (NPC)
# ============================================================================

func initialize_trader_ships():
	"""Initialize NPC trading vessels"""

	# MERCHANT FREIGHTER
	var trader_medium = ShipTemplate.new("ship_trader_merchant", "Merchant Freighter", ShipClass.TRADER)
	trader_medium.ship_size = ShipSize.MEDIUM
	trader_medium.description = "Commercial freighter. Large cargo hold, minimal weapons."
	trader_medium.hull_max = 1200
	trader_medium.shields_max = 500
	trader_medium.energy_max = 1000
	trader_medium.energy_regen = 12.0
	trader_medium.cargo_capacity = 5000.0
	trader_medium.fuel_capacity = 1500.0
	trader_medium.max_speed = 80.0
	trader_medium.acceleration = 12.0
	trader_medium.turn_rate = 50.0
	trader_medium.mass = 30000.0
	trader_medium.weapon_slots = 1
	trader_medium.module_slots = 3
	trader_medium.default_weapons = ["module_weapon_cannon_t1"]  # Self-defense only
	trader_medium.ai_behavior = AIBehavior.TRADER
	trader_medium.ai_aggression = 0.0
	trader_medium.ai_courage = 0.2  # Flees combat
	trader_medium.ai_skill = 0.4
	trader_medium.base_price = 1500000
	trader_medium.salvage_value = 750000
	trader_medium.sprite_path = "res://assets/sprites/ships/ship_npc_trader_merchant_idle.png"
	trader_medium.icon_path = "res://assets/icons/ships/ship_trader_merchant.png"
	trader_medium.engine_particle = "res://assets/particles/engine_green.tres"
	trader_medium.faction = "traders_guild"
	register_ship(trader_medium)

	# BULK TRANSPORT (massive cargo)
	var transport_large = ShipTemplate.new("ship_transport_bulk", "Bulk Transport", ShipClass.TRANSPORT)
	transport_large.ship_size = ShipSize.LARGE
	transport_large.description = "Massive cargo hauler. Extremely slow, no weapons."
	transport_large.hull_max = 2500
	transport_large.shields_max = 800
	transport_large.energy_max = 1500
	transport_large.energy_regen = 15.0
	transport_large.cargo_capacity = 20000.0  # Massive hold
	transport_large.fuel_capacity = 3000.0
	transport_large.max_speed = 40.0
	transport_large.acceleration = 5.0
	transport_large.turn_rate = 25.0
	transport_large.mass = 100000.0
	transport_large.weapon_slots = 0
	transport_large.module_slots = 2
	transport_large.ai_behavior = AIBehavior.TRADER
	transport_large.ai_aggression = 0.0
	transport_large.ai_courage = 0.1  # Always flees
	transport_large.ai_skill = 0.3
	transport_large.base_price = 5000000
	transport_large.salvage_value = 2500000
	transport_large.sprite_path = "res://assets/sprites/ships/ship_npc_transport_bulk_idle.png"
	transport_large.icon_path = "res://assets/icons/ships/ship_transport_bulk.png"
	transport_large.engine_particle = "res://assets/particles/engine_green_large.tres"
	transport_large.faction = "traders_guild"
	register_ship(transport_large)

# ============================================================================
# SPECIAL SHIPS (Police, etc.)
# ============================================================================

func initialize_special_ships():
	"""Initialize special-purpose ships"""

	# POLICE PATROL SHIP
	var police = ShipTemplate.new("ship_police_patrol", "Enforcer-Class Patrol Ship", ShipClass.POLICE)
	police.ship_size = ShipSize.SMALL
	police.description = "Law enforcement vessel. Patrols trade routes, engages pirates."
	police.hull_max = 1000
	police.shields_max = 700
	police.energy_max = 1400
	police.energy_regen = 20.0
	police.cargo_capacity = 300.0
	police.fuel_capacity = 800.0
	police.ammo_capacity = 2000
	police.max_speed = 160.0
	police.acceleration = 35.0
	police.turn_rate = 140.0
	police.mass = 8000.0
	police.weapon_slots = 4
	police.module_slots = 4
	police.default_weapons = ["module_weapon_laser_t1", "module_weapon_cannon_t1"]
	police.default_modules = ["module_shield_t1", "module_scanner_t1"]
	police.ai_behavior = AIBehavior.PATROL
	police.ai_aggression = 0.6  # Attacks criminals
	police.ai_courage = 0.7
	police.ai_skill = 0.8
	police.base_price = 1000000
	police.salvage_value = 500000
	police.sprite_path = "res://assets/sprites/ships/ship_npc_police_patrol_idle.png"
	police.icon_path = "res://assets/icons/ships/ship_police_patrol.png"
	police.engine_particle = "res://assets/particles/engine_white.tres"
	police.faction = "police"
	register_ship(police)

	# EXPLORER DRONE (automated survey)
	var explorer = ShipTemplate.new("ship_explorer_drone", "Survey Drone", ShipClass.SPECIAL)
	explorer.ship_size = ShipSize.SMALL
	explorer.description = "Automated exploration drone. Discovers new sectors."
	explorer.hull_max = 400
	explorer.shields_max = 200
	explorer.energy_max = 800
	explorer.energy_regen = 10.0
	explorer.cargo_capacity = 100.0
	explorer.fuel_capacity = 1000.0  # Long range
	explorer.max_speed = 140.0
	explorer.acceleration = 25.0
	explorer.turn_rate = 100.0
	explorer.mass = 3000.0
	explorer.weapon_slots = 0
	explorer.module_slots = 2
	explorer.default_modules = ["module_scanner_t1"]
	explorer.ai_behavior = AIBehavior.FLEE  # Runs from everything
	explorer.ai_aggression = 0.0
	explorer.ai_courage = 0.0
	explorer.ai_skill = 0.5
	explorer.base_price = 200000
	explorer.salvage_value = 100000
	explorer.sprite_path = "res://assets/sprites/ships/ship_npc_explorer_drone_idle.png"
	explorer.icon_path = "res://assets/icons/ships/ship_explorer_drone.png"
	explorer.engine_particle = "res://assets/particles/engine_cyan.tres"
	explorer.faction = "neutral"
	register_ship(explorer)

# ============================================================================
# REGISTRATION & QUERIES
# ============================================================================

func register_ship(ship: ShipTemplate):
	"""Register a ship template in the database"""
	ship_registry[ship.ship_id] = ship

func get_ship(ship_id: String) -> ShipTemplate:
	"""Get ship template by ID (returns copy for safety)"""
	if ship_registry.has(ship_id):
		return ship_registry[ship_id].clone()
	return null

func get_ship_info(ship_id: String) -> Dictionary:
	"""Get ship information as Dictionary"""
	if ship_registry.has(ship_id):
		return ship_registry[ship_id].get_info()
	return {}

func get_ships_by_class(ship_class: ShipClass) -> Array:
	"""Get all ships of a specific class"""
	var results = []
	for ship_id in ship_registry:
		var ship = ship_registry[ship_id]
		if ship.ship_class == ship_class:
			results.append(ship.clone())
	return results

func get_ships_by_faction(faction: String) -> Array:
	"""Get all ships of a specific faction"""
	var results = []
	for ship_id in ship_registry:
		var ship = ship_registry[ship_id]
		if ship.faction == faction:
			results.append(ship.clone())
	return results

func get_player_ships() -> Array:
	"""Get all player-controllable ships"""
	var results = []
	for ship_id in ship_registry:
		var ship = ship_registry[ship_id]
		if ship.faction == "player":
			results.append(ship.clone())
	return results

func get_npc_ships() -> Array:
	"""Get all NPC ships"""
	var results = []
	for ship_id in ship_registry:
		var ship = ship_registry[ship_id]
		if ship.faction != "player":
			results.append(ship.clone())
	return results

func ship_exists(ship_id: String) -> bool:
	"""Check if ship exists in database"""
	return ship_registry.has(ship_id)

func get_all_ships() -> Array:
	"""Get all ships in database"""
	var results = []
	for ship_id in ship_registry:
		results.append(ship_registry[ship_id].clone())
	return results

# ============================================================================
# SPAWN HELPERS
# ============================================================================

func create_ship_instance(ship_id: String, position: Vector2 = Vector2.ZERO, custom_faction: String = "") -> Dictionary:
	"""Create a ship instance with randomized stats (for spawning)
	Returns Dictionary with all ship data ready to spawn in-game
	"""
	var template = get_ship(ship_id)
	if not template:
		print("❌ Ship template not found: %s" % ship_id)
		return {}

	# Override faction if specified
	if custom_faction != "":
		template.faction = custom_faction

	# Create instance data
	var instance = {
		"ship_id": ship_id,
		"template": template.ship_id,
		"position": position,
		"rotation": randf_range(0, 360),

		# Current stats (can be damaged)
		"hull_current": template.hull_max,
		"hull_max": template.hull_max,
		"shields_current": template.shields_max,
		"shields_max": template.shields_max,
		"energy_current": template.energy_max,
		"energy_max": template.energy_max,
		"fuel_current": template.fuel_capacity,
		"fuel_max": template.fuel_capacity,

		# Equipment (copy defaults)
		"weapons": template.default_weapons.duplicate(),
		"modules": template.default_modules.duplicate(),

		# Cargo (empty on spawn)
		"cargo": {},
		"cargo_used": 0.0,
		"cargo_max": template.cargo_capacity,

		# AI state
		"ai_behavior": template.ai_behavior,
		"ai_state": "idle",
		"ai_target": null,
		"ai_destination": Vector2.ZERO,

		# Faction & relations
		"faction": template.faction,
		"is_hostile": template.faction == "pirates",
		"is_friendly": template.faction in ["player", "police", "miners_guild", "traders_guild"],

		# Movement
		"velocity": Vector2.ZERO,
		"max_speed": template.max_speed,
		"acceleration": template.acceleration,
		"turn_rate": template.turn_rate,

		# Economy
		"salvage_value": template.salvage_value,

		# Assets
		"sprite_path": template.sprite_path,
		"icon_path": template.icon_path,
		"engine_particle": template.engine_particle
	}

	emit_signal("ship_spawned", ship_id, instance)
	return instance

func spawn_random_npc(ship_class: ShipClass, position: Vector2 = Vector2.ZERO, faction: String = "") -> Dictionary:
	"""Spawn a random NPC ship of a specific class"""
	var ships = get_ships_by_class(ship_class)
	if ships.size() == 0:
		print("❌ No ships found for class: %s" % ShipClass.keys()[ship_class])
		return {}

	var random_ship = ships[randi() % ships.size()]
	return create_ship_instance(random_ship.ship_id, position, faction)

# ============================================================================
# STATISTICS
# ============================================================================

func get_database_statistics() -> Dictionary:
	"""Get ship database statistics"""
	var stats = {
		"total_ships": ship_registry.size(),
		"by_class": {},
		"by_size": {},
		"by_faction": {},
		"player_ships": 0,
		"npc_ships": 0
	}

	for ship_id in ship_registry:
		var ship = ship_registry[ship_id]

		# Count by class
		var cls = ShipClass.keys()[ship.ship_class]
		if not stats["by_class"].has(cls):
			stats["by_class"][cls] = 0
		stats["by_class"][cls] += 1

		# Count by size
		var size = ShipSize.keys()[ship.ship_size]
		if not stats["by_size"].has(size):
			stats["by_size"][size] = 0
		stats["by_size"][size] += 1

		# Count by faction
		if not stats["by_faction"].has(ship.faction):
			stats["by_faction"][ship.faction] = 0
		stats["by_faction"][ship.faction] += 1

		# Player vs NPC
		if ship.faction == "player":
			stats["player_ships"] += 1
		else:
			stats["npc_ships"] += 1

	return stats

func print_database_statistics():
	"""Print ship database statistics"""
	var stats = get_database_statistics()
	print("\n🚀 SHIP DATABASE STATISTICS")
	print("═══════════════════════════════════════")
	print("Total Ships: %d" % stats["total_ships"])
	print("  Player: %d" % stats["player_ships"])
	print("  NPC: %d" % stats["npc_ships"])
	print("\nBy Class:")
	for cls in stats["by_class"]:
		print("  %s: %d" % [cls, stats["by_class"][cls]])
	print("\nBy Size:")
	for size in stats["by_size"]:
		print("  %s: %d" % [size, stats["by_size"][size]])
	print("\nBy Faction:")
	for faction in stats["by_faction"]:
		print("  %s: %d" % [faction, stats["by_faction"][faction]])
	print("═══════════════════════════════════════\n")
