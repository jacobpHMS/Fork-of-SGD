# 🚀 System Integration Guide

## Performance Optimizations for 10,000+ Objects

All systems have been optimized for massive scale simulation:

### ⚡ Performance Manager
- **Batch Processing**: Max 100 objects per frame
- **Update Intervals**: Different priorities (Critical, High, Medium, Low, Background)
- **Spatial Partitioning**: Fast proximity queries via grid
- **Frame Budget**: 16.67ms target (60 FPS)

### 🚢 Fleet Automation System (OPTIMIZED)
- Supports **10,000+ ships** simultaneously
- **Batch updates**: Only 100 ships updated per frame
- **Active/Docked lists**: Separate tracking for optimization
- **Dirty flags**: UI only updates when needed
- **Minimal logging**: Reduces console spam at scale

### 📊 Key Performance Features
1. **Circular Batch Processing** - Distributes work across frames
2. **Spatial Grid** - O(1) proximity queries instead of O(n²)
3. **Update Priorities** - Critical systems every frame, background every 30 frames
4. **Frame Budget Monitoring** - Automatic performance warnings

---

## 🔧 Setup Instructions

### 1. Add AutoLoads to project.godot

Open `project.godot` and add these lines to the `[autoload]` section:

```ini
[autoload]
PerformanceManager="*res://scripts/PerformanceManager.gd"
SelectionManager="*res://scripts/SelectionManager.gd"
TranslationManager="*res://scripts/TranslationManager.gd"
SkillManager="*res://scripts/SkillManager.gd"
```

### 2. Scene Structure

```
Main (Node2D)
├── SystemIntegration            # Integration coordinator
├── CraftingSystem               # World crafting system
├── StationSystem                # Station management
├── FleetAutomationSystem        # Fleet automation
├── Player (CharacterBody2D)
│   ├── TemperatureSystem        # Player temperature
│   ├── EnergySystem             # Player energy
│   ├── RefinerySystem           # Player refinery
│   └── ModuleSystem             # Player modules
└── UI (CanvasLayer)
    ├── SkillsUI                 # Skills panel
    ├── TemperatureUI            # Temperature panel
    ├── EnergyUI                 # Energy panel
    └── CraftingUI               # Crafting panel
```

### 3. Add Systems to Scenes

#### Player Scene
1. Add as child nodes:
   - `TemperatureSystem.gd`
   - `EnergySystem.gd`
   - `RefinerySystem.gd`
   - `ModuleSystem.gd`

#### Main Scene
1. Add as child nodes:
   - `SystemIntegration.gd`
   - `CraftingSystem.gd`
   - `StationSystem.gd`
   - `FleetAutomationSystem.gd`

#### UI Scene
1. Add UI controller scripts to corresponding UI nodes

### 4. Enable Translations

1. Go to **Project → Project Settings → Localization**
2. Click **Add** under "Translations"
3. Select `res://translations/game_strings.csv`
4. The system will auto-detect languages (en, de)

---

## 📱 UI Systems

### SelectionManager
- **Single Click**: Select object
- **Double Click**: Focus/Open (ships → focus camera, stations → open UI)
- **Right Click**: Context menu
- **Ctrl+Click**: Multi-select
- **Drag**: Box selection or drag & drop
- **Keyboard**: F (focus), A (select all), Delete, Escape

### Supported Interactions
- Click ore → Command ships to mine
- Drag ore to ship → Mine this ore
- Drag ship to station → Dock at station
- Double-click station → Open station UI

---

## 🌍 Translation System

### Available Languages
- **English** (en)
- **Deutsch** (de)

### Usage in Code

```gdscript
# Direct translation
var text = TranslationManager.tr("skill_mining")  # "Mining" or "Bergbau"

# Convenience functions
var ui_text = TranslationManager.tr_ui("yes")      # "Yes" or "Ja"
var skill_text = TranslationManager.tr_skill("mining")  # "Mining" or "Bergbau"

# Format helpers
var time = TranslationManager.format_time(125)     # "2m 5s"
var distance = TranslationManager.format_distance(1500)  # "1.5 km" or "1,5 km"
```

### Adding New Translations
1. Open `translations/game_strings.csv`
2. Add new row: `key,english_text,german_text`
3. Godot automatically reloads on save

---

## ⚙️ System Integration

### Connecting Systems

The `SystemIntegration.gd` script automatically connects all systems. It:
1. Finds all systems in the scene tree
2. Connects them to each other
3. Validates that everything is working
4. Optionally runs integration tests

