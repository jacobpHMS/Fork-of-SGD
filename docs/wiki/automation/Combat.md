# ⚔️ Combat AI

[← Zurück](../INDEX.md)

## Übersicht

Das Combat AI System verwaltet Aggression Management, Morale, Threat Assessment und taktische Entscheidungen für NPCs.

**Siehe auch:** [NPC Manager](NPCs.md) | [Factions](Factions.md) | [Commands](Commands.md)

---

## Aggression Levels

```gdscript
enum AggressionLevel {
    PASSIVE = 0,    # Greift nie an, flieht immer
    DEFENSIVE = 1,  # Nur Gegenangriff
    NEUTRAL = 2,    # Standard, situationsabhängig
    AGGRESSIVE = 3, # Greift Feinde proaktiv an
    BERSERK = 4     # Greift alles an, ignoriert Morale
}
```

### Level-Verhalten

| Level | Attack Behavior | Retreat Threshold |
|-------|----------------|-------------------|
| **PASSIVE** | Nie | Immer |
| **DEFENSIVE** | Nur bei Angriff | < 50% Hull |
| **NEUTRAL** | Bei Hostile Faction | < 30% Hull |
| **AGGRESSIVE** | Bei Sight Range | < 20% Hull |
| **BERSERK** | Alle in Range | Nie |

---

## Tactical States

```gdscript
enum TacticalState {
    HOLD,     # Position halten
    ADVANCE,  # Auf Feind zu
    RETREAT,  # Rückzug
    FLANK,    # Flankenmanöver
    REGROUP   # Zu Verbündeten
}
```

### State Transitions

```
HOLD → ADVANCE (Enemy detected)
ADVANCE → FLANK (Enemy shields up)
ADVANCE → RETREAT (Morale low)
FLANK → ADVANCE (Flank successful)
RETREAT → REGROUP (Allies nearby)
REGROUP → HOLD (Safe position)
```

---

## Morale System

### Morale Calculation

```gdscript
class CombatState:
    var morale: float = 1.0  # 0.0 - 1.0

# Morale wird beeinflusst von:
morale_factors = {
    "hull_integrity": 0.3,      # 30% Gewicht
    "allies_nearby": 0.2,       # 20%
    "enemies_nearby": -0.2,     # -20%
    "commander_alive": 0.1,     # 10%
    "faction_reputation": 0.1,  # 10%
    "recent_kills": 0.1         # 10%
}
```

### Morale Effects

```gdscript
# Low Morale (< 0.3)
if morale < 0.3:
    weapon_accuracy *= 0.7    # -30% Accuracy
    should_retreat = true

# High Morale (> 0.8)
if morale > 0.8:
    weapon_accuracy *= 1.2    # +20% Accuracy
    damage_output *= 1.1      # +10% Damage
```

### Morale Recovery

```gdscript
# Morale erholt sich über Zeit
func recover_morale(delta: float):
    if not in_combat:
        morale += 0.1 * delta  # +10% pro Sekunde außerhalb Combat

    if docked_at_station:
        morale = 1.0  # Volle Erholung an Station
```

---

## Threat Assessment

### Threat Calculation

```gdscript
func calculate_threat(target: Ship) -> float:
    var threat = 0.0

    # Hull & Shields
    threat += target.hull_integrity * 0.3
    threat += target.shield_strength * 0.2

    # Firepower
    threat += target.weapon_damage * 0.3

    # Distance (näher = bedrohlicher)
    var distance_factor = 1.0 - (distance / max_range)
    threat += distance_factor * 0.2

    return threat
```

### Target Selection

```gdscript
func select_target(enemies: Array[Ship]) -> Ship:
    var best_target = null
    var highest_priority = 0.0

    for enemy in enemies:
        var priority = 0.0

        # Threat Level
        priority += calculate_threat(enemy) * 0.4

        # Target Type Priority
        match enemy.type:
            NPCType.CAPITAL:
                priority += 1.0  # Höchste Priorität
            NPCType.MILITARY:
                priority += 0.8
            NPCType.MERCHANT:
                priority += 0.3  # Niedrige Priorität

        # Distance (näher bevorzugt)
        priority += (1.0 - distance/max_range) * 0.3

        if priority > highest_priority:
            highest_priority = priority
            best_target = enemy

    return best_target
```

---

## Behavior States

