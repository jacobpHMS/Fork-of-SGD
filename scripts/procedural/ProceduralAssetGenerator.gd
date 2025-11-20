## res://scripts/procedural/ProceduralAssetGenerator.gd
## Main class for procedural asset generation
## Integrates SeedSystem, parameter loading, and shader material creation

class_name ProceduralAssetGenerator
extends Node

# ============================================================================
# DEPENDENCIES
# ============================================================================

var seed_system: SeedSystem = SeedSystem.new()
var id_generator: AsteroidIDGenerator = AsteroidIDGenerator.new()

# Shader resources
var asteroid_shader: Shader = preload("res://shaders/procedural/asteroid_procedural.gdshader")
var container_shader: Shader  # Will be loaded dynamically

# Parameter cache
var parameter_cache: Dictionary = {}

# ============================================================================
# PARAMETER LOADING
# ============================================================================

func load_parameters(json_path: String) -> Dictionary:
	"""
	Load parameter definitions from JSON file

	Args:
		json_path: Path to parameter JSON file (e.g., "res://parameters/asteroid_shape_params.json")

	Returns:
		Dictionary with parameter definitions
	"""
	# Check cache
	if parameter_cache.has(json_path):
		return parameter_cache[json_path]

	# Load JSON
	if not FileAccess.file_exists(json_path):
		push_error("ProceduralAssetGenerator: Parameter file not found: " + json_path)
		return {}

	var file = FileAccess.open(json_path, FileAccess.READ)
	if not file:
		push_error("ProceduralAssetGenerator: Failed to open: " + json_path)
		return {}

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_string)

	if parse_result != OK:
		push_error("ProceduralAssetGenerator: Failed to parse JSON: " + json_path)
		return {}

	var data = json.data
	parameter_cache[json_path] = data

	print("ProceduralAssetGenerator: Loaded parameters from %s (%d parameters)" % [
		json_path,
		count_parameters(data)
	])

	return data

func count_parameters(param_data: Dictionary) -> int:
	"""Count total number of parameters in definition"""
	var count = 0
	if param_data.has("categories"):
		for category in param_data.categories.values():
			if category.has("parameters"):
				count += category.parameters.size()
	return count

# ============================================================================
# PRESET LOADING
# ============================================================================

func get_preset_parameters(param_data: Dictionary, preset_name: String) -> Dictionary:
	"""
	Get parameter values for a specific preset

	Args:
		param_data: Parameter definitions
		preset_name: Name of preset (e.g., "T1_Iron", "T3_Titanium_Elongated")

	Returns:
		Dictionary of parameter values
	"""
	if param_data.has("tier_presets") or param_data.has("presets"):
		var presets = param_data.get("tier_presets", param_data.get("presets", {}))

		if presets.has(preset_name):
			return presets[preset_name].get("parameters", {})

	push_warning("ProceduralAssetGenerator: Preset not found: " + preset_name)
	return {}

# ============================================================================
# ASTEROID GENERATION
# ============================================================================

func generate_asteroid_material(
	item_id: String,
	variant: String = "default",
	frame: int = 0,
	preset_name: String = "",
	custom_params: Dictionary = {}
) -> ShaderMaterial:
	"""
	Generate ShaderMaterial for asteroid

	Args:
		item_id: Item ID (e.g., "ORE_T1_001")
		variant: Variant name (e.g., "iron", "titanium")
		frame: Animation frame (0-7)
		preset_name: Optional preset name (e.g., "T1_Iron")
		custom_params: Optional custom parameter overrides

	Returns:
		ShaderMaterial configured for asteroid
	"""
	# Load parameter definitions
	var param_data = load_parameters("res://parameters/asteroid_shape_params.json")
	if param_data.is_empty():
		push_error("ProceduralAssetGenerator: Failed to load asteroid parameters")
		return null

	# Generate seed
	var seed = seed_system.generate_seed("asteroid", item_id, variant, frame)

	# Create shader material
	var material = ShaderMaterial.new()
	material.shader = asteroid_shader

	# Set seed
	material.set_shader_parameter("seed", seed)

	# Get parameter values (default → preset → custom)
	var params = get_default_parameters(param_data)

	if not preset_name.is_empty():
		var preset_params = get_preset_parameters(param_data, preset_name)
		params.merge(preset_params, true)

	params.merge(custom_params, true)

	# Apply parameters to shader
	apply_parameters_to_material(material, params)

	print("ProceduralAssetGenerator: Generated asteroid material (seed=%d, preset=%s)" % [seed, preset_name])

	return material

