extends Control

# ============================================================================
# CRAFTING UI CONTROLLER
# ============================================================================
# Displays crafting recipes, materials, and queue
# Integrates with CraftingSystem

# UI References
@onready var recipes_list: ItemList = $RecipesList
@onready var recipe_details: Panel = $RecipeDetails
@onready var materials_required: VBoxContainer = $RecipeDetails/MaterialsRequired
@onready var craft_button: Button = $RecipeDetails/CraftButton
@onready var craft_amount: SpinBox = $RecipeDetails/CraftAmount
@onready var queue_container: VBoxContainer = $QueueContainer
@onready var tier_filter: OptionButton = $TierFilter

# Reference to crafting system
var crafting_system: Node = null

# Currently selected recipe
var selected_recipe_id: String = ""

# Update interval
var update_timer: float = 0.0
const UPDATE_INTERVAL: float = 0.5

func _ready():
	# Get crafting system
	if has_node("/root/Player"):
		var player = get_node("/root/Player")
		if player.has_node("CraftingSystem"):
			crafting_system = player.get_node("CraftingSystem")

			# Connect signals
			crafting_system.crafting_started.connect(_on_crafting_started)
			crafting_system.crafting_complete.connect(_on_crafting_complete)
			crafting_system.crafting_failed.connect(_on_crafting_failed)
			crafting_system.materials_insufficient.connect(_on_materials_insufficient)

	# Setup tier filter
	if tier_filter:
		tier_filter.clear()
		tier_filter.add_item("All Tiers", -1)
		tier_filter.add_item("Components", 3)
		tier_filter.add_item("Complex Components", 4)
		tier_filter.add_item("Modules", 5)
		tier_filter.add_item("Items", 6)
		tier_filter.item_selected.connect(_on_tier_filter_changed)

	# Setup craft button
	if craft_button:
		craft_button.pressed.connect(_on_craft_button_pressed)

	# Setup recipe list
	if recipes_list:
		recipes_list.item_selected.connect(_on_recipe_selected)

	# Initial display
	update_recipes_list()
	update_queue_display()

func _process(delta):
	update_timer += delta
	if update_timer >= UPDATE_INTERVAL:
		update_timer = 0.0
		update_queue_display()

func update_recipes_list(tier_filter_value: int = -1):
	"""Update the recipes list"""
	if not recipes_list or not crafting_system:
		return

	recipes_list.clear()

	# Get all recipes
	for recipe_id in crafting_system.recipe_database:
		var recipe = crafting_system.recipe_database[recipe_id]

		# Apply tier filter
		if tier_filter_value >= 0 and recipe.production_tier != tier_filter_value:
			continue

		# Check if can craft
		var can_craft = crafting_system.can_craft(recipe_id, 1)

		# Add to list
		var display_name = recipe.recipe_name
		if not can_craft["can_craft"]:
			display_name += " [LOCKED]"

		recipes_list.add_item(display_name)
		recipes_list.set_item_metadata(recipes_list.item_count - 1, recipe_id)

		# Color based on availability
		var color = Color.WHITE
		if not can_craft["can_craft"]:
			if can_craft["insufficient_skill"]:
				color = Color.RED
			elif can_craft["missing_quality"]:
				color = Color.ORANGE
			elif can_craft["missing_materials"].size() > 0:
				color = Color.YELLOW
			else:
				color = Color.GRAY

		recipes_list.set_item_custom_fg_color(recipes_list.item_count - 1, color)

func update_recipe_details():
	"""Update recipe details panel"""
	if selected_recipe_id == "" or not crafting_system:
		if recipe_details:
			recipe_details.visible = false
		return

	if not crafting_system.recipe_database.has(selected_recipe_id):
		return

	var recipe = crafting_system.recipe_database[selected_recipe_id]

	if recipe_details:
		recipe_details.visible = true

	# Clear materials list
	if materials_required:
		for child in materials_required.get_children():
			child.queue_free()

		# Add title
		var title = Label.new()
		title.text = "Materials Required:"
		title.add_theme_font_size_override("font_size", 14)
		materials_required.add_child(title)

		# Add materials
		for material_id in recipe.required_materials:
			var required = recipe.required_materials[material_id]
			var available = crafting_system.player_inventory.get(material_id, 0.0)

			var mat_label = Label.new()
			mat_label.text = "  %s: %.0f / %.0f" % [material_id, available, required]

			if available >= required:
				mat_label.add_theme_color_override("font_color", Color.GREEN)
			else:
				mat_label.add_theme_color_override("font_color", Color.RED)

			materials_required.add_child(mat_label)

		# Add quality requirement
		if recipe.required_quality > 0:
			var quality_label = Label.new()
			quality_label.text = "  ⚠️ Requires PURE materials"
			quality_label.add_theme_color_override("font_color", Color.CYAN)
			materials_required.add_child(quality_label)

		# Add production info
		var info_label = Label.new()
		info_label.text = "\nProduction Time: %.0fs\nEnergy Cost: %.0f EU" % [
			recipe.crafting_time,
			recipe.energy_cost
		]
		materials_required.add_child(info_label)

		# Add skill requirement
		if recipe.skill_required != "":
			var skill_label = Label.new()
			skill_label.text = "Skill: %s (Level %d)" % [recipe.skill_required, recipe.min_skill_level]
			materials_required.add_child(skill_label)

	# Update craft button
	if craft_button:
		var can_craft = crafting_system.can_craft(selected_recipe_id, 1)
		craft_button.disabled = not can_craft["can_craft"]

		if can_craft["can_craft"]:
			craft_button.text = "Craft"
		else:
			craft_button.text = "Cannot Craft: " + can_craft["reason"]

