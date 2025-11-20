# CLAUDE CODE IMPLEMENTIERUNGS-ANWEISUNGEN

**Projekt:** Space Game Database System  
**Ziel:** Editierbare TSV-Datenbank mit CRUD-Operationen  
**Technologie:** Godot 4.x + GDScript + TSV/JSON  

---

## ÜBERSICHT

Erstelle ein editierbares Datenbank-System für:
- 300 SHIP_MODULES (MOD_001 - MOD_300)
- 155 SHIPS (SHIP_001 - SHIP_155)

**Anforderungen:**
1. ✅ Import aus TSV-Dateien
2. ✅ Export nach TSV/JSON
3. ✅ CRUD-Operationen (Create, Read, Update, Delete)
4. ✅ In-Game Editor-UI
5. ✅ Validierung & Error-Handling
6. ✅ Backup-System

---

## DATEI-STRUKTUR

```
res://
├── data/
│   ├── modules/
│   │   ├── 09a_shields_armor.tsv
│   │   ├── 09b_engines_power.tsv
│   │   ├── 09c_cargo_sensors.tsv
│   │   ├── 09d_ecm_mining.tsv
│   │   ├── 09e_command_medical.tsv
│   │   └── 09f_utility_station.tsv
│   ├── ships/
│   │   ├── 10a_frigates_destroyers.tsv
│   │   ├── 10b_cruisers_battlecruisers.tsv
│   │   ├── 10c_battleships_carriers.tsv
│   │   ├── 10d_dreadnoughts_titans.tsv
│   │   └── 10e_industrial_special_civilian.tsv
│   └── backups/
│       └── [auto-generated timestamps]
├── scripts/
│   ├── autoload/
│   │   ├── database_manager.gd
│   │   ├── module_data.gd
│   │   └── ship_data.gd
│   ├── database/
│   │   ├── tsv_parser.gd
│   │   ├── validator.gd
│   │   └── backup_manager.gd
│   └── ui/
│       ├── database_editor.gd
│       └── entry_form.gd
└── scenes/
    └── ui/
        ├── database_editor.tscn
        └── entry_form.tscn
```

---

## TEIL 1: TSV PARSER

### tsv_parser.gd

```gdscript
# res://scripts/database/tsv_parser.gd
class_name TSVParser
extends RefCounted

const SEPARATOR = "\t"

# Parse TSV-Datei → Dictionary Array
static func parse_file(file_path: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	
	if not FileAccess.file_exists(file_path):
		push_error("TSV file not found: " + file_path)
		return result
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: " + file_path)
		return result
	
	# Read header
	var header_line = file.get_line()
	var headers = header_line.split(SEPARATOR)
	
	# Read data lines
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line.is_empty():
			continue
		
		var values = line.split(SEPARATOR)
		var entry = {}
		
		for i in range(min(headers.size(), values.size())):
			var key = headers[i].strip_edges()
			var value = values[i].strip_edges()
			entry[key] = _convert_value(value)
		
		result.append(entry)
	
	file.close()
	return result

# Konvertiere String → richtiger Typ
static func _convert_value(value: String):
	if value.is_empty():
		return null
	
	# Try integer
	if value.is_valid_int():
		return value.to_int()
	
	# Try float
	if value.is_valid_float():
		return value.to_float()
	
	# Return as string
	return value

# Write Dictionary Array → TSV
static func write_file(file_path: String, data: Array[Dictionary], headers: Array) -> bool:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file for writing: " + file_path)
		return false
	
	# Write header
	file.store_line(SEPARATOR.join(headers))
	
	# Write data
	for entry in data:
		var row_values = []
		for header in headers:
			var value = entry.get(header, "")
			row_values.append(str(value))
		file.store_line(SEPARATOR.join(row_values))
	
	file.close()
	return true

# Export to JSON
static func export_to_json(data: Array[Dictionary], json_path: String) -> bool:
	var file = FileAccess.open(json_path, FileAccess.WRITE)
	if file == null:
		return false
	
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	return true
```

---

## TEIL 2: DATABASE MANAGER (AUTOLOAD)

### database_manager.gd

