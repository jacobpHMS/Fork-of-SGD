# Procedural Pixel Art Asset Generator

**Tool-Typ:** Web-basierter Prozeduraler Generator
**Version:** 2.0
**Location:** `/asset-generator/`
**Status:** ✅ Production Ready

---

## 📖 Übersicht

Der **Procedural Pixel Art Asset Generator** ist ein vollständig funktionsfähiges Web-Tool zur automatischen Generierung von Pixel-Art Assets für SpaceGameDev. Es benötigt **keine Grafikerfahrung** und läuft komplett im Browser!

### 🎯 Hauptfunktionen

- **5 Generator-Module:** Schiffe, Asteroiden, Projektile, Effekte, Backgrounds
- **Animation-System:** Automatische Frame-Generierung für Animationen
- **Farbpaletten-Manager:** Vorgefertigte + custom Paletten
- **Export-System:** PNG, Sprite Sheets, Batch-Export
- **Seeded Random:** Reproduzierbare Assets
- **Keine Installation:** Läuft direkt im Browser

---

## 🚀 Quick Start

### Tool starten

```bash
# Browser öffnen mit:
/pfad/zu/SpaceGameDev/asset-generator/index.html
```

### In 30 Sekunden zum ersten Schiff

1. Tool öffnen
2. Größe: **32x32**
3. Komplexität: **5**
4. Faction: **Angular**
5. **Generate** klicken
6. **Export PNG** klicken
7. Fertig! ✨

---

## 🎨 Generator-Module

### 1. Raumschiff-Generator 🚀

**Perfekt für:** Spieler-Schiffe, NPCs, Feinde

#### Features
- Symmetrische Generierung (vertical/horizontal/radial)
- 3 Fraktionsstile (Angular/Organic/Hybrid)
- Größen: 16×16 bis 128×128
- Optional: Waffen + Triebwerke
- Seeded Random für Reproduzierbarkeit

#### Fraktionsstile im Detail

| Stil | Beschreibung | Perfekt für |
|------|--------------|-------------|
| **Angular** | Eckig, geometrisch, militärisch | Menschliche Flotten, Militär |
| **Organic** | Rund, fließend, alien-artig | Außerirdische Rassen |
| **Hybrid** | Mix aus beiden | Prototypen, Spezialschiffe |

#### Symmetrie-Modi

- **Vertical:** Links/Rechts gespiegelt (Standard für Schiffe)
- **Horizontal:** Oben/Unten gespiegelt
- **Both:** Kreuzförmig
- **Radial:** 4-fach Symmetrie

#### Beispiel-Workflow

```
Ziel: Player Explorer Ship

Settings:
  Size: 64x64
  Complexity: 7
  Faction: Hybrid
  Symmetry: Vertical
  Weapons: ✓
  Engines: ✓
  Seed: (leer für random)

→ Generate
→ Export als "ship_player_explorer_001.png"
```

---

### 2. Asteroiden-Generator 🪨

**Perfekt für:** Mining-Targets, Umgebungs-Obstacles

#### Features
- Perlin Noise für organische Formen
- 7 Ore-Typen (Iron, Copper, Gold, Titanium, Uranium, Platinum, Crystal)
- Damage-States generierbar
- Krater-System
- Größen: 8×8 bis 256×256

#### Ore-Typen & Farben

| Ore | Farben | Verwendung |
|-----|--------|------------|
| **Iron** | Grau-metallisch | Standard-Mining |
| **Copper** | Orange-kupfer | Tech-Produktion |
| **Gold** | Gold-gelb | Wertvoll, Trade |
| **Titanium** | Dunkel-blau | Schiffsbau |
| **Uranium** | Grün-leuchtend | Energie, selten |
| **Platinum** | Silber-weiß | Premium, sehr selten |
| **Crystal** | Blau-kristallin | Sci-Fi, exotisch |

#### Parameter erklärt

- **Roughness (0-1):** Wie irregulär die Kanten sind
  - 0.2 = Glatt, fast rund
  - 0.5 = Mittel, natürlich
  - 0.8 = Sehr rau, zerklüftet

- **Complexity (1-10):** Oberflächendetails
  - 1-3 = Wenig Details, glatt
  - 4-7 = Moderate Details, gut
  - 8-10 = Viele Details, komplex

#### Damage-States

