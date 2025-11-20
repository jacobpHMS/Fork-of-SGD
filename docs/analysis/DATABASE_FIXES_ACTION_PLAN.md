# 🔧 Database Consistency Fixes - Action Plan

**Erstellt:** 2025-11-19
**Basierend auf:** DATABASE_CONSISTENCY_REPORT.md, DEPENDENCIES.md
**Status:** ⚠️ IMMEDIATE ACTION REQUIRED

---

## 📋 EXECUTIVE SUMMARY

**Probleme:**
1. ❌ **45+ fehlende Item-Definitionen** - Items werden referenziert, existieren aber nicht
2. ❌ **Keine referenzielle Integrität** - Schiffe referenzieren nicht-existierende Waffen
3. ❌ **60+ fehlende Translations** - Neue Systeme haben keine deutschen Übersetzungen
4. ❌ **Inkonsistente Namensgebung** - Mix aus camelCase, snake_case
5. ❌ **Leerzeichen in IDs** - Einige IDs enthalten Leerzeichen (Fehleranfällig)

---

## 🎯 PRIORITÄT 1: CRITICAL FIXES (Diese Woche)

### 1.1 ItemDatabase.gd erstellen

**Problem:** 45+ Items werden referenziert, aber nirgends definiert

**Lösung:** Zentrale Item-Datenbank erstellen

