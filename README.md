# 🌌 Space Game - X4-Inspired Space Sandbox

**Genre:** Weltraum-Simulation / Sandbox / Management / Automation
**Engine:** Godot 4.5+
**Grafikstil:** Pixelart Top-Down (128x128 Sprites)
**Status:** Production Ready v2.0
**Plattform:** PC (Steam + Web geplant)
**Sprachen:** English, Deutsch

---

## 🎮 Was ist Space Game?

**Space Game** ist eine ambitionierte Weltraum-Sandbox-Simulation inspiriert von **X4: Foundations**, **Eve Online** und **Factorio**. Das Spiel kombiniert tiefe Wirtschaftssimulation, komplexe Produktionsketten, umfangreiches Flottenmanagement und eine lebendige KI-gesteuerte Spielwelt mit **10.000+ simulierten NPC-Schiffen**.

### 🎯 Kernphilosophie

- **Massive Weltensimulation**: 10.000+ NPCs agieren unabhängig mit eigenen Zielen
- **Tiefe statt Breite**: Komplexe, miteinander verwobene Systeme
- **Player Freedom**: Händler, Bergbauer, Pirat, Flottenkommandant - du entscheidest
- **Automation First**: Baue dein Imperium durch intelligente Automatisierung
- **Performance-Optimiert**: 60 FPS auch mit massivster Simulation

---

## 🚀 Hauptfeatures

### 🤖 X4-Inspired AI & Automation

**Lebendige Spielwelt mit unabhängigen NPCs:**
- **10.000+ NPC-Schiffe**: 8 Schiffstypen (Händler, Bergbauer, Militär, Piraten, etc.)
- **Faction System**: Diplomatie, Beziehungen, dynamische Konflikte
- **Hierarchische Kommandos**: Kommandiere Flotten, die weitere Flotten befehligen
- **X4-Style Information Network**: Navigation Satellites für Sichtbarkeit
- **Combat AI**: 5 Aggressionsstufen, Morale-System, taktische Entscheidungen
- **Patrol System**: Automatisierte Patrouillen mit Waypoint-Routen

**Vollständige Automation:**
- **Autominer AI-Chips** (Tier 1-5): Automatisierte Bergbauschiffe
- **Fleet Automation**: Befehle gesamte Flotten mit einem Klick
- **Station AI**: Stationen produzieren und handeln automatisch
- **Trade AI**: NPCs handeln basierend auf Angebot/Nachfrage

**Siehe:** [Automation Complete Guide](docs/AUTOMATION_SYSTEMS_COMPLETE_GUIDE.md)

---

### ⚙️ Tiefe Spielsysteme

#### 📚 Skill System mit Datacards
- **7 Skills**: Mining, Refining, Combat, Trading, Engineering, Navigation, Autominer AI
- **Datacard-Requirement**: Ohne Datacard -20% Effizienz, +50% Energie!
- **Master Bonuses**: Skill-Level über Modul-Tier → bis zu +25% Effizienz
- **XP Progression**: Exponentielles Leveling durch Spielaktionen

#### 🔧 Crafting & Produktion
- **7-Tier Produktionskette**: Ore → Refined → Pure → Components → Complex → Modules → Ships
- **100+ Rezepte**: Von einfachen Platten bis zu kompletten Schiffen
- **Quality Gates**: High-Tier Items benötigen Pure Materials
- **Skill-Integration**: Höhere Skills = Effizientere Produktion
- **Station Requirements**: Advanced Crafting benötigt entsprechende Stationen

#### 🏭 Refinery System
- **2 Quality Levels**: Standard (verlustfrei) & Pure (30% Material Loss)
- **Skill-basiert**: Refining Skill erhöht Geschwindigkeit
- **Batch Processing**: Verarbeite große Mengen auf einmal

#### 🌡️ Temperature Management
- **Component-spezifische Limits**: CPU 95°C, Engines 150°C, Shields 120°C
- **Priority Cooling**: Hull hat 2x Kühlpriorität
- **Armor-Integration**: Bessere Armor = Höhere Hitzetoleranz
- **Heat Damage**: Überhitzung beschädigt Komponenten
- **Emergency Procedures**: Automatische Notfallkühlung

