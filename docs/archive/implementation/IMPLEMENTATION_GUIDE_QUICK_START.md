# Quick Start Implementation Guide

**Based on:** GODOT_BEST_PRACTICES_2025.md
**For:** Space Mining Game
**Priority:** High-impact, low-effort improvements

---

## Week 1: Add Structured Logging

### Step 1: Create Logger Autoload

Create `/home/user/SpaceGameDev/scripts/autoload/logger.gd`:

```gdscript
extends Node

enum Level { DEBUG, INFO, WARNING, ERROR, CRITICAL }

const LOG_FILE_PATH = "user://logs/game.log"
var min_log_level: Level = Level.INFO
var log_to_file: bool = true
var log_to_console: bool = true

func _ready() -> void:
    _ensure_log_directory()

func debug(message: String, context: Dictionary = {}) -> void:
    _log(Level.DEBUG, message, context)

func info(message: String, context: Dictionary = {}) -> void:
    _log(Level.INFO, message, context)

func warning(message: String, context: Dictionary = {}) -> void:
    _log(Level.WARNING, message, context)

func error(message: String, context: Dictionary = {}) -> void:
    _log(Level.ERROR, message, context)

func critical(message: String, context: Dictionary = {}) -> void:
    _log(Level.CRITICAL, message, context)

func _log(level: Level, message: String, context: Dictionary) -> void:
    if level < min_log_level:
        return

    var timestamp = Time.get_datetime_string_from_system()
    var level_str = Level.keys()[level]
    var context_str = JSON.stringify(context) if not context.is_empty() else ""
    var log_entry = "[%s] [%s] %s %s" % [timestamp, level_str, message, context_str]

    if log_to_console:
        _print_to_console(level, log_entry)
    if log_to_file:
        _write_to_file(log_entry)

func _print_to_console(level: Level, message: String) -> void:
    match level:
        Level.DEBUG:
            print_debug(message)
        Level.INFO:
            print(message)
        Level.WARNING:
            push_warning(message)
        Level.ERROR, Level.CRITICAL:
            push_error(message)

func _write_to_file(message: String) -> void:
    var file = FileAccess.open(LOG_FILE_PATH, FileAccess.READ_WRITE)
    if file == null:
        file = FileAccess.open(LOG_FILE_PATH, FileAccess.WRITE)
    if file:
        file.seek_end()
        file.store_line(message)
        file.close()

func _ensure_log_directory() -> void:
    var dir = DirAccess.open("user://")
    if not dir.dir_exists("logs"):
        dir.make_dir("logs")
```

### Step 2: Add to Autoload

In `project.godot`, add:
```
Logger="*res://scripts/autoload/logger.gd"
```

### Step 3: Replace print() statements

**Before:**
```gdscript
print("Mining ore: ", ore_name)
```

**After:**
```gdscript
Logger.info("Mining ore", {"ore_type": ore_name, "amount": amount})
```

---

## Week 2: Install GUT Testing Framework

### Step 1: Download GUT

1. Open Godot Editor
2. AssetLib tab (top)
3. Search "GUT"
4. Download "GUT - Godot Unit Testing (Godot 4)"
5. Install to `res://addons/gut/`

### Step 2: Enable Plugin

1. Project > Project Settings > Plugins
2. Enable "Gut"

### Step 3: Create Test Directory

```
mkdir -p /home/user/SpaceGameDev/test/unit
mkdir -p /home/user/SpaceGameDev/test/integration
```

### Step 4: Write First Test

Create `/home/user/SpaceGameDev/test/unit/test_save_manager.gd`:

