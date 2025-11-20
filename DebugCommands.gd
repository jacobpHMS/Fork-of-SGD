extends Node
class_name DebugCommands

## Debug command system with cheats and testing tools
## Access via console (Shift+F12) or directly via code

# ============================================================================
# COMMAND REGISTRY
# ============================================================================

static var command_history: Array[String] = []
static var god_mode_active: bool = false
static var speed_multiplier: float = 1.0
static var infinite_cargo: bool = false

# ============================================================================
# CHEAT COMMANDS
# ============================================================================

static func enable_god_mode(player: Node2D) -> String:
	"""Make player invulnerable"""
	god_mode_active = true
	if "invulnerable" in player:
		player.invulnerable = true
	return "✅ God mode ENABLED - Player is invulnerable"

static func disable_god_mode(player: Node2D) -> String:
	"""Disable god mode"""
	god_mode_active = false
	if "invulnerable" in player:
		player.invulnerable = false
	return "❌ God mode DISABLED"

static func set_speed(player: Node2D, multiplier: float) -> String:
	"""Set player speed multiplier"""
	speed_multiplier = multiplier
	if "speed_multiplier" in player:
		player.speed_multiplier = multiplier
	elif "max_speed" in player:
		player.max_speed *= multiplier
	return "⚡ Speed multiplier set to %.1fx" % multiplier

static func teleport_to(player: Node2D, x: float, y: float) -> String:
	"""Teleport player to position"""
	player.global_position = Vector2(x, y)
	if "velocity" in player:
		player.velocity = Vector2.ZERO
	return "📍 Teleported to (%.0f, %.0f)" % [x, y]

static func add_cargo(player: Node2D, item_id: String, amount: float) -> String:
	"""Add items to cargo"""
	if player.has_method("add_to_cargo_hold"):
		var added = player.add_to_cargo_hold(player.CargoType.GENERAL, item_id, amount)
		return "📦 Added %.0f x %s to cargo (actually added: %.0f)" % [amount, item_id, added]
	return "❌ Player doesn't have cargo system"

static func fill_cargo(player: Node2D) -> String:
	"""Fill cargo with various ores"""
	if not player.has_method("add_to_cargo_hold"):
		return "❌ Player doesn't have cargo system"

	var ores = ["ore_veldspar", "ore_scordite", "ore_pyroxeres", "ore_plagioclase"]
	var total = 0.0

	for ore in ores:
		var added = player.add_to_cargo_hold(player.CargoType.ORE, ore, 5000)
		total += added

	return "📦 Filled cargo with %.0f units of ore" % total

static func clear_cargo(player: Node2D) -> String:
	"""Clear all cargo"""
	if not "cargo_holds" in player:
		return "❌ Player doesn't have cargo system"

	for cargo_type in player.cargo_holds:
		player.cargo_holds[cargo_type]["contents"].clear()
		player.cargo_holds[cargo_type]["used"] = 0.0

	return "🗑️ Cargo cleared"

static func toggle_infinite_cargo(player: Node2D) -> String:
	"""Toggle infinite cargo capacity"""
	infinite_cargo = !infinite_cargo

	if "cargo_holds" in player:
		for cargo_type in player.cargo_holds:
			if infinite_cargo:
				player.cargo_holds[cargo_type]["capacity"] = 999999999.0
			else:
				# Reset to default (you might want to store original values)
				player.cargo_holds[cargo_type]["capacity"] = 500.0  # Default

	if infinite_cargo:
		return "♾️ Infinite cargo ENABLED"
	else:
		return "❌ Infinite cargo DISABLED"

static func install_best_compression(player: Node2D) -> String:
	"""Install EXTREME compression on all cargo types"""
	if not player.has_method("install_compression_module"):
		return "❌ Compression system not available"

	var extreme = player.CompressionLevel.EXTREME if "CompressionLevel" in player else 3

	for cargo_type in range(5):  # Assuming 5 cargo types
		player.install_compression_module(cargo_type, extreme)

	return "🗜️ EXTREME compression installed on all cargo types"

# ============================================================================
# SPAWN COMMANDS
# ============================================================================