### Manual Connection Example

```gdscript
# In your Main.gd or similar
var fleet_system = $FleetAutomationSystem
var station_system = $StationSystem

# Connect fleet to stations
fleet_system.station_system = station_system

# Register with performance manager
if has_node("/root/PerformanceManager"):
    var perf = get_node("/root/PerformanceManager")
    perf.register_system("MySystem", _my_update_func, perf.UpdatePriority.MEDIUM)
```

---

## 🧪 Testing

### Run Integration Test

```gdscript
# In SystemIntegration.gd
func _ready():
    setup_all_systems()
    run_integration_test()  # Uncomment to test
```

### Performance Monitoring

```gdscript
# Print performance report
if has_node("/root/PerformanceManager"):
    get_node("/root/PerformanceManager").print_performance_report()
```

Output example:
```
╔════════════════════════════════════════╗
║     PERFORMANCE REPORT                 ║
╠════════════════════════════════════════╣
║ Average FPS: 60.0
║ Average Frame Time: 15.23ms
║ Frame Budget Used: 91.4%
║ Registered Systems: 3
╠════════════════════════════════════════╣
║ System Average Times:                  ║
║   FleetAutomation: 8.50ms
║   EnergySystem: 2.30ms
║   TemperatureSystem: 1.20ms
╚════════════════════════════════════════╝
```

---

## 📈 Performance Best Practices

### For 10,000+ Objects:

1. **Always register with PerformanceManager**
   ```gdscript
   PerformanceManager.register_system("MySystem", _update, PerformanceManager.UpdatePriority.MEDIUM)
   ```

2. **Use Spatial Grid for proximity queries**
   ```gdscript
   var nearby = PerformanceManager.query_nearby_objects(position, 1000.0)
   ```

3. **Batch your updates**
   ```gdscript
   var batch = PerformanceManager.create_batch_iterator(items, 100)
   while batch.has_next():
       for item in batch.get_next_batch():
           process_item(item)
   ```

4. **Use dirty flags for UI**
   ```gdscript
   var stats_dirty = false

   func update_stats():
       stats_dirty = true

   func _process(delta):
       if stats_dirty and update_interval % 60 == 0:
           emit_signal("stats_updated", get_stats())
           stats_dirty = false
   ```

5. **Minimize logging at scale**
   ```gdscript
   # Only log every 100th event
   if object_count % 100 == 0:
       print("Created %d objects" % object_count)
   ```

---

## 🐛 Troubleshooting

### "PerformanceManager not found"
→ Add to project.godot AutoLoads (see Setup section)

### "Translation not working"
→ Check that `game_strings.csv` is added in Project Settings → Localization

### "Systems not connecting"
→ Verify `SystemIntegration.gd` is in your Main scene and running

### "Low FPS with many ships"
→ Check PerformanceManager report, reduce `ships_per_frame` in FleetAutomationSystem

### "UI not updating"
→ Make sure UI scripts have references to backend systems via `get_node("/root/...")`

---

## 📝 File Overview

| File | Purpose | Location |
|------|---------|----------|
| `PerformanceManager.gd` | Performance optimization for 10k+ objects | AutoLoad |
| `SelectionManager.gd` | Universal selection & interaction | AutoLoad |
| `TranslationManager.gd` | Multi-language support | AutoLoad |
| `SkillManager.gd` | Skill progression system | AutoLoad |
| `FleetAutomationSystem.gd` | Fleet automation (OPTIMIZED) | Main scene |
| `EnergySystem.gd` | Power generation & distribution | Player |
| `TemperatureSystem.gd` | Temperature simulation | Player |
| `CraftingSystem.gd` | Production chains | Main scene |
| `StationSystem.gd` | Station management | Main scene |
| `SystemIntegration.gd` | Integration coordinator | Main scene |
| `game_strings.csv` | Translations (en, de) | translations/ |

---

## 🎮 Ready to Use!

All systems are production-ready and optimized for:
- ✅ 10,000+ fleet ships
- ✅ Thousands of ore asteroids
- ✅ Complex production chains
- ✅ Multi-language support
- ✅ Full save/load integration
- ✅ 60 FPS target on modern hardware

For questions or issues, check the troubleshooting section or review the code comments.

---

**Version**: 1.0
**Last Updated**: 2025-11-17
**Godot Version**: 4.5+
