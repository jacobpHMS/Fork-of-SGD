# 🤖 Automation Orchestrator

[← Zurück](../INDEX.md)

## Zentrale AI-Steuerung

Der Orchestrator koordiniert alle AI-Subsysteme für massive Weltensimulation.

**Subsysteme:**
- [NPC Manager](NPCs.md) - 10.000+ NPC-Schiffe
- [Faction System](Factions.md) - Diplomatie
- [Command Hierarchy](Commands.md) - Flottenkommandos
- [Combat AI](Combat.md) - Kampf & Aggression
- [Patrol System](Patrols.md) - Patrouillen
- [Information Network](Information.md) - X4-Style Sensoren

---

## Orchestration Modes

| Mode | Tick Rate | NPCs/Tick | Verwendung |
|------|-----------|-----------|------------|
| **DISABLED** | 0.0 | 0 | Keine AI |
| **MINIMAL** | 0.5 | 50 | Nur Spieler-nah |
| **STANDARD** | 1.0 | 100 | Empfohlen |
| **FULL** | 2.0 | 200 | Volle Simulation |

---

## World Tick System

```gdscript
# Priority-basierte Updates
CRITICAL: Every tick (NPCManager, CombatAI)
HIGH: Every 2 ticks (CommandHierarchy, InformationNetwork)
MEDIUM: Every 5 ticks (PatrolSystem, TradeAI)
LOW: Every 10 ticks (FactionSystem)
```

---

## Usage

```gdscript
var orch = get_node("/root/AutomationOrchestrator")
await orch.orchestrator_ready

# Mode setzen
orch.set_orchestration_mode(OrchestrationMode.STANDARD)

# Befehle dispatchen
orch.dispatch_command(ship_id, {"type": "attack", "target": enemy_id})
orch.dispatch_fleet_command(fleet_id, {"type": "patrol", "route": route_id})

# Weltabfragen
var enemies = orch.get_nearby_enemies(position, faction_id, range)
var visible = orch.get_visible_objects(position, range)
```

**Details:** [Automation Complete Guide](../../AUTOMATION_SYSTEMS_COMPLETE_GUIDE.md)

[← Zurück](../INDEX.md)
