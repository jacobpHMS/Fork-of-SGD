# ⚔️ Command Hierarchy

[← Zurück](../INDEX.md)

## Übersicht

Das Command Hierarchy System verwaltet hierarchische Flottenkommandos mit Commander/Subordinate-Struktur.

**Siehe auch:** [NPC Manager](NPCs.md) | [Orchestrator](Orchestrator.md) | [Fleet Automation](../systems/Fleet.md)

---

## Hierarchische Struktur

```
Player
  ↓
Fleet Commander (Capital Ship)
  ↓
Squadron Leaders (Frigates)
  ↓
Individual Ships (Fighters)
```

**Beispiel:**
```
Player → Battleship "Titan"
  ├── Frigate "Alpha Leader" (Commander)
  │     ├── Fighter "Alpha-1"
  │     ├── Fighter "Alpha-2"
  │     └── Fighter "Alpha-3"
  └── Frigate "Bravo Leader" (Commander)
        ├── Fighter "Bravo-1"
        └── Fighter "Bravo-2"
```

---

## Command Types

```gdscript
enum CommandType {
    ATTACK,         # Ziel angreifen
    DEFEND,         # Position/Ziel verteidigen
    PATROL,         # Route patrouillieren
    ESCORT,         # Ziel eskortieren
    TRADE,          # Handelsroute folgen
    MINE,           # Gebiet abbauen
    DOCK,           # An Station docken
    HOLD_POSITION,  # Position halten
    REGROUP         # Zu Commander zurück
}
```

---

## Fleet Management

### Fleet erstellen

```gdscript
# Fleet erstellen
var fleet_id = CommandHierarchy.create_fleet({
    "fleet_name": "Alpha Squadron",
    "commander_id": "ship_frigate_001",
    "formation": "wedge"
})

# Ships zur Fleet hinzufügen
CommandHierarchy.add_ship_to_fleet(fleet_id, "ship_fighter_001")
CommandHierarchy.add_ship_to_fleet(fleet_id, "ship_fighter_002")
CommandHierarchy.add_ship_to_fleet(fleet_id, "ship_fighter_003")
```

### Fleet Command

```gdscript
# Befehl an gesamte Fleet
CommandHierarchy.issue_fleet_command(fleet_id, {
    "type": CommandType.ATTACK,
    "target": enemy_ship_id,
    "priority": "high"
})

# Befehl wird automatisch an alle Subordinates propagiert!
```

---

## Command Propagation

### Automatische Weitergabe

```gdscript
# Commander bekommt Befehl
issue_command(commander_id, attack_command)

# System propagiert automatisch:
for subordinate_id in commander.subordinates:
    issue_command(subordinate_id, attack_command)

    # Rekursiv für weitere Ebenen
    if subordinate.has_subordinates():
        propagate_to_subordinates(subordinate_id, attack_command)
```

**Beispiel:**
```
Player → "Attack Enemy Station"
  ↓
Fleet Commander → Weiterleitung
  ↓
Squadron Leaders → Weiterleitung
  ↓
Individual Ships → Ausführung
```

---

## Command Overrides

### Prioritäten

```gdscript
enum CommandPriority {
    LOW = 0,
    MEDIUM = 1,
    HIGH = 2,
    CRITICAL = 3
}
```

**Regel:** Höhere Priorität überschreibt niedrigere

```gdscript
# Ship hat MEDIUM Command: "Patrol"
current_command = {type: PATROL, priority: MEDIUM}

# Neuer HIGH Command: "Attack"
new_command = {type: ATTACK, priority: HIGH}

# → Attack überschreibt Patrol
if new_command.priority > current_command.priority:
    execute_command(new_command)
```

---

## Formations

### Formation Types

```gdscript
enum Formation {
    NONE,      # Keine Formation
    WEDGE,     # Keil-Formation (Angriff)
    LINE,      # Linie (Verteidigung)
    CIRCLE,    # Kreis (um Ziel)
    COLUMN,    # Kolonne (Patrol)
    SCATTER    # Verstreut (Ausweichen)
}
```

### Formation Positioning