func update_queue_display():
	"""Update crafting queue display"""
	if not queue_container or not crafting_system:
		return

	# Clear existing
	for child in queue_container.get_children():
		child.queue_free()

	# Add queue header
	var header = Label.new()
	header.text = "Crafting Queue (%d/%d)" % [
		crafting_system.crafting_queue.size(),
		crafting_system.max_concurrent_jobs
	]
	header.add_theme_font_size_override("font_size", 16)
	queue_container.add_child(header)

	# Add queue items
	for i in range(crafting_system.crafting_queue.size()):
		var job = crafting_system.crafting_queue[i]
		var panel = create_queue_panel(job, i)
		queue_container.add_child(panel)

func create_queue_panel(job, index: int) -> PanelContainer:
	"""Create a queue item panel"""
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(300, 80)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	# Job name
	var name_label = Label.new()
	name_label.text = "%s x%d" % [job.recipe.recipe_name, job.quantity]
	name_label.add_theme_font_size_override("font_size", 14)
	vbox.add_child(name_label)

	# Progress bar
	var progress_bar = ProgressBar.new()
	progress_bar.custom_minimum_size = Vector2(280, 20)
	var effective_time = job.recipe.crafting_time / job.efficiency_multiplier
	progress_bar.max_value = effective_time
	progress_bar.value = job.progress
	vbox.add_child(progress_bar)

	# Time remaining
	var time_label = Label.new()
	var remaining = effective_time - job.progress
	time_label.text = "Time remaining: %.0fs" % remaining
	vbox.add_child(time_label)

	# Cancel button
	var cancel_button = Button.new()
	cancel_button.text = "Cancel (50% refund)"
	cancel_button.pressed.connect(func(): _on_cancel_crafting(index))
	vbox.add_child(cancel_button)

	return panel

# ============================================================================
# SIGNAL HANDLERS
# ============================================================================

func _on_recipe_selected(index: int):
	"""Handle recipe selection"""
	if not recipes_list:
		return

	selected_recipe_id = recipes_list.get_item_metadata(index)
	update_recipe_details()

func _on_craft_button_pressed():
	"""Handle craft button press"""
	if selected_recipe_id == "" or not crafting_system:
		return

	var amount = 1
	if craft_amount:
		amount = int(craft_amount.value)

	# Start crafting
	crafting_system.start_crafting(selected_recipe_id, amount)

	# Refresh displays
	update_recipes_list()
	update_recipe_details()
	update_queue_display()

func _on_cancel_crafting(index: int):
	"""Handle cancel crafting"""
	if not crafting_system:
		return

	crafting_system.cancel_crafting(index)
	update_queue_display()

func _on_tier_filter_changed(index: int):
	"""Handle tier filter change"""
	if not tier_filter:
		return

	var tier = tier_filter.get_item_id(index)
	update_recipes_list(tier)

func _on_crafting_started(recipe_id: String, quantity: int):
	"""Handle crafting started"""
	print("🔧 UI: Crafting started - %s x%d" % [recipe_id, quantity])
	update_queue_display()

func _on_crafting_complete(recipe_id: String, result: Dictionary):
	"""Handle crafting complete"""
	print("✅ UI: Crafting complete - %s" % recipe_id)

	# Show notification
	show_notification("Crafting Complete", "%s x%.0f produced!" % [
		result["output_id"],
		result["output_amount"]
	])

	update_queue_display()
	update_recipes_list()

func _on_crafting_failed(recipe_id: String, reason: String):
	"""Handle crafting failed"""
	print("❌ UI: Crafting failed - %s: %s" % [recipe_id, reason])

	# Show error
	show_error("Crafting Failed", reason)

func _on_materials_insufficient(recipe_id: String, missing: Dictionary):
	"""Handle insufficient materials"""
	var message = "Missing materials:\n"
	for material_id in missing:
		message += "  %s: %.0f\n" % [material_id, missing[material_id]]

	show_error("Insufficient Materials", message)

func show_notification(title: String, message: String):
	"""Show notification popup"""
	var popup = AcceptDialog.new()
	popup.dialog_text = message
	popup.title = title
	popup.size = Vector2(300, 150)
	add_child(popup)
	popup.popup_centered()

	# Auto-close after 3 seconds
	get_tree().create_timer(3.0).timeout.connect(func(): popup.queue_free())

func show_error(title: String, message: String):
	"""Show error popup"""
	var popup = AcceptDialog.new()
	popup.dialog_text = message
	popup.title = title
	popup.size = Vector2(300, 200)
	add_child(popup)
	popup.popup_centered()

# ============================================================================
# PUBLIC INTERFACE
# ============================================================================

func refresh():
	"""Force refresh of UI"""
	update_recipes_list()
	update_recipe_details()
	update_queue_display()

func craft_recipe(recipe_id: String, amount: int = 1):
	"""Craft a recipe"""
	if not crafting_system:
		return

	crafting_system.start_crafting(recipe_id, amount)
	refresh()
