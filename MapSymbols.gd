extends Node
class_name MapSymbols

## Symbol definitions for map system (EVE-style)
## Provides icons, colors, and categorization for all space objects

# ============================================================================
# OBJECT TYPES
# ============================================================================

enum ObjectType {
	# Ships
	PLAYER_SHIP,
	FRIENDLY_SHIP,
	NEUTRAL_SHIP,
	HOSTILE_SHIP,

	# Stations & Structures
	STATION_OUTPOST,
	STATION_STATION,
	STATION_CITADEL,
	STATION_KEEPSTAR,
	STARGATE,

	# Resources
	ASTEROID_ORE,
	ASTEROID_ICE,
	MOON,
	PLANET,

	# NPCs & Hostiles
	NPC_FRIGATE,
	NPC_CRUISER,
	NPC_BATTLESHIP,
	PIRATE,

	# Celestials
	SUN,
	WORMHOLE,
	BEACON,

	# Other
	WRECK,
	CONTAINER,
	BOOKMARK,
	UNKNOWN
}

# ============================================================================
# SYMBOL DEFINITIONS (Unicode Icons)
# ============================================================================

const SYMBOLS = {
	# Ships
	ObjectType.PLAYER_SHIP: "⬤",        # Filled circle (you)
	ObjectType.FRIENDLY_SHIP: "▲",      # Triangle (allies)
	ObjectType.NEUTRAL_SHIP: "◆",       # Diamond (neutral)
	ObjectType.HOSTILE_SHIP: "✖",       # X (hostile)

	# Stations & Structures
	ObjectType.STATION_OUTPOST: "⌂",    # House (small station)
	ObjectType.STATION_STATION: "◈",    # Diamond with cross
	ObjectType.STATION_CITADEL: "⬟",    # Pentagon
	ObjectType.STATION_KEEPSTAR: "✦",   # Star (largest)
	ObjectType.STARGATE: "⊕",           # Circle with cross

	# Resources
	ObjectType.ASTEROID_ORE: "◆",       # Diamond (ore)
	ObjectType.ASTEROID_ICE: "◇",       # Hollow diamond (ice)
	ObjectType.MOON: "◐",               # Half circle
	ObjectType.PLANET: "●",             # Large circle

	# NPCs & Hostiles
	ObjectType.NPC_FRIGATE: "▸",        # Small triangle
	ObjectType.NPC_CRUISER: "▶",        # Medium triangle
	ObjectType.NPC_BATTLESHIP: "◥",     # Large triangle
	ObjectType.PIRATE: "☠",             # Skull

	# Celestials
	ObjectType.SUN: "☀",                # Sun
	ObjectType.WORMHOLE: "◉",           # Circle with dot
	ObjectType.BEACON: "⚑",             # Flag

	# Other
	ObjectType.WRECK: "✚",              # Cross
	ObjectType.CONTAINER: "□",          # Square
	ObjectType.BOOKMARK: "⚐",           # Flag outline
	ObjectType.UNKNOWN: "?"             # Unknown
}

# ============================================================================
# COLOR DEFINITIONS
# ============================================================================

const COLORS = {
	# Ships - based on standing
	ObjectType.PLAYER_SHIP: Color(0.2, 1.0, 0.2),         # Bright green
	ObjectType.FRIENDLY_SHIP: Color(0.3, 0.7, 1.0),       # Blue
	ObjectType.NEUTRAL_SHIP: Color(0.8, 0.8, 0.8),        # Gray
	ObjectType.HOSTILE_SHIP: Color(1.0, 0.2, 0.2),        # Red

	# Stations & Structures - golden/yellow tones
	ObjectType.STATION_OUTPOST: Color(1.0, 0.9, 0.5),     # Light gold
	ObjectType.STATION_STATION: Color(1.0, 0.8, 0.2),     # Gold
	ObjectType.STATION_CITADEL: Color(1.0, 0.7, 0.0),     # Deep gold
	ObjectType.STATION_KEEPSTAR: Color(1.0, 0.6, 0.0),    # Orange-gold
	ObjectType.STARGATE: Color(0.5, 0.8, 1.0),            # Cyan

	# Resources - earth tones
	ObjectType.ASTEROID_ORE: Color(0.7, 0.6, 0.4),        # Brown
	ObjectType.ASTEROID_ICE: Color(0.7, 0.9, 1.0),        # Ice blue
	ObjectType.MOON: Color(0.8, 0.8, 0.7),                # Light gray
	ObjectType.PLANET: Color(0.4, 0.6, 0.8),              # Blue-gray

	# NPCs & Hostiles - red tones
	ObjectType.NPC_FRIGATE: Color(1.0, 0.6, 0.4),         # Orange-red
	ObjectType.NPC_CRUISER: Color(1.0, 0.4, 0.3),         # Red-orange
	ObjectType.NPC_BATTLESHIP: Color(1.0, 0.2, 0.2),      # Red
	ObjectType.PIRATE: Color(0.8, 0.0, 0.2),              # Dark red

	# Celestials - bright colors
	ObjectType.SUN: Color(1.0, 1.0, 0.3),                 # Yellow
	ObjectType.WORMHOLE: Color(0.7, 0.3, 1.0),            # Purple
	ObjectType.BEACON: Color(0.3, 1.0, 0.5),              # Green

	# Other - utility colors
	ObjectType.WRECK: Color(0.5, 0.5, 0.5),               # Dark gray
	ObjectType.CONTAINER: Color(0.6, 0.8, 0.6),           # Light green
	ObjectType.BOOKMARK: Color(1.0, 1.0, 0.6),            # Light yellow
	ObjectType.UNKNOWN: Color(0.7, 0.7, 0.7)              # Gray
}

