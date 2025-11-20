extends Node
## WindowManager - Centralized window and widget management system
##
## Manages all game windows, panels, and widgets. Provides:
## - Window registration and lifecycle management
## - Layout presets for different gameplay modes (Mining, Combat, Trading, etc.)
## - Hotkey binding system
## - Window state persistence
## - Event bus for window communication
##
## Usage:
##   WindowManager.register_window("cargo_panel", cargo_panel_node)
##   WindowManager.open_window("cargo_panel")
##   WindowManager.apply_layout_preset(WindowManager.LayoutPreset.MINING)

# ============================================================================
# SIGNALS
# ============================================================================

signal window_opened(window_id: String)
signal window_closed(window_id: String)
signal window_focused(window_id: String)
signal layout_changed(preset: int)
signal widget_registered(widget_id: String)
signal widget_data_updated(widget_id: String, data: Dictionary)

# Widget switching signals (F1-F8)
signal widget_switch_f1
signal widget_switch_f2
signal widget_switch_f3
signal widget_switch_f4
signal widget_switch_f5
signal widget_switch_f6
signal widget_switch_f7
signal widget_switch_f8

# ============================================================================
# ENUMS
# ============================================================================

enum LayoutPreset {
	MINING,      ## Mining Scanner + Cargo Overview focus
	COMBAT,      ## Tactical Display + Ship Status focus
	TRADING,     ## Market + Cargo + Station focus
	EXPLORATION, ## Map + Scanner + Discovery focus
	ENGINEERING, ## Ship Details + Module Management focus
	CUSTOM       ## User-defined layout
}

enum WidgetUpdatePriority {
	CRITICAL,    ## Every frame (max 60 FPS)
	HIGH,        ## Every 2 frames (30 FPS)
	MEDIUM,      ## Every 5 frames (12 FPS)
	LOW,         ## Every 10 frames (6 FPS)
	BACKGROUND   ## Every 30 frames (2 FPS)
}

# ============================================================================
# CONSTANTS
# ============================================================================

const MAX_WIDGETS: int = 50
const DEFAULT_UPDATE_INTERVAL: float = 0.5

# ============================================================================
# STATE
# ============================================================================

## Registered windows: window_id -> Control node
var _windows: Dictionary = {}

## Active (visible) windows
var _active_windows: Array[String] = []

## Currently focused window
var _focused_window: String = ""

## Current layout preset
var current_layout: LayoutPreset = LayoutPreset.MINING

## Hotkey bindings: Key -> {type: "window"|"widget"|"action", target: String, callback: Callable}
var _hotkeys: Dictionary = {}

## Widget switching hotkeys for PermanentInfoPanel
var _widget_hotkeys: Dictionary = {}

## Registered widgets for batch updating
var _widgets: Dictionary = {}  # widget_id -> BaseWidget instance

## Widget update batching (performance optimization)
var _widget_update_queue: Dictionary = {
	WidgetUpdatePriority.CRITICAL: [],
	WidgetUpdatePriority.HIGH: [],
	WidgetUpdatePriority.MEDIUM: [],
	WidgetUpdatePriority.LOW: [],
	WidgetUpdatePriority.BACKGROUND: []
}

var _frame_counter: int = 0

# ============================================================================
# LIFECYCLE
# ============================================================================

func _ready():
	print("✅ WindowManager initialized")

	# Setup default hotkeys
	_setup_default_hotkeys()

	# Start update loop
	set_process(true)

func _process(_delta: float):
	_frame_counter += 1

	# Batch update widgets based on priority
	_update_widget_batch(WidgetUpdatePriority.CRITICAL, 1)

	if _frame_counter % 2 == 0:
		_update_widget_batch(WidgetUpdatePriority.HIGH, 2)

	if _frame_counter % 5 == 0:
		_update_widget_batch(WidgetUpdatePriority.MEDIUM, 5)

	if _frame_counter % 10 == 0:
		_update_widget_batch(WidgetUpdatePriority.LOW, 10)

	if _frame_counter % 30 == 0:
		_update_widget_batch(WidgetUpdatePriority.BACKGROUND, 30)

func _update_widget_batch(priority: WidgetUpdatePriority, _interval: int):
	"""Update all widgets in a priority queue"""
	var widgets = _widget_update_queue.get(priority, [])

	for widget_id in widgets:
		if _widgets.has(widget_id):
			var widget = _widgets[widget_id]
			if is_instance_valid(widget) and widget.visible:
				widget.update_widget_data()

