# ☄️ Asteroid Field System

[← Zurück](../INDEX.md)

## Übersicht

Das Asteroid Field System generiert dynamisch Asteroidenfelder in Sternsystemen basierend auf **Security Levels**. Höhere Security = weniger Ressourcen, niedrigere Security = reichere Felder mit seltenen Erzen!

**Siehe auch:** [Security Levels](SecurityLevels.md) | [Mining](../mechanics/Mining.md) | [Ore Database](../reference/Ores.md)

---

## Asteroidenfeld-Generierung

### Automatische Generierung

Asteroidenfelder werden automatisch für alle Sternsysteme generiert:

```gdscript
# 3-8 Felder pro System
var field_count = randi_range(3, 8)

# Eigenschaften basieren auf Security Level
field.richness = system.resource_richness * randf_range(0.8, 1.2)
field.ore_types = get_ore_types_for_security(system.security_level)
field.asteroid_count = int(50 * field.richness)
```

### Feld-Eigenschaften

**AsteroidField Class:**
- **field_id**: Eindeutige ID
- **field_name**: "Sol Asteroid Field A"
- **position**: Position im System
- **radius**: 1500-3000 Einheiten
- **richness**: 0.24 - 3.6 (basierend auf Security)
- **ore_types**: Verfügbare Erz-Typen
- **asteroid_count**: 12 - 180 Asteroiden
- **density**: Asteroiden pro Flächeneinheit

---

## Erz-Verteilung nach Security Level

### ⭐ Verfügbare Erze (aus OreDatabase)

**Common Ores (überall):**
- Ferralite (40% Weight) - Eisenbasiertes Erz
- Cupreon (30% Weight) - Kupferbasiertes Erz
- Palestone (20% Weight) - Leichtes Strukturerz

**Uncommon Ores (Sec ≤ 24):**
- Titanex (15% Weight) - Titanlegierungserz
- Densore (12% Weight) - Hochdichtes Metallerz
- Alumara (10% Weight) - Aluminiumbasiertes Erz

**Rare Ores (Sec ≤ 14):**
- Noblore (8% Weight) - Edelmetallerz
- Auralith (6% Weight) - Goldkristallerz
- Mirrorvein (5% Weight) - Reflektierendes Erz

**Exotic Ores (Sec ≤ 4 - NULL SEC ONLY!):**
- Fusionore (10% Weight) ⭐⭐⭐ - Fusionsreaktorerz
- Novaore (5% Weight) ⭐⭐⭐⭐ - Supernovaerz
- Nexalith (3% Weight) ⭐⭐⭐⭐⭐ - Ultra-seltene Nexuskristalle

### Weighted Ore Selection

```gdscript
# Beispiel: Null Sec Field (Level 1)
Available Ores: [Ferralite, Cupreon, Palestone, Titanex, Densore, Alumara,
                 Noblore, Auralith, Mirrorvein, Fusionore, Novaore, Nexalith]

# Spawn-Wahrscheinlichkeit:
Ferralite:  ~25%
Cupreon:    ~19%
Palestone:  ~13%
Fusionore:  ~6%  # SEHR WERTVOLL!
Novaore:    ~3%  # EXTREM WERTVOLL!
Nexalith:   ~2%  # ULTRA SELTEN!
```

**In High Sec (Level 30):**
```gdscript
Available Ores: [Ferralite, Cupreon, Palestone]

# Nur Common Ores!
Ferralite:  ~44%
Cupreon:    ~33%
Palestone:  ~23%
```

---

## Asteroiden-Spawning

### Asteroid Properties

**Asteroid Class:**
```gdscript
var asteroid_id: String
var ore_type: String  # "iron", "platinum", etc.
var position: Vector2  # Position im Feld
var size: float  # 50-200 × richness
var ore_amount: float  # size × 10 × richness
var ore_remaining: float
var is_depleted: bool

# Mining stats
var mining_difficulty: float  # 1.0-3.0
var optimal_laser_tier: int  # 1-5
```

### Size & Ore Amount

```gdscript
# Beispiel: High Sec Field (richness = 0.3)
min_size = 50 × 0.3 = 15
max_size = 200 × 0.3 = 60
ore_amount = size × 10 × 0.3 = 45-180 Einheiten

# Beispiel: Null Sec Field (richness = 3.0)
min_size = 50 × 3.0 = 150
max_size = 200 × 3.0 = 600
ore_amount = size × 10 × 3.0 = 4500-18000 Einheiten!
```

**Null Sec Asteroiden haben bis zu 100x mehr Erz!**

### Position Distribution

Asteroiden werden zufällig im Feld verteilt (kreisförmig):

```gdscript
var angle = randf() * TAU
var distance = randf() * field.radius
asteroid.position = field.position + Vector2(cos(angle), sin(angle)) * distance
```

---

## Mining Difficulty

### Difficulty by Ore Type

