# Changelog v0.2 - Autopilot & UI Update

## 🚀 Neue Features

### 1. Autopilot-System
- **Doppelklick-Steuerung:** Linke Maustaste doppelt klicken zum Fliegen
- **Intelligentes Navigations-System:**
  - Automatische Rotation zum Ziel (kürzeste Richtung!)
  - Beschleunigungsphase
  - Automatisches Abbremsen am Ziel
  - Stoppt präzise am Zielpunkt
- **Zustandsmaschine:** IDLE → ACCELERATING → DECELERATING → ARRIVED

### 2. Radialmenü (Rechtsklick)
- **12 Optionen** im Kreis angeordnet
- **Implementiert:**
  - "Fly To" - Fliege zu Position
  - "Mine Ore" - Auto-Mining Befehl
  - "Hold Position" - Position halten
  - "Stop" - Sofort stoppen
  - "Cancel" - Menü schließen
- **Mining-Befehl:** Fliegt zum Ore und startet automatisch beide Miner!

### 3. Schiffs-Status-UI
Neues Panel links unten zeigt:
- **Speed:** Echtzeit-Geschwindigkeit in m/s
- **Shield:** Schildstärke (1000)
- **Armor:** Panzerung (500)
- **Hull Integrity:** Rumpfintegrität (100%)
- **Electronics:** Elektronische Stabilität (100%)
- **Fuel:** Treibstoff (1000/1000)
- **Status:** Autopilot-Zustand (Idle/Accelerating/Mining/etc.)

### 4. Verbessertes Kollisionssystem
- **Abprallen** statt hartes Blockieren
- **Energieverlust** bei Kollision (60% Geschwindigkeit bleibt)
- Objekte **driften aneinander vorbei**

---

## 🐛 Bug Fixes

### Rotations-Bug behoben
- **Problem:** Schiff rotierte nur in eine Richtung ab bestimmtem Winkel
- **Fix:** Verwendung von `wrapf()` für kürzesten Rotationsweg
- **Resultat:** Schiff dreht sich jetzt immer in die kürzeste Richtung

### Unendliches Fliegen behoben
- **Problem:** Schiff flog unendlich weiter ohne zu stoppen
- **Fix:** Autopilot-System mit Deceleration-Phase
- **Resultat:** Schiff bremst automatisch ab und stoppt am Ziel

---

## 🎮 Geänderte Steuerung

| Alt (v0.1) | Neu (v0.2) |
|------------|------------|
| Rechtsklick zum Bewegen | **Doppelklick (Links)** zum Bewegen |
| Keine Radialmenü | **Rechtsklick** für Radialmenü |
| Manuelles Mining starten | **Radialmenü → "Mine Ore"** für Auto-Mining |

---

## 📊 Technische Änderungen

### Player.gd
- Neues `AutopilotState` Enum
- Doppelklick-Detection (0.3s Fenster)
- Autopilot State Machine
- Deceleration Distance Calculation
- Bounce-Collision System
- Ship Status UI Update

### Neue Dateien
- `scripts/RadialMenu.gd` - Radialmenü-Logik
- `scenes/RadialMenu.tscn` - Radialmenü-Szene
- `CONTROLS.md` - Vollständige Steuerungsdoku

### UI Updates
- `Main.tscn`: ShipStatus Panel hinzugefügt
- `Main.tscn`: RadialMenu eingebunden
- `Player.tscn`: "player" Gruppe hinzugefügt
- `Main.tscn`: "ore_container" Gruppe hinzugefügt

---

## 🎯 Was funktioniert jetzt

### Bewegung
✅ Doppelklick-Flug mit Autopilot
✅ Automatisches Abbremsen
✅ Rotation immer kürzeste Richtung
✅ Kollisions-Abprallen

### Mining
✅ Manuelles Mining (Taste 1 & 2)
✅ Auto-Mining via Radialmenü
✅ Automatische Miner-Aktivierung bei Auto-Mining
✅ Mining stoppt wenn Ore leer

### UI
✅ Echtzeit Schiffs-Status
✅ Autopilot-Status-Anzeige
✅ Tactical Overview (wie vorher)
✅ Cargo Hold Display

---

## 📝 Bekannte Einschränkungen

- Radialmenü: Nur 5 von 12 Optionen implementiert
- Schiffs-Animation: Noch nicht genutzt (Sprite-Sheet vorhanden)
- Fuel-Verbrauch: Noch nicht implementiert (wird angezeigt aber nicht verbraucht)
- Schaden-System: Noch nicht implementiert (Shield/Armor/Hull statisch)

---

## 🔜 Nächste Schritte (v0.3)

- [ ] Schiffs-Animation (Sprite-Sheet mit mehreren Frames)
- [ ] Fuel-Verbrauch beim Fliegen
- [ ] Schaden-System (Shield/Armor/Hull)
- [ ] Weitere Radialmenü-Optionen
- [ ] Station zum Verkaufen von Ores
- [ ] Pixel/Meter/KM Verhältnis festlegen

---

**Version:** 0.2.0
**Datum:** 2025-11-13
**Branch:** claude/add-missing-assets-011CV5zHZvB7ECmR4Vjd6GXH
**Kompatibilität:** Godot 4.3
