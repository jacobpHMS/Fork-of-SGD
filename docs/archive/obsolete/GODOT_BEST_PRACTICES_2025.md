# Godot 4.x Game Development Best Practices - 2025 Edition

**Project:** Space Mining Game
**Godot Version:** 4.5
**Research Date:** November 2025
**Status:** Based on latest 2024-2025 industry standards

---

## Table of Contents
1. [Modern GDScript Patterns](#1-modern-gdscript-patterns)
2. [Performance Optimization](#2-performance-optimization)
3. [Architecture Patterns](#3-architecture-patterns)
4. [Testing](#4-testing)
5. [Security](#5-security)
6. [Observability](#6-observability)
7. [Asset Management](#7-asset-management)
8. [Networking](#8-networking)
9. [State Management](#9-state-management)
10. [UI/UX](#10-uiux)
11. [Project-Specific Recommendations](#11-project-specific-recommendations)
12. [Implementation Roadmap](#12-implementation-roadmap)

---

## ⚠️ CRITICAL: Godot 3.x → 4.x Migration Issues

### Property Checking with `has()`

**BREAKING CHANGE:** In Godot 4.x, the `has()` method is **ONLY** available on Dictionaries, **NOT** on Nodes.

#### ❌ **WRONG** (Godot 3.x syntax - will crash in 4.x):
```gdscript
if player_node.has("velocity"):
    player_node.velocity = Vector2.ZERO

if mining_target.has("amount"):
    var amount = mining_target.amount

if main_scene.has("camera"):
    var camera = main_scene.camera
```

#### ✅ **CORRECT** (Godot 4.x syntax):
```gdscript
# Use "property" in node syntax
if "velocity" in player_node:
    player_node.velocity = Vector2.ZERO

if "amount" in mining_target:
    var amount = mining_target.amount

if "camera" in main_scene:
    var camera = main_scene.camera

# For methods, use has_method()
if player_node.has_method("get_ship_info"):
    var info = player_node.get_ship_info()
```

#### ✅ **Dictionary.has() is still valid**:
```gdscript
# This is CORRECT - Dictionaries still support has()
if data.has("player"):
    var player = data.player

if cargo_holds.has("ore"):
    var ore_hold = cargo_holds["ore"]
```

#### **Runtime Error Example:**
```
E 0:01:05:716   check_mining_target_depleted: Invalid call.
                Nonexistent function 'has' in base 'Area2D (Ore.gd)'.
```

#### **Migration Script:**
```bash
# Find all problematic Node.has() calls
grep -r '\.has("' scripts/ --include="*.gd" | grep -E 'player\.|main\.|node\.|target\.|ship\.'

# Replace with correct syntax (example for player_node)
sed -i 's/player_node\.has("\([^"]*\)")/"\1" in player_node/g' script.gd
```

#### **When to Use What:**
| Context | Method | Example |
|---------|--------|---------|
| Check Node property | `"property" in node` | `if "velocity" in player_node:` |
| Check Node method | `node.has_method("name")` | `if node.has_method("mine"):` |
| Check Dictionary key | `dict.has("key")` | `if data.has("player"):` |
| Check if Node valid | `is_instance_valid(node)` | `if is_instance_valid(target):` |

**Reference:** This migration issue affected 40+ files in this project and caused runtime crashes during gameplay.

---

## 1. Modern GDScript Patterns

### 1.1 Type Safety (Typed GDScript)

**Best Practice:** Use type hints everywhere for better performance, IDE support, and error detection.

**2025 Standards:**
```gdscript
# ✅ GOOD - Fully typed
class_name PlayerInventory
extends Node

signal item_added(item_id: String, quantity: int)

const MAX_SLOTS: int = 100
var items: Dictionary = {}  # String -> int
var capacity: float = 1000.0

func add_item(item_id: String, amount: int) -> bool:
    if not can_add_item(item_id, amount):
        return false

    items[item_id] = items.get(item_id, 0) + amount
    item_added.emit(item_id, amount)
    return true

func get_item_count(item_id: String) -> int:
    return items.get(item_id, 0)
```

```gdscript
# ❌ BAD - No type hints
func add_item(item_id, amount):
    items[item_id] = items.get(item_id, 0) + amount
    return true
```

**Benefits:**
- 20-30% better runtime performance with typed GDScript
- Compile-time error detection
- Better IDE autocomplete and refactoring support
- Self-documenting code

**Current Project Status:** ⚠️ **PARTIAL** - Some files use typing (TSVParser, signals), but many don't

**Implementation Priority:** 🔴 **HIGH** - Apply gradually during refactoring

**References:**
- [Official GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [GDScript Best Practices 2025 - Toxigon](https://toxigon.com/gdscript-best-practices-2025)

---

### 1.2 Static Typing for Arrays and Dictionaries

**Best Practice:** Use typed arrays for better performance and safety.

```gdscript
# ✅ GOOD
var ores: Array[Dictionary] = []
var ship_names: Array[String] = []
var positions: Array[Vector2] = []

# Type-safe dictionary patterns
var cargo_holds: Dictionary = {
    "general": {"capacity": 100.0, "used": 0.0},
    "ore": {"capacity": 500.0, "used": 0.0}
}

# ❌ BAD
var ores = []
var ship_names = []
```

**Current Project Status:** ✅ **GOOD** - DatabaseManager uses `Array[Dictionary]` consistently

---

### 1.3 Class Organization

**Best Practice:** Follow a consistent structure for all scripts.

```gdscript
class_name MyClass
extends Node

# ============================================================================
# SIGNALS
# ============================================================================
signal state_changed(new_state: int)

# ============================================================================
# CONSTANTS
# ============================================================================
const MAX_HEALTH: float = 100.0

# ============================================================================
# EXPORTS
# ============================================================================
@export var speed: float = 100.0
@export_range(0.0, 1.0) var damage_multiplier: float = 1.0

# ============================================================================
# PUBLIC VARIABLES
# ============================================================================
var health: float = MAX_HEALTH

# ============================================================================
# PRIVATE VARIABLES
# ============================================================================
var _internal_state: int = 0

# ============================================================================
# ONREADY VARIABLES
# ============================================================================
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

# ============================================================================
# LIFECYCLE METHODS
# ============================================================================
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

func _physics_process(delta: float) -> void:
    pass

# ============================================================================
# PUBLIC METHODS
# ============================================================================
func take_damage(amount: float) -> void:
    health -= amount
    if health <= 0.0:
        die()

# ============================================================================
# PRIVATE METHODS
# ============================================================================
func _calculate_damage(base: float) -> float:
    return base * damage_multiplier

func _on_area_entered(area: Area2D) -> void:
    pass
```

**Current Project Status:** ✅ **GOOD** - Player.gd uses clear section separators

**References:**
- [GDQuest Guidelines](https://www.gdquest.com/docs/guidelines/best-practices/godot-gdscript/)

---

### 1.4 Modern Signal Patterns

**Best Practice:** Use typed signals and new Godot 4 syntax.

```gdscript
# ✅ GOOD - Godot 4 typed signals
signal health_changed(old_value: float, new_value: float)
signal item_collected(item: Item, collector: Node2D)

# Connection (Godot 4 syntax)
func _ready() -> void:
    health_changed.connect(_on_health_changed)
    # Or with callable
    $Button.pressed.connect(func(): print("Pressed"))

func _on_health_changed(old: float, new: float) -> void:
    print("Health: %s -> %s" % [old, new])

# ❌ BAD - Godot 3 syntax
signal health_changed

func _ready():
    connect("health_changed", self, "_on_health_changed")
```

**Current Project Status:** ✅ **EXCELLENT** - Already using typed signals in Player.gd

---

### 1.5 Composition Over Inheritance

**Best Practice:** Use components and composition instead of deep inheritance hierarchies.

```gdscript
# ✅ GOOD - Component-based
class_name Ship
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var cargo_component: CargoComponent = $CargoComponent
@onready var mining_component: MiningComponent = $MiningComponent

func take_damage(amount: float) -> void:
    health_component.take_damage(amount)

# ✅ GOOD - Reusable component
class_name HealthComponent
extends Node

signal died()
signal health_changed(current: float, maximum: float)

@export var max_health: float = 100.0
var current_health: float = max_health

func take_damage(amount: float) -> void:
    current_health = max(0.0, current_health - amount)
    health_changed.emit(current_health, max_health)
    if current_health <= 0.0:
        died.emit()

# ❌ BAD - Deep inheritance
class_name BaseShip extends Node2D
class_name MilitaryShip extends BaseShip
class_name Fighter extends MilitaryShip
class_name HeavyFighter extends Fighter
```

**Current Project Status:** ⚠️ **MIXED** - Has some inheritance (BaseShip), could benefit from more components

**Implementation Priority:** 🟡 **MEDIUM** - Gradually refactor complex classes

**References:**
- [Entity-Component Pattern - GDQuest](https://www.gdquest.com/tutorial/godot/design-patterns/entity-component-pattern/)

---

## 2. Performance Optimization

### 2.1 Multithreading (Godot 4)

**Best Practice:** Offload heavy computations to worker threads.

```gdscript
# ✅ GOOD - Worker thread for pathfinding
class_name PathfindingManager
extends Node

var worker_thread: Thread = null
var mutex: Mutex = Mutex.new()
var path_result: PackedVector2Array = []
var is_calculating: bool = false

func calculate_path_async(start: Vector2, end: Vector2) -> void:
    if worker_thread and worker_thread.is_alive():
        return  # Already calculating

    worker_thread = Thread.new()
    worker_thread.start(_calculate_path_threaded.bind(start, end))

func _calculate_path_threaded(start: Vector2, end: Vector2) -> void:
    var result = _expensive_pathfinding(start, end)

    mutex.lock()
    path_result = result
    is_calculating = false
    mutex.unlock()

func get_path_result() -> PackedVector2Array:
    mutex.lock()
    var result = path_result.duplicate()
    mutex.unlock()
    return result

func _exit_tree() -> void:
    if worker_thread and worker_thread.is_alive():
        worker_thread.wait_to_finish()
```

**2025 Update:** Godot 4 has improved multithreading:
- Vulkan secondary command buffers for parallel rendering
- Multi-threaded culling
- Better thread pool management

**Threading Rules:**
- **1-2 threads per CPU core** (1 for non-hyperthreaded, 2 for hyperthreaded CPUs)
- Always use Mutex for shared data
- Never access SceneTree from threads (use call_deferred)

**Current Project Status:** ❌ **NONE** - No multithreading implemented

**Implementation Priority:** 🟡 **MEDIUM** - Consider for AI pathfinding, economy calculations

**References:**
- [Godot 4.0 Multithreading Guide - Howik](https://howik.com/godot-performance-optimization-guide)
- [Official Performance Tips](https://docs.godotengine.org/en/stable/tutorials/performance/general_optimization.html)

---

### 2.2 Object Pooling

**Best Practice:** Reuse objects instead of creating/destroying them.

```gdscript
# ✅ GOOD - Object pool
class_name ProjectilePool
extends Node

@export var projectile_scene: PackedScene
@export var initial_pool_size: int = 50

var pool: Array[Node] = []
var active_projectiles: Array[Node] = []

func _ready() -> void:
    _initialize_pool()

func _initialize_pool() -> void:
    for i in range(initial_pool_size):
        var projectile = projectile_scene.instantiate()
        projectile.visible = false
        add_child(projectile)
        pool.append(projectile)

func get_projectile() -> Node:
    var projectile: Node

    if pool.is_empty():
        # Pool exhausted, create new
        projectile = projectile_scene.instantiate()
        add_child(projectile)
    else:
        projectile = pool.pop_back()

    projectile.visible = true
    active_projectiles.append(projectile)
    return projectile

func return_projectile(projectile: Node) -> void:
    if projectile in active_projectiles:
        active_projectiles.erase(projectile)
        projectile.visible = false
        pool.append(projectile)
```

**Use Cases for This Project:**
- Mining laser effects
- Ore particles/crates
- UI elements that spawn frequently
- Projectiles (if combat is added)

**Current Project Status:** ❌ **NONE** - Objects are instantiated/freed normally

**Implementation Priority:** 🟡 **MEDIUM** - Especially for CargoCrate spawning

---

### 2.3 Scene Optimization

**Best Practice:** Keep scene tree as simple as possible.

```gdscript
# ✅ GOOD - Optimized scene structure
Player (CharacterBody2D)
├── CollisionShape2D
├── Sprite2D
├── Components
│   ├── HealthComponent
│   ├── CargoComponent
│   └── MiningComponent
└── UI
    └── StatusDisplay

# ❌ BAD - Bloated scene tree
Player (CharacterBody2D)
├── CollisionShape2D
├── Sprite2D
├── Node2D (empty wrapper)
│   ├── Node2D (another wrapper)
│   │   ├── Node2D (why?)
│   │   │   └── HealthDisplay
```

**Optimization Techniques:**
- **Instancing:** Use instanced scenes for repeated objects (ore asteroids)
- **LOD (Level of Detail):** Reduce distant object complexity
- **Occlusion Culling:** Only render visible objects
- **Viewport Culling:** Disable processing for off-screen nodes

**Current Project Status:** ✅ **GOOD** - Scene structure appears reasonable

---

### 2.4 Memory Management

**Best Practice:** Avoid memory leaks and minimize allocations.

```gdscript
# ✅ GOOD - Proper cleanup
class_name ResourceLoader
extends Node

var loaded_textures: Dictionary = {}  # String -> Texture2D

func load_texture(path: String) -> Texture2D:
    if path in loaded_textures:
        return loaded_textures[path]

    var texture = load(path) as Texture2D
    loaded_textures[path] = texture
    return texture

func clear_cache() -> void:
    loaded_textures.clear()

func _exit_tree() -> void:
    clear_cache()

# ❌ BAD - Memory leak
func _process(delta: float) -> void:
    var temp_array = []  # Creates new array every frame!
    for i in range(1000):
        temp_array.append(i)
```

**Best Practices:**
- Reuse arrays/dictionaries instead of creating new ones
- Clear large data structures when no longer needed
- Use `queue_free()` instead of `free()` for nodes
- Monitor memory usage in the profiler

**Current Project Status:** ⚠️ **UNKNOWN** - Needs profiling

**Implementation Priority:** 🟢 **LOW** - Profile first, then optimize

---

## 3. Architecture Patterns

### 3.1 Service Locator Pattern (Current)

**Your Current Implementation:**
```gdscript
# Autoload singletons (project.godot)
OreDatabase
SaveManager
SoundManager
SkillManager
DragManager
DatabaseManager
AssetManager
ItemDatabase
ShipDatabase
```

**Pros:**
- ✅ Easy to access from anywhere
- ✅ Simple to understand
- ✅ Good for small-medium projects

**Cons:**
- ⚠️ Can become a "god object" anti-pattern
- ⚠️ Harder to test (tight coupling)
- ⚠️ Hidden dependencies

**Current Status:** ✅ **APPROPRIATE** for project size

**When to Reconsider:** If project grows beyond 100k lines or needs extensive testing

---

### 3.2 Dependency Injection

**Best Practice:** Pass dependencies explicitly for better testability.

```gdscript
# ✅ GOOD - Dependency injection
class_name Ship
extends CharacterBody2D

var cargo_system: CargoSystem
var mining_system: MiningSystem

func _init(cargo: CargoSystem = null, mining: MiningSystem = null) -> void:
    self.cargo_system = cargo if cargo else CargoSystem.new()
    self.mining_system = mining if mining else MiningSystem.new()

func mine_ore(ore: Node2D) -> void:
    var mined = mining_system.mine(ore)
    cargo_system.add_item(mined)

# ❌ BAD - Hard dependency on singletons
func mine_ore(ore: Node2D) -> void:
    var mined = MiningManager.mine(ore)  # Can't test or replace
    CargoManager.add_item(mined)
```

**Current Project Status:** ❌ **NONE** - Uses autoload pattern exclusively

**Implementation Priority:** 🟢 **LOW** - Only needed if testing becomes priority

**References:**
- [Game Development Patterns with Godot 4 - Book](https://www.packtpub.com/en-us/product/game-development-patterns-with-godot-4-9781835880296)

---

### 3.3 Entity-Component System (ECS)

**Best Practice:** Use ECS for performance-critical simulations with many entities.

**When to Use ECS:**
- Hundreds/thousands of similar entities (asteroids, projectiles)
- Need cache-friendly memory layout
- Performance is critical

**When NOT to Use ECS:**
- Small number of entities (< 100)
- Complex unique behaviors per entity
- Godot's node system works fine

**Available Solutions:**
- **GECS** - Lightweight ECS for Godot 4 ([Asset Library](https://godotengine.org/asset-library/asset/3481))
- **Bevy ECS** - Rust-based ECS via GDExtension
- **Custom Entity-Component Pattern** - Lighter than full ECS

**Current Project Status:** ❌ **NOT NEEDED** - Ship/station counts are low

**Implementation Priority:** 🟢 **LOW** - Consider only if adding 1000+ asteroids

**References:**
- [Bevy ECS in Godot](https://gamefromscratch.com/bevy-ecs-in-godot-engine/)
- [GECS Documentation](https://csprance.com/blog/gecs)

---

### 3.4 Event Bus Pattern

**Best Practice:** Decouple systems with a central event bus.

```gdscript
# ✅ GOOD - Global event bus
# res://autoload/event_bus.gd
extends Node

# Game events
signal game_paused()
signal game_resumed()
signal game_over()

# Combat events
signal enemy_died(enemy: Node2D)
signal player_damaged(damage: float)

# Economy events
signal item_purchased(item_id: String, price: float)
signal ore_sold(ore_id: String, amount: float, profit: float)

# Usage in any script:
func _on_enemy_killed() -> void:
    EventBus.enemy_died.emit(enemy)

func _ready() -> void:
    EventBus.ore_sold.connect(_on_ore_sold)
```

**Benefits:**
- Reduces coupling between systems
- Easy to add new listeners
- Centralized event documentation

**Current Project Status:** ❌ **NONE** - Uses direct signal connections

**Implementation Priority:** 🟡 **MEDIUM** - Would help with complex interactions

---

## 4. Testing

### 4.1 GUT Framework (Godot Unit Test)

**Best Practice:** Implement unit testing for critical game logic.

**Installation:**
1. Download GUT 9.5.0 from [Asset Library](https://godotengine.org/asset-library/asset/1709)
2. Install to `res://addons/gut/`
3. Enable plugin in Project Settings

**Basic Test Structure:**
```gdscript
# res://test/unit/test_cargo_system.gd
extends GutTest

var cargo_system: CargoSystem

func before_each():
    cargo_system = CargoSystem.new()
    cargo_system.set_capacity(CargoType.ORE, 1000.0)

func after_each():
    cargo_system.free()

func test_add_item_within_capacity():
    var result = cargo_system.add_item("iron_ore", 500.0, CargoType.ORE)
    assert_true(result, "Should successfully add item")
    assert_eq(cargo_system.get_used_space(CargoType.ORE), 500.0)

func test_add_item_exceeds_capacity():
    cargo_system.add_item("iron_ore", 900.0, CargoType.ORE)
    var result = cargo_system.add_item("iron_ore", 200.0, CargoType.ORE)
    assert_false(result, "Should fail to add item exceeding capacity")

func test_remove_item():
    cargo_system.add_item("iron_ore", 500.0, CargoType.ORE)
    var result = cargo_system.remove_item("iron_ore", 200.0)
    assert_eq(result, 200.0, "Should remove 200.0 units")
    assert_eq(cargo_system.get_item_amount("iron_ore"), 300.0)
```

**Directory Structure:**
```
res://
├── test/
│   ├── unit/          # Fast unit tests
│   │   ├── test_cargo_system.gd
│   │   ├── test_ore_database.gd
│   │   └── test_save_manager.gd
│   └── integration/   # Slower integration tests
│       ├── test_mining_workflow.gd
│       └── test_trading_system.gd
```

**Running Tests:**
- Editor: Create GUT panel (Project > Tools > Gut Panel)
- Command line: `godot --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit`
- VSCode: Use GUT extension

**Current Project Status:** ❌ **NONE** - No testing framework

**Implementation Priority:** 🔴 **HIGH** - Critical for preventing regressions

**What to Test:**
1. **Cargo System** - Add/remove items, capacity checks
2. **Mining System** - Ore extraction calculations
3. **Save/Load** - Data persistence
4. **Database Queries** - Item lookups
5. **Economy Calculations** - Price calculations

**References:**
- [GUT Documentation](https://gut.readthedocs.io/)
- [GUT GitHub](https://github.com/bitwes/Gut)
- [Unit Testing Blog Post](https://blog.bigturtleworks.com/posts/unit-testing-godot-gut/)

---

### 4.2 Testing Best Practices

**Best Practices:**

```gdscript
# ✅ GOOD - Tests are independent
func before_each():
    game_state = GameState.new()

func after_each():
    game_state.free()

# ✅ GOOD - Descriptive test names
func test_player_takes_damage_reduces_health():
    pass

func test_player_dies_when_health_reaches_zero():
    pass

# ❌ BAD - Generic test names
func test_1():
    pass

# ✅ GOOD - Test one thing
func test_cargo_add_item_increases_used_space():
    cargo.add_item("ore", 100.0)
    assert_eq(cargo.used_space, 100.0)

# ❌ BAD - Test multiple things
func test_cargo_system():
    cargo.add_item("ore", 100.0)
    cargo.remove_item("ore", 50.0)
    cargo.clear()
    # Too much in one test!
```

---

## 5. Security

### 5.1 Save File Security

**Best Practice:** Encrypt sensitive save data to prevent cheating.

**Current Implementation:**
```gdscript
# Your current SaveManager.gd
func write_save_file(save_path: String) -> bool:
    var file = FileAccess.open(save_path, FileAccess.WRITE)
    file.store_var(current_game_data)
    # ⚠️ Unencrypted - easy to modify
```

**Improved Implementation:**
```gdscript
# ✅ GOOD - Encrypted saves
class_name SecureSaveManager
extends Node

const ENCRYPTION_KEY = "your-32-byte-encryption-key-here!"  # 32 bytes for AES-256
const SAVE_VERSION = 1

func save_game_encrypted(slot: int) -> bool:
    var save_path = get_save_path(slot)
    var save_data = collect_game_data()

    # Add version and checksum
    var final_data = {
        "version": SAVE_VERSION,
        "data": save_data,
        "checksum": _calculate_checksum(save_data)
    }

    var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, ENCRYPTION_KEY)
    if file == null:
        push_error("Failed to create encrypted save file")
        return false

    file.store_var(final_data)
    file.close()
    return true

func load_game_encrypted(slot: int) -> bool:
    var save_path = get_save_path(slot)

    if not FileAccess.file_exists(save_path):
        return false

    var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ, ENCRYPTION_KEY)
    if file == null:
        push_error("Failed to open encrypted save file - wrong key?")
        return false

    var loaded_data = file.get_var()
    file.close()

    # Validate checksum
    if not _validate_checksum(loaded_data):
        push_error("Save file corrupted - checksum mismatch")
        return false

    # Check version
    if loaded_data.version != SAVE_VERSION:
        push_warning("Save file version mismatch - attempting migration")
        loaded_data = migrate_save_data(loaded_data)

    apply_game_data(loaded_data.data)
    return true

func _calculate_checksum(data: Dictionary) -> String:
    var json = JSON.stringify(data)
    return json.sha256_text()

func _validate_checksum(loaded_data: Dictionary) -> bool:
    if not "checksum" in loaded_data:
        return false
    var expected = loaded_data.checksum
    var actual = _calculate_checksum(loaded_data.data)
    return expected == actual
```

**Additional Security Measures:**
```gdscript
# Obfuscate save data order
func obfuscate_data(data: Dictionary) -> Dictionary:
    var keys = data.keys()
    keys.shuffle()
    var obfuscated = {}
    for key in keys:
        obfuscated[key] = data[key]
    return obfuscated
```

**Current Project Status:** ❌ **UNENCRYPTED** - Save files are plain text

**Implementation Priority:** 🟡 **MEDIUM** - Important to prevent save editing

**References:**
- [Encrypting Save Games - Godot Docs](https://docs.huihoo.com/godotengine/godot-docs/godot/tutorials/engine/encrypting_save_games.html)

---

### 5.2 Anti-Cheat for Memory Editing

**Best Practice:** Use anti-cheat plugin for sensitive values.

**Available Solution:** Anti-cheating-value-plus (November 2024)
- [Asset Library Link](https://godotengine.org/asset-library/asset/3522)

**Manual Implementation:**
```gdscript
# ✅ GOOD - Protected value
class_name ProtectedFloat
extends RefCounted

var _value: float = 0.0
var _checksum: int = 0
var _offset: float = 0.0

func _init(initial_value: float = 0.0):
    _offset = randf() * 1000.0
    set_value(initial_value)

func set_value(value: float) -> void:
    _value = value + _offset
    _checksum = _calculate_checksum(value)

func get_value() -> float:
    var actual_value = _value - _offset
    if _checksum != _calculate_checksum(actual_value):
        push_error("Value tampered! Possible memory hack detected.")
        return 0.0  # Or trigger anti-cheat response
    return actual_value

func _calculate_checksum(value: float) -> int:
    return int(value * 12345.67) ^ 0xDEADBEEF

# Usage:
var player_credits: ProtectedFloat = ProtectedFloat.new(1000.0)

func add_credits(amount: float) -> void:
    player_credits.set_value(player_credits.get_value() + amount)
```

**What to Protect:**
- Player credits/money
- Skill points
- Rare items
- High-value cargo

**Current Project Status:** ❌ **NONE** - Values are unprotected

**Implementation Priority:** 🟢 **LOW** - Only critical for multiplayer or competitive modes

---

### 5.3 Resource Protection

**Best Practice:** Prevent extraction of game assets.

**PCK Encryption:**
```bash
# Export with encryption (Project > Export)
# In export preset:
# - Enable "Encrypt PCK"
# - Set encryption key (256-bit hex string)
```

**Script Encryption:**
```gdscript
# Project Settings > Script Encryption Key
# Encrypts .gdc files in export
```

**Limitations:**
- ⚠️ Not foolproof - determined hackers can still extract
- ✅ Prevents casual asset ripping
- ✅ Good for commercial projects

**Current Project Status:** ⚠️ **UNKNOWN** - Check export settings

**Implementation Priority:** 🟢 **LOW** - Only critical near release

---

## 6. Observability

### 6.1 Custom Logger System

**Best Practice:** Implement structured logging for debugging.

```gdscript
# res://autoload/logger.gd
class_name Logger
extends Node

enum Level { DEBUG, INFO, WARNING, ERROR, CRITICAL }

const LOG_FILE_PATH = "user://logs/game.log"
const MAX_LOG_SIZE = 10_000_000  # 10 MB

var min_log_level: Level = Level.INFO
var log_to_file: bool = true
var log_to_console: bool = true

func _ready() -> void:
    _ensure_log_directory()

func debug(message: String, context: Dictionary = {}) -> void:
    _log(Level.DEBUG, message, context)

func info(message: String, context: Dictionary = {}) -> void:
    _log(Level.INFO, message, context)

func warning(message: String, context: Dictionary = {}) -> void:
    _log(Level.WARNING, message, context)

func error(message: String, context: Dictionary = {}) -> void:
    _log(Level.ERROR, message, context)

func critical(message: String, context: Dictionary = {}) -> void:
    _log(Level.CRITICAL, message, context)

func _log(level: Level, message: String, context: Dictionary) -> void:
    if level < min_log_level:
        return

    var timestamp = Time.get_datetime_string_from_system()
    var level_str = Level.keys()[level]
    var context_str = JSON.stringify(context) if not context.is_empty() else ""

    var log_entry = "[%s] [%s] %s %s" % [timestamp, level_str, message, context_str]

    if log_to_console:
        _print_to_console(level, log_entry)

    if log_to_file:
        _write_to_file(log_entry)

func _print_to_console(level: Level, message: String) -> void:
    match level:
        Level.DEBUG:
            print_debug(message)
        Level.INFO:
            print(message)
        Level.WARNING:
            push_warning(message)
        Level.ERROR, Level.CRITICAL:
            push_error(message)

func _write_to_file(message: String) -> void:
    var file = FileAccess.open(LOG_FILE_PATH, FileAccess.READ_WRITE)
    if file == null:
        file = FileAccess.open(LOG_FILE_PATH, FileAccess.WRITE)

    if file:
        file.seek_end()
        file.store_line(message)
        file.close()

func _ensure_log_directory() -> void:
    var dir = DirAccess.open("user://")
    if not dir.dir_exists("logs"):
        dir.make_dir("logs")

# Usage:
Logger.info("Game started", {"version": "0.3.0"})
Logger.warning("Low fuel", {"fuel": player.fuel, "max": player.max_fuel})
Logger.error("Failed to load save", {"slot": slot, "error": err})
```

**Usage Examples:**
```gdscript
# In Player.gd
func mine_ore(ore: Node2D) -> void:
    Logger.debug("Mining started", {
        "ore_type": ore.ore_id,
        "player_pos": global_position,
        "cargo_used": cargo_used
    })

    var result = _perform_mining(ore)

    if result:
        Logger.info("Ore mined successfully", {
            "ore_type": ore.ore_id,
            "amount": result.amount
        })
    else:
        Logger.warning("Mining failed", {
            "ore_type": ore.ore_id,
            "reason": result.error
        })
```

**Current Project Status:** ❌ **NONE** - Uses basic print() statements

**Implementation Priority:** 🟡 **MEDIUM** - Very helpful for debugging complex issues

**References:**
- [Writing a Simple Logger - NightQuest Games](https://www.nightquestgames.com/logger-in-gdscript-for-better-debugging/)

---

### 6.2 Profiling and Performance Monitoring

**Best Practice:** Use Godot's built-in profiler + custom metrics.

**Built-in Profiler:**
- Open with Debugger panel (bottom) > Profiler tab
- Run game (F5 or F6 for debug mode)
- Monitor:
  - **CPU time** per function
  - **Memory usage** (objects, resources)
  - **Physics/rendering** time
  - **Network** traffic

**Custom Performance Metrics:**
```gdscript
# res://autoload/performance_monitor.gd
extends Node

var frame_times: Array[float] = []
var max_frame_history: int = 300  # 5 seconds at 60fps

var metrics: Dictionary = {
    "total_objects": 0,
    "active_ores": 0,
    "cargo_operations": 0,
    "save_operations": 0
}

func _process(delta: float) -> void:
    frame_times.append(delta)
    if frame_times.size() > max_frame_history:
        frame_times.pop_front()

    _update_metrics()

func _update_metrics() -> void:
    metrics.total_objects = Performance.get_monitor(Performance.OBJECT_COUNT)
    metrics.active_ores = get_tree().get_nodes_in_group("ores").size()

func get_average_fps() -> float:
    if frame_times.is_empty():
        return 0.0
    var avg_delta = 0.0
    for dt in frame_times:
        avg_delta += dt
    avg_delta /= frame_times.size()
    return 1.0 / avg_delta if avg_delta > 0 else 0.0

func get_frame_time_ms() -> float:
    if frame_times.is_empty():
        return 0.0
    return frame_times[-1] * 1000.0

func log_performance_summary() -> void:
    Logger.info("Performance Summary", {
        "avg_fps": "%.1f" % get_average_fps(),
        "frame_time_ms": "%.2f" % get_frame_time_ms(),
        "total_objects": metrics.total_objects,
        "active_ores": metrics.active_ores
    })
```

**Performance Overlay:**
```gdscript
# Add to Player or Main scene
@onready var perf_label: Label = $UI/PerformanceLabel

func _process(delta: float) -> void:
    perf_label.text = "FPS: %d | Objects: %d | Memory: %.1f MB" % [
        Engine.get_frames_per_second(),
        Performance.get_monitor(Performance.OBJECT_COUNT),
        Performance.get_monitor(Performance.MEMORY_STATIC) / 1024.0 / 1024.0
    ]
```

**Current Project Status:** ⚠️ **BASIC** - Likely uses DevInfo.tscn for some stats

**Implementation Priority:** 🟡 **MEDIUM** - Essential for optimization

**References:**
- [Official Profiler Docs](https://docs.godotengine.org/en/stable/tutorials/scripting/debug/the_profiler.html)

---

### 6.3 Error Reporting

**Best Practice:** Catch and log errors gracefully.

```gdscript
# ✅ GOOD - Graceful error handling
func load_ship_data(ship_id: String) -> Dictionary:
    if not DatabaseManager.has_ship(ship_id):
        Logger.error("Ship not found", {"ship_id": ship_id})
        return {}

    var ship_data = DatabaseManager.get_ship(ship_id)

    if not _validate_ship_data(ship_data):
        Logger.error("Invalid ship data", {
            "ship_id": ship_id,
            "data": ship_data
        })
        return {}

    return ship_data

func _validate_ship_data(data: Dictionary) -> bool:
    var required_fields = ["name", "mass", "max_thrust"]
    for field in required_fields:
        if not field in data:
            Logger.warning("Missing field in ship data", {"field": field})
            return false
    return true

# ❌ BAD - No error handling
func load_ship_data(ship_id: String) -> Dictionary:
    return DatabaseManager.get_ship(ship_id)  # Might crash if ship doesn't exist
```

---

## 7. Asset Management

### 7.1 Asset Organization

**Best Practice:** Consistent folder structure.

**Recommended Structure:**
```
res://
├── addons/            # Third-party plugins
├── assets/
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   ├── fonts/
│   ├── shaders/
│   ├── textures/
│   │   ├── ui/
│   │   ├── ships/
│   │   ├── ores/
│   │   └── effects/
│   └── models/        # 3D models (if applicable)
├── data/              # Game data (TSV, JSON)
│   ├── batch05/
│   ├── ships/
│   └── items/
├── scenes/
│   ├── ui/
│   ├── entities/
│   │   ├── ships/
│   │   ├── ores/
│   │   └── stations/
│   ├── levels/
│   └── menus/
├── scripts/
│   ├── autoload/      # Singletons
│   ├── base/          # Base classes
│   ├── components/    # Reusable components
│   ├── database/      # Database scripts
│   ├── ui/            # UI controllers
│   └── utils/         # Utility scripts
├── test/
│   ├── unit/
│   └── integration/
└── translations/
```

**Current Project Status:** ✅ **GOOD** - Already well-organized

---

### 7.2 Resource Loading Strategies

**Best Practice:** Preload vs dynamic loading.

```gdscript
# ✅ GOOD - Preload for frequently used assets
const ORE_SCENE = preload("res://scenes/Ore.tscn")
const EXPLOSION_EFFECT = preload("res://scenes/effects/Explosion.tscn")

func spawn_ore(position: Vector2) -> void:
    var ore = ORE_SCENE.instantiate()
    ore.global_position = position
    get_tree().current_scene.add_child(ore)

# ✅ GOOD - Dynamic load for infrequent assets
func load_ship_scene(ship_id: String) -> PackedScene:
    var path = "res://scenes/ships/%s.tscn" % ship_id
    if ResourceLoader.exists(path):
        return load(path) as PackedScene
    else:
        Logger.error("Ship scene not found", {"path": path})
        return null

# ✅ GOOD - Threaded loading for large assets
func load_level_async(level_name: String) -> void:
    var path = "res://scenes/levels/%s.tscn" % level_name
    ResourceLoader.load_threaded_request(path)

    # Check progress
    while true:
        var progress = []
        var status = ResourceLoader.load_threaded_get_status(path, progress)

        match status:
            ResourceLoader.THREAD_LOAD_LOADED:
                var scene = ResourceLoader.load_threaded_get(path)
                _instantiate_level(scene)
                break
            ResourceLoader.THREAD_LOAD_FAILED:
                Logger.error("Failed to load level", {"path": path})
                break
            _:
                # Update loading bar
                _update_loading_bar(progress[0])
                await get_tree().process_frame
```

**Current Project Status:** ⚠️ **MIXED** - Has AssetManager but needs review

**Implementation Priority:** 🟢 **LOW** - Current approach likely sufficient

---

### 7.3 Asset Streaming

**Best Practice:** Load/unload assets based on proximity.

```gdscript
# ✅ GOOD - Chunk-based loading
class_name ChunkManager
extends Node2D

const CHUNK_SIZE = 2000  # pixels
var loaded_chunks: Dictionary = {}  # Vector2i -> ChunkData

func _process(delta: float) -> void:
    var player_pos = get_player_position()
    var player_chunk = _world_to_chunk(player_pos)

    _load_nearby_chunks(player_chunk)
    _unload_distant_chunks(player_chunk)

func _load_nearby_chunks(center: Vector2i) -> void:
    var load_radius = 2  # Load 2 chunks in each direction

    for x in range(-load_radius, load_radius + 1):
        for y in range(-load_radius, load_radius + 1):
            var chunk_pos = center + Vector2i(x, y)
            if not chunk_pos in loaded_chunks:
                _load_chunk(chunk_pos)

func _unload_distant_chunks(center: Vector2i) -> void:
    var unload_distance = 3

    for chunk_pos in loaded_chunks.keys():
        var distance = (chunk_pos - center).length()
        if distance > unload_distance:
            _unload_chunk(chunk_pos)
```

**Use Case:** If your space game has a large explorable area

**Current Project Status:** ❌ **NOT NEEDED** - Single-scene gameplay

**Implementation Priority:** 🟢 **LOW** - Only if map becomes massive

---

## 8. Networking

### 8.1 Multiplayer Architecture (Future-Proofing)

**Best Practice:** Use Godot 4's high-level multiplayer API.

**Basic Setup:**
```gdscript
# Server/Host
func create_server(port: int) -> void:
    var peer = ENetMultiplayerPeer.new()
    peer.create_server(port)
    multiplayer.multiplayer_peer = peer

    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)

    Logger.info("Server created", {"port": port})

# Client
func join_server(address: String, port: int) -> void:
    var peer = ENetMultiplayerPeer.new()
    peer.create_client(address, port)
    multiplayer.multiplayer_peer = peer

    Logger.info("Connecting to server", {"address": address, "port": port})

func _on_peer_connected(id: int) -> void:
    Logger.info("Peer connected", {"id": id})

func _on_peer_disconnected(id: int) -> void:
    Logger.info("Peer disconnected", {"id": id})
```

**RPC (Remote Procedure Calls):**
```gdscript
# ✅ GOOD - Modern Godot 4 RPC
class_name Player
extends CharacterBody2D

@rpc("any_peer", "call_remote", "reliable")
func move_to(target_pos: Vector2) -> void:
    # This runs on all clients
    position = target_pos

@rpc("authority", "call_remote", "unreliable")
func update_position(pos: Vector2, vel: Vector2) -> void:
    # Only server can call this
    position = pos
    velocity = vel

func _physics_process(delta: float) -> void:
    if is_multiplayer_authority():
        # Only controlling client processes input
        _process_input()
        update_position.rpc(position, velocity)
```

**Multiplayer Synchronizer:**
```gdscript
# In Player.tscn, add MultiplayerSynchronizer node
# Configure it to sync:
# - position
# - velocity
# - rotation
# - animation state

# Godot 4 automatically handles replication!
```

**Security Best Practices:**
1. **Never trust client input** - Validate on server
2. **Use encryption** - `peer.create_server(port, 0, 0, true)` for DTLS
3. **Implement authority checks**
4. **Rate limiting** - Prevent spam/DoS
5. **Server-side inventory** - Critical data on server only

**Current Project Status:** ❌ **SINGLE-PLAYER ONLY**

**Implementation Priority:** 🟢 **LOW** - Only if planning multiplayer

**References:**
- [Godot 4.0 Multiplayer Best Practices](https://toxigon.com/godot-4-0-best-practices-for-multiplayer-games)
- [Official Multiplayer Docs](https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html)
- [The Essential Guide to Creating Multiplayer Games with Godot 4.0 (Book)](https://www.amazon.com/Essential-Guide-Creating-Multiplayer-Games/dp/1803232617)

---

## 9. State Management

### 9.1 Finite State Machine (FSM)

**Best Practice:** Use node-based state machines for game states and AI.

**Node-Based FSM:**
```gdscript
# res://scripts/state_machine/state_machine.gd
class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
    # Collect all child State nodes
    for child in get_children():
        if child is State:
            states[child.name] = child
            child.state_machine = self

    if initial_state:
        current_state = initial_state
        current_state.enter()

func _process(delta: float) -> void:
    if current_state:
        current_state.update(delta)

func _physics_process(delta: float) -> void:
    if current_state:
        current_state.physics_update(delta)

func transition_to(state_name: String) -> void:
    if not state_name in states:
        Logger.error("State not found", {"state": state_name})
        return

    var new_state = states[state_name]

    if current_state:
        Logger.debug("State transition", {
            "from": current_state.name,
            "to": new_state.name
        })
        current_state.exit()

    current_state = new_state
    current_state.enter()
```

**Base State Class:**
```gdscript
# res://scripts/state_machine/state.gd
class_name State
extends Node

var state_machine: StateMachine

func enter() -> void:
    pass

func exit() -> void:
    pass

func update(delta: float) -> void:
    pass

func physics_update(delta: float) -> void:
    pass
```

**Example: Ship AI States:**
```gdscript
# res://scripts/ai/states/idle_state.gd
class_name IdleState
extends State

@export var wander_state: State
@export var attack_state: State

var idle_timer: float = 0.0
const IDLE_DURATION = 3.0

func enter() -> void:
    get_parent().get_parent().velocity = Vector2.ZERO
    idle_timer = 0.0

func update(delta: float) -> void:
    idle_timer += delta

    # Check for enemies
    var enemies = get_parent().get_parent().detect_enemies()
    if not enemies.is_empty():
        state_machine.transition_to(attack_state.name)
        return

    # Wander after idle period
    if idle_timer >= IDLE_DURATION:
        state_machine.transition_to(wander_state.name)
```

**Scene Structure:**
```
NPCShip (CharacterBody2D)
├── Sprite2D
├── CollisionShape2D
├── StateMachine
│   ├── IdleState
│   ├── WanderState
│   ├── AttackState
│   └── FleeState
```

**Current Project Status:** ⚠️ **PARTIAL** - Uses enum-based states (AutopilotState)

**Implementation Priority:** 🟡 **MEDIUM** - Would improve NPC AI and game states

**References:**
- [Finite State Machine - GDQuest](https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/)

---

### 9.2 Behavior Trees

**Best Practice:** Use behavior trees for complex AI decision-making.

**LimboAI - Modern Solution (2025):**
- **Latest Version:** Supports Godot 4.4+ (November 2025)
- **Features:**
  - Visual behavior tree editor
  - Built-in documentation
  - Debugger with visual feedback
  - State machine integration
  - Blackboard for AI memory

**Installation:**
1. Download from [Asset Library](https://godotengine.org/asset-library/asset/3787)
2. Or GitHub: [LimboAI](https://github.com/limbonaut/limboai)

**Example Behavior Tree:**
```
MiningShip AI
├── Sequence (Root)
│   ├── HasFuel?
│   ├── Selector
│   │   ├── Sequence (Mining)
│   │   │   ├── FindNearestOre
│   │   │   ├── ApproachOre
│   │   │   ├── MineOre
│   │   │   └── CargoNotFull?
│   │   ├── Sequence (Return)
│   │   │   ├── FindNearestStation
│   │   │   ├── ApproachStation
│   │   │   └── UnloadCargo
│   │   └── Wander
│   └── ReturnToStation
```

**When to Use Behavior Trees vs FSM:**
- **FSM:** Simple, predictable states (player movement, autopilot)
- **Behavior Trees:** Complex decision-making (NPC AI, enemy tactics)

**Current Project Status:** ❌ **NONE** - No behavior trees

**Implementation Priority:** 🟢 **LOW** - Only needed for complex NPC AI

**References:**
- [LimboAI GitHub](https://github.com/limbonaut/limboai)
- [BehaviourToolkit](https://godotengine.org/asset-library/asset/2333)

---

## 10. UI/UX

### 10.1 Responsive UI Design

**Best Practice:** Use containers and anchors for resolution-independent UI.

**Your Current Settings (project.godot):**
```gdscript
window/stretch/mode="canvas_items"  # ✅ Correct
window/stretch/aspect="expand"      # ⚠️ Consider "keep" instead
```

**Recommended:**
```gdscript
window/stretch/mode="canvas_items"
window/stretch/aspect="keep"  # Maintains aspect ratio, adds letterboxing
```

**Container-Based Layout:**
```gdscript
# ✅ GOOD - Responsive UI structure
CanvasLayer
└── MarginContainer (anchors: full rect, margins: 20px)
    └── VBoxContainer
        ├── HBoxContainer (Top Bar)
        │   ├── Label (Ship Name)
        │   ├── Control (spacer, size_flags_h: expand)
        │   └── Label (Credits)
        ├── Control (Middle spacer, size_flags_v: expand)
        └── HBoxContainer (Bottom Bar)
            ├── ProgressBar (Fuel)
            ├── ProgressBar (Shield)
            └── ProgressBar (Cargo)

# ❌ BAD - Fixed positions
# Control at position (100, 100) - breaks on different resolutions
```

**Container Types:**
- **HBoxContainer/VBoxContainer** - Linear layouts
- **GridContainer** - Grid layouts
- **MarginContainer** - Padding/margins
- **CenterContainer** - Centers children
- **PanelContainer** - Background panel
- **ScrollContainer** - Scrollable content

**Current Project Status:** ⚠️ **NEEDS REVIEW** - Check UI scenes for container usage

**Implementation Priority:** 🟡 **MEDIUM** - Critical for multi-resolution support

**References:**
- [Making Responsive UI - Kodeco](https://www.kodeco.com/45869762-making-responsive-ui-in-godot)
- [Mastering UI Design in Godot 2025](https://howik.com/best-practices-for-ui-design-in-godot)

---

### 10.2 UI Themes and Styling

**Best Practice:** Use centralized Theme resource.

```gdscript
# Create Theme resource
# 1. Create new Theme: File > New > Theme
# 2. Save as res://ui/main_theme.tres
# 3. Assign to root Control node

# Theme configuration:
# - Default Font
# - Font Sizes (small: 12, normal: 16, large: 24, title: 32)
# - Colors (accent, primary, secondary, background, text)
# - StyleBoxes for buttons, panels, etc.
```

**Programmatic Theming:**
```gdscript
# Apply theme to UI root
@onready var ui_root: Control = $UIRoot

func _ready() -> void:
    var theme = load("res://ui/main_theme.tres") as Theme
    ui_root.theme = theme
```

**Current Project Status:** ⚠️ **UNKNOWN** - Check for theme usage

**Implementation Priority:** 🟡 **MEDIUM** - Improves consistency and maintainability

---

### 10.3 UI Animation and Feedback

**Best Practice:** Provide visual feedback for all interactions.

```gdscript
# ✅ GOOD - Animated button
extends Button

@onready var tween: Tween

func _ready() -> void:
    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)
    pressed.connect(_on_pressed)

func _on_mouse_entered() -> void:
    if tween:
        tween.kill()
    tween = create_tween()
    tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)

func _on_mouse_exited() -> void:
    if tween:
        tween.kill()
    tween = create_tween()
    tween.tween_property(self, "scale", Vector2.ONE, 0.1)

func _on_pressed() -> void:
    if tween:
        tween.kill()
    tween = create_tween()
    tween.tween_property(self, "scale", Vector2(0.95, 0.95), 0.05)
    tween.tween_property(self, "scale", Vector2.ONE, 0.05)
```

**UI Feedback Checklist:**
- ✅ Button hover effects
- ✅ Click animations
- ✅ Loading indicators
- ✅ Success/error notifications
- ✅ Smooth transitions between screens

**Current Project Status:** ⚠️ **UNKNOWN** - Needs UI review

**Implementation Priority:** 🟡 **MEDIUM** - Improves user experience

---

### 10.4 Accessibility

**Best Practice:** Make UI accessible to all players.

```gdscript
# Font scaling
@export_range(0.5, 2.0) var font_scale: float = 1.0:
    set(value):
        font_scale = value
        _update_font_sizes()

# Colorblind mode
enum ColorblindMode { NONE, PROTANOPIA, DEUTERANOPIA, TRITANOPIA }
var colorblind_mode: ColorblindMode = ColorblindMode.NONE

# High contrast mode
var high_contrast: bool = false

# Screen reader support (for critical info)
func announce(text: String) -> void:
    if OS.is_screen_reader_active():
        DisplayServer.tts_speak(text, DisplayServer.TTS_UTTERANCE_PRIORITY_HIGH)
```

**Accessibility Features to Consider:**
- Adjustable font sizes
- Colorblind modes
- Subtitles/captions
- Remappable controls
- Audio cues for visual events
- High contrast mode

**Current Project Status:** ❌ **NONE**

**Implementation Priority:** 🟢 **LOW** - Nice to have, but not critical for prototype

---

## 11. Project-Specific Recommendations

### 11.1 Current Strengths

✅ **Well-organized project structure**
- Clear separation of scripts, scenes, data
- Good use of autoload for managers
- Consistent naming conventions

✅ **Good use of signals**
- Typed signals in Player.gd
- Decoupled event communication

✅ **Database-driven design**
- TSV-based data storage
- Centralized DatabaseManager
- Easy to add new items/ships

✅ **Comprehensive documentation**
- README, CHANGELOG, feature docs
- System integration guides

### 11.2 Critical Improvements

🔴 **HIGH PRIORITY:**

1. **Implement Unit Testing**
   - Add GUT framework
   - Test cargo system, mining, save/load
   - Prevent regressions during development
   - **Impact:** Prevents bugs, speeds up development
   - **Effort:** 2-3 days initial setup, ongoing

2. **Add Type Hints Everywhere**
   - Gradually add to all scripts
   - Start with core systems (Player, DatabaseManager, SaveManager)
   - **Impact:** Better performance, fewer bugs
   - **Effort:** 1-2 weeks, done incrementally

3. **Implement Structured Logging**
   - Replace print() with Logger
   - Add log levels (debug, info, warning, error)
   - Log to file for post-crash analysis
   - **Impact:** Easier debugging, better error tracking
   - **Effort:** 1-2 days

### 11.3 Important Improvements

🟡 **MEDIUM PRIORITY:**

4. **Encrypt Save Files**
   - Prevent save editing
   - Add checksum validation
   - **Impact:** Prevents cheating
   - **Effort:** 1-2 days

5. **Implement Event Bus**
   - Decouple systems
   - Easier to add features
   - **Impact:** Better architecture, easier maintenance
   - **Effort:** 1 day

6. **Add Performance Monitoring**
   - Custom metrics for key systems
   - Performance overlay (debug mode)
   - **Impact:** Identify bottlenecks early
   - **Effort:** 1 day

7. **Object Pooling for Cargo Crates**
   - Reuse crate instances
   - Reduce garbage collection
   - **Impact:** Better performance when many crates exist
   - **Effort:** 1 day

8. **Node-based State Machine for NPCs**
   - Replace enum-based states
   - Easier to extend AI
   - **Impact:** More maintainable AI code
   - **Effort:** 2-3 days

### 11.4 Nice-to-Have Improvements

🟢 **LOW PRIORITY:**

9. **Component-based Architecture**
   - Refactor Player into components
   - HealthComponent, CargoComponent, etc.
   - **Impact:** More reusable code
   - **Effort:** 1-2 weeks (gradual refactor)

10. **UI Theming System**
    - Centralized theme resource
    - Consistent styling
    - **Impact:** Better visual consistency
    - **Effort:** 2-3 days

11. **Accessibility Features**
    - Font scaling
    - Colorblind mode
    - **Impact:** Wider player base
    - **Effort:** 3-5 days

### 11.5 Future Considerations

🔵 **IF PROJECT GROWS:**

- **ECS Architecture** - Only if adding 1000+ entities
- **Behavior Trees** - For complex NPC AI
- **Multiplayer** - Complete rewrite of networking layer
- **Chunk Loading** - If map becomes massive

---

## 12. Implementation Roadmap

### Phase 1: Foundation (Week 1-2)

**Goal:** Improve code quality and debugging capabilities

- [ ] Add structured Logger system
- [ ] Install GUT testing framework
- [ ] Write tests for CargoSystem
- [ ] Write tests for SaveManager
- [ ] Add type hints to Player.gd
- [ ] Add type hints to DatabaseManager

**Expected Benefits:**
- Easier debugging
- Prevent regressions
- Better code completion

---

### Phase 2: Architecture (Week 3-4)

**Goal:** Improve system architecture

- [ ] Implement EventBus
- [ ] Migrate key events to EventBus
- [ ] Add save file encryption
- [ ] Add checksum validation
- [ ] Implement PerformanceMonitor
- [ ] Add performance overlay (debug mode)

**Expected Benefits:**
- More secure saves
- Better system decoupling
- Performance visibility

---

### Phase 3: Optimization (Week 5-6)

**Goal:** Improve performance

- [ ] Profile game with Godot profiler
- [ ] Identify bottlenecks
- [ ] Implement object pooling for CargoCrates
- [ ] Optimize cargo operations
- [ ] Add multithreading where beneficial
- [ ] Test performance improvements

**Expected Benefits:**
- Smoother gameplay
- Higher FPS
- Better scalability

---

### Phase 4: Polish (Week 7-8)

**Goal:** Improve user experience

- [ ] Review UI for responsiveness
- [ ] Implement container-based layouts
- [ ] Add UI animations
- [ ] Create centralized Theme
- [ ] Improve visual feedback
- [ ] Test on multiple resolutions

**Expected Benefits:**
- Better UX
- Multi-resolution support
- More polished feel

---

### Phase 5: Advanced Features (Week 9+)

**Goal:** Add advanced systems as needed

- [ ] Implement node-based FSM for NPCs
- [ ] Consider LimboAI for complex AI
- [ ] Refactor into components (gradual)
- [ ] Add accessibility features
- [ ] Optimize asset loading
- [ ] Final performance pass

**Expected Benefits:**
- More sophisticated AI
- Better code reusability
- Wider player accessibility

---

## Quick Reference Checklist

### Code Quality
- [ ] Type hints on all functions
- [ ] Type hints on all variables
- [ ] Signals are typed
- [ ] Classes use `class_name`
- [ ] Consistent code organization
- [ ] Documentation comments
- [ ] No magic numbers (use constants)

### Performance
- [ ] Profile regularly
- [ ] Object pooling for frequent spawns
- [ ] Avoid allocations in loops
- [ ] Use @onready for node references
- [ ] Minimize draw calls
- [ ] Optimize physics queries

### Architecture
- [ ] Clear separation of concerns
- [ ] Composition over inheritance
- [ ] Event-driven communication
- [ ] Testable code
- [ ] Single responsibility principle
- [ ] Don't repeat yourself (DRY)

### Testing
- [ ] Unit tests for core logic
- [ ] Integration tests for workflows
- [ ] Test coverage > 70%
- [ ] Tests run automatically
- [ ] Tests are independent
- [ ] Tests are fast

### Security
- [ ] Save files encrypted
- [ ] Input validation
- [ ] Checksums for data integrity
- [ ] Protected critical values
- [ ] No sensitive data in logs
- [ ] Secure resource loading

### UI/UX
- [ ] Responsive design
- [ ] Container-based layouts
- [ ] Consistent theming
- [ ] Visual feedback
- [ ] Accessibility considered
- [ ] Multi-resolution tested

---

## Resources

### Official Documentation
- [Godot 4.5 Documentation](https://docs.godotengine.org/en/stable/)
- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Best Practices](https://docs.godotengine.org/en/stable/tutorials/best_practices/index.html)

### Books
- [Game Development Patterns with Godot 4](https://www.packtpub.com/en-us/product/game-development-patterns-with-godot-4-9781835880296) by Henrique Campos (2024)
- [The Essential Guide to Creating Multiplayer Games with Godot 4.0](https://www.amazon.com/Essential-Guide-Creating-Multiplayer-Games/dp/1803232617) by Henrique Campos & Nathan Lovato

### Tutorials
- [GDQuest](https://www.gdquest.com/) - Design patterns, best practices
- [Brackeys](https://www.youtube.com/@Brackeys) - Godot tutorials (now on Godot)
- [Kodeco](https://www.kodeco.com/gamedev) - Responsive UI, debugging

### Plugins & Tools
- [GUT Testing Framework](https://github.com/bitwes/Gut)
- [LimboAI](https://github.com/limbonaut/limboai) - Behavior trees & FSM
- [Anti-cheating-value-plus](https://godotengine.org/asset-library/asset/3522)

### Community
- [Godot Forums](https://forum.godotengine.org/)
- [Godot Discord](https://discord.gg/godotengine)
- [r/godot](https://www.reddit.com/r/godot/)

---

## Conclusion

This document provides a comprehensive overview of Godot 4.x best practices for 2025, tailored to your Space Mining Game project. The recommendations are prioritized based on impact and effort, allowing you to incrementally improve your codebase.

**Recommended Starting Points:**
1. **Add unit testing** - Prevents future bugs
2. **Implement structured logging** - Easier debugging
3. **Add type hints** - Better performance and safety

These foundational improvements will make all future development easier and more reliable.

**Key Takeaway:** Don't try to implement everything at once. Follow the phased roadmap, focusing on high-impact improvements first. Your project already has a solid foundation - these practices will help it scale as development continues.

---

**Document Version:** 1.0
**Last Updated:** November 18, 2025
**Next Review:** February 2026
