#!/usr/bin/env python3
"""
TSV to ItemDatabase.gd Converter FINAL
Handles misaligned TSV formats correctly
"""

import csv
from pathlib import Path
from typing import List, Dict

# EVE Name Replacements
EVE_REPLACEMENTS = {
    "Dominix": "Sentinel", "Megathron": "Titan", "Hyperion": "Assault",
    "Apocalypse": "Laser", "Armageddon": "Energy", "Abaddon": "Artillery",
    "Tempest": "Storm", "Maelstrom": "Heavy Artillery", "Typhoon": "Cyclone",
    "Raven": "Cruise", "Scorpion": "ECM", "Rokh": "Railgun",
    "Kronos": "Blaster Marauder", "Paladin": "Laser Marauder",
    "Vargur": "Projectile Marauder", "Golem": "Missile Marauder",
    "Nightmare": "Laser Faction", "Vindicator": "Blaster Faction",
    "Machariel": "Projectile Faction",
    "Thanatos": "Drone Carrier", "Archon": "Armor Carrier",
    "Chimera": "Shield Carrier", "Nidhoggur": "Projectile Carrier",
    "Aeon": "Laser Supercarrier", "Hel": "Projectile Supercarrier",
    "Nyx": "Hybrid Supercarrier",
    "Phoenix": "Missile Dreadnought", "Moros": "Blaster Dreadnought",
    "Revelation": "Laser Dreadnought", "Naglfar": "Projectile Dreadnought",
    "Zirnitra": "Pirate DN-A", "Chemosh": "Pirate DN-B",
    "Vehement": "Faction DN", "Caiman": "Pirate DN-C",
    "Molok": "Pirate DN-D", "Komodo": "Faction DN Elite",
    "Avatar": "Laser Titan", "Erebus": "Hybrid Titan",
    "Leviathan": "Missile Titan", "Ragnarok": "Projectile Titan",
    "Vendetta": "Faction Titan-A", "Vanquisher": "Faction Titan-B",
    "Drake": "Missile BC", "Ferox": "Railgun BC", "Hurricane": "Projectile BC",
    "Prophecy": "Laser BC", "Harbinger": "Beam BC", "Myrmidon": "Drone BC",
    "Brutix": "Blaster BC", "Cyclone": "Heavy Missile BC",
    "Talos": "Artillery BC", "Naga": "Railgun Elite BC", "Oracle": "Laser Elite BC",
    "Basilisk": "Shield Logi", "Oneiros": "Armor Logi", "Scythe": "Fast Logi",
    "Venture": "Mining Frigate", "Prospect": "Expedition Frigate",
    "Procurer": "Tanked Barge", "Retriever": "Standard Barge",
    "Covetor": "Yield Barge", "Skiff": "Tanked Exhumer",
    "Mackinaw": "Standard Exhumer", "Hulk": "Yield Exhumer",
    "Orca": "Industrial Command", "Rorqual": "Capital Industrial",
    "Badger": "Fast Hauler", "Tayra": "Medium Hauler",
    "Bestower": "Standard Hauler", "Iteron": "Large Hauler",
    "Mammoth": "Heavy Hauler", "Nereus": "Specialist Hauler",
    "Kryos": "Ore Hauler", "Miasmos": "Gas Hauler",
    "Epithal": "Planetary Hauler", "Hoarder": "Quick Hauler",
    "Bustard": "DST-A", "Mastodon": "DST-B",
    "Crane": "BR-A", "Viator": "BR-B",
    "Charon": "Standard Freighter", "Obelisk": "Heavy Freighter",
    "Fenrir": "Fast Freighter",
    "Prowler": "Covert Ops", "Raptor": "Interceptor", "Hound": "Bomber",
    "Ibis": "Rookie-A", "Velator": "Rookie-B",
    "Reaper": "Rookie-C", "Impairor": "Rookie-D",
}

def replace_eve(name: str) -> str:
    for eve, gen in EVE_REPLACEMENTS.items():
        name = name.replace(eve, gen)
    return name

def map_category(cat: str, item_id: str) -> str:
    cat = cat.upper().strip()
    if "ORE" in cat or item_id.startswith("ORE_"):
        return "ORE"
    if "MAT" in cat or item_id.startswith("MAT_"):
        return "MINERAL"
    if "GAS" in cat or item_id.startswith("GAS_"):
        return "GAS"
    if "WASTE" in cat or item_id.startswith("WASTE_"):
        return "WASTE"
    if "COMP" in cat or item_id.startswith("COMP_"):
        return "COMPONENT"
    if "MOD" in cat or "MODULE" in cat or item_id.startswith("MOD_"):
        return "MODULE"
    if "WEP" in cat or "WEAPON" in cat or item_id.startswith("WEP_"):
        return "WEAPON"
    if "AMMO" in cat or item_id.startswith("AMMO_"):
        return "AMMO"
    if "SHIP" in cat or item_id.startswith("SHIP_"):
        return "SHIP"
    if item_id.startswith("SCAN_") or item_id.startswith("MINE_") or item_id.startswith("STAB_"):
        return "MODULE"
    return "COMPONENT"