```gdscript
# res://scripts/autoload/database_manager.gd
extends Node

# Data storage
var modules: Array[Dictionary] = []
var ships: Array[Dictionary] = []

# Lookup caches
var module_lookup: Dictionary = {}
var ship_lookup: Dictionary = {}

# Headers for TSV export
const MODULE_HEADERS = [
	"DATABASE", "ID", "NAME", "TIER", "CATEGORY", "SIZE", "SUBCATEGORY",
	"MASS_KG", "VOLUME_M3", "BASE_PRICE", "PRODUCTION_TIME_SEC",
	"INPUT_1", "INPUT_1_QTY", "INPUT_2", "INPUT_2_QTY", 
	"INPUT_3", "INPUT_3_QTY", "SPECIAL_NOTES"
]

const SHIP_HEADERS = [
	"DATABASE", "ID", "NAME", "TIER", "CATEGORY", "SIZE", "SUBCATEGORY",
	"MASS_KG", "VOLUME_M3", "BASE_PRICE", "PRODUCTION_TIME_SEC",
	"INPUT_1", "INPUT_1_QTY", "INPUT_2", "INPUT_2_QTY", 
	"INPUT_3", "INPUT_3_QTY", "SPECIAL_NOTES"
]

signal data_loaded
signal data_saved
signal data_changed

func _ready():
	load_all_data()

# ========== LOAD ==========

func load_all_data():
	load_modules()
	load_ships()
	rebuild_caches()
	data_loaded.emit()

func load_modules():
	modules.clear()
	
	var module_files = [
		"res://data/modules/09a_shields_armor.tsv",
		"res://data/modules/09b_engines_power.tsv",
		"res://data/modules/09c_cargo_sensors.tsv",
		"res://data/modules/09d_ecm_mining.tsv",
		"res://data/modules/09e_command_medical.tsv",
		"res://data/modules/09f_utility_station.tsv"
	]
	
	for file_path in module_files:
		var entries = TSVParser.parse_file(file_path)
		modules.append_array(entries)
	
	print("Loaded %d modules" % modules.size())

func load_ships():
	ships.clear()
	
	var ship_files = [
		"res://data/ships/10a_frigates_destroyers.tsv",
		"res://data/ships/10b_cruisers_battlecruisers.tsv",
		"res://data/ships/10c_battleships_carriers.tsv",
		"res://data/ships/10d_dreadnoughts_titans.tsv",
		"res://data/ships/10e_industrial_special_civilian.tsv"
	]
	
	for file_path in ship_files:
		var entries = TSVParser.parse_file(file_path)
		ships.append_array(entries)
	
	print("Loaded %d ships" % ships.size())

func rebuild_caches():
	module_lookup.clear()
	ship_lookup.clear()
	
	for module in modules:
		var id = module.get("ID", "")
		if not id.is_empty():
			module_lookup[id] = module
	
	for ship in ships:
		var id = ship.get("ID", "")
		if not id.is_empty():
			ship_lookup[id] = ship

# ========== SAVE ==========

func save_all_data():
	save_modules()
	save_ships()
	create_backup()
	data_saved.emit()

func save_modules():
	# Group by category for separate files
	var shields_armor = []
	var engines_power = []
	var cargo_sensors = []
	var ecm_mining = []
	var command_medical = []
	var utility_station = []
	
	for module in modules:
		var id = module.get("ID", "")
		var num = int(id.replace("MOD_", ""))
		
		if num <= 50:
			shields_armor.append(module)
		elif num <= 100:
			engines_power.append(module)
		elif num <= 150:
			cargo_sensors.append(module)
		elif num <= 200:
			ecm_mining.append(module)
		elif num <= 250:
			command_medical.append(module)
		else:
			utility_station.append(module)
	
	TSVParser.write_file("res://data/modules/09a_shields_armor.tsv", shields_armor, MODULE_HEADERS)
	TSVParser.write_file("res://data/modules/09b_engines_power.tsv", engines_power, MODULE_HEADERS)
	TSVParser.write_file("res://data/modules/09c_cargo_sensors.tsv", cargo_sensors, MODULE_HEADERS)
	TSVParser.write_file("res://data/modules/09d_ecm_mining.tsv", ecm_mining, MODULE_HEADERS)
	TSVParser.write_file("res://data/modules/09e_command_medical.tsv", command_medical, MODULE_HEADERS)
	TSVParser.write_file("res://data/modules/09f_utility_station.tsv", utility_station, MODULE_HEADERS)

func save_ships():
	# Group by category
	var frigates_destroyers = []
	var cruisers_battlecruisers = []
	var battleships_carriers = []
	var dreadnoughts_titans = []
	var industrial_special_civilian = []
	
	for ship in ships:
		var id = ship.get("ID", "")
		var num = int(id.replace("SHIP_", ""))
		
		if num <= 40:
			frigates_destroyers.append(ship)
		elif num <= 75:
			cruisers_battlecruisers.append(ship)
		elif num <= 102:
			battleships_carriers.append(ship)
		elif num <= 120:
			dreadnoughts_titans.append(ship)
		else:
			industrial_special_civilian.append(ship)
	
	TSVParser.write_file("res://data/ships/10a_frigates_destroyers.tsv", frigates_destroyers, SHIP_HEADERS)
	TSVParser.write_file("res://data/ships/10b_cruisers_battlecruisers.tsv", cruisers_battlecruisers, SHIP_HEADERS)
	TSVParser.write_file("res://data/ships/10c_battleships_carriers.tsv", battleships_carriers, SHIP_HEADERS)
	TSVParser.write_file("res://data/ships/10d_dreadnoughts_titans.tsv", dreadnoughts_titans, SHIP_HEADERS)
	TSVParser.write_file("res://data/ships/10e_industrial_special_civilian.tsv", industrial_special_civilian, SHIP_HEADERS)

# ========== CRUD OPERATIONS ==========

# CREATE
func add_module(data: Dictionary) -> bool:
	if not Validator.validate_module(data):
		return false
	
	modules.append(data)
	module_lookup[data["ID"]] = data
	data_changed.emit()
	return true

func add_ship(data: Dictionary) -> bool:
	if not Validator.validate_ship(data):
		return false
	
	ships.append(data)
	ship_lookup[data["ID"]] = data
	data_changed.emit()
	return true

# READ
func get_module(id: String) -> Dictionary:
	return module_lookup.get(id, {})

func get_ship(id: String) -> Dictionary:
	return ship_lookup.get(id, {})

func get_modules_by_category(category: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for module in modules:
		if module.get("CATEGORY", "") == category:
			result.append(module)
	return result

func get_ships_by_category(category: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for ship in ships:
		if ship.get("CATEGORY", "") == category:
			result.append(ship)
	return result

# UPDATE
func update_module(id: String, new_data: Dictionary) -> bool:
	if not module_lookup.has(id):
		return false
	
	if not Validator.validate_module(new_data):
		return false
	
	var index = modules.find(module_lookup[id])
	if index >= 0:
		modules[index] = new_data
		module_lookup[id] = new_data
		data_changed.emit()
		return true
	
	return false

func update_ship(id: String, new_data: Dictionary) -> bool:
	if not ship_lookup.has(id):
		return false
	
	if not Validator.validate_ship(new_data):
		return false
	
	var index = ships.find(ship_lookup[id])
	if index >= 0:
		ships[index] = new_data
		ship_lookup[id] = new_data
		data_changed.emit()
		return true
	
	return false

# DELETE
func delete_module(id: String) -> bool:
	if not module_lookup.has(id):
		return false
	
	var module = module_lookup[id]
	modules.erase(module)
	module_lookup.erase(id)
	data_changed.emit()
	return true

func delete_ship(id: String) -> bool:
	if not ship_lookup.has(id):
		return false
	
	var ship = ship_lookup[id]
	ships.erase(ship)
	ship_lookup.erase(id)
	data_changed.emit()
	return true

# ========== BACKUP ==========

func create_backup():
	var timestamp = Time.get_datetime_string_from_system().replace(":", "-")
	var backup_dir = "res://data/backups/" + timestamp + "/"
	
	DirAccess.make_dir_recursive_absolute(backup_dir + "modules")
	DirAccess.make_dir_recursive_absolute(backup_dir + "ships")
	
	# Export to JSON for easy backup
	TSVParser.export_to_json(modules, backup_dir + "modules/all_modules.json")
	TSVParser.export_to_json(ships, backup_dir + "ships/all_ships.json")
	
	print("Backup created: " + backup_dir)
```

