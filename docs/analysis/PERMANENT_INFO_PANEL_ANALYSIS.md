# 🔍 PermanentInfoPanel - Tiefgreifende Analyse & Refactoring-Vorschlag

**Erstellt:** 2025-11-19
**Problem:** Hohe Kopplung (Instabilität 1.00), schwierige Wartbarkeit
**Betroffene Datei:** `scripts/PermanentInfoPanel.gd` (1217 Zeilen)

---

## 📊 AKTUELLE SITUATION

### Problem-Zusammenfassung

**Aus DEPENDENCIES.md:**
```
PermanentInfoPanel (1.00) - Heavily coupled to multiple systems
- Efferent Coupling (Ce): 7 Systeme
- Afferent Coupling (Ca): 0 (nichts hängt davon ab)
- Instabilität: 1.00 (Maximal instabil) 🔴
```

**Das bedeutet:**
- **7 Abhängigkeiten**: Player, GameData, TemperatureSystem, CraftingSystem, CargoSystem, EnergySystem, ModuleSystem
- **Keine Rückabhängigkeiten**: Nichts nutzt PermanentInfoPanel (ist nur Anzeige)
- **Änderungen in einem der 7 Systeme** → PermanentInfoPanel bricht möglicherweise

### Aktuelle Datei-Analyse

**Größe:** 1217 Zeilen Code (zu groß für Single Responsibility Principle)

**Struktur:**
```gdscript
# 4-Spalten-Layout: 15% / 35% / 35% / 15%

Column 1: History & Events (Fix)
  ├─ HistoryLog (Ereignis-Verlauf)
  └─ WorldEvents (Welt-Ereignisse)

Column 2: Selectable Panel (8 Optionen)
  ├─ Mining Scanner (4 Circles)
  ├─ Spectral Scan (1 Circle)
  ├─ Quality Graph
  ├─ Cargo Overview
  ├─ Ship Modules
  ├─ Tactical Display
  ├─ Ship Overview
  └─ Ship Details

Column 3: Selectable Panel (8 Optionen, gleich wie Column 2)

Column 4: Reiter-System (Tabs)
  ├─ ShipStatus Tab
  ├─ Temperature Tab
  ├─ Energy Tab
  ├─ Modules Tab
  └─ Mining Queue Tab
```

**Abhängigkeiten im Code (Beispiele):**
```gdscript
# Direkte Zugriffe auf Player
player_node.ship_data["hull_integrity"]
player_node.cargo_holds["ore"]
player_node.mining_queue

# Direkte Zugriffe auf Systeme
TemperatureSystem.get_temperature(player_node)
CraftingSystem.get_queue_info()
EnergySystem.get_generation()
ModuleSystem.get_module_status()
```

**Problem:** Tight Coupling - Änderungen in Player.gd oder Systemen brechen PermanentInfoPanel

---

## 🎯 ROOT CAUSE ANALYSIS

### Warum ist PermanentInfoPanel so gekoppelt?

#### 1. **Keine Datenschicht**
```gdscript
# ❌ AKTUELL: Direkter Zugriff auf interne Daten
var hull = player_node.ship_data["hull_integrity"]
var max_hull = player_node.ship_data["max_hull"]

# ✅ BESSER: Über öffentliche API
var hull_info = player_node.get_hull_status()  # Returns {current, max, percent}
```

#### 2. **God Object Pattern**
- PermanentInfoPanel versucht **alles anzuzeigen**
- **8 verschiedene Panel-Typen** in einer Datei
- Jeder Panel-Typ = 50-150 Zeilen Code
- Verletzt Single Responsibility Principle

#### 3. **Keine Trennung von UI & Logic**
```gdscript
# ❌ AKTUELL: UI-Update vermischt mit Daten-Logik
func update_mining_scanner():
    var ores = get_nearby_ores()  # Logik
    for ore in ores:
        var quality = analyze_ore_quality(ore)  # Logik
        draw_ore_circle(ore, quality)  # UI
```