# ============================================================================
# CATEGORY DEFINITIONS (for filtering)
# ============================================================================

const CATEGORIES = {
	"ships": [
		ObjectType.PLAYER_SHIP,
		ObjectType.FRIENDLY_SHIP,
		ObjectType.NEUTRAL_SHIP,
		ObjectType.HOSTILE_SHIP
	],
	"stations": [
		ObjectType.STATION_OUTPOST,
		ObjectType.STATION_STATION,
		ObjectType.STATION_CITADEL,
		ObjectType.STATION_KEEPSTAR,
		ObjectType.STARGATE
	],
	"resources": [
		ObjectType.ASTEROID_ORE,
		ObjectType.ASTEROID_ICE,
		ObjectType.MOON,
		ObjectType.PLANET
	],
	"npcs": [
		ObjectType.NPC_FRIGATE,
		ObjectType.NPC_CRUISER,
		ObjectType.NPC_BATTLESHIP,
		ObjectType.PIRATE
	],
	"celestials": [
		ObjectType.SUN,
		ObjectType.WORMHOLE,
		ObjectType.BEACON
	],
	"other": [
		ObjectType.WRECK,
		ObjectType.CONTAINER,
		ObjectType.BOOKMARK,
		ObjectType.UNKNOWN
	]
}

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

static func get_symbol(type: ObjectType) -> String:
	"""Get the unicode symbol for an object type"""
	return SYMBOLS.get(type, "?")

static func get_color(type: ObjectType) -> Color:
	"""Get the color for an object type"""
	return COLORS.get(type, Color.WHITE)

static func get_category(type: ObjectType) -> String:
	"""Get the category name for an object type"""
	for category_name in CATEGORIES:
		if type in CATEGORIES[category_name]:
			return category_name
	return "other"

static func get_display_name(type: ObjectType) -> String:
	"""Get human-readable name for object type"""
	var name = ObjectType.keys()[type]
	return name.replace("_", " ").capitalize()

static func detect_object_type(node: Node2D) -> ObjectType:
	"""Auto-detect object type from node (for automatic categorization)"""
	var node_name = node.name.to_lower()

	# Check if it's the player
	if node.is_in_group("player"):
		return ObjectType.PLAYER_SHIP

	# Check for stations
	if node.has_method("dock_ship"):
		if "station_type" in node:
			match node.station_type:
				0: return ObjectType.STATION_OUTPOST
				1: return ObjectType.STATION_STATION
				2: return ObjectType.STATION_CITADEL
				3: return ObjectType.STATION_KEEPSTAR
		return ObjectType.STATION_STATION

	# Check for asteroids
	if "ore" in node_name or node.has_method("get_ore_info"):
		return ObjectType.ASTEROID_ORE

	# Check for ships
	if node.has_method("get_ship_info"):
		# Check standing/relationship
		if "is_hostile" in node and node.is_hostile:
			return ObjectType.HOSTILE_SHIP
		elif "is_friendly" in node and node.is_friendly:
			return ObjectType.FRIENDLY_SHIP
		else:
			return ObjectType.NEUTRAL_SHIP

	# Default
	return ObjectType.UNKNOWN

static func get_size_multiplier(type: ObjectType) -> float:
	"""Get size multiplier for map icons (relative to base size)"""
	match type:
		ObjectType.PLAYER_SHIP:
			return 1.2  # Player slightly larger
		ObjectType.STATION_KEEPSTAR:
			return 2.0  # Largest stations
		ObjectType.STATION_CITADEL:
			return 1.7
		ObjectType.STATION_STATION:
			return 1.4
		ObjectType.SUN:
			return 2.5  # Sun is huge
		ObjectType.PLANET:
			return 1.8
		ObjectType.NPC_BATTLESHIP:
			return 1.3
		ObjectType.NPC_CRUISER:
			return 1.0
		ObjectType.NPC_FRIGATE:
			return 0.8
		_:
			return 1.0  # Default size
