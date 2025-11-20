# 📚 Skill System

[← Zurück zum Index](../INDEX.md)

## Übersicht

Das Skill-System basiert auf **Datacards** und **XP-Progression**. Ohne Datacard: -20% Effizienz!

**Siehe auch:** [Crafting System](Crafting.md) | [Modules](Modules.md) | [Fleet Automation](Fleet.md)

---

## Skill-Kategorien

| Skill | Kategorie | Verwendung |
|-------|-----------|------------|
| **Mining** | MINING | Bergbau-Effizienz, Autominer |
| **Refining** | REFINING | Raffinerie-Geschwindigkeit |
| **Combat** | COMBAT | Kampf, Waffen-Effizienz |
| **Trading** | TRADING | Handelspreise, Profit |
| **Engineering** | ENGINEERING | Modul-Effizienz, Reparatur |
| **Navigation** | NAVIGATION | Geschwindigkeit, Manövrierbarkeit |
| **Autominer AI** | AUTOMINER_AI | [Autominer-Chips](Fleet.md#autominer-chips) |

---

## XP & Leveling

### XP-Formel (Exponentiell)

```gdscript
xp_required = base_xp * (multiplier ^ level)
# Default: 100 * (1.5 ^ level)
```

**Beispiel:**
- Level 1→2: 150 XP
- Level 2→3: 225 XP
- Level 5→6: 759 XP
- Level 10→11: 5767 XP

### XP Verdienen

- **Mining**: XP pro abgebautem Erz
- **Crafting**: XP pro hergestelltem Item (siehe [Crafting](Crafting.md))
- **Combat**: XP pro Abschuss
- **Trading**: XP pro Trade

---

## Datacards

**Ohne Datacard:** -20% Effizienz, +50% Energieverbrauch!

### Datacard Erwerben

```gdscript
SkillManager.acquire_datacard("Mining")
```

**Kosten:** Variabel (1.000 - 100.000 Credits)

**Fundorte:**
- Stationen (siehe [Stations](Stations.md))
- Loot von NPCs
- Missionen (geplant)

---

## Effizienz-Berechnung

### Module-Effizienz

```gdscript
# Ohne Datacard
efficiency = 0.8  # 80% Output
energy_mult = 1.5  # +50% Energie

# Mit Datacard
if skill_level < module_tier:
    # Noob Malus: -20% pro fehlendem Level
    efficiency = max(0.2, 1.0 - (level_diff * 0.2))
    energy_mult = 1.0 + (level_diff * 0.5)
elif skill_level > module_tier:
    # Master Bonus: +5% pro extra Level (max +25%)
    efficiency = 1.0 + (min(level_diff, 5) * 0.05)
```

**Beispiele:**

| Skill Level | Modul Tier | Effizienz | Energie |
|-------------|------------|-----------|---------|
| 3 | 5 | 60% | +100% |
| 5 | 5 | 100% | 100% |
| 7 | 5 | 110% | 100% |
| 10 | 5 | 125% | 100% |

**Siehe auch:** [Module System](../mechanics/Modules.md)

---

## Integration

### Mit Crafting

Skill-Level beeinflusst Crafting-Effizienz:
- Höheres Level = Schnellere Produktion
- Master Bonus = Mehr Output

**Details:** [Crafting System](Crafting.md#skill-integration)

### Mit Fleet Automation

Autominer AI-Skill steuert [Autominer-Chips](Fleet.md#autominer-chips):
- Skill Level = Chip-Emulationslevel
- Höher = Effizienter automatisiert

---

## API Referenz

```gdscript
# XP hinzufügen
SkillManager.add_xp("Mining", 50)

# Level abfragen
var level = SkillManager.get_skill_level("Mining")

# Datacard-Status
var has_card = SkillManager.has_datacard("Mining")

# Effizienz berechnen
var efficiency = SkillManager.calculate_module_efficiency(module_tier, "Mining")
# Returns: {"output": 1.0, "energy_mult": 1.0, "effective_tier": 5}
```

---

## Signale

```gdscript
signal skill_leveled_up(skill_name: String, new_level: int)
signal xp_gained(skill_name: String, amount: int, new_total: int)
signal datacard_acquired(skill_name: String)
```

---

**Siehe auch:**
- [Module System](../mechanics/Modules.md) - Modul-Installation
- [Crafting](Crafting.md) - Skill-Einfluss auf Herstellung
- [Fleet Automation](Fleet.md) - Autominer AI

[← Zurück zum Index](../INDEX.md)