```gdscript
# Wedge Formation (Beispiel)
func calculate_formation_position(ship_index: int, commander_pos: Vector2) -> Vector2:
    match formation:
        Formation.WEDGE:
            # V-Form
            var offset = Vector2(
                ship_index * 100,
                abs(ship_index - fleet_size/2) * 50
            )
            return commander_pos + offset.rotated(commander_rotation)
```

---

## Fleet Status

### Status Tracking

```gdscript
class FleetStatus:
    var fleet_id: String
    var commander_id: String
    var subordinates: Array[String] = []
    var current_command: Dictionary
    var formation: Formation
    var combat_ready: bool
    var average_hull: float
    var average_morale: float
```

### Fleet Queries

```gdscript
# Fleet-Status abfragen
var status = CommandHierarchy.get_fleet_status(fleet_id)

# Alle Fleets
var all_fleets = CommandHierarchy.get_all_fleets()

# Ships einer Fleet
var ships = CommandHierarchy.get_fleet_ships(fleet_id)
```

---

## Commander System

### Commander Assignment

```gdscript
# Ship als Commander setzen
CommandHierarchy.assign_commander(ship_id, {
    "max_subordinates": 5,
    "command_radius": 2000,  # Maximale Entfernung für Commands
    "auto_regroup": true
})
```

### Commander Abilities

**Commander Ships haben:**
- Größere Command Radius
- Bessere Formation Control
- Auto-Regroup bei Subordinate Loss
- Command Priority Override

### Commander Loss

```gdscript
# Bei Commander Zerstörung
func on_commander_destroyed(commander_id: String):
    var fleet = get_fleet_by_commander(commander_id)

    # Option 1: Promote Subordinate
    promote_new_commander(fleet.subordinates[0])

    # Option 2: Dissolve Fleet
    dissolve_fleet(fleet.fleet_id)

    # Option 3: Auto-Retreat
    issue_retreat_command(fleet.subordinates)
```

---

## API Referenz

```gdscript
# Fleet erstellen
var fleet_id = CommandHierarchy.create_fleet(config)

# Ship hinzufügen
CommandHierarchy.add_ship_to_fleet(fleet_id, ship_id)

# Command ausgeben
CommandHierarchy.issue_fleet_command(fleet_id, command)

# Einzelschiff-Command
CommandHierarchy.issue_ship_command(ship_id, command)

# Formation setzen
CommandHierarchy.set_fleet_formation(fleet_id, Formation.WEDGE)

# Fleet auflösen
CommandHierarchy.dissolve_fleet(fleet_id)

# Status
var status = CommandHierarchy.get_fleet_status(fleet_id)
```

---

## Signale

```gdscript
signal fleet_created(fleet_id: String, commander_id: String)
signal ship_added_to_fleet(fleet_id: String, ship_id: String)
signal fleet_command_issued(fleet_id: String, command: Dictionary)
signal formation_changed(fleet_id: String, formation: Formation)
signal commander_destroyed(fleet_id: String, old_commander: String)
signal fleet_dissolved(fleet_id: String)
```

---

## Integration

### Mit NPC Manager
- NPCs können Fleets kommandieren
- Hierarchische NPC Structures
- **Details:** [NPC Manager](NPCs.md)

### Mit Combat AI
- Fleet Commands → Tactical AI
- Coordinated Attacks
- **Details:** [Combat AI](Combat.md)

### Mit Orchestrator
- Command Hierarchy = HIGH Priority (Update every 2 ticks)
- Command Propagation batched
- **Details:** [Orchestrator](Orchestrator.md)

---

## Tipps

1. **Commander wichtig**: Starkes Ship als Commander
2. **Formation wählen**: WEDGE für Angriff, LINE für Defense
3. **Command Radius**: Commander nicht zu weit weg
4. **Backup Commander**: Immer zweites starkes Ship
5. **Auto-Regroup**: Verhindert Fragmentierung
6. **Prioritäten nutzen**: CRITICAL für Emergency Commands

---

**Siehe auch:**
- [NPC Manager](NPCs.md) - NPC Fleet Commands
- [Combat AI](Combat.md) - Tactical Integration
- [Orchestrator](Orchestrator.md) - Command Priority
- [Fleet Automation](../systems/Fleet.md) - Player Fleets

[← Zurück](../INDEX.md)