```gdscript
# NEW FILE: scripts/ItemDatabase.gd
extends Node

## Central Item Database
## Defines all items in the game with consistent properties

# ============================================================================
# ITEM CATEGORIES
# ============================================================================

enum ItemCategory {
	ORE,           # Raw minable resources
	MINERAL,       # Refined minerals
	COMPONENT,     # Crafted components
	MODULE,        # Ship modules
	SHIP,          # Ships
	LIQUID,        # Liquid cargo
	GAS,           # Gas cargo
	HAZMAT,        # Hazardous materials
	AMMO,          # Ammunition
	BUILD          # Building materials
}

# ============================================================================
# ITEM DATA STRUCTURE
# ============================================================================

class ItemData:
	var id: String                   # Unique item ID (e.g., "ore_iron")
	var name: String                 # Display name
	var category: ItemCategory       # Item category
	var tier: int                    # Progression tier (0-5)
	var stack_size: int              # Max stack size
	var volume_per_unit: float       # m³ per unit
	var mass_per_unit: float         # kg per unit
	var base_price: float            # Base price in credits
	var description: String          # Item description
	var icon_path: String            # Path to icon
	var translation_key: String      # Translation key

	func _init(
		p_id: String,
		p_name: String,
		p_category: ItemCategory,
		p_tier: int = 0,
		p_stack_size: int = 1000,
		p_volume: float = 1.0,
		p_mass: float = 1.0,
		p_price: float = 10.0,
		p_desc: String = "",
		p_icon: String = "res://assets/icons/placeholder.png"
	):
		id = p_id
		name = p_name
		category = p_category
		tier = p_tier
		stack_size = p_stack_size
		volume_per_unit = p_volume
		mass_per_unit = p_mass
		base_price = p_price
		description = p_desc
		icon_path = p_icon
		translation_key = "item_" + p_id

# ============================================================================
# GLOBAL ITEM REGISTRY
# ============================================================================

var items: Dictionary = {}  # id -> ItemData

func _ready():
	_register_all_items()
	_validate_items()
	print("✅ ItemDatabase initialized: %d items registered" % items.size())

# ============================================================================
# ITEM REGISTRATION
# ============================================================================

func register_item(item: ItemData) -> void:
	if items.has(item.id):
		push_warning("Item '%s' already registered, overwriting" % item.id)

	items[item.id] = item

func get_item(item_id: String) -> ItemData:
	if not items.has(item_id):
		push_error("Item not found: %s" % item_id)
		return null

	return items[item_id]

func has_item(item_id: String) -> bool:
	return items.has(item_id)

# ============================================================================
# ITEM DATABASE (COMPLETE)
# ============================================================================

func _register_all_items():
	# ========================================================================
	# TIER 0: ORES (Minable Resources)
	# ========================================================================

	register_item(ItemData.new(
		"ore_iron", "Iron Ore", ItemCategory.ORE, 0,
		1000, 1.0, 7.87, 10, "Raw iron ore from asteroids"
	))

	register_item(ItemData.new(
		"ore_copper", "Copper Ore", ItemCategory.ORE, 0,
		1000, 1.0, 8.96, 15, "Raw copper ore with high conductivity"
	))

	register_item(ItemData.new(
		"ore_titanium", "Titanium Ore", ItemCategory.ORE, 0,
		1000, 1.0, 4.51, 50, "Lightweight yet strong titanium ore"
	))

	register_item(ItemData.new(
		"ore_gold", "Gold Ore", ItemCategory.ORE, 0,
		500, 1.0, 19.32, 200, "Precious gold ore for electronics"
	))

	register_item(ItemData.new(
		"ore_platinum", "Platinum Ore", ItemCategory.ORE, 0,
		500, 1.0, 21.45, 500, "Rare platinum ore for advanced tech"
	))

	register_item(ItemData.new(
		"ore_exotic", "Exotic Ore", ItemCategory.ORE, 0,
		100, 1.0, 50.0, 2000, "Extremely rare exotic material"
	))

	# ❗ NEUE ORES (waren vorher fehlend)
	register_item(ItemData.new(
		"ore_aluminum", "Aluminum Ore", ItemCategory.ORE, 0,
		1000, 1.0, 2.70, 20, "Lightweight aluminum ore"
	))

	register_item(ItemData.new(
		"ore_silicon", "Silicon Ore", ItemCategory.ORE, 0,
		1000, 1.0, 2.33, 30, "Silicon ore for electronics"
	))

	register_item(ItemData.new(
		"ore_uranium", "Uranium Ore", ItemCategory.ORE, 0,
		100, 1.0, 19.05, 1000, "Radioactive uranium ore (HAZMAT)"
	))

	# ========================================================================
	# TIER 1: MINERALS (Refined)
	# ========================================================================

	register_item(ItemData.new(
		"mineral_iron", "Iron", ItemCategory.MINERAL, 1,
		500, 0.8, 7.87, 20, "Refined iron"
	))

	register_item(ItemData.new(
		"mineral_copper", "Copper", ItemCategory.MINERAL, 1,
		500, 0.8, 8.96, 30, "Refined copper"
	))

	register_item(ItemData.new(
		"mineral_titanium", "Titanium", ItemCategory.MINERAL, 1,
		500, 0.8, 4.51, 100, "Refined titanium"
	))

	register_item(ItemData.new(
		"mineral_aluminum", "Aluminum", ItemCategory.MINERAL, 1,
		500, 0.8, 2.70, 40, "Refined aluminum"
	))

	register_item(ItemData.new(
		"mineral_silicon", "Silicon", ItemCategory.MINERAL, 1,
		500, 0.8, 2.33, 60, "Refined silicon"
	))

	# ========================================================================
	# TIER 2: PURE MINERALS
	# ========================================================================

	register_item(ItemData.new(
		"mineral_iron_pure", "Pure Iron", ItemCategory.MINERAL, 2,
		200, 0.5, 7.87, 50, "99.9% pure iron"
	))

	register_item(ItemData.new(
		"mineral_copper_pure", "Pure Copper", ItemCategory.MINERAL, 2,
		200, 0.5, 8.96, 80, "99.9% pure copper"
	))

	register_item(ItemData.new(
		"mineral_titanium_pure", "Pure Titanium", ItemCategory.MINERAL, 2,
		200, 0.5, 4.51, 250, "99.9% pure titanium"
	))

	register_item(ItemData.new(
		"mineral_platinum_pure", "Pure Platinum", ItemCategory.MINERAL, 2,
		100, 0.5, 21.45, 1200, "99.9% pure platinum"
	))

	register_item(ItemData.new(
		"mineral_silicon_pure", "Pure Silicon", ItemCategory.MINERAL, 2,
		200, 0.5, 2.33, 150, "99.9% pure silicon"
	))

	register_item(ItemData.new(
		"mineral_exotic_pure", "Pure Exotic Material", ItemCategory.MINERAL, 2,
		50, 0.5, 50.0, 5000, "Purified exotic material"
	))

	# ========================================================================
	# TIER 3: BASIC COMPONENTS
	# ========================================================================

	register_item(ItemData.new(
		"component_metal_plates", "Metal Plates", ItemCategory.COMPONENT, 3,
		500, 2.0, 15.0, 100, "Reinforced metal plates for construction"
	))

	register_item(ItemData.new(
		"component_wiring", "Electrical Wiring", ItemCategory.COMPONENT, 3,
		1000, 0.5, 2.0, 50, "High-grade electrical wiring"
	))

	register_item(ItemData.new(
		"component_circuit_board", "Circuit Board", ItemCategory.COMPONENT, 3,
		200, 1.0, 3.0, 200, "Advanced circuit board for electronics"
	))

	register_item(ItemData.new(
		"component_hydraulics", "Hydraulic System", ItemCategory.COMPONENT, 3,
		50, 10.0, 50.0, 800, "Hydraulic actuator system"
	))

	# ❗ NEUE COMPONENTS (waren vorher fehlend)
	register_item(ItemData.new(
		"component_battery", "Battery Pack", ItemCategory.COMPONENT, 3,
		100, 5.0, 20.0, 500, "Energy storage battery pack"
	))

	register_item(ItemData.new(
		"component_reactor_core", "Reactor Core", ItemCategory.COMPONENT, 3,
		10, 50.0, 500.0, 5000, "Fusion reactor core"
	))

	register_item(ItemData.new(
		"component_thruster", "Thruster Module", ItemCategory.COMPONENT, 3,
		20, 20.0, 100.0, 3000, "Ship propulsion thruster"
	))

	register_item(ItemData.new(
		"component_radar", "Radar System", ItemCategory.COMPONENT, 3,
		50, 8.0, 30.0, 1500, "Long-range detection radar"
	))

	register_item(ItemData.new(
		"component_computer", "Ship Computer", ItemCategory.COMPONENT, 3,
		20, 10.0, 40.0, 4000, "AI control computer"
	))

	register_item(ItemData.new(
		"component_armor_plate", "Armor Plating", ItemCategory.COMPONENT, 3,
		100, 15.0, 80.0, 1000, "Reinforced armor plating"
	))

	register_item(ItemData.new(
		"component_coolant_pump", "Coolant Pump", ItemCategory.COMPONENT, 3,
		50, 8.0, 25.0, 800, "Active cooling system"
	))

	register_item(ItemData.new(
		"component_fuel_cell", "Fuel Cell", ItemCategory.COMPONENT, 3,
		100, 5.0, 15.0, 600, "Hydrogen fuel cell"
	))

	register_item(ItemData.new(
		"component_sensor_array", "Sensor Array", ItemCategory.COMPONENT, 3,
		30, 12.0, 35.0, 2000, "Multi-spectrum sensor array"
	))

	# ========================================================================
	# TIER 4: COMPLEX COMPONENTS
	# ========================================================================

	register_item(ItemData.new(
		"component_compressor", "Cargo Compressor", ItemCategory.COMPONENT, 4,
		10, 50.0, 200.0, 10000, "Advanced cargo compression system"
	))

	register_item(ItemData.new(
		"component_quantum_core", "Quantum Core", ItemCategory.COMPONENT, 4,
		5, 100.0, 500.0, 50000, "Quantum computing core"
	))

	register_item(ItemData.new(
		"component_shield_emitter", "Shield Emitter", ItemCategory.COMPONENT, 4,
		10, 30.0, 120.0, 20000, "Energy shield emitter"
	))

	# ========================================================================
	# TIER 5: MODULES
	# ========================================================================

	register_item(ItemData.new(
		"module_mining_laser_t1", "Mining Laser T1", ItemCategory.MODULE, 5,
		1, 100.0, 500.0, 50000, "Basic mining laser module"
	))

	register_item(ItemData.new(
		"module_shield_t1", "Shield Generator T1", ItemCategory.MODULE, 5,
		1, 150.0, 800.0, 100000, "Basic shield generator"
	))

	# ❗ NEUE MODULES T2/T3 (waren vorher fehlend)
	register_item(ItemData.new(
		"module_mining_laser_t2", "Mining Laser T2", ItemCategory.MODULE, 5,
		1, 120.0, 600.0, 150000, "Advanced mining laser (+50% yield)"
	))

	register_item(ItemData.new(
		"module_mining_laser_t3", "Mining Laser T3", ItemCategory.MODULE, 5,
		1, 150.0, 750.0, 500000, "Elite mining laser (+100% yield)"
	))

	register_item(ItemData.new(
		"module_shield_t2", "Shield Generator T2", ItemCategory.MODULE, 5,
		1, 180.0, 1000.0, 300000, "Advanced shield (+75% capacity)"
	))

	register_item(ItemData.new(
		"module_shield_t3", "Shield Generator T3", ItemCategory.MODULE, 5,
		1, 220.0, 1300.0, 1000000, "Elite shield (+150% capacity)"
	))

	register_item(ItemData.new(
		"module_weapon_cannon_t1", "Cannon T1", ItemCategory.MODULE, 5,
		1, 200.0, 1500.0, 200000, "Basic ballistic cannon"
	))

	register_item(ItemData.new(
		"module_weapon_laser_t1", "Laser Weapon T1", ItemCategory.MODULE, 5,
		1, 180.0, 1200.0, 250000, "Basic laser weapon"
	))

	register_item(ItemData.new(
		"module_engine_t1", "Engine T1", ItemCategory.MODULE, 5,
		1, 500.0, 3000.0, 300000, "Basic engine module"
	))

	register_item(ItemData.new(
		"module_engine_t2", "Engine T2", ItemCategory.MODULE, 5,
		1, 600.0, 3500.0, 800000, "Advanced engine (+40% speed)"
	))

	register_item(ItemData.new(
		"module_cargo_expansion_t1", "Cargo Expansion T1", ItemCategory.MODULE, 5,
		1, 100.0, 400.0, 100000, "Cargo capacity +25%"
	))

	# ========================================================================
	# TIER 6: LIQUIDS
	# ========================================================================

	register_item(ItemData.new(
		"liquid_fuel", "Fuel", ItemCategory.LIQUID, 1,
		10000, 1.0, 0.8, 5, "Ship fuel (liquid hydrogen)"
	))

	register_item(ItemData.new(
		"liquid_coolant", "Coolant", ItemCategory.LIQUID, 1,
		5000, 1.0, 1.1, 8, "Cooling fluid for temperature regulation"
	))

	register_item(ItemData.new(
		"liquid_hydrogen", "Liquid Hydrogen", ItemCategory.LIQUID, 1,
		10000, 1.0, 0.07, 10, "Cryogenic liquid hydrogen"
	))

	# ========================================================================
	# TIER 7: GASES
	# ========================================================================

	register_item(ItemData.new(
		"gas_hydrogen", "Hydrogen Gas", ItemCategory.GAS, 1,
		10000, 1.0, 0.00009, 3, "Compressed hydrogen gas"
	))

	register_item(ItemData.new(
		"gas_oxygen", "Oxygen Gas", ItemCategory.GAS, 1,
		5000, 1.0, 0.0014, 5, "Breathable oxygen for life support"
	))

	register_item(ItemData.new(
		"gas_nitrogen", "Nitrogen Gas", ItemCategory.GAS, 1,
		10000, 1.0, 0.0012, 2, "Inert nitrogen gas"
	))

	# ========================================================================
	# TIER 8: HAZMAT
	# ========================================================================

	register_item(ItemData.new(
		"hazmat_uranium", "Enriched Uranium", ItemCategory.HAZMAT, 2,
		100, 1.0, 19.05, 5000, "Radioactive nuclear fuel (HAZMAT)"
	))

	register_item(ItemData.new(
		"hazmat_plutonium", "Plutonium", ItemCategory.HAZMAT, 3,
		50, 1.0, 19.84, 15000, "Highly radioactive plutonium (HAZMAT)"
	))

	register_item(ItemData.new(
		"hazmat_toxic_waste", "Toxic Waste", ItemCategory.HAZMAT, 1,
		1000, 1.0, 2.0, 1, "Toxic refinery byproduct (HAZMAT)"
	))

	# ========================================================================
	# TIER 9: FINAL ITEMS
	# ========================================================================

	register_item(ItemData.new(
		"ship_miner_small", "Small Mining Vessel", ItemCategory.SHIP, 6,
		1, 10000.0, 50000.0, 500000, "Basic mining ship hull"
	))

	register_item(ItemData.new(
		"ammo_ballistic_basic", "Ballistic Ammunition", ItemCategory.AMMO, 1,
		1000, 0.5, 5.0, 10, "Standard ballistic ammo"
	))

# ============================================================================
# VALIDATION
# ============================================================================

func _validate_items():
	"""Validate item database for consistency"""
	var errors = 0

	# Check for duplicate IDs
	var ids_seen = []
	for item_id in items.keys():
		if ids_seen.has(item_id):
			push_error("Duplicate item ID: %s" % item_id)
			errors += 1
		ids_seen.append(item_id)

	# Check for missing icons (placeholder is OK)
	for item in items.values():
		if not FileAccess.file_exists(item.icon_path):
			if item.icon_path != "res://assets/icons/placeholder.png":
				push_warning("Item '%s' icon not found: %s" % [item.id, item.icon_path])

	# Check for invalid values
	for item in items.values():
		if item.volume_per_unit <= 0:
			push_error("Item '%s' has invalid volume: %f" % [item.id, item.volume_per_unit])
			errors += 1

		if item.mass_per_unit <= 0:
			push_error("Item '%s' has invalid mass: %f" % [item.id, item.mass_per_unit])
			errors += 1

	if errors > 0:
		push_error("Item database validation failed with %d errors!" % errors)
	else:
		print("✅ Item database validation passed")
```

