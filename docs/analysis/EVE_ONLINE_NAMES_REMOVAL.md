# 🚫 EVE Online Namen - Entfernung & Ersetzung

**Erstellt:** 2025-11-19
**Grund:** Markenrechtliche Bedenken, eigene Identität schaffen
**Status:** ⚠️ ACTION REQUIRED

---

## 📋 GEFUNDENE EVE ONLINE REFERENZEN

### 1. Station-Namen (StationSystem.gd)

**Aktuell (EVE Online Namen):**
```gdscript
# Station sizes (EVE-inspired naming: Raitaru, Astrahus, Fortizar)
enum StationSize {
	SMALL = 0,   # "Raitaru-Class" - Basic Operations
	MEDIUM = 1,  # "Astrahus-Class" - Advanced Operations
	LARGE = 2    # "Citadel/Keep-Class" - High-End (Player Endgame)
}
```

**Problematische Namen:**
- ❌ **Raitaru** - EVE Online Upwell Refinery (Medium Structure)
- ❌ **Astrahus** - EVE Online Upwell Citadel (Medium Structure)
- ❌ **Fortizar** - EVE Online Upwell Citadel (Large Structure)
- ❌ **Citadel** - EVE Online Struktur-Kategorie
- ❌ **Keepstar** - EVE Online Upwell Citadel (XL Structure)

**Quelle:** `scripts/StationSystem.gd:17-21`

### 2. Schiffs-Namen (TSV Database)

**data/batch05/10a_frigates_destroyers.tsv:**
```tsv
SHIP_005  Raven Stealth  Frigate  ...
```

**data/batch05/10b_cruisers_battlecruisers.tsv:**
```tsv
SHIP_062  Drake Combat  Battlecruiser  ...
```

**data/batch05/10c_battleships_carriers.tsv:**
```tsv
SHIP_085  Raven Cruise Missile  Battleship  ...
```

**Problematische Namen:**
- ❌ **Raven** - EVE Online Caldari Battleship
- ❌ **Drake** - EVE Online Caldari Battlecruiser

---

## ✅ ERSETZUNGSPLAN

### 1. Station-Namen Ersetzung

#### Option A: Generische Beschreibungen
```gdscript
enum StationSize {
	SMALL = 0,   # "Outpost-Class" - Basic Operations
	MEDIUM = 1,  # "Station-Class" - Advanced Operations
	LARGE = 2    # "Fortress-Class" - High-End (Player Endgame)
}
```

#### Option B: Science-Fiction Begriffe (Neutral)
```gdscript
enum StationSize {
	SMALL = 0,   # "Alpha Station" - Basic Operations
	MEDIUM = 1,  # "Beta Station" - Advanced Operations
	LARGE = 2    # "Gamma Station" - High-End (Player Endgame)
}
```

#### Option C: Mining/Industrial Theme
```gdscript
enum StationSize {
	SMALL = 0,   # "Refinery Platform" - Basic Operations
	MEDIUM = 1,  # "Industrial Complex" - Advanced Operations
	LARGE = 2    # "Manufacturing Citadel" - High-End
}
```

#### Option D: Eigenes Lore-System ⭐ **EMPFOHLEN**
```gdscript
enum StationSize {
	SMALL = 0,   # "Pioneer-Class" - Basic Operations (Starter stations)
	MEDIUM = 1,  # "Settler-Class" - Advanced Operations (Mid-game)
	LARGE = 2    # "Colony-Class" - High-End (Endgame mega-stations)
}
```

**Warum Option D?**
- Passt zum Thema (Space Mining, Kolonisierung)
- Progression: Pioneer → Settler → Colony
- Kein Konflikt mit anderen IPs
- Eigene Identität

---

### 2. Schiffs-Namen Ersetzung

#### Aktuelle problematische Namen:
```tsv
Raven Stealth → ?
Drake Combat → ?
Raven Cruise Missile → ?
```

#### Ersetzungsvorschläge:

**Option A: Tier-basierte Namen**
```tsv
Raven Stealth         → Viper Stealth (Tier 2 Frigate)
Drake Combat          → Falcon Combat (Tier 4 Battlecruiser)
Raven Cruise Missile  → Eagle Cruise (Tier 5 Battleship)
```

**Option B: Mining/Industrial Theme**
```tsv
Raven Stealth         → Prospector Stealth (Mining-fokussiert)
Drake Combat          → Enforcer Combat (Security/Combat)
Raven Cruise Missile  → Dreadnought Cruise (Heavy Combat)
```

