# 🚀 Feature Roadmap & Tracking

> **Letzte Aktualisierung:** 2025-11-15
> **Aktuelle Version:** v0.2
> **Nächste Version:** v0.3 (geplant)

---

## ✅ Implementierte Features (v0.2)

### 🎮 Core Gameplay
- ✅ **Autopilot System**
  - Doppelklick-Navigation zu Position
  - Automatisches Beschleunigen/Abbremsen
  - Orbit-Mechanik um Objekte
  - Hold Position Modus

- ✅ **Mining System**
  - 2 Miner Slots
  - 10-Sekunden Mining Cycles
  - Progress Bar Visualisierung
  - Auto-Mining Modus
  - Fuel Consumption beim Mining

- ✅ **Cargo System**
  - 6 separate Cargo Holds:
    - General Cargo (500 m³)
    - Ore Cargo (2000 m³)
    - Mineral Cargo (800 m³)
    - Ammo Cargo (300 m³)
    - Build Materials (600 m³)
    - Gas Cargo (1000 m³)
  - Eject Cargo into Space
  - Transfer Cargo zwischen Schiffen
  - Cargo Crates im Space

- ✅ **Collision & Physics**
  - Bounce Physics beim Aufprall
  - Energy Loss bei Kollisionen
  - Proper Collision Detection

### 🎯 Controls & UI
- ✅ **Radialmenü (12 Befehle)**
  - Fly To, Mine Ore, Orbit, Hold Position
  - Stop, Eject, Transfer, Scan
  - Activate, Target, Pickup, Cancel
  - Orbit Submenu mit 7 Distanz-Optionen

- ✅ **Kamera System**
  - Freie Kamera (F/HOME Taste)
  - WASD/Arrow Keys für Bewegung
  - Smooth Follow beim Spieler
  - Zoom mit Mausrad

- ✅ **Object List & Filtering**
  - Filter: All, Ships, Ores, Stations, Enemies
  - Distanz-Anzeige
  - Object Details Panel
  - Click to Select

- ✅ **Draggable Windows**
  - Cargo Window
  - Transfer UI
  - Eject UI
  - Alle Windows verschiebbar

### 📊 Ship Status & Info
- ✅ **Ship Status Display**
  - Speed, Shield, Armor
  - Hull Integrity, Electronics
  - Fuel Level
  - Autopilot Status

- ✅ **Developer Info Panel**
  - Performance Metrics
  - Debug Information
  - System Stats

### 💾 Save/Load System
- ✅ **SaveManager**
  - Multiple Save Slots
  - Auto-Save Funktionalität
  - Save Game Metadata
  - Load Game with Preview

- ✅ **Main Menu System**
  - New Game
  - Load Game
  - Options
  - Quit

### 🔊 Sound System
- ✅ **SoundManager Framework**
  - Music System mit Crossfade
  - SFX System mit Kategorien
  - 3D Positional Audio Support
  - Volume Control per Kategorie
  - Comprehensive Documentation

### 🌍 Localization
- ✅ **Multi-Language Support**
  - English (EN)
  - German (DE)
  - Easy to extend
  - Live Language Switching

### 👥 NPC System
- ✅ **NPC Ships**
  - Basic NPC Ship Framework
  - Cargo Transfer zu NPCs
  - NPC Ship Detection im Radialmenü

---

## 🔜 Geplante Features (v0.3 - Feature Batch 01)

### 🎯 Priorität: Must-have (In Entwicklung)

#### 🚀 Phase 1: Core Mechanics
- [ ] **[F1] Universelle Flug-/Bewegungsmechaniken**
  - Einheitliches Bewegungssystem für ALLE Schiffstypen
  - Acceleration, Max Speed, Turn Rate, Inertia
  - Basis-Klasse `BaseShip` mit Bewegungslogik
  - Stats aus JSON-Datenbank

- [ ] **[F2] Beschleunigung/Masse/Wendigkeit Überarbeitung**
  - Aktuelles Schiff beschleunigt zu langsam
  - Masse um 50% reduzieren (Testing)
  - Acceleration verdoppeln
  - Turn Rate +50%
  - Balancing durch Testing

