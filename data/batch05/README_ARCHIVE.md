# Batch05 TSV Archive

**Status:** ⚠️ DEPRECATED - NUR ALS REFERENZ/BACKUP

---

## ⚠️ WARNUNG

Diese TSV-Dateien wurden **konsolidiert** und sind **nicht mehr die aktive Datenquelle**!

**Aktive Datenbank:** `scripts/ItemDatabase.gd` (910 Items)

---

## Archivierte Dateien

Dieser Ordner enthält die ursprünglichen TSV-Dateien, die als **Backup und Referenz** aufbewahrt werden:

```
data/batch05/
├── COMPLETE_SPACE_GAME_DATABASE.tsv  (105 Items: Ores, Materials, Gases, Waste, Mining Modules)
├── 06_COMPONENTS.tsv                  (100 Components)
├── 07a_WEAPONS_PART1.tsv              (100 Weapons)
├── 07b_WEAPONS_PART2.tsv              (100 Weapons)
├── 08_AMMUNITION.tsv                  (50 Ammunition)
├── 09a_shields_armor.tsv              (50 Shield/Armor Modules)
├── 09b_engines_power.tsv              (50 Engine/Power Modules)
├── 09c_cargo_sensors.tsv              (50 Cargo/Sensor Modules)
├── 09d_ecm_mining.tsv                 (50 ECM/Mining Modules)
├── 09e_command_medical.tsv            (50 Command/Medical Modules)
├── 09f_utility_station.tsv            (50 Utility/Station Modules)
├── 10a_frigates_destroyers.tsv        (40 Frigates/Destroyers)
├── 10b_cruisers_battlecruisers.tsv    (35 Cruisers/Battlecruisers)
├── 10c_battleships_carriers.tsv       (27 Battleships/Carriers)
├── 10d_dreadnoughts_titans.tsv        (18 Dreadnoughts/Titans)
└── 10e_industrial_special_civilian.tsv (35 Industrial/Special/Civilian)
```

**TOTAL:** 910 Items

---

## 🔄 Konsolidierung

Alle diese Dateien wurden am **2025-11-19** in eine einheitliche Datenbank konsolidiert:

**Ziel:** `scripts/ItemDatabase.gd`

**Konvertierungsskript:** `convert_tsv_final.py`

---

## ⚠️ Nicht mehr verwenden!

**Verwende NICHT:**
- ❌ Diese TSV-Dateien direkt im Code
- ❌ `OreDatabase.gd` (entfernt)
- ❌ `database_manager.gd` (deprecated)
- ❌ Fragmentierte Item-Definitionen

**Verwende STATTDESSEN:**
- ✅ `ItemDatabase.gd` für alle Item-Zugriffe
- ✅ `ItemDatabase.get_item(item_id)` API
- ✅ Guidelines in `docs/ITEM_MANAGEMENT_GUIDELINES.md`

---

## 📚 Weitere Informationen

Siehe: `docs/ITEM_MANAGEMENT_GUIDELINES.md`
