# 🚢 Passenger Transport System

[← Zurück](../INDEX.md)

## Übersicht

Das Passagier-Transport-System ermöglicht den Transport von 5 verschiedenen Passagiertypen zwischen Stationen und Planeten. Passagiere haben individuelle Bedürfnisse, zahlen unterschiedlich und beeinflussen die Reputation.

**Siehe auch:** [Planet System](Planets.md) | [Station System](Stations.md) | [Cargo System](Cargo.md)

---

## Passagiertypen

### 🏖️ TOURIST (Touristik)

**Beschreibung:** Urlauber, Sightseeing, entspanntes Reisen

**Eigenschaften:**
- **Bezahlung:** 500-2.000 Credits (niedrig-mittel)
- **Geduld:** 80-100% (sehr geduldig)
- **Kabinen-Klasse:** Economy (Klasse 1)
- **Benötigte Annehmlichkeiten:** Entertainment
- **Max. Reisezeit:** 2 Stunden (7200s)
- **Reputation-Bonus:** +2

**Strategische Notizen:**
- Einfachste Passagiere
- Flexible Zeitpläne
- Gute Anfänger-Missions

---

### 👷 WORKER (Arbeiter/Pendler)

**Beschreibung:** Pendler, Arbeiter zwischen Stationen/Planeten

**Eigenschaften:**
- **Bezahlung:** 200-800 Credits (niedrig)
- **Geduld:** 50-80% (ungeduldig)
- **Kabinen-Klasse:** Economy (Klasse 1)
- **Benötigte Annehmlichkeiten:** Keine
- **Max. Reisezeit:** 30 Minuten (1800s)
- **Deadline:** JA! Müssen pünktlich ankommen
- **Reputation-Bonus:** +3

**Strategische Notizen:**
- STRENGE DEADLINES!
- Kurze Strecken (Pendler)
- Hohe Frequenz (regelmäßig)
- Gut für schnelle Credits

---

### 💎 VIP (Wichtige Personen)

**Beschreibung:** CEOs, Botschafter, Prominente, High-Value Targets

**Eigenschaften:**
- **Bezahlung:** 10.000-50.000 Credits (SEHR HOCH!)
- **Geduld:** 20-50% (EXTREM ungeduldig)
- **Kabinen-Klasse:** First Class (Klasse 3) - NUR BESTE!
- **Benötigte Annehmlichkeiten:** Meals, Entertainment, Privacy, Luxury
- **Max. Reisezeit:** 1 Stunde (3600s)
- **Reputation-Bonus:** +20 (MASSIV!)

**Strategische Notizen:**
- HÖCHSTE ANSPRÜCHE
- Benötigt bestes Schiff
- Verlust eines VIPs = RIESIGER Reputationsverlust
- Extrem hohe Belohnungen
- Nur für erfahrene Captains

---

### 🎒 TRAVELER (Reisende)

**Beschreibung:** Langstrecken-Reisende, Kolonisten, Migrationstransport

**Eigenschaften:**
- **Bezahlung:** 1.000-5.000 Credits (mittel-hoch)
- **Geduld:** 90-100% (SEHR geduldig)
- **Kabinen-Klasse:** Business Class (Klasse 2)
- **Benötigte Annehmlichkeiten:** Meals, Entertainment
- **Max. Reisezeit:** 4 Stunden (14400s)
- **Reputation-Bonus:** +5

**Strategische Notizen:**
- Langstreckenflüge
- Sehr entspannt
- Gute Balance: Bezahlung/Anforderungen
- Ideal für mittlere Schiffe

---

### 🚌 PUBLIC TRANSPORT (Öffentlicher Nahverkehr)

**Beschreibung:** Massen-Transit, Gruppen (10-50 Personen)

**Eigenschaften:**
- **Bezahlung:** 50-200 Credits **pro Person** (insgesamt 500-10.000)
- **Geduld:** 60-90% (moderat)
- **Kabinen-Klasse:** Economy (Klasse 1)
- **Benötigte Annehmlichkeiten:** Keine
- **Max. Reisezeit:** 30 Minuten (1800s)
- **Reputation-Bonus:** +1 pro Person

**Strategische Notizen:**
- Hohes Volumen, niedrige Marge pro Person
- Benötigt große Passagierkapazität
- Regelmäßige Routen (Bus/Bahn-Stil)
- Gut für Fraktionsreputation aufbauen

---

## Passagier-Status

### Status-Zustände

```gdscript
enum PassengerStatus {
    WAITING,       # Wartet an Station/Planet
    BOARDED,       # An Bord des Schiffs
    IN_TRANSIT,    # Unterwegs
    DELIVERED,     # Erfolgreich ausgeliefert
    DIED,          # Gestorben (Kampf, Unfall)
    ABANDONED      # Verlassen (keine Geduld mehr)
}
```

---

## Komfort & Zufriedenheit

### Komfort-System

**Komfort-Level:** 0-100%

**Faktoren die Komfort beeinflussen:**
- Kabinen-Qualität vs. Anforderungen
- Verfügbare Annehmlichkeiten
- Reisezeit
- Passagiertyp

```gdscript
# Gute Kabine = +1% Komfort/Sekunde
# Schlechte Kabine = -5% Komfort/Sekunde
# Fehlende Annehmlichkeiten = -3% Komfort/Sekunde
# VIPs verlieren -2% extra Komfort/Sekunde
```

### Geduld-System