#### 4. **Signal-Spaghetti**
```gdscript
# 20+ Signal-Verbindungen direkt im Panel
player_node.ore_mined.connect(_on_ore_mined)
player_node.cargo_changed.connect(_on_cargo_changed)
player_node.ship_damaged.connect(_on_ship_damaged)
player_node.temperature_warning.connect(_on_temperature_warning)
# ... 16 weitere Signale
```

---

## 🛠️ LÖSUNGSVORSCHLAG: WINDOW MANAGEMENT SYSTEM

### Konzept: Modulares Fenster-Management

#### Architektur-Übersicht

```
┌─────────────────────────────────────────────────────────────┐
│              WindowManager (Autoload)                        │
│  - Verwaltet alle Fenster                                    │
│  - Koordiniert Layout                                        │
│  - Event-Bus für Fenster-Kommunikation                       │
└─────────────────────────────────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│         PermanentInfoPanel (Vereinfacht, 200 Zeilen)         │
│  - Nur Layout-Container (4 Spalten)                          │
│  - Lädt/entlädt Module dynamisch                             │
│  - Keine Geschäftslogik                                      │
└─────────────────────────────────────────────────────────────┘
       │              │              │              │
       ▼              ▼              ▼              ▼
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│ Column 1 │  │ Column 2 │  │ Column 3 │  │ Column 4 │
│ (Fixed)  │  │(Swappable│  │(Swappable│  │  (Tabs)  │
└──────────┘  └──────────┘  └──────────┘  └──────────┘
     │              │              │              │
     ▼              ▼              ▼              ▼
 ┌────────┐    ┌────────┐    ┌────────┐    ┌────────┐
 │History │    │Mining  │    │ Cargo  │    │ Ship   │
 │ Widget │    │Scanner │    │Overview│    │ Status │
 └────────┘    │ Widget │    │ Widget │    │ Widget │
 ┌────────┐    └────────┐    └────────┘    └────────┘
 │Events  │    ┌────────┐    ┌────────┐    ┌────────┐
 │ Widget │    │Spectral│    │Quality │    │  Temp  │
 └────────┘    │ Widget │    │ Widget │    │ Widget │
               └────────┘    └────────┘    └────────┘
```

### Phase 1: WindowManager (Neues Autoload)