**Integration in project.godot:**
```ini
[autoload]
ItemDatabase="*res://scripts/ItemDatabase.gd"
```

---

### 1.2 Referenzielle Integrität prüfen

**Problem:** Schiffe referenzieren Waffen/Module, die nicht existieren

**Lösung:** Validation-System in GameData.gd

```gdscript
# ADD TO: scripts/GameData.gd

func _validate_database_references():
	"""Validate all database cross-references"""
	print("🔍 Validating database references...")

	var errors = 0

	# Check ship → weapon references
	for ship_id in _ships.keys():
		var ship = _ships[ship_id]

		# Check weapon references
		if ship.has("weapon_id"):
			if not _weapons.has(ship.weapon_id):
				push_error("Ship '%s' references missing weapon '%s'" % [ship_id, ship.weapon_id])
				errors += 1

		# Check module references
		if ship.has("modules"):
			for module_id in ship.modules:
				if not ItemDatabase.has_item(module_id):
					push_error("Ship '%s' references missing module '%s'" % [ship_id, module_id])
					errors += 1

	# Check crafting recipe → component references
	for recipe in _crafting_recipes:
		for input_id in recipe.inputs.keys():
			if not ItemDatabase.has_item(input_id):
				push_error("Recipe '%s' references missing component '%s'" % [recipe.id, input_id])
				errors += 1

		if not ItemDatabase.has_item(recipe.output_id):
			push_error("Recipe '%s' output missing: '%s'" % [recipe.id, recipe.output_id])
			errors += 1

	if errors > 0:
		push_error("❌ Database validation FAILED: %d errors found!" % errors)
	else:
		print("✅ Database validation PASSED")

	return errors == 0
```

