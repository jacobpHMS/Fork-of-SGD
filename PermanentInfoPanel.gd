extends PanelContainer
## PermanentInfoPanel - Refactored Widget-Based System
##
## Manages the permanent info panel at the bottom of the screen.
## Now uses the WindowManager + BaseWidget architecture for modularity.
##
## Layout: 4 columns (15% / 35% / 35% / 15%)
## - Column 1: History & Events (fixed widgets)
## - Column 2: Selectable Widget (8 options)
## - Column 3: Selectable Widget (8 options)
## - Column 4: Tab System (Ship Status tabs)

# ============================================================================
# CONSTANTS
# ============================================================================

const CargoWindowScene = preload("res://scenes/CargoWindow.tscn")

# ============================================================================
# WIDGET TYPES
# ============================================================================

enum WidgetType {
	MINING_SCANNER,    # Mining Scanner (2 circles)
	SPECTRAL_SCAN,     # Spectral Scan (1 large circle)
	QUALITY_GRAPH,     # Quality Distribution Graph
	CARGO_OVERVIEW,    # Cargo Overview
	SHIP_MODULES,      # Ship Module Status
	TACTICAL_DISPLAY,  # Tactical Display
	SHIP_OVERVIEW,     # Ship Overview (visual layout)
	SHIP_DETAILS       # Ship Details (resource management)
}

# ============================================================================
# REFERENCES
# ============================================================================

# Column References
@onready var column1 = $HBoxContainer/Column1
@onready var column2 = $HBoxContainer/Column2
@onready var column3 = $HBoxContainer/Column3
@onready var column4 = $HBoxContainer/Column4

# Column 1 Widgets (Fixed)
var history_widget: HistoryWidget = null
var world_events_widget: WorldEventsWidget = null

# Column 2+3 Widget Containers
@onready var panel2_selector = $HBoxContainer/Column2/VBoxContainer/PanelSelector
@onready var panel2_container = $HBoxContainer/Column2/VBoxContainer/ContentContainer
@onready var panel3_selector = $HBoxContainer/Column3/VBoxContainer/PanelSelector
@onready var panel3_container = $HBoxContainer/Column3/VBoxContainer/ContentContainer

# Column 4 References
@onready var tab_container = $HBoxContainer/Column4/VBoxContainer/TabContainer
@onready var ship_status_label = $HBoxContainer/Column4/VBoxContainer/ShipStatus/StatusLabel

# Current widget selections
var panel2_widget: BaseWidget = null
var panel3_widget: BaseWidget = null
var panel2_type: int = WidgetType.MINING_SCANNER
var panel3_type: int = WidgetType.CARGO_OVERVIEW

# Player reference
var player_node: Node = null

# Theme
var theme: SciFiTheme = null

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	# Create theme
	theme = SciFiTheme.new()

	# Apply panel styling
	_apply_theme()

	# Setup column 1 (fixed widgets)
	_setup_column1_widgets()

	# Setup panel selectors (column 2+3)
	_setup_panel_selectors()

	# Load initial widgets
	_load_widget_in_column(2, panel2_type)
	_load_widget_in_column(3, panel3_type)

	# Setup tab hotkeys
	_setup_tab_hotkeys()

	print("✅ PermanentInfoPanel initialized with Widget system")

func _process(_delta: float):
	# Update ship status (Column 4)
	_update_ship_status()

# ============================================================================
# THEMING
# ============================================================================

func _apply_theme() -> void:
	"""Apply Sci-Fi theme to panel"""
	var stylebox = theme.create_panel_style(SciFiTheme.PanelStyle.STANDARD, SciFiTheme.BorderGlow.MEDIUM)
	add_theme_stylebox_override("panel", stylebox)

# ============================================================================
# COLUMN 1: FIXED WIDGETS
# ============================================================================

func _setup_column1_widgets() -> void:
	"""Setup fixed widgets in Column 1 (History & Events)"""
	var column1_content = column1.get_node("VBoxContainer")

	# History Widget
	history_widget = HistoryWidget.new()
	history_widget.size_flags_vertical = Control.SIZE_EXPAND_FILL
	history_widget.custom_minimum_size = Vector2(0, 200)
	column1_content.add_child(history_widget)

	# World Events Widget
	world_events_widget = WorldEventsWidget.new()
	world_events_widget.size_flags_vertical = Control.SIZE_EXPAND_FILL
	world_events_widget.custom_minimum_size = Vector2(0, 150)
	column1_content.add_child(world_events_widget)

# ============================================================================
# COLUMN 2+3: SELECTABLE WIDGETS
# ============================================================================

