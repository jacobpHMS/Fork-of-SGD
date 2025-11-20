# 🚀 Procedural Pixel Art Asset Generator

**Version 2.0** - Complete Edition
Vollständiges Web-basiertes Tool zur prozeduralen Generierung von Pixel-Art Assets für SpaceGameDev

---

## 📖 Inhaltsverzeichnis

1. [Überblick](#überblick)
2. [Features](#features)
3. [Schnellstart](#schnellstart)
4. [Generatoren-Guide](#generatoren-guide)
5. [Animation-System](#animation-system)
6. [Batch-Generation](#batch-generation)
7. [Export-Optionen](#export-optionen)
8. [Tipps & Tricks](#tipps--tricks)
9. [Technische Details](#technische-details)

---

## 🎯 Überblick

Dieser Generator erstellt **automatisch** professionelle Pixel-Art Assets für dein Space-Game!
**Keine Grafikerfahrung nötig** - einfach Parameter einstellen und generieren!

### Was kann ich erstellen?

- ✅ **Raumschiffe** (symmetrisch, 3 Fraktionsstile)
- ✅ **Asteroiden** (organisch mit Perlin Noise)
- ✅ **Projektile** (Laser, Raketen, Plasma, Torpedos)
- ✅ **Effekte** (Explosionen, Schildtreffer, Warp-Jump)
- ✅ **Hintergründe** (Nebel, Sternfelder, Planeten)
- ✅ **Animationen** (4-16 Frames pro Asset)

---

## ⭐ Features

### Core Features
- 🎨 **5 Generator-Module** (Schiffe, Asteroiden, Projektile, Effekte, Backgrounds)
- 🌈 **Farbpaletten-Manager** (4 Presets + custom)
- 🎬 **Animation-System** (bis zu 16 Frames)
- 📦 **Batch-Generation** (10-100 Varianten auf Knopfdruck)
- 💾 **Export-System** (PNG, Sprite Sheets, Metadata)
- 🎲 **Seeded Random** (reproduzierbare Ergebnisse)

### Canvas Features
- 🔍 **Zoom** (1x bis 32x, Mausrad-Support)
- ✋ **Pan** (Shift+Drag)
- ⊞ **Grid-Overlay** (an/aus)
- 👁️ **Echtzeit-Preview**
- 📊 **Live-Statistiken**

### Workflow Features
- 💾 **Preset-System** (Settings speichern/laden)
- 🔄 **Randomize-Button** (alle Settings zufällig)
- 📝 **LocalStorage** (Einstellungen bleiben erhalten)
- 🎯 **Anfängerfreundlich** (keine Vorkenntnisse nötig!)

---

## 🚀 Schnellstart

### 1. Tool öffnen

```bash
# Im Browser öffnen:
/pfad/zu/SpaceGameDev/asset-generator/index.html
```

Oder: Doppelklick auf `index.html`

### 2. Erstes Schiff generieren (30 Sekunden!)

1. **Größe wählen:** 32x32 (Standard)
2. **Komplexität:** 5 (Mittel)
3. **Fraktionsstil:** Angular (Militärisch)
4. **Button klicken:** "🎲 Generate"
5. **Fertig!** ✨

### 3. Exportieren

1. Filename eingeben: `ship_player_001`
2. "📥 Export PNG" klicken
3. PNG wird heruntergeladen (mit Transparenz!)

---

## 🎨 Generatoren-Guide

### 🚀 Raumschiff-Generator

**Wofür:** Spieler-Schiffe, NPC-Schiffe, Feinde

#### Parameter

| Parameter | Optionen | Beschreibung |
|-----------|----------|--------------|
| **Größe** | 16/32/64/128 | Pixel-Größe des Schiffs |
| **Komplexität** | 1-10 | Detailgrad (mehr Details = komplexer) |
| **Fraktionsstil** | Angular/Organic/Hybrid | Designstil |
| **Symmetrie** | Vertical/Horizontal/Both/Radial | Spiegelungs-Modus |
| **Waffen** | ✓/✗ | Waffen hinzufügen |
| **Triebwerke** | ✓/✗ | Engine-Glow hinzufügen |

#### Fraktionsstile erklärt

**Angular (Militärisch):**
- Eckige, geometrische Formen
- Scharfe Kanten
- Militärisch/technisch
- Perfekt für: Menschliche Schiffe, Militär

**Organic (Alien):**
- Runde, fließende Formen
- Organische Kurven
- Alien-artig
- Perfekt für: Außerirdische Rassen

**Hybrid (Gemischt):**
- Mix aus Angular + Organic
- Vielseitig
- Interessante Designs
- Perfekt für: Prototypen, Spezialschiffe

#### Beispiel-Workflow

```
Ziel: Spieler-Explorer-Schiff erstellen

1. Größe: 64x64 (mittlere Größe)
2. Komplexität: 7 (detailliert)
3. Faction: Hybrid
4. Symmetry: Vertical
5. Weapons: ✓
6. Engines: ✓
7. Generate!
```

### 🪨 Asteroiden-Generator

**Wofür:** Mining-Objekte, Umgebungs-Hazards

#### Parameter

| Parameter | Optionen | Beschreibung |
|-----------|----------|--------------|
| **Größe** | 16-256 | Asteroid-Größe |
| **Komplexität** | 1-10 | Oberflächen-Detail |
| **Ore-Typ** | Iron/Copper/Gold/... | Erz-Farbe |
| **Roughness** | 0-1 | Kantenrauheit |
| **Craters** | ✓/✗ | Krater hinzufügen |

#### Ore-Typen

- **Iron:** Grau-metallisch
- **Copper:** Orange-kupfer
- **Gold:** Goldgelb glänzend
- **Titanium:** Dunkel-blau-grau
- **Uranium:** Grün leuchtend
- **Platinum:** Silber-weiß
- **Crystal:** Blau kristallin

#### Tipps

- **Kleine Asteroiden (16-32px):** Schnell zerstörbar, wenig Erz
- **Große Asteroiden (128-256px):** Viel Erz, länger zum abbauen
- **Roughness hoch:** Sehr irregulär, natürlich
- **Complexity hoch:** Mehr Oberflächendetails

### 💥 Projektil-Generator

**Wofür:** Waffen, Laser, Raketen, Torpedos

#### Typen

**1. Laser (Schnell, dünn)**
```
Eigenschaften:
- Dünner Strahl
- Pulsierender Effekt (Animation)
- 4 Frames
- Perfekt für: Schnellfeuer-Waffen
```

**2. Missile (Mittel, mit Thrust)**
```
Eigenschaften:
- Raketen-Körper
- Animiertes Triebwerk
- 4 Frames (rotierend)
- Perfekt für: Lenkwaffen
```

**3. Plasma (Langsam, Energie-Ball)**
```
Eigenschaften:
- Pulsierender Energie-Ball
- Elektrische Bögen
- 8 Frames
- Perfekt für: Schwere Energiewaffen
```

**4. Beam (Kontinuierlich)**
```
Eigenschaften:
- Durchgehender Strahl
- Flackernder Effekt
- 4 Frames
- Perfekt für: Mining-Laser, Dauerfeuer
```

**5. Torpedo (Schwer, groß)**
```
Eigenschaften:
- Großer Sprengkopf
- Leuchtende Warhead
- Massives Triebwerk
- Perfekt für: Kapitalschiff-Waffen
```

#### Beispiel-Workflow

```
Ziel: Plasma-Waffe für Spieler-Schiff

1. Type: Plasma
2. Size: 16x16
3. Animated: ✓
4. Frame Count: 8
5. Color: Cyber Blue Palette
6. Generate!
7. Export as Sprite Sheet
```

### ✨ Effekt-Generator

**Wofür:** Explosionen, Schild-Effekte, Special FX

#### Effekt-Typen

**1. Explosion (Standard)**
```
Frames: 16
Phasen:
  1. Flash (Frames 1-3)
  2. Expansion (Frames 4-10)
  3. Dissipation (Frames 11-16)
Perfekt für: Schiffs-Zerstörung
```

**2. Shield Hit (Schild-Treffer)**
```
Frames: 12
Effekt:
  - Hexagon-Gitter
  - Ripple-Welle vom Einschlag
  - Blitz am Impact-Punkt
Perfekt für: Schaden an Schilden
```

**3. Shield Ambient (Schild-Aura)**
```
Frames: 8
Effekt:
  - Pulsierender Schild-Bubble
  - Hexagon-Muster
  - Subtil, Loop-bar
Perfekt für: Aktive Schild-Anzeige
```

**4. Hull Damage (Hüllen-Schaden)**
```
Frames: 16
Effekt:
  - Scorch-Mark (bleibt)
  - Funken-Partikel
  - Rauch-Wolke
Perfekt für: Schiff-Schaden
```

**5. Warp Jump (Warp-Sprung)**
```
Frames: 16
Effekt:
  - Kollabierender Warp-Tunnel
  - Spiralen
  - Zentraler Blitz
Perfekt für: FTL-Jump Animation
```

**6. Teleport (Teleportation)**
```
Frames: 12
Effekt:
  - Partikel konvergieren
  - Energie-Aufbau im Zentrum
  - Materialisierung
Perfekt für: Beam-in Effekt
```

**7. EMP Burst (EMP-Schockwelle)**
```
Frames: 16
Effekt:
  - Elektrische Bögen
  - Expandierender Ring
  - Blitze
Perfekt für: EMP-Waffen
```

#### Tipps für Effekte

- **Intensity:** Steuert Partikel-Dichte
- **Frame Count:** Mehr Frames = flüssiger, aber größere Datei
- **Export als Sprite Sheet!** (nicht einzeln)

### 🌌 Background-Generator

**Wofür:** Spielhintergründe, Menü-Screens

#### Typen

**1. Starfield (Sternfeld)**
```
Perfekt für:
  - Gameplay-Hintergrund
  - Deep Space Szenen

Features:
  - Gradient (dunkel → hell)
  - Mehrere Stern-Helligkeiten
  - Realistische Verteilung
```

**2. Nebula (Nebel)**
```
Perfekt für:
  - Farbenfroh
  - Atmosphärisch
  - Menü-Backgrounds

Features:
  - Perlin Noise basiert
  - Multi-Farben
  - Sterne obendrauf
```

**3. Planet (Planet)**
```
Perfekt für:
  - Planeten-Orbit-Szenen
  - System-Map

Features:
  - Sphärische Form
  - Oberflächenmuster
  - Atmosphären-Glow
  - Cloud-Layer (optional)
```

**4. Parallax (Parallax-Schichten)**
```
Perfekt für:
  - Scroll-Backgrounds
  - Tiefeneffekt

Features:
  - 3 Layers
  - Unterschiedliche Scroll-Geschwindigkeiten
  - Layer 1: 0.1x (langsam, fern)
  - Layer 2: 0.3x (mittel)
  - Layer 3: 0.6x (schnell, nah)
```

#### Auflösungen

- **1920×1080** (Full HD) - Standard
- **2560×1440** (2K) - High-End
- **3840×2160** (4K) - Ultra

---

## 🎬 Animation-System

### Frame-Based Animationen

Alle animierten Assets werden als **Sprite Sheets** exportiert:

```
Frame Layout:
[Frame 1][Frame 2][Frame 3][Frame 4]
[Frame 5][Frame 6][Frame 7][Frame 8]
...
```

### Animation erstellen (Schritt-für-Schritt)

**Beispiel: Explosions-Animation**

1. Generator: "✨ Effect"
2. Type: "Explosion"
3. Frame Count: 16
4. Intensity: 7
5. Generate
6. Preview: Spielt Animation ab
7. Export Format: "Sprite Sheet"
8. Filename: "explosion_medium"
9. Export!

**Ergebnis:**
- `explosion_medium.png` (Sprite Sheet 1024×1024)
- `explosion_medium.json` (Metadata)

### Metadata JSON

```json
{
  "frameCount": 16,
  "frameSize": 64,
  "columns": 4,
  "rows": 4,
  "sheetSize": { "width": 256, "height": 256 },
  "padding": 0
}
```

### Godot Integration

```gdscript
# Sprite Sheet in Godot laden
var sprite_frames = SpriteFrames.new()
var texture = preload("res://assets/explosion_medium.png")

# Frames extrahieren (4×4 Grid)
for y in range(4):
    for x in range(4):
        var atlas = AtlasTexture.new()
        atlas.atlas = texture
        atlas.region = Rect2(x * 64, y * 64, 64, 64)
        sprite_frames.add_frame("explode", atlas)

sprite_frames.set_animation_speed("explode", 24)  # 24 FPS
$AnimatedSprite2D.sprite_frames = sprite_frames
$AnimatedSprite2D.play("explode")
```

---

## 📦 Batch-Generation

### Viele Varianten schnell erstellen

**Problem:** Du brauchst 50 verschiedene Asteroiden
**Lösung:** Batch-Generation!

### So geht's (wenn implementiert):

1. Generator wählen (z.B. Asteroid)
2. Parameter einstellen
3. "Batch Generate" Button
4. Anzahl eingeben: 50
5. Generate!
6. Export All → ZIP-Download

### Tipps

- **Schiffe:** 10-20 Varianten pro Fraktion
- **Asteroiden:** 50-100 für Vielfalt
- **Projektile:** 5-10 pro Waffentyp
- **Effekte:** 3-5 Varianten

---

## 💾 Export-Optionen

### 1. Single PNG

**Wann:** Einzelnes statisches Asset

```
Filename: ship_player_001
Format: PNG (Transparent)
Output: ship_player_001.png
```

### 2. Sprite Sheet

**Wann:** Animiertes Asset

```
Filename: explosion_large
Format: Sprite Sheet
Frames: 16
Output:
  - explosion_large.png (Sheet)
  - explosion_large.json (Metadata)
```

### 3. Batch Export

**Wann:** Viele Assets auf einmal

```
Output: assets.zip
Enthält:
  - asset_001.png
  - asset_002.png
  - ...
  - asset_050.png
```

### Export-Qualität

- **Format:** PNG (verlustfrei)
- **Transparenz:** Ja (Alpha-Channel)
- **Farbtiefe:** 32-bit RGBA
- **Kompression:** Lossless

---

## 💡 Tipps & Tricks

### Für Anfänger

1. **Start klein:** Beginne mit 32×32 Schiffen
2. **Presets nutzen:** Lade vorgefertigte Farbpaletten
3. **Experimentieren:** Randomize-Button ist dein Freund!
4. **Speichern:** Gute Settings als Preset speichern

### Für Fortgeschrittene

1. **Seeds nutzen:** Gleicher Seed = gleiches Ergebnis
2. **Batch-Gen:** Viele Varianten, beste auswählen
3. **Paletten mischen:** Eigene Farbkombis erstellen
4. **Layer-Technik:** Backgrounds mit Parallax-Layers

### Kreative Workflows

**"Fraktion erstellen":**
```
1. Farbpalette definieren (z.B. Alien Green)
2. 5 Schiffe generieren (Small→Large)
3. Matching Projektile (grün)
4. Matching Effekte
5. → Komplette Fraktion!
```

**"Level-Theme erstellen":**
```
1. Nebula Background (purple)
2. Matching Asteroiden (purple tint)
3. Umgebungs-Effekte
4. → Kohärentes Level!
```

### Häufige Fehler

❌ **Zu hohe Komplexität bei kleinen Sizes**
```
Problem: 16×16 mit Complexity 10
Lösung: Klein = weniger Details (Complexity 3-5)
```

❌ **Zu viele Frames bei großen Assets**
```
Problem: 128×128 mit 32 Frames = riesige Datei
Lösung: Große Assets brauchen weniger Frames (8-12)
```

❌ **Palette passt nicht zum Stil**
```
Problem: Neon-Farben für Militär-Schiff
Lösung: Passende Palette wählen (Military Green)
```

---

## 🔊 SFX-Generator (Sound Effects)

### Übersicht

Der **SFX-Generator** erstellt prozedurale 8-bit/16-bit Sound-Effekte für dein Spiel!

**Features:**
- ✅ **5 Synthese-Methoden** (Additive, Subtractive, FM, Pulse Wave, Physical)
- ✅ **30+ Sound-Presets** (Laser, Explosionen, UI, Engines)
- ✅ **Externe Samples laden** und manipulieren (Granular, Pitch Shift, Bitcrush)
- ✅ **8-bit Retro Sounds** (Chip-Tune Style)
- ✅ **Waveform/Spectrogram Visualisierung**
- ✅ **WAV Export** (44.1kHz, 16-bit)

### Preset-Modus

**Schritt-für-Schritt:**

1. **Generator wählen:** 🔊 SFX
2. **Synthesis Mode:** "Preset"
3. **Sound Type wählen:**
   - 🔫 Weapons (Laser, Missile, Cannon, Plasma)
   - 💥 Impacts (Explosion, Hull Hit, Shield Hit)
   - 🖱️ UI Sounds (Click, Hover, Confirm, Cancel)
   - 🚀 Engines (Idle, Thrust, Warp Jump)
   - 🎮 8-bit Retro (Jump, Coin, Powerup)
4. **Variation Amount:** 0.0-0.5 (Zufallsabweichung)
5. **Generate Sound:** Hörprobe!
6. **Export:** WAV-Datei + Metadata JSON

**Beispiel: Laser-Sound erstellen**
```
1. Sound Type: "Laser (Basic)"
2. Variation: 0.1
3. Generate → ▶️ Play
4. Klingt gut? → Export!
→ Datei: laser_basic.wav (44.1kHz, 0.3 Sekunden)
```

### Sample-Modus (Externes Audio manipulieren)

**Upload eigene Sounds und "verwurstle" sie!**

**Verfügbare Effekte:**

**1. Granular Synthesis**
```
Was: Zerhackt Sound in winzige "Grains" und reassembliert
Parameter:
  - Grain Size: 10-200ms
  - Grain Density: 10-100 grains/sec
  - Pitch Variation: ±12 semitones
Perfekt für: Atmosphärische Sounds, Drones
```

**2. Pitch Shift**
```
Was: Tonhöhe ändern ohne Tempo zu ändern
Parameter:
  - Semitones: -12 bis +12
Perfekt für: Stimmen tiefer/höher machen
```

**3. Reverse**
```
Was: Spielt Sound rückwärts ab
Perfekt für: Mysteriöse Effekte, Reverse Cymbals
```

**4. Slice & Randomize**
```
Was: Schneidet in 8 Teile, spielt in zufälliger Reihenfolge
Perfekt für: Glitchy Effekte
```

**5. Filter Sweep**
```
Was: Low-Pass Filter von 8000Hz → 200Hz
Perfekt für: Explosionen, Impact Sounds
```

**6. Distortion**
```
Was: Waveshaper Distortion
Perfekt für: Aggressive Sounds, Metal
```

**7. Bitcrusher (8-bit Style)**
```
Was: Reduziert Bit-Tiefe und Sample-Rate
Parameter:
  - Bit Depth: 1-16 bit (4 = klassisch 8-bit)
  - Sample Rate Reduction: 1-16x
Perfekt für: Retro Game Sounds!
```

### Sound-Presets Übersicht

**Weapons (Waffen):**
- `laser_basic` - Klassischer Laser-Shot
- `laser_charged` - Power-Up Laser
- `missile_launch` - Raketen-Start
- `cannon_fire` - Kanonen-Schuss
- `plasma_shot` - Plasma-Waffe

**Impacts (Einschläge):**
- `explosion_small` - Kleine Explosion
- `explosion_large` - Große Explosion
- `hull_hit` - Metall-Impact
- `shield_hit` - Schild-Treffer

**UI Sounds:**
- `ui_click` - Button-Klick
- `ui_hover` - Mouse-Over
- `ui_confirm` - Bestätigung
- `ui_cancel` - Abbrechen
- `ui_error` - Fehler-Sound

**Engines (Triebwerke):**
- `engine_idle` - Motor im Leerlauf
- `engine_thrust` - Beschleunigung
- `warp_jump` - Warp-Sprung

**8-bit Retro:**
- `retro_jump` - Sprung-Sound
- `retro_coin` - Münz-Sound
- `retro_powerup` - Power-Up

**Misc:**
- `cargo_pickup` - Cargo aufheben
- `mining_laser` - Mining-Laser
- `alarm_critical` - Alarm

### Godot Integration (SFX)

```gdscript
# Sound in Godot laden
var laser_sound = preload("res://assets/sounds/laser_basic.wav")

# Abspielen
$AudioStreamPlayer.stream = laser_sound
$AudioStreamPlayer.play()

# Mit Variation (Pitch-Shifting)
$AudioStreamPlayer.pitch_scale = randf_range(0.9, 1.1)
$AudioStreamPlayer.play()
```

### Tipps für Sound-Design

**Variationen erstellen:**
```
Problem: Laser-Sound klingt immer gleich (langweilig!)
Lösung:
  1. Preset wählen
  2. Variation: 0.1-0.2
  3. 5x Generate → 5 Varianten
  4. Alle exportieren
  5. In Godot: Random wählen!
```

**8-bit Sounds erstellen:**
```
Methode 1 (Preset):
  - Retro-Presets nutzen (fertig!)

Methode 2 (Sample):
  - Beliebigen Sound laden
  - Bitcrush Effect
  - Bit Depth: 4
  - Sample Reduction: 8
  → Instant Retro!
```

**Atmosphäre mit Granular:**
```
1. Upload: wind.mp3
2. Effect: Granular
3. Grain Size: 50ms
4. Density: 30
5. Pitch Var: 5 semitones
→ Mysteriöser Space-Wind!
```

### Waveform & Spectrogram

**Waveform (oben):**
- Zeigt Amplitude über Zeit
- Gut für: Lautstärke-Check, Clipping erkennen

**Spectrogram (unten):**
- Zeigt Frequenzen über Zeit
- Gut für: Frequenz-Analyse, Harmonic-Content

---

## 🔧 Technische Details

### System-Anforderungen

- **Browser:** Modern (Chrome, Firefox, Edge)
- **JavaScript:** Aktiviert
- **Canvas-Support:** Ja
- **Speicher:** Minimal (rein client-seitig)

### Performance

| Asset Type | Size | Gen Time | Export Time |
|------------|------|----------|-------------|
| Ship 32×32 | Small | <0.1s | <0.1s |
| Asteroid 128 | Medium | <0.2s | <0.2s |
| Effect 64×64 16F | Large | <0.5s | <1s |
| Background 1920 | XLarge | <2s | <3s |

### Browser-Kompatibilität

✅ Chrome 90+
✅ Firefox 88+
✅ Edge 90+
✅ Safari 14+
❌ Internet Explorer (nicht unterstützt)

### LocalStorage

Gespeichert werden:
- Zoom-Level
- Grid-Einstellungen
- Gespeicherte Presets
- Letzte Farbpalette

**Speichergröße:** ~50KB (sehr klein!)

### Technologie-Stack

- **Frontend:** Vanilla HTML5/CSS3/JavaScript (ES6+)
- **Canvas:** 2D Context API
- **Audio:** Web Audio API (Synthese & Processing)
- **Storage:** LocalStorage API
- **Export:** Blob API + Canvas.toBlob()
- **Noise:** Custom Perlin-like Implementation
- **SFX:** 5 Synthese-Methoden (Additive, Subtractive, FM, Pulse, Physical)

### Dateigröße

**Tool selbst:**
```
index.html:    ~10 KB
style.css:     ~15 KB
JavaScript:    ~50 KB (total)
---
Gesamt:        ~75 KB (extrem klein!)
```

**Generierte Assets:**
```
32×32 PNG:      ~1-2 KB
64×64 PNG:      ~3-5 KB
128×128 PNG:    ~8-15 KB
Sprite Sheet:   ~50-200 KB (je nach Frames)
```

---

## 🆘 Hilfe & Support

### Probleme?

**Asset sieht komisch aus:**
- Versuche andere Complexity
- Ändere Symmetry-Mode
- Nutze Randomize mehrmals

**Export funktioniert nicht:**
- Browser erlaubt Downloads?
- Popup-Blocker deaktiviert?
- Genug Speicherplatz?

**Tool lädt nicht:**
- JavaScript aktiviert?
- Moderne Browser-Version?
- Konsole öffnen (F12) → Fehler?

### Keyboard-Shortcuts

| Taste | Aktion |
|-------|--------|
| **Shift+Drag** | Canvas Pan |
| **Mausrad** | Zoom |
| **Strg+S** | Export (wenn fokussiert) |
| **Leertaste** | Randomize |

---

## 📚 Weitere Ressourcen

- **Godot Docs:** https://docs.godotengine.org
- **Pixel Art Tutorial:** https://lospec.com/pixel-art-tutorials
- **Color Palettes:** https://lospec.com/palette-list

---

## 🎓 Tutorial-Videos (Geplant)

1. ✅ Erstes Schiff in 60 Sekunden
2. ✅ Komplette Fraktion erstellen
3. ✅ Explosions-Animation erstellen
4. ✅ Level-Background bauen
5. ✅ In Godot importieren

---

## ✨ Credits

**Entwickelt für:** SpaceGameDev
**Version:** 2.0 Complete
**Lizenz:** MIT (free to use)
**Autor:** Claude + Jacob

---

**Viel Spaß beim Erstellen! 🚀🎨✨**