# ============================================================================
# WINDOW REGISTRATION
# ============================================================================

func register_window(window_id: String, window_instance: Control) -> void:
	"""Register a window with the manager"""
	if _windows.has(window_id):
		push_warning("WindowManager: Window '%s' already registered, overwriting" % window_id)

	_windows[window_id] = window_instance
	print("✅ WindowManager: Registered window '%s'" % window_id)

func unregister_window(window_id: String) -> void:
	"""Unregister a window"""
	if not _windows.has(window_id):
		push_warning("WindowManager: Cannot unregister unknown window '%s'" % window_id)
		return

	_windows.erase(window_id)
	_active_windows.erase(window_id)
	print("✅ WindowManager: Unregistered window '%s'" % window_id)

func has_window(window_id: String) -> bool:
	"""Check if window exists"""
	return _windows.has(window_id)

func get_window(window_id: String) -> Control:
	"""Get window by ID"""
	return _windows.get(window_id, null)

# ============================================================================
# WINDOW CONTROL
# ============================================================================

func open_window(window_id: String) -> void:
	"""Open/show a window"""
	if not _windows.has(window_id):
		push_error("WindowManager: Window not found: %s" % window_id)
		return

	var window = _windows[window_id]
	if not is_instance_valid(window):
		push_error("WindowManager: Window '%s' is invalid" % window_id)
		return

	window.visible = true

	if not _active_windows.has(window_id):
		_active_windows.append(window_id)

	window_opened.emit(window_id)
	print("✅ WindowManager: Opened window '%s'" % window_id)

func close_window(window_id: String) -> void:
	"""Close/hide a window"""
	if not _windows.has(window_id):
		push_warning("WindowManager: Cannot close unknown window '%s'" % window_id)
		return

	var window = _windows[window_id]
	if is_instance_valid(window):
		window.visible = false

	_active_windows.erase(window_id)
	window_closed.emit(window_id)
	print("✅ WindowManager: Closed window '%s'" % window_id)

func toggle_window(window_id: String) -> void:
	"""Toggle window visibility"""
	if not _windows.has(window_id):
		push_warning("WindowManager: Cannot toggle unknown window '%s'" % window_id)
		return

	var window = _windows[window_id]
	if not is_instance_valid(window):
		return

	if window.visible:
		close_window(window_id)
	else:
		open_window(window_id)

func focus_window(window_id: String) -> void:
	"""Bring window to front and focus it"""
	if not _windows.has(window_id):
		push_warning("WindowManager: Cannot focus unknown window '%s'" % window_id)
		return

	var window = _windows[window_id]
	if not is_instance_valid(window):
		return

	_focused_window = window_id
	window.move_to_front()
	window_focused.emit(window_id)

func is_window_open(window_id: String) -> bool:
	"""Check if window is currently open"""
	return _active_windows.has(window_id)

func get_active_windows() -> Array[String]:
	"""Get list of active window IDs"""
	return _active_windows.duplicate()

# ============================================================================
# WIDGET REGISTRATION (Performance Optimized)
# ============================================================================

func register_widget(widget_id: String, widget_instance: Control, priority: WidgetUpdatePriority = WidgetUpdatePriority.MEDIUM) -> void:
	"""Register a widget for managed updates"""
	if _widgets.has(widget_id):
		push_warning("WindowManager: Widget '%s' already registered, overwriting" % widget_id)

	_widgets[widget_id] = widget_instance

	# Add to appropriate update queue
	if not _widget_update_queue[priority].has(widget_id):
		_widget_update_queue[priority].append(widget_id)

	widget_registered.emit(widget_id)
	print("✅ WindowManager: Registered widget '%s' with priority %s" % [widget_id, WidgetUpdatePriority.keys()[priority]])

func unregister_widget(widget_id: String) -> void:
	"""Unregister a widget"""
	if not _widgets.has(widget_id):
		return

	_widgets.erase(widget_id)

	# Remove from all update queues
	for priority in _widget_update_queue.keys():
		_widget_update_queue[priority].erase(widget_id)

	print("✅ WindowManager: Unregistered widget '%s'" % widget_id)

