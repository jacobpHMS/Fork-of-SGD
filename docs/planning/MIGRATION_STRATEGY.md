# Migration Strategy

**Project:** SpaceGameDev
**From Version:** 2.0 (Current)
**To Version:** 2.1+ (Evolution Branch)
**Migration Date:** 2025-11-18

---

## 📋 Overview

This document outlines the **migration strategy** for upgrading SpaceGameDev from version 2.0 to the evolved 2.1+ architecture with:
- Enhanced error handling
- Refactored architecture
- Testing framework
- Security improvements
- Performance optimizations

---

## 🎯 Migration Goals

### Technical Goals
- ✅ **Zero Breaking Changes** for existing saves
- ✅ **Backward Compatibility** for v2.0 save files
- ✅ **Gradual Migration** (not big-bang)
- ✅ **Rollback Capability** if issues arise

### User Experience Goals
- ✅ **Seamless Upgrade** (automatic migration)
- ✅ **No Data Loss** from existing saves
- ✅ **Improved Performance** (faster, smoother)
- ✅ **Better Feedback** (error messages, warnings)

---

## 🔄 Migration Phases

### Phase 1: Preparation (Week 1)
**Goal:** Set up migration infrastructure

```gdscript
# scripts/autoload/MigrationManager.gd (NEW)
## Handles version migration for save files and game data
##
## Automatically detects save file version and applies
## necessary transformations to upgrade to current version.
##
## Usage:
##   MigrationManager.migrate_save_data(old_data, "2.0")
class_name MigrationManager
extends Node

const CURRENT_VERSION = "2.1"
const COMPATIBLE_VERSIONS = ["2.0", "2.0.1", "2.1"]

## Version migration registry
## Maps old_version -> migration_function
var _migrations: Dictionary = {
    "2.0": _migrate_2_0_to_2_0_1,
    "2.0.1": _migrate_2_0_1_to_2_1,
}

func migrate_save_data(data: Dictionary, from_version: String) -> Dictionary:
    """
    Migrates save data from old version to current.

    Applies all necessary migrations in sequence.
    For example, 2.0 → 2.0.1 → 2.1

    Args:
        data: Save data dictionary
        from_version: Original save file version

    Returns:
        Migrated data dictionary with updated version

    Errors:
        Logs error and returns original data if migration fails
    """
    if from_version == CURRENT_VERSION:
        Logger.info("Migration", "Save data already at current version %s" % CURRENT_VERSION)
        return data

    if from_version not in COMPATIBLE_VERSIONS:
        Logger.error("Migration", "Incompatible save version: %s" % from_version)
        push_error("Save file version %s is not compatible with game version %s" % [
            from_version, CURRENT_VERSION
        ])
        return data

    var migrated_data = data.duplicate(true)
    var current_version = from_version

    # Apply migrations in sequence
    while current_version != CURRENT_VERSION:
        if not _migrations.has(current_version):
            Logger.error("Migration", "No migration path from %s" % current_version)
            break

        Logger.info("Migration", "Migrating from %s to next version..." % current_version)
        migrated_data = _migrations[current_version].call(migrated_data)
        current_version = migrated_data.version

    migrated_data.version = CURRENT_VERSION
    Logger.info("Migration", "Migration complete: %s → %s" % [from_version, CURRENT_VERSION])
    return migrated_data

func _migrate_2_0_to_2_0_1(data: Dictionary) -> Dictionary:
    """
    Migrates v2.0 save data to v2.0.1

    Changes:
    - Add checksum field
    - Add timestamp field
    - Encrypt sensitive data (future)
    """
    Logger.info("Migration", "Applying v2.0 → v2.0.1 migration")

    # Add new fields
    data.checksum = _calculate_checksum(data)
    data.timestamp = Time.get_datetime_string_from_system()
    data.version = "2.0.1"

    # No structural changes needed
    return data

func _migrate_2_0_1_to_2_1(data: Dictionary) -> Dictionary:
    """
    Migrates v2.0.1 save data to v2.1

    Changes:
    - Refactor cargo structure (if needed)
    - Add new skill fields
    - Update temperature data format
    """
    Logger.info("Migration", "Applying v2.0.1 → v2.1 migration")

    # Example: Add new skill fields with defaults
    if data.has("skills"):
        for skill_id in data.skills:
            if not data.skills[skill_id].has("mastery_level"):
                data.skills[skill_id].mastery_level = 0

    # Update cargo structure (if refactored)
    if data.has("cargo") and typeof(data.cargo) == TYPE_ARRAY:
        # Convert old array format to new dictionary format
        var new_cargo = {}
        for item in data.cargo:
            if not new_cargo.has(item.id):
                new_cargo[item.id] = 0
            new_cargo[item.id] += item.quantity
        data.cargo = new_cargo

    data.version = "2.1"
    return data

func _calculate_checksum(data: Dictionary) -> String:
    """Calculates SHA-256 checksum of save data"""
    var data_copy = data.duplicate(true)
    data_copy.erase("checksum")

    var json_string = JSON.stringify(data_copy)
    var hash = HashingContext.new()
    hash.start(HashingContext.HASH_SHA256)
    hash.update(json_string.to_utf8_buffer())
    return hash.finish().hex_encode()
```

