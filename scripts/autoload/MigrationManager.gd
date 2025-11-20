extends Node
## Save file and game data migration manager
##
## Handles automatic version migration for save files and game data structures.
## Detects save file version and applies necessary transformations to upgrade
## to the current game version without data loss.
##
## Features:
## - Automatic version detection
## - Sequential migration chain (v2.0 → v2.0.1 → v2.1 → etc.)
## - Backup creation before migration
## - Rollback capability if migration fails
## - Data validation and integrity checks
## - Migration statistics and logging
##
## Migration Philosophy:
## - **Backward Compatibility:** Old saves always loadable
## - **No Data Loss:** All user data preserved
## - **Automatic:** No user intervention required
## - **Safe:** Backups created, rollback available
## - **Logged:** All migrations tracked for debugging
##
## Usage:
##   # In SaveManager.load_game()
##   var save_data = load_json_file(path)
##   var save_version = save_data.get("version", "2.0")
##
##   if save_version != MigrationManager.CURRENT_VERSION:
##       save_data = MigrationManager.migrate_save_data(save_data, save_version)
##
##   apply_save_data(save_data)
##
## Adding New Migrations:
##   1. Increment CURRENT_VERSION
##   2. Add migration function _migrate_X_to_Y()
##   3. Register in _migrations dictionary
##   4. Update COMPATIBLE_VERSIONS
##   5. Test migration path
##
## Migration Function Template:
##   func _migrate_X_to_Y(data: Dictionary) -> Dictionary:
##       print("Migration", "Applying vX → vY migration")
##       # ... transform data ...
##       data.version = "Y"
##       return data
##
## @author SpaceGameDev Team
## @version 2.0.1
## @since 2025-11-18

# ============================================================================
# CONSTANTS
# ============================================================================

## Current game version (update when adding new migrations)
const CURRENT_VERSION = "2.1"

## List of compatible save file versions
## Older versions not in this list cannot be loaded
const COMPATIBLE_VERSIONS = ["2.0", "2.0.1", "2.1"]

## Maximum migration chain length (safety limit)
const MAX_MIGRATION_STEPS = 10

# ============================================================================
# MIGRATION REGISTRY
# ============================================================================

## Version migration registry
## Maps source_version → migration_function
## Each function transforms data from one version to the next
var _migrations: Dictionary = {
	"2.0": _migrate_2_0_to_2_0_1,
	"2.0.1": _migrate_2_0_1_to_2_1,
}

# ============================================================================
# STATISTICS
# ============================================================================

var _migration_stats: Dictionary = {
	"total_migrations": 0,
	"successful": 0,
	"failed": 0,
	"total_time_ms": 0.0,
	"average_time_ms": 0.0
}

# ============================================================================
# PUBLIC API
# ============================================================================

func migrate_save_data(data: Dictionary, from_version: String) -> Dictionary:
	"""
	Migrates save data from old version to current version.

	Applies all necessary migrations in sequence to bring save data
	up to the current game version. Creates backup and validates data.

	Migration Chain Example:
		v2.0 → v2.0.1 → v2.1 (current)

	Args:
		data: Save data dictionary from JSON file
		from_version: Original save file version string

	Returns:
		Migrated data dictionary with updated version field
		Original data if migration fails (with error logged)

	Errors:
		Logs error and returns original data if:
		- Source version incompatible
		- Migration function not found
		- Migration exceeds MAX_MIGRATION_STEPS
		- Data validation fails after migration

	Side Effects:
		- Updates _migration_stats
		- Logs all migration steps
		- May modify input data dictionary

	Example:
		var save_data = {"version": "2.0", "player": {...}}
		var migrated = MigrationManager.migrate_save_data(save_data, "2.0")
		# migrated.version == "2.1"
	"""
	var start_time = Time.get_ticks_msec()
	_migration_stats.total_migrations += 1

	# Check if already at current version
	if from_version == CURRENT_VERSION:
		print("Migration", "Save data already at current version %s" % CURRENT_VERSION)
		return data

	# Check if version is compatible
	if from_version not in COMPATIBLE_VERSIONS:
		push_error("Migration", "Incompatible save version: %s (compatible: %s)" % [
			from_version, ", ".join(COMPATIBLE_VERSIONS)
		])
		_migration_stats.failed += 1
		return data

	print("Migration", "Starting migration: %s → %s" % [from_version, CURRENT_VERSION])

	# Create deep copy to avoid mutating original
	var migrated_data = data.duplicate(true)
	var current_version = from_version
	var steps = 0

	# Apply migrations sequentially
	while current_version != CURRENT_VERSION:
		# Safety check: Prevent infinite loops
		steps += 1
		if steps > MAX_MIGRATION_STEPS:
			push_error("Migration", "Migration chain exceeded %d steps! Aborting." % MAX_MIGRATION_STEPS)
			_migration_stats.failed += 1
			return data

		# Check if migration exists
		if not _migrations.has(current_version):
			push_error("Migration", "No migration path from version %s" % current_version)
			_migration_stats.failed += 1
			return data

		# Apply migration
		print("Migration", "Applying migration: %s → next version (step %d)" % [current_version, steps])
		var migration_func = _migrations[current_version]
		migrated_data = migration_func.call(migrated_data)

		# Verify version was updated
		if not migrated_data.has("version"):
			push_error("Migration", "Migration failed: version field missing after migration")
			_migration_stats.failed += 1
			return data

		current_version = migrated_data.version

	# Final validation
	if not _validate_migrated_data(migrated_data):
		push_error("Migration", "Migration validation failed")
		_migration_stats.failed += 1
		return data

	# Update statistics
	_migration_stats.successful += 1
	var elapsed = Time.get_ticks_msec() - start_time
	_migration_stats.total_time_ms += elapsed
	_migration_stats.average_time_ms = _migration_stats.total_time_ms / _migration_stats.successful

	print("Migration", "Migration complete: %s → %s (%d steps, %.0f ms)" % [
		from_version, CURRENT_VERSION, steps, elapsed
	])

	return migrated_data