**Geduld:** 0-100%

**Faktoren:**
- Wartezeit an Station
- VIPs verlieren 5x schneller Geduld
- Bei 0% Geduld → ABANDONED

---

## Bezahlung & Bonusse

### Bezahlungs-Kalkulation

```gdscript
# Basis-Bezahlung
var payment = passenger.credits

# Komfort-Bonus
if comfort_level > 80:
    payment *= 1.2  # +20% für exzellenten Service

# Komfort-Strafe
elif comfort_level < 30:
    payment *= 0.5  # -50% Rückerstattung für schlechten Service

# Pünktlichkeits-Bonus (Worker, VIP)
if arrival_deadline > 0 and on_time:
    payment *= 1.5  # +50% für pünktliche Lieferung!
```

### Reputation-Auswirkungen

```gdscript
# Erfolgreiche Lieferung
if passenger.is_happy():
    Faction.modify_reputation(+passenger.reputation_value)

# VIP stirbt
if passenger_type == VIP and status == DIED:
    Faction.modify_reputation(-50)  # MASSIVER Verlust!
```

---

## Kabinen-Klassen

### Schiffs-Kabinen

| Klasse | Name | Passagiere | Komfort | Kosten |
|--------|------|------------|---------|--------|
| **1** | Economy | Alle außer VIP | Standard | Niedrig |
| **2** | Business | Traveler, VIP | Gut | Mittel |
| **3** | First Class | NUR VIP | Exzellent | Hoch |

### Annehmlichkeiten

**Verfügbare Amenities:**
- **Meals:** Verpflegung
- **Entertainment:** Unterhaltung
- **Privacy:** Privatsphäre
- **Luxury:** Luxus (VIP-only)

**Installation:** Über Module/Crafting-System

---

## Passagier-Operations

### Boarding (Einsteigen)

```gdscript
# Passagiere an Station einsteigen lassen
var boarded = PassengerSystem.board_passengers(
    ship_id,
    station_id,
    max_count  # Optional: Limit
)

# Returns: Array[passenger_ids] die an Bord sind
```

**Requirements:**
- Schiff muss an Station gedockt sein
- Ausreichend Passagierkapazität
- Kabinen-Klasse muss Anforderungen erfüllen

### Delivery (Aussteigen)

```gdscript
# Passagiere am Ziel aussteigen lassen
var delivered = PassengerSystem.deliver_passengers(
    ship_id,
    destination_id  # station_id oder planet_id
)

# Returns: Array[passenger_ids] die ausgestiegen sind
```

**Payment:**
- Automatische Bezahlung bei Delivery
- Reputation-Update
- Passagier-Status → DELIVERED

---

## API Referenz

### Passagier-Generierung

```gdscript
# Einzelnen Passagier generieren
var passenger_id = PassengerSystem.generate_passenger(
    PassengerSystem.PassengerType.VIP,
    "origin_station",
    "destination_planet"
)

# Zufällige Passagiere generieren
PassengerSystem.generate_random_passengers(count)
```

### Queries

```gdscript
# Passagier-Daten
var passenger = PassengerSystem.get_passenger(passenger_id)

# Wartende Passagiere an Ort
var waiting = PassengerSystem.get_passengers_at_location("station_id")

# Passagiere an Bord
var on_ship = PassengerSystem.get_passengers_on_ship(ship_id)

# Statistiken
var waiting_count = PassengerSystem.get_waiting_passenger_count()
var in_transit = PassengerSystem.get_in_transit_count()
```

---

## Integration

### Mit Planet System
- Passagiere reisen zwischen Planeten
- Planets generieren Passagier-Nachfrage
- **Details:** [Planet System](Planets.md)

### Mit Station System
- Stationen als Passagier-Hubs
- Passenger Terminals
- **Details:** [Station System](Stations.md)

### Mit Cargo System
- Passagiere benötigen Kabinen-Slots
- Alternative zu Fracht
- **Details:** [Cargo System](Cargo.md)

---

## Strategische Tipps

### Für Anfänger
1. **Start:** Touristen & Public Transport
2. **Equipment:** Economy Kabinen ausreichend
3. **Routen:** Kurze Strecken zwischen nahen Stationen

### Für Fortgeschrittene
4. **Upgrade:** Business Class Kabinen
5. **Passagiere:** Traveler für bessere Bezahlung
6. **Annehmlichkeiten:** Meals & Entertainment installieren

### Für Profis
7. **VIP-Transport:** First Class + alle Amenities
8. **Deadlines:** Worker-Rushes für Bonusse
9. **Volumen:** Public Transport en masse
10. **Reputation:** VIPs für Fraktions-Ansehen

---

## Risiken

### Combat Risks
- **Passagiere sterben im Kampf**
- VIP-Tod = -50 Reputation!
- Vermeidung: Eskorte, sichere Routen

### Time Pressure
- **Worker Deadlines verfehlen**
- Strafe: Reduzierte Bezahlung
- Lösung: Schnelle Schiffe, kurze Routen

### Komfort-Verlust
- **Unzufriedene Passagiere**
- Niedrige Bezahlung
- Schlechte Reputation

---

**Siehe auch:**
- [Planet System](Planets.md) - Passagier-Ziele
- [Station System](Stations.md) - Passagier-Terminals
- [Cargo System](Cargo.md) - Kabinen vs. Fracht
- [Faction System](../automation/Factions.md) - Reputation

[← Zurück](../INDEX.md)
