# 🐛 Known Bugs & Issues

> **Letzte Aktualisierung:** 2025-11-15
> **Version:** v0.2

## 🔴 Kritisch

*Keine kritischen Bugs bekannt*

---

## 🟡 Hoch

*Keine Bugs mit hoher Priorität bekannt*

---

## 🟢 Mittel

*Keine Bugs mit mittlerer Priorität bekannt*

---

## 🔵 Niedrig / Kosmetisch

*Keine kleinen Bugs bekannt*

---

## ✅ Kürzlich Behoben (v0.2)

### Navigation & Controls
- ✅ **Doppelklick-Navigation funktionierte nicht**
  - **Problem:** Schiff bewegte sich nicht per Doppelklick zum Zielpunkt
  - **Ursache:** UI-Blocking Logik hat auch Controls mit `MOUSE_FILTER_IGNORE` blockiert
  - **Fix:** `Player.gd:711` - Prüft jetzt `mouse_filter` korrekt
  - **Commit:** `f28c2eb`
  - **Behoben:** 2025-11-15

- ✅ **Radialmenü öffnete sich nicht per Rechtsklick**
  - **Problem:** Radialmenü reagierte nicht auf Rechtsklick
  - **Ursache:** UI-Blocking + falsche `mouse_filter` Einstellung in Scene
  - **Fix:** `RadialMenu.tscn` - `mouse_filter` auf `0` (MOUSE_FILTER_STOP) gesetzt
  - **Commit:** `f28c2eb`
  - **Behoben:** 2025-11-15

- ✅ **Radialmenü schloss sich nicht automatisch**
  - **Problem:** Menu blieb offen beim Klick außerhalb
  - **Fix:** `RadialMenu.gd` - Auto-Close bei Klick außerhalb der Buttons
  - **Commit:** `f28c2eb`
  - **Behoben:** 2025-11-15

### Mining System
- ✅ **Mining Progress Bars zeigten nicht korrekt an**
  - **Fix:** Progress Bars zeigen jetzt Mining Cycle korrekt an
  - **Commit:** `ebe7ed9`
  - **Behoben:** 2025-11-14

### Parser/Syntax Errors
- ✅ **Parser Errors in OptionsMenu.gd und Player.gd**
  - **Fix:** Alle Syntax-Fehler behoben
  - **Commit:** `100e765`
  - **Behoben:** 2025-11-14

- ✅ **Localization.tr() Konflikt mit Godot**
  - **Problem:** `tr()` ist eine Godot Built-in Funktion
  - **Fix:** Umbenannt zu `translate()`
  - **Commit:** `840ab2a`
  - **Behoben:** 2025-11-14

---

## 📝 Bug Report Template

Um einen neuen Bug zu melden, erstelle ein [GitHub Issue](https://github.com/jacobpHMS/SpaceGameDev/issues/new?template=bug_report.md) mit dem Bug Report Template.

**Oder füge ihn direkt hier ein:**

```markdown
### [BUG] Titel des Bugs

**Priorität:** 🔴 Kritisch / 🟡 Hoch / 🟢 Mittel / 🔵 Niedrig

**Beschreibung:**
[Kurze Beschreibung des Problems]

**Reproduktion:**
1. [Schritt 1]
2. [Schritt 2]
3. [Siehe Fehler]

**Erwartet:** [Was sollte passieren]
**Aktuell:** [Was tatsächlich passiert]

**System:** [OS, Godot Version, Game Version]

**Commit/Branch:** [z.B. main, commit abc123]
```

---

## 🔍 Testing Checklist

Teste diese Features vor jedem Release:

- [ ] **Navigation**
  - [ ] Doppelklick-Navigation funktioniert
  - [ ] Autopilot fliegt korrekt zum Ziel
  - [ ] Schiff stoppt beim Ziel

- [ ] **Radialmenü**
  - [ ] Öffnet sich per Rechtsklick
  - [ ] Schließt sich beim Klick außerhalb
  - [ ] Alle 12 Befehle funktionieren
  - [ ] Orbit-Untermenü funktioniert

- [ ] **Mining**
  - [ ] Miner starten/stoppen korrekt
  - [ ] Progress Bars zeigen Fortschritt
  - [ ] Erz wird korrekt abgebaut
  - [ ] Cargo wird korrekt gefüllt

- [ ] **Cargo System**
  - [ ] Verschiedene Cargo Holds funktionieren
  - [ ] Eject funktioniert
  - [ ] Transfer zwischen Schiffen funktioniert
  - [ ] Cargo Crates spawnen korrekt

- [ ] **UI/UX**
  - [ ] Freie Kamera (F-Taste) funktioniert
  - [ ] WASD Bewegung in freier Kamera
  - [ ] Alle UI Windows sind draggable
  - [ ] Object List filtert korrekt

- [ ] **Save/Load**
  - [ ] Spiel speichern funktioniert
  - [ ] Spiel laden funktioniert
  - [ ] Multiple Save Slots funktionieren

- [ ] **Localization**
  - [ ] Sprache wechseln (EN/DE) funktioniert
  - [ ] Alle UI Texte sind übersetzt

---

## 📊 Bug Statistik

**Gesamt bekannte Bugs:** 0
**Kritisch:** 0
**Hoch:** 0
**Mittel:** 0
**Niedrig:** 0

**In v0.2 behoben:** 7
**Bug-freie Tage:** 0

---

*Diese Datei wird automatisch aktualisiert. Bei neuen Bugs bitte GitHub Issue erstellen oder direkt hier eintragen.*
