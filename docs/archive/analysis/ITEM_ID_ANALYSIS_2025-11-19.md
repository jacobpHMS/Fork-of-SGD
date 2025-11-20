# ITEM-ID ANALYSE - ALLE SYSTEM-DATEIEN
**Datum:** 2025-11-19  
**Durchgesehen:** BlueprintSystem.gd, StationModuleSystem.gd, MarketSystem.gd, ExtendedPassengerSystem.gd, ColonyManagementSystem.gd, ItemDatabase.gd

---

## ZUSAMMENFASSUNG

| Metrik | Anzahl |
|--------|--------|
| **Total Item-IDs in ItemDatabase** | 67 |
| **Item-IDs verwendet in anderen Systemen** | 20 (davon 18 existieren, 2 fehlen) |
| **Fehlende Item-IDs** | 2 |
| **Lücken in der ItemDatabase** | 2 missing ships |

---

## 1. ITEMDATABASE BESTANDSAUFNAHME (67 Items)

### TIER 0: ORES (13 Items)
```
✓ ore_iron            (COMMON)
✓ ore_copper          (COMMON)
✓ ore_aluminum        (COMMON)
✓ ore_silicon         (UNCOMMON)
✓ ore_titanium        (UNCOMMON)
✓ ore_nickel          (UNCOMMON)
✓ ore_uranium         (RARE)
✓ ore_platinum        (RARE)
✓ ore_gold            (RARE)
✓ ore_lithium         (RARE)
✓ ore_exotic          (EXOTIC)
✓ ore_crystal         (EXOTIC)
✓ ore_dark_matter     (LEGENDARY)
```

### TIER 1: STANDARD MINERALS (13 Items)
```
✓ mineral_iron        (COMMON)
✓ mineral_copper      (COMMON)
✓ mineral_aluminum    (COMMON)
✓ mineral_silicon     (UNCOMMON)
✓ mineral_titanium    (UNCOMMON)
✓ mineral_nickel      (UNCOMMON)
✓ mineral_uranium     (RARE)
✓ mineral_platinum    (RARE)
✓ mineral_gold        (RARE)
✓ mineral_lithium     (RARE)
✓ mineral_exotic      (EXOTIC)
✓ mineral_crystal     (EXOTIC)
✓ mineral_dark_matter (LEGENDARY)
```

### TIER 2: PURE MINERALS (10 Items)
```
✓ mineral_iron_pure        (UNCOMMON)
✓ mineral_copper_pure      (UNCOMMON)
✓ mineral_silicon_pure     (UNCOMMON)
✓ mineral_titanium_pure    (RARE)
✓ mineral_platinum_pure    (RARE)
✓ mineral_gold_pure        (RARE)
✓ mineral_lithium_pure     (RARE)
✓ mineral_exotic_pure      (EXOTIC)
✓ mineral_crystal_pure     (EXOTIC)
✓ mineral_dark_matter_pure (LEGENDARY)
```

### TIER 3-4: COMPONENTS (11 Items)
```
TIER 3 (Basic):
✓ component_metal_plates      (COMMON)
✓ component_wiring            (COMMON)
✓ component_circuit_board     (UNCOMMON)
✓ component_hydraulics        (UNCOMMON)
✓ component_battery           (UNCOMMON)
✓ component_storage_chip      (UNCOMMON)

TIER 4 (Complex):
✓ component_compressor        (RARE)
✓ component_quantum_core      (EXOTIC)
✓ component_shield_emitter    (RARE)
✓ component_reactor_core      (EXOTIC)
✓ component_thruster          (RARE)
```

### TIER 5: MODULES (8 Items)
```
✓ module_mining_laser_t1      (UNCOMMON)
✓ module_mining_laser_t2      (RARE)
✓ module_weapon_cannon_t1     (UNCOMMON)
✓ module_weapon_laser_t1      (UNCOMMON)
✓ module_shield_t1            (RARE)
✓ module_armor_plating_t1     (UNCOMMON)
✓ module_scanner_t1           (COMMON)
✓ module_cargo_expander       (COMMON)
```