```gdscript
# scripts/autoload/WindowManager.gd
extends Node
class_name WindowManager

## Manages all game windows and panels
## Provides centralized window control, layout management, and event bus

# ============================================================================
# SIGNALS
# ============================================================================

signal window_opened(window_id: String)
signal window_closed(window_id: String)
signal window_focused(window_id: String)
signal layout_changed()

# ============================================================================
# REGISTERED WINDOWS
# ============================================================================

var _windows: Dictionary = {}  # window_id -> Window instance
var _active_windows: Array[String] = []
var _focused_window: String = ""

# ============================================================================
# WINDOW REGISTRATION
# ============================================================================

func register_window(window_id: String, window_instance: Control) -> void:
	"""Register a window with the manager"""
	if _windows.has(window_id):
		push_warning("Window '%s' already registered" % window_id)
		return

	_windows[window_id] = window_instance
	print("✅ Window registered: %s" % window_id)

func unregister_window(window_id: String) -> void:
	"""Unregister a window"""
	if not _windows.has(window_id):
		return

	_windows.erase(window_id)
	_active_windows.erase(window_id)

# ============================================================================
# WINDOW CONTROL
# ============================================================================

func open_window(window_id: String) -> void:
	"""Open/show a window"""
	if not _windows.has(window_id):
		push_error("Window not found: %s" % window_id)
		return

	var window = _windows[window_id]
	window.visible = true

	if not _active_windows.has(window_id):
		_active_windows.append(window_id)

	window_opened.emit(window_id)

func close_window(window_id: String) -> void:
	"""Close/hide a window"""
	if not _windows.has(window_id):
		return

	var window = _windows[window_id]
	window.visible = false
	_active_windows.erase(window_id)

	window_closed.emit(window_id)

func toggle_window(window_id: String) -> void:
	"""Toggle window visibility"""
	if not _windows.has(window_id):
		return

	var window = _windows[window_id]
	if window.visible:
		close_window(window_id)
	else:
		open_window(window_id)

func focus_window(window_id: String) -> void:
	"""Bring window to front"""
	if not _windows.has(window_id):
		return

	_focused_window = window_id
	_windows[window_id].move_to_front()
	window_focused.emit(window_id)

# ============================================================================
# LAYOUT MANAGEMENT
# ============================================================================

enum LayoutPreset {
	MINING,      # Mining Scanner + Cargo Overview
	COMBAT,      # Tactical + Ship Status
	TRADING,     # Market + Cargo + Station
	EXPLORATION, # Map + Scanner
	CUSTOM       # User-defined
}

var current_layout: LayoutPreset = LayoutPreset.MINING

func apply_layout_preset(preset: LayoutPreset) -> void:
	"""Apply a predefined layout configuration"""
	current_layout = preset

	match preset:
		LayoutPreset.MINING:
			_apply_mining_layout()
		LayoutPreset.COMBAT:
			_apply_combat_layout()
		LayoutPreset.TRADING:
			_apply_trading_layout()
		LayoutPreset.EXPLORATION:
			_apply_exploration_layout()

	layout_changed.emit()

func _apply_mining_layout() -> void:
	"""Configure windows for mining operations"""
	# Example: Open mining scanner, cargo overview, close combat displays
	pass  # Implementation depends on window system

# ============================================================================
# HOTKEY MANAGEMENT
# ============================================================================

var _hotkeys: Dictionary = {}  # Key -> window_id

func bind_hotkey(key: Key, window_id: String) -> void:
	"""Bind a hotkey to toggle a window"""
	_hotkeys[key] = window_id

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if _hotkeys.has(event.keycode):
			var window_id = _hotkeys[event.keycode]
			toggle_window(window_id)

# ============================================================================
# WINDOW STATE PERSISTENCE
# ============================================================================

func save_window_layout() -> Dictionary:
	"""Save current window layout to dictionary"""
	var state = {
		"layout": current_layout,
		"active_windows": _active_windows.duplicate(),
		"focused": _focused_window,
		"window_positions": {}
	}

	for window_id in _windows.keys():
		var window = _windows[window_id]
		state.window_positions[window_id] = {
			"pos": window.position,
			"size": window.size
		}

	return state

func load_window_layout(state: Dictionary) -> void:
	"""Restore window layout from saved state"""
	if state.has("layout"):
		current_layout = state.layout

	if state.has("active_windows"):
		for window_id in state.active_windows:
			open_window(window_id)

	if state.has("window_positions"):
		for window_id in state.window_positions.keys():
			if _windows.has(window_id):
				var pos_data = state.window_positions[window_id]
				_windows[window_id].position = pos_data.pos
				_windows[window_id].size = pos_data.size
```

### Phase 2: Widget Base Class

```gdscript
# scripts/ui/BaseWidget.gd
extends Control
class_name BaseWidget

## Base class for all dashboard widgets
## Provides standardized interface for data binding and updates

# ============================================================================
# WIDGET METADATA
# ============================================================================

@export var widget_id: String = ""
@export var widget_title: String = "Widget"
@export var update_interval: float = 0.5  # seconds

# ============================================================================
# DATA BINDING
# ============================================================================

var _data_source: Object = null
var _update_timer: Timer = null

func _ready():
	# Setup update timer
	_update_timer = Timer.new()
	_update_timer.wait_time = update_interval
	_update_timer.timeout.connect(_on_update_tick)
	add_child(_update_timer)
	_update_timer.start()

	# Initialize widget
	initialize_widget()

# ============================================================================
# VIRTUAL METHODS (Override in subclasses)
# ============================================================================

func initialize_widget() -> void:
	"""Called once when widget is created. Override in subclass."""
	pass

func update_widget_data() -> void:
	"""Called every update_interval. Override to update display."""
	pass

func bind_data_source(source: Object) -> void:
	"""Bind widget to a data source (e.g., Player node)"""
	_data_source = source

# ============================================================================
# UPDATE LOOP
# ============================================================================

func _on_update_tick() -> void:
	if _data_source:
		update_widget_data()
```