**Option C: Mythologie (Neutral) ⭐ **EMPFOHLEN**
```tsv
Raven Stealth         → Hermes Stealth (Griechisch: Schnelligkeit)
Drake Combat          → Ares Combat (Griechisch: Kriegsgott)
Raven Cruise Missile  → Atlas Cruise (Griechisch: Titan, Stärke)
```

**Option D: Edelsteine/Mineralien (Passt zum Thema)**
```tsv
Raven Stealth         → Obsidian Stealth (Schwarz, schnell)
Drake Combat          → Titanium Combat (Hart, robust)
Raven Cruise Missile  → Adamant Cruise (Unzerstörbar)
```

---

## 🔧 IMPLEMENTATION PLAN

### Phase 1: StationSystem.gd (15 Minuten)

**Datei:** `scripts/StationSystem.gd`

**Änderungen:**
```gdscript
# VORHER (Zeile 17-21):
# Station sizes (EVE-inspired naming: Raitaru, Astrahus, Fortizar)
enum StationSize {
	SMALL = 0,   # "Raitaru-Class" - Basic Operations
	MEDIUM = 1,  # "Astrahus-Class" - Advanced Operations
	LARGE = 2    # "Citadel/Keep-Class" - High-End (Player Endgame)
}

# NACHHER:
# Station sizes (Pioneer → Settler → Colony progression)
enum StationSize {
	SMALL = 0,   # "Pioneer-Class" - Basic Operations
	MEDIUM = 1,  # "Settler-Class" - Advanced Operations
	LARGE = 2    # "Colony-Class" - High-End (Player Endgame)
}
```

**Weitere Ersetzungen in StationSystem.gd:**
```bash
# Suche nach allen Vorkommen
grep -n "Raitaru\|Astrahus\|Fortizar\|Citadel\|Keepstar" scripts/StationSystem.gd

# Ersetzung (nach Bestätigung):
sed -i 's/Raitaru/Pioneer/g' scripts/StationSystem.gd
sed -i 's/Astrahus/Settler/g' scripts/StationSystem.gd
sed -i 's/Fortizar/Colony/g' scripts/StationSystem.gd
sed -i 's/Citadel/Colony/g' scripts/StationSystem.gd
sed -i 's/Keepstar/Mega-Colony/g' scripts/StationSystem.gd
```

### Phase 2: Database TSV Files (30 Minuten)

**Betroffene Dateien:**
- `data/batch05/10a_frigates_destroyers.tsv`
- `data/batch05/10b_cruisers_battlecruisers.tsv`
- `data/batch05/10c_battleships_carriers.tsv`

**Manuelle Ersetzung (TSV erfordert Vorsicht):**

#### 10a_frigates_destroyers.tsv:
```tsv
# VORHER (Zeile 6):
SHIP  SHIP_005  Raven Stealth  2  Frigate  S  Stealth  ...

# NACHHER:
SHIP  SHIP_005  Hermes Stealth  2  Frigate  S  Stealth  ...
```

#### 10b_cruisers_battlecruisers.tsv:
```tsv
# VORHER (Zeile 23):
SHIP  SHIP_062  Drake Combat  4  Battlecruiser  L  Missile  ...

# NACHHER:
SHIP  SHIP_062  Ares Combat  4  Battlecruiser  L  Missile  ...
```

#### 10c_battleships_carriers.tsv:
```tsv
# VORHER (Zeile 11):
SHIP  SHIP_085  Raven Cruise Missile  5  Battleship  XL  Cruise  ...

# NACHHER:
SHIP  SHIP_085  Atlas Cruise  5  Battleship  XL  Cruise  ...
```

**Batch-Ersetzung (nur nach Backup!):**
```bash
# Backup erstellen
cp data/batch05/10a_frigates_destroyers.tsv data/batch05/10a_frigates_destroyers.tsv.backup

# Ersetzung
sed -i 's/Raven Stealth/Hermes Stealth/g' data/batch05/10a_frigates_destroyers.tsv
sed -i 's/Drake Combat/Ares Combat/g' data/batch05/10b_cruisers_battlecruisers.tsv
sed -i 's/Raven Cruise Missile/Atlas Cruise/g' data/batch05/10c_battleships_carriers.tsv
```

### Phase 3: Dokumentation aktualisieren (15 Minuten)

