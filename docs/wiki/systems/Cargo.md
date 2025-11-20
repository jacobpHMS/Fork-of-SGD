# 📦 Cargo Specialization System

[← Zurück](../INDEX.md)

## Übersicht

Das Cargo System verwaltet spezialisierte Frachträume mit Bonuses/Penalties, Compression-Technologie und speziellen Modulen.

**Siehe auch:** [Fleet Automation](Fleet.md) | [Stations](Stations.md) | [Energy](Energy.md) | [Temperature](Temperature.md)

---

## Cargo Types (8 Typen)

```gdscript
enum CargoType {
    GENERAL,     # Universal hold (no bonus)
    ORE,         # Raw ores
    MINERAL,     # Processed minerals
    GAS,         # Compressed gases
    LIQUID,      # Liquids (temperature control!)
    AMMO,        # Ammunition
    BUILD,       # Building materials
    HAZMAT       # Radioactive/Toxic materials
}
```

### Specialization Bonuses

| Cargo Type | Bonus | Best For |
|------------|-------|----------|
| **GENERAL** | -10% | Allzweck, flexibel |
| **ORE** | +50% | Mining Ships, Raw Ore Transport |
| **MINERAL** | +50% | Refined Material Transport |
| **GAS** | +50% | Gas Haulers, Industrial Transport |
| **LIQUID** | +50% | Fuel Tankers, Chemical Transport |
| **AMMO** | +50% | Combat Ships, Ammo Runners |
| **BUILD** | +50% | Construction Material Transport |
| **HAZMAT** | +50% | Radioactive/Toxic Material (Special!) |

**Regel:**
- Spezialisierter Hold: **+50% Kapazität** für den richtigen Typ
- Spezialisierter Hold: **0% Kapazität** für falsche Typen (kann nicht speichern!)
- GENERAL Hold: **-10% Kapazität** für alles, aber universell

---

## Compression Technology (Modul-System)

**Compression ist KEIN Cargo-Typ, sondern ein UPGRADE!**

```gdscript
enum CompressionLevel {
    NONE = 0,      # Base capacity (1.0x)
    BASIC = 1,     # +20% capacity (1.2x)
    ADVANCED = 2,  # +40% capacity (1.4x)
    ELITE = 3      # +60% capacity (1.6x)
}
```

### Compression Multipliers

| Level | Multiplier | Total mit Specialization |
|-------|------------|--------------------------|
| **NONE** | 1.0x | 1.5x (nur Specialization) |
| **BASIC** | 1.2x | 1.8x (1.5 * 1.2) |
| **ADVANCED** | 1.4x | 2.1x (1.5 * 1.4) |
| **ELITE** | 1.6x | 2.4x (1.5 * 1.6) |

**Beispiel:**
```
ORE Hold (Base: 1000 m³)
+ Specialization: 1000 * 1.5 = 1500 m³
+ ELITE Compression: 1500 * 1.6 = 2400 m³

Total: 2.4x Base Capacity!
```

### Compression Costs

| Level | Credits | Materials |
|-------|---------|-----------|
| **BASIC** | 100k | 500 Titanium |
| **ADVANCED** | 500k | 2000 Titanium, 10 Compressors |
| **ELITE** | 2M | 50 Compressors, 5 Quantum Cores |

---

## Cargo Hold Capacity Calculation

```gdscript
func get_effective_capacity() -> float:
    var capacity = base_capacity

    # 1. Compression bonus
    capacity *= COMPRESSION_MULTIPLIER[compression_level]

    # 2. Specialization bonus/penalty
    if specialization != CargoType.GENERAL:
        capacity *= 1.5  # +50%
    else:
        capacity *= 0.9  # -10%

    return capacity
```

**Beispiele:**

```
GENERAL Hold (1000 m³, ELITE Compression):
= 1000 * 1.6 * 0.9 = 1440 m³

ORE Hold (1000 m³, ELITE Compression):
= 1000 * 1.6 * 1.5 = 2400 m³

LIQUID Hold (1000 m³, ADVANCED Compression):
= 1000 * 1.4 * 1.5 = 2100 m³
```

---

## Special Modules

### Temperature Control (für LIQUID)

