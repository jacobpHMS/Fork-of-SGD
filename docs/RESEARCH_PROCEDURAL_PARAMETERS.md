# RESEARCH: PROCEDURAL GENERATION PARAMETERS

## Research Date: 2025-11-20
## Sources: Industry Tools, Academic Papers, Game Development Resources

---

## 1. HOUDINI PROCEDURAL ROCK/ASTEROID GENERATION

### Key Parameters from SideFX Research

**Source**: SideFX.com Tutorials - "Building an Asteroid Maker HDA", "Procedural Rocks using VOPs"

#### Base Shape Parameters:
- **Noise Frequency Scaling**: Y-axis stretched Worley noise creates vertically elongated cells
- **Displacement Amplitude**: Controls surface roughness
- **Subdivision Level**: High-res mesh detail (LOD system)
- **Base Primitive**: Sphere, icosphere, or custom mesh

#### Surface Detail (Houdini VOP-based):
- **Multi-Octave Noise**: 3-8 octaves of layered Perlin/Worley noise
- **Triplanar Displacement**: No UV unwrapping needed (Houdini Labs tool)
- **Crater Generation**: Distance field circles with negative displacement
- **Vein Systems**: Voronoi-based branching patterns

#### Copy Attributes (For Instancing):
- `@orient` (quaternion) - Rotation
- `@scale` (3 floats) - Non-uniform scaling
- `@N` (vector) - Normal direction
- `@pscale` (float) - Uniform scale

**Key Insight**: Houdini uses **procedural stacking** - start simple (sphere), add layers of deformation

---

## 2. UNITY VFX GRAPH - PARTICLE & BEAM SYSTEMS

### Key Parameters from Unity Documentation

**Source**: Unity VFX Graph Manual, Gabriel Aguiar VFX Tutorials

#### Beam/Laser Parameters:
- **Mesh-Based Approach**: Elongated cylinders without caps
- **Layering System**: 3+ meshes with different materials for depth
  - Core layer (bright, narrow)
  - Glow layer (wide, semi-transparent)
  - Distortion layer (UV scroll, noise)

#### Shader Graph Integration:
- **Scroll Speed**: UV offset over time
- **Mask Textures**: Control beam shape/falloff
- **Distortion Maps**: Heat shimmer effect
- **HDR Color**: Bloom-compatible values (>1.0)

#### Particle System Parameters:
- **Spawn Rate**: Particles/second
- **Lifetime**: Duration before fade
- **Size Over Lifetime**: Growth/shrink curves
- **Color Over Lifetime**: Gradient ramps
- **Velocity**: Initial direction + inheritance
- **Drag**: Air resistance simulation
- **Noise Turbulence**: Brownian motion

**Key Insight**: Unity VFX Graph emphasizes **GPU acceleration** and **data-oriented design**

---

## 3. BLENDER GEOMETRY NODES - PROCEDURAL DEFORMATION

### Key Parameters from Blender Documentation

**Source**: Blender Manual, Community Tutorials

#### Deformation Techniques:
- **Set Position Node**: Offset vertices by texture/noise values
- **Nearest Surface**: Use cage meshes for complex deformations
- **Instance ID as Seed**: Randomize per-instance without affecting neighbors
- **Attribute Capture**: Store pre-deformation data for masks

#### Procedural Modifiers:
- **Displace Modifier**: Texture-driven vertex offset
- **Simple Deform**: Twist, bend, taper, stretch
- **Curve Deform**: Wrap geometry along spline
- **Lattice**: Volume-based deformation cage

#### Instance Manipulation:
- **Random Phase Offset**: `sin(time + instanceID)` for variation
- **Procedural Scale**: Noise-based size variation
- **Domain Warping**: Distort noise space before sampling

**Key Insight**: Blender emphasizes **non-destructive workflows** and **attribute-based control**

---

## 4. ACADEMIC PAPERS - PROCEDURAL ROCK GENERATION

### Source: ResearchGate, Game Development Stack Exchange

#### "Procedural Generation of Rock Piles Using Aperiodic Tiling" (2009)
- **Voronoi Cell Method**: Anisotropic distance functions
- **Corner Cube Algorithm**: Modified for aperiodic patterns
- **Contact Surfaces**: Compute adjacency without physics sim
- **Shape Control**: Parameterized distance metrics

#### Terrain Generation Techniques (2016 Survey)
- **Perlin/Simplex Noise**: Fractal variants (fBm)
- **Spectral Synthesis**: Fourier-based terrain
- **Erosion Simulation**: Hydraulic/thermal weathering
- **L-Systems**: Grammar-based structure generation

#### Common Approaches from Game Dev Community:
1. **Sphere Deformation**: Start with sphere, randomly flatten/scrape regions
2. **3D Noise Displacement**: Push/pull vertices based on 3D noise field
3. **SDF Composition**: Combine multiple signed distance functions
4. **Metaball Fusion**: Blob-based organic shapes

**Key Insight**: Academic approaches favor **mathematical rigor** over real-time performance

---

## 5. GAME VFX BEST PRACTICES

### Source: GDC Vault, 80.lv Breakdowns, ArtStation

#### Asteroid Generation (Darksiders 3 approach):
- **ZBrush-style Noise Mixing**: Multiple noise types blended
- **Edge Detection**: Sharpen broken surfaces
- **Material Zones**: Ore veins as separate masks