| Ore Type | Difficulty | Optimal Laser Tier | Value |
|----------|------------|-------------------|--------|
| Ferralite, Cupreon, Palestone | 1.0 | T1 | Low |
| Titanex, Densore, Alumara | 1.5 | T2 | Medium |
| Noblore, Auralith, Mirrorvein | 2.0 | T3 | High |
| Fusionore, Novaore, Nexalith | 3.0 | T5 | EXTREME |

### Mining Efficiency

```gdscript
# Laser Tier 1 on Ferralite (Difficulty 1.0)
Efficiency: 100%

# Laser Tier 1 on Fusionore (Difficulty 3.0)
Efficiency: ~33%  # SEHR INEFFIZIENT!

# Laser Tier 5 on Fusionore (Difficulty 3.0)
Efficiency: 100%  # OPTIMAL!
```

**Fazit:** Exotic Ores benötigen High-Tier Laser!

---

## Asteroid Depletion & Respawn

### Depletion

```gdscript
# Asteroid wird abgebaut
asteroid.mine(amount)

# Bei 0 ore_remaining
asteroid.is_depleted = true
field.active_asteroids.erase(asteroid_id)
field.depleted_asteroids[asteroid_id] = current_time
```

### Respawn System

**Respawn Settings:**
- **Enabled**: true (standardmäßig)
- **Respawn Time**: 300 Sekunden (5 Minuten)
- **Check Interval**: 60 Sekunden

```gdscript
# Nach 5 Minuten
if current_time - depletion_time >= 300.0:
    respawn_asteroid(asteroid_id)
    # Asteroid zurück mit voller ore_amount!
```

**Infinite Resource Gathering durch Respawning!**

---

## Field Examples

### High Sec Field (Sol System, Level 30)

```
Field: "Sol Asteroid Field A"
Security Level: 30
Richness: 0.36 (30% × 1.2)
Asteroid Count: 18
Available Ores: [Ferralite, Cupreon, Palestone]
Average Ore per Asteroid: 54-216 units

Profitabilität: ⭐ Niedrig
Sicherheit: ✅✅✅ Sehr hoch
```

### Med Sec Field (Wolf 359, Level 18)

```
Field: "Wolf 359 Asteroid Field B"
Security Level: 18
Richness: 0.84 (70% × 1.2)
Asteroid Count: 42
Available Ores: [Ferralite, Cupreon, Palestone, Titanex, Densore, Alumara]
Average Ore per Asteroid: 126-504 units

Profitabilität: ⭐⭐ Mittel
Sicherheit: ⚠️ Moderat
```

### Low Sec Field (Epsilon Eridani, Level 8)

```
Field: "Epsilon Eridani Asteroid Field C"
Security Level: 8
Richness: 1.8 (150% × 1.2)
Asteroid Count: 90
Available Ores: [All Common + Uncommon + Rare]
Average Ore per Asteroid: 270-1080 units

Profitabilität: ⭐⭐⭐ Hoch
Sicherheit: ⚠️⚠️ Gefährlich
```

### Null Sec Field (Dark Zone, Level 1)

```
Field: "Dark Zone Asteroid Field D"
Security Level: 1
Richness: 3.6 (300% × 1.2)
Asteroid Count: 180
Available Ores: [ALL ORES INCLUDING EXOTIC!]
Average Ore per Asteroid: 540-2160 units
FUSIONORE/NOVAORE/NEXALITH spawns!

Profitabilität: ⭐⭐⭐⭐⭐ EXTREM
Sicherheit: ☠️☠️☠️ SEHR GEFÄHRLICH
```

---

## API Referenz

### Field Queries

```gdscript
# Field abfragen
var field = AsteroidFieldManager.get_field(field_id)

# Felder in System
var fields = AsteroidFieldManager.get_fields_in_system("sol")

# Nächstes Feld
var nearest = AsteroidFieldManager.get_nearest_field(player.position)
```

### Asteroid Queries

```gdscript
# Asteroid abfragen
var asteroid = AsteroidFieldManager.get_asteroid(asteroid_id)

# Asteroiden im Feld
var asteroids = AsteroidFieldManager.get_asteroids_in_field(field_id)

# Asteroiden in Reichweite
var nearby = AsteroidFieldManager.get_asteroids_in_range(position, 1000.0)

# Statistiken
var total = AsteroidFieldManager.get_total_asteroid_count()
var active = AsteroidFieldManager.get_active_asteroid_count()
```

### Mining Operations

```gdscript
# Ore abbauen
var mined_amount = asteroid.mine(100.0)

# Depletion prüfen
if asteroid.is_depleted:
    AsteroidFieldManager.deplete_asteroid(asteroid_id)
    # Respawnt nach 5 Minuten

# Depletion Prozent
var percent = asteroid.get_depletion_percent()
# Returns: 0-100
```

---

## Integration