- [ ] **[F4] Asteroid-Sichtbarkeit Fix**
  - BUG: Asteroid wird während Mining transparent
  - FIX: Bleibt voll sichtbar bis HP = 0
  - Instant Despawn bei HP = 0 (kein Fade)

- [ ] **[F7] Radialmenü-Bug Fix**
  - BUG: Radialmenü kann nur 1x geöffnet werden
  - FIX: Beliebig oft öffnen auf gleichem Objekt
  - State-Variable korrekt zurücksetzen

- [ ] **[F9] Kamera-Bewegung Fix**
  - BUG: Kamera-Pan mit mittlerer Maustaste + WASD funktioniert nicht
  - FIX: Eingabe-System komplett prüfen und reparieren

#### ⛏️ Phase 2: Mining System
- [ ] **[F3a] Multi-Module Parallel-Mining**
  - Focus-Modus: Alle Module → 1 Asteroid (2x Speed)
  - Spread-Modus: Jedes Modul → eigener Asteroid
  - Mix-Modus: Flexibel kombinieren
  - Manuelle und Auto-Zuweisung

- [ ] **[F3b] Mining-Queue System**
  - Liste mit mehreren Asteroiden nacheinander
  - Auto-Fly zum nächsten nach Completion
  - Reichweiten-Check (nur in Mining-Range)
  - UI: Queue-Liste mit Drag & Drop

- [ ] **[F3c] Auto-Target-System**
  - Automatische Asteroid-Auswahl
  - Kriterien: Entfernung (40%), Ore-Wert (30%), HP (20%), Qualität (10%)
  - Score-basierte Berechnung

- [ ] **[F3d] Asteroid-Direktauswahl**
  - Asteroid anklicken → Mining-Befehl direkt
  - Hotkey "M" für Mining starten
  - Integration mit Radialmenü

- [ ] **[F5] Asteroid-Rotation**
  - Zufällige Start-Rotation (0-360°)
  - Langsame Drehgeschwindigkeit (0.5-2.0°/s)
  - Visuell interessant, nicht schwindelerregend

- [ ] **[F6] Mining-Rotations-Änderung**
  - Zufällige Änderung bei jedem Mining-Cycle (0-5%)
  - Simuliert physikalische Reaktion

#### 📦 Phase 3: Cargo & UI
- [ ] **[F8] Taktische Übersicht - Kontextmenü**
  - Rechtsklick auf Objekt in Tactical Overlay
  - Befehle: Fliege hin (F), Orbitiere (O), Mining (M), Positioniere (P)
  - Erweiterbar für Schiffe, Stationen, alle Objekte

- [ ] **[F10] Intelligente Cargo-Zuweisung**
  - Automatische Item-Sortierung in korrekten Cargo-Typ
  - Whitelist-System (Kategorie → erlaubte Cargos)
  - Priorität-basiert (Spezial-Cargo vor General)
  - Fallback auf General-Cargo wenn voll

- [ ] **[F10a] Cargo-Type-Whitelist-Datenbank**
  - JSON-Datenbank definiert erlaubte Item-Kategorien
  - Pro Cargo-Typ: allowed_categories, priority, exclusive
  - Vollständige Cargo-Matrix (siehe Anhang)

- [ ] **[F11] Drag & Drop Cargo-Management**
  - Items zwischen Cargo-Räumen verschieben
  - Validation: Nur erlaubte Transfers
  - UI-Feedback: Grün = OK, Rot = Blocked
  - Tooltip erklärt warum

- [ ] **[F12a] Cargo-Item-Visualisierung Grid-Modus**
  - Icons 16x16px (skalierte Asteroid-Sprites)
  - Name unter Icon
  - Tooltip (2s Hover): Menge, Volumen, Wert
  - Sortierung: Name / Volumen / Wert

- [ ] **[F12b] Cargo-Item-Visualisierung List-Modus**
  - Spalten: Icon, Name, Menge, Volumen, Wert, Aktionen
  - Click Header = Sortierung
  - Rechtsklick = Kontextmenü

#### 💰 Phase 4: Wirtschafts-System
- [ ] **[F13a] Basis-Währung**
  - Credits (Cr) als Währung
  - Format: Ganzzahl (kein Komma)
  - Anzeige: 1K, 1M, 1B etc.

