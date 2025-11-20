# 🌟 Security Level System

[← Zurück](../INDEX.md)

## Übersicht

Das Security Level System implementiert EVE Online-inspirierte Sicherheitsstufen für Sternsysteme (Level 1-30). Die Sicherheitsstufe beeinflusst **massiv** Ressourcenreichtum, Piratenvorkommen und Sicherheitskräfte.

**Siehe auch:** [Faction System](../automation/Factions.md) | [Planet System](Planets.md) | [NPC Manager](../automation/NPCs.md)

---

## Security Level Categories

### Level-Bereiche (EVE-Style)

| Security Level | Kategorie | Beschreibung | Ressourcen | Gefahr |
|---------------|-----------|--------------|------------|--------|
| **30-25** | HIGH SEC | Empire-Space, maximale Sicherheit | ⭐ 30-50% | ✅ Sehr sicher |
| **24-15** | MED SEC | Lowsec, moderate Sicherheit | ⭐⭐ 70-100% | ⚠️ Moderat |
| **14-5** | LOW SEC | Nullsec, gefährlich | ⭐⭐⭐ 150-200% | ⚠️⚠️ Gefährlich |
| **4-1** | NULL SEC | Gesetzloser Raum | ⭐⭐⭐⭐ 300%+ | ☠️ EXTREM |

### Security Multipliers

```gdscript
# Ressourcen-Reichtum (inverse zur Sicherheit)
Level 30: 30% Basisressourcen (arm)
Level 15: 100% Basisressourcen
Level 5:  200% Basisressourcen (reich)
Level 1:  300% Basisressourcen (EXTREM REICH!)

# Seltene Erze Spawn-Chance
Level 30: 1% Chance auf seltene Erze
Level 15: 20% Chance
Level 5:  50% Chance
Level 1:  70% Chance (!!!)

# Polizei/Militär Patrouillendichte
Level 30: 3.0x Patrouillendichte (schwer bewacht)
Level 15: 1.0x Normal
Level 5:  0.2x Wenig Sicherheit
Level 1:  0.0x Keine Polizei

# Piraten-Spawn-Rate
Level 30: 0.0x Keine Piraten
Level 15: 0.5x Moderate Piraten
Level 5:  2.0x Viele Piraten
Level 1:  5.0x EXTREME Piratenaktivität
```

---

## Sternsystem-Generierung

### Default Systems

Das System generiert automatisch verschiedene Systeme:

**High Security (Empire Space):**
- Sol System (Level 30) - Capital
- Alpha Centauri (Level 28)
- Sirius (Level 27)

**Medium Security (Trade Routes):**
- Barnard's Star (Level 20)
- Wolf 359 (Level 18)
- Lalande 21185 (Level 16)

**Low Security (Frontier):**
- Ross 154 (Level 10)
- Epsilon Eridani (Level 8)
- Tau Ceti (Level 12)

**Null Security (Lawless Space):**
- Outer Rim Alpha (Level 3)
- Outer Rim Beta (Level 2)
- Dark Zone (Level 1) - EXTREME DANGER

---

## Asteroidenfelder

### Generierung basierend auf Security Level

```gdscript
# Anzahl Asteroidenfelder pro System
var field_count = randi_range(3, 8)

# Reichhaltigkeit multipliziert mit Security-Multiplikator
var richness = system.resource_richness * randf_range(0.8, 1.2)

# Asteroiden pro Feld
var asteroid_count = int(50 * richness)
```

### Erz-Typen nach Security Level

**Alle Systeme (Common Ores):**
- Iron
- Copper
- Silicon

**Medium Sec und niedriger (Uncommon):**
- Titanium
- Nickel
- Aluminum

**Low Sec und niedriger (Rare):**
- Platinum
- Gold
- Silver

**Null Sec ONLY (Exotic):**
- Tritanium (EVE-Style)
- Morphite (EVE-Style)
- Zydrine (EVE-Style)

---

## Security Response System

### Sicherheitsverletzungen

**Events die Sicherheitsresponse triggern:**
- Angriff auf NPC-Schiffe
- Angriff auf Stationen
- Piraterie
- Schmuggel (zukünftig)

```gdscript
# Verletzung melden
SecurityLevelSystem.report_security_violation(
    violator_id,
    system_id,
    severity  # 1.0 = normal, 5.0 = extrem
)
```

### High Sec Response

**In High Sec (Level 25+) wird SOFORT reagiert:**
- Police/Military NPCs spawnen
- Stärke basiert auf Patrouillendichte × Severity
- Jagen den Täter
- Bounty auf Kopf gesetzt

**In Low/Null Sec:**
- Keine Polizei-Response
- Player ist auf sich alleine gestellt
- Survival of the fittest!

---

## System-Daten

### StarSystem Class

