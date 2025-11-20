# 🛡️ Patrol System

[← Zurück](../INDEX.md)

## Übersicht

Das Patrol System verwaltet automatisierte Patrouillen mit Waypoint-Routen für NPCs.

**Siehe auch:** [NPC Manager](NPCs.md) | [Commands](Commands.md) | [Factions](Factions.md)

---

## Patrol Routes

### Route Definition

```gdscript
class PatrolRoute:
    var route_id: String
    var waypoints: Array[Vector2] = []
    var loop: bool = true  # true = endlos, false = one-way
    var pause_time: float = 5.0  # Sekunden an Waypoint
```

**Beispiel:**
```gdscript
var route = PatrolRoute.new()
route.route_id = "station_alpha_patrol"
route.waypoints = [
    Vector2(1000, 1000),   # Waypoint 0
    Vector2(3000, 1000),   # Waypoint 1
    Vector2(3000, 3000),   # Waypoint 2
    Vector2(1000, 3000)    # Waypoint 3
]
route.loop = true  # Zurück zu Waypoint 0
```

---

## Route Types

### Loop Patrol

```
Waypoint 0 → 1 → 2 → 3 → 0 → 1 → ...
```

**Verwendung:** Stations-Schutz, Territory-Überwachung

### One-Way Patrol

```
Waypoint 0 → 1 → 2 → 3 → STOP
```

**Verwendung:** Konvoi-Eskort, Scout-Missions

### Ping-Pong Patrol

```
Waypoint 0 → 1 → 2 → 3 → 2 → 1 → 0 → ...
```

**Verwendung:** Grenz-Patrouille

---

## Waypoint Behavior

### Arrival Detection

```gdscript
const WAYPOINT_ARRIVAL_DISTANCE = 100.0  # Units

func has_arrived_at_waypoint(ship_pos: Vector2, waypoint: Vector2) -> bool:
    return ship_pos.distance_to(waypoint) < WAYPOINT_ARRIVAL_DISTANCE
```

### Pause at Waypoint

```gdscript
# Ship pausiert an Waypoint
if has_arrived_at_waypoint(ship.position, current_waypoint):
    ship.state = "paused"
    await get_tree().create_timer(pause_time).timeout
    ship.state = "patrolling"
    advance_to_next_waypoint()
```

---

## Patrol Assignment

### NPC Assignment

```gdscript
# Route erstellen
var route_id = PatrolSystem.create_patrol_route({
    "waypoints": [Vector2(1000, 1000), Vector2(3000, 3000)],
    "loop": true,
    "pause_time": 5.0
})

# NPC zuweisen
PatrolSystem.assign_patrol(npc_id, route_id)

# NPC patroulliert jetzt automatisch!
```

### Fleet Assignment

```gdscript
# Ganze Fleet auf Patrol
CommandHierarchy.issue_fleet_command(fleet_id, {
    "type": CommandType.PATROL,
    "route_id": route_id,
    "formation": Formation.LINE
})
```

