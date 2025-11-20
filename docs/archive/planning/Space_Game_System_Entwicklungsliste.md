# Space Game - System-Entwicklungsliste

## ÜBERSICHT: ZU ENTWICKELNDE SYSTEME

**Status:** Planungsphase  
**Datum:** November 2025  
**Zweck:** Detaillierte Ausarbeitung in separaten Chat-Sessions

---

## 📋 HAUPT-SYSTEME ÜBERSICHT

| # | System | Umfang | Priorität | Abhängigkeiten | Status |
|---|--------|--------|-----------|----------------|--------|
| 1 | Ore-System | 20 Erze + Gehaltsstufen | 🔴 Hoch | Keine | ⬜ Offen |
| 2 | Refinery-Ressourcen | 45+ Veredelungsprodukte | 🔴 Hoch | Ore-System | ⬜ Offen |
| 3 | Treibstoff & Liquids | 20 Flüssigkeitstypen | 🟠 Mittel | Refinery | ⬜ Offen |
| 4 | Komponenten & Produkte | Produktionsketten-Items | 🔴 Hoch | Refinery | ⬜ Offen |
| 5 | Naming Convention | Alle Item/Objekt-Namen | 🟡 Niedrig | Alle Systeme | ⬜ Offen |
| 6 | Munitionssystem | Munitionsarten & Typen | 🟠 Mittel | Waffensystem | ⬜ Offen |
| 7 | LOD-System | Zoom/Sprite-Management | 🔴 Hoch | Sprite-Größen | ⬜ Offen |
| 8 | Schiffssystem | Schiffs-Mechaniken & Slots | 🔴 Hoch | Modul-System | ⬜ Offen |
| 9 | Schiffsgrößen-System | 7 Größenklassen (32-4096px) | 🔴 Hoch | Sprite-System | ⬜ Offen |
| 10 | Waffensystem | 10 Haupt-Typen + Varianten | 🟠 Mittel | Munition, Schiffe | ⬜ Offen |
| 11 | Verteidigungs-System | Armor, Schild, Repair | 🟠 Mittel | Schiffssystem | ⬜ Offen |
| 12 | Energie-System | Power-Management (kein Cap) | 🟠 Mittel | Schiffssystem | ⬜ Offen |
| 13 | Spielbereich-Größen | IoS-Zonen mit km-System | 🔴 Hoch | Zoom, LOD | ⬜ Offen |

---

## 🎯 DETAILLIERTE SYSTEM-BESCHREIBUNGEN

### 1. ORE-SYSTEM (Roherze)

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Anzahl Erze** | 20 verschiedene Ore-Typen | Welche? Namen? |
| **Gehaltsstufen** | Mehrere Qualitäten pro Erz | Wie viele Stufen? Multiplikatoren? |
| **Verteilung** | Verschiedene Regionen | Welche Erze wo? |
| **Abbau-Mechanik** | Mining-Yield-Formeln | Basis-Werte? |
| **Verwendung** | In welchen Recipes? | Produktionsketten? |

**Zu erarbeiten:**
- Liste aller 20 Erze mit Eigenschaften
- Gehaltsstufen-Tabelle (z.B. 0%, 5%, 10%, 25%, 50%)
- Spawn-Regeln pro Erz-Typ
- Basis-Werte (Volumen, Masse, Preis)

---

### 2. REFINERY-RESSOURCEN SYSTEM

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Anzahl Produkte** | 45+ Raffinerie-Outputs | Welche konkret? |
| **Veredelungsstufen** | Ore → Rohstoff → Material | Wie viele Stufen? |
| **Recipes** | Welches Ore gibt was? | Verhältnisse? |
| **Nebenprodukte** | Abfall? Beiprodukte? | Nutzung? |
| **Spezial-Raffinerien** | Besondere Prozesse | Welche? |

**Zu erarbeiten:**
- Vollständige Raffinerie-Produktliste
- Rezept-Matrix (Input → Output)
- Veredelungszeiten
- Abfallmanagement-System

---

### 3. TREIBSTOFF & LIQUIDS SYSTEM

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Treibstoff-Typen** | ~10 verschiedene | Welche? Unterschiede? |
| **Liquids/Gase** | ~10 weitere Flüssigkeiten | Industriegase? Kühlmittel? |
| **Verwendung** | Antriebe, Produktion, Module | Wo genau? |
| **Lagerung** | Spezial-Tanks? | Container-Typen? |
| **Produktion** | Herstellung aus? | Recipes? |

