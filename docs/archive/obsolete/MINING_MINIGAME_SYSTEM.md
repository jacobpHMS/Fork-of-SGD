# Mining Minigame System - Complete Specification

## Übersicht

Das Mining-System ist ein komplexes Minigame, das es Spielern ermöglicht, Erze aus Asteroiden zu extrahieren. Das System basiert auf:
- **Scanner-Module** zur Erkennung von Qualitätsbereichen
- **Quality-Shift-Mechanik** zur Verschiebung der Qualitätsverteilung
- **Timing-basierte Extraktionscycles**
- **Modulare Ausrüstung** für verschiedene Strategien

## Quality-Tier System

### Quality Tiers (Q0 - Q5)
- **Q0:** Schrott (0-10% Wert)
- **Q1:** Niedrig (10-30% Wert)
- **Q2:** Standard (30-50% Wert)
- **Q3:** Gut (50-70% Wert)
- **Q4:** Hoch (70-90% Wert)
- **Q5:** Perfekt (90-100% Wert)

### Verteilung in Asteroiden
Jeder Asteroid hat eine Qualitätsverteilung:
```gdscript
# Beispiel: T4 Asteroid (Metalite)
var quality_distribution = {
    "Q0": 5.0,   # 5%
    "Q1": 15.0,  # 15%
    "Q2": 35.0,  # 35%
    "Q3": 30.0,  # 30%
    "Q4": 12.0,  # 12%
    "Q5": 3.0    # 3%
}
```

## Scanner-Module

### Funktionsweise
Scanner-Module zeigen die Qualitätsverteilung als **konzentrische Kreise** an. Jeder Kreis repräsentiert einen Quality-Tier.

### Scanner-Eigenschaften
1. **Visibility (Sichtbarkeit):** Wie viele Quality-Tiers der Scanner zeigen kann
   - Scanner Mk1: 2 Tiers (Q0, Q1)
   - Scanner Mk2: 3 Tiers (Q0, Q1, Q2)
   - Scanner Mk3: 4 Tiers (Q0-Q3)
   - Scanner Mk4: 5 Tiers (Q0-Q4)
   - Scanner Mk5: 6 Tiers (Q0-Q5)

2. **Quality-Shift:** Verschiebt die Wahrscheinlichkeitsverteilung
   - Shift +1: Erhöht Chance auf höhere Quality um 10%
   - Shift +2: Erhöht Chance auf höhere Quality um 20%
   - Shift -1: Senkt Quality (für schnelleres Mining)

### Visuelle Darstellung
```
Scanner-Display (konzentrische Kreise):

        ┌─────────────┐
        │             │  Q5 (3%)  - Innerster Kreis (Gold)
        │   ┌─────┐   │  Q4 (12%) - Dunkelgelb
        │   │ ┌─┐ │   │  Q3 (30%) - Grün
        │   │ │ │ │   │  Q2 (35%) - Blau
        │   │ └─┘ │   │  Q1 (15%) - Grau
        │   └─────┘   │  Q0 (5%)  - Rot (äußerster Kreis)
        └─────────────┘

Kreisgröße = Prozentuale Menge
Farbe = Quality-Tier
```

## Socket-Module

### Funktion
Socket-Module verstärken oder verändern Scanner-Eigenschaften:
- **Visibility Boost:** +1 Tier Sichtbarkeit
- **Quality Shift:** Verschiebt Verteilung nach oben/unten
- **Scan Speed:** Reduziert Scan-Zeit
- **Range Extension:** Erhöht Scan-Reichweite

### Beispiel-Kombination
```
Scanner Mk3 (zeigt Q0-Q3)
+ Socket "Quality Amplifier" (+1 Quality-Shift)
= Zeigt Q0-Q3 mit 10% höherer Chance auf Q3-Q4
```

## Stabilizer-Module

### Funktion
Stabilizer ermöglichen **automatisches Mining** ohne manuelle Interaktion:
- **Auto-Target:** Wählt automatisch besten Asteroid
- **Auto-Cycle:** Startet Mining-Cycles automatisch
- **Auto-Extract:** Extrahiert automatisch bei bestem Quality-Tier