```gdscript
extends GutTest

var save_manager: Node

func before_all():
    save_manager = load("res://scripts/SaveManager.gd").new()
    add_child(save_manager)

func after_all():
    save_manager.queue_free()

func test_save_directory_exists():
    save_manager.ensure_save_directory()
    var dir = DirAccess.open("user://")
    assert_true(dir.dir_exists("saves"), "Save directory should exist")

func test_save_and_load():
    # Setup test data
    save_manager.current_game_data = {
        "player_name": "Test Player",
        "credits": 1000,
        "position": {"x": 100, "y": 200}
    }

    # Save
    var save_result = save_manager.save_game(0)
    assert_true(save_result, "Save should succeed")

    # Clear data
    save_manager.current_game_data = {}

    # Load
    var load_result = save_manager.load_game(0)
    assert_true(load_result, "Load should succeed")
    assert_eq(save_manager.current_game_data.player_name, "Test Player")
    assert_eq(save_manager.current_game_data.credits, 1000)
```

### Step 5: Run Tests

1. Bottom panel > Gut
2. Click "Run All"
3. View results

---

## Week 3: Add Type Hints to Core Scripts

### Example: Player.gd

**Before:**
```gdscript
var ship_data = {
    "name": "Test Mining Frigate",
    "mass": 50000.0
}

func mine_ore(ore):
    var result = _perform_mining(ore)
    return result
```

**After:**
```gdscript
var ship_data: Dictionary = {
    "name": "Test Mining Frigate",
    "mass": 50000.0
}

func mine_ore(ore: Node2D) -> Dictionary:
    var result: Dictionary = _perform_mining(ore)
    return result

func _perform_mining(ore: Node2D) -> Dictionary:
    var mining_result: Dictionary = {}
    # ... mining logic
    return mining_result
```

### Priority Files:
1. `/home/user/SpaceGameDev/scripts/Player.gd` ✅ (partially done)
2. `/home/user/SpaceGameDev/scripts/autoload/database_manager.gd` ✅ (partially done)
3. `/home/user/SpaceGameDev/scripts/SaveManager.gd`
4. `/home/user/SpaceGameDev/scripts/CargoWindow.gd`
5. `/home/user/SpaceGameDev/scripts/Main.gd`

---

## Week 4: Implement EventBus

### Step 1: Create EventBus

Create `/home/user/SpaceGameDev/scripts/autoload/event_bus.gd`:

```gdscript
extends Node

# === GAME EVENTS ===
signal game_started()
signal game_paused()
signal game_resumed()
signal game_saved(slot: int)
signal game_loaded(slot: int)

# === MINING EVENTS ===
signal mining_started(ore_type: String)
signal mining_completed(ore_type: String, amount: float)
signal mining_failed(ore_type: String, reason: String)

# === CARGO EVENTS ===
signal cargo_added(item_id: String, amount: float, cargo_type: int)
signal cargo_removed(item_id: String, amount: float)
signal cargo_full(cargo_type: int)
signal cargo_crate_spawned(position: Vector2, item_id: String, amount: float)
signal cargo_crate_collected(item_id: String, amount: float)

# === ECONOMY EVENTS ===
signal item_purchased(item_id: String, quantity: int, total_price: float)
signal item_sold(item_id: String, quantity: int, total_profit: float)
signal credits_changed(old_value: float, new_value: float)

# === STATION EVENTS ===
signal station_entered(station: Node2D)
signal station_exited(station: Node2D)
signal docked_at_station(station: Node2D)
signal undocked_from_station(station: Node2D)

# === UI EVENTS ===
signal notification_requested(message: String, type: String)
signal window_opened(window_name: String)
signal window_closed(window_name: String)
```

### Step 2: Add to Autoload

In `project.godot`:
```
EventBus="*res://scripts/autoload/event_bus.gd"
```

### Step 3: Use in Scripts

**Emit events:**
```gdscript
# In Player.gd
func mine_ore(ore: Node2D) -> void:
    EventBus.mining_started.emit(ore.ore_id)

    var result = _perform_mining(ore)

    if result.success:
        EventBus.mining_completed.emit(ore.ore_id, result.amount)
        EventBus.cargo_added.emit(ore.ore_id, result.amount, CargoType.ORE)
    else:
        EventBus.mining_failed.emit(ore.ore_id, result.error)
```

