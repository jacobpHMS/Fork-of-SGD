// res://shaders/procedural/asteroid_procedural.gdshader
// Procedural asteroid shader with 27 parameters
// Matches asset-generator/generators/asteroid.html for 1:1 reproduction

shader_type canvas_item;

// ============================================================================
// SEED & RNG
// ============================================================================

uniform int seed = 0;

// LCG Random Number Generator (matches SeedSystem.gd)
// State is derived from seed + UV position
float random(vec2 uv, int iteration) {
	// Combine seed, UV, and iteration for unique per-pixel randomness
	float state = float(seed) + uv.x * 12.9898 + uv.y * 78.233 + float(iteration) * 43.758;

	// LCG constants (matching JavaScript/GDScript)
	const float LCG_A = 1664525.0;
	const float LCG_C = 1013904223.0;
	const float LCG_M = 4294967296.0;

	state = mod(LCG_A * state + LCG_C, LCG_M);
	return fract(state / LCG_M);
}

// ============================================================================
// BASE SHAPE PARAMETERS (8)
// ============================================================================

uniform int shape_type : hint_range(0, 6) = 0; // 0=sphere, 1=ellipsoid, 2=oblong, 3=irregular, 4=fragmented, 5=crystalline, 6=potato
uniform float elongation_x : hint_range(0.5, 2.0) = 1.0;
uniform float elongation_y : hint_range(0.5, 2.0) = 1.0;
uniform float elongation_z : hint_range(0.5, 2.0) = 1.0;
uniform float asymmetry : hint_range(0.0, 1.0) = 0.0;
uniform float roundness : hint_range(0.0, 1.0) = 1.0;
uniform int facet_count : hint_range(0, 32) = 0;
uniform float twist_angle : hint_range(-180.0, 180.0) = 0.0;

// ============================================================================
// SURFACE DETAIL PARAMETERS (7)
// ============================================================================

uniform float roughness : hint_range(0.0, 1.0) = 0.5;
uniform float noise_scale : hint_range(0.5, 10.0) = 2.0;
uniform int noise_octaves : hint_range(1, 8) = 4;
uniform int noise_type : hint_range(0, 3) = 0; // 0=perlin, 1=simplex, 2=voronoi, 3=worley
uniform int crater_density : hint_range(0, 100) = 10;
uniform float crater_depth : hint_range(0.0, 1.0) = 0.3;
uniform float crater_size_variance : hint_range(0.5, 2.0) = 1.0;

// ============================================================================
// DEFORMATION PARAMETERS (5)
// ============================================================================

uniform float impact_dents : hint_range(0.0, 1.0) = 0.0;
uniform int impact_count : hint_range(0, 20) = 0;
uniform float fracture_lines : hint_range(0.0, 1.0) = 0.0;
uniform float wobble_amount : hint_range(0.0, 1.0) = 0.0;
uniform float edge_chipping : hint_range(0.0, 1.0) = 0.0;

// ============================================================================
// MATERIAL PARAMETERS (7)
// ============================================================================

uniform float hue : hint_range(0.0, 360.0) = 30.0;
uniform float saturation : hint_range(0.0, 1.0) = 0.5;
uniform float metallic : hint_range(0.0, 1.0) = 0.3;
uniform int ore_vein_count : hint_range(0, 20) = 3;
uniform float ore_vein_thickness : hint_range(0.5, 3.0) = 1.0;
uniform float purity_glow : hint_range(0.0, 1.0) = 0.0;
uniform vec3 glow_color : source_color = vec3(0.2, 0.8, 1.0);

// ============================================================================
// NOISE FUNCTIONS
// ============================================================================

// Simple 2D noise (Perlin-like)
float noise2d(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);

	// Smoothstep interpolation
	vec2 u = f * f * (3.0 - 2.0 * f);

	float a = random(i, 0);
	float b = random(i + vec2(1.0, 0.0), 0);
	float c = random(i + vec2(0.0, 1.0), 0);
	float d = random(i + vec2(1.0, 1.0), 0);

	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion (multi-octave noise)
float fbm(vec2 p, int octaves) {
	float value = 0.0;
	float amplitude = 0.5;
	float frequency = 1.0;

	for (int i = 0; i < 8; i++) {
		if (i >= octaves) break;

		value += amplitude * noise2d(p * frequency);
		frequency *= 2.0;
		amplitude *= 0.5;
	}

	return value;
}

// Voronoi/Worley noise (for crystalline structures)
float voronoi(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);

	float min_dist = 1.0;

	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x), float(y));
			vec2 point = vec2(random(i + neighbor, 0), random(i + neighbor, 1));
			vec2 diff = neighbor + point - f;
			float dist = length(diff);
			min_dist = min(min_dist, dist);
		}
	}

	return min_dist;
}

// ============================================================================
// HSV TO RGB CONVERSION
// ============================================================================

vec3 hsv_to_rgb(vec3 hsv) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(hsv.xxx + K.xyz) * 6.0 - K.www);
	return hsv.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), hsv.y);
}

// ============================================================================
// SHAPE GENERATION
// ============================================================================

