extends Control

# ============================================================================
# SKILLS UI CONTROLLER
# ============================================================================
# Displays skill levels, XP progress, and datacard status
# Integrates with SkillManager

# UI References (set in editor or via code)
@onready var skills_container: VBoxContainer = $SkillsContainer
@onready var skill_template: PackedScene = null  # Load skill panel template

# Update interval
var update_timer: float = 0.0
const UPDATE_INTERVAL: float = 1.0

func _ready():
	# Connect to SkillManager signals
	if SkillManager:
		SkillManager.skill_leveled_up.connect(_on_skill_leveled_up)
		SkillManager.xp_gained.connect(_on_xp_gained)
		SkillManager.datacard_acquired.connect(_on_datacard_acquired)

	# Initial UI update
	update_skills_display()

func _process(delta):
	update_timer += delta
	if update_timer >= UPDATE_INTERVAL:
		update_timer = 0.0
		update_skills_display()

func update_skills_display():
	"""Update all skill displays"""
	if not SkillManager:
		return

	# Clear existing displays
	if skills_container:
		for child in skills_container.get_children():
			child.queue_free()

	# Create skill panels
	for skill_name in SkillManager.skills:
		var skill = SkillManager.skills[skill_name]
		create_skill_panel(skill_name, skill)

func create_skill_panel(skill_name: String, skill: Dictionary):
	"""Create a skill display panel"""
	# Create panel
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(400, 80)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	# Skill name and level
	var header = HBoxContainer.new()
	vbox.add_child(header)

	var name_label = Label.new()
	name_label.text = skill_name.capitalize()
	name_label.add_theme_font_size_override("font_size", 16)
	header.add_child(name_label)

	header.add_child(Control.new())  # Spacer
	header.get_child(-1).size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var level_label = Label.new()
	level_label.text = "Level %d" % skill["current_level"]
	level_label.add_theme_font_size_override("font_size", 16)
	header.add_child(level_label)

	# Datacard status
	var datacard_label = Label.new()
	if skill["datacard_owned"]:
		datacard_label.text = "✅ Datacard"
		datacard_label.add_theme_color_override("font_color", Color.GREEN)
	else:
		datacard_label.text = "❌ No Datacard (-20% efficiency)"
		datacard_label.add_theme_color_override("font_color", Color.RED)
	vbox.add_child(datacard_label)

	# XP Progress bar
	var xp_container = VBoxContainer.new()
	vbox.add_child(xp_container)

	var xp_label = Label.new()
	var xp_percent = 0.0
	if skill["xp_for_next_level"] > 0:
		xp_percent = (float(skill["current_xp"]) / float(skill["xp_for_next_level"])) * 100.0
	xp_label.text = "XP: %d / %d (%.1f%%)" % [skill["current_xp"], skill["xp_for_next_level"], xp_percent]
	xp_container.add_child(xp_label)

	var xp_bar = ProgressBar.new()
	xp_bar.max_value = skill["xp_for_next_level"]
	xp_bar.value = skill["current_xp"]
	xp_bar.custom_minimum_size = Vector2(380, 20)
	xp_container.add_child(xp_bar)

	# Add to container
	if skills_container:
		skills_container.add_child(panel)

# ============================================================================
# SIGNAL HANDLERS
# ============================================================================

func _on_skill_leveled_up(skill_name: String, new_level: int):
	"""Handle skill level up"""
	print("🎉 UI: %s leveled up to %d!" % [skill_name, new_level])
	update_skills_display()

	# Show popup notification
	show_notification("Level Up!", "%s reached level %d!" % [skill_name.capitalize(), new_level])

func _on_xp_gained(skill_name: String, amount: int, new_total: int):
	"""Handle XP gain"""
	# XP updates are handled by periodic refresh
	pass

func _on_datacard_acquired(skill_name: String):
	"""Handle datacard acquisition"""
	print("📀 UI: Datacard acquired for %s!" % skill_name)
	update_skills_display()

	# Show popup notification
	show_notification("Datacard Acquired!", "%s efficiency unlocked!" % skill_name.capitalize())

func show_notification(title: String, message: String):
	"""Show a notification popup"""
	# Create notification popup
	var popup = AcceptDialog.new()
	popup.dialog_text = message
	popup.title = title
	popup.size = Vector2(300, 150)
	add_child(popup)
	popup.popup_centered()

	# Auto-close after 3 seconds
	get_tree().create_timer(3.0).timeout.connect(func(): popup.queue_free())

# ============================================================================
# PUBLIC INTERFACE
# ============================================================================

func refresh():
	"""Force refresh of UI"""
	update_skills_display()