func is_version_compatible(version: String) -> bool:
	"""
	Checks if a save file version is compatible with current game.

	Args:
		version: Save file version string

	Returns:
		True if version can be migrated, false otherwise

	Example:
		if MigrationManager.is_version_compatible("2.0"):
			# Can load and migrate
		else:
			# Cannot load, show error
	"""
	return version in COMPATIBLE_VERSIONS or version == CURRENT_VERSION

func get_migration_chain(from_version: String) -> Array[String]:
	"""
	Returns the migration chain from source version to current.

	Useful for showing user what migrations will be applied.

	Args:
		from_version: Source version

	Returns:
		Array of version strings representing migration path
		Empty array if version incompatible

	Example:
		var chain = MigrationManager.get_migration_chain("2.0")
		# Returns ["2.0", "2.0.1", "2.1"]
	"""
	if not is_version_compatible(from_version):
		return []

	if from_version == CURRENT_VERSION:
		return [CURRENT_VERSION]

	var chain: Array[String] = [from_version]
	var current = from_version

	while current != CURRENT_VERSION and _migrations.has(current):
		# Simulate migration to find next version
		var temp_data = {"version": current}
		temp_data = _migrations[current].call(temp_data)
		current = temp_data.version
		chain.append(current)

	return chain

func get_statistics() -> Dictionary:
	"""
	Returns migration statistics for analytics.

	Returns:
		Dictionary with keys:
		- total_migrations: Total migration attempts
		- successful: Successful migrations
		- failed: Failed migrations
		- total_time_ms: Total migration time
		- average_time_ms: Average time per migration

	Example:
		var stats = MigrationManager.get_statistics()
		print("Stats", "Migration success rate: %.1f%%" % (
			100.0 * stats.successful / stats.total_migrations
		))
	"""
	return _migration_stats.duplicate()

# ============================================================================
# MIGRATION FUNCTIONS
# ============================================================================

func _migrate_2_0_to_2_0_1(data: Dictionary) -> Dictionary:
	"""
	Migrates save data from v2.0 to v2.0.1

	Changes:
	- Add checksum field for integrity validation
	- Add timestamp field for save file tracking
	- Add session_id for multi-session tracking
	- Prepare for future encryption

	Args:
		data: v2.0 save data

	Returns:
		v2.0.1 save data with new fields
	"""
	print("Migration", "Applying v2.0 → v2.0.1 migration")

	# Add new metadata fields
	data.timestamp = Time.get_datetime_string_from_system()
	data.session_id = Time.get_ticks_msec()  # Unique session identifier
	data.game_version = "2.0.1"  # Game version that created this save

	# Calculate checksum (for future integrity validation)
	# Note: Checksum calculated AFTER adding new fields
	data.checksum = _calculate_checksum(data)

	# Update version
	data.version = "2.0.1"

	print("Migration", "Added metadata: timestamp, session_id, checksum")

	return data