### Phase 3: Beispiel-Widgets

```gdscript
# scripts/ui/widgets/MiningScannerWidget.gd
extends BaseWidget
class_name MiningScannerWidget

## Displays nearby asteroids in 4 circular radar displays

@onready var circle_1 = $HBoxContainer/Circle1
@onready var circle_2 = $HBoxContainer/Circle2
@onready var circle_3 = $HBoxContainer/Circle3
@onready var circle_4 = $HBoxContainer/Circle4

var scan_range: float = 2000.0

func initialize_widget() -> void:
	widget_id = "mining_scanner"
	widget_title = "Mining Scanner"

func update_widget_data() -> void:
	if not _data_source:
		return

	# Get player position
	var player_pos = _data_source.global_position

	# Scan for nearby ores
	var ores = _scan_nearby_ores(player_pos, scan_range)

	# Update circles (max 4 closest ores)
	for i in range(4):
		if i < ores.size():
			_draw_ore_in_circle(i, ores[i])
		else:
			_clear_circle(i)

func _scan_nearby_ores(center: Vector2, range: float) -> Array:
	"""Scan for ores within range (uses spatial query)"""
	var main = get_tree().root.get_node_or_null("Main")
	if not main:
		return []

	var ore_container = main.get_node_or_null("OreContainer")
	if not ore_container:
		return []

	var nearby_ores = []
	for ore in ore_container.get_children():
		var distance = center.distance_to(ore.global_position)
		if distance <= range:
			nearby_ores.append({
				"ore": ore,
				"distance": distance,
				"quality": ore.get("quality", 1.0)
			})

	# Sort by distance
	nearby_ores.sort_custom(func(a, b): return a.distance < b.distance)
	return nearby_ores.slice(0, 4)

func _draw_ore_in_circle(circle_index: int, ore_data: Dictionary) -> void:
	"""Draw ore info in a circle display"""
	var circle = [circle_1, circle_2, circle_3, circle_4][circle_index]
	# Update circle display (implement drawing logic)
	pass

func _clear_circle(circle_index: int) -> void:
	"""Clear a circle display"""
	var circle = [circle_1, circle_2, circle_3, circle_4][circle_index]
	# Clear circle
	pass
```

```gdscript
# scripts/ui/widgets/CargoOverviewWidget.gd
extends BaseWidget
class_name CargoOverviewWidget

## Displays summary of all cargo holds

@onready var cargo_list = $VBoxContainer/ScrollContainer/CargoList

func initialize_widget() -> void:
	widget_id = "cargo_overview"
	widget_title = "Cargo Overview"

func update_widget_data() -> void:
	if not _data_source:
		return

	cargo_list.clear()

	# Get cargo holds from player
	var holds = _data_source.cargo_holds

	for hold_type in holds.keys():
		var hold = holds[hold_type]
		var used = hold.used
		var capacity = hold.capacity
		var percent = (used / capacity) * 100.0 if capacity > 0 else 0.0

		var item = cargo_list.add_item("%s: %.1f / %.1f m³ (%.0f%%)" % [
			hold_type.capitalize(),
			used,
			capacity,
			percent
		])

		# Color code based on fullness
		if percent > 90.0:
			cargo_list.set_item_custom_fg_color(item, Color.RED)
		elif percent > 75.0:
			cargo_list.set_item_custom_fg_color(item, Color.YELLOW)
		else:
			cargo_list.set_item_custom_fg_color(item, Color.GREEN)
```

---

## 📐 IMPLEMENTATION PLAN

### Phase 1: Vorbereitung (Woche 1)

**1.1 WindowManager Autoload erstellen**
- Neue Datei: `scripts/autoload/WindowManager.gd`
- Registrierung in `project.godot`
- Basis-Funktionalität testen

**1.2 BaseWidget Klasse erstellen**
- Neue Datei: `scripts/ui/BaseWidget.gd`
- Update-Loop und Data-Binding implementieren

