## res://scripts/Ore_Procedural.gd
## Enhanced Ore class with procedural shader support
## Extends original Ore.gd with 1:1 reproduction from HTML generator

extends "res://scripts/Ore.gd"

# ============================================================================
# PROCEDURAL GENERATION
# ============================================================================

## Enable procedural shader rendering (true) or use static images (false)
@export var use_procedural_shader: bool = true

## Frame for animation (0-7)
@export var animation_frame: int = 0

## Procedural asset generator instance
var procedural_generator: ProceduralAssetGenerator = null

# ============================================================================
# INITIALIZATION
# ============================================================================

func _ready():
	# Initialize procedural generator
	if use_procedural_shader:
		procedural_generator = ProceduralAssetGenerator.new()
		add_child(procedural_generator)

	# Call parent _ready (randomizes ore, etc.)
	super._ready()

	# Apply procedural shader if enabled
	if use_procedural_shader:
		apply_procedural_shader()

# ============================================================================
# PROCEDURAL SHADER APPLICATION
# ============================================================================

func apply_procedural_shader():
	"""Apply procedural shader material to sprite based on ore properties"""
	if not sprite or not procedural_generator:
		return

	# Determine preset from ore_id
	var preset_name = get_preset_from_ore_id()

	# Determine variant from quality_tier or ore type
	var variant = get_variant_from_ore()

	# Generate shader material
	var material = procedural_generator.generate_asteroid_material(
		ore_id,
		variant,
		animation_frame,
		preset_name
	)

	if material:
		# Create white texture if sprite doesn't have one
		if not sprite.texture:
			sprite.texture = create_white_texture()

		# Apply shader material
		sprite.material = material

		print("Ore_Procedural: Applied shader to %s (preset=%s, seed=%d)" % [
			ore_name,
			preset_name,
			procedural_generator.get_seed_for_item(ore_id, variant, animation_frame)
		])
	else:
		push_error("Ore_Procedural: Failed to generate material for %s" % ore_id)