**Erforderlich für sicheren Liquid-Transport:**

```gdscript
func install_temperature_control(hold_id: String, cost: float) -> bool:
    # Installiert Kühlsystem
    hold.has_temperature_control = true
```

**Funktion:**
- Hält Liquids bei optimaler Temperatur
- Verhindert Verdampfung/Gefrieren
- **Empfohlen** für LIQUID Cargo (nicht zwingend, aber Warnung!)

**Kosten:** 50k Credits

**Integration:** [Temperature System](Temperature.md)

---

### Hazmat Shielding (für HAZMAT)

**ERFORDERLICH für radioaktive/toxische Materialien:**

```gdscript
func install_hazmat_shielding(hold_id: String, cost: float) -> bool:
    # Installiert Strahlenschutz
    hold.has_hazmat_shielding = true
```

**Funktion:**
- Schützt Crew vor Strahlung
- **ZWINGEND** für HAZMAT Cargo (sonst Ablehnung!)

**Kosten:** 100k Credits

---

## Pressurized Compression (GAS & LIQUID Modul)

### Druckbehälter-Technologie

**Erweiterte Compression für GAS und LIQUID mit RISIKO:**

```gdscript
class PressurizedCompressionModule:
    var compression_level: CompressionLevel = CompressionLevel.ELITE
    var energy_consumption: float = 50.0   # Energy/second
    var fuel_consumption: float = 5.0      # Fuel/hour
    var heat_generation: float = 30.0      # Heat/second
    var pressure_level: float = 1.0        # 0.0 - 1.0
    var max_pressure_psi: float = 1000.0
```

**Kann installiert werden auf:**
- GAS Holds → Compressed Gas Storage
- LIQUID Holds → Pressurized Liquid Storage

---

### Druckbehälter-Mechanik

#### Installation

```gdscript
# Als Modul auf GAS/LIQUID Hold installieren
CargoSpecializationSystem.install_pressurized_compression(hold_id, {
    "compression_level": CompressionLevel.ELITE,  # +60%
    "safety_systems": true
})

# Benötigt:
# - GAS oder LIQUID Hold
# - 500k Credits
# - 50 Quantum Cores
```

**Effekt:**
```
GAS Hold (1000 m³) + Specialization + ELITE + Pressurized:
= 1000 * 1.5 (spec) * 1.6 (compression) * 1.2 (pressure) = 2880 m³!

ABER: Benötigt kontinuierlich Energie, Fuel, Kühlung!
```

---

### Ressourcen-Bedarf (Pressurized)

#### Kontinuierliche Kosten

```gdscript
# Pro Sekunde
energy_consumption: 50 Power/s
fuel_consumption: 5 Fuel/hour
heat_generation: 30 Heat/s

# Integration mit Systemen
if EnergySystem.available_power < 50:
    pressure_level -= 0.1 * delta  # Druckabfall!

if TemperatureSystem.get_temperature("cargo") > 100:
    pressure_instability = true
```

**Siehe:** [Energy System](Energy.md) | [Temperature System](Temperature.md)

---

### Pressure States & Risiken

#### Pressure Levels

```gdscript
enum PressureState {
    NORMAL,       # 0.8 - 1.0: Safe
    LOW,          # 0.5 - 0.8: Warning
    CRITICAL,     # 0.3 - 0.5: Danger
    FAILING,      # < 0.3: Imminent Failure
    CATASTROPHIC  # Explosion!
}
```

#### Failure Conditions

**Druckabfall führt zu:**
- ⚡ **Energie-Ausfall** → Compression stoppt → Druckabfall
- ⛽ **Fuel leer** → Pumpen stoppen → Druckabfall
- 🌡️ **Überhitzung** → Material-Expansion → Druckabfall
- ⚔️ **Combat Damage** → Hull Breach → Sofort-Explosion

**Bei Catastrophic Failure:**
```gdscript
func catastrophic_failure():
    # EXPLOSION!
    var explosion_damage = cargo_amount * 0.5
    ship.take_damage(explosion_damage)
    CargoSystem.clear_cargo(hold_id)  # Alle Cargo verloren!
```

---

### Safety Systems

#### Emergency Venting