static func spawn_asteroids(main: Node2D, count: int, radius: float = 2000.0) -> String:
	"""Spawn asteroids around player"""
	var player = main.get_node_or_null("Player")
	if not player:
		return "❌ Player not found"

	var ore_container = main.get_node_or_null("OreContainer")
	if not ore_container:
		return "❌ OreContainer not found"

	var OreScene = load("res://scenes/Ore.tscn")
	if not OreScene:
		return "❌ Ore scene not found"

	for i in range(count):
		var ore = OreScene.instantiate()
		var angle = randf() * TAU
		var distance = randf_range(radius * 0.3, radius)
		ore.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * distance
		ore_container.add_child(ore)

	return "🌑 Spawned %d asteroids in %.0fm radius" % [count, radius]

static func spawn_ships(main: Node2D, count: int, radius: float = 3000.0) -> String:
	"""Spawn NPC ships around player"""
	var player = main.get_node_or_null("Player")
	if not player:
		return "❌ Player not found"

	var ship_container = main.get_node_or_null("ShipContainer")
	if not ship_container:
		ship_container = Node2D.new()
		ship_container.name = "ShipContainer"
		main.add_child(ship_container)

	var NPCShipScene = load("res://scenes/NPCShip.tscn")
	if not NPCShipScene:
		return "❌ NPCShip scene not found"

	for i in range(count):
		var ship = NPCShipScene.instantiate()
		var angle = randf() * TAU
		var distance = randf_range(radius * 0.5, radius)
		ship.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * distance
		ship.modulate = Color(randf(), randf(), randf())  # Random color
		ship_container.add_child(ship)

	return "🚀 Spawned %d ships in %.0fm radius" % [count, radius]

static func clear_all_objects(main: Node2D) -> String:
	"""Remove all asteroids and ships"""
	var count = 0

	var ore_container = main.get_node_or_null("OreContainer")
	if ore_container:
		count += ore_container.get_child_count()
		for child in ore_container.get_children():
			child.queue_free()

	var ship_container = main.get_node_or_null("ShipContainer")
	if ship_container:
		count += ship_container.get_child_count()
		for child in ship_container.get_children():
			child.queue_free()

	return "🗑️ Cleared %d objects from scene" % count

# ============================================================================
# CAMERA COMMANDS
# ============================================================================

static func set_camera_zoom(main: Node2D, zoom: float) -> String:
	"""Set camera zoom level"""
	if not "zoom_level" in main:
		return "❌ Main scene doesn't have zoom"

	main.zoom_level = clamp(zoom, main.zoom_min, main.zoom_max)
	if "camera" in main:
		main.camera.zoom = Vector2(main.zoom_level, main.zoom_level)

	return "🔍 Camera zoom set to %.2f" % zoom

static func reset_camera_offset(main: Node2D) -> String:
	"""Reset camera offset to center"""
	if main.has_method("set_camera_offset"):
		main.set_camera_offset(Vector2.ZERO)
		return "📷 Camera offset reset to center"
	return "❌ Camera offset not available"

# ============================================================================
# SYSTEM COMMANDS
# ============================================================================

static func complete_mining_instantly(player: Node2D) -> String:
	"""Instantly complete current mining operation"""
	if not "mining_target" in player:
		return "❌ No mining target"

	if player.mining_target:
		var target = player.mining_target
		if "amount" in target:
			# Add all remaining ore to cargo
			var remaining = target.amount
			if player.has_method("add_to_cargo_hold"):
				player.add_to_cargo_hold(player.CargoType.ORE, "ore_veldspar", remaining)
			target.amount = 0
			return "⛏️ Mining completed - %.0f units extracted" % remaining

	return "❌ No active mining operation"

static func refill_fuel(player: Node2D) -> String:
	"""Refill fuel to maximum"""
	if "fuel_current" in player and "fuel_max" in player:
		player.fuel_current = player.fuel_max
		return "⛽ Fuel refilled to %.0f" % player.fuel_max
	return "❌ Fuel system not found"

static func repair_ship(player: Node2D) -> String:
	"""Fully repair ship"""
	var repaired = []

	if "hull_current" in player and "hull_max" in player:
		player.hull_current = player.hull_max
		repaired.append("Hull")

	if "shield_current" in player and "shield_max" in player:
		player.shield_current = player.shield_max
		repaired.append("Shield")

	if "armor_current" in player and "armor_max" in player:
		player.armor_current = player.armor_max
		repaired.append("Armor")

	if repaired.is_empty():
		return "❌ No repairable systems found"

	return "🔧 Repaired: %s" % ", ".join(repaired)

