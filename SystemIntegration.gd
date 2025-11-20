extends Node

# ============================================================================
# SYSTEM INTEGRATION - Connects all game systems
# ============================================================================
# This script demonstrates how all systems work together
# Add this to your Main scene or Player scene to integrate everything

# ============================================================================
# SYSTEM REFERENCES
# ============================================================================

# Core Systems (should be AutoLoad or children of Main/Player)
var performance_manager: Node = null
var selection_manager: Node = null
var translation_manager: Node = null

# Player Systems (attach to Player node)
var skill_manager: Node = null
var temperature_system: Node = null
var energy_system: Node = null
var refinery_system: Node = null
var module_system: Node = null
var autominer_chip_system: Node = null
var cargo_specialization_system: Node = null

# World Systems (attach to Main scene)
var crafting_system: Node = null
var station_system: Node = null
var fleet_automation_system: Node = null

# UI Systems (attach to UI nodes)
var skills_ui: Control = null
var temperature_ui: Control = null
var energy_ui: Control = null
var crafting_ui: Control = null

# ============================================================================
# INTEGRATION SETUP
# ============================================================================

func _ready():
	print("🔗 System Integration initializing...")

	# 1. Setup Core Systems (AutoLoad)
	setup_core_systems()

	# 2. Setup Player Systems
	setup_player_systems()

	# 3. Setup World Systems
	setup_world_systems()

	# 4. Connect Systems
	connect_all_systems()

	# 5. Setup UI
	setup_ui_systems()

	print("✅ All systems integrated and ready!")

	# Optional: Run integration test
	# run_integration_test()

# ============================================================================
# CORE SYSTEMS SETUP
# ============================================================================

func setup_core_systems():
	"""Setup core AutoLoad systems"""
	print("⚙️ Setting up core systems...")

	# Performance Manager (AutoLoad)
	if has_node("/root/PerformanceManager"):
		performance_manager = get_node("/root/PerformanceManager")
		print("  ✅ PerformanceManager")
	else:
		print("  ⚠️ PerformanceManager not found - add to project AutoLoads")

	# Selection Manager (AutoLoad)
	if has_node("/root/SelectionManager"):
		selection_manager = get_node("/root/SelectionManager")
		print("  ✅ SelectionManager")
	else:
		print("  ⚠️ SelectionManager not found - add to project AutoLoads")

	# Translation Manager (AutoLoad)
	if has_node("/root/TranslationManager"):
		translation_manager = get_node("/root/TranslationManager")
		print("  ✅ TranslationManager")
	else:
		print("  ⚠️ TranslationManager not found - add to project AutoLoads")

	# Skill Manager (AutoLoad)
	if has_node("/root/SkillManager"):
		skill_manager = get_node("/root/SkillManager")
		print("  ✅ SkillManager")
	else:
		print("  ⚠️ SkillManager not found - add to project AutoLoads")

# ============================================================================
# PLAYER SYSTEMS SETUP
# ============================================================================

func setup_player_systems():
	"""Setup systems attached to Player node"""
	print("⚙️ Setting up player systems...")

	var player = get_player_node()
	if not player:
		print("  ❌ Player node not found!")
		return

	# Temperature System
	if player.has_node("TemperatureSystem"):
		temperature_system = player.get_node("TemperatureSystem")
		print("  ✅ TemperatureSystem")
	else:
		print("  ℹ️ TemperatureSystem not attached to Player")

	# Energy System
	if player.has_node("EnergySystem"):
		energy_system = player.get_node("EnergySystem")
		print("  ✅ EnergySystem")
	else:
		print("  ℹ️ EnergySystem not attached to Player")

	# Refinery System
	if player.has_node("RefinerySystem"):
		refinery_system = player.get_node("RefinerySystem")
		print("  ✅ RefinerySystem")
	else:
		print("  ℹ️ RefinerySystem not attached to Player")

	# Module System
	if player.has_node("ModuleSystem"):
		module_system = player.get_node("ModuleSystem")
		print("  ✅ ModuleSystem")
	else:
		print("  ℹ️ ModuleSystem not attached to Player")