**Zu erarbeiten:**
- Liste aller 20 Flüssigkeitstypen
- Verwendungszwecke pro Typ
- Produktionsrezepte
- Lager- und Transport-Mechaniken

---

### 4. KOMPONENTEN & PRODUKTE SYSTEM

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Basis-Komponenten** | Schrauben, Platten, Chips | Wie viele? Namen? |
| **Zwischen-Produkte** | Schaltkreise, Bauteile | Komplexität? |
| **End-Produkte** | Module, Schiffe, Stationen | Vollständige Liste? |
| **Produktionsketten** | Mehrstufige Ketten | Wie tief? |
| **Bauplan-System** | Forschung/Erwerb | Mechanik? |

**Zu erarbeiten:**
- Vollständige Item-Hierarchie
- Produktionsketten-Diagramme
- Komplexitäts-Stufen
- Bauplan-Freischalt-System

---

### 5. NAMING CONVENTION (Namensgebung)

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Schiffsnamen** | Keine Eve-Klone | Naming-Schema? |
| **Fraktionen** | Eigene Identitäten | Wie viele? Kultur? |
| **Ressourcen** | Sci-Fi aber unique | Phantasienamen vs. real? |
| **Orte/Systeme** | Stern-/Planeten-Namen | Generierungs-Regeln? |
| **Module/Waffen** | Technische Bezeichnungen | Namens-Konventionen? |

**Zu erarbeiten:**
- Naming-Guidelines für alle Kategorien
- Fraktions-Identitäten und Sprach-Themen
- Generator-Regeln für prozedurale Namen
- Überprüfung auf Plagiate

---

### 6. MUNITIONSSYSTEM

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Munitionsarten** | Projektile, Raketen, Ladungen | Wie viele Haupt-Typen? |
| **Varianten** | Tech-Level, Spezialisierung | Pro Waffentyp? |
| **Eigenschaften** | Schaden, Reichweite, Speed | Basis-Stats? |
| **Produktion** | Herstellung, Ressourcen | Recipes? |
| **Lagerung** | Cargo vs. Munitions-Bay | Mechanik? |

**Zu erarbeiten:**
- Munitions-Typen-Matrix
- Schadens-Typen (Kinetisch, Energie, etc.)
- Produktionsrezepte
- Balancing-Tabellen

---

### 7. LOD-SYSTEM (Level of Detail)

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Zoom-Stufen** | 7 Level definiert | Genaue Schwellenwerte? |
| **Sprite-Verhalten** | Wann Icons, wann Sprites | LOD-Regeln? |
| **Performance** | Culling, Deaktivierung | Distanz-Limits? |
| **UI-Integration** | Tactical List, Labels | Wann was sichtbar? |
| **Übergangs-Animation** | Smooth Fading? | Optional? |

**Zu erarbeiten:**
- Exakte Zoom-Schwellenwerte-Tabelle
- Sprite↔Icon Übergangsregeln
- Performance-Culling-System
- UI-Visibility-Matrix

---

### 8. SCHIFFSSYSTEM

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Hüllen-Typen** | 150+ verschiedene | Kategorisierung? |
| **Slot-System** | High/Mid/Low/Rig/Subsystem | Anzahl pro Schiff? |
| **Boni-System** | Rollen-Boni pro Hülle | Wie berechnen? |
| **Fitting-Requirements** | CPU, Power Grid, Cargo | Formeln? |
| **Schiffs-AI** | Automatisierung | Befehls-System? |

**Zu erarbeiten:**
- Schiffs-Kategorien & Rollen
- Slot-Layout-Templates
- Boni-Berechnungsformeln
- AI-Befehls-Interface

---

### 9. SCHIFFSGRÖSSEN-SYSTEM

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Größenklassen** | 7 Klassen (32px-4096px) | Genaue Zuordnung? |
| **Sprite-Pipeline** | Master-Sprites, Downscale | Workflow? |
| **Kollisions-Größen** | Hitboxen pro Klasse | Formeln? |
| **Manövrierraum** | Sicherheitsabstände | Multiplikatoren? |
| **Asset-Organisation** | Ordnerstruktur | Naming? |

