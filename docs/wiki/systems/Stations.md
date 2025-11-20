# 🚢 Station System (EVE Online-Inspired)

[← Zurück](../INDEX.md)

## Übersicht

Das Station System verwendet ein modulares EVE Online-inspiriertes Design mit 3 Basisgrößen und Modul-Sockel-System.

**Siehe auch:** [Crafting](Crafting.md) | [Refinery](Refinery.md) | [Fleet](Fleet.md)

---

## Station Sizes (EVE-Inspired)

```gdscript
enum StationSize {
    SMALL = 0,   # "Raitaru-Class" - Basic Operations
    MEDIUM = 1,  # "Astrahus-Class" - Advanced Operations
    LARGE = 2    # "Citadel/Keep-Class" - High-End (Player Endgame)
}
```

### Size Comparison

| Size | EVE Equivalent | Module Sockets | Docking Capacity | Kosten | Player Access |
|------|----------------|----------------|------------------|--------|---------------|
| **SMALL** | Raitaru / Athanor | 5 | 10 Ships | 500k | Early Game |
| **MEDIUM** | Astrahus / Tatara | 12 | 30 Ships | 5M | Mid Game |
| **LARGE** | Fortizar / Keepstar | 25+ | 100 Ships | 50M+ | High-End |

**Copyright-Safe Naming:**
- Verwende generische Namen (Small/Medium/Large Station)
- Mechanik inspiriert von EVE, aber eigene Bezeichnungen

---

## Modular Design System

### Station = Basis + Module

```
Station (Size) + Installed Modules = Capabilities
```

**NICHT** die Station selbst bestimmt Funktionen, sondern die **installierten Module**!

```gdscript
class Station:
    var station_size: StationSize = StationSize.SMALL
    var module_sockets: int = 5
    var installed_modules: Array[StationModule] = []
    var available_sockets: int = 5
```

---

## Station Modules

### Module Categories

```gdscript
enum ModuleCategory {
    REFINERY,          # Ore Processing
    FACTORY,           # Component Manufacturing
    SHIPYARD,          # Ship Construction
    TRADING,           # Market & Commerce
    MILITARY,          # Combat Services
    UTILITY,           # Storage, Docking, etc.
    SOCKET_EXPANDER    # Unlocks more sockets!
}
```

### Module Examples

| Module | Category | Sockets | Funktion |
|--------|----------|---------|----------|
| **Basic Refinery Unit** | REFINERY | 1 | Standard Refining |
| **Advanced Refinery** | REFINERY | 2 | Pure Refining |
| **Component Assembly** | FACTORY | 1 | T1-T3 Crafting |
| **Advanced Assembly** | FACTORY | 2 | T4-T5 Crafting |
| **Ship Construction Bay** | SHIPYARD | 3 | T6 Ships |
| **Market Hub** | TRADING | 1 | Trading Services |
| **Weapon Platform** | MILITARY | 2 | Station Defense |
| **Expanded Docking** | UTILITY | 1 | +10 Docking Slots |
| **Socket Expansion Rig** | SOCKET_EXPANDER | 1 | +3 Sockets! |

---

## Socket Expansion System

### Base Sockets

| Station Size | Base Sockets |
|--------------|--------------|
| SMALL | 5 |
| MEDIUM | 12 |
| LARGE | 25 |

### Socket Expander Modules

**Kritisches Feature:** Module können mehr Sockets freischalten!

```gdscript
# Socket Expansion Rig
class SocketExpanderModule:
    var sockets_required: int = 1
    var sockets_unlocked: int = 3

    # Net Gain: +2 Sockets (3 unlocked - 1 used)
```

**Beispiel:**
```
SMALL Station (5 Sockets)
→ Install Socket Expander (uses 1 socket, unlocks 3)
→ Result: 5 - 1 + 3 = 7 Sockets available

→ Install another Expander (uses 1, unlocks 3)
→ Result: 7 - 1 + 3 = 9 Sockets available
```