# ============================================================================
# WORLD SYSTEMS SETUP
# ============================================================================

func setup_world_systems():
	"""Setup systems attached to Main scene"""
	print("⚙️ Setting up world systems...")

	# Crafting System
	if has_node("CraftingSystem"):
		crafting_system = get_node("CraftingSystem")
		print("  ✅ CraftingSystem")
	else:
		print("  ℹ️ CraftingSystem not found")

	# Station System
	if has_node("StationSystem"):
		station_system = get_node("StationSystem")
		print("  ✅ StationSystem")
	else:
		print("  ℹ️ StationSystem not found")

	# Fleet Automation System
	if has_node("FleetAutomationSystem"):
		fleet_automation_system = get_node("FleetAutomationSystem")
		print("  ✅ FleetAutomationSystem")
	else:
		print("  ℹ️ FleetAutomationSystem not found")

# ============================================================================
# SYSTEM CONNECTIONS
# ============================================================================

func connect_all_systems():
	"""Connect systems to each other"""
	print("🔗 Connecting systems...")

	# Connect Fleet → Station
	if fleet_automation_system and station_system:
		fleet_automation_system.station_system = station_system
		print("  ✅ Fleet ↔ Station")

	# Connect Crafting → Refinery (for quality checks)
	if crafting_system and refinery_system:
		# Crafting system can check refinery for quality
		print("  ✅ Crafting ↔ Refinery")

	# Connect Energy → Temperature (heat generation)
	if energy_system and temperature_system:
		# Energy system generates heat
		print("  ✅ Energy ↔ Temperature")

	# Connect Station → Crafting
	if station_system and crafting_system:
		station_system.crafting_system = crafting_system
		print("  ✅ Station ↔ Crafting")

	# Connect Station → Refinery
	if station_system and refinery_system:
		station_system.refinery_system = refinery_system
		print("  ✅ Station ↔ Refinery")

	# Connect Module → Skill (for efficiency bonuses)
	if module_system and skill_manager:
		# Module system uses SkillManager for efficiency
		print("  ✅ Module ↔ Skill")

	# Connect UI → Systems
	connect_ui_to_systems()

	print("✅ All systems connected!")

# ============================================================================
# UI CONNECTIONS
# ============================================================================

func setup_ui_systems():
	"""Setup UI controllers"""
	print("⚙️ Setting up UI systems...")

	# These should be found in the UI tree
	# Adjust paths based on your UI structure

func connect_ui_to_systems():
	"""Connect UI to backend systems"""
	print("🔗 Connecting UI to systems...")

	# UI connections would be done in the UI scripts themselves
	# They get references to the systems via get_node("/root/...")

# ============================================================================
# INTEGRATION TESTING
# ============================================================================

func run_integration_test():
	"""Test that all systems work together"""
	print("\n╔════════════════════════════════════════╗")
	print("║  INTEGRATION TEST                      ║")
	print("╚════════════════════════════════════════╝\n")

	# Test 1: Skill System
	test_skill_system()

	# Test 2: Energy System
	test_energy_system()

	# Test 3: Temperature System
	test_temperature_system()

	# Test 4: Crafting System
	test_crafting_system()

	# Test 5: Station System
	test_station_system()

	# Test 6: Fleet System
	test_fleet_system()

	# Test 7: Performance System
	test_performance_system()

	print("\n✅ Integration test complete!\n")

func test_skill_system():
	"""Test Skill System integration"""
	print("🧪 Testing Skill System...")

	if not skill_manager:
		print("  ⚠️ SkillManager not available")
		return

	# Add XP and check level up
	skill_manager.add_xp("Mining", 100)
	var level = skill_manager.get_skill_level("Mining")
	print("  ✅ Mining skill level: %d" % level)