func create_white_texture() -> ImageTexture:
	"""Create white placeholder texture for shader rendering"""
	var size = 64
	var image = Image.create(size, size, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	return ImageTexture.create_from_image(image)

# ============================================================================
# PRESET & VARIANT MAPPING
# ============================================================================

func get_preset_from_ore_id() -> String:
	"""
	Map ore_id to preset name

	Examples:
	- ORE_T1_001 → T1_Iron
	- ORE_T3_042 → T3_Titanium_Elongated
	- ORE_T5_100 → T5_Platinum_Crystalline
	"""
	# Extract tier from ore_id (e.g., "ORE_T1_001" -> "T1")
	var tier = ""
	if ore_id.begins_with("ORE_T"):
		tier = ore_id.substr(4, 2) # "T1", "T2", etc.

	# Map ore name to preset variant
	var ore_lower = ore_name.to_lower()

	match tier:
		"T1":
			if "nickel" in ore_lower:
				return "T1_Nickel_Oblong"
			else:
				return "T1_Iron"  # Default T1

		"T2":
			return "T2_Copper_Irregular"

		"T3":
			return "T3_Titanium_Elongated"

		"T4":
			return "T4_Gold_Faceted"

		"T5":
			return "T5_Platinum_Crystalline"

		"T6":
			return "T6_Iridium_Complex"

		_:
			return "T1_Iron"  # Fallback

func get_variant_from_ore() -> String:
	"""
	Get variant identifier from ore name/type

	Examples:
	- "Ferralite" → "iron"
	- "Cuprite" → "copper"
	- "Titanite" → "titanium"
	"""
	var ore_lower = ore_name.to_lower()

	# Map ore names to variants
	if "ferr" in ore_lower or "iron" in ore_lower:
		return "iron"
	elif "nickel" in ore_lower:
		return "nickel"
	elif "copper" in ore_lower or "cupr" in ore_lower:
		return "copper"
	elif "titan" in ore_lower:
		return "titanium"
	elif "gold" in ore_lower or "aur" in ore_lower:
		return "gold"
	elif "platin" in ore_lower:
		return "platinum"
	elif "iridium" in ore_lower:
		return "iridium"
	else:
		return "default"

# ============================================================================
# QUALITY-BASED VISUAL UPDATES
# ============================================================================

func update_visual():
	"""Override to update shader parameters based on quality"""
	super.update_visual()  # Call parent (updates label, etc.)

	if use_procedural_shader and sprite and sprite.material:
		# Update shader parameters based on quality
		update_shader_quality_parameters()

func update_shader_quality_parameters():
	"""Update shader parameters to reflect ore quality"""
	if not sprite or not sprite.material or not sprite.material is ShaderMaterial:
		return

	var material = sprite.material as ShaderMaterial

	# Extract quality tier number (Q2 -> 2)
	var tier_num = int(quality_tier.substr(1, 1)) if quality_tier.length() > 1 else 2

	# Adjust purity glow based on quality (Q0=0.0, Q5=1.0)
	var purity = tier_num / 5.0
	material.set_shader_parameter("purity_glow", purity)

	# Adjust ore vein count based on quality
	var vein_count = tier_num * 2  # Q0=0, Q5=10
	material.set_shader_parameter("ore_vein_count", vein_count)

	# Adjust metallic based on quality
	var metallic_value = 0.3 + (purity * 0.4)  # 0.3 to 0.7
	material.set_shader_parameter("metallic", metallic_value)

# ============================================================================
# ANIMATION FRAME CONTROL
# ============================================================================

func set_animation_frame(frame: int):
	"""
	Change animation frame (0-7) and regenerate shader

	Useful for 8-frame rotation animation
	"""
	animation_frame = clamp(frame, 0, 7)

	if use_procedural_shader:
		apply_procedural_shader()

func cycle_animation_frame():
	"""Cycle to next animation frame"""
	animation_frame = (animation_frame + 1) % 8
	if use_procedural_shader:
		apply_procedural_shader()

# ============================================================================
# SEED SYSTEM ACCESS
# ============================================================================

func get_current_seed() -> int:
	"""Get current seed value for this asteroid"""
	if not procedural_generator:
		return 0

	var variant = get_variant_from_ore()
	return procedural_generator.get_seed_for_item(ore_id, variant, animation_frame)

func print_generation_info():
	"""Print debugging information about procedural generation"""
	var preset = get_preset_from_ore_id()
	var variant = get_variant_from_ore()
	var seed = get_current_seed()

	print("\n========== ORE PROCEDURAL INFO ==========")
	print("Ore ID: %s" % ore_id)
	print("Ore Name: %s" % ore_name)
	print("Quality Tier: %s" % quality_tier)
	print("Preset: %s" % preset)
	print("Variant: %s" % variant)
	print("Animation Frame: %d" % animation_frame)
	print("Seed: %d (0x%08X)" % [seed, seed])
	print("Procedural: %s" % ("ENABLED" if use_procedural_shader else "DISABLED"))
	print("========================================\n")

# ============================================================================
# EXPORT ASTEROID IMAGE
# ============================================================================

func export_as_png(output_path: String = "") -> String:
	"""
	Export current asteroid as PNG file

	Args:
		output_path: File path (auto-generated if empty)

	Returns:
		Path to exported PNG
	"""
	if not procedural_generator:
		push_error("Ore_Procedural: No procedural generator available")
		return ""

	if output_path.is_empty():
		output_path = "user://exported_ores/%s_frame%d.png" % [ore_id, animation_frame]

	var variant = get_variant_from_ore()
	var preset = get_preset_from_ore_id()

	var path = await procedural_generator.export_asteroid_png(
		ore_id,
		variant,
		preset,
		output_path,
		Vector2i(512, 512)
	)

	return path

# ============================================================================
# TESTING
# ============================================================================

func test_seed_reproduction():
	"""Test if seed matches HTML generator"""
	if not procedural_generator:
		print("ERROR: No procedural generator")
		return

	var variant = get_variant_from_ore()
	var seed = get_current_seed()

	print("\n========== SEED REPRODUCTION TEST ==========")
	print("Ore: %s (%s)" % [ore_name, ore_id])
	print("Variant: %s" % variant)
	print("Frame: %d" % animation_frame)
	print("Seed: %d" % seed)
	print("\nTo verify in HTML generator:")
	print("1. Open asset-generator/generators/asteroid.html")
	print("2. Set Item ID: %s" % ore_id)
	print("3. Set Variant: %s" % variant)
	print("4. Check displayed seed: %d" % seed)
	print("5. Seeds should MATCH exactly!")
	print("===========================================\n")

	# Also test SeedSystem
	procedural_generator.test_seed_system()
