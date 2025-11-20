extends Control

# ============================================================================
# TEMPERATURE UI CONTROLLER
# ============================================================================
# Displays ship temperature, coolant levels, and warnings
# Integrates with TemperatureSystem

# UI References
@onready var temp_label: Label = $TempLabel
@onready var temp_bar: ProgressBar = $TempBar
@onready var coolant_label: Label = $CoolantLabel
@onready var coolant_bar: ProgressBar = $CoolantBar
@onready var status_label: Label = $StatusLabel
@onready var warning_panel: Panel = $WarningPanel

# Reference to temperature system
var temperature_system: Node = null

# Update interval
var update_timer: float = 0.0
const UPDATE_INTERVAL: float = 0.5  # Update twice per second

func _ready():
	# Get player and temperature system
	if has_node("/root/Player"):
		var player = get_node("/root/Player")
		if player.has_node("TemperatureSystem"):
			temperature_system = player.get_node("TemperatureSystem")

			# Connect signals
			temperature_system.temperature_warning.connect(_on_temperature_warning)
			temperature_system.temperature_critical.connect(_on_temperature_critical)
			temperature_system.temperature_damage.connect(_on_temperature_damage)
			temperature_system.coolant_low.connect(_on_coolant_low)
			temperature_system.coolant_depleted.connect(_on_coolant_depleted)

	# Hide warning panel initially
	if warning_panel:
		warning_panel.visible = false

	update_display()

func _process(delta):
	update_timer += delta
	if update_timer >= UPDATE_INTERVAL:
		update_timer = 0.0
		update_display()

func update_display():
	"""Update temperature display"""
	if not temperature_system:
		return

	var temp = temperature_system.current_temperature
	var coolant = temperature_system.coolant_amount
	var max_coolant = temperature_system.MAX_COOLANT_CAPACITY

	# Temperature label and bar
	if temp_label:
		temp_label.text = "Temperature: %.1f°C" % temp

	if temp_bar:
		temp_bar.max_value = temperature_system.MAX_TEMP
		temp_bar.value = temp

		# Color based on temperature
		if temp >= temperature_system.DAMAGE_TEMP:
			temp_bar.modulate = Color.RED
		elif temp >= temperature_system.CPU_CRITICAL_TEMP:
			temp_bar.modulate = Color.ORANGE
		elif temp >= temperature_system.WARNING_TEMP:
			temp_bar.modulate = Color.YELLOW
		else:
			temp_bar.modulate = Color.GREEN

	# Coolant label and bar
	if coolant_label:
		var runtime = temperature_system.get_coolant_runtime_minutes()
		coolant_label.text = "Coolant: %.0f / %.0f (%.0f min)" % [coolant, max_coolant, runtime]

	if coolant_bar:
		coolant_bar.max_value = max_coolant
		coolant_bar.value = coolant

		# Color based on coolant level
		var percent = (coolant / max_coolant) * 100.0
		if percent < 10.0:
			coolant_bar.modulate = Color.RED
		elif percent < 30.0:
			coolant_bar.modulate = Color.ORANGE
		else:
			coolant_bar.modulate = Color.CYAN

	# Status label
	if status_label:
		var status = temperature_system.get_temperature_status()
		status_label.text = "Status: %s" % status

		match status:
			"CRITICAL":
				status_label.add_theme_color_override("font_color", Color.RED)
			"WARNING":
				status_label.add_theme_color_override("font_color", Color.YELLOW)
			"ELEVATED":
				status_label.add_theme_color_override("font_color", Color.ORANGE)
			"NORMAL":
				status_label.add_theme_color_override("font_color", Color.GREEN)

# ============================================================================
# SIGNAL HANDLERS
# ============================================================================

func _on_temperature_warning(temp: float):
	"""Handle temperature warning"""
	show_warning("Temperature Warning", "Temperature at %.1f°C" % temp, Color.YELLOW)

func _on_temperature_critical(temp: float):
	"""Handle critical temperature"""
	show_warning("CRITICAL TEMPERATURE", "Emergency shutdown at %.1f°C!" % temp, Color.RED)

func _on_temperature_damage(damage: float):
	"""Handle temperature damage"""
	show_warning("HEAT DAMAGE", "Taking %.1f HP/s damage!" % damage, Color.RED)

func _on_coolant_low(amount: float):
	"""Handle low coolant"""
	show_warning("Coolant Low", "Only %.0f units remaining" % amount, Color.ORANGE)

func _on_coolant_depleted():
	"""Handle depleted coolant"""
	show_warning("COOLANT DEPLETED", "Temperature rising rapidly!", Color.RED)

func show_warning(title: String, message: String, color: Color):
	"""Show warning message"""
	if warning_panel:
		warning_panel.visible = true
		warning_panel.modulate = color

		# Auto-hide after 3 seconds
		get_tree().create_timer(3.0).timeout.connect(func():
			if warning_panel:
				warning_panel.visible = false
		)

	print("⚠️ UI Warning: %s - %s" % [title, message])

# ============================================================================
# PUBLIC INTERFACE
# ============================================================================

func refresh():
	"""Force refresh of UI"""
	update_display()

func get_system_info() -> Dictionary:
	"""Get temperature system info"""
	if not temperature_system:
		return {}

	return temperature_system.get_system_info()
