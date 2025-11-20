# Configuration Guide - AI Max Evolution

**Branch:** `claude/ai-max-evolution-01RK2D3QTD62zFokAUVEE5r7`
**Date:** 2025-11-18

---

## ⚙️ Required Configuration

To use the new systems (Logger, MigrationManager), you need to add them as **Autoload singletons** in your Godot project.

---

## 📝 Step-by-Step Setup

### 1. Add Autoloads to project.godot

**Option A: Manual Edit (Recommended)**

Open `project.godot` in a text editor and add these lines to the `[autoload]` section:

```ini
[autoload]

# === EXISTING AUTOLOADS (DON'T REMOVE) ===
GameData="*res://scripts/autoload/GameData.gd"
SaveManager="*res://scripts/SaveManager.gd"
TemperatureSystem="*res://scripts/autoload/TemperatureSystem.gd"
CraftingSystem="*res://scripts/autoload/CraftingSystem.gd"
RefinerySystem="*res://scripts/autoload/RefinerySystem.gd"
SkillSystem="*res://scripts/autoload/SkillSystem.gd"
StationSystem="*res://scripts/autoload/StationSystem.gd"
AutomationOrchestrator="*res://scripts/automation/AutomationOrchestrator.gd"
FleetCommandStructure="*res://scripts/automation/FleetCommandStructure.gd"
CreditsManager="*res://scripts/autoload/CreditsManager.gd"

# === NEW AUTOLOADS (ADD THESE!) ===
Logger="*res://scripts/autoload/Logger.gd"
MigrationManager="*res://scripts/autoload/MigrationManager.gd"
```

**Option B: Godot Editor**

1. Open Godot Editor
2. Go to **Project → Project Settings**
3. Select the **Autoload** tab
4. Click **Add** button
5. For Logger:
   - **Path:** `res://scripts/autoload/Logger.gd`
   - **Node Name:** `Logger`
   - **Enable:** ✓ (checked)
   - **Singleton:** ✓ (checked)
   - Click **Add**
6. For MigrationManager:
   - **Path:** `res://scripts/autoload/MigrationManager.gd`
   - **Node Name:** `MigrationManager`
   - **Enable:** ✓ (checked)
   - **Singleton:** ✓ (checked)
   - Click **Add**
7. Click **Close**

---

## 🔧 Initialization Order

**IMPORTANT:** Logger must load BEFORE other systems that use it.

**Correct Order:**
1. **Logger** (first)
2. **MigrationManager** (second)
3. **SaveManager** (uses both Logger and MigrationManager)
4. All other systems

If autoloads are in wrong order:
1. Open `project.godot`
2. Manually reorder the `[autoload]` section
3. Logger and MigrationManager should be at the top

---

## 🧪 Verify Installation

### Test Logger

Create a test script:

```gdscript
extends Node

func _ready():
    Logger.info("Test", "Logger is working!")
    Logger.debug("Test", "Debug message (only in debug builds)")
    Logger.warning("Test", "Warning message")
    Logger.error("Test", "Error message")

    # Check statistics
    var stats = Logger.get_statistics()
    print("Total logs: ", stats.total_logs)
```

**Expected Output:**
```
[2025-11-18T10:30:00] [INFO    ] [Test           ] Logger is working!
[2025-11-18T10:30:00] [DEBUG   ] [Test           ] Debug message (only in debug builds)
[2025-11-18T10:30:00] [WARNING ] [Test           ] Warning message
[2025-11-18T10:30:00] [ERROR   ] [Test           ] Error message
Total logs: 4
```

### Test MigrationManager

```gdscript
func _ready():
    # Check version compatibility
    var compatible = MigrationManager.is_version_compatible("2.0")
    print("v2.0 compatible: ", compatible)  # Should print: true

    # Get migration chain
    var chain = MigrationManager.get_migration_chain("2.0")
    print("Migration chain: ", chain)  # Should print: [2.0, 2.0.1, 2.1]

    # Get statistics
    var stats = MigrationManager.get_statistics()
    print("Migrations: ", stats.total_migrations)
```

### Test SaveManager

