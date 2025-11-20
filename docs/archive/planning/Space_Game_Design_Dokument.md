# Space Game - Design Dokument

## Kerninformationen

**Genre:** Weltraum-Simulation / Sandbox / Management  
**Perspektive:** Top-Down Pixelart mit Tiefenelementen  
**Zielplattform:** PC (kommerzieller Verkauf geplant)  
**Entwickler-Erfahrung:** Elektrotechnik, ESP32/Arduino/C/HTML/VBA, keine Game-Dev Erfahrung

## Hauptinspirationen

Eve Online, Factorio, Satisfactory, X3/X4, Anno-Reihe, Dyson Sphere Program, Vanguard Galaxy, Rift Breaker, Shapez, No Man's Sky, Space Engineers

---

## 1. WIRTSCHAFTSSYSTEM

### Produktionskreislauf
- **Alle Items produzierbar, handelbar, kaufbar**
- Rohstoffgewinnung â†’ Veredelung â†’ Weiterverarbeitung (mehrstufig)
- NPC-Produktion & Spieler-Produktion gleichwertig
- Items nur verfÃ¼gbar wenn produziert (keine Magic-Spawns)
- Event-Items & Spezial-Items durch Quests oder komplexe Verfahren (Wahrscheinlichkeiten)

### Warenwirtschaft
- Warenwirtschaftskreislauf zwischen allen Akteuren
- Geldkreislaufsystem mit Inflation/Deflation
- Preisbildung durch Angebot/Nachfrage
- Handelsrouten zwischen Stationen/Systemen

---

## 2. MODULSYSTEM

### ModulgrÃ¶ÃŸen
- Schiffsmodule: Sehr Klein â†’ Klein â†’ Mittel â†’ GroÃŸ â†’ Sehr GroÃŸ
- Stationsmodule: Klein â†’ Mittel â†’ GroÃŸ â†’ Gigantisch

### QualitÃ¤tsstufen (Farbsystem)
| Stufe | Farbe | Beschreibung |
|-------|-------|--------------|
| Normal | WeiÃŸ/Grau | Basisstufe |
| Bronze | Bronze | Verbessert |
| Gelb | Gelb | Fortgeschritten |
| Blau | Blau | Selten |
| GrÃ¼n | GrÃ¼n | Erweitert |
| Silber | Silber | Hochwertig |
| Gold | Gold | Elite |
| Purpur | Purpur | LegendÃ¤r |

### Sockelsystem
- **Farbe 1:** QualitÃ¤tsstufe (Stats)
- **Farbe 2:** Spezialisierung (Sockelanzahl/Boni)
- HÃ¶here Stufen = mehr Sockel ODER bessere Stats
- Verbesserungen einsetzbar in Sockel
- Verbesserungen haben eigene QualitÃ¤tsstufen
- HÃ¶here QualitÃ¤t = teurer in Herstellung & Preis

### Modultypen
- Antriebe
- Schilde
- Waffen
- Scanner
- Extramodule
- Sondermodule
- Fabrikmodule
- Raffinerie-Module
- Lagermodule

---

## 3. PRODUKTIONSSYSTEM

### Mikromanagement â†’ Automatisierung
- Start: Manuelles Management aller Prozesse
- Fortschritt: Teilautomatisierung durch PC-Auto-Modus (mit Malus)
- Endgame: Vollautomatisierung durch Schiffs-AI & Personal

### Fabriklayouts
- Innerhalb Stationen: Eigene Automatisierung erstellbar
- Input/Output-Management
- Produktionsketten: Erstellung â†’ Raffinerie â†’ Veredelung â†’ Abfallmanagement
- Mehrere Layouts pro Station (begrenzt durch StationsgrÃ¶ÃŸe)
- Fabrikmodule verbesserbar (QualitÃ¤t + Sockel)
- Spezialfabriken fÃ¼r besondere Prozesse

### Stationsverbindungen
- Warentransport zwischen Stationen via:
  - Drohnen
  - Schiffe
  - Pipes (Rohrleitungen)
