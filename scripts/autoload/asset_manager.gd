# res://scripts/autoload/asset_manager.gd
extends Node

# Asset directories
const ASSET_PATHS = {
	"ORES": "res://assets/database/ores/",
	"MATERIALS": "res://assets/database/materials/",
	"GASES": "res://assets/database/gases/",
	"COMPONENTS": "res://assets/database/components/",
	"WEAPONS": "res://assets/database/weapons/",
	"AMMUNITION": "res://assets/database/ammunition/",
	"SHIP_MODULES": "res://assets/database/ship_modules/",
	"SHIPS": "res://assets/database/ships/"
}

# Target size for all icons (auto-scaled)
const TARGET_ICON_SIZE = Vector2i(32, 32)

# Asset cache (ID → Texture2D)
var icon_cache: Dictionary = {}

# Fallback icon
var fallback_icon: Texture2D = null

# Signals
signal asset_loaded(item_id: String, texture: Texture2D)
signal asset_loading_failed(item_id: String, reason: String)

func _ready():
	print("AssetManager: Initializing...")
	create_fallback_icon()

# ============================================================================
# ICON LOADING
# ============================================================================

func get_icon(item_id: String, item_database: String = "") -> Texture2D:
	"""Get icon for item (returns cached if available)"""
	# Check cache first
	if icon_cache.has(item_id):
		return icon_cache[item_id]

	# Try to load from disk
	var texture = load_and_scale_icon(item_id, item_database)

	if texture:
		icon_cache[item_id] = texture
		asset_loaded.emit(item_id, texture)
		return texture

	# Return fallback if not found
	return fallback_icon

func load_and_scale_icon(item_id: String, item_database: String) -> Texture2D:
	"""Load icon and auto-scale to TARGET_ICON_SIZE (32x32)"""
	# Determine asset path based on database
	var base_path = ASSET_PATHS.get(item_database.to_upper(), "")

	if base_path.is_empty():
		# Try to determine from ID prefix
		if item_id.begins_with("ORE_"):
			base_path = ASSET_PATHS["ORES"]
		elif item_id.begins_with("MAT_"):
			base_path = ASSET_PATHS["MATERIALS"]
		elif item_id.begins_with("GAS_"):
			base_path = ASSET_PATHS["GASES"]
		elif item_id.begins_with("COMP_"):
			base_path = ASSET_PATHS["COMPONENTS"]
		elif item_id.begins_with("WEP_"):
			base_path = ASSET_PATHS["WEAPONS"]
		elif item_id.begins_with("AMMO_"):
			base_path = ASSET_PATHS["AMMUNITION"]
		elif item_id.begins_with("MOD_"):
			base_path = ASSET_PATHS["SHIP_MODULES"]
		elif item_id.begins_with("SHIP_"):
			base_path = ASSET_PATHS["SHIPS"]
		else:
			push_warning("AssetManager: Unknown item ID format: " + item_id)
			return null

	# Try common image formats
	var extensions = ["png", "jpg", "webp", "svg"]

	for ext in extensions:
		var file_path = base_path + item_id + "." + ext

		if FileAccess.file_exists(file_path):
			var image = Image.new()
			var error = image.load(file_path)

			if error != OK:
				push_error("AssetManager: Failed to load image: " + file_path)
				asset_loading_failed.emit(item_id, "Failed to load image file")
				return null

			# Scale to target size if needed
			if image.get_size() != TARGET_ICON_SIZE:
				image.resize(TARGET_ICON_SIZE.x, TARGET_ICON_SIZE.y, Image.INTERPOLATE_LANCZOS)

			# Create texture from image
			var texture = ImageTexture.create_from_image(image)
			print("AssetManager: Loaded and scaled %s → 32x32" % item_id)
			return texture

	# Asset not found
	push_warning("AssetManager: Asset not found for " + item_id)
	asset_loading_failed.emit(item_id, "Asset file not found")
	return null

# ============================================================================
# BATCH OPERATIONS
# ============================================================================

func preload_icons_for_database(database_name: String):
	"""Preload all icons for a specific database"""
	var items = DatabaseManager.get_items_by_database(database_name)
	var loaded_count = 0

	print("AssetManager: Preloading icons for %s (%d items)..." % [database_name, items.size()])

	for item in items:
		var item_id = item.get("ID", "")
		if not item_id.is_empty():
			var texture = get_icon(item_id, database_name)
			if texture and texture != fallback_icon:
				loaded_count += 1

	print("AssetManager: Preloaded %d/%d icons for %s" % [loaded_count, items.size(), database_name])

func preload_all_icons():
	"""Preload ALL icons (use cautiously - 1005 items!)"""
	print("AssetManager: Preloading ALL icons (this may take a while)...")

	for database_name in ASSET_PATHS.keys():
		preload_icons_for_database(database_name)

	print("AssetManager: Finished preloading. Cached: %d icons" % icon_cache.size())

func clear_cache():
	"""Clear icon cache to free memory"""
	icon_cache.clear()
	print("AssetManager: Cache cleared")

# ============================================================================
# FALLBACK ICON
# ============================================================================

func create_fallback_icon():
	"""Create a simple fallback icon (gray square with ? mark)"""
	var image = Image.create(TARGET_ICON_SIZE.x, TARGET_ICON_SIZE.y, false, Image.FORMAT_RGBA8)

	# Fill with gray background
	image.fill(Color(0.3, 0.3, 0.3, 1.0))

	# Draw border
	for x in range(TARGET_ICON_SIZE.x):
		image.set_pixel(x, 0, Color.WHITE)
		image.set_pixel(x, TARGET_ICON_SIZE.y - 1, Color.WHITE)

	for y in range(TARGET_ICON_SIZE.y):
		image.set_pixel(0, y, Color.WHITE)
		image.set_pixel(TARGET_ICON_SIZE.x - 1, y, Color.WHITE)

	fallback_icon = ImageTexture.create_from_image(image)
	print("AssetManager: Fallback icon created")

# ============================================================================
# UTILITY
# ============================================================================

func get_cache_stats() -> Dictionary:
	"""Get cache statistics"""
	return {
		"cached_icons": icon_cache.size(),
		"has_fallback": fallback_icon != null
	}

func print_cache_stats():
	"""Print cache statistics to console"""
	var stats = get_cache_stats()
	print("\n========== ASSET CACHE STATISTICS ==========")
	print("Cached Icons: %d" % stats["cached_icons"])
	print("Has Fallback: %s" % str(stats["has_fallback"]))
	print("============================================\n")

# ============================================================================
# ADVANCED: SPRITE GENERATION
# ============================================================================

func create_sprite_for_item(item_id: String, database: String = "") -> Sprite2D:
	"""Create a Sprite2D node with the item's icon"""
	var sprite = Sprite2D.new()
	sprite.texture = get_icon(item_id, database)
	sprite.centered = true
	return sprite

func create_texture_rect_for_item(item_id: String, database: String = "") -> TextureRect:
	"""Create a TextureRect node with the item's icon"""
	var texture_rect = TextureRect.new()
	texture_rect.texture = get_icon(item_id, database)
	texture_rect.custom_minimum_size = TARGET_ICON_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	return texture_rect
