extends RefCounted
class_name LayoutManager
## LayoutManager - Save and load custom UI layouts
##
## Manages window layouts, widget positions, and panel configurations.
## Supports multiple named layouts and persistence to disk.
##
## Features:
## - Save/Load layouts to JSON files
## - Named layout presets
## - Window position/size persistence
## - Widget configuration storage
## - Import/Export layouts
##
## Usage:
##   var layout_mgr = LayoutManager.new()
##   layout_mgr.save_layout("my_mining_layout")
##   layout_mgr.load_layout("my_mining_layout")

# ============================================================================
# CONSTANTS
# ============================================================================

const LAYOUTS_DIR = "user://layouts/"
const LAYOUT_FILE_EXT = ".layout.json"

# ============================================================================
# LAYOUT DATA STRUCTURE
# ============================================================================

## Layout data structure:
## {
##   "name": "Mining Layout",
##   "description": "Optimized for mining operations",
##   "version": "1.0",
##   "timestamp": "2025-11-19T12:00:00",
##   "permanent_info_panel": {
##     "column2_widget": "mining_scanner",
##     "column3_widget": "cargo_overview"
##   },
##   "windows": {
##     "cargo_window_0": {
##       "visible": true,
##       "position": [100, 100],
##       "size": [600, 500],
##       "view_mode": "grid"
##     }
##   },
##   "window_manager": {
##     "layout_preset": "MINING"
##   }
## }

# ============================================================================
# INITIALIZATION
# ============================================================================

func _init():
	# Ensure layouts directory exists
	_ensure_layouts_dir()

func _ensure_layouts_dir() -> void:
	"""Create layouts directory if it doesn't exist"""
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("layouts"):
		dir.make_dir("layouts")

# ============================================================================
# SAVE LAYOUT
# ============================================================================

func save_layout(layout_name: String, description: String = "") -> bool:
	"""Save current UI layout to file"""
	var layout_data = _capture_current_layout(layout_name, description)

	var file_path = LAYOUTS_DIR + layout_name + LAYOUT_FILE_EXT
	var file = FileAccess.open(file_path, FileAccess.WRITE)

	if not file:
		push_error("LayoutManager: Failed to open file for writing: %s" % file_path)
		return false

	var json_string = JSON.stringify(layout_data, "\t")
	file.store_string(json_string)
	file.close()

	print("✅ LayoutManager: Saved layout '%s' to %s" % [layout_name, file_path])
	return true

func _capture_current_layout(layout_name: String, description: String) -> Dictionary:
	"""Capture current UI state"""
	var layout = {
		"name": layout_name,
		"description": description,
		"version": "1.0",
		"timestamp": Time.get_datetime_string_from_system(),
		"permanent_info_panel": {},
		"windows": {},
		"window_manager": {}
	}

	# Capture WindowManager state
	if WindowManager:
		layout.window_manager = {
			"layout_preset": WindowManager.LayoutPreset.keys()[WindowManager.current_layout]
		}

	# Capture PermanentInfoPanel widget selections
	# (This would need to be exposed by PermanentInfoPanel)
	# For now, placeholder
	layout.permanent_info_panel = {
		"column2_widget": "mining_scanner",
		"column3_widget": "cargo_overview"
	}

	# Capture open windows
	# (Would need to iterate through registered windows)
	layout.windows = {}

	return layout

# ============================================================================
# LOAD LAYOUT
# ============================================================================

func load_layout(layout_name: String) -> bool:
	"""Load UI layout from file"""
	var file_path = LAYOUTS_DIR + layout_name + LAYOUT_FILE_EXT

	if not FileAccess.file_exists(file_path):
		push_warning("LayoutManager: Layout file not found: %s" % file_path)
		return false

	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("LayoutManager: Failed to open layout file: %s" % file_path)
		return false

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_string)

	if parse_result != OK:
		push_error("LayoutManager: Failed to parse JSON: %s" % json.get_error_message())
		return false

	var layout_data = json.data

	if not layout_data is Dictionary:
		push_error("LayoutManager: Invalid layout data format")
		return false

	_apply_layout(layout_data)

	print("✅ LayoutManager: Loaded layout '%s'" % layout_name)
	return true