**Siehe:** [Commands - Fleet Patrol](Commands.md#command-types)

---

## Patrol Algorithms

### Waypoint Progression

```gdscript
class PatrolState:
    var current_waypoint_index: int = 0
    var direction: int = 1  # 1 = forward, -1 = backward (ping-pong)

func advance_waypoint():
    match patrol_type:
        "loop":
            current_waypoint_index = (current_waypoint_index + 1) % waypoints.size()
        "one_way":
            current_waypoint_index += 1
            if current_waypoint_index >= waypoints.size():
                patrol_complete()
        "ping_pong":
            current_waypoint_index += direction
            if current_waypoint_index >= waypoints.size() or current_waypoint_index < 0:
                direction *= -1  # Reverse
                current_waypoint_index += direction * 2
```

---

## Faction Territory Patrols

### Automatic Territory Coverage

```gdscript
# System generiert automatisch Patrol-Routes für Faction Territory
func generate_territory_patrol(faction_id: String, territory: Dictionary) -> String:
    var center = territory.center
    var radius = territory.radius

    # 4 Waypoints in einem Quadrat um Territory
    var waypoints = [
        center + Vector2(-radius, -radius),
        center + Vector2(radius, -radius),
        center + Vector2(radius, radius),
        center + Vector2(-radius, radius)
    ]

    return PatrolSystem.create_patrol_route({
        "waypoints": waypoints,
        "loop": true,
        "pause_time": 10.0
    })
```

**Siehe:** [Factions - Territory](Factions.md#faction-territories)

---

## Patrol Density

### Coverage Optimization

```gdscript
# NPCs pro Patrol Route
var patrol_density = {
    "low": 1,      # 1 Ship pro Route
    "medium": 3,   # 3 Ships
    "high": 5      # 5 Ships
}

# Mehr Density → Bessere Coverage, aber mehr Performance-Cost
```

### Shift System (Geplant)

```
Shift A: 00:00 - 08:00
Shift B: 08:00 - 16:00
Shift C: 16:00 - 00:00

# NPCs rotieren Patrols
```

---

## Interrupts

### Combat Interrupt

```gdscript
# Während Patrol: Enemy detected
if enemy_detected and npc.aggression > 0.3:
    PatrolSystem.pause_patrol(npc_id)
    CombatAI.engage_target(npc_id, enemy_id)

# Nach Combat: Zurück zur Patrol
func on_combat_ended(npc_id: String):
    PatrolSystem.resume_patrol(npc_id)
    # Kehrt zum letzten Waypoint zurück
```

### Player Interrupt

```gdscript
# Player gibt neuen Befehl
if player_command_issued:
    PatrolSystem.cancel_patrol(npc_id)
    execute_player_command(npc_id, command)
```

---

## API Referenz

```gdscript
# Route erstellen
var route_id = PatrolSystem.create_patrol_route(config)

# Patrol zuweisen
PatrolSystem.assign_patrol(npc_id, route_id)

# Patrol Status
var status = PatrolSystem.get_patrol_status(npc_id)
# Returns: {
#   route_id: "route_123",
#   current_waypoint: 2,
#   total_waypoints: 4,
#   paused: false
# }

# Patrol pausieren/fortsetzen
PatrolSystem.pause_patrol(npc_id)
PatrolSystem.resume_patrol(npc_id)

# Patrol abbrechen
PatrolSystem.cancel_patrol(npc_id)

# Alle Routes
var routes = PatrolSystem.get_all_patrol_routes()
```

---

## Signale

```gdscript
signal patrol_route_created(route_id: String, waypoints: Array)
signal patrol_assigned(npc_id: String, route_id: String)
signal waypoint_reached(npc_id: String, waypoint_index: int)
signal patrol_completed(npc_id: String)  # One-way finished
signal patrol_paused(npc_id: String, reason: String)
signal patrol_resumed(npc_id: String)
signal patrol_cancelled(npc_id: String)
```

---

## Integration

### Mit NPC Manager
- Behavior State: PATROLLING
- NPCs folgen automatisch Routes
- **Details:** [NPC Manager](NPCs.md)

### Mit Factions
- Faction-specific Patrols
- Territory Coverage
- **Details:** [Factions](Factions.md)

### Mit Combat AI
- Combat Interrupts
- Resume nach Combat
- **Details:** [Combat AI](Combat.md)

### Mit Orchestrator
- Patrol System = MEDIUM Priority (every 5 ticks)
- Waypoint Updates batched
- **Details:** [Orchestrator](Orchestrator.md)

---

## Tipps

1. **Station Patrols**: Loop-Patrol um wichtige Stationen
2. **Border Patrols**: Ping-Pong entlang Grenze
3. **Density anpassen**: High Density nur in wichtigen Gebieten
4. **Waypoint Spacing**: 1000-2000 Units für gute Coverage
5. **Combat-Ready**: Patrol-Ships mit guter Combat-Ausrüstung
6. **Route-Planung**: Nicht durch Danger Zones

---

**Siehe auch:**
- [NPC Manager](NPCs.md) - PATROLLING Behavior
- [Commands](Commands.md) - Fleet Patrol Commands
- [Factions](Factions.md) - Territory Patrols
- [Combat AI](Combat.md) - Combat Interrupts

[← Zurück](../INDEX.md)