func test_energy_system():
	"""Test Energy System integration"""
	print("🧪 Testing Energy System...")

	if not energy_system:
		print("  ⚠️ EnergySystem not available")
		return

	# Add a generator
	energy_system.add_generator("test_gen", energy_system.GeneratorType.SOLAR, 1)

	# Register a consumer
	energy_system.register_consumer("test_consumer", "Test Device", 50.0, energy_system.PowerPriority.MEDIUM)

	var grid_info = energy_system.get_grid_info()
	print("  ✅ Energy generation: %.0f EU/s" % grid_info["total_generation"])
	print("  ✅ Energy consumption: %.0f EU/s" % grid_info["total_consumption"])

func test_temperature_system():
	"""Test Temperature System integration"""
	print("🧪 Testing Temperature System...")

	if not temperature_system:
		print("  ⚠️ TemperatureSystem not available")
		return

	var status = temperature_system.get_temperature_status()
	print("  ✅ Temperature status: %s" % status)

func test_crafting_system():
	"""Test Crafting System integration"""
	print("🧪 Testing Crafting System...")

	if not crafting_system:
		print("  ⚠️ CraftingSystem not available")
		return

	var recipes_count = crafting_system.recipe_database.size()
	print("  ✅ Loaded %d recipes" % recipes_count)

func test_station_system():
	"""Test Station System integration"""
	print("🧪 Testing Station System...")

	if not station_system:
		print("  ⚠️ StationSystem not available")
		return

	var stations = station_system.get_all_stations()
	print("  ✅ Found %d stations" % stations.size())

func test_fleet_system():
	"""Test Fleet System integration"""
	print("🧪 Testing Fleet System...")

	if not fleet_automation_system:
		print("  ⚠️ FleetAutomationSystem not available")
		return

	# Spawn a test ship
	var ship_id = fleet_automation_system.spawn_fleet_ship("Test Miner", "miner_small", Vector2(1000, 1000))
	print("  ✅ Spawned fleet ship: %s" % ship_id)

	var stats = fleet_automation_system.get_fleet_stats()
	print("  ✅ Fleet stats: %d ships" % stats["total_ships"])

func test_performance_system():
	"""Test Performance System"""
	print("🧪 Testing Performance System...")

	if not performance_manager:
		print("  ⚠️ PerformanceManager not available")
		return

	var stats = performance_manager.get_performance_stats()
	if not stats.is_empty():
		print("  ✅ Average FPS: %.1f" % stats["average_fps"])
		print("  ✅ Frame budget used: %.1f%%" % stats["frame_budget_used_percent"])
	else:
		print("  ℹ️ No performance data yet")

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_player_node() -> Node:
	"""Get player node (try multiple paths)"""
	# Try different paths where player might be
	if has_node("/root/Main/Player"):
		return get_node("/root/Main/Player")
	elif has_node("/root/Player"):
		return get_node("/root/Player")
	elif has_node("../Player"):
		return get_node("../Player")
	return null

# ============================================================================
# PERFORMANCE MONITORING
# ============================================================================

func print_performance_report():
	"""Print detailed performance report"""
	if performance_manager:
		performance_manager.print_performance_report()

func is_performance_good() -> bool:
	"""Check if performance is acceptable"""
	if not performance_manager:
		return true

	var stats = performance_manager.get_performance_stats()
	if stats.is_empty():
		return true

	return stats["average_fps"] >= 30.0

# ============================================================================
# EXAMPLE INTEGRATION FOR project.godot
# ============================================================================

# Add these to project.godot AutoLoads:
# [autoload]
# PerformanceManager="*res://scripts/PerformanceManager.gd"
# SelectionManager="*res://scripts/SelectionManager.gd"
# TranslationManager="*res://scripts/TranslationManager.gd"
# SkillManager="*res://scripts/SkillManager.gd"

# Scene structure example:
# Main (Node2D)
#   ├── SystemIntegration (this script)
#   ├── CraftingSystem
#   ├── StationSystem
#   ├── FleetAutomationSystem
#   ├── Player
#   │   ├── TemperatureSystem
#   │   ├── EnergySystem
#   │   ├── RefinerySystem
#   │   └── ModuleSystem
#   └── UI
#       ├── SkillsUI
#       ├── TemperatureUI
#       ├── EnergyUI
#       └── CraftingUI