- [ ] **[F13b] Spieler-Geld-Limit**
  - Max 5 Milliarden Credits direkt bei Spieler
  - UI-Warnung bei Limit
  - Überschuss → Crypto-Wallet transferieren

- [ ] **[F13c] Crypto-Wallet Item**
  - Item (stackable), max 5 Mrd/Wallet
  - Volumen: 0.1 m³, Masse: 0.1 kg
  - Verlierbar bei Schiffszerstörung
  - Handelbar mit NPCs

- [ ] **[F13d] Stations-Konto-System**
  - Stationen haben eigenes Konto
  - Spieler → Station Transfer
  - Auto-Rücküberweisung ab Schwellenwert
  - Tresor-Module erhöhen Limit

- [ ] **[F13e] Handelszentrum-Mechanik**
  - Handelszentrum-Modul auf Station bauen
  - Preissetzung: Spieler-Preis / Marktpreis / Auto-Adjust
  - NPC-Verhalten basiert auf Preis-Verhältnis

#### 🔮 Phase 5: Advanced Features
- [ ] **[F14] Kredit-System**
  - Crypto-Wallet als Kredit an NPCs vergeben
  - Zinssatz und Zeitlimit setzen
  - Erfolgs-Wahrscheinlichkeit berechnet
  - Risk/Reward System

- [ ] **[F15a] Transporterstrahl: Versorgungs-Schiff**
  - Waffen/Munition → Flotten-Schiffe
  - Reichweite: 7.5 km (+50% Bonus)
  - Transfer-Rate: 200 kg/s (+100% Bonus)
  - Auto-Mode: Erkennt niedrige Munition

- [ ] **[F15b] Transporterstrahl: Mining-Operations-Schiff**
  - Ore von Minern → Self (Orca-Like)
  - Reichweite: 7.5 km
  - Transfer-Rate: 500 kg/s
  - Ore-Cargo-Bonus: +200%

### 🎯 Priorität: Nice-to-have (Backlog Batch 01)
- [ ] **[F3e] Sockel-System für Mining-Module**
  - Filter-Module in Sockel einstecken
  - Ore-Filter T3+, Quality-Filter Q3+, Type-Filter

- [ ] **[F15c] Weitere Transporterstrahl-Typen**
  - Logistik-Schiff (Komponenten)
  - Bau-Schiff (Bau-Items/Module)
  - Salvage-Schiff (Wrack-Loot)

---

## 🔜 Geplante Features (v0.4 - Mining Minigame System)

### 🎯 Priorität: Must-have (In Planung)

#### 🖥️ Permanent Info Panel UI
- [ ] **Permanent Info Panel**
  - 25% Bildschirmhöhe (270px bei 1080p)
  - 100% Bildschirmbreite (1920px bei 1080p)
  - Immer sichtbar (nicht ausblendbar)
  - 4-Spalten-Layout: 15% / 35% / 35% / 15%
  - Anchor: Bottom Wide (wächst nach oben)

- [ ] **Spalte 1: History & Events (15%, fest)**
  - History Log (60%): Letzte Aktionen/Events
  - World Events (40%): PvP-Zonen, Market-Trends, Alerts
  - Scrollbar für History
  - Auto-Update alle 5 Sekunden

- [ ] **Spalte 2+3: Selectable Content Panels (je 35%)**
  - Dropdown-Auswahl für Panel-Content
  - 6 Panel-Optionen:
    1. Mining Scanner (4 Circles)
    2. Spectral Scan (1 großer Circle)
    3. Quality Distribution Graph
    4. Cargo Overview Summary
    5. Ship Module Status
    6. Tactical Situation Display
  - Unabhängige Auswahl pro Spalte
  - Kann gleichen Content doppelt zeigen

- [ ] **Spalte 4: Reiter-System (15%)**
  - 5 Tabs mit F1-F5 Hotkeys:
    - **F1: Mining** - Mining-Kontrollen, Scanner-Auswahl
    - **F2: Cargo** - Cargo-Räume öffnen, Eject
    - **F3: Ship** - Module, Repair, Refuel, Fittings
    - **F4: Target** - Target-Info, Befehle (Scan, Mine, Orbit, Fly To)
    - **F5: Tactical** - D-Scan, Overview, Fleet, Bookmarks
  - Permanent Ship Status (unten, immer sichtbar)
  - Context-specific Buttons pro Tab