**Tasks:**
- [ ] Create MigrationManager autoload (2h)
- [ ] Add version field to all saves (1h)
- [ ] Create backup system (2h)
- [ ] Test migration pipeline (2h)

**Deliverables:**
- MigrationManager.gd
- Version detection system
- Automatic backup before migration

---

### Phase 2: Code Migration (Weeks 2-4)
**Goal:** Refactor code gradually without breaking changes

#### Strategy: Feature Flag Pattern

```gdscript
# scripts/config/FeatureFlags.gd (NEW)
## Feature flags for gradual rollout of new systems
##
## Allows enabling/disabling new features without code changes.
## Useful for A/B testing and gradual migration.
class_name FeatureFlags
extends Node

# Critical Systems (v2.0.1)
const ENCRYPTED_SAVES = true  # Enable encrypted save files
const ERROR_HANDLING = true   # Enhanced error handling
const LOGGER_SYSTEM = true    # Structured logging

# Refactored Systems (v2.1)
const NEW_UI_PANELS = false   # Split PermanentInfoPanel
const LAZY_DATABASE_LOADING = false  # On-demand database loading
const PERFORMANCE_MONITORING = false  # Performance metrics

# Advanced Features (v2.2+)
const COMBAT_AI_ENABLED = false  # New combat AI
const TRADE_AI_ENABLED = false   # New trade AI
const MISSION_SYSTEM_ENABLED = false  # Mission system

func is_enabled(feature: String) -> bool:
    """
    Checks if a feature is enabled.

    Args:
        feature: Feature flag name (e.g., "ENCRYPTED_SAVES")

    Returns:
        True if feature enabled, false otherwise
    """
    if has(feature):
        return get(feature)
    push_warning("Unknown feature flag: " + feature)
    return false
```

**Usage Example:**
```gdscript
# SaveManager.gd
func save_game(slot_name: String) -> Error:
    if FeatureFlags.is_enabled("ENCRYPTED_SAVES"):
        return _save_encrypted(slot_name)
    else:
        return _save_plain(slot_name)  # Old method

# Main.gd
func _ready():
    if FeatureFlags.is_enabled("NEW_UI_PANELS"):
        _setup_new_ui_panels()
    else:
        _setup_old_ui()  # Fallback to v2.0 UI
```

**Benefits:**
- ✅ Test new features in production
- ✅ Easy rollback if issues found
- ✅ Gradual user migration
- ✅ A/B testing capability

---

### Phase 3: Database Migration (Week 3)
**Goal:** Migrate database format without data loss

#### Database Versioning

```gdscript
# database/schema_version.txt (NEW)
3

# scripts/autoload/GameData.gd
const DATABASE_VERSION = 3

func _ready():
    _check_database_version()
    _load_all_databases()

func _check_database_version():
    """Validates database schema version"""
    var version_file = FileAccess.open("res://database/schema_version.txt", FileAccess.READ)
    if version_file == null:
        push_error("Database version file missing!")
        return

    var db_version = version_file.get_line().to_int()
    if db_version != DATABASE_VERSION:
        push_error("Database version mismatch: expected %d, got %d" % [
            DATABASE_VERSION, db_version
        ])
```