### Effizienz-Verlust
Automatisches Mining ist weniger effizient als manuell:
- Stabilizer Mk1: 70% Effizienz
- Stabilizer Mk2: 80% Effizienz
- Stabilizer Mk3: 90% Effizienz
- Stabilizer Mk4: 95% Effizienz
- Stabilizer Mk5: 100% Effizienz (kein Verlust)

## Operator-Module

### Funktion
Operator-Module verbessern die **Extraktionsqualität**:
- **Quality Boost:** +5% bis +25% höhere Quality beim Extraction
- **Yield Increase:** +10% bis +50% mehr Erz pro Cycle
- **Cycle Speed:** -10% bis -30% schnellere Mining-Cycles

### High-End Operator
```
Operator "Quantum Extractor" (Mk5):
- Quality Boost: +25%
- Yield Increase: +50%
- Cycle Speed: -30%
- Energieverbrauch: +200%
```

## Mining-Prozess (Manuell)

### Schritt-für-Schritt
1. **Asteroid scannen**
   - Rechtsklick auf Asteroid → "Scan Ore"
   - Scanner zeigt Quality-Verteilung als Kreise

2. **Mining starten**
   - Rechtsklick → "Mine Ore" oder Hotkey "M"
   - Schiff fliegt zu Asteroid (Auto-Pilot)

3. **Quality-Tier wählen**
   - Während Mining-Cycle: Klick auf gewünschten Quality-Kreis
   - Je höher Quality, desto wertvoller das Erz

4. **Extraction ausführen**
   - Nach 30 Sekunden (standard cycle time) wird Erz extrahiert
   - Quality basiert auf gewähltem Tier + Operator-Bonus

5. **Wiederholen**
   - Bis Asteroid erschöpft oder Cargo voll

## Mining-Prozess (Automatisch mit Stabilizer)

```gdscript
# Stabilizer-Logik
func auto_mining_cycle():
    # 1. Scan Asteroid
    var quality_distribution = scan_asteroid(target_asteroid)

    # 2. Wähle besten verfügbaren Quality-Tier
    var best_tier = find_best_quality_tier(quality_distribution)

    # 3. Starte Mining
    start_mining_cycle(best_tier)

    # 4. Warte auf Cycle-Abschluss
    await get_tree().create_timer(mining_cycle_time).timeout

    # 5. Extrahiere mit Effizienz-Verlust
    var extracted = extract_ore(best_tier, stabilizer_efficiency)

    # 6. Wiederhole
    if target_asteroid.amount > 0 and cargo_space_available():
        auto_mining_cycle()
```

## UI-Layout: Permanent Info Panel

### Gesamtstruktur
```
┌───────────────────────────────────────────────────────────────────┐
│                    Hauptspiel-Viewport (75% Höhe)                 │
│                                                                   │
│                  (Weltansicht, Schiffe, Asteroiden)               │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
┌───────────────────────────────────────────────────────────────────┐
│              Permanent Info Panel (25% Höhe = 270px)              │
├────────┬──────────────────────┬──────────────────────┬────────────┤
│ Col 1  │       Col 2          │       Col 3          │   Col 4    │
│ 15%    │       35%            │       35%            │   15%      │
│ (288px)│      (672px)         │      (672px)         │  (288px)   │
└────────┴──────────────────────┴──────────────────────┴────────────┘
```

### Spalte 1: History & Events (FEST)
```
┌─────────────────────┐
│ History (60%)       │
│ ───────────────────│
│ [15:43] Mining +15kg│
│ [15:42] Ore depleted│
│ [15:40] Autopilot OK│
│ [15:38] Cargo 45%   │
│ ...                 │
├─────────────────────┤
│ World Events (40%)  │
│ ───────────────────│
│ 🔴 PvP Zone aktiv  │
│ 💰 Market: Ore +5% │
│ ⚠️  Station Attack  │
└─────────────────────┘
```

### Spalte 2 & 3: Selectable Content Panels

#### Option 1: Mining Scanner (4 Circles)
```
┌──────────────────────────────────┐
│  Mining Scanner - 4 Circles      │
├────────────┬─────────────────────┤
│  Circle 1  │    Circle 2         │
│            │                     │
│  Scanner A │    Scanner B        │
│  Q0-Q5     │    Q0-Q5            │
├────────────┼─────────────────────┤
│  Circle 3  │    Circle 4         │
│            │                     │
│  Scanner C │    Scanner D        │
│  Q0-Q5     │    Q0-Q5            │
└────────────┴─────────────────────┘
```