- Automatisierte Lieferketten aufbaubar

### BauplÃ¤ne
- Alle Produktionen benÃ¶tigen BauplÃ¤ne
- BauplÃ¤ne mÃ¼ssen: Erforscht / Gekauft / Gefunden werden
- Bauplanforschung eigene Rolle
- Bauplanverteilung/Handel mÃ¶glich

---

## 4. ROLLEN & SKILLSYSTEM

### Hauptrollen (zu entwickeln)

**Mining & Rohstoffgewinnung:**
- Mining Single (Solo-Bergbau)
- Mining Operator (mehrere Schiffe)
- Mining Flottenkommandant (groÃŸe Flotten)

**Produktion & Industrie:**
- Produzent (Basis-Herstellung)
- Industrieller (Massenproduktion)
- Spezial-Forschungsproduzent
- Bauplanforschung & Verteilung
- Prozessverteiler
- Refinery-Spezialist
- Wiederherstellung (Recycling)

**Bau & Konstruktion:**
- Stationsbau
- Bauoperator (Koordination)

**Logistik & Handel:**
- Logistiker
- VerkÃ¤ufer
- EinkÃ¤ufer
- Transport-Manager

**Drohnenmanagement:**
- Produktion
- Verteidigung
- Angriff
- Logistik
- Mining

**Kampf & MilitÃ¤r:**
- Flottenangriff
- Kommandant Angriff
- Geheimoperationen Angriff
- Bomber
- Flottenmanager
- Sektorwachen

**UnterstÃ¼tzung:**
- Scouting
- Reparatur
- Energieverwaltung
- Scanner-Spezialist

**Skillsystem:** Muss komplett entwickelt werden (Progression, Spezialisierungen, Synergien)

---

## 5. SCHIFFSSYSTEM

### Schiffsdesign
- **Feste Rahmen:** HÃ¼llen mit vordefinierten Slot-Typen
- **Individuelle Anpassung:** Module frei wÃ¤hlbar innerhalb der Slots
- Slot-Typen: Antrieb / Schild / Angriff / Extramodule / Sondermodule / Scanner

### SchiffshÃ¼llen
- **Ziel:** Ãœber 150 verschiedene HÃ¼llen
- Jede HÃ¼lle mit eigenen Boni & Buffs
- Rollenspezifische Spezialisierungen
- Unterschiedliche GrÃ¶ÃŸenklassen

### Schiffsproduktion
- Alle Schiffe mÃ¼ssen produziert werden
- Ressourcenintensiv
- BauplÃ¤ne erforderlich

### Schiffs-AI & Automatisierung
- Schiffe kaufbar und mit Aufgaben versehbar:
  - Handel
  - Transport
  - Verteidigung
  - Angriff
  - Sektorwachen
  - Scouting
  - Mining
  - Logistik
- Personal-Management nÃ¶tig
- Kosten: Unterhalt + Gehalt
- **Korruptionssystem:** Ohne Vertrauen korrupiertes Personal mÃ¶glich

---

## 6. KAMPFSYSTEM

### Waffenarten
- Explosiv
- Energie
- Strahlenwaffen
- Impulswaffen
- Antimaterie
- Raketen
- Bombenwerferer

### Waffenmechaniken
- Tracking-System
- Reichweite
- Durchschlagskraft
- Spezialeffekte

---

## 7. GESELLSCHAFTSSYSTEME

### Fraktionssystem
- Verschiedene Fraktionen mit eigenen Zielen
- Reputationssystem
- Fraktionskriege mÃ¶glich

### Weitere Systeme
- **Bounty-System:** Kopfgelder auf Spieler/NPCs
- **Privatleute-System:** Einzelpersonen als Wirtschaftsfaktoren
- **Gesellschafts-System:** Unternehmen/Allianzen
- **Religions-System:** Glaubensrichtungen im Universum
- **Fanatismus-System:** Extreme Gruppierungen

---