```gdscript
func _ready():
    # Save game
    SaveManager.save_game(0)
    print("Game saved")

    # Load game
    SaveManager.load_game(0)
    print("Game loaded")

    # Check logs
    # Should see encrypted save messages in Logger output
```

---

## 🔒 Security Configuration

### Change Encryption Password (PRODUCTION)

**⚠️ IMPORTANT:** Before release, change the default encryption password!

Edit `scripts/SaveManager.gd`:

```gdscript
# BEFORE (Default - INSECURE!)
const SAVE_PASSWORD = "SpaceGameDev_SaveEncryption_v2.1_SecureKey_2025"

# AFTER (Your Secure Key)
const SAVE_PASSWORD = "YourUniqueSecurePasswordHere_ChangeThis_v2.1"
```

**Best Practices:**
- Use a long, random password (32+ characters)
- Include letters, numbers, and symbols
- Don't commit the password to public repositories
- Consider using environment variables for production

**Advanced:** Derive password from game key:

```gdscript
# Generate from game-specific data
const GAME_KEY = "SpaceGameDev_UniqueKey"
var SAVE_PASSWORD: String

func _ready():
    # Derive password from game key + version
    var data = (GAME_KEY + Engine.get_version_info().string).to_utf8_buffer()
    var hash = HashingContext.new()
    hash.start(HashingContext.HASH_SHA256)
    hash.update(data)
    SAVE_PASSWORD = hash.finish().hex_encode()
```

### Disable Encryption (DEBUGGING ONLY)

To view save files in plain JSON (debugging only):

Edit `scripts/SaveManager.gd`:

```gdscript
# Encryption toggle (for debugging - disable to view save files)
var encryption_enabled: bool = false  # Changed from true
```

**⚠️ WARNING:** Never ship with encryption disabled!

---

## 📊 Logger Configuration

### Change Log Level

Edit `scripts/autoload/Logger.gd`:

```gdscript
# Minimum log level to output
var log_level: LogLevel = LogLevel.INFO  # Changed from DEBUG
```

**Log Levels:**
- `LogLevel.DEBUG` - All logs (verbose, debug builds only)
- `LogLevel.INFO` - Informational + warnings + errors
- `LogLevel.WARNING` - Warnings + errors only
- `LogLevel.ERROR` - Errors only
- `LogLevel.CRITICAL` - Critical errors only

### Disable File Logging

Edit `scripts/autoload/Logger.gd`:

```gdscript
# Enable file logging (disk writes)
var log_to_file: bool = false  # Changed from true
```

### Filter by Category

Only log specific categories:

```gdscript
func _ready():
    # Only log Player and Combat categories
    Logger.enabled_categories = ["Player", "Combat"]

    Logger.info("Player", "This will be logged")
    Logger.info("Database", "This will be IGNORED")
```

### Change Log File Location

Edit `scripts/autoload/Logger.gd`:

```gdscript
const LOG_FILE_PATH = "user://custom_logs/game.log"  # Changed from user://logs/game.log
```

---

## 🗂️ File Locations

After configuration, logs and saves will be stored in platform-specific locations:

### Windows
```
%APPDATA%\Godot\app_userdata\SpaceGameDev\
├── logs\
│   ├── game.log
│   ├── game.log.1
│   └── game.log.2
└── saves\
    ├── save_slot_0.save (encrypted)
    ├── save_slot_1.save
    ├── autosave_0.save
    └── backups\
        ├── save_slot_0_2025-11-18T10-30-00.save
        └── ...
```

### Linux
```
~/.local/share/godot/app_userdata/SpaceGameDev/
├── logs/
└── saves/
```

### macOS
```
~/Library/Application Support/Godot/app_userdata/SpaceGameDev/
├── logs/
└── saves/
```

---

## 🐛 Troubleshooting

### "Logger not found" Error

**Problem:** Logger autoload not registered

**Solution:**
1. Check `project.godot` has `Logger="*res://scripts/autoload/Logger.gd"`
2. Restart Godot Editor
3. Verify file exists at correct path

### "Could not open save file" Error

**Problem:** Wrong encryption password or corrupted file

