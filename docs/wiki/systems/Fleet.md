# 🚀 Fleet Automation

[← Zurück](../INDEX.md)

## Übersicht

Das Fleet Automation System ermöglicht vollautomatische Flotten mit AI-Chips, die Mining, Trading und andere Aufgaben übernehmen.

**Siehe auch:** [Skills](Skills.md) | [Stations](Stations.md) | [NPC Manager](../automation/NPCs.md)

---

## Autominer AI Chips

**Kern des Fleet-Systems:** Autominer AI-Chips emulieren Spieler-Skills für automatisierte Schiffe.

| Chip Tier | Emulated Level | Efficiency | Kosten |
|-----------|----------------|------------|--------|
| **Tier 1** | Level 1-2 | 50% | 10k |
| **Tier 2** | Level 3-4 | 75% | 30k |
| **Tier 3** | Level 5-6 | 100% | 80k |
| **Tier 4** | Level 7-8 | 115% | 200k |
| **Tier 5** | Level 9-10 | 125% | 500k |

### Skill-Integration

```gdscript
# Chip emuliert Skill Level
chip_tier = 3  # Tier 3 Chip
emulated_level = 5  # Emuliert Level 5-6

# Efficiency Berechnung
if player_skill_level >= emulated_level:
    # Spieler kann Chip nutzen
    efficiency = base_efficiency * chip_multiplier
else:
    # Spieler-Level zu niedrig!
    efficiency = 0.5  # Nur 50%
```

**Requirement:**
- **Autominer AI Datacard** erforderlich!
- Ohne Datacard: Chips funktionieren nur mit 30% Effizienz