Erstelle Asteroiden mit Abbau-Fortschritt:
- 0% Damage = Voll
- 25% Damage = Kleine Risse
- 50% Damage = Große Risse
- 75% Damage = Stark beschädigt
- 100% = Depleted (leer, dunkel)

---

### 3. Projektil-Generator 💥

**Perfekt für:** Waffensysteme, Laser, Raketen

#### Projektil-Typen

**Laser** (Schnellfeuer)
```
Eigenschaften:
  - Dünner Beam
  - Pulsing-Animation (4 Frames)
  - Farbe: Meist Cyan/Red
  - Speed: Sehr schnell

Verwendung: Spieler-Primärwaffe, Feind-Laser
```

**Missile** (Gelenkt)
```
Eigenschaften:
  - Raketen-Körper
  - Thrust-Animation (4 Frames)
  - Sichtbare Triebwerke
  - Speed: Mittel

Verwendung: Lenkwaffen, Heavy Weapons
```

**Plasma** (Energie)
```
Eigenschaften:
  - Pulsierender Ball
  - Elektrische Bögen (8 Frames)
  - Glow-Effekt
  - Speed: Langsam

Verwendung: Alien-Waffen, Energiegeschosse
```

**Beam** (Kontinuierlich)
```
Eigenschaften:
  - Durchgehender Strahl
  - Flacker-Effekt (4 Frames)
  - Dicke variabel
  - Speed: Instant

Verwendung: Mining-Laser, Continuous-Fire
```

**Torpedo** (Schwer)
```
Eigenschaften:
  - Großer Körper
  - Leuchtender Warhead
  - Massives Thrust (8 Frames)
  - Speed: Langsam, mächtig

Verwendung: Capital Ship Waffen, Boss-Weapons
```

#### Animation-Settings

- **Frame Count:** 4-8 Frames (je nach Typ)
- **Animated:** ✓ für Bewegung, ✗ für statisch
- **Color:** Palette-basiert

---

### 4. Effekt-Generator ✨

**Perfekt für:** Explosionen, Schilde, VFX

#### Effekt-Typen im Detail

**Explosion** (Standard)
```
Frames: 16
Ablauf:
  Frame 1-3:   Weißer Flash (Impact)
  Frame 4-10:  Expansion (Fireball wächst)
  Frame 11-16: Dissipation (Verblassen)

Farben: Orange → Yellow → White → Black
Intensity: 1-10 (Partikel-Dichte)

Verwendung:
  - Schiffs-Zerstörung
  - Waffen-Impact
  - Explosion-Hazards
```

**Shield Hit** (Schild-Treffer)
```
Frames: 12
Effekt:
  - Hexagon-Grid-Muster
  - Ripple-Welle vom Impact
  - Flash am Einschlagpunkt

Farben: Cyan → White → Blue

Verwendung:
  - Schild nimmt Schaden
  - Energiewaffen-Impact
  - Defensive Feedback
```

**Shield Ambient** (Aktiver Schild)
```
Frames: 8 (Loop)
Effekt:
  - Pulsierender Bubble
  - Subtiles Hexagon-Pattern
  - Sanftes Glühen

Farben: Cyan/Blue

Verwendung:
  - Schiff hat aktiven Schild
  - Kontinuierliche Animation
  - Statusanzeige
```

**Hull Damage** (Hüllen-Schaden)
```
Frames: 16
Effekt:
  - Scorch-Mark (permanent)
  - Funken (Frame 1-8)
  - Rauch (Frame 8-16)

Farben: Orange/Yellow/Black/Gray

Verwendung:
  - Schild down, Hull hit
  - Schaden-Animation
  - Visuelle Feedback
```

**Warp Jump** (FTL-Sprung)
```
Frames: 16
Effekt:
  - Kollabierender Warp-Tunnel
  - Spiralen
  - Zentraler Flash

Farben: Purple/Blue/Cyan/White

Verwendung:
  - FTL-Jump Animation
  - Teleport-Effekt
  - Warp-Gates
```

**Teleport** (Beam-In)
```
Frames: 12
Effekt:
  - Partikel konvergieren
  - Energie-Buildup
  - Materialisierung

Farben: Cyan/Blue/White

Verwendung:
  - Teleport-System
  - Spawn-Animation
  - Materialisierung
```

**EMP Burst** (Elektro-Schock)
```
Frames: 16
Effekt:
  - Elektrische Bögen
  - Expandierender Ring
  - Lightning-Arcs

Farben: Yellow/White/Cyan

Verwendung:
  - EMP-Waffen
  - Electrical Damage
  - Disable-Effekte
```

