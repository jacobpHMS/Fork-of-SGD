# 🌍 Planet System

[← Zurück](../INDEX.md)

## Übersicht

Das Planeten-System ermöglicht das Anfliegen und Landen auf Planeten. Planeten haben verschiedene Typen, Regierungsformen, Dienstleistungen und sind Passagier-Ziele.

**Siehe auch:** [Security Levels](SecurityLevels.md) | [Faction System](../automation/Factions.md) | [Passengers](Passengers.md)

---

## Planeten-Typen

### 🌍 TERRESTRIAL (Erdähnlich)

**Beschreibung:** M-Klasse, bewohnbar, erdähnliche Atmosphäre

**Eigenschaften:**
- **Klasse:** M (Class M)
- **Bevölkerung:** 1-10 Millionen
- **Entwicklung:** Level 6-10 (hochentwickelt)
- **Primärexport:** Vielfältig
- **Services:** Alle verfügbar
- **Passagier-Nachfrage:** Sehr hoch (100-500)

**Strategisch:**
- Beste Planeten für alle Aktivitäten
- Hohe Passagier-Nachfrage
- Exzellente Infrastruktur

---

### 🌊 OCEANIC (Wasserwelt)

**Beschreibung:** M-Klasse, größtenteils Wasser

**Eigenschaften:**
- **Klasse:** M (Class M)
- **Bevölkerung:** 0.5-5 Millionen
- **Entwicklung:** Level 5-8
- **Primärexport:** Wasser, Fisch
- **Landepads:** Schwimmende Plattformen

---

### 🏜️ DESERT (Wüstenwelt)

**Beschreibung:** H-Klasse, trocken, Tatooine-Style

**Eigenschaften:**
- **Klasse:** H (Class H)
- **Bevölkerung:** 0.1-1 Million
- **Entwicklung:** Level 3-6
- **Primärimport:** Wasser!
- **Passagier-Nachfrage:** Niedrig

**Strategisch:**
- Ressourcen: Mineralien, Salze
- Wasserhandel profitabel

---

### ❄️ ICE (Eiswelt)

**Beschreibung:** L-Klasse, gefroren

**Eigenschaften:**
- **Klasse:** L (Class L - Marginal)
- **Bevölkerung:** 10.000-500.000
- **Entwicklung:** Level 2-5
- **Primärexport:** Eis, gefrorene Gase

---

### 🌋 VOLCANIC (Vulkanwelt)

**Beschreibung:** K-Klasse, vulkanisch aktiv

**Eigenschaften:**
- **Klasse:** K (Class K - Adaptable)
- **Bevölkerung:** 5.000-100.000
- **Entwicklung:** Level 3-6
- **Primärexport:** Seltene Mineralien!
- **Has Refinery:** Oft ja

**Strategisch:**
- Seltene Ressourcen
- Gefährlich aber profitabel
- Gut für Mining

---

### 🪐 GAS GIANT (Gasriese)

**Beschreibung:** J-Klasse, riesiger Gasplanet

**Eigenschaften:**
- **Klasse:** J (Class J)
- **Bevölkerung:** 0 (nur Orbitalstationen)
- **Kein Landen möglich**
- **Orbitalstationen:** Fuel Scooping

**Strategisch:**
- Treibstoff-Quellen (zukünftig)
- Orbitalstationen als Hubs

---

### 🌑 BARREN (Öde/Kahl)

**Beschreibung:** D-Klasse, leblos, keine Atmosphäre

**Eigenschaften:**
- **Klasse:** D (Class D)
- **Bevölkerung:** 0-50.000 (Mining Kolonien)
- **Entwicklung:** Level 1-3
- **Primärexport:** Rohmineralien

**Strategisch:**
- Mining Outposts
- Günstige Basis für Mining-Operationen

---

### ☠️ TOXIC (Giftig)

**Beschreibung:** K-Klasse, giftige Atmosphäre

**Eigenschaften:**
- **Klasse:** K (Class K)
- **Bevölkerung:** 0-10.000
- **Entwicklung:** Level 1-4
- **Primärexport:** Chemikalien

**Strategisch:**
- Chemikalien-Industrie
- Gefährlich aber lukrativ

---

## Regierungsformen

### Organisationstypen (wie Fraktionen)

| Typ | Beschreibung | Verhalten |
|-----|--------------|-----------|
| **INDEPENDENT** | Freier Planet | Neutral, offen |
| **FEDERATION** | Föderationsplanet | Demokratisch |
| **CORPORATE** | Corporation-owned | Profit-fokussiert |
| **FEUDAL** | Feudalsystem | Hierarchisch |
| **MILITARY** | Militärdiktatur | Aggressiv |
| **DEMOCRACY** | Demokratie | Friedlich |
| **ANARCHIST** | Anarchie | Gesetzlos |

**Siehe:** [Faction System](../automation/Factions.md) für Details zu Organisationstypen

---

## Planeten-Services

### Verfügbare Dienste

**Spaceport (Raumhafen):**
- Landing Pads
- Docking Services
- Fuel (zukünftig)

**Shipyard:**
- Schiffskauf/-verkauf
- Schiffsreparatur
- Refit Services

**Refinery:**
- Erzverarbeitung
- Material-Raffination

**Trading Hub:**
- Commodities Trading
- Market Access

**Passenger Terminal:**
- Passagier-Boarding
- Passagier-Delivery
- Passagier-Generierung

---

## Landing & Docking

### Landing Request

```gdscript
# Landing anfragen
var result = PlanetSystem.request_landing(ship_id, planet_id)

# Result: Dictionary
{
    "success": true/false,
    "reason": "String",  # Bei Fehler
    "landing_fee": 100.0,
    "pad_number": 3
}
```

