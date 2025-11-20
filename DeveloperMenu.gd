extends Control

## Developer Menu with Test Scenarios

# ============================================================================
# SCENARIOS
# ============================================================================

const SCENARIOS = [
	{
		"id": "scenario_01_basic_mining",
		"name": "01 - Basic Mining",
		"description": "3 asteroids nearby, test basic mining mechanics",
		"setup": "basic_mining"
	},
	{
		"id": "scenario_02_mining_queue",
		"name": "02 - Mining Queue System",
		"description": "10 asteroids in a line, test queue system",
		"setup": "mining_queue"
	},
	{
		"id": "scenario_03_cargo_management",
		"name": "03 - Cargo Management",
		"description": "Full ore hold, test cargo drag & drop",
		"setup": "cargo_management"
	},
	{
		"id": "scenario_04_compression",
		"name": "04 - Compression Modules",
		"description": "Test all compression levels (30%, 50%, 70%)",
		"setup": "compression"
	},
	{
		"id": "scenario_05_stack_splitting",
		"name": "05 - Stack Splitting",
		"description": "Multiple full stacks, test slider splitting",
		"setup": "stack_splitting"
	},
	{
		"id": "scenario_06_station_docking",
		"name": "06 - Station Docking",
		"description": "4 stations (Outpost, Station, Citadel, Keepstar)",
		"setup": "station_docking"
	},
	{
		"id": "scenario_07_map_system",
		"name": "07 - Map System Testing",
		"description": "Objects at different distances, test all map layers",
		"setup": "map_system"
	},
	{
		"id": "scenario_08_combat_basic",
		"name": "08 - Basic Combat",
		"description": "3 hostile NPC ships, test combat mechanics",
		"setup": "combat_basic"
	},
	{
		"id": "scenario_09_performance",
		"name": "09 - Performance Test",
		"description": "100 asteroids, 20 ships, stress test",
		"setup": "performance"
	},
	{
		"id": "scenario_10_full_gameplay",
		"name": "10 - Full Gameplay Loop",
		"description": "Mining -> Refining -> Trading at station",
		"setup": "full_gameplay"
	},
	{
		"id": "scenario_11_multimonitor",
		"name": "11 - Multi-Monitor Camera",
		"description": "Test camera offset system (Numpad 1-9)",
		"setup": "multimonitor"
	},
	{
		"id": "scenario_12_minimap",
		"name": "12 - Minimap Testing",
		"description": "Many objects for minimap testing",
		"setup": "minimap"
	},
	{
		"id": "scenario_13_ore_types",
		"name": "13 - All Ore Types",
		"description": "One of each ore type for testing",
		"setup": "ore_types"
	},
	{
		"id": "scenario_14_scanner_levels",
		"name": "14 - Scanner Levels",
		"description": "Test Mk1, Mk2, Mk3 scanners",
		"setup": "scanner_levels"
	},
	{
		"id": "scenario_15_autopilot",
		"name": "15 - Autopilot System",
		"description": "Distant targets for autopilot testing",
		"setup": "autopilot"
	},
	{
		"id": "scenario_16_orbit",
		"name": "16 - Orbit Mechanics",
		"description": "Large asteroids and stations for orbit testing",
		"setup": "orbit"
	},
	{
		"id": "scenario_17_module_fitting",
		"name": "17 - Station Module Fitting",
		"description": "Test installing/removing station modules",
		"setup": "module_fitting"
	},
	{
		"id": "scenario_18_refinery",
		"name": "18 - Refinery Efficiency",
		"description": "Compare refinery levels (70% vs 95%)",
		"setup": "refinery"
	},
	{
		"id": "scenario_19_empty_space",
		"name": "19 - Empty Space",
		"description": "No objects, test exploration",
		"setup": "empty_space"
	},
	{
		"id": "scenario_20_dense_field",
		"name": "20 - Dense Asteroid Field",
		"description": "50+ asteroids clustered together",
		"setup": "dense_field"
	},
	{
		"id": "scenario_21_perf_100_ships",
		"name": "21 - Performance: 100 Ships",
		"description": "Penetrationstest mit 100 Schiffen",
		"setup": "perf_100_ships"
	},
	{
		"id": "scenario_22_perf_1000_ships",
		"name": "22 - Performance: 1000 Ships",
		"description": "Penetrationstest mit 1000 Schiffen",
		"setup": "perf_1000_ships"
	},
	{
		"id": "scenario_23_perf_10000_ships",
		"name": "23 - Performance: 10,000 Ships",
		"description": "Penetrationstest mit 10000 Schiffen (EXTREME)",
		"setup": "perf_10000_ships"
	},
	{
		"id": "scenario_24_perf_mixed",
		"name": "24 - Performance: Mixed (1000 Ships + 500 Asteroids)",
		"description": "Kombinierter Stresstest",
		"setup": "perf_mixed"
	}
]

# ============================================================================
# INITIALIZATION
# ============================================================================

var scenario_list: VBoxContainer

func _ready():
	_setup_ui()

func _setup_ui():
	"""Setup the developer menu UI"""
	# Main VBox
	var vbox = VBoxContainer.new()
	vbox.anchor_right = 1.0
	vbox.anchor_bottom = 1.0
	vbox.offset_left = 50
	vbox.offset_top = 50
	vbox.offset_right = -50
	vbox.offset_bottom = -50
	add_child(vbox)

	# Title
	var title = Label.new()
	title.text = "=== DEVELOPER TEST SCENARIOS ==="
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)

	# Subtitle
	var subtitle = Label.new()
	subtitle.text = "Select a scenario to test specific features"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	vbox.add_child(subtitle)

	vbox.add_child(HSeparator.new())

	# Scroll container for scenarios
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(scroll)

	scenario_list = VBoxContainer.new()
	scenario_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(scenario_list)

	# Populate scenarios
	_populate_scenarios()

	# Back button
	var back_btn = Button.new()
	back_btn.text = "← Back to Main Menu"
	back_btn.custom_minimum_size = Vector2(0, 50)
	back_btn.pressed.connect(_on_back_pressed)
	vbox.add_child(back_btn)

func _populate_scenarios():
	"""Populate scenario list with buttons"""
	for scenario in SCENARIOS:
		var hbox = HBoxContainer.new()
		hbox.custom_minimum_size = Vector2(0, 60)
		scenario_list.add_child(hbox)

		# Scenario button
		var btn = Button.new()
		btn.text = scenario["name"]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(_on_scenario_selected.bind(scenario))
		hbox.add_child(btn)

		# Description label
		var desc_label = Label.new()
		desc_label.text = scenario["description"]
		desc_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		desc_label.add_theme_color_override("font_color", Color(0.6, 0.8, 1.0))
		desc_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hbox.add_child(desc_label)

		# Separator
		scenario_list.add_child(HSeparator.new())

# ============================================================================
# HANDLERS
# ============================================================================

func _on_back_pressed():
	"""Return to main menu"""
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_scenario_selected(scenario: Dictionary):
	"""Load selected test scenario"""
	print("Loading scenario: %s" % scenario["name"])
	print("Description: %s" % scenario["description"])

	# Save scenario data for Main.gd to load
	var scenario_data = {
		"enabled": true,
		"setup": scenario["setup"],
		"name": scenario["name"],
		"id": scenario["id"]
	}

	var file = FileAccess.open("user://dev_scenario.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(scenario_data))
		file.close()
		print("✅ Scenario data saved")
	else:
		print("❌ Failed to save scenario data")

	# Load main scene
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
