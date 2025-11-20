extends Control

# ============================================================================
# ENERGY UI CONTROLLER
# ============================================================================
# Displays power grid status, generators, and consumers
# Integrates with EnergySystem

# UI References
@onready var energy_bar: ProgressBar = $EnergyBar
@onready var energy_label: Label = $EnergyLabel
@onready var generation_label: Label = $GenerationLabel
@onready var consumption_label: Label = $ConsumptionLabel
@onready var balance_label: Label = $BalanceLabel
@onready var generators_container: VBoxContainer = $GeneratorsContainer
@onready var consumers_container: VBoxContainer = $ConsumersContainer

# Reference to energy system
var energy_system: Node = null

# Update interval
var update_timer: float = 0.0
const UPDATE_INTERVAL: float = 1.0

func _ready():
	# Get energy system
	if has_node("/root/Player"):
		var player = get_node("/root/Player")
		if player.has_node("EnergySystem"):
			energy_system = player.get_node("EnergySystem")

			# Connect signals
			energy_system.energy_depleted.connect(_on_energy_depleted)
			energy_system.energy_low.connect(_on_energy_low)
			energy_system.grid_overload.connect(_on_grid_overload)
			energy_system.generator_overload.connect(_on_generator_overload)

	update_display()

func _process(delta):
	update_timer += delta
	if update_timer >= UPDATE_INTERVAL:
		update_timer = 0.0
		update_display()

func update_display():
	"""Update energy grid display"""
	if not energy_system:
		return

	var info = energy_system.get_grid_info()

	# Energy buffer
	if energy_bar:
		energy_bar.max_value = info["max_energy_buffer"]
		energy_bar.value = info["energy_buffer"]

		# Color based on level
		var percent = info["buffer_percent"]
		if percent < 5.0:
			energy_bar.modulate = Color.RED
		elif percent < 20.0:
			energy_bar.modulate = Color.ORANGE
		elif percent < 50.0:
			energy_bar.modulate = Color.YELLOW
		else:
			energy_bar.modulate = Color.GREEN

	if energy_label:
		energy_label.text = "Energy: %.0f / %.0f EU (%.1f%%)" % [
			info["energy_buffer"],
			info["max_energy_buffer"],
			info["buffer_percent"]
		]

	# Generation
	if generation_label:
		generation_label.text = "⚡ Generation: %.0f EU/s" % info["total_generation"]

	# Consumption
	if consumption_label:
		consumption_label.text = "🔌 Consumption: %.0f EU/s" % info["total_consumption"]

	# Balance
	if balance_label:
		var balance = info["total_generation"] - info["total_consumption"]
		var symbol = "+" if balance >= 0 else ""
		balance_label.text = "Balance: %s%.0f EU/s" % [symbol, balance]

		if balance < 0:
			balance_label.add_theme_color_override("font_color", Color.RED)
		else:
			balance_label.add_theme_color_override("font_color", Color.GREEN)

	# Update generators list
	update_generators_list()

	# Update consumers list
	update_consumers_list()

func update_generators_list():
	"""Update generators display"""
	if not generators_container or not energy_system:
		return

	# Clear existing
	for child in generators_container.get_children():
		child.queue_free()

	# Add generators
	for gen_id in energy_system.generators:
		var gen = energy_system.generators[gen_id]
		var gen_info = gen.get_info()

		var panel = create_generator_panel(gen_info)
		generators_container.add_child(panel)