## 8. UNIVERSUM & WELTRAUM

### Universum-Aufbau
- Riesiges Universum mit vielen Systemen
- Systeme enthalten:
  - Planeten (bewohnbar/unbewohnbar)
  - Monde
  - Gasriesen
  - Asteroidenfelder (basierend auf realer Weltraumforschung)
  - Erloschene Sterne
  - Sonderbare Sterne
  - Schwarze LÃ¶cher
  - Besondere kosmische PhÃ¤nomene

### Navigation
- System-zu-System Flug
- Out-of-Sector (OoS): Systeme simuliert ohne SpielerprÃ¤senz
- In-Sector (IoS): Spieler aktiv im System
- Interaktion per Terminal:
  - Karte
  - Produktionsterminal
  - Ãœbersichten
  - Flottenmanagement

### Netzwerksystem
- DatenÃ¼bertragungsnetzwerk fÃ¼r alle Infos
- Spieler muss Netzwerk ausbauen
- InformationsverzÃ¶gerung bei groÃŸen Distanzen mÃ¶glich
- Kommunikationsinfrastruktur zwischen Stationen

---

## 9. STATIONSBAU

### StationsgrÃ¶ÃŸen
- Klein
- Mittel
- GroÃŸ
- Gigantisch

### Ressourcenbedarf
- Exponentieller Anstieg mit GrÃ¶ÃŸe
- Gigantische Mengen fÃ¼r groÃŸe Stationen
- Langfristige Bauprojekte

### Stationsfunktionen
- Produktion
- Raffinerie
- Lagerung
- Handel
- Forschung
- Werften
- Wohnen (Personal)

---

## 10. SPIELPHILOSOPHIE

### Freiheit
- Spieler hat freie Wahl was er tut
- Jederzeit Umorientierung mÃ¶glich
- Im Verlauf werden aber alle Rollen relevant

### KomplexitÃ¤t & Tiefe
- Vielschichtige Mechaniken
- Lernen durch Spielen
- Von einfach zu komplex
- Mikromanagement â†’ Automatisierung

### Langzeitmotivation
- Keine Endgame-Grenze
- StÃ¤ndige Optimierung mÃ¶glich
- PvE und PvP-Elemente
- Wirtschaftliche Dominanz als Ziel
- Territoriale Expansion

---

## 11. TECHNISCHE ANFORDERUNGEN

### Grafikstil
- Pixelart Top-Down
- Tiefenelemente fÃ¼r KomplexitÃ¤t
- Performance-freundlich fÃ¼r groÃŸe Systeme

### Performance-Ãœberlegungen
- OoS-Simulation: Vereinfacht
- IoS-Rendering: Detailliert
- GroÃŸe Mengen an Objekten (Schiffe, Drohnen, Stationen)
- Wirtschafts-Simulation im Hintergrund

---

## 12. ENTWICKLUNGSPRIORITÃ„TEN

*Wird im separaten Entwicklungsplan definiert*

### Kern-Features (Phase 1)
- Basis-Bewegung & Controls
- Einfaches Schiffssystem
- Basis-Mining
- Basis-Produktion

### Erweiterungen (Phase 2+)
- Komplexe Wirtschaft
- AI-Systeme
- Fraktionen
- Universum-Generation

---

## OFFENE FRAGEN FÃœR ENTWICKLUNG

1. **Singleplayer oder Multiplayer?** (Oder beides?)
2. **Persistente Welt oder Sessions?**
3. **Prozedural generiertes Universum oder handcrafted?**
4. **Echtzeit oder pausierbar?**
5. **Zielgruppenalter & KomplexitÃ¤t?** (Casual bis Hardcore?)
6. **Monetarisierung:** Einmalkauf / DLC / Keine?
7. **Early Access geplant?**
8. **Entwicklungszeit-Budget:** Monate? Jahre?
9. **Solo-Entwicklung oder Team spÃ¤ter?**
10. **Erste Release-Zielplattform:** Steam / Itch.io / Eigene Website?