def parse_complete_db(path: Path) -> List[Dict]:
    """Parse COMPLETE_SPACE_GAME_DATABASE.tsv"""
    items = []
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#') or line.startswith('DATABASE'):
                continue
            parts = line.split('\t')
            if len(parts) < 3:
                continue

            item_id = parts[0].strip()
            name = parts[1].strip()
            tier = parts[2].strip()

            # Estimate base_price (column 6 often has it for COMPLETE_DB)
            base_price = "1000"
            if len(parts) > 6:
                try:
                    val = float(parts[6])
                    if val > 0 and val < 1000000:
                        base_price = parts[6]
                except:
                    pass

            # Estimate volume/mass (columns 3-5 seem to have numeric data)
            volume = "10.0"
            mass = "10.0"
            if len(parts) > 4:
                try:
                    volume = str(float(parts[4]))
                except:
                    pass
            if len(parts) > 3:
                try:
                    mass = str(float(parts[3]))
                except:
                    pass

            items.append({
                'id': item_id,
                'name': replace_eve(name),
                'tier': tier,
                'category': map_category("", item_id),
                'base_price': base_price,
                'volume': volume,
                'mass': mass,
                'description': name
            })
    return items

def parse_standard(path: Path) -> List[Dict]:
    """Parse standard TSV files"""
    items = []
    with open(path, 'r', encoding='utf-8') as f:
        lines = [line for line in f if line.strip() and not line.startswith('#')]
        if not lines:
            return []
        reader = csv.DictReader(lines, delimiter='\t')
        for row in reader:
            item_id = row.get('ID', '').strip()
            name = row.get('NAME', '').strip()
            if not item_id or not name:
                continue

            items.append({
                'id': item_id,
                'name': replace_eve(name),
                'tier': row.get('TIER', '1').strip(),
                'category': map_category(row.get('CATEGORY', row.get('DATABASE', '')), item_id),
                'base_price': row.get('BASE_PRICE', '1000').strip(),
                'volume': row.get('VOLUME_M3', '10.0').strip(),
                'mass': row.get('MASS_KG', '10.0').strip(),
                'description': row.get('INFO_TEXT', name).strip()
            })
    return items

def generate_gd(items: List[Dict]) -> str:
    lines = []
    for item in items:
        lines.append(f'''
    # {item['id']} - {item['name']}
    item_registry["{item['id']}"] = ItemData.new()
    item_registry["{item['id']}"].id = "{item['id']}"
    item_registry["{item['id']}"].name = "{item['name']}"
    item_registry["{item['id']}"].category = ItemCategory.{item['category']}
    item_registry["{item['id']}"].tier = {item['tier']}
    item_registry["{item['id']}"].base_price = {item['base_price']}
    item_registry["{item['id']}"].volume = {item['volume']}
    item_registry["{item['id']}"].mass = {item['mass']}
    item_registry["{item['id']}"].description = "{item['description']}"
''')
    return ''.join(lines)

def main():
    base = Path('/home/user/SpaceGameDev/data/batch05')
    all_items = []

    print("🔄 Reading TSV files...")

    # COMPLETE_SPACE_GAME_DATABASE.tsv
    items = parse_complete_db(base / 'COMPLETE_SPACE_GAME_DATABASE.tsv')
    print(f"  ✓ COMPLETE_SPACE_GAME_DATABASE.tsv: {len(items)}")
    all_items.extend(items)

    # Standard TSVs
    for fname in [
        '06_COMPONENTS.tsv', '07a_WEAPONS_PART1.tsv', '07b_WEAPONS_PART2.tsv',
        '08_AMMUNITION.tsv', '09a_shields_armor.tsv', '09b_engines_power.tsv',
        '09c_cargo_sensors.tsv', '09d_ecm_mining.tsv', '09e_command_medical.tsv',
        '09f_utility_station.tsv', '10a_frigates_destroyers.tsv',
        '10b_cruisers_battlecruisers.tsv', '10c_battleships_carriers.tsv',
        '10d_dreadnoughts_titans.tsv', '10e_industrial_special_civilian.tsv'
    ]:
        items = parse_standard(base / fname)
        print(f"  ✓ {fname}: {len(items)}")
        all_items.extend(items)

    print(f"\n📊 TOTAL: {len(all_items)} items")

    header = f'''# ============================================================================
# ITEMDATABASE.GD - UNIFIED ITEM DATABASE
# ============================================================================
# Auto-generated from Batch05 TSV files
# EVE Online names replaced (Copyright compliance)
#
# TOTAL ITEMS: {len(all_items)}
# ============================================================================

extends Node

enum ItemCategory {{
    ORE, MINERAL, GAS, WASTE, COMPONENT, MODULE, WEAPON, AMMO,
    SHIP, CARGO, PASSENGER, MANUFACTURING
}}

enum ItemRarity {{
    COMMON, UNCOMMON, RARE, EPIC, LEGENDARY
}}

class ItemData:
    var id: String
    var name: String
    var category: ItemCategory
    var tier: int
    var base_price: int
    var volume: float
    var mass: float
    var description: String

var item_registry: Dictionary = {{}}

func _ready():
    _initialize_items()

func _initialize_items():
'''

    footer = '''
    print("✅ ItemDatabase initialized with ", item_registry.size(), " items")

func get_item(item_id: String) -> ItemData:
    return item_registry.get(item_id, null)

func get_all_items() -> Array:
    return item_registry.values()

func get_items_by_category(category: ItemCategory) -> Array:
    var result = []
    for item in item_registry.values():
        if item.category == category:
            result.append(item)
    return result

func get_market_price(item_id: String) -> int:
    var item = get_item(item_id)
    return item.base_price if item else 0
'''

    out_path = '/home/user/SpaceGameDev/scripts/ItemDatabase.gd'
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(header)
        f.write(generate_gd(all_items))
        f.write(footer)

    print(f"\n✅ ItemDatabase.gd generated!")
    print(f"   📁 {out_path}")
    print(f"   📊 {len(all_items)} items")

if __name__ == "__main__":
    main()