**Aus NPC Manager:**
```gdscript
enum NPCBehavior {
    IDLE,        # Nichts tun
    TRAVELING,   # Unterwegs
    TRADING,     # Handelt
    MINING,      # Abbau
    PATROLLING,  # Patrouille
    ATTACKING,   # Im Kampf ← Combat AI aktiv
    FLEEING,     # Auf der Flucht ← Combat AI aktiv
    DOCKED,      # An Station
    ESCORTING,   # Eskortiert
    WAITING      # Wartet
}
```

**Combat AI steuert:** `ATTACKING` und `FLEEING`

**Siehe:** [NPC Manager - Behavior States](NPCs.md#behavior-states)

---

## Combat Decision Making

### Should Attack?

```gdscript
func should_attack(target: Ship) -> bool:
    # Aggression Check
    if aggression_level == AggressionLevel.PASSIVE:
        return false

    # Faction Check
    var reputation = FactionSystem.get_reputation(faction_id, target.faction_id)
    if reputation > 0 and aggression_level != AggressionLevel.BERSERK:
        return false  # Freundliche Faction

    # Threat Assessment
    var threat = calculate_threat(target)
    var my_strength = calculate_own_strength()

    if threat > my_strength * 1.5:
        return false  # Zu stark, nicht angreifen

    # Morale Check
    if morale < 0.5 and aggression_level != AggressionLevel.BERSERK:
        return false  # Zu demoralisiert

    return true
```

### Should Retreat?

```gdscript
func should_flee() -> bool:
    # Berserk nie zurückziehen
    if aggression_level == AggressionLevel.BERSERK:
        return false

    # Morale Check
    if morale < 0.3:
        return true

    # Threat Level
    var threat = calculate_threat_level()
    if threat > 0.8:
        return true

    # Hull Integrity
    if hull_integrity < 0.3:
        return true

    return false
```

---

## API Referenz

```gdscript
# Aggression Level setzen
CombatAI.set_aggression_level(npc_id, AggressionLevel.AGGRESSIVE)

# Tactical State setzen
CombatAI.set_tactical_state(npc_id, TacticalState.ADVANCE)

# Combat State abfragen
var state = CombatAI.get_combat_state(npc_id)
# Returns: {
#   aggression: AggressionLevel.AGGRESSIVE,
#   tactical_state: TacticalState.ADVANCE,
#   morale: 0.75,
#   threat_level: 0.4,
#   current_target: "enemy_123"
# }

# Target zuweisen
CombatAI.assign_target(npc_id, target_id)

# Combat Command
CombatAI.assign_combat_command(npc_id, {
    "type": "attack",
    "target": target_id,
    "formation": "wedge"
})
```

---

## Signale

```gdscript
signal combat_started(npc_id: String, target_id: String)
signal combat_ended(npc_id: String, result: String)  # "victory", "defeat", "flee"
signal target_acquired(npc_id: String, target_id: String)
signal target_lost(npc_id: String)
signal morale_changed(npc_id: String, new_morale: float)
signal retreat_initiated(npc_id: String, reason: String)
```

---

## Integration

### Mit NPC Manager
- Behavior States ATTACKING/FLEEING
- NPC Stats (Hull, Aggression)
- **Details:** [NPC Manager](NPCs.md)

### Mit Factions
- Reputation beeinflusst Aggression
- Faction-wide War-Status
- **Details:** [Factions](Factions.md)

### Mit Command Hierarchy
- Fleet Combat Commands
- Coordinated Attacks
- **Details:** [Commands](Commands.md)

### Mit Orchestrator
- Combat AI = CRITICAL Priority (every tick)
- Threat Assessment batched
- **Details:** [Orchestrator](Orchestrator.md)

---

## Tipps (für Spieler)

1. **Faction Relations**: Gute Reputation → Weniger Angriffe
2. **Morale nutzen**: Starker erster Schlag senkt Enemy Morale
3. **Numbers Matter**: 3 vs 1 → Low Enemy Morale → Retreat
4. **Berserk Enemies**: Piraten oft BERSERK → Kämpfen bis zum Tod
5. **Retreat Path**: Immer Fluchtweg freihalten
6. **Station Refuge**: Bei Low Hull zu Station → Morale Recovery

---

**Siehe auch:**
- [NPC Manager](NPCs.md) - NPC Behavior States
- [Factions](Factions.md) - Reputation & Aggression
- [Commands](Commands.md) - Fleet Combat
- [Orchestrator](Orchestrator.md) - Update Priority

[← Zurück](../INDEX.md)
