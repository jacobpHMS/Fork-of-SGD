# 🌡️ Temperature System

[← Zurück](../INDEX.md)

## Übersicht

Das Temperature System verwaltet komponenten-spezifisches Wärmemanagement mit Priority-based Cooling.

**Siehe auch:** [Energy System](Energy.md) | [Skills](Skills.md)

---

## Component-Specific Limits

Verschiedene Komponenten haben unterschiedliche Temperatur-Limits:

| Component | Critical Temp | Beschreibung |
|-----------|---------------|--------------|
| **CPU** | 95°C | Prozessoren, Computer-Systeme |
| **Engines** | 150°C | Antriebssysteme, Thrusters |
| **Shields** | 120°C | Schildgeneratoren |
| **Weapons** | 130°C | Waffensysteme, Laser |
| **Hull** | 200°C+ | Schiffsrumpf (Armor-abhängig) |

**Armor-Integration:**
- Höhere Armor-Qualität erhöht Hull-Hitzetoleranz
- Base: 200°C
- Pro Armor-Tier: +10°C

---

## Heat Levels

```gdscript
enum HeatLevel {
    NORMAL,      # < 70% Critical Temp
    ELEVATED,    # 70-85%
    WARNING,     # 85-95%
    CRITICAL,    # 95-100%
    EMERGENCY    # > 100%
}
```

**Konsequenzen:**

- **NORMAL**: Keine Auswirkungen
- **ELEVATED**: Performance Warning
- **WARNING**: -10% Component Efficiency
- **CRITICAL**: -25% Efficiency, Damage Risk
- **EMERGENCY**: Kontinuierlicher Damage, Auto-Shutdown

---

## Priority Cooling System

Cooling wird nach Priorität verteilt:

```gdscript
const COOLING_PRIORITIES = {
    "hull": 2.0,      # 2x Priority!
    "cpu": 1.5,
    "shields": 1.2,
    "engines": 1.0,
    "weapons": 0.8
}
```

**Beispiel:**
- 100 Kühlleistung verfügbar
- Hull bekommt 2x Anteil gegenüber Engines
- CPU 1.5x, Shields 1.2x

---

## Heat Generation

Verschiedene Aktivitäten erzeugen Wärme:

| Aktivität | Heat/Second |
|-----------|-------------|
| **Idle** | 5-10 |
| **Movement** | 15-30 |
| **Shields Active** | 20-40 |
| **Weapons Firing** | 30-60 |
| **Energy Overload** | 50-100 |

**Integration mit [Energy System](Energy.md):**
- Energieverbrauch generiert Wärme
- Overload → Extreme Heat Generation

---

## Cooling Systems

### Passive Cooling
- Base Rate: 10 Heat/Second
- Funktioniert immer
- Skaliert mit Schiffsgröße

### Active Cooling Modules
- **Basic Cooler** (T1): +20 Heat/Second
- **Advanced Cooler** (T3): +50 Heat/Second
- **Industrial Cooler** (T5): +100 Heat/Second

**Kosten:**
- Energie-Verbrauch (10-30 Power)
- CPU-Slots (1-3)

### Emergency Cooling
Automatisch aktiviert bei CRITICAL:
- +50% Cooling für 10 Sekunden
- Dann 30 Sekunden Cooldown

---

## Heat Damage

Bei Überhitzung (> 100% Critical Temp):

```gdscript
# Damage pro Sekunde
damage_per_second = (current_temp - critical_temp) * 0.1

# Beispiel: 110°C bei CPU (95°C Critical)
# → (110 - 95) * 0.1 = 1.5 Damage/s
```

**Permanenter Schaden:**
- Komponenten können beschädigt werden
- Repair an Stationen erforderlich
- Siehe [Stations](Stations.md#repair-service)

---

## API Referenz

```gdscript
# Temperature abfragen
var cpu_temp = TemperatureSystem.get_component_temperature("cpu")
var heat_level = TemperatureSystem.get_heat_level("cpu")

# Cooling hinzufügen
TemperatureSystem.add_cooling_module("advanced_cooler_t3")

# Heat generieren
TemperatureSystem.generate_heat("weapons", 30.0)

# Emergency Cooling
TemperatureSystem.activate_emergency_cooling()
```

---

## Signale

```gdscript
signal heat_level_changed(component: String, level: HeatLevel)
signal component_overheating(component: String, temperature: float)
signal heat_damage_taken(component: String, damage: float)
signal emergency_cooling_activated()
```

---

## Integration

### Mit Energy System
- Energie-Verbrauch → Heat Generation
- Cooling Module benötigen Power
- **Details:** [Energy System](Energy.md)

### Mit Skills
- Engineering Skill reduziert Heat Generation
- Höheres Level → Effizientere Kühlung
- **Details:** [Skills](Skills.md)

---

**Siehe auch:**
- [Energy System](Energy.md) - Power Management
- [Skills](Skills.md) - Engineering Skill
- [Modules](../mechanics/Modules.md) - Cooling Modules

[← Zurück](../INDEX.md)