```gdscript
class StarSystem:
    var system_id: String
    var system_name: String
    var position: Vector2
    var security_level: int  # 1-30
    var radius: float = 5000.0

    # Ownership
    var owning_faction: String
    var planet_ids: Array[String]
    var station_ids: Array[String]

    # Dynamic
    var security_violations: int
    var security_response_active: bool

    # Resources
    var asteroid_fields: Array[Dictionary]
    var resource_richness: float
```

---

## API Referenz

### Queries

```gdscript
# System abfragen
var system = SecurityLevelSystem.get_system("sol")

# Security Level
var level = SecurityLevelSystem.get_security_level("sol")
# Returns: 30

# Kategorie
var category = SecurityLevelSystem.get_security_category("sol")
# Returns: "HIGH_SEC"

# Ressourcen-Reichtum
var richness = SecurityLevelSystem.get_resource_richness("sol")
# Returns: 0.3 (30% in High Sec)

# Seltene Erze Chance
var rare_chance = SecurityLevelSystem.get_rare_spawn_chance("dark_zone")
# Returns: 0.7 (70% in Null Sec!)

# Patrouillendichte
var patrols = SecurityLevelSystem.get_patrol_density("sol")
# Returns: 3.0 (Heavy patrols)

# Piratenrate
var pirates = SecurityLevelSystem.get_pirate_spawn_rate("dark_zone")
# Returns: 5.0 (EXTREME!)

# System an Position finden
var system = SecurityLevelSystem.get_system_by_position(position)
```

### System Creation

```gdscript
# Neues System erstellen
var system = SecurityLevelSystem.create_system(
    "new_system",
    "New System Name",
    Vector2(10000, 10000),
    15,  # Medium Security
    "faction_id"
)
```

### Dynamic Security Changes

```gdscript
# Security Level ändern (Conquest, etc.)
SecurityLevelSystem.modify_security_level("system_id", -5)
# System wird gefährlicher!
```

---

## Integration

### Mit Planet System
- Planeten werden in Systemen generiert
- Sicherheitslevel beeinflusst Planetenentwicklung
- **Details:** [Planet System](Planets.md)

### Mit NPC Manager
- NPC-Spawning basiert auf Security Level
- Piraten spawnen nur in Low/Null Sec
- Militär/Polizei spawnen in High/Med Sec
- **Details:** [NPC Manager](../automation/NPCs.md)

### Mit Faction System
- Fraktionen kontrollieren Systeme
- Security Level kann sich durch Kriege ändern
- **Details:** [Faction System](../automation/Factions.md)

---

## Strategische Überlegungen

### High Sec (25-30)
**Vorteile:**
- ✅ Sehr sicher
- ✅ Keine Piraten
- ✅ Gute Infrastruktur

**Nachteile:**
- ❌ Arme Ressourcen (30-50%)
- ❌ Keine seltenen Erze
- ❌ Überfüllt

### Medium Sec (15-24)
**Vorteile:**
- ✅ Moderate Sicherheit
- ✅ 100% Ressourcen
- ✅ Einige seltene Erze

**Nachteile:**
- ⚠️ Piraten vorhanden
- ⚠️ Weniger Polizei

### Low Sec (5-14)
**Vorteile:**
- ✅ 150-200% Ressourcen!
- ✅ 35-50% seltene Erze
- ✅ Wenig Competition

**Nachteile:**
- ⚠️⚠️ Sehr gefährlich
- ⚠️⚠️ Viele Piraten
- ⚠️ Kaum Polizei

### Null Sec (1-4)
**Vorteile:**
- ✅✅✅ 300% Ressourcen!!!
- ✅✅✅ 70% seltene Erze
- ✅✅✅ Exotic Ores (Tritanium, Morphite)
- ✅ Kein Law Enforcement (Freiheit!)

**Nachteile:**
- ☠️☠️☠️ EXTREM GEFÄHRLICH
- ☠️☠️☠️ 5x Piraten-Spawn
- ☠️ Keine Hilfe
- ☠️ PvP-Zone (zukünftig)

---

## Tipps

1. **Anfänger**: Bleib in High Sec (25+)
2. **Fortgeschrittene**: Farm in Medium Sec (15-24)
3. **Experten**: Low Sec (5-14) für seltene Erze
4. **Profis**: Null Sec (1-4) für maximale Gewinne
5. **Flotten**: Null Sec nur mit Eskorte
6. **Solo**: Vermeide Null Sec ohne gutes Schiff

---

**Siehe auch:**
- [Planet System](Planets.md) - Planeten in Systemen
- [Faction System](../automation/Factions.md) - Systemkontrolle
- [NPC Manager](../automation/NPCs.md) - Piraten & Polizei
- [Asteroid Fields](../mechanics/Mining.md) - Bergbau

[← Zurück](../INDEX.md)
