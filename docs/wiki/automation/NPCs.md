# 🤖 NPC Manager

[← Zurück](../INDEX.md)

## NPC-Typen

| Typ | Beschreibung | Hull | Cargo | Speed | Aggression |
|-----|--------------|------|-------|-------|------------|
| **MERCHANT** | Händler | 150 | 5000 | 150 | 0.1 |
| **MINER** | Bergbau | 100 | 3000 | 120 | 0.0 |
| **MILITARY** | Militär | 300 | 0 | 250 | 0.7 |
| **PIRATE** | Piraten | 200 | 500 | 280 | 0.9 |
| **CIVILIAN** | Zivilisten | 80 | 500 | 180 | 0.0 |
| **TRANSPORT** | Frachter | 250 | 10000 | 140 | 0.2 |
| **SCOUT** | Aufklärer | 80 | 0 | 350 | 0.3 |
| **CAPITAL** | Großkampf | 1000 | 20000 | 100 | 0.6 |

---

## Behavior States

```gdscript
IDLE → TRAVELING → TRADING
                → MINING
                → PATROLLING → ATTACKING → FLEEING
                → DOCKED
                → ESCORTING
```

**Siehe auch:** [Combat AI](Combat.md#behavior-states)

---

## Auto-Spawning

```gdscript
npc_manager.auto_spawn_enabled = true
npc_manager.target_npc_population = 500
npc_manager.spawn_interval = 5.0  # Sekunden
```

**Verteilung:**
- 30% Merchants
- 20% Miners
- 15% Transports
- 10% Military
- 10% Civilians
- 10% Pirates
- 5% Scouts

---

## API

```gdscript
# NPC spawnen
var npc_id = npc_manager.spawn_npc(
    NPCManager.NPCType.MILITARY,
    "player_faction",
    Vector2(1000, 1000),
    "Patrol Alpha"
)

# Queries
var nearby = npc_manager.get_ships_in_range(position, 5000.0)
var faction_ships = npc_manager.get_ships_by_faction("pirates")
var npc = npc_manager.get_npc(npc_id)
```

**Siehe auch:** [Orchestrator](Orchestrator.md) | [Factions](Factions.md)

[← Zurück](../INDEX.md)