#### Option 2: Spectral Scan (1 Circle groß)
```
┌──────────────────────────────────┐
│     Spectral Analysis            │
│                                  │
│        ┌─────────────┐          │
│        │             │           │
│        │   Q5 (3%)   │           │
│        │   Q4 (12%)  │           │
│        │   Q3 (30%)  │           │
│        │   Q2 (35%)  │           │
│        │   Q1 (15%)  │           │
│        │   Q0 (5%)   │           │
│        └─────────────┘           │
│                                  │
│  Target: Metalite T4 Asteroid    │
└──────────────────────────────────┘
```

#### Option 3: Quality Distribution Graph
```
┌──────────────────────────────────┐
│   Quality Distribution Graph     │
│                                  │
│  %│                              │
│ 40│      ████                    │
│ 35│    ██████                    │
│ 30│    ██████  ████              │
│ 25│    ██████  ████              │
│ 20│    ██████  ████              │
│ 15│  ████████  ████              │
│ 10│  ████████  ████  ██          │
│  5│████████████████████  ██      │
│  0└─Q0──Q1──Q2──Q3──Q4──Q5──     │
└──────────────────────────────────┘
```

#### Option 4: Cargo Overview
```
┌──────────────────────────────────┐
│      Cargo Hold Summary          │
├──────────────────────────────────┤
│ Ore Cargo:      450 / 1000 m³   │
│ ├─ Ferralite Q3:    150 kg      │
│ ├─ Metalite Q4:     200 kg      │
│ └─ Pyrite Q2:       100 kg      │
│                                  │
│ General Cargo:  200 / 500 m³    │
│ ├─ Ammo:            50 units    │
│ └─ Repair Kits:     10 units    │
│                                  │
│ Gas Cargo:      0 / 300 m³      │
└──────────────────────────────────┘
```

#### Option 5: Ship Module Status
```
┌──────────────────────────────────┐
│      Ship Modules Status         │
├──────────────────────────────────┤
│ Mining:                          │
│ ├─ Miner 1: ████████░░ 80%      │
│ └─ Miner 2: ██████░░░░ 60%      │
│                                  │
│ Scanners:                        │
│ ├─ Scanner A: ██████████ 100%   │
│ ├─ Scanner B: ████████░░ 80%    │
│ ├─ Scanner C: OFFLINE            │
│ └─ Scanner D: ██████░░░░ 60%    │
│                                  │
│ Energy: 850 / 1000 GJ            │
│ Hull: ████████████ 100%          │
└──────────────────────────────────┘
```

#### Option 6: Tactical Display
```
┌──────────────────────────────────┐
│       Tactical Situation         │
├──────────────────────────────────┤
│ Nearby Ships: 3                  │
│ ├─ Miner (Friendly) - 450m       │
│ ├─ Trader (Neutral) - 1200m      │
│ └─ Pirate (Hostile) - 2500m      │
│                                  │
│ Asteroids in Range: 12           │
│ Station Distance: 15.3 km        │
│                                  │
│ Threat Level: █░░░░ LOW          │
└──────────────────────────────────┘
```

### Spalte 4: Reiter-System (Tab System)

```
┌─────────────────────┐
│ ┌─┬─┬─┬─┬─┐         │
│ │M│C│S│T│Y│ Tabs    │
│ └─┴─┴─┴─┴─┘         │
├─────────────────────┤
│                     │
│  [Active Panel]     │
│                     │
│  Context-specific   │
│  buttons and info   │
│                     │
│  based on selected  │
│  tab                │
│                     │
├─────────────────────┤
│ Ship Status (fest)  │
│ Status: Mining      │
│ Speed: 0.0 m/s      │
│ Energy: 85%         │
└─────────────────────┘
```

#### Tab 1: Mining (F1)
```
┌─────────────────────┐
│ [Start Mining]      │
│ [Stop Mining]       │
│ [Auto-Target]       │
│ [Scan Asteroid]     │
│ ────────────────── │
│ Miner 1: Active     │
│ Miner 2: Active     │
│ ────────────────── │
│ Cycle: 65%          │
│ Quality: Q3 Target  │
└─────────────────────┘
```