func get_default_parameters(param_data: Dictionary) -> Dictionary:
	"""Extract default parameter values from parameter definitions"""
	var defaults = {}

	if param_data.has("categories"):
		for category in param_data.categories.values():
			if category.has("parameters"):
				for param_name in category.parameters.keys():
					var param = category.parameters[param_name]
					if param.has("default"):
						defaults[param_name] = param.default

	return defaults

func apply_parameters_to_material(material: ShaderMaterial, params: Dictionary) -> void:
	"""Apply parameter dictionary to shader material"""
	for param_name in params.keys():
		var value = params[param_name]

		# Convert enum strings to integers
		if value is String:
			value = convert_enum_to_int(param_name, value)

		material.set_shader_parameter(param_name, value)

func convert_enum_to_int(param_name: String, value: String) -> int:
	"""Convert enum string values to shader integers"""
	# Shape type mapping
	if param_name == "shape_type":
		var shape_types = {
			"sphere": 0,
			"ellipsoid": 1,
			"oblong": 2,
			"irregular": 3,
			"fragmented": 4,
			"crystalline": 5,
			"potato": 6
		}
		return shape_types.get(value, 0)

	# Noise type mapping
	if param_name == "noise_type":
		var noise_types = {
			"perlin": 0,
			"simplex": 1,
			"voronoi": 2,
			"worley": 3
		}
		return noise_types.get(value, 0)

	# Unknown enum, return 0
	return 0

# ============================================================================
# SPRITE CREATION
# ============================================================================

func create_asteroid_sprite(
	item_id: String,
	variant: String = "default",
	frame: int = 0,
	preset_name: String = "",
	size: Vector2 = Vector2(64, 64)
) -> Sprite2D:
	"""
	Create Sprite2D with procedural asteroid shader

	Args:
		item_id: Item ID
		variant: Variant name
		frame: Animation frame
		preset_name: Optional preset
		size: Sprite size in pixels

	Returns:
		Configured Sprite2D node
	"""
	var sprite = Sprite2D.new()

	# Create material
	var material = generate_asteroid_material(item_id, variant, frame, preset_name)
	if not material:
		push_error("ProceduralAssetGenerator: Failed to create material for sprite")
		return sprite

	# Create placeholder texture (shader will render over it)
	var texture = create_placeholder_texture(size)
	sprite.texture = texture
	sprite.material = material
	sprite.centered = true

	return sprite

func create_placeholder_texture(size: Vector2) -> ImageTexture:
	"""Create white square texture for shader rendering"""
	var image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	return ImageTexture.create_from_image(image)

# ============================================================================
# TEXTURE EXPORT (for AssetManager compatibility)
# ============================================================================

func render_asteroid_to_image(
	item_id: String,
	variant: String = "default",
	preset_name: String = "",
	size: Vector2i = Vector2i(512, 512)
) -> Image:
	"""
	Render asteroid to Image (can be saved as PNG)

	Args:
		item_id: Item ID
		variant: Variant name
		preset_name: Optional preset
		size: Image size

	Returns:
		Rendered Image

	Note: Requires viewport rendering (must be called in scene)
	"""
	# Create viewport for offscreen rendering
	var viewport = SubViewport.new()
	viewport.size = size
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	viewport.transparent_bg = true

	# Create sprite in viewport
	var sprite = create_asteroid_sprite(item_id, variant, 0, preset_name, Vector2(size))
	sprite.position = Vector2(size) / 2.0
	viewport.add_child(sprite)

	# Add viewport to scene temporarily
	add_child(viewport)

	# Wait for render
	await get_tree().process_frame
	await get_tree().process_frame

	# Get rendered image
	var image = viewport.get_texture().get_image()

	# Cleanup
	viewport.queue_free()

	print("ProceduralAssetGenerator: Rendered asteroid to %dx%d image" % [size.x, size.y])

	return image