**Zu erarbeiten:**
- Größenklassen-Matrix (Pixel, Rolle, Masse)
- Asset-Creation-Pipeline
- Kollisions-Skalierungs-Regeln
- Organisations-Schema

---

### 10. WAFFENSYSTEM

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Haupt-Typen** | 10 Waffen-Kategorien | Welche konkret? |
| **Varianten** | Tech-Level, Spezialisierung | Pro Typ? |
| **Mechaniken** | Tracking, Reichweite, DPS | Formeln? |
| **Optimal/Falloff** | Distanz-Damage-Kurven | Wie berechnen? |
| **Größen** | Small/Medium/Large/XL | Zuordnung? |

**Zu erarbeiten:**
- Waffen-Typen-Liste mit Eigenschaften
- Damage-Berechnungsformeln
- Tracking-Mechanik-System
- Balancing-Matrix

**Waffen-Kategorien-Vorschlag:**
1. Projektil-Waffen (Kinetisch)
2. Energie-Waffen (Laser/Beam)
3. Raketen (Missiles)
4. Torpedos (Capital-Missiles)
5. Strahlen-Waffen (Pulse/Particle)
6. Plasma-Waffen
7. Antimaterie-Waffen
8. Drohnen (Weapon-Kategorie)
9. Bomber (Spezialisiert)
10. Spezial-Waffen (EMP, Webber, etc.)

---

### 11. VERTEIDIGUNGS-SYSTEM

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Armor-System** | Schichten, Resistenzen | Wie komplex? |
| **Schild-System** | Regeneration, HP, Recharge | Mechanik? |
| **Repair-Mechaniken** | Selbst, Remote, Station | Arten? |
| **Schadens-Typen** | Kinetisch, Thermisch, EM, etc. | Wie viele? |
| **Resistenzen** | Prozentuale Reduktion | Formeln? |

**Zu erarbeiten:**
- Armor-Schichten-Konzept
- Schild-Regenerations-Formeln
- Repair-Modul-Typen
- Schadens-Resistenz-Matrix
- Damage-Application-Formel

---

### 12. ENERGIE-SYSTEM

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **Power-Generation** | Reaktoren, Output | Wie berechnen? |
| **Power-Verbrauch** | Module, Waffen | Pro Item? |
| **Kein Cap-System** | Wie stattdessen? | Alternatives Konzept? |
| **Überlastung** | Was passiert bei Overload? | Penalties? |
| **Effizienz** | Skills/Boni | Multiplikatoren? |

**Zu erarbeiten:**
- Alternatives Energie-Konzept (nicht Eve Cap)
- Power-Grid-Balancing
- Reaktor-Typen und -Größen
- Überlast-Mechaniken
- Energie-Effizienz-System

---

### 13. SPIELBEREICH-GRÖSSENSYSTEM

| Aspekt | Details | Zu klären |
|--------|---------|-----------|
| **IoS-Zone-Größen** | Klein bis Sektor | km-Maße? |
| **km-Konversionssystem** | Pixel ↔ km | Formel? |
| **Zoom-Integration** | LOD mit Größen | Anpassungen? |
| **Feldtypen** | Asteroiden, Nebel, Leer | Kategorien? |
| **Navigation** | Distanz-Anzeigen | In km oder px? |

**Zu erarbeiten:**
- Pixel-zu-km-Konversionstabelle
- IoS-Zonen-Größen-Matrix
- Feldtyp-Definitionen
- Navigations-UI-System
- Distanz-Berechnungen

---

## 🔗 ABHÄNGIGKEITS-MATRIX

| System | Benötigt | Wird benötigt von |
|--------|----------|-------------------|
| **Ore** | - | Refinery, Komponenten |
| **Refinery** | Ore | Treibstoff, Komponenten |
| **Treibstoff** | Refinery | Schiffe, Energie |
| **Komponenten** | Refinery | Schiffe, Module, Stationen |
| **Munition** | Komponenten, Refinery | Waffen |
| **Waffen** | Munition, Größen | Schiffe, Kampf |
| **Schiffe** | Komponenten, Größen | Alle Gameplay-Systeme |
| **Größen** | Sprites, LOD | Schiffe, Stationen |
| **LOD** | Größen, Zoom | Rendering |
| **Verteidigung** | Schiffe | Kampf-System |
| **Energie** | Schiffe | Module, Waffen |
| **Spielbereich** | LOD, Größen | Universum |

