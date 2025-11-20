# Steuerung - Space Mining Game

## 🎮 Neue Steuerung (v0.2)

### Grundlegende Bewegung

| Aktion | Steuerung |
|--------|-----------|
| **Zum Punkt fliegen** | **Doppelklick (Links)** auf Zielposition |
| **Radialmenü öffnen** | **Rechtsklick** |
| **Zoom** | **Mausrad** (hoch/runter) |

### Autopilot-System ✨ NEU!

Das Schiff nutzt jetzt ein intelligentes Autopilot-System:

1. **Doppelklick** auf eine Position
2. Das Schiff:
   - Rotiert automatisch zum Ziel (kürzester Weg!)
   - Beschleunigt in Richtung Ziel
   - Bremst automatisch ab wenn nah am Ziel
   - Stoppt am Zielpunkt

**Keine manuelle Steuerung mehr nötig!** Der Autopilot macht alles.

### Radialmenü (Rechtsklick) ✨ NEU!

Rechtsklick öffnet ein Radialmenü mit 12 Optionen:

| Option | Funktion |
|--------|----------|
| **Fly To** | Fliegt zur Cursor-Position |
| **Mine Ore** | Fliegt zum nächsten Ore und startet Mining automatisch |
| **Hold Position** | Hält aktuelle Position |
| **Stop** | Stoppt alle Bewegung sofort |
| **Scan** | (Noch nicht implementiert) |
| **Target** | (Noch nicht implementiert) |
| **Autopilot** | (Noch nicht implementiert) |
| **Defensive** | (Noch nicht implementiert) |
| **Aggressive** | (Noch nicht implementiert) |
| **Pickup** | (Noch nicht implementiert) |
| **Cancel** | Schließt das Menü |

### Mining

| Aktion | Steuerung |
|--------|-----------|
| **Miner 1 aktivieren** | **Taste 1** |
| **Miner 2 aktivieren** | **Taste 2** |
| **Auto-Mining** | Rechtsklick → **"Mine Ore"** |

**Auto-Mining Modus:**
- Fliegt automatisch zum gewählten Ore
- Aktiviert automatisch beide Miner
- Stoppt Mining wenn Ore abgebaut ist

### Kamera

| Aktion | Steuerung |
|--------|-----------|
| **Zoom In** | **Mausrad hoch** |
| **Zoom Out** | **Mausrad runter** |
| **Kamera folgt Schiff** | Automatisch |

---

## 📊 UI-Elemente

### Links Unten: SHIP STATUS ✨ NEU!
Zeigt alle wichtigen Schiffswerte:
- **Speed:** Aktuelle Geschwindigkeit in m/s
- **Shield:** Schildstärke
- **Armor:** Panzerung
- **Hull:** Rumpfintegrität in %
- **Electronics:** Elektronische Stabilität in %
- **Fuel:** Treibstoff (aktuell / max)
- **Status:** Aktueller Autopilot-Status

### Unten Mitte: CARGO HOLD
- Zeigt genutzten/verfügbaren Frachtraum
- Miner-Buttons (1 & 2)

### Rechts: TACTICAL OVERVIEW
- Liste aller sichtbaren Objekte
- Filter-Buttons (All/Ships/Ores/Stations/Enemies)
- Distanzanzeige zu Objekten
- Detail-Ansicht bei Auswahl

---

## 🚀 Physik-System

### Autopilot-Phasen:
1. **IDLE** - Schiff wartet auf Befehle
2. **ACCELERATING** - Schiff beschleunigt zum Ziel
3. **DECELERATING** - Schiff bremst ab
4. **ARRIVED** - Schiff am Ziel angekommen

### Kollisionssystem ✨ NEU!
- Schiffe **prallen ab** bei Kollisionen
- Kein hartes Blockieren mehr
- Energie-Verlust beim Aufprall (60% Geschwindigkeit bleibt)
- Objekte driften aneinander vorbei

---

## 🔧 Tastenkürzel

| Taste | Funktion |
|-------|----------|
| **1** | Miner 1 an/aus |
| **2** | Miner 2 an/aus |
| **Mausrad ↑** | Zoom in |
| **Mausrad ↓** | Zoom out |
| **Doppelklick** | Zu Position fliegen |
| **Rechtsklick** | Radialmenü |

---

## 💡 Tipps

### Effizientes Mining:
1. **Rechtsklick** auf Ore
2. Wähle **"Mine Ore"**
3. Schiff fliegt automatisch hin und startet Mining
4. Beide Miner aktivieren sich automatisch!

### Navigation:
- **Doppelklick** für schnelle Bewegung
- **Radialmenü** für präzise Befehle
- Autopilot stoppt automatisch am Ziel

### Übersicht behalten:
- Nutze die **Tactical Overview** rechts
- Filter nach Objekttypen
- Klicke Objekte an für Details

---

**Version:** 0.2.0
**Status:** Autopilot-System aktiv
**Neu:** Doppelklick-Steuerung, Radialmenü, Schiffs-Status-UI, Auto-Mining, Kollisions-Abprallen