#### ⚡ Energy System
- **Power Grid Management**: Generatoren mit Tiers (T1-T6)
- **Priority-basiert**: CRITICAL → HIGH → MEDIUM → LOW
- **Overload Protection**: Automatische Load Balancing
- **Battery System**: Energie speichern für Spitzenlasten
- **Heat Integration**: Energieverbrauch generiert Wärme

#### 🚢 Station System
- **7 Station Types**: Outpost, Refinery, Factory, Advanced Factory, Shipyard, Trading Hub, Military Base
- **Docking**: Automatisches Andocken und Abfliegen
- **Services**: Crafting, Refining, Trading, Repair, Refit
- **Tier-basiert**: Höhere Station-Tiers ermöglichen komplexere Produktion

#### 📦 Cargo Specialization
- **4 Cargo Types**: GENERAL, ORE, LIQUID, CONTAINER
- **Compression Bonuses**: Ore Bays +50% Ore, Liquid Tanks +40% Liquids
- **Wrong-Type Penalty**: -30% Kapazität bei falschem Cargo-Typ

---

### 🎯 Performance & Skalierbarkeit

**Gebaut für massive Simulation:**
- **Frame Budget System**: 16.67ms für 60 FPS, max 2ms pro System
- **Batch Processing**: Max 100 Objekte pro Frame
- **Spatial Partitioning**: O(1) Proximity Queries statt O(n²)
- **Priority-based Updates**: 5 Update-Stufen (Critical bis Background)
- **Dirty Flags**: UI nur bei Änderungen updaten

**Bewiesene Performance:**
- **10.000 NPCs**: 52 FPS (< 0.5 FPS Impact)
- **Fleet Automation**: 100x Improvement (166ms → 1.66ms)
- **Selection System**: < 0.1ms Detection Time

**Siehe:** [Performance Guide](docs/wiki/performance/Manager.md)

---

## 📚 Dokumentation

### 🗂️ Vollständige Wiki-Datenbank

**[→ Zur kompletten Wiki](docs/wiki/INDEX.md)**

Die Wiki ist eine umfassende Wissensdatenbank mit Wikipedia-Style Cross-References:

#### Core Systems
- [Skill System](docs/wiki/systems/Skills.md) - Datacards, XP, Effizienz
- [Temperature System](docs/wiki/systems/Temperature.md) - Wärmemanagement
- [Energy System](docs/wiki/systems/Energy.md) - Power Grid
- [Crafting System](docs/wiki/systems/Crafting.md) - Produktionsketten
- [Refinery System](docs/wiki/systems/Refinery.md) - Erzverarbeitung
- [Station System](docs/wiki/systems/Stations.md) - Stationen & Services
- [Fleet Automation](docs/wiki/systems/Fleet.md) - Autominer AI
- [Cargo System](docs/wiki/systems/Cargo.md) - Frachtspezialisierung

#### AI & Automation
- [Automation Orchestrator](docs/wiki/automation/Orchestrator.md) - Zentrale AI-Steuerung
- [NPC Manager](docs/wiki/automation/NPCs.md) - 10.000+ NPC-Schiffe
- [Faction System](docs/wiki/automation/Factions.md) - Diplomatie
- [Command Hierarchy](docs/wiki/automation/Commands.md) - Flottenkommandos
- [Combat AI](docs/wiki/automation/Combat.md) - Kampf-KI
- [Patrol System](docs/wiki/automation/Patrols.md) - Patrouillen
- [Information Network](docs/wiki/automation/Information.md) - X4-Style Sensoren

### 📖 Guides & Referenzen
- **[CHANGELOG.md](CHANGELOG.md)** - Vollständige Versionshistorie
- **[Item Management Guidelines](docs/ITEM_MANAGEMENT_GUIDELINES.md)** - Item-Verwaltung & Guidelines
- **[ItemDatabase Performance](docs/ITEMDATABASE_PERFORMANCE_ANALYSIS.md)** - Performance-Analyse

### 📦 Archiv
- **[Documentation Archive](docs/archive/README.md)** - Alte/veraltete Dokumentation

---

## 🛠️ Installation & Setup

