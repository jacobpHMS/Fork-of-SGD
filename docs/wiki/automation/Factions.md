# 🏛️ Faction System

[← Zurück](../INDEX.md)

## Übersicht

Das Faction System verwaltet Diplomatie, Beziehungen und Reputation zwischen verschiedenen Fraktionen.

**Siehe auch:** [NPC Manager](NPCs.md) | [Combat AI](Combat.md) | [Orchestrator](Orchestrator.md)

---

## Fraktionen

### Standard Factions

| Faction | Organization Type | Size | Planets | Default Relation |
|---------|------------------|------|---------|------------------|
| **Player Faction** | Free Planet | Tiny | 1 | 100 (Player) |
| **Merchants Guild** | Corporation | Large | 15 | 50 (Friendly) |
| **Federation Navy** | Democratic Union | Empire | 25 | 0 (Neutral) |
| **Pirate Clans** | Pirate Clan | Medium | 8 | -80 (Hostile) |
| **Independent Systems** | Free Planet | Small | 3 | 30 (Unfriendly) |
| **Feudal Empire** | Feudal System | Large | 12 | 0 (Neutral) |
| **MegaCorp Industries** | Corporation | Medium | 9 | -20 (Unfriendly) |

**Siehe auch:** [Reference - Factions](../reference/Factions.md) | [Planet System](../systems/Planets.md)

---

## Relationship System

### Relationship Values

```gdscript
# Range: -100 bis +100
-100 to -60: WAR
-59 to -20:  HOSTILE
-19 to 20:   UNFRIENDLY
21 to 50:    NEUTRAL
51 to 80:    FRIENDLY
81 to 100:   ALLIED
```

### Relationship States

```gdscript
enum RelationshipState {
    WAR = 0,        # -100 to -60: Aktiver Krieg
    HOSTILE = 1,    # -59 to -20: Feindlich, greift an
    UNFRIENDLY = 2, # -19 to 20: Misstrauisch
    NEUTRAL = 3,    # 21 to 50: Neutral
    FRIENDLY = 4,   # 51 to 80: Freundlich
    ALLIED = 5      # 81 to 100: Verbündet
}
```

---

## Reputation Changes

### Dynamic Reputation

**Events die Reputation ändern:**

| Event | Reputation Change |
|-------|-------------------|
| **Trade mit Faction** | +1 bis +5 |
| **Mission Complete** | +10 bis +30 |
| **NPC zerstört** | -20 bis -50 |
| **Station zerstört** | -100 (War!) |
| **Pirate Kill** | +5 (bei Lawful) |
| **Police Kill** | -30 (bei Lawful) |

```gdscript
# Beispiel: Pirate Kill
FactionSystem.modify_reputation("player_faction", "UEC", +5)
FactionSystem.modify_reputation("player_faction", "pirates", -10)
```

### Reputation Decay

**Über Zeit normalisieren sich Beziehungen:**

```gdscript
# Jeden Tag (in-game)
if reputation > 0:
    reputation -= 0.5  # Positive Reputation verfällt
elif reputation < 0:
    reputation += 1.0  # Negative Reputation erholt sich langsam

# Ausnahme: WAR-Status bleibt bis explizit beendet
```

---

## Faction Behaviors

### Aggression Traits

```gdscript
class FactionData:
    var base_aggression: float = 0.5  # 0.0 = Peaceful, 1.0 = Always Hostile
    var territorial: bool = false     # Greift in eigenem Gebiet an
    var piracy: bool = false          # Überfällt Transporter
```

**Beispiele:**
- **UEC**: base_aggression = 0.2, territorial = true
- **Pirates**: base_aggression = 0.9, piracy = true
- **Traders**: base_aggression = 0.0, defensive only

### Peace Traits

```gdscript
var peaceful_factions = ["traders", "civilians"]
# Greifen nie zuerst an, nur Verteidigung
```

---

## Faction-wide Effects

### Alliance Benefits

**Bei ALLIED Status (81-100):**
- Zugang zu speziellen Stationen
- Bessere Handelspreise (-10%)
- Militärische Unterstützung
- Shared Information Network

### War Consequences

**Bei WAR Status (-100 to -60):**
- Alle Faction-Schiffe greifen an
- Kein Docking an Faction-Stationen
- Bounty auf Kopf (Andere greifen an)
- Territorium ist No-Go-Zone

---

## Faction Territories

### Territory Control

```gdscript
var faction_territories = {
    "UEC": [
        {"center": Vector2(10000, 10000), "radius": 5000},
        {"center": Vector2(20000, 15000), "radius": 3000}
    ],
    "pirates": [
        {"center": Vector2(-5000, -5000), "radius": 2000}
    ]
}
```

**Territorial Behavior:**
- Faction ist aggressiver in eigenem Gebiet
- Mehr Patrols in Territory
- Schnellere Reinforcements

**Siehe:** [Patrol System](Patrols.md)

---

## Organisationstypen (NEU!)

### Faction Organization Types

Fraktionen haben verschiedene Organisationsformen, die ihr Verhalten stark beeinflussen:

| Typ | Beschreibung | Eigenschaften |
|-----|--------------|---------------|
| **FREE_PLANET** | Freier Planet | Kann keinen Krieg führen, sehr offen |
| **PLANETARY_ALLIANCE** | Planetenverbund | Fokus auf Allianzen & Handel |
| **FEUDAL_SYSTEM** | Feudalsystem | Aggressiv, hierarchisch, expansiv |
| **CORPORATION** | Megacorp | Handels-fokussiert, aggressive Expansion |
| **COMPANY** | Firma | Wie Corp, aber kleiner |
| **MILITARY_JUNTA** | Militärregierung | Sehr aggressiv, +50% Military Power |
| **DEMOCRATIC_UNION** | Demokratische Union | Sehr offen, friedlich, Allianzen |
| **PIRATE_CLAN** | Piratenclan | Extrem aggressiv, kein Handel |
| **RELIGIOUS_ORDER** | Religiöse Ordnung | Expansiv, moderate Aggression |
| **AI_COLLECTIVE** | KI-Kollektiv | Rapid Expansion, schwer zu verhandeln |