---

## 🎯 PRIORITÄT 2: TRANSLATIONS (Nächste Woche)

### 2.1 Fehlende Translations hinzufügen

**Datei:** `translations/game_strings.csv`

**60+ neue Keys hinzufügen:**

```csv
keys,en,de

# Cargo System (fehlend)
cargo_pressurized,Pressurized,Druckbeaufschlagt
cargo_pressure_level,Pressure Level,Druckstufe
cargo_pressure_normal,Normal Pressure,Normaldruck
cargo_pressure_low,Low Pressure,Niederdruck
cargo_pressure_critical,CRITICAL PRESSURE,KRITISCHER DRUCK
cargo_pressure_failing,Pressure Failing,Druckabfall
cargo_emergency_vent,Emergency Vent,Not-Entlüftung
cargo_explosion,Cargo Explosion,Fracht-Explosion
cargo_type_general,General Cargo,Allgemeine Fracht
cargo_type_ore,Ore Cargo,Erz-Fracht
cargo_type_mineral,Mineral Cargo,Mineral-Fracht
cargo_type_liquid,Liquid Cargo,Flüssig-Fracht
cargo_type_gas,Gas Cargo,Gas-Fracht
cargo_type_ammo,Ammunition,Munition
cargo_type_build,Building Materials,Baumaterialien
cargo_type_components,Components,Komponenten
cargo_type_hazmat,Hazardous Materials,Gefahrstoffe
cargo_compression_basic,Basic Compression,Basis-Kompression
cargo_compression_advanced,Advanced Compression,Erweiterte Kompression
cargo_compression_elite,Elite Compression,Elite-Kompression

# Station System (fehlend)
station_size_small,Small Station,Kleine Station
station_size_medium,Medium Station,Mittlere Station
station_size_large,Large Station,Große Station
station_sockets,Sockets,Sockel
station_sockets_available,Available Sockets,Verfügbare Sockel
station_module_refinery,Refinery Module,Raffinerie-Modul
station_module_factory,Factory Module,Fabrik-Modul
station_module_shipyard,Shipyard Module,Werft-Modul
station_module_trading,Trading Module,Handels-Modul
station_module_military,Military Module,Militär-Modul
station_module_socket_expander,Socket Expander,Sockel-Erweiterer
station_deploy,Deploy Station,Station aufbauen
station_install_module,Install Module,Modul installieren
station_uninstall_module,Uninstall Module,Modul deinstallieren

# Item Names (neue Items)
item_ore_aluminum,Aluminum Ore,Aluminium-Erz
item_ore_silicon,Silicon Ore,Silizium-Erz
item_ore_uranium,Uranium Ore,Uran-Erz
item_component_battery,Battery Pack,Batterie-Pack
item_component_reactor_core,Reactor Core,Reaktor-Kern
item_component_thruster,Thruster Module,Triebwerk-Modul
item_component_radar,Radar System,Radar-System
item_component_computer,Ship Computer,Schiffs-Computer
item_component_armor_plate,Armor Plating,Panzerung
item_component_coolant_pump,Coolant Pump,Kühlpumpe
item_component_fuel_cell,Fuel Cell,Brennstoffzelle
item_component_sensor_array,Sensor Array,Sensor-Array
item_liquid_fuel,Fuel,Treibstoff
item_liquid_coolant,Coolant,Kühlmittel
item_liquid_hydrogen,Liquid Hydrogen,Flüssigwasserstoff
item_gas_hydrogen,Hydrogen Gas,Wasserstoffgas
item_gas_oxygen,Oxygen Gas,Sauerstoffgas
item_gas_nitrogen,Nitrogen Gas,Stickstoffgas
item_hazmat_uranium,Enriched Uranium,Angereichertes Uran
item_hazmat_plutonium,Plutonium,Plutonium
item_hazmat_toxic_waste,Toxic Waste,Giftmüll
```

