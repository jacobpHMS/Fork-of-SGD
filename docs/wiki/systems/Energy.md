# ⚡ Energy System

[← Zurück](../INDEX.md)

## Übersicht

Das Energy System verwaltet Power Grid Management mit Generators, Priorities und Overload Protection.

**Siehe auch:** [Temperature System](Temperature.md) | [Modules](../mechanics/Modules.md)

---

## Power Grid

```
Generators → Power Grid → Consumers (Priority-based)
              ↓
           Battery (Buffer)
```

**Komponenten:**
- **Generators**: Erzeugen Energie (T1-T6)
- **Power Grid**: Verteilt Energie nach Priorität
- **Battery**: Speichert überschüssige Energie
- **Consumers**: Verbrauchen Energie (Shields, Weapons, etc.)

---

## Generators

| Tier | Power Output | Heat/s | Kosten |
|------|--------------|--------|--------|
| **T1** | 100 | 5 | 5k Credits |
| **T2** | 250 | 10 | 15k |
| **T3** | 500 | 20 | 40k |
| **T4** | 1000 | 35 | 100k |
| **T5** | 2000 | 60 | 250k |
| **T6** | 4000 | 100 | 600k |

**Installation:**
- Benötigt CPU-Slots (1-3)
- Generiert Heat → [Temperature Management](Temperature.md)
- Skill: Engineering (höher = effizienter)

---

## Power Priorities

```gdscript
enum PowerPriority {
    CRITICAL = 0,  # Life Support, CPU
    HIGH = 1,      # Shields, Engines
    MEDIUM = 2,    # Weapons, Sensors
    LOW = 3        # Mining, Cargo
}
```

**Distribution:**
1. Alle CRITICAL-Consumer zuerst
2. Dann HIGH (anteilig bei Overload)
3. Dann MEDIUM
4. Dann LOW

**Bei Overload:** Niedrigere Prioritäten werden abgeschaltet!

---

## Battery System

**Funktionen:**
- Speichert überschüssige Energie
- Buffer für Spitzenlasten
- Backup bei Generator-Ausfall

**Kapazität:**
- **Basic Battery** (T1): 500 Energy
- **Advanced Battery** (T3): 2000 Energy
- **Industrial Capacitor** (T5): 5000 Energy

**Charge/Discharge Rates:**
- Charge: 50-200 Energy/s (Generator-abhängig)
- Discharge: 100-500 Energy/s (Verbrauch-abhängig)

---

## Energy Consumers

### Typische Verbräuche

| System | Priority | Power/s |
|--------|----------|---------|
| **CPU** | CRITICAL | 10-30 |
| **Life Support** | CRITICAL | 5 |
| **Shields** | HIGH | 30-100 |
| **Engines** | HIGH | 20-80 |
| **Weapons** | MEDIUM | 15-60 (firing) |
| **Sensors** | MEDIUM | 5-15 |
| **Mining Laser** | LOW | 25-50 |
| **Cooling** | HIGH | 10-30 |

---

## Overload Protection

**Bei Overload (Consumption > Generation):**

1. **Warning** (90-100% Load)
   - UI Warning anzeigen
   - Performance-Reduktion vorbereiten

2. **Overload** (> 100%)
   - Battery discharge aktivieren
   - LOW Priority deaktivieren
   - Falls nicht genug: MEDIUM deaktivieren

3. **Critical Overload** (> 120%)
   - Nur CRITICAL & HIGH aktiv
   - Emergency Power Mode
   - Heat Generation +50%

**Automatisches Load Balancing:**
```gdscript
# Verfügbare Power anteilig verteilen
available_power = total_generation + battery_discharge
for consumer in priority_sorted_consumers:
    if available_power >= consumer.demand:
        consumer.power = consumer.demand
        available_power -= consumer.demand
    else:
        consumer.power = available_power
        break  # Niedrigere Prioritäten bekommen nichts
```

---

## Emergency Power Mode

Aktiviert bei Critical Overload:

```gdscript
# Nur absolute Notwendigkeiten
active_systems = ["cpu", "life_support", "engines"]
all_other_systems.shutdown()

# Reduzierte Performance
engines.max_speed *= 0.5
shields.recharge_rate = 0
```

**Deaktivierung:**
- Manuell durch Spieler
- Automatisch bei < 80% Load

---

## Heat Integration

Energie-Verbrauch erzeugt Wärme:

```gdscript
heat_generated = power_consumed * HEAT_MULTIPLIER

# Standard Multipliers
HEAT_MULTIPLIER = {
    "shields": 0.3,    # 30% von Power → Heat
    "weapons": 0.5,    # 50%
    "engines": 0.4,
    "generators": 0.2
}
```

**Siehe:** [Temperature System](Temperature.md) für Heat Management

---

## API Referenz

```gdscript
# Generator hinzufügen
EnergySystem.add_generator("generator_t3", 500)

# Power-Status abfragen
var status = EnergySystem.get_power_status()
# Returns: {
#   total_generation: 1000,
#   total_consumption: 850,
#   battery_charge: 1500,
#   load_percent: 85,
#   is_overload: false
# }

# Priorität setzen
EnergySystem.set_consumer_priority("mining_laser", PowerPriority.LOW)

# Emergency Mode
EnergySystem.activate_emergency_power_mode()
```

---

## Signale

```gdscript
signal power_overload(load_percent: float)
signal battery_depleted()
signal battery_charged()
signal emergency_power_activated()
signal generator_added(generator_id: String, output: float)
signal consumer_shutdown(consumer_id: String, priority: PowerPriority)
```

---

## Integration

### Mit Temperature System
- Generators erzeugen Heat
- Overload → Extra Heat Generation
- **Details:** [Temperature System](Temperature.md)

### Mit Skills
- Engineering Skill reduziert Energie-Verbrauch
- Höher = Effizientere Generatoren (-5% pro Level)
- **Details:** [Skills](Skills.md)

### Mit Modules
- Generators als installierbare Module
- Batteries als Upgrades
- **Details:** [Modules](../mechanics/Modules.md)

---

## Tipps

1. **Redundante Generatoren**: Immer 120% Generation planen
2. **Battery als Buffer**: Spitzenlasten abfangen
3. **Priorisierung wichtig**: CRITICAL für Überlebenswichtig
4. **Heat beachten**: Mehr Power = Mehr Heat
5. **Engineering Skill**: Investieren für Effizienz

---

**Siehe auch:**
- [Temperature System](Temperature.md) - Heat Management
- [Skills](Skills.md) - Engineering Skill
- [Modules](../mechanics/Modules.md) - Generatoren & Batteries

[← Zurück](../INDEX.md)