func export_asteroid_png(
	item_id: String,
	variant: String = "default",
	preset_name: String = "",
	output_path: String = "",
	size: Vector2i = Vector2i(512, 512)
) -> String:
	"""
	Export asteroid as PNG file

	Args:
		item_id: Item ID
		variant: Variant name
		preset_name: Optional preset
		output_path: Output file path (auto-generated if empty)
		size: Image size

	Returns:
		Path to saved PNG file
	"""
	var image = await render_asteroid_to_image(item_id, variant, preset_name, size)

	if output_path.is_empty():
		output_path = "user://generated_assets/%s_%s_%s.png" % [item_id, variant, preset_name]

	# Create directory if needed
	var dir = output_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)

	# Save PNG
	var error = image.save_png(output_path)

	if error == OK:
		print("ProceduralAssetGenerator: Exported PNG to %s" % output_path)
	else:
		push_error("ProceduralAssetGenerator: Failed to save PNG: %s" % output_path)

	return output_path

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

func get_seed_for_item(item_id: String, variant: String = "default", frame: int = 0) -> int:
	"""Get seed value for specific item"""
	return seed_system.generate_seed("asteroid", item_id, variant, frame)

func test_seed_system() -> void:
	"""Test seed system reproduction"""
	seed_system.print_test_results()

# ============================================================================
# EXAMPLE USAGE
# ============================================================================

# Example in game code:
#
# var generator = ProceduralAssetGenerator.new()
#
# # Generate asteroid sprite
# var asteroid_sprite = generator.create_asteroid_sprite(
#     "ORE_T1_001",
#     "iron",
#     0,
#     "T1_Iron"
# )
# add_child(asteroid_sprite)
#
# # Export as PNG
# var png_path = await generator.export_asteroid_png(
#     "ORE_T1_001",
#     "iron",
#     "T1_Iron",
#     "user://asteroid_preview.png"
# )
#
# # Just get the material for existing sprite
# var material = generator.generate_asteroid_material("ORE_T3_042", "titanium", 0, "T3_Titanium_Elongated")
# existing_sprite.material = material

# ============================================================================
# VARIANCE-BASED GENERATION (NEW!)
# ============================================================================

func generate_asteroid_with_variance(
	size_category: String,
	ore_tier: int,
	quality: int,
	amount: float,
	sector_id: String = ""
) -> Dictionary:
	"""
	Generate asteroid with automatic variance based on size category

	Args:
		size_category: "small", "medium", "large", "huge"
		ore_tier: 1-6 (T1-T6)
		quality: 0-5 (Q0-Q5)
		amount: Amount of ore in units
		sector_id: Sector identifier for spatial organization

	Returns:
		Dictionary with complete asteroid data:
		{
			"id": "ORE_SMALL_T1_Q2_A5_00042",
			"seed": 1234567890,
			"material": ShaderMaterial,
			"size": Vector2(32, 32),
			"collision_shape": CircleShape2D,
			"amount": 120.0,
			"quality": "Q2",
			"tier": 1
		}
	"""
	# 1. Generate unique ID
	var asteroid_id = id_generator.generate_asteroid_id(size_category, ore_tier, quality, sector_id)

	# 2. Generate seed from unique ID
	var seed = seed_system.generate_seed("asteroid", asteroid_id, "", 0)
	var rng = seed_system.create_rng(seed)

	# 3. Determine preset based on tier
	var preset_name = get_preset_for_tier(ore_tier)

	# 4. Load base parameters
	var param_data = load_parameters("res://parameters/asteroid_shape_params.json")
	var params = get_default_parameters(param_data)

	# Apply preset if available
	if not preset_name.is_empty():
		var preset_params = get_preset_parameters(param_data, preset_name)
		params.merge(preset_params, true)

	# 5. Apply size-based variance
	params = apply_size_variance(params, size_category, rng)

	# 6. Apply quality-based adjustments
	params = apply_quality_adjustments(params, quality)

	# 7. Calculate scale from amount
	var scale = calculate_scale_from_amount(amount, size_category)

	# 8. Generate shader material
	var material = ShaderMaterial.new()
	material.shader = asteroid_shader
	material.set_shader_parameter("seed", seed)
	apply_parameters_to_material(material, params)

	# 9. Generate collision shape
	var collision_shape = generate_collision_shape(params, scale)

	return {
		"id": asteroid_id,
		"seed": seed,
		"material": material,
		"size": Vector2(scale, scale),
		"collision_shape": collision_shape,
		"amount": amount,
		"quality": "Q%d" % quality,
		"tier": ore_tier,
		"params": params
	}

func get_preset_for_tier(tier: int) -> String:
	"""Map tier to preset name"""
	match tier:
		1: return "T1_Iron"
		2: return "T2_Copper_Irregular"
		3: return "T3_Titanium_Elongated"
		4: return "T4_Gold_Faceted"
		5: return "T5_Platinum_Crystalline"
		6: return "T6_Iridium_Complex"
		_: return "T1_Iron"