#### Weapon VFX Principles:
1. **Readability**: Player must instantly recognize weapon type
2. **Screen-Space Effects**: Distortion, chromatic aberration for impact
3. **Anticipation**: Charge-up effects telegraph attacks
4. **Falloff Curves**: Exponential fade for glows (not linear)

#### Beam Weapon Structure (Industry Standard):
- **3-Layer System**:
  1. Core (100% opacity, narrow)
  2. Inner Glow (50% opacity, 2x width)
  3. Outer Glow (20% opacity, 4x width)
- **UV Animation**: Scroll textures in opposite directions
- **Noise Distortion**: Apply in tangent space
- **Impact Point**: Separate particle system

#### Plasma Projectile Structure:
- **Blob Core**: Pulsing sphere with noise displacement
- **Energy Field**: Scrolling Voronoi texture
- **Electric Arcs**: Procedural lightning using line renderers
- **Trail**: Fading particles with size decay

**Key Insight**: Professional VFX emphasizes **clarity over realism** in gameplay contexts

---

## 6. PARAMETER EXTRACTION SUMMARY

### Asteroid Shape (25+ Parameters)
From research, key parameters identified:
- **Base Shape** (8): Type, Elongation XYZ, Asymmetry, Roundness, Facets, Twist
- **Surface Detail** (7): Roughness, Noise Scale/Octaves/Type, Crater Density/Depth/Variance
- **Deformation** (6): Dents, Bulges, Breaks, Warp Strength
- **Material** (4): Ore Veins, Glow, Metallic, Color

### Weapon Systems (150+ Parameters Total)

#### Flak/Scatter (35+):
- Projectile shape, count, scatter angle, launch pattern
- Trail effects, turbulence, color shift
- Impact radius, particle count, shockwave

#### Plasma (40+):
- Blob type, size, pulsation, irregularity
- Energy turbulence, electric arcs, warp strength
- Charge phase, glow/emission, trail dissipation
- Temperature-based color (blackbody radiation)

#### Beam/Laser (45+):
- Beam geometry, width taper, segments
- Core/corona structure, layer count
- Heat shimmer, noise distortion, chromatic aberration
- Pulse behavior, duty cycle, envelope
- Impact hotspot, surface deformation

#### Kinetic (30+):
- Shell type, size, rotation, tracer
- Muzzle flash, smoke duration
- Impact sparks, dent size, ricochet
- Armor penetration visuals

#### Capital Ship (50+):
- Scale multipliers, charge time
- Multi-stage effects, venting, barrel glow
- Screen effects, camera shake, chromatic pulse

---

## 7. IMPLEMENTATION RECOMMENDATIONS

### Priority 1: Core Parameters
1. Implement **deterministic seed system** (all parameters reproducible)
2. Create **variance ranges** (min/max for each parameter)
3. Build **preset library** (T1-T6 defaults per asset type)

### Priority 2: Visualization
1. **Real-time preview** with parameter adjustment
2. **8-frame animation** system for projectiles
3. **Comparison view** (show multiple variants side-by-side)

### Priority 3: Database Integration
1. **Auto-naming** based on parameters
2. **Metadata export** (JSON with full parameter set)
3. **Godot import pipeline** (direct .import file generation)

---

## 8. TOOL INSPIRATION MATRIX

| Feature | Source Tool | Implementation |
|---------|-------------|----------------|
| **SDF-based shapes** | Houdini VOPs | GLSL shader with SDF primitives |
| **Layered noise** | Blender Geometry Nodes | Multi-octave fBm |
| **Beam layering** | Unity VFX Graph | Multiple canvas layers with blend modes |
| **GPU particles** | Unreal Niagara | HTML5 Canvas + WebGL fallback |
| **Blackbody color** | Academic papers | Temperature → RGB lookup table |
| **Material zones** | Substance Designer | Mask-based blending |
| **Voronoi veins** | Houdini | Distance-based branching |
| **Screen shake** | Game Maker Studio | Trauma-based camera offset |

---

## 9. REFERENCES

### Official Documentation:
- SideFX Houdini Tutorials: https://www.sidefx.com/tutorials/
- Unity VFX Graph Manual: https://docs.unity3d.com/Manual/VFXGraph.html
- Blender Geometry Nodes: https://docs.blender.org/manual/en/latest/modeling/geometry_nodes/

### Academic:
- "Procedural Generation of Rock Piles Using Aperiodic Tiling" (Siggraph 2009)
- "Algorithms and Approaches for Procedural Terrain Generation" (2016)

### Community:
- Gabriel Aguiar VFX Tutorials: https://www.gabrielaguiarprod.com/tutorials
- 80.lv Breakdown Articles: https://80.lv/articles/
- Real Time VFX Community: https://realtimevfx.com/

---

## 10. NEXT STEPS

1. **Implement parameter JSON schemas** for all 200+ parameters
2. **Create UI mockups** with collapsible sections
3. **Build shader library** (asteroid SDF, plasma blob, beam core)
4. **Develop seed system** (CRC32-based hashing)
5. **Performance test** (1000+ simultaneous assets)

---

**Document Status**: Research Complete
**Implementation Phase**: Ready to Begin
**Estimated Parameters**: 220+ across all systems