- [ ] **Panel Pop-Out System**
  - Rechtsklick auf Panel-Titel → "Pop Out Window"
  - Panel wird eigenständiges, verschiebbares Fenster
  - Ideal für Multi-Monitor-Setups
  - Kann wieder zurück gedockt werden

#### ⛏️ Mining Scanner System
- [ ] **Quality-Tier System**
  - 6 Quality-Tiers: Q0 (Schrott) bis Q5 (Perfekt)
  - Prozentuale Verteilung pro Asteroid
  - Wert steigt exponentiell mit Quality (Q5 = 10x Q0)
  - Visuelle Farben: Rot (Q0) → Gold (Q5)

- [ ] **Scanner-Module (Mk1-Mk5)**
  - Zeigen Quality-Verteilung als konzentrische Kreise
  - Visibility: Wie viele Tiers sichtbar sind (2-6)
  - Quality-Shift: Verschiebt Verteilung nach oben (+0 bis +2)
  - Scan-Time: 3.0s - 5.0s
  - Scan-Range: 150m - 250m
  - Energie-Verbrauch: 10 - 35 GJ
  - CPU/Powergrid-Anforderungen

- [ ] **Scanner-Display Varianten**
  - **4-Circle Display:** 4 Scanner gleichzeitig (Quadrant-Layout)
  - **Spectral Scan:** 1 großer Scanner-Kreis mit Details
  - **Quality Graph:** Balkendiagramm für alle 6 Tiers
  - Echtzeit-Update bei Scan
  - Color-Coded (Rot/Grau/Blau/Grün/Gelb/Gold)

- [ ] **Quality-Shift Mechanik**
  - Verschiebt Wahrscheinlichkeitsverteilung
  - +1 Shift = +10% Chance auf höhere Quality
  - +2 Shift = +20% Chance
  - Maximum: +4 Shift (Scanner +2, Socket +2)
  - Berechnung mit apply_quality_shift()

#### 🔧 Mining Module System
- [ ] **Scanner-Module (5 Stufen)**
  - Mk1: Basic Scanner (Q0-Q1, kein Shift, 5000 Cr)
  - Mk2: Advanced Scanner (Q0-Q2, kein Shift, 25k Cr)
  - Mk3: Professional Scanner (Q0-Q3, kein Shift, 75k Cr)
  - Mk4: Elite Scanner (Q0-Q4, +1 Shift, 250k Cr)
  - Mk5: Quantum Scanner (Q0-Q5, +2 Shift, 1M Cr)

- [ ] **Socket-Module**
  - Visibility Amplifier (+1 Tier Sichtbarkeit, 50k Cr)
  - Quality Amplifier (+1 Quality-Shift, 125k Cr)
  - Range Extender (+50% Scan-Range, 75k Cr)
  - Speed Optimizer (-30% Scan-Time, 90k Cr)
  - Quantum Resonator (+1 Visibility, +2 Shift, 750k Cr)

- [ ] **Stabilizer-Module (Auto-Mining)**
  - Mk1: 70% Effizienz, Auto-Target (100k Cr)
  - Mk2: 80% Effizienz, Quality-Aware (250k Cr)
  - Mk3: 90% Effizienz, Cycle-Optimization (500k Cr)
  - Mk4: 95% Effizienz, Cargo-Management (1.25M Cr)
  - Mk5: 100% Effizienz, AI-Learning (3M Cr)

- [ ] **Operator-Module (Extraction Bonus)**
  - Mk1: +5% Quality, +10% Yield (75k Cr)
  - Mk2: +10% Quality, +20% Yield, -5% Cycle (200k Cr)
  - Mk3: +15% Quality, +30% Yield, -10% Cycle (500k Cr)
  - Mk4: +20% Quality, +40% Yield, -20% Cycle (1.5M Cr)
  - Mk5: +25% Quality, +50% Yield, -30% Cycle, Guaranteed Tier-Up (3.5M Cr)

- [ ] **Module Database System**
  - JSON-Datei: res://data/mining_modules.json
  - MiningModuleDatabase.gd Autoload
  - get_module(module_id), get_modules_by_category()
  - CPU/Powergrid-Validierung