func _setup_panel_selectors() -> void:
	"""Setup dropdown menus for panel selection"""
	if panel2_selector:
		_populate_selector(panel2_selector)
		panel2_selector.selected = panel2_type
		panel2_selector.item_selected.connect(_on_panel2_selected)

	if panel3_selector:
		_populate_selector(panel3_selector)
		panel3_selector.selected = panel3_type
		panel3_selector.item_selected.connect(_on_panel3_selected)

func _populate_selector(selector: OptionButton) -> void:
	"""Populate selector with widget options (with hotkey hints)"""
	selector.clear()
	selector.add_item("F1 - Mining Scanner", WidgetType.MINING_SCANNER)
	selector.add_item("F2 - Spectral Scan", WidgetType.SPECTRAL_SCAN)
	selector.add_item("F3 - Quality Graph", WidgetType.QUALITY_GRAPH)
	selector.add_item("F4 - Cargo Overview", WidgetType.CARGO_OVERVIEW)
	selector.add_item("F5 - Ship Modules", WidgetType.SHIP_MODULES)
	selector.add_item("F6 - Tactical Display", WidgetType.TACTICAL_DISPLAY)
	selector.add_item("F7 - Ship Overview", WidgetType.SHIP_OVERVIEW)
	selector.add_item("F8 - Ship Details", WidgetType.SHIP_DETAILS)

func _on_panel2_selected(index: int) -> void:
	"""Handle panel 2 selection changed"""
	panel2_type = index
	_load_widget_in_column(2, panel2_type)

func _on_panel3_selected(index: int) -> void:
	"""Handle panel 3 selection changed"""
	panel3_type = index
	_load_widget_in_column(3, panel3_type)

# ============================================================================
# WIDGET LOADING
# ============================================================================

func _load_widget_in_column(column: int, widget_type: int) -> void:
	"""Load a widget into column 2 or 3"""
	var container = panel2_container if column == 2 else panel3_container
	var current_widget = panel2_widget if column == 2 else panel3_widget

	# Remove old widget
	if current_widget and is_instance_valid(current_widget):
		current_widget.queue_free()

	# Create new widget
	var new_widget = _create_widget(widget_type)
	if not new_widget:
		push_error("Failed to create widget type %d" % widget_type)
		return

	# Bind data source
	if player_node:
		new_widget.bind_data_source(player_node)

	# Add to container
	container.add_child(new_widget)

	# Store reference
	if column == 2:
		panel2_widget = new_widget
	else:
		panel3_widget = new_widget

func _create_widget(widget_type: int) -> BaseWidget:
	"""Factory method to create widgets"""
	match widget_type:
		WidgetType.MINING_SCANNER:
			return MiningScannerWidget.new()
		WidgetType.SPECTRAL_SCAN:
			return SpectralScanWidget.new()
		WidgetType.QUALITY_GRAPH:
			return QualityGraphWidget.new()
		WidgetType.CARGO_OVERVIEW:
			return CargoOverviewWidget.new()
		WidgetType.SHIP_MODULES:
			return ShipModulesWidget.new()
		WidgetType.TACTICAL_DISPLAY:
			return TacticalDisplayWidget.new()
		WidgetType.SHIP_OVERVIEW:
			return ShipOverviewWidget.new()
		WidgetType.SHIP_DETAILS:
			return ShipDetailsWidget.new()
	return null

# ============================================================================
# COLUMN 4: SHIP STATUS
# ============================================================================

func _setup_tab_hotkeys() -> void:
	"""Setup F1-F8 hotkeys for widget switching"""
	# Connect to WindowManager widget switching signals
	WindowManager.widget_switch_f1.connect(_on_hotkey_f1_pressed)
	WindowManager.widget_switch_f2.connect(_on_hotkey_f2_pressed)
	WindowManager.widget_switch_f3.connect(_on_hotkey_f3_pressed)
	WindowManager.widget_switch_f4.connect(_on_hotkey_f4_pressed)
	WindowManager.widget_switch_f5.connect(_on_hotkey_f5_pressed)
	WindowManager.widget_switch_f6.connect(_on_hotkey_f6_pressed)
	WindowManager.widget_switch_f7.connect(_on_hotkey_f7_pressed)
	WindowManager.widget_switch_f8.connect(_on_hotkey_f8_pressed)

	print("✅ PermanentInfoPanel: F1-F8 hotkeys connected for widget switching")