func update_widget_priority(widget_id: String, new_priority: WidgetUpdatePriority) -> void:
	"""Change widget update priority"""
	if not _widgets.has(widget_id):
		return

	# Remove from all queues
	for priority in _widget_update_queue.keys():
		_widget_update_queue[priority].erase(widget_id)

	# Add to new priority queue
	_widget_update_queue[new_priority].append(widget_id)

# ============================================================================
# LAYOUT MANAGEMENT
# ============================================================================

func apply_layout_preset(preset: LayoutPreset) -> void:
	"""Apply a predefined layout configuration"""
	current_layout = preset

	match preset:
		LayoutPreset.MINING:
			_apply_mining_layout()
		LayoutPreset.COMBAT:
			_apply_combat_layout()
		LayoutPreset.TRADING:
			_apply_trading_layout()
		LayoutPreset.EXPLORATION:
			_apply_exploration_layout()
		LayoutPreset.ENGINEERING:
			_apply_engineering_layout()
		LayoutPreset.CUSTOM:
			pass  # User-defined, no changes

	layout_changed.emit(preset)
	print("✅ WindowManager: Applied layout preset '%s'" % LayoutPreset.keys()[preset])

func _apply_mining_layout() -> void:
	"""Configure windows for mining operations"""
	# Column 2: Mining Scanner
	# Column 3: Cargo Overview
	# This is set via PermanentInfoPanel widget selection
	pass

func _apply_combat_layout() -> void:
	"""Configure windows for combat"""
	# Column 2: Tactical Display
	# Column 3: Ship Modules
	pass

func _apply_trading_layout() -> void:
	"""Configure windows for trading"""
	# Column 2: Cargo Overview
	# Column 3: Ship Details (for resource management)
	pass

func _apply_exploration_layout() -> void:
	"""Configure windows for exploration"""
	# Column 2: Spectral Scan
	# Column 3: Quality Graph
	pass

func _apply_engineering_layout() -> void:
	"""Configure windows for ship engineering"""
	# Column 2: Ship Overview
	# Column 3: Ship Details
	pass

# ============================================================================
# HOTKEY MANAGEMENT
# ============================================================================

func bind_hotkey(key: Key, window_id: String) -> void:
	"""Bind a hotkey to toggle a window"""
	_hotkeys[key] = {
		"type": "window",
		"target": window_id,
		"callback": Callable()
	}
	print("✅ WindowManager: Bound key %s to window '%s'" % [OS.get_keycode_string(key), window_id])

func bind_hotkey_action(key: Key, action_name: String, callback: Callable) -> void:
	"""Bind a hotkey to a custom action with callback"""
	_hotkeys[key] = {
		"type": "action",
		"target": action_name,
		"callback": callback
	}
	print("✅ WindowManager: Bound key %s to action '%s'" % [OS.get_keycode_string(key), action_name])

func bind_widget_hotkey(key: Key, widget_signal_name: String) -> void:
	"""Bind a hotkey to emit a widget switching signal"""
	_widget_hotkeys[key] = widget_signal_name
	print("✅ WindowManager: Bound key %s to widget signal '%s'" % [OS.get_keycode_string(key), widget_signal_name])

func unbind_hotkey(key: Key) -> void:
	"""Remove hotkey binding"""
	_hotkeys.erase(key)
	_widget_hotkeys.erase(key)

func get_hotkey_for_window(window_id: String) -> Key:
	"""Get the hotkey bound to a window"""
	for key in _hotkeys.keys():
		var binding = _hotkeys[key]
		if binding.type == "window" and binding.target == window_id:
			return key
	return KEY_NONE

func get_all_hotkeys() -> Dictionary:
	"""Get all hotkey bindings"""
	return _hotkeys.duplicate()