```gdscript
func emergency_vent():
    # Gas/Liquid in Space venten
    var vented_amount = cargo_amount * 0.5  # 50% verloren
    pressure_level = 0.3  # Safe level

    # Schiff gerettet, aber 50% Profit weg!
```

#### Auto-Safety

```gdscript
# Automatic Safety Thresholds
auto_vent_threshold: 0.2    # Auto-vent bei 20% pressure
alarm_threshold: 0.5        # Alarm bei 50% pressure
warning_threshold: 0.8      # Warning bei 80% pressure
```

---

## Transfer Rates

### Docking Transfer Speeds

| Cargo Type | Transfer Rate | Time for 1000 units |
|------------|---------------|---------------------|
| **ORE** | 100/s | 10 seconds |
| **MINERAL** | 100/s | 10 seconds |
| **GAS** | 150/s | 6.7 seconds (faster!) |
| **LIQUID** | 50/s | 20 seconds (slower!) |
| **AMMO** | 100/s | 10 seconds |
| **BUILD** | 100/s | 10 seconds |
| **HAZMAT** | 25/s | 40 seconds (very slow!) |
| **GENERAL** | 100/s | 10 seconds |

**Warum unterschiedlich?**
- GAS: Schnell (Druck-Transfer)
- LIQUID: Langsam (Pumpen-Limit)
- HAZMAT: Sehr langsam (Sicherheit!)

---

## Item Type Mapping

### Welche Items gehören zu welchem Typ?

| Item | Cargo Type |
|------|------------|
| Iron Ore, Copper Ore, etc. | ORE |
| Iron, Copper, Titanium, etc. | MINERAL |
| Pure Iron, Pure Copper, etc. | MINERAL |
| Hydrogen Gas, Oxygen, Nitrogen | GAS |
| Fuel, Coolant, Liquid Hydrogen | LIQUID |
| Missiles, Bullets, Torpedoes | AMMO |
| Steel Plates, Components | BUILD |
| Uranium, Plutonium, Toxic Waste | HAZMAT |
| Everything else | GENERAL |

---

## API Referenz

```gdscript
# Cargo Hold erstellen
CargoSpecializationSystem.create_cargo_hold(
    "hold_ore_1",
    CargoType.ORE,
    capacity: 1000.0
)

# Compression upgraden
CargoSpecializationSystem.upgrade_compression(
    "hold_ore_1",
    CompressionLevel.ELITE,
    player_resources
)

# Temperature Control installieren (LIQUID)
CargoSpecializationSystem.install_temperature_control("hold_liquid_1", 50000)

# Hazmat Shielding installieren (HAZMAT)
CargoSpecializationSystem.install_hazmat_shielding("hold_hazmat_1", 100000)

# Pressurized Compression installieren (GAS/LIQUID)
CargoSpecializationSystem.install_pressurized_compression("hold_gas_1", {
    "compression_level": CompressionLevel.ELITE,
    "safety_systems": true
})

# Cargo speichern
CargoSpecializationSystem.store_cargo(
    "hold_ore_1",
    "iron_ore",
    amount: 500.0,
    CargoType.ORE
)

# Hold Info
var info = CargoSpecializationSystem.get_hold_info("hold_ore_1")
# Returns: {
#   specialization: "ORE",
#   base_capacity: 1000.0,
#   effective_capacity: 2400.0,  # With ELITE compression
#   used_capacity: 500.0,
#   free_capacity: 1900.0,
#   percent_full: 20.8,
#   compression_level: 3,
#   has_temperature_control: false,
#   has_hazmat_shielding: false
# }

# Best Hold finden
var best_hold = CargoSpecializationSystem.find_best_hold_for_item(
    "iron_ore",
    500.0,
    CargoType.ORE
)
```

---

## Signale

```gdscript
signal cargo_type_changed(hold_id: String, new_type: String)
signal compression_upgraded(hold_id: String, new_level: int)
signal hazmat_warning(material: String, requires_special: bool)
signal temperature_critical(hold_id: String, material: String)
signal pressure_warning(hold_id: String, pressure_level: float)
signal pressure_critical(hold_id: String)
signal emergency_vent(hold_id: String, vented_amount: float)
signal cargo_explosion(hold_id: String, damage: float)
```

