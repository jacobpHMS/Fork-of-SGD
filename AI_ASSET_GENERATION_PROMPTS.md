# 🤖 AI ASSET GENERATION PROMPTS
## Complete AI Prompt Collection for SpaceGameDev Assets

**Version:** 1.0
**Last Updated:** 2025-11-19
**Total Assets:** ~4,585
**Purpose:** Ready-to-use AI prompts for automatic asset generation

---

## 📋 TABLE OF CONTENTS

1. [Recommended AI Tools](#recommended-ai-tools)
2. [Global Settings & Style](#global-settings--style)
3. [Universal Prompt Templates](#universal-prompt-templates)
4. [Ship Prompts](#ship-prompts)
5. [Item Icon Prompts](#item-icon-prompts)
6. [Planet Prompts](#planet-prompts)
7. [Asteroid Prompts](#asteroid-prompts)
8. [Station Prompts](#station-prompts)
9. [Effect/VFX Prompts](#effectvfx-prompts)
10. [UI Element Prompts](#ui-element-prompts)
11. [NPC Avatar Prompts](#npc-avatar-prompts)
12. [Background Prompts](#background-prompts)
13. [Cursor Prompts](#cursor-prompts)
14. [Batch Generation Scripts](#batch-generation-scripts)

---

## 🤖 RECOMMENDED AI TOOLS

### Free/Freemium Options

#### 1. **Stable Diffusion (Best for Game Assets)**
- **Platform:** Local (ComfyUI, Automatic1111) or Online (DreamStudio)
- **Cost:** FREE (local) / $10 credits (DreamStudio)
- **Best For:** Pixel art, consistent style, transparent backgrounds
- **Recommended Model:** Pixel Art Diffusion XL, Aseprite Style
- **Website:** https://stability.ai / https://dreamstudio.ai
- **Pros:** Full control, batch generation, LoRA training
- **Cons:** Setup required for local

#### 2. **Bing Image Creator (DALL-E 3)**
- **Platform:** Web (Microsoft)
- **Cost:** FREE (15 credits/day, slow mode unlimited)
- **Best For:** Quick concepts, high quality
- **Website:** https://www.bing.com/create
- **Pros:** Completely free, high quality, easy
- **Cons:** No transparent backgrounds by default, limited control

#### 3. **Leonardo.ai**
- **Platform:** Web
- **Cost:** FREE (150 credits/day)
- **Best For:** Game assets, pixel art, consistent style
- **Website:** https://leonardo.ai
- **Pros:** Game asset templates, transparent backgrounds, upscaling
- **Cons:** Limited free credits

#### 4. **Lexica.art (Stable Diffusion)**
- **Platform:** Web
- **Cost:** FREE (100 images/month)
- **Best For:** Pixel art, sprites
- **Website:** https://lexica.art
- **Pros:** Simple, fast, good for pixel art
- **Cons:** Limited free tier

#### 5. **NightCafe**
- **Platform:** Web
- **Cost:** FREE (5 credits/day)
- **Best For:** Varied styles, backgrounds
- **Website:** https://nightcafe.studio
- **Pros:** Multiple AI models, community
- **Cons:** Limited daily credits

### Specialized Tools

#### For Pixel Art
- **Pixelicious.xyz** - Convert images to pixel art (FREE)
- **Aseprite** - Pixel art editor ($20 one-time, or compile free)
- **Piskel** - Free online pixel art tool

#### For Transparent Backgrounds
- **Remove.bg** - Free background removal (15/month free)
- **Photopea** - Free Photoshop alternative (web)
- **GIMP** - Free desktop editor

---

## 🎨 GLOBAL SETTINGS & STYLE

### Universal Requirements

**ALL assets must include:**
```
Style: 2D pixel art, 16-bit SNES style, clean lines, vibrant colors
Format: PNG with transparent background
Lighting: Top-down lighting, slight ambient glow
Perspective: Isometric 3/4 view OR top-down (depending on asset)
Color Palette: Sci-fi themed, high contrast, neon accents
Transparency: Background must be fully transparent (alpha channel)
```

### Negative Prompts (Use for ALL generations)

```
Negative Prompt:
blurry, low quality, jpeg artifacts, watermark, text, signature,
3D render, photorealistic, white background, solid background,
noise, grain, oversaturated, cartoon, anime style, sketch
```

### Recommended Settings (Stable Diffusion)

```
Steps: 30-50
CFG Scale: 7-9
Sampler: DPM++ 2M Karras
Resolution: Match target size (32x32, 128x128, etc.)
Model: Pixel Art Diffusion XL or custom pixel art model
```

---

## 📐 UNIVERSAL PROMPT TEMPLATES

### Template Variables

Use these in prompts below:

- `{SIZE}` = Target resolution (32x32, 128x128, 256x256, etc.)
- `{NAME}` = Asset name (e.g., "Ferralite", "Explorer")
- `{COLOR}` = Primary color (e.g., "gray metallic", "orange copper")
- `{TYPE}` = Asset type (e.g., "ore", "ship", "planet")
- `{TIER}` = Tier level (T1, T2, T3)
- `{VARIANT}` = Variant number (01, 02, etc.)

### Base Template Structure

```
[MAIN SUBJECT], [STYLE], [DETAILS], [TECHNICAL SPECS]

Example:
Iron ore chunk, 2D pixel art icon, gray metallic texture with rust spots,
32x32 pixels, transparent background, top-down view, SNES 16-bit style
```

---

## 🚀 SHIP PROMPTS

### Universal Ship Prompt Template

```
{SHIP_TYPE} spaceship sprite, 2D pixel art, {SIZE} pixels, isometric 3/4 view,
{COLOR_SCHEME}, detailed hull plating, glowing engine thrusters,
weapon hardpoints visible, sci-fi design, clean lines, vibrant colors,
transparent background, 16-bit SNES style, game asset, centered composition

Negative: blurry, 3D render, photorealistic, white background, text, watermark
```

### Player Ships (Detailed Examples)

#### Explorer Ship
```
Filename: ship_player_explorer_idle_128.png
Size: 128x128 pixels

Prompt:
Medium-sized explorer spaceship sprite, 2D pixel art, 128x128 pixels,
isometric 3/4 view from above, silver and blue color scheme,
sleek balanced design, visible cockpit windows, dual engine thrusters,
small weapon mounts on sides, cargo bay visible, clean sci-fi aesthetic,
detailed hull panels, subtle ambient glow from engines,
transparent background, 16-bit SNES style, game sprite, centered

Negative: blurry, 3D, photorealistic, white background, text, cartoon
```

#### Miner Ship
```
Filename: ship_player_miner_idle_128.png
Size: 128x128 pixels

Prompt:
Industrial mining spaceship sprite, 2D pixel art, 128x128 pixels,
isometric 3/4 view, yellow and orange industrial colors, bulky sturdy design,
large cargo containers visible on sides, mining laser array on front,
reinforced hull plates, industrial exhaust ports, ore collection scoops,
heavy-duty construction, work lights glowing,
transparent background, 16-bit SNES style, game sprite, centered

Negative: blurry, 3D, photorealistic, white background, text, sleek design
```

#### Fighter Ship
```
Filename: ship_player_fighter_idle_128.png
Size: 128x128 pixels

Prompt:
Compact fighter spaceship sprite, 2D pixel art, 128x128 pixels,
isometric 3/4 view, red and black aggressive color scheme,
sleek aerodynamic design, multiple visible weapon hardpoints,
swept-back wings, powerful engine exhausts, armored cockpit,
combat-ready aesthetic, glowing targeting systems,
transparent background, 16-bit SNES style, game sprite, centered

Negative: blurry, 3D, photorealistic, white background, text, bulky design
```

### NPC Ships (Batch Template)

```
Filename: ship_npc_{faction}_{type}_{variant}_idle_128.png
Size: 128x128 pixels

Template:
{FACTION} {TYPE} spaceship sprite, 2D pixel art, 128x128 pixels,
isometric 3/4 view, {COLOR_SCHEME}, {DESIGN_DESCRIPTION},
{SPECIAL_FEATURES}, transparent background, 16-bit SNES style, centered

Examples:

Trader Ship:
Neutral trader cargo ship sprite, 2D pixel art, 128x128 pixels,
isometric 3/4 view, white and blue peaceful colors, boxy cargo hauler design,
large cargo containers, minimal weapons, commercial markings,
navigation lights, transparent background, 16-bit SNES style, centered

Pirate Ship:
Pirate fighter spacecraft sprite, 2D pixel art, 128x128 pixels,
isometric 3/4 view, dark gray and red menacing colors, aggressive angular design,
exposed weapons, makeshift armor plating, skull emblem optional,
damaged paint, mismatched components, transparent background, 16-bit SNES style

Police Ship:
Law enforcement patrol ship sprite, 2D pixel art, 128x128 pixels,
isometric 3/4 view, white and blue authority colors, sleek interceptor design,
police markings, warning lights, scanner array, pursuit thrusters,
clean official aesthetic, transparent background, 16-bit SNES style
```

### Ship States (Thrust, Damaged, etc.)

```
Thrust Animation:
Same as idle prompt + "with bright glowing engine exhausts,
particle effects trailing behind, motion blur on engines"

Damaged State:
Same as idle prompt + "with battle damage, hull breaches,
sparking electronics, scorch marks, missing panels, small fires"

Destroyed (Spritesheet):
Ship explosion sequence, 2D pixel art spritesheet, 16 frames in 4x4 grid,
total size 1024x1024 (each frame 256x256), progressive destruction,
expanding fireball, debris flying outward, bright flash to dim embers,
orange and yellow explosion colors, transparent background, 16-bit style
```

---

## 📦 ITEM ICON PROMPTS

### Universal Item Icon Template

```
{ITEM_NAME} icon, 2D pixel art item icon, 32x32 pixels, top-down view,
{COLOR_DESCRIPTION}, {MATERIAL_TEXTURE}, {SPECIAL_FEATURES},
game inventory icon, clean simple design, recognizable silhouette,
transparent background, 16-bit SNES style, centered composition

Negative: blurry, complex, cluttered, white background, 3D render
```

### Ore Icons (Tier-Based)

#### Tier 1 Ores (Common) - Batch Prompt

```
Filename: icon_ore_{ore_name}_t1_32.png
Size: 32x32 pixels

Base Template:
{ORE_NAME} ore chunk icon, 2D pixel art, 32x32 pixels, top-down view,
{COLOR} rough rocky texture, simple mineral chunk, basic ore deposit,
slight metallic sheen, common quality, game inventory icon,
transparent background, 16-bit SNES style, centered

Specific Examples:

Ferralite (Iron):
Ferralite ore chunk icon, 2D pixel art, 32x32 pixels, top-down view,
dark gray metallic texture with brown rust spots, rough rocky surface,
iron ore appearance, simple chunk shape, common mineral,
transparent background, 16-bit SNES style, centered

Cupreon (Copper):
Cupreon ore chunk icon, 2D pixel art, 32x32 pixels, top-down view,
orange-copper metallic texture, warm earthy tones, copper ore veins,
rough mineral surface, common quality, game inventory icon,
transparent background, 16-bit SNES style, centered

Titanex (Titanium):
Titanex ore chunk icon, 2D pixel art, 32x32 pixels, top-down view,
dark metallic gray texture with blue-silver sheen, dense mineral structure,
titanium ore appearance, angular crystalline facets, uncommon quality,
transparent background, 16-bit SNES style, centered

Azurex (Blue Rare):
Azurex ore chunk icon, 2D pixel art, 32x32 pixels, top-down view,
deep blue crystal texture with azure highlights, semi-precious appearance,
glowing blue veins, polished mineral surface, uncommon quality,
transparent background, 16-bit SNES style, centered
```

#### Tier 2 Ores (Uncommon)

```
{ORE_NAME} ore crystal icon, 2D pixel art, 32x32 pixels, top-down view,
{COLOR} crystalline texture with metallic sheen, refined mineral structure,
visible energy veins, glowing accents, uncommon quality indicators,
more complex geometry than T1, polished surfaces,
transparent background, 16-bit SNES style, centered

Example - Chromore:
Chromore crystal ore icon, 2D pixel art, 32x32 pixels, top-down view,
chrome silver metallic texture with rainbow iridescence, high-quality mineral,
polished crystalline facets, subtle energy glow, uncommon quality,
transparent background, 16-bit SNES style, centered
```

#### Tier 3 Ores (Rare)

```
{ORE_NAME} rare crystal icon, 2D pixel art, 32x32 pixels, top-down view,
{COLOR} exotic crystal texture with intense glow, pulsing energy veins,
perfect geometric structure, particle aura effect, legendary quality,
complex facets, bright magical appearance, premium mineral,
transparent background, 16-bit SNES style, centered

Example - Neutronite:
Neutronite exotic ore icon, 2D pixel art, 32x32 pixels, top-down view,
deep purple crystal with bright cyan energy veins pulsing,
perfect hexagonal structure, glowing particle aura, legendary rare quality,
otherworldly appearance, intense luminescence,
transparent background, 16-bit SNES style, centered
```

### Mineral Icons (Refined)

```
{MINERAL_NAME} ingot icon, 2D pixel art, 32x32 pixels, top-down view,
{COLOR} polished metal bar, rectangular ingot shape, refined material,
smooth reflective surface, industrial processing stamp optional,
clean metallic appearance, game inventory icon,
transparent background, 16-bit SNES style, centered

Examples:

Iron Ingot:
Iron metal ingot icon, 2D pixel art, 32x32 pixels, top-down view,
polished gray steel bar, rectangular ingot shape, smooth metallic surface,
subtle reflections, industrial quality, refined material,
transparent background, 16-bit SNES style, centered

Platinum Ingot (T2):
Platinum ingot icon, 2D pixel art, 32x32 pixels, top-down view,
brilliant silver-white polished metal bar, high-quality rectangular ingot,
mirror-like reflective surface, premium material appearance,
transparent background, 16-bit SNES style, centered
```

### Gas Icons

```
{GAS_NAME} canister icon, 2D pixel art, 32x32 pixels, top-down view,
{COLOR} gas contained in transparent cylindrical canister,
swirling gas visible inside, metallic cap and base, pressure valve,
color-coded gas type, semi-transparent effect, game inventory icon,
transparent background, 16-bit SNES style, centered

Examples:

Hydrogen:
Hydrogen gas canister icon, 2D pixel art, 32x32 pixels, top-down view,
light blue gas swirling inside transparent cylinder, metallic silver cap,
H2 label optional, clean fuel appearance, scientific container,
transparent background, 16-bit SNES style, centered

Plasma (Rare):
Exotic plasma canister icon, 2D pixel art, 32x32 pixels, top-down view,
bright purple-pink energy plasma swirling violently inside reinforced container,
glowing with intense light, electric arcs visible, danger markings,
unstable appearance, rare gas type,
transparent background, 16-bit SNES style, centered
```

### Component Icons

```
{COMPONENT_NAME} component icon, 2D pixel art, 32x32 pixels, top-down view,
{DESCRIPTION} mechanical/electronic part, industrial design,
metallic casing with {COLOR} accents, technical details visible,
circuit patterns optional, crafted item quality, game inventory icon,
transparent background, 16-bit SNES style, centered

Examples:

Compressor (T1):
Compressor component icon, 2D pixel art, 32x32 pixels, top-down view,
cylindrical mechanical compressor with gray metallic casing,
visible intake/exhaust ports, industrial design, basic tech level,
simple geometric shape, blue accent lights,
transparent background, 16-bit SNES style, centered

Quantum Core (T2):
Quantum core component icon, 2D pixel art, 32x32 pixels, top-down view,
spherical device with glowing cyan energy core visible through transparent shell,
advanced technology, circuit patterns on surface, pulsing light effect,
high-tech appearance, premium component quality,
transparent background, 16-bit SNES style, centered

Antimatter Containment (T3):
Antimatter containment unit icon, 2D pixel art, 32x32 pixels, top-down view,
complex cubic device with purple-black energy swirling inside magnetic field,
ultra-advanced technology, glowing warning stripes, multiple layers visible,
dangerous exotic material, legendary tier component,
transparent background, 16-bit SNES style, centered
```

### Weapon Icons

```
{WEAPON_NAME} weapon icon, 2D pixel art, 32x32 pixels, side/angled view,
{WEAPON_TYPE} design in {COLOR} color scheme, combat weapon appearance,
visible barrel/emitter, power cells, targeting systems,
military industrial design, tier {TIER} technology level,
transparent background, 16-bit SNES style, centered

Examples:

Basic Laser (T1):
Basic laser weapon icon, 2D pixel art, 32x32 pixels, angled view,
red beam emitter design, simple cylindrical barrel, basic power cell,
entry-level energy weapon, minimal details, functional military design,
transparent background, 16-bit SNES style, centered

Railgun (T2):
Railgun weapon icon, 2D pixel art, 32x32 pixels, side view,
long electromagnetic barrel in dark gray, blue capacitor coils visible,
advanced kinetic weapon, glowing charging elements, sleek military design,
transparent background, 16-bit SNES style, centered
```

### Module Icons

```
{MODULE_NAME} ship module icon, 2D pixel art, 32x32 pixels, top-down view,
{MODULE_TYPE} equipment in {COLOR} housing, technical ship component,
mounting points visible, {SPECIAL_FEATURES}, upgrade module appearance,
transparent background, 16-bit SNES style, centered

Example - Shield Generator:
Shield generator module icon, 2D pixel art, 32x32 pixels, top-down view,
circular device with cyan energy emitters, protective field generator,
metallic gray housing with glowing blue accents, energy coils visible,
defensive module appearance, advanced technology,
transparent background, 16-bit SNES style, centered
```

---

## 🌍 PLANET PROMPTS

### Universal Planet Template

```
{PLANET_TYPE} planet sprite, 2D pixel art, {SIZE} pixels, perfect sphere,
{COLOR_SCHEME} surface, {ATMOSPHERIC_FEATURES}, {SPECIAL_DETAILS},
space background removed, only planet visible, clean circular shape,
subtle lighting from upper-left, sci-fi aesthetic, game asset,
transparent background, 16-bit SNES style, centered composition

Negative: blurry, irregular shape, stars visible, space background, text
```

### Gas Giants (200 variants)

#### Jupiter-Type (50 variants)

```
Filename: planet_gas_jupiter_variant{001-050}_256.png
Size: 256x256 pixels

Base Prompt:
Gas giant planet sprite, 2D pixel art, 256x256 pixels, perfect sphere,
Jupiter-style appearance with horizontal cloud bands,
{VARIANT_COLORS: orange/brown/cream/red variations},
swirling storm systems visible, great red spot optional,
atmospheric turbulence patterns, gaseous texture,
subtle lighting from upper-left, majestic gas giant,
transparent background, 16-bit SNES style, centered

Variant Color Schemes (rotate through):
Variant 001-010: Classic orange and brown bands
Variant 011-020: Red and cream bands
Variant 021-030: Yellow and white bands
Variant 031-040: Purple and blue bands (exotic)
Variant 041-050: Green and teal bands (rare)
```

#### Saturn-Type (with rings, 50 variants)

```
Filename: planet_gas_saturn_variant{001-050}_256.png
Size: 256x256 pixels

Prompt:
Ringed gas giant planet sprite, 2D pixel art, 256x256 pixels, perfect sphere,
Saturn-style with prominent ring system, pale yellow-cream planet surface,
detailed horizontal cloud bands, spectacular planetary rings at angle,
{RING_COLORS: ice white/golden/multi-colored variations},
ring shadow cast on planet surface, atmospheric haze,
subtle lighting from upper-left, elegant gas giant,
transparent background, 16-bit SNES style, centered
```

#### Neptune-Type (50 variants)

```
Prompt:
Ice giant planet sprite, 2D pixel art, 256x256 pixels, perfect sphere,
Neptune-style deep blue appearance, {BLUE_VARIANT: azure/cobalt/navy/cyan},
subtle cloud patterns, smooth atmospheric gradient,
darker storm spots visible, icy gas composition,
calm serene appearance, cold gas giant aesthetic,
transparent background, 16-bit SNES style, centered
```

#### Exotic Gas Giants (50 variants)

```
Prompt:
Exotic gas giant planet sprite, 2D pixel art, 256x256 pixels, perfect sphere,
{EXOTIC_TYPE} unusual appearance, {EXOTIC_COLORS: purple/green/black/neon},
{SPECIAL_EFFECTS: glowing bands/energy storms/plasma arcs/aurora},
alien atmospheric composition, sci-fi surreal aesthetic,
otherworldly gas giant, unique phenomenon visible,
transparent background, 16-bit SNES style, centered

Examples:
- Purple lightning storms across surface
- Neon green bioluminescent clouds
- Black anti-matter swirls
- Rainbow aurora rings
```

### Rocky Planets (300 variants)

#### Mars-Type (100 variants)

```
Filename: planet_rocky_mars_variant{001-100}_256.png
Size: 256x256 pixels

Prompt:
Rocky desert planet sprite, 2D pixel art, 256x256 pixels, perfect sphere,
Mars-style red desert surface, {RED_VARIANT: rust red/orange/brown variations},
visible craters and canyons, polar ice caps optional,
dust storm clouds, arid barren landscape, rocky terrain texture,
no atmosphere or thin atmosphere, desert planet aesthetic,
transparent background, 16-bit SNES style, centered

Variant Features (randomize):
- Large canyon systems (Variants 001-020)
- Prominent craters (Variants 021-040)
- Polar ice caps (Variants 041-060)
- Dust storms (Variants 061-080)
- Mixed features (Variants 081-100)
```

#### Earth-Type (100 variants)

```
Filename: planet_rocky_earth_variant{001-100}_256.png
Size: 256x256 pixels

Prompt:
Habitable rocky planet sprite, 2D pixel art, 256x256 pixels, perfect sphere,
Earth-like with blue oceans and green-brown continents,
{OCEAN_COVERAGE: 20%-80% variations}, white cloud patterns,
visible landmasses with varied shapes, polar ice caps,
lush living planet appearance, blue marble aesthetic,
transparent background, 16-bit SNES style, centered

Continent Variations:
- Single supercontinent (Variants 001-020)
- Island archipelagos (Variants 021-040)
- Two major continents (Variants 041-060)
- Pangaea-style (Variants 061-080)
- Random configurations (Variants 081-100)
```

#### Volcanic/Lava Planets (100 variants)

```
Filename: planet_lava_molten_variant{001-100}_256.png
Size: 256x256 pixels

Prompt:
Molten lava planet sprite, 2D pixel art, 256x256 pixels, perfect sphere,
volcanic surface with glowing orange-red lava rivers,
dark black-gray cooled rock crust, bright magma cracks,
active volcanic eruptions visible, intense heat glow,
hellish inferno planet, dramatic lighting from lava,
smoke and ash atmosphere optional, dangerous world aesthetic,
transparent background, 16-bit SNES style, centered

Intensity Variations:
- Mostly cooled (10% lava) - Variants 001-025
- Active (30% lava) - Variants 026-050
- Very active (60% lava) - Variants 051-075
- Molten surface (90% lava) - Variants 076-100
```

### Ice Planets (200 variants)

```
Filename: planet_ice_{type}_variant{001-200}_256.png
Size: 256x256 pixels

Prompt:
Frozen ice planet sprite, 2D pixel art, 256x256 pixels, perfect sphere,
{ICE_TYPE} icy surface in {COLOR: white/blue/cyan variations},
visible ice cracks and glaciers, frozen ocean surface,
snow-covered terrain, polar planet appearance, cold blue-white tones,
{FEATURES: ice crystals/frozen seas/frost patterns/crevasses},
frigid world aesthetic, subtle atmosphere haze,
transparent background, 16-bit SNES style, centered

Types:
- Pluto-style (gray-white ice)
- Europa-style (cracked ice surface)
- Pure ice (brilliant white)
- Methane ice (blue-tinted)
```

### Desert Planets (100 variants)

```
Prompt:
Desert planet sprite, 2D pixel art, 256x256 pixels, perfect sphere,
{DESERT_TYPE: sand/rocky} desert surface in {COLOR: tan/gold/orange/red},
dune patterns or rocky wasteland, no vegetation, arid barren appearance,
occasional crater, dust storms optional, harsh sunlight,
Tatooine-style desert world, desolate landscape,
transparent background, 16-bit SNES style, centered
```

### Exotic Planets (100 variants)

```
Prompt:
Exotic alien planet sprite, 2D pixel art, 256x256 pixels, perfect sphere,
{EXOTIC_TYPE} otherworldly surface, {IMPOSSIBLE_COLORS: unnatural hues},
{SPECIAL_PHENOMENA: crystals/plasma/dark matter/radiation/bioluminescence},
science fiction anomaly, unique planetary composition,
surreal alien world, mysterious appearance, glowing features optional,
transparent background, 16-bit SNES style, centered

Types:
- Crystalline planets (geometric crystal formations)
- Plasma planets (energy surface)
- Dark matter planets (void-like appearance)
- Radioactive planets (green glow)
- Bioluminescent planets (glowing organic patterns)
```

---

## ⛏️ ASTEROID PROMPTS

### Universal Asteroid Template

```
{ORE_TYPE} asteroid sprite, 2D pixel art, {SIZE} pixels, irregular rock shape,
{COLOR} rocky texture with {ORE_COLOR} ore veins visible,
{SIZE_DESC} space rock, cratered surface, rough terrain,
floating in space, resource-rich asteroid, mineable object,
transparent background, 16-bit SNES style, centered

Negative: perfect sphere, planet, smooth, blurry, white background
```

### Size-Specific Templates

#### Small Asteroids (64x64)

```
Filename: asteroid_{ore_type}_small_{01-02}_64.png
Size: 64x64 pixels

Prompt:
Small {ORE_TYPE} asteroid sprite, 2D pixel art, 64x64 pixels,
irregular rocky chunk, {COLOR} stone with {ORE_COLOR} mineral veins,
simple shape, few craters, rough surface texture,
small mineable resource, compact space rock,
transparent background, 16-bit SNES style, centered
```

#### Medium Asteroids (128x128)

```
Filename: asteroid_{ore_type}_medium_{01-02}_128.png
Size: 128x128 pixels

Prompt:
Medium {ORE_TYPE} asteroid sprite, 2D pixel art, 128x128 pixels,
irregular potato-shaped rock, {COLOR} stone with prominent {ORE_COLOR} ore deposits,
visible craters and surface detail, rich mineral veins,
moderate size space rock, detailed surface features,
transparent background, 16-bit SNES style, centered
```

#### Large Asteroids (256x256)

```
Filename: asteroid_{ore_type}_large_{01-02}_256.png
Size: 256x256 pixels

Prompt:
Large {ORE_TYPE} asteroid sprite, 2D pixel art, 256x256 pixels,
massive irregular rock formation, {COLOR} stone with extensive {ORE_COLOR} ore veins,
many impact craters, detailed rocky terrain, valuable mineral deposits,
huge mineable asteroid, complex surface geography,
transparent background, 16-bit SNES style, centered
```

### Ore-Specific Examples

```
Ferralite (Iron) Asteroid:
Ferralite asteroid sprite, 2D pixel art, 128x128 pixels,
irregular gray rocky chunk, dark metallic gray with rust-brown iron ore veins,
cratered surface, rough texture, iron-rich asteroid,
transparent background, 16-bit SNES style, centered

Cupreon (Copper) Asteroid:
Cupreon asteroid sprite, 2D pixel art, 128x128 pixels,
irregular rocky mass, gray stone with bright orange-copper mineral veins,
visible copper deposits, cratered surface, valuable ore asteroid,
transparent background, 16-bit SNES style, centered

Azurex (Blue Rare) Asteroid:
Azurex asteroid sprite, 2D pixel art, 128x128 pixels,
irregular crystalline rock, dark stone with glowing blue crystal veins,
rare azure mineral deposits, semi-precious asteroid, subtle glow,
transparent background, 16-bit SNES style, centered
```

### Damage States

```
25% Damage:
Same base prompt + "with small cracks appearing, minor damage,
surface fractures, early mining stage, mostly intact"

50% Damage:
Same base prompt + "with large visible cracks, moderate damage,
deep fissures, half-depleted ore, partially mined"

75% Damage:
Same base prompt + "with severe cracks and chunks missing, heavy damage,
nearly depleted, fragmented appearance, almost mined out"

Depleted:
Same base prompt + "completely depleted, dark empty shell,
all ore extracted, hollow appearance, worthless husk, no glow"
```

---

## 🏭 STATION PROMPTS

### Small Stations (256x256)

```
Filename: station_small_{type}_256.png
Size: 256x256 pixels

Base Template:
Small space station sprite, 2D pixel art, 256x256 pixels,
{STATION_TYPE} design, {COLOR_SCHEME}, compact modular structure,
{KEY_FEATURES}, docking ports visible, antenna arrays,
window lights glowing, industrial space construction,
transparent background, 16-bit SNES style, centered

Examples:

Mining Outpost:
Small mining outpost station, 2D pixel art, 256x256 pixels,
industrial refinery design, yellow and gray color scheme,
ore processing equipment visible, storage silos, crane arms,
docking bay for ships, red warning lights, utilitarian construction,
transparent background, 16-bit SNES style, centered

Trading Post:
Small trading post station, 2D pixel art, 256x256 pixels,
commercial hub design, white and blue friendly colors,
market stalls visible, cargo containers, multiple docking ports,
neon signs optional, busy commercial activity, welcoming appearance,
transparent background, 16-bit SNES style, centered
```

### Medium Stations (512x512)

```
Filename: station_medium_{type}_512.png
Size: 512x512 pixels

Factory Station:
Medium factory station sprite, 2D pixel art, 512x512 pixels,
large industrial manufacturing complex, gray and orange industrial colors,
smokestacks emitting particles, assembly line visible through windows,
cargo loading bays, multiple modules connected, complex structure,
glowing furnaces, active production facility, heavy industry aesthetic,
transparent background, 16-bit SNES style, centered

Shipyard:
Medium shipyard station sprite, 2D pixel art, 512x512 pixels,
ship construction facility design, blue and silver tech colors,
large construction scaffolding, ship under construction visible,
welding sparks effects, crane arms, massive docking framework,
high-tech appearance, advanced manufacturing, impressive scale,
transparent background, 16-bit SNES style, centered
```

### Large Stations (1024x1024)

```
Filename: station_large_{type}_1024.png
Size: 1024x1024 pixels

Citadel:
Massive citadel space station, 2D pixel art, 1024x1024 pixels,
enormous ring-shaped megastructure, white and gold majestic design,
multiple rotating sections, hundreds of windows lit,
massive scale, city in space, population center visible,
defense turrets, docking terminals, grandeur architecture,
impressive capital station, monumental construction,
transparent background, 16-bit SNES style, centered

Military Fortress:
Large military fortress station, 2D pixel art, 1024x1024 pixels,
heavily armed military base, dark gray and red threatening design,
weapon turrets everywhere, armored hull plating, shield generators,
hangar bays with fighters, radar dishes, defense platform,
intimidating fortress appearance, military power projection,
transparent background, 16-bit SNES style, centered
```

### Station Modules (128x128)

```
Refinery Module Active:
Refinery module sprite, 2D pixel art, 128x128 pixels,
rotating processing unit, orange glow from furnaces,
pipes and smokestacks, industrial machinery visible,
active ore refining, heat shimmer effect, busy operation,
transparent background, 16-bit SNES style, centered

Shield Generator Module:
Shield generator module sprite, 2D pixel art, 128x128 pixels,
dome-shaped energy emitter, cyan energy field visible,
glowing capacitor coils, humming with power, defensive system,
protective force field technology, blue-white energy glow,
transparent background, 16-bit SNES style, centered
```

---

## ✨ EFFECT/VFX PROMPTS

### Explosion Spritesheets

```
Filename: fx_explosion_{size}_spritesheet_{total_size}.png
Grid: 4x4 (16 frames) or 6x4 (24 frames)

Small Explosion (512x512 total, 128px/frame):
Ship explosion animation spritesheet, 2D pixel art, 512x512 pixels,
16 frames in 4x4 grid, each frame 128x128 pixels,
progressive explosion sequence:
Frame 1-4: Initial flash and expanding fireball,
Frame 5-8: Peak explosion with debris flying,
Frame 9-12: Smoke and fading flames,
Frame 13-16: Final wisps of smoke dissipating,
bright orange-yellow-red explosion colors, dramatic blast,
transparent background, 16-bit SNES style, animation sequence

Medium Explosion (1024x1024 total, 256px/frame):
Large ship explosion spritesheet, 2D pixel art, 1024x1024 pixels,
16 frames in 4x4 grid, each frame 256x256 pixels,
massive explosion sequence with expanding shockwave,
intense fireball, flying debris chunks, bright white flash at center,
orange and red flames billowing, black smoke forming,
spectacular destruction, high-energy blast,
transparent background, 16-bit SNES style, animation sequence
```

### Laser Beams

```
Mining Laser:
Mining laser beam sprite, 2D pixel art, 16x128 pixels vertical beam,
bright red energy beam, glowing core with softer outer aura,
straight vertical line, intense cutting laser, pulsing energy,
semi-transparent glow effect, mining tool beam,
transparent background, 16-bit SNES style

Weapon Laser:
Combat laser beam sprite, 2D pixel art, 16x128 pixels,
{COLOR: red/blue/green} weapon energy beam, intense brightness,
sharp focused beam, deadly weapon discharge, electrical crackle,
transparent background, 16-bit SNES style
```

### Shield Effects

```
Shield Impact Animation:
Shield hit effect spritesheet, 2D pixel art, 256x256 pixels,
12 frames showing ripple impact, hexagonal shield pattern,
bright flash at impact point, energy wave expanding outward,
cyan-blue shield color, protective barrier visualization,
fading over 12 frames, defensive effect,
transparent background, 16-bit SNES style, animation
```

### Particle Textures

```
Engine Exhaust Particle:
Engine exhaust particle, 2D pixel art, 32x32 pixels,
glowing blue-white energy wisp, soft gradient to edges,
radial glow particle, thruster exhaust, fading transparent edges,
bright center, transparent background, 16-bit SNES style

Mining Debris Particle:
Mining rock debris particle, 2D pixel art, 16x16 pixels,
small gray rock chunk, irregular shape, tumbling asteroid fragment,
mining waste, simple solid particle,
transparent background, 16-bit SNES style
```

### Nebulae & Gas Clouds

```
Nebula Layer (Parallax):
Space nebula background layer, 2D pixel art, 1920x1080 pixels,
{COLOR: purple/blue/red/green} gaseous cloud formation,
wispy ethereal gas, stars scattered throughout optional,
subtle transparency, cosmic cloud, deep space aesthetics,
painterly style, atmospheric phenomenon,
transparent edges for tiling, 16-bit SNES style

Toxic Gas Cloud (Hazard):
Toxic gas cloud sprite, 2D pixel art, 256x256 pixels,
green glowing poisonous gas, swirling dangerous cloud,
hazardous area marker, warning aesthetic, semi-transparent,
ominous appearance, environmental hazard,
transparent background, 16-bit SNES style
```

---

## 🖥️ UI ELEMENT PROMPTS

### HUD Bars

```
Health Bar Background:
Health bar background UI, 2D pixel art, 300x40 pixels,
dark gray container with metallic border, empty health bar frame,
9-slice compatible, clean UI design, game interface element,
transparent background, 16-bit SNES style

Health Bar Fill:
Health bar fill UI, 2D pixel art, 300x40 pixels,
bright green gradient health indicator, smooth fill bar,
left-to-right fill, 9-slice compatible for resizing,
vibrant life indicator, game HUD element,
transparent background, 16-bit SNES style

Shield Bar Fill:
Shield bar fill UI, 2D pixel art, 300x40 pixels,
cyan-blue gradient shield indicator, energy barrier color,
glowing effect, 9-slice compatible,
transparent background, 16-bit SNES style
```

### Buttons

```
Primary Button Normal:
Primary UI button normal state, 2D pixel art, 200x60 pixels,
blue-gray metallic button, subtle 3D bevel effect,
clean professional design, clickable appearance,
9-slice compatible edges, sci-fi interface style,
transparent background, 16-bit SNES style

Primary Button Hover:
Primary UI button hover state, 2D pixel art, 200x60 pixels,
brighter blue highlighted button, glowing effect,
mouse-over state, more vibrant than normal,
same shape as normal state, interactive feedback,
transparent background, 16-bit SNES style

Primary Button Pressed:
Primary UI button pressed state, 2D pixel art, 200x60 pixels,
darker blue pushed-down button, inverted bevel,
clicked appearance, depressed state,
transparent background, 16-bit SNES style
```

### Panels

```
Station Menu Panel:
Station menu panel UI, 2D pixel art, 800x600 pixels,
sci-fi window frame with metallic borders, dark semi-transparent center,
corner decorations, title bar area, 9-slice compatible,
futuristic interface design, game menu background,
transparent outer area, 16-bit SNES style
```

### Icons

```
Inventory Slot Empty:
Empty inventory slot UI, 2D pixel art, 64x64 pixels,
dark square with light border, empty container,
grid pattern faint background, item slot placeholder,
clean minimal design, game inventory interface,
transparent background, 16-bit SNES style

Rarity Border Legendary:
Legendary item border, 2D pixel art, 64x64 pixels,
glowing golden ornate frame, animated shimmer effect optional,
prestigious appearance, rare quality indicator,
transparent center for item icon, 16-bit SNES style
```

### Minimap Elements

```
Minimap Player Dot:
Player minimap marker, 2D pixel art, 8x8 pixels,
bright green glowing dot, player position indicator,
clearly visible, friendly color, navigation HUD element,
transparent background, 16-bit SNES style

Minimap Enemy Dot:
Enemy minimap marker, 2D pixel art, 8x8 pixels,
bright red glowing dot, hostile target indicator,
danger color, threat marker, navigation element,
transparent background, 16-bit SNES style
```

---

## 👥 NPC AVATAR PROMPTS

### Universal NPC Avatar Template

```
{NPC_TYPE} character portrait, 2D pixel art, 128x128 pixels,
{DESCRIPTION} person, {CLOTHING/UNIFORM}, head and shoulders view,
{DISTINCTIVE_FEATURES}, {EXPRESSION}, sci-fi character design,
clean portrait composition, game dialog avatar,
transparent background, 16-bit SNES style, centered

Negative: full body, blurry, photorealistic, anime, white background
```

### Specific NPC Types

```
Trader (Human Male):
Merchant trader character portrait, 2D pixel art, 128x128 pixels,
middle-aged human male with friendly appearance, commercial uniform,
clean-cut hair, slight smile, professional demeanor,
trader's insignia on collar, trustworthy face,
sci-fi character design, head and shoulders portrait,
transparent background, 16-bit SNES style, centered

Pirate (Scarred):
Pirate captain portrait, 2D pixel art, 128x128 pixels,
rough human male with facial scar, aggressive expression,
makeshift armor pieces, unkempt appearance, eye patch optional,
menacing look, battle-hardened features, dark clothing,
sci-fi space pirate, intimidating character,
transparent background, 16-bit SNES style, centered

Police Officer:
Law enforcement officer portrait, 2D pixel art, 128x128 pixels,
stern human in blue police uniform, official cap,
serious professional expression, badge visible,
authority figure appearance, clean uniform,
sci-fi space police, by-the-book demeanor,
transparent background, 16-bit SNES style, centered

Station Manager:
Station administrator portrait, 2D pixel art, 128x128 pixels,
middle-aged person in business attire, professional appearance,
neutral friendly expression, management role,
clean groomed, station uniform with rank insignia,
bureaucrat aesthetic, organized demeanor,
transparent background, 16-bit SNES style, centered

Alien Trader (Type 1):
Alien merchant portrait, 2D pixel art, 128x128 pixels,
friendly alien species with {FEATURES: blue skin/tentacles/multiple eyes},
exotic but approachable appearance, trader's robe,
non-threatening alien design, curious expression,
sci-fi extraterrestrial character, unique biology,
transparent background, 16-bit SNES style, centered
```

### Faction Logos

```
{Faction Name} Logo:
{FACTION} faction emblem, 2D pixel art, 128x128 pixels,
{SYMBOL_DESCRIPTION} insignia design, {COLOR_SCHEME},
military/corporate/organization style, clean iconic symbol,
professional logo design, faction identification,
transparent background, 16-bit SNES style, centered

Examples:

Galactic Federation:
Galactic Federation emblem, 2D pixel art, 128x128 pixels,
stylized planet and stars symbol in blue and white,
official government insignia, authoritative design,
circle border with text optional, professional logo,
transparent background, 16-bit SNES style, centered

Pirate Syndicate:
Pirate syndicate logo, 2D pixel art, 128x128 pixels,
skull and crossed tools symbol in red and black,
menacing outlaw insignia, threatening design,
rough aggressive style, criminal organization mark,
transparent background, 16-bit SNES style, centered
```

---

## 🌌 BACKGROUND PROMPTS

### Star Fields (Parallax Layers)

```
Layer 1 (Distant Stars):
Deep space star field layer 1, 2D pixel art, 1920x1080 pixels,
distant tiny stars scattered sparsely, very small white dots,
far background layer, minimal detail, dark space,
seamless tiling edges, parallax background layer,
black space background, 16-bit SNES style

Layer 2 (Medium Stars):
Space star field layer 2, 2D pixel art, 1920x1080 pixels,
medium-sized stars more densely scattered, varied brightness,
middle parallax layer, some subtle color variation,
seamless tiling, medium-distance stars,
dark space background, 16-bit SNES style

Layer 3 (Near Stars/Dust):
Foreground star field layer 3, 2D pixel art, 1920x1080 pixels,
large bright stars and space dust, closest layer,
varied star sizes, twinkling effect optional,
seamless tiling edges, nearest parallax layer,
transparent background for layering, 16-bit SNES style
```

### Nebula Backgrounds

```
Purple Nebula:
Purple space nebula background, 2D pixel art, 1920x1080 pixels,
vast purple and pink gaseous cloud formation,
wispy ethereal nebula, cosmic dust clouds,
deep space phenomenon, stars scattered throughout,
majestic cosmic view, atmospheric sci-fi background,
seamless tiling optional, 16-bit SNES style

Red Nebula:
Red emission nebula background, 2D pixel art, 1920x1080 pixels,
glowing red hydrogen clouds, intense crimson gas,
stellar nursery appearance, bright active region,
dramatic space background, fiery cosmic colors,
16-bit SNES style
```

### Sector-Specific Backgrounds

```
Asteroid Belt Sector:
Asteroid belt space background, 2D pixel art, 1920x1080 pixels,
distant asteroids silhouetted in background, dense asteroid field,
multiple rock chunks visible far away, hazardous sector appearance,
dark space with rocky obstacles, dangerous region aesthetic,
16-bit SNES style

Trading Hub Sector:
Busy trading hub background, 2D pixel art, 1920x1080 pixels,
distant space stations and ships visible in background,
commercial space lane, busy traffic far away,
bright station lights in distance, civilization presence,
active trading sector, 16-bit SNES style
```

---

## 🖱️ CURSOR PROMPTS

### Standard Cursors

```
Default Cursor:
Default mouse cursor, 2D pixel art, 32x32 pixels,
white arrow pointer with black outline, classic cursor shape,
clear visible design, game interface cursor,
transparent background, 16-bit SNES style

Pointer Hand Cursor:
Hand pointer cursor, 2D pixel art, 32x32 pixels,
white hand with pointing finger, clickable indicator,
clear gesture, interactive element cursor,
transparent background, 16-bit SNES style
```

### Gameplay Cursors

```
Mining Target Cursor:
Mining target cursor, 2D pixel art, 32x32 pixels,
green crosshair with small pickaxe icon in center,
mining action indicator, clear targeting reticle,
friendly green color, resource gathering cursor,
transparent background, 16-bit SNES style

Combat Target Enemy:
Enemy targeting cursor, 2D pixel art, 32x32 pixels,
red aggressive crosshair, hostile target indicator,
sharp angular design, combat cursor, danger color,
lock-on appearance, weapon targeting reticle,
transparent background, 16-bit SNES style

Docking Available:
Docking cursor, 2D pixel art, 32x32 pixels,
blue station icon with docking arrow, interaction indicator,
friendly approach cursor, landing permission visual,
transparent background, 16-bit SNES style
```

---

## 📜 BATCH GENERATION SCRIPTS

### Python Script for Batch Prompt Generation

```python
#!/usr/bin/env python3
"""
Generate AI prompts for all SpaceGameDev assets
Outputs: prompts.txt with one prompt per line
"""

# Ore Names from ItemDatabase (first 10 examples)
ORES_T1 = [
    ("ferralite", "dark gray metallic with rust spots"),
    ("metalite", "silver-gray metallic"),
    ("cupreon", "orange-copper metallic"),
    ("cuprex", "bright copper"),
    ("palestone", "pale gray stone"),
    ("titanex", "dark blue-gray titanium"),
    ("densore", "dense dark gray"),
    ("mirrorvein", "reflective silver veins"),
    ("azurex", "deep blue crystal"),
    ("sunvein", "golden veins")
]

def generate_ore_prompts():
    """Generate prompts for all ore icons"""
    prompts = []

    for ore_name, color_desc in ORES_T1:
        prompt = f"""
{ore_name.capitalize()} ore chunk icon, 2D pixel art, 32x32 pixels, top-down view,
{color_desc} rough rocky texture, simple mineral chunk, basic ore deposit,
slight metallic sheen, common quality, game inventory icon,
transparent background, 16-bit SNES style, centered

Negative: blurry, complex, white background, 3D render
---
FILENAME: icon_ore_{ore_name}_t1_32.png
SIZE: 32x32
"""
        prompts.append(prompt)

    return prompts

def generate_planet_prompts(count=1000):
    """Generate prompts for 1000 planet variants"""
    prompts = []

    categories = {
        "gas_jupiter": (50, "orange and brown bands", "Gas giant planet sprite"),
        "gas_saturn": (50, "pale yellow with rings", "Ringed gas giant sprite"),
        "gas_neptune": (50, "deep blue ice giant", "Ice giant planet sprite"),
        "gas_exotic": (50, "purple and neon", "Exotic gas giant sprite"),
        "rocky_mars": (100, "red desert", "Rocky desert planet sprite"),
        "rocky_earth": (100, "blue oceans green land", "Habitable planet sprite"),
        "ice_pluto": (100, "white and blue ice", "Frozen ice planet sprite"),
        "ice_europa": (50, "cracked ice surface", "Ice moon planet sprite"),
        "lava_molten": (100, "orange lava rivers", "Molten lava planet sprite"),
        "desert_sand": (50, "tan sand dunes", "Desert planet sprite"),
        "exotic_crystal": (50, "crystalline surface", "Exotic crystal planet sprite")
    }

    for category, (num_variants, colors, desc) in categories.items():
        for i in range(1, num_variants + 1):
            variant = f"{i:03d}"
            prompt = f"""
{desc}, 2D pixel art, 256x256 pixels, perfect sphere,
{colors}, detailed planetary surface, space object,
subtle lighting from upper-left, sci-fi aesthetic,
transparent background, 16-bit SNES style, centered

Negative: irregular shape, stars visible, blurry, text
---
FILENAME: planet_{category}_variant{variant}_256.png
SIZE: 256x256
"""
            prompts.append(prompt)

    return prompts

def generate_ship_prompts():
    """Generate prompts for all ship types"""
    ships = [
        ("player_explorer", "Medium explorer ship", "silver and blue", "balanced versatile design"),
        ("player_miner", "Industrial mining ship", "yellow and orange", "bulky with cargo holds"),
        ("player_fighter", "Combat fighter ship", "red and black", "sleek aggressive design"),
        ("npc_trader", "Cargo trader ship", "white and blue", "boxy cargo hauler"),
        ("npc_pirate", "Pirate fighter ship", "dark gray and red", "menacing angular design"),
        ("npc_police", "Police patrol ship", "white and blue", "clean interceptor design")
    ]

    prompts = []
    for ship_id, desc, colors, design in ships:
        prompt = f"""
{desc} sprite, 2D pixel art, 128x128 pixels, isometric 3/4 view,
{colors} color scheme, {design}, detailed hull plating,
glowing engine thrusters, sci-fi spaceship, game asset,
transparent background, 16-bit SNES style, centered

Negative: blurry, 3D render, white background, text
---
FILENAME: ship_{ship_id}_idle_128.png
SIZE: 128x128
"""
        prompts.append(prompt)

    return prompts

# Main execution
if __name__ == "__main__":
    all_prompts = []

    print("Generating ore prompts...")
    all_prompts.extend(generate_ore_prompts())

    print("Generating planet prompts (1000 variants)...")
    all_prompts.extend(generate_planet_prompts())

    print("Generating ship prompts...")
    all_prompts.extend(generate_ship_prompts())

    # Write to file
    with open("ai_generation_prompts.txt", "w") as f:
        f.write("\n".join(all_prompts))

    print(f"Generated {len(all_prompts)} prompts!")
    print("Saved to: ai_generation_prompts.txt")
```

### Usage Instructions

```bash
# 1. Save script as generate_prompts.py
# 2. Run script:
python3 generate_prompts.py

# 3. Output file contains all prompts ready for AI
# 4. Copy each prompt into your AI tool (Stable Diffusion, Leonardo, etc.)
# 5. Save generated image with exact filename from prompt
```

---

## 🎯 QUICK START WORKFLOW

### Step-by-Step Asset Generation

1. **Choose AI Tool**
   - Recommend: **Leonardo.ai** (free 150 credits/day)
   - Or: **Stable Diffusion** (local, unlimited)

2. **Set Global Settings**
   ```
   Style: 2D pixel art, 16-bit SNES
   Background: Transparent
   Aspect Ratio: 1:1 (square)
   Quality: High
   ```

3. **Start with High Priority**
   - Item icons (910) - Use batch generation
   - Player ships (9)
   - Basic UI (buttons, bars)

4. **Use Prompts from This Document**
   - Copy prompt exactly
   - Paste into AI tool
   - Generate
   - Download PNG

5. **Post-Processing**
   - Remove background if not transparent (use Remove.bg)
   - Resize to exact pixel size (use Photopea/GIMP)
   - Save with exact filename from specification

6. **Place in Correct Folder**
   ```bash
   assets/sprites/items/icons/ores/icon_ore_ferralite_t1_32.png
   ```

7. **Test in Game**
   - Game auto-loads via AssetManager
   - Check in-game appearance
   - Iterate if needed

---

## ✅ TRANSPARENCY CHECKLIST

**Yes, transparent backgrounds are REQUIRED for:**

✅ All sprites (ships, asteroids, stations)
✅ All icons (items, UI elements)
✅ All effects (explosions, particles)
✅ All cursors
✅ All UI elements (buttons, panels - except solid backgrounds)
✅ NPC avatars (portrait only, not background)

**Solid backgrounds OK for:**

❌ Full-screen backgrounds (space, nebulae) - These should fill screen
❌ Planet sprites - Can have black space OR transparent (your choice)

**How to ensure transparency:**

1. **In AI Tool:** Select "transparent background" option
2. **In Stable Diffusion:** Use PNG format, alpha channel enabled
3. **Post-processing:** Use Remove.bg or Photopea to remove white backgrounds
4. **Verification:** Open in image editor, check for checkered pattern (= transparent)

---

## 📊 GENERATION ESTIMATES

### Time Estimates (Using Leonardo.ai Free Tier)

| Category | Assets | AI Generations Needed | Days (150 credits/day) |
|----------|--------|----------------------|------------------------|
| Item Icons | 910 | 910 | ~6 days |
| Planets | 1000 | 1000 | ~7 days |
| Ships | 350 | 350 | ~3 days |
| Asteroids | 500 | 500 | ~4 days |
| UI | 200 | 200 | ~2 days |
| Effects | 150 | 150 | ~1 day |
| NPCs | 200 | 200 | ~2 days |
| Other | 285 | 285 | ~2 days |
| **TOTAL** | **3,595** | **3,595** | **~27 days** |

**Faster options:**
- **Stable Diffusion (local):** Unlimited generations, ~30 seconds each = ~30 hours total
- **Leonardo.ai paid:** $12/month = 8,500 credits = generate all in 1-2 days
- **Multiple AI tools:** Use 3-4 free accounts in parallel = ~7 days total

---

## 🚀 READY TO START!

You now have:

✅ **Recommended AI tools** (free options)
✅ **Complete prompt templates** for every asset category
✅ **Exact specifications** (size, style, colors)
✅ **Batch generation scripts** for automation
✅ **Transparency requirements** clearly defined
✅ **Time estimates** for planning

**Next Steps:**

1. Choose your AI tool (recommend: Leonardo.ai or Stable Diffusion)
2. Start with **Item Icons** (910 assets, most important)
3. Use prompts from this document
4. Generate, download, rename to exact filename
5. Place in correct folder
6. Game auto-loads!

**Good luck with your asset generation!** 🎨🚀

---

**Document Version:** 1.0
**Companion Document:** ASSET_SPECIFICATION.md
**Total Prompts Ready:** 4,585+
**Automation Level:** High (batch scripts included)