**Siehe:** [Skills - Autominer AI](Skills.md#autominer-ai)

---

## Fleet Ship Assignment

### Schiff zur Flotte hinzufügen

```gdscript
# Schiff registrieren
var ship_id = FleetAutomationSystem.register_fleet_ship({
    "ship_name": "Miner Alpha-1",
    "ship_type": "mining_frigate",
    "cargo_capacity": 3000,
    "installed_modules": ["autominer_chip_t3", "mining_laser_t2"]
})

# AI-Chip zuweisen
FleetAutomationSystem.assign_ai_chip(ship_id, "autominer_chip_t3")
```

### Mining Assignment

```gdscript
# Mining-Gebiet zuweisen
FleetAutomationSystem.assign_mining_zone(ship_id, {
    "center": Vector2(5000, 5000),
    "radius": 2000,
    "ore_filter": ["iron_ore", "copper_ore"],  # Nur diese Erze
    "return_station": "refinery_alpha"
})

# Schiff mined jetzt automatisch!
```

---

## Automated Behaviors

### Mining Automation

**Ablauf:**
1. Schiff fliegt zu Mining-Zone
2. Scannt Asteroiden für gewünschte Erze
3. Mined bis Cargo voll (oder Zeit abgelaufen)
4. Fliegt automatisch zur Return-Station
5. Dockt an, lädt Cargo ab
6. Dockt ab, kehrt zu Mining-Zone zurück
7. Wiederholt Zyklus

**Effizienz:**
```gdscript
mining_rate = base_mining_rate * chip_efficiency * ship_modules_efficiency

# Beispiel:
# Base: 10 Ore/s
# Chip T3: 100%
# Mining Laser T2: 150%
# → 10 * 1.0 * 1.5 = 15 Ore/s
```

### Refining Automation

```gdscript
# Auto-Refining aktivieren
FleetAutomationSystem.enable_auto_refining(ship_id, {
    "quality": QualityLevel.STANDARD,
    "refinery_station": "refinery_alpha",
    "output_storage": "warehouse_1"
})

# Schiff raffiniert automatisch nach Mining
```

### Trading Automation (Geplant v2.1)

```gdscript
# Auto-Trading Assignment
FleetAutomationSystem.assign_trading_route(ship_id, {
    "buy_station": "station_a",
    "buy_goods": ["minerals"],
    "sell_station": "station_b",
    "sell_goods": ["minerals"],
    "profit_threshold": 0.1  # Min 10% Profit
})
```

---

## Fleet Management

### Fleet Status

```gdscript
# Alle Fleet Ships
var ships = FleetAutomationSystem.get_all_fleet_ships()

# Status eines Schiffs
var status = FleetAutomationSystem.get_ship_status(ship_id)
# Returns: {
#   state: "MINING",  # IDLE, TRAVELING, MINING, DOCKED, RETURNING
#   cargo_fill: 0.75,
#   current_location: Vector2(5000, 5000),
#   assigned_task: {...}
# }
```

### Fleet Statistics

```gdscript
var stats = FleetAutomationSystem.get_fleet_statistics()
# Returns: {
#   total_ships: 50,
#   active_ships: 45,
#   docked_ships: 5,
#   total_ore_mined_today: 150000,
#   total_profit_today: 750000
# }
```

---

## Performance Optimization

**Batch Processing für 10.000+ Ships:**

```gdscript
# Nur 100 Ships pro Frame updaten
var ships_per_frame = 100
var ship_update_index = 0

func _process(delta):
    var batch = get_next_ship_batch()
    for ship_id in batch:
        update_ship_automation(ship_id, delta)
```

**Resultat:**
- Original: 166ms für 10.000 Ships
- Optimiert: 1.66ms für 10.000 Ships
- **100x Performance Improvement!**

**Siehe:** [Performance Manager](../performance/Manager.md)

---

## Return-to-Base Logic

### Automatisches Zurückkehren

**Triggers:**
1. Cargo voll (>= 95%)
2. Fuel niedrig (<= 10%)
3. Hull Damage (< 50%)
4. Manual Return Command

```gdscript
func should_return_to_base(ship: FleetShip) -> bool:
    return ship.cargo_fill >= 0.95 \
        or ship.fuel <= 0.1 \
        or ship.hull_integrity < 0.5 \
        or ship.manual_return_requested
```

### Pathfinding

```gdscript
# Automatisches Pathfinding zur Station
var path = FleetAutomationSystem.calculate_return_path(
    ship.position,
    station.position,
    avoid_danger_zones: true
)

ship.follow_path(path)
```

---

## AI Chip Installation

### Installation Requirements

1. **Schiff muss an Station gedockt sein** (Shipyard oder Advanced Factory)
2. **CPU-Slots verfügbar** (Chips benötigen 1-2 Slots)
3. **Credits** für Chip-Kauf

```gdscript
# An Station
if StationSystem.is_docked(ship_id):
    # Chip kaufen & installieren
    FleetAutomationSystem.install_ai_chip(ship_id, "autominer_chip_t3")
    # Kostet 80k Credits, benötigt 2 CPU Slots
```

### Upgrade Path

```
Tier 1 (50%) → Tier 2 (75%) → Tier 3 (100%) → Tier 4 (115%) → Tier 5 (125%)
```

**Tipp:** Upgrade lohnt sich! Tier 5 ist 2.5x effizienter als Tier 1.

---

## API Referenz

```gdscript
# Fleet Ship registrieren
var ship_id = FleetAutomationSystem.register_fleet_ship(config)

# AI-Chip zuweisen
FleetAutomationSystem.assign_ai_chip(ship_id, chip_id)

# Mining-Task zuweisen
FleetAutomationSystem.assign_mining_zone(ship_id, zone_config)

# Status abfragen
var status = FleetAutomationSystem.get_ship_status(ship_id)

# Schiff zurückrufen
FleetAutomationSystem.recall_ship(ship_id)

# Schiff aus Flotte entfernen
FleetAutomationSystem.unregister_fleet_ship(ship_id)
```

---

## Signale

```gdscript
signal fleet_ship_registered(ship_id: String)
signal ai_chip_installed(ship_id: String, chip_id: String)
signal mining_started(ship_id: String, zone: Dictionary)
signal cargo_full(ship_id: String)
signal returning_to_base(ship_id: String, station_id: String)
signal ship_docked(ship_id: String, station_id: String)
signal cargo_unloaded(ship_id: String, amount: int)
```

---

## Integration

### Mit Skills
- Autominer AI Skill = Chip Emulation Level
- Höheres Skill = Bessere Chips nutzbar
- **Details:** [Skills](Skills.md)

### Mit Stations
- Auto-Docking für Cargo Transfer
- Refining an Stations
- **Details:** [Stations](Stations.md)

### Mit NPC Manager
- Fleet Ships interagieren mit NPCs
- Koordination durch [Orchestrator](../automation/Orchestrator.md)

---

## Tipps

1. **Start klein**: 5-10 Ships, dann skalieren
2. **Chip-Tier wichtig**: Investiere in höhere Tiers
3. **Skill leveln**: Autominer AI auf mindestens Level 5
4. **Station-Platzierung**: Refinery nahe Mining-Zonen
5. **Ore-Filter**: Nur profitable Erze minen lassen
6. **Monitoring**: Fleet Statistics regelmäßig checken

---

**Siehe auch:**
- [Skills](Skills.md) - Autominer AI Skill
- [Stations](Stations.md) - Docking & Services
- [Performance](../performance/Manager.md) - Batch Processing
- [NPC Manager](../automation/NPCs.md) - NPC Flotten

[← Zurück](../INDEX.md)
