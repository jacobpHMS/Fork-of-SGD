# Extended Development Roadmap - Living Universe Features

**Project:** SpaceGameDev - Living Universe Expansion
**Planning Date:** 2025-11-19
**Base Version:** 2.0
**Target Version:** 4.0 (Living Universe)

---

## 🌌 Extended Vision Statement

Transform SpaceGameDev into a **living, breathing universe** with:
- 💰 **Player-driven economy** (Supply & Demand, Market dynamics)
- 🏛️ **Territory control** (EVE/X4-style sovereignty)
- 🚀 **Deep manufacturing** (Blueprints, Research & Development)
- 🌍 **Colony management** (Terraforming, Population growth)
- 🤖 **Living NPC economy** (NPC corps, AI-driven wars)
- 🕳️ **Exotic physics** (Black holes, Time dilation)
- 🎭 **Social systems** (Walk in stations, Player housing)
- 📖 **Rich storytelling** (Dialog system, Storylines)

---

## 📅 Extended Release Timeline

```
v2.0 (Current)
    │
    ├─► v3.0 (Base Systems) ────────────── 8 weeks
    │   ├─ MarketSystem (Dynamic economy)
    │   ├─ DialogSystem + LocalizationSystem
    │   ├─ TerritorySystem (Basic sovereignty)
    │   └─ BlueprintSystem (Manufacturing)
    │
    ├─► v3.5 (Advanced Economy & Passengers) ── 6 weeks
    │   ├─ Advanced Market features
    │   ├─ Extended Passenger missions
    │   ├─ Commodity Exchange
    │   └─ Trading Contracts
    │
    ├─► v4.0 (Living Universe) ────────── 10 weeks
    │   ├─ Living Universe Simulation
    │   ├─ NPC-Corporations
    │   ├─ AI-Driven Wars
    │   ├─ Economic Cycles
    │   └─ Technology Trees
    │
    └─► v4.5 (Planetary & Social) ──────── 8 weeks
        ├─ Colony Management
        ├─ Terraforming
        ├─ Social Hub System
        ├─ Walk in Stations
        └─ Black Hole Mechanics

Total Extended Timeline: 32 weeks (8 months additional)
```

---

## 🚀 Version 3.0: Foundation Systems (Weeks 1-8)

**Focus:** Core economic and social infrastructure

### 🏗️ Core Systems Implementation

#### 1.3 Dynamische Markt-Wirtschaft
```
[MARKET-001] MarketSystem.gd - Base System
  ├─ Market data structure
  ├─ Station inventory tracking
  ├─ Supply & Demand calculation
  ├─ Price fluctuation algorithm
  ├─ Market history tracking
  └─ Estimated: 12 hours

[MARKET-002] Supply & Demand Engine
  ├─ Consumption rates (per station type)
  ├─ Production rates (from refinery/manufacturing)
  ├─ Price elasticity curves
  ├─ Stock level thresholds
  ├─ Dynamic price updates
  └─ Estimated: 8 hours

[MARKET-003] Market Trends System
  ├─ Weekly/Monthly trend calculation
  ├─ Seasonal variations
  ├─ Event-driven price shocks
  ├─ Trend visualization (charts)
  └─ Estimated: 6 hours

[MARKET-004] Player-Driven Economy
  ├─ Player transaction tracking
  ├─ Market manipulation detection
  ├─ Volume-based price impact
  ├─ Market maker system
  └─ Estimated: 6 hours

[MARKET-005] Trading Contracts
  ├─ Contract template system
  ├─ Long-term trade agreements
  ├─ Contract UI
  ├─ Auto-fulfillment logic
  ├─ Reputation impact
  └─ Estimated: 10 hours

[MARKET-006] Commodity Exchange (Börse)
  ├─ Exchange UI (stock-market style)
  ├─ Buy/Sell orders
  ├─ Order book visualization
  ├─ Price charts (candlestick)
  ├─ Volume indicators
  └─ Estimated: 14 hours

Total Market System: 56 hours
```

