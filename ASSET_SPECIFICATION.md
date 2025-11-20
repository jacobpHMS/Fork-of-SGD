# 🎨 ASSET SPECIFICATION - SpaceGameDev
## Complete Asset Production Guide & Naming Convention System

**Version:** 2.0
**Last Updated:** 2025-11-19
**Total Assets Required:** ~3,500+ individual files
**Purpose:** Production-ready asset specification with automated naming for direct integration

---

## 📋 TABLE OF CONTENTS

1. [Quick Start Guide](#quick-start-guide)
2. [Master Naming Convention](#master-naming-convention)
3. [Folder Structure](#folder-structure)
4. [Ships (Player & NPC)](#ships-player--npc)
5. [Items & Icons (910 Items)](#items--icons-910-items)
6. [Planets (1000 Variants)](#planets-1000-variants)
7. [Asteroids & Mining](#asteroids--mining)
8. [Stations & Structures](#stations--structures)
9. [Effects & VFX](#effects--vfx)
10. [UI Elements](#ui-elements)
11. [NPC Avatars & Characters](#npc-avatars--characters)
12. [Backgrounds & Parallax](#backgrounds--parallax)
13. [Mining Minigame Assets](#mining-minigame-assets)
14. [Cursors & Mouse States](#cursors--mouse-states)
15. [Storyline Assets](#storyline-assets)
16. [Animation Specifications](#animation-specifications)
17. [Integration Checklist](#integration-checklist)

---

## 🚀 QUICK START GUIDE

### How to Use This Document

1. **Find the asset category** you need (Ships, Items, Planets, etc.)
2. **Check the naming pattern** (e.g., `ship_player_explorer_idle.png`)
3. **Create the asset** with the exact filename
4. **Place it in the correct folder** (e.g., `assets/sprites/ships/player/`)
5. **The game will auto-load it** via AssetManager.gd

### Naming Formula

```
[category]_[subcategory]_[descriptor]_[variant]_[state]_[size].[extension]

Examples:
- ship_player_explorer_idle_128.png
- icon_ore_ferralite_t1_32.png
- planet_gas_jupiter_variant01_512.png
- fx_explosion_large_spritesheet_1024.png
- cursor_mining_active_32.png
```

### Critical Rules

✅ **DO:**
- Use **lowercase** only
- Use **underscores** (not spaces or hyphens)
- Match **exact IDs** from databases (ORE_T1_001 → ore_t1_001)
- Include **size suffix** for sprites (32, 64, 128, 256, 512, 1024)
- Use **spritesheet** suffix for animations

❌ **DON'T:**
- Use spaces, special characters, or German umlauts
- Mix case (ShipPlayer.png ❌)
- Use generic names (image1.png ❌)
- Skip size suffixes

---

## 🎯 MASTER NAMING CONVENTION

### Category Prefixes

| Prefix | Category | Example |
|--------|----------|---------|
| `ship_` | Ships | `ship_player_explorer_idle_128.png` |
| `icon_` | Item icons | `icon_ore_ferralite_32.png` |
| `asteroid_` | Asteroids | `asteroid_iron_small_01_64.png` |
| `station_` | Stations | `station_refinery_large_512.png` |
| `planet_` | Planets | `planet_rocky_mars_256.png` |
| `bg_` | Backgrounds | `bg_nebula_purple_layer1_1920.png` |
| `fx_` | Effects/VFX | `fx_explosion_small_spritesheet_512.png` |
| `ui_` | UI elements | `ui_button_primary_normal_200.png` |
| `npc_` | NPC avatars | `npc_avatar_trader_male_01_128.png` |
| `cursor_` | Cursors | `cursor_default_32.png` |
| `module_` | Ship modules | `module_mining_laser_t1_64.png` |
| `particle_` | Particles | `particle_engine_exhaust_32.png` |

### State Suffixes

| Suffix | Meaning | Usage |
|--------|---------|-------|
| `_idle` | Default/resting | Ships, NPCs |
| `_thrust` | Moving/accelerating | Ships |
| `_damaged` | Damaged state | Ships, stations |
| `_destroyed` | Destroyed state | All entities |
| `_active` | Active/in-use | Modules, UI |
| `_inactive` | Inactive/disabled | Modules, UI |
| `_hover` | Mouse hover | UI buttons |
| `_pressed` | Mouse pressed | UI buttons |
| `_disabled` | Cannot interact | UI buttons |
| `_normal` | Default UI state | UI elements |
| `_spritesheet` | Animation frames | Animations |

### Size Suffixes

| Size | Pixels | Usage |
|------|--------|-------|
| `_16` | 16×16 | Small particles, minimap dots |
| `_32` | 32×32 | Item icons, cursors |
| `_64` | 64×64 | Small asteroids, modules |
| `_128` | 128×128 | Standard ships, NPCs |
| `_256` | 256×256 | Large ships, planets |
| `_512` | 512×512 | Stations, large planets |
| `_1024` | 1024×1024 | Capital ships, backgrounds |
| `_1920` | 1920×1080 | Full-screen backgrounds |

---

## 📁 FOLDER STRUCTURE

```
SpaceGameDev/
└── assets/
    ├── sprites/
    │   ├── ships/
    │   │   ├── player/           # Player ships (9 types)
    │   │   ├── npc/              # NPC ships (50+ types)
    │   │   └── modules/          # Ship modules (visible equipment)
    │   ├── items/
    │   │   ├── icons/            # All 910 item icons
    │   │   │   ├── ores/         # Ore icons (40 types)
    │   │   │   ├── minerals/     # Mineral icons (40 types)
    │   │   │   ├── gases/        # Gas icons (20 types)
    │   │   │   ├── components/   # Component icons (300+ types)
    │   │   │   ├── weapons/      # Weapon icons (100+ types)
    │   │   │   ├── ammunition/   # Ammo icons (50+ types)
    │   │   │   └── modules/      # Module icons (200+ types)
    │   │   └── cargo/            # 3D cargo representations
    │   ├── planets/
    │   │   ├── gas_giants/       # 200 variants
    │   │   ├── rocky/            # 300 variants
    │   │   ├── ice/              # 200 variants
    │   │   ├── lava/             # 100 variants
    │   │   ├── desert/           # 100 variants
    │   │   └── exotic/           # 100 variants
    │   ├── asteroids/
    │   │   ├── ore_asteroids/    # By ore type
    │   │   └── variants/         # Size variations
    │   ├── stations/
    │   │   ├── small/            # Small stations
    │   │   ├── medium/           # Medium stations
    │   │   ├── large/            # Large stations
    │   │   └── modules/          # Station modules (visible)
    │   ├── environment/
    │   │   ├── nebulae/          # Gas clouds, nebulae
    │   │   ├── backgrounds/      # Space backgrounds
    │   │   └── parallax/         # Parallax layers
    │   ├── npcs/
    │   │   ├── avatars/          # NPC portraits
    │   │   ├── factions/         # Faction logos
    │   │   └── story/            # Story characters
    │   ├── ui/
    │   │   ├── hud/              # HUD elements
    │   │   ├── buttons/          # Buttons (all states)
    │   │   ├── panels/           # Windows, panels
    │   │   ├── icons/            # UI icons
    │   │   └── cursors/          # Mouse cursors
    │   └── effects/
    │       ├── explosions/       # Explosion spritesheets
    │       ├── lasers/           # Laser beams
    │       ├── shields/          # Shield effects
    │       ├── mining/           # Mining effects
    │       └── particles/        # Particle textures
    └── audio/
        ├── sfx/
        │   ├── ships/
        │   ├── weapons/
        │   ├── mining/
        │   ├── ui/
        │   └── environment/
        └── music/
```

---

## 🚀 SHIPS (PLAYER & NPC)

### Player Ships (9 Types)

Based on ShipDatabase.gd classes:

#### 1. Explorer Class (Starter Ship)
```
Required Assets:
├── ship_player_explorer_idle_128.png
├── ship_player_explorer_thrust_128.png
├── ship_player_explorer_damaged_128.png
├── ship_player_explorer_destroyed_spritesheet_1024.png (16 frames, 8×2 grid)
├── ship_player_explorer_icon_64.png
└── ship_player_explorer_engine_glow_32.png

Specifications:
- Size: 128×128 pixels (standard)
- Style: Versatile, balanced design
- Colors: Silver/blue tones
- Features: Medium-sized, jack-of-all-trades
```

#### 2. Miner Class
```
Required Assets:
├── ship_player_miner_idle_128.png
├── ship_player_miner_thrust_128.png
├── ship_player_miner_mining_128.png (with laser beam active)
├── ship_player_miner_damaged_128.png
├── ship_player_miner_icon_64.png
└── module_mining_laser_visible_64.png (attached to ship)

Specifications:
- Size: 128×128 pixels
- Style: Industrial, bulky
- Colors: Yellow/orange industrial tones
- Features: Large cargo holds, mining equipment
```

#### 3. Fighter Class
```
Required Assets:
├── ship_player_fighter_idle_128.png
├── ship_player_fighter_thrust_128.png
├── ship_player_fighter_combat_128.png (weapons visible)
├── ship_player_fighter_damaged_128.png
└── ship_player_fighter_icon_64.png

Specifications:
- Size: 128×128 pixels
- Style: Sleek, aggressive
- Colors: Red/black combat tones
- Features: Weapon hardpoints, compact design
```

#### 4-9. Additional Player Ships
```
ship_player_corvette_*_128.png       # Medium combat ship
ship_player_frigate_*_128.png        # Large combat ship
ship_player_trader_*_128.png         # Cargo hauler
ship_player_transport_*_128.png      # Bulk transport
ship_player_special_stealth_*_128.png # Stealth ship
ship_player_special_science_*_128.png # Science vessel
```

### NPC Ships (50+ Types)

#### By Faction:

**Neutral Traders (10 types)**
```
ship_npc_trader_small_01_idle_128.png
ship_npc_trader_small_02_idle_128.png
...
ship_npc_trader_large_01_idle_256.png
```

**Pirates (10 types)**
```
ship_npc_pirate_fighter_01_idle_128.png
ship_npc_pirate_fighter_02_idle_128.png
...
ship_npc_pirate_corvette_01_idle_128.png
```

**Police (5 types)**
```
ship_npc_police_patrol_01_idle_128.png
ship_npc_police_interceptor_01_idle_128.png
ship_npc_police_cruiser_01_idle_256.png
```

**Miners (5 types)**
```
ship_npc_miner_basic_01_idle_128.png
ship_npc_miner_advanced_01_idle_128.png
```

**Capital Ships (5 types)**
```
ship_npc_capital_battleship_01_idle_512.png
ship_npc_capital_carrier_01_idle_512.png
ship_npc_capital_dreadnought_01_idle_512.png
```

### Ship Module Overlays (Visible Equipment)

```
Weapons:
├── module_weapon_laser_t1_32.png
├── module_weapon_laser_t2_32.png
├── module_weapon_cannon_t1_48.png
├── module_weapon_missile_launcher_48.png
└── module_weapon_railgun_64.png

Mining:
├── module_mining_laser_t1_32.png
├── module_mining_laser_t2_32.png
└── module_mining_drill_48.png

Engines:
├── module_engine_basic_glow_32.png
├── module_engine_advanced_glow_48.png
└── module_engine_warp_glow_64.png

Utilities:
├── module_shield_emitter_32.png
├── module_scanner_dish_32.png
└── module_cargo_pod_48.png
```

**Total Ship Assets: ~350 files**

---

## 📦 ITEMS & ICONS (910 Items from ItemDatabase)

### Naming Pattern for Item Icons

```
icon_[category]_[item_name]_[tier]_32.png

Examples from ItemDatabase.gd:
- ORE_T1_001 (Ferralite) → icon_ore_ferralite_t1_32.png
- ORE_T1_002 (Metalite) → icon_ore_metalite_t1_32.png
- MIN_T1_001 (Iron Ingot) → icon_mineral_iron_ingot_t1_32.png
- COMP_T1_001 (Compressor) → icon_component_compressor_t1_32.png
```

### Ores (40+ types, Tiers 1-3)

```
Tier 1 Ores (Common):
├── icon_ore_ferralite_t1_32.png     # ORE_T1_001
├── icon_ore_metalite_t1_32.png      # ORE_T1_002
├── icon_ore_cupreon_t1_32.png       # ORE_T1_003
├── icon_ore_cuprex_t1_32.png        # ORE_T1_004
├── icon_ore_palestone_t1_32.png     # ORE_T1_005
├── icon_ore_titanex_t1_32.png       # ORE_T1_006
├── icon_ore_densore_t1_32.png       # ORE_T1_007
├── icon_ore_mirrorvein_t1_32.png    # ORE_T1_008
├── icon_ore_azurex_t1_32.png        # ORE_T1_009
└── icon_ore_sunvein_t1_32.png       # ORE_T1_010

Tier 2 Ores (Uncommon):
├── icon_ore_chromore_t2_32.png      # ORE_T2_011
├── icon_ore_noblore_t2_32.png       # ORE_T2_012
├── icon_ore_abyssite_t2_32.png      # ORE_T2_013
├── icon_ore_radiantweave_t2_32.png  # ORE_T2_014
└── icon_ore_fluxore_t2_32.png       # ORE_T2_015

Tier 3 Ores (Rare):
├── icon_ore_neutronite_t3_32.png
├── icon_ore_chromatite_t3_32.png
└── icon_ore_voidstone_t3_32.png
```

**Visual Guidelines for Ore Icons:**
- **T1:** Simple rock texture, basic colors (gray, brown, copper)
- **T2:** More detailed, metallic sheen, special colors (silver, blue)
- **T3:** Glowing veins, particle effects, rare colors (purple, gold)
- **Size:** 32×32 pixels (will be auto-scaled by AssetManager)
- **Format:** PNG with transparency
- **Style:** Top-down view, slight 3D depth

### Minerals (40+ types, Refined from Ores)

```
Tier 1 Minerals:
├── icon_mineral_iron_ingot_t1_32.png
├── icon_mineral_copper_ingot_t1_32.png
├── icon_mineral_aluminum_ingot_t1_32.png
└── icon_mineral_titanium_ingot_t1_32.png

Tier 2 Minerals:
├── icon_mineral_chromium_ingot_t2_32.png
├── icon_mineral_platinum_ingot_t2_32.png
└── icon_mineral_depleted_uranium_t2_32.png

Tier 3 Minerals:
├── icon_mineral_neutronium_ingot_t3_32.png
└── icon_mineral_quantum_metal_t3_32.png
```

**Visual Guidelines for Mineral Icons:**
- **T1:** Ingot/bar shape, metallic texture
- **T2:** Polished, high-quality finish, reflections
- **T3:** Energy glow, advanced materials, sci-fi look

### Gases (20+ types)

```
├── icon_gas_hydrogen_32.png
├── icon_gas_helium_32.png
├── icon_gas_nitrogen_32.png
├── icon_gas_oxygen_32.png
├── icon_gas_methane_32.png
├── icon_gas_ammonia_32.png
├── icon_gas_plasma_rare_32.png
└── icon_gas_exotic_dark_matter_32.png
```

**Visual Guidelines:**
- Cloud/gas canister representation
- Color-coded by gas type (H2=blue, O2=cyan, plasma=purple)
- Transparent/translucent effects

### Components (300+ types)

```
Basic Components:
├── icon_component_compressor_t1_32.png
├── icon_component_heat_sink_t1_32.png
├── icon_component_power_cell_t1_32.png
├── icon_component_circuit_board_t1_32.png
└── icon_component_servo_motor_t1_32.png

Advanced Components:
├── icon_component_quantum_core_t2_32.png
├── icon_component_fusion_reactor_t2_32.png
├── icon_component_warp_coil_t2_32.png
└── icon_component_ai_chip_t2_32.png

Elite Components:
├── icon_component_antimatter_containment_t3_32.png
├── icon_component_singularity_generator_t3_32.png
└── icon_component_hyperspace_matrix_t3_32.png
```

### Weapons (100+ types)

```
Lasers:
├── icon_weapon_laser_basic_t1_32.png
├── icon_weapon_laser_pulse_t2_32.png
└── icon_weapon_laser_beam_t3_32.png

Projectile:
├── icon_weapon_autocannon_t1_32.png
├── icon_weapon_railgun_t2_32.png
└── icon_weapon_gauss_cannon_t3_32.png

Missiles:
├── icon_weapon_missile_launcher_light_t1_32.png
├── icon_weapon_missile_launcher_heavy_t2_32.png
└── icon_weapon_torpedo_launcher_t3_32.png
```

### Ammunition (50+ types)

```
├── icon_ammo_laser_charge_t1_32.png
├── icon_ammo_autocannon_rounds_t1_32.png
├── icon_ammo_railgun_slugs_t2_32.png
├── icon_ammo_missile_light_t1_32.png
├── icon_ammo_missile_heavy_t2_32.png
└── icon_ammo_torpedo_plasma_t3_32.png
```

### Ship Modules (200+ types)

```
Mining Modules:
├── icon_module_mining_laser_t1_32.png
├── icon_module_mining_laser_t2_32.png
├── icon_module_ore_scanner_t1_32.png
└── icon_module_refinery_onboard_t2_32.png

Shield Modules:
├── icon_module_shield_generator_t1_32.png
├── icon_module_shield_booster_t2_32.png
└── icon_module_shield_hardener_t3_32.png

Engine Modules:
├── icon_module_engine_basic_t1_32.png
├── icon_module_engine_afterburner_t2_32.png
└── icon_module_engine_warp_drive_t3_32.png

Cargo Modules:
├── icon_module_cargo_expander_t1_32.png
├── icon_module_cargo_optimizer_t2_32.png
└── icon_module_cargo_compression_t3_32.png
```

**Total Item Icons: 910 files (32×32 each)**

---

## 🌍 PLANETS (1,000 Variants)

### Planet Categories

Based on your requirement: "1000 verschiedenen, nach Kategorien"

#### Gas Giants (200 variants)

```
Jupiter-type (50 variants):
├── planet_gas_jupiter_variant001_256.png
├── planet_gas_jupiter_variant002_256.png
...
└── planet_gas_jupiter_variant050_256.png

Saturn-type (50 variants):
├── planet_gas_saturn_variant001_256.png (with rings)
├── planet_gas_saturn_variant002_256.png
...
└── planet_gas_saturn_variant050_256.png

Neptune-type (50 variants):
├── planet_gas_neptune_variant001_256.png
...
└── planet_gas_neptune_variant050_256.png

Exotic Gas Giants (50 variants):
├── planet_gas_exotic_purple_variant001_256.png
├── planet_gas_exotic_green_variant001_256.png
...
└── planet_gas_exotic_black_variant050_256.png
```

**Visual Guidelines:**
- Size: 256×256 standard, 512×512 for close-up views
- Animated cloud layers (optional spritesheets)
- Color variations: orange, red, blue, purple, green
- Band patterns, storms, atmospheric features

#### Rocky Planets (300 variants)

```
Mars-type (100 variants):
├── planet_rocky_mars_variant001_256.png
├── planet_rocky_mars_variant002_256.png
...
└── planet_rocky_mars_variant100_256.png

Earth-type (100 variants):
├── planet_rocky_earth_variant001_256.png (with oceans)
├── planet_rocky_earth_variant002_256.png
...
└── planet_rocky_earth_variant100_256.png

Moon-type (50 variants):
├── planet_rocky_moon_variant001_256.png
...
└── planet_rocky_moon_variant050_256.png

Volcanic (50 variants):
├── planet_rocky_volcanic_variant001_256.png
...
└── planet_rocky_volcanic_variant050_256.png
```

#### Ice Planets (200 variants)

```
Pluto-type (100 variants):
├── planet_ice_pluto_variant001_256.png
...
└── planet_ice_pluto_variant100_256.png

Europa-type (50 variants):
├── planet_ice_europa_variant001_256.png (cracked ice surface)
...
└── planet_ice_europa_variant050_256.png

Frozen Gas (50 variants):
├── planet_ice_frozen_gas_variant001_256.png
...
└── planet_ice_frozen_gas_variant050_256.png
```

#### Lava Planets (100 variants)

```
├── planet_lava_molten_variant001_256.png
├── planet_lava_molten_variant002_256.png
...
└── planet_lava_molten_variant100_256.png
```

**Visual Guidelines:**
- Glowing lava rivers
- Dark rocky surface
- Particle effects (smoke, ash)
- Animated glow (optional)

#### Desert Planets (100 variants)

```
Tatooine-style (50 variants):
├── planet_desert_sand_variant001_256.png
...
└── planet_desert_sand_variant050_256.png

Rocky Desert (50 variants):
├── planet_desert_rocky_variant001_256.png
...
└── planet_desert_rocky_variant050_256.png
```

#### Exotic Planets (100 variants)

```
├── planet_exotic_crystalline_variant001_256.png
├── planet_exotic_plasma_variant001_256.png
├── planet_exotic_dark_matter_variant001_256.png
├── planet_exotic_radiation_variant001_256.png
...
└── planet_exotic_quantum_variant050_256.png
```

**Visual Guidelines:**
- Unique sci-fi aesthetics
- Glowing effects, particle auras
- Non-realistic colors (purple, cyan, neon)
- Special shader effects

### Planet Size Variants

Each planet should have 2 size options:

```
Standard View (256×256):
- Used in system map
- Used when distant

Detail View (512×512):
- Used when orbiting
- Used in planet info screen
```

**Total Planet Assets: 1,000 files (256×256) + 1,000 detail versions (512×512) = 2,000 files**

---

## ⛏️ ASTEROIDS & MINING

### Asteroid Types (by Ore)

Based on ItemDatabase ores:

```
Ferralite Asteroids (ORE_T1_001):
├── asteroid_ferralite_small_01_64.png
├── asteroid_ferralite_small_02_64.png
├── asteroid_ferralite_medium_01_128.png
├── asteroid_ferralite_medium_02_128.png
├── asteroid_ferralite_large_01_256.png
└── asteroid_ferralite_large_02_256.png

Metalite Asteroids (ORE_T1_002):
├── asteroid_metalite_small_01_64.png
├── asteroid_metalite_small_02_64.png
├── asteroid_metalite_medium_01_128.png
...

Cupreon Asteroids (ORE_T1_003):
├── asteroid_cupreon_small_01_64.png
...

(Repeat for all 40+ ore types)
```

### Asteroid States

```
Intact States:
├── asteroid_ferralite_large_01_intact_256.png (100% health)

Damage States:
├── asteroid_ferralite_large_01_damage_25_256.png (75% health, small cracks)
├── asteroid_ferralite_large_01_damage_50_256.png (50% health, larger cracks)
├── asteroid_ferralite_large_01_damage_75_256.png (25% health, heavily cracked)

Depleted:
└── asteroid_ferralite_large_01_depleted_256.png (0% ore, dark/empty)
```

### Size Guidelines

| Size | Pixels | Ore Amount | Usage |
|------|--------|------------|-------|
| Small | 64×64 | 100-500 units | Common |
| Medium | 128×128 | 500-2000 units | Common |
| Large | 256×256 | 2000-10000 units | Rare |

### Visual Guidelines

**Ore Color Coding:**
- Ferralite (Iron): Gray/brown
- Cupreon/Cuprex (Copper): Orange/copper
- Palestone: Pale gray
- Titanex (Titanium): Dark metallic
- Mirrorvein (Silver): Shiny silver
- Azurex: Blue tints
- Sunvein (Gold): Golden veins
- Rare ores: Glowing veins, particle effects

**Total Asteroid Assets: ~500 files**

---

## 🏭 STATIONS & STRUCTURES

### Station Sizes

```
Small Stations (256×256):
├── station_small_mining_outpost_256.png
├── station_small_refinery_256.png
├── station_small_trading_post_256.png
└── station_small_research_lab_256.png

Medium Stations (512×512):
├── station_medium_factory_512.png
├── station_medium_shipyard_512.png
├── station_medium_market_hub_512.png
└── station_medium_military_base_512.png

Large Stations (1024×1024):
├── station_large_citadel_1024.png
├── station_large_megalopolis_1024.png
├── station_large_capital_station_1024.png
└── station_large_fortress_1024.png
```

### Station Modules (Visible)

```
Refinery Module:
├── station_module_refinery_active_128.png (glowing, processing)
├── station_module_refinery_inactive_128.png

Factory Module:
├── station_module_factory_active_128.png (smokestacks, lights)
├── station_module_factory_inactive_128.png

Shipyard Module:
├── station_module_shipyard_active_256.png (construction in progress)
├── station_module_shipyard_inactive_256.png

Trading Module:
├── station_module_market_active_128.png (busy, ships docking)
├── station_module_market_inactive_128.png

Defense Module:
├── station_module_turret_laser_128.png
├── station_module_turret_missile_128.png
├── station_module_shield_generator_128.png
```

### Station Socket Highlights

```
├── station_socket_empty_highlight_64.png (outline, available)
├── station_socket_occupied_highlight_64.png (blue glow)
├── station_socket_installing_highlight_64.png (yellow pulse)
└── station_socket_damaged_highlight_64.png (red warning)
```

### Station States

```
├── station_*_idle_*.png (normal operation)
├── station_*_damaged_*.png (battle damage, fires)
├── station_*_under_construction_*.png (scaffolding, partial)
└── station_*_destroyed_*.png (wreckage)
```

**Total Station Assets: ~100 files**

---

## ✨ EFFECTS & VFX

### Explosions

```
Small Explosions (ship weapons):
├── fx_explosion_small_spritesheet_512.png (16 frames, 4×4 grid, 128px/frame)

Medium Explosions (ship destruction):
├── fx_explosion_medium_spritesheet_1024.png (16 frames, 4×4 grid, 256px/frame)

Large Explosions (station/capital ship):
├── fx_explosion_large_spritesheet_2048.png (24 frames, 6×4 grid, 512px/frame)

Specialized:
├── fx_explosion_plasma_spritesheet_512.png (purple/blue plasma)
├── fx_explosion_nuclear_spritesheet_1024.png (white flash, shockwave)
└── fx_explosion_antimatter_spritesheet_1024.png (reality distortion)
```

**Spritesheet Specifications:**
- Format: PNG with transparency
- Frame order: Left-to-right, top-to-bottom
- FPS: 24 frames per second
- Loop: No (play once, then delete)

### Lasers & Beams

```
Mining Lasers:
├── fx_laser_mining_beam_red_16x128.png (vertical beam segment)
├── fx_laser_mining_beam_green_16x128.png
├── fx_laser_mining_glow_32.png (impact glow)
└── fx_laser_mining_sparks_spritesheet_256.png (16 frames)

Weapon Lasers:
├── fx_laser_weapon_red_16x128.png
├── fx_laser_weapon_blue_16x128.png
├── fx_laser_weapon_plasma_16x128.png
└── fx_laser_weapon_pulse_spritesheet_128.png (8 frames)

Scanner Beams:
├── fx_scanner_beam_cyan_8x64.png
└── fx_scanner_pulse_spritesheet_128.png (cone effect, 12 frames)
```

### Shield Effects

```
Shield Hit Effects:
├── fx_shield_impact_spritesheet_256.png (16 frames, ripple effect)
├── fx_shield_impact_kinetic_spritesheet_256.png (blue ripple)
├── fx_shield_impact_energy_spritesheet_256.png (yellow ripple)

Shield Ambient:
├── fx_shield_ambient_hexagon_256.png (static overlay)
├── fx_shield_ambient_bubble_256.png (spherical)
```

### Particles

```
Engine Exhaust:
├── particle_engine_exhaust_blue_32.png
├── particle_engine_exhaust_orange_32.png
├── particle_engine_warp_trail_purple_64.png

Mining Debris:
├── particle_mining_rock_chunk_16.png
├── particle_mining_dust_8.png
├── particle_mining_sparkle_16.png

Space Environment:
├── particle_star_white_4.png
├── particle_star_twinkle_8.png
├── particle_nebula_gas_32.png

Damage Effects:
├── particle_fire_16.png
├── particle_smoke_32.png
├── particle_debris_metal_16.png
├── particle_debris_sparks_8.png
```

### Nebulae & Gas Clouds

```
Nebula Overlays (parallax layers):
├── nebula_purple_layer1_1920.png (furthest back)
├── nebula_purple_layer2_1920.png
├── nebula_purple_layer3_1920.png (closest)

Gas Clouds (gameplay hazards):
├── gas_cloud_toxic_green_256.png
├── gas_cloud_radioactive_yellow_256.png
├── gas_cloud_plasma_purple_512.png

Animated Gas (optional):
├── gas_cloud_swirling_spritesheet_1024.png (8 frames, slow loop)
```

**Total Effect Assets: ~150 files**

---

## 🖥️ UI ELEMENTS

### HUD Components

```
Top Bar:
├── ui_hud_top_bar_bg_1920x60.png
├── ui_hud_health_bar_bg_300x40.png
├── ui_hud_health_bar_fill_green_300x40.png (9-slice)
├── ui_hud_shield_bar_fill_cyan_300x40.png
├── ui_hud_energy_bar_fill_blue_300x40.png
├── ui_hud_heat_bar_fill_red_300x40.png

Icons:
├── ui_icon_health_32.png (heart)
├── ui_icon_shield_32.png (shield)
├── ui_icon_energy_32.png (lightning)
├── ui_icon_heat_32.png (thermometer)
├── ui_icon_cargo_32.png (box)
├── ui_icon_credits_32.png (coin)

Minimap:
├── ui_minimap_frame_256.png
├── ui_minimap_bg_radar_240.png
├── ui_minimap_dot_player_8.png (green)
├── ui_minimap_dot_friendly_8.png (blue)
├── ui_minimap_dot_enemy_8.png (red)
├── ui_minimap_dot_neutral_8.png (yellow)
├── ui_minimap_dot_station_16.png
├── ui_minimap_dot_asteroid_8.png
```

### Buttons

```
Primary Buttons (200×60):
├── ui_button_primary_normal_200x60.png
├── ui_button_primary_hover_200x60.png
├── ui_button_primary_pressed_200x60.png
├── ui_button_primary_disabled_200x60.png

Danger Buttons (red, 200×60):
├── ui_button_danger_normal_200x60.png
├── ui_button_danger_hover_200x60.png
├── ui_button_danger_pressed_200x60.png

Success Buttons (green, 200×60):
├── ui_button_success_normal_200x60.png
├── ui_button_success_hover_200x60.png
├── ui_button_success_pressed_200x60.png

Icon Buttons (48×48):
├── ui_button_close_normal_48.png (X icon)
├── ui_button_close_hover_48.png
├── ui_button_minimize_normal_48.png
├── ui_button_maximize_normal_48.png
```

### Panels & Windows

```
Main Panels (9-slice, resizable):
├── ui_panel_station_menu_800x600.png
├── ui_panel_cargo_hold_600x400.png
├── ui_panel_market_1000x700.png
├── ui_panel_crafting_800x500.png
├── ui_panel_ship_fitting_900x600.png

Dialog Boxes:
├── ui_dialog_confirm_400x200.png
├── ui_dialog_alert_400x150.png
├── ui_dialog_input_500x250.png

Title Bars:
├── ui_titlebar_window_800x40.png (9-slice)
```

### Inventory & Item Slots

```
├── ui_slot_empty_64.png (empty inventory slot)
├── ui_slot_highlight_64.png (mouse hover)
├── ui_slot_selected_64.png (selected item)
├── ui_slot_locked_64.png (cannot use)

Rarity Borders:
├── ui_slot_border_common_64.png (white)
├── ui_slot_border_uncommon_64.png (green)
├── ui_slot_border_rare_64.png (blue)
├── ui_slot_border_epic_64.png (purple)
├── ui_slot_border_legendary_64.png (gold)
```

### Tooltips

```
├── ui_tooltip_bg_auto_resize.png (9-slice background, dark)
├── ui_tooltip_border_auto_resize.png (cyan border)
```

**Total UI Assets: ~200 files**

---

## 👥 NPC AVATARS & CHARACTERS

### NPC Portrait System

```
Traders (50 variants):
├── npc_avatar_trader_human_male_01_128.png
├── npc_avatar_trader_human_male_02_128.png
...
├── npc_avatar_trader_human_female_01_128.png
...
├── npc_avatar_trader_alien_type1_01_128.png
...
└── npc_avatar_trader_alien_type5_10_128.png

Pirates (30 variants):
├── npc_avatar_pirate_human_male_01_128.png
├── npc_avatar_pirate_human_male_scarred_01_128.png
├── npc_avatar_pirate_cyborg_01_128.png
...

Police/Military (20 variants):
├── npc_avatar_police_officer_01_128.png
├── npc_avatar_military_commander_01_128.png
...

Station Personnel (30 variants):
├── npc_avatar_station_manager_01_128.png
├── npc_avatar_mechanic_01_128.png
├── npc_avatar_scientist_01_128.png
├── npc_avatar_bartender_01_128.png
...

Miners (20 variants):
├── npc_avatar_miner_veteran_01_128.png
├── npc_avatar_miner_rookie_01_128.png
...

VIPs/Story Characters (20 variants):
├── npc_avatar_story_protagonist_128.png
├── npc_avatar_story_antagonist_128.png
├── npc_avatar_story_mentor_128.png
...
```

### Faction Logos

```
├── faction_logo_galactic_federation_128.png
├── faction_logo_mining_guild_128.png
├── faction_logo_traders_union_128.png
├── faction_logo_pirate_syndicate_128.png
├── faction_logo_scientific_collective_128.png
├── faction_logo_military_command_128.png
└── faction_logo_independent_128.png
```

### Expression Variants (Optional)

```
For key story characters:
├── npc_avatar_story_protagonist_neutral_128.png
├── npc_avatar_story_protagonist_happy_128.png
├── npc_avatar_story_protagonist_angry_128.png
├── npc_avatar_story_protagonist_surprised_128.png
└── npc_avatar_story_protagonist_sad_128.png
```

**Total NPC Avatar Assets: ~200 files**

---

## 🌌 BACKGROUNDS & PARALLAX

### Space Backgrounds (Full-Screen)

```
Star Fields (base layer):
├── bg_stars_dense_layer1_1920.png (furthest, static)
├── bg_stars_medium_layer2_1920.png (middle, slow scroll)
├── bg_stars_sparse_layer3_1920.png (closest, faster scroll)

Nebula Backgrounds (10 variants):
├── bg_nebula_purple_1920.png
├── bg_nebula_blue_1920.png
├── bg_nebula_red_1920.png
├── bg_nebula_green_1920.png
├── bg_nebula_orange_1920.png
...
└── bg_nebula_rainbow_exotic_1920.png

Sector-Specific:
├── bg_sector_asteroid_belt_1920.png (dense asteroids in background)
├── bg_sector_trade_hub_1920.png (distant stations, ships)
├── bg_sector_nebula_hazard_1920.png (gas clouds)
├── bg_sector_deep_space_1920.png (empty, dark)
└── bg_sector_galactic_core_1920.png (bright, star-dense)
```

### Parallax Layers

```
3-Layer System:
├── parallax_layer1_stars_far_1920.png (scroll speed: 0.1x)
├── parallax_layer2_nebula_mid_1920.png (scroll speed: 0.3x)
└── parallax_layer3_dust_near_1920.png (scroll speed: 0.6x)

Example Setup:
- Player moves right
- Layer 1 scrolls slowly (distant stars)
- Layer 2 scrolls medium (nebula clouds)
- Layer 3 scrolls fast (space dust)
```

### Animated Backgrounds (Optional)

```
Animated Nebula:
├── bg_nebula_animated_spritesheet_1920.png (8 frames, slow fade)

Animated Wormhole:
├── bg_wormhole_spritesheet_1920.png (16 frames, swirling)
```

**Total Background Assets: ~40 files**

---

## ⛏️ MINING MINIGAME ASSETS

### Minigame UI Frame

```
├── ui_mining_frame_800x600.png (full minigame window)
├── ui_mining_drill_indicator_64.png (rotating drill icon)
├── ui_mining_sweet_spot_ring_128.png (pulsing target ring)
├── ui_mining_progress_bar_bg_400x40.png
├── ui_mining_progress_bar_fill_400x40.png
├── ui_mining_heat_gauge_vertical_50x300.png
├── ui_mining_heat_gauge_fill_50x300.png (red, rising)
```

### Minigame Effects

```
Success Effects:
├── fx_mining_success_sparkle_spritesheet_256.png (8 frames, celebration)
├── fx_mining_success_text_overlay_200x100.png ("Perfect!")

Failure Effects:
├── fx_mining_overheat_warning_spritesheet_128.png (red flash, 4 frames)
├── fx_mining_drill_broken_128.png (broken drill icon)

Particle Effects:
├── particle_mining_ore_chunk_flying_16.png
├── particle_mining_laser_impact_sparkle_8.png
```

### Asteroid Detail View (Minigame)

```
Close-up asteroid views for minigame:
├── asteroid_detail_ferralite_800x600.png (zoomed in, show ore veins)
├── asteroid_detail_cupreon_800x600.png
├── asteroid_detail_titanex_800x600.png
...
(One for each ore type, showing internal structure)
```

**Total Mining Minigame Assets: ~60 files**

---

## 🖱️ CURSORS & MOUSE STATES

### Standard Cursors

```
├── cursor_default_32.png (normal pointer)
├── cursor_pointer_hand_32.png (clickable items)
├── cursor_text_beam_32.png (text input)
├── cursor_wait_32.png (loading/busy)
├── cursor_crosshair_32.png (general targeting)
```

### Gameplay Cursors

```
Mining:
├── cursor_mining_target_32.png (crosshair with ore icon)
├── cursor_mining_active_32.png (drilling animation, spritesheet)
├── cursor_mining_overheat_32.png (red warning)

Combat:
├── cursor_combat_target_friendly_32.png (green crosshair)
├── cursor_combat_target_enemy_32.png (red crosshair)
├── cursor_combat_target_neutral_32.png (yellow crosshair)
├── cursor_combat_locked_32.png (locked target, special icon)

Navigation:
├── cursor_nav_move_here_32.png (movement waypoint)
├── cursor_nav_autopilot_32.png (autopilot destination)
├── cursor_nav_forbidden_32.png (cannot go here, X icon)

Interaction:
├── cursor_dock_available_32.png (station docking)
├── cursor_cargo_pickup_32.png (cargo container)
├── cursor_scan_available_32.png (scannable object)
```

### Animated Cursors (Optional)

```
├── cursor_loading_spritesheet_32.png (8 frames, spinning)
├── cursor_mining_active_spritesheet_32.png (8 frames, pulsing)
```

**Total Cursor Assets: ~25 files**

---

## 📖 STORYLINE ASSETS

### Mission Icons

```
├── mission_icon_combat_64.png (sword/laser icon)
├── mission_icon_trade_64.png (credits/cargo)
├── mission_icon_exploration_64.png (star/map)
├── mission_icon_mining_64.png (pickaxe/ore)
├── mission_icon_rescue_64.png (SOS icon)
├── mission_icon_story_main_64.png (special/unique)
├── mission_icon_story_side_64.png (optional)
```

### Story Character Portraits

```
Main Characters (256×256 high quality):
├── story_character_protagonist_256.png
├── story_character_mentor_256.png
├── story_character_antagonist_256.png
├── story_character_ally_01_256.png
├── story_character_ally_02_256.png
...
```

### Story Event Illustrations

```
Key story moments:
├── story_event_game_start_1920x1080.png (opening scene)
├── story_event_first_station_1920x1080.png
├── story_event_pirate_encounter_1920x1080.png
├── story_event_major_discovery_1920x1080.png
├── story_event_final_battle_1920x1080.png
└── story_event_ending_1920x1080.png
```

### Faction Emblems (for storyline)

```
├── emblem_protagonist_faction_128.png
├── emblem_antagonist_faction_128.png
├── emblem_neutral_federation_128.png
...
```

**Total Storyline Assets: ~50 files**

---

## 🎬 ANIMATION SPECIFICATIONS

### Spritesheet Grid Standards

All spritesheets use **power-of-2 dimensions** and **uniform frame sizes**:

```
Small Animations (512×512):
├── Frame size: 128×128 pixels
├── Grid: 4×4 (16 frames total)
├── FPS: 24
└── Duration: 0.67 seconds

Medium Animations (1024×1024):
├── Frame size: 256×256 pixels
├── Grid: 4×4 (16 frames total)
├── FPS: 24
└── Duration: 0.67 seconds

Large Animations (2048×2048):
├── Frame size: 512×512 pixels
├── Grid: 4×4 (16 frames total)
├── FPS: 24
└── Duration: 0.67 seconds
```

### Animation Types

```
Looping Animations:
├── Ship thrust (8 frames, loop)
├── Engine glow (6 frames, loop)
├── Shield shimmer (12 frames, loop)
├── Station lights (4 frames, loop)

One-Shot Animations:
├── Explosions (16-24 frames, no loop)
├── Shield hit (12 frames, no loop)
├── Mining success (8 frames, no loop)
├── Warp jump (16 frames, no loop)
```

### Godot Integration Example

```gdscript
# Example: Load explosion animation
var explosion_texture = preload("res://assets/sprites/effects/explosions/fx_explosion_medium_spritesheet_1024.png")

var sprite_frames = SpriteFrames.new()
sprite_frames.add_animation("explode")

# Split 4×4 grid (16 frames, 256px each)
for y in range(4):
    for x in range(4):
        var atlas = AtlasTexture.new()
        atlas.atlas = explosion_texture
        atlas.region = Rect2(x * 256, y * 256, 256, 256)
        sprite_frames.add_frame("explode", atlas)

sprite_frames.set_animation_speed("explode", 24)
sprite_frames.set_animation_loop("explode", false)

$AnimatedSprite2D.sprite_frames = sprite_frames
$AnimatedSprite2D.play("explode")
```

---

## ✅ INTEGRATION CHECKLIST

### For Each Asset Type:

#### 1. Ships
- [ ] Create idle sprite (128×128)
- [ ] Create thrust animation (optional)
- [ ] Create damaged state (optional)
- [ ] Create icon (64×64)
- [ ] Place in `assets/sprites/ships/[player|npc]/`
- [ ] Test with `AssetManager.get_icon("ship_id")`

#### 2. Items (910 total)
- [ ] Extract item ID from ItemDatabase.gd
- [ ] Convert ID to filename (ORE_T1_001 → icon_ore_ferralite_t1_32.png)
- [ ] Create 32×32 icon
- [ ] Place in `assets/sprites/items/icons/[category]/`
- [ ] Test with `AssetManager.get_icon("ORE_T1_001", "ORES")`

#### 3. Planets (1000 total)
- [ ] Create base texture (256×256)
- [ ] Create detail texture (512×512)
- [ ] Add to category folder (`gas_giants`, `rocky`, etc.)
- [ ] Number sequentially (variant001, variant002, ...)

#### 4. Asteroids
- [ ] Create size variants (small, medium, large)
- [ ] Create damage states (25%, 50%, 75%, depleted)
- [ ] Match ore types from ItemDatabase
- [ ] Place in `assets/sprites/asteroids/ore_asteroids/`

#### 5. Effects
- [ ] Create spritesheet (power-of-2 dimensions)
- [ ] Use uniform frame size
- [ ] Test animation in Godot AnimatedSprite2D
- [ ] Adjust FPS for desired duration

#### 6. UI
- [ ] Create all button states (normal, hover, pressed, disabled)
- [ ] Use 9-slice for resizable panels
- [ ] Test at different resolutions
- [ ] Ensure readable at 1920×1080

---

## 📊 ASSET SUMMARY

### Total Asset Count

| Category | Files | Notes |
|----------|-------|-------|
| Ships | 350+ | Player + NPC + modules |
| Item Icons | 910 | Exact match to ItemDatabase |
| Planets | 2,000 | 1000 standard + 1000 detail |
| Asteroids | 500+ | All ore types, all sizes |
| Stations | 100+ | Small/medium/large + modules |
| Effects | 150+ | Explosions, lasers, shields |
| UI | 200+ | HUD, buttons, panels |
| NPCs | 200+ | Avatars, factions |
| Backgrounds | 40+ | Parallax, nebulae |
| Mining | 60+ | Minigame UI + effects |
| Cursors | 25+ | All states |
| Storyline | 50+ | Characters, events |
| **TOTAL** | **~4,585** | **Individual asset files** |

---

## 🎨 PRODUCTION WORKFLOW

### Recommended Order

1. **Week 1-2: Core Assets**
   - Item icons (910 files) - bulk production
   - Ship sprites (player + basic NPCs)
   - Basic UI (HUD, buttons)

2. **Week 3-4: Environments**
   - Planets (1000 variants) - procedural/batch
   - Asteroids (ore types)
   - Backgrounds (parallax layers)

3. **Week 5-6: Effects & Polish**
   - Explosions (spritesheets)
   - Lasers, particles
   - Shield effects
   - Mining minigame

4. **Week 7-8: Characters & Story**
   - NPC avatars
   - Story character portraits
   - Mission icons
   - Cursors

### Batch Production Tips

**For 910 Item Icons:**
- Create templates for each category
- Use consistent lighting/angle
- Automate with Photoshop actions or scripts
- Export all at 32×32

**For 1000 Planets:**
- Use procedural generation (Blender, custom tools)
- Create base templates per category
- Vary colors/features programmatically
- Batch render and export

**For Spritesheets:**
- Animate in dedicated software (Spine, Aseprite)
- Export to uniform grid
- Test frame count before final render

---

## 🔗 ASSET MANAGER INTEGRATION

### Automatic Loading

The game's `AssetManager.gd` will auto-load assets based on ID:

```gdscript
# Example: Load ore icon
var icon = AssetManager.get_icon("ORE_T1_001", "ORES")
# Looks for: assets/sprites/items/icons/ores/icon_ore_ferralite_t1_32.png

# Example: Load ship sprite
var ship_sprite = AssetManager.get_sprite("SHIP_PLAYER_EXPLORER")
# Looks for: assets/sprites/ships/player/ship_player_explorer_idle_128.png
```

### Fallback System

If an asset is missing:
1. AssetManager loads **fallback icon** (gray square with "?")
2. Warning logged to console
3. Game continues without crash

### Testing Assets

```gdscript
# Test if asset exists
if AssetManager.has_icon("ORE_T1_001"):
    print("Asset found!")
else:
    print("Asset missing - will use fallback")
```

---

## 📝 FILENAME EXAMPLES (Ready to Copy)

### Quick Reference

```
# Ships
ship_player_explorer_idle_128.png
ship_player_miner_idle_128.png
ship_npc_pirate_fighter_01_idle_128.png

# Items
icon_ore_ferralite_t1_32.png
icon_mineral_iron_ingot_t1_32.png
icon_component_compressor_t1_32.png
icon_weapon_laser_basic_t1_32.png

# Planets
planet_gas_jupiter_variant001_256.png
planet_rocky_earth_variant042_256.png
planet_ice_pluto_variant007_256.png

# Asteroids
asteroid_ferralite_small_01_64.png
asteroid_cupreon_large_02_damage_50_256.png

# Effects
fx_explosion_medium_spritesheet_1024.png
fx_laser_mining_beam_red_16x128.png
fx_shield_impact_spritesheet_256.png

# UI
ui_button_primary_normal_200x60.png
ui_hud_health_bar_fill_green_300x40.png
ui_minimap_dot_enemy_8.png

# NPCs
npc_avatar_trader_human_male_01_128.png
npc_avatar_pirate_cyborg_05_128.png

# Cursors
cursor_mining_target_32.png
cursor_combat_target_enemy_32.png
```

---

## 🎯 NEXT STEPS

1. **Share this document** with your artist/asset creator
2. **Set up folder structure** (`assets/sprites/...`)
3. **Start with high-priority assets** (item icons, player ships)
4. **Test integration** with AssetManager.gd
5. **Iterate and refine** based on in-game appearance

---

**Document Status:** ✅ Complete
**Ready for Production:** Yes
**Estimated Production Time:** 8-12 weeks (with team)
**Automated Integration:** Yes (via AssetManager.gd)

**Questions?** Check existing `docs/ASSET_MANAGEMENT_SYSTEM.md` for technical integration details.