### Faction Size Categories

| Size | Planeten | Kriegsfähigkeit |
|------|----------|-----------------|
| **TINY** | 1-2 | Nein |
| **SMALL** | 3-5 | Nein |
| **MEDIUM** | 6-10 | Ja |
| **LARGE** | 11-20 | Ja |
| **EMPIRE** | 20+ | Ja, große Kriege |

**Nur MEDIUM+ Fraktionen können große Kriege führen!**

---

## Dynamisches Fraktionsverhalten (NEU!)

### Kriegserklärungen

Große Fraktionen (Medium+) können automatisch Kriege erklären:

```gdscript
# 1% Chance pro World Tick
if randf() < 0.01 and faction.can_engage_in_large_scale_war():
    FactionSystem.declare_war(attacker_id, defender_id)
```

**War Declaration Requirements:**
- Beide Fraktionen müssen MEDIUM+ sein
- Relationship muss HOSTILE/UNFRIENDLY sein
- Oder basierend auf Aggression-Level

**War Effects:**
- Relationship → HOSTILE
- Alle Schiffe der Fraktionen greifen sich an
- Allianzen werden gebrochen
- Security in Systemen sinkt (zukünftig)

### Allianzen

Große Fraktionen können Allianzen bilden:

```gdscript
# 5% Chance pro World Tick
if randf() < 0.05 and relationship >= FRIENDLY:
    FactionSystem.form_alliance(faction_a, faction_b)
```

**Alliance Benefits:**
- Relationship → ALLIED
- Mutual Defense (zukünftig)
- Shared Information Network (zukünftig)
- Trade Bonuses (zukünftig)

### Friedensverhandlungen

Kriege können automatisch enden:

```gdscript
# Wenn Relationship über -30 steigt
if relationship > -30.0:
    FactionSystem.end_war(faction_a, faction_b)
```

**Peace Treaty Effects:**
- War Status endet
- Relationship +20
- Handel wieder möglich

---

## Faction Events

Das System trackt alle wichtigen Events:

```gdscript
var faction_events = [
    {
        "type": "war_declared",
        "faction_a": "military",
        "faction_b": "pirates",
        "time": 12345.0
    },
    {
        "type": "alliance_formed",
        "faction_a": "merchants",
        "faction_b": "player",
        "time": 12400.0
    }
]
```

**Event Types:**
- `war_declared`
- `alliance_formed`
- `peace_signed`
- `planet_conquered` (zukünftig)
- `treaty_broken` (zukünftig)

**Siehe:** [Patrol System](Patrols.md)

---

## API Referenz

```gdscript
# Reputation abfragen
var rep = FactionSystem.get_reputation("player_faction", "UEC")
# Returns: 50 (NEUTRAL)

# Relationship State
var state = FactionSystem.get_relationship_state("player_faction", "pirates")
# Returns: RelationshipState.HOSTILE

# Reputation ändern
FactionSystem.modify_reputation("player_faction", "UEC", +10)

# Faction Data
var faction = FactionSystem.get_faction_data("pirates")
# Returns: {aggression: 0.9, piracy: true, ...}

# Territory Check
var is_in_territory = FactionSystem.is_in_faction_territory(
    position,
    "UEC"
)
```

---

## Signale

```gdscript
signal reputation_changed(faction_a: String, faction_b: String, new_value: int)
signal relationship_state_changed(faction_a: String, faction_b: String, new_state: RelationshipState)
signal war_declared(faction_a: String, faction_b: String)
signal peace_treaty_signed(faction_a: String, faction_b: String)
signal faction_standing_update(faction: String, standing: String)
```

---

## Integration

### Mit NPC Manager
- NPCs gehören zu Factions
- Verhalten basiert auf Reputation
- **Details:** [NPC Manager](NPCs.md)

### Mit Combat AI
- Aggression Level beeinflusst durch Reputation
- Auto-Attack bei HOSTILE/WAR
- **Details:** [Combat AI](Combat.md)

### Mit Orchestrator
- Faction System = LOW Priority (Update every 10 ticks)
- Reputation-Änderungen werden batched
- **Details:** [Orchestrator](Orchestrator.md)

---

## Diplomatie (Geplant v2.1)

**Zukünftige Features:**
- Player-initiierte Diplomatie
- Faction Missions für Reputation
- Dynamic Faction Wars
- Territory Conquest
- Trade Agreements

---

## Tipps

1. **Neutral bleiben**: Handel mit allen möglich
2. **Alliance wählen**: Bessere Preise & Zugang
3. **Pirate Kills**: Einfacher Weg zu Lawful Reputation
4. **War vermeiden**: Sehr schwer zurückzugewinnen
5. **Territory beachten**: Nicht in feindliches Gebiet
6. **Reputation pflegen**: Trading & Missions

---

**Siehe auch:**
- [NPC Manager](NPCs.md) - NPC Faction Membership
- [Combat AI](Combat.md) - Faction-based Aggression
- [Orchestrator](Orchestrator.md) - Faction Update Priority
- [Reference - Factions](../reference/Factions.md) - Faction Database

[← Zurück](../INDEX.md)