**Betroffene Dateien:**
- `docs/wiki/systems/Stations.md`
- `docs/ASSET_MANAGEMENT_SYSTEM.md`
- `docs/DATABASE_CONSISTENCY_REPORT.md`

**Suche nach Referenzen:**
```bash
grep -r "Raitaru\|Astrahus\|Fortizar\|Citadel\|Keepstar\|Raven\|Drake" docs/
```

**Ersetzung:**
```bash
# Station-Namen in Dokumentation
find docs/ -type f -name "*.md" -exec sed -i 's/Raitaru/Pioneer/g; s/Astrahus/Settler/g; s/Fortizar/Colony/g' {} +

# Schiffs-Namen in Dokumentation
find docs/ -type f -name "*.md" -exec sed -i 's/Raven/Hermes/g; s/Drake/Ares/g' {} +
```

---

## 🔍 VOLLSTÄNDIGE SUCHE (Alle Dateien)

```bash
# Suche nach allen EVE Online Referenzen im gesamten Projekt
grep -r -i "raitaru\|astrahus\|fortizar\|keepstar\|azbel\|sotiyo\|tatara\|athanor" . \
  --include="*.gd" --include="*.tsv" --include="*.md" --include="*.tscn"

# Caldari-spezifische Schiffsnamen
grep -r -i "raven\|drake\|rokh\|scorpion\|golem" . \
  --include="*.gd" --include="*.tsv" --include="*.md"

# Gallente-spezifische Schiffsnamen
grep -r -i "dominix\|myrmidon\|brutix\|hyperion\|megathron" . \
  --include="*.gd" --include="*.tsv" --include="*.md"

# Amarr-spezifische Schiffsnamen
grep -r -i "apocalypse\|armageddon\|abaddon\|paladin" . \
  --include="*.gd" --include="*.tsv" --include="*.md"

# Minmatar-spezifische Schiffsnamen
grep -r -i "rifter\|thrasher\|maelstrom\|tempest" . \
  --include="*.gd" --include="*.tsv" --include="*.md"
```

---

## ✅ ERSETZUNGS-CHECKLISTE

### Code-Dateien
- [ ] `scripts/StationSystem.gd` - Raitaru → Pioneer, Astrahus → Settler, etc.
- [ ] `scripts/Station.gd` - Überprüfen auf Referenzen
- [ ] `scripts/DeveloperMenu.gd` - Überprüfen
- [ ] `scripts/MapSystem.gd` - Überprüfen
- [ ] `scripts/MapSymbols.gd` - Überprüfen

### Database-Dateien
- [ ] `data/batch05/10a_frigates_destroyers.tsv` - Raven → Hermes
- [ ] `data/batch05/10b_cruisers_battlecruisers.tsv` - Drake → Ares
- [ ] `data/batch05/10c_battleships_carriers.tsv` - Raven → Atlas
- [ ] `data/batch05/COMPLETE_SPACE_GAME_DATABASE.tsv` - Alle Ersetzungen

### Dokumentation
- [ ] `docs/wiki/systems/Stations.md`
- [ ] `docs/ASSET_MANAGEMENT_SYSTEM.md`
- [ ] `docs/DATABASE_CONSISTENCY_REPORT.md`
- [ ] `docs/analysis/DEPENDENCIES.md`
- [ ] `FEATURE_ROADMAP.md`
- [ ] `IMPLEMENTED_FEATURES.md`
- [ ] `00_COMPLETE_DATABASE_OVERVIEW.txt`
- [ ] `Batch05/DATABASE_SUMMARY.md`
- [ ] `Batch05/SHIP_MODULES_SHIPS_DATABASE_COMPLETE.md`

### Textdateien & Misc
- [ ] Überprüfe alle `.txt` Dateien
- [ ] Überprüfe alle Kommentare in `.gd` Dateien

---

## 📊 NEUE NAMENSKONVENTIONEN

### Stationen (Thema: Kolonisierung & Expansion)

| Größe | Alter Name (EVE) | Neuer Name | Beschreibung |
|-------|------------------|------------|--------------|
| SMALL | Raitaru | **Pioneer Station** | Erste Aussenposten, grundlegende Operationen |
| MEDIUM | Astrahus | **Settler Station** | Erweiterte Kolonien, mittlere Operationen |
| LARGE | Fortizar/Citadel | **Colony Station** | Große Kolonien, komplexe Operationen |
| XLARGE | Keepstar | **Mega-Colony** | Endgame Megastationen |