---

## 🎯 PRIORITÄT 3: NAMING CONSISTENCY (Diese Woche)

### 3.1 ID-Namenskonventionen standardisieren

**Problem:** Mix aus camelCase, snake_case, Leerzeichen

**Regel:** **IMMER snake_case, KEINE Leerzeichen**

**Beispiele:**
```
✅ KORREKT:
ore_iron
mineral_copper_pure
component_metal_plates
module_mining_laser_t1

❌ FALSCH:
IronOre (camelCase)
iron ore (Leerzeichen!)
iron-ore (Bindestrich)
Iron_Ore (PascalCase)
```

**Auto-Fix Script:**
```bash
# Findet alle IDs mit Leerzeichen in TSV-Dateien
grep -P '\t[^\t]*\s+[^\t]*\t' data/**/*.tsv

# Warnung: Manuelle Korrektur erforderlich!
# Leerzeichen in IDs können System-Crashes verursachen
```

---

## 🎯 PRIORITÄT 4: NO SPACES IN IDs (KRITISCH)

### 4.1 IDs mit Leerzeichen finden und fixen

**Problem:** Einige IDs enthalten Leerzeichen → Runtime-Fehler

**Suche:**
```bash
# Suche nach IDs mit Leerzeichen in allen TSV-Dateien
find data/ -name "*.tsv" -exec grep -H -P '\t[A-Z_]+\s+[A-Z_]+\t' {} \;
```