**Listen to events:**
```gdscript
# In UI/NotificationSystem.gd
func _ready() -> void:
    EventBus.mining_completed.connect(_on_mining_completed)
    EventBus.cargo_full.connect(_on_cargo_full)
    EventBus.credits_changed.connect(_on_credits_changed)

func _on_mining_completed(ore_type: String, amount: float) -> void:
    show_notification("Mined %.1f units of %s" % [amount, ore_type], "success")

func _on_cargo_full(cargo_type: int) -> void:
    show_notification("Cargo hold full!", "warning")
```

---

## Week 5: Add Save File Encryption

### Update SaveManager.gd

```gdscript
extends Node

const SAVE_DIR = "user://saves/"
const ENCRYPTION_KEY = "SpaceMiningGame2025SecureKey!!"  # 32 bytes
const SAVE_VERSION = 1

func save_game(slot: int) -> bool:
    if slot < 0 or slot >= MANUAL_SLOTS:
        Logger.error("Invalid save slot", {"slot": slot})
        return false

    var save_path = SAVE_DIR + MANUAL_SAVE_PREFIX + str(slot) + SAVE_EXTENSION

    var save_data = {
        "version": SAVE_VERSION,
        "timestamp": Time.get_unix_time_from_system(),
        "data": current_game_data,
        "checksum": _calculate_checksum(current_game_data)
    }

    var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, ENCRYPTION_KEY)
    if file == null:
        Logger.error("Failed to create encrypted save", {"path": save_path})
        return false

    file.store_var(save_data)
    file.close()

    Logger.info("Game saved", {"slot": slot, "timestamp": save_data.timestamp})
    EventBus.game_saved.emit(slot)
    return true

func load_game(slot: int) -> bool:
    var save_path = SAVE_DIR + MANUAL_SAVE_PREFIX + str(slot) + SAVE_EXTENSION

    if not FileAccess.file_exists(save_path):
        Logger.warning("Save file not found", {"slot": slot})
        return false

    var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, ENCRYPTION_KEY)
    if file == null:
        Logger.error("Failed to decrypt save file", {"slot": slot})
        return false

    var loaded_data = file.get_var()
    file.close()

    # Validate checksum
    if not _validate_checksum(loaded_data):
        Logger.error("Save file corrupted", {"slot": slot})
        return false

    # Apply data
    current_game_data = loaded_data.data

    Logger.info("Game loaded", {"slot": slot, "version": loaded_data.version})
    EventBus.game_loaded.emit(slot)
    return true

func _calculate_checksum(data: Dictionary) -> String:
    var json = JSON.stringify(data)
    return json.sha256_text()

func _validate_checksum(loaded_data: Dictionary) -> bool:
    if not "checksum" in loaded_data:
        return false
    var expected = loaded_data.checksum
    var actual = _calculate_checksum(loaded_data.data)
    return expected == actual
```

---

## Week 6: Add Performance Monitoring

### Create PerformanceMonitor

Create `/home/user/SpaceGameDev/scripts/autoload/performance_monitor.gd`:

```gdscript
extends Node

var frame_times: Array[float] = []
const MAX_FRAME_HISTORY: int = 300  # 5 seconds at 60fps

var metrics: Dictionary = {
    "fps": 0.0,
    "frame_time_ms": 0.0,
    "total_objects": 0,
    "active_ores": 0,
    "memory_mb": 0.0
}

func _process(delta: float) -> void:
    frame_times.append(delta)
    if frame_times.size() > MAX_FRAME_HISTORY:
        frame_times.pop_front()

    _update_metrics()

func _update_metrics() -> void:
    metrics.fps = Engine.get_frames_per_second()
    metrics.frame_time_ms = Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
    metrics.total_objects = Performance.get_monitor(Performance.OBJECT_COUNT)
    metrics.active_ores = get_tree().get_nodes_in_group("ores").size()
    metrics.memory_mb = Performance.get_monitor(Performance.MEMORY_STATIC) / 1024.0 / 1024.0

func get_metrics() -> Dictionary:
    return metrics

func log_summary() -> void:
    Logger.info("Performance Summary", metrics)
```

### Add Debug Overlay

In your UI scene, add:

```gdscript
# res://scenes/ui/PerformanceOverlay.gd
extends CanvasLayer

@onready var label: Label = $MarginContainer/Label
var visible_debug: bool = false

func _ready() -> void:
    visible = false

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_F3:
            visible_debug = !visible_debug
            visible = visible_debug

func _process(delta: float) -> void:
    if not visible:
        return

    var metrics = PerformanceMonitor.get_metrics()
    label.text = """FPS: %d (%.2f ms)
Objects: %d
Active Ores: %d
Memory: %.1f MB
""" % [
        metrics.fps,
        metrics.frame_time_ms,
        metrics.total_objects,
        metrics.active_ores,
        metrics.memory_mb
    ]
```

Add to autoload:
```
PerformanceMonitor="*res://scripts/autoload/performance_monitor.gd"
```

---

## Testing Checklist

After each week, verify:

### Week 1 - Logger
- [ ] Logger appears in autoload
- [ ] print() replaced with Logger.info()
- [ ] Log file created at user://logs/game.log
- [ ] Different log levels work
- [ ] No console spam (only WARNING and above)

### Week 2 - GUT
- [ ] GUT panel appears in editor
- [ ] Test files run successfully
- [ ] At least 3 tests written
- [ ] All tests pass
- [ ] Can run from command line

### Week 3 - Type Hints
- [ ] No type errors on startup
- [ ] IDE autocomplete works better
- [ ] Performance unchanged or improved
- [ ] No runtime errors

### Week 4 - EventBus
- [ ] EventBus appears in autoload
- [ ] Events emit correctly
- [ ] Listeners receive events
- [ ] No circular dependencies
- [ ] Systems are more decoupled

### Week 5 - Encryption
- [ ] Save files are encrypted
- [ ] Can't read save files in text editor
- [ ] Saves load correctly
- [ ] Checksum detects corruption
- [ ] Performance impact minimal

### Week 6 - Performance Monitor
- [ ] PerformanceMonitor tracks metrics
- [ ] F3 toggles overlay
- [ ] Metrics are accurate
- [ ] No performance impact
- [ ] Useful for debugging

---

## Common Issues & Solutions

### Issue: GUT tests fail with "Node not found"

**Solution:** Use `add_child_autofree()` instead of `add_child()`:
```gdscript
func before_each():
    my_node = MyNode.new()
    add_child_autofree(my_node)
```

### Issue: Type hints cause "Invalid type" errors

**Solution:** Check for null:
```gdscript
# Before
var ore: Node2D = get_node("Ore")

# After
var ore: Node2D = get_node_or_null("Ore")
if ore == null:
    Logger.error("Ore node not found")
    return
```

### Issue: EventBus creates circular dependencies

**Solution:** Use signals for upward communication, direct calls for downward:
```gdscript
# Child to parent: Use EventBus
EventBus.player_died.emit()

# Parent to child: Direct call
$Player.take_damage(10)
```

### Issue: Encrypted saves won't load

**Solution:** Check encryption key length (must be 32 bytes):
```gdscript
const ENCRYPTION_KEY = "1234567890123456789012345678901!"  # Exactly 32 chars
```

---

## Next Steps

After completing these 6 weeks:

1. **Review** - Assess improvements
2. **Profile** - Use Godot profiler to find bottlenecks
3. **Optimize** - Implement object pooling if needed
4. **Refine** - Continue adding tests
5. **Document** - Update documentation

**Long-term goals:**
- 70%+ test coverage
- All scripts fully typed
- Performance overlay in debug builds
- Comprehensive logging

---

## Quick Commands Reference

### Run Tests (Command Line)
```bash
cd /home/user/SpaceGameDev
godot --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit
```

### Run Specific Test
```bash
godot --path . -s addons/gut/gut_cmdln.gd -gtest=test_save_manager.gd
```

### View Logs
```bash
cat ~/.local/share/godot/app_userdata/Space\ Mining\ Game/logs/game.log
```

### Check Performance
- Press **F3** in-game (after implementing overlay)
- Or use Debugger > Profiler tab

---

**Good luck with your implementation!**