#### Tab 2: Cargo (F2)
```
┌─────────────────────┐
│ [Open Ore Cargo]    │
│ [Open General]      │
│ [Open Gas]          │
│ [Eject Items]       │
│ ────────────────── │
│ Total: 650/1800 m³  │
│ Ore: 45%            │
│ General: 40%        │
│ Gas: 0%             │
└─────────────────────┘
```

#### Tab 3: Ship (F3)
```
┌─────────────────────┐
│ [Modules]           │
│ [Fittings]          │
│ [Repair]            │
│ [Refuel]            │
│ ────────────────── │
│ Hull: 100%          │
│ Shield: 100%        │
│ Energy: 85%         │
│ Fuel: 450/500       │
└─────────────────────┘
```

#### Tab 4: Target (F4)
```
┌─────────────────────┐
│ Target: Asteroid    │
│ Name: Metalite T4   │
│ Distance: 50m       │
│ ────────────────── │
│ [Scan]              │
│ [Mine]              │
│ [Orbit]             │
│ [Fly To]            │
│ ────────────────── │
│ HP: ██████░ 60%     │
└─────────────────────┘
```

#### Tab 5: Tactical (F5)
```
┌─────────────────────┐
│ [D-Scan]            │
│ [Overview]          │
│ [Fleet]             │
│ [Bookmarks]         │
│ ────────────────── │
│ Threats: 0          │
│ Friendlies: 2       │
│ Neutrals: 5         │
│ Unknown: 1          │
└─────────────────────┘
```

## Panel-Auswahl (Dropdown)

### Spalte 2 & 3 Dropdown-Menü
```
┌───────────────────────────────┐
│ Panel wählen:            [▼] │
├───────────────────────────────┤
│ ✓ Mining Scanner (4 Circles)  │
│   Spectral Scan (1 Circle)    │
│   Quality Distribution        │
│   Cargo Overview              │
│   Ship Modules                │
│   Tactical Display            │
└───────────────────────────────┘
```

## Panel Pop-Out System

### Funktion
Jedes Panel in Spalte 2/3 kann als **eigenständiges Fenster** ausgedockt werden:
- Rechtsklick auf Panel-Titel
- Option: "Pop Out Window"
- Panel wird als eigenständiges, verschiebbares Fenster geöffnet
- Ideal für Multi-Monitor-Setups

### Beispiel
```gdscript
func _on_panel_popout_requested(panel_content: Control):
    # Create floating window
    var window = FloatingWindow.new()
    window.title = panel_content.get_panel_title()
    window.size = Vector2(800, 600)

    # Move content to window
    panel_content.reparent(window.content_container)

    # Add to UI layer
    get_tree().root.add_child(window)
```

## Technische Implementierung

### Scene-Struktur
```
PermanentInfoPanel.tscn
├─ HBoxContainer (4 columns)
│  ├─ Column1 (15% - History & Events)
│  │  ├─ VBoxContainer
│  │  │  ├─ HistoryLog (60%)
│  │  │  └─ WorldEvents (40%)
│  │
│  ├─ Column2 (35% - Selectable Panel)
│  │  ├─ PanelSelector (OptionButton)
│  │  └─ ContentContainer
│  │     ├─ MiningScanner4Circles
│  │     ├─ SpectralScan
│  │     ├─ QualityGraph
│  │     ├─ CargoOverview
│  │     ├─ ShipModules
│  │     └─ TacticalDisplay
│  │
│  ├─ Column3 (35% - Selectable Panel)
│  │  ├─ PanelSelector (OptionButton)
│  │  └─ ContentContainer (same options as Column2)
│  │
│  └─ Column4 (15% - Reiter-System)
│     ├─ TabContainer (F1-F5)
│     │  ├─ Mining (F1)
│     │  ├─ Cargo (F2)
│     │  ├─ Ship (F3)
│     │  ├─ Target (F4)
│     │  └─ Tactical (F5)
│     └─ ShipStatus (always visible at bottom)
```