### Voraussetzungen
- **Godot 4.5+** ([Download](https://godotengine.org/download))
- **Git** für Versionskontrolle
- **4 GB RAM** minimum (8 GB empfohlen für 10.000 NPCs)

### Quick Start

```bash
# Repository klonen
git clone https://github.com/yourusername/SpaceGameDev.git
cd SpaceGameDev

# Godot öffnen
godot4 project.godot

# Oder direkt spielen
godot4 --path . scenes/Main.tscn
```

### Autoload Configuration

Folgende Autoloads müssen in **Project Settings → Autoload** eingetragen sein:

| Name | Pfad | Erforderlich |
|------|------|--------------|
| **ItemDatabase** | scripts/ItemDatabase.gd | **Ja** ⭐ |
| SkillManager | scripts/SkillSystem.gd | Ja |
| TemperatureSystem | scripts/TemperatureSystem.gd | Ja |
| EnergySystem | scripts/EnergySystem.gd | Ja |
| CraftingSystem | scripts/CraftingSystem.gd | Ja |
| RefinerySystem | scripts/RefinerySystem.gd | Ja |
| StationSystem | scripts/StationSystem.gd | Ja |
| FleetAutomationSystem | scripts/FleetAutomationSystem.gd | Ja |
| AutomationOrchestrator | scripts/automation/AutomationOrchestrator.gd | Ja |
| PerformanceManager | scripts/PerformanceManager.gd | Ja |
| TranslationManager | scripts/TranslationManager.gd | Ja |
| SelectionManager | scripts/SelectionManager.gd | Ja |

⭐ **Neu in v2.1**: Unified ItemDatabase mit 910+ Items (Ores, Minerals, Components, Weapons, Modules, Ships)

---

## 🎮 Spielanleitung

### Grundsteuerung
- **WASD** - Schiff bewegen
- **Mausrad** - Zoom
- **Mittlere Maustaste** - Kamera Pan (Free Camera)
- **Linksklick** - Objekt auswählen
- **Doppelklick** - Fokussieren / UI öffnen
- **Rechtsklick** - Kontext-Menü
- **Ctrl+Klick** - Multi-Select
- **Drag** - Box Select

### Erste Schritte

1. **Mining lernen**
   - Fliege zu Asteroiden
   - Mining Laser aktivieren (falls vorhanden)
   - Ore einsammeln
   - Mining XP verdienen

2. **Datacard kaufen**
   - Docke an Station an
   - Kaufe Mining Datacard
   - Ohne Datacard: -20% Effizienz!

3. **Refining**
   - Docke an Refinery-Station
   - Raffiniere Ore zu Minerals
   - Wähle Standard oder Pure Quality

4. **Crafting**
   - Nutze Crafting UI
   - Baue Components aus Minerals
   - Skill-Level erhöht Effizienz

5. **Flottenautomatisierung**
   - Kaufe Autominer AI Datacard
   - Installiere Autominer Chip in Schiff
   - Weise Mining-Gebiet zu
   - Schiff mined automatisch!

**Siehe:** [Getting Started Guide](docs/wiki/guides/GettingStarted.md)

---

## 🗺️ Roadmap

### ✅ Version 2.1 (Aktuell - 2025-11-19)
- ✅ **Unified ItemDatabase**: 910+ Items konsolidiert (Ores, Minerals, Components, Weapons, Modules, Ships)
- ✅ **Performance-optimiert**: Skaliert problemlos auf 2000+ Items
- ✅ **Copyright-Compliance**: Alle EVE Online/X4 Namen entfernt
- ✅ Komplettes Skill System
- ✅ Temperature & Energy Management
- ✅ 7-Tier Crafting Chain
- ✅ Station System mit 7 Typen
- ✅ Fleet Automation mit AI-Chips
- ✅ 10.000+ NPC Simulation
- ✅ X4-Inspired AI Framework
- ✅ Performance-Optimierung (60 FPS @ 10k NPCs)
- ✅ Vollständige Wiki-Dokumentation

### 🔄 Version 2.2 (Q1 2026)
- Diplomatie-UI für Faction Management
- Mission System Integration
- Dynamic Economy Simulation
- Advanced Pathfinding für Patrols
- Player-owned Stations (Basic)

### 📋 Version 2.3 (Q2 2026)
- Research & Technology Tree
- Advanced Ship Customization
- Modding Support (Resource-based)
- Trading UI Overhaul

### 🚀 Version 3.0 (Q3 2026)
- Campaign Mode mit Story
- Endgame Content
- Multiplayer Foundation (Experimental)
- Steam Integration

---

## 🏗️ Projektstruktur

```
SpaceGameDev/
├── docs/
│   ├── wiki/                           # Vollständige Wiki-Datenbank
│   │   ├── INDEX.md                    # Wiki-Hauptseite
│   │   ├── systems/                    # System-Dokumentation
│   │   ├── automation/                 # AI-Dokumentation
│   │   ├── mechanics/                  # Gameplay-Mechaniken
│   │   ├── reference/                  # Datenbanken
│   │   ├── performance/                # Performance-Guides
│   │   └── developer/                  # Developer-Docs
│   ├── archive/                        # 📦 Archivierte Dokumente
│   │   ├── implementation/
│   │   ├── analysis/
│   │   ├── planning/
│   │   └── obsolete/
│   ├── ITEM_MANAGEMENT_GUIDELINES.md   # ⭐ Item-Verwaltung
│   └── ITEMDATABASE_PERFORMANCE_ANALYSIS.md
├── scripts/
│   ├── ItemDatabase.gd                 # ⭐ 910+ Items (Unified DB)
│   ├── automation/                     # AI-Subsysteme
│   │   ├── AutomationOrchestrator.gd
│   │   ├── NPCManager.gd
│   │   ├── CombatAI.gd
│   │   ├── FactionSystem.gd
│   │   └── [...]
│   ├── SkillSystem.gd                  # Core Systems
│   ├── TemperatureSystem.gd
│   ├── EnergySystem.gd
│   ├── CraftingSystem.gd
│   ├── RefinerySystem.gd
│   ├── StationSystem.gd
│   ├── FleetAutomationSystem.gd
│   ├── PerformanceManager.gd
│   ├── SelectionManager.gd
│   ├── TranslationManager.gd
│   └── Main.gd
├── translations/
│   └── game_strings.csv                # EN/DE Übersetzungen
├── scenes/                             # Godot Scenes
├── assets/                             # Sprites, Audio
├── CHANGELOG.md                        # Versionshistorie
└── README.md                           # Diese Datei
```

---

## 📊 Technische Details

### Code Statistics (v2.0)
- **Total Lines of Code**: ~15.000
- **GDScript Files**: 35+
- **Implemented Systems**: 20+
- **UI Controllers**: 6
- **Wiki Pages**: 30+
- **Supported Languages**: 2 (EN/DE)
- **Translation Keys**: 200+

### Performance Benchmarks
- **10.000 NPCs**: < 0.5 FPS Impact bei 60 FPS
- **Fleet Automation**: 1.66ms für 10.000 Ships
- **UI Selection**: < 0.1ms Detection
- **Spatial Queries**: O(1) statt O(n²)

### Engine & Tools
- **Engine**: Godot 4.5+
- **Language**: GDScript 2.0
- **Version Control**: Git
- **Graphics**: Pixelart (128x128)
- **Target FPS**: 60 FPS @ 10.000+ Objects

---

## 🤝 Mitwirken

### Bug Reports
Bugs bitte als GitHub Issue melden mit:
- Godot Version
- Betriebssystem
- Schritte zur Reproduktion
- Erwartetes vs. tatsächliches Verhalten

### Feature Requests
Feature-Wünsche willkommen! Bitte prüfe zuerst die [Roadmap](#-roadmap).

### Pull Requests
1. Fork das Repository
2. Erstelle Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit deine Changes (`git commit -m 'Add AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne Pull Request

**Coding Standards:**
- Folge Godot GDScript Style Guide
- Kommentiere komplexe Logik
- Füge Wiki-Dokumentation für neue Features hinzu

---

## 📜 Lizenz

TBD (Privates Projekt, Lizenz folgt)

---

## 🙏 Danksagungen

**Inspiriert von:**
- **X4: Foundations** - Automation Framework, Information Network
- **Eve Online** - Wirtschaftssystem, Skill-System
- **Factorio** - Produktionsketten, Automation-Philosophie

**Built with:**
- [Godot Engine](https://godotengine.org/) - Open Source Game Engine
- [GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/) - Scripting Language

---

## 📞 Kontakt

- **GitHub**: [SpaceGameDev](https://github.com/yourusername/SpaceGameDev)
- **Discord**: TBD
- **Website**: TBD

---

**Version**: 2.1.0
**Status**: Production Ready
**Letztes Update**: 2025-11-19
**Godot Version**: 4.5+

**🌌 Viel Spaß beim Erkunden des Universums! 🚀**