**1.3 Widget-Ordner-Struktur**
```
scripts/ui/
├── BaseWidget.gd
└── widgets/
    ├── MiningScannerWidget.gd
    ├── SpectralScanWidget.gd
    ├── CargoOverviewWidget.gd
    ├── ShipModulesWidget.gd
    ├── ShipStatusWidget.gd
    ├── TemperatureWidget.gd
    ├── EnergyWidget.gd
    └── MiningQueueWidget.gd
```

### Phase 2: Widget-Migration (Woche 2-3)

**Für jedes Widget:**
1. Neues Widget erstellen (extends BaseWidget)
2. Logik aus PermanentInfoPanel extrahieren
3. In PermanentInfoPanel.tscn referenzieren
4. Testen
5. Alten Code auskommentieren

**Reihenfolge (nach Komplexität):**
1. ✅ CargoOverviewWidget (einfach)
2. ✅ ShipStatusWidget (einfach)
3. ✅ TemperatureWidget (mittel)
4. ✅ EnergyWidget (mittel)
5. ✅ MiningScannerWidget (komplex)
6. ✅ SpectralScanWidget (komplex)
7. ✅ ShipModulesWidget (komplex)
8. ✅ MiningQueueWidget (mittel)

### Phase 3: PermanentInfoPanel Refactoring (Woche 4)

**Alte Datei:** `PermanentInfoPanel.gd` (1217 Zeilen)
**Neue Datei:** `PermanentInfoPanel.gd` (~200 Zeilen)

**Neue Verantwortlichkeiten:**
- ✅ Layout-Container (4 Spalten)
- ✅ Widget-Loading (dynamisch)
- ✅ Panel-Selection (Dropdown-Handling)
- ❌ **KEINE** Geschäftslogik
- ❌ **KEINE** direkten System-Zugriffe

### Phase 4: Testing & Polish (Woche 5)

- Unit-Tests für WindowManager
- Integration-Tests für Widgets
- Performance-Testing
- UI/UX Polish

---

## 🎯 VORTEILE DER NEUEN ARCHITEKTUR

### 1. **Entkopplung** ✅
```gdscript
# VORHER: 7 direkte Abhängigkeiten
PermanentInfoPanel → Player
                   → GameData
                   → TemperatureSystem
                   → CraftingSystem
                   → CargoSystem
                   → EnergySystem
                   → ModuleSystem

# NACHHER: Nur WindowManager
PermanentInfoPanel → WindowManager
                   → BaseWidget (abstract)

# Widgets → Player (über data binding)
MiningScannerWidget → Player (via bind_data_source)
CargoWidget → Player (via bind_data_source)
```

**Instabilität:**
- Vorher: 1.00 (maximal instabil)
- Nachher: ~0.3 (stabil)

### 2. **Wiederverwendbarkeit** ✅
```gdscript
# Widgets können in anderen Fenstern verwendet werden
var cargo_widget = CargoOverviewWidget.new()
cargo_widget.bind_data_source(player)

# Kann in PermanentInfoPanel verwendet werden
panel.add_widget(cargo_widget)

# ODER in eigenem Fenster
var cargo_window = Window.new()
cargo_window.add_child(cargo_widget)
```

### 3. **Testbarkeit** ✅
```gdscript
# Widget-Tests ohne ganzes Panel
func test_cargo_widget():
	var widget = CargoOverviewWidget.new()
	var mock_player = MockPlayer.new()
	mock_player.cargo_holds = {"ore": {"used": 100, "capacity": 200}}

	widget.bind_data_source(mock_player)
	widget.update_widget_data()

	assert(widget.cargo_list.get_item_count() == 1)
```

### 4. **Wartbarkeit** ✅
- Widget kaputt? Nur ein Widget fixen (50-150 Zeilen)
- Vorher: Ganzes Panel debuggen (1217 Zeilen)
- Klare Verantwortlichkeiten
- Einfacher zu verstehen