### Godot Scene Settings
```
# PermanentInfoPanel.tscn Root Node
Type: PanelContainer
Custom Minimum Size: (1920, 270)
Anchor Preset: Bottom Wide
Grow Direction: Begin (wächst nach oben)

# Column Layout
Type: HBoxContainer
Size Flags: Expand Fill
Columns:
- Column1: size_flags_stretch_ratio = 0.15
- Column2: size_flags_stretch_ratio = 0.35
- Column3: size_flags_stretch_ratio = 0.35
- Column4: size_flags_stretch_ratio = 0.15
```

## Quality-Shift Mechanik (Detailliert)

### Berechnung
```gdscript
func apply_quality_shift(base_distribution: Dictionary, shift_value: int) -> Dictionary:
    var shifted = {}

    for tier in base_distribution.keys():
        var tier_num = int(tier.substr(1, 1))  # "Q3" -> 3

        # Shift probability to higher tier
        if shift_value > 0:
            var shift_amount = base_distribution[tier] * (shift_value * 0.1)
            var target_tier = "Q" + str(min(tier_num + 1, 5))

            shifted[tier] = base_distribution[tier] - shift_amount
            shifted[target_tier] = shifted.get(target_tier, 0) + shift_amount

        # Shift probability to lower tier
        elif shift_value < 0:
            var shift_amount = base_distribution[tier] * (abs(shift_value) * 0.1)
            var target_tier = "Q" + str(max(tier_num - 1, 0))

            shifted[tier] = base_distribution[tier] - shift_amount
            shifted[target_tier] = shifted.get(target_tier, 0) + shift_amount

        else:
            shifted[tier] = base_distribution[tier]

    return shifted
```

### Beispiel
```
Base Distribution:
Q0: 5%, Q1: 15%, Q2: 35%, Q3: 30%, Q4: 12%, Q5: 3%

Mit Quality-Shift +2 (20%):
Q0: 4%  (1% verschoben zu Q1)
Q1: 13% (2% verschoben zu Q2, 1% erhalten von Q0)
Q2: 28% (7% verschoben zu Q3, 2% erhalten von Q1)
Q3: 30% (6% verschoben zu Q4, 7% erhalten von Q2)
Q4: 14% (2.4% verschoben zu Q5, 6% erhalten von Q3)
Q5: 5.4% (2.4% erhalten von Q4)
```

## Integration mit bestehenden Systemen

### Player.gd Integration
```gdscript
# Mining mit Scanner-Daten
func start_mining_with_scanner(scanner_id: int, target_quality: String):
    var scanner_data = get_scanner_module(scanner_id)

    # Quality-Shift anwenden
    var shifted_distribution = apply_quality_shift(
        target_ore.quality_distribution,
        scanner_data["quality_shift"]
    )

    # Mining-Cycle starten
    current_mining_target_quality = target_quality
    mining_cycle_progress = 0.0
    miner_1_active = true
```

### DragManager Integration
```gdscript
# Drag & Drop für Scanner-Module
func _on_scanner_slot_dropped(drag_data: Dictionary) -> bool:
    if drag_data["item_type"] != "scanner_module":
        return false

    var scanner_id = drag_data["item_id"]
    var slot_index = drag_data["target_slot"]

    # Equip scanner
    player.equip_scanner_module(slot_index, scanner_id)
    return true
```

## Zusammenfassung

Dieses System bietet:
1. ✅ **Tiefes Mining-Minigame** mit strategischen Entscheidungen
2. ✅ **Modulares Scanner-System** mit Quality-Shift
3. ✅ **Flexibles UI-Layout** mit 4 Spalten
4. ✅ **Reiter-System** für verschiedene Spielbereiche
5. ✅ **Panel Pop-Out** für Multi-Monitor
6. ✅ **Automatik-Option** mit Stabilizern
7. ✅ **Operator-Boni** für Optimierung
8. ✅ **Visuelle Feedback-Systeme** (Kreise, Graphen)

**Nächste Schritte:**
1. Implementierung PermanentInfoPanel.tscn
2. Scanner-Circle-Rendering
3. Quality-Shift-Berechnung
4. Panel-Selector-System
5. Reiter-System mit Hotkeys
6. Pop-Out-Fenster-Logik