#### Dialog & Localization System
```
[DIALOG-001] DialogSystem.gd - Base System
  ├─ Dialog data structure
  ├─ Dialog tree parser
  ├─ Choice/branching logic
  ├─ Variable substitution
  ├─ Condition evaluation
  └─ Estimated: 10 hours

[DIALOG-002] LocalizationSystem Enhancement
  ├─ Translation file structure (JSON/CSV)
  ├─ Language switching
  ├─ Fallback language support
  ├─ Placeholder system ({PLAYER_NAME}, etc.)
  ├─ Context-aware translations
  └─ Estimated: 8 hours

[DIALOG-003] Dialog Database
  ├─ Create dialog templates
  ├─ Standard conversations (100+)
  ├─ Storyline dialogs (50+)
  ├─ Random flavor text (200+)
  ├─ NPC personality variations
  └─ Estimated: 20 hours

[DIALOG-004] Dialog UI
  ├─ Dialog window (Sci-Fi styled)
  ├─ Character portraits
  ├─ Choice buttons
  ├─ Text animations (typewriter effect)
  ├─ Voice-over support (future)
  └─ Estimated: 12 hours

[DIALOG-005] AI Text Generation Preparation
  ├─ Template system for AI generation
  ├─ Prompt engineering
  ├─ Quality validation
  ├─ Fallback to pre-written text
  └─ Estimated: 6 hours

Total Dialog System: 56 hours
```

#### Blueprint & Manufacturing System
```
[BLUEPRINT-001] BlueprintSystem.gd
  ├─ Blueprint data structure
  ├─ Material Efficiency (ME) system
  ├─ Time Efficiency (TE) system
  ├─ Blueprint database integration
  ├─ Blueprint acquisition (drops, purchase)
  └─ Estimated: 10 hours

[BLUEPRINT-002] Research & Development
  ├─ R&D UI
  ├─ Blueprint improvement (ME/TE)
  ├─ Research cost calculation
  ├─ Research time calculation
  ├─ Skill requirements
  └─ Estimated: 8 hours

[BLUEPRINT-003] Manufacturing Integration
  ├─ Enhance CraftingSystem with blueprints
  ├─ ME/TE application to costs
  ├─ Manufacturing jobs queue
  ├─ Station manufacturing slots
  └─ Estimated: 8 hours

[BLUEPRINT-004] Market Seeding (NPC Production)
  ├─ NPC manufacturing simulation
  ├─ Auto-market supply from NPC production
  ├─ Production balancing (prevent oversupply)
  └─ Estimated: 6 hours

Total Blueprint System: 32 hours
```

#### Territory System (Basic Sovereignty)
```
[TERRITORY-001] TerritorySystem.gd
  ├─ Star system ownership tracking
  ├─ Territory data structure
  ├─ Control point system
  ├─ Sovereignty status
  └─ Estimated: 8 hours

[TERRITORY-002] System Ownership Mechanics
  ├─ Player corps can claim systems
  ├─ Ownership requirements (structures)
  ├─ Contested status
  ├─ Territory UI/Map integration
  └─ Estimated: 8 hours

[TERRITORY-003] Territory Benefits
  ├─ Tax income from owned systems
  ├─ Resource bonuses
  ├─ Manufacturing bonuses
  ├─ Benefit calculation
  └─ Estimated: 6 hours

[TERRITORY-004] Basic Siege Mechanics
  ├─ Attack/defend territory
  ├─ Defense timers (24h)
  ├─ Structure reinforcement
  ├─ Siege notifications
  └─ Estimated: 10 hours

Total Territory System: 32 hours
```

---

## 🚀 Version 3.5: Advanced Economy & Passengers (Weeks 9-14)

### 1.2 Erweiterte Passagier-Missionen
```
[PASSENGER-001] Extended PassengerSystem
  ├─ Passenger groups (5-20 persons)
  ├─ Families, Delegations
  ├─ Cabin requirements
  ├─ Passenger comfort system
  └─ Estimated: 8 hours

[PASSENGER-002] VIP Eskorte Missionen
  ├─ High-risk transport missions
  ├─ Threat events during transport
  ├─ Security requirements
  ├─ High rewards calculation
  └─ Estimated: 6 hours

[PASSENGER-003] Event-based Passengers
  ├─ War refugees
  ├─ Emergency evacuations
  ├─ Event-triggered spawning
  ├─ Dynamic pricing
  └─ Estimated: 6 hours

[PASSENGER-004] Luxury Liner Ships
  ├─ New ship type: Luxury Liner
  ├─ 50-200 passenger capacity
  ├─ Specialized modules
  ├─ Ship database entries
  └─ Estimated: 6 hours

[PASSENGER-005] Reputation System
  ├─ Repeat customers
  ├─ Passenger satisfaction rating
  ├─ Loyalty bonuses
  ├─ VIP passenger unlocks
  └─ Estimated: 6 hours

Total Passenger System: 32 hours
```

