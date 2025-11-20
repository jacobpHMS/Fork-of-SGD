# 🎨 ASSET MANAGEMENT SYSTEM

**Version:** 1.0
**Last Updated:** 2025-01-18
**Purpose:** Complete asset organization, naming conventions, and integration guide

---

## 📋 TABLE OF CONTENTS

1. [Directory Structure](#directory-structure)
2. [Naming Conventions](#naming-conventions)
3. [Asset Categories](#asset-categories)
4. [Animation System](#animation-system)
5. [VFX & Particles](#vfx--particles)
6. [UI Assets](#ui-assets)
7. [Audio Assets](#audio-assets)
8. [Integration Guide](#integration-guide)
9. [Asset Checklist](#asset-checklist)

---

## DIRECTORY STRUCTURE

### Godot 4 Best Practices

```
SpaceGameDev/
├── assets/
│   ├── sprites/
│   │   ├── ships/
│   │   │   ├── player/
│   │   │   │   ├── ship_player_basic_idle.png
│   │   │   │   ├── ship_player_basic_thrust.png
│   │   │   │   ├── ship_player_mining_idle.png
│   │   │   │   └── ship_player_fighter_idle.png
│   │   │   ├── npc/
│   │   │   │   ├── ship_npc_miner_idle.png
│   │   │   │   ├── ship_npc_trader_idle.png
│   │   │   │   ├── ship_npc_pirate_idle.png
│   │   │   │   └── ship_npc_police_idle.png
│   │   │   └── modules/
│   │   │       ├── module_mining_laser_t1.png
│   │   │       ├── module_mining_laser_t2.png
│   │   │       ├── module_weapon_cannon.png
│   │   │       └── module_engine_thruster.png
│   │   ├── environment/
│   │   │   ├── asteroids/
│   │   │   │   ├── asteroid_iron_small_01.png
│   │   │   │   ├── asteroid_iron_medium_01.png
│   │   │   │   ├── asteroid_copper_small_01.png
│   │   │   │   ├── asteroid_gold_large_01.png
│   │   │   │   └── asteroid_uranium_large_01.png
│   │   │   ├── stations/
│   │   │   │   ├── station_small_refinery.png
│   │   │   │   ├── station_medium_factory.png
│   │   │   │   ├── station_large_citadel.png
│   │   │   │   └── station_module_socket_highlight.png
│   │   │   ├── backgrounds/
│   │   │   │   ├── bg_space_nebula_purple.png
│   │   │   │   ├── bg_space_stars_01.png
│   │   │   │   ├── bg_space_stars_02.png (parallax layer 2)
│   │   │   │   └── bg_space_stars_03.png (parallax layer 3)
│   │   │   └── planets/
│   │   │       ├── planet_gas_giant_jupiter.png
│   │   │       ├── planet_rocky_mars.png
│   │   │       └── planet_ice_pluto.png
│   │   ├── items/
│   │   │   ├── icons/
│   │   │   │   ├── icon_ore_iron.png
│   │   │   │   ├── icon_ore_copper.png
│   │   │   │   ├── icon_mineral_iron.png
│   │   │   │   ├── icon_component_compressor.png
│   │   │   │   └── icon_component_quantum_core.png
│   │   │   └── cargo/
│   │   │       ├── cargo_ore_chunk.png
│   │   │       ├── cargo_mineral_ingot.png
│   │   │       └── cargo_container_generic.png
│   │   └── ui/
│   │       ├── hud/
│   │       │   ├── ui_hud_frame_main.png
│   │       │   ├── ui_hud_minimap_frame.png
│   │       │   ├── ui_hud_cargo_bar.png
│   │       │   ├── ui_hud_health_bar.png
│   │       │   └── ui_hud_energy_bar.png
│   │       ├── buttons/
│   │       │   ├── ui_btn_primary_normal.png
│   │       │   ├── ui_btn_primary_hover.png
│   │       │   ├── ui_btn_primary_pressed.png
│   │       │   └── ui_btn_danger_normal.png
│   │       ├── panels/
│   │       │   ├── ui_panel_station_menu.png
│   │       │   ├── ui_panel_cargo_hold.png
│   │       │   └── ui_panel_market.png
│   │       └── cursors/
│   │           ├── cursor_default.png
│   │           ├── cursor_mining_target.png
│   │           └── cursor_combat_target.png
│   ├── animations/
│   │   ├── ships/
│   │   │   ├── anim_ship_player_thrust_spritesheet.png
│   │   │   ├── anim_ship_explosion_spritesheet.png
│   │   │   └── anim_ship_warp_jump_spritesheet.png
│   │   ├── effects/
│   │   │   ├── anim_mining_laser_beam.png
│   │   │   ├── anim_mining_sparks_spritesheet.png
│   │   │   ├── anim_explosion_small_spritesheet.png
│   │   │   ├── anim_explosion_large_spritesheet.png
│   │   │   └── anim_shield_hit_spritesheet.png
│   │   ├── modules/
│   │   │   ├── anim_module_engine_glow.png
│   │   │   ├── anim_module_refinery_process.png
│   │   │   └── anim_module_weapon_charge.png
│   │   └── ui/
│   │       ├── anim_ui_button_pulse.png
│   │       ├── anim_ui_loading_spinner.png
│   │       └── anim_ui_progress_bar_fill.png
│   ├── vfx/
│   │   ├── particles/
│   │   │   ├── particle_star_field.png
│   │   │   ├── particle_engine_exhaust.png
│   │   │   ├── particle_mining_debris.png
│   │   │   ├── particle_explosion_debris.png
│   │   │   ├── particle_laser_beam.png
│   │   │   └── particle_warp_trail.png
│   │   ├── shaders/
│   │   │   ├── shader_shield_shimmer.gdshader
│   │   │   ├── shader_hologram.gdshader
│   │   │   ├── shader_space_distortion.gdshader
│   │   │   └── shader_energy_pulse.gdshader
│   │   └── textures/
│   │       ├── tex_noise_perlin.png
│   │       ├── tex_gradient_radial.png
│   │       └── tex_glow_soft.png
│   ├── audio/
│   │   ├── sfx/
│   │   │   ├── ships/
│   │   │   │   ├── sfx_ship_engine_loop.ogg
│   │   │   │   ├── sfx_ship_explosion.ogg
│   │   │   │   └── sfx_ship_warp_jump.ogg
│   │   │   ├── weapons/
│   │   │   │   ├── sfx_weapon_laser_shot.ogg
│   │   │   │   ├── sfx_weapon_missile_launch.ogg
│   │   │   │   └── sfx_weapon_explosion_impact.ogg
│   │   │   ├── mining/
│   │   │   │   ├── sfx_mining_laser_loop.ogg
│   │   │   │   ├── sfx_mining_asteroid_crack.ogg
│   │   │   │   └── sfx_mining_ore_collect.ogg
│   │   │   ├── ui/
│   │   │   │   ├── sfx_ui_button_click.ogg
│   │   │   │   ├── sfx_ui_panel_open.ogg
│   │   │   │   ├── sfx_ui_error_beep.ogg
│   │   │   │   └── sfx_ui_success_chime.ogg
│   │   │   └── ambient/
│   │   │       ├── sfx_ambient_station_hum.ogg
│   │   │       ├── sfx_ambient_space_wind.ogg
│   │   │       └── sfx_ambient_alarm_loop.ogg
│   │   └── music/
│   │       ├── music_menu_theme.ogg
│   │       ├── music_exploration_ambient.ogg
│   │       ├── music_combat_intense.ogg
│   │       └── music_station_calm.ogg
│   └── fonts/
│       ├── font_main_regular.ttf
│       ├── font_main_bold.ttf
│       ├── font_mono_code.ttf
│       └── font_title_display.ttf
├── scenes/
│   ├── entities/
│   │   ├── ships/
│   │   │   ├── player_ship.tscn
│   │   │   ├── npc_miner.tscn
│   │   │   └── npc_pirate.tscn
│   │   ├── asteroids/
│   │   │   ├── asteroid_iron.tscn
│   │   │   └── asteroid_copper.tscn
│   │   └── stations/
│   │       ├── station_small.tscn
│   │       └── station_large.tscn
│   ├── ui/
│   │   ├── hud.tscn
│   │   ├── main_menu.tscn
│   │   ├── station_menu.tscn
│   │   └── mining_minigame.tscn
│   └── levels/
│       ├── sector_asteroid_belt.tscn
│       └── sector_trading_hub.tscn
└── scripts/
    └── (existing GDScript files)
```

---

## NAMING CONVENTIONS

### General Rules

**✅ DO:**
- Use **snake_case** for all files/folders (Godot 4 standard)
- Use **descriptive names** (e.g., `asteroid_iron_large_01` not `ast1`)
- Include **category prefix** (e.g., `ship_`, `ui_`, `sfx_`)
- Include **variant suffix** (e.g., `_idle`, `_hover`, `_01`)
- Use **ASCII characters only** (a-z, 0-9, underscore)

**❌ DON'T:**
- Use spaces (e.g., `ship texture.png` ❌)
- Use Unicode/special characters (e.g., `schiff_ä.png` ❌)
- Use PascalCase or camelCase (e.g., `ShipPlayer.png` ❌)
- Use generic names (e.g., `image1.png` ❌)

### Naming Pattern

```
[category]_[subcategory]_[descriptor]_[variant]_[state].[extension]

Examples:
ship_player_mining_idle.png
ship_npc_trader_thrust_01.png
ui_btn_primary_hover.png
sfx_weapon_laser_shot.ogg
anim_explosion_large_spritesheet.png
particle_engine_exhaust.png
```

### Category Prefixes

| Prefix | Category | Example |
|--------|----------|---------|
| `ship_` | Ship sprites | `ship_player_basic.png` |
| `asteroid_` | Asteroid sprites | `asteroid_iron_small_01.png` |
| `station_` | Station sprites | `station_large_citadel.png` |
| `module_` | Ship/station modules | `module_mining_laser_t2.png` |
| `icon_` | Item icons | `icon_ore_copper.png` |
| `ui_` | UI elements | `ui_hud_frame_main.png` |
| `bg_` | Backgrounds | `bg_space_nebula_purple.png` |
| `planet_` | Planets | `planet_gas_giant_jupiter.png` |
| `anim_` | Animations | `anim_ship_explosion_spritesheet.png` |
| `particle_` | Particle textures | `particle_laser_beam.png` |
| `sfx_` | Sound effects | `sfx_ui_button_click.ogg` |
| `music_` | Music tracks | `music_combat_intense.ogg` |
| `tex_` | Generic textures | `tex_noise_perlin.png` |
| `shader_` | Shader files | `shader_shield_shimmer.gdshader` |
| `font_` | Font files | `font_main_regular.ttf` |
| `cursor_` | Cursor sprites | `cursor_mining_target.png` |

### Variant Suffixes

| Suffix | Meaning | Example |
|--------|---------|---------|
| `_01`, `_02` | Variation number | `asteroid_iron_small_01.png` |
| `_idle` | Idle/default state | `ship_player_basic_idle.png` |
| `_thrust` | Thrust animation | `ship_player_basic_thrust.png` |
| `_hover` | Mouse hover state | `ui_btn_primary_hover.png` |
| `_pressed` | Button pressed | `ui_btn_primary_pressed.png` |
| `_disabled` | Disabled state | `ui_btn_primary_disabled.png` |
| `_normal` | Normal/default UI | `ui_btn_primary_normal.png` |
| `_active` | Active state | `ui_tab_nav_active.png` |
| `_small`, `_medium`, `_large` | Size variant | `asteroid_iron_large_01.png` |
| `_t1`, `_t2`, `_t3` | Tier/level | `module_mining_laser_t2.png` |
| `_spritesheet` | Sprite sheet | `anim_explosion_large_spritesheet.png` |
| `_loop` | Looping audio | `sfx_ship_engine_loop.ogg` |

---

## ASSET CATEGORIES

### 1. Ships

**Required Assets per Ship Type:**

```
Player Ships (3 types):
├── ship_player_basic_idle.png (128x128)
├── ship_player_basic_thrust.png (128x128, engine glow)
├── ship_player_mining_idle.png (128x128)
├── ship_player_mining_thrust.png
├── ship_player_fighter_idle.png (128x128)
└── ship_player_fighter_thrust.png

NPC Ships (5+ types):
├── ship_npc_miner_idle.png
├── ship_npc_trader_idle.png
├── ship_npc_pirate_idle.png
├── ship_npc_police_idle.png
└── ship_npc_capital_idle.png (256x256, larger)

Ship Modules (Visible on ship):
├── module_mining_laser_t1.png (32x32)
├── module_weapon_cannon.png (48x48)
├── module_engine_thruster.png (64x64)
└── module_shield_emitter.png (32x32)
```

**Technical Specs:**
- **Format:** PNG with transparency
- **Size:** 128x128 (standard), 256x256 (capital ships)
- **DPI:** 72
- **Color:** RGB (not indexed)
- **Layers:** Flattened (no PSD layers in final PNG)

### 2. Asteroids

**Required Variants:**

```
Ore Types (8):
├── asteroid_iron_small_01.png (64x64)
├── asteroid_iron_medium_01.png (128x128)
├── asteroid_iron_large_01.png (256x256)
├── asteroid_copper_small_01.png
├── asteroid_gold_large_01.png
├── asteroid_titanium_medium_01.png
├── asteroid_uranium_large_01.png (rare, glowing)
└── asteroid_platinum_large_01.png (rare)

Damaged States:
├── asteroid_iron_small_01_damage_25.png (75% intact)
├── asteroid_iron_small_01_damage_50.png (50% intact)
├── asteroid_iron_small_01_damage_75.png (25% intact)
└── asteroid_iron_small_01_depleted.png (empty husk)
```

**Visual Guidelines:**
- **Small:** 64x64, simple detail
- **Medium:** 128x128, more detail, cracks
- **Large:** 256x256, high detail, surface features
- **Damage:** Progressive cracks, dark spots
- **Rare Ores:** Glowing veins, special particles

### 3. Stations

**Required Assets:**

```
Station Sizes (EVE-Style):
├── station_small_raitaru.png (256x256)
├── station_medium_astrahus.png (512x512)
└── station_large_citadel.png (1024x1024)

Station Modules (Visible):
├── station_module_refinery_active.png (128x128, glowing)
├── station_module_factory_active.png (128x128, smokestacks)
├── station_module_shipyard_active.png (256x256, construction)
├── station_module_trading_market.png (128x128, lights)
└── station_module_socket_empty.png (64x64, outline)

Socket Highlights:
├── station_socket_highlight_available.png (glow green)
├── station_socket_highlight_occupied.png (glow blue)
└── station_socket_highlight_installing.png (glow yellow)
```

**Animation States:**
- **Idle:** Rotating slowly, blinking lights
- **Active:** Modules glowing, particles emitting
- **Docking:** Hangar bay doors opening
- **Under Attack:** Damage sparks, fires

### 4. UI Elements

**HUD Components:**

```
Main HUD:
├── ui_hud_frame_main.png (1920x1080, outer frame)
├── ui_hud_minimap_frame.png (256x256)
├── ui_hud_cargo_bar_bg.png (300x40)
├── ui_hud_cargo_bar_fill.png (300x40, 9-slice)
├── ui_hud_health_bar_bg.png
├── ui_hud_health_bar_fill_green.png (9-slice)
├── ui_hud_energy_bar_fill_blue.png (9-slice)
└── ui_hud_shield_bar_fill_cyan.png (9-slice)

Buttons:
├── ui_btn_primary_normal.png (200x60)
├── ui_btn_primary_hover.png (200x60)
├── ui_btn_primary_pressed.png (200x60)
├── ui_btn_primary_disabled.png (200x60)
├── ui_btn_danger_normal.png (red variant)
├── ui_btn_success_normal.png (green variant)
└── ui_btn_icon_close.png (32x32, X button)

Panels:
├── ui_panel_station_menu.png (800x600, 9-slice)
├── ui_panel_cargo_hold.png (600x400, 9-slice)
├── ui_panel_market.png (1000x700, 9-slice)
└── ui_panel_dialog_box.png (400x200, 9-slice)
```

**9-Slice Configuration:**
```gdscript
# For resizable UI panels
ui_panel_station_menu.png
├── Corner size: 32x32 pixels
├── Edge mode: Tile
└── Center mode: Stretch
```

### 5. Mining Minigame

**Required Assets:**

```
Minigame UI:
├── ui_mining_minigame_frame.png (800x600)
├── ui_mining_drill_indicator.png (64x64, rotating)
├── ui_mining_sweet_spot.png (128x128, pulsing ring)
├── ui_mining_progress_bar.png (400x40)
├── ui_mining_heat_gauge.png (50x300, vertical)
└── ui_mining_success_overlay.png (800x600, fade-in)

Cursors:
├── cursor_mining_target.png (32x32, crosshair)
├── cursor_mining_active.png (32x32, drilling)
└── cursor_mining_overheat.png (32x32, red warning)

Visual Feedback:
├── anim_mining_laser_beam.png (16x128, beam sprite)
├── anim_mining_sparks_spritesheet.png (32x32x16 frames)
├── anim_mining_success_sparkle.png (64x64x8 frames)
└── particle_mining_debris.png (16x16, rocks)
```

**Minigame States:**
1. **Idle:** Cursor showing target reticle
2. **Drilling:** Beam firing, progress bar filling
3. **Sweet Spot:** Ring pulsing, bonus indicator
4. **Overheat:** Red glow, warning icon
5. **Success:** Sparkle animation, ore collected

---

## ANIMATION SYSTEM

### Sprite Sheets

**Standard Format:**
```
Sprite Sheet Layout (Power of 2):
├── Frame size: 128x128 pixels
├── Frames per row: 8
├── Total frames: 16 (2 rows x 8 columns)
└── Spacing: 0 pixels (no gaps)

File: anim_explosion_large_spritesheet.png (1024x256)
Frame sequence: Left-to-right, top-to-bottom
FPS: 24 frames per second
Duration: 0.67 seconds
```

**Animation Types:**

```gdscript
# Ship thrust animation
anim_ship_player_thrust_spritesheet.png
├── Frames: 8
├── FPS: 12
├── Loop: true
└── Usage: Play when player presses W/forward

# Explosion animation
anim_explosion_small_spritesheet.png
├── Frames: 16
├── FPS: 24
├── Loop: false
└── Usage: Play on ship destruction, auto-delete

# Shield hit animation
anim_shield_hit_spritesheet.png
├── Frames: 12
├── FPS: 30
├── Loop: false
└── Usage: Play on damage taken, fade out
```

### Godot AnimationPlayer Setup

```gdscript
# Example: Ship thrust glow animation
[gd_scene load_steps=10 format=3]

[ext_resource type="Texture2D" path="res://assets/animations/ships/anim_ship_player_thrust_spritesheet.png"]

[sub_resource type="AtlasTexture" id="1"]
atlas = ExtResource("1")
region = Rect2(0, 0, 128, 128)

[sub_resource type="AtlasTexture" id="2"]
atlas = ExtResource("1")
region = Rect2(128, 0, 128, 128)

# ... (repeat for all 8 frames)

[node name="ThrustAnimation" type="AnimatedSprite2D"]
sprite_frames = SubResource("SpriteFrames_thrust")
autoplay = "thrust_loop"
speed_scale = 1.0
```

### Rotation Animations

**Module Rotation (e.g., Refinery):**

```gdscript
# Rotating station module
func _process(delta):
    # Rotate refinery module when active
    if is_processing:
        $ModuleRefinery.rotation += rotation_speed * delta
        $ModuleRefinery.modulate.a = lerp(0.8, 1.0, sin(Time.get_ticks_msec() * 0.001))
```

**Assets Needed:**
```
module_refinery_rotor.png (128x128, transparent center)
module_factory_conveyor.png (256x64, horizontal loop)
module_shipyard_crane.png (64x128, vertical swing)
```

---

## VFX & PARTICLES

### Particle Systems

**Engine Exhaust:**

```gdscript
# GPUParticles2D configuration
[node name="EngineExhaust" type="GPUParticles2D"]
amount = 50
lifetime = 0.5
preprocess = 0.1
explosiveness = 0.1
randomness = 0.2
fixed_fps = 60

[sub_resource type="ParticleProcessMaterial"]
emission_shape = 0  # Point
direction = Vector3(0, 1, 0)  # Backward from ship
spread = 15.0
gravity = Vector3(0, 0, 0)
initial_velocity_min = 200.0
initial_velocity_max = 300.0
angular_velocity_min = -45.0
angular_velocity_max = 45.0
orbit_velocity_min = 0.0
orbit_velocity_max = 0.0
radial_accel_min = 0.0
radial_accel_max = 0.0
tangential_accel_min = 0.0
tangential_accel_max = 0.0
damping_min = 1.0
damping_max = 2.0
angle_min = 0.0
angle_max = 360.0
scale_min = 0.5
scale_max = 1.0
color = Color(0.8, 0.9, 1.0, 1.0)  # Blue-white
hue_variation_min = -0.1
hue_variation_max = 0.1

texture = preload("res://assets/vfx/particles/particle_engine_exhaust.png")
```

**Asset Requirements:**

```
Particle Textures (64x64, radial gradient):
├── particle_engine_exhaust.png (blue glow)
├── particle_mining_debris.png (gray rocks)
├── particle_explosion_debris.png (orange fire)
├── particle_laser_beam.png (red/green beam segment)
├── particle_warp_trail.png (purple streak)
└── particle_star_field.png (white dot)
```

### Laser Beam VFX

**Implementation:**

```gdscript
# Mining laser beam (Line2D + particles)
extends Line2D

@export var beam_width: float = 4.0
@export var beam_color: Color = Color(1, 0.2, 0.2)  # Red
@export var spark_particles: GPUParticles2D

func fire_laser(from: Vector2, to: Vector2):
    points = [from, to]
    width = beam_width
    default_color = beam_color
    visible = true

    # Sparks at impact point
    spark_particles.position = to
    spark_particles.emitting = true

    # Fade out over 0.1 seconds
    await get_tree().create_timer(0.1).timeout
    visible = false
```

**Required Assets:**
```
anim_mining_laser_beam.png (16x128, vertical beam)
anim_mining_laser_glow.png (32x32, glow circle)
particle_mining_sparks.png (8x8, white spark)
```

### Shield Shader Effect

**Shader Code:**

```gdshader
shader_type canvas_item;

uniform float shield_strength : hint_range(0.0, 1.0) = 1.0;
uniform vec4 shield_color : source_color = vec4(0.0, 0.8, 1.0, 0.5);
uniform float hit_flash : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // Hexagonal shield pattern
    vec2 uv = UV * 10.0;
    float hex = abs(sin(uv.x) + sin(uv.y + 0.5) + sin(uv.x - uv.y));
    hex = step(2.0, hex);

    // Fade at edges
    float edge_fade = 1.0 - length(UV - vec2(0.5));
    edge_fade = smoothstep(0.0, 0.5, edge_fade);

    // Shield visibility based on strength
    float alpha = shield_strength * 0.3 + hit_flash * 0.7;
    alpha *= hex * edge_fade;

    COLOR = vec4(shield_color.rgb, alpha);
}
```

**Shader Files:**
```
shader_shield_shimmer.gdshader
shader_hologram.gdshader (for UI holograms)
shader_space_distortion.gdshader (warp effects)
shader_energy_pulse.gdshader (weapon charge-up)
```

---

## UI ASSETS

### HUD Layout

**1920x1080 Screen:**

```
┌──────────────────────────────────────────────────┐
│ [Health] [Shield] [Energy]         [Credits]     │  ← Top Bar
├──────────────────────────────────────────────────┤
│                                                   │
│              [Main View]                          │
│                                                   │
│   [Minimap]                                       │
│   ┌───────┐                                       │
│   │ • • • │                                       │
│   │ • X • │ ← Player                              │
│   │ • • • │                                       │
│   └───────┘                                       │
├──────────────────────────────────────────────────┤
│ [Cargo 45/100] [Target: Iron Asteroid] [Dist: 50m]│  ← Bottom Bar
└──────────────────────────────────────────────────┘
```

**Asset Breakdown:**

```
Top Bar (1920x60):
├── ui_hud_top_bar_bg.png (1920x60)
├── ui_hud_health_icon.png (32x32, heart)
├── ui_hud_shield_icon.png (32x32, shield)
├── ui_hud_energy_icon.png (32x32, lightning)
└── ui_hud_credits_icon.png (32x32, coin)

Minimap (256x256):
├── ui_hud_minimap_frame.png (256x256, outer border)
├── ui_hud_minimap_bg.png (240x240, radar grid)
├── ui_hud_minimap_dot_player.png (8x8, green)
├── ui_hud_minimap_dot_friendly.png (8x8, blue)
├── ui_hud_minimap_dot_enemy.png (8x8, red)
└── ui_hud_minimap_dot_neutral.png (8x8, yellow)

Bottom Bar (1920x80):
├── ui_hud_bottom_bar_bg.png (1920x80)
├── ui_hud_cargo_icon.png (32x32, box)
├── ui_hud_target_icon.png (32x32, crosshair)
└── ui_hud_distance_icon.png (32x32, ruler)
```

### Station Menu

**Layout:**

```
┌───────────────────────────────────────┐
│ [Station Name: Alpha Refinery]    [X] │  ← Title Bar
├───────────────────────────────────────┤
│ ┌─────────┐ ┌───────────────────────┐ │
│ │ Refine  │ │                       │ │
│ ├─────────┤ │   [Content Area]      │ │
│ │ Trade   │ │                       │ │
│ ├─────────┤ │                       │ │
│ │ Upgrade │ │                       │ │
│ ├─────────┤ │                       │ │
│ │ Undock  │ │                       │ │
│ └─────────┘ └───────────────────────┘ │
└───────────────────────────────────────┘
```

**Assets:**

```
ui_panel_station_menu_bg.png (1000x700, 9-slice)
ui_panel_station_title_bar.png (1000x60)
ui_btn_station_nav_normal.png (200x50)
ui_btn_station_nav_active.png (200x50, highlighted)
ui_icon_refinery.png (48x48)
ui_icon_trade.png (48x48)
ui_icon_upgrade.png (48x48)
ui_icon_undock.png (48x48)
```

### Tooltips

```
ui_tooltip_bg.png (auto-resize, 9-slice)
├── Min size: 200x60
├── Slice margins: 16x16
└── Color: rgba(0, 0, 0, 0.9)

Content:
├── Title (bold font, white)
├── Description (regular font, gray)
└── Stats (mono font, cyan)
```

---

## AUDIO ASSETS

### Sound Effects

**Format Standards:**
- **Format:** OGG Vorbis (smaller than WAV, good quality)
- **Sample Rate:** 44100 Hz
- **Bitrate:** 128 kbps (adequate for most SFX)
- **Channels:** Mono (positional sounds), Stereo (UI sounds)

**SFX Categories:**

```
Ship Sounds:
├── sfx_ship_engine_loop.ogg (mono, 5 sec loop)
├── sfx_ship_explosion.ogg (mono, 2 sec)
├── sfx_ship_warp_jump.ogg (stereo, 3 sec)
└── sfx_ship_collision.ogg (mono, 0.5 sec)

Weapon Sounds:
├── sfx_weapon_laser_shot.ogg (mono, 0.3 sec)
├── sfx_weapon_missile_launch.ogg (mono, 1 sec)
├── sfx_weapon_cannon_fire.ogg (mono, 0.5 sec)
└── sfx_weapon_explosion_impact.ogg (mono, 2 sec)

Mining Sounds:
├── sfx_mining_laser_loop.ogg (mono, 3 sec loop)
├── sfx_mining_asteroid_crack.ogg (mono, 1 sec)
├── sfx_mining_ore_collect.ogg (stereo, 0.5 sec, UI feedback)
└── sfx_mining_drill_hit.ogg (mono, 0.3 sec)

UI Sounds:
├── sfx_ui_button_click.ogg (stereo, 0.1 sec)
├── sfx_ui_panel_open.ogg (stereo, 0.3 sec)
├── sfx_ui_error_beep.ogg (stereo, 0.5 sec)
├── sfx_ui_success_chime.ogg (stereo, 0.8 sec)
└── sfx_ui_typing.ogg (stereo, 0.05 sec per key)
```

**Audio Bus Setup:**

```gdscript
# AudioServer configuration
Master
├── SFX (-6 dB)
│   ├── Ships
│   ├── Weapons
│   └── Mining
├── UI (0 dB)
└── Music (-12 dB)
    ├── Combat
    └── Ambient
```

### Music

**Adaptive Music System:**

```gdscript
# Music layers that blend based on game state
music_exploration_ambient_layer1.ogg (base layer, always playing)
music_exploration_ambient_layer2.ogg (adds when near station)
music_combat_intense_drums.ogg (crossfade when in combat)
music_combat_intense_full.ogg (full intensity at low health)
```

**Tracks Needed:**
```
music_menu_theme.ogg (2 min loop)
music_exploration_ambient.ogg (5 min, seamless loop)
music_combat_intense.ogg (3 min loop, high energy)
music_station_calm.ogg (4 min loop, peaceful)
music_victory_stinger.ogg (10 sec, mission complete)
music_defeat_stinger.ogg (8 sec, game over)
```

---

## INTEGRATION GUIDE

### Step-by-Step Asset Integration

#### 1. Import Sprites

```gdscript
# 1. Place PNG file in assets/sprites/ships/
# 2. Godot will auto-import with default settings
# 3. Select sprite in FileSystem
# 4. In Import tab, configure:

Import Settings:
├── Compress Mode: VRAM Compressed
├── Filter: false (pixel-perfect)
├── Mipmaps: false
└── Repeat: false

# 5. Click "Reimport"
# 6. Drag sprite into scene
```

#### 2. Setup Sprite Sheets

```gdscript
# 1. Import sprite sheet (e.g., explosion animation)
# 2. Create AnimatedSprite2D node
# 3. Create new SpriteFrames resource
# 4. Add frames:

var sprite_frames = SpriteFrames.new()
var texture = preload("res://assets/animations/effects/anim_explosion_small_spritesheet.png")

# Split into frames (128x128, 4x4 grid = 16 frames)
for y in range(4):
    for x in range(4):
        var atlas = AtlasTexture.new()
        atlas.atlas = texture
        atlas.region = Rect2(x * 128, y * 128, 128, 128)
        sprite_frames.add_frame("explode", atlas)

sprite_frames.set_animation_speed("explode", 24)  # 24 FPS
sprite_frames.set_animation_loop("explode", false)

$AnimatedSprite2D.sprite_frames = sprite_frames
$AnimatedSprite2D.play("explode")
```

#### 3. Particle Setup

```gdscript
# 1. Create GPUParticles2D node
# 2. Set texture: particle_engine_exhaust.png
# 3. Create ParticleProcessMaterial
# 4. Configure emission:

@export var exhaust_particles: GPUParticles2D

func _ready():
    exhaust_particles.amount = 50
    exhaust_particles.lifetime = 0.5
    exhaust_particles.process_material = create_exhaust_material()

func create_exhaust_material() -> ParticleProcessMaterial:
    var mat = ParticleProcessMaterial.new()
    mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_POINT
    mat.direction = Vector3(0, 1, 0)  # Backward
    mat.spread = 15.0
    mat.initial_velocity_min = 200.0
    mat.initial_velocity_max = 300.0
    mat.gravity = Vector3(0, 0, 0)
    mat.scale_min = 0.5
    mat.scale_max = 1.0
    return mat
```

#### 4. UI Integration

```gdscript
# HUD health bar with 9-slice scaling
@onready var health_bar: TextureProgressBar = $HUD/HealthBar

func _ready():
    health_bar.texture_under = preload("res://assets/sprites/ui/hud/ui_hud_health_bar_bg.png")
    health_bar.texture_progress = preload("res://assets/sprites/ui/hud/ui_hud_health_bar_fill_green.png")

    # Enable 9-slice
    health_bar.nine_patch_stretch = true
    health_bar.stretch_margin_left = 8
    health_bar.stretch_margin_right = 8
    health_bar.stretch_margin_top = 8
    health_bar.stretch_margin_bottom = 8

func update_health(current: float, max: float):
    health_bar.value = (current / max) * 100.0
```

#### 5. Audio Setup

```gdscript
# Positional sound (3D space)
@onready var laser_sound: AudioStreamPlayer2D = $LaserSound

func _ready():
    laser_sound.stream = preload("res://assets/audio/sfx/weapons/sfx_weapon_laser_shot.ogg")
    laser_sound.volume_db = -6.0
    laser_sound.max_distance = 2000.0
    laser_sound.attenuation = 2.0  # Falloff curve

func fire_laser():
    laser_sound.play()

# UI sound (no position)
@onready var button_click: AudioStreamPlayer = $UI/ButtonClick

func _on_button_pressed():
    button_click.stream = preload("res://assets/audio/sfx/ui/sfx_ui_button_click.ogg")
    button_click.volume_db = 0.0
    button_click.play()
```

---

## ASSET CHECKLIST

### Pre-Production

- [ ] **Define art style** (pixel art, vector, realistic?)
- [ ] **Create style guide** (color palette, line thickness)
- [ ] **Set resolution standards** (128x128 for ships, etc.)
- [ ] **Choose software** (Aseprite, Photoshop, Blender?)

### Sprite Production

#### Ships
- [ ] Player ship (basic, mining, fighter)
- [ ] NPC ships (miner, trader, pirate, police, capital)
- [ ] Ship thrust animations
- [ ] Ship damage states
- [ ] Ship explosion effects

#### Environment
- [ ] Asteroids (8 ore types, 3 sizes each)
- [ ] Asteroid damage states
- [ ] Stations (3 sizes: small, medium, large)
- [ ] Station modules (refinery, factory, shipyard, etc.)
- [ ] Backgrounds (space, nebulae, planets)
- [ ] Parallax layers (stars at different depths)

#### Items
- [ ] Item icons (ores, minerals, components)
- [ ] Cargo visual representations
- [ ] Module icons (weapons, engines, utilities)

#### UI
- [ ] HUD elements (frames, bars, icons)
- [ ] Buttons (normal, hover, pressed, disabled)
- [ ] Panels (9-slice for resizing)
- [ ] Cursors (default, mining, combat)
- [ ] Tooltips

### Animation Production

- [ ] Ship thrust loops
- [ ] Explosion sequences
- [ ] Shield hit effects
- [ ] Mining laser beam
- [ ] Mining sparks
- [ ] Warp jump effect
- [ ] UI animations (button pulse, loading spinner)

### VFX Production

- [ ] Particle textures (exhaust, debris, sparks)
- [ ] Shader effects (shield, hologram, distortion)
- [ ] Beam effects (lasers, tractor beams)
- [ ] Impact effects (explosions, collisions)

### Audio Production

#### SFX
- [ ] Ship sounds (engine, explosion, warp)
- [ ] Weapon sounds (laser, missile, cannon)
- [ ] Mining sounds (drill, crack, collect)
- [ ] UI sounds (click, open, error, success)
- [ ] Ambient sounds (station hum, space wind)

#### Music
- [ ] Menu theme
- [ ] Exploration ambient
- [ ] Combat intense
- [ ] Station calm
- [ ] Victory/defeat stingers

### Integration

- [ ] Import all sprites
- [ ] Configure import settings
- [ ] Create AnimatedSprite2D nodes
- [ ] Setup particle systems
- [ ] Configure audio buses
- [ ] Test all assets in-game
- [ ] Optimize file sizes
- [ ] Create asset manifest (list of all files)

### Post-Production

- [ ] **Performance testing** (FPS with all VFX active)
- [ ] **Memory profiling** (texture memory usage)
- [ ] **Audio balancing** (volume levels, mixing)
- [ ] **Accessibility** (colorblind modes, audio cues)

---

## ASSET MANIFEST EXAMPLE

```json
{
  "ships": {
    "player_basic": {
      "sprite": "assets/sprites/ships/player/ship_player_basic_idle.png",
      "size": "128x128",
      "states": ["idle", "thrust"],
      "modules": ["mining_laser", "basic_weapon", "engine"]
    }
  },
  "asteroids": {
    "iron": {
      "variants": ["small_01", "medium_01", "large_01"],
      "damage_states": 4,
      "particle_color": "gray"
    }
  },
  "audio": {
    "sfx_weapon_laser_shot": {
      "file": "assets/audio/sfx/weapons/sfx_weapon_laser_shot.ogg",
      "duration": "0.3s",
      "format": "OGG",
      "channels": "mono",
      "usage": "Weapon.gd:fire_laser()"
    }
  }
}
```

---

**END OF ASSET MANAGEMENT SYSTEM**

**Status:** ✅ Ready for asset production
**Next Steps:**
1. Share with artist/designer
2. Begin asset creation
3. Import and integrate iteratively
4. Test performance and iterate