---

## 📊 ENTWICKLUNGS-PRIORITÄTEN

### PHASE 1 - GRUNDLAGEN (Monate 0-6)
- ✅ Sprite-Größensystem definiert
- ✅ LOD-Konzept erstellt
- ⬜ Ore-System ausarbeiten
- ⬜ Refinery-System ausarbeiten
- ⬜ Komponenten-Basis erstellen

### PHASE 2 - KERN-MECHANIKEN (Monate 6-12)
- ⬜ Schiffssystem vollständig
- ⬜ Waffensystem implementiert
- ⬜ Verteidigungs-System
- ⬜ Energie-System
- ⬜ Munitions-System

### PHASE 3 - CONTENT (Monate 12-18)
- ⬜ Treibstoff/Liquids-System
- ⬜ Naming Convention durchführen
- ⬜ Spielbereich-Größen finalisieren
- ⬜ Alle 150+ Schiffe designen

### PHASE 4 - POLISH (Monate 18-24+)
- ⬜ Balancing aller Systeme
- ⬜ Performance-Optimierung
- ⬜ Content-Explosion

---

## 📝 NÄCHSTE SCHRITTE

### SOFORT (Diese Woche):
1. Chat für **Ore-System** erstellen
2. Chat für **Refinery-Ressourcen** erstellen

### KURZFRISTIG (Nächste 2 Wochen):
3. Chat für **Schiffssystem** Details
4. Chat für **LOD-System** Implementierung

### MITTELFRISTIG (Nächster Monat):
5. Chat für **Waffensystem** Ausarbeitung
6. Chat für **Verteidigungs-System**
7. Chat für **Energie-System**

### LANGFRISTIG:
- Naming Convention (wenn alle Systeme definiert)
- Spielbereich-Größen (wenn LOD fertig)

---

## 🎯 VORGEHENSWEISE PRO CHAT-SESSION

Für jedes System separate Chat-Session mit folgendem Aufbau:

1. **Definition:** Was ist das System genau?
2. **Umfang:** Wie viele Items/Mechaniken?
3. **Formeln:** Berechnungen, Balancing
4. **Daten-Struktur:** JSON-Format, Tabellen
5. **Integration:** Wie interagiert es mit anderen Systemen?
6. **Namensgebung:** Konkrete Namen für Items
7. **Werte:** Alle numerischen Daten

**Output pro System:**
- Vollständige Tabellen
- JSON-Templates
- Formel-Sammlungen
- Balancing-Sheets
- Integrations-Diagramme

---

## ✅ FORTSCHRITT-TRACKING

| System | Chat erstellt | Ausgearbeitet | Dokumentiert | In Projekt-Docs |
|--------|--------------|---------------|--------------|-----------------|
| Ore-System | ⬜ | ⬜ | ⬜ | ⬜ |
| Refinery | ⬜ | ⬜ | ⬜ | ⬜ |
| Treibstoff | ⬜ | ⬜ | ⬜ | ⬜ |
| Komponenten | ⬜ | ⬜ | ⬜ | ⬜ |
| Naming | ⬜ | ⬜ | ⬜ | ⬜ |
| Munition | ⬜ | ⬜ | ⬜ | ⬜ |
| LOD | ⬜ | ⬜ | ⬜ | ⬜ |
| Schiffe | ⬜ | ⬜ | ⬜ | ⬜ |
| Größen | ⬜ | ⬜ | ⬜ | ⬜ |
| Waffen | ⬜ | ⬜ | ⬜ | ⬜ |
| Verteidigung | ⬜ | ⬜ | ⬜ | ⬜ |
| Energie | ⬜ | ⬜ | ⬜ | ⬜ |
| Spielbereich | ⬜ | ⬜ | ⬜ | ⬜ |

---

**VERSION:** 1.0  
**DATUM:** November 2025  
**STATUS:** Planungs-Übersicht  
**NÄCHSTER SCHRITT:** Ore-System Chat erstellen