### TIER 6: SHIPS (4 Items)
```
✓ ship_player_basic    (UNCOMMON)
✓ ship_miner_small     (COMMON)
✓ ship_miner_medium    (UNCOMMON)
✓ ship_fighter_light   (UNCOMMON)
```

### SPECIAL: CARGO ITEMS (4 Items)
```
✓ liquid_fuel          (TIER 1, COMMON)
✓ liquid_coolant       (TIER 2, UNCOMMON)
✓ gas_hydrogen         (TIER 1, COMMON)
✓ gas_oxygen           (TIER 1, COMMON)
```

### SPECIAL: AMMUNITION (4 Items)
```
✓ ammo_ballistic_basic (TIER 3, COMMON)
✓ ammo_energy_cell     (TIER 3, UNCOMMON)
✓ ammo_emp_round       (TIER 4, RARE)
✓ ammo_plasma_bolt     (TIER 5, EXOTIC)
```

---

## 2. ITEM-REFERENZEN IN BLUEPRINTSYSTEM.GD

### Software-Datenbank (Manufacturing Recipes)

**SOFTWARE_SHIP_MINING_FRIGATE**
- Output: `ship_miner_small` ✓
- Materials: 
  - `mineral_iron` (10000) ✓
  - `mineral_copper` (2000) ✓
  - `component_battery` (50) ✓

**SOFTWARE_MODULE_MINING_LASER**
- Output: `module_mining_laser_t1` ✓
- Materials:
  - `mineral_iron` (100) ✓
  - `component_circuit_board` (5) ✓

**SOFTWARE_AMMO_BALLISTIC**
- Output: `ammo_ballistic_basic` ✓
- Materials:
  - `mineral_iron` (500) ✓

**SOFTWARE_AMMO_EMP**
- Output: `ammo_emp_round` ✓
- Materials:
  - `mineral_iron` (300) ✓
  - `mineral_copper` (50) ✓
  - `component_circuit_board` (10) ✓

**SOFTWARE_AMMO_PLASMA**
- Output: `ammo_plasma_bolt` ✓
- Materials:
  - `mineral_copper` (200) ✓
  - `mineral_titanium` (100) ✓
  - `component_shield_emitter` (20) ✓

### Chip Recharge System (RECHARGE_MATERIALS_COST)

| Tier | Materials |
|------|-----------|
| TIER 1 | `mineral_iron_pure` ✓, `liquid_coolant` ✓, `component_storage_chip` ✓ |
| TIER 2 | TIER 1 + `mineral_copper_pure` ✓ |
| TIER 3 | TIER 2 + `mineral_titanium_pure` ✓ |
| TIER 4 | TIER 3 + `mineral_platinum_pure` ✓ |
| TIER 5 | TIER 4 + `mineral_gold_pure` ✓ |

---

## 3. ITEM-REFERENZEN IN STATIONMODULESYSTEM.GD

**Status:** Keine Item-Referenzen (nur Modul-Verwaltung)

---

## 4. ITEM-REFERENZEN IN MARKETSYSTEM.GD

**Status:** Nutzt `DatabaseManager.get_all_item_ids()` - alle Items aus ItemDatabase werden automatisch integriert

---

## 5. ITEM-REFERENZEN IN EXTENDEDPASSENGERSYSTEM.GD

**luxury_liner_ships Array (Zeile 10):**
```gdscript
var luxury_liner_ships = ["SHIP_LUXURY_LINER_I", "SHIP_LUXURY_LINER_II"]
```

| Item-ID | Status | Problem |
|---------|--------|---------|
| `SHIP_LUXURY_LINER_I` | **FEHLT** | ✗ Nicht in ItemDatabase |
| `SHIP_LUXURY_LINER_II` | **FEHLT** | ✗ Nicht in ItemDatabase |

---

## 6. ITEM-REFERENZEN IN COLONYMANGEMENTSYSTEM.GD