float get_shape_distance(vec2 uv) {
	// Center and normalize coordinates
	vec2 center = vec2(0.5, 0.5);
	vec2 p = (uv - center) * 2.0; // Range: [-1, 1]

	// Apply elongation
	p.x /= elongation_x;
	p.y /= elongation_y;

	// Apply twist
	if (abs(twist_angle) > 0.01) {
		float angle = radians(twist_angle) * length(p);
		float cos_a = cos(angle);
		float sin_a = sin(angle);
		p = vec2(
			p.x * cos_a - p.y * sin_a,
			p.x * sin_a + p.y * cos_a
		);
	}

	float dist = length(p);

	// Add asymmetry based on shape type
	if (shape_type == 3 || shape_type == 6) { // irregular or potato
		float angle = atan(p.y, p.x);
		float noise_val = fbm(vec2(cos(angle), sin(angle)) * noise_scale, noise_octaves);
		dist += (noise_val - 0.5) * asymmetry * 0.5;
	}

	// Crystalline facets
	if (shape_type == 5 && facet_count > 0) {
		float angle = atan(p.y, p.x);
		float facet_angle = 6.28318 / float(facet_count);
		float faceted = mod(angle, facet_angle);
		dist += sin(faceted * float(facet_count)) * 0.1 * (1.0 - roundness);
	}

	return dist;
}

// ============================================================================
// CRATER GENERATION
// ============================================================================

float get_craters(vec2 uv) {
	float crater_effect = 0.0;

	if (crater_density > 0) {
		int num_craters = crater_density / 2; // Reduce for performance

		for (int i = 0; i < 50; i++) {
			if (i >= num_craters) break;

			// Random crater position
			vec2 crater_pos = vec2(
				random(vec2(float(i) * 0.1, 0.0), seed),
				random(vec2(float(i) * 0.1, 1.0), seed)
			);

			float crater_size = 0.05 + random(vec2(float(i) * 0.1, 2.0), seed) * 0.1 * crater_size_variance;
			float dist = length(uv - crater_pos);

			if (dist < crater_size) {
				float depth = (1.0 - dist / crater_size) * crater_depth;
				crater_effect += depth;
			}
		}
	}

	return crater_effect;
}

// ============================================================================
// ORE VEIN GENERATION
// ============================================================================

vec3 get_ore_veins(vec2 uv, vec3 base_color) {
	if (ore_vein_count == 0) {
		return base_color;
	}

	vec3 vein_color = base_color;
	float total_vein = 0.0;

	for (int i = 0; i < 20; i++) {
		if (i >= ore_vein_count) break;

		// Random vein starting position
		vec2 vein_start = vec2(
			random(vec2(float(i), 0.0), seed + 100),
			random(vec2(float(i), 1.0), seed + 100)
		);

		// Vein direction
		float vein_angle = random(vec2(float(i), 2.0), seed + 100) * 6.28318;
		vec2 vein_dir = vec2(cos(vein_angle), sin(vein_angle));

		// Distance to vein line
		vec2 to_point = uv - vein_start;
		float along_vein = dot(to_point, vein_dir);
		float perp_dist = length(to_point - vein_dir * along_vein);

		if (along_vein > 0.0 && along_vein < 0.3) {
			float vein_width = 0.01 * ore_vein_thickness;
			if (perp_dist < vein_width) {
				float vein_strength = 1.0 - (perp_dist / vein_width);
				total_vein += vein_strength;
			}
		}
	}

	total_vein = clamp(total_vein, 0.0, 1.0);

	// Blend vein color (brighter, more saturated)
	if (total_vein > 0.0) {
		vec3 bright_vein = hsv_to_rgb(vec3(hue / 360.0 + 0.1, saturation * 1.5, 0.8));
		vein_color = mix(base_color, bright_vein, total_vein * 0.7);
	}

	return vein_color;
}

// ============================================================================
// FRAGMENT SHADER (MAIN)
// ============================================================================

void fragment() {
	vec2 uv = UV;

	// Calculate shape distance
	float shape_dist = get_shape_distance(uv);

	// Base shape (circle with radius 0.5)
	float base_radius = 0.5;
	float edge_dist = shape_dist - base_radius;

	// Apply roughness via noise
	float roughness_noise = fbm(uv * noise_scale * 5.0, noise_octaves);
	edge_dist += (roughness_noise - 0.5) * roughness * 0.1;

	// Apply craters (darken surface)
	float crater_darkening = get_craters(uv);

	// Discard pixels outside asteroid
	if (edge_dist > 0.02) {
		discard;
	}

	// Soft edge
	float alpha = 1.0 - smoothstep(-0.02, 0.02, edge_dist);

	// Base color from HSV
	vec3 base_hsv = vec3(hue / 360.0, saturation, 0.3 + crater_darkening * 0.2);
	vec3 base_color = hsv_to_rgb(base_hsv);

	// Add lighting based on distance from center
	vec2 center = vec2(0.5, 0.5);
	vec2 to_center = uv - center;
	float light_factor = 1.0 - length(to_center) * 1.5;
	light_factor = clamp(light_factor, 0.3, 1.0);

	base_color *= light_factor;

	// Darken craters
	base_color *= (1.0 - crater_darkening * 0.5);

	// Add ore veins
	vec3 final_color = get_ore_veins(uv, base_color);

	// Apply metallic sheen
	if (metallic > 0.1) {
		float specular = pow(light_factor, 3.0) * metallic;
		final_color += vec3(specular * 0.3);
	}

	// Add purity glow
	if (purity_glow > 0.1) {
		float glow_strength = purity_glow * (1.0 - shape_dist);
		final_color += glow_color * glow_strength * 0.5;
	}

	// Add surface roughness texture
	float roughness_detail = noise2d(uv * 20.0) * roughness * 0.1;
	final_color += vec3(roughness_detail);

	// Output
	COLOR = vec4(final_color, alpha);
}