**Strategie:**
- Früh Socket Expanders installieren
- Dann Produktions-Module
- Maximale Expansion für Endgame-Stationen

---

## Module Installation

### Installation Process

```gdscript
# Modul installieren
StationSystem.install_module(station_id, {
    "module_type": "advanced_refinery",
    "category": ModuleCategory.REFINERY,
    "sockets_required": 2
})

# Prüfung:
if station.available_sockets < module.sockets_required:
    return "Not enough sockets!"

# Installation
station.installed_modules.append(module)
station.available_sockets -= module.sockets_required
```

### Module Upgrades

```gdscript
# Modul upgraden (T1 → T2)
StationSystem.upgrade_module(station_id, module_id, new_tier: 2)

# Kosten: Credits + Materials
# Sockets bleiben gleich
```

---

## Station Capabilities

### Capability durch Module

```gdscript
# Station Services basieren auf installierten Modulen
func get_station_capabilities(station_id: String) -> Array[String]:
    var capabilities = []

    for module in station.installed_modules:
        match module.category:
            ModuleCategory.REFINERY:
                capabilities.append("refining")
            ModuleCategory.FACTORY:
                capabilities.append("crafting")
            ModuleCategory.SHIPYARD:
                capabilities.append("ship_construction")
            ModuleCategory.TRADING:
                capabilities.append("market")

    return capabilities
```

**Beispiel-Station:**
```
MEDIUM Station (12 Sockets)
Modules:
- Socket Expander x2 (2 sockets, +6 total)
- Advanced Refinery (2 sockets)
- Component Assembly (1 socket)
- Advanced Assembly (2 sockets)
- Market Hub (1 socket)
- Expanded Docking (1 socket)

Available: 12 - 2 + 6 - 6 = 10 sockets remaining

Capabilities: Refining (Pure), Crafting (T1-T5), Trading, 40 Docks
```

---

## Refinery Stations (EVE "Ore Company" Equivalent)

**Copyright-Safe Implementation:**

```gdscript
# "Ore Processing Complex" statt "ORE Company"
class RefineryStation:
    var station_size: StationSize = StationSize.MEDIUM
    var refinery_modules: Array[RefineryModule] = []
    var ore_storage: int = 500000
```

**Optimierte Refinery-Configuration:**
```
MEDIUM Station - "Ore Processing Complex"
Modules:
- Socket Expander x2 (+4 net sockets)
- Advanced Refinery x4 (Pure Refining)
- Ore Compression Unit x2 (25% volume reduction)
- Expanded Storage x2 (+200k storage)

Perfect for: Mining Operations, Ore Processing
```

---

## EVE-Style Features

### 1. Player-Owned Structures (v2.1)

```gdscript
# Player deployed station
var station_id = StationSystem.deploy_player_station(
    position: Vector2(10000, 10000),
    size: StationSize.SMALL,
    faction_id: "player_faction"
)

# Kosten: 500k Credits + Materials
```

### 2. Station Defense (v2.2)

```gdscript
# Weapon Platforms (EVE-Style)
StationSystem.install_module(station_id, {
    "module_type": "missile_battery",
    "category": ModuleCategory.MILITARY,
    "dps": 500
})
```

### 3. Access Control (v2.2)

```gdscript
# ACL System (wie EVE)
StationSystem.set_access_control(station_id, {
    "owner": "player_faction",
    "allies": ["faction_uec"],
    "public_docking": true,
    "public_market": false
})
```

---

## NICHT implementiert (EVE Moon Mining)

**Was der User NICHT will:**
- ❌ Mobile Stationen an Monden
- ❌ Athanor-Style Moon Mining
- ❌ Separate Strukturen außerhalb der Station

**Stattdessen:**
- ✅ Alles IN der Station
- ✅ Module IN Sockets
- ✅ Keine mobilen Strukturen

---

## Docking System

### Docking Capacity