func create_generator_panel(gen_info: Dictionary) -> PanelContainer:
	"""Create a generator display panel"""
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(300, 60)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	# Generator name and status
	var header = HBoxContainer.new()
	vbox.add_child(header)

	var name_label = Label.new()
	name_label.text = gen_info["name"]
	header.add_child(name_label)

	header.add_child(Control.new())  # Spacer
	header.get_child(-1).size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var status_label = Label.new()
	status_label.text = "ON" if gen_info["is_active"] else "OFF"
	status_label.add_theme_color_override("font_color", Color.GREEN if gen_info["is_active"] else Color.RED)
	header.add_child(status_label)

	# Output
	var output_label = Label.new()
	output_label.text = "Output: %.0f EU/s (%.0f%% efficiency)" % [
		gen_info["current_output"],
		gen_info["efficiency"] * 100.0
	]
	vbox.add_child(output_label)

	# Fuel (if applicable)
	if gen_info["fuel_type"] != "":
		var fuel_label = Label.new()
		fuel_label.text = "Fuel: %s (%.2f/s)" % [gen_info["fuel_type"], gen_info["fuel_consumption"]]
		vbox.add_child(fuel_label)

	# Overload indicator
	if gen_info["is_overloaded"]:
		var overload_label = Label.new()
		overload_label.text = "⚠️ OVERLOAD (%.0fs remaining)" % gen_info["overload_time_remaining"]
		overload_label.add_theme_color_override("font_color", Color.ORANGE)
		vbox.add_child(overload_label)

	return panel

func update_consumers_list():
	"""Update consumers display"""
	if not consumers_container or not energy_system:
		return

	# Clear existing
	for child in consumers_container.get_children():
		child.queue_free()

	# Add consumers
	for consumer_id in energy_system.power_consumers:
		var consumer = energy_system.power_consumers[consumer_id]
		var consumer_info = consumer.get_info()

		var panel = create_consumer_panel(consumer_info)
		consumers_container.add_child(panel)

func create_consumer_panel(consumer_info: Dictionary) -> PanelContainer:
	"""Create a consumer display panel"""
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(300, 40)

	var hbox = HBoxContainer.new()
	panel.add_child(hbox)

	# Consumer name
	var name_label = Label.new()
	name_label.text = consumer_info["consumer_name"]
	hbox.add_child(name_label)

	hbox.add_child(Control.new())  # Spacer
	hbox.get_child(-1).size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Power draw
	var draw_label = Label.new()
	draw_label.text = "%.0f EU/s" % consumer_info["power_draw"]
	hbox.add_child(draw_label)

	# Status
	var status_label = Label.new()
	status_label.text = " [ON]" if consumer_info["is_active"] else " [OFF]"
	status_label.add_theme_color_override("font_color", Color.GREEN if consumer_info["is_active"] else Color.GRAY)
	hbox.add_child(status_label)

	# Priority
	var priority_label = Label.new()
	priority_label.text = " (%s)" % consumer_info["priority"]
	priority_label.add_theme_font_size_override("font_size", 10)
	hbox.add_child(priority_label)

	return panel

# ============================================================================
# SIGNAL HANDLERS
# ============================================================================

func _on_energy_depleted():
	"""Handle energy depletion"""
	show_alert("ENERGY DEPLETED", "Power systems failing!", Color.RED)

func _on_energy_low(amount: float):
	"""Handle low energy"""
	show_alert("Low Energy", "Energy buffer at %.0f EU" % amount, Color.ORANGE)

func _on_grid_overload(consumption: float, capacity: float):
	"""Handle grid overload"""
	show_alert("Grid Overload", "Consumption (%.0f) exceeds generation (%.0f)" % [consumption, capacity], Color.RED)

func _on_generator_overload(generator_id: String):
	"""Handle generator overload"""
	show_alert("Generator Overload", "%s overload limit reached" % generator_id, Color.ORANGE)

func show_alert(title: String, message: String, color: Color):
	"""Show alert message"""
	print("⚠️ Energy Alert: %s - %s" % [title, message])

	# Create popup
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
	update_display()

func toggle_generator(generator_id: String):
	"""Toggle generator on/off"""
	if not energy_system:
		return

	if energy_system.generators.has(generator_id):
		var gen = energy_system.generators[generator_id]
		energy_system.set_generator_active(generator_id, not gen.is_active)
		update_display()

func toggle_consumer(consumer_id: String):
	"""Toggle consumer on/off"""
	if not energy_system:
		return

	if energy_system.power_consumers.has(consumer_id):
		var consumer = energy_system.power_consumers[consumer_id]
		energy_system.set_consumer_active(consumer_id, not consumer.is_active)
		update_display()
