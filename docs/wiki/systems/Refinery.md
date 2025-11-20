# 🏭 Refinery System

[← Zurück](../INDEX.md)

## Übersicht

Das Refinery System verarbeitet Ore (Roherz) zu Minerals mit zwei Qualitätsstufen.

**Siehe auch:** [Crafting System](Crafting.md) | [Skills](Skills.md) | [Stations](Stations.md)

---

## Quality Levels

```gdscript
enum QualityLevel {
    STANDARD = 0,  # Verlustfreie Verarbeitung
    PURE = 1       # 30% Material Loss, High-Quality
}
```

### STANDARD Refining

**Prozess:**
```
Ore (1000 units) → Standard Mineral (1000 units)
```

- **Material Loss**: 0%
- **Geschwindigkeit**: 10 Ore/Second
- **Verwendung**: Normale Produktion (T1-T3)

### PURE Refining

**Prozess:**
```
Ore (1000 units) → Pure Mineral (700 units)
```

- **Material Loss**: 30%
- **Geschwindigkeit**: 5 Ore/Second (langsamer!)
- **Verwendung**: High-Tier Items (T4-T6)

**Quality Gates:**
Pure Materials erforderlich für:
- Quantum Core
- AI Matrix
- Fusion Reactor
- Warp Coil
- Shield Emitter
- Advanced CPU

**Siehe:** [Crafting - Quality Gates](Crafting.md#quality-gates)

---

## Ore Types

| Ore | Standard Mineral | Pure Mineral | Vorkommen |
|-----|------------------|--------------|-----------|
| **Iron Ore** | Iron | Pure Iron | Häufig |
| **Copper Ore** | Copper | Pure Copper | Häufig |
| **Silicon Ore** | Silicon | Pure Silicon | Mittel |
| **Titanium Ore** | Titanium | Pure Titanium | Selten |
| **Platinum Ore** | Platinum | Pure Platinum | Sehr Selten |
| **Iridium Ore** | Iridium | Pure Iridium | Ultra Selten |

**Siehe:** [Ore Types Reference](../reference/Ores.md)

---

## Refining Process

### Station-basiert

Refining benötigt eine **Refinery Station**:

```gdscript
# An Station docken
StationSystem.dock_at_station(station_id)

# Refining starten
RefinerySystem.start_refining(
    ore_type: "iron_ore",
    amount: 1000,
    quality: QualityLevel.PURE
)
```

**Siehe:** [Stations - Refinery](Stations.md#refinery)

### Batch Processing

```gdscript
# Große Mengen auf einmal
RefinerySystem.start_batch_refining([
    {"ore": "iron_ore", "amount": 5000, "quality": QualityLevel.STANDARD},
    {"ore": "copper_ore", "amount": 3000, "quality": QualityLevel.PURE}
])
```

**Queue System:**
- Jobs werden nacheinander abgearbeitet
- Progress Tracking für jeden Job
- Kann jederzeit abgebrochen werden

---

## Skill Integration

**Refining Skill** beeinflusst:

### Geschwindigkeit
```gdscript
# Base Speed
base_speed = 10.0  # Ore/Second

# Mit Skill Bonus
actual_speed = base_speed * (1.0 + skill_level * 0.05)

# Beispiele:
# Level 1: 10.5 Ore/s
# Level 5: 12.5 Ore/s
# Level 10: 15.0 Ore/s (+50%!)
```

### Effizienz (nur PURE)
```gdscript
# Base Material Loss: 30%
# Pro Skill Level: -1% Loss (max -10%)

material_loss = max(20%, 30% - (skill_level * 1%))

# Level 1: 29% Loss
# Level 5: 25% Loss
# Level 10: 20% Loss (statt 30%!)
```

**XP Gain:**
- +1 XP pro Standard Refined Ore
- +2 XP pro Pure Refined Ore

**Siehe:** [Skills - Refining](Skills.md#refining)

---

## Station Requirements

### Basic Refinery (T1)
- Standard Refining: ✅
- Pure Refining: ❌
- Max Throughput: 100 Ore/s

### Advanced Refinery (T3)
- Standard Refining: ✅
- Pure Refining: ✅
- Max Throughput: 500 Ore/s

### Industrial Refinery (T5)
- Standard Refining: ✅
- Pure Refining: ✅
- Max Throughput: 2000 Ore/s
- Batch Processing: ✅

**Siehe:** [Stations](Stations.md#station-types)

---

## Cost Analysis

### Standard vs Pure (1000 Iron Ore)

**Standard:**
- Input: 1000 Iron Ore
- Output: 1000 Iron
- Time: 100 Seconds (10/s)
- Value: 1000 Iron = 10k Credits

**Pure:**
- Input: 1000 Iron Ore
- Output: 700 Pure Iron
- Time: 200 Seconds (5/s)
- Value: 700 Pure Iron = 21k Credits

**Profit:**
- Pure ist 2.1x wertvoller
- Aber 30% Material Loss + 2x Zeit
- Lohnt sich für High-Tier Crafting!

---

## API Referenz

```gdscript
# Refining starten
var job_id = RefinerySystem.start_refining(
    "iron_ore",
    1000,
    QualityLevel.PURE
)

# Status abfragen
var status = RefinerySystem.get_job_status(job_id)
# Returns: {
#   progress: 0.5,        # 50% complete
#   remaining_time: 50.0, # seconds
#   output_amount: 350    # 50% of 700
# }

# Job abbrechen
RefinerySystem.cancel_job(job_id)

# Alle Jobs abrufen
var jobs = RefinerySystem.get_active_jobs()
```

---

## Signale

```gdscript
signal refining_started(job_id: String, ore_type: String, amount: int)
signal refining_progress(job_id: String, progress: float)
signal refining_completed(job_id: String, output_type: String, amount: int)
signal refining_cancelled(job_id: String)
```

---

## Tipps

1. **Standard für Masse**: Große Mengen schnell verarbeiten
2. **Pure für Value**: High-Tier Items benötigen Pure
3. **Skill investieren**: -10% Loss + 50% Speed lohnt sich
4. **Batch Processing**: Über Nacht große Jobs laufen lassen
5. **Material Planning**: 30% Loss einkalkulieren

---

**Siehe auch:**
- [Crafting System](Crafting.md) - Verwendung von Minerals
- [Skills](Skills.md) - Refining Skill
- [Stations](Stations.md) - Refinery Stations
- [Mining](../mechanics/Mining.md) - Ore beschaffen

[← Zurück](../INDEX.md)