#### Effekt-Parameter

- **Intensity (1-10):** Partikel-Dichte
  - 1-3 = Wenige Partikel, subtle
  - 4-7 = Moderate Dichte, gut sichtbar
  - 8-10 = Viele Partikel, intensiv

- **Frame Count:** Länge der Animation
  - 8 Frames = Kurz, schnell
  - 12 Frames = Medium
  - 16 Frames = Lang, detailliert

---

### 5. Background-Generator 🌌

**Perfekt für:** Gameplay-Backgrounds, Menüs

#### Background-Typen

**Starfield** (Sternfeld)
```
Features:
  - Gradient Background (Tiefe)
  - Multi-Brightness Stars
  - Realistische Verteilung

Density: 1-10 (Sterne-Anzahl)
Resolution: 1920×1080 / 2560×1440 / 3840×2160

Verwendung:
  - Standard Gameplay-BG
  - Deep Space Szenen
  - Neutrale Backgrounds
```

**Nebula** (Weltraum-Nebel)
```
Features:
  - Perlin Noise Clouds
  - Multi-Color Gradients
  - Sterne obendrauf

Complexity: 1-10 (Detail-Level)
Colors: Custom Palette

Verwendung:
  - Farbenfrohe Szenen
  - Special Locations
  - Menü-Backgrounds
```

**Planet** (Planeten-Ansicht)
```
Features:
  - Spherical Shape
  - Surface Patterns (Noise)
  - Atmospheric Glow
  - Optional Clouds

Complexity: 5+ für Clouds
Colors: Surface + Atmosphere

Verwendung:
  - Orbit Szenen
  - Planet Approaches
  - System Map
```

**Parallax** (Parallax-Layers)
```
Features:
  - 3 Separate Layers
  - Different Scroll Speeds
    - Layer 1: 0.1x (fern)
    - Layer 2: 0.3x (mittel)
    - Layer 3: 0.6x (nah)

Verwendung:
  - Scrolling Backgrounds
  - Depth Effect
  - Dynamic Gameplay
```

#### Auflösungen

| Resolution | Use Case |
|------------|----------|
| 1920×1080 | Full HD, Standard |
| 2560×1440 | 2K, High-End |
| 3840×2160 | 4K, Ultra |

---

## 🎬 Animation-Workflow

### Animiertes Asset erstellen

**Beispiel: Explosion für Schiffs-Zerstörung**

#### Schritt 1: Generator öffnen
```
Wähle: ✨ Effect
```

#### Schritt 2: Settings
```
Type: Explosion
Size: 64×64
Intensity: 7
Frame Count: 16
Palette: Orange/Yellow/White
```

#### Schritt 3: Generate
```
Klick: 🎲 Generate
→ Preview zeigt Animation
```

#### Schritt 4: Export
```
Format: Sprite Sheet
Filename: explosion_medium
Klick: 📥 Export PNG
```

#### Schritt 5: Ergebnis
```
Download:
  - explosion_medium.png (Sprite Sheet 1024×1024)
  - explosion_medium.json (Metadata)
```

### Metadata-Datei Struktur

```json
{
  "frameCount": 16,
  "frameSize": 64,
  "columns": 4,
  "rows": 4,
  "sheetSize": {
    "width": 256,
    "height": 256
  },
  "padding": 0
}
```

### Godot Integration

```gdscript
# 1. Sprite Sheet Resource erstellen
var sprite_frames = SpriteFrames.new()
var texture = preload("res://assets/explosion_medium.png")

# 2. Frames extrahieren (4×4 Grid, 64px pro Frame)
for y in range(4):
    for x in range(4):
        var atlas = AtlasTexture.new()
        atlas.atlas = texture
        atlas.region = Rect2(x * 64, y * 64, 64, 64)
        sprite_frames.add_frame("explode", atlas)

# 3. Animation konfigurieren
sprite_frames.set_animation_speed("explode", 24)  # 24 FPS
sprite_frames.set_animation_loop("explode", false) # Nicht loopen

# 4. AnimatedSprite2D zuweisen
$AnimatedSprite2D.sprite_frames = sprite_frames
$AnimatedSprite2D.play("explode")

# 5. Nach Animation löschen (optional)
await $AnimatedSprite2D.animation_finished
queue_free()
```

---

## 💡 Best Practices