### 1.5 Erweiterte Karten-Features
```
[MAP-001] Route Planning
  ├─ Multi-system pathfinding (A*)
  ├─ Route cost calculation
  ├─ Route visualization on map
  ├─ Waypoint system
  └─ Estimated: 10 hours

[MAP-002] Jumpgate System - Base
  ├─ Jumpgate node type
  ├─ Gate connection logic
  ├─ Jump travel mechanics
  ├─ Gate UI interaction
  └─ Estimated: 8 hours

[MAP-003] Player-Built Jumpgates
  ├─ Buildable jumpgate structures
  ├─ Multi-phase construction
  │   ├─ Phase 1: Foundation (Components)
  │   ├─ Phase 2: Power Core (Exotic matter)
  │   ├─ Phase 3: Calibration (Mini-game)
  │   └─ Phase 4: Activation
  ├─ Construction cost calculation
  ├─ Construction UI
  └─ Estimated: 14 hours

[MAP-004] Neuverbindungskalibrierungen
  ├─ Special events for new star systems
  ├─ Exploration missions to calibrate
  ├─ New system discovery
  ├─ Colonization unlock
  └─ Estimated: 8 hours

[MAP-005] Map Bookmarks
  ├─ Player can mark positions
  ├─ Bookmark categories (Mining, Combat, Trade)
  ├─ Bookmark sharing (future: multiplayer)
  ├─ Bookmark UI
  └─ Estimated: 4 hours

[MAP-006] Fleet Tracking
  ├─ Show fleet members on map
  ├─ Real-time position updates
  ├─ Formation visualization
  ├─ Fleet commands via map
  └─ Estimated: 6 hours

Total Map Features: 50 hours
```

### Combat Sites & Advanced Features
```
[COMBAT-001] Combat Sites (PvE Dungeons)
  ├─ Site spawning system
  ├─ Wave-based enemy spawns
  ├─ Loot table system
  ├─ Site difficulty scaling
  ├─ Salvage mechanics
  └─ Estimated: 12 hours

Total: 12 hours
```

---

## 🚀 Version 4.0: Living Universe (Weeks 15-24)

### 3.1 Living Universe Simulation
```
[LIVING-001] NPC-Corporations System
  ├─ NPC corp data structure
  ├─ Corp formation/dissolution
  ├─ Corp alliances
  ├─ Corp resources tracking
  ├─ Corp AI decision-making
  └─ Estimated: 16 hours

[LIVING-002] AI-Driven Wars
  ├─ War declaration logic
  ├─ Resource-based conflicts
  ├─ War objectives
  ├─ Peace negotiations
  ├─ War impact on economy
  └─ Estimated: 14 hours

[LIVING-003] Economic Cycles
  ├─ Boom/Bust cycle simulation
  ├─ Regional economic variations
  ├─ Investment mechanics
  ├─ Economic indicators
  └─ Estimated: 10 hours

[LIVING-004] Technology Trees
  ├─ Galactic tech level tracking
  ├─ Tech advancement over time
  ├─ New items unlock
  ├─ Player participation in research
  └─ Estimated: 12 hours

[LIVING-005] Emergent Gameplay
  ├─ Event generation from AI interactions
  ├─ Dynamic mission creation
  ├─ Unpredictable consequences
  ├─ News system integration
  └─ Estimated: 10 hours

[LIVING-006] Historical Events System
  ├─ Galaxy history tracking
  ├─ Major events recording
  ├─ Historical timeline UI
  ├─ Player impact on history
  └─ Estimated: 8 hours

Total Living Universe: 70 hours
```

---

## 🚀 Version 4.5: Planetary & Social (Weeks 25-32)

### Colony Management
```
[COLONY-001] Colony System
  ├─ Colony data structure
  ├─ Build colony on planet
  ├─ Colony UI
  ├─ Resource requirements
  └─ Estimated: 12 hours

[COLONY-002] Population Growth
  ├─ Population simulation
  ├─ Growth rates
  ├─ Happiness system
  ├─ Population demands
  └─ Estimated: 8 hours

[COLONY-003] Planetary Defense
  ├─ Defense structures
  ├─ Attack/defend mechanics
  ├─ Ground combat (simplified)
  └─ Estimated: 10 hours

[COLONY-004] Terraforming
  ├─ Transform barren → terrestrial
  ├─ Multi-phase terraforming
  ├─ Terraforming equipment
  ├─ Atmosphere/Water/Life phases
  └─ Estimated: 12 hours

[COLONY-005] Orbital Bombardment
  ├─ Bomb from orbit
  ├─ Collateral damage
  ├─ War crime consequences
  └─ Estimated: 6 hours

Total Colony System: 48 hours
```

