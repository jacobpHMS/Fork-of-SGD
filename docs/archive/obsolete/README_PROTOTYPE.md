# Space Mining Game - Godot Prototype

## 🚀 Status: Playable Prototype v0.1

Ein funktionsfähiger Godot 4.3 Prototyp mit grundlegenden Space-Mining-Mechaniken.

---

## ✅ Implementierte Features

### 1. **Schiffssteuerung**
- ✅ Mausklick-Steuerung (Rechtsklick)
- ✅ Realistische Space-Physik mit Trägheit
- ✅ Wenig Drift (95% Momentum-Erhaltung)
- ✅ Rotation zum Ziel
- ✅ Beschleunigung und Geschwindigkeitslimit

### 2. **Mining-System**
- ✅ 2 Miner-Slots
- ✅ Button-Aktivierung (Taste 1 & 2 oder UI)
- ✅ Automatische Zielerfassung (nächstes Ore in Reichweite)
- ✅ Mining-Laser-Visualisierung (Line2D, Grün)
- ✅ Mining-Rate: 10 Einheiten/Sekunde pro Miner

### 3. **Inventar-System**
- ✅ Cargo Hold: 500 m³ Kapazität
- ✅ Ores stapelbar (unbegrenzt stapelbar)
- ✅ Kapazitätsgrenze
- ✅ Echtzeit UI-Anzeige

### 4. **Ore-System**
- ✅ 5 zufällige Ores spawnen
- ✅ 192 Ore-Typen aus ORE_REFINERY_MATRIX.tsv
- ✅ Verschiedene Qualitäten (Q0-Q5)
- ✅ Dynamische Labels mit Namen und Menge
- ✅ Ores verschwinden wenn abgebaut

### 5. **UI-System**
- ✅ Rechte Tactical Overview (EVE-Style)
- ✅ Objekt-Liste mit Distanzanzeige
- ✅ Filter-Buttons (All/Ships/Ores/Stations/Enemies)
- ✅ Detail-Ansicht bei Auswahl
- ✅ Cargo Hold UI (unten)
- ✅ Miner-Control-Panel
- ✅ Sci-Fi Blau/Grün Farbschema

### 6. **Kamera-System**
- ✅ Folgt dem Spielerschiff
- ✅ Freier Zoom (Mausrad)
- ✅ Zoom-Range: 0.2x - 2.0x

### 7. **Datenbank-System**
- ✅ OreDatabase Singleton
- ✅ JSON-Import aus ORE_REFINERY_MATRIX
- ✅ 192 Ore-Einträge mit Materialien/Gasen/Waste

---

## 🎮 Steuerung

| Aktion | Taste/Maus |
|--------|-----------|
| Schiff bewegen | **Rechtsklick** auf Zielposition |
| Miner 1 aktivieren | **Taste 1** oder UI-Button |
| Miner 2 aktivieren | **Taste 2** oder UI-Button |
| Zoom In | **Mausrad hoch** |
| Zoom Out | **Mausrad runter** |
| Objekt auswählen | Klick in Tactical Overview |

---

## 📁 Projektstruktur

```
SpaceGameDev/
├── project.godot              # Godot-Projektkonfiguration
├── scenes/
│   ├── Main.tscn             # Hauptszene
│   ├── Player.tscn           # Spielerschiff
│   └── Ore.tscn              # Ore-Objekte
├── scripts/
│   ├── Main.gd               # Hauptlogik, Spawning, UI
│   ├── Player.gd             # Schiffssteuerung, Mining, Inventar
│   ├── Ore.gd                # Ore-Logik
│   └── OreDatabase.gd        # Singleton: Ore-Daten-Management
├── assets/
│   ├── Test_Spaceship.png    # Spielerschiff
│   ├── test_ore_Item.png     # Ore-Sprite
│   └── space_hintergrund.png # Hintergrund
├── data/
│   └── ore_database.json     # 192 Ore-Typen aus Matrix
└── docs/                      # Design-Dokumente
```

---

## 🔧 Technische Details

### Physik-Parameter (Testdaten)
```gdscript
{
  "mass": 50000.0,           # 50 Tonnen
  "max_thrust": 100000.0,    # 100 kN
  "turn_speed": 90.0,        # 90°/s
  "max_speed": 200.0,        # 200 m/s
  "cargo_capacity": 500.0,   # 500 m³
  "miner_range": 150.0,      # 150 pixel
  "miner_rate": 10.0         # 10 units/s
}
```

### Drift-Mechanik
- **Drift Factor:** 0.95 (5% Geschwindigkeitsverlust/Frame)
- **Bewegungsgefühl:** Wenig Drift, gute Kontrolle

---

## 🚧 Nächste Schritte

### Phase 2 - Erweiterungen
- [ ] Stations-System
- [ ] Ore-Verkauf/Handel
- [ ] Schiffs-Upgrades
- [ ] Weitere Schiffs-Typen
- [ ] NPC-Schiffe
- [ ] Refinerie-System

### Phase 3 - Content
- [ ] Mehrere Systeme/Sektoren
- [ ] Produktionsketten
- [ ] Fraktionen
- [ ] Missions-System

---

## 📊 Datenbanken

### Ore-Datenbank
- **Datei:** `data/ore_database.json`
- **Einträge:** 192
- **Quelle:** ORE_REFINERY_MATRIX_COMPLETE.tsv
- **Enthält:**
  - Ore-IDs (ORE_T1_001 - ORE_T5_032)
  - Ore-Namen (Ferralite, Metalite, etc.)
  - Qualitäts-Tiers (Q0-Q5)
  - Raffinerie-Outputs (Materialien, Gase, Waste)

---

## 🎨 Assets

### Vorhanden
- ✅ Test_Spaceship.png (45 KB)
- ✅ test_ore_Item.png (9 KB)
- ✅ Space-Hintergründe (mehrere)

### Benötigt für Phase 2
- [ ] Station-Sprites
- [ ] Weitere Schiff-Sprites
- [ ] UI-Icons
- [ ] Waffen-Effekte
- [ ] Explosionen

---

## 🛠️ Entwicklung

### Godot Version
- **Engine:** Godot 4.3
- **Rendering:** GL Compatibility
- **2D Physics:** Gravity = 0 (Space!)

### Wie starten?
1. Godot 4.3 installieren
2. Projekt öffnen: `project.godot`
3. Main-Szene ausführen (F5)
4. Spaß haben! 🚀

---

## 📝 Notizen

### Werte-Anpassung
Alle Schiffs-Werte sind **Testdaten** und können später über:
- Datenbank-Dateien (JSON)
- Resource-Files (.tres)
- External Configs

angepasst werden.

### Pixel/Meter/KM Verhältnis
- **Aktuell:** 1:1 (1 Pixel = 1 Meter)
- **TODO:** Verhältnis festlegen nach ersten Tests

### Performance
- **Ore-Spawning:** Aktuell 5, skalierbar
- **UI-Updates:** Jedes Frame (optimierbar mit Timer)

---

## 🐛 Bekannte Bugs/TODOs

- [ ] Laser-Offset bei Miner 2 optimieren
- [ ] UI-Scaling bei verschiedenen Auflösungen testen
- [ ] Ore-Label-Größe bei Zoom anpassen
- [ ] Mining-Range-Indikator hinzufügen

---

## 📜 Lizenz

Siehe Haupt-README.md für Lizenzinformationen.

---

**Version:** 0.1.0
**Datum:** 2025-11-13
**Status:** ✅ Funktionsfähiger Prototyp