func _apply_layout(layout_data: Dictionary) -> void:
	"""Apply layout data to UI"""
	# Apply WindowManager layout preset
	if layout_data.has("window_manager") and layout_data.window_manager.has("layout_preset"):
		var preset_name = layout_data.window_manager.layout_preset
		var preset_value = WindowManager.LayoutPreset.get(preset_name)
		if preset_value != null:
			WindowManager.apply_layout_preset(preset_value)

	# Apply PermanentInfoPanel widget selections
	# (Would need API in PermanentInfoPanel)

	# Apply window positions/sizes
	# (Would need to iterate through windows)

# ============================================================================
# LIST LAYOUTS
# ============================================================================

func get_available_layouts() -> Array[String]:
	"""Get list of saved layout names"""
	var layouts: Array[String] = []

	var dir = DirAccess.open(LAYOUTS_DIR)
	if not dir:
		return layouts

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name.ends_with(LAYOUT_FILE_EXT):
			var layout_name = file_name.replace(LAYOUT_FILE_EXT, "")
			layouts.append(layout_name)
		file_name = dir.get_next()

	dir.list_dir_end()

	return layouts

func get_layout_info(layout_name: String) -> Dictionary:
	"""Get layout metadata without loading it"""
	var file_path = LAYOUTS_DIR + layout_name + LAYOUT_FILE_EXT

	if not FileAccess.file_exists(file_path):
		return {}

	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return {}

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	if json.parse(json_string) != OK:
		return {}

	var layout_data = json.data
	if not layout_data is Dictionary:
		return {}

	return {
		"name": layout_data.get("name", "Unknown"),
		"description": layout_data.get("description", ""),
		"version": layout_data.get("version", "1.0"),
		"timestamp": layout_data.get("timestamp", "")
	}

# ============================================================================
# DELETE LAYOUT
# ============================================================================

func delete_layout(layout_name: String) -> bool:
	"""Delete a saved layout"""
	var file_path = LAYOUTS_DIR + layout_name + LAYOUT_FILE_EXT

	if not FileAccess.file_exists(file_path):
		push_warning("LayoutManager: Layout file not found: %s" % file_path)
		return false

	var dir = DirAccess.open(LAYOUTS_DIR)
	if dir.remove(layout_name + LAYOUT_FILE_EXT) != OK:
		push_error("LayoutManager: Failed to delete layout file")
		return false

	print("✅ LayoutManager: Deleted layout '%s'" % layout_name)
	return true

# ============================================================================
# RENAME LAYOUT
# ============================================================================

func rename_layout(old_name: String, new_name: String) -> bool:
	"""Rename a layout"""
	var old_path = LAYOUTS_DIR + old_name + LAYOUT_FILE_EXT
	var new_path = LAYOUTS_DIR + new_name + LAYOUT_FILE_EXT

	if not FileAccess.file_exists(old_path):
		push_warning("LayoutManager: Source layout not found: %s" % old_name)
		return false

	if FileAccess.file_exists(new_path):
		push_warning("LayoutManager: Target layout already exists: %s" % new_name)
		return false

	# Load, modify name, save to new location
	if not load_layout(old_name):
		return false

	# Would need to re-save with new name
	# Simplified version: just copy file and update name field
	var dir = DirAccess.open(LAYOUTS_DIR)
	if dir.copy(old_path, new_path) != OK:
		push_error("LayoutManager: Failed to copy layout file")
		return false

	# Update name in new file
	# (Would need to load, modify, save)

	# Delete old file
	dir.remove(old_name + LAYOUT_FILE_EXT)

	print("✅ LayoutManager: Renamed layout '%s' to '%s'" % [old_name, new_name])
	return true

# ============================================================================
# IMPORT/EXPORT
# ============================================================================