- [ ] **Module Equip System**
  - equip_module(module_id, slot) in Player.gd
  - Skill-Requirements Check
  - CPU/Powergrid-Limit Check
  - Unequip/Swap-Logik
  - Fitting Window UI

#### 📊 Content Panels (Spalte 2+3)
- [ ] **Mining Scanner 4-Circles Panel**
  - 4 Scanner in 2x2 Grid
  - Jeder Scanner zeigt eigene Quality-Verteilung
  - Click to select active Scanner
  - Echtzeitupdate während Mining

- [ ] **Spectral Scan Panel**
  - 1 großer Scanner-Kreis (centered)
  - Detaillierte Prozentanzeige pro Tier
  - Target-Info: Name, Tier, Distance
  - Scan/Mine-Buttons

- [ ] **Quality Distribution Graph Panel**
  - Balkendiagramm (Q0-Q5)
  - Y-Achse: Prozent (0-100%)
  - Color-Coded Bars
  - Hover-Tooltip mit exakten Werten

- [ ] **Cargo Overview Panel**
  - Zusammenfassung aller 6 Cargo-Räume
  - Pro Cargo: Used/Capacity, %
  - Top 3 Items pro Cargo
  - Quick-Open Buttons

- [ ] **Ship Module Status Panel**
  - Mining Modules: Progress Bars
  - Scanners: Online/Offline Status
  - Energy: Aktuell/Max
  - Hull/Shield Bars

- [ ] **Tactical Situation Panel**
  - Nearby Ships: Count + List (mit Distanz)
  - Asteroids in Range: Count
  - Station Distance
  - Threat Level: LOW/MEDIUM/HIGH/CRITICAL

#### 🔀 Advanced Mining Mechanics
- [ ] **Auto-Target-System mit Quality-Shift**
  - Berücksichtigt Quality-Shift bei Scoring
  - Höhere Priority für high-quality Asteroids
  - Configurable Weights (Distance, Tier, HP, Quality)

- [ ] **Manual Quality Selection**
  - Während Mining-Cycle: Click auf Quality-Kreis
  - Wählt Target-Quality für Extraction
  - Visual Highlight des gewählten Tiers

- [ ] **Extraction mit Operator-Bonus**
  - Quality-Boost: Chance auf höheres Tier
  - Yield-Increase: Mehr Erz pro Cycle
  - Cycle-Speed: Schnellere Mining-Cycles
  - Special Effects: Guaranteed Tier-Up (Mk5)

- [ ] **Stabilizer Auto-Mining**
  - Vollautomatisches Mining ohne Input
  - Auto-Target → Auto-Scan → Auto-Mine → Auto-Extract
  - Auto-Cargo-Management (Eject Low Quality)
  - AI-Learning (Mk5): Optimiert sich selbst

#### 🎨 Visual Feedback Systems
- [ ] **Scanner Circle Rendering**
  - Konzentrische Kreise mit CanvasItem
  - Color-Gradient pro Tier
  - Animierte Glow-Effekte
  - Hover-Highlight