**Beispiel-Problem:**
```tsv
# ❌ FALSCH:
SHIP_ID  SHIP 005  Hermes Stealth  ...
           ^^^^^^^^ Leerzeichen in ID!

# ✅ KORREKT:
SHIP_ID  SHIP_005  Hermes Stealth  ...
```

**Fix-Script:**
```bash
#!/bin/bash
# fix_id_spaces.sh
# Entfernt Leerzeichen aus IDs in TSV-Dateien

echo "🔍 Suche nach IDs mit Leerzeichen..."

# Backup
tar -czf tsv_backup_$(date +%Y%m%d_%H%M%S).tar.gz data/

# Fix: Ersetze "SHIP 005" mit "SHIP_005" etc.
find data/ -name "*.tsv" -exec sed -i 's/\(SHIP\|ORE\|COMP\|MAT\)\s\+\([0-9]\)/\1_\2/g' {} \;

echo "✅ Fertig! Überprüfe mit: git diff data/"
```

---

## 📊 ZUSAMMENFASSUNG

### Kritische Fixes (Diese Woche)
- [ ] ItemDatabase.gd erstellen (63 Items) - **2-3 Stunden**
- [ ] Referenzielle Integrität prüfen - **1 Stunde**
- [ ] IDs mit Leerzeichen fixen - **30 Minuten**
- [ ] Namenskonventionen standardisieren - **1 Stunde**

### Wichtige Fixes (Nächste Woche)
- [ ] 60+ Translations hinzufügen - **2 Stunden**
- [ ] ShipDatabase.gd erweitern - **2 Stunden**

### Total Zeitaufwand
- **Critical Path:** ~5 Stunden
- **Full Implementation:** ~10 Stunden

---

## 🚀 AUSFÜHRUNGS-REIHENFOLGE

1. ✅ **ItemDatabase.gd erstellen** (Blocker für alles andere)
2. ✅ **IDs mit Leerzeichen fixen** (Runtime-Crash-Prävention)
3. ✅ **Referenzielle Integrität** (Catch errors early)
4. ✅ **Translations** (UX-Verbesserung)
5. ✅ **Naming Consistency** (Wartbarkeit)

---

**Status:** ⚠️ WARTET AUF AUSFÜHRUNG
**Priorität:** CRITICAL
**Blocker:** Viele Systeme nutzen fehlende Items