```gdscript
# Base Docking
var base_docking = {
    StationSize.SMALL: 10,
    StationSize.MEDIUM: 30,
    StationSize.LARGE: 100
}

# Mit Expanded Docking Module
for module in installed_modules:
    if module.type == "expanded_docking":
        total_docking += 10
```

### Docking Procedure

```gdscript
# Unverändert von vorher
var dock_id = StationSystem.request_docking(station_id)

if dock_id == -1:
    print("No free docking slots!")
    return

StationSystem.dock_at_station(station_id, dock_id)
```

---

## Storage Management

### Storage durch Module

```gdscript
# Base Storage
var base_storage = {
    StationSize.SMALL: 50000,
    StationSize.MEDIUM: 200000,
    StationSize.LARGE: 1000000
}

# Expanded Storage Module
class ExpandedStorageModule:
    var additional_capacity: int = 100000
```

---

## API Referenz

```gdscript
# Station deployen (Player)
var station_id = StationSystem.deploy_player_station(position, size, faction)

# Modul installieren
StationSystem.install_module(station_id, module_config)

# Modul entfernen
StationSystem.uninstall_module(station_id, module_id)

# Station Info
var info = StationSystem.get_station_info(station_id)
# Returns: {
#   size: StationSize.MEDIUM,
#   total_sockets: 16,  # 12 base + 4 from expanders
#   available_sockets: 6,
#   installed_modules: [...],
#   capabilities: ["refining", "crafting", "market"]
# }

# Verfügbare Sockets
var sockets = StationSystem.get_available_sockets(station_id)
```

---

## Signale

```gdscript
signal station_deployed(station_id: String, owner: String)
signal module_installed(station_id: String, module_id: String)
signal module_uninstalled(station_id: String, module_id: String)
signal sockets_expanded(station_id: String, new_total: int)
signal docking_requested(ship_id: String, station_id: String)
signal docking_completed(ship_id: String, station_id: String)
signal access_denied(ship_id: String, station_id: String, reason: String)
```

---

## Integration

### Mit Crafting
- Factory Modules → Crafting Capabilities
- Tier durch Module bestimmt
- **Details:** [Crafting](Crafting.md)

### Mit Refinery
- Refinery Modules → Ore Processing
- Pure Refining benötigt Advanced Module
- **Details:** [Refinery](Refinery.md)

### Mit Fleet
- Auto-Docking für Fleet Ships
- Cargo Transfer an Player Stations
- **Details:** [Fleet](Fleet.md)

---

## Progression Path

### Early Game
1. **NPC-Stationen nutzen** - Keine eigenen Stationen
2. **Services lernen** - Refining, Crafting verstehen

### Mid Game
1. **SMALL Station deployen** (500k)
2. **Socket Expander** installieren (+2-4 sockets)
3. **Basic Modules** - Refinery, Factory
4. **Profitabel machen** - Trading, Production

### Late Game
1. **MEDIUM Station** (5M)
2. **Multiple Expanders** (+8-12 sockets)
3. **Advanced Modules** - Shipyard, Military
4. **Empire Building** - Multiple Stationen

### Endgame
1. **LARGE Station / Citadel** (50M+)
2. **Maximum Sockets** (40-50+)
3. **Full Capabilities** - Alles möglich
4. **Faction Hub** - Zentrale für gesamte Faction

---

## Tipps

1. **Socket Expanders first**: Maximale Flexibilität
2. **Spezialisierung**: Refinery-Station, Factory-Station, etc.
3. **Standort wichtig**: Nahe Ressourcen oder Trade Routes
4. **Defense**: Weapon Platforms in unsicheren Gebieten
5. **ACL richtig setzen**: Public für Trading, Private für Production
6. **Backup-Stationen**: Nie nur eine Station haben

---

**Siehe auch:**
- [Crafting System](Crafting.md) - Factory Modules
- [Refinery System](Refinery.md) - Refinery Modules
- [Fleet Automation](Fleet.md) - Station Integration
- [Factions](../automation/Factions.md) - Station Ownership

[← Zurück](../INDEX.md)
