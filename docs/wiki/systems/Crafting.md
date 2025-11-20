# 🔧 Crafting System

[← Zurück](../INDEX.md)

## Produktionskette

```
Ore (T0)
  ↓
Refined Mineral (T1)
  ↓
Pure Mineral (T2) [30% Materialverlust]
  ↓
Components (T3)
  ↓
Complex Components (T4)
  ↓
Modules (T5)
  ↓
Items/Ships (T6)
```

**Siehe auch:** [Refinery System](Refinery.md) | [Skills](Skills.md) | [Stations](Stations.md)

---

## Quality Gates

**Pure Materials** erforderlich für:
- Quantum Core
- AI Matrix
- Fusion Reactor
- Warp Coil
- Shield Emitter
- Advanced CPU

**Siehe:** [Refinery - Quality Levels](Refinery.md#quality-levels)

---

## Skill-Integration

```gdscript
var efficiency = SkillManager.calculate_module_efficiency(recipe.min_skill_level, recipe.skill_required)
job.efficiency_multiplier = efficiency["output"]

# Master Bonus: Bis zu +25% Output!
```

**Details:** [Skills - Effizienz](Skills.md#effizienz-berechnung)

---

## Station Requirements

High-Tier Crafting benötigt Stationen:

- **Factory**: T4 Complex Components
- **Advanced Factory**: T5 Pure-Material Items
- **Shipyard**: T6 Ships

**Siehe:** [Stations](Stations.md#station-types)

---

**API:**
```gdscript
# Crafting starten
crafting_system.start_crafting("module_mining_laser_t1", 1)

# Batch crafting
crafting_system.craft_batch("component_metal_plates", 10)

# Verfügbare Rezepte
var recipes = crafting_system.get_available_recipes()
```

[← Zurück](../INDEX.md)