#### Database Migration Scripts

```
database/migrations/
├── 001_add_ore_quality.sql
├── 002_refactor_crafting_recipes.sql
└── 003_add_faction_data.sql
```

**Migration Process:**
1. Detect current database version
2. Apply migrations sequentially
3. Update version file
4. Validate data integrity

**Example Migration:**
```
# database/migrations/002_refactor_crafting_recipes.sql
-- Add new columns to crafting_recipes.tsv
ALTER TABLE crafting_recipes ADD COLUMN skill_requirement INT DEFAULT 0;
ALTER TABLE crafting_recipes ADD COLUMN crafting_time FLOAT DEFAULT 1.0;

-- Update existing recipes
UPDATE crafting_recipes SET skill_requirement = 10 WHERE tier >= 3;
UPDATE crafting_recipes SET crafting_time = tier * 2.0;
```

---

### Phase 4: Save File Migration (Week 4)
**Goal:** Migrate all player save files automatically

#### Automatic Migration on Load

```gdscript
# scripts/autoload/SaveManager.gd
func load_game(slot_name: String) -> Error:
    """
    Loads game with automatic migration.

    Detects save file version and applies necessary migrations
    before loading. Creates backup before migration.
    """
    var save_path = _get_save_path(slot_name)

    # Check file exists
    if not FileAccess.file_exists(save_path):
        Logger.error("SaveManager", "Save file not found: " + save_path)
        return ERR_FILE_NOT_FOUND

    # Load save data
    var save_data = _load_save_file(save_path)
    if save_data == null:
        return ERR_FILE_CORRUPT

    # Detect version
    var save_version = save_data.get("version", "2.0")  # Default to v2.0 for old saves

    # Create backup before migration
    if save_version != MigrationManager.CURRENT_VERSION:
        _create_backup(slot_name, save_data)

    # Migrate if necessary
    if save_version != MigrationManager.CURRENT_VERSION:
        Logger.info("SaveManager", "Migrating save from v%s to v%s" % [
            save_version, MigrationManager.CURRENT_VERSION
        ])

        save_data = MigrationManager.migrate_save_data(save_data, save_version)

        # Save migrated data
        _save_migrated_data(slot_name, save_data)

    # Apply to game state
    _apply_save_data(save_data)
    Logger.info("SaveManager", "Game loaded successfully (version %s)" % save_data.version)
    return OK

func _create_backup(slot_name: String, save_data: Dictionary):
    """Creates backup of save file before migration"""
    var backup_path = "user://saves/backups/%s_%s.backup" % [
        slot_name,
        Time.get_datetime_string_from_system().replace(":", "-")
    ]

    # Create backups directory
    if not DirAccess.dir_exists_absolute("user://saves/backups"):
        DirAccess.make_dir_recursive_absolute("user://saves/backups")

    # Save backup
    var file = FileAccess.open(backup_path, FileAccess.WRITE)
    file.store_string(JSON.stringify(save_data))
    file.close()

    Logger.info("SaveManager", "Backup created: " + backup_path)
```

#### Migration Validation

```gdscript
func _validate_migrated_data(data: Dictionary) -> bool:
    """
    Validates migrated save data.

    Checks:
    - Required fields present
    - Data types correct
    - Values in valid ranges

    Returns:
        True if valid, false otherwise
    """
    # Check required fields
    var required_fields = ["version", "player", "timestamp"]
    for field in required_fields:
        if not data.has(field):
            Logger.error("SaveManager", "Missing required field: " + field)
            return false

    # Validate player data
    if not data.player.has("credits") or typeof(data.player.credits) != TYPE_FLOAT:
        Logger.error("SaveManager", "Invalid player credits")
        return false

    # Validate ranges
    if data.player.credits < 0:
        Logger.warning("SaveManager", "Negative credits detected, resetting to 0")
        data.player.credits = 0.0

    # All checks passed
    return true
```