func _update_ship_status() -> void:
	"""Update ship status display in Column 4"""
	if not ship_status_label or not player_node:
		return

	var status_text = "No Data"
	var speed = 0.0
	var fuel_percent = 0.0

	if player_node.has_method("get_autopilot_status_text"):
		status_text = player_node.get_autopilot_status_text()

	if "current_velocity" in player_node:
		speed = player_node.current_velocity.length()

	if "ship_data" in player_node:
		var fuel = player_node.ship_data.get("fuel", 0.0)
		var max_fuel = player_node.ship_data.get("max_fuel", 1000.0)
		fuel_percent = (fuel / max_fuel * 100.0) if max_fuel > 0 else 0

	ship_status_label.text = "%s\nSpeed: %.1f m/s\nFuel: %.0f%%" % [
		status_text,
		speed,
		fuel_percent
	]

# ============================================================================
# HOTKEY HANDLERS
# ============================================================================

func _on_hotkey_f1_pressed() -> void:
	"""F1: Switch Column 2 to Mining Scanner"""
	panel2_type = WidgetType.MINING_SCANNER
	_load_widget_in_column(2, panel2_type)
	if panel2_selector:
		panel2_selector.selected = panel2_type
	print("🔥 F1: Mining Scanner activated")

func _on_hotkey_f2_pressed() -> void:
	"""F2: Switch Column 2 to Spectral Scan"""
	panel2_type = WidgetType.SPECTRAL_SCAN
	_load_widget_in_column(2, panel2_type)
	if panel2_selector:
		panel2_selector.selected = panel2_type
	print("🔥 F2: Spectral Scan activated")

func _on_hotkey_f3_pressed() -> void:
	"""F3: Switch Column 2 to Quality Graph"""
	panel2_type = WidgetType.QUALITY_GRAPH
	_load_widget_in_column(2, panel2_type)
	if panel2_selector:
		panel2_selector.selected = panel2_type
	print("🔥 F3: Quality Graph activated")

func _on_hotkey_f4_pressed() -> void:
	"""F4: Switch Column 2 to Cargo Overview"""
	panel2_type = WidgetType.CARGO_OVERVIEW
	_load_widget_in_column(2, panel2_type)
	if panel2_selector:
		panel2_selector.selected = panel2_type
	print("🔥 F4: Cargo Overview activated")

func _on_hotkey_f5_pressed() -> void:
	"""F5: Switch Column 2 to Ship Modules"""
	panel2_type = WidgetType.SHIP_MODULES
	_load_widget_in_column(2, panel2_type)
	if panel2_selector:
		panel2_selector.selected = panel2_type
	print("🔥 F5: Ship Modules activated")

func _on_hotkey_f6_pressed() -> void:
	"""F6: Switch Column 2 to Tactical Display"""
	panel2_type = WidgetType.TACTICAL_DISPLAY
	_load_widget_in_column(2, panel2_type)
	if panel2_selector:
		panel2_selector.selected = panel2_type
	print("🔥 F6: Tactical Display activated")

func _on_hotkey_f7_pressed() -> void:
	"""F7: Switch Column 2 to Ship Overview"""
	panel2_type = WidgetType.SHIP_OVERVIEW
	_load_widget_in_column(2, panel2_type)
	if panel2_selector:
		panel2_selector.selected = panel2_type
	print("🔥 F7: Ship Overview activated")

func _on_hotkey_f8_pressed() -> void:
	"""F8: Switch Column 2 to Ship Details"""
	panel2_type = WidgetType.SHIP_DETAILS
	_load_widget_in_column(2, panel2_type)
	if panel2_selector:
		panel2_selector.selected = panel2_type
	print("🔥 F8: Ship Details activated")

# ============================================================================
# PLAYER CONNECTION
# ============================================================================

func set_player_node(player: Node) -> void:
	"""Set player reference and connect signals"""
	player_node = player

	# Bind data source to all widgets
	if history_widget:
		history_widget.bind_data_source(player)
		history_widget.connect_player_signals(player)

	if world_events_widget:
		world_events_widget.bind_data_source(player)

	if panel2_widget:
		panel2_widget.bind_data_source(player)

	if panel3_widget:
		panel3_widget.bind_data_source(player)

	print("✅ PermanentInfoPanel: Player connected")

# ============================================================================
# PUBLIC API (for compatibility)
# ============================================================================

func add_history_message(message: String) -> void:
	"""Add message to history log"""
	if history_widget:
		history_widget.add_history_message(message)

func add_world_event(event: String, event_type: String = "info") -> void:
	"""Add world event"""
	if world_events_widget:
		world_events_widget.add_world_event(event, event_type)