### Schiffe erstellen

**DO ✅:**
- Größe 32×32 oder 64×64 für NPCs
- Complexity 5-7 für gutes Detail
- Vertical Symmetry für Top-Down
- Passende Farbpalette zur Fraktion

**DON'T ❌:**
- Nicht zu klein + zu komplex (16×16 mit Complexity 10)
- Nicht zu groß für einfache NPCs (128×128 für Basic Enemy)
- Nicht asymmetrisch für Standard-Schiffe

### Effekte erstellen

**DO ✅:**
- 16 Frames für Explosionen
- 8-12 Frames für Loop-Effekte
- Intensity an Asset-Größe anpassen
- Export als Sprite Sheet!

**DON'T ❌:**
- Nicht zu viele Frames (>24) → große Datei
- Nicht zu wenig Frames (<8) → ruckelig
- Nicht einzeln exportieren → viele Dateien

### Batch-Production

**Workflow:**
```
1. Settings perfektionieren
2. Preset speichern: "Faction_Ships_Template"
3. Batch Generate: 20 Varianten
4. Beste 10 auswählen
5. Export All
6. In Game importieren
```

---

## 🎯 Projekt-Workflows

### Komplette Fraktion erstellen

**Ziel:** Neue Alien-Fraktion "Zephyr"

#### 1. Farbpalette definieren
```
Palette: "Zephyr Green"
  - Base: #1A4D2E (Dark Green)
  - Mid: #2E7D32 (Green)
  - Bright: #66BB6A (Light Green)
  - Accent: #00FF7F (Neon Green)
```

#### 2. Schiffe generieren
```
Ship Types:
  - Fighter (32×32, Complexity 5)
  - Corvette (64×64, Complexity 6)
  - Frigate (128×128, Complexity 8)
  - Mothership (256×256, Complexity 10)

Settings:
  - Faction: Organic
  - Symmetry: Vertical
  - Palette: Zephyr Green
```

#### 3. Waffen generieren
```
Projectile Types:
  - Primary: Plasma (Green)
  - Secondary: Torpedo (Green)
```

#### 4. Effekte generieren
```
Effects:
  - Explosion (Green-tinted)
  - Shield Hit (Green)
  - Shield Ambient (Green loop)
```

#### 5. Export
```
Batch Export All:
  - faction_zephyr_fighter_001.png
  - faction_zephyr_fighter_002.png
  - ...
  - faction_zephyr_plasma_primary.png (sheet)
  - faction_zephyr_explosion.png (sheet)
  - ...
```

**Ergebnis:** Komplette kohärente Fraktion! ✨

---

## 🔧 Troubleshooting

### Problem: "Asset sieht komisch aus"

**Lösung:**
1. Complexity anpassen (höher/niedriger)
2. Faction-Style ändern
3. Symmetry-Mode variieren
4. Randomize mehrmals drücken
5. Neuen Seed probieren

### Problem: "Export funktioniert nicht"

**Checklist:**
- [ ] Browser erlaubt Downloads?
- [ ] Popup-Blocker deaktiviert?
- [ ] Genug Speicherplatz?
- [ ] Filename ohne Sonderzeichen?

**Lösung:**
```
1. F12 → Konsole öffnen
2. Fehlermeldung lesen
3. Meist: Popup-Blocker oder Browser-Rechte
```

### Problem: "Animation ist ruckelig"

**Ursachen:**
- Zu wenig Frames (<8)
- Falsche FPS in Godot

**Lösung:**
```
1. Mehr Frames generieren (12-16)
2. Godot FPS erhöhen (24-30)
3. Smooth interpolation aktivieren
```

### Problem: "Farben passen nicht"

**Lösung:**
1. Eigene Palette erstellen
2. Farbfelder klicken → Hex eingeben
3. Harmonie-Tool nutzen (extern: coolors.co)
4. Als Preset speichern für später

---

## 📊 Performance-Tipps

### Für große Projekte

**Asset-Größen optimieren:**
```
NPCs/Enemies: 32×32 (Standard)
Player Ship: 64×64 (Detail wichtig)
Bosses: 128×128 (Impressive)
Backgrounds: Nach Auflösung
```

**Frame-Counts:**
```
Loops (Shields): 8 Frames
Explosions: 12-16 Frames
Weapon Fire: 4-6 Frames
```

**Batch-Strategie:**
```
1. Template perfektionieren
2. Batch 20-50 generieren
3. Beste auswählen
4. Rest verwerfen
```

