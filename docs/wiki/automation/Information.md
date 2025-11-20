# 📡 Information Network

[← Zurück](../INDEX.md)

## Übersicht

Das Information Network ist ein X4-inspiriertes Sichtbarkeitssystem mit Navigation Satellites und Scout Ships für Fog-of-War.

**Siehe auch:** [NPC Manager](NPCs.md) | [Factions](Factions.md) | [Orchestrator](Orchestrator.md)

---

## Sensor Nodes

### Node Types

```gdscript
enum SensorNodeType {
    NAVIGATION_SATELLITE,  # Statisch, großer Radius
    SCOUT_SHIP,           # Mobil, mittlerer Radius
    STATION,              # Statisch, kleiner Radius
    PLAYER_SHIP           # Spieler, mittlerer Radius
}
```

### Sensor Ranges

| Type | Range | Deployment | Cost |
|------|-------|------------|------|
| **Navigation Satellite** | 10000 Units | Player-deployed | 50k Credits |
| **Scout Ship** | 3000 Units | Auto-patrol | 30k Credits |
| **Station** | 2000 Units | Fixed | Included |
| **Player Ship** | 2500 Units | Player-controlled | Included |

---

## Navigation Satellites

### X4-Style Deployment

**Inspiriert von X4: Foundations Navigation Satellites**

```gdscript
# Satellite deployen
var sat_id = InformationNetwork.deploy_nav_satellite(
    position: Vector2(5000, 5000),
    faction_id: "player_faction"
)

# Satellite offenbart Gebiet permanent
# → Fog-of-War entfernt
# → Schiffsbewegungen sichtbar
```

### Satellite Properties

```gdscript
class NavigationSatellite:
    var satellite_id: String
    var position: Vector2
    var faction_id: String
    var sensor_range: float = 10000.0
    var active: bool = true
    var deployed_at: float  # Game time
```

### Strategic Placement

**Empfohlene Positionen:**
- Handelsrouten-Knotenpunkte
- Stations-Umgebung
- Grenz-Gebiete
- Mining-Zonen

---

## Scout Ships

### Auto-Patrol Scouts

```gdscript
# Scout Ship spawnen
var scout_id = NPCManager.spawn_npc(
    NPCType.SCOUT,
    "player_faction",
    position,
    "Scout Alpha-1"
)

# Patrol Route zuweisen
PatrolSystem.assign_patrol(scout_id, patrol_route_id)

# Scout offenbart Gebiet während Patrol
```

### Scout Efficiency

```gdscript
# Scout Coverage berechnen
func calculate_scout_coverage(scout_id: String) -> float:
    var patrol_route = PatrolSystem.get_route(scout_id)
    var waypoints = patrol_route.waypoints
    var sensor_range = 3000.0

    var total_area = 0.0
    for waypoint in waypoints:
        total_area += PI * sensor_range * sensor_range

    return total_area
```

**Siehe:** [Patrol System](Patrols.md) | [NPC Manager](NPCs.md)

---

## Visibility System

### Fog-of-War

```gdscript
# 3 Visibility States
enum VisibilityState {
    UNEXPLORED,  # Schwarz, nie gesehen
    EXPLORED,    # Grau, war mal sichtbar
    VISIBLE      # Normal, aktuell sichtbar
}
```

### Visibility Calculation

```gdscript
func is_visible(position: Vector2, faction_id: String) -> bool:
    # Prüfe alle Sensor Nodes der Faction
    for sensor in get_faction_sensors(faction_id):
        if position.distance_to(sensor.position) <= sensor.range:
            return true
    return false
```

### Visibility Cache

```gdscript
# Performance: Cache Visibility pro Grid Cell
class VisibilityGrid:
    var cell_size: float = 500.0
    var visibility_cache: Dictionary = {}  # Vector2i -> bool

func update_visibility_cache():
    for cell in grid_cells:
        visibility_cache[cell] = is_visible(cell * cell_size, player_faction)
```

---

## Information Sharing

### Faction Networks

```gdscript
# Factions teilen Sensor-Daten bei ALLIED Status
func get_visible_area(faction_id: String) -> Array[Vector2]:
    var visible_areas = []

    # Eigene Sensoren
    visible_areas.append_array(get_faction_sensors(faction_id))

    # Allied Faction Sensoren
    for ally_faction in get_allied_factions(faction_id):
        visible_areas.append_array(get_faction_sensors(ally_faction))

    return visible_areas
```

