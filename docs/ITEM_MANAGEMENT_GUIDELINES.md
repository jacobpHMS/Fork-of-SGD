# ITEM MANAGEMENT GUIDELINES

**Version:** 1.0
**Datum:** 2025-11-19
**Status:** ✅ AKTIV

---

## 🎯 Übersicht

Dieses Dokument definiert die **verbindlichen Richtlinien** für die Verwaltung von Items im SpaceGameDev-Projekt. Alle zukünftigen Änderungen an Items, Modulen, Schiffen und anderen Spielinhalten **MÜSSEN** diesen Guidelines folgen.

---

## ⚠️ KRITISCHE REGEL: EINE ZENTRALE DATENQUELLE

### ❌ **NIEMALS WIEDER:**
- Mehrere fragmentierte Item-Datenbanken erstellen
- Items in separaten TSV/JSON-Dateien verstreuen
- Duplikate zwischen verschiedenen Systemen anlegen
- EVE Online oder X4 Namen verwenden (Copyright!)

### ✅ **IMMER:**
- **EINE zentrale Datenquelle:** `scripts/ItemDatabase.gd`
- Alle Items werden in dieser Datei definiert
- Alle Systeme greifen auf diese Datenbank zu
- Generische, Copyright-freie Namen verwenden

---

## 📁 Projektstruktur

```
SpaceGameDev/
├── scripts/
│   └── ItemDatabase.gd          ← ✅ ZENTRALE ITEM-DATENBANK (910 Items)
│
├── data/
│   └── batch05/                 ← ⚠️ ARCHIVIERT (nur als Backup)
│       ├── COMPLETE_SPACE_GAME_DATABASE.tsv
│       ├── 06_COMPONENTS.tsv
│       ├── 07a_WEAPONS_PART1.tsv
│       └── ...
│
├── convert_tsv_final.py         ← 🔄 Konvertierungsskript (bei Bedarf)
│
└── docs/
    └── ITEM_MANAGEMENT_GUIDELINES.md  ← 📄 Dieses Dokument
```

---

## 📊 ItemDatabase.gd Struktur

### Item-Kategorien

```gdscript
enum ItemCategory {
    ORE,            # Erze (32 Items)
    MINERAL,        # Raffin. Materialien (33 Items)
    GAS,            # Gase (10 Items)
    WASTE,          # Abfallprodukte (5 Items)
    COMPONENT,      # Komponenten (100 Items)
    MODULE,         # Schiffsmodule (325 Items)
    WEAPON,         # Waffen (200 Items)
    AMMO,           # Munition (50 Items)
    SHIP,           # Schiffe (155 Items)
    CARGO,          # Cargo Items
    PASSENGER,      # Passagiere
    MANUFACTURING   # Manufacturing Items
}
```

### Item-Datenstruktur

```gdscript
class ItemData:
    var id: String               # Eindeutige ID (z.B. "ORE_T1_001")
    var name: String             # Anzeigename (z.B. "Ferralite")
    var category: ItemCategory   # Kategorie (z.B. ORE)
    var tier: int                # Tier/Level (1-6)
    var base_price: int          # Basis-Preis in Credits
    var volume: float            # Volumen in m³
    var mass: float              # Masse in kg
    var description: String      # Beschreibung
```

---

## 🔧 Neue Items hinzufügen

### Option 1: Direkt in ItemDatabase.gd (Einfache Änderungen)

Für 1-5 neue Items:

```gdscript
# scripts/ItemDatabase.gd

func _initialize_items():
    # ... existing items ...

    # Neues Item hinzufügen
    item_registry["NEW_ITEM_001"] = ItemData.new()
    item_registry["NEW_ITEM_001"].id = "NEW_ITEM_001"
    item_registry["NEW_ITEM_001"].name = "Neues Item"
    item_registry["NEW_ITEM_001"].category = ItemCategory.COMPONENT
    item_registry["NEW_ITEM_001"].tier = 1
    item_registry["NEW_ITEM_001"].base_price = 5000
    item_registry["NEW_ITEM_001"].volume = 10.0
    item_registry["NEW_ITEM_001"].mass = 5.0
    item_registry["NEW_ITEM_001"].description = "Ein neues Component Item"
```

### Option 2: TSV → Konvertierung (Bulk-Änderungen)

Für 10+ neue Items:

1. **Erstelle neue TSV-Datei** in `data/batch05/`:
   ```tsv
   DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	...
   COMP	NEW_001	Neues Item	1	COMPONENT	S	Tech	5.0	10.0	5000	...
   ```

2. **Führe Konvertierungsskript aus:**
   ```bash
   python3 convert_tsv_final.py
   ```

3. **Validiere die neue ItemDatabase.gd**

4. **Teste im Spiel**

---

## 🚫 Copyright-Compliance: EVE Online Namen

### ❌ **VERBOTEN:**
- Direktes Kopieren von EVE Online Schiffsnamen
- Direktes Kopieren von X4 Namen
- Verwendung geschützter Markennamen

### ✅ **ERLAUBT:**
- Generische Beschreibungen (z.B. "Laser Battleship")
- Funktionale Namen (z.B. "Heavy Missile Dreadnought")
- Eigene kreative Namen

### Beispiele:

| ❌ EVE Online Name | ✅ Generischer Name |
|-------------------|---------------------|
| Dominix | Sentinel Battleship |
| Erebus | Hybrid Titan |
| Thanatos | Drone Carrier |
| Kronos | Blaster Marauder |
| Venture | Mining Frigate |

**Falls EVE Namen versehentlich eingeschlichen sind:**
1. Aktualisiere `EVE_REPLACEMENTS` in `convert_tsv_final.py`
2. Führe Konvertierung neu aus
3. Committe die Änderungen

---

## 🔄 Workflow: Items aktualisieren

1. **Backup erstellen** (optional):
   ```bash
   cp scripts/ItemDatabase.gd scripts/ItemDatabase.gd.backup
   ```

2. **Änderungen vornehmen:**
   - Direkt in ItemDatabase.gd ODER
   - TSV bearbeiten + Konvertierung

3. **Testen:**
   - Godot starten
   - ItemDatabase laden
   - Funktionen testen:
     ```gdscript
     var item = ItemDatabase.get_item("ORE_T1_001")
     print(item.name, " - ", item.base_price, " Credits")
     ```

4. **Committen:**
   ```bash
   git add scripts/ItemDatabase.gd
   git commit -m "feat: Add new items to ItemDatabase"
   git push origin <branch>
   ```

---

## 📈 Aktuelle Item-Statistiken

```
✅ 910 ITEMS TOTAL

Kategorien:
  - Ores:        32
  - Minerals:    33
  - Gases:       10
  - Waste:       5
  - Mining Mods: 25
  - Components:  100
  - Weapons:     200
  - Ammunition:  50
  - Modules:     300
  - Ships:       155
```

---

## 🛡️ Qualitätssicherung

### Vor jedem Commit prüfen:

- [ ] ✅ Alle Items haben eindeutige IDs
- [ ] ✅ Keine EVE Online oder X4 Namen enthalten
- [ ] ✅ Alle Felder korrekt ausgefüllt (id, name, category, tier, base_price, volume, mass, description)
- [ ] ✅ Keine Duplikate
- [ ] ✅ Kategorien korrekt zugewiesen
- [ ] ✅ Preise realistisch (nicht 0, nicht 999999999)
- [ ] ✅ Im Spiel getestet

---

## 🔍 Fehlerbehandlung

### Problem: "Item nicht gefunden"

```gdscript
var item = ItemDatabase.get_item("UNKNOWN_ID")
if item == null:
    print("❌ Item nicht gefunden!")
```

**Lösung:**
1. Prüfe, ob Item-ID in ItemDatabase.gd existiert
2. Prüfe Schreibweise (Case-Sensitive!)
3. Falls neu: Item hinzufügen

### Problem: "Doppelte Items"

**Symptome:**
- Ein Item überschreibt ein anderes
- Falsche Daten werden angezeigt

**Lösung:**
1. Suche nach doppelten IDs: `grep -n "item_registry\[\"ID\"\]" scripts/ItemDatabase.gd`
2. Entferne oder bennenne Duplikate um

---

## 📞 Support

Bei Fragen oder Problemen:
1. Lies diese Guidelines nochmal
2. Prüfe bestehende Items als Vorlage
3. Teste im Entwicklungsmodus
4. Dokumentiere Änderungen im Commit

---

## 📜 Changelog

| Version | Datum | Änderungen |
|---------|-------|------------|
| 1.0 | 2025-11-19 | Initiale Version - 910 Items konsolidiert |

---

**🎮 Viel Erfolg beim Entwickeln!**