**Status:** Keine Item-Referenzen (nur Kolonien-Verwaltung)

---

## FEHLER-ANALYSE

### Fehlende Items (2 Items)

#### 1. SHIP_LUXURY_LINER_I
- **Quelle:** ExtendedPassengerSystem.gd, Zeile 10
- **Status:** FEHLT IN ItemDatabase
- **Verwendung:** Passenger transportation (luxury tier)
- **Kategorie:** SHIP
- **Geschätzter Tier:** TIER 6 (Advanced)
- **Geschätzte Rarity:** RARE
- **Geschätzter Preis:** 2,000,000 credits

#### 2. SHIP_LUXURY_LINER_II
- **Quelle:** ExtendedPassengerSystem.gd, Zeile 10
- **Status:** FEHLT IN ItemDatabase
- **Verwendung:** Premium passenger transportation
- **Kategorie:** SHIP
- **Geschätzter Tier:** TIER 6 (Advanced)
- **Geschätzte Rarity:** EXOTIC
- **Geschätzter Preis:** 5,000,000 credits

---

## VERWENDUNGSMUSTER

### Häufig verwendete Item-IDs (in Manufacturing/Recharge)

| Item-ID | Verwendungen | Verwendungsart |
|---------|--------------|----------------|
| `mineral_iron` | 3x | Manufacturing input |
| `mineral_copper` | 3x | Manufacturing input |
| `mineral_iron_pure` | 5x | Recharge input |
| `mineral_copper_pure` | 4x | Recharge input |
| `component_circuit_board` | 2x | Manufacturing input |
| `component_battery` | 1x | Manufacturing input |
| `component_storage_chip` | 5x | Recharge input |
| `liquid_coolant` | 5x | Recharge input |
| `mineral_titanium_pure` | 4x | Recharge input |
| `mineral_platinum_pure` | 4x | Recharge input |

---

## EMPFEHLUNG: AKTION ERFORDERLICH

### Items die zur ItemDatabase hinzugefügt werden MÜSSEN:

1. **SHIP_LUXURY_LINER_I** - Luxury Passenger Liner (Tier)
2. **SHIP_LUXURY_LINER_II** - Premium Luxury Liner (Exotic)

Diese zwei Ships werden in `ExtendedPassengerSystem.gd` referenziert, aber sind nicht in `ItemDatabase.gd` registriert.

**Priorität:** HOCH - Das Spiel wird Runtime-Fehler werfen, wenn diese Ships verwendet werden.

---

## VALIDIERUNGSERGEBNIS

### Alle verwendeten Item-IDs:

```
BLUEPRINTSYSTEM (14 verschiedene IDs):
✓ ship_miner_small
✓ mineral_iron
✓ mineral_copper
✓ component_battery
✓ module_mining_laser_t1
✓ component_circuit_board
✓ ammo_ballistic_basic
✓ ammo_emp_round
✓ ammo_plasma_bolt
✓ mineral_titanium
✓ component_shield_emitter
✓ mineral_iron_pure
✓ mineral_copper_pure
✓ mineral_titanium_pure
✓ mineral_platinum_pure
✓ mineral_gold_pure
✓ liquid_coolant
✓ component_storage_chip

EXTENDEDPASSENGERSYSTEM (2 verschiedene IDs):
✗ SHIP_LUXURY_LINER_I       (FEHLT)
✗ SHIP_LUXURY_LINER_II      (FEHLT)
```

**Validierungsergebnis:** 18 Items vorhanden, 2 Items fehlen (10% Fehlerquote)

---

## NEXT STEPS

1. **SOFORT:** Füge `SHIP_LUXURY_LINER_I` und `SHIP_LUXURY_LINER_II` zu ItemDatabase.gd hinzu
2. **VERIFY:** Teste ExtendedPassengerSystem, um zu bestätigen dass die neuen Ships korrekt geladen werden
3. **AUDIT:** Überprüfe andere System-Dateien auf weitere versteckte Item-Referenzen