---

### Phase 5: Testing & Validation (Week 5)
**Goal:** Ensure migration works correctly

#### Test Cases

```gdscript
# tests/integration/test_migration.gd
extends GutTest

func test_migrate_v2_0_to_v2_1():
    """Should successfully migrate v2.0 save to v2.1"""
    # Arrange
    var v2_0_save = {
        "version": "2.0",
        "player": {
            "credits": 1000.0,
            "position": {"x": 100, "y": 200}
        },
        "cargo": [  # Old array format
            {"id": "iron_ore", "quantity": 50},
            {"id": "iron_ore", "quantity": 30}
        ]
    }

    # Act
    var migrated = MigrationManager.migrate_save_data(v2_0_save, "2.0")

    # Assert
    assert_eq(migrated.version, "2.1", "Should update version")
    assert_has(migrated, "checksum", "Should add checksum")
    assert_has(migrated, "timestamp", "Should add timestamp")
    assert_typeof(migrated.cargo, TYPE_DICTIONARY, "Should convert cargo to dictionary")
    assert_eq(migrated.cargo.iron_ore, 80, "Should sum duplicate cargo items")

func test_migration_creates_backup():
    """Should create backup before migration"""
    # Arrange
    var slot_name = "test_slot"
    var save_data = _create_v2_0_save()

    # Act
    SaveManager._create_backup(slot_name, save_data)

    # Assert
    var backup_path = "user://saves/backups/%s_*.backup" % slot_name
    var backups = _find_files_matching(backup_path)
    assert_gt(backups.size(), 0, "Should create backup file")

func test_rollback_on_migration_failure():
    """Should restore backup if migration fails"""
    # Arrange
    var slot_name = "test_slot_corrupt"
    var corrupt_save = {"version": "2.0", "invalid": "data"}

    # Act
    var result = SaveManager.load_game(slot_name)

    # Assert
    assert_eq(result, ERR_FILE_CORRUPT, "Should detect corrupted data")
    # Verify backup still exists
    var backup_exists = FileAccess.file_exists("user://saves/backups/%s_*.backup" % slot_name)
    assert_true(backup_exists, "Should preserve backup on failure")
```

---

## 🔄 Rollback Strategy

### Automatic Rollback

```gdscript
# scripts/autoload/SaveManager.gd
func rollback_migration(slot_name: String) -> Error:
    """
    Rolls back to previous save version.

    Restores most recent backup and discards migrated data.

    Args:
        slot_name: Save slot to rollback

    Returns:
        OK if successful, ERR_* otherwise
    """
    # Find most recent backup
    var backup_path = _find_latest_backup(slot_name)
    if backup_path == "":
        Logger.error("SaveManager", "No backup found for slot: " + slot_name)
        return ERR_FILE_NOT_FOUND

    # Load backup
    var backup_data = _load_save_file(backup_path)
    if backup_data == null:
        return ERR_FILE_CORRUPT

    # Restore backup to main save
    var save_path = _get_save_path(slot_name)
    var file = FileAccess.open(save_path, FileAccess.WRITE)
    file.store_string(JSON.stringify(backup_data))
    file.close()

    Logger.info("SaveManager", "Rollback successful: restored backup from %s" % backup_path)
    return OK
```

### Manual Rollback UI

```gdscript
# scenes/ui/SaveManagerUI.tscn
# Add "Restore Backup" button in save slot menu

func _on_restore_backup_pressed():
    """User clicks 'Restore Backup' button"""
    var slot_name = _get_selected_slot()

    var confirm = ConfirmationDialog.new()
    confirm.dialog_text = "Restore save file from backup?\nThis will discard current save data."
    confirm.confirmed.connect(func():
        var result = SaveManager.rollback_migration(slot_name)
        if result == OK:
            _show_notification("Backup restored successfully")
        else:
            _show_error("Failed to restore backup")
    )
    add_child(confirm)
    confirm.popup_centered()
```

---

## 📊 Migration Metrics

### Track Migration Success