func apply_size_variance(params: Dictionary, size_category: String, rng: SeedSystem.SeededRandom) -> Dictionary:
	"""Apply size-specific parameter variance"""
	var result = params.duplicate()

	match size_category.to_lower():
		"small":
			# Small asteroids: High variance (more interesting)
			result.elongation_x += rng.next_float(-0.3, 0.3)
			result.elongation_y += rng.next_float(-0.3, 0.3)
			result.asymmetry += rng.next_float(-0.2, 0.3)
			result.roughness += rng.next_float(-0.2, 0.2)
			result.crater_density += rng.next_int(-5, 10)

		"medium":
			# Medium asteroids: Moderate variance
			result.elongation_x += rng.next_float(-0.2, 0.2)
			result.elongation_y += rng.next_float(-0.2, 0.2)
			result.asymmetry += rng.next_float(-0.15, 0.15)
			result.roughness += rng.next_float(-0.1, 0.1)
			result.crater_density += rng.next_int(-3, 8)

		"large":
			# Large asteroids: Low variance (massive look)
			result.elongation_x += rng.next_float(-0.1, 0.1)
			result.elongation_y += rng.next_float(-0.1, 0.1)
			result.asymmetry += rng.next_float(-0.1, 0.1)
			result.roughness += rng.next_float(-0.05, 0.05)
			result.crater_density += rng.next_int(5, 15)  # More craters

		"huge":
			# Huge asteroids: Minimal variance, many craters
			result.elongation_x += rng.next_float(-0.05, 0.05)
			result.elongation_y += rng.next_float(-0.05, 0.05)
			result.asymmetry = 0.1  # Almost round
			result.crater_density += rng.next_int(20, 40)
			result.ore_vein_count += rng.next_int(5, 10)

	# Clamp to valid ranges
	result.elongation_x = clamp(result.elongation_x, 0.5, 2.0)
	result.elongation_y = clamp(result.elongation_y, 0.5, 2.0)
	result.asymmetry = clamp(result.asymmetry, 0.0, 1.0)
	result.roughness = clamp(result.roughness, 0.0, 1.0)
	result.crater_density = clamp(result.crater_density, 0, 100)

	return result

func apply_quality_adjustments(params: Dictionary, quality: int) -> Dictionary:
	"""Adjust parameters based on quality tier"""
	var result = params.duplicate()

	# Purity glow (Q0=0.0, Q5=1.0)
	result.purity_glow = quality / 5.0

	# Ore veins (more with higher quality)
	result.ore_vein_count = quality * 2

	# Metallic (higher with better quality)
	result.metallic = 0.3 + (quality / 5.0) * 0.4

	# Saturation (higher with better quality)
	result.saturation = 0.3 + (quality / 5.0) * 0.5

	return result

func calculate_scale_from_amount(amount: float, size_category: String) -> float:
	"""Calculate sprite scale based on ore amount"""
	var base_scale: float
	var variance: float

	match size_category.to_lower():
		"small":
			base_scale = 32.0
			variance = 0.3  # ±30%
		"medium":
			base_scale = 64.0
			variance = 0.25
		"large":
			base_scale = 128.0
			variance = 0.2
		"huge":
			base_scale = 256.0
			variance = 0.15
		_:
			base_scale = 64.0
			variance = 0.25

	# Normalize amount (assuming 50-150 is typical range)
	var normalized_amount = (amount - 50.0) / 100.0
	normalized_amount = clamp(normalized_amount, 0.0, 1.0)

	# Apply scaling
	var scale_factor = 1.0 + (normalized_amount - 0.5) * variance

	return base_scale * scale_factor

func generate_collision_shape(params: Dictionary, scale: float) -> CircleShape2D:
	"""Generate collision shape based on shader parameters"""
	var base_radius = scale / 2.0

	# Adjust for elongation
	var elongation_avg = (params.get("elongation_x", 1.0) + params.get("elongation_y", 1.0)) / 2.0
	var asymmetry = params.get("asymmetry", 0.0)

	var adjusted_radius = base_radius * elongation_avg
	adjusted_radius *= (1.0 + asymmetry * 0.2)

	var shape = CircleShape2D.new()
	shape.radius = adjusted_radius

	return shape

# ============================================================================
# CONTAINER GENERATION (NEW!)
# ============================================================================