### Schiffe (Thema: Mythologie)

| Typ | Alter Name (EVE) | Neuer Name | Mythologie-Bezug |
|-----|------------------|------------|------------------|
| Frigate | Raven | **Hermes** | Griechisch: Schnelligkeit, Handel |
| Battlecruiser | Drake | **Ares** | Griechisch: Krieg, Kampf |
| Battleship | Raven | **Atlas** | Griechisch: Titan, Stärke |

**Weitere Mythologie-Namen (Reserve):**
- **Prometheus** (Innovator, Technologie)
- **Apollo** (Präzision, Zielsicherheit)
- **Artemis** (Jäger, Stealth)
- **Thor** (Nordisch: Kraft, Donner)
- **Odin** (Nordisch: Weisheit, Strategie)
- **Freya** (Nordisch: Schönheit, Kampf)

---

## 🚀 AUSFÜHRUNGS-SCRIPT

```bash
#!/bin/bash
# eve_names_removal.sh
# Entfernt alle EVE Online Referenzen aus dem Projekt

echo "🚫 EVE Online Namen Entfernung"
echo "=============================="

# Backup erstellen
echo "📦 Erstelle Backup..."
tar -czf backup_before_eve_removal_$(date +%Y%m%d_%H%M%S).tar.gz \
  scripts/ data/ docs/

# Station-Namen ersetzen
echo "🏭 Ersetze Station-Namen..."
sed -i 's/Raitaru/Pioneer/g' scripts/StationSystem.gd
sed -i 's/Astrahus/Settler/g' scripts/StationSystem.gd
sed -i 's/Fortizar/Colony/g' scripts/StationSystem.gd
sed -i 's/Citadel-Class/Colony-Class/g' scripts/StationSystem.gd
sed -i 's/Keepstar/Mega-Colony/g' scripts/StationSystem.gd

# Schiffs-Namen ersetzen
echo "🚀 Ersetze Schiffs-Namen..."
sed -i 's/Raven Stealth/Hermes Stealth/g' data/batch05/10a_frigates_destroyers.tsv
sed -i 's/Drake Combat/Ares Combat/g' data/batch05/10b_cruisers_battlecruisers.tsv
sed -i 's/Raven Cruise/Atlas Cruise/g' data/batch05/10c_battleships_carriers.tsv

# Dokumentation aktualisieren
echo "📝 Aktualisiere Dokumentation..."
find docs/ -type f -name "*.md" -exec sed -i \
  -e 's/Raitaru/Pioneer/g' \
  -e 's/Astrahus/Settler/g' \
  -e 's/Fortizar/Colony/g' \
  -e 's/Keepstar/Mega-Colony/g' \
  -e 's/Raven/Hermes/g' \
  -e 's/Drake/Ares/g' \
  {} +

echo "✅ Fertig! Überprüfe die Änderungen mit 'git diff'"
echo "📋 Bei Problemen: Backup wiederherstellen mit 'tar -xzf backup_*.tar.gz'"
```

---

## ⚠️ WICHTIGE HINWEISE

1. **Vor Ausführung:**
   - ✅ Backup erstellen (`git stash` oder `tar`)
   - ✅ Branch erstellen: `git checkout -b remove-eve-names`
   - ✅ TSV-Dateien überprüfen (Tab-Trennung!)

2. **Nach Ausführung:**
   - ✅ `git diff` überprüfen
   - ✅ Spiel starten und testen
   - ✅ Database-Integrität prüfen
   - ✅ Translations aktualisieren (falls nötig)

3. **Translations (game_strings.csv):**
   - Möglicherweise enthalten Translations auch EVE-Namen
   - Manuell überprüfen und anpassen

---

## 📖 EMPFEHLUNG

**Reihenfolge:**
1. ✅ Script ausführen (mit Backup)
2. ✅ `git diff` überprüfen
3. ✅ Manuell kritische Dateien nachkontrollieren (TSV!)
4. ✅ Spiel testen
5. ✅ Commit: `git commit -m "LEGAL: Remove all EVE Online trademarked names"`
6. ✅ Push und PR erstellen

**Zeitaufwand:** ~1 Stunde (mit Testing)

---

**Status:** ⚠️ WARTET AUF AUSFÜHRUNG
**Priorität:** HOCH (Rechtliche Absicherung)