**Solution:**
1. Check SAVE_PASSWORD matches between save and load
2. Try loading with encryption disabled (debugging)
3. Restore from backup in `user://saves/backups/`

### Save Files Not Encrypting

**Problem:** `encryption_enabled = false`

**Solution:**
1. Edit `scripts/SaveManager.gd`
2. Set `var encryption_enabled: bool = true`
3. Delete old unencrypted saves
4. Save again

### Logs Not Appearing

**Problem:** Log level too high or category filtered

**Solution:**
1. Check `Logger.log_level` (set to `LogLevel.DEBUG` for all logs)
2. Check `Logger.enabled_categories` (empty = all enabled)
3. Verify `Logger.logging_enabled = true`

### Migration Failing

**Problem:** Incompatible save version

**Solution:**
1. Check save file version: Open in text editor (if not encrypted)
2. Verify version in `COMPATIBLE_VERSIONS` array
3. Check MigrationManager has migration function for that version
4. View logs for detailed error messages

---

## 📖 Usage Examples

### Basic Logging

```gdscript
# scripts/Player.gd
extends CharacterBody2D

func _ready():
    Logger.info("Player", "Player initialized")

func take_damage(amount: float):
    Logger.warning("Player", "Took damage: %.1f HP" % amount)

    if health <= 0:
        Logger.error("Player", "Player died!")
```

### Performance Logging

```gdscript
func expensive_operation():
    var start_time = Time.get_ticks_msec()

    # ... do expensive work ...

    var elapsed = Time.get_ticks_msec() - start_time
    Logger.log_performance("MySystem", "Expensive operation", elapsed)
```

### Save/Load with Logging

```gdscript
func _on_save_button_pressed():
    Logger.info("UI", "User clicked save button")

    if SaveManager.save_game(0):
        Logger.info("UI", "Save successful")
        show_notification("Game saved!")
    else:
        Logger.error("UI", "Save failed")
        show_error("Failed to save game")
```

### Migration Status

```gdscript
func _on_load_button_pressed():
    var slot = 0

    # Check if migration needed
    var save_info = SaveManager.get_save_info(slot)
    if save_info.version != SaveManager.SAVE_VERSION:
        var chain = MigrationManager.get_migration_chain(save_info.version)
        Logger.info("UI", "Will migrate save: %s" % " → ".join(chain))

    # Load (migration happens automatically)
    SaveManager.load_game(slot)
```

---

## ✅ Post-Configuration Checklist

- [ ] Logger autoload added to project.godot
- [ ] MigrationManager autoload added to project.godot
- [ ] Autoloads in correct order (Logger first)
- [ ] Encryption password changed (production only)
- [ ] Log level configured (INFO or WARNING for release)
- [ ] File logging enabled (production)
- [ ] Tested Logger with debug prints
- [ ] Tested SaveManager save/load
- [ ] Tested migration with old save
- [ ] Verified log files created in user://logs/
- [ ] Verified encrypted saves in user://saves/
- [ ] Verified backups in user://saves/backups/

---

## 🔄 Reverting Changes (If Needed)

If you need to revert to the old system:

1. **Remove Autoloads:**
   - Delete `Logger="*res://scripts/autoload/Logger.gd"` from project.godot
   - Delete `MigrationManager="*res://scripts/autoload/MigrationManager.gd"` from project.godot

2. **Revert SaveManager:**
   - Checkout previous version of `scripts/SaveManager.gd`
   - Or set `encryption_enabled = false` to load old saves

3. **Load Old Saves:**
   - Old unencrypted saves will load automatically with encryption disabled
   - Or use backup files in `user://saves/backups/`

---

## 📞 Support

If you encounter issues:

1. **Check Logs:** `user://logs/game.log` for error messages
2. **Check Documentation:** See IMPLEMENTATION_SUMMARY.md
3. **Check Examples:** See docs/analysis/ for detailed system docs
4. **File Issue:** Report on GitHub with log files attached

---

**Configuration Guide Version:** 1.0
**Last Updated:** 2025-11-18
**Branch:** `claude/ai-max-evolution-01RK2D3QTD62zFokAUVEE5r7`