---

## TEIL 3: VALIDATOR

### validator.gd

```gdscript
# res://scripts/database/validator.gd
class_name Validator
extends RefCounted

# Required fields
const REQUIRED_MODULE_FIELDS = ["ID", "NAME", "TIER", "CATEGORY", "SIZE", "MASS_KG", "VOLUME_M3", "BASE_PRICE"]
const REQUIRED_SHIP_FIELDS = ["ID", "NAME", "TIER", "CATEGORY", "SIZE", "MASS_KG", "VOLUME_M3", "BASE_PRICE"]

# Valid tiers
const VALID_TIERS = [1, 2, 3, 4, 5]

# Valid sizes
const VALID_SIZES = ["S", "M", "L", "XL", "Station"]

static func validate_module(data: Dictionary) -> bool:
	# Check required fields
	for field in REQUIRED_MODULE_FIELDS:
		if not data.has(field):
			push_error("Missing required field: " + field)
			return false
	
	# Validate ID format
	var id = data["ID"]
	if not id is String or not id.begins_with("MOD_"):
		push_error("Invalid module ID format: " + str(id))
		return false
	
	# Validate tier
	var tier = data["TIER"]
	if not tier in VALID_TIERS:
		push_error("Invalid tier: " + str(tier))
		return false
	
	# Validate size
	var size = data["SIZE"]
	if not size in VALID_SIZES:
		push_error("Invalid size: " + str(size))
		return false
	
	# Validate numeric fields
	if data["MASS_KG"] <= 0:
		push_error("Mass must be positive")
		return false
	
	if data["VOLUME_M3"] <= 0:
		push_error("Volume must be positive")
		return false
	
	if data["BASE_PRICE"] < 0:
		push_error("Price cannot be negative")
		return false
	
	return true

static func validate_ship(data: Dictionary) -> bool:
	# Check required fields
	for field in REQUIRED_SHIP_FIELDS:
		if not data.has(field):
			push_error("Missing required field: " + field)
			return false
	
	# Validate ID format
	var id = data["ID"]
	if not id is String or not id.begins_with("SHIP_"):
		push_error("Invalid ship ID format: " + str(id))
		return false
	
	# Validate tier
	var tier = data["TIER"]
	if not tier in VALID_TIERS:
		push_error("Invalid tier: " + str(tier))
		return false
	
	# Validate size
	var size = data["SIZE"]
	if not size in VALID_SIZES:
		push_error("Invalid size: " + str(size))
		return false
	
	# Validate numeric fields
	if data["MASS_KG"] <= 0:
		push_error("Mass must be positive")
		return false
	
	if data["VOLUME_M3"] <= 0:
		push_error("Volume must be positive")
		return false
	
	if data["BASE_PRICE"] < 0:
		push_error("Price cannot be negative")
		return false
	
	return true
```