### Mit Security Level System
- Felder werden für alle Systeme generiert
- Richness basiert auf Security Level
- Ore-Typen abhängig von Security
- **Details:** [Security Levels](SecurityLevels.md)

### Mit Mining System
- Asteroids als Mining-Targets
- Mining Difficulty beeinflusst Effizienz
- Optimal Laser Tier für beste Performance
- **Details:** [Mining Mechanics](../mechanics/Mining.md)

### Mit Ore Database
- Ore Types definiert in OreDatabase
- Werte, Gewichte, Eigenschaften
- **Details:** [Ore Reference](../reference/Ores.md)

---

## Strategische Überlegungen

### Für Anfänger (Level 25-30)
- **Start**: High Sec Fields (Sol, Alpha Centauri)
- **Ores**: Ferralite, Cupreon, Palestone
- **Equipment**: T1 Laser ausreichend
- **Sicherheit**: Keine Piraten
- **Profit**: Niedrig, aber sicher

### Für Fortgeschrittene (Level 15-24)
- **Location**: Med Sec Fields (Wolf 359, Barnard's Star)
- **Ores**: Common + Uncommon (Titanex, Densore, Alumara!)
- **Equipment**: T2 Laser empfohlen
- **Sicherheit**: Moderate Piraten
- **Profit**: 2-3x vs High Sec

### Für Profis (Level 5-14)
- **Location**: Low Sec Fields (Epsilon Eridani, Ross 154)
- **Ores**: Common + Uncommon + Rare (Noblore, Auralith, Mirrorvein!)
- **Equipment**: T3 Laser, starkes Schiff
- **Sicherheit**: Viele Piraten, Eskorte empfohlen
- **Profit**: 5-7x vs High Sec

### Für Experten (Level 1-4)
- **Location**: Null Sec Fields (Dark Zone, Outer Rim)
- **Ores**: ALL INCLUDING EXOTIC (Fusionore, Novaore, Nexalith!)
- **Equipment**: T5 Laser, Combat Ship, FLOTTE!
- **Sicherheit**: EXTREME Gefahr, ständige Angriffe
- **Profit**: 10-15x vs High Sec, aber HOHES RISIKO
- **Respawn**: Auch Exotic Ores respawnen!

---

## Profit Calculation

### Ore Value Examples (hypothetisch)

```
Common Ores:
Ferralite:  10 cr/unit
Cupreon:    15 cr/unit
Palestone:  12 cr/unit

Uncommon Ores:
Titanex:  50 cr/unit
Densore:  40 cr/unit
Alumara:  35 cr/unit

Rare Ores:
Noblore:     200 cr/unit
Auralith:    250 cr/unit
Mirrorvein:  180 cr/unit

Exotic Ores:
Fusionore:  1000 cr/unit ⭐⭐⭐
Novaore:    2500 cr/unit ⭐⭐⭐⭐
Nexalith:   5000 cr/unit ⭐⭐⭐⭐⭐
```

### Profit per Hour Estimates

**High Sec (Level 30):**
- Asteroids: Klein, wenig Ore
- Ores: Nur Common (10-15 cr/unit)
- Profit/Hour: ~5.000 Credits
- Risk: Keine

**Med Sec (Level 18):**
- Asteroids: Mittel, moderate Ore
- Ores: Common + Uncommon (10-50 cr/unit)
- Profit/Hour: ~15.000 Credits
- Risk: Niedrig

**Low Sec (Level 8):**
- Asteroids: Groß, viel Ore
- Ores: Common + Uncommon + Rare (10-250 cr/unit)
- Profit/Hour: ~50.000 Credits
- Risk: Hoch

**Null Sec (Level 1):**
- Asteroids: RIESIG, massives Ore
- Ores: ALL + EXOTIC (10-5000 cr/unit)
- Profit/Hour: ~200.000 Credits (bei Fusionore/Novaore/Nexalith)
- Risk: EXTREM
- Death Chance: 50%+

**High Risk = High Reward!**

---

## Tipps

### Mining Efficiency
1. **Match Laser Tier** zu Ore Difficulty
2. **Scan Field** bevor Mining (welche Ores?)
3. **Target Exotic Ores** in Null Sec
4. **Respawn Timer** beachten (5 min)

### Safety
5. **High Sec** für Safe Farming
6. **Eskorte** in Low/Null Sec
7. **Combat Ship** in Null Sec
8. **Schnelle Exits** planen

### Profit Maximierung
9. **Focus Rare/Exotic** Ores
10. **Null Sec Raids** mit Flotte
11. **Respawn Farming** (gleiche Felder)
12. **Trade Routes** zu High Sec (verkaufen)

---

**Siehe auch:**
- [Security Levels](SecurityLevels.md) - System Security
- [Mining Mechanics](../mechanics/Mining.md) - Wie minen?
- [Ore Database](../reference/Ores.md) - Alle Erze
- [NPC System](../automation/NPCs.md) - Piraten!

[← Zurück](../INDEX.md)