**Requirements:**
- Spaceport vorhanden
- Freie Landing Pads
- Keine Feindschaft mit Planet-Fraktion (zukünftig)

### Landing Fees

**Basis-Gebühr:** 100 Credits

**Modifiers:**
- High Development: +50-200 Credits
- Low Development: 50-100 Credits
- Corporate Planets: +100% Fee
- Military Planets: Nur bei friendly

### Departure

```gdscript
# Abheben
PlanetSystem.depart_planet(ship_id, planet_id)
```

---

## Planeten-Generierung

### Auto-Generierung

Planeten werden automatisch für alle Sternensysteme generiert:

```gdscript
# Generiert 2-6 Planeten pro System
PlanetSystem.generate_planets_for_system(system_id)

# Alle Systeme
PlanetSystem.generate_all_planets()
```

### Namensschema

**Format:** `[System Name] [Roman Numeral]`

**Beispiele:**
- Sol I (erster Planet in Sol)
- Sol II
- Alpha Centauri III
- Sirius V

---

## Planeten-Daten

### Planet Class

```gdscript
class Planet:
    var planet_id: String
    var planet_name: String
    var planet_type: PlanetType
    var planet_class: PlanetClass

    # Location
    var system_id: String
    var position: Vector2
    var orbit_radius: float
    var orbit_speed: float

    # Stats
    var radius: float
    var population: int
    var development_level: int  # 1-10

    # Ownership
    var owning_faction: String
    var government_type: GovernmentType

    # Economy
    var gdp: float
    var trade_volume: float
    var primary_export: String
    var primary_import: String

    # Services
    var has_spaceport: bool
    var has_shipyard: bool
    var has_refinery: bool
    var has_trading_hub: bool
    var has_passenger_terminal: bool

    # Landing
    var landing_pads: int
    var occupied_pads: int
    var landing_fee: float
    var docked_ships: Array[String]

    # Passengers
    var passenger_demand: int
    var passenger_arrivals: int

    # Defense
    var defense_rating: float
    var has_military_base: bool
```

---

## API Referenz

### Queries

```gdscript
# Planet abfragen
var planet = PlanetSystem.get_planet("sol_planet_1")

# Planeten in System
var planets = PlanetSystem.get_planets_in_system("sol")

# Planeten nach Fraktion
var faction_planets = PlanetSystem.get_planets_by_faction("military")

# Nächster Planet
var nearest = PlanetSystem.get_nearest_planet(position)

# Bewohnbare Planeten
var habitable = PlanetSystem.get_habitable_planets()
# Returns: Nur TERRESTRIAL & OCEANIC
```

### Planet Creation

```gdscript
# Neuen Planeten erstellen
var planet = PlanetSystem.create_planet(
    "custom_planet",
    "New Terra",
    PlanetSystem.PlanetType.TERRESTRIAL,
    "sol",
    "player_faction"
)
```

### Ownership Changes

```gdscript
# Planetenbesitz ändern (Eroberung)
PlanetSystem.change_planet_ownership(planet_id, new_faction_id)
# Triggert: planet_ownership_changed Signal
```

---

## Integration

### Mit Security Level System
- Planeten werden in Systemen generiert
- System Security beeinflusst Entwicklung
- **Details:** [Security Levels](SecurityLevels.md)

### Mit Passenger System
- Planeten als Passagierziele
- Passagier-Nachfrage generiert
- **Details:** [Passengers](Passengers.md)

### Mit Faction System
- Planeten gehören Fraktionen
- Regierungsform basiert auf Fraktion
- Conquest & Wars ändern Besitz
- **Details:** [Faction System](../automation/Factions.md)

---

## Strategische Überlegungen

### Für Händler
- **Terrestrial/Oceanic:** Hohe Bevölkerung = hohe Nachfrage
- **Desert:** Wasser importieren = Profit
- **Volcanic:** Seltene Mineralien exportieren

### Für Passagier-Transport
- **Terrestrial:** Höchste Passagier-Nachfrage
- **Routen:** Terrestrial <-> Terrestrial = beste Routen
- **Corporate Planets:** Business-Travel = VIPs

### Für Miner
- **Volcanic:** Seltene Erze in Nähe
- **Barren:** Mining Outposts, günstiger Fuel
- **Toxic:** Chemikalien-Abbau

### Für Militär/Eroberung (zukünftig)
- **High Development:** Wertvolle Ziele
- **Military Planets:** Schwer zu erobern
- **Independent:** Einfache Ziele

---

## Orbitale Mechanik

### Orbit-Updates

```gdscript
# Planeten bewegen sich in Orbits
func update_orbit(delta: float):
    var angle = orbit_speed * delta
    position = position.rotated(angle)
```

**Hinweis:** Rein visuell, keine Gameplay-Auswirkung (aktuell)

---

## Zukünftige Features (v2.2+)

### Planet Surface
- Landungen auf Oberfläche
- Surface Mining
- Ground Vehicles

### Atmospheric Flight
- In-Atmosphere Flug
- Wettereffekte
- Turbulenz

### Colonization
- Player-owned Colonies
- Colony Management
- Resource Exploitation

### Planetary Defense
- Surface-to-Orbit Weapons
- Orbital Defense Platforms
- Planetary Shields

---

**Siehe auch:**
- [Security Levels](SecurityLevels.md) - System-Generierung
- [Passengers](Passengers.md) - Passagier-Ziele
- [Faction System](../automation/Factions.md) - Ownership
- [Station System](Stations.md) - Vergleich

[← Zurück](../INDEX.md)