---

## TEIL 4: EDITOR UI (OPTIONAL)

### database_editor.gd (Basic Version)

```gdscript
# res://scripts/ui/database_editor.gd
extends Control

@onready var category_tabs = $VBoxContainer/TabContainer
@onready var entry_list = $VBoxContainer/HSplitContainer/ItemList
@onready var edit_panel = $VBoxContainer/HSplitContainer/EditPanel

var current_category = "Shields"
var current_entries: Array[Dictionary] = []
var selected_entry: Dictionary = {}

func _ready():
	DatabaseManager.data_loaded.connect(_on_data_loaded)
	DatabaseManager.data_changed.connect(_on_data_changed)
	
	category_tabs.tab_changed.connect(_on_category_changed)
	entry_list.item_selected.connect(_on_entry_selected)
	
	refresh_list()

func _on_data_loaded():
	refresh_list()

func _on_data_changed():
	refresh_list()

func _on_category_changed(tab_index: int):
	match tab_index:
		0: current_category = "Shield"
		1: current_category = "Armor"
		2: current_category = "Engines"
		3: current_category = "Power"
		# ... etc
	
	refresh_list()

func refresh_list():
	entry_list.clear()
	current_entries = DatabaseManager.get_modules_by_category(current_category)
	
	for entry in current_entries:
		var display_text = "%s - %s (T%d)" % [entry.get("ID", ""), entry.get("NAME", ""), entry.get("TIER", 0)]
		entry_list.add_item(display_text)

func _on_entry_selected(index: int):
	if index >= 0 and index < current_entries.size():
		selected_entry = current_entries[index]
		display_entry(selected_entry)

func display_entry(entry: Dictionary):
	# Update edit panel with entry data
	for key in entry.keys():
		var control = edit_panel.get_node_or_null(key)
		if control:
			if control is LineEdit:
				control.text = str(entry[key])
			elif control is SpinBox:
				control.value = entry[key]

func save_current_entry():
	# Collect data from edit panel
	var new_data = {}
	for key in selected_entry.keys():
		var control = edit_panel.get_node_or_null(key)
		if control:
			if control is LineEdit:
				new_data[key] = control.text
			elif control is SpinBox:
				new_data[key] = control.value
	
	# Update database
	var id = selected_entry.get("ID", "")
	if DatabaseManager.update_module(id, new_data):
		print("Entry updated successfully")
	else:
		print("Failed to update entry")

func save_all_to_disk():
	DatabaseManager.save_all_data()
	print("All data saved to disk")
```

