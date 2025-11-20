extends BaseWidget
class_name MiningScannerWidget
## Mining Scanner Widget - Displays nearby asteroids in 2 circular radar displays
##
## Shows mining progress, quality distribution, and target information
## for the player's two mining lasers.

# ============================================================================
# REFERENCES
# ============================================================================

var miner1_container: VBoxContainer = null
var miner2_container: VBoxContainer = null
var miner1_circle: Control = null
var miner2_circle: Control = null
var target_info_label: Label = null

const MiningCircleScript = preload("res://scripts/MiningCircle.gd")

# ============================================================================
# INITIALIZATION
# ============================================================================

func initialize_widget() -> void:
	widget_id = "mining_scanner"
	widget_title = "Mining Scanner"
	update_priority = WindowManager.WidgetUpdatePriority.HIGH
	panel_style = SciFiTheme.PanelStyle.STANDARD

	_build_scanner_ui()

func _build_scanner_ui() -> void:
	"""Build the scanner UI with 2 mining circles"""
	var content = get_content_container()

	# Target info label
	target_info_label = create_label("", "small")
	target_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	target_info_label.add_theme_color_override("font_color", get_theme().COLOR_STATUS_ACTIVE)
	content.add_child(target_info_label)

	# HBox for 2 circles side by side
	var hbox = HBoxContainer.new()
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(hbox)

	# Miner 1
	miner1_container = VBoxContainer.new()
	miner1_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(miner1_container)

	var miner1_label = create_label("Miner 1", "header")
	miner1_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	miner1_container.add_child(miner1_label)

	miner1_circle = Control.new()
	miner1_circle.set_script(MiningCircleScript)
	miner1_circle.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	miner1_circle.size_flags_vertical = Control.SIZE_EXPAND_FILL
	miner1_circle.custom_minimum_size = Vector2(200, 200)
	miner1_container.add_child(miner1_circle)

	# Miner 2
	miner2_container = VBoxContainer.new()
	miner2_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(miner2_container)

	var miner2_label = create_label("Miner 2", "header")
	miner2_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	miner2_container.add_child(miner2_label)

	miner2_circle = Control.new()
	miner2_circle.set_script(MiningCircleScript)
	miner2_circle.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	miner2_circle.size_flags_vertical = Control.SIZE_EXPAND_FILL
	miner2_circle.custom_minimum_size = Vector2(200, 200)
	miner2_container.add_child(miner2_circle)

# ============================================================================
# UPDATE
# ============================================================================

func update_widget_data() -> void:
	if not has_data_source():
		show_no_data_message("No Player Data")
		return

	var player = get_data_source()

	# Update target info
	_update_target_info(player)

	# Update mining circles
	_update_mining_circles(player)

func _update_target_info(player: Node) -> void:
	"""Update mining target information"""
	if not target_info_label:
		return

	if "mining_target" in player:
		var mining_target = player.mining_target
		if mining_target and is_instance_valid(mining_target):
			var target_name = mining_target.ore_name if "ore_name" in mining_target else "Unknown"
			var target_amount = mining_target.amount if "amount" in mining_target else 0.0

			var mining_progress = 0.0
			if "mining_cycle_time" in player and player.mining_cycle_time > 0:
				mining_progress = (player.mining_cycle_progress / player.mining_cycle_time) * 100.0

			target_info_label.text = "Target: %s | Amount: %.1f units | Progress: %.0f%%" % [target_name, target_amount, mining_progress]
			target_info_label.visible = true
		else:
			target_info_label.text = "No Target"
			target_info_label.visible = true
	else:
		target_info_label.visible = false

func _update_mining_circles(player: Node) -> void:
	"""Update mining circle displays"""
	if not miner1_circle or not miner2_circle:
		return

	# Update miner active states
	if "miner_1_active" in player:
		miner1_circle.call("set_mining_active", player.miner_1_active)
	if "miner_2_active" in player:
		miner2_circle.call("set_mining_active", player.miner_2_active)

	# Update mining progress
	if "mining_cycle_time" in player and "mining_cycle_progress" in player and player.mining_cycle_time > 0:
		var progress = player.mining_cycle_progress / player.mining_cycle_time
		miner1_circle.call("set_mining_progress", progress)
		miner2_circle.call("set_mining_progress", progress)

	# Update quality distribution from targeted object
	if player.has_method("get_targeted_object"):
		var targeted = player.get_targeted_object()
		if targeted and is_instance_valid(targeted):
			var distribution = {}

			if targeted.has_method("get_scan_data"):
				distribution = targeted.get_scan_data()
			elif targeted.has_method("get_quality_distribution"):
				distribution = targeted.get_quality_distribution()

			if distribution.size() > 0:
				miner1_circle.call("set_quality_distribution", distribution)
				miner2_circle.call("set_quality_distribution", distribution)
