## res://scripts/procedural/Test_SeedReproduction.gd
## Test script to verify 1:1 seed reproduction between HTML and Godot
## Run this script to validate the integration

extends Node

func _ready():
	print("\n" + "="*60)
	print("  PROCEDURAL ASSET GENERATION - SEED REPRODUCTION TEST")
	print("="*60 + "\n")

	test_seed_system()
	test_rng_sequence()
	test_asteroid_generation()

	print("\n" + "="*60)
	print("  ALL TESTS COMPLETE")
	print("="*60 + "\n")

# ============================================================================
# TEST 1: SEED GENERATION
# ============================================================================

func test_seed_system():
	print("TEST 1: Seed Generation")
	print("-" * 40)

	var seed_system = SeedSystem.new()

	# Test known seed values (must match JavaScript)
	var test_cases = [
		{
			"asset_type": "asteroid",
			"item_id": "ORE_T1_001",
			"variant": "iron",
			"frame": 0,
			"expected": 2847563891  # Known from JavaScript
		},
		{
			"asset_type": "projectile",
			"item_id": "WEAPON_FLAK_001",
			"variant": "standard",
			"frame": 0,
			"expected": null  # Unknown, just generate
		}
	]

	var passed = 0
	var failed = 0

	for test in test_cases:
		var seed = seed_system.generate_seed(
			test.asset_type,
			test.item_id,
			test.variant,
			test.frame
		)

		if test.expected != null:
			if seed == test.expected:
				print("  ✓ %s/%s/%s → %d (MATCH)" % [
					test.asset_type, test.item_id, test.variant, seed
				])
				passed += 1
			else:
				print("  ✗ %s/%s/%s → %d (expected %d) FAIL" % [
					test.asset_type, test.item_id, test.variant, seed, test.expected
				])
				failed += 1
		else:
			print("  • %s/%s/%s → %d" % [
				test.asset_type, test.item_id, test.variant, seed
			])

	print("\nSeed Generation: %d passed, %d failed" % [passed, failed])
	print("")

# ============================================================================
# TEST 2: RNG SEQUENCE
# ============================================================================

func test_rng_sequence():
	print("TEST 2: RNG Sequence (should match JavaScript)")
	print("-" * 40)

	var seed_system = SeedSystem.new()
	var rng = seed_system.create_rng(12345)

	print("  Seed: 12345")
	print("  First 10 random values:")

	for i in range(10):
		var value = rng.next()
		print("    [%d] %.8f" % [i, value])

	print("\n  Gaussian distribution (mean=0, stdDev=1):")
	rng = seed_system.create_rng(54321)
	for i in range(5):
		var value = rng.next_gaussian(0.0, 1.0)
		print("    [%d] %.6f" % [i, value])

	print("\n  Verify these values match JavaScript output!")
	print("")

# ============================================================================
# TEST 3: ASTEROID GENERATION
# ============================================================================

func test_asteroid_generation():
	print("TEST 3: Asteroid Material Generation")
	print("-" * 40)

	var generator = ProceduralAssetGenerator.new()
	add_child(generator)

	# Test asteroid generation
	var test_ores = [
		{"id": "ORE_T1_001", "variant": "iron", "preset": "T1_Iron"},
		{"id": "ORE_T3_042", "variant": "titanium", "preset": "T3_Titanium_Elongated"},
		{"id": "ORE_T5_100", "variant": "platinum", "preset": "T5_Platinum_Crystalline"}
	]

	for ore in test_ores:
		var material = generator.generate_asteroid_material(
			ore.id,
			ore.variant,
			0,
			ore.preset
		)

		if material:
			var seed = generator.get_seed_for_item(ore.id, ore.variant, 0)
			print("  ✓ %s (%s) → Seed: %d [%s]" % [
				ore.id, ore.variant, seed, ore.preset
			])

			# Get some parameter values
			var elongation_x = material.get_shader_parameter("elongation_x")
			var crater_density = material.get_shader_parameter("crater_density")
			print("    Parameters: elongation_x=%.2f, crater_density=%d" % [
				elongation_x, crater_density
			])
		else:
			print("  ✗ %s (%s) → FAILED to generate material!" % [
				ore.id, ore.variant
			])

	print("")

	# Cleanup
	generator.queue_free()

# ============================================================================
# HTML COMPARISON INSTRUCTIONS
# ============================================================================

func _exit_tree():
	print("\n" + "="*60)
	print("  TO VERIFY IN HTML GENERATOR:")
	print("="*60)
	print("\n1. Open: asset-generator/generators/asteroid.html")
	print("2. Set Item ID: ORE_T1_001")
	print("3. Set Variant: iron")
	print("4. Check seed: Should be 2847563891")
	print("\n5. Compare visual output:")
	print("   - Same shape type")
	print("   - Same crater pattern")
	print("   - Same ore veins")
	print("\nIf seeds match → 100% reproduction achieved! ✓")
	print("="*60 + "\n")