---

## TEIL 5: PROJEKTEINRICHTUNG

### project.godot Autoload Konfiguration

```ini
[autoload]

DatabaseManager="*res://scripts/autoload/database_manager.gd"
TSVParser="*res://scripts/database/tsv_parser.gd"
Validator="*res://scripts/database/validator.gd"
```

---

## VERWENDUNGS-BEISPIELE

### Beispiel 1: Modul laden

```gdscript
# In beliebigem Script
func equip_shield():
	var shield_data = DatabaseManager.get_module("MOD_001")
	if shield_data.is_empty():
		print("Shield not found!")
		return
	
	print("Equipping: " + shield_data["NAME"])
	print("Mass: %d kg" % shield_data["MASS_KG"])
	print("Price: %d Cr" % shield_data["BASE_PRICE"])
```

### Beispiel 2: Schiff erstellen

```gdscript
func spawn_ship():
	var ship_data = DatabaseManager.get_ship("SHIP_001")
	if ship_data.is_empty():
		return
	
	var ship_scene = preload("res://scenes/ships/base_ship.tscn")
	var ship = ship_scene.instantiate()
	
	ship.mass = ship_data["MASS_KG"]
	ship.max_hp = ship_data["BASE_PRICE"] / 100  # Example
	ship.ship_name = ship_data["NAME"]
	
	add_child(ship)
```

### Beispiel 3: Filter nach Tier

```gdscript
func get_tier3_shields() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var all_shields = DatabaseManager.get_modules_by_category("Shield")
	
	for shield in all_shields:
		if shield.get("TIER", 0) == 3:
			result.append(shield)
	
	return result
```

### Beispiel 4: Produktionskosten berechnen

```gdscript
func calculate_production_cost(item_id: String) -> int:
	var item = DatabaseManager.get_module(item_id)
	if item.is_empty():
		item = DatabaseManager.get_ship(item_id)
	
	if item.is_empty():
		return 0
	
	var total_cost = 0
	
	# Material 1
	var mat1_id = item.get("INPUT_1", "")
	var mat1_qty = item.get("INPUT_1_QTY", 0)
	if not mat1_id.is_empty():
		var mat1_price = get_material_price(mat1_id)
		total_cost += mat1_price * mat1_qty
	
	# Material 2
	var mat2_id = item.get("INPUT_2", "")
	var mat2_qty = item.get("INPUT_2_QTY", 0)
	if not mat2_id.is_empty():
		var mat2_price = get_material_price(mat2_id)
		total_cost += mat2_price * mat2_qty
	
	# Material 3
	var mat3_id = item.get("INPUT_3", "")
	var mat3_qty = item.get("INPUT_3_QTY", 0)
	if not mat3_id.is_empty():
		var mat3_price = get_material_price(mat3_id)
		total_cost += mat3_price * mat3_qty
	
	return total_cost
```

---

## NÄCHSTE SCHRITTE

### Phase 1: Basis-System (Priorität HOCH)
1. ✅ TSV Parser implementieren
2. ✅ DatabaseManager Autoload erstellen
3. ✅ Validator implementieren
4. ✅ Load/Save Funktionalität testen
5. ✅ CRUD-Operationen testen

### Phase 2: UI-Editor (Priorität MITTEL)
1. Database Editor Scene erstellen
2. Entry Form mit allen Feldern
3. Search & Filter System
4. Batch-Edit Funktionalität

### Phase 3: Erweiterte Features (Priorität NIEDRIG)
1. Import/Export zu anderen Formaten (CSV, XML)
2. Versionshistorie (Git-Integration)
3. Diff-Tool für Änderungen
4. Bulk-Operations (z.B. alle Tier 3 Module um 10% teurer)