func generate_container_with_variance(
	container_type: String,
	content_type: String,
	amount: float,
	quality: int = 2,
	sector_id: String = ""
) -> Dictionary:
	"""
	Generate cargo container with procedural appearance

	Args:
		container_type: "mineral", "gas", "liquid", "ammo"
		content_type: "iron", "oxygen", "water", "missiles"
		amount: Amount of content
		quality: 0-5 (affects appearance)
		sector_id: Sector identifier

	Returns:
		Dictionary with complete container data
	"""
	# 1. Generate unique ID
	var container_id = id_generator.generate_container_id(container_type, content_type, sector_id)

	# 2. Generate seed
	var seed = seed_system.generate_seed("container", container_id, container_type, 0)
	var rng = seed_system.create_rng(seed)

	# 3. Load container parameters
	var param_data = load_parameters("res://parameters/container_params.json")
	if param_data.is_empty():
		push_warning("Container parameters not found, using defaults")
		param_data = get_default_container_params()

	# 4. Get type-specific parameters
	var params = get_container_type_params(param_data, container_type, rng)

	# 5. Apply quality
	params = apply_container_quality(params, quality)

	# 6. Calculate size
	var size = calculate_container_size(amount, container_type)

	# 7. Generate material (if shader available)
	var material = generate_container_material(container_id, container_type, params, seed)

	# 8. Collision shape
	var collision_shape = CircleShape2D.new()
	collision_shape.radius = size / 2.0

	return {
		"id": container_id,
		"seed": seed,
		"material": material,
		"container_type": container_type,
		"content_type": content_type,
		"size": Vector2(size, size),
		"collision_shape": collision_shape,
		"amount": amount,
		"quality": quality,
		"params": params
	}

func get_default_container_params() -> Dictionary:
	"""Fallback container parameters"""
	return {
		"categories": {
			"visual": {
				"parameters": {
					"glow_intensity": {"default": 0.5},
					"metallic": {"default": 0.7},
					"hue": {"default": 200.0}
				}
			}
		}
	}

func get_container_type_params(param_data: Dictionary, container_type: String, rng: SeedSystem.SeededRandom) -> Dictionary:
	"""Get type-specific container parameters"""
	var params = {}

	match container_type.to_lower():
		"mineral":
			params = {
				"glow_intensity": rng.next_float(0.1, 0.3),
				"metallic": rng.next_float(0.6, 0.9),
				"hue": rng.next_float(20.0, 40.0),  # Brown/orange
				"shape_type": 0  # Cubic
			}
		"gas":
			params = {
				"glow_intensity": rng.next_float(0.7, 1.0),
				"metallic": rng.next_float(0.2, 0.4),
				"hue": rng.next_float(180.0, 240.0),  # Blue/cyan
				"shape_type": 1  # Spherical
			}
		"liquid":
			params = {
				"glow_intensity": rng.next_float(0.4, 0.6),
				"metallic": rng.next_float(0.3, 0.5),
				"hue": rng.next_float(190.0, 210.0),  # Blue
				"shape_type": 2  # Cylindrical
			}
		"ammo":
			params = {
				"glow_intensity": rng.next_float(0.2, 0.4),
				"metallic": rng.next_float(0.8, 1.0),
				"hue": rng.next_float(0.0, 30.0),  # Red/orange
				"shape_type": 0  # Cubic
			}

	return params

func apply_container_quality(params: Dictionary, quality: int) -> Dictionary:
	"""Apply quality to container appearance"""
	var result = params.duplicate()

	# Higher quality = more glow
	if result.has("glow_intensity"):
		result.glow_intensity *= (1.0 + quality / 10.0)

	return result

func calculate_container_size(amount: float, container_type: String) -> float:
	"""Calculate container size based on amount"""
	var base_size: float

	match container_type.to_lower():
		"mineral": base_size = 24.0
		"gas": base_size = 32.0
		"liquid": base_size = 28.0
		"ammo": base_size = 20.0
		_: base_size = 24.0

	# Scale with amount (assuming 1-100 range)
	var scale_factor = 1.0 + (amount / 100.0) * 0.5

	return base_size * scale_factor

func generate_container_material(container_id: String, container_type: String, params: Dictionary, seed: int) -> ShaderMaterial:
	"""Generate container shader material"""
	# For now, use simple colored material
	# TODO: Implement container shader
	var material = ShaderMaterial.new()
	# material.shader = container_shader  # When shader is ready
	return material