func _migrate_2_0_1_to_2_1(data: Dictionary) -> Dictionary:
	"""
	Migrates save data from v2.0.1 to v2.1

	Changes:
	- Convert cargo from array format to dictionary format (if needed)
	- Add mastery_level field to all skills
	- Add protected_values for anti-cheat (credits, skills)
	- Restructure temperature tracking data
	- Add new achievement tracking fields

	Args:
		data: v2.0.1 save data

	Returns:
		v2.1 save data with updated structures
	"""
	print("Migration", "Applying v2.0.1 → v2.1 migration")

	# --- Skill System Updates ---
	if data.has("skills"):
		print("Migration", "Upgrading skill system...")
		for skill_id in data.skills:
			var skill = data.skills[skill_id]

			# Add mastery_level if missing (new feature)
			if not skill.has("mastery_level"):
				skill.mastery_level = 0
				print("Migration", "Added mastery_level to skill: %s" % skill_id)

			# Add XP tracking if missing
			if not skill.has("total_xp"):
				skill.total_xp = skill.get("xp", 0)

	# --- Cargo System Refactoring ---
	if data.has("cargo"):
		print("Migration", "Migrating cargo format...")

		# Check if cargo is old array format
		if typeof(data.cargo) == TYPE_ARRAY:
			print("Migration", "Converting cargo from array to dictionary format")

			# Convert array of items to dictionary (sum quantities)
			var new_cargo = {}
			for item in data.cargo:
				var item_id = item.get("id", "unknown")
				var quantity = item.get("quantity", 0)

				if not new_cargo.has(item_id):
					new_cargo[item_id] = 0
				new_cargo[item_id] += quantity

			data.cargo = new_cargo
			print("Migration", "Cargo converted: %d unique items" % new_cargo.size())

	# --- Temperature System Update ---
	if data.has("temperature_data"):
		print("Migration", "Updating temperature system...")

		# Old format: Single temperature value
		# New format: Per-system temperature tracking
		if typeof(data.temperature_data) == TYPE_FLOAT:
			var old_temp = data.temperature_data
			data.temperature_data = {
				"hull": old_temp,
				"systems": old_temp,
				"cargo": old_temp * 0.8,  # Cargo slightly cooler
				"last_update": Time.get_ticks_msec()
			}
			print("Migration", "Temperature data restructured")

	# --- Achievement System (New Feature) ---
	if not data.has("achievements"):
		print("Migration", "Adding achievement tracking...")
		data.achievements = {
			"unlocked": [],
			"progress": {},
			"last_unlock_time": 0
		}

	# --- Protected Values (Anti-Cheat) ---
	# Wrap sensitive values in checksums
	if data.has("player"):
		var player = data.player

		# Protect credits
		if player.has("credits"):
			player.credits_checksum = hash(player.credits)

		# Protect skill points
		if data.has("skills"):
			var total_skill_points = 0
			for skill in data.skills.values():
				total_skill_points += skill.get("level", 0)
			data.total_skill_points = total_skill_points
			data.total_skill_points_checksum = hash(total_skill_points)

	# --- Update Metadata ---
	data.game_version = "2.1"
	data.migration_applied = Time.get_datetime_string_from_system()

	# Recalculate checksum with new data
	data.checksum = _calculate_checksum(data)

	# Update version
	data.version = "2.1"

	print("Migration", "v2.0.1 → v2.1 migration complete")

	return data

# ============================================================================
# VALIDATION
# ============================================================================

func _validate_migrated_data(data: Dictionary) -> bool:
	"""
	Validates migrated save data for correctness.

	Checks:
	- Required fields present
	- Data types correct
	- Values in valid ranges
	- Checksums valid (if present)

	Args:
		data: Migrated save data

	Returns:
		True if valid, false otherwise
	"""
	# Check required top-level fields
	var required_fields = ["version", "player"]
	for field in required_fields:
		if not data.has(field):
			push_error("Migration", "Validation failed: Missing required field '%s'" % field)
			return false

	# Validate version
	if data.version != CURRENT_VERSION:
		push_error("Migration", "Validation failed: Version mismatch (expected %s, got %s)" % [
			CURRENT_VERSION, data.version
		])
		return false

	# Validate player data
	if not data.player.has("credits"):
		push_error("Migration", "Validation failed: Player missing 'credits' field")
		return false

	# Validate credits range
	if typeof(data.player.credits) != TYPE_FLOAT and typeof(data.player.credits) != TYPE_INT:
		push_error("Migration", "Validation failed: Invalid credits type")
		return false

	if data.player.credits < 0:
		push_warning("Migration", "Negative credits detected (%.2f), clamping to 0" % data.player.credits)
		data.player.credits = 0.0

	# Validate checksum if present
	if data.has("checksum"):
		var stored_checksum = data.checksum
		var calculated_checksum = _calculate_checksum(data)

		if stored_checksum != calculated_checksum:
			push_error("Migration", "Validation failed: Checksum mismatch (data corrupted?)")
			return false

	# All validations passed
	print("Migration", "Validation passed")
	return true

# ============================================================================
# UTILITIES
# ============================================================================

func _calculate_checksum(data: Dictionary) -> String:
	"""
	Calculates SHA-256 checksum of save data.

	Excludes the checksum field itself to avoid circular dependency.

	Args:
		data: Save data dictionary

	Returns:
		Hex-encoded SHA-256 hash string

	Performance:
		O(n) where n = size of JSON string (~1-5ms for typical save)
	"""
	# Create copy and remove checksum field
	var data_copy = data.duplicate(true)
	data_copy.erase("checksum")

	# Serialize to JSON
	var json_string = JSON.stringify(data_copy, "\t")  # Pretty-print for readability

	# Calculate SHA-256 hash
	var hash_ctx = HashingContext.new()
	hash_ctx.start(HashingContext.HASH_SHA256)
	hash_ctx.update(json_string.to_utf8_buffer())
	var hash_bytes = hash_ctx.finish()

	return hash_bytes.hex_encode()

func _get_next_version(current: String) -> String:
	"""
	Gets the next version in migration chain.

	Args:
		current: Current version

	Returns:
		Next version string, or empty string if no migration exists
	"""
	if not _migrations.has(current):
		return ""

	# Simulate migration to extract version
	var temp_data = {"version": current}
	temp_data = _migrations[current].call(temp_data)
	return temp_data.get("version", "")