---

## TESTING CHECKLISTE

```gdscript
# res://tests/database_tests.gd
extends Node

func test_all():
	test_load()
	test_create()
	test_read()
	test_update()
	test_delete()
	test_validation()

func test_load():
	DatabaseManager.load_all_data()
	assert(DatabaseManager.modules.size() == 300, "Should load 300 modules")
	assert(DatabaseManager.ships.size() == 155, "Should load 155 ships")
	print("✅ Load test passed")

func test_create():
	var new_module = {
		"DATABASE": "MODULE",
		"ID": "MOD_TEST",
		"NAME": "Test Module",
		"TIER": 1,
		"CATEGORY": "Shield",
		"SIZE": "S",
		"MASS_KG": 100,
		"VOLUME_M3": 1.0,
		"BASE_PRICE": 5000
	}
	
	var success = DatabaseManager.add_module(new_module)
	assert(success, "Should create new module")
	print("✅ Create test passed")

func test_read():
	var module = DatabaseManager.get_module("MOD_001")
	assert(not module.is_empty(), "Should find MOD_001")
	assert(module["NAME"] == "Basic Shield Generator", "Should have correct name")
	print("✅ Read test passed")

func test_update():
	var updated = {
		"ID": "MOD_TEST",
		"NAME": "Updated Test Module",
		"TIER": 2,
		"CATEGORY": "Shield",
		"SIZE": "M",
		"MASS_KG": 200,
		"VOLUME_M3": 2.0,
		"BASE_PRICE": 10000
	}
	
	var success = DatabaseManager.update_module("MOD_TEST", updated)
	assert(success, "Should update module")
	
	var module = DatabaseManager.get_module("MOD_TEST")
	assert(module["TIER"] == 2, "Should have updated tier")
	print("✅ Update test passed")

func test_delete():
	var success = DatabaseManager.delete_module("MOD_TEST")
	assert(success, "Should delete module")
	
	var module = DatabaseManager.get_module("MOD_TEST")
	assert(module.is_empty(), "Should not find deleted module")
	print("✅ Delete test passed")

func test_validation():
	var invalid = {
		"ID": "INVALID",
		"NAME": "Test"
	}
	
	assert(not Validator.validate_module(invalid), "Should reject invalid module")
	print("✅ Validation test passed")
```

---

## BACKUP & RECOVERY

### Automatisches Backup

```gdscript
# Backup jeden Tag um 3 Uhr nachts
func _ready():
	var timer = Timer.new()
	timer.wait_time = 86400  # 24 Stunden
	timer.autostart = true
	timer.timeout.connect(_daily_backup)
	add_child(timer)

func _daily_backup():
	var hour = Time.get_time_dict_from_system()["hour"]
	if hour == 3:
		DatabaseManager.create_backup()
```

### Recovery aus Backup

```gdscript
func restore_backup(backup_dir: String):
	var modules_path = backup_dir + "modules/all_modules.json"
	var ships_path = backup_dir + "ships/all_ships.json"
	
	if FileAccess.file_exists(modules_path):
		var file = FileAccess.open(modules_path, FileAccess.READ)
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			DatabaseManager.modules = json.data
		file.close()
	
	if FileAccess.file_exists(ships_path):
		var file = FileAccess.open(ships_path, FileAccess.READ)
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			DatabaseManager.ships = json.data
		file.close()
	
	DatabaseManager.rebuild_caches()
	print("Backup restored from: " + backup_dir)
```

---

## PERFORMANCE-OPTIMIERUNG

### Caching-Strategie

```gdscript
# Cache für häufige Abfragen
var tier_cache: Dictionary = {}
var category_cache: Dictionary = {}

func get_modules_by_tier_cached(tier: int) -> Array[Dictionary]:
	if tier_cache.has(tier):
		return tier_cache[tier]
	
	var result: Array[Dictionary] = []
	for module in modules:
		if module.get("TIER", 0) == tier:
			result.append(module)
	
	tier_cache[tier] = result
	return result

func clear_caches():
	tier_cache.clear()
	category_cache.clear()
```

---

**ENDE DER ANWEISUNGEN**

**Status:** ✅ Implementierungs-Ready  
**Geschätzte Zeit:** 4-6 Stunden Entwicklung  
**Dependencies:** Godot 4.x, GDScript