```gdscript
# scripts/autoload/MigrationManager.gd
var _migration_stats: Dictionary = {
    "total_migrations": 0,
    "successful": 0,
    "failed": 0,
    "rollbacks": 0,
    "average_time_ms": 0.0
}

func migrate_save_data(data: Dictionary, from_version: String) -> Dictionary:
    var start_time = Time.get_ticks_msec()
    _migration_stats.total_migrations += 1

    var result = _perform_migration(data, from_version)

    if result.has("error"):
        _migration_stats.failed += 1
        Logger.error("Migration", "Migration failed: " + result.error)
        return data
    else:
        _migration_stats.successful += 1

    var elapsed = Time.get_ticks_msec() - start_time
    _migration_stats.average_time_ms = (
        (_migration_stats.average_time_ms * (_migration_stats.successful - 1) + elapsed)
        / _migration_stats.successful
    )

    Logger.info("Migration", "Migration completed in %d ms" % elapsed)
    return result

func get_migration_stats() -> Dictionary:
    """Returns migration statistics for analytics"""
    return _migration_stats.duplicate()
```

---

## 🎯 Success Criteria

### Technical Success
- ✅ 100% of v2.0 saves migrate successfully
- ✅ Zero data loss during migration
- ✅ Migration completes in < 1 second
- ✅ Automatic backups created
- ✅ Rollback works correctly

### User Experience Success
- ✅ Migration happens automatically (no user action)
- ✅ Users see progress indicator if migration takes >1s
- ✅ Clear error messages if migration fails
- ✅ Easy rollback option if issues occur

---

## 📋 Migration Checklist

### Pre-Migration
- [ ] MigrationManager implemented and tested
- [ ] FeatureFlags system in place
- [ ] Backup system working
- [ ] Rollback tested
- [ ] Migration validation tests passing

### During Migration
- [ ] Version detection working
- [ ] Migrations applied in correct order
- [ ] Backups created before migration
- [ ] Progress feedback shown to user
- [ ] Validation checks passed

### Post-Migration
- [ ] Save files migrated successfully
- [ ] Game loads without errors
- [ ] All features functional
- [ ] Performance metrics acceptable
- [ ] User feedback collected

---

## 🚨 Risk Mitigation

### Risk 1: Data Loss
**Mitigation:**
- Automatic backups before migration
- Validation checks after migration
- Rollback capability
- Test on copy of production data

### Risk 2: Migration Failures
**Mitigation:**
- Comprehensive error handling
- Graceful degradation (load with warnings)
- Clear error messages
- Manual migration tools

### Risk 3: Performance Issues
**Mitigation:**
- Migrate in background thread
- Show progress indicator
- Optimize migration code
- Batch processing for large saves

### Risk 4: Breaking Changes
**Mitigation:**
- Feature flags for new systems
- Backward compatibility layer
- Comprehensive testing
- Gradual rollout

---

## 📖 User Communication

### Migration Notice

```
╔════════════════════════════════════════════════════════╗
║         SPACEGAMEDEV VERSION 2.1 UPDATE               ║
╠════════════════════════════════════════════════════════╣
║                                                        ║
║  Your save files will be automatically updated to     ║
║  the new format. This is a one-time process.          ║
║                                                        ║
║  • Backup created: user://saves/backups/               ║
║  • Estimated time: < 1 second                         ║
║  • No action required                                 ║
║                                                        ║
║  What's New:                                          ║
║  ✓ Enhanced security (encrypted saves)                ║
║  ✓ Better performance (faster loading)                ║
║  ✓ Improved stability (error handling)                ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
```

### Migration Progress

```
Migrating save file...
├─ Backing up original file... ✓
├─ Detecting version (2.0)... ✓
├─ Applying migration 2.0 → 2.0.1... ✓
├─ Applying migration 2.0.1 → 2.1... ✓
├─ Validating migrated data... ✓
└─ Complete! (450 ms)
```

---

**Migration Strategy Version:** 2.0-evolution
**Last Updated:** 2025-11-18
**Next Review:** After each major version release
**Document Owner:** Development Team