- [ ] **Quality Tier Colors**
  - Q0: Rot (#FF0000)
  - Q1: Grau (#888888)
  - Q2: Blau (#0088FF)
  - Q3: Grün (#00FF00)
  - Q4: Dunkelgelb (#FFAA00)
  - Q5: Gold (#FFD700)

- [ ] **Mining Progress Visualization**
  - Circular Progress Bar um Scanner
  - Percentage Text (0-100%)
  - Color-Change bei Quality-Selection
  - Pulsing Animation bei Extraction

### 🎯 Priorität: Hoch (Future Batches)

#### Combat System
- [ ] **Waffen System**
  - Verschiedene Waffentypen
  - Targeting System
  - Damage Calculation
  - Shield/Armor Mechanics

- [ ] **Feindliche NPCs**
  - AI-gesteuerte Gegner
  - Different Difficulty Levels
  - Loot Drops

#### Stations & Trading
- [ ] **Space Stations**
  - Station Docking
  - Trading System
  - Repair/Refuel Services
  - Mission Board

- [ ] **Economy System (Advanced)**
  - Dynamische Preise
  - Supply & Demand
  - Market Interface

### 🎯 Priorität: Mittel

#### Erweiterte Gameplay Mechanics
- [ ] **Crafting/Refining System**
  - Ore → Mineral Raffination
  - Schiff Upgrades
  - Module Crafting

- [ ] **Skills & Progression**
  - Skill Tree
  - Experience System
  - Skill Bonuses (Mining Speed, etc.)

- [ ] **Mission System**
  - Quest Types (Mining, Combat, Delivery)
  - Quest Rewards
  - Story Missions

#### UI/UX Improvements
- [ ] **Minimap/Radar**
  - Local Area Radar
  - Object Icons
  - Zoom Levels

- [ ] **Enhanced Cargo Management**
  - Quick Transfer Presets
  - Cargo Sorting/Filtering
  - Auto-Eject bei vollem Lager

- [ ] **Ship Customization UI**
  - Ship Loadout Screen
  - Module Installation
  - Ship Painting/Cosmetics

### 🎯 Priorität: Niedrig

#### Quality of Life
- [ ] **Keybind Customization**
  - Custom Control Mapping
  - Save/Load Keybinds

- [ ] **Graphics Settings**
  - Quality Presets
  - VSync, FPS Limit
  - Particle Effects Toggle

- [ ] **Tutorial System**
  - Interactive Tutorial
  - Tooltips
  - Help System

#### Advanced Features
- [ ] **Multiplayer (Langfristig)**
  - Co-op Mining
  - PvP Combat
  - Shared Economy

- [ ] **Procedural Generation**
  - Procedural Asteroids
  - Random Events
  - Dynamic Universe

---

## 💡 Feature Ideas (Backlog)

Ideen die noch nicht priorisiert sind:

- **Warp Gates** - Fast Travel zwischen Sektoren
- **Ship Classes** - Verschiedene Schiffstypen (Frigate, Hauler, Fighter)
- **Faction System** - Verschiedene Fraktionen mit Reputation
- **Mining Laser Upgrades** - Verschiedene Laser-Typen
- **Asteroid Types** - Verschiedene Asteroid-Varianten
- **Weather Effects** - Nebel, Asteroidenfelder, etc.
- **Ship Damage Model** - Subsystem Damage
- **Autopilot Waypoints** - Multi-Point Navigation
- **Screenshot Mode** - Camera Controls für Screenshots
- **Achievement System** - Steam Achievements / Ingame

---

## 📝 Feature Request Template

Um ein neues Feature vorzuschlagen, erstelle ein [GitHub Issue](https://github.com/jacobpHMS/SpaceGameDev/issues/new?template=feature_request.md) mit dem Feature Request Template.

**Oder füge es direkt hier ein:**

```markdown
### [FEATURE] Titel des Features

**Priorität:** Must-have / Should-have / Nice-to-have / Optional

**Beschreibung:**
[Was soll das Feature tun?]

**Motivation:**
[Warum ist das Feature wichtig?]

**Vorschlag:**
[Wie könnte es implementiert werden?]

**Nutzen:**
- [ ] Verbessert Gameplay
- [ ] Verbessert Performance
- [ ] Verbessert UI/UX
- [ ] Fügt Content hinzu

**Geschätzte Komplexität:** Niedrig / Mittel / Hoch

**Version:** [In welcher Version soll es kommen? z.B. v0.3]
```

---

## 📊 Feature Statistik

**Implementiert (v0.2):** 45+ Features
**Geplant (v0.3):** 15 Features
**Backlog:** 12 Ideen

**Completion Rate v0.2:** 100%
**In Entwicklung:** 0

---

## 🗓️ Release Timeline

| Version | Release Datum | Status | Features |
|---------|---------------|--------|----------|
| v0.1 | 2025-11-10 | ✅ Released | Core Mechanics, Basic Mining |
| v0.2 | 2025-11-15 | ✅ Released | Full UI, Save/Load, Cargo System |
| v0.3 | TBD | 🔜 Geplant | Combat, Stations, Trading |
| v0.4 | TBD | 💭 Konzept | Crafting, Missions, Progression |

---

*Diese Datei wird regelmäßig aktualisiert. Bei Feature-Ideen bitte GitHub Issue erstellen oder direkt hier eintragen.*