# ============================================================================
# UTILITY COMMANDS
# ============================================================================

static func get_player_info(player: Node2D) -> String:
	"""Get detailed player information"""
	var info = "=== PLAYER INFO ===\n"
	info += "Position: (%.0f, %.0f)\n" % [player.global_position.x, player.global_position.y]

	if "velocity" in player:
		info += "Velocity: %.1f m/s\n" % player.velocity.length()

	if player.has_method("get_ship_info"):
		var ship_info = player.get_ship_info()
		info += "Mass: %.0f kg\n" % ship_info.mass
		info += "Cargo: %.1f / %.0f m³\n" % [ship_info.cargo_used, ship_info.cargo_capacity]

	return info

static func list_commands() -> String:
	"""List all available debug commands"""
	return """
=== DEBUG COMMANDS ===

CHEATS:
  god_mode - Toggle invulnerability
  speed <multiplier> - Set speed (e.g., speed 2.0)
  teleport <x> <y> - Teleport to position
  infinite_cargo - Toggle infinite cargo

CARGO:
  add_cargo <item> <amount> - Add items
  fill_cargo - Fill with ores
  clear_cargo - Empty cargo
  install_compression - Install EXTREME compression

SPAWNING:
  spawn_asteroids <count> [radius] - Spawn asteroids
  spawn_ships <count> [radius] - Spawn ships
  clear_objects - Remove all objects

MINING:
  instant_mine - Complete mining instantly

SHIP:
  refill_fuel - Refill fuel
  repair - Fully repair ship

CAMERA:
  zoom <level> - Set camera zoom
  reset_camera - Reset camera offset

UTILITY:
  player_info - Show player info
  help - Show this help
"""

# ============================================================================
# COMMAND PARSER
# ============================================================================

static func execute_command(command_string: String, player: Node2D, main: Node2D) -> String:
	"""Parse and execute debug command"""
	command_history.append(command_string)

	var parts = command_string.split(" ", false)
	if parts.is_empty():
		return "❌ Empty command"

	var cmd = parts[0].to_lower()
	var args = parts.slice(1)

	# Execute command
	match cmd:
		"help", "commands", "?":
			return list_commands()

		"god_mode", "god":
			if god_mode_active:
				return disable_god_mode(player)
			else:
				return enable_god_mode(player)

		"speed":
			if args.size() < 1:
				return "❌ Usage: speed <multiplier>"
			var mult = float(args[0])
			return set_speed(player, mult)

		"teleport", "tp":
			if args.size() < 2:
				return "❌ Usage: teleport <x> <y>"
			var x = float(args[0])
			var y = float(args[1])
			return teleport_to(player, x, y)

		"add_cargo":
			if args.size() < 2:
				return "❌ Usage: add_cargo <item_id> <amount>"
			return add_cargo(player, args[0], float(args[1]))

		"fill_cargo":
			return fill_cargo(player)

		"clear_cargo":
			return clear_cargo(player)

		"infinite_cargo", "inf_cargo":
			return toggle_infinite_cargo(player)

		"install_compression", "compression":
			return install_best_compression(player)

		"spawn_asteroids", "spawn_ore":
			if args.size() < 1:
				return "❌ Usage: spawn_asteroids <count> [radius]"
			var count = int(args[0])
			var radius = float(args[1]) if args.size() > 1 else 2000.0
			return spawn_asteroids(main, count, radius)

		"spawn_ships":
			if args.size() < 1:
				return "❌ Usage: spawn_ships <count> [radius]"
			var count = int(args[0])
			var radius = float(args[1]) if args.size() > 1 else 3000.0
			return spawn_ships(main, count, radius)

		"clear_objects", "clear":
			return clear_all_objects(main)

		"instant_mine", "fast_mine":
			return complete_mining_instantly(player)

		"refill_fuel", "fuel":
			return refill_fuel(player)

		"repair":
			return repair_ship(player)

		"zoom":
			if args.size() < 1:
				return "❌ Usage: zoom <level>"
			return set_camera_zoom(main, float(args[0]))

		"reset_camera", "cam_reset":
			return reset_camera_offset(main)

		"player_info", "info":
			return get_player_info(player)

		_:
			return "❌ Unknown command: %s (type 'help' for commands)" % cmd