### 3.5 Social Hub System
```
[SOCIAL-001] Walk in Stations (WiS)
  ├─ Station interior scenes
  ├─ Character controller (walking)
  ├─ First-person mode
  ├─ Interior navigation
  └─ Estimated: 20 hours

[SOCIAL-002] Cantinas & Bars
  ├─ Social gathering spaces
  ├─ NPC characters
  ├─ Ambient dialog
  ├─ Player interactions
  └─ Estimated: 10 hours

[SOCIAL-003] Player Housing
  ├─ Apartments in stations
  ├─ Furniture placement
  ├─ Decoration system
  ├─ Storage in apartments
  └─ Estimated: 14 hours

[SOCIAL-004] Avatar Customization
  ├─ Character creator
  ├─ Body/face customization
  ├─ Clothing system
  ├─ Avatar saving
  └─ Estimated: 16 hours

[SOCIAL-005] Emotes & Gestures
  ├─ Emote animations
  ├─ Gesture wheel UI
  ├─ Social interactions
  └─ Estimated: 8 hours

[SOCIAL-006] Ship Naming
  ├─ Name input UI
  ├─ Name validation
  ├─ Name display on ship
  └─ Estimated: 2 hours

[SOCIAL-007] Killmail System
  ├─ Combat logging
  ├─ Killmail generation
  ├─ News system integration
  ├─ Killmail sharing
  └─ Estimated: 6 hours

Total Social Hub: 76 hours
```

### Black Hole Mechanics
```
[BLACKHOLE-001] Black Hole Systems
  ├─ Black hole celestial type
  ├─ Gravity well mechanics
  ├─ Visual effects (distortion)
  ├─ Extreme danger zones
  └─ Estimated: 10 hours

[BLACKHOLE-002] Time Dilation
  ├─ Time passes slower near black holes
  ├─ Relativity calculations
  ├─ UI time display
  ├─ Game balance considerations
  └─ Estimated: 8 hours

[BLACKHOLE-003] Accretion Disk Mining
  ├─ Exotic matter resource
  ├─ High-risk mining
  ├─ Special equipment required
  └─ Estimated: 6 hours

[BLACKHOLE-004] Spaghettification Danger
  ├─ Too close = ship destruction
  ├─ Visual warnings
  ├─ Tidal force damage
  └─ Estimated: 4 hours

[BLACKHOLE-005] Ship Personality
  ├─ Ship develops personality over time
  ├─ Personality traits system
  ├─ Player interaction affects personality
  ├─ Personality dialog/quirks
  └─ Estimated: 12 hours

Total Black Hole Features: 40 hours
```

---

## 📊 Extended Resource Allocation

### Total Development Time
```
Market System:           56 hours
Dialog & Localization:   56 hours
Blueprint System:        32 hours
Territory System:        32 hours
Passenger Extensions:    32 hours
Map Features:            50 hours
Combat Sites:            12 hours
Living Universe:         70 hours
Colony Management:       48 hours
Social Hub:              76 hours
Black Hole Mechanics:    40 hours
─────────────────────────────────
Total:                  504 hours
```

### Budget Estimate
At $100/hour developer rate: **$50,400**

---

## 🎯 Implementation Priority

### Phase 1: Foundation (Weeks 1-4)
1. MarketSystem (critical for economy)
2. DialogSystem + LocalizationSystem (for missions/storylines)
3. BlueprintSystem (for manufacturing)

### Phase 2: Economy & Territory (Weeks 5-8)
4. Advanced Market features
5. TerritorySystem
6. Combat Sites

### Phase 3: Passengers & Map (Weeks 9-14)
7. Extended Passenger missions
8. Route Planning & Jumpgates
9. Map Bookmarks & Fleet Tracking

### Phase 4: Living World (Weeks 15-24)
10. NPC-Corporations
11. AI-Driven Wars
12. Economic Cycles
13. Technology Trees

### Phase 5: Planetary & Social (Weeks 25-32)
14. Colony Management
15. Terraforming
16. Walk in Stations
17. Player Housing
18. Black Hole Mechanics

---

**Document Owner:** Development Team
**Last Updated:** 2025-11-19
**Status:** 📋 Planning Phase
**Next Review:** After base systems prototype