**Siehe:** [Factions - Alliance](Factions.md#alliance-benefits)

---

## Object Detection

### Detected Objects

```gdscript
# Was wird erkannt in Sensor Range?
func get_visible_objects(position: Vector2, sensor_range: float) -> Array:
    var visible = []

    # Ships
    for ship in all_ships:
        if ship.position.distance_to(position) <= sensor_range:
            visible.append(ship)

    # Stations
    for station in all_stations:
        if station.position.distance_to(position) <= sensor_range:
            visible.append(station)

    # Ore (nur wenn nahe)
    if sensor_range > 500:
        for ore in nearby_ore:
            if ore.position.distance_to(position) <= sensor_range:
                visible.append(ore)

    return visible
```

### Object Information

```gdscript
# Je nach Sensor-Quality unterschiedliche Info
class DetectedObject:
    var object_id: String
    var position: Vector2
    var object_type: String  # "ship", "station", "ore"

    # Nur bei guten Sensoren:
    var faction_id: String
    var ship_class: String
    var cargo_info: Dictionary
```

---

## Counter-Intelligence

### Stealth (Geplant v2.1)

```gdscript
# Ships mit Stealth-Modulen
class StealthModule:
    var stealth_level: int = 1  # 1-5

    # Reduziert Sensor Detection Range
    func effective_detection_range(base_range: float) -> float:
        return base_range * (1.0 - stealth_level * 0.15)
        # Level 5: -75% Detection Range!
```

### Sensor Jamming (Geplant v2.2)

```gdscript
# Jamming-Ships stören Sensor Networks
class JammingShip:
    var jamming_radius: float = 2000.0

    # Satellites in Jamming Range funktionieren nicht
```

---

## API Referenz

```gdscript
# Navigation Satellite deployen
var sat_id = InformationNetwork.deploy_nav_satellite(position, faction_id)

# Satellite zerstören
InformationNetwork.destroy_satellite(sat_id)

# Sichtbarkeit prüfen
var visible = InformationNetwork.is_visible(position, faction_id)

# Visible Objects
var objects = InformationNetwork.get_visible_objects(position, range)

# Alle Faction Sensoren
var sensors = InformationNetwork.get_faction_sensors(faction_id)

# Coverage berechnen
var coverage = InformationNetwork.calculate_coverage(faction_id)
# Returns: 0.0 - 1.0 (percentage of map covered)
```

---

## Signale

```gdscript
signal satellite_deployed(sat_id: String, position: Vector2, faction: String)
signal satellite_destroyed(sat_id: String)
signal area_revealed(faction_id: String, area: Rect2)
signal object_detected(detector_id: String, object_id: String)
signal visibility_changed(position: Vector2, state: VisibilityState)
```

---

## Integration

### Mit NPC Manager
- Scout Ships für Reconnaissance
- NPC Visibility-based Behavior
- **Details:** [NPC Manager](NPCs.md)

### Mit Factions
- Allied Sensor Sharing
- Hostile Detection
- **Details:** [Factions](Factions.md)

### Mit Patrol System
- Scout Patrols für Coverage
- Waypoints in Unexplored Areas
- **Details:** [Patrol System](Patrols.md)

### Mit Orchestrator
- Information Network = HIGH Priority (every 2 ticks)
- Visibility Updates batched
- **Details:** [Orchestrator](Orchestrator.md)

---

## Strategic Gameplay

### Network Expansion

**Phase 1:** Player-Ship Only
- Nur 2500 Units Sichtbarkeit
- Sehr limitiert

**Phase 2:** First Satellites
- Deploy bei wichtigen Punkten
- 10km Coverage pro Satellite

**Phase 3:** Scout Network
- 5-10 Scout Ships auf Patrol
- Dynamische Coverage

**Phase 4:** Complete Network
- 50+ Satellites
- 20+ Scouts
- Fast komplette Map-Coverage

### Economic Impact

**Information = Profit:**
- Sichtbare Handelswege → Bessere Trades
- Enemy Movement → Piracy Prevention
- Resource Discovery → Mining Opportunities

---

## Performance Optimization

```gdscript
# Visibility nur für relevante Objekte
func update_visibility(delta: float):
    # Nur Objects nahe Player updaten
    var relevant_objects = get_objects_near_player(5000.0)

    for obj in relevant_objects:
        obj.visible = is_visible(obj.position, player_faction)

    # Rest cached oder nicht gerendert
```

**Siehe:** [Performance Manager](../performance/Manager.md)

---

## Tipps

1. **Start Coverage**: Erste Satellite bei Home Station
2. **Trade Routes**: Satellites entlang Handelsrouten
3. **Scout Patrols**: Border-Areas und Danger Zones
4. **Allied Sharing**: Alliance = Doppelte Coverage
5. **Strategic Gaps**: Enemies können Unexplored nutzen
6. **Satellite Defense**: Wichtige Satellites beschützen

---

**Siehe auch:**
- [NPC Manager](NPCs.md) - Scout Ships
- [Factions](Factions.md) - Sensor Sharing
- [Patrol System](Patrols.md) - Scout Patrols
- [Orchestrator](Orchestrator.md) - Update Priority

[← Zurück](../INDEX.md)