func _setup_default_hotkeys() -> void:
	"""Setup default hotkey bindings"""
	# F-keys for PermanentInfoPanel widget switching (F1-F8)
	bind_widget_hotkey(KEY_F1, "widget_switch_f1")
	bind_widget_hotkey(KEY_F2, "widget_switch_f2")
	bind_widget_hotkey(KEY_F3, "widget_switch_f3")
	bind_widget_hotkey(KEY_F4, "widget_switch_f4")
	bind_widget_hotkey(KEY_F5, "widget_switch_f5")
	bind_widget_hotkey(KEY_F6, "widget_switch_f6")
	bind_widget_hotkey(KEY_F7, "widget_switch_f7")
	bind_widget_hotkey(KEY_F8, "widget_switch_f8")

	print("✅ WindowManager: Default hotkeys configured (F1-F8 for widgets)")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		# Check widget hotkeys first
		if _widget_hotkeys.has(event.keycode):
			var signal_name = _widget_hotkeys[event.keycode]
			# Emit signal that PermanentInfoPanel can listen to
			call_deferred("emit_signal", signal_name)
			get_viewport().set_input_as_handled()
			return

		# Check general hotkeys
		if _hotkeys.has(event.keycode):
			var binding = _hotkeys[event.keycode]
			match binding.type:
				"window":
					toggle_window(binding.target)
				"action":
					if binding.callback.is_valid():
						binding.callback.call()
			get_viewport().set_input_as_handled()

# ============================================================================
# WINDOW STATE PERSISTENCE
# ============================================================================

func save_window_layout() -> Dictionary:
	"""Save current window layout to dictionary"""
	var state = {
		"layout": current_layout,
		"active_windows": _active_windows.duplicate(),
		"focused": _focused_window,
		"window_positions": {}
	}

	for window_id in _windows.keys():
		var window = _windows[window_id]
		if is_instance_valid(window):
			state.window_positions[window_id] = {
				"position": window.position,
				"size": window.size,
				"visible": window.visible
			}

	return state

func load_window_layout(state: Dictionary) -> void:
	"""Restore window layout from saved state"""
	if state.has("layout"):
		current_layout = state.layout

	if state.has("active_windows"):
		for window_id in state.active_windows:
			open_window(window_id)

	if state.has("window_positions"):
		for window_id in state.window_positions.keys():
			if _windows.has(window_id):
				var pos_data = state.window_positions[window_id]
				var window = _windows[window_id]
				if is_instance_valid(window):
					window.position = pos_data.get("position", Vector2.ZERO)
					window.size = pos_data.get("size", Vector2(400, 300))
					window.visible = pos_data.get("visible", false)

	print("✅ WindowManager: Loaded window layout")

# ============================================================================
# DATA SHARING (Event Bus)
# ============================================================================

func broadcast_widget_data(widget_id: String, data: Dictionary) -> void:
	"""Broadcast data update from a widget to all listeners"""
	widget_data_updated.emit(widget_id, data)

# ============================================================================
# UTILITY
# ============================================================================

func get_stats() -> Dictionary:
	"""Get WindowManager statistics"""
	return {
		"total_windows": _windows.size(),
		"active_windows": _active_windows.size(),
		"total_widgets": _widgets.size(),
		"current_layout": LayoutPreset.keys()[current_layout],
		"frame_counter": _frame_counter
	}

func print_stats() -> void:
	"""Print WindowManager statistics to console"""
	var stats = get_stats()
	print("=== WindowManager Stats ===")
	print("Total Windows: %d" % stats.total_windows)
	print("Active Windows: %d" % stats.active_windows)
	print("Total Widgets: %d" % stats.total_widgets)
	print("Current Layout: %s" % stats.current_layout)
	print("Frame Counter: %d" % stats.frame_counter)
	print("===========================")

# ============================================================================
# LAYOUT MANAGER INTEGRATION
# ============================================================================

var layout_manager: LayoutManager = null

func enable_layout_persistence() -> void:
	"""Enable layout saving and loading"""
	if not layout_manager:
		layout_manager = LayoutManager.new()
		layout_manager.create_default_layouts()
		print("✅ WindowManager: Layout persistence enabled")

func save_current_layout(layout_name: String, description: String = "") -> bool:
	"""Save current layout"""
	if not layout_manager:
		enable_layout_persistence()

	return layout_manager.save_layout(layout_name, description)

func load_saved_layout(layout_name: String) -> bool:
	"""Load a saved layout"""
	if not layout_manager:
		enable_layout_persistence()

	return layout_manager.load_layout(layout_name)

func get_available_layouts() -> Array[String]:
	"""Get list of saved layouts"""
	if not layout_manager:
		enable_layout_persistence()

	return layout_manager.get_available_layouts()

func delete_saved_layout(layout_name: String) -> bool:
	"""Delete a saved layout"""
	if not layout_manager:
		enable_layout_persistence()

	return layout_manager.delete_layout(layout_name)