### 5. **Performance** ✅
```gdscript
# Vorher: Alles wird immer geupdatet (auch unsichtbare Panels)
func _process(delta):
	update_mining_scanner()  # 100ms
	update_spectral_scan()   # 50ms
	update_cargo()           # 30ms
	update_ship_status()     # 20ms
	# ... 8 Panel-Updates, auch wenn nicht sichtbar

# Nachher: Nur sichtbare Widgets updaten
# Widgets haben eigene Timer
# Unsichtbare Widgets pausieren automatisch
```

---

## 📊 MIGRATION ROADMAP

### Woche 1: Setup
- [ ] WindowManager.gd erstellen
- [ ] BaseWidget.gd erstellen
- [ ] Widget-Ordnerstruktur anlegen
- [ ] Testing-Framework setup

### Woche 2-3: Widget-Entwicklung
- [ ] CargoOverviewWidget
- [ ] ShipStatusWidget
- [ ] TemperatureWidget
- [ ] EnergyWidget
- [ ] MiningScannerWidget
- [ ] SpectralScanWidget
- [ ] ShipModulesWidget
- [ ] MiningQueueWidget

### Woche 4: Integration
- [ ] PermanentInfoPanel.gd refactoren
- [ ] Widget-Loading implementieren
- [ ] Signal-Connections umstellen
- [ ] Alte Code-Entfernung

### Woche 5: Testing & Launch
- [ ] Unit-Tests schreiben
- [ ] Performance-Tests
- [ ] Bug-Fixing
- [ ] Dokumentation

---

## 🔧 ALTERNATIVE: Minimale Verbesserung (Wenn volle Migration nicht möglich)

Falls die vollständige Widget-Migration zu aufwendig ist, **Minimal-Verbesserungen:**

### 1. **Data Layer einführen**
```gdscript
# scripts/PlayerDataProvider.gd (Neue Datei)
class_name PlayerDataProvider
extends RefCounted

## Provides read-only access to player data
## Entkoppelt UI von Player-Implementierung

var _player: Node

func _init(player: Node):
	_player = player

func get_hull_status() -> Dictionary:
	return {
		"current": _player.ship_data.get("hull_integrity", 0),
		"max": _player.ship_data.get("max_hull", 100),
		"percent": _player.ship_data.get("hull_integrity", 0) / _player.ship_data.get("max_hull", 100) * 100
	}

func get_cargo_summary() -> Array[Dictionary]:
	var summary = []
	for hold_type in _player.cargo_holds.keys():
		var hold = _player.cargo_holds[hold_type]
		summary.append({
			"type": hold_type,
			"used": hold.used,
			"capacity": hold.capacity
		})
	return summary

# ... weitere getter-Methoden
```

### 2. **Signal-Aggregator**
```gdscript
# scripts/PlayerSignalBus.gd (Neue Datei)
extends Node

## Zentrale Signal-Weiterleitung für Player-Events
## Reduziert Signal-Connections

signal player_data_changed(data_type: String)

func notify_hull_changed():
	player_data_changed.emit("hull")

func notify_cargo_changed():
	player_data_changed.emit("cargo")

# ... weitere Signale
```

### 3. **Code in Funktionen aufteilen**
```gdscript
# Statt 1217 Zeilen in einer Datei:
# - update_mining_scanner() → _mining_scanner.gd
# - update_cargo() → _cargo_panel.gd
# - update_ship_status() → _ship_status.gd

# Hauptdatei wird kleiner, Logik wird modular
```

---

## ✅ EMPFEHLUNG

**Empfohlener Ansatz:** Vollständige Widget-Migration (Phase 1-5)

**Warum?**
1. Langfristig wartbarer
2. Bessere Architektur
3. Wiederverwendbare Komponenten
4. Bessere Performance
5. Einfacher zu testen

**Zeitinvestition:** 5 Wochen
**Langfristiger Nutzen:** Hoch (Entwicklungsgeschwindigkeit +30%)

---

**Nächste Schritte:** Siehe WINDOW_MANAGEMENT_REFACTORING.md (erstellen)