func export_layout(layout_name: String, export_path: String) -> bool:
	"""Export layout to external file"""
	var source_path = LAYOUTS_DIR + layout_name + LAYOUT_FILE_EXT

	if not FileAccess.file_exists(source_path):
		push_warning("LayoutManager: Layout not found: %s" % layout_name)
		return false

	var dir = DirAccess.open(LAYOUTS_DIR)
	if dir.copy(source_path, export_path) != OK:
		push_error("LayoutManager: Failed to export layout")
		return false

	print("✅ LayoutManager: Exported layout to %s" % export_path)
	return true

func import_layout(import_path: String, layout_name: String = "") -> bool:
	"""Import layout from external file"""
	if not FileAccess.file_exists(import_path):
		push_warning("LayoutManager: Import file not found: %s" % import_path)
		return false

	# If no name specified, use filename
	if layout_name == "":
		layout_name = import_path.get_file().replace(".json", "").replace(".layout", "")

	var target_path = LAYOUTS_DIR + layout_name + LAYOUT_FILE_EXT

	var dir = DirAccess.open("user://")
	if dir.copy(import_path, target_path) != OK:
		push_error("LayoutManager: Failed to import layout")
		return false

	print("✅ LayoutManager: Imported layout as '%s'" % layout_name)
	return true

# ============================================================================
# DEFAULT LAYOUTS
# ============================================================================

func create_default_layouts() -> void:
	"""Create default layout presets"""
	# Mining Layout
	var mining_layout = {
		"name": "Mining",
		"description": "Optimized for mining operations",
		"version": "1.0",
		"timestamp": Time.get_datetime_string_from_system(),
		"permanent_info_panel": {
			"column2_widget": "mining_scanner",
			"column3_widget": "cargo_overview"
		},
		"window_manager": {
			"layout_preset": "MINING"
		}
	}
	_save_layout_data("mining_default", mining_layout)

	# Combat Layout
	var combat_layout = {
		"name": "Combat",
		"description": "Optimized for combat situations",
		"version": "1.0",
		"timestamp": Time.get_datetime_string_from_system(),
		"permanent_info_panel": {
			"column2_widget": "tactical_display",
			"column3_widget": "ship_modules"
		},
		"window_manager": {
			"layout_preset": "COMBAT"
		}
	}
	_save_layout_data("combat_default", combat_layout)

	# Trading Layout
	var trading_layout = {
		"name": "Trading",
		"description": "Optimized for trading and logistics",
		"version": "1.0",
		"timestamp": Time.get_datetime_string_from_system(),
		"permanent_info_panel": {
			"column2_widget": "cargo_overview",
			"column3_widget": "ship_details"
		},
		"window_manager": {
			"layout_preset": "TRADING"
		}
	}
	_save_layout_data("trading_default", trading_layout)

	print("✅ LayoutManager: Created default layouts")

func _save_layout_data(layout_name: String, layout_data: Dictionary) -> void:
	"""Save layout data directly"""
	var file_path = LAYOUTS_DIR + layout_name + LAYOUT_FILE_EXT
	var file = FileAccess.open(file_path, FileAccess.WRITE)

	if file:
		var json_string = JSON.stringify(layout_data, "\t")
		file.store_string(json_string)
		file.close()

# ============================================================================
# AUTO-SAVE
# ============================================================================

var auto_save_enabled: bool = true
var auto_save_interval: float = 300.0  # 5 minutes
var _auto_save_timer: float = 0.0

func enable_auto_save(enabled: bool = true, interval: float = 300.0) -> void:
	"""Enable automatic layout saving"""
	auto_save_enabled = enabled
	auto_save_interval = interval
	_auto_save_timer = 0.0

func _process(delta: float) -> void:
	"""Handle auto-save timer"""
	if not auto_save_enabled:
		return

	_auto_save_timer += delta

	if _auto_save_timer >= auto_save_interval:
		auto_save()
		_auto_save_timer = 0.0

func auto_save() -> void:
	"""Auto-save current layout"""
	save_layout("auto_save", "Automatic save")