---

## Integration

### Mit Energy System
- Pressurized Compression: 50 Power/s
- **Details:** [Energy System](Energy.md)

### Mit Temperature System
- Temperature Control für LIQUID
- Pressurized Compression: 30 Heat/s
- **Details:** [Temperature System](Temperature.md)

### Mit Fleet Automation
- Auto-Cargo Management für Standard Holds
- Pressurized Holds: Manuelle Überwachung!
- **Details:** [Fleet Automation](Fleet.md)

---

## Schiffsrollen & Empfohlene Holds

| Ship Role | Primary Hold | Secondary Hold | Modules |
|-----------|--------------|----------------|---------|
| **Miner** | ORE (ELITE) | GENERAL | - |
| **Refinery Hauler** | MINERAL (ADVANCED) | - | - |
| **Fuel Tanker** | LIQUID (ADVANCED) | - | Temp Control |
| **Gas Hauler (Safe)** | GAS (ADVANCED) | - | - |
| **Gas Hauler (Risk)** | GAS (ELITE) | - | Pressurized! |
| **Ammo Runner** | AMMO (BASIC) | GENERAL | - |
| **Constructor** | BUILD (ADVANCED) | GENERAL | - |
| **Hazmat Transport** | HAZMAT (BASIC) | - | Hazmat Shield! |
| **Trader** | GENERAL (BASIC) | GENERAL | Flexibility |

---

## Tipps

### Standard Holds
1. **Spezialisierung lohnt**: +50% ist massiv
2. **Compression upgraden**: ELITE = +60% on top
3. **Combo-Effekt**: Specialization + Compression = 2.4x!
4. **GENERAL nur als Backup**: -10% penalty

### Special Modules
1. **LIQUID = Temp Control**: Empfohlen, nicht zwingend
2. **HAZMAT = Shield**: ZWINGEND!
3. **Kosten einplanen**: 50k-100k pro Modul

### Pressurized Compression
1. ⚠️ **Nur für Experten**: Hohes Risiko!
2. **Energie-Backup**: Redundante Generatoren
3. **Fuel-Reserve**: Nie unter 20%
4. **Cooling wichtig**: Temperature Monitoring
5. **Kurze Strecken**: Weniger Zeit = Weniger Risiko
6. **Safety Systems**: Auto-Vent bei 20%
7. **Nicht AFK**: Continuous Monitoring!
8. **Insurance**: Schiff versichern!

---

## Progression Path

### Early Game
- GENERAL Holds (flexible)
- Keine Compression
- Keine Special Modules

### Mid Game
- Specialized Holds (ORE, MINERAL)
- BASIC/ADVANCED Compression
- Temperature Control für Traders

### Late Game
- Full Specialization
- ELITE Compression überall
- Alle Module installiert

### Endgame / Expert
- Pressurized Compression für max Profit
- Risk/Reward Management
- Multiple specialized Ships

---

## Warnung: Pressurized Compression

```
⚠️ WARNUNG ⚠️

Pressurized Compression ist EXTREM GEFÄHRLICH!

Risiken:
- Energie-Ausfall → Druckabfall → 💥 EXPLOSION
- Fuel leer → Compression stoppt → 💥 EXPLOSION
- Überhitzung → Instabilität → 💥 EXPLOSION
- Combat Damage → 💥 Sofort-EXPLOSION

Bei Explosion:
- Schiff TOTAL ZERSTÖRT
- Alle Cargo VERLOREN
- Respawn erforderlich

NUR verwenden wenn:
✅ Schiff voll ausgestattet (Energie, Fuel, Cooling)
✅ Redundante Systeme vorhanden
✅ Kurze Transportstrecke
✅ Hoher Profit rechtfertigt Risiko
✅ Du weißt was du tust!

Für Anfänger: Nutze Standard Compression (Safe, +60% ohne Risiko)
```

---

**Siehe auch:**
- [Energy System](Energy.md) - Power für Pressurized
- [Temperature System](Temperature.md) - Cooling Management
- [Fleet Automation](Fleet.md) - Cargo Management
- [Stations](Stations.md) - Docking & Transfer

[← Zurück](../INDEX.md)