### Export-Optimierung

**PNG Compression:**
- Tool exportiert bereits optimiert
- Bei Bedarf: TinyPNG.com für weitere Kompression
- Transparenz bleibt erhalten!

---

## 🎓 Learning Resources

### Video-Tutorials (Empfohlen)

1. **Lospec Pixel Art Basics** (YouTube)
2. **Godot AnimatedSprite2D Tutorial** (Official Docs)
3. **Space Game Asset Design** (GameDev.tv)

### Externe Tools (Ergänzend)

- **Aseprite:** Manuelles Pixel-Art (Feintuning)
- **Piskel:** Browser Pixel-Editor (Free)
- **Lospec Palette List:** Farbpaletten-Inspiration

### Community

- **r/PixelArt** (Reddit): Feedback & Inspiration
- **Godot Discord:** Integration-Hilfe
- **SpaceGameDev Discord:** Projektspezifisch

---

## 🔗 Integration mit SpaceGameDev

### Asset-Pipeline

```
Generator → Export → Godot Import → Integration

1. Asset generieren
2. PNG exportieren (transparent!)
3. In Godot: res://assets/ships/ kopieren
4. Texture2D Resource erstellen
5. Sprite2D zuweisen
6. Fertig!
```

### Naming Convention

**Folge diesem Schema:**
```
[category]_[faction]_[type]_[variant].[ext]

Beispiele:
  ship_player_explorer_001.png
  ship_npc_pirate_fighter_003.png
  projectile_laser_red_primary.png
  effect_explosion_medium.png
  asteroid_iron_large_002.png
```

### Datei-Organisation

```
res://assets/
  ├── ships/
  │   ├── player/
  │   │   └── ship_player_explorer_001.png
  │   ├── npc/
  │   │   └── ship_npc_pirate_fighter_001.png
  ├── projectiles/
  │   └── projectile_laser_red.png
  ├── effects/
  │   └── effect_explosion_medium.png (sheet)
  └── backgrounds/
      └── bg_nebula_purple_1920.png
```

---

## ✨ Advanced Tips

### Seeded Random nutzen

**Warum?**
- Selber Seed = identisches Asset
- Perfekt für Teamwork
- Reproduzierbare Ergebnisse

**Beispiel:**
```
Seed: "faction_zephyr_fighter"
→ Generiert immer gleiches Schiff
→ Teilen mit Team möglich!
```

### Custom Paletten erstellen

**Workflow:**
1. Inspirationsquelle finden (Screenshot, Artwork)
2. Farben extrahieren (ColorZilla Browser-Plugin)
3. In Generator eingeben
4. Als Preset speichern
5. Für alle Assets der Fraktion nutzen

**Pro-Tip:** 4-6 Farben sind optimal!

### Layer-Technik

**Für Backgrounds:**
```
1. Nebula generieren (1920×1080)
2. Parallax Layer 1 generieren (Stars far)
3. Parallax Layer 2 generieren (Stars mid)
4. Parallax Layer 3 generieren (Stars near)
5. In Godot als ParallaxBackground layern
6. Different scroll speeds setzen
7. → Depth-Effect! 🎨
```

---

## 📝 Changelog

### Version 2.0 (Current)
- ✅ Alle 5 Generatoren implementiert
- ✅ Animation-System (Sprite Sheets)
- ✅ Export-Funktionen
- ✅ Farbpaletten-Manager
- ✅ Preset-System
- ✅ Seeded Random
- ✅ Dokumentation

### Version 1.0 (Initial)
- ✅ Ship Generator (basic)
- ✅ Basic UI
- ✅ PNG Export

---

## 🚀 Roadmap (Planned)

### v2.1 (Planned)
- [ ] Batch-Generation UI (10-100 auf einmal)
- [ ] Referenz-Import (Drag & Drop Vorlage)
- [ ] More Background-Types
- [ ] Palette Import (von Lospec URLs)

### v2.2 (Future)
- [ ] Undo/Redo System
- [ ] Manual Edit Mode
- [ ] More Animation Types
- [ ] AI-Enhanced Generation

---

## 💬 Feedback

**Issues/Bugs:**
GitHub Issues: `SpaceGameDev/issues`

**Feature Requests:**
Discord: `#asset-generator`

**Contributions:**
PRs welcome! 🎉

---

**Happy Generating! 🎨🚀✨**
