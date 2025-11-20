# ============================================================================
# ITEMDATABASE.GD - UNIFIED ITEM DATABASE
# ============================================================================
# Auto-generated from Batch05 TSV files
# EVE Online names replaced (Copyright compliance)
#
# TOTAL ITEMS: 910
# ============================================================================

extends Node

enum ItemCategory {
    ORE, MINERAL, GAS, WASTE, COMPONENT, MODULE, WEAPON, AMMO,
    SHIP, CARGO, PASSENGER, MANUFACTURING
}

enum ItemRarity {
    COMMON, UNCOMMON, RARE, EPIC, LEGENDARY
}

class ItemData:
    var id: String
    var name: String
    var category: ItemCategory
    var tier: int
    var base_price: int
    var volume: float
    var mass: float
    var description: String

var item_registry: Dictionary = {}

func _ready():
    _initialize_items()

func _initialize_items():

    # ORE_T1_001 - Ferralite
    item_registry["ORE_T1_001"] = ItemData.new()
    item_registry["ORE_T1_001"].id = "ORE_T1_001"
    item_registry["ORE_T1_001"].name = "Ferralite"
    item_registry["ORE_T1_001"].category = ItemCategory.ORE
    item_registry["ORE_T1_001"].tier = 1
    item_registry["ORE_T1_001"].base_price = 100
    item_registry["ORE_T1_001"].volume = 25.0
    item_registry["ORE_T1_001"].mass = 12.0
    item_registry["ORE_T1_001"].description = "Ferralite"

    # ORE_T1_002 - Metalite
    item_registry["ORE_T1_002"] = ItemData.new()
    item_registry["ORE_T1_002"].id = "ORE_T1_002"
    item_registry["ORE_T1_002"].name = "Metalite"
    item_registry["ORE_T1_002"].category = ItemCategory.ORE
    item_registry["ORE_T1_002"].tier = 1
    item_registry["ORE_T1_002"].base_price = 95
    item_registry["ORE_T1_002"].volume = 24.0
    item_registry["ORE_T1_002"].mass = 11.0
    item_registry["ORE_T1_002"].description = "Metalite"

    # ORE_T1_003 - Cupreon
    item_registry["ORE_T1_003"] = ItemData.new()
    item_registry["ORE_T1_003"].id = "ORE_T1_003"
    item_registry["ORE_T1_003"].name = "Cupreon"
    item_registry["ORE_T1_003"].category = ItemCategory.ORE
    item_registry["ORE_T1_003"].tier = 1
    item_registry["ORE_T1_003"].base_price = 120
    item_registry["ORE_T1_003"].volume = 26.0
    item_registry["ORE_T1_003"].mass = 10.0
    item_registry["ORE_T1_003"].description = "Cupreon"

    # ORE_T1_004 - Cuprex
    item_registry["ORE_T1_004"] = ItemData.new()
    item_registry["ORE_T1_004"].id = "ORE_T1_004"
    item_registry["ORE_T1_004"].name = "Cuprex"
    item_registry["ORE_T1_004"].category = ItemCategory.ORE
    item_registry["ORE_T1_004"].tier = 1
    item_registry["ORE_T1_004"].base_price = 115
    item_registry["ORE_T1_004"].volume = 25.0
    item_registry["ORE_T1_004"].mass = 9.0
    item_registry["ORE_T1_004"].description = "Cuprex"

    # ORE_T1_005 - Palestone
    item_registry["ORE_T1_005"] = ItemData.new()
    item_registry["ORE_T1_005"].id = "ORE_T1_005"
    item_registry["ORE_T1_005"].name = "Palestone"
    item_registry["ORE_T1_005"].category = ItemCategory.ORE
    item_registry["ORE_T1_005"].tier = 1
    item_registry["ORE_T1_005"].base_price = 140
    item_registry["ORE_T1_005"].volume = 22.0
    item_registry["ORE_T1_005"].mass = 8.0
    item_registry["ORE_T1_005"].description = "Palestone"

    # ORE_T1_006 - Titanex
    item_registry["ORE_T1_006"] = ItemData.new()
    item_registry["ORE_T1_006"].id = "ORE_T1_006"
    item_registry["ORE_T1_006"].name = "Titanex"
    item_registry["ORE_T1_006"].category = ItemCategory.ORE
    item_registry["ORE_T1_006"].tier = 1
    item_registry["ORE_T1_006"].base_price = 180
    item_registry["ORE_T1_006"].volume = 23.0
    item_registry["ORE_T1_006"].mass = 7.0
    item_registry["ORE_T1_006"].description = "Titanex"

    # ORE_T1_007 - Densore
    item_registry["ORE_T1_007"] = ItemData.new()
    item_registry["ORE_T1_007"].id = "ORE_T1_007"
    item_registry["ORE_T1_007"].name = "Densore"
    item_registry["ORE_T1_007"].category = ItemCategory.ORE
    item_registry["ORE_T1_007"].tier = 1
    item_registry["ORE_T1_007"].base_price = 160
    item_registry["ORE_T1_007"].volume = 28.0
    item_registry["ORE_T1_007"].mass = 6.0
    item_registry["ORE_T1_007"].description = "Densore"

    # ORE_T1_008 - Mirrorvein
    item_registry["ORE_T1_008"] = ItemData.new()
    item_registry["ORE_T1_008"].id = "ORE_T1_008"
    item_registry["ORE_T1_008"].name = "Mirrorvein"
    item_registry["ORE_T1_008"].category = ItemCategory.ORE
    item_registry["ORE_T1_008"].tier = 1
    item_registry["ORE_T1_008"].base_price = 200
    item_registry["ORE_T1_008"].volume = 24.0
    item_registry["ORE_T1_008"].mass = 5.0
    item_registry["ORE_T1_008"].description = "Mirrorvein"

    # ORE_T1_009 - Azurex
    item_registry["ORE_T1_009"] = ItemData.new()
    item_registry["ORE_T1_009"].id = "ORE_T1_009"
    item_registry["ORE_T1_009"].name = "Azurex"
    item_registry["ORE_T1_009"].category = ItemCategory.ORE
    item_registry["ORE_T1_009"].tier = 1
    item_registry["ORE_T1_009"].base_price = 220
    item_registry["ORE_T1_009"].volume = 26.0
    item_registry["ORE_T1_009"].mass = 4.0
    item_registry["ORE_T1_009"].description = "Azurex"

    # ORE_T1_010 - Sunvein
    item_registry["ORE_T1_010"] = ItemData.new()
    item_registry["ORE_T1_010"].id = "ORE_T1_010"
    item_registry["ORE_T1_010"].name = "Sunvein"
    item_registry["ORE_T1_010"].category = ItemCategory.ORE
    item_registry["ORE_T1_010"].tier = 1
    item_registry["ORE_T1_010"].base_price = 250
    item_registry["ORE_T1_010"].volume = 25.0
    item_registry["ORE_T1_010"].mass = 3.0
    item_registry["ORE_T1_010"].description = "Sunvein"

    # ORE_T2_011 - Chromore
    item_registry["ORE_T2_011"] = ItemData.new()
    item_registry["ORE_T2_011"].id = "ORE_T2_011"
    item_registry["ORE_T2_011"].name = "Chromore"
    item_registry["ORE_T2_011"].category = ItemCategory.ORE
    item_registry["ORE_T2_011"].tier = 2
    item_registry["ORE_T2_011"].base_price = 400
    item_registry["ORE_T2_011"].volume = 27.0
    item_registry["ORE_T2_011"].mass = 5.0
    item_registry["ORE_T2_011"].description = "Chromore"

    # ORE_T2_012 - Noblore
    item_registry["ORE_T2_012"] = ItemData.new()
    item_registry["ORE_T2_012"].id = "ORE_T2_012"
    item_registry["ORE_T2_012"].name = "Noblore"
    item_registry["ORE_T2_012"].category = ItemCategory.ORE
    item_registry["ORE_T2_012"].tier = 2
    item_registry["ORE_T2_012"].base_price = 500
    item_registry["ORE_T2_012"].volume = 30.0
    item_registry["ORE_T2_012"].mass = 4.0
    item_registry["ORE_T2_012"].description = "Noblore"

    # ORE_T2_013 - Abyssite
    item_registry["ORE_T2_013"] = ItemData.new()
    item_registry["ORE_T2_013"].id = "ORE_T2_013"
    item_registry["ORE_T2_013"].name = "Abyssite"
    item_registry["ORE_T2_013"].category = ItemCategory.ORE
    item_registry["ORE_T2_013"].tier = 2
    item_registry["ORE_T2_013"].base_price = 550
    item_registry["ORE_T2_013"].volume = 29.0
    item_registry["ORE_T2_013"].mass = 3.0
    item_registry["ORE_T2_013"].description = "Abyssite"

    # ORE_T2_014 - Radiantweave
    item_registry["ORE_T2_014"] = ItemData.new()
    item_registry["ORE_T2_014"].id = "ORE_T2_014"
    item_registry["ORE_T2_014"].name = "Radiantweave"
    item_registry["ORE_T2_014"].category = ItemCategory.ORE
    item_registry["ORE_T2_014"].tier = 2
    item_registry["ORE_T2_014"].base_price = 600
    item_registry["ORE_T2_014"].volume = 24.0
    item_registry["ORE_T2_014"].mass = 3.0
    item_registry["ORE_T2_014"].description = "Radiantweave"

    # ORE_T2_015 - Fluxore
    item_registry["ORE_T2_015"] = ItemData.new()
    item_registry["ORE_T2_015"].id = "ORE_T2_015"
    item_registry["ORE_T2_015"].name = "Fluxore"
    item_registry["ORE_T2_015"].category = ItemCategory.ORE
    item_registry["ORE_T2_015"].tier = 2
    item_registry["ORE_T2_015"].base_price = 700
    item_registry["ORE_T2_015"].volume = 28.0
    item_registry["ORE_T2_015"].mass = 2.0
    item_registry["ORE_T2_015"].description = "Fluxore"

    # ORE_T3_016 - Radex
    item_registry["ORE_T3_016"] = ItemData.new()
    item_registry["ORE_T3_016"].id = "ORE_T3_016"
    item_registry["ORE_T3_016"].name = "Radex"
    item_registry["ORE_T3_016"].category = ItemCategory.ORE
    item_registry["ORE_T3_016"].tier = 3
    item_registry["ORE_T3_016"].base_price = 1500
    item_registry["ORE_T3_016"].volume = 26.0
    item_registry["ORE_T3_016"].mass = 2.0
    item_registry["ORE_T3_016"].description = "Radex"

    # ORE_T3_017 - Fusionore
    item_registry["ORE_T3_017"] = ItemData.new()
    item_registry["ORE_T3_017"].id = "ORE_T3_017"
    item_registry["ORE_T3_017"].name = "Fusionore"
    item_registry["ORE_T3_017"].category = ItemCategory.ORE
    item_registry["ORE_T3_017"].tier = 3
    item_registry["ORE_T3_017"].base_price = 1800
    item_registry["ORE_T3_017"].volume = 27.0
    item_registry["ORE_T3_017"].mass = 1.5
    item_registry["ORE_T3_017"].description = "Fusionore"

    # ORE_T3_018 - Attractore
    item_registry["ORE_T3_018"] = ItemData.new()
    item_registry["ORE_T3_018"].id = "ORE_T3_018"
    item_registry["ORE_T3_018"].name = "Attractore"
    item_registry["ORE_T3_018"].category = ItemCategory.ORE
    item_registry["ORE_T3_018"].tier = 3
    item_registry["ORE_T3_018"].base_price = 2000
    item_registry["ORE_T3_018"].volume = 29.0
    item_registry["ORE_T3_018"].mass = 1.0
    item_registry["ORE_T3_018"].description = "Attractore"

    # ORE_T3_019 - Novaore
    item_registry["ORE_T3_019"] = ItemData.new()
    item_registry["ORE_T3_019"].id = "ORE_T3_019"
    item_registry["ORE_T3_019"].name = "Novaore"
    item_registry["ORE_T3_019"].category = ItemCategory.ORE
    item_registry["ORE_T3_019"].tier = 3
    item_registry["ORE_T3_019"].base_price = 2200
    item_registry["ORE_T3_019"].volume = 25.0
    item_registry["ORE_T3_019"].mass = 1.0
    item_registry["ORE_T3_019"].description = "Novaore"

    # ORE_T3_020 - Auralith
    item_registry["ORE_T3_020"] = ItemData.new()
    item_registry["ORE_T3_020"].id = "ORE_T3_020"
    item_registry["ORE_T3_020"].name = "Auralith"
    item_registry["ORE_T3_020"].category = ItemCategory.ORE
    item_registry["ORE_T3_020"].tier = 3
    item_registry["ORE_T3_020"].base_price = 3000
    item_registry["ORE_T3_020"].volume = 24.0
    item_registry["ORE_T3_020"].mass = 0.5
    item_registry["ORE_T3_020"].description = "Auralith"

    # ORE_T4_021 - Lumispar
    item_registry["ORE_T4_021"] = ItemData.new()
    item_registry["ORE_T4_021"].id = "ORE_T4_021"
    item_registry["ORE_T4_021"].name = "Lumispar"
    item_registry["ORE_T4_021"].category = ItemCategory.ORE
    item_registry["ORE_T4_021"].tier = 4
    item_registry["ORE_T4_021"].base_price = 5000
    item_registry["ORE_T4_021"].volume = 23.0
    item_registry["ORE_T4_021"].mass = 0.5
    item_registry["ORE_T4_021"].description = "Lumispar"

    # ORE_T4_022 - Nexalith
    item_registry["ORE_T4_022"] = ItemData.new()
    item_registry["ORE_T4_022"].id = "ORE_T4_022"
    item_registry["ORE_T4_022"].name = "Nexalith"
    item_registry["ORE_T4_022"].category = ItemCategory.ORE
    item_registry["ORE_T4_022"].tier = 4
    item_registry["ORE_T4_022"].base_price = 6000
    item_registry["ORE_T4_022"].volume = 24.0
    item_registry["ORE_T4_022"].mass = 0.4
    item_registry["ORE_T4_022"].description = "Nexalith"

    # ORE_T4_023 - Cupralith
    item_registry["ORE_T4_023"] = ItemData.new()
    item_registry["ORE_T4_023"].id = "ORE_T4_023"
    item_registry["ORE_T4_023"].name = "Cupralith"
    item_registry["ORE_T4_023"].category = ItemCategory.ORE
    item_registry["ORE_T4_023"].tier = 4
    item_registry["ORE_T4_023"].base_price = 7500
    item_registry["ORE_T4_023"].volume = 25.0
    item_registry["ORE_T4_023"].mass = 0.3
    item_registry["ORE_T4_023"].description = "Cupralith"

    # ORE_T4_024 - Alumara
    item_registry["ORE_T4_024"] = ItemData.new()
    item_registry["ORE_T4_024"].id = "ORE_T4_024"
    item_registry["ORE_T4_024"].name = "Alumara"
    item_registry["ORE_T4_024"].category = ItemCategory.ORE
    item_registry["ORE_T4_024"].tier = 4
    item_registry["ORE_T4_024"].base_price = 8000
    item_registry["ORE_T4_024"].volume = 22.0
    item_registry["ORE_T4_024"].mass = 0.3
    item_registry["ORE_T4_024"].description = "Alumara"

    # ORE_T4_025 - Serendyn
    item_registry["ORE_T4_025"] = ItemData.new()
    item_registry["ORE_T4_025"].id = "ORE_T4_025"
    item_registry["ORE_T4_025"].name = "Serendyn"
    item_registry["ORE_T4_025"].category = ItemCategory.ORE
    item_registry["ORE_T4_025"].tier = 4
    item_registry["ORE_T4_025"].base_price = 10000
    item_registry["ORE_T4_025"].volume = 21.0
    item_registry["ORE_T4_025"].mass = 0.2
    item_registry["ORE_T4_025"].description = "Serendyn"

    # ORE_T5_026 - Rhodochros
    item_registry["ORE_T5_026"] = ItemData.new()
    item_registry["ORE_T5_026"].id = "ORE_T5_026"
    item_registry["ORE_T5_026"].name = "Rhodochros"
    item_registry["ORE_T5_026"].category = ItemCategory.ORE
    item_registry["ORE_T5_026"].tier = 5
    item_registry["ORE_T5_026"].base_price = 20000
    item_registry["ORE_T5_026"].volume = 20.0
    item_registry["ORE_T5_026"].mass = 0.08
    item_registry["ORE_T5_026"].description = "Rhodochros"

    # ORE_T5_027 - Chromdravit
    item_registry["ORE_T5_027"] = ItemData.new()
    item_registry["ORE_T5_027"].id = "ORE_T5_027"
    item_registry["ORE_T5_027"].name = "Chromdravit"
    item_registry["ORE_T5_027"].category = ItemCategory.ORE
    item_registry["ORE_T5_027"].tier = 5
    item_registry["ORE_T5_027"].base_price = 25000
    item_registry["ORE_T5_027"].volume = 19.0
    item_registry["ORE_T5_027"].mass = 0.06
    item_registry["ORE_T5_027"].description = "Chromdravit"

    # ORE_T5_028 - Cobaltore
    item_registry["ORE_T5_028"] = ItemData.new()
    item_registry["ORE_T5_028"].id = "ORE_T5_028"
    item_registry["ORE_T5_028"].name = "Cobaltore"
    item_registry["ORE_T5_028"].category = ItemCategory.ORE
    item_registry["ORE_T5_028"].tier = 5
    item_registry["ORE_T5_028"].base_price = 30000
    item_registry["ORE_T5_028"].volume = 21.0
    item_registry["ORE_T5_028"].mass = 0.05
    item_registry["ORE_T5_028"].description = "Cobaltore"

    # ORE_T5_029 - Hematine
    item_registry["ORE_T5_029"] = ItemData.new()
    item_registry["ORE_T5_029"].id = "ORE_T5_029"
    item_registry["ORE_T5_029"].name = "Hematine"
    item_registry["ORE_T5_029"].category = ItemCategory.ORE
    item_registry["ORE_T5_029"].tier = 5
    item_registry["ORE_T5_029"].base_price = 35000
    item_registry["ORE_T5_029"].volume = 22.0
    item_registry["ORE_T5_029"].mass = 0.04
    item_registry["ORE_T5_029"].description = "Hematine"

    # ORE_T5_030 - Borax
    item_registry["ORE_T5_030"] = ItemData.new()
    item_registry["ORE_T5_030"].id = "ORE_T5_030"
    item_registry["ORE_T5_030"].name = "Borax"
    item_registry["ORE_T5_030"].category = ItemCategory.ORE
    item_registry["ORE_T5_030"].tier = 5
    item_registry["ORE_T5_030"].base_price = 40000
    item_registry["ORE_T5_030"].volume = 20.0
    item_registry["ORE_T5_030"].mass = 0.03
    item_registry["ORE_T5_030"].description = "Borax"

    # ORE_T6_031 - Cassiteride
    item_registry["ORE_T6_031"] = ItemData.new()
    item_registry["ORE_T6_031"].id = "ORE_T6_031"
    item_registry["ORE_T6_031"].name = "Cassiteride"
    item_registry["ORE_T6_031"].category = ItemCategory.ORE
    item_registry["ORE_T6_031"].tier = 6
    item_registry["ORE_T6_031"].base_price = 100000
    item_registry["ORE_T6_031"].volume = 18.0
    item_registry["ORE_T6_031"].mass = 0.03
    item_registry["ORE_T6_031"].description = "Cassiteride"

    # ORE_T6_032 - Vanadinite
    item_registry["ORE_T6_032"] = ItemData.new()
    item_registry["ORE_T6_032"].id = "ORE_T6_032"
    item_registry["ORE_T6_032"].name = "Vanadinite"
    item_registry["ORE_T6_032"].category = ItemCategory.ORE
    item_registry["ORE_T6_032"].tier = 6
    item_registry["ORE_T6_032"].base_price = 150000
    item_registry["ORE_T6_032"].volume = 17.0
    item_registry["ORE_T6_032"].mass = 0.01
    item_registry["ORE_T6_032"].description = "Vanadinite"

    # MAT_T1_001 - Ironyx
    item_registry["MAT_T1_001"] = ItemData.new()
    item_registry["MAT_T1_001"].id = "MAT_T1_001"
    item_registry["MAT_T1_001"].name = "Ironyx"
    item_registry["MAT_T1_001"].category = ItemCategory.MINERAL
    item_registry["MAT_T1_001"].tier = 1
    item_registry["MAT_T1_001"].base_price = 1000
    item_registry["MAT_T1_001"].volume = 2.5
    item_registry["MAT_T1_001"].mass = 10.0
    item_registry["MAT_T1_001"].description = "Ironyx"

    # MAT_T1_002 - Redwire
    item_registry["MAT_T1_002"] = ItemData.new()
    item_registry["MAT_T1_002"].id = "MAT_T1_002"
    item_registry["MAT_T1_002"].name = "Redwire"
    item_registry["MAT_T1_002"].category = ItemCategory.MINERAL
    item_registry["MAT_T1_002"].tier = 1
    item_registry["MAT_T1_002"].base_price = 1000
    item_registry["MAT_T1_002"].volume = 2.3
    item_registry["MAT_T1_002"].mass = 10.0
    item_registry["MAT_T1_002"].description = "Redwire"

    # MAT_T1_003 - Stannel
    item_registry["MAT_T1_003"] = ItemData.new()
    item_registry["MAT_T1_003"].id = "MAT_T1_003"
    item_registry["MAT_T1_003"].name = "Stannel"
    item_registry["MAT_T1_003"].category = ItemCategory.MINERAL
    item_registry["MAT_T1_003"].tier = 1
    item_registry["MAT_T1_003"].base_price = 1000
    item_registry["MAT_T1_003"].volume = 2.4
    item_registry["MAT_T1_003"].mass = 10.0
    item_registry["MAT_T1_003"].description = "Stannel"

    # MAT_T1_004 - Galvan
    item_registry["MAT_T1_004"] = ItemData.new()
    item_registry["MAT_T1_004"].id = "MAT_T1_004"
    item_registry["MAT_T1_004"].name = "Galvan"
    item_registry["MAT_T1_004"].category = ItemCategory.MINERAL
    item_registry["MAT_T1_004"].tier = 1
    item_registry["MAT_T1_004"].base_price = 1000
    item_registry["MAT_T1_004"].volume = 2.6
    item_registry["MAT_T1_004"].mass = 10.0
    item_registry["MAT_T1_004"].description = "Galvan"

    # MAT_T1_005 - Skylar
    item_registry["MAT_T1_005"] = ItemData.new()
    item_registry["MAT_T1_005"].id = "MAT_T1_005"
    item_registry["MAT_T1_005"].name = "Skylar"
    item_registry["MAT_T1_005"].category = ItemCategory.MINERAL
    item_registry["MAT_T1_005"].tier = 1
    item_registry["MAT_T1_005"].base_price = 1000
    item_registry["MAT_T1_005"].volume = 2.0
    item_registry["MAT_T1_005"].mass = 10.0
    item_registry["MAT_T1_005"].description = "Skylar"

    # MAT_T2_006 - Plumbex
    item_registry["MAT_T2_006"] = ItemData.new()
    item_registry["MAT_T2_006"].id = "MAT_T2_006"
    item_registry["MAT_T2_006"].name = "Plumbex"
    item_registry["MAT_T2_006"].category = ItemCategory.MINERAL
    item_registry["MAT_T2_006"].tier = 2
    item_registry["MAT_T2_006"].base_price = 1000
    item_registry["MAT_T2_006"].volume = 3.2
    item_registry["MAT_T2_006"].mass = 10.0
    item_registry["MAT_T2_006"].description = "Plumbex"

    # MAT_T2_007 - Mangyx
    item_registry["MAT_T2_007"] = ItemData.new()
    item_registry["MAT_T2_007"].id = "MAT_T2_007"
    item_registry["MAT_T2_007"].name = "Mangyx"
    item_registry["MAT_T2_007"].category = ItemCategory.MINERAL
    item_registry["MAT_T2_007"].tier = 2
    item_registry["MAT_T2_007"].base_price = 1000
    item_registry["MAT_T2_007"].volume = 2.7
    item_registry["MAT_T2_007"].mass = 10.0
    item_registry["MAT_T2_007"].description = "Mangyx"

    # MAT_T2_008 - Chromex
    item_registry["MAT_T2_008"] = ItemData.new()
    item_registry["MAT_T2_008"].id = "MAT_T2_008"
    item_registry["MAT_T2_008"].name = "Chromex"
    item_registry["MAT_T2_008"].category = ItemCategory.MINERAL
    item_registry["MAT_T2_008"].tier = 2
    item_registry["MAT_T2_008"].base_price = 1000
    item_registry["MAT_T2_008"].volume = 2.5
    item_registry["MAT_T2_008"].mass = 10.0
    item_registry["MAT_T2_008"].description = "Chromex"

    # MAT_T2_009 - Nickron
    item_registry["MAT_T2_009"] = ItemData.new()
    item_registry["MAT_T2_009"].id = "MAT_T2_009"
    item_registry["MAT_T2_009"].name = "Nickron"
    item_registry["MAT_T2_009"].category = ItemCategory.MINERAL
    item_registry["MAT_T2_009"].tier = 2
    item_registry["MAT_T2_009"].base_price = 1000
    item_registry["MAT_T2_009"].volume = 2.6
    item_registry["MAT_T2_009"].mass = 10.0
    item_registry["MAT_T2_009"].description = "Nickron"

    # MAT_T2_010 - Titanyx
    item_registry["MAT_T2_010"] = ItemData.new()
    item_registry["MAT_T2_010"].id = "MAT_T2_010"
    item_registry["MAT_T2_010"].name = "Titanyx"
    item_registry["MAT_T2_010"].category = ItemCategory.MINERAL
    item_registry["MAT_T2_010"].tier = 2
    item_registry["MAT_T2_010"].base_price = 1000
    item_registry["MAT_T2_010"].volume = 2.4
    item_registry["MAT_T2_010"].mass = 10.0
    item_registry["MAT_T2_010"].description = "Titanyx"

    # MAT_T2_011 - Vanox
    item_registry["MAT_T2_011"] = ItemData.new()
    item_registry["MAT_T2_011"].id = "MAT_T2_011"
    item_registry["MAT_T2_011"].name = "Vanox"
    item_registry["MAT_T2_011"].category = ItemCategory.MINERAL
    item_registry["MAT_T2_011"].tier = 2
    item_registry["MAT_T2_011"].base_price = 1000
    item_registry["MAT_T2_011"].volume = 2.8
    item_registry["MAT_T2_011"].mass = 10.0
    item_registry["MAT_T2_011"].description = "Vanox"

    # MAT_T2_012 - Kobaltyx
    item_registry["MAT_T2_012"] = ItemData.new()
    item_registry["MAT_T2_012"].id = "MAT_T2_012"
    item_registry["MAT_T2_012"].name = "Kobaltyx"
    item_registry["MAT_T2_012"].category = ItemCategory.MINERAL
    item_registry["MAT_T2_012"].tier = 2
    item_registry["MAT_T2_012"].base_price = 1000
    item_registry["MAT_T2_012"].volume = 2.7
    item_registry["MAT_T2_012"].mass = 10.0
    item_registry["MAT_T2_012"].description = "Kobaltyx"

    # MAT_T2_013 - Silicron
    item_registry["MAT_T2_013"] = ItemData.new()
    item_registry["MAT_T2_013"].id = "MAT_T2_013"
    item_registry["MAT_T2_013"].name = "Silicron"
    item_registry["MAT_T2_013"].category = ItemCategory.MINERAL
    item_registry["MAT_T2_013"].tier = 2
    item_registry["MAT_T2_013"].base_price = 1000
    item_registry["MAT_T2_013"].volume = 2.2
    item_registry["MAT_T2_013"].mass = 10.0
    item_registry["MAT_T2_013"].description = "Silicron"

    # MAT_T2_014 - Carbonex
    item_registry["MAT_T2_014"] = ItemData.new()
    item_registry["MAT_T2_014"].id = "MAT_T2_014"
    item_registry["MAT_T2_014"].name = "Carbonex"
    item_registry["MAT_T2_014"].category = ItemCategory.MINERAL
    item_registry["MAT_T2_014"].tier = 2
    item_registry["MAT_T2_014"].base_price = 1000
    item_registry["MAT_T2_014"].volume = 1.8
    item_registry["MAT_T2_014"].mass = 10.0
    item_registry["MAT_T2_014"].description = "Carbonex"

    # MAT_T2_015 - Polymyx
    item_registry["MAT_T2_015"] = ItemData.new()
    item_registry["MAT_T2_015"].id = "MAT_T2_015"
    item_registry["MAT_T2_015"].name = "Polymyx"
    item_registry["MAT_T2_015"].category = ItemCategory.MINERAL
    item_registry["MAT_T2_015"].tier = 2
    item_registry["MAT_T2_015"].base_price = 1000
    item_registry["MAT_T2_015"].volume = 1.5
    item_registry["MAT_T2_015"].mass = 10.0
    item_registry["MAT_T2_015"].description = "Polymyx"

    # MAT_T3_016 - Fissium-U
    item_registry["MAT_T3_016"] = ItemData.new()
    item_registry["MAT_T3_016"].id = "MAT_T3_016"
    item_registry["MAT_T3_016"].name = "Fissium-U"
    item_registry["MAT_T3_016"].category = ItemCategory.MINERAL
    item_registry["MAT_T3_016"].tier = 3
    item_registry["MAT_T3_016"].base_price = 1000
    item_registry["MAT_T3_016"].volume = 3.5
    item_registry["MAT_T3_016"].mass = 10.0
    item_registry["MAT_T3_016"].description = "Fissium-U"

    # MAT_T3_017 - Thorex
    item_registry["MAT_T3_017"] = ItemData.new()
    item_registry["MAT_T3_017"].id = "MAT_T3_017"
    item_registry["MAT_T3_017"].name = "Thorex"
    item_registry["MAT_T3_017"].category = ItemCategory.MINERAL
    item_registry["MAT_T3_017"].tier = 3
    item_registry["MAT_T3_017"].base_price = 1000
    item_registry["MAT_T3_017"].volume = 3.4
    item_registry["MAT_T3_017"].mass = 10.0
    item_registry["MAT_T3_017"].description = "Thorex"

    # MAT_T3_018 - Tungstyx
    item_registry["MAT_T3_018"] = ItemData.new()
    item_registry["MAT_T3_018"].id = "MAT_T3_018"
    item_registry["MAT_T3_018"].name = "Tungstyx"
    item_registry["MAT_T3_018"].category = ItemCategory.MINERAL
    item_registry["MAT_T3_018"].tier = 3
    item_registry["MAT_T3_018"].base_price = 1000
    item_registry["MAT_T3_018"].volume = 3.8
    item_registry["MAT_T3_018"].mass = 10.0
    item_registry["MAT_T3_018"].description = "Tungstyx"

    # MAT_T3_019 - Magnyx
    item_registry["MAT_T3_019"] = ItemData.new()
    item_registry["MAT_T3_019"].id = "MAT_T3_019"
    item_registry["MAT_T3_019"].name = "Magnyx"
    item_registry["MAT_T3_019"].category = ItemCategory.MINERAL
    item_registry["MAT_T3_019"].tier = 3
    item_registry["MAT_T3_019"].base_price = 1000
    item_registry["MAT_T3_019"].volume = 2.9
    item_registry["MAT_T3_019"].mass = 10.0
    item_registry["MAT_T3_019"].description = "Magnyx"

    # MAT_T3_020 - Aurex
    item_registry["MAT_T3_020"] = ItemData.new()
    item_registry["MAT_T3_020"].id = "MAT_T3_020"
    item_registry["MAT_T3_020"].name = "Aurex"
    item_registry["MAT_T3_020"].category = ItemCategory.MINERAL
    item_registry["MAT_T3_020"].tier = 3
    item_registry["MAT_T3_020"].base_price = 1000
    item_registry["MAT_T3_020"].volume = 2.0
    item_registry["MAT_T3_020"].mass = 10.0
    item_registry["MAT_T3_020"].description = "Aurex"

    # MAT_T3_021 - Selenyx
    item_registry["MAT_T3_021"] = ItemData.new()
    item_registry["MAT_T3_021"].id = "MAT_T3_021"
    item_registry["MAT_T3_021"].name = "Selenyx"
    item_registry["MAT_T3_021"].category = ItemCategory.MINERAL
    item_registry["MAT_T3_021"].tier = 3
    item_registry["MAT_T3_021"].base_price = 1000
    item_registry["MAT_T3_021"].volume = 2.6
    item_registry["MAT_T3_021"].mass = 10.0
    item_registry["MAT_T3_021"].description = "Selenyx"

    # MAT_T3_022 - Germyx
    item_registry["MAT_T3_022"] = ItemData.new()
    item_registry["MAT_T3_022"].id = "MAT_T3_022"
    item_registry["MAT_T3_022"].name = "Germyx"
    item_registry["MAT_T3_022"].category = ItemCategory.MINERAL
    item_registry["MAT_T3_022"].tier = 3
    item_registry["MAT_T3_022"].base_price = 1000
    item_registry["MAT_T3_022"].volume = 2.3
    item_registry["MAT_T3_022"].mass = 10.0
    item_registry["MAT_T3_022"].description = "Germyx"

    # MAT_T4_023 - Yttrex
    item_registry["MAT_T4_023"] = ItemData.new()
    item_registry["MAT_T4_023"].id = "MAT_T4_023"
    item_registry["MAT_T4_023"].name = "Yttrex"
    item_registry["MAT_T4_023"].category = ItemCategory.MINERAL
    item_registry["MAT_T4_023"].tier = 4
    item_registry["MAT_T4_023"].base_price = 1000
    item_registry["MAT_T4_023"].volume = 2.7
    item_registry["MAT_T4_023"].mass = 10.0
    item_registry["MAT_T4_023"].description = "Yttrex"

    # MAT_T4_024 - Niobyx
    item_registry["MAT_T4_024"] = ItemData.new()
    item_registry["MAT_T4_024"].id = "MAT_T4_024"
    item_registry["MAT_T4_024"].name = "Niobyx"
    item_registry["MAT_T4_024"].category = ItemCategory.MINERAL
    item_registry["MAT_T4_024"].tier = 4
    item_registry["MAT_T4_024"].base_price = 1000
    item_registry["MAT_T4_024"].volume = 2.5
    item_registry["MAT_T4_024"].mass = 10.0
    item_registry["MAT_T4_024"].description = "Niobyx"

    # MAT_T4_025 - Platikar
    item_registry["MAT_T4_025"] = ItemData.new()
    item_registry["MAT_T4_025"].id = "MAT_T4_025"
    item_registry["MAT_T4_025"].name = "Platikar"
    item_registry["MAT_T4_025"].category = ItemCategory.MINERAL
    item_registry["MAT_T4_025"].tier = 4
    item_registry["MAT_T4_025"].base_price = 1000
    item_registry["MAT_T4_025"].volume = 2.1
    item_registry["MAT_T4_025"].mass = 10.0
    item_registry["MAT_T4_025"].description = "Platikar"

    # MAT_T4_026 - Beryllex
    item_registry["MAT_T4_026"] = ItemData.new()
    item_registry["MAT_T4_026"].id = "MAT_T4_026"
    item_registry["MAT_T4_026"].name = "Beryllex"
    item_registry["MAT_T4_026"].category = ItemCategory.MINERAL
    item_registry["MAT_T4_026"].tier = 4
    item_registry["MAT_T4_026"].base_price = 1000
    item_registry["MAT_T4_026"].volume = 1.9
    item_registry["MAT_T4_026"].mass = 10.0
    item_registry["MAT_T4_026"].description = "Beryllex"

    # MAT_T4_027 - Fissium-Pu
    item_registry["MAT_T4_027"] = ItemData.new()
    item_registry["MAT_T4_027"].id = "MAT_T4_027"
    item_registry["MAT_T4_027"].name = "Fissium-Pu"
    item_registry["MAT_T4_027"].category = ItemCategory.MINERAL
    item_registry["MAT_T4_027"].tier = 4
    item_registry["MAT_T4_027"].base_price = 1000
    item_registry["MAT_T4_027"].volume = 3.6
    item_registry["MAT_T4_027"].mass = 10.0
    item_registry["MAT_T4_027"].description = "Fissium-Pu"

    # MAT_T5_028 - Borcrys
    item_registry["MAT_T5_028"] = ItemData.new()
    item_registry["MAT_T5_028"].id = "MAT_T5_028"
    item_registry["MAT_T5_028"].name = "Borcrys"
    item_registry["MAT_T5_028"].category = ItemCategory.MINERAL
    item_registry["MAT_T5_028"].tier = 5
    item_registry["MAT_T5_028"].base_price = 1000
    item_registry["MAT_T5_028"].volume = 1.7
    item_registry["MAT_T5_028"].mass = 10.0
    item_registry["MAT_T5_028"].description = "Borcrys"

    # MAT_T5_029 - Neurogel
    item_registry["MAT_T5_029"] = ItemData.new()
    item_registry["MAT_T5_029"].id = "MAT_T5_029"
    item_registry["MAT_T5_029"].name = "Neurogel"
    item_registry["MAT_T5_029"].category = ItemCategory.MINERAL
    item_registry["MAT_T5_029"].tier = 5
    item_registry["MAT_T5_029"].base_price = 1000
    item_registry["MAT_T5_029"].volume = 1.2
    item_registry["MAT_T5_029"].mass = 10.0
    item_registry["MAT_T5_029"].description = "Neurogel"

    # MAT_T5_030 - Voidshatter
    item_registry["MAT_T5_030"] = ItemData.new()
    item_registry["MAT_T5_030"].id = "MAT_T5_030"
    item_registry["MAT_T5_030"].name = "Voidshatter"
    item_registry["MAT_T5_030"].category = ItemCategory.MINERAL
    item_registry["MAT_T5_030"].tier = 5
    item_registry["MAT_T5_030"].base_price = 1000
    item_registry["MAT_T5_030"].volume = 1.5
    item_registry["MAT_T5_030"].mass = 10.0
    item_registry["MAT_T5_030"].description = "Voidshatter"

    # MAT_T6_031 - Phasium
    item_registry["MAT_T6_031"] = ItemData.new()
    item_registry["MAT_T6_031"].id = "MAT_T6_031"
    item_registry["MAT_T6_031"].name = "Phasium"
    item_registry["MAT_T6_031"].category = ItemCategory.MINERAL
    item_registry["MAT_T6_031"].tier = 6
    item_registry["MAT_T6_031"].base_price = 1000
    item_registry["MAT_T6_031"].volume = 1.3
    item_registry["MAT_T6_031"].mass = 10.0
    item_registry["MAT_T6_031"].description = "Phasium"

    # MAT_T6_032 - Chronyx
    item_registry["MAT_T6_032"] = ItemData.new()
    item_registry["MAT_T6_032"].id = "MAT_T6_032"
    item_registry["MAT_T6_032"].name = "Chronyx"
    item_registry["MAT_T6_032"].category = ItemCategory.MINERAL
    item_registry["MAT_T6_032"].tier = 6
    item_registry["MAT_T6_032"].base_price = 1000
    item_registry["MAT_T6_032"].volume = 1.4
    item_registry["MAT_T6_032"].mass = 10.0
    item_registry["MAT_T6_032"].description = "Chronyx"

    # MAT_T6_033 - Singulyx
    item_registry["MAT_T6_033"] = ItemData.new()
    item_registry["MAT_T6_033"].id = "MAT_T6_033"
    item_registry["MAT_T6_033"].name = "Singulyx"
    item_registry["MAT_T6_033"].category = ItemCategory.MINERAL
    item_registry["MAT_T6_033"].tier = 6
    item_registry["MAT_T6_033"].base_price = 1000
    item_registry["MAT_T6_033"].volume = 1.1
    item_registry["MAT_T6_033"].mass = 10.0
    item_registry["MAT_T6_033"].description = "Singulyx"

    # GAS_T1_001 - Hydrogen
    item_registry["GAS_T1_001"] = ItemData.new()
    item_registry["GAS_T1_001"].id = "GAS_T1_001"
    item_registry["GAS_T1_001"].name = "Hydrogen"
    item_registry["GAS_T1_001"].category = ItemCategory.GAS
    item_registry["GAS_T1_001"].tier = 1
    item_registry["GAS_T1_001"].base_price = 1000
    item_registry["GAS_T1_001"].volume = 50.0
    item_registry["GAS_T1_001"].mass = 1100.0
    item_registry["GAS_T1_001"].description = "Hydrogen"

    # GAS_T1_002 - Oxygen
    item_registry["GAS_T1_002"] = ItemData.new()
    item_registry["GAS_T1_002"].id = "GAS_T1_002"
    item_registry["GAS_T1_002"].name = "Oxygen"
    item_registry["GAS_T1_002"].category = ItemCategory.GAS
    item_registry["GAS_T1_002"].tier = 1
    item_registry["GAS_T1_002"].base_price = 1000
    item_registry["GAS_T1_002"].volume = 60.0
    item_registry["GAS_T1_002"].mass = 700.0
    item_registry["GAS_T1_002"].description = "Oxygen"

    # GAS_T1_003 - Nitrogen
    item_registry["GAS_T1_003"] = ItemData.new()
    item_registry["GAS_T1_003"].id = "GAS_T1_003"
    item_registry["GAS_T1_003"].name = "Nitrogen"
    item_registry["GAS_T1_003"].category = ItemCategory.GAS
    item_registry["GAS_T1_003"].tier = 1
    item_registry["GAS_T1_003"].base_price = 1000
    item_registry["GAS_T1_003"].volume = 45.0
    item_registry["GAS_T1_003"].mass = 800.0
    item_registry["GAS_T1_003"].description = "Nitrogen"

    # GAS_T2_001 - Argon
    item_registry["GAS_T2_001"] = ItemData.new()
    item_registry["GAS_T2_001"].id = "GAS_T2_001"
    item_registry["GAS_T2_001"].name = "Argon"
    item_registry["GAS_T2_001"].category = ItemCategory.GAS
    item_registry["GAS_T2_001"].tier = 2
    item_registry["GAS_T2_001"].base_price = 1000
    item_registry["GAS_T2_001"].volume = 150.0
    item_registry["GAS_T2_001"].mass = 600.0
    item_registry["GAS_T2_001"].description = "Argon"

    # GAS_T2_002 - Projectile Supercarrierium
    item_registry["GAS_T2_002"] = ItemData.new()
    item_registry["GAS_T2_002"].id = "GAS_T2_002"
    item_registry["GAS_T2_002"].name = "Projectile Supercarrierium"
    item_registry["GAS_T2_002"].category = ItemCategory.GAS
    item_registry["GAS_T2_002"].tier = 2
    item_registry["GAS_T2_002"].base_price = 1000
    item_registry["GAS_T2_002"].volume = 200.0
    item_registry["GAS_T2_002"].mass = 900.0
    item_registry["GAS_T2_002"].description = "Helium"

    # GAS_T2_003 - Methane
    item_registry["GAS_T2_003"] = ItemData.new()
    item_registry["GAS_T2_003"].id = "GAS_T2_003"
    item_registry["GAS_T2_003"].name = "Methane"
    item_registry["GAS_T2_003"].category = ItemCategory.GAS
    item_registry["GAS_T2_003"].tier = 2
    item_registry["GAS_T2_003"].base_price = 1000
    item_registry["GAS_T2_003"].volume = 180.0
    item_registry["GAS_T2_003"].mass = 650.0
    item_registry["GAS_T2_003"].description = "Methane"

    # GAS_T3_001 - Neon
    item_registry["GAS_T3_001"] = ItemData.new()
    item_registry["GAS_T3_001"].id = "GAS_T3_001"
    item_registry["GAS_T3_001"].name = "Neon"
    item_registry["GAS_T3_001"].category = ItemCategory.GAS
    item_registry["GAS_T3_001"].tier = 3
    item_registry["GAS_T3_001"].base_price = 1000
    item_registry["GAS_T3_001"].volume = 1000.0
    item_registry["GAS_T3_001"].mass = 550.0
    item_registry["GAS_T3_001"].description = "Neon"

    # GAS_T3_002 - Xenon
    item_registry["GAS_T3_002"] = ItemData.new()
    item_registry["GAS_T3_002"].id = "GAS_T3_002"
    item_registry["GAS_T3_002"].name = "Xenon"
    item_registry["GAS_T3_002"].category = ItemCategory.GAS
    item_registry["GAS_T3_002"].tier = 3
    item_registry["GAS_T3_002"].base_price = 1000
    item_registry["GAS_T3_002"].volume = 2000.0
    item_registry["GAS_T3_002"].mass = 500.0
    item_registry["GAS_T3_002"].description = "Xenon"

    # GAS_T3_003 - Plasma-Gas
    item_registry["GAS_T3_003"] = ItemData.new()
    item_registry["GAS_T3_003"].id = "GAS_T3_003"
    item_registry["GAS_T3_003"].name = "Plasma-Gas"
    item_registry["GAS_T3_003"].category = ItemCategory.GAS
    item_registry["GAS_T3_003"].tier = 3
    item_registry["GAS_T3_003"].base_price = 1000
    item_registry["GAS_T3_003"].volume = 3000.0
    item_registry["GAS_T3_003"].mass = 400.0
    item_registry["GAS_T3_003"].description = "Plasma-Gas"

    # GAS_T4_001 - Deuterium
    item_registry["GAS_T4_001"] = ItemData.new()
    item_registry["GAS_T4_001"].id = "GAS_T4_001"
    item_registry["GAS_T4_001"].name = "Deuterium"
    item_registry["GAS_T4_001"].category = ItemCategory.GAS
    item_registry["GAS_T4_001"].tier = 4
    item_registry["GAS_T4_001"].base_price = 1000
    item_registry["GAS_T4_001"].volume = 50000.0
    item_registry["GAS_T4_001"].mass = 800.0
    item_registry["GAS_T4_001"].description = "Deuterium"

    # WASTE_001 - Gestein
    item_registry["WASTE_001"] = ItemData.new()
    item_registry["WASTE_001"].id = "WASTE_001"
    item_registry["WASTE_001"].name = "Gestein"
    item_registry["WASTE_001"].category = ItemCategory.WASTE
    item_registry["WASTE_001"].tier = 40
    item_registry["WASTE_001"].base_price = 1000
    item_registry["WASTE_001"].volume = 10.0
    item_registry["WASTE_001"].mass = 5.0
    item_registry["WASTE_001"].description = "Gestein"

    # WASTE_002 - Kiesel
    item_registry["WASTE_002"] = ItemData.new()
    item_registry["WASTE_002"].id = "WASTE_002"
    item_registry["WASTE_002"].name = "Kiesel"
    item_registry["WASTE_002"].category = ItemCategory.WASTE
    item_registry["WASTE_002"].tier = 35
    item_registry["WASTE_002"].base_price = 1000
    item_registry["WASTE_002"].volume = 10.0
    item_registry["WASTE_002"].mass = 8.0
    item_registry["WASTE_002"].description = "Kiesel"

    # WASTE_003 - Sand
    item_registry["WASTE_003"] = ItemData.new()
    item_registry["WASTE_003"].id = "WASTE_003"
    item_registry["WASTE_003"].name = "Sand"
    item_registry["WASTE_003"].category = ItemCategory.WASTE
    item_registry["WASTE_003"].tier = 30
    item_registry["WASTE_003"].base_price = 1000
    item_registry["WASTE_003"].volume = 10.0
    item_registry["WASTE_003"].mass = 12.0
    item_registry["WASTE_003"].description = "Sand"

    # WASTE_004 - Lehm
    item_registry["WASTE_004"] = ItemData.new()
    item_registry["WASTE_004"].id = "WASTE_004"
    item_registry["WASTE_004"].name = "Lehm"
    item_registry["WASTE_004"].category = ItemCategory.WASTE
    item_registry["WASTE_004"].tier = 25
    item_registry["WASTE_004"].base_price = 1000
    item_registry["WASTE_004"].volume = 10.0
    item_registry["WASTE_004"].mass = 15.0
    item_registry["WASTE_004"].description = "Lehm"

    # WASTE_005 - Granit
    item_registry["WASTE_005"] = ItemData.new()
    item_registry["WASTE_005"].id = "WASTE_005"
    item_registry["WASTE_005"].name = "Granit"
    item_registry["WASTE_005"].category = ItemCategory.WASTE
    item_registry["WASTE_005"].tier = 50
    item_registry["WASTE_005"].base_price = 1000
    item_registry["WASTE_005"].volume = 10.0
    item_registry["WASTE_005"].mass = 20.0
    item_registry["WASTE_005"].description = "Granit"

    # SCAN_T1_001 - Ore-Scanner Mk1
    item_registry["SCAN_T1_001"] = ItemData.new()
    item_registry["SCAN_T1_001"].id = "SCAN_T1_001"
    item_registry["SCAN_T1_001"].name = "Ore-Scanner Mk1"
    item_registry["SCAN_T1_001"].category = ItemCategory.MODULE
    item_registry["SCAN_T1_001"].tier = Scanner
    item_registry["SCAN_T1_001"].base_price = 1000
    item_registry["SCAN_T1_001"].volume = 10.0
    item_registry["SCAN_T1_001"].mass = 1.0
    item_registry["SCAN_T1_001"].description = "Ore-Scanner Mk1"

    # SCAN_T2_001 - Ore-Scanner Mk2
    item_registry["SCAN_T2_001"] = ItemData.new()
    item_registry["SCAN_T2_001"].id = "SCAN_T2_001"
    item_registry["SCAN_T2_001"].name = "Ore-Scanner Mk2"
    item_registry["SCAN_T2_001"].category = ItemCategory.MODULE
    item_registry["SCAN_T2_001"].tier = Scanner
    item_registry["SCAN_T2_001"].base_price = 1000
    item_registry["SCAN_T2_001"].volume = 10.0
    item_registry["SCAN_T2_001"].mass = 2.0
    item_registry["SCAN_T2_001"].description = "Ore-Scanner Mk2"

    # SCAN_T3_001 - Advanced Scanner
    item_registry["SCAN_T3_001"] = ItemData.new()
    item_registry["SCAN_T3_001"].id = "SCAN_T3_001"
    item_registry["SCAN_T3_001"].name = "Advanced Scanner"
    item_registry["SCAN_T3_001"].category = ItemCategory.MODULE
    item_registry["SCAN_T3_001"].tier = Scanner
    item_registry["SCAN_T3_001"].base_price = 1000
    item_registry["SCAN_T3_001"].volume = 10.0
    item_registry["SCAN_T3_001"].mass = 3.0
    item_registry["SCAN_T3_001"].description = "Advanced Scanner"

    # SCAN_T4_001 - Precision Scanner
    item_registry["SCAN_T4_001"] = ItemData.new()
    item_registry["SCAN_T4_001"].id = "SCAN_T4_001"
    item_registry["SCAN_T4_001"].name = "Precision Scanner"
    item_registry["SCAN_T4_001"].category = ItemCategory.MODULE
    item_registry["SCAN_T4_001"].tier = Scanner
    item_registry["SCAN_T4_001"].base_price = 1000
    item_registry["SCAN_T4_001"].volume = 10.0
    item_registry["SCAN_T4_001"].mass = 4.0
    item_registry["SCAN_T4_001"].description = "Precision Scanner"

    # SCAN_T5_001 - Quantum Scanner
    item_registry["SCAN_T5_001"] = ItemData.new()
    item_registry["SCAN_T5_001"].id = "SCAN_T5_001"
    item_registry["SCAN_T5_001"].name = "Quantum Scanner"
    item_registry["SCAN_T5_001"].category = ItemCategory.MODULE
    item_registry["SCAN_T5_001"].tier = Scanner
    item_registry["SCAN_T5_001"].base_price = 1000
    item_registry["SCAN_T5_001"].volume = 10.0
    item_registry["SCAN_T5_001"].mass = 5.0
    item_registry["SCAN_T5_001"].description = "Quantum Scanner"

    # MINE_T1_001 - Mining Laser I
    item_registry["MINE_T1_001"] = ItemData.new()
    item_registry["MINE_T1_001"].id = "MINE_T1_001"
    item_registry["MINE_T1_001"].name = "Mining Laser I"
    item_registry["MINE_T1_001"].category = ItemCategory.MODULE
    item_registry["MINE_T1_001"].tier = Miner
    item_registry["MINE_T1_001"].base_price = 1000
    item_registry["MINE_T1_001"].volume = 10.0
    item_registry["MINE_T1_001"].mass = 1.0
    item_registry["MINE_T1_001"].description = "Mining Laser I"

    # MINE_T2_001 - Mining Laser II
    item_registry["MINE_T2_001"] = ItemData.new()
    item_registry["MINE_T2_001"].id = "MINE_T2_001"
    item_registry["MINE_T2_001"].name = "Mining Laser II"
    item_registry["MINE_T2_001"].category = ItemCategory.MODULE
    item_registry["MINE_T2_001"].tier = Miner
    item_registry["MINE_T2_001"].base_price = 1000
    item_registry["MINE_T2_001"].volume = 10.0
    item_registry["MINE_T2_001"].mass = 2.0
    item_registry["MINE_T2_001"].description = "Mining Laser II"

    # MINE_T3_001 - Strip Miner
    item_registry["MINE_T3_001"] = ItemData.new()
    item_registry["MINE_T3_001"].id = "MINE_T3_001"
    item_registry["MINE_T3_001"].name = "Strip Miner"
    item_registry["MINE_T3_001"].category = ItemCategory.MODULE
    item_registry["MINE_T3_001"].tier = Miner
    item_registry["MINE_T3_001"].base_price = 1000
    item_registry["MINE_T3_001"].volume = 10.0
    item_registry["MINE_T3_001"].mass = 3.0
    item_registry["MINE_T3_001"].description = "Strip Miner"

    # MINE_T4_001 - Modulated Strip Miner
    item_registry["MINE_T4_001"] = ItemData.new()
    item_registry["MINE_T4_001"].id = "MINE_T4_001"
    item_registry["MINE_T4_001"].name = "Modulated Strip Miner"
    item_registry["MINE_T4_001"].category = ItemCategory.MODULE
    item_registry["MINE_T4_001"].tier = Miner
    item_registry["MINE_T4_001"].base_price = 1000
    item_registry["MINE_T4_001"].volume = 10.0
    item_registry["MINE_T4_001"].mass = 4.0
    item_registry["MINE_T4_001"].description = "Modulated Strip Miner"

    # MINE_T5_001 - ORE Extraction Beam
    item_registry["MINE_T5_001"] = ItemData.new()
    item_registry["MINE_T5_001"].id = "MINE_T5_001"
    item_registry["MINE_T5_001"].name = "ORE Extraction Beam"
    item_registry["MINE_T5_001"].category = ItemCategory.MODULE
    item_registry["MINE_T5_001"].tier = Miner
    item_registry["MINE_T5_001"].base_price = 1000
    item_registry["MINE_T5_001"].volume = 10.0
    item_registry["MINE_T5_001"].mass = 5.0
    item_registry["MINE_T5_001"].description = "ORE Extraction Beam"

    # STAB_T1_001 - Basic Stabilizer
    item_registry["STAB_T1_001"] = ItemData.new()
    item_registry["STAB_T1_001"].id = "STAB_T1_001"
    item_registry["STAB_T1_001"].name = "Basic Stabilizer"
    item_registry["STAB_T1_001"].category = ItemCategory.MODULE
    item_registry["STAB_T1_001"].tier = Stabilizer
    item_registry["STAB_T1_001"].base_price = 1000
    item_registry["STAB_T1_001"].volume = 10.0
    item_registry["STAB_T1_001"].mass = 1.0
    item_registry["STAB_T1_001"].description = "Basic Stabilizer"

    # STAB_T2_001 - Enhanced Stabilizer
    item_registry["STAB_T2_001"] = ItemData.new()
    item_registry["STAB_T2_001"].id = "STAB_T2_001"
    item_registry["STAB_T2_001"].name = "Enhanced Stabilizer"
    item_registry["STAB_T2_001"].category = ItemCategory.MODULE
    item_registry["STAB_T2_001"].tier = Stabilizer
    item_registry["STAB_T2_001"].base_price = 1000
    item_registry["STAB_T2_001"].volume = 10.0
    item_registry["STAB_T2_001"].mass = 2.0
    item_registry["STAB_T2_001"].description = "Enhanced Stabilizer"

    # STAB_T3_001 - Advanced Stabilizer
    item_registry["STAB_T3_001"] = ItemData.new()
    item_registry["STAB_T3_001"].id = "STAB_T3_001"
    item_registry["STAB_T3_001"].name = "Advanced Stabilizer"
    item_registry["STAB_T3_001"].category = ItemCategory.MODULE
    item_registry["STAB_T3_001"].tier = Stabilizer
    item_registry["STAB_T3_001"].base_price = 1000
    item_registry["STAB_T3_001"].volume = 10.0
    item_registry["STAB_T3_001"].mass = 3.0
    item_registry["STAB_T3_001"].description = "Advanced Stabilizer"

    # STAB_T4_001 - Precision Stabilizer
    item_registry["STAB_T4_001"] = ItemData.new()
    item_registry["STAB_T4_001"].id = "STAB_T4_001"
    item_registry["STAB_T4_001"].name = "Precision Stabilizer"
    item_registry["STAB_T4_001"].category = ItemCategory.MODULE
    item_registry["STAB_T4_001"].tier = Stabilizer
    item_registry["STAB_T4_001"].base_price = 1000
    item_registry["STAB_T4_001"].volume = 10.0
    item_registry["STAB_T4_001"].mass = 4.0
    item_registry["STAB_T4_001"].description = "Precision Stabilizer"

    # STAB_T5_001 - Quantum Stabilizer
    item_registry["STAB_T5_001"] = ItemData.new()
    item_registry["STAB_T5_001"].id = "STAB_T5_001"
    item_registry["STAB_T5_001"].name = "Quantum Stabilizer"
    item_registry["STAB_T5_001"].category = ItemCategory.MODULE
    item_registry["STAB_T5_001"].tier = Stabilizer
    item_registry["STAB_T5_001"].base_price = 1000
    item_registry["STAB_T5_001"].volume = 10.0
    item_registry["STAB_T5_001"].mass = 5.0
    item_registry["STAB_T5_001"].description = "Quantum Stabilizer"

    # MOPS_T1_001 - Basic Mining Operator
    item_registry["MOPS_T1_001"] = ItemData.new()
    item_registry["MOPS_T1_001"].id = "MOPS_T1_001"
    item_registry["MOPS_T1_001"].name = "Basic Mining Operator"
    item_registry["MOPS_T1_001"].category = ItemCategory.COMPONENT
    item_registry["MOPS_T1_001"].tier = Operator
    item_registry["MOPS_T1_001"].base_price = 1000
    item_registry["MOPS_T1_001"].volume = 10.0
    item_registry["MOPS_T1_001"].mass = 1.0
    item_registry["MOPS_T1_001"].description = "Basic Mining Operator"

    # MOPS_T2_001 - Enhanced Mining Operator
    item_registry["MOPS_T2_001"] = ItemData.new()
    item_registry["MOPS_T2_001"].id = "MOPS_T2_001"
    item_registry["MOPS_T2_001"].name = "Enhanced Mining Operator"
    item_registry["MOPS_T2_001"].category = ItemCategory.COMPONENT
    item_registry["MOPS_T2_001"].tier = Operator
    item_registry["MOPS_T2_001"].base_price = 1000
    item_registry["MOPS_T2_001"].volume = 10.0
    item_registry["MOPS_T2_001"].mass = 2.0
    item_registry["MOPS_T2_001"].description = "Enhanced Mining Operator"

    # MOPS_T3_001 - Advanced Mining Operator
    item_registry["MOPS_T3_001"] = ItemData.new()
    item_registry["MOPS_T3_001"].id = "MOPS_T3_001"
    item_registry["MOPS_T3_001"].name = "Advanced Mining Operator"
    item_registry["MOPS_T3_001"].category = ItemCategory.COMPONENT
    item_registry["MOPS_T3_001"].tier = Operator
    item_registry["MOPS_T3_001"].base_price = 1000
    item_registry["MOPS_T3_001"].volume = 10.0
    item_registry["MOPS_T3_001"].mass = 3.0
    item_registry["MOPS_T3_001"].description = "Advanced Mining Operator"

    # MOPS_T4_001 - Precision Mining Operator
    item_registry["MOPS_T4_001"] = ItemData.new()
    item_registry["MOPS_T4_001"].id = "MOPS_T4_001"
    item_registry["MOPS_T4_001"].name = "Precision Mining Operator"
    item_registry["MOPS_T4_001"].category = ItemCategory.COMPONENT
    item_registry["MOPS_T4_001"].tier = Operator
    item_registry["MOPS_T4_001"].base_price = 1000
    item_registry["MOPS_T4_001"].volume = 10.0
    item_registry["MOPS_T4_001"].mass = 4.0
    item_registry["MOPS_T4_001"].description = "Precision Mining Operator"

    # MOPS_T5_001 - Quantum Mining Operator
    item_registry["MOPS_T5_001"] = ItemData.new()
    item_registry["MOPS_T5_001"].id = "MOPS_T5_001"
    item_registry["MOPS_T5_001"].name = "Quantum Mining Operator"
    item_registry["MOPS_T5_001"].category = ItemCategory.COMPONENT
    item_registry["MOPS_T5_001"].tier = Operator
    item_registry["MOPS_T5_001"].base_price = 1000
    item_registry["MOPS_T5_001"].volume = 10.0
    item_registry["MOPS_T5_001"].mass = 5.0
    item_registry["MOPS_T5_001"].description = "Quantum Mining Operator"

    # SOCK_T1_001 - Basic Enhancement Socket
    item_registry["SOCK_T1_001"] = ItemData.new()
    item_registry["SOCK_T1_001"].id = "SOCK_T1_001"
    item_registry["SOCK_T1_001"].name = "Basic Enhancement Socket"
    item_registry["SOCK_T1_001"].category = ItemCategory.COMPONENT
    item_registry["SOCK_T1_001"].tier = Socket
    item_registry["SOCK_T1_001"].base_price = 1000
    item_registry["SOCK_T1_001"].volume = 10.0
    item_registry["SOCK_T1_001"].mass = 1.0
    item_registry["SOCK_T1_001"].description = "Basic Enhancement Socket"

    # SOCK_T2_001 - Enhanced Socket
    item_registry["SOCK_T2_001"] = ItemData.new()
    item_registry["SOCK_T2_001"].id = "SOCK_T2_001"
    item_registry["SOCK_T2_001"].name = "Enhanced Socket"
    item_registry["SOCK_T2_001"].category = ItemCategory.COMPONENT
    item_registry["SOCK_T2_001"].tier = Socket
    item_registry["SOCK_T2_001"].base_price = 1000
    item_registry["SOCK_T2_001"].volume = 10.0
    item_registry["SOCK_T2_001"].mass = 2.0
    item_registry["SOCK_T2_001"].description = "Enhanced Socket"

    # SOCK_T3_001 - Advanced Socket
    item_registry["SOCK_T3_001"] = ItemData.new()
    item_registry["SOCK_T3_001"].id = "SOCK_T3_001"
    item_registry["SOCK_T3_001"].name = "Advanced Socket"
    item_registry["SOCK_T3_001"].category = ItemCategory.COMPONENT
    item_registry["SOCK_T3_001"].tier = Socket
    item_registry["SOCK_T3_001"].base_price = 1000
    item_registry["SOCK_T3_001"].volume = 10.0
    item_registry["SOCK_T3_001"].mass = 3.0
    item_registry["SOCK_T3_001"].description = "Advanced Socket"

    # SOCK_T4_001 - Precision Socket
    item_registry["SOCK_T4_001"] = ItemData.new()
    item_registry["SOCK_T4_001"].id = "SOCK_T4_001"
    item_registry["SOCK_T4_001"].name = "Precision Socket"
    item_registry["SOCK_T4_001"].category = ItemCategory.COMPONENT
    item_registry["SOCK_T4_001"].tier = Socket
    item_registry["SOCK_T4_001"].base_price = 1000
    item_registry["SOCK_T4_001"].volume = 10.0
    item_registry["SOCK_T4_001"].mass = 4.0
    item_registry["SOCK_T4_001"].description = "Precision Socket"

    # SOCK_T5_001 - Quantum Socket
    item_registry["SOCK_T5_001"] = ItemData.new()
    item_registry["SOCK_T5_001"].id = "SOCK_T5_001"
    item_registry["SOCK_T5_001"].name = "Quantum Socket"
    item_registry["SOCK_T5_001"].category = ItemCategory.COMPONENT
    item_registry["SOCK_T5_001"].tier = Socket
    item_registry["SOCK_T5_001"].base_price = 1000
    item_registry["SOCK_T5_001"].volume = 10.0
    item_registry["SOCK_T5_001"].mass = 5.0
    item_registry["SOCK_T5_001"].description = "Quantum Socket"

    # COMP_001 - Flux Capacitor Unit
    item_registry["COMP_001"] = ItemData.new()
    item_registry["COMP_001"].id = "COMP_001"
    item_registry["COMP_001"].name = "Flux Capacitor Unit"
    item_registry["COMP_001"].category = ItemCategory.COMPONENT
    item_registry["COMP_001"].tier = 1
    item_registry["COMP_001"].base_price = 500
    item_registry["COMP_001"].volume = 0.5
    item_registry["COMP_001"].mass = 5
    item_registry["COMP_001"].description = "Electronic warfare capabilities"

    # COMP_002 - Circuit Matrix Board
    item_registry["COMP_002"] = ItemData.new()
    item_registry["COMP_002"].id = "COMP_002"
    item_registry["COMP_002"].name = "Circuit Matrix Board"
    item_registry["COMP_002"].category = ItemCategory.COMPONENT
    item_registry["COMP_002"].tier = 1
    item_registry["COMP_002"].base_price = 450
    item_registry["COMP_002"].volume = 0.3
    item_registry["COMP_002"].mass = 3
    item_registry["COMP_002"].description = "Electronic warfare capabilities"

    # COMP_003 - Nano-Lattice Frame
    item_registry["COMP_003"] = ItemData.new()
    item_registry["COMP_003"].id = "COMP_003"
    item_registry["COMP_003"].name = "Nano-Lattice Frame"
    item_registry["COMP_003"].category = ItemCategory.COMPONENT
    item_registry["COMP_003"].tier = 1
    item_registry["COMP_003"].base_price = 400
    item_registry["COMP_003"].volume = 0.8
    item_registry["COMP_003"].mass = 8
    item_registry["COMP_003"].description = "Structural framework component"

    # COMP_004 - Plasma Conduit Array
    item_registry["COMP_004"] = ItemData.new()
    item_registry["COMP_004"].id = "COMP_004"
    item_registry["COMP_004"].name = "Plasma Conduit Array"
    item_registry["COMP_004"].category = ItemCategory.COMPONENT
    item_registry["COMP_004"].tier = 2
    item_registry["COMP_004"].base_price = 800
    item_registry["COMP_004"].volume = 0.4
    item_registry["COMP_004"].mass = 4
    item_registry["COMP_004"].description = "Energy transfer component"

    # COMP_005 - Quantum Relay Node
    item_registry["COMP_005"] = ItemData.new()
    item_registry["COMP_005"].id = "COMP_005"
    item_registry["COMP_005"].name = "Quantum Relay Node"
    item_registry["COMP_005"].category = ItemCategory.COMPONENT
    item_registry["COMP_005"].tier = 2
    item_registry["COMP_005"].base_price = 1200
    item_registry["COMP_005"].volume = 0.2
    item_registry["COMP_005"].mass = 2
    item_registry["COMP_005"].description = "Electronic warfare capabilities"

    # COMP_006 - Servo-Actuator Assembly
    item_registry["COMP_006"] = ItemData.new()
    item_registry["COMP_006"].id = "COMP_006"
    item_registry["COMP_006"].name = "Servo-Actuator Assembly"
    item_registry["COMP_006"].category = ItemCategory.COMPONENT
    item_registry["COMP_006"].tier = 2
    item_registry["COMP_006"].base_price = 700
    item_registry["COMP_006"].volume = 0.6
    item_registry["COMP_006"].mass = 6
    item_registry["COMP_006"].description = "Manufacturing component"

    # COMP_007 - Photonic Processor Core
    item_registry["COMP_007"] = ItemData.new()
    item_registry["COMP_007"].id = "COMP_007"
    item_registry["COMP_007"].name = "Photonic Processor Core"
    item_registry["COMP_007"].category = ItemCategory.COMPONENT
    item_registry["COMP_007"].tier = 3
    item_registry["COMP_007"].base_price = 2500
    item_registry["COMP_007"].volume = 0.4
    item_registry["COMP_007"].mass = 4
    item_registry["COMP_007"].description = "Electronic warfare capabilities"

    # COMP_008 - Reinforced Bulkhead
    item_registry["COMP_008"] = ItemData.new()
    item_registry["COMP_008"].id = "COMP_008"
    item_registry["COMP_008"].name = "Reinforced Bulkhead"
    item_registry["COMP_008"].category = ItemCategory.COMPONENT
    item_registry["COMP_008"].tier = 2
    item_registry["COMP_008"].base_price = 900
    item_registry["COMP_008"].volume = 2.0
    item_registry["COMP_008"].mass = 20
    item_registry["COMP_008"].description = "Manufacturing component"

    # COMP_009 - Sensor Array Module
    item_registry["COMP_009"] = ItemData.new()
    item_registry["COMP_009"].id = "COMP_009"
    item_registry["COMP_009"].name = "Sensor Array Module"
    item_registry["COMP_009"].category = ItemCategory.COMPONENT
    item_registry["COMP_009"].tier = 2
    item_registry["COMP_009"].base_price = 1500
    item_registry["COMP_009"].volume = 0.3
    item_registry["COMP_009"].mass = 3
    item_registry["COMP_009"].description = "Manufacturing component"

    # COMP_010 - Fusion Regulator Unit
    item_registry["COMP_010"] = ItemData.new()
    item_registry["COMP_010"].id = "COMP_010"
    item_registry["COMP_010"].name = "Fusion Regulator Unit"
    item_registry["COMP_010"].category = ItemCategory.COMPONENT
    item_registry["COMP_010"].tier = 3
    item_registry["COMP_010"].base_price = 3000
    item_registry["COMP_010"].volume = 0.7
    item_registry["COMP_010"].mass = 7
    item_registry["COMP_010"].description = "Manufacturing component"

    # COMP_011 - Graphene Heatsink
    item_registry["COMP_011"] = ItemData.new()
    item_registry["COMP_011"].id = "COMP_011"
    item_registry["COMP_011"].name = "Graphene Heatsink"
    item_registry["COMP_011"].category = ItemCategory.COMPONENT
    item_registry["COMP_011"].tier = 2
    item_registry["COMP_011"].base_price = 850
    item_registry["COMP_011"].volume = 0.4
    item_registry["COMP_011"].mass = 4
    item_registry["COMP_011"].description = "Manufacturing component"

    # COMP_012 - Crystalline Focusing Lens
    item_registry["COMP_012"] = ItemData.new()
    item_registry["COMP_012"].id = "COMP_012"
    item_registry["COMP_012"].name = "Crystalline Focusing Lens"
    item_registry["COMP_012"].category = ItemCategory.COMPONENT
    item_registry["COMP_012"].tier = 3
    item_registry["COMP_012"].base_price = 1800
    item_registry["COMP_012"].volume = 0.1
    item_registry["COMP_012"].mass = 1
    item_registry["COMP_012"].description = "Manufacturing component"

    # COMP_013 - Hyper-Threading Core
    item_registry["COMP_013"] = ItemData.new()
    item_registry["COMP_013"].id = "COMP_013"
    item_registry["COMP_013"].name = "Hyper-Threading Core"
    item_registry["COMP_013"].category = ItemCategory.COMPONENT
    item_registry["COMP_013"].tier = 3
    item_registry["COMP_013"].base_price = 4000
    item_registry["COMP_013"].volume = 0.5
    item_registry["COMP_013"].mass = 5
    item_registry["COMP_013"].description = "Electronic warfare capabilities"

    # COMP_014 - Magnetic Confinement Ring
    item_registry["COMP_014"] = ItemData.new()
    item_registry["COMP_014"].id = "COMP_014"
    item_registry["COMP_014"].name = "Magnetic Confinement Ring"
    item_registry["COMP_014"].category = ItemCategory.COMPONENT
    item_registry["COMP_014"].tier = 3
    item_registry["COMP_014"].base_price = 2800
    item_registry["COMP_014"].volume = 1.5
    item_registry["COMP_014"].mass = 15
    item_registry["COMP_014"].description = "Manufacturing component"

    # COMP_015 - Adaptive Armor Plate
    item_registry["COMP_015"] = ItemData.new()
    item_registry["COMP_015"].id = "COMP_015"
    item_registry["COMP_015"].name = "Adaptive Armor Plate"
    item_registry["COMP_015"].category = ItemCategory.COMPONENT
    item_registry["COMP_015"].tier = 3
    item_registry["COMP_015"].base_price = 3500
    item_registry["COMP_015"].volume = 2.5
    item_registry["COMP_015"].mass = 25
    item_registry["COMP_015"].description = "Manufacturing component"

    # COMP_016 - Temporal Stabilizer
    item_registry["COMP_016"] = ItemData.new()
    item_registry["COMP_016"].id = "COMP_016"
    item_registry["COMP_016"].name = "Temporal Stabilizer"
    item_registry["COMP_016"].category = ItemCategory.COMPONENT
    item_registry["COMP_016"].tier = 4
    item_registry["COMP_016"].base_price = 6000
    item_registry["COMP_016"].volume = 0.3
    item_registry["COMP_016"].mass = 3
    item_registry["COMP_016"].description = "Manufacturing component"

    # COMP_017 - Neural Interface Module
    item_registry["COMP_017"] = ItemData.new()
    item_registry["COMP_017"].id = "COMP_017"
    item_registry["COMP_017"].name = "Neural Interface Module"
    item_registry["COMP_017"].category = ItemCategory.COMPONENT
    item_registry["COMP_017"].tier = 3
    item_registry["COMP_017"].base_price = 5000
    item_registry["COMP_017"].volume = 0.2
    item_registry["COMP_017"].mass = 2
    item_registry["COMP_017"].description = "Electronic warfare capabilities"

    # COMP_018 - Drone Control Matrix
    item_registry["COMP_018"] = ItemData.new()
    item_registry["COMP_018"].id = "COMP_018"
    item_registry["COMP_018"].name = "Drone Control Matrix"
    item_registry["COMP_018"].category = ItemCategory.COMPONENT
    item_registry["COMP_018"].tier = 3
    item_registry["COMP_018"].base_price = 4500
    item_registry["COMP_018"].volume = 0.8
    item_registry["COMP_018"].mass = 8
    item_registry["COMP_018"].description = "Electronic warfare capabilities"

    # COMP_019 - Warp Core Stabilizer
    item_registry["COMP_019"] = ItemData.new()
    item_registry["COMP_019"].id = "COMP_019"
    item_registry["COMP_019"].name = "Warp Core Stabilizer"
    item_registry["COMP_019"].category = ItemCategory.COMPONENT
    item_registry["COMP_019"].tier = 4
    item_registry["COMP_019"].base_price = 15000
    item_registry["COMP_019"].volume = 3.0
    item_registry["COMP_019"].mass = 30
    item_registry["COMP_019"].description = "Manufacturing component"

    # COMP_020 - Quantum Entanglement Array
    item_registry["COMP_020"] = ItemData.new()
    item_registry["COMP_020"].id = "COMP_020"
    item_registry["COMP_020"].name = "Quantum Entanglement Array"
    item_registry["COMP_020"].category = ItemCategory.COMPONENT
    item_registry["COMP_020"].tier = 4
    item_registry["COMP_020"].base_price = 12000
    item_registry["COMP_020"].volume = 0.6
    item_registry["COMP_020"].mass = 6
    item_registry["COMP_020"].description = "Manufacturing component"

    # COMP_021 - Nanite Repair Swarm
    item_registry["COMP_021"] = ItemData.new()
    item_registry["COMP_021"].id = "COMP_021"
    item_registry["COMP_021"].name = "Nanite Repair Swarm"
    item_registry["COMP_021"].category = ItemCategory.COMPONENT
    item_registry["COMP_021"].tier = 4
    item_registry["COMP_021"].base_price = 8000
    item_registry["COMP_021"].volume = 0.1
    item_registry["COMP_021"].mass = 1
    item_registry["COMP_021"].description = "Manufacturing component"

    # COMP_022 - Compression Field Generator
    item_registry["COMP_022"] = ItemData.new()
    item_registry["COMP_022"].id = "COMP_022"
    item_registry["COMP_022"].name = "Compression Field Generator"
    item_registry["COMP_022"].category = ItemCategory.COMPONENT
    item_registry["COMP_022"].tier = 3
    item_registry["COMP_022"].base_price = 7000
    item_registry["COMP_022"].volume = 1.2
    item_registry["COMP_022"].mass = 12
    item_registry["COMP_022"].description = "Manufacturing component"

    # COMP_023 - Plasma Injection Manifold
    item_registry["COMP_023"] = ItemData.new()
    item_registry["COMP_023"].id = "COMP_023"
    item_registry["COMP_023"].name = "Plasma Injection Manifold"
    item_registry["COMP_023"].category = ItemCategory.COMPONENT
    item_registry["COMP_023"].tier = 3
    item_registry["COMP_023"].base_price = 3200
    item_registry["COMP_023"].volume = 1.0
    item_registry["COMP_023"].mass = 10
    item_registry["COMP_023"].description = "Manufacturing component"

    # COMP_024 - Shield Harmonic Resonator
    item_registry["COMP_024"] = ItemData.new()
    item_registry["COMP_024"].id = "COMP_024"
    item_registry["COMP_024"].name = "Shield Harmonic Resonator"
    item_registry["COMP_024"].category = ItemCategory.COMPONENT
    item_registry["COMP_024"].tier = 4
    item_registry["COMP_024"].base_price = 9000
    item_registry["COMP_024"].volume = 1.4
    item_registry["COMP_024"].mass = 14
    item_registry["COMP_024"].description = "Manufacturing component"

    # COMP_025 - Dark Matter Containment Pod
    item_registry["COMP_025"] = ItemData.new()
    item_registry["COMP_025"].id = "COMP_025"
    item_registry["COMP_025"].name = "Dark Matter Containment Pod"
    item_registry["COMP_025"].category = ItemCategory.COMPONENT
    item_registry["COMP_025"].tier = 5
    item_registry["COMP_025"].base_price = 25000
    item_registry["COMP_025"].volume = 2.0
    item_registry["COMP_025"].mass = 20
    item_registry["COMP_025"].description = "Manufacturing component"

    # COMP_026 - Ion Thruster Assembly
    item_registry["COMP_026"] = ItemData.new()
    item_registry["COMP_026"].id = "COMP_026"
    item_registry["COMP_026"].name = "Ion Thruster Assembly"
    item_registry["COMP_026"].category = ItemCategory.COMPONENT
    item_registry["COMP_026"].tier = 2
    item_registry["COMP_026"].base_price = 2200
    item_registry["COMP_026"].volume = 1.8
    item_registry["COMP_026"].mass = 18
    item_registry["COMP_026"].description = "Manufacturing component"

    # COMP_027 - Cloaking Field Emitter
    item_registry["COMP_027"] = ItemData.new()
    item_registry["COMP_027"].id = "COMP_027"
    item_registry["COMP_027"].name = "Cloaking Field Emitter"
    item_registry["COMP_027"].category = ItemCategory.COMPONENT
    item_registry["COMP_027"].tier = 4
    item_registry["COMP_027"].base_price = 18000
    item_registry["COMP_027"].volume = 2.5
    item_registry["COMP_027"].mass = 25
    item_registry["COMP_027"].description = "Manufacturing component"

    # COMP_028 - Radiation Shielding Panel
    item_registry["COMP_028"] = ItemData.new()
    item_registry["COMP_028"].id = "COMP_028"
    item_registry["COMP_028"].name = "Radiation Shielding Panel"
    item_registry["COMP_028"].category = ItemCategory.COMPONENT
    item_registry["COMP_028"].tier = 3
    item_registry["COMP_028"].base_price = 2800
    item_registry["COMP_028"].volume = 2.2
    item_registry["COMP_028"].mass = 22
    item_registry["COMP_028"].description = "Manufacturing component"

    # COMP_029 - Tractor Beam Projector
    item_registry["COMP_029"] = ItemData.new()
    item_registry["COMP_029"].id = "COMP_029"
    item_registry["COMP_029"].name = "Tractor Beam Projector"
    item_registry["COMP_029"].category = ItemCategory.COMPONENT
    item_registry["COMP_029"].tier = 3
    item_registry["COMP_029"].base_price = 5500
    item_registry["COMP_029"].volume = 1.6
    item_registry["COMP_029"].mass = 16
    item_registry["COMP_029"].description = "Manufacturing component"

    # COMP_030 - Graviton Pulse Generator
    item_registry["COMP_030"] = ItemData.new()
    item_registry["COMP_030"].id = "COMP_030"
    item_registry["COMP_030"].name = "Graviton Pulse Generator"
    item_registry["COMP_030"].category = ItemCategory.COMPONENT
    item_registry["COMP_030"].tier = 4
    item_registry["COMP_030"].base_price = 22000
    item_registry["COMP_030"].volume = 3.5
    item_registry["COMP_030"].mass = 35
    item_registry["COMP_030"].description = "Manufacturing component"

    # COMP_031 - Antimatter Injector
    item_registry["COMP_031"] = ItemData.new()
    item_registry["COMP_031"].id = "COMP_031"
    item_registry["COMP_031"].name = "Antimatter Injector"
    item_registry["COMP_031"].category = ItemCategory.COMPONENT
    item_registry["COMP_031"].tier = 5
    item_registry["COMP_031"].base_price = 30000
    item_registry["COMP_031"].volume = 1.2
    item_registry["COMP_031"].mass = 12
    item_registry["COMP_031"].description = "Manufacturing component"

    # COMP_032 - Void Crystal Resonator
    item_registry["COMP_032"] = ItemData.new()
    item_registry["COMP_032"].id = "COMP_032"
    item_registry["COMP_032"].name = "Void Crystal Resonator"
    item_registry["COMP_032"].category = ItemCategory.COMPONENT
    item_registry["COMP_032"].tier = 5
    item_registry["COMP_032"].base_price = 35000
    item_registry["COMP_032"].volume = 0.4
    item_registry["COMP_032"].mass = 4
    item_registry["COMP_032"].description = "Manufacturing component"

    # COMP_033 - Bio-Neural Gel Pack
    item_registry["COMP_033"] = ItemData.new()
    item_registry["COMP_033"].id = "COMP_033"
    item_registry["COMP_033"].name = "Bio-Neural Gel Pack"
    item_registry["COMP_033"].category = ItemCategory.COMPONENT
    item_registry["COMP_033"].tier = 3
    item_registry["COMP_033"].base_price = 6500
    item_registry["COMP_033"].volume = 0.2
    item_registry["COMP_033"].mass = 2
    item_registry["COMP_033"].description = "Electronic warfare capabilities"

    # COMP_034 - Hardened Blast Shutter
    item_registry["COMP_034"] = ItemData.new()
    item_registry["COMP_034"].id = "COMP_034"
    item_registry["COMP_034"].name = "Hardened Blast Shutter"
    item_registry["COMP_034"].category = ItemCategory.COMPONENT
    item_registry["COMP_034"].tier = 2
    item_registry["COMP_034"].base_price = 1800
    item_registry["COMP_034"].volume = 2.8
    item_registry["COMP_034"].mass = 28
    item_registry["COMP_034"].description = "Manufacturing component"

    # COMP_035 - Energy Siphon Module
    item_registry["COMP_035"] = ItemData.new()
    item_registry["COMP_035"].id = "COMP_035"
    item_registry["COMP_035"].name = "Energy Siphon Module"
    item_registry["COMP_035"].category = ItemCategory.COMPONENT
    item_registry["COMP_035"].tier = 4
    item_registry["COMP_035"].base_price = 10000
    item_registry["COMP_035"].volume = 1.1
    item_registry["COMP_035"].mass = 11
    item_registry["COMP_035"].description = "Manufacturing component"

    # COMP_036 - Subspace Transceiver
    item_registry["COMP_036"] = ItemData.new()
    item_registry["COMP_036"].id = "COMP_036"
    item_registry["COMP_036"].name = "Subspace Transceiver"
    item_registry["COMP_036"].category = ItemCategory.COMPONENT
    item_registry["COMP_036"].tier = 4
    item_registry["COMP_036"].base_price = 13000
    item_registry["COMP_036"].volume = 0.7
    item_registry["COMP_036"].mass = 7
    item_registry["COMP_036"].description = "Manufacturing component"

    # COMP_037 - Particle Accelerator Ring
    item_registry["COMP_037"] = ItemData.new()
    item_registry["COMP_037"].id = "COMP_037"
    item_registry["COMP_037"].name = "Particle Accelerator Ring"
    item_registry["COMP_037"].category = ItemCategory.COMPONENT
    item_registry["COMP_037"].tier = 4
    item_registry["COMP_037"].base_price = 16000
    item_registry["COMP_037"].volume = 4.0
    item_registry["COMP_037"].mass = 40
    item_registry["COMP_037"].description = "Manufacturing component"

    # COMP_038 - Smart Munition Processor
    item_registry["COMP_038"] = ItemData.new()
    item_registry["COMP_038"].id = "COMP_038"
    item_registry["COMP_038"].name = "Smart Munition Processor"
    item_registry["COMP_038"].category = ItemCategory.COMPONENT
    item_registry["COMP_038"].tier = 3
    item_registry["COMP_038"].base_price = 4200
    item_registry["COMP_038"].volume = 0.5
    item_registry["COMP_038"].mass = 5
    item_registry["COMP_038"].description = "Electronic computing component"

    # COMP_039 - Reactor Core Assembly
    item_registry["COMP_039"] = ItemData.new()
    item_registry["COMP_039"].id = "COMP_039"
    item_registry["COMP_039"].name = "Reactor Core Assembly"
    item_registry["COMP_039"].category = ItemCategory.COMPONENT
    item_registry["COMP_039"].tier = 4
    item_registry["COMP_039"].base_price = 35000
    item_registry["COMP_039"].volume = 10.0
    item_registry["COMP_039"].mass = 100
    item_registry["COMP_039"].description = "Manufacturing component"

    # COMP_040 - Singularity Containment Sphere
    item_registry["COMP_040"] = ItemData.new()
    item_registry["COMP_040"].id = "COMP_040"
    item_registry["COMP_040"].name = "Singularity Containment Sphere"
    item_registry["COMP_040"].category = ItemCategory.COMPONENT
    item_registry["COMP_040"].tier = 5
    item_registry["COMP_040"].base_price = 80000
    item_registry["COMP_040"].volume = 5.0
    item_registry["COMP_040"].mass = 50
    item_registry["COMP_040"].description = "Manufacturing component"

    # COMP_041 - Electro-Magnetic Coil
    item_registry["COMP_041"] = ItemData.new()
    item_registry["COMP_041"].id = "COMP_041"
    item_registry["COMP_041"].name = "Electro-Magnetic Coil"
    item_registry["COMP_041"].category = ItemCategory.COMPONENT
    item_registry["COMP_041"].tier = 1
    item_registry["COMP_041"].base_price = 350
    item_registry["COMP_041"].volume = 0.6
    item_registry["COMP_041"].mass = 6
    item_registry["COMP_041"].description = "Manufacturing component"

    # COMP_042 - Liquid Cooling Loop
    item_registry["COMP_042"] = ItemData.new()
    item_registry["COMP_042"].id = "COMP_042"
    item_registry["COMP_042"].name = "Liquid Cooling Loop"
    item_registry["COMP_042"].category = ItemCategory.COMPONENT
    item_registry["COMP_042"].tier = 2
    item_registry["COMP_042"].base_price = 1200
    item_registry["COMP_042"].volume = 1.5
    item_registry["COMP_042"].mass = 15
    item_registry["COMP_042"].description = "Manufacturing component"

    # COMP_043 - Kinetic Barrier Projector
    item_registry["COMP_043"] = ItemData.new()
    item_registry["COMP_043"].id = "COMP_043"
    item_registry["COMP_043"].name = "Kinetic Barrier Projector"
    item_registry["COMP_043"].category = ItemCategory.COMPONENT
    item_registry["COMP_043"].tier = 3
    item_registry["COMP_043"].base_price = 7500
    item_registry["COMP_043"].volume = 1.8
    item_registry["COMP_043"].mass = 18
    item_registry["COMP_043"].description = "Manufacturing component"

    # COMP_044 - Mass Driver Accelerator
    item_registry["COMP_044"] = ItemData.new()
    item_registry["COMP_044"].id = "COMP_044"
    item_registry["COMP_044"].name = "Mass Driver Accelerator"
    item_registry["COMP_044"].category = ItemCategory.COMPONENT
    item_registry["COMP_044"].tier = 3
    item_registry["COMP_044"].base_price = 8000
    item_registry["COMP_044"].volume = 4.5
    item_registry["COMP_044"].mass = 45
    item_registry["COMP_044"].description = "Manufacturing component"

    # COMP_045 - Holographic Projector
    item_registry["COMP_045"] = ItemData.new()
    item_registry["COMP_045"].id = "COMP_045"
    item_registry["COMP_045"].name = "Holographic Projector"
    item_registry["COMP_045"].category = ItemCategory.COMPONENT
    item_registry["COMP_045"].tier = 2
    item_registry["COMP_045"].base_price = 2800
    item_registry["COMP_045"].volume = 0.3
    item_registry["COMP_045"].mass = 3
    item_registry["COMP_045"].description = "Manufacturing component"

    # COMP_046 - Cargo Bay Expander
    item_registry["COMP_046"] = ItemData.new()
    item_registry["COMP_046"].id = "COMP_046"
    item_registry["COMP_046"].name = "Cargo Bay Expander"
    item_registry["COMP_046"].category = ItemCategory.COMPONENT
    item_registry["COMP_046"].tier = 2
    item_registry["COMP_046"].base_price = 3500
    item_registry["COMP_046"].volume = 5.0
    item_registry["COMP_046"].mass = 50
    item_registry["COMP_046"].description = "Manufacturing component"

    # COMP_047 - Jump Drive Capacitor
    item_registry["COMP_047"] = ItemData.new()
    item_registry["COMP_047"].id = "COMP_047"
    item_registry["COMP_047"].name = "Jump Drive Capacitor"
    item_registry["COMP_047"].category = ItemCategory.COMPONENT
    item_registry["COMP_047"].tier = 4
    item_registry["COMP_047"].base_price = 28000
    item_registry["COMP_047"].volume = 8.0
    item_registry["COMP_047"].mass = 80
    item_registry["COMP_047"].description = "Energy storage component"

    # COMP_048 - Asteroid Mining Drill
    item_registry["COMP_048"] = ItemData.new()
    item_registry["COMP_048"].id = "COMP_048"
    item_registry["COMP_048"].name = "Asteroid Mining Drill"
    item_registry["COMP_048"].category = ItemCategory.COMPONENT
    item_registry["COMP_048"].tier = 2
    item_registry["COMP_048"].base_price = 4000
    item_registry["COMP_048"].volume = 2.5
    item_registry["COMP_048"].mass = 25
    item_registry["COMP_048"].description = "Deep penetration ore extraction"

    # COMP_049 - Salvage Claw Mechanism
    item_registry["COMP_049"] = ItemData.new()
    item_registry["COMP_049"].id = "COMP_049"
    item_registry["COMP_049"].name = "Salvage Claw Mechanism"
    item_registry["COMP_049"].category = ItemCategory.COMPONENT
    item_registry["COMP_049"].tier = 2
    item_registry["COMP_049"].base_price = 3200
    item_registry["COMP_049"].volume = 2.0
    item_registry["COMP_049"].mass = 20
    item_registry["COMP_049"].description = "Manufacturing component"

    # COMP_050 - Emergency Escape Pod
    item_registry["COMP_050"] = ItemData.new()
    item_registry["COMP_050"].id = "COMP_050"
    item_registry["COMP_050"].name = "Emergency Escape Pod"
    item_registry["COMP_050"].category = ItemCategory.COMPONENT
    item_registry["COMP_050"].tier = 2
    item_registry["COMP_050"].base_price = 5000
    item_registry["COMP_050"].volume = 3.0
    item_registry["COMP_050"].mass = 30
    item_registry["COMP_050"].description = "Manufacturing component"

    # COMP_051 - Stealth Coating Layer
    item_registry["COMP_051"] = ItemData.new()
    item_registry["COMP_051"].id = "COMP_051"
    item_registry["COMP_051"].name = "Stealth Coating Layer"
    item_registry["COMP_051"].category = ItemCategory.COMPONENT
    item_registry["COMP_051"].tier = 3
    item_registry["COMP_051"].base_price = 9000
    item_registry["COMP_051"].volume = 0.8
    item_registry["COMP_051"].mass = 8
    item_registry["COMP_051"].description = "Manufacturing component"

    # COMP_052 - Auto-Targeting System
    item_registry["COMP_052"] = ItemData.new()
    item_registry["COMP_052"].id = "COMP_052"
    item_registry["COMP_052"].name = "Auto-Targeting System"
    item_registry["COMP_052"].category = ItemCategory.COMPONENT
    item_registry["COMP_052"].tier = 3
    item_registry["COMP_052"].base_price = 5500
    item_registry["COMP_052"].volume = 0.4
    item_registry["COMP_052"].mass = 4
    item_registry["COMP_052"].description = "Manufacturing component"

    # COMP_053 - Power Distribution Node
    item_registry["COMP_053"] = ItemData.new()
    item_registry["COMP_053"].id = "COMP_053"
    item_registry["COMP_053"].name = "Power Distribution Node"
    item_registry["COMP_053"].category = ItemCategory.COMPONENT
    item_registry["COMP_053"].tier = 2
    item_registry["COMP_053"].base_price = 2400
    item_registry["COMP_053"].volume = 1.2
    item_registry["COMP_053"].mass = 12
    item_registry["COMP_053"].description = "Manufacturing component"

    # COMP_054 - Thermal Lance Emitter
    item_registry["COMP_054"] = ItemData.new()
    item_registry["COMP_054"].id = "COMP_054"
    item_registry["COMP_054"].name = "Thermal Lance Emitter"
    item_registry["COMP_054"].category = ItemCategory.COMPONENT
    item_registry["COMP_054"].tier = 3
    item_registry["COMP_054"].base_price = 6800
    item_registry["COMP_054"].volume = 2.2
    item_registry["COMP_054"].mass = 22
    item_registry["COMP_054"].description = "Manufacturing component"

    # COMP_055 - Mineral Scanner Array
    item_registry["COMP_055"] = ItemData.new()
    item_registry["COMP_055"].id = "COMP_055"
    item_registry["COMP_055"].name = "Mineral Scanner Array"
    item_registry["COMP_055"].category = ItemCategory.COMPONENT
    item_registry["COMP_055"].tier = 2
    item_registry["COMP_055"].base_price = 3800
    item_registry["COMP_055"].volume = 0.5
    item_registry["COMP_055"].mass = 5
    item_registry["COMP_055"].description = "Enhances mining operations"

    # COMP_056 - Trade Computer Core
    item_registry["COMP_056"] = ItemData.new()
    item_registry["COMP_056"].id = "COMP_056"
    item_registry["COMP_056"].name = "Trade Computer Core"
    item_registry["COMP_056"].category = ItemCategory.COMPONENT
    item_registry["COMP_056"].tier = 2
    item_registry["COMP_056"].base_price = 4500
    item_registry["COMP_056"].volume = 0.3
    item_registry["COMP_056"].mass = 3
    item_registry["COMP_056"].description = "Manufacturing component"

    # COMP_057 - Warp Nacelle Housing
    item_registry["COMP_057"] = ItemData.new()
    item_registry["COMP_057"].id = "COMP_057"
    item_registry["COMP_057"].name = "Warp Nacelle Housing"
    item_registry["COMP_057"].category = ItemCategory.COMPONENT
    item_registry["COMP_057"].tier = 4
    item_registry["COMP_057"].base_price = 32000
    item_registry["COMP_057"].volume = 12.0
    item_registry["COMP_057"].mass = 120
    item_registry["COMP_057"].description = "Manufacturing component"

    # COMP_058 - Life Support Recycler
    item_registry["COMP_058"] = ItemData.new()
    item_registry["COMP_058"].id = "COMP_058"
    item_registry["COMP_058"].name = "Life Support Recycler"
    item_registry["COMP_058"].category = ItemCategory.COMPONENT
    item_registry["COMP_058"].tier = 2
    item_registry["COMP_058"].base_price = 3600
    item_registry["COMP_058"].volume = 1.8
    item_registry["COMP_058"].mass = 18
    item_registry["COMP_058"].description = "Manufacturing component"

    # COMP_059 - Torpedo Tube Assembly
    item_registry["COMP_059"] = ItemData.new()
    item_registry["COMP_059"].id = "COMP_059"
    item_registry["COMP_059"].name = "Torpedo Tube Assembly"
    item_registry["COMP_059"].category = ItemCategory.COMPONENT
    item_registry["COMP_059"].tier = 3
    item_registry["COMP_059"].base_price = 12000
    item_registry["COMP_059"].volume = 3.5
    item_registry["COMP_059"].mass = 35
    item_registry["COMP_059"].description = "Manufacturing component"

    # COMP_060 - Shield Recharger Unit
    item_registry["COMP_060"] = ItemData.new()
    item_registry["COMP_060"].id = "COMP_060"
    item_registry["COMP_060"].name = "Shield Recharger Unit"
    item_registry["COMP_060"].category = ItemCategory.COMPONENT
    item_registry["COMP_060"].tier = 3
    item_registry["COMP_060"].base_price = 8500
    item_registry["COMP_060"].volume = 1.6
    item_registry["COMP_060"].mass = 16
    item_registry["COMP_060"].description = "Manufacturing component"

    # COMP_061 - Cargo Scanner Module
    item_registry["COMP_061"] = ItemData.new()
    item_registry["COMP_061"].id = "COMP_061"
    item_registry["COMP_061"].name = "Cargo Scanner Module"
    item_registry["COMP_061"].category = ItemCategory.COMPONENT
    item_registry["COMP_061"].tier = 2
    item_registry["COMP_061"].base_price = 2900
    item_registry["COMP_061"].volume = 0.4
    item_registry["COMP_061"].mass = 4
    item_registry["COMP_061"].description = "Manufacturing component"

    # COMP_062 - Missile Guidance Chip
    item_registry["COMP_062"] = ItemData.new()
    item_registry["COMP_062"].id = "COMP_062"
    item_registry["COMP_062"].name = "Missile Guidance Chip"
    item_registry["COMP_062"].category = ItemCategory.COMPONENT
    item_registry["COMP_062"].tier = 2
    item_registry["COMP_062"].base_price = 1800
    item_registry["COMP_062"].volume = 0.1
    item_registry["COMP_062"].mass = 1
    item_registry["COMP_062"].description = "Manufacturing component"

    # COMP_063 - Engine Coolant Pump
    item_registry["COMP_063"] = ItemData.new()
    item_registry["COMP_063"].id = "COMP_063"
    item_registry["COMP_063"].name = "Engine Coolant Pump"
    item_registry["COMP_063"].category = ItemCategory.COMPONENT
    item_registry["COMP_063"].tier = 2
    item_registry["COMP_063"].base_price = 2200
    item_registry["COMP_063"].volume = 1.4
    item_registry["COMP_063"].mass = 14
    item_registry["COMP_063"].description = "Manufacturing component"

    # COMP_064 - Point Defense Turret
    item_registry["COMP_064"] = ItemData.new()
    item_registry["COMP_064"].id = "COMP_064"
    item_registry["COMP_064"].name = "Point Defense Turret"
    item_registry["COMP_064"].category = ItemCategory.COMPONENT
    item_registry["COMP_064"].tier = 3
    item_registry["COMP_064"].base_price = 9500
    item_registry["COMP_064"].volume = 2.4
    item_registry["COMP_064"].mass = 24
    item_registry["COMP_064"].description = "Manufacturing component"

    # COMP_065 - Cargo Compressor Field
    item_registry["COMP_065"] = ItemData.new()
    item_registry["COMP_065"].id = "COMP_065"
    item_registry["COMP_065"].name = "Cargo Compressor Field"
    item_registry["COMP_065"].category = ItemCategory.COMPONENT
    item_registry["COMP_065"].tier = 3
    item_registry["COMP_065"].base_price = 7800
    item_registry["COMP_065"].volume = 1.3
    item_registry["COMP_065"].mass = 13
    item_registry["COMP_065"].description = "Manufacturing component"

    # COMP_066 - ECM Jammer Array
    item_registry["COMP_066"] = ItemData.new()
    item_registry["COMP_066"].id = "COMP_066"
    item_registry["COMP_066"].name = "ECM Jammer Array"
    item_registry["COMP_066"].category = ItemCategory.COMPONENT
    item_registry["COMP_066"].tier = 3
    item_registry["COMP_066"].base_price = 11000
    item_registry["COMP_066"].volume = 1.0
    item_registry["COMP_066"].mass = 10
    item_registry["COMP_066"].description = "Disrupts enemy targeting systems"

    # COMP_067 - Refinery Processing Unit
    item_registry["COMP_067"] = ItemData.new()
    item_registry["COMP_067"].id = "COMP_067"
    item_registry["COMP_067"].name = "Refinery Processing Unit"
    item_registry["COMP_067"].category = ItemCategory.COMPONENT
    item_registry["COMP_067"].tier = 3
    item_registry["COMP_067"].base_price = 14000
    item_registry["COMP_067"].volume = 6.0
    item_registry["COMP_067"].mass = 60
    item_registry["COMP_067"].description = "Manufacturing component"

    # COMP_068 - Factory Assembly Line
    item_registry["COMP_068"] = ItemData.new()
    item_registry["COMP_068"].id = "COMP_068"
    item_registry["COMP_068"].name = "Factory Assembly Line"
    item_registry["COMP_068"].category = ItemCategory.COMPONENT
    item_registry["COMP_068"].tier = 3
    item_registry["COMP_068"].base_price = 20000
    item_registry["COMP_068"].volume = 10.0
    item_registry["COMP_068"].mass = 100
    item_registry["COMP_068"].description = "Manufacturing component"

    # COMP_069 - Hangar Bay Module
    item_registry["COMP_069"] = ItemData.new()
    item_registry["COMP_069"].id = "COMP_069"
    item_registry["COMP_069"].name = "Hangar Bay Module"
    item_registry["COMP_069"].category = ItemCategory.COMPONENT
    item_registry["COMP_069"].tier = 3
    item_registry["COMP_069"].base_price = 25000
    item_registry["COMP_069"].volume = 15.0
    item_registry["COMP_069"].mass = 150
    item_registry["COMP_069"].description = "Manufacturing component"

    # COMP_070 - Command Bridge Core
    item_registry["COMP_070"] = ItemData.new()
    item_registry["COMP_070"].id = "COMP_070"
    item_registry["COMP_070"].name = "Command Bridge Core"
    item_registry["COMP_070"].category = ItemCategory.COMPONENT
    item_registry["COMP_070"].tier = 3
    item_registry["COMP_070"].base_price = 18000
    item_registry["COMP_070"].volume = 4.0
    item_registry["COMP_070"].mass = 40
    item_registry["COMP_070"].description = "Electronic warfare capabilities"

    # COMP_071 - Medical Bay Unit
    item_registry["COMP_071"] = ItemData.new()
    item_registry["COMP_071"].id = "COMP_071"
    item_registry["COMP_071"].name = "Medical Bay Unit"
    item_registry["COMP_071"].category = ItemCategory.COMPONENT
    item_registry["COMP_071"].tier = 2
    item_registry["COMP_071"].base_price = 12000
    item_registry["COMP_071"].volume = 4.5
    item_registry["COMP_071"].mass = 45
    item_registry["COMP_071"].description = "Manufacturing component"

    # COMP_072 - Science Lab Module
    item_registry["COMP_072"] = ItemData.new()
    item_registry["COMP_072"].id = "COMP_072"
    item_registry["COMP_072"].name = "Science Lab Module"
    item_registry["COMP_072"].category = ItemCategory.COMPONENT
    item_registry["COMP_072"].tier = 3
    item_registry["COMP_072"].base_price = 22000
    item_registry["COMP_072"].volume = 5.0
    item_registry["COMP_072"].mass = 50
    item_registry["COMP_072"].description = "Manufacturing component"

    # COMP_073 - Crew Quarters Section
    item_registry["COMP_073"] = ItemData.new()
    item_registry["COMP_073"].id = "COMP_073"
    item_registry["COMP_073"].name = "Crew Quarters Section"
    item_registry["COMP_073"].category = ItemCategory.COMPONENT
    item_registry["COMP_073"].tier = 2
    item_registry["COMP_073"].base_price = 8000
    item_registry["COMP_073"].volume = 5.5
    item_registry["COMP_073"].mass = 55
    item_registry["COMP_073"].description = "Manufacturing component"

    # COMP_074 - Fuel Storage Tank
    item_registry["COMP_074"] = ItemData.new()
    item_registry["COMP_074"].id = "COMP_074"
    item_registry["COMP_074"].name = "Fuel Storage Tank"
    item_registry["COMP_074"].category = ItemCategory.COMPONENT
    item_registry["COMP_074"].tier = 2
    item_registry["COMP_074"].base_price = 6000
    item_registry["COMP_074"].volume = 7.0
    item_registry["COMP_074"].mass = 70
    item_registry["COMP_074"].description = "Manufacturing component"

    # COMP_075 - Ammunition Magazine
    item_registry["COMP_075"] = ItemData.new()
    item_registry["COMP_075"].id = "COMP_075"
    item_registry["COMP_075"].name = "Ammunition Magazine"
    item_registry["COMP_075"].category = ItemCategory.COMPONENT
    item_registry["COMP_075"].tier = 2
    item_registry["COMP_075"].base_price = 7500
    item_registry["COMP_075"].volume = 5.0
    item_registry["COMP_075"].mass = 50
    item_registry["COMP_075"].description = "Manufacturing component"

    # COMP_076 - Drone Launch Bay
    item_registry["COMP_076"] = ItemData.new()
    item_registry["COMP_076"].id = "COMP_076"
    item_registry["COMP_076"].name = "Drone Launch Bay"
    item_registry["COMP_076"].category = ItemCategory.COMPONENT
    item_registry["COMP_076"].tier = 3
    item_registry["COMP_076"].base_price = 16000
    item_registry["COMP_076"].volume = 6.5
    item_registry["COMP_076"].mass = 65
    item_registry["COMP_076"].description = "Manufacturing component"

    # COMP_077 - Capital Shield Emitter
    item_registry["COMP_077"] = ItemData.new()
    item_registry["COMP_077"].id = "COMP_077"
    item_registry["COMP_077"].name = "Capital Shield Emitter"
    item_registry["COMP_077"].category = ItemCategory.COMPONENT
    item_registry["COMP_077"].tier = 4
    item_registry["COMP_077"].base_price = 45000
    item_registry["COMP_077"].volume = 9.0
    item_registry["COMP_077"].mass = 90
    item_registry["COMP_077"].description = "Manufacturing component"

    # COMP_078 - Siege Module
    item_registry["COMP_078"] = ItemData.new()
    item_registry["COMP_078"].id = "COMP_078"
    item_registry["COMP_078"].name = "Siege Module"
    item_registry["COMP_078"].category = ItemCategory.COMPONENT
    item_registry["COMP_078"].tier = 4
    item_registry["COMP_078"].base_price = 50000
    item_registry["COMP_078"].volume = 11.0
    item_registry["COMP_078"].mass = 110
    item_registry["COMP_078"].description = "Manufacturing component"

    # COMP_079 - Mining Platform Core
    item_registry["COMP_079"] = ItemData.new()
    item_registry["COMP_079"].id = "COMP_079"
    item_registry["COMP_079"].name = "Mining Platform Core"
    item_registry["COMP_079"].category = ItemCategory.COMPONENT
    item_registry["COMP_079"].tier = 3
    item_registry["COMP_079"].base_price = 28000
    item_registry["COMP_079"].volume = 9.5
    item_registry["COMP_079"].mass = 95
    item_registry["COMP_079"].description = "Manufacturing component"

    # COMP_080 - Trade Hub Terminal
    item_registry["COMP_080"] = ItemData.new()
    item_registry["COMP_080"].id = "COMP_080"
    item_registry["COMP_080"].name = "Trade Hub Terminal"
    item_registry["COMP_080"].category = ItemCategory.COMPONENT
    item_registry["COMP_080"].tier = 3
    item_registry["COMP_080"].base_price = 19000
    item_registry["COMP_080"].volume = 6.0
    item_registry["COMP_080"].mass = 60
    item_registry["COMP_080"].description = "Manufacturing component"

    # COMP_081 - Shipyard Assembly Rig
    item_registry["COMP_081"] = ItemData.new()
    item_registry["COMP_081"].id = "COMP_081"
    item_registry["COMP_081"].name = "Shipyard Assembly Rig"
    item_registry["COMP_081"].category = ItemCategory.COMPONENT
    item_registry["COMP_081"].tier = 4
    item_registry["COMP_081"].base_price = 80000
    item_registry["COMP_081"].volume = 20.0
    item_registry["COMP_081"].mass = 200
    item_registry["COMP_081"].description = "Manufacturing component"

    # COMP_082 - Starbase Core Module
    item_registry["COMP_082"] = ItemData.new()
    item_registry["COMP_082"].id = "COMP_082"
    item_registry["COMP_082"].name = "Starbase Core Module"
    item_registry["COMP_082"].category = ItemCategory.COMPONENT
    item_registry["COMP_082"].tier = 5
    item_registry["COMP_082"].base_price = 150000
    item_registry["COMP_082"].volume = 50.0
    item_registry["COMP_082"].mass = 500
    item_registry["COMP_082"].description = "Manufacturing component"

    # COMP_083 - Cyno Beacon Array
    item_registry["COMP_083"] = ItemData.new()
    item_registry["COMP_083"].id = "COMP_083"
    item_registry["COMP_083"].name = "Cyno Beacon Array"
    item_registry["COMP_083"].category = ItemCategory.COMPONENT
    item_registry["COMP_083"].tier = 4
    item_registry["COMP_083"].base_price = 23000
    item_registry["COMP_083"].volume = 1.5
    item_registry["COMP_083"].mass = 15
    item_registry["COMP_083"].description = "Manufacturing component"

    # COMP_084 - Clone Bay System
    item_registry["COMP_084"] = ItemData.new()
    item_registry["COMP_084"].id = "COMP_084"
    item_registry["COMP_084"].name = "Clone Bay System"
    item_registry["COMP_084"].category = ItemCategory.COMPONENT
    item_registry["COMP_084"].tier = 4
    item_registry["COMP_084"].base_price = 55000
    item_registry["COMP_084"].volume = 7.5
    item_registry["COMP_084"].mass = 75
    item_registry["COMP_084"].description = "Manufacturing component"

    # COMP_085 - Black Hole Generator
    item_registry["COMP_085"] = ItemData.new()
    item_registry["COMP_085"].id = "COMP_085"
    item_registry["COMP_085"].name = "Black Hole Generator"
    item_registry["COMP_085"].category = ItemCategory.COMPONENT
    item_registry["COMP_085"].tier = 5
    item_registry["COMP_085"].base_price = 200000
    item_registry["COMP_085"].volume = 15.0
    item_registry["COMP_085"].mass = 150
    item_registry["COMP_085"].description = "Manufacturing component"

    # COMP_086 - Titan Armor Plate
    item_registry["COMP_086"] = ItemData.new()
    item_registry["COMP_086"].id = "COMP_086"
    item_registry["COMP_086"].name = "Titan Armor Plate"
    item_registry["COMP_086"].category = ItemCategory.COMPONENT
    item_registry["COMP_086"].tier = 5
    item_registry["COMP_086"].base_price = 120000
    item_registry["COMP_086"].volume = 30.0
    item_registry["COMP_086"].mass = 300
    item_registry["COMP_086"].description = "Manufacturing component"

    # COMP_087 - Doomsday Device Core
    item_registry["COMP_087"] = ItemData.new()
    item_registry["COMP_087"].id = "COMP_087"
    item_registry["COMP_087"].name = "Doomsday Device Core"
    item_registry["COMP_087"].category = ItemCategory.COMPONENT
    item_registry["COMP_087"].tier = 5
    item_registry["COMP_087"].base_price = 250000
    item_registry["COMP_087"].volume = 18.0
    item_registry["COMP_087"].mass = 180
    item_registry["COMP_087"].description = "Manufacturing component"

    # COMP_088 - Phase Shift Module
    item_registry["COMP_088"] = ItemData.new()
    item_registry["COMP_088"].id = "COMP_088"
    item_registry["COMP_088"].name = "Phase Shift Module"
    item_registry["COMP_088"].category = ItemCategory.COMPONENT
    item_registry["COMP_088"].tier = 5
    item_registry["COMP_088"].base_price = 90000
    item_registry["COMP_088"].volume = 8.0
    item_registry["COMP_088"].mass = 80
    item_registry["COMP_088"].description = "Manufacturing component"

    # COMP_089 - AI Core Processor
    item_registry["COMP_089"] = ItemData.new()
    item_registry["COMP_089"].id = "COMP_089"
    item_registry["COMP_089"].name = "AI Core Processor"
    item_registry["COMP_089"].category = ItemCategory.COMPONENT
    item_registry["COMP_089"].tier = 4
    item_registry["COMP_089"].base_price = 70000
    item_registry["COMP_089"].volume = 1.0
    item_registry["COMP_089"].mass = 10
    item_registry["COMP_089"].description = "Electronic warfare capabilities"

    # COMP_090 - Resource Converter Matrix
    item_registry["COMP_090"] = ItemData.new()
    item_registry["COMP_090"].id = "COMP_090"
    item_registry["COMP_090"].name = "Resource Converter Matrix"
    item_registry["COMP_090"].category = ItemCategory.COMPONENT
    item_registry["COMP_090"].tier = 4
    item_registry["COMP_090"].base_price = 65000
    item_registry["COMP_090"].volume = 7.0
    item_registry["COMP_090"].mass = 70
    item_registry["COMP_090"].description = "Manufacturing component"

    # COMP_091 - Terraform Engine
    item_registry["COMP_091"] = ItemData.new()
    item_registry["COMP_091"].id = "COMP_091"
    item_registry["COMP_091"].name = "Terraform Engine"
    item_registry["COMP_091"].category = ItemCategory.COMPONENT
    item_registry["COMP_091"].tier = 5
    item_registry["COMP_091"].base_price = 180000
    item_registry["COMP_091"].volume = 25.0
    item_registry["COMP_091"].mass = 250
    item_registry["COMP_091"].description = "Manufacturing component"

    # COMP_092 - Dyson Collector Panel
    item_registry["COMP_092"] = ItemData.new()
    item_registry["COMP_092"].id = "COMP_092"
    item_registry["COMP_092"].name = "Dyson Collector Panel"
    item_registry["COMP_092"].category = ItemCategory.COMPONENT
    item_registry["COMP_092"].tier = 5
    item_registry["COMP_092"].base_price = 95000
    item_registry["COMP_092"].volume = 12.0
    item_registry["COMP_092"].mass = 120
    item_registry["COMP_092"].description = "Manufacturing component"

    # COMP_093 - Megastructure Frame
    item_registry["COMP_093"] = ItemData.new()
    item_registry["COMP_093"].id = "COMP_093"
    item_registry["COMP_093"].name = "Megastructure Frame"
    item_registry["COMP_093"].category = ItemCategory.COMPONENT
    item_registry["COMP_093"].tier = 5
    item_registry["COMP_093"].base_price = 300000
    item_registry["COMP_093"].volume = 100.0
    item_registry["COMP_093"].mass = 1000
    item_registry["COMP_093"].description = "Structural framework component"

    # COMP_094 - Wormhole Stabilizer
    item_registry["COMP_094"] = ItemData.new()
    item_registry["COMP_094"].id = "COMP_094"
    item_registry["COMP_094"].name = "Wormhole Stabilizer"
    item_registry["COMP_094"].category = ItemCategory.COMPONENT
    item_registry["COMP_094"].tier = 5
    item_registry["COMP_094"].base_price = 220000
    item_registry["COMP_094"].volume = 20.0
    item_registry["COMP_094"].mass = 200
    item_registry["COMP_094"].description = "Manufacturing component"

    # COMP_095 - Matter-Energy Converter
    item_registry["COMP_095"] = ItemData.new()
    item_registry["COMP_095"].id = "COMP_095"
    item_registry["COMP_095"].name = "Matter-Energy Converter"
    item_registry["COMP_095"].category = ItemCategory.COMPONENT
    item_registry["COMP_095"].tier = 5
    item_registry["COMP_095"].base_price = 110000
    item_registry["COMP_095"].volume = 8.5
    item_registry["COMP_095"].mass = 85
    item_registry["COMP_095"].description = "Manufacturing component"

    # COMP_096 - Quantum Computer Core
    item_registry["COMP_096"] = ItemData.new()
    item_registry["COMP_096"].id = "COMP_096"
    item_registry["COMP_096"].name = "Quantum Computer Core"
    item_registry["COMP_096"].category = ItemCategory.COMPONENT
    item_registry["COMP_096"].tier = 5
    item_registry["COMP_096"].base_price = 100000
    item_registry["COMP_096"].volume = 1.2
    item_registry["COMP_096"].mass = 12
    item_registry["COMP_096"].description = "Electronic warfare capabilities"

    # COMP_097 - Universal Translator AI
    item_registry["COMP_097"] = ItemData.new()
    item_registry["COMP_097"].id = "COMP_097"
    item_registry["COMP_097"].name = "Universal Translator AI"
    item_registry["COMP_097"].category = ItemCategory.COMPONENT
    item_registry["COMP_097"].tier = 3
    item_registry["COMP_097"].base_price = 15000
    item_registry["COMP_097"].volume = 0.3
    item_registry["COMP_097"].mass = 3
    item_registry["COMP_097"].description = "Manufacturing component"

    # COMP_098 - Weather Control Array
    item_registry["COMP_098"] = ItemData.new()
    item_registry["COMP_098"].id = "COMP_098"
    item_registry["COMP_098"].name = "Weather Control Array"
    item_registry["COMP_098"].category = ItemCategory.COMPONENT
    item_registry["COMP_098"].tier = 4
    item_registry["COMP_098"].base_price = 85000
    item_registry["COMP_098"].volume = 9.5
    item_registry["COMP_098"].mass = 95
    item_registry["COMP_098"].description = "Manufacturing component"

    # COMP_099 - Time Dilation Field
    item_registry["COMP_099"] = ItemData.new()
    item_registry["COMP_099"].id = "COMP_099"
    item_registry["COMP_099"].name = "Time Dilation Field"
    item_registry["COMP_099"].category = ItemCategory.COMPONENT
    item_registry["COMP_099"].tier = 5
    item_registry["COMP_099"].base_price = 280000
    item_registry["COMP_099"].volume = 16.0
    item_registry["COMP_099"].mass = 160
    item_registry["COMP_099"].description = "Manufacturing component"

    # COMP_100 - Reality Anchor
    item_registry["COMP_100"] = ItemData.new()
    item_registry["COMP_100"].id = "COMP_100"
    item_registry["COMP_100"].name = "Reality Anchor"
    item_registry["COMP_100"].category = ItemCategory.COMPONENT
    item_registry["COMP_100"].tier = 5
    item_registry["COMP_100"].base_price = 150000
    item_registry["COMP_100"].volume = 9.0
    item_registry["COMP_100"].mass = 90
    item_registry["COMP_100"].description = "Manufacturing component"

    # WEP_001 - Light Autocannon
    item_registry["WEP_001"] = ItemData.new()
    item_registry["WEP_001"].id = "WEP_001"
    item_registry["WEP_001"].name = "Light Autocannon"
    item_registry["WEP_001"].category = ItemCategory.WEAPON
    item_registry["WEP_001"].tier = 1
    item_registry["WEP_001"].base_price = 3000
    item_registry["WEP_001"].volume = 2.0
    item_registry["WEP_001"].mass = 200
    item_registry["WEP_001"].description = "Rapid-fire kinetic projectile weapon"

    # WEP_002 - Medium Autocannon
    item_registry["WEP_002"] = ItemData.new()
    item_registry["WEP_002"].id = "WEP_002"
    item_registry["WEP_002"].name = "Medium Autocannon"
    item_registry["WEP_002"].category = ItemCategory.WEAPON
    item_registry["WEP_002"].tier = 2
    item_registry["WEP_002"].base_price = 8000
    item_registry["WEP_002"].volume = 5.0
    item_registry["WEP_002"].mass = 500
    item_registry["WEP_002"].description = "Rapid-fire kinetic projectile weapon"

    # WEP_003 - Heavy Autocannon
    item_registry["WEP_003"] = ItemData.new()
    item_registry["WEP_003"].id = "WEP_003"
    item_registry["WEP_003"].name = "Heavy Autocannon"
    item_registry["WEP_003"].category = ItemCategory.WEAPON
    item_registry["WEP_003"].tier = 3
    item_registry["WEP_003"].base_price = 20000
    item_registry["WEP_003"].volume = 12.0
    item_registry["WEP_003"].mass = 1200
    item_registry["WEP_003"].description = "Rapid-fire kinetic projectile weapon"

    # WEP_004 - Gatling Cannon
    item_registry["WEP_004"] = ItemData.new()
    item_registry["WEP_004"].id = "WEP_004"
    item_registry["WEP_004"].name = "Gatling Cannon"
    item_registry["WEP_004"].category = ItemCategory.WEAPON
    item_registry["WEP_004"].tier = 2
    item_registry["WEP_004"].base_price = 12000
    item_registry["WEP_004"].volume = 6.0
    item_registry["WEP_004"].mass = 600
    item_registry["WEP_004"].description = "Ship weapon system"

    # WEP_005 - Burst Cannon
    item_registry["WEP_005"] = ItemData.new()
    item_registry["WEP_005"].id = "WEP_005"
    item_registry["WEP_005"].name = "Burst Cannon"
    item_registry["WEP_005"].category = ItemCategory.WEAPON
    item_registry["WEP_005"].tier = 2
    item_registry["WEP_005"].base_price = 6500
    item_registry["WEP_005"].volume = 3.5
    item_registry["WEP_005"].mass = 350
    item_registry["WEP_005"].description = "Ship weapon system"

    # WEP_006 - Light Railgun
    item_registry["WEP_006"] = ItemData.new()
    item_registry["WEP_006"].id = "WEP_006"
    item_registry["WEP_006"].name = "Light Railgun"
    item_registry["WEP_006"].category = ItemCategory.WEAPON
    item_registry["WEP_006"].tier = 2
    item_registry["WEP_006"].base_price = 15000
    item_registry["WEP_006"].volume = 8.0
    item_registry["WEP_006"].mass = 800
    item_registry["WEP_006"].description = "Long-range kinetic projectile weapon"

    # WEP_007 - Medium Railgun
    item_registry["WEP_007"] = ItemData.new()
    item_registry["WEP_007"].id = "WEP_007"
    item_registry["WEP_007"].name = "Medium Railgun"
    item_registry["WEP_007"].category = ItemCategory.WEAPON
    item_registry["WEP_007"].tier = 3
    item_registry["WEP_007"].base_price = 35000
    item_registry["WEP_007"].volume = 18.0
    item_registry["WEP_007"].mass = 1800
    item_registry["WEP_007"].description = "Long-range kinetic projectile weapon"

    # WEP_008 - Heavy Railgun
    item_registry["WEP_008"] = ItemData.new()
    item_registry["WEP_008"].id = "WEP_008"
    item_registry["WEP_008"].name = "Heavy Railgun"
    item_registry["WEP_008"].category = ItemCategory.WEAPON
    item_registry["WEP_008"].tier = 4
    item_registry["WEP_008"].base_price = 80000
    item_registry["WEP_008"].volume = 40.0
    item_registry["WEP_008"].mass = 4000
    item_registry["WEP_008"].description = "Long-range kinetic projectile weapon"

    # WEP_009 - Coilgun Battery
    item_registry["WEP_009"] = ItemData.new()
    item_registry["WEP_009"].id = "WEP_009"
    item_registry["WEP_009"].name = "Coilgun Battery"
    item_registry["WEP_009"].category = ItemCategory.WEAPON
    item_registry["WEP_009"].tier = 3
    item_registry["WEP_009"].base_price = 40000
    item_registry["WEP_009"].volume = 20.0
    item_registry["WEP_009"].mass = 2000
    item_registry["WEP_009"].description = "Ship weapon system"

    # WEP_010 - Mass Driver Turret
    item_registry["WEP_010"] = ItemData.new()
    item_registry["WEP_010"].id = "WEP_010"
    item_registry["WEP_010"].name = "Mass Driver Turret"
    item_registry["WEP_010"].category = ItemCategory.WEAPON
    item_registry["WEP_010"].tier = 3
    item_registry["WEP_010"].base_price = 45000
    item_registry["WEP_010"].volume = 25.0
    item_registry["WEP_010"].mass = 2500
    item_registry["WEP_010"].description = "Ship weapon system"

    # WEP_011 - Flak Cannon
    item_registry["WEP_011"] = ItemData.new()
    item_registry["WEP_011"].id = "WEP_011"
    item_registry["WEP_011"].name = "Flak Cannon"
    item_registry["WEP_011"].category = ItemCategory.WEAPON
    item_registry["WEP_011"].tier = 2
    item_registry["WEP_011"].base_price = 11000
    item_registry["WEP_011"].volume = 7.0
    item_registry["WEP_011"].mass = 700
    item_registry["WEP_011"].description = "Ship weapon system"

    # WEP_012 - Scatter Gun
    item_registry["WEP_012"] = ItemData.new()
    item_registry["WEP_012"].id = "WEP_012"
    item_registry["WEP_012"].name = "Scatter Gun"
    item_registry["WEP_012"].category = ItemCategory.WEAPON
    item_registry["WEP_012"].tier = 1
    item_registry["WEP_012"].base_price = 4500
    item_registry["WEP_012"].volume = 2.8
    item_registry["WEP_012"].mass = 280
    item_registry["WEP_012"].description = "Ship weapon system"

    # WEP_013 - Sniper Cannon
    item_registry["WEP_013"] = ItemData.new()
    item_registry["WEP_013"].id = "WEP_013"
    item_registry["WEP_013"].name = "Sniper Cannon"
    item_registry["WEP_013"].category = ItemCategory.WEAPON
    item_registry["WEP_013"].tier = 3
    item_registry["WEP_013"].base_price = 32000
    item_registry["WEP_013"].volume = 15.0
    item_registry["WEP_013"].mass = 1500
    item_registry["WEP_013"].description = "Ship weapon system"

    # WEP_014 - Artillery Cannon
    item_registry["WEP_014"] = ItemData.new()
    item_registry["WEP_014"].id = "WEP_014"
    item_registry["WEP_014"].name = "Artillery Cannon"
    item_registry["WEP_014"].category = ItemCategory.WEAPON
    item_registry["WEP_014"].tier = 4
    item_registry["WEP_014"].base_price = 90000
    item_registry["WEP_014"].volume = 45.0
    item_registry["WEP_014"].mass = 4500
    item_registry["WEP_014"].description = "Long-range kinetic projectile weapon"

    # WEP_015 - Assault Cannon
    item_registry["WEP_015"] = ItemData.new()
    item_registry["WEP_015"].id = "WEP_015"
    item_registry["WEP_015"].name = "Assault Cannon"
    item_registry["WEP_015"].category = ItemCategory.WEAPON
    item_registry["WEP_015"].tier = 2
    item_registry["WEP_015"].base_price = 10000
    item_registry["WEP_015"].volume = 6.5
    item_registry["WEP_015"].mass = 650
    item_registry["WEP_015"].description = "Ship weapon system"

    # WEP_016 - Tactical Railgun
    item_registry["WEP_016"] = ItemData.new()
    item_registry["WEP_016"].id = "WEP_016"
    item_registry["WEP_016"].name = "Tactical Railgun"
    item_registry["WEP_016"].category = ItemCategory.WEAPON
    item_registry["WEP_016"].tier = 3
    item_registry["WEP_016"].base_price = 28000
    item_registry["WEP_016"].volume = 14.0
    item_registry["WEP_016"].mass = 1400
    item_registry["WEP_016"].description = "Long-range kinetic projectile weapon"

    # WEP_017 - Siege Autocannon
    item_registry["WEP_017"] = ItemData.new()
    item_registry["WEP_017"].id = "WEP_017"
    item_registry["WEP_017"].name = "Siege Autocannon"
    item_registry["WEP_017"].category = ItemCategory.WEAPON
    item_registry["WEP_017"].tier = 4
    item_registry["WEP_017"].base_price = 75000
    item_registry["WEP_017"].volume = 38.0
    item_registry["WEP_017"].mass = 3800
    item_registry["WEP_017"].description = "Rapid-fire kinetic projectile weapon"

    # WEP_018 - Rotary Cannon
    item_registry["WEP_018"] = ItemData.new()
    item_registry["WEP_018"].id = "WEP_018"
    item_registry["WEP_018"].name = "Rotary Cannon"
    item_registry["WEP_018"].category = ItemCategory.WEAPON
    item_registry["WEP_018"].tier = 3
    item_registry["WEP_018"].base_price = 42000
    item_registry["WEP_018"].volume = 22.0
    item_registry["WEP_018"].mass = 2200
    item_registry["WEP_018"].description = "Ship weapon system"

    # WEP_019 - Proximity Cannon
    item_registry["WEP_019"] = ItemData.new()
    item_registry["WEP_019"].id = "WEP_019"
    item_registry["WEP_019"].name = "Proximity Cannon"
    item_registry["WEP_019"].category = ItemCategory.WEAPON
    item_registry["WEP_019"].tier = 3
    item_registry["WEP_019"].base_price = 33000
    item_registry["WEP_019"].volume = 16.0
    item_registry["WEP_019"].mass = 1600
    item_registry["WEP_019"].description = "Ship weapon system"

    # WEP_020 - Gauss Rifle
    item_registry["WEP_020"] = ItemData.new()
    item_registry["WEP_020"].id = "WEP_020"
    item_registry["WEP_020"].name = "Gauss Rifle"
    item_registry["WEP_020"].category = ItemCategory.WEAPON
    item_registry["WEP_020"].tier = 2
    item_registry["WEP_020"].base_price = 9000
    item_registry["WEP_020"].volume = 4.5
    item_registry["WEP_020"].mass = 450
    item_registry["WEP_020"].description = "Ship weapon system"

    # WEP_021 - Light Missile Launcher
    item_registry["WEP_021"] = ItemData.new()
    item_registry["WEP_021"].id = "WEP_021"
    item_registry["WEP_021"].name = "Light Missile Launcher"
    item_registry["WEP_021"].category = ItemCategory.WEAPON
    item_registry["WEP_021"].tier = 1
    item_registry["WEP_021"].base_price = 4000
    item_registry["WEP_021"].volume = 2.5
    item_registry["WEP_021"].mass = 250
    item_registry["WEP_021"].description = "Guided explosive projectile weapon"

    # WEP_022 - Medium Missile Launcher
    item_registry["WEP_022"] = ItemData.new()
    item_registry["WEP_022"].id = "WEP_022"
    item_registry["WEP_022"].name = "Medium Missile Launcher"
    item_registry["WEP_022"].category = ItemCategory.WEAPON
    item_registry["WEP_022"].tier = 2
    item_registry["WEP_022"].base_price = 10000
    item_registry["WEP_022"].volume = 6.0
    item_registry["WEP_022"].mass = 600
    item_registry["WEP_022"].description = "Guided explosive projectile weapon"

    # WEP_023 - Heavy Missile Launcher
    item_registry["WEP_023"] = ItemData.new()
    item_registry["WEP_023"].id = "WEP_023"
    item_registry["WEP_023"].name = "Heavy Missile Launcher"
    item_registry["WEP_023"].category = ItemCategory.WEAPON
    item_registry["WEP_023"].tier = 3
    item_registry["WEP_023"].base_price = 25000
    item_registry["WEP_023"].volume = 14.0
    item_registry["WEP_023"].mass = 1400
    item_registry["WEP_023"].description = "Guided explosive projectile weapon"

    # WEP_024 - Torpedo Launcher
    item_registry["WEP_024"] = ItemData.new()
    item_registry["WEP_024"].id = "WEP_024"
    item_registry["WEP_024"].name = "Torpedo Launcher"
    item_registry["WEP_024"].category = ItemCategory.WEAPON
    item_registry["WEP_024"].tier = 3
    item_registry["WEP_024"].base_price = 35000
    item_registry["WEP_024"].volume = 18.0
    item_registry["WEP_024"].mass = 1800
    item_registry["WEP_024"].description = "Guided explosive projectile weapon"

    # WEP_025 - Cruise Missile Battery
    item_registry["WEP_025"] = ItemData.new()
    item_registry["WEP_025"].id = "WEP_025"
    item_registry["WEP_025"].name = "Cruise Missile Battery"
    item_registry["WEP_025"].category = ItemCategory.WEAPON
    item_registry["WEP_025"].tier = 4
    item_registry["WEP_025"].base_price = 70000
    item_registry["WEP_025"].volume = 35.0
    item_registry["WEP_025"].mass = 3500
    item_registry["WEP_025"].description = "Guided explosive projectile weapon"

    # WEP_026 - Swarm Launcher
    item_registry["WEP_026"] = ItemData.new()
    item_registry["WEP_026"].id = "WEP_026"
    item_registry["WEP_026"].name = "Swarm Launcher"
    item_registry["WEP_026"].category = ItemCategory.WEAPON
    item_registry["WEP_026"].tier = 2
    item_registry["WEP_026"].base_price = 13000
    item_registry["WEP_026"].volume = 7.0
    item_registry["WEP_026"].mass = 700
    item_registry["WEP_026"].description = "Ship weapon system"

    # WEP_027 - Rocket Pod
    item_registry["WEP_027"] = ItemData.new()
    item_registry["WEP_027"].id = "WEP_027"
    item_registry["WEP_027"].name = "Rocket Pod"
    item_registry["WEP_027"].category = ItemCategory.WEAPON
    item_registry["WEP_027"].tier = 1
    item_registry["WEP_027"].base_price = 5000
    item_registry["WEP_027"].volume = 3.0
    item_registry["WEP_027"].mass = 300
    item_registry["WEP_027"].description = "Ship weapon system"

    # WEP_028 - Smart Missile System
    item_registry["WEP_028"] = ItemData.new()
    item_registry["WEP_028"].id = "WEP_028"
    item_registry["WEP_028"].name = "Smart Missile System"
    item_registry["WEP_028"].category = ItemCategory.WEAPON
    item_registry["WEP_028"].tier = 3
    item_registry["WEP_028"].base_price = 32000
    item_registry["WEP_028"].volume = 16.0
    item_registry["WEP_028"].mass = 1600
    item_registry["WEP_028"].description = "Guided explosive projectile weapon"

    # WEP_029 - Stealth Torpedo
    item_registry["WEP_029"] = ItemData.new()
    item_registry["WEP_029"].id = "WEP_029"
    item_registry["WEP_029"].name = "Stealth Torpedo"
    item_registry["WEP_029"].category = ItemCategory.WEAPON
    item_registry["WEP_029"].tier = 4
    item_registry["WEP_029"].base_price = 50000
    item_registry["WEP_029"].volume = 22.0
    item_registry["WEP_029"].mass = 2200
    item_registry["WEP_029"].description = "Guided explosive projectile weapon"

    # WEP_030 - Micro Missile Array
    item_registry["WEP_030"] = ItemData.new()
    item_registry["WEP_030"].id = "WEP_030"
    item_registry["WEP_030"].name = "Micro Missile Array"
    item_registry["WEP_030"].category = ItemCategory.WEAPON
    item_registry["WEP_030"].tier = 2
    item_registry["WEP_030"].base_price = 8500
    item_registry["WEP_030"].volume = 4.0
    item_registry["WEP_030"].mass = 400
    item_registry["WEP_030"].description = "Guided explosive projectile weapon"

    # WEP_031 - Cluster Launcher
    item_registry["WEP_031"] = ItemData.new()
    item_registry["WEP_031"].id = "WEP_031"
    item_registry["WEP_031"].name = "Cluster Launcher"
    item_registry["WEP_031"].category = ItemCategory.WEAPON
    item_registry["WEP_031"].tier = 3
    item_registry["WEP_031"].base_price = 38000
    item_registry["WEP_031"].volume = 19.0
    item_registry["WEP_031"].mass = 1900
    item_registry["WEP_031"].description = "Ship weapon system"

    # WEP_032 - EMP Missile System
    item_registry["WEP_032"] = ItemData.new()
    item_registry["WEP_032"].id = "WEP_032"
    item_registry["WEP_032"].name = "EMP Missile System"
    item_registry["WEP_032"].category = ItemCategory.WEAPON
    item_registry["WEP_032"].tier = 3
    item_registry["WEP_032"].base_price = 30000
    item_registry["WEP_032"].volume = 15.0
    item_registry["WEP_032"].mass = 1500
    item_registry["WEP_032"].description = "Guided explosive projectile weapon"

    # WEP_033 - Plasma Warhead Launcher
    item_registry["WEP_033"] = ItemData.new()
    item_registry["WEP_033"].id = "WEP_033"
    item_registry["WEP_033"].name = "Plasma Warhead Launcher"
    item_registry["WEP_033"].category = ItemCategory.WEAPON
    item_registry["WEP_033"].tier = 4
    item_registry["WEP_033"].base_price = 55000
    item_registry["WEP_033"].volume = 24.0
    item_registry["WEP_033"].mass = 2400
    item_registry["WEP_033"].description = "Ship weapon system"

    # WEP_034 - Nuclear Torpedo
    item_registry["WEP_034"] = ItemData.new()
    item_registry["WEP_034"].id = "WEP_034"
    item_registry["WEP_034"].name = "Nuclear Torpedo"
    item_registry["WEP_034"].category = ItemCategory.WEAPON
    item_registry["WEP_034"].tier = 5
    item_registry["WEP_034"].base_price = 150000
    item_registry["WEP_034"].volume = 50.0
    item_registry["WEP_034"].mass = 5000
    item_registry["WEP_034"].description = "Guided explosive projectile weapon"

    # WEP_035 - Homing Rocket Cluster
    item_registry["WEP_035"] = ItemData.new()
    item_registry["WEP_035"].id = "WEP_035"
    item_registry["WEP_035"].name = "Homing Rocket Cluster"
    item_registry["WEP_035"].category = ItemCategory.WEAPON
    item_registry["WEP_035"].tier = 2
    item_registry["WEP_035"].base_price = 14000
    item_registry["WEP_035"].volume = 7.5
    item_registry["WEP_035"].mass = 750
    item_registry["WEP_035"].description = "Ship weapon system"

    # WEP_036 - Long Range Missile
    item_registry["WEP_036"] = ItemData.new()
    item_registry["WEP_036"].id = "WEP_036"
    item_registry["WEP_036"].name = "Long Range Missile"
    item_registry["WEP_036"].category = ItemCategory.WEAPON
    item_registry["WEP_036"].tier = 3
    item_registry["WEP_036"].base_price = 42000
    item_registry["WEP_036"].volume = 20.0
    item_registry["WEP_036"].mass = 2000
    item_registry["WEP_036"].description = "Guided explosive projectile weapon"

    # WEP_037 - Siege Torpedo Bay
    item_registry["WEP_037"] = ItemData.new()
    item_registry["WEP_037"].id = "WEP_037"
    item_registry["WEP_037"].name = "Siege Torpedo Bay"
    item_registry["WEP_037"].category = ItemCategory.WEAPON
    item_registry["WEP_037"].tier = 4
    item_registry["WEP_037"].base_price = 85000
    item_registry["WEP_037"].volume = 42.0
    item_registry["WEP_037"].mass = 4200
    item_registry["WEP_037"].description = "Guided explosive projectile weapon"

    # WEP_038 - Interceptor Launcher
    item_registry["WEP_038"] = ItemData.new()
    item_registry["WEP_038"].id = "WEP_038"
    item_registry["WEP_038"].name = "Interceptor Launcher"
    item_registry["WEP_038"].category = ItemCategory.WEAPON
    item_registry["WEP_038"].tier = 2
    item_registry["WEP_038"].base_price = 9500
    item_registry["WEP_038"].volume = 5.0
    item_registry["WEP_038"].mass = 500
    item_registry["WEP_038"].description = "Ship weapon system"

    # WEP_039 - Guided Bomb Rack
    item_registry["WEP_039"] = ItemData.new()
    item_registry["WEP_039"].id = "WEP_039"
    item_registry["WEP_039"].name = "Guided Bomb Rack"
    item_registry["WEP_039"].category = ItemCategory.WEAPON
    item_registry["WEP_039"].tier = 3
    item_registry["WEP_039"].base_price = 27000
    item_registry["WEP_039"].volume = 13.0
    item_registry["WEP_039"].mass = 1300
    item_registry["WEP_039"].description = "Ship weapon system"

    # WEP_040 - Antimatter Torpedo
    item_registry["WEP_040"] = ItemData.new()
    item_registry["WEP_040"].id = "WEP_040"
    item_registry["WEP_040"].name = "Antimatter Torpedo"
    item_registry["WEP_040"].category = ItemCategory.WEAPON
    item_registry["WEP_040"].tier = 5
    item_registry["WEP_040"].base_price = 200000
    item_registry["WEP_040"].volume = 55.0
    item_registry["WEP_040"].mass = 5500
    item_registry["WEP_040"].description = "Guided explosive projectile weapon"

    # WEP_041 - Pulse Laser
    item_registry["WEP_041"] = ItemData.new()
    item_registry["WEP_041"].id = "WEP_041"
    item_registry["WEP_041"].name = "Pulse Laser"
    item_registry["WEP_041"].category = ItemCategory.WEAPON
    item_registry["WEP_041"].tier = 1
    item_registry["WEP_041"].base_price = 3500
    item_registry["WEP_041"].volume = 1.5
    item_registry["WEP_041"].mass = 150
    item_registry["WEP_041"].description = "Energy weapon with focused beam damage"

    # WEP_042 - Beam Laser
    item_registry["WEP_042"] = ItemData.new()
    item_registry["WEP_042"].id = "WEP_042"
    item_registry["WEP_042"].name = "Beam Laser"
    item_registry["WEP_042"].category = ItemCategory.WEAPON
    item_registry["WEP_042"].tier = 2
    item_registry["WEP_042"].base_price = 9000
    item_registry["WEP_042"].volume = 4.0
    item_registry["WEP_042"].mass = 400
    item_registry["WEP_042"].description = "Energy weapon with focused beam damage"

    # WEP_043 - Heavy Laser Turret
    item_registry["WEP_043"] = ItemData.new()
    item_registry["WEP_043"].id = "WEP_043"
    item_registry["WEP_043"].name = "Heavy Laser Turret"
    item_registry["WEP_043"].category = ItemCategory.WEAPON
    item_registry["WEP_043"].tier = 3
    item_registry["WEP_043"].base_price = 22000
    item_registry["WEP_043"].volume = 10.0
    item_registry["WEP_043"].mass = 1000
    item_registry["WEP_043"].description = "Energy weapon with focused beam damage"

    # WEP_044 - Pulse Laser Battery
    item_registry["WEP_044"] = ItemData.new()
    item_registry["WEP_044"].id = "WEP_044"
    item_registry["WEP_044"].name = "Pulse Laser Battery"
    item_registry["WEP_044"].category = ItemCategory.WEAPON
    item_registry["WEP_044"].tier = 2
    item_registry["WEP_044"].base_price = 11000
    item_registry["WEP_044"].volume = 5.0
    item_registry["WEP_044"].mass = 500
    item_registry["WEP_044"].description = "Energy weapon with focused beam damage"

    # WEP_045 - Mining Laser
    item_registry["WEP_045"] = ItemData.new()
    item_registry["WEP_045"].id = "WEP_045"
    item_registry["WEP_045"].name = "Mining Laser"
    item_registry["WEP_045"].category = ItemCategory.WEAPON
    item_registry["WEP_045"].tier = 1
    item_registry["WEP_045"].base_price = 2500
    item_registry["WEP_045"].volume = 2.0
    item_registry["WEP_045"].mass = 200
    item_registry["WEP_045"].description = "Energy weapon with focused beam damage"

    # WEP_046 - Tactical Laser
    item_registry["WEP_046"] = ItemData.new()
    item_registry["WEP_046"].id = "WEP_046"
    item_registry["WEP_046"].name = "Tactical Laser"
    item_registry["WEP_046"].category = ItemCategory.WEAPON
    item_registry["WEP_046"].tier = 2
    item_registry["WEP_046"].base_price = 12000
    item_registry["WEP_046"].volume = 6.0
    item_registry["WEP_046"].mass = 600
    item_registry["WEP_046"].description = "Energy weapon with focused beam damage"

    # WEP_047 - Scatter Laser
    item_registry["WEP_047"] = ItemData.new()
    item_registry["WEP_047"].id = "WEP_047"
    item_registry["WEP_047"].name = "Scatter Laser"
    item_registry["WEP_047"].category = ItemCategory.WEAPON
    item_registry["WEP_047"].tier = 2
    item_registry["WEP_047"].base_price = 7500
    item_registry["WEP_047"].volume = 3.5
    item_registry["WEP_047"].mass = 350
    item_registry["WEP_047"].description = "Energy weapon with focused beam damage"

    # WEP_048 - Focus Laser Cannon
    item_registry["WEP_048"] = ItemData.new()
    item_registry["WEP_048"].id = "WEP_048"
    item_registry["WEP_048"].name = "Focus Laser Cannon"
    item_registry["WEP_048"].category = ItemCategory.WEAPON
    item_registry["WEP_048"].tier = 3
    item_registry["WEP_048"].base_price = 28000
    item_registry["WEP_048"].volume = 13.0
    item_registry["WEP_048"].mass = 1300
    item_registry["WEP_048"].description = "Energy weapon with focused beam damage"

    # WEP_049 - Particle Beam Projector
    item_registry["WEP_049"] = ItemData.new()
    item_registry["WEP_049"].id = "WEP_049"
    item_registry["WEP_049"].name = "Particle Beam Projector"
    item_registry["WEP_049"].category = ItemCategory.WEAPON
    item_registry["WEP_049"].tier = 3
    item_registry["WEP_049"].base_price = 32000
    item_registry["WEP_049"].volume = 15.0
    item_registry["WEP_049"].mass = 1500
    item_registry["WEP_049"].description = "Energy weapon with focused beam damage"

    # WEP_050 - Plasma Cannon
    item_registry["WEP_050"] = ItemData.new()
    item_registry["WEP_050"].id = "WEP_050"
    item_registry["WEP_050"].name = "Plasma Cannon"
    item_registry["WEP_050"].category = ItemCategory.WEAPON
    item_registry["WEP_050"].tier = 3
    item_registry["WEP_050"].base_price = 26000
    item_registry["WEP_050"].volume = 12.0
    item_registry["WEP_050"].mass = 1200
    item_registry["WEP_050"].description = "Ship weapon system"

    # WEP_051 - Heavy Plasma Turret
    item_registry["WEP_051"] = ItemData.new()
    item_registry["WEP_051"].id = "WEP_051"
    item_registry["WEP_051"].name = "Heavy Plasma Turret"
    item_registry["WEP_051"].category = ItemCategory.WEAPON
    item_registry["WEP_051"].tier = 4
    item_registry["WEP_051"].base_price = 55000
    item_registry["WEP_051"].volume = 25.0
    item_registry["WEP_051"].mass = 2500
    item_registry["WEP_051"].description = "Ship weapon system"

    # WEP_052 - Ion Cannon
    item_registry["WEP_052"] = ItemData.new()
    item_registry["WEP_052"].id = "WEP_052"
    item_registry["WEP_052"].name = "Ion Cannon"
    item_registry["WEP_052"].category = ItemCategory.WEAPON
    item_registry["WEP_052"].tier = 3
    item_registry["WEP_052"].base_price = 24000
    item_registry["WEP_052"].volume = 11.0
    item_registry["WEP_052"].mass = 1100
    item_registry["WEP_052"].description = "Ship weapon system"

    # WEP_053 - Disintegrator Ray
    item_registry["WEP_053"] = ItemData.new()
    item_registry["WEP_053"].id = "WEP_053"
    item_registry["WEP_053"].name = "Disintegrator Ray"
    item_registry["WEP_053"].category = ItemCategory.WEAPON
    item_registry["WEP_053"].tier = 4
    item_registry["WEP_053"].base_price = 65000
    item_registry["WEP_053"].volume = 28.0
    item_registry["WEP_053"].mass = 2800
    item_registry["WEP_053"].description = "Ship weapon system"

    # WEP_054 - Thermal Lance
    item_registry["WEP_054"] = ItemData.new()
    item_registry["WEP_054"].id = "WEP_054"
    item_registry["WEP_054"].name = "Thermal Lance"
    item_registry["WEP_054"].category = ItemCategory.WEAPON
    item_registry["WEP_054"].tier = 2
    item_registry["WEP_054"].base_price = 10500
    item_registry["WEP_054"].volume = 5.5
    item_registry["WEP_054"].mass = 550
    item_registry["WEP_054"].description = "Ship weapon system"

    # WEP_055 - Cutting Beam
    item_registry["WEP_055"] = ItemData.new()
    item_registry["WEP_055"].id = "WEP_055"
    item_registry["WEP_055"].name = "Cutting Beam"
    item_registry["WEP_055"].category = ItemCategory.WEAPON
    item_registry["WEP_055"].tier = 2
    item_registry["WEP_055"].base_price = 13500
    item_registry["WEP_055"].volume = 7.0
    item_registry["WEP_055"].mass = 700
    item_registry["WEP_055"].description = "Energy weapon with focused beam damage"

    # WEP_056 - Photonic Disruptor
    item_registry["WEP_056"] = ItemData.new()
    item_registry["WEP_056"].id = "WEP_056"
    item_registry["WEP_056"].name = "Photonic Disruptor"
    item_registry["WEP_056"].category = ItemCategory.WEAPON
    item_registry["WEP_056"].tier = 4
    item_registry["WEP_056"].base_price = 50000
    item_registry["WEP_056"].volume = 22.0
    item_registry["WEP_056"].mass = 2200
    item_registry["WEP_056"].description = "Ship weapon system"

    # WEP_057 - Gamma Ray Emitter
    item_registry["WEP_057"] = ItemData.new()
    item_registry["WEP_057"].id = "WEP_057"
    item_registry["WEP_057"].name = "Gamma Ray Emitter"
    item_registry["WEP_057"].category = ItemCategory.WEAPON
    item_registry["WEP_057"].tier = 4
    item_registry["WEP_057"].base_price = 58000
    item_registry["WEP_057"].volume = 26.0
    item_registry["WEP_057"].mass = 2600
    item_registry["WEP_057"].description = "Ship weapon system"

    # WEP_058 - Maser Cannon
    item_registry["WEP_058"] = ItemData.new()
    item_registry["WEP_058"].id = "WEP_058"
    item_registry["WEP_058"].name = "Maser Cannon"
    item_registry["WEP_058"].category = ItemCategory.WEAPON
    item_registry["WEP_058"].tier = 3
    item_registry["WEP_058"].base_price = 30000
    item_registry["WEP_058"].volume = 14.0
    item_registry["WEP_058"].mass = 1400
    item_registry["WEP_058"].description = "Ship weapon system"

    # WEP_059 - X-Ray Laser
    item_registry["WEP_059"] = ItemData.new()
    item_registry["WEP_059"].id = "WEP_059"
    item_registry["WEP_059"].name = "X-Ray Laser"
    item_registry["WEP_059"].category = ItemCategory.WEAPON
    item_registry["WEP_059"].tier = 4
    item_registry["WEP_059"].base_price = 52000
    item_registry["WEP_059"].volume = 24.0
    item_registry["WEP_059"].mass = 2400
    item_registry["WEP_059"].description = "Energy weapon with focused beam damage"

    # WEP_060 - Antimatter Beam
    item_registry["WEP_060"] = ItemData.new()
    item_registry["WEP_060"].id = "WEP_060"
    item_registry["WEP_060"].name = "Antimatter Beam"
    item_registry["WEP_060"].category = ItemCategory.WEAPON
    item_registry["WEP_060"].tier = 5
    item_registry["WEP_060"].base_price = 180000
    item_registry["WEP_060"].volume = 50.0
    item_registry["WEP_060"].mass = 5000
    item_registry["WEP_060"].description = "Energy weapon with focused beam damage"

    # WEP_061 - Light Blaster
    item_registry["WEP_061"] = ItemData.new()
    item_registry["WEP_061"].id = "WEP_061"
    item_registry["WEP_061"].name = "Light Blaster"
    item_registry["WEP_061"].category = ItemCategory.WEAPON
    item_registry["WEP_061"].tier = 1
    item_registry["WEP_061"].base_price = 4200
    item_registry["WEP_061"].volume = 2.2
    item_registry["WEP_061"].mass = 220
    item_registry["WEP_061"].description = "Short-range rapid-fire energy weapon"

    # WEP_062 - Medium Blaster
    item_registry["WEP_062"] = ItemData.new()
    item_registry["WEP_062"].id = "WEP_062"
    item_registry["WEP_062"].name = "Medium Blaster"
    item_registry["WEP_062"].category = ItemCategory.WEAPON
    item_registry["WEP_062"].tier = 2
    item_registry["WEP_062"].base_price = 10500
    item_registry["WEP_062"].volume = 5.5
    item_registry["WEP_062"].mass = 550
    item_registry["WEP_062"].description = "Short-range rapid-fire energy weapon"

    # WEP_063 - Heavy Blaster
    item_registry["WEP_063"] = ItemData.new()
    item_registry["WEP_063"].id = "WEP_063"
    item_registry["WEP_063"].name = "Heavy Blaster"
    item_registry["WEP_063"].category = ItemCategory.WEAPON
    item_registry["WEP_063"].tier = 3
    item_registry["WEP_063"].base_price = 26000
    item_registry["WEP_063"].volume = 13.0
    item_registry["WEP_063"].mass = 1300
    item_registry["WEP_063"].description = "Short-range rapid-fire energy weapon"

    # WEP_064 - Ion Blaster
    item_registry["WEP_064"] = ItemData.new()
    item_registry["WEP_064"].id = "WEP_064"
    item_registry["WEP_064"].name = "Ion Blaster"
    item_registry["WEP_064"].category = ItemCategory.WEAPON
    item_registry["WEP_064"].tier = 2
    item_registry["WEP_064"].base_price = 12000
    item_registry["WEP_064"].volume = 6.5
    item_registry["WEP_064"].mass = 650
    item_registry["WEP_064"].description = "Short-range rapid-fire energy weapon"

    # WEP_065 - Neutron Blaster
    item_registry["WEP_065"] = ItemData.new()
    item_registry["WEP_065"].id = "WEP_065"
    item_registry["WEP_065"].name = "Neutron Blaster"
    item_registry["WEP_065"].category = ItemCategory.WEAPON
    item_registry["WEP_065"].tier = 3
    item_registry["WEP_065"].base_price = 32000
    item_registry["WEP_065"].volume = 15.0
    item_registry["WEP_065"].mass = 1500
    item_registry["WEP_065"].description = "Short-range rapid-fire energy weapon"

    # WEP_066 - Electron Blaster
    item_registry["WEP_066"] = ItemData.new()
    item_registry["WEP_066"].id = "WEP_066"
    item_registry["WEP_066"].name = "Electron Blaster"
    item_registry["WEP_066"].category = ItemCategory.WEAPON
    item_registry["WEP_066"].tier = 2
    item_registry["WEP_066"].base_price = 9000
    item_registry["WEP_066"].volume = 4.8
    item_registry["WEP_066"].mass = 480
    item_registry["WEP_066"].description = "Short-range rapid-fire energy weapon"

    # WEP_067 - Photon Blaster
    item_registry["WEP_067"] = ItemData.new()
    item_registry["WEP_067"].id = "WEP_067"
    item_registry["WEP_067"].name = "Photon Blaster"
    item_registry["WEP_067"].category = ItemCategory.WEAPON
    item_registry["WEP_067"].tier = 3
    item_registry["WEP_067"].base_price = 25000
    item_registry["WEP_067"].volume = 12.0
    item_registry["WEP_067"].mass = 1200
    item_registry["WEP_067"].description = "Short-range rapid-fire energy weapon"

    # WEP_068 - Railblaster
    item_registry["WEP_068"] = ItemData.new()
    item_registry["WEP_068"].id = "WEP_068"
    item_registry["WEP_068"].name = "Railblaster"
    item_registry["WEP_068"].category = ItemCategory.WEAPON
    item_registry["WEP_068"].tier = 3
    item_registry["WEP_068"].base_price = 38000
    item_registry["WEP_068"].volume = 18.0
    item_registry["WEP_068"].mass = 1800
    item_registry["WEP_068"].description = "Ship weapon system"

    # WEP_069 - Vortex Cannon
    item_registry["WEP_069"] = ItemData.new()
    item_registry["WEP_069"].id = "WEP_069"
    item_registry["WEP_069"].name = "Vortex Cannon"
    item_registry["WEP_069"].category = ItemCategory.WEAPON
    item_registry["WEP_069"].tier = 4
    item_registry["WEP_069"].base_price = 52000
    item_registry["WEP_069"].volume = 24.0
    item_registry["WEP_069"].mass = 2400
    item_registry["WEP_069"].description = "Ship weapon system"

    # WEP_070 - Fusion Blaster
    item_registry["WEP_070"] = ItemData.new()
    item_registry["WEP_070"].id = "WEP_070"
    item_registry["WEP_070"].name = "Fusion Blaster"
    item_registry["WEP_070"].category = ItemCategory.WEAPON
    item_registry["WEP_070"].tier = 4
    item_registry["WEP_070"].base_price = 48000
    item_registry["WEP_070"].volume = 22.0
    item_registry["WEP_070"].mass = 2200
    item_registry["WEP_070"].description = "Short-range rapid-fire energy weapon"

    # WEP_071 - Antimatter Blaster
    item_registry["WEP_071"] = ItemData.new()
    item_registry["WEP_071"].id = "WEP_071"
    item_registry["WEP_071"].name = "Antimatter Blaster"
    item_registry["WEP_071"].category = ItemCategory.WEAPON
    item_registry["WEP_071"].tier = 5
    item_registry["WEP_071"].base_price = 160000
    item_registry["WEP_071"].volume = 48.0
    item_registry["WEP_071"].mass = 4800
    item_registry["WEP_071"].description = "Short-range rapid-fire energy weapon"

    # WEP_072 - Quantum Blaster
    item_registry["WEP_072"] = ItemData.new()
    item_registry["WEP_072"].id = "WEP_072"
    item_registry["WEP_072"].name = "Quantum Blaster"
    item_registry["WEP_072"].category = ItemCategory.WEAPON
    item_registry["WEP_072"].tier = 5
    item_registry["WEP_072"].base_price = 85000
    item_registry["WEP_072"].volume = 30.0
    item_registry["WEP_072"].mass = 3000
    item_registry["WEP_072"].description = "Short-range rapid-fire energy weapon"

    # WEP_073 - Singularity Cannon
    item_registry["WEP_073"] = ItemData.new()
    item_registry["WEP_073"].id = "WEP_073"
    item_registry["WEP_073"].name = "Singularity Cannon"
    item_registry["WEP_073"].category = ItemCategory.WEAPON
    item_registry["WEP_073"].tier = 5
    item_registry["WEP_073"].base_price = 200000
    item_registry["WEP_073"].volume = 52.0
    item_registry["WEP_073"].mass = 5200
    item_registry["WEP_073"].description = "Ship weapon system"

    # WEP_074 - Phase Blaster
    item_registry["WEP_074"] = ItemData.new()
    item_registry["WEP_074"].id = "WEP_074"
    item_registry["WEP_074"].name = "Phase Blaster"
    item_registry["WEP_074"].category = ItemCategory.WEAPON
    item_registry["WEP_074"].tier = 4
    item_registry["WEP_074"].base_price = 42000
    item_registry["WEP_074"].volume = 19.0
    item_registry["WEP_074"].mass = 1900
    item_registry["WEP_074"].description = "Short-range rapid-fire energy weapon"

    # WEP_075 - Chrono Blaster
    item_registry["WEP_075"] = ItemData.new()
    item_registry["WEP_075"].id = "WEP_075"
    item_registry["WEP_075"].name = "Chrono Blaster"
    item_registry["WEP_075"].category = ItemCategory.WEAPON
    item_registry["WEP_075"].tier = 5
    item_registry["WEP_075"].base_price = 95000
    item_registry["WEP_075"].volume = 32.0
    item_registry["WEP_075"].mass = 3200
    item_registry["WEP_075"].description = "Short-range rapid-fire energy weapon"

    # WEP_076 - Flux Cannon
    item_registry["WEP_076"] = ItemData.new()
    item_registry["WEP_076"].id = "WEP_076"
    item_registry["WEP_076"].name = "Flux Cannon"
    item_registry["WEP_076"].category = ItemCategory.WEAPON
    item_registry["WEP_076"].tier = 3
    item_registry["WEP_076"].base_price = 29000
    item_registry["WEP_076"].volume = 14.0
    item_registry["WEP_076"].mass = 1400
    item_registry["WEP_076"].description = "Ship weapon system"

    # WEP_077 - Void Blaster
    item_registry["WEP_077"] = ItemData.new()
    item_registry["WEP_077"].id = "WEP_077"
    item_registry["WEP_077"].name = "Void Blaster"
    item_registry["WEP_077"].category = ItemCategory.WEAPON
    item_registry["WEP_077"].tier = 5
    item_registry["WEP_077"].base_price = 88000
    item_registry["WEP_077"].volume = 29.0
    item_registry["WEP_077"].mass = 2900
    item_registry["WEP_077"].description = "Short-range rapid-fire energy weapon"

    # WEP_078 - Converter Blaster
    item_registry["WEP_078"] = ItemData.new()
    item_registry["WEP_078"].id = "WEP_078"
    item_registry["WEP_078"].name = "Converter Blaster"
    item_registry["WEP_078"].category = ItemCategory.WEAPON
    item_registry["WEP_078"].tier = 4
    item_registry["WEP_078"].base_price = 50000
    item_registry["WEP_078"].volume = 23.0
    item_registry["WEP_078"].mass = 2300
    item_registry["WEP_078"].description = "Short-range rapid-fire energy weapon"

    # WEP_079 - Nanite Blaster
    item_registry["WEP_079"] = ItemData.new()
    item_registry["WEP_079"].id = "WEP_079"
    item_registry["WEP_079"].name = "Nanite Blaster"
    item_registry["WEP_079"].category = ItemCategory.WEAPON
    item_registry["WEP_079"].tier = 4
    item_registry["WEP_079"].base_price = 38000
    item_registry["WEP_079"].volume = 17.0
    item_registry["WEP_079"].mass = 1700
    item_registry["WEP_079"].description = "Short-range rapid-fire energy weapon"

    # WEP_080 - Reality Disruptor
    item_registry["WEP_080"] = ItemData.new()
    item_registry["WEP_080"].id = "WEP_080"
    item_registry["WEP_080"].name = "Reality Disruptor"
    item_registry["WEP_080"].category = ItemCategory.WEAPON
    item_registry["WEP_080"].tier = 5
    item_registry["WEP_080"].base_price = 220000
    item_registry["WEP_080"].volume = 55.0
    item_registry["WEP_080"].mass = 5500
    item_registry["WEP_080"].description = "Ship weapon system"

    # WEP_081 - Gravity Well Generator
    item_registry["WEP_081"] = ItemData.new()
    item_registry["WEP_081"].id = "WEP_081"
    item_registry["WEP_081"].name = "Gravity Well Generator"
    item_registry["WEP_081"].category = ItemCategory.WEAPON
    item_registry["WEP_081"].tier = 4
    item_registry["WEP_081"].base_price = 45000
    item_registry["WEP_081"].volume = 20.0
    item_registry["WEP_081"].mass = 2000
    item_registry["WEP_081"].description = "Ship weapon system"

    # WEP_082 - Tractor Beam
    item_registry["WEP_082"] = ItemData.new()
    item_registry["WEP_082"].id = "WEP_082"
    item_registry["WEP_082"].name = "Tractor Beam"
    item_registry["WEP_082"].category = ItemCategory.WEAPON
    item_registry["WEP_082"].tier = 2
    item_registry["WEP_082"].base_price = 15000
    item_registry["WEP_082"].volume = 8.0
    item_registry["WEP_082"].mass = 800
    item_registry["WEP_082"].description = "Energy weapon with focused beam damage"

    # WEP_083 - Repulsor Beam
    item_registry["WEP_083"] = ItemData.new()
    item_registry["WEP_083"].id = "WEP_083"
    item_registry["WEP_083"].name = "Repulsor Beam"
    item_registry["WEP_083"].category = ItemCategory.WEAPON
    item_registry["WEP_083"].tier = 2
    item_registry["WEP_083"].base_price = 14000
    item_registry["WEP_083"].volume = 7.5
    item_registry["WEP_083"].mass = 750
    item_registry["WEP_083"].description = "Energy weapon with focused beam damage"

    # WEP_084 - Stasis Field
    item_registry["WEP_084"] = ItemData.new()
    item_registry["WEP_084"].id = "WEP_084"
    item_registry["WEP_084"].name = "Stasis Field"
    item_registry["WEP_084"].category = ItemCategory.WEAPON
    item_registry["WEP_084"].tier = 4
    item_registry["WEP_084"].base_price = 52000
    item_registry["WEP_084"].volume = 23.0
    item_registry["WEP_084"].mass = 2300
    item_registry["WEP_084"].description = "Ship weapon system"

    # WEP_085 - Singularity Projector
    item_registry["WEP_085"] = ItemData.new()
    item_registry["WEP_085"].id = "WEP_085"
    item_registry["WEP_085"].name = "Singularity Projector"
    item_registry["WEP_085"].category = ItemCategory.WEAPON
    item_registry["WEP_085"].tier = 5
    item_registry["WEP_085"].base_price = 150000
    item_registry["WEP_085"].volume = 45.0
    item_registry["WEP_085"].mass = 4500
    item_registry["WEP_085"].description = "Ship weapon system"

    # WEP_086 - Temporal Displacer
    item_registry["WEP_086"] = ItemData.new()
    item_registry["WEP_086"].id = "WEP_086"
    item_registry["WEP_086"].name = "Temporal Displacer"
    item_registry["WEP_086"].category = ItemCategory.WEAPON
    item_registry["WEP_086"].tier = 5
    item_registry["WEP_086"].base_price = 120000
    item_registry["WEP_086"].volume = 35.0
    item_registry["WEP_086"].mass = 3500
    item_registry["WEP_086"].description = "Ship weapon system"

    # WEP_087 - Dimensional Rift Cannon
    item_registry["WEP_087"] = ItemData.new()
    item_registry["WEP_087"].id = "WEP_087"
    item_registry["WEP_087"].name = "Dimensional Rift Cannon"
    item_registry["WEP_087"].category = ItemCategory.WEAPON
    item_registry["WEP_087"].tier = 5
    item_registry["WEP_087"].base_price = 180000
    item_registry["WEP_087"].volume = 50.0
    item_registry["WEP_087"].mass = 5000
    item_registry["WEP_087"].description = "Ship weapon system"

    # WEP_088 - Void Projector
    item_registry["WEP_088"] = ItemData.new()
    item_registry["WEP_088"].id = "WEP_088"
    item_registry["WEP_088"].name = "Void Projector"
    item_registry["WEP_088"].category = ItemCategory.WEAPON
    item_registry["WEP_088"].tier = 5
    item_registry["WEP_088"].base_price = 100000
    item_registry["WEP_088"].volume = 32.0
    item_registry["WEP_088"].mass = 3200
    item_registry["WEP_088"].description = "Ship weapon system"

    # WEP_089 - Reality Anchor Beam
    item_registry["WEP_089"] = ItemData.new()
    item_registry["WEP_089"].id = "WEP_089"
    item_registry["WEP_089"].name = "Reality Anchor Beam"
    item_registry["WEP_089"].category = ItemCategory.WEAPON
    item_registry["WEP_089"].tier = 4
    item_registry["WEP_089"].base_price = 40000
    item_registry["WEP_089"].volume = 18.0
    item_registry["WEP_089"].mass = 1800
    item_registry["WEP_089"].description = "Energy weapon with focused beam damage"

    # WEP_090 - Chrono Bomb Launcher
    item_registry["WEP_090"] = ItemData.new()
    item_registry["WEP_090"].id = "WEP_090"
    item_registry["WEP_090"].name = "Chrono Bomb Launcher"
    item_registry["WEP_090"].category = ItemCategory.WEAPON
    item_registry["WEP_090"].tier = 5
    item_registry["WEP_090"].base_price = 130000
    item_registry["WEP_090"].volume = 38.0
    item_registry["WEP_090"].mass = 3800
    item_registry["WEP_090"].description = "Ship weapon system"

    # WEP_091 - Phase Disruptor
    item_registry["WEP_091"] = ItemData.new()
    item_registry["WEP_091"].id = "WEP_091"
    item_registry["WEP_091"].name = "Phase Disruptor"
    item_registry["WEP_091"].category = ItemCategory.WEAPON
    item_registry["WEP_091"].tier = 4
    item_registry["WEP_091"].base_price = 55000
    item_registry["WEP_091"].volume = 24.0
    item_registry["WEP_091"].mass = 2400
    item_registry["WEP_091"].description = "Ship weapon system"

    # WEP_092 - Warp Scrambler
    item_registry["WEP_092"] = ItemData.new()
    item_registry["WEP_092"].id = "WEP_092"
    item_registry["WEP_092"].name = "Warp Scrambler"
    item_registry["WEP_092"].category = ItemCategory.WEAPON
    item_registry["WEP_092"].tier = 3
    item_registry["WEP_092"].base_price = 32000
    item_registry["WEP_092"].volume = 15.0
    item_registry["WEP_092"].mass = 1500
    item_registry["WEP_092"].description = "Ship weapon system"

    # WEP_093 - Quantum Entangler
    item_registry["WEP_093"] = ItemData.new()
    item_registry["WEP_093"].id = "WEP_093"
    item_registry["WEP_093"].name = "Quantum Entangler"
    item_registry["WEP_093"].category = ItemCategory.WEAPON
    item_registry["WEP_093"].tier = 4
    item_registry["WEP_093"].base_price = 43000
    item_registry["WEP_093"].volume = 19.0
    item_registry["WEP_093"].mass = 1900
    item_registry["WEP_093"].description = "Ship weapon system"

    # WEP_094 - Entropy Cannon
    item_registry["WEP_094"] = ItemData.new()
    item_registry["WEP_094"].id = "WEP_094"
    item_registry["WEP_094"].name = "Entropy Cannon"
    item_registry["WEP_094"].category = ItemCategory.WEAPON
    item_registry["WEP_094"].tier = 5
    item_registry["WEP_094"].base_price = 110000
    item_registry["WEP_094"].volume = 34.0
    item_registry["WEP_094"].mass = 3400
    item_registry["WEP_094"].description = "Ship weapon system"

    # WEP_095 - Probability Disruptor
    item_registry["WEP_095"] = ItemData.new()
    item_registry["WEP_095"].id = "WEP_095"
    item_registry["WEP_095"].name = "Probability Disruptor"
    item_registry["WEP_095"].category = ItemCategory.WEAPON
    item_registry["WEP_095"].tier = 5
    item_registry["WEP_095"].base_price = 95000
    item_registry["WEP_095"].volume = 31.0
    item_registry["WEP_095"].mass = 3100
    item_registry["WEP_095"].description = "Ship weapon system"

    # WEP_096 - Dark Matter Projector
    item_registry["WEP_096"] = ItemData.new()
    item_registry["WEP_096"].id = "WEP_096"
    item_registry["WEP_096"].name = "Dark Matter Projector"
    item_registry["WEP_096"].category = ItemCategory.WEAPON
    item_registry["WEP_096"].tier = 5
    item_registry["WEP_096"].base_price = 170000
    item_registry["WEP_096"].volume = 48.0
    item_registry["WEP_096"].mass = 4800
    item_registry["WEP_096"].description = "Ship weapon system"

    # WEP_097 - Wormhole Generator
    item_registry["WEP_097"] = ItemData.new()
    item_registry["WEP_097"].id = "WEP_097"
    item_registry["WEP_097"].name = "Wormhole Generator"
    item_registry["WEP_097"].category = ItemCategory.WEAPON
    item_registry["WEP_097"].tier = 5
    item_registry["WEP_097"].base_price = 125000
    item_registry["WEP_097"].volume = 36.0
    item_registry["WEP_097"].mass = 3600
    item_registry["WEP_097"].description = "Ship weapon system"

    # WEP_098 - Subspace Disruptor
    item_registry["WEP_098"] = ItemData.new()
    item_registry["WEP_098"].id = "WEP_098"
    item_registry["WEP_098"].name = "Subspace Disruptor"
    item_registry["WEP_098"].category = ItemCategory.WEAPON
    item_registry["WEP_098"].tier = 4
    item_registry["WEP_098"].base_price = 46000
    item_registry["WEP_098"].volume = 20.0
    item_registry["WEP_098"].mass = 2000
    item_registry["WEP_098"].description = "Ship weapon system"

    # WEP_099 - Graviton Pulse
    item_registry["WEP_099"] = ItemData.new()
    item_registry["WEP_099"].id = "WEP_099"
    item_registry["WEP_099"].name = "Graviton Pulse"
    item_registry["WEP_099"].category = ItemCategory.WEAPON
    item_registry["WEP_099"].tier = 4
    item_registry["WEP_099"].base_price = 58000
    item_registry["WEP_099"].volume = 25.0
    item_registry["WEP_099"].mass = 2500
    item_registry["WEP_099"].description = "Short-range rapid-fire energy weapon"

    # WEP_100 - Matter Disassembler
    item_registry["WEP_100"] = ItemData.new()
    item_registry["WEP_100"].id = "WEP_100"
    item_registry["WEP_100"].name = "Matter Disassembler"
    item_registry["WEP_100"].category = ItemCategory.WEAPON
    item_registry["WEP_100"].tier = 5
    item_registry["WEP_100"].base_price = 190000
    item_registry["WEP_100"].volume = 53.0
    item_registry["WEP_100"].mass = 5300
    item_registry["WEP_100"].description = "Ship weapon system"

    # WEP_101 - Asteroid Drill
    item_registry["WEP_101"] = ItemData.new()
    item_registry["WEP_101"].id = "WEP_101"
    item_registry["WEP_101"].name = "Asteroid Drill"
    item_registry["WEP_101"].category = ItemCategory.WEAPON
    item_registry["WEP_101"].tier = 1
    item_registry["WEP_101"].base_price = 2000
    item_registry["WEP_101"].volume = 1.8
    item_registry["WEP_101"].mass = 180
    item_registry["WEP_101"].description = "Deep penetration ore extraction"

    # WEP_102 - Deep Core Drill
    item_registry["WEP_102"] = ItemData.new()
    item_registry["WEP_102"].id = "WEP_102"
    item_registry["WEP_102"].name = "Deep Core Drill"
    item_registry["WEP_102"].category = ItemCategory.WEAPON
    item_registry["WEP_102"].tier = 2
    item_registry["WEP_102"].base_price = 6000
    item_registry["WEP_102"].volume = 4.5
    item_registry["WEP_102"].mass = 450
    item_registry["WEP_102"].description = "Deep penetration ore extraction"

    # WEP_103 - Plasma Cutter
    item_registry["WEP_103"] = ItemData.new()
    item_registry["WEP_103"].id = "WEP_103"
    item_registry["WEP_103"].name = "Plasma Cutter"
    item_registry["WEP_103"].category = ItemCategory.WEAPON
    item_registry["WEP_103"].tier = 2
    item_registry["WEP_103"].base_price = 7500
    item_registry["WEP_103"].volume = 5.0
    item_registry["WEP_103"].mass = 500
    item_registry["WEP_103"].description = "Enhances mining operations"

    # WEP_104 - Sonic Resonator
    item_registry["WEP_104"] = ItemData.new()
    item_registry["WEP_104"].id = "WEP_104"
    item_registry["WEP_104"].name = "Sonic Resonator"
    item_registry["WEP_104"].category = ItemCategory.WEAPON
    item_registry["WEP_104"].tier = 2
    item_registry["WEP_104"].base_price = 9000
    item_registry["WEP_104"].volume = 6.0
    item_registry["WEP_104"].mass = 600
    item_registry["WEP_104"].description = "Enhances mining operations"

    # WEP_105 - Thermal Fracture Beam
    item_registry["WEP_105"] = ItemData.new()
    item_registry["WEP_105"].id = "WEP_105"
    item_registry["WEP_105"].name = "Thermal Fracture Beam"
    item_registry["WEP_105"].category = ItemCategory.WEAPON
    item_registry["WEP_105"].tier = 3
    item_registry["WEP_105"].base_price = 15000
    item_registry["WEP_105"].volume = 10.0
    item_registry["WEP_105"].mass = 1000
    item_registry["WEP_105"].description = "Enhances mining operations"

    # WEP_106 - Magnetic Extractor
    item_registry["WEP_106"] = ItemData.new()
    item_registry["WEP_106"].id = "WEP_106"
    item_registry["WEP_106"].name = "Magnetic Extractor"
    item_registry["WEP_106"].category = ItemCategory.WEAPON
    item_registry["WEP_106"].tier = 3
    item_registry["WEP_106"].base_price = 17000
    item_registry["WEP_106"].volume = 11.0
    item_registry["WEP_106"].mass = 1100
    item_registry["WEP_106"].description = "Enhances mining operations"

    # WEP_107 - Ice Melter
    item_registry["WEP_107"] = ItemData.new()
    item_registry["WEP_107"].id = "WEP_107"
    item_registry["WEP_107"].name = "Ice Melter"
    item_registry["WEP_107"].category = ItemCategory.WEAPON
    item_registry["WEP_107"].tier = 2
    item_registry["WEP_107"].base_price = 5500
    item_registry["WEP_107"].volume = 4.0
    item_registry["WEP_107"].mass = 400
    item_registry["WEP_107"].description = "Enhances mining operations"

    # WEP_108 - Gas Ionizer
    item_registry["WEP_108"] = ItemData.new()
    item_registry["WEP_108"].id = "WEP_108"
    item_registry["WEP_108"].name = "Gas Ionizer"
    item_registry["WEP_108"].category = ItemCategory.WEAPON
    item_registry["WEP_108"].tier = 2
    item_registry["WEP_108"].base_price = 10000
    item_registry["WEP_108"].volume = 7.0
    item_registry["WEP_108"].mass = 700
    item_registry["WEP_108"].description = "Enhances mining operations"

    # WEP_109 - Quantum Excavator
    item_registry["WEP_109"] = ItemData.new()
    item_registry["WEP_109"].id = "WEP_109"
    item_registry["WEP_109"].name = "Quantum Excavator"
    item_registry["WEP_109"].category = ItemCategory.WEAPON
    item_registry["WEP_109"].tier = 4
    item_registry["WEP_109"].base_price = 40000
    item_registry["WEP_109"].volume = 20.0
    item_registry["WEP_109"].mass = 2000
    item_registry["WEP_109"].description = "Enhances mining operations"

    # WEP_110 - Void Extractor
    item_registry["WEP_110"] = ItemData.new()
    item_registry["WEP_110"].id = "WEP_110"
    item_registry["WEP_110"].name = "Void Extractor"
    item_registry["WEP_110"].category = ItemCategory.WEAPON
    item_registry["WEP_110"].tier = 5
    item_registry["WEP_110"].base_price = 80000
    item_registry["WEP_110"].volume = 30.0
    item_registry["WEP_110"].mass = 3000
    item_registry["WEP_110"].description = "Enhances mining operations"

    # WEP_111 - Nanite Disassembler
    item_registry["WEP_111"] = ItemData.new()
    item_registry["WEP_111"].id = "WEP_111"
    item_registry["WEP_111"].name = "Nanite Disassembler"
    item_registry["WEP_111"].category = ItemCategory.WEAPON
    item_registry["WEP_111"].tier = 4
    item_registry["WEP_111"].base_price = 35000
    item_registry["WEP_111"].volume = 18.0
    item_registry["WEP_111"].mass = 1800
    item_registry["WEP_111"].description = "Enhances mining operations"

    # WEP_112 - Refinery Beam
    item_registry["WEP_112"] = ItemData.new()
    item_registry["WEP_112"].id = "WEP_112"
    item_registry["WEP_112"].name = "Refinery Beam"
    item_registry["WEP_112"].category = ItemCategory.WEAPON
    item_registry["WEP_112"].tier = 3
    item_registry["WEP_112"].base_price = 22000
    item_registry["WEP_112"].volume = 13.0
    item_registry["WEP_112"].mass = 1300
    item_registry["WEP_112"].description = "Enhances mining operations"

    # WEP_113 - Compression Drill
    item_registry["WEP_113"] = ItemData.new()
    item_registry["WEP_113"].id = "WEP_113"
    item_registry["WEP_113"].name = "Compression Drill"
    item_registry["WEP_113"].category = ItemCategory.WEAPON
    item_registry["WEP_113"].tier = 3
    item_registry["WEP_113"].base_price = 20000
    item_registry["WEP_113"].volume = 12.0
    item_registry["WEP_113"].mass = 1200
    item_registry["WEP_113"].description = "Deep penetration ore extraction"

    # WEP_114 - Smart Mining Array
    item_registry["WEP_114"] = ItemData.new()
    item_registry["WEP_114"].id = "WEP_114"
    item_registry["WEP_114"].name = "Smart Mining Array"
    item_registry["WEP_114"].category = ItemCategory.WEAPON
    item_registry["WEP_114"].tier = 4
    item_registry["WEP_114"].base_price = 45000
    item_registry["WEP_114"].volume = 22.0
    item_registry["WEP_114"].mass = 2200
    item_registry["WEP_114"].description = "Enhances mining operations"

    # WEP_115 - Stellar Harvester
    item_registry["WEP_115"] = ItemData.new()
    item_registry["WEP_115"].id = "WEP_115"
    item_registry["WEP_115"].name = "Stellar Harvester"
    item_registry["WEP_115"].category = ItemCategory.WEAPON
    item_registry["WEP_115"].tier = 5
    item_registry["WEP_115"].base_price = 100000
    item_registry["WEP_115"].volume = 40.0
    item_registry["WEP_115"].mass = 4000
    item_registry["WEP_115"].description = "Enhances mining operations"

    # WEP_116 - Asteroid Shredder
    item_registry["WEP_116"] = ItemData.new()
    item_registry["WEP_116"].id = "WEP_116"
    item_registry["WEP_116"].name = "Asteroid Shredder"
    item_registry["WEP_116"].category = ItemCategory.WEAPON
    item_registry["WEP_116"].tier = 3
    item_registry["WEP_116"].base_price = 28000
    item_registry["WEP_116"].volume = 16.0
    item_registry["WEP_116"].mass = 1600
    item_registry["WEP_116"].description = "Enhances mining operations"

    # WEP_117 - Gravity Scoop
    item_registry["WEP_117"] = ItemData.new()
    item_registry["WEP_117"].id = "WEP_117"
    item_registry["WEP_117"].name = "Gravity Scoop"
    item_registry["WEP_117"].category = ItemCategory.WEAPON
    item_registry["WEP_117"].tier = 4
    item_registry["WEP_117"].base_price = 42000
    item_registry["WEP_117"].volume = 21.0
    item_registry["WEP_117"].mass = 2100
    item_registry["WEP_117"].description = "Enhances mining operations"

    # WEP_118 - Rift Miner
    item_registry["WEP_118"] = ItemData.new()
    item_registry["WEP_118"].id = "WEP_118"
    item_registry["WEP_118"].name = "Rift Miner"
    item_registry["WEP_118"].category = ItemCategory.WEAPON
    item_registry["WEP_118"].tier = 5
    item_registry["WEP_118"].base_price = 75000
    item_registry["WEP_118"].volume = 32.0
    item_registry["WEP_118"].mass = 3200
    item_registry["WEP_118"].description = "Enhances mining operations"

    # WEP_119 - Planet Drill
    item_registry["WEP_119"] = ItemData.new()
    item_registry["WEP_119"].id = "WEP_119"
    item_registry["WEP_119"].name = "Planet Drill"
    item_registry["WEP_119"].category = ItemCategory.WEAPON
    item_registry["WEP_119"].tier = 5
    item_registry["WEP_119"].base_price = 120000
    item_registry["WEP_119"].volume = 50.0
    item_registry["WEP_119"].mass = 5000
    item_registry["WEP_119"].description = "Deep penetration ore extraction"

    # WEP_120 - Core Tap
    item_registry["WEP_120"] = ItemData.new()
    item_registry["WEP_120"].id = "WEP_120"
    item_registry["WEP_120"].name = "Core Tap"
    item_registry["WEP_120"].category = ItemCategory.WEAPON
    item_registry["WEP_120"].tier = 5
    item_registry["WEP_120"].base_price = 110000
    item_registry["WEP_120"].volume = 45.0
    item_registry["WEP_120"].mass = 4500
    item_registry["WEP_120"].description = "Enhances mining operations"

    # WEP_121 - ECM Jammer
    item_registry["WEP_121"] = ItemData.new()
    item_registry["WEP_121"].id = "WEP_121"
    item_registry["WEP_121"].name = "ECM Jammer"
    item_registry["WEP_121"].category = ItemCategory.WEAPON
    item_registry["WEP_121"].tier = 2
    item_registry["WEP_121"].base_price = 8000
    item_registry["WEP_121"].volume = 3.0
    item_registry["WEP_121"].mass = 300
    item_registry["WEP_121"].description = "Ship weapon system"

    # WEP_122 - Sensor Dampener
    item_registry["WEP_122"] = ItemData.new()
    item_registry["WEP_122"].id = "WEP_122"
    item_registry["WEP_122"].name = "Sensor Dampener"
    item_registry["WEP_122"].category = ItemCategory.WEAPON
    item_registry["WEP_122"].tier = 2
    item_registry["WEP_122"].base_price = 9000
    item_registry["WEP_122"].volume = 3.5
    item_registry["WEP_122"].mass = 350
    item_registry["WEP_122"].description = "Ship weapon system"

    # WEP_123 - Target Painter
    item_registry["WEP_123"] = ItemData.new()
    item_registry["WEP_123"].id = "WEP_123"
    item_registry["WEP_123"].name = "Target Painter"
    item_registry["WEP_123"].category = ItemCategory.WEAPON
    item_registry["WEP_123"].tier = 2
    item_registry["WEP_123"].base_price = 7000
    item_registry["WEP_123"].volume = 2.8
    item_registry["WEP_123"].mass = 280
    item_registry["WEP_123"].description = "Ship weapon system"

    # WEP_124 - Tracking Disruptor
    item_registry["WEP_124"] = ItemData.new()
    item_registry["WEP_124"].id = "WEP_124"
    item_registry["WEP_124"].name = "Tracking Disruptor"
    item_registry["WEP_124"].category = ItemCategory.WEAPON
    item_registry["WEP_124"].tier = 2
    item_registry["WEP_124"].base_price = 8500
    item_registry["WEP_124"].volume = 3.2
    item_registry["WEP_124"].mass = 320
    item_registry["WEP_124"].description = "Ship weapon system"

    # WEP_125 - Energy Vampire
    item_registry["WEP_125"] = ItemData.new()
    item_registry["WEP_125"].id = "WEP_125"
    item_registry["WEP_125"].name = "Energy Vampire"
    item_registry["WEP_125"].category = ItemCategory.WEAPON
    item_registry["WEP_125"].tier = 3
    item_registry["WEP_125"].base_price = 16000
    item_registry["WEP_125"].volume = 8.0
    item_registry["WEP_125"].mass = 800
    item_registry["WEP_125"].description = "Ship weapon system"

    # WEP_126 - Shield Disruptor
    item_registry["WEP_126"] = ItemData.new()
    item_registry["WEP_126"].id = "WEP_126"
    item_registry["WEP_126"].name = "Shield Disruptor"
    item_registry["WEP_126"].category = ItemCategory.WEAPON
    item_registry["WEP_126"].tier = 3
    item_registry["WEP_126"].base_price = 18000
    item_registry["WEP_126"].volume = 9.0
    item_registry["WEP_126"].mass = 900
    item_registry["WEP_126"].description = "Ship weapon system"

    # WEP_127 - Stasis Web
    item_registry["WEP_127"] = ItemData.new()
    item_registry["WEP_127"].id = "WEP_127"
    item_registry["WEP_127"].name = "Stasis Web"
    item_registry["WEP_127"].category = ItemCategory.WEAPON
    item_registry["WEP_127"].tier = 2
    item_registry["WEP_127"].base_price = 10000
    item_registry["WEP_127"].volume = 4.0
    item_registry["WEP_127"].mass = 400
    item_registry["WEP_127"].description = "Ship weapon system"

    # WEP_128 - Warp Scrambler
    item_registry["WEP_128"] = ItemData.new()
    item_registry["WEP_128"].id = "WEP_128"
    item_registry["WEP_128"].name = "Warp Scrambler"
    item_registry["WEP_128"].category = ItemCategory.WEAPON
    item_registry["WEP_128"].tier = 3
    item_registry["WEP_128"].base_price = 20000
    item_registry["WEP_128"].volume = 10.0
    item_registry["WEP_128"].mass = 1000
    item_registry["WEP_128"].description = "Ship weapon system"

    # WEP_129 - Weapons Disruptor
    item_registry["WEP_129"] = ItemData.new()
    item_registry["WEP_129"].id = "WEP_129"
    item_registry["WEP_129"].name = "Weapons Disruptor"
    item_registry["WEP_129"].category = ItemCategory.WEAPON
    item_registry["WEP_129"].tier = 3
    item_registry["WEP_129"].base_price = 19000
    item_registry["WEP_129"].volume = 9.5
    item_registry["WEP_129"].mass = 950
    item_registry["WEP_129"].description = "Ship weapon system"

    # WEP_130 - Remote Sensor Booster
    item_registry["WEP_130"] = ItemData.new()
    item_registry["WEP_130"].id = "WEP_130"
    item_registry["WEP_130"].name = "Remote Sensor Booster"
    item_registry["WEP_130"].category = ItemCategory.WEAPON
    item_registry["WEP_130"].tier = 2
    item_registry["WEP_130"].base_price = 11000
    item_registry["WEP_130"].volume = 4.5
    item_registry["WEP_130"].mass = 450
    item_registry["WEP_130"].description = "Ship weapon system"

    # WEP_131 - Remote Armor Repairer
    item_registry["WEP_131"] = ItemData.new()
    item_registry["WEP_131"].id = "WEP_131"
    item_registry["WEP_131"].name = "Remote Armor Repairer"
    item_registry["WEP_131"].category = ItemCategory.WEAPON
    item_registry["WEP_131"].tier = 3
    item_registry["WEP_131"].base_price = 22000
    item_registry["WEP_131"].volume = 11.0
    item_registry["WEP_131"].mass = 1100
    item_registry["WEP_131"].description = "Ship weapon system"

    # WEP_132 - Remote Shield Booster
    item_registry["WEP_132"] = ItemData.new()
    item_registry["WEP_132"].id = "WEP_132"
    item_registry["WEP_132"].name = "Remote Shield Booster"
    item_registry["WEP_132"].category = ItemCategory.WEAPON
    item_registry["WEP_132"].tier = 3
    item_registry["WEP_132"].base_price = 24000
    item_registry["WEP_132"].volume = 12.0
    item_registry["WEP_132"].mass = 1200
    item_registry["WEP_132"].description = "Ship weapon system"

    # WEP_133 - Remote Capacitor Transfer
    item_registry["WEP_133"] = ItemData.new()
    item_registry["WEP_133"].id = "WEP_133"
    item_registry["WEP_133"].name = "Remote Capacitor Transfer"
    item_registry["WEP_133"].category = ItemCategory.WEAPON
    item_registry["WEP_133"].tier = 3
    item_registry["WEP_133"].base_price = 20000
    item_registry["WEP_133"].volume = 10.0
    item_registry["WEP_133"].mass = 1000
    item_registry["WEP_133"].description = "Ship weapon system"

    # WEP_134 - Electronic Counter
    item_registry["WEP_134"] = ItemData.new()
    item_registry["WEP_134"].id = "WEP_134"
    item_registry["WEP_134"].name = "Electronic Counter"
    item_registry["WEP_134"].category = ItemCategory.WEAPON
    item_registry["WEP_134"].tier = 4
    item_registry["WEP_134"].base_price = 35000
    item_registry["WEP_134"].volume = 18.0
    item_registry["WEP_134"].mass = 1800
    item_registry["WEP_134"].description = "Ship weapon system"

    # WEP_135 - Cloaking Device
    item_registry["WEP_135"] = ItemData.new()
    item_registry["WEP_135"].id = "WEP_135"
    item_registry["WEP_135"].name = "Cloaking Device"
    item_registry["WEP_135"].category = ItemCategory.WEAPON
    item_registry["WEP_135"].tier = 4
    item_registry["WEP_135"].base_price = 50000
    item_registry["WEP_135"].volume = 20.0
    item_registry["WEP_135"].mass = 2000
    item_registry["WEP_135"].description = "Ship weapon system"

    # WEP_136 - Jump Field Generator
    item_registry["WEP_136"] = ItemData.new()
    item_registry["WEP_136"].id = "WEP_136"
    item_registry["WEP_136"].name = "Jump Field Generator"
    item_registry["WEP_136"].category = ItemCategory.WEAPON
    item_registry["WEP_136"].tier = 4
    item_registry["WEP_136"].base_price = 45000
    item_registry["WEP_136"].volume = 22.0
    item_registry["WEP_136"].mass = 2200
    item_registry["WEP_136"].description = "Ship weapon system"

    # WEP_137 - Cyno Generator
    item_registry["WEP_137"] = ItemData.new()
    item_registry["WEP_137"].id = "WEP_137"
    item_registry["WEP_137"].name = "Cyno Generator"
    item_registry["WEP_137"].category = ItemCategory.WEAPON
    item_registry["WEP_137"].tier = 3
    item_registry["WEP_137"].base_price = 25000
    item_registry["WEP_137"].volume = 13.0
    item_registry["WEP_137"].mass = 1300
    item_registry["WEP_137"].description = "Ship weapon system"

    # WEP_138 - Scan Probe Launcher
    item_registry["WEP_138"] = ItemData.new()
    item_registry["WEP_138"].id = "WEP_138"
    item_registry["WEP_138"].name = "Scan Probe Launcher"
    item_registry["WEP_138"].category = ItemCategory.WEAPON
    item_registry["WEP_138"].tier = 2
    item_registry["WEP_138"].base_price = 12000
    item_registry["WEP_138"].volume = 5.0
    item_registry["WEP_138"].mass = 500
    item_registry["WEP_138"].description = "Ship weapon system"

    # WEP_139 - Interdiction Sphere
    item_registry["WEP_139"] = ItemData.new()
    item_registry["WEP_139"].id = "WEP_139"
    item_registry["WEP_139"].name = "Interdiction Sphere"
    item_registry["WEP_139"].category = ItemCategory.WEAPON
    item_registry["WEP_139"].tier = 4
    item_registry["WEP_139"].base_price = 55000
    item_registry["WEP_139"].volume = 25.0
    item_registry["WEP_139"].mass = 2500
    item_registry["WEP_139"].description = "Ship weapon system"

    # WEP_140 - Command Burst
    item_registry["WEP_140"] = ItemData.new()
    item_registry["WEP_140"].id = "WEP_140"
    item_registry["WEP_140"].name = "Command Burst"
    item_registry["WEP_140"].category = ItemCategory.WEAPON
    item_registry["WEP_140"].tier = 3
    item_registry["WEP_140"].base_price = 28000
    item_registry["WEP_140"].volume = 14.0
    item_registry["WEP_140"].mass = 1400
    item_registry["WEP_140"].description = "Ship weapon system"

    # WEP_141 - Light Combat Drone
    item_registry["WEP_141"] = ItemData.new()
    item_registry["WEP_141"].id = "WEP_141"
    item_registry["WEP_141"].name = "Light Combat Drone"
    item_registry["WEP_141"].category = ItemCategory.WEAPON
    item_registry["WEP_141"].tier = 1
    item_registry["WEP_141"].base_price = 3000
    item_registry["WEP_141"].volume = 1.0
    item_registry["WEP_141"].mass = 100
    item_registry["WEP_141"].description = "Ship weapon system"

    # WEP_142 - Medium Combat Drone
    item_registry["WEP_142"] = ItemData.new()
    item_registry["WEP_142"].id = "WEP_142"
    item_registry["WEP_142"].name = "Medium Combat Drone"
    item_registry["WEP_142"].category = ItemCategory.WEAPON
    item_registry["WEP_142"].tier = 2
    item_registry["WEP_142"].base_price = 7000
    item_registry["WEP_142"].volume = 2.5
    item_registry["WEP_142"].mass = 250
    item_registry["WEP_142"].description = "Ship weapon system"

    # WEP_143 - Heavy Combat Drone
    item_registry["WEP_143"] = ItemData.new()
    item_registry["WEP_143"].id = "WEP_143"
    item_registry["WEP_143"].name = "Heavy Combat Drone"
    item_registry["WEP_143"].category = ItemCategory.WEAPON
    item_registry["WEP_143"].tier = 3
    item_registry["WEP_143"].base_price = 15000
    item_registry["WEP_143"].volume = 6.0
    item_registry["WEP_143"].mass = 600
    item_registry["WEP_143"].description = "Ship weapon system"

    # WEP_144 - Interceptor Drone
    item_registry["WEP_144"] = ItemData.new()
    item_registry["WEP_144"].id = "WEP_144"
    item_registry["WEP_144"].name = "Interceptor Drone"
    item_registry["WEP_144"].category = ItemCategory.WEAPON
    item_registry["WEP_144"].tier = 2
    item_registry["WEP_144"].base_price = 6000
    item_registry["WEP_144"].volume = 2.0
    item_registry["WEP_144"].mass = 200
    item_registry["WEP_144"].description = "Ship weapon system"

    # WEP_145 - Bomber Drone
    item_registry["WEP_145"] = ItemData.new()
    item_registry["WEP_145"].id = "WEP_145"
    item_registry["WEP_145"].name = "Bomber Drone"
    item_registry["WEP_145"].category = ItemCategory.WEAPON
    item_registry["WEP_145"].tier = 3
    item_registry["WEP_145"].base_price = 12000
    item_registry["WEP_145"].volume = 5.0
    item_registry["WEP_145"].mass = 500
    item_registry["WEP_145"].description = "Ship weapon system"

    # WEP_146 - Mining Drone
    item_registry["WEP_146"] = ItemData.new()
    item_registry["WEP_146"].id = "WEP_146"
    item_registry["WEP_146"].name = "Mining Drone"
    item_registry["WEP_146"].category = ItemCategory.WEAPON
    item_registry["WEP_146"].tier = 1
    item_registry["WEP_146"].base_price = 2500
    item_registry["WEP_146"].volume = 1.2
    item_registry["WEP_146"].mass = 120
    item_registry["WEP_146"].description = "Ship weapon system"

    # WEP_147 - Harvester Drone
    item_registry["WEP_147"] = ItemData.new()
    item_registry["WEP_147"].id = "WEP_147"
    item_registry["WEP_147"].name = "Harvester Drone"
    item_registry["WEP_147"].category = ItemCategory.WEAPON
    item_registry["WEP_147"].tier = 2
    item_registry["WEP_147"].base_price = 6000
    item_registry["WEP_147"].volume = 3.0
    item_registry["WEP_147"].mass = 300
    item_registry["WEP_147"].description = "Ship weapon system"

    # WEP_148 - Salvage Drone
    item_registry["WEP_148"] = ItemData.new()
    item_registry["WEP_148"].id = "WEP_148"
    item_registry["WEP_148"].name = "Salvage Drone"
    item_registry["WEP_148"].category = ItemCategory.WEAPON
    item_registry["WEP_148"].tier = 2
    item_registry["WEP_148"].base_price = 4000
    item_registry["WEP_148"].volume = 1.5
    item_registry["WEP_148"].mass = 150
    item_registry["WEP_148"].description = "Ship weapon system"

    # WEP_149 - Repair Drone
    item_registry["WEP_149"] = ItemData.new()
    item_registry["WEP_149"].id = "WEP_149"
    item_registry["WEP_149"].name = "Repair Drone"
    item_registry["WEP_149"].category = ItemCategory.WEAPON
    item_registry["WEP_149"].tier = 2
    item_registry["WEP_149"].base_price = 5000
    item_registry["WEP_149"].volume = 1.8
    item_registry["WEP_149"].mass = 180
    item_registry["WEP_149"].description = "Ship weapon system"

    # WEP_150 - Shield Drone
    item_registry["WEP_150"] = ItemData.new()
    item_registry["WEP_150"].id = "WEP_150"
    item_registry["WEP_150"].name = "Shield Drone"
    item_registry["WEP_150"].category = ItemCategory.WEAPON
    item_registry["WEP_150"].tier = 2
    item_registry["WEP_150"].base_price = 5500
    item_registry["WEP_150"].volume = 2.0
    item_registry["WEP_150"].mass = 200
    item_registry["WEP_150"].description = "Ship weapon system"

    # WEP_151 - ECM Drone
    item_registry["WEP_151"] = ItemData.new()
    item_registry["WEP_151"].id = "WEP_151"
    item_registry["WEP_151"].name = "ECM Drone"
    item_registry["WEP_151"].category = ItemCategory.WEAPON
    item_registry["WEP_151"].tier = 2
    item_registry["WEP_151"].base_price = 6500
    item_registry["WEP_151"].volume = 1.6
    item_registry["WEP_151"].mass = 160
    item_registry["WEP_151"].description = "Ship weapon system"

    # WEP_152 - Sentry Drone
    item_registry["WEP_152"] = ItemData.new()
    item_registry["WEP_152"].id = "WEP_152"
    item_registry["WEP_152"].name = "Sentry Drone"
    item_registry["WEP_152"].category = ItemCategory.WEAPON
    item_registry["WEP_152"].tier = 3
    item_registry["WEP_152"].base_price = 9000
    item_registry["WEP_152"].volume = 4.0
    item_registry["WEP_152"].mass = 400
    item_registry["WEP_152"].description = "Ship weapon system"

    # WEP_153 - Kamikaze Drone
    item_registry["WEP_153"] = ItemData.new()
    item_registry["WEP_153"].id = "WEP_153"
    item_registry["WEP_153"].name = "Kamikaze Drone"
    item_registry["WEP_153"].category = ItemCategory.WEAPON
    item_registry["WEP_153"].tier = 2
    item_registry["WEP_153"].base_price = 3500
    item_registry["WEP_153"].volume = 1.4
    item_registry["WEP_153"].mass = 140
    item_registry["WEP_153"].description = "Ship weapon system"

    # WEP_154 - Recon Drone
    item_registry["WEP_154"] = ItemData.new()
    item_registry["WEP_154"].id = "WEP_154"
    item_registry["WEP_154"].name = "Recon Drone"
    item_registry["WEP_154"].category = ItemCategory.WEAPON
    item_registry["WEP_154"].tier = 2
    item_registry["WEP_154"].base_price = 4500
    item_registry["WEP_154"].volume = 1.0
    item_registry["WEP_154"].mass = 100
    item_registry["WEP_154"].description = "Ship weapon system"

    # WEP_155 - Swarm Drone
    item_registry["WEP_155"] = ItemData.new()
    item_registry["WEP_155"].id = "WEP_155"
    item_registry["WEP_155"].name = "Swarm Drone"
    item_registry["WEP_155"].category = ItemCategory.WEAPON
    item_registry["WEP_155"].tier = 3
    item_registry["WEP_155"].base_price = 2000
    item_registry["WEP_155"].volume = 0.8
    item_registry["WEP_155"].mass = 80
    item_registry["WEP_155"].description = "Ship weapon system"

    # WEP_156 - Hunter-Killer Drone
    item_registry["WEP_156"] = ItemData.new()
    item_registry["WEP_156"].id = "WEP_156"
    item_registry["WEP_156"].name = "Hunter-Killer Drone"
    item_registry["WEP_156"].category = ItemCategory.WEAPON
    item_registry["WEP_156"].tier = 4
    item_registry["WEP_156"].base_price = 25000
    item_registry["WEP_156"].volume = 10.0
    item_registry["WEP_156"].mass = 1000
    item_registry["WEP_156"].description = "Ship weapon system"

    # WEP_157 - Command Drone
    item_registry["WEP_157"] = ItemData.new()
    item_registry["WEP_157"].id = "WEP_157"
    item_registry["WEP_157"].name = "Command Drone"
    item_registry["WEP_157"].category = ItemCategory.WEAPON
    item_registry["WEP_157"].tier = 3
    item_registry["WEP_157"].base_price = 16000
    item_registry["WEP_157"].volume = 7.0
    item_registry["WEP_157"].mass = 700
    item_registry["WEP_157"].description = "Ship weapon system"

    # WEP_158 - Nanite Swarm
    item_registry["WEP_158"] = ItemData.new()
    item_registry["WEP_158"].id = "WEP_158"
    item_registry["WEP_158"].name = "Nanite Swarm"
    item_registry["WEP_158"].category = ItemCategory.WEAPON
    item_registry["WEP_158"].tier = 4
    item_registry["WEP_158"].base_price = 20000
    item_registry["WEP_158"].volume = 8.0
    item_registry["WEP_158"].mass = 800
    item_registry["WEP_158"].description = "Ship weapon system"

    # WEP_159 - Assault Drone
    item_registry["WEP_159"] = ItemData.new()
    item_registry["WEP_159"].id = "WEP_159"
    item_registry["WEP_159"].name = "Assault Drone"
    item_registry["WEP_159"].category = ItemCategory.WEAPON
    item_registry["WEP_159"].tier = 3
    item_registry["WEP_159"].base_price = 14000
    item_registry["WEP_159"].volume = 6.5
    item_registry["WEP_159"].mass = 650
    item_registry["WEP_159"].description = "Ship weapon system"

    # WEP_160 - Stealth Drone
    item_registry["WEP_160"] = ItemData.new()
    item_registry["WEP_160"].id = "WEP_160"
    item_registry["WEP_160"].name = "Stealth Drone"
    item_registry["WEP_160"].category = ItemCategory.WEAPON
    item_registry["WEP_160"].tier = 4
    item_registry["WEP_160"].base_price = 18000
    item_registry["WEP_160"].volume = 5.0
    item_registry["WEP_160"].mass = 500
    item_registry["WEP_160"].description = "Ship weapon system"

    # WEP_161 - Doomsday Device
    item_registry["WEP_161"] = ItemData.new()
    item_registry["WEP_161"].id = "WEP_161"
    item_registry["WEP_161"].name = "Doomsday Device"
    item_registry["WEP_161"].category = ItemCategory.WEAPON
    item_registry["WEP_161"].tier = 5
    item_registry["WEP_161"].base_price = 500000
    item_registry["WEP_161"].volume = 100.0
    item_registry["WEP_161"].mass = 10000
    item_registry["WEP_161"].description = "Ship weapon system"

    # WEP_162 - Planet Cracker
    item_registry["WEP_162"] = ItemData.new()
    item_registry["WEP_162"].id = "WEP_162"
    item_registry["WEP_162"].name = "Planet Cracker"
    item_registry["WEP_162"].category = ItemCategory.WEAPON
    item_registry["WEP_162"].tier = 5
    item_registry["WEP_162"].base_price = 400000
    item_registry["WEP_162"].volume = 80.0
    item_registry["WEP_162"].mass = 8000
    item_registry["WEP_162"].description = "Ship weapon system"

    # WEP_163 - Star Killer
    item_registry["WEP_163"] = ItemData.new()
    item_registry["WEP_163"].id = "WEP_163"
    item_registry["WEP_163"].name = "Star Killer"
    item_registry["WEP_163"].category = ItemCategory.WEAPON
    item_registry["WEP_163"].tier = 5
    item_registry["WEP_163"].base_price = 800000
    item_registry["WEP_163"].volume = 120.0
    item_registry["WEP_163"].mass = 12000
    item_registry["WEP_163"].description = "Ship weapon system"

    # WEP_164 - System Bomb
    item_registry["WEP_164"] = ItemData.new()
    item_registry["WEP_164"].id = "WEP_164"
    item_registry["WEP_164"].name = "System Bomb"
    item_registry["WEP_164"].category = ItemCategory.WEAPON
    item_registry["WEP_164"].tier = 5
    item_registry["WEP_164"].base_price = 600000
    item_registry["WEP_164"].volume = 90.0
    item_registry["WEP_164"].mass = 9000
    item_registry["WEP_164"].description = "Ship weapon system"

    # WEP_165 - Reality Bomb
    item_registry["WEP_165"] = ItemData.new()
    item_registry["WEP_165"].id = "WEP_165"
    item_registry["WEP_165"].name = "Reality Bomb"
    item_registry["WEP_165"].category = ItemCategory.WEAPON
    item_registry["WEP_165"].tier = 5
    item_registry["WEP_165"].base_price = 1000000
    item_registry["WEP_165"].volume = 150.0
    item_registry["WEP_165"].mass = 15000
    item_registry["WEP_165"].description = "Ship weapon system"

    # WEP_166 - Time Bomb
    item_registry["WEP_166"] = ItemData.new()
    item_registry["WEP_166"].id = "WEP_166"
    item_registry["WEP_166"].name = "Time Bomb"
    item_registry["WEP_166"].category = ItemCategory.WEAPON
    item_registry["WEP_166"].tier = 5
    item_registry["WEP_166"].base_price = 350000
    item_registry["WEP_166"].volume = 50.0
    item_registry["WEP_166"].mass = 5000
    item_registry["WEP_166"].description = "Ship weapon system"

    # WEP_167 - Wormhole Weapon
    item_registry["WEP_167"] = ItemData.new()
    item_registry["WEP_167"].id = "WEP_167"
    item_registry["WEP_167"].name = "Wormhole Weapon"
    item_registry["WEP_167"].category = ItemCategory.WEAPON
    item_registry["WEP_167"].tier = 5
    item_registry["WEP_167"].base_price = 450000
    item_registry["WEP_167"].volume = 70.0
    item_registry["WEP_167"].mass = 7000
    item_registry["WEP_167"].description = "Ship weapon system"

    # WEP_168 - Entropy Accelerator
    item_registry["WEP_168"] = ItemData.new()
    item_registry["WEP_168"].id = "WEP_168"
    item_registry["WEP_168"].name = "Entropy Accelerator"
    item_registry["WEP_168"].category = ItemCategory.WEAPON
    item_registry["WEP_168"].tier = 5
    item_registry["WEP_168"].base_price = 300000
    item_registry["WEP_168"].volume = 45.0
    item_registry["WEP_168"].mass = 4500
    item_registry["WEP_168"].description = "Ship weapon system"

    # WEP_169 - Quantum Eraser
    item_registry["WEP_169"] = ItemData.new()
    item_registry["WEP_169"].id = "WEP_169"
    item_registry["WEP_169"].name = "Quantum Eraser"
    item_registry["WEP_169"].category = ItemCategory.WEAPON
    item_registry["WEP_169"].tier = 5
    item_registry["WEP_169"].base_price = 380000
    item_registry["WEP_169"].volume = 55.0
    item_registry["WEP_169"].mass = 5500
    item_registry["WEP_169"].description = "Ship weapon system"

    # WEP_170 - Void Cannon
    item_registry["WEP_170"] = ItemData.new()
    item_registry["WEP_170"].id = "WEP_170"
    item_registry["WEP_170"].name = "Void Cannon"
    item_registry["WEP_170"].category = ItemCategory.WEAPON
    item_registry["WEP_170"].tier = 5
    item_registry["WEP_170"].base_price = 420000
    item_registry["WEP_170"].volume = 60.0
    item_registry["WEP_170"].mass = 6000
    item_registry["WEP_170"].description = "Ship weapon system"

    # WEP_171 - Dark Matter Bomb
    item_registry["WEP_171"] = ItemData.new()
    item_registry["WEP_171"].id = "WEP_171"
    item_registry["WEP_171"].name = "Dark Matter Bomb"
    item_registry["WEP_171"].category = ItemCategory.WEAPON
    item_registry["WEP_171"].tier = 5
    item_registry["WEP_171"].base_price = 320000
    item_registry["WEP_171"].volume = 48.0
    item_registry["WEP_171"].mass = 4800
    item_registry["WEP_171"].description = "Ship weapon system"

    # WEP_172 - Singularity Missile
    item_registry["WEP_172"] = ItemData.new()
    item_registry["WEP_172"].id = "WEP_172"
    item_registry["WEP_172"].name = "Singularity Missile"
    item_registry["WEP_172"].category = ItemCategory.WEAPON
    item_registry["WEP_172"].tier = 5
    item_registry["WEP_172"].base_price = 360000
    item_registry["WEP_172"].volume = 52.0
    item_registry["WEP_172"].mass = 5200
    item_registry["WEP_172"].description = "Guided explosive projectile weapon"

    # WEP_173 - Dimensional Shear
    item_registry["WEP_173"] = ItemData.new()
    item_registry["WEP_173"].id = "WEP_173"
    item_registry["WEP_173"].name = "Dimensional Shear"
    item_registry["WEP_173"].category = ItemCategory.WEAPON
    item_registry["WEP_173"].tier = 5
    item_registry["WEP_173"].base_price = 340000
    item_registry["WEP_173"].volume = 49.0
    item_registry["WEP_173"].mass = 4900
    item_registry["WEP_173"].description = "Ship weapon system"

    # WEP_174 - Chrono Disintegrator
    item_registry["WEP_174"] = ItemData.new()
    item_registry["WEP_174"].id = "WEP_174"
    item_registry["WEP_174"].name = "Chrono Disintegrator"
    item_registry["WEP_174"].category = ItemCategory.WEAPON
    item_registry["WEP_174"].tier = 5
    item_registry["WEP_174"].base_price = 350000
    item_registry["WEP_174"].volume = 51.0
    item_registry["WEP_174"].mass = 5100
    item_registry["WEP_174"].description = "Ship weapon system"

    # WEP_175 - Antimatter Cascade
    item_registry["WEP_175"] = ItemData.new()
    item_registry["WEP_175"].id = "WEP_175"
    item_registry["WEP_175"].name = "Antimatter Cascade"
    item_registry["WEP_175"].category = ItemCategory.WEAPON
    item_registry["WEP_175"].tier = 5
    item_registry["WEP_175"].base_price = 480000
    item_registry["WEP_175"].volume = 75.0
    item_registry["WEP_175"].mass = 7500
    item_registry["WEP_175"].description = "Ship weapon system"

    # WEP_176 - Probability Engine
    item_registry["WEP_176"] = ItemData.new()
    item_registry["WEP_176"].id = "WEP_176"
    item_registry["WEP_176"].name = "Probability Engine"
    item_registry["WEP_176"].category = ItemCategory.WEAPON
    item_registry["WEP_176"].tier = 5
    item_registry["WEP_176"].base_price = 310000
    item_registry["WEP_176"].volume = 46.0
    item_registry["WEP_176"].mass = 4600
    item_registry["WEP_176"].description = "Ship weapon system"

    # WEP_177 - Matter Converter
    item_registry["WEP_177"] = ItemData.new()
    item_registry["WEP_177"].id = "WEP_177"
    item_registry["WEP_177"].name = "Matter Converter"
    item_registry["WEP_177"].category = ItemCategory.WEAPON
    item_registry["WEP_177"].tier = 5
    item_registry["WEP_177"].base_price = 370000
    item_registry["WEP_177"].volume = 53.0
    item_registry["WEP_177"].mass = 5300
    item_registry["WEP_177"].description = "Ship weapon system"

    # WEP_178 - Subspace Rupture
    item_registry["WEP_178"] = ItemData.new()
    item_registry["WEP_178"].id = "WEP_178"
    item_registry["WEP_178"].name = "Subspace Rupture"
    item_registry["WEP_178"].category = ItemCategory.WEAPON
    item_registry["WEP_178"].tier = 5
    item_registry["WEP_178"].base_price = 330000
    item_registry["WEP_178"].volume = 47.0
    item_registry["WEP_178"].mass = 4700
    item_registry["WEP_178"].description = "Ship weapon system"

    # WEP_179 - Psionic Disruptor
    item_registry["WEP_179"] = ItemData.new()
    item_registry["WEP_179"].id = "WEP_179"
    item_registry["WEP_179"].name = "Psionic Disruptor"
    item_registry["WEP_179"].category = ItemCategory.WEAPON
    item_registry["WEP_179"].tier = 5
    item_registry["WEP_179"].base_price = 390000
    item_registry["WEP_179"].volume = 54.0
    item_registry["WEP_179"].mass = 5400
    item_registry["WEP_179"].description = "Ship weapon system"

    # WEP_180 - Nanite Plague
    item_registry["WEP_180"] = ItemData.new()
    item_registry["WEP_180"].id = "WEP_180"
    item_registry["WEP_180"].name = "Nanite Plague"
    item_registry["WEP_180"].category = ItemCategory.WEAPON
    item_registry["WEP_180"].tier = 5
    item_registry["WEP_180"].base_price = 250000
    item_registry["WEP_180"].volume = 35.0
    item_registry["WEP_180"].mass = 3500
    item_registry["WEP_180"].description = "Ship weapon system"

    # WEP_181 - Survey Scanner
    item_registry["WEP_181"] = ItemData.new()
    item_registry["WEP_181"].id = "WEP_181"
    item_registry["WEP_181"].name = "Survey Scanner"
    item_registry["WEP_181"].category = ItemCategory.WEAPON
    item_registry["WEP_181"].tier = 1
    item_registry["WEP_181"].base_price = 1500
    item_registry["WEP_181"].volume = 0.5
    item_registry["WEP_181"].mass = 50
    item_registry["WEP_181"].description = "Ship weapon system"

    # WEP_182 - Cargo Scanner
    item_registry["WEP_182"] = ItemData.new()
    item_registry["WEP_182"].id = "WEP_182"
    item_registry["WEP_182"].name = "Cargo Scanner"
    item_registry["WEP_182"].category = ItemCategory.WEAPON
    item_registry["WEP_182"].tier = 2
    item_registry["WEP_182"].base_price = 3000
    item_registry["WEP_182"].volume = 0.8
    item_registry["WEP_182"].mass = 80
    item_registry["WEP_182"].description = "Ship weapon system"

    # WEP_183 - Gas Analyzer
    item_registry["WEP_183"] = ItemData.new()
    item_registry["WEP_183"].id = "WEP_183"
    item_registry["WEP_183"].name = "Gas Analyzer"
    item_registry["WEP_183"].category = ItemCategory.WEAPON
    item_registry["WEP_183"].tier = 2
    item_registry["WEP_183"].base_price = 4000
    item_registry["WEP_183"].volume = 1.0
    item_registry["WEP_183"].mass = 100
    item_registry["WEP_183"].description = "Ship weapon system"

    # WEP_184 - Ore Identifier
    item_registry["WEP_184"] = ItemData.new()
    item_registry["WEP_184"].id = "WEP_184"
    item_registry["WEP_184"].name = "Ore Identifier"
    item_registry["WEP_184"].category = ItemCategory.WEAPON
    item_registry["WEP_184"].tier = 2
    item_registry["WEP_184"].base_price = 3500
    item_registry["WEP_184"].volume = 0.9
    item_registry["WEP_184"].mass = 90
    item_registry["WEP_184"].description = "Ship weapon system"

    # WEP_185 - Deep Space Probe
    item_registry["WEP_185"] = ItemData.new()
    item_registry["WEP_185"].id = "WEP_185"
    item_registry["WEP_185"].name = "Deep Space Probe"
    item_registry["WEP_185"].category = ItemCategory.WEAPON
    item_registry["WEP_185"].tier = 3
    item_registry["WEP_185"].base_price = 8000
    item_registry["WEP_185"].volume = 1.5
    item_registry["WEP_185"].mass = 150
    item_registry["WEP_185"].description = "Ship weapon system"

    # WEP_186 - Salvage Scanner
    item_registry["WEP_186"] = ItemData.new()
    item_registry["WEP_186"].id = "WEP_186"
    item_registry["WEP_186"].name = "Salvage Scanner"
    item_registry["WEP_186"].category = ItemCategory.WEAPON
    item_registry["WEP_186"].tier = 2
    item_registry["WEP_186"].base_price = 2800
    item_registry["WEP_186"].volume = 0.7
    item_registry["WEP_186"].mass = 70
    item_registry["WEP_186"].description = "Ship weapon system"

    # WEP_187 - Life Form Detector
    item_registry["WEP_187"] = ItemData.new()
    item_registry["WEP_187"].id = "WEP_187"
    item_registry["WEP_187"].name = "Life Form Detector"
    item_registry["WEP_187"].category = ItemCategory.WEAPON
    item_registry["WEP_187"].tier = 3
    item_registry["WEP_187"].base_price = 10000
    item_registry["WEP_187"].volume = 2.0
    item_registry["WEP_187"].mass = 200
    item_registry["WEP_187"].description = "Ship weapon system"

    # WEP_188 - Anomaly Detector
    item_registry["WEP_188"] = ItemData.new()
    item_registry["WEP_188"].id = "WEP_188"
    item_registry["WEP_188"].name = "Anomaly Detector"
    item_registry["WEP_188"].category = ItemCategory.WEAPON
    item_registry["WEP_188"].tier = 4
    item_registry["WEP_188"].base_price = 20000
    item_registry["WEP_188"].volume = 4.0
    item_registry["WEP_188"].mass = 400
    item_registry["WEP_188"].description = "Ship weapon system"

    # WEP_189 - Stellar Cartographer
    item_registry["WEP_189"] = ItemData.new()
    item_registry["WEP_189"].id = "WEP_189"
    item_registry["WEP_189"].name = "Stellar Cartographer"
    item_registry["WEP_189"].category = ItemCategory.WEAPON
    item_registry["WEP_189"].tier = 3
    item_registry["WEP_189"].base_price = 15000
    item_registry["WEP_189"].volume = 3.0
    item_registry["WEP_189"].mass = 300
    item_registry["WEP_189"].description = "Ship weapon system"

    # WEP_190 - Quantum Analyzer
    item_registry["WEP_190"] = ItemData.new()
    item_registry["WEP_190"].id = "WEP_190"
    item_registry["WEP_190"].name = "Quantum Analyzer"
    item_registry["WEP_190"].category = ItemCategory.WEAPON
    item_registry["WEP_190"].tier = 4
    item_registry["WEP_190"].base_price = 25000
    item_registry["WEP_190"].volume = 5.0
    item_registry["WEP_190"].mass = 500
    item_registry["WEP_190"].description = "Ship weapon system"

    # WEP_191 - Universal Translator
    item_registry["WEP_191"] = ItemData.new()
    item_registry["WEP_191"].id = "WEP_191"
    item_registry["WEP_191"].name = "Universal Translator"
    item_registry["WEP_191"].category = ItemCategory.WEAPON
    item_registry["WEP_191"].tier = 2
    item_registry["WEP_191"].base_price = 5000
    item_registry["WEP_191"].volume = 0.6
    item_registry["WEP_191"].mass = 60
    item_registry["WEP_191"].description = "Ship weapon system"

    # WEP_192 - Navigation Computer
    item_registry["WEP_192"] = ItemData.new()
    item_registry["WEP_192"].id = "WEP_192"
    item_registry["WEP_192"].name = "Navigation Computer"
    item_registry["WEP_192"].category = ItemCategory.WEAPON
    item_registry["WEP_192"].tier = 2
    item_registry["WEP_192"].base_price = 8000
    item_registry["WEP_192"].volume = 2.5
    item_registry["WEP_192"].mass = 250
    item_registry["WEP_192"].description = "Ship weapon system"

    # WEP_193 - Trade Analyzer
    item_registry["WEP_193"] = ItemData.new()
    item_registry["WEP_193"].id = "WEP_193"
    item_registry["WEP_193"].name = "Trade Analyzer"
    item_registry["WEP_193"].category = ItemCategory.WEAPON
    item_registry["WEP_193"].tier = 2
    item_registry["WEP_193"].base_price = 6000
    item_registry["WEP_193"].volume = 1.2
    item_registry["WEP_193"].mass = 120
    item_registry["WEP_193"].description = "Ship weapon system"

    # WEP_194 - Research Lab
    item_registry["WEP_194"] = ItemData.new()
    item_registry["WEP_194"].id = "WEP_194"
    item_registry["WEP_194"].name = "Research Lab"
    item_registry["WEP_194"].category = ItemCategory.WEAPON
    item_registry["WEP_194"].tier = 3
    item_registry["WEP_194"].base_price = 35000
    item_registry["WEP_194"].volume = 8.0
    item_registry["WEP_194"].mass = 800
    item_registry["WEP_194"].description = "Ship weapon system"

    # WEP_195 - Medical Scanner
    item_registry["WEP_195"] = ItemData.new()
    item_registry["WEP_195"].id = "WEP_195"
    item_registry["WEP_195"].name = "Medical Scanner"
    item_registry["WEP_195"].category = ItemCategory.WEAPON
    item_registry["WEP_195"].tier = 2
    item_registry["WEP_195"].base_price = 7000
    item_registry["WEP_195"].volume = 1.4
    item_registry["WEP_195"].mass = 140
    item_registry["WEP_195"].description = "Ship weapon system"

    # WEP_196 - Environmental Analyzer
    item_registry["WEP_196"] = ItemData.new()
    item_registry["WEP_196"].id = "WEP_196"
    item_registry["WEP_196"].name = "Environmental Analyzer"
    item_registry["WEP_196"].category = ItemCategory.WEAPON
    item_registry["WEP_196"].tier = 3
    item_registry["WEP_196"].base_price = 12000
    item_registry["WEP_196"].volume = 3.5
    item_registry["WEP_196"].mass = 350
    item_registry["WEP_196"].description = "Ship weapon system"

    # WEP_197 - Terraforming Module
    item_registry["WEP_197"] = ItemData.new()
    item_registry["WEP_197"].id = "WEP_197"
    item_registry["WEP_197"].name = "Terraforming Module"
    item_registry["WEP_197"].category = ItemCategory.WEAPON
    item_registry["WEP_197"].tier = 5
    item_registry["WEP_197"].base_price = 200000
    item_registry["WEP_197"].volume = 50.0
    item_registry["WEP_197"].mass = 5000
    item_registry["WEP_197"].description = "Ship weapon system"

    # WEP_198 - Weather Controller
    item_registry["WEP_198"] = ItemData.new()
    item_registry["WEP_198"].id = "WEP_198"
    item_registry["WEP_198"].name = "Weather Controller"
    item_registry["WEP_198"].category = ItemCategory.WEAPON
    item_registry["WEP_198"].tier = 4
    item_registry["WEP_198"].base_price = 60000
    item_registry["WEP_198"].volume = 20.0
    item_registry["WEP_198"].mass = 2000
    item_registry["WEP_198"].description = "Ship weapon system"

    # WEP_199 - Gravity Stabilizer
    item_registry["WEP_199"] = ItemData.new()
    item_registry["WEP_199"].id = "WEP_199"
    item_registry["WEP_199"].name = "Gravity Stabilizer"
    item_registry["WEP_199"].category = ItemCategory.WEAPON
    item_registry["WEP_199"].tier = 3
    item_registry["WEP_199"].base_price = 18000
    item_registry["WEP_199"].volume = 6.0
    item_registry["WEP_199"].mass = 600
    item_registry["WEP_199"].description = "Ship weapon system"

    # WEP_200 - Universal Constructor
    item_registry["WEP_200"] = ItemData.new()
    item_registry["WEP_200"].id = "WEP_200"
    item_registry["WEP_200"].name = "Universal Constructor"
    item_registry["WEP_200"].category = ItemCategory.WEAPON
    item_registry["WEP_200"].tier = 5
    item_registry["WEP_200"].base_price = 150000
    item_registry["WEP_200"].volume = 30.0
    item_registry["WEP_200"].mass = 3000
    item_registry["WEP_200"].description = "Ship weapon system"

    # AMMO_001 - Standard Autocannon Round
    item_registry["AMMO_001"] = ItemData.new()
    item_registry["AMMO_001"].id = "AMMO_001"
    item_registry["AMMO_001"].name = "Standard Autocannon Round"
    item_registry["AMMO_001"].category = ItemCategory.AMMO
    item_registry["AMMO_001"].tier = 1
    item_registry["AMMO_001"].base_price = 5
    item_registry["AMMO_001"].volume = 0.005
    item_registry["AMMO_001"].mass = 0.5
    item_registry["AMMO_001"].description = "Projectile module"

    # AMMO_002 - Depleted Uranium Round
    item_registry["AMMO_002"] = ItemData.new()
    item_registry["AMMO_002"].id = "AMMO_002"
    item_registry["AMMO_002"].name = "Depleted Uranium Round"
    item_registry["AMMO_002"].category = ItemCategory.AMMO
    item_registry["AMMO_002"].tier = 2
    item_registry["AMMO_002"].base_price = 15
    item_registry["AMMO_002"].volume = 0.005
    item_registry["AMMO_002"].mass = 0.8
    item_registry["AMMO_002"].description = "Projectile module"

    # AMMO_003 - Explosive Round
    item_registry["AMMO_003"] = ItemData.new()
    item_registry["AMMO_003"].id = "AMMO_003"
    item_registry["AMMO_003"].name = "Explosive Round"
    item_registry["AMMO_003"].category = ItemCategory.AMMO
    item_registry["AMMO_003"].tier = 2
    item_registry["AMMO_003"].base_price = 12
    item_registry["AMMO_003"].volume = 0.006
    item_registry["AMMO_003"].mass = 0.6
    item_registry["AMMO_003"].description = "Projectile module"

    # AMMO_004 - Incendiary Round
    item_registry["AMMO_004"] = ItemData.new()
    item_registry["AMMO_004"].id = "AMMO_004"
    item_registry["AMMO_004"].name = "Incendiary Round"
    item_registry["AMMO_004"].category = ItemCategory.AMMO
    item_registry["AMMO_004"].tier = 2
    item_registry["AMMO_004"].base_price = 10
    item_registry["AMMO_004"].volume = 0.005
    item_registry["AMMO_004"].mass = 0.7
    item_registry["AMMO_004"].description = "Projectile module"

    # AMMO_005 - EMP Round
    item_registry["AMMO_005"] = ItemData.new()
    item_registry["AMMO_005"].id = "AMMO_005"
    item_registry["AMMO_005"].name = "EMP Round"
    item_registry["AMMO_005"].category = ItemCategory.AMMO
    item_registry["AMMO_005"].tier = 3
    item_registry["AMMO_005"].base_price = 20
    item_registry["AMMO_005"].volume = 0.005
    item_registry["AMMO_005"].mass = 0.5
    item_registry["AMMO_005"].description = "Projectile module"

    # AMMO_006 - Railgun Slug
    item_registry["AMMO_006"] = ItemData.new()
    item_registry["AMMO_006"].id = "AMMO_006"
    item_registry["AMMO_006"].name = "Railgun Slug"
    item_registry["AMMO_006"].category = ItemCategory.AMMO
    item_registry["AMMO_006"].tier = 2
    item_registry["AMMO_006"].base_price = 25
    item_registry["AMMO_006"].volume = 0.01
    item_registry["AMMO_006"].mass = 1.5
    item_registry["AMMO_006"].description = "Projectile module"

    # AMMO_007 - Sabot Round
    item_registry["AMMO_007"] = ItemData.new()
    item_registry["AMMO_007"].id = "AMMO_007"
    item_registry["AMMO_007"].name = "Sabot Round"
    item_registry["AMMO_007"].category = ItemCategory.AMMO
    item_registry["AMMO_007"].tier = 3
    item_registry["AMMO_007"].base_price = 40
    item_registry["AMMO_007"].volume = 0.012
    item_registry["AMMO_007"].mass = 2.0
    item_registry["AMMO_007"].description = "Projectile module"

    # AMMO_008 - Cluster Round
    item_registry["AMMO_008"] = ItemData.new()
    item_registry["AMMO_008"].id = "AMMO_008"
    item_registry["AMMO_008"].name = "Cluster Round"
    item_registry["AMMO_008"].category = ItemCategory.AMMO
    item_registry["AMMO_008"].tier = 3
    item_registry["AMMO_008"].base_price = 35
    item_registry["AMMO_008"].volume = 0.015
    item_registry["AMMO_008"].mass = 1.8
    item_registry["AMMO_008"].description = "Projectile module"

    # AMMO_009 - Plasma Round
    item_registry["AMMO_009"] = ItemData.new()
    item_registry["AMMO_009"].id = "AMMO_009"
    item_registry["AMMO_009"].name = "Plasma Round"
    item_registry["AMMO_009"].category = ItemCategory.AMMO
    item_registry["AMMO_009"].tier = 3
    item_registry["AMMO_009"].base_price = 50
    item_registry["AMMO_009"].volume = 0.01
    item_registry["AMMO_009"].mass = 1.2
    item_registry["AMMO_009"].description = "Projectile module"

    # AMMO_010 - Antimatter Slug
    item_registry["AMMO_010"] = ItemData.new()
    item_registry["AMMO_010"].id = "AMMO_010"
    item_registry["AMMO_010"].name = "Antimatter Slug"
    item_registry["AMMO_010"].category = ItemCategory.AMMO
    item_registry["AMMO_010"].tier = 5
    item_registry["AMMO_010"].base_price = 200
    item_registry["AMMO_010"].volume = 0.003
    item_registry["AMMO_010"].mass = 0.3
    item_registry["AMMO_010"].description = "Projectile module"

    # AMMO_011 - Standard Missile
    item_registry["AMMO_011"] = ItemData.new()
    item_registry["AMMO_011"].id = "AMMO_011"
    item_registry["AMMO_011"].name = "Standard Missile"
    item_registry["AMMO_011"].category = ItemCategory.AMMO
    item_registry["AMMO_011"].tier = 1
    item_registry["AMMO_011"].base_price = 50
    item_registry["AMMO_011"].volume = 0.05
    item_registry["AMMO_011"].mass = 5
    item_registry["AMMO_011"].description = "Missile module"

    # AMMO_012 - Heavy Missile
    item_registry["AMMO_012"] = ItemData.new()
    item_registry["AMMO_012"].id = "AMMO_012"
    item_registry["AMMO_012"].name = "Heavy Missile"
    item_registry["AMMO_012"].category = ItemCategory.AMMO
    item_registry["AMMO_012"].tier = 2
    item_registry["AMMO_012"].base_price = 120
    item_registry["AMMO_012"].volume = 0.12
    item_registry["AMMO_012"].mass = 12
    item_registry["AMMO_012"].description = "Missile module"

    # AMMO_013 - Cruise Missile
    item_registry["AMMO_013"] = ItemData.new()
    item_registry["AMMO_013"].id = "AMMO_013"
    item_registry["AMMO_013"].name = "Cruise Missile"
    item_registry["AMMO_013"].category = ItemCategory.AMMO
    item_registry["AMMO_013"].tier = 3
    item_registry["AMMO_013"].base_price = 300
    item_registry["AMMO_013"].volume = 0.25
    item_registry["AMMO_013"].mass = 25
    item_registry["AMMO_013"].description = "Missile module"

    # AMMO_014 - Torpedo
    item_registry["AMMO_014"] = ItemData.new()
    item_registry["AMMO_014"].id = "AMMO_014"
    item_registry["AMMO_014"].name = "Torpedo"
    item_registry["AMMO_014"].category = ItemCategory.AMMO
    item_registry["AMMO_014"].tier = 3
    item_registry["AMMO_014"].base_price = 400
    item_registry["AMMO_014"].volume = 0.30
    item_registry["AMMO_014"].mass = 30
    item_registry["AMMO_014"].description = "Missile module"

    # AMMO_015 - Smart Missile
    item_registry["AMMO_015"] = ItemData.new()
    item_registry["AMMO_015"].id = "AMMO_015"
    item_registry["AMMO_015"].name = "Smart Missile"
    item_registry["AMMO_015"].category = ItemCategory.AMMO
    item_registry["AMMO_015"].tier = 3
    item_registry["AMMO_015"].base_price = 250
    item_registry["AMMO_015"].volume = 0.15
    item_registry["AMMO_015"].mass = 15
    item_registry["AMMO_015"].description = "Missile module"

    # AMMO_016 - Cluster Missile
    item_registry["AMMO_016"] = ItemData.new()
    item_registry["AMMO_016"].id = "AMMO_016"
    item_registry["AMMO_016"].name = "Cluster Missile"
    item_registry["AMMO_016"].category = ItemCategory.AMMO
    item_registry["AMMO_016"].tier = 3
    item_registry["AMMO_016"].base_price = 280
    item_registry["AMMO_016"].volume = 0.18
    item_registry["AMMO_016"].mass = 18
    item_registry["AMMO_016"].description = "Missile module"

    # AMMO_017 - EMP Missile
    item_registry["AMMO_017"] = ItemData.new()
    item_registry["AMMO_017"].id = "AMMO_017"
    item_registry["AMMO_017"].name = "EMP Missile"
    item_registry["AMMO_017"].category = ItemCategory.AMMO
    item_registry["AMMO_017"].tier = 3
    item_registry["AMMO_017"].base_price = 220
    item_registry["AMMO_017"].volume = 0.14
    item_registry["AMMO_017"].mass = 14
    item_registry["AMMO_017"].description = "Missile module"

    # AMMO_018 - Nuclear Missile
    item_registry["AMMO_018"] = ItemData.new()
    item_registry["AMMO_018"].id = "AMMO_018"
    item_registry["AMMO_018"].name = "Nuclear Missile"
    item_registry["AMMO_018"].category = ItemCategory.AMMO
    item_registry["AMMO_018"].tier = 5
    item_registry["AMMO_018"].base_price = 2000
    item_registry["AMMO_018"].volume = 0.50
    item_registry["AMMO_018"].mass = 50
    item_registry["AMMO_018"].description = "Missile module"

    # AMMO_019 - Plasma Missile
    item_registry["AMMO_019"] = ItemData.new()
    item_registry["AMMO_019"].id = "AMMO_019"
    item_registry["AMMO_019"].name = "Plasma Missile"
    item_registry["AMMO_019"].category = ItemCategory.AMMO
    item_registry["AMMO_019"].tier = 4
    item_registry["AMMO_019"].base_price = 500
    item_registry["AMMO_019"].volume = 0.28
    item_registry["AMMO_019"].mass = 28
    item_registry["AMMO_019"].description = "Missile module"

    # AMMO_020 - Antimatter Torpedo
    item_registry["AMMO_020"] = ItemData.new()
    item_registry["AMMO_020"].id = "AMMO_020"
    item_registry["AMMO_020"].name = "Antimatter Torpedo"
    item_registry["AMMO_020"].category = ItemCategory.AMMO
    item_registry["AMMO_020"].tier = 5
    item_registry["AMMO_020"].base_price = 3000
    item_registry["AMMO_020"].volume = 0.35
    item_registry["AMMO_020"].mass = 35
    item_registry["AMMO_020"].description = "Missile module"

    # AMMO_021 - Standard Laser Cell
    item_registry["AMMO_021"] = ItemData.new()
    item_registry["AMMO_021"].id = "AMMO_021"
    item_registry["AMMO_021"].name = "Standard Laser Cell"
    item_registry["AMMO_021"].category = ItemCategory.AMMO
    item_registry["AMMO_021"].tier = 1
    item_registry["AMMO_021"].base_price = 8
    item_registry["AMMO_021"].volume = 0.001
    item_registry["AMMO_021"].mass = 0.1
    item_registry["AMMO_021"].description = "Energy module"

    # AMMO_022 - High-Capacity Laser Cell
    item_registry["AMMO_022"] = ItemData.new()
    item_registry["AMMO_022"].id = "AMMO_022"
    item_registry["AMMO_022"].name = "High-Capacity Laser Cell"
    item_registry["AMMO_022"].category = ItemCategory.AMMO
    item_registry["AMMO_022"].tier = 2
    item_registry["AMMO_022"].base_price = 20
    item_registry["AMMO_022"].volume = 0.002
    item_registry["AMMO_022"].mass = 0.2
    item_registry["AMMO_022"].description = "Energy module"

    # AMMO_023 - Overcharge Laser Cell
    item_registry["AMMO_023"] = ItemData.new()
    item_registry["AMMO_023"].id = "AMMO_023"
    item_registry["AMMO_023"].name = "Overcharge Laser Cell"
    item_registry["AMMO_023"].category = ItemCategory.AMMO
    item_registry["AMMO_023"].tier = 3
    item_registry["AMMO_023"].base_price = 40
    item_registry["AMMO_023"].volume = 0.003
    item_registry["AMMO_023"].mass = 0.3
    item_registry["AMMO_023"].description = "Energy module"

    # AMMO_024 - Pulse Laser Crystal
    item_registry["AMMO_024"] = ItemData.new()
    item_registry["AMMO_024"].id = "AMMO_024"
    item_registry["AMMO_024"].name = "Pulse Laser Crystal"
    item_registry["AMMO_024"].category = ItemCategory.AMMO
    item_registry["AMMO_024"].tier = 2
    item_registry["AMMO_024"].base_price = 15
    item_registry["AMMO_024"].volume = 0.0015
    item_registry["AMMO_024"].mass = 0.15
    item_registry["AMMO_024"].description = "Energy module"

    # AMMO_025 - Beam Laser Crystal
    item_registry["AMMO_025"] = ItemData.new()
    item_registry["AMMO_025"].id = "AMMO_025"
    item_registry["AMMO_025"].name = "Beam Laser Crystal"
    item_registry["AMMO_025"].category = ItemCategory.AMMO
    item_registry["AMMO_025"].tier = 2
    item_registry["AMMO_025"].base_price = 30
    item_registry["AMMO_025"].volume = 0.0025
    item_registry["AMMO_025"].mass = 0.25
    item_registry["AMMO_025"].description = "Energy module"

    # AMMO_026 - Particle Accelerator Charge
    item_registry["AMMO_026"] = ItemData.new()
    item_registry["AMMO_026"].id = "AMMO_026"
    item_registry["AMMO_026"].name = "Particle Accelerator Charge"
    item_registry["AMMO_026"].category = ItemCategory.AMMO
    item_registry["AMMO_026"].tier = 3
    item_registry["AMMO_026"].base_price = 80
    item_registry["AMMO_026"].volume = 0.005
    item_registry["AMMO_026"].mass = 0.5
    item_registry["AMMO_026"].description = "Energy module"

    # AMMO_027 - Plasma Charge
    item_registry["AMMO_027"] = ItemData.new()
    item_registry["AMMO_027"].id = "AMMO_027"
    item_registry["AMMO_027"].name = "Plasma Charge"
    item_registry["AMMO_027"].category = ItemCategory.AMMO
    item_registry["AMMO_027"].tier = 3
    item_registry["AMMO_027"].base_price = 60
    item_registry["AMMO_027"].volume = 0.004
    item_registry["AMMO_027"].mass = 0.4
    item_registry["AMMO_027"].description = "Energy module"

    # AMMO_028 - Ion Charge
    item_registry["AMMO_028"] = ItemData.new()
    item_registry["AMMO_028"].id = "AMMO_028"
    item_registry["AMMO_028"].name = "Ion Charge"
    item_registry["AMMO_028"].category = ItemCategory.AMMO
    item_registry["AMMO_028"].tier = 3
    item_registry["AMMO_028"].base_price = 50
    item_registry["AMMO_028"].volume = 0.0035
    item_registry["AMMO_028"].mass = 0.35
    item_registry["AMMO_028"].description = "Energy module"

    # AMMO_029 - Fusion Cell
    item_registry["AMMO_029"] = ItemData.new()
    item_registry["AMMO_029"].id = "AMMO_029"
    item_registry["AMMO_029"].name = "Fusion Cell"
    item_registry["AMMO_029"].category = ItemCategory.AMMO
    item_registry["AMMO_029"].tier = 4
    item_registry["AMMO_029"].base_price = 150
    item_registry["AMMO_029"].volume = 0.006
    item_registry["AMMO_029"].mass = 0.6
    item_registry["AMMO_029"].description = "Energy module"

    # AMMO_030 - Antimatter Cell
    item_registry["AMMO_030"] = ItemData.new()
    item_registry["AMMO_030"].id = "AMMO_030"
    item_registry["AMMO_030"].name = "Antimatter Cell"
    item_registry["AMMO_030"].category = ItemCategory.AMMO
    item_registry["AMMO_030"].tier = 5
    item_registry["AMMO_030"].base_price = 400
    item_registry["AMMO_030"].volume = 0.002
    item_registry["AMMO_030"].mass = 0.2
    item_registry["AMMO_030"].description = "Energy module"

    # AMMO_031 - Light Blaster Charge
    item_registry["AMMO_031"] = ItemData.new()
    item_registry["AMMO_031"].id = "AMMO_031"
    item_registry["AMMO_031"].name = "Light Blaster Charge"
    item_registry["AMMO_031"].category = ItemCategory.AMMO
    item_registry["AMMO_031"].tier = 1
    item_registry["AMMO_031"].base_price = 12
    item_registry["AMMO_031"].volume = 0.003
    item_registry["AMMO_031"].mass = 0.3
    item_registry["AMMO_031"].description = "Hybrid module"

    # AMMO_032 - Medium Blaster Charge
    item_registry["AMMO_032"] = ItemData.new()
    item_registry["AMMO_032"].id = "AMMO_032"
    item_registry["AMMO_032"].name = "Medium Blaster Charge"
    item_registry["AMMO_032"].category = ItemCategory.AMMO
    item_registry["AMMO_032"].tier = 2
    item_registry["AMMO_032"].base_price = 30
    item_registry["AMMO_032"].volume = 0.006
    item_registry["AMMO_032"].mass = 0.6
    item_registry["AMMO_032"].description = "Hybrid module"

    # AMMO_033 - Heavy Blaster Charge
    item_registry["AMMO_033"] = ItemData.new()
    item_registry["AMMO_033"].id = "AMMO_033"
    item_registry["AMMO_033"].name = "Heavy Blaster Charge"
    item_registry["AMMO_033"].category = ItemCategory.AMMO
    item_registry["AMMO_033"].tier = 3
    item_registry["AMMO_033"].base_price = 80
    item_registry["AMMO_033"].volume = 0.012
    item_registry["AMMO_033"].mass = 1.2
    item_registry["AMMO_033"].description = "Hybrid module"

    # AMMO_034 - Ion Blaster Charge
    item_registry["AMMO_034"] = ItemData.new()
    item_registry["AMMO_034"].id = "AMMO_034"
    item_registry["AMMO_034"].name = "Ion Blaster Charge"
    item_registry["AMMO_034"].category = ItemCategory.AMMO
    item_registry["AMMO_034"].tier = 3
    item_registry["AMMO_034"].base_price = 60
    item_registry["AMMO_034"].volume = 0.008
    item_registry["AMMO_034"].mass = 0.8
    item_registry["AMMO_034"].description = "Hybrid module"

    # AMMO_035 - Neutron Blaster Charge
    item_registry["AMMO_035"] = ItemData.new()
    item_registry["AMMO_035"].id = "AMMO_035"
    item_registry["AMMO_035"].name = "Neutron Blaster Charge"
    item_registry["AMMO_035"].category = ItemCategory.AMMO
    item_registry["AMMO_035"].tier = 4
    item_registry["AMMO_035"].base_price = 120
    item_registry["AMMO_035"].volume = 0.015
    item_registry["AMMO_035"].mass = 1.5
    item_registry["AMMO_035"].description = "Hybrid module"

    # AMMO_036 - Antimatter Blaster Charge
    item_registry["AMMO_036"] = ItemData.new()
    item_registry["AMMO_036"].id = "AMMO_036"
    item_registry["AMMO_036"].name = "Antimatter Blaster Charge"
    item_registry["AMMO_036"].category = ItemCategory.AMMO
    item_registry["AMMO_036"].tier = 5
    item_registry["AMMO_036"].base_price = 300
    item_registry["AMMO_036"].volume = 0.008
    item_registry["AMMO_036"].mass = 0.8
    item_registry["AMMO_036"].description = "Hybrid module"

    # AMMO_037 - Quantum Blaster Charge
    item_registry["AMMO_037"] = ItemData.new()
    item_registry["AMMO_037"].id = "AMMO_037"
    item_registry["AMMO_037"].name = "Quantum Blaster Charge"
    item_registry["AMMO_037"].category = ItemCategory.AMMO
    item_registry["AMMO_037"].tier = 5
    item_registry["AMMO_037"].base_price = 250
    item_registry["AMMO_037"].volume = 0.01
    item_registry["AMMO_037"].mass = 1.0
    item_registry["AMMO_037"].description = "Hybrid module"

    # AMMO_038 - Phase Charge
    item_registry["AMMO_038"] = ItemData.new()
    item_registry["AMMO_038"].id = "AMMO_038"
    item_registry["AMMO_038"].name = "Phase Charge"
    item_registry["AMMO_038"].category = ItemCategory.AMMO
    item_registry["AMMO_038"].tier = 4
    item_registry["AMMO_038"].base_price = 100
    item_registry["AMMO_038"].volume = 0.009
    item_registry["AMMO_038"].mass = 0.9
    item_registry["AMMO_038"].description = "Hybrid module"

    # AMMO_039 - Void Charge
    item_registry["AMMO_039"] = ItemData.new()
    item_registry["AMMO_039"].id = "AMMO_039"
    item_registry["AMMO_039"].name = "Void Charge"
    item_registry["AMMO_039"].category = ItemCategory.AMMO
    item_registry["AMMO_039"].tier = 5
    item_registry["AMMO_039"].base_price = 280
    item_registry["AMMO_039"].volume = 0.011
    item_registry["AMMO_039"].mass = 1.1
    item_registry["AMMO_039"].description = "Hybrid module"

    # AMMO_040 - Singularity Charge
    item_registry["AMMO_040"] = ItemData.new()
    item_registry["AMMO_040"].id = "AMMO_040"
    item_registry["AMMO_040"].name = "Singularity Charge"
    item_registry["AMMO_040"].category = ItemCategory.AMMO
    item_registry["AMMO_040"].tier = 5
    item_registry["AMMO_040"].base_price = 350
    item_registry["AMMO_040"].volume = 0.005
    item_registry["AMMO_040"].mass = 0.5
    item_registry["AMMO_040"].description = "Hybrid module"

    # AMMO_041 - Mining Charge
    item_registry["AMMO_041"] = ItemData.new()
    item_registry["AMMO_041"].id = "AMMO_041"
    item_registry["AMMO_041"].name = "Mining Charge"
    item_registry["AMMO_041"].category = ItemCategory.AMMO
    item_registry["AMMO_041"].tier = 1
    item_registry["AMMO_041"].base_price = 20
    item_registry["AMMO_041"].volume = 0.02
    item_registry["AMMO_041"].mass = 2.0
    item_registry["AMMO_041"].description = "Enhances mining operations"

    # AMMO_042 - Shaped Charge
    item_registry["AMMO_042"] = ItemData.new()
    item_registry["AMMO_042"].id = "AMMO_042"
    item_registry["AMMO_042"].name = "Shaped Charge"
    item_registry["AMMO_042"].category = ItemCategory.AMMO
    item_registry["AMMO_042"].tier = 2
    item_registry["AMMO_042"].base_price = 50
    item_registry["AMMO_042"].volume = 0.035
    item_registry["AMMO_042"].mass = 3.5
    item_registry["AMMO_042"].description = "Enhances mining operations"

    # AMMO_043 - Thermal Charge
    item_registry["AMMO_043"] = ItemData.new()
    item_registry["AMMO_043"].id = "AMMO_043"
    item_registry["AMMO_043"].name = "Thermal Charge"
    item_registry["AMMO_043"].category = ItemCategory.AMMO
    item_registry["AMMO_043"].tier = 2
    item_registry["AMMO_043"].base_price = 40
    item_registry["AMMO_043"].volume = 0.025
    item_registry["AMMO_043"].mass = 2.5
    item_registry["AMMO_043"].description = "Enhances mining operations"

    # AMMO_044 - Sonic Resonator Charge
    item_registry["AMMO_044"] = ItemData.new()
    item_registry["AMMO_044"].id = "AMMO_044"
    item_registry["AMMO_044"].name = "Sonic Resonator Charge"
    item_registry["AMMO_044"].category = ItemCategory.AMMO
    item_registry["AMMO_044"].tier = 3
    item_registry["AMMO_044"].base_price = 80
    item_registry["AMMO_044"].volume = 0.04
    item_registry["AMMO_044"].mass = 4.0
    item_registry["AMMO_044"].description = "Enhances mining operations"

    # AMMO_045 - Nanite Mining Charge
    item_registry["AMMO_045"] = ItemData.new()
    item_registry["AMMO_045"].id = "AMMO_045"
    item_registry["AMMO_045"].name = "Nanite Mining Charge"
    item_registry["AMMO_045"].category = ItemCategory.AMMO
    item_registry["AMMO_045"].tier = 4
    item_registry["AMMO_045"].base_price = 150
    item_registry["AMMO_045"].volume = 0.03
    item_registry["AMMO_045"].mass = 3.0
    item_registry["AMMO_045"].description = "Enhances mining operations"

    # AMMO_046 - Tracker Round
    item_registry["AMMO_046"] = ItemData.new()
    item_registry["AMMO_046"].id = "AMMO_046"
    item_registry["AMMO_046"].name = "Tracker Round"
    item_registry["AMMO_046"].category = ItemCategory.AMMO
    item_registry["AMMO_046"].tier = 2
    item_registry["AMMO_046"].base_price = 15
    item_registry["AMMO_046"].volume = 0.004
    item_registry["AMMO_046"].mass = 0.4
    item_registry["AMMO_046"].description = "Utility module"

    # AMMO_047 - Smoke Round
    item_registry["AMMO_047"] = ItemData.new()
    item_registry["AMMO_047"].id = "AMMO_047"
    item_registry["AMMO_047"].name = "Smoke Round"
    item_registry["AMMO_047"].category = ItemCategory.AMMO
    item_registry["AMMO_047"].tier = 1
    item_registry["AMMO_047"].base_price = 10
    item_registry["AMMO_047"].volume = 0.005
    item_registry["AMMO_047"].mass = 0.5
    item_registry["AMMO_047"].description = "Utility module"

    # AMMO_048 - Flare Round
    item_registry["AMMO_048"] = ItemData.new()
    item_registry["AMMO_048"].id = "AMMO_048"
    item_registry["AMMO_048"].name = "Flare Round"
    item_registry["AMMO_048"].category = ItemCategory.AMMO
    item_registry["AMMO_048"].tier = 1
    item_registry["AMMO_048"].base_price = 8
    item_registry["AMMO_048"].volume = 0.003
    item_registry["AMMO_048"].mass = 0.3
    item_registry["AMMO_048"].description = "Utility module"

    # AMMO_049 - Decoy Round
    item_registry["AMMO_049"] = ItemData.new()
    item_registry["AMMO_049"].id = "AMMO_049"
    item_registry["AMMO_049"].name = "Decoy Round"
    item_registry["AMMO_049"].category = ItemCategory.AMMO
    item_registry["AMMO_049"].tier = 2
    item_registry["AMMO_049"].base_price = 25
    item_registry["AMMO_049"].volume = 0.006
    item_registry["AMMO_049"].mass = 0.6
    item_registry["AMMO_049"].description = "Utility module"

    # AMMO_050 - Data Probe
    item_registry["AMMO_050"] = ItemData.new()
    item_registry["AMMO_050"].id = "AMMO_050"
    item_registry["AMMO_050"].name = "Data Probe"
    item_registry["AMMO_050"].category = ItemCategory.AMMO
    item_registry["AMMO_050"].tier = 2
    item_registry["AMMO_050"].base_price = 50
    item_registry["AMMO_050"].volume = 0.002
    item_registry["AMMO_050"].mass = 0.2
    item_registry["AMMO_050"].description = "Utility module"

    # MOD_001 - Basic Shield Generator
    item_registry["MOD_001"] = ItemData.new()
    item_registry["MOD_001"].id = "MOD_001"
    item_registry["MOD_001"].name = "Basic Shield Generator"
    item_registry["MOD_001"].category = ItemCategory.MODULE
    item_registry["MOD_001"].tier = 1
    item_registry["MOD_001"].base_price = 5000
    item_registry["MOD_001"].volume = 1.2
    item_registry["MOD_001"].mass = 120
    item_registry["MOD_001"].description = "Generates protective energy shield around ship"

    # MOD_002 - Standard Shield Generator
    item_registry["MOD_002"] = ItemData.new()
    item_registry["MOD_002"].id = "MOD_002"
    item_registry["MOD_002"].name = "Standard Shield Generator"
    item_registry["MOD_002"].category = ItemCategory.MODULE
    item_registry["MOD_002"].tier = 1
    item_registry["MOD_002"].base_price = 6500
    item_registry["MOD_002"].volume = 1.5
    item_registry["MOD_002"].mass = 150
    item_registry["MOD_002"].description = "Generates protective energy shield around ship"

    # MOD_003 - Small Shield Booster
    item_registry["MOD_003"] = ItemData.new()
    item_registry["MOD_003"].id = "MOD_003"
    item_registry["MOD_003"].name = "Small Shield Booster"
    item_registry["MOD_003"].category = ItemCategory.MODULE
    item_registry["MOD_003"].tier = 1
    item_registry["MOD_003"].base_price = 4000
    item_registry["MOD_003"].volume = 0.8
    item_registry["MOD_003"].mass = 80
    item_registry["MOD_003"].description = "Increases shield regeneration rate"

    # MOD_004 - Light Shield Extender
    item_registry["MOD_004"] = ItemData.new()
    item_registry["MOD_004"].id = "MOD_004"
    item_registry["MOD_004"].name = "Light Shield Extender"
    item_registry["MOD_004"].category = ItemCategory.MODULE
    item_registry["MOD_004"].tier = 1
    item_registry["MOD_004"].base_price = 5500
    item_registry["MOD_004"].volume = 1.0
    item_registry["MOD_004"].mass = 100
    item_registry["MOD_004"].description = "Extends maximum shield capacity"

    # MOD_005 - Basic Hardener
    item_registry["MOD_005"] = ItemData.new()
    item_registry["MOD_005"].id = "MOD_005"
    item_registry["MOD_005"].name = "Basic Hardener"
    item_registry["MOD_005"].category = ItemCategory.MODULE
    item_registry["MOD_005"].tier = 1
    item_registry["MOD_005"].base_price = 4500
    item_registry["MOD_005"].volume = 0.9
    item_registry["MOD_005"].mass = 90
    item_registry["MOD_005"].description = "Reduces damage taken by shields"

    # MOD_006 - Improved Shield Generator
    item_registry["MOD_006"] = ItemData.new()
    item_registry["MOD_006"].id = "MOD_006"
    item_registry["MOD_006"].name = "Improved Shield Generator"
    item_registry["MOD_006"].category = ItemCategory.MODULE
    item_registry["MOD_006"].tier = 2
    item_registry["MOD_006"].base_price = 18000
    item_registry["MOD_006"].volume = 4.5
    item_registry["MOD_006"].mass = 450
    item_registry["MOD_006"].description = "Generates protective energy shield around ship"

    # MOD_007 - Enhanced Shield Generator
    item_registry["MOD_007"] = ItemData.new()
    item_registry["MOD_007"].id = "MOD_007"
    item_registry["MOD_007"].name = "Enhanced Shield Generator"
    item_registry["MOD_007"].category = ItemCategory.MODULE
    item_registry["MOD_007"].tier = 2
    item_registry["MOD_007"].base_price = 22000
    item_registry["MOD_007"].volume = 5.2
    item_registry["MOD_007"].mass = 520
    item_registry["MOD_007"].description = "Generates protective energy shield around ship"

    # MOD_008 - Medium Shield Booster
    item_registry["MOD_008"] = ItemData.new()
    item_registry["MOD_008"].id = "MOD_008"
    item_registry["MOD_008"].name = "Medium Shield Booster"
    item_registry["MOD_008"].category = ItemCategory.MODULE
    item_registry["MOD_008"].tier = 2
    item_registry["MOD_008"].base_price = 16000
    item_registry["MOD_008"].volume = 3.8
    item_registry["MOD_008"].mass = 380
    item_registry["MOD_008"].description = "Increases shield regeneration rate"

    # MOD_009 - Medium Shield Extender
    item_registry["MOD_009"] = ItemData.new()
    item_registry["MOD_009"].id = "MOD_009"
    item_registry["MOD_009"].name = "Medium Shield Extender"
    item_registry["MOD_009"].category = ItemCategory.MODULE
    item_registry["MOD_009"].tier = 2
    item_registry["MOD_009"].base_price = 19000
    item_registry["MOD_009"].volume = 4.2
    item_registry["MOD_009"].mass = 420
    item_registry["MOD_009"].description = "Extends maximum shield capacity"

    # MOD_010 - Advanced Hardener
    item_registry["MOD_010"] = ItemData.new()
    item_registry["MOD_010"].id = "MOD_010"
    item_registry["MOD_010"].name = "Advanced Hardener"
    item_registry["MOD_010"].category = ItemCategory.MODULE
    item_registry["MOD_010"].tier = 2
    item_registry["MOD_010"].base_price = 17000
    item_registry["MOD_010"].volume = 4.0
    item_registry["MOD_010"].mass = 400
    item_registry["MOD_010"].description = "Reduces damage taken by shields"

    # MOD_011 - Elite Shield Generator
    item_registry["MOD_011"] = ItemData.new()
    item_registry["MOD_011"].id = "MOD_011"
    item_registry["MOD_011"].name = "Elite Shield Generator"
    item_registry["MOD_011"].category = ItemCategory.MODULE
    item_registry["MOD_011"].tier = 3
    item_registry["MOD_011"].base_price = 75000
    item_registry["MOD_011"].volume = 8.5
    item_registry["MOD_011"].mass = 850
    item_registry["MOD_011"].description = "Generates protective energy shield around ship"

    # MOD_012 - Combat Shield Generator
    item_registry["MOD_012"] = ItemData.new()
    item_registry["MOD_012"].id = "MOD_012"
    item_registry["MOD_012"].name = "Combat Shield Generator"
    item_registry["MOD_012"].category = ItemCategory.MODULE
    item_registry["MOD_012"].tier = 3
    item_registry["MOD_012"].base_price = 85000
    item_registry["MOD_012"].volume = 9.2
    item_registry["MOD_012"].mass = 920
    item_registry["MOD_012"].description = "Generates protective energy shield around ship"

    # MOD_013 - Tactical Shield Generator
    item_registry["MOD_013"] = ItemData.new()
    item_registry["MOD_013"].id = "MOD_013"
    item_registry["MOD_013"].name = "Tactical Shield Generator"
    item_registry["MOD_013"].category = ItemCategory.MODULE
    item_registry["MOD_013"].tier = 3
    item_registry["MOD_013"].base_price = 95000
    item_registry["MOD_013"].volume = 11.0
    item_registry["MOD_013"].mass = 1100
    item_registry["MOD_013"].description = "Generates protective energy shield around ship"

    # MOD_014 - Heavy Shield Booster
    item_registry["MOD_014"] = ItemData.new()
    item_registry["MOD_014"].id = "MOD_014"
    item_registry["MOD_014"].name = "Heavy Shield Booster"
    item_registry["MOD_014"].category = ItemCategory.MODULE
    item_registry["MOD_014"].tier = 3
    item_registry["MOD_014"].base_price = 68000
    item_registry["MOD_014"].volume = 7.8
    item_registry["MOD_014"].mass = 780
    item_registry["MOD_014"].description = "Increases shield regeneration rate"

    # MOD_015 - Large Shield Extender
    item_registry["MOD_015"] = ItemData.new()
    item_registry["MOD_015"].id = "MOD_015"
    item_registry["MOD_015"].name = "Large Shield Extender"
    item_registry["MOD_015"].category = ItemCategory.MODULE
    item_registry["MOD_015"].tier = 3
    item_registry["MOD_015"].base_price = 80000
    item_registry["MOD_015"].volume = 9.5
    item_registry["MOD_015"].mass = 950
    item_registry["MOD_015"].description = "Extends maximum shield capacity"

    # MOD_016 - Elite Hardener
    item_registry["MOD_016"] = ItemData.new()
    item_registry["MOD_016"].id = "MOD_016"
    item_registry["MOD_016"].name = "Elite Hardener"
    item_registry["MOD_016"].category = ItemCategory.MODULE
    item_registry["MOD_016"].tier = 3
    item_registry["MOD_016"].base_price = 72000
    item_registry["MOD_016"].volume = 8.2
    item_registry["MOD_016"].mass = 820
    item_registry["MOD_016"].description = "Reduces damage taken by shields"

    # MOD_017 - Adaptive Shield System
    item_registry["MOD_017"] = ItemData.new()
    item_registry["MOD_017"].id = "MOD_017"
    item_registry["MOD_017"].name = "Adaptive Shield System"
    item_registry["MOD_017"].category = ItemCategory.MODULE
    item_registry["MOD_017"].tier = 3
    item_registry["MOD_017"].base_price = 90000
    item_registry["MOD_017"].volume = 10.5
    item_registry["MOD_017"].mass = 1050
    item_registry["MOD_017"].description = "Provides shield defense capabilities"

    # MOD_018 - Quantum Shield Generator
    item_registry["MOD_018"] = ItemData.new()
    item_registry["MOD_018"].id = "MOD_018"
    item_registry["MOD_018"].name = "Quantum Shield Generator"
    item_registry["MOD_018"].category = ItemCategory.MODULE
    item_registry["MOD_018"].tier = 4
    item_registry["MOD_018"].base_price = 280000
    item_registry["MOD_018"].volume = 32.0
    item_registry["MOD_018"].mass = 3200
    item_registry["MOD_018"].description = "Generates protective energy shield around ship"

    # MOD_019 - Capital Shield Generator
    item_registry["MOD_019"] = ItemData.new()
    item_registry["MOD_019"].id = "MOD_019"
    item_registry["MOD_019"].name = "Capital Shield Generator"
    item_registry["MOD_019"].category = ItemCategory.MODULE
    item_registry["MOD_019"].tier = 4
    item_registry["MOD_019"].base_price = 320000
    item_registry["MOD_019"].volume = 36.0
    item_registry["MOD_019"].mass = 3600
    item_registry["MOD_019"].description = "Generates protective energy shield around ship"

    # MOD_020 - Siege Shield Booster
    item_registry["MOD_020"] = ItemData.new()
    item_registry["MOD_020"].id = "MOD_020"
    item_registry["MOD_020"].name = "Siege Shield Booster"
    item_registry["MOD_020"].category = ItemCategory.MODULE
    item_registry["MOD_020"].tier = 4
    item_registry["MOD_020"].base_price = 250000
    item_registry["MOD_020"].volume = 28.0
    item_registry["MOD_020"].mass = 2800
    item_registry["MOD_020"].description = "Increases shield regeneration rate"

    # MOD_021 - Capital Shield Extender
    item_registry["MOD_021"] = ItemData.new()
    item_registry["MOD_021"].id = "MOD_021"
    item_registry["MOD_021"].name = "Capital Shield Extender"
    item_registry["MOD_021"].category = ItemCategory.MODULE
    item_registry["MOD_021"].tier = 4
    item_registry["MOD_021"].base_price = 300000
    item_registry["MOD_021"].volume = 34.0
    item_registry["MOD_021"].mass = 3400
    item_registry["MOD_021"].description = "Extends maximum shield capacity"

    # MOD_022 - Quantum Hardener
    item_registry["MOD_022"] = ItemData.new()
    item_registry["MOD_022"].id = "MOD_022"
    item_registry["MOD_022"].name = "Quantum Hardener"
    item_registry["MOD_022"].category = ItemCategory.MODULE
    item_registry["MOD_022"].tier = 4
    item_registry["MOD_022"].base_price = 265000
    item_registry["MOD_022"].volume = 30.0
    item_registry["MOD_022"].mass = 3000
    item_registry["MOD_022"].description = "Reduces damage taken by shields"

    # MOD_023 - Titan Shield Generator
    item_registry["MOD_023"] = ItemData.new()
    item_registry["MOD_023"].id = "MOD_023"
    item_registry["MOD_023"].name = "Titan Shield Generator"
    item_registry["MOD_023"].category = ItemCategory.MODULE
    item_registry["MOD_023"].tier = 5
    item_registry["MOD_023"].base_price = 1800000
    item_registry["MOD_023"].volume = 120.0
    item_registry["MOD_023"].mass = 12000
    item_registry["MOD_023"].description = "Generates protective energy shield around ship"

    # MOD_024 - Mega Shield Booster
    item_registry["MOD_024"] = ItemData.new()
    item_registry["MOD_024"].id = "MOD_024"
    item_registry["MOD_024"].name = "Mega Shield Booster"
    item_registry["MOD_024"].category = ItemCategory.MODULE
    item_registry["MOD_024"].tier = 5
    item_registry["MOD_024"].base_price = 1500000
    item_registry["MOD_024"].volume = 100.0
    item_registry["MOD_024"].mass = 10000
    item_registry["MOD_024"].description = "Increases shield regeneration rate"

    # MOD_025 - Ultimate Shield Extender
    item_registry["MOD_025"] = ItemData.new()
    item_registry["MOD_025"].id = "MOD_025"
    item_registry["MOD_025"].name = "Ultimate Shield Extender"
    item_registry["MOD_025"].category = ItemCategory.MODULE
    item_registry["MOD_025"].tier = 5
    item_registry["MOD_025"].base_price = 2200000
    item_registry["MOD_025"].volume = 150.0
    item_registry["MOD_025"].mass = 15000
    item_registry["MOD_025"].description = "Extends maximum shield capacity"

    # MOD_026 - Basic Armor Plate
    item_registry["MOD_026"] = ItemData.new()
    item_registry["MOD_026"].id = "MOD_026"
    item_registry["MOD_026"].name = "Basic Armor Plate"
    item_registry["MOD_026"].category = ItemCategory.MODULE
    item_registry["MOD_026"].tier = 1
    item_registry["MOD_026"].base_price = 4500
    item_registry["MOD_026"].volume = 1.8
    item_registry["MOD_026"].mass = 180
    item_registry["MOD_026"].description = "Adds armor plating to hull"

    # MOD_027 - Standard Armor Plate
    item_registry["MOD_027"] = ItemData.new()
    item_registry["MOD_027"].id = "MOD_027"
    item_registry["MOD_027"].name = "Standard Armor Plate"
    item_registry["MOD_027"].category = ItemCategory.MODULE
    item_registry["MOD_027"].tier = 1
    item_registry["MOD_027"].base_price = 6000
    item_registry["MOD_027"].volume = 2.2
    item_registry["MOD_027"].mass = 220
    item_registry["MOD_027"].description = "Adds armor plating to hull"

    # MOD_028 - Small Armor Hardener
    item_registry["MOD_028"] = ItemData.new()
    item_registry["MOD_028"].id = "MOD_028"
    item_registry["MOD_028"].name = "Small Armor Hardener"
    item_registry["MOD_028"].category = ItemCategory.MODULE
    item_registry["MOD_028"].tier = 1
    item_registry["MOD_028"].base_price = 4000
    item_registry["MOD_028"].volume = 1.4
    item_registry["MOD_028"].mass = 140
    item_registry["MOD_028"].description = "Increases ship armor protection"

    # MOD_029 - Light Armor Repair
    item_registry["MOD_029"] = ItemData.new()
    item_registry["MOD_029"].id = "MOD_029"
    item_registry["MOD_029"].name = "Light Armor Repair"
    item_registry["MOD_029"].category = ItemCategory.MODULE
    item_registry["MOD_029"].tier = 1
    item_registry["MOD_029"].base_price = 5000
    item_registry["MOD_029"].volume = 1.6
    item_registry["MOD_029"].mass = 160
    item_registry["MOD_029"].description = "Enables armor self-repair systems"

    # MOD_030 - Reactive Plating
    item_registry["MOD_030"] = ItemData.new()
    item_registry["MOD_030"].id = "MOD_030"
    item_registry["MOD_030"].name = "Reactive Plating"
    item_registry["MOD_030"].category = ItemCategory.MODULE
    item_registry["MOD_030"].tier = 1
    item_registry["MOD_030"].base_price = 5500
    item_registry["MOD_030"].volume = 1.5
    item_registry["MOD_030"].mass = 150
    item_registry["MOD_030"].description = "Increases ship armor protection"

    # MOD_031 - Improved Armor Plate
    item_registry["MOD_031"] = ItemData.new()
    item_registry["MOD_031"].id = "MOD_031"
    item_registry["MOD_031"].name = "Improved Armor Plate"
    item_registry["MOD_031"].category = ItemCategory.MODULE
    item_registry["MOD_031"].tier = 2
    item_registry["MOD_031"].base_price = 20000
    item_registry["MOD_031"].volume = 6.8
    item_registry["MOD_031"].mass = 680
    item_registry["MOD_031"].description = "Adds armor plating to hull"

    # MOD_032 - Enhanced Armor Plate
    item_registry["MOD_032"] = ItemData.new()
    item_registry["MOD_032"].id = "MOD_032"
    item_registry["MOD_032"].name = "Enhanced Armor Plate"
    item_registry["MOD_032"].category = ItemCategory.MODULE
    item_registry["MOD_032"].tier = 2
    item_registry["MOD_032"].base_price = 24000
    item_registry["MOD_032"].volume = 7.8
    item_registry["MOD_032"].mass = 780
    item_registry["MOD_032"].description = "Adds armor plating to hull"

    # MOD_033 - Medium Armor Hardener
    item_registry["MOD_033"] = ItemData.new()
    item_registry["MOD_033"].id = "MOD_033"
    item_registry["MOD_033"].name = "Medium Armor Hardener"
    item_registry["MOD_033"].category = ItemCategory.MODULE
    item_registry["MOD_033"].tier = 2
    item_registry["MOD_033"].base_price = 18000
    item_registry["MOD_033"].volume = 5.8
    item_registry["MOD_033"].mass = 580
    item_registry["MOD_033"].description = "Increases ship armor protection"

    # MOD_034 - Medium Armor Repair
    item_registry["MOD_034"] = ItemData.new()
    item_registry["MOD_034"].id = "MOD_034"
    item_registry["MOD_034"].name = "Medium Armor Repair"
    item_registry["MOD_034"].category = ItemCategory.MODULE
    item_registry["MOD_034"].tier = 2
    item_registry["MOD_034"].base_price = 19000
    item_registry["MOD_034"].volume = 6.2
    item_registry["MOD_034"].mass = 620
    item_registry["MOD_034"].description = "Enables armor self-repair systems"

    # MOD_035 - Composite Armor
    item_registry["MOD_035"] = ItemData.new()
    item_registry["MOD_035"].id = "MOD_035"
    item_registry["MOD_035"].name = "Composite Armor"
    item_registry["MOD_035"].category = ItemCategory.MODULE
    item_registry["MOD_035"].tier = 2
    item_registry["MOD_035"].base_price = 22000
    item_registry["MOD_035"].volume = 7.2
    item_registry["MOD_035"].mass = 720
    item_registry["MOD_035"].description = "Increases ship armor protection"

    # MOD_036 - Elite Armor Plate
    item_registry["MOD_036"] = ItemData.new()
    item_registry["MOD_036"].id = "MOD_036"
    item_registry["MOD_036"].name = "Elite Armor Plate"
    item_registry["MOD_036"].category = ItemCategory.MODULE
    item_registry["MOD_036"].tier = 3
    item_registry["MOD_036"].base_price = 80000
    item_registry["MOD_036"].volume = 13.0
    item_registry["MOD_036"].mass = 1300
    item_registry["MOD_036"].description = "Adds armor plating to hull"

    # MOD_037 - Combat Armor Plate
    item_registry["MOD_037"] = ItemData.new()
    item_registry["MOD_037"].id = "MOD_037"
    item_registry["MOD_037"].name = "Combat Armor Plate"
    item_registry["MOD_037"].category = ItemCategory.MODULE
    item_registry["MOD_037"].tier = 3
    item_registry["MOD_037"].base_price = 72000
    item_registry["MOD_037"].volume = 11.5
    item_registry["MOD_037"].mass = 1150
    item_registry["MOD_037"].description = "Adds armor plating to hull"

    # MOD_038 - Tactical Armor System
    item_registry["MOD_038"] = ItemData.new()
    item_registry["MOD_038"].id = "MOD_038"
    item_registry["MOD_038"].name = "Tactical Armor System"
    item_registry["MOD_038"].category = ItemCategory.MODULE
    item_registry["MOD_038"].tier = 3
    item_registry["MOD_038"].base_price = 90000
    item_registry["MOD_038"].volume = 14.5
    item_registry["MOD_038"].mass = 1450
    item_registry["MOD_038"].description = "Increases ship armor protection"

    # MOD_039 - Heavy Armor Hardener
    item_registry["MOD_039"] = ItemData.new()
    item_registry["MOD_039"].id = "MOD_039"
    item_registry["MOD_039"].name = "Heavy Armor Hardener"
    item_registry["MOD_039"].category = ItemCategory.MODULE
    item_registry["MOD_039"].tier = 3
    item_registry["MOD_039"].base_price = 68000
    item_registry["MOD_039"].volume = 11.0
    item_registry["MOD_039"].mass = 1100
    item_registry["MOD_039"].description = "Increases ship armor protection"

    # MOD_040 - Large Armor Repair
    item_registry["MOD_040"] = ItemData.new()
    item_registry["MOD_040"].id = "MOD_040"
    item_registry["MOD_040"].name = "Large Armor Repair"
    item_registry["MOD_040"].category = ItemCategory.MODULE
    item_registry["MOD_040"].tier = 3
    item_registry["MOD_040"].base_price = 75000
    item_registry["MOD_040"].volume = 12.5
    item_registry["MOD_040"].mass = 1250
    item_registry["MOD_040"].description = "Enables armor self-repair systems"

    # MOD_041 - Nanofiber Armor
    item_registry["MOD_041"] = ItemData.new()
    item_registry["MOD_041"].id = "MOD_041"
    item_registry["MOD_041"].name = "Nanofiber Armor"
    item_registry["MOD_041"].category = ItemCategory.MODULE
    item_registry["MOD_041"].tier = 3
    item_registry["MOD_041"].base_price = 78000
    item_registry["MOD_041"].volume = 12.0
    item_registry["MOD_041"].mass = 1200
    item_registry["MOD_041"].description = "Increases ship armor protection"

    # MOD_042 - Crystalline Armor
    item_registry["MOD_042"] = ItemData.new()
    item_registry["MOD_042"].id = "MOD_042"
    item_registry["MOD_042"].name = "Crystalline Armor"
    item_registry["MOD_042"].category = ItemCategory.MODULE
    item_registry["MOD_042"].tier = 3
    item_registry["MOD_042"].base_price = 85000
    item_registry["MOD_042"].volume = 13.5
    item_registry["MOD_042"].mass = 1350
    item_registry["MOD_042"].description = "Increases ship armor protection"

    # MOD_043 - Quantum Armor Plate
    item_registry["MOD_043"] = ItemData.new()
    item_registry["MOD_043"].id = "MOD_043"
    item_registry["MOD_043"].name = "Quantum Armor Plate"
    item_registry["MOD_043"].category = ItemCategory.MODULE
    item_registry["MOD_043"].tier = 4
    item_registry["MOD_043"].base_price = 320000
    item_registry["MOD_043"].volume = 48.0
    item_registry["MOD_043"].mass = 4800
    item_registry["MOD_043"].description = "Adds armor plating to hull"

    # MOD_044 - Capital Armor Plate
    item_registry["MOD_044"] = ItemData.new()
    item_registry["MOD_044"].id = "MOD_044"
    item_registry["MOD_044"].name = "Capital Armor Plate"
    item_registry["MOD_044"].category = ItemCategory.MODULE
    item_registry["MOD_044"].tier = 4
    item_registry["MOD_044"].base_price = 280000
    item_registry["MOD_044"].volume = 42.0
    item_registry["MOD_044"].mass = 4200
    item_registry["MOD_044"].description = "Adds armor plating to hull"

    # MOD_045 - Siege Armor System
    item_registry["MOD_045"] = ItemData.new()
    item_registry["MOD_045"].id = "MOD_045"
    item_registry["MOD_045"].name = "Siege Armor System"
    item_registry["MOD_045"].category = ItemCategory.MODULE
    item_registry["MOD_045"].tier = 4
    item_registry["MOD_045"].base_price = 350000
    item_registry["MOD_045"].volume = 52.0
    item_registry["MOD_045"].mass = 5200
    item_registry["MOD_045"].description = "Increases ship armor protection"

    # MOD_046 - Capital Armor Hardener
    item_registry["MOD_046"] = ItemData.new()
    item_registry["MOD_046"].id = "MOD_046"
    item_registry["MOD_046"].name = "Capital Armor Hardener"
    item_registry["MOD_046"].category = ItemCategory.MODULE
    item_registry["MOD_046"].tier = 4
    item_registry["MOD_046"].base_price = 265000
    item_registry["MOD_046"].volume = 40.0
    item_registry["MOD_046"].mass = 4000
    item_registry["MOD_046"].description = "Increases ship armor protection"

    # MOD_047 - Capital Armor Repair
    item_registry["MOD_047"] = ItemData.new()
    item_registry["MOD_047"].id = "MOD_047"
    item_registry["MOD_047"].name = "Capital Armor Repair"
    item_registry["MOD_047"].category = ItemCategory.MODULE
    item_registry["MOD_047"].tier = 4
    item_registry["MOD_047"].base_price = 300000
    item_registry["MOD_047"].volume = 44.0
    item_registry["MOD_047"].mass = 4400
    item_registry["MOD_047"].description = "Enables armor self-repair systems"

    # MOD_048 - Titan Armor Plate
    item_registry["MOD_048"] = ItemData.new()
    item_registry["MOD_048"].id = "MOD_048"
    item_registry["MOD_048"].name = "Titan Armor Plate"
    item_registry["MOD_048"].category = ItemCategory.MODULE
    item_registry["MOD_048"].tier = 5
    item_registry["MOD_048"].base_price = 2000000
    item_registry["MOD_048"].volume = 180.0
    item_registry["MOD_048"].mass = 18000
    item_registry["MOD_048"].description = "Adds armor plating to hull"

    # MOD_049 - Mega Armor System
    item_registry["MOD_049"] = ItemData.new()
    item_registry["MOD_049"].id = "MOD_049"
    item_registry["MOD_049"].name = "Mega Armor System"
    item_registry["MOD_049"].category = ItemCategory.MODULE
    item_registry["MOD_049"].tier = 5
    item_registry["MOD_049"].base_price = 1800000
    item_registry["MOD_049"].volume = 160.0
    item_registry["MOD_049"].mass = 16000
    item_registry["MOD_049"].description = "Increases ship armor protection"

    # MOD_050 - Ultimate Armor Repair
    item_registry["MOD_050"] = ItemData.new()
    item_registry["MOD_050"].id = "MOD_050"
    item_registry["MOD_050"].name = "Ultimate Armor Repair"
    item_registry["MOD_050"].category = ItemCategory.MODULE
    item_registry["MOD_050"].tier = 5
    item_registry["MOD_050"].base_price = 2400000
    item_registry["MOD_050"].volume = 200.0
    item_registry["MOD_050"].mass = 20000
    item_registry["MOD_050"].description = "Enables armor self-repair systems"

    # MOD_051 - Basic Thruster
    item_registry["MOD_051"] = ItemData.new()
    item_registry["MOD_051"].id = "MOD_051"
    item_registry["MOD_051"].name = "Basic Thruster"
    item_registry["MOD_051"].category = ItemCategory.MODULE
    item_registry["MOD_051"].tier = 1
    item_registry["MOD_051"].base_price = 6000
    item_registry["MOD_051"].volume = 2.0
    item_registry["MOD_051"].mass = 200
    item_registry["MOD_051"].description = "Provides primary ship propulsion"

    # MOD_052 - Standard Engine
    item_registry["MOD_052"] = ItemData.new()
    item_registry["MOD_052"].id = "MOD_052"
    item_registry["MOD_052"].name = "Standard Engine"
    item_registry["MOD_052"].category = ItemCategory.MODULE
    item_registry["MOD_052"].tier = 1
    item_registry["MOD_052"].base_price = 7500
    item_registry["MOD_052"].volume = 2.5
    item_registry["MOD_052"].mass = 250
    item_registry["MOD_052"].description = "Provides primary ship propulsion"

    # MOD_053 - Light Afterburner
    item_registry["MOD_053"] = ItemData.new()
    item_registry["MOD_053"].id = "MOD_053"
    item_registry["MOD_053"].name = "Light Afterburner"
    item_registry["MOD_053"].category = ItemCategory.MODULE
    item_registry["MOD_053"].tier = 1
    item_registry["MOD_053"].base_price = 5500
    item_registry["MOD_053"].volume = 1.8
    item_registry["MOD_053"].mass = 180
    item_registry["MOD_053"].description = "Provides short burst of extreme speed"

    # MOD_054 - Small Microwarpdrive
    item_registry["MOD_054"] = ItemData.new()
    item_registry["MOD_054"].id = "MOD_054"
    item_registry["MOD_054"].name = "Small Microwarpdrive"
    item_registry["MOD_054"].category = ItemCategory.MODULE
    item_registry["MOD_054"].tier = 1
    item_registry["MOD_054"].base_price = 8000
    item_registry["MOD_054"].volume = 2.2
    item_registry["MOD_054"].mass = 220
    item_registry["MOD_054"].description = "Sustained high-speed propulsion"

    # MOD_055 - Basic Gyrostabilizer
    item_registry["MOD_055"] = ItemData.new()
    item_registry["MOD_055"].id = "MOD_055"
    item_registry["MOD_055"].name = "Basic Gyrostabilizer"
    item_registry["MOD_055"].category = ItemCategory.MODULE
    item_registry["MOD_055"].tier = 1
    item_registry["MOD_055"].base_price = 5000
    item_registry["MOD_055"].volume = 1.6
    item_registry["MOD_055"].mass = 160
    item_registry["MOD_055"].description = "Provides primary ship propulsion"

    # MOD_056 - Improved Thruster
    item_registry["MOD_056"] = ItemData.new()
    item_registry["MOD_056"].id = "MOD_056"
    item_registry["MOD_056"].name = "Improved Thruster"
    item_registry["MOD_056"].category = ItemCategory.MODULE
    item_registry["MOD_056"].tier = 2
    item_registry["MOD_056"].base_price = 25000
    item_registry["MOD_056"].volume = 7.5
    item_registry["MOD_056"].mass = 750
    item_registry["MOD_056"].description = "Provides primary ship propulsion"

    # MOD_057 - Enhanced Engine
    item_registry["MOD_057"] = ItemData.new()
    item_registry["MOD_057"].id = "MOD_057"
    item_registry["MOD_057"].name = "Enhanced Engine"
    item_registry["MOD_057"].category = ItemCategory.MODULE
    item_registry["MOD_057"].tier = 2
    item_registry["MOD_057"].base_price = 28000
    item_registry["MOD_057"].volume = 8.5
    item_registry["MOD_057"].mass = 850
    item_registry["MOD_057"].description = "Provides primary ship propulsion"

    # MOD_058 - Medium Afterburner
    item_registry["MOD_058"] = ItemData.new()
    item_registry["MOD_058"].id = "MOD_058"
    item_registry["MOD_058"].name = "Medium Afterburner"
    item_registry["MOD_058"].category = ItemCategory.MODULE
    item_registry["MOD_058"].tier = 2
    item_registry["MOD_058"].base_price = 22000
    item_registry["MOD_058"].volume = 6.8
    item_registry["MOD_058"].mass = 680
    item_registry["MOD_058"].description = "Provides short burst of extreme speed"

    # MOD_059 - Medium Microwarpdrive
    item_registry["MOD_059"] = ItemData.new()
    item_registry["MOD_059"].id = "MOD_059"
    item_registry["MOD_059"].name = "Medium Microwarpdrive"
    item_registry["MOD_059"].category = ItemCategory.MODULE
    item_registry["MOD_059"].tier = 2
    item_registry["MOD_059"].base_price = 30000
    item_registry["MOD_059"].volume = 8.2
    item_registry["MOD_059"].mass = 820
    item_registry["MOD_059"].description = "Sustained high-speed propulsion"

    # MOD_060 - Improved Gyrostabilizer
    item_registry["MOD_060"] = ItemData.new()
    item_registry["MOD_060"].id = "MOD_060"
    item_registry["MOD_060"].name = "Improved Gyrostabilizer"
    item_registry["MOD_060"].category = ItemCategory.MODULE
    item_registry["MOD_060"].tier = 2
    item_registry["MOD_060"].base_price = 24000
    item_registry["MOD_060"].volume = 7.2
    item_registry["MOD_060"].mass = 720
    item_registry["MOD_060"].description = "Provides primary ship propulsion"

    # MOD_061 - Elite Thruster
    item_registry["MOD_061"] = ItemData.new()
    item_registry["MOD_061"].id = "MOD_061"
    item_registry["MOD_061"].name = "Elite Thruster"
    item_registry["MOD_061"].category = ItemCategory.MODULE
    item_registry["MOD_061"].tier = 3
    item_registry["MOD_061"].base_price = 95000
    item_registry["MOD_061"].volume = 16.0
    item_registry["MOD_061"].mass = 1600
    item_registry["MOD_061"].description = "Provides primary ship propulsion"

    # MOD_062 - Combat Engine
    item_registry["MOD_062"] = ItemData.new()
    item_registry["MOD_062"].id = "MOD_062"
    item_registry["MOD_062"].name = "Combat Engine"
    item_registry["MOD_062"].category = ItemCategory.MODULE
    item_registry["MOD_062"].tier = 3
    item_registry["MOD_062"].base_price = 85000
    item_registry["MOD_062"].volume = 14.0
    item_registry["MOD_062"].mass = 1400
    item_registry["MOD_062"].description = "Provides primary ship propulsion"

    # MOD_063 - Tactical Thruster
    item_registry["MOD_063"] = ItemData.new()
    item_registry["MOD_063"].id = "MOD_063"
    item_registry["MOD_063"].name = "Tactical Thruster"
    item_registry["MOD_063"].category = ItemCategory.MODULE
    item_registry["MOD_063"].tier = 3
    item_registry["MOD_063"].base_price = 105000
    item_registry["MOD_063"].volume = 17.5
    item_registry["MOD_063"].mass = 1750
    item_registry["MOD_063"].description = "Provides primary ship propulsion"

    # MOD_064 - Heavy Afterburner
    item_registry["MOD_064"] = ItemData.new()
    item_registry["MOD_064"].id = "MOD_064"
    item_registry["MOD_064"].name = "Heavy Afterburner"
    item_registry["MOD_064"].category = ItemCategory.MODULE
    item_registry["MOD_064"].tier = 3
    item_registry["MOD_064"].base_price = 82000
    item_registry["MOD_064"].volume = 13.5
    item_registry["MOD_064"].mass = 1350
    item_registry["MOD_064"].description = "Provides short burst of extreme speed"

    # MOD_065 - Large Microwarpdrive
    item_registry["MOD_065"] = ItemData.new()
    item_registry["MOD_065"].id = "MOD_065"
    item_registry["MOD_065"].name = "Large Microwarpdrive"
    item_registry["MOD_065"].category = ItemCategory.MODULE
    item_registry["MOD_065"].tier = 3
    item_registry["MOD_065"].base_price = 98000
    item_registry["MOD_065"].volume = 16.5
    item_registry["MOD_065"].mass = 1650
    item_registry["MOD_065"].description = "Sustained high-speed propulsion"

    # MOD_066 - Elite Gyrostabilizer
    item_registry["MOD_066"] = ItemData.new()
    item_registry["MOD_066"].id = "MOD_066"
    item_registry["MOD_066"].name = "Elite Gyrostabilizer"
    item_registry["MOD_066"].category = ItemCategory.MODULE
    item_registry["MOD_066"].tier = 3
    item_registry["MOD_066"].base_price = 80000
    item_registry["MOD_066"].volume = 13.0
    item_registry["MOD_066"].mass = 1300
    item_registry["MOD_066"].description = "Provides primary ship propulsion"

    # MOD_067 - Ion Drive System
    item_registry["MOD_067"] = ItemData.new()
    item_registry["MOD_067"].id = "MOD_067"
    item_registry["MOD_067"].name = "Ion Drive System"
    item_registry["MOD_067"].category = ItemCategory.MODULE
    item_registry["MOD_067"].tier = 3
    item_registry["MOD_067"].base_price = 110000
    item_registry["MOD_067"].volume = 18.0
    item_registry["MOD_067"].mass = 1800
    item_registry["MOD_067"].description = "Provides primary ship propulsion"

    # MOD_068 - Quantum Thruster
    item_registry["MOD_068"] = ItemData.new()
    item_registry["MOD_068"].id = "MOD_068"
    item_registry["MOD_068"].name = "Quantum Thruster"
    item_registry["MOD_068"].category = ItemCategory.MODULE
    item_registry["MOD_068"].tier = 4
    item_registry["MOD_068"].base_price = 350000
    item_registry["MOD_068"].volume = 55.0
    item_registry["MOD_068"].mass = 5500
    item_registry["MOD_068"].description = "Provides primary ship propulsion"

    # MOD_069 - Capital Engine
    item_registry["MOD_069"] = ItemData.new()
    item_registry["MOD_069"].id = "MOD_069"
    item_registry["MOD_069"].name = "Capital Engine"
    item_registry["MOD_069"].category = ItemCategory.MODULE
    item_registry["MOD_069"].tier = 4
    item_registry["MOD_069"].base_price = 310000
    item_registry["MOD_069"].volume = 48.0
    item_registry["MOD_069"].mass = 4800
    item_registry["MOD_069"].description = "Provides primary ship propulsion"

    # MOD_070 - Siege Afterburner
    item_registry["MOD_070"] = ItemData.new()
    item_registry["MOD_070"].id = "MOD_070"
    item_registry["MOD_070"].name = "Siege Afterburner"
    item_registry["MOD_070"].category = ItemCategory.MODULE
    item_registry["MOD_070"].tier = 4
    item_registry["MOD_070"].base_price = 285000
    item_registry["MOD_070"].volume = 45.0
    item_registry["MOD_070"].mass = 4500
    item_registry["MOD_070"].description = "Provides short burst of extreme speed"

    # MOD_071 - Capital Microwarpdrive
    item_registry["MOD_071"] = ItemData.new()
    item_registry["MOD_071"].id = "MOD_071"
    item_registry["MOD_071"].name = "Capital Microwarpdrive"
    item_registry["MOD_071"].category = ItemCategory.MODULE
    item_registry["MOD_071"].tier = 4
    item_registry["MOD_071"].base_price = 380000
    item_registry["MOD_071"].volume = 58.0
    item_registry["MOD_071"].mass = 5800
    item_registry["MOD_071"].description = "Sustained high-speed propulsion"

    # MOD_072 - Quantum Gyrostabilizer
    item_registry["MOD_072"] = ItemData.new()
    item_registry["MOD_072"].id = "MOD_072"
    item_registry["MOD_072"].name = "Quantum Gyrostabilizer"
    item_registry["MOD_072"].category = ItemCategory.MODULE
    item_registry["MOD_072"].tier = 4
    item_registry["MOD_072"].base_price = 295000
    item_registry["MOD_072"].volume = 47.0
    item_registry["MOD_072"].mass = 4700
    item_registry["MOD_072"].description = "Provides primary ship propulsion"

    # MOD_073 - Titan Thruster
    item_registry["MOD_073"] = ItemData.new()
    item_registry["MOD_073"].id = "MOD_073"
    item_registry["MOD_073"].name = "Titan Thruster"
    item_registry["MOD_073"].category = ItemCategory.MODULE
    item_registry["MOD_073"].tier = 5
    item_registry["MOD_073"].base_price = 2200000
    item_registry["MOD_073"].volume = 220.0
    item_registry["MOD_073"].mass = 22000
    item_registry["MOD_073"].description = "Provides primary ship propulsion"

    # MOD_074 - Mega Drive System
    item_registry["MOD_074"] = ItemData.new()
    item_registry["MOD_074"].id = "MOD_074"
    item_registry["MOD_074"].name = "Mega Drive System"
    item_registry["MOD_074"].category = ItemCategory.MODULE
    item_registry["MOD_074"].tier = 5
    item_registry["MOD_074"].base_price = 1900000
    item_registry["MOD_074"].volume = 190.0
    item_registry["MOD_074"].mass = 19000
    item_registry["MOD_074"].description = "Provides primary ship propulsion"

    # MOD_075 - Ultimate Warp Drive
    item_registry["MOD_075"] = ItemData.new()
    item_registry["MOD_075"].id = "MOD_075"
    item_registry["MOD_075"].name = "Ultimate Warp Drive"
    item_registry["MOD_075"].category = ItemCategory.MODULE
    item_registry["MOD_075"].tier = 5
    item_registry["MOD_075"].base_price = 2600000
    item_registry["MOD_075"].volume = 250.0
    item_registry["MOD_075"].mass = 25000
    item_registry["MOD_075"].description = "Provides primary ship propulsion"

    # MOD_076 - Basic Reactor
    item_registry["MOD_076"] = ItemData.new()
    item_registry["MOD_076"].id = "MOD_076"
    item_registry["MOD_076"].name = "Basic Reactor"
    item_registry["MOD_076"].category = ItemCategory.MODULE
    item_registry["MOD_076"].tier = 1
    item_registry["MOD_076"].base_price = 7000
    item_registry["MOD_076"].volume = 2.8
    item_registry["MOD_076"].mass = 280
    item_registry["MOD_076"].description = "Generates ship electrical power"

    # MOD_077 - Standard Power Core
    item_registry["MOD_077"] = ItemData.new()
    item_registry["MOD_077"].id = "MOD_077"
    item_registry["MOD_077"].name = "Standard Power Core"
    item_registry["MOD_077"].category = ItemCategory.MODULE
    item_registry["MOD_077"].tier = 1
    item_registry["MOD_077"].base_price = 8500
    item_registry["MOD_077"].volume = 3.2
    item_registry["MOD_077"].mass = 320
    item_registry["MOD_077"].description = "Manages ship power systems"

    # MOD_078 - Small Capacitor
    item_registry["MOD_078"] = ItemData.new()
    item_registry["MOD_078"].id = "MOD_078"
    item_registry["MOD_078"].name = "Small Capacitor"
    item_registry["MOD_078"].category = ItemCategory.MODULE
    item_registry["MOD_078"].tier = 1
    item_registry["MOD_078"].base_price = 6500
    item_registry["MOD_078"].volume = 2.4
    item_registry["MOD_078"].mass = 240
    item_registry["MOD_078"].description = "Stores energy for power demands"

    # MOD_079 - Light Power Relay
    item_registry["MOD_079"] = ItemData.new()
    item_registry["MOD_079"].id = "MOD_079"
    item_registry["MOD_079"].name = "Light Power Relay"
    item_registry["MOD_079"].category = ItemCategory.MODULE
    item_registry["MOD_079"].tier = 1
    item_registry["MOD_079"].base_price = 5500
    item_registry["MOD_079"].volume = 2.0
    item_registry["MOD_079"].mass = 200
    item_registry["MOD_079"].description = "Distributes power to ship systems"

    # MOD_080 - Basic Energy Regulator
    item_registry["MOD_080"] = ItemData.new()
    item_registry["MOD_080"].id = "MOD_080"
    item_registry["MOD_080"].name = "Basic Energy Regulator"
    item_registry["MOD_080"].category = ItemCategory.MODULE
    item_registry["MOD_080"].tier = 1
    item_registry["MOD_080"].base_price = 6000
    item_registry["MOD_080"].volume = 2.2
    item_registry["MOD_080"].mass = 220
    item_registry["MOD_080"].description = "Manages ship power systems"

    # MOD_081 - Improved Reactor
    item_registry["MOD_081"] = ItemData.new()
    item_registry["MOD_081"].id = "MOD_081"
    item_registry["MOD_081"].name = "Improved Reactor"
    item_registry["MOD_081"].category = ItemCategory.MODULE
    item_registry["MOD_081"].tier = 2
    item_registry["MOD_081"].base_price = 30000
    item_registry["MOD_081"].volume = 9.5
    item_registry["MOD_081"].mass = 950
    item_registry["MOD_081"].description = "Generates ship electrical power"

    # MOD_082 - Enhanced Power Core
    item_registry["MOD_082"] = ItemData.new()
    item_registry["MOD_082"].id = "MOD_082"
    item_registry["MOD_082"].name = "Enhanced Power Core"
    item_registry["MOD_082"].category = ItemCategory.MODULE
    item_registry["MOD_082"].tier = 2
    item_registry["MOD_082"].base_price = 35000
    item_registry["MOD_082"].volume = 11.0
    item_registry["MOD_082"].mass = 1100
    item_registry["MOD_082"].description = "Manages ship power systems"

    # MOD_083 - Medium Capacitor
    item_registry["MOD_083"] = ItemData.new()
    item_registry["MOD_083"].id = "MOD_083"
    item_registry["MOD_083"].name = "Medium Capacitor"
    item_registry["MOD_083"].category = ItemCategory.MODULE
    item_registry["MOD_083"].tier = 2
    item_registry["MOD_083"].base_price = 28000
    item_registry["MOD_083"].volume = 8.8
    item_registry["MOD_083"].mass = 880
    item_registry["MOD_083"].description = "Stores energy for power demands"

    # MOD_084 - Medium Power Relay
    item_registry["MOD_084"] = ItemData.new()
    item_registry["MOD_084"].id = "MOD_084"
    item_registry["MOD_084"].name = "Medium Power Relay"
    item_registry["MOD_084"].category = ItemCategory.MODULE
    item_registry["MOD_084"].tier = 2
    item_registry["MOD_084"].base_price = 26000
    item_registry["MOD_084"].volume = 8.2
    item_registry["MOD_084"].mass = 820
    item_registry["MOD_084"].description = "Distributes power to ship systems"

    # MOD_085 - Improved Energy Regulator
    item_registry["MOD_085"] = ItemData.new()
    item_registry["MOD_085"].id = "MOD_085"
    item_registry["MOD_085"].name = "Improved Energy Regulator"
    item_registry["MOD_085"].category = ItemCategory.MODULE
    item_registry["MOD_085"].tier = 2
    item_registry["MOD_085"].base_price = 29000
    item_registry["MOD_085"].volume = 9.0
    item_registry["MOD_085"].mass = 900
    item_registry["MOD_085"].description = "Manages ship power systems"

    # MOD_086 - Elite Reactor
    item_registry["MOD_086"] = ItemData.new()
    item_registry["MOD_086"].id = "MOD_086"
    item_registry["MOD_086"].name = "Elite Reactor"
    item_registry["MOD_086"].category = ItemCategory.MODULE
    item_registry["MOD_086"].tier = 3
    item_registry["MOD_086"].base_price = 120000
    item_registry["MOD_086"].volume = 20.0
    item_registry["MOD_086"].mass = 2000
    item_registry["MOD_086"].description = "Generates ship electrical power"

    # MOD_087 - Combat Power Core
    item_registry["MOD_087"] = ItemData.new()
    item_registry["MOD_087"].id = "MOD_087"
    item_registry["MOD_087"].name = "Combat Power Core"
    item_registry["MOD_087"].category = ItemCategory.MODULE
    item_registry["MOD_087"].tier = 3
    item_registry["MOD_087"].base_price = 105000
    item_registry["MOD_087"].volume = 17.5
    item_registry["MOD_087"].mass = 1750
    item_registry["MOD_087"].description = "Manages ship power systems"

    # MOD_088 - Tactical Reactor
    item_registry["MOD_088"] = ItemData.new()
    item_registry["MOD_088"].id = "MOD_088"
    item_registry["MOD_088"].name = "Tactical Reactor"
    item_registry["MOD_088"].category = ItemCategory.MODULE
    item_registry["MOD_088"].tier = 3
    item_registry["MOD_088"].base_price = 135000
    item_registry["MOD_088"].volume = 22.0
    item_registry["MOD_088"].mass = 2200
    item_registry["MOD_088"].description = "Generates ship electrical power"

    # MOD_089 - Large Capacitor
    item_registry["MOD_089"] = ItemData.new()
    item_registry["MOD_089"].id = "MOD_089"
    item_registry["MOD_089"].name = "Large Capacitor"
    item_registry["MOD_089"].category = ItemCategory.MODULE
    item_registry["MOD_089"].tier = 3
    item_registry["MOD_089"].base_price = 115000
    item_registry["MOD_089"].volume = 19.0
    item_registry["MOD_089"].mass = 1900
    item_registry["MOD_089"].description = "Stores energy for power demands"

    # MOD_090 - Heavy Power Relay
    item_registry["MOD_090"] = ItemData.new()
    item_registry["MOD_090"].id = "MOD_090"
    item_registry["MOD_090"].name = "Heavy Power Relay"
    item_registry["MOD_090"].category = ItemCategory.MODULE
    item_registry["MOD_090"].tier = 3
    item_registry["MOD_090"].base_price = 110000
    item_registry["MOD_090"].volume = 18.0
    item_registry["MOD_090"].mass = 1800
    item_registry["MOD_090"].description = "Distributes power to ship systems"

    # MOD_091 - Elite Energy Regulator
    item_registry["MOD_091"] = ItemData.new()
    item_registry["MOD_091"].id = "MOD_091"
    item_registry["MOD_091"].name = "Elite Energy Regulator"
    item_registry["MOD_091"].category = ItemCategory.MODULE
    item_registry["MOD_091"].tier = 3
    item_registry["MOD_091"].base_price = 112000
    item_registry["MOD_091"].volume = 18.5
    item_registry["MOD_091"].mass = 1850
    item_registry["MOD_091"].description = "Manages ship power systems"

    # MOD_092 - Fusion Reactor
    item_registry["MOD_092"] = ItemData.new()
    item_registry["MOD_092"].id = "MOD_092"
    item_registry["MOD_092"].name = "Fusion Reactor"
    item_registry["MOD_092"].category = ItemCategory.MODULE
    item_registry["MOD_092"].tier = 3
    item_registry["MOD_092"].base_price = 130000
    item_registry["MOD_092"].volume = 21.5
    item_registry["MOD_092"].mass = 2150
    item_registry["MOD_092"].description = "Generates ship electrical power"

    # MOD_093 - Quantum Reactor
    item_registry["MOD_093"] = ItemData.new()
    item_registry["MOD_093"].id = "MOD_093"
    item_registry["MOD_093"].name = "Quantum Reactor"
    item_registry["MOD_093"].category = ItemCategory.MODULE
    item_registry["MOD_093"].tier = 4
    item_registry["MOD_093"].base_price = 420000
    item_registry["MOD_093"].volume = 70.0
    item_registry["MOD_093"].mass = 7000
    item_registry["MOD_093"].description = "Generates ship electrical power"

    # MOD_094 - Capital Power Core
    item_registry["MOD_094"] = ItemData.new()
    item_registry["MOD_094"].id = "MOD_094"
    item_registry["MOD_094"].name = "Capital Power Core"
    item_registry["MOD_094"].category = ItemCategory.MODULE
    item_registry["MOD_094"].tier = 4
    item_registry["MOD_094"].base_price = 380000
    item_registry["MOD_094"].volume = 62.0
    item_registry["MOD_094"].mass = 6200
    item_registry["MOD_094"].description = "Manages ship power systems"

    # MOD_095 - Siege Reactor
    item_registry["MOD_095"] = ItemData.new()
    item_registry["MOD_095"].id = "MOD_095"
    item_registry["MOD_095"].name = "Siege Reactor"
    item_registry["MOD_095"].category = ItemCategory.MODULE
    item_registry["MOD_095"].tier = 4
    item_registry["MOD_095"].base_price = 450000
    item_registry["MOD_095"].volume = 75.0
    item_registry["MOD_095"].mass = 7500
    item_registry["MOD_095"].description = "Generates ship electrical power"

    # MOD_096 - Capital Capacitor
    item_registry["MOD_096"] = ItemData.new()
    item_registry["MOD_096"].id = "MOD_096"
    item_registry["MOD_096"].name = "Capital Capacitor"
    item_registry["MOD_096"].category = ItemCategory.MODULE
    item_registry["MOD_096"].tier = 4
    item_registry["MOD_096"].base_price = 395000
    item_registry["MOD_096"].volume = 65.0
    item_registry["MOD_096"].mass = 6500
    item_registry["MOD_096"].description = "Stores energy for power demands"

    # MOD_097 - Quantum Power Relay
    item_registry["MOD_097"] = ItemData.new()
    item_registry["MOD_097"].id = "MOD_097"
    item_registry["MOD_097"].name = "Quantum Power Relay"
    item_registry["MOD_097"].category = ItemCategory.MODULE
    item_registry["MOD_097"].tier = 4
    item_registry["MOD_097"].base_price = 365000
    item_registry["MOD_097"].volume = 60.0
    item_registry["MOD_097"].mass = 6000
    item_registry["MOD_097"].description = "Distributes power to ship systems"

    # MOD_098 - Titan Reactor
    item_registry["MOD_098"] = ItemData.new()
    item_registry["MOD_098"].id = "MOD_098"
    item_registry["MOD_098"].name = "Titan Reactor"
    item_registry["MOD_098"].category = ItemCategory.MODULE
    item_registry["MOD_098"].tier = 5
    item_registry["MOD_098"].base_price = 2800000
    item_registry["MOD_098"].volume = 280.0
    item_registry["MOD_098"].mass = 28000
    item_registry["MOD_098"].description = "Generates ship electrical power"

    # MOD_099 - Mega Power Core
    item_registry["MOD_099"] = ItemData.new()
    item_registry["MOD_099"].id = "MOD_099"
    item_registry["MOD_099"].name = "Mega Power Core"
    item_registry["MOD_099"].category = ItemCategory.MODULE
    item_registry["MOD_099"].tier = 5
    item_registry["MOD_099"].base_price = 2400000
    item_registry["MOD_099"].volume = 240.0
    item_registry["MOD_099"].mass = 24000
    item_registry["MOD_099"].description = "Manages ship power systems"

    # MOD_100 - Ultimate Capacitor
    item_registry["MOD_100"] = ItemData.new()
    item_registry["MOD_100"].id = "MOD_100"
    item_registry["MOD_100"].name = "Ultimate Capacitor"
    item_registry["MOD_100"].category = ItemCategory.MODULE
    item_registry["MOD_100"].tier = 5
    item_registry["MOD_100"].base_price = 3200000
    item_registry["MOD_100"].volume = 300.0
    item_registry["MOD_100"].mass = 30000
    item_registry["MOD_100"].description = "Stores energy for power demands"

    # MOD_101 - Basic Cargo Bay
    item_registry["MOD_101"] = ItemData.new()
    item_registry["MOD_101"].id = "MOD_101"
    item_registry["MOD_101"].name = "Basic Cargo Bay"
    item_registry["MOD_101"].category = ItemCategory.MODULE
    item_registry["MOD_101"].tier = 1
    item_registry["MOD_101"].base_price = 4000
    item_registry["MOD_101"].volume = 1.5
    item_registry["MOD_101"].mass = 150
    item_registry["MOD_101"].description = "Expands cargo storage space"

    # MOD_102 - Standard Cargo Bay
    item_registry["MOD_102"] = ItemData.new()
    item_registry["MOD_102"].id = "MOD_102"
    item_registry["MOD_102"].name = "Standard Cargo Bay"
    item_registry["MOD_102"].category = ItemCategory.MODULE
    item_registry["MOD_102"].tier = 1
    item_registry["MOD_102"].base_price = 5000
    item_registry["MOD_102"].volume = 1.8
    item_registry["MOD_102"].mass = 180
    item_registry["MOD_102"].description = "Expands cargo storage space"

    # MOD_103 - Small Ore Hold
    item_registry["MOD_103"] = ItemData.new()
    item_registry["MOD_103"].id = "MOD_103"
    item_registry["MOD_103"].name = "Small Ore Hold"
    item_registry["MOD_103"].category = ItemCategory.MODULE
    item_registry["MOD_103"].tier = 1
    item_registry["MOD_103"].base_price = 5500
    item_registry["MOD_103"].volume = 2.0
    item_registry["MOD_103"].mass = 200
    item_registry["MOD_103"].description = "Expands cargo storage space"

    # MOD_104 - Light Cargo Optimizer
    item_registry["MOD_104"] = ItemData.new()
    item_registry["MOD_104"].id = "MOD_104"
    item_registry["MOD_104"].name = "Light Cargo Optimizer"
    item_registry["MOD_104"].category = ItemCategory.MODULE
    item_registry["MOD_104"].tier = 1
    item_registry["MOD_104"].base_price = 4500
    item_registry["MOD_104"].volume = 1.4
    item_registry["MOD_104"].mass = 140
    item_registry["MOD_104"].description = "Optimizes cargo space efficiency"

    # MOD_105 - Basic Cargo Scanner
    item_registry["MOD_105"] = ItemData.new()
    item_registry["MOD_105"].id = "MOD_105"
    item_registry["MOD_105"].name = "Basic Cargo Scanner"
    item_registry["MOD_105"].category = ItemCategory.MODULE
    item_registry["MOD_105"].tier = 1
    item_registry["MOD_105"].base_price = 3800
    item_registry["MOD_105"].volume = 1.2
    item_registry["MOD_105"].mass = 120
    item_registry["MOD_105"].description = "Expands cargo storage space"

    # MOD_106 - Improved Cargo Bay
    item_registry["MOD_106"] = ItemData.new()
    item_registry["MOD_106"].id = "MOD_106"
    item_registry["MOD_106"].name = "Improved Cargo Bay"
    item_registry["MOD_106"].category = ItemCategory.MODULE
    item_registry["MOD_106"].tier = 2
    item_registry["MOD_106"].base_price = 18000
    item_registry["MOD_106"].volume = 6.5
    item_registry["MOD_106"].mass = 650
    item_registry["MOD_106"].description = "Expands cargo storage space"

    # MOD_107 - Enhanced Cargo Bay
    item_registry["MOD_107"] = ItemData.new()
    item_registry["MOD_107"].id = "MOD_107"
    item_registry["MOD_107"].name = "Enhanced Cargo Bay"
    item_registry["MOD_107"].category = ItemCategory.MODULE
    item_registry["MOD_107"].tier = 2
    item_registry["MOD_107"].base_price = 22000
    item_registry["MOD_107"].volume = 7.5
    item_registry["MOD_107"].mass = 750
    item_registry["MOD_107"].description = "Expands cargo storage space"

    # MOD_108 - Medium Ore Hold
    item_registry["MOD_108"] = ItemData.new()
    item_registry["MOD_108"].id = "MOD_108"
    item_registry["MOD_108"].name = "Medium Ore Hold"
    item_registry["MOD_108"].category = ItemCategory.MODULE
    item_registry["MOD_108"].tier = 2
    item_registry["MOD_108"].base_price = 24000
    item_registry["MOD_108"].volume = 8.2
    item_registry["MOD_108"].mass = 820
    item_registry["MOD_108"].description = "Expands cargo storage space"

    # MOD_109 - Medium Gas Hold
    item_registry["MOD_109"] = ItemData.new()
    item_registry["MOD_109"].id = "MOD_109"
    item_registry["MOD_109"].name = "Medium Gas Hold"
    item_registry["MOD_109"].category = ItemCategory.MODULE
    item_registry["MOD_109"].tier = 2
    item_registry["MOD_109"].base_price = 23000
    item_registry["MOD_109"].volume = 7.8
    item_registry["MOD_109"].mass = 780
    item_registry["MOD_109"].description = "Expands cargo storage space"

    # MOD_110 - Improved Cargo Optimizer
    item_registry["MOD_110"] = ItemData.new()
    item_registry["MOD_110"].id = "MOD_110"
    item_registry["MOD_110"].name = "Improved Cargo Optimizer"
    item_registry["MOD_110"].category = ItemCategory.MODULE
    item_registry["MOD_110"].tier = 2
    item_registry["MOD_110"].base_price = 20000
    item_registry["MOD_110"].volume = 6.8
    item_registry["MOD_110"].mass = 680
    item_registry["MOD_110"].description = "Optimizes cargo space efficiency"

    # MOD_111 - Elite Cargo Bay
    item_registry["MOD_111"] = ItemData.new()
    item_registry["MOD_111"].id = "MOD_111"
    item_registry["MOD_111"].name = "Elite Cargo Bay"
    item_registry["MOD_111"].category = ItemCategory.MODULE
    item_registry["MOD_111"].tier = 3
    item_registry["MOD_111"].base_price = 85000
    item_registry["MOD_111"].volume = 15.0
    item_registry["MOD_111"].mass = 1500
    item_registry["MOD_111"].description = "Expands cargo storage space"

    # MOD_112 - Combat Cargo Bay
    item_registry["MOD_112"] = ItemData.new()
    item_registry["MOD_112"].id = "MOD_112"
    item_registry["MOD_112"].name = "Combat Cargo Bay"
    item_registry["MOD_112"].category = ItemCategory.MODULE
    item_registry["MOD_112"].tier = 3
    item_registry["MOD_112"].base_price = 78000
    item_registry["MOD_112"].volume = 13.5
    item_registry["MOD_112"].mass = 1350
    item_registry["MOD_112"].description = "Expands cargo storage space"

    # MOD_113 - Tactical Cargo System
    item_registry["MOD_113"] = ItemData.new()
    item_registry["MOD_113"].id = "MOD_113"
    item_registry["MOD_113"].name = "Tactical Cargo System"
    item_registry["MOD_113"].category = ItemCategory.MODULE
    item_registry["MOD_113"].tier = 3
    item_registry["MOD_113"].base_price = 95000
    item_registry["MOD_113"].volume = 16.5
    item_registry["MOD_113"].mass = 1650
    item_registry["MOD_113"].description = "Expands cargo storage space"

    # MOD_114 - Large Ore Hold
    item_registry["MOD_114"] = ItemData.new()
    item_registry["MOD_114"].id = "MOD_114"
    item_registry["MOD_114"].name = "Large Ore Hold"
    item_registry["MOD_114"].category = ItemCategory.MODULE
    item_registry["MOD_114"].tier = 3
    item_registry["MOD_114"].base_price = 98000
    item_registry["MOD_114"].volume = 17.0
    item_registry["MOD_114"].mass = 1700
    item_registry["MOD_114"].description = "Expands cargo storage space"

    # MOD_115 - Large Gas Hold
    item_registry["MOD_115"] = ItemData.new()
    item_registry["MOD_115"].id = "MOD_115"
    item_registry["MOD_115"].name = "Large Gas Hold"
    item_registry["MOD_115"].category = ItemCategory.MODULE
    item_registry["MOD_115"].tier = 3
    item_registry["MOD_115"].base_price = 92000
    item_registry["MOD_115"].volume = 16.0
    item_registry["MOD_115"].mass = 1600
    item_registry["MOD_115"].description = "Expands cargo storage space"

    # MOD_116 - Elite Cargo Optimizer
    item_registry["MOD_116"] = ItemData.new()
    item_registry["MOD_116"].id = "MOD_116"
    item_registry["MOD_116"].name = "Elite Cargo Optimizer"
    item_registry["MOD_116"].category = ItemCategory.MODULE
    item_registry["MOD_116"].tier = 3
    item_registry["MOD_116"].base_price = 82000
    item_registry["MOD_116"].volume = 14.0
    item_registry["MOD_116"].mass = 1400
    item_registry["MOD_116"].description = "Optimizes cargo space efficiency"

    # MOD_117 - Compression Module
    item_registry["MOD_117"] = ItemData.new()
    item_registry["MOD_117"].id = "MOD_117"
    item_registry["MOD_117"].name = "Compression Module"
    item_registry["MOD_117"].category = ItemCategory.MODULE
    item_registry["MOD_117"].tier = 3
    item_registry["MOD_117"].base_price = 105000
    item_registry["MOD_117"].volume = 17.5
    item_registry["MOD_117"].mass = 1750
    item_registry["MOD_117"].description = "Expands cargo storage space"

    # MOD_118 - Quantum Cargo Bay
    item_registry["MOD_118"] = ItemData.new()
    item_registry["MOD_118"].id = "MOD_118"
    item_registry["MOD_118"].name = "Quantum Cargo Bay"
    item_registry["MOD_118"].category = ItemCategory.MODULE
    item_registry["MOD_118"].tier = 4
    item_registry["MOD_118"].base_price = 330000
    item_registry["MOD_118"].volume = 52.0
    item_registry["MOD_118"].mass = 5200
    item_registry["MOD_118"].description = "Expands cargo storage space"

    # MOD_119 - Capital Cargo Bay
    item_registry["MOD_119"] = ItemData.new()
    item_registry["MOD_119"].id = "MOD_119"
    item_registry["MOD_119"].name = "Capital Cargo Bay"
    item_registry["MOD_119"].category = ItemCategory.MODULE
    item_registry["MOD_119"].tier = 4
    item_registry["MOD_119"].base_price = 295000
    item_registry["MOD_119"].volume = 46.0
    item_registry["MOD_119"].mass = 4600
    item_registry["MOD_119"].description = "Expands cargo storage space"

    # MOD_120 - Siege Cargo System
    item_registry["MOD_120"] = ItemData.new()
    item_registry["MOD_120"].id = "MOD_120"
    item_registry["MOD_120"].name = "Siege Cargo System"
    item_registry["MOD_120"].category = ItemCategory.MODULE
    item_registry["MOD_120"].tier = 4
    item_registry["MOD_120"].base_price = 360000
    item_registry["MOD_120"].volume = 56.0
    item_registry["MOD_120"].mass = 5600
    item_registry["MOD_120"].description = "Expands cargo storage space"

    # MOD_121 - Capital Ore Hold
    item_registry["MOD_121"] = ItemData.new()
    item_registry["MOD_121"].id = "MOD_121"
    item_registry["MOD_121"].name = "Capital Ore Hold"
    item_registry["MOD_121"].category = ItemCategory.MODULE
    item_registry["MOD_121"].tier = 4
    item_registry["MOD_121"].base_price = 375000
    item_registry["MOD_121"].volume = 58.0
    item_registry["MOD_121"].mass = 5800
    item_registry["MOD_121"].description = "Expands cargo storage space"

    # MOD_122 - Quantum Cargo Optimizer
    item_registry["MOD_122"] = ItemData.new()
    item_registry["MOD_122"].id = "MOD_122"
    item_registry["MOD_122"].name = "Quantum Cargo Optimizer"
    item_registry["MOD_122"].category = ItemCategory.MODULE
    item_registry["MOD_122"].tier = 4
    item_registry["MOD_122"].base_price = 310000
    item_registry["MOD_122"].volume = 48.0
    item_registry["MOD_122"].mass = 4800
    item_registry["MOD_122"].description = "Optimizes cargo space efficiency"

    # MOD_123 - Titan Cargo Bay
    item_registry["MOD_123"] = ItemData.new()
    item_registry["MOD_123"].id = "MOD_123"
    item_registry["MOD_123"].name = "Titan Cargo Bay"
    item_registry["MOD_123"].category = ItemCategory.MODULE
    item_registry["MOD_123"].tier = 5
    item_registry["MOD_123"].base_price = 2000000
    item_registry["MOD_123"].volume = 200.0
    item_registry["MOD_123"].mass = 20000
    item_registry["MOD_123"].description = "Expands cargo storage space"

    # MOD_124 - Mega Cargo System
    item_registry["MOD_124"] = ItemData.new()
    item_registry["MOD_124"].id = "MOD_124"
    item_registry["MOD_124"].name = "Mega Cargo System"
    item_registry["MOD_124"].category = ItemCategory.MODULE
    item_registry["MOD_124"].tier = 5
    item_registry["MOD_124"].base_price = 1800000
    item_registry["MOD_124"].volume = 180.0
    item_registry["MOD_124"].mass = 18000
    item_registry["MOD_124"].description = "Expands cargo storage space"

    # MOD_125 - Ultimate Ore Hold
    item_registry["MOD_125"] = ItemData.new()
    item_registry["MOD_125"].id = "MOD_125"
    item_registry["MOD_125"].name = "Ultimate Ore Hold"
    item_registry["MOD_125"].category = ItemCategory.MODULE
    item_registry["MOD_125"].tier = 5
    item_registry["MOD_125"].base_price = 2400000
    item_registry["MOD_125"].volume = 220.0
    item_registry["MOD_125"].mass = 22000
    item_registry["MOD_125"].description = "Expands cargo storage space"

    # MOD_126 - Basic Scanner
    item_registry["MOD_126"] = ItemData.new()
    item_registry["MOD_126"].id = "MOD_126"
    item_registry["MOD_126"].name = "Basic Scanner"
    item_registry["MOD_126"].category = ItemCategory.MODULE
    item_registry["MOD_126"].tier = 1
    item_registry["MOD_126"].base_price = 3500
    item_registry["MOD_126"].volume = 1.1
    item_registry["MOD_126"].mass = 110
    item_registry["MOD_126"].description = "Provides sensor detection capability"

    # MOD_127 - Standard Sensor Array
    item_registry["MOD_127"] = ItemData.new()
    item_registry["MOD_127"].id = "MOD_127"
    item_registry["MOD_127"].name = "Standard Sensor Array"
    item_registry["MOD_127"].category = ItemCategory.MODULE
    item_registry["MOD_127"].tier = 1
    item_registry["MOD_127"].base_price = 4200
    item_registry["MOD_127"].volume = 1.3
    item_registry["MOD_127"].mass = 130
    item_registry["MOD_127"].description = "Provides sensor detection capability"

    # MOD_128 - Small Radar
    item_registry["MOD_128"] = ItemData.new()
    item_registry["MOD_128"].id = "MOD_128"
    item_registry["MOD_128"].name = "Small Radar"
    item_registry["MOD_128"].category = ItemCategory.MODULE
    item_registry["MOD_128"].tier = 1
    item_registry["MOD_128"].base_price = 3200
    item_registry["MOD_128"].volume = 1.0
    item_registry["MOD_128"].mass = 100
    item_registry["MOD_128"].description = "Provides sensor detection capability"

    # MOD_129 - Light Analyser
    item_registry["MOD_129"] = ItemData.new()
    item_registry["MOD_129"].id = "MOD_129"
    item_registry["MOD_129"].name = "Light Analyser"
    item_registry["MOD_129"].category = ItemCategory.MODULE
    item_registry["MOD_129"].tier = 1
    item_registry["MOD_129"].base_price = 3800
    item_registry["MOD_129"].volume = 1.2
    item_registry["MOD_129"].mass = 120
    item_registry["MOD_129"].description = "Provides sensor detection capability"

    # MOD_130 - Basic Signal Booster
    item_registry["MOD_130"] = ItemData.new()
    item_registry["MOD_130"].id = "MOD_130"
    item_registry["MOD_130"].name = "Basic Signal Booster"
    item_registry["MOD_130"].category = ItemCategory.MODULE
    item_registry["MOD_130"].tier = 1
    item_registry["MOD_130"].base_price = 3000
    item_registry["MOD_130"].volume = 0.9
    item_registry["MOD_130"].mass = 90
    item_registry["MOD_130"].description = "Provides sensor detection capability"

    # MOD_131 - Improved Scanner
    item_registry["MOD_131"] = ItemData.new()
    item_registry["MOD_131"].id = "MOD_131"
    item_registry["MOD_131"].name = "Improved Scanner"
    item_registry["MOD_131"].category = ItemCategory.MODULE
    item_registry["MOD_131"].tier = 2
    item_registry["MOD_131"].base_price = 16000
    item_registry["MOD_131"].volume = 4.8
    item_registry["MOD_131"].mass = 480
    item_registry["MOD_131"].description = "Provides sensor detection capability"

    # MOD_132 - Enhanced Sensor Array
    item_registry["MOD_132"] = ItemData.new()
    item_registry["MOD_132"].id = "MOD_132"
    item_registry["MOD_132"].name = "Enhanced Sensor Array"
    item_registry["MOD_132"].category = ItemCategory.MODULE
    item_registry["MOD_132"].tier = 2
    item_registry["MOD_132"].base_price = 19000
    item_registry["MOD_132"].volume = 5.5
    item_registry["MOD_132"].mass = 550
    item_registry["MOD_132"].description = "Provides sensor detection capability"

    # MOD_133 - Medium Radar
    item_registry["MOD_133"] = ItemData.new()
    item_registry["MOD_133"].id = "MOD_133"
    item_registry["MOD_133"].name = "Medium Radar"
    item_registry["MOD_133"].category = ItemCategory.MODULE
    item_registry["MOD_133"].tier = 2
    item_registry["MOD_133"].base_price = 15000
    item_registry["MOD_133"].volume = 4.5
    item_registry["MOD_133"].mass = 450
    item_registry["MOD_133"].description = "Provides sensor detection capability"

    # MOD_134 - Medium Analyser
    item_registry["MOD_134"] = ItemData.new()
    item_registry["MOD_134"].id = "MOD_134"
    item_registry["MOD_134"].name = "Medium Analyser"
    item_registry["MOD_134"].category = ItemCategory.MODULE
    item_registry["MOD_134"].tier = 2
    item_registry["MOD_134"].base_price = 17000
    item_registry["MOD_134"].volume = 5.0
    item_registry["MOD_134"].mass = 500
    item_registry["MOD_134"].description = "Provides sensor detection capability"

    # MOD_135 - Improved Signal Booster
    item_registry["MOD_135"] = ItemData.new()
    item_registry["MOD_135"].id = "MOD_135"
    item_registry["MOD_135"].name = "Improved Signal Booster"
    item_registry["MOD_135"].category = ItemCategory.MODULE
    item_registry["MOD_135"].tier = 2
    item_registry["MOD_135"].base_price = 14000
    item_registry["MOD_135"].volume = 4.2
    item_registry["MOD_135"].mass = 420
    item_registry["MOD_135"].description = "Provides sensor detection capability"

    # MOD_136 - Elite Scanner
    item_registry["MOD_136"] = ItemData.new()
    item_registry["MOD_136"].id = "MOD_136"
    item_registry["MOD_136"].name = "Elite Scanner"
    item_registry["MOD_136"].category = ItemCategory.MODULE
    item_registry["MOD_136"].tier = 3
    item_registry["MOD_136"].base_price = 72000
    item_registry["MOD_136"].volume = 11.0
    item_registry["MOD_136"].mass = 1100
    item_registry["MOD_136"].description = "Provides sensor detection capability"

    # MOD_137 - Combat Sensor Array
    item_registry["MOD_137"] = ItemData.new()
    item_registry["MOD_137"].id = "MOD_137"
    item_registry["MOD_137"].name = "Combat Sensor Array"
    item_registry["MOD_137"].category = ItemCategory.MODULE
    item_registry["MOD_137"].tier = 3
    item_registry["MOD_137"].base_price = 68000
    item_registry["MOD_137"].volume = 9.8
    item_registry["MOD_137"].mass = 980
    item_registry["MOD_137"].description = "Tracks hostile targets in combat"

    # MOD_138 - Tactical Scanner
    item_registry["MOD_138"] = ItemData.new()
    item_registry["MOD_138"].id = "MOD_138"
    item_registry["MOD_138"].name = "Tactical Scanner"
    item_registry["MOD_138"].category = ItemCategory.MODULE
    item_registry["MOD_138"].tier = 3
    item_registry["MOD_138"].base_price = 78000
    item_registry["MOD_138"].volume = 12.0
    item_registry["MOD_138"].mass = 1200
    item_registry["MOD_138"].description = "Provides sensor detection capability"

    # MOD_139 - Heavy Radar
    item_registry["MOD_139"] = ItemData.new()
    item_registry["MOD_139"].id = "MOD_139"
    item_registry["MOD_139"].name = "Heavy Radar"
    item_registry["MOD_139"].category = ItemCategory.MODULE
    item_registry["MOD_139"].tier = 3
    item_registry["MOD_139"].base_price = 70000
    item_registry["MOD_139"].volume = 10.5
    item_registry["MOD_139"].mass = 1050
    item_registry["MOD_139"].description = "Provides sensor detection capability"

    # MOD_140 - Large Analyser
    item_registry["MOD_140"] = ItemData.new()
    item_registry["MOD_140"].id = "MOD_140"
    item_registry["MOD_140"].name = "Large Analyser"
    item_registry["MOD_140"].category = ItemCategory.MODULE
    item_registry["MOD_140"].tier = 3
    item_registry["MOD_140"].base_price = 75000
    item_registry["MOD_140"].volume = 11.5
    item_registry["MOD_140"].mass = 1150
    item_registry["MOD_140"].description = "Provides sensor detection capability"

    # MOD_141 - Elite Signal Booster
    item_registry["MOD_141"] = ItemData.new()
    item_registry["MOD_141"].id = "MOD_141"
    item_registry["MOD_141"].name = "Elite Signal Booster"
    item_registry["MOD_141"].category = ItemCategory.MODULE
    item_registry["MOD_141"].tier = 3
    item_registry["MOD_141"].base_price = 68000
    item_registry["MOD_141"].volume = 10.0
    item_registry["MOD_141"].mass = 1000
    item_registry["MOD_141"].description = "Provides sensor detection capability"

    # MOD_142 - Quantum Scanner Array
    item_registry["MOD_142"] = ItemData.new()
    item_registry["MOD_142"].id = "MOD_142"
    item_registry["MOD_142"].name = "Quantum Scanner Array"
    item_registry["MOD_142"].category = ItemCategory.MODULE
    item_registry["MOD_142"].tier = 3
    item_registry["MOD_142"].base_price = 82000
    item_registry["MOD_142"].volume = 12.5
    item_registry["MOD_142"].mass = 1250
    item_registry["MOD_142"].description = "Provides sensor detection capability"

    # MOD_143 - Quantum Scanner
    item_registry["MOD_143"] = ItemData.new()
    item_registry["MOD_143"].id = "MOD_143"
    item_registry["MOD_143"].name = "Quantum Scanner"
    item_registry["MOD_143"].category = ItemCategory.MODULE
    item_registry["MOD_143"].tier = 4
    item_registry["MOD_143"].base_price = 280000
    item_registry["MOD_143"].volume = 40.0
    item_registry["MOD_143"].mass = 4000
    item_registry["MOD_143"].description = "Provides sensor detection capability"

    # MOD_144 - Capital Sensor Array
    item_registry["MOD_144"] = ItemData.new()
    item_registry["MOD_144"].id = "MOD_144"
    item_registry["MOD_144"].name = "Capital Sensor Array"
    item_registry["MOD_144"].category = ItemCategory.MODULE
    item_registry["MOD_144"].tier = 4
    item_registry["MOD_144"].base_price = 255000
    item_registry["MOD_144"].volume = 36.0
    item_registry["MOD_144"].mass = 3600
    item_registry["MOD_144"].description = "Provides sensor detection capability"

    # MOD_145 - Siege Scanner
    item_registry["MOD_145"] = ItemData.new()
    item_registry["MOD_145"].id = "MOD_145"
    item_registry["MOD_145"].name = "Siege Scanner"
    item_registry["MOD_145"].category = ItemCategory.MODULE
    item_registry["MOD_145"].tier = 4
    item_registry["MOD_145"].base_price = 295000
    item_registry["MOD_145"].volume = 42.0
    item_registry["MOD_145"].mass = 4200
    item_registry["MOD_145"].description = "Provides sensor detection capability"

    # MOD_146 - Capital Radar
    item_registry["MOD_146"] = ItemData.new()
    item_registry["MOD_146"].id = "MOD_146"
    item_registry["MOD_146"].name = "Capital Radar"
    item_registry["MOD_146"].category = ItemCategory.MODULE
    item_registry["MOD_146"].tier = 4
    item_registry["MOD_146"].base_price = 265000
    item_registry["MOD_146"].volume = 38.0
    item_registry["MOD_146"].mass = 3800
    item_registry["MOD_146"].description = "Provides sensor detection capability"

    # MOD_147 - Quantum Signal Booster
    item_registry["MOD_147"] = ItemData.new()
    item_registry["MOD_147"].id = "MOD_147"
    item_registry["MOD_147"].name = "Quantum Signal Booster"
    item_registry["MOD_147"].category = ItemCategory.MODULE
    item_registry["MOD_147"].tier = 4
    item_registry["MOD_147"].base_price = 245000
    item_registry["MOD_147"].volume = 35.0
    item_registry["MOD_147"].mass = 3500
    item_registry["MOD_147"].description = "Provides sensor detection capability"

    # MOD_148 - Titan Scanner
    item_registry["MOD_148"] = ItemData.new()
    item_registry["MOD_148"].id = "MOD_148"
    item_registry["MOD_148"].name = "Titan Scanner"
    item_registry["MOD_148"].category = ItemCategory.MODULE
    item_registry["MOD_148"].tier = 5
    item_registry["MOD_148"].base_price = 1800000
    item_registry["MOD_148"].volume = 160.0
    item_registry["MOD_148"].mass = 16000
    item_registry["MOD_148"].description = "Provides sensor detection capability"

    # MOD_149 - Mega Sensor Array
    item_registry["MOD_149"] = ItemData.new()
    item_registry["MOD_149"].id = "MOD_149"
    item_registry["MOD_149"].name = "Mega Sensor Array"
    item_registry["MOD_149"].category = ItemCategory.MODULE
    item_registry["MOD_149"].tier = 5
    item_registry["MOD_149"].base_price = 1600000
    item_registry["MOD_149"].volume = 140.0
    item_registry["MOD_149"].mass = 14000
    item_registry["MOD_149"].description = "Provides sensor detection capability"

    # MOD_150 - Ultimate Signal Booster
    item_registry["MOD_150"] = ItemData.new()
    item_registry["MOD_150"].id = "MOD_150"
    item_registry["MOD_150"].name = "Ultimate Signal Booster"
    item_registry["MOD_150"].category = ItemCategory.MODULE
    item_registry["MOD_150"].tier = 5
    item_registry["MOD_150"].base_price = 2000000
    item_registry["MOD_150"].volume = 180.0
    item_registry["MOD_150"].mass = 18000
    item_registry["MOD_150"].description = "Provides sensor detection capability"

    # MOD_151 - Basic ECM Jammer
    item_registry["MOD_151"] = ItemData.new()
    item_registry["MOD_151"].id = "MOD_151"
    item_registry["MOD_151"].name = "Basic ECM Jammer"
    item_registry["MOD_151"].category = ItemCategory.MODULE
    item_registry["MOD_151"].tier = 2
    item_registry["MOD_151"].base_price = 12000
    item_registry["MOD_151"].volume = 1.8
    item_registry["MOD_151"].mass = 180
    item_registry["MOD_151"].description = "Disrupts enemy targeting systems"

    # MOD_152 - Standard ECM Suite
    item_registry["MOD_152"] = ItemData.new()
    item_registry["MOD_152"].id = "MOD_152"
    item_registry["MOD_152"].name = "Standard ECM Suite"
    item_registry["MOD_152"].category = ItemCategory.MODULE
    item_registry["MOD_152"].tier = 2
    item_registry["MOD_152"].base_price = 15000
    item_registry["MOD_152"].volume = 2.2
    item_registry["MOD_152"].mass = 220
    item_registry["MOD_152"].description = "Electronic warfare capabilities"

    # MOD_153 - Small Cloaking Device
    item_registry["MOD_153"] = ItemData.new()
    item_registry["MOD_153"].id = "MOD_153"
    item_registry["MOD_153"].name = "Small Cloaking Device"
    item_registry["MOD_153"].category = ItemCategory.MODULE
    item_registry["MOD_153"].tier = 2
    item_registry["MOD_153"].base_price = 28000
    item_registry["MOD_153"].volume = 4.5
    item_registry["MOD_153"].mass = 450
    item_registry["MOD_153"].description = "Electronic warfare capabilities"

    # MOD_154 - Light Dampener
    item_registry["MOD_154"] = ItemData.new()
    item_registry["MOD_154"].id = "MOD_154"
    item_registry["MOD_154"].name = "Light Dampener"
    item_registry["MOD_154"].category = ItemCategory.MODULE
    item_registry["MOD_154"].tier = 2
    item_registry["MOD_154"].base_price = 13000
    item_registry["MOD_154"].volume = 2.0
    item_registry["MOD_154"].mass = 200
    item_registry["MOD_154"].description = "Reduces enemy sensor range"

    # MOD_155 - Basic Target Painter
    item_registry["MOD_155"] = ItemData.new()
    item_registry["MOD_155"].id = "MOD_155"
    item_registry["MOD_155"].name = "Basic Target Painter"
    item_registry["MOD_155"].category = ItemCategory.MODULE
    item_registry["MOD_155"].tier = 2
    item_registry["MOD_155"].base_price = 12500
    item_registry["MOD_155"].volume = 1.9
    item_registry["MOD_155"].mass = 190
    item_registry["MOD_155"].description = "Electronic warfare capabilities"

    # MOD_156 - Improved ECM Jammer
    item_registry["MOD_156"] = ItemData.new()
    item_registry["MOD_156"].id = "MOD_156"
    item_registry["MOD_156"].name = "Improved ECM Jammer"
    item_registry["MOD_156"].category = ItemCategory.MODULE
    item_registry["MOD_156"].tier = 3
    item_registry["MOD_156"].base_price = 65000
    item_registry["MOD_156"].volume = 7.8
    item_registry["MOD_156"].mass = 780
    item_registry["MOD_156"].description = "Disrupts enemy targeting systems"

    # MOD_157 - Enhanced ECM Suite
    item_registry["MOD_157"] = ItemData.new()
    item_registry["MOD_157"].id = "MOD_157"
    item_registry["MOD_157"].name = "Enhanced ECM Suite"
    item_registry["MOD_157"].category = ItemCategory.MODULE
    item_registry["MOD_157"].tier = 3
    item_registry["MOD_157"].base_price = 72000
    item_registry["MOD_157"].volume = 8.5
    item_registry["MOD_157"].mass = 850
    item_registry["MOD_157"].description = "Electronic warfare capabilities"

    # MOD_158 - Medium Cloaking Device
    item_registry["MOD_158"] = ItemData.new()
    item_registry["MOD_158"].id = "MOD_158"
    item_registry["MOD_158"].name = "Medium Cloaking Device"
    item_registry["MOD_158"].category = ItemCategory.MODULE
    item_registry["MOD_158"].tier = 3
    item_registry["MOD_158"].base_price = 78000
    item_registry["MOD_158"].volume = 9.5
    item_registry["MOD_158"].mass = 950
    item_registry["MOD_158"].description = "Electronic warfare capabilities"

    # MOD_159 - Heavy Dampener
    item_registry["MOD_159"] = ItemData.new()
    item_registry["MOD_159"].id = "MOD_159"
    item_registry["MOD_159"].name = "Heavy Dampener"
    item_registry["MOD_159"].category = ItemCategory.MODULE
    item_registry["MOD_159"].tier = 3
    item_registry["MOD_159"].base_price = 68000
    item_registry["MOD_159"].volume = 8.2
    item_registry["MOD_159"].mass = 820
    item_registry["MOD_159"].description = "Reduces enemy sensor range"

    # MOD_160 - Elite Target Painter
    item_registry["MOD_160"] = ItemData.new()
    item_registry["MOD_160"].id = "MOD_160"
    item_registry["MOD_160"].name = "Elite Target Painter"
    item_registry["MOD_160"].category = ItemCategory.MODULE
    item_registry["MOD_160"].tier = 3
    item_registry["MOD_160"].base_price = 66000
    item_registry["MOD_160"].volume = 8.0
    item_registry["MOD_160"].mass = 800
    item_registry["MOD_160"].description = "Electronic warfare capabilities"

    # MOD_161 - Tactical ECM Suite
    item_registry["MOD_161"] = ItemData.new()
    item_registry["MOD_161"].id = "MOD_161"
    item_registry["MOD_161"].name = "Tactical ECM Suite"
    item_registry["MOD_161"].category = ItemCategory.MODULE
    item_registry["MOD_161"].tier = 3
    item_registry["MOD_161"].base_price = 85000
    item_registry["MOD_161"].volume = 11.0
    item_registry["MOD_161"].mass = 1100
    item_registry["MOD_161"].description = "Electronic warfare capabilities"

    # MOD_162 - Warp Disruptor
    item_registry["MOD_162"] = ItemData.new()
    item_registry["MOD_162"].id = "MOD_162"
    item_registry["MOD_162"].name = "Warp Disruptor"
    item_registry["MOD_162"].category = ItemCategory.MODULE
    item_registry["MOD_162"].tier = 3
    item_registry["MOD_162"].base_price = 75000
    item_registry["MOD_162"].volume = 8.8
    item_registry["MOD_162"].mass = 880
    item_registry["MOD_162"].description = "Electronic warfare capabilities"

    # MOD_163 - Sensor Booster
    item_registry["MOD_163"] = ItemData.new()
    item_registry["MOD_163"].id = "MOD_163"
    item_registry["MOD_163"].name = "Sensor Booster"
    item_registry["MOD_163"].category = ItemCategory.MODULE
    item_registry["MOD_163"].tier = 3
    item_registry["MOD_163"].base_price = 70000
    item_registry["MOD_163"].volume = 8.5
    item_registry["MOD_163"].mass = 850
    item_registry["MOD_163"].description = "Electronic warfare capabilities"

    # MOD_164 - Quantum ECM Jammer
    item_registry["MOD_164"] = ItemData.new()
    item_registry["MOD_164"].id = "MOD_164"
    item_registry["MOD_164"].name = "Quantum ECM Jammer"
    item_registry["MOD_164"].category = ItemCategory.MODULE
    item_registry["MOD_164"].tier = 4
    item_registry["MOD_164"].base_price = 270000
    item_registry["MOD_164"].volume = 34.0
    item_registry["MOD_164"].mass = 3400
    item_registry["MOD_164"].description = "Disrupts enemy targeting systems"

    # MOD_165 - Capital ECM Suite
    item_registry["MOD_165"] = ItemData.new()
    item_registry["MOD_165"].id = "MOD_165"
    item_registry["MOD_165"].name = "Capital ECM Suite"
    item_registry["MOD_165"].category = ItemCategory.MODULE
    item_registry["MOD_165"].tier = 4
    item_registry["MOD_165"].base_price = 295000
    item_registry["MOD_165"].volume = 38.0
    item_registry["MOD_165"].mass = 3800
    item_registry["MOD_165"].description = "Electronic warfare capabilities"

    # MOD_166 - Siege Cloaking Device
    item_registry["MOD_166"] = ItemData.new()
    item_registry["MOD_166"].id = "MOD_166"
    item_registry["MOD_166"].name = "Siege Cloaking Device"
    item_registry["MOD_166"].category = ItemCategory.MODULE
    item_registry["MOD_166"].tier = 4
    item_registry["MOD_166"].base_price = 320000
    item_registry["MOD_166"].volume = 42.0
    item_registry["MOD_166"].mass = 4200
    item_registry["MOD_166"].description = "Electronic warfare capabilities"

    # MOD_167 - Quantum Dampener
    item_registry["MOD_167"] = ItemData.new()
    item_registry["MOD_167"].id = "MOD_167"
    item_registry["MOD_167"].name = "Quantum Dampener"
    item_registry["MOD_167"].category = ItemCategory.MODULE
    item_registry["MOD_167"].tier = 4
    item_registry["MOD_167"].base_price = 280000
    item_registry["MOD_167"].volume = 36.0
    item_registry["MOD_167"].mass = 3600
    item_registry["MOD_167"].description = "Reduces enemy sensor range"

    # MOD_168 - Capital Target Painter
    item_registry["MOD_168"] = ItemData.new()
    item_registry["MOD_168"].id = "MOD_168"
    item_registry["MOD_168"].name = "Capital Target Painter"
    item_registry["MOD_168"].category = ItemCategory.MODULE
    item_registry["MOD_168"].tier = 4
    item_registry["MOD_168"].base_price = 275000
    item_registry["MOD_168"].volume = 35.0
    item_registry["MOD_168"].mass = 3500
    item_registry["MOD_168"].description = "Electronic warfare capabilities"

    # MOD_169 - Titan ECM Suite
    item_registry["MOD_169"] = ItemData.new()
    item_registry["MOD_169"].id = "MOD_169"
    item_registry["MOD_169"].name = "Titan ECM Suite"
    item_registry["MOD_169"].category = ItemCategory.MODULE
    item_registry["MOD_169"].tier = 5
    item_registry["MOD_169"].base_price = 1700000
    item_registry["MOD_169"].volume = 150.0
    item_registry["MOD_169"].mass = 15000
    item_registry["MOD_169"].description = "Electronic warfare capabilities"

    # MOD_170 - Mega Cloaking Device
    item_registry["MOD_170"] = ItemData.new()
    item_registry["MOD_170"].id = "MOD_170"
    item_registry["MOD_170"].name = "Mega Cloaking Device"
    item_registry["MOD_170"].category = ItemCategory.MODULE
    item_registry["MOD_170"].tier = 5
    item_registry["MOD_170"].base_price = 1900000
    item_registry["MOD_170"].volume = 170.0
    item_registry["MOD_170"].mass = 17000
    item_registry["MOD_170"].description = "Electronic warfare capabilities"

    # MOD_171 - Ultimate ECM System
    item_registry["MOD_171"] = ItemData.new()
    item_registry["MOD_171"].id = "MOD_171"
    item_registry["MOD_171"].name = "Ultimate ECM System"
    item_registry["MOD_171"].category = ItemCategory.MODULE
    item_registry["MOD_171"].tier = 5
    item_registry["MOD_171"].base_price = 2100000
    item_registry["MOD_171"].volume = 190.0
    item_registry["MOD_171"].mass = 19000
    item_registry["MOD_171"].description = "Electronic warfare capabilities"

    # MOD_172 - Basic Mining Laser
    item_registry["MOD_172"] = ItemData.new()
    item_registry["MOD_172"].id = "MOD_172"
    item_registry["MOD_172"].name = "Basic Mining Laser"
    item_registry["MOD_172"].category = ItemCategory.MODULE
    item_registry["MOD_172"].tier = 2
    item_registry["MOD_172"].base_price = 15000
    item_registry["MOD_172"].volume = 2.5
    item_registry["MOD_172"].mass = 250
    item_registry["MOD_172"].description = "Extracts ore from asteroids"

    # MOD_173 - Standard Mining Laser
    item_registry["MOD_173"] = ItemData.new()
    item_registry["MOD_173"].id = "MOD_173"
    item_registry["MOD_173"].name = "Standard Mining Laser"
    item_registry["MOD_173"].category = ItemCategory.MODULE
    item_registry["MOD_173"].tier = 2
    item_registry["MOD_173"].base_price = 17000
    item_registry["MOD_173"].volume = 2.8
    item_registry["MOD_173"].mass = 280
    item_registry["MOD_173"].description = "Extracts ore from asteroids"

    # MOD_174 - Small Strip Miner
    item_registry["MOD_174"] = ItemData.new()
    item_registry["MOD_174"].id = "MOD_174"
    item_registry["MOD_174"].name = "Small Strip Miner"
    item_registry["MOD_174"].category = ItemCategory.MODULE
    item_registry["MOD_174"].tier = 2
    item_registry["MOD_174"].base_price = 32000
    item_registry["MOD_174"].volume = 5.2
    item_registry["MOD_174"].mass = 520
    item_registry["MOD_174"].description = "Enhances mining operations"

    # MOD_175 - Light Ore Processor
    item_registry["MOD_175"] = ItemData.new()
    item_registry["MOD_175"].id = "MOD_175"
    item_registry["MOD_175"].name = "Light Ore Processor"
    item_registry["MOD_175"].category = ItemCategory.MODULE
    item_registry["MOD_175"].tier = 2
    item_registry["MOD_175"].base_price = 18000
    item_registry["MOD_175"].volume = 3.0
    item_registry["MOD_175"].mass = 300
    item_registry["MOD_175"].description = "Enhances mining operations"

    # MOD_176 - Basic Ice Harvester
    item_registry["MOD_176"] = ItemData.new()
    item_registry["MOD_176"].id = "MOD_176"
    item_registry["MOD_176"].name = "Basic Ice Harvester"
    item_registry["MOD_176"].category = ItemCategory.MODULE
    item_registry["MOD_176"].tier = 2
    item_registry["MOD_176"].base_price = 28000
    item_registry["MOD_176"].volume = 4.8
    item_registry["MOD_176"].mass = 480
    item_registry["MOD_176"].description = "Enhances mining operations"

    # MOD_177 - Improved Mining Laser
    item_registry["MOD_177"] = ItemData.new()
    item_registry["MOD_177"].id = "MOD_177"
    item_registry["MOD_177"].name = "Improved Mining Laser"
    item_registry["MOD_177"].category = ItemCategory.MODULE
    item_registry["MOD_177"].tier = 3
    item_registry["MOD_177"].base_price = 75000
    item_registry["MOD_177"].volume = 9.2
    item_registry["MOD_177"].mass = 920
    item_registry["MOD_177"].description = "Extracts ore from asteroids"

    # MOD_178 - Enhanced Mining Laser
    item_registry["MOD_178"] = ItemData.new()
    item_registry["MOD_178"].id = "MOD_178"
    item_registry["MOD_178"].name = "Enhanced Mining Laser"
    item_registry["MOD_178"].category = ItemCategory.MODULE
    item_registry["MOD_178"].tier = 3
    item_registry["MOD_178"].base_price = 82000
    item_registry["MOD_178"].volume = 10.0
    item_registry["MOD_178"].mass = 1000
    item_registry["MOD_178"].description = "Extracts ore from asteroids"

    # MOD_179 - Medium Strip Miner
    item_registry["MOD_179"] = ItemData.new()
    item_registry["MOD_179"].id = "MOD_179"
    item_registry["MOD_179"].name = "Medium Strip Miner"
    item_registry["MOD_179"].category = ItemCategory.MODULE
    item_registry["MOD_179"].tier = 3
    item_registry["MOD_179"].base_price = 105000
    item_registry["MOD_179"].volume = 14.5
    item_registry["MOD_179"].mass = 1450
    item_registry["MOD_179"].description = "Enhances mining operations"

    # MOD_180 - Heavy Ore Processor
    item_registry["MOD_180"] = ItemData.new()
    item_registry["MOD_180"].id = "MOD_180"
    item_registry["MOD_180"].name = "Heavy Ore Processor"
    item_registry["MOD_180"].category = ItemCategory.MODULE
    item_registry["MOD_180"].tier = 3
    item_registry["MOD_180"].base_price = 78000
    item_registry["MOD_180"].volume = 9.5
    item_registry["MOD_180"].mass = 950
    item_registry["MOD_180"].description = "Enhances mining operations"

    # MOD_181 - Elite Ice Harvester
    item_registry["MOD_181"] = ItemData.new()
    item_registry["MOD_181"].id = "MOD_181"
    item_registry["MOD_181"].name = "Elite Ice Harvester"
    item_registry["MOD_181"].category = ItemCategory.MODULE
    item_registry["MOD_181"].tier = 3
    item_registry["MOD_181"].base_price = 98000
    item_registry["MOD_181"].volume = 13.5
    item_registry["MOD_181"].mass = 1350
    item_registry["MOD_181"].description = "Enhances mining operations"

    # MOD_182 - Deep Core Miner
    item_registry["MOD_182"] = ItemData.new()
    item_registry["MOD_182"].id = "MOD_182"
    item_registry["MOD_182"].name = "Deep Core Miner"
    item_registry["MOD_182"].category = ItemCategory.MODULE
    item_registry["MOD_182"].tier = 3
    item_registry["MOD_182"].base_price = 110000
    item_registry["MOD_182"].volume = 15.0
    item_registry["MOD_182"].mass = 1500
    item_registry["MOD_182"].description = "Enhances mining operations"

    # MOD_183 - Gas Harvester
    item_registry["MOD_183"] = ItemData.new()
    item_registry["MOD_183"].id = "MOD_183"
    item_registry["MOD_183"].name = "Gas Harvester"
    item_registry["MOD_183"].category = ItemCategory.MODULE
    item_registry["MOD_183"].tier = 3
    item_registry["MOD_183"].base_price = 88000
    item_registry["MOD_183"].volume = 11.0
    item_registry["MOD_183"].mass = 1100
    item_registry["MOD_183"].description = "Enhances mining operations"

    # MOD_184 - Quantum Mining Laser
    item_registry["MOD_184"] = ItemData.new()
    item_registry["MOD_184"].id = "MOD_184"
    item_registry["MOD_184"].name = "Quantum Mining Laser"
    item_registry["MOD_184"].category = ItemCategory.MODULE
    item_registry["MOD_184"].tier = 4
    item_registry["MOD_184"].base_price = 310000
    item_registry["MOD_184"].volume = 41.0
    item_registry["MOD_184"].mass = 4100
    item_registry["MOD_184"].description = "Extracts ore from asteroids"

    # MOD_185 - Capital Strip Miner
    item_registry["MOD_185"] = ItemData.new()
    item_registry["MOD_185"].id = "MOD_185"
    item_registry["MOD_185"].name = "Capital Strip Miner"
    item_registry["MOD_185"].category = ItemCategory.MODULE
    item_registry["MOD_185"].tier = 4
    item_registry["MOD_185"].base_price = 385000
    item_registry["MOD_185"].volume = 56.0
    item_registry["MOD_185"].mass = 5600
    item_registry["MOD_185"].description = "Enhances mining operations"

    # MOD_186 - Siege Ore Processor
    item_registry["MOD_186"] = ItemData.new()
    item_registry["MOD_186"].id = "MOD_186"
    item_registry["MOD_186"].name = "Siege Ore Processor"
    item_registry["MOD_186"].category = ItemCategory.MODULE
    item_registry["MOD_186"].tier = 4
    item_registry["MOD_186"].base_price = 325000
    item_registry["MOD_186"].volume = 43.0
    item_registry["MOD_186"].mass = 4300
    item_registry["MOD_186"].description = "Enhances mining operations"

    # MOD_187 - Capital Ice Harvester
    item_registry["MOD_187"] = ItemData.new()
    item_registry["MOD_187"].id = "MOD_187"
    item_registry["MOD_187"].name = "Capital Ice Harvester"
    item_registry["MOD_187"].category = ItemCategory.MODULE
    item_registry["MOD_187"].tier = 4
    item_registry["MOD_187"].base_price = 365000
    item_registry["MOD_187"].volume = 52.0
    item_registry["MOD_187"].mass = 5200
    item_registry["MOD_187"].description = "Enhances mining operations"

    # MOD_188 - Quantum Gas Harvester
    item_registry["MOD_188"] = ItemData.new()
    item_registry["MOD_188"].id = "MOD_188"
    item_registry["MOD_188"].name = "Quantum Gas Harvester"
    item_registry["MOD_188"].category = ItemCategory.MODULE
    item_registry["MOD_188"].tier = 4
    item_registry["MOD_188"].base_price = 340000
    item_registry["MOD_188"].volume = 45.0
    item_registry["MOD_188"].mass = 4500
    item_registry["MOD_188"].description = "Enhances mining operations"

    # MOD_189 - Titan Mining Laser
    item_registry["MOD_189"] = ItemData.new()
    item_registry["MOD_189"].id = "MOD_189"
    item_registry["MOD_189"].name = "Titan Mining Laser"
    item_registry["MOD_189"].category = ItemCategory.MODULE
    item_registry["MOD_189"].tier = 5
    item_registry["MOD_189"].base_price = 1900000
    item_registry["MOD_189"].volume = 180.0
    item_registry["MOD_189"].mass = 18000
    item_registry["MOD_189"].description = "Extracts ore from asteroids"

    # MOD_190 - Mega Strip Miner
    item_registry["MOD_190"] = ItemData.new()
    item_registry["MOD_190"].id = "MOD_190"
    item_registry["MOD_190"].name = "Mega Strip Miner"
    item_registry["MOD_190"].category = ItemCategory.MODULE
    item_registry["MOD_190"].tier = 5
    item_registry["MOD_190"].base_price = 2300000
    item_registry["MOD_190"].volume = 220.0
    item_registry["MOD_190"].mass = 22000
    item_registry["MOD_190"].description = "Enhances mining operations"

    # MOD_191 - Ultimate Ore Processor
    item_registry["MOD_191"] = ItemData.new()
    item_registry["MOD_191"].id = "MOD_191"
    item_registry["MOD_191"].name = "Ultimate Ore Processor"
    item_registry["MOD_191"].category = ItemCategory.MODULE
    item_registry["MOD_191"].tier = 5
    item_registry["MOD_191"].base_price = 2100000
    item_registry["MOD_191"].volume = 200.0
    item_registry["MOD_191"].mass = 20000
    item_registry["MOD_191"].description = "Enhances mining operations"

    # MOD_192 - Anomaly Extractor
    item_registry["MOD_192"] = ItemData.new()
    item_registry["MOD_192"].id = "MOD_192"
    item_registry["MOD_192"].name = "Anomaly Extractor"
    item_registry["MOD_192"].category = ItemCategory.MODULE
    item_registry["MOD_192"].tier = 5
    item_registry["MOD_192"].base_price = 2600000
    item_registry["MOD_192"].volume = 240.0
    item_registry["MOD_192"].mass = 24000
    item_registry["MOD_192"].description = "Enhances mining operations"

    # MOD_193 - Void Harvester
    item_registry["MOD_193"] = ItemData.new()
    item_registry["MOD_193"].id = "MOD_193"
    item_registry["MOD_193"].name = "Void Harvester"
    item_registry["MOD_193"].category = ItemCategory.MODULE
    item_registry["MOD_193"].tier = 5
    item_registry["MOD_193"].base_price = 2400000
    item_registry["MOD_193"].volume = 210.0
    item_registry["MOD_193"].mass = 21000
    item_registry["MOD_193"].description = "Enhances mining operations"

    # MOD_194 - Quantum Refinery Module
    item_registry["MOD_194"] = ItemData.new()
    item_registry["MOD_194"].id = "MOD_194"
    item_registry["MOD_194"].name = "Quantum Refinery Module"
    item_registry["MOD_194"].category = ItemCategory.MODULE
    item_registry["MOD_194"].tier = 5
    item_registry["MOD_194"].base_price = 2800000
    item_registry["MOD_194"].volume = 250.0
    item_registry["MOD_194"].mass = 25000
    item_registry["MOD_194"].description = "Enhances mining operations"

    # MOD_195 - Mining Drone Bay
    item_registry["MOD_195"] = ItemData.new()
    item_registry["MOD_195"].id = "MOD_195"
    item_registry["MOD_195"].name = "Mining Drone Bay"
    item_registry["MOD_195"].category = ItemCategory.MODULE
    item_registry["MOD_195"].tier = 3
    item_registry["MOD_195"].base_price = 92000
    item_registry["MOD_195"].volume = 12.0
    item_registry["MOD_195"].mass = 1200
    item_registry["MOD_195"].description = "Enhances mining operations"

    # MOD_196 - Survey Scanner Module
    item_registry["MOD_196"] = ItemData.new()
    item_registry["MOD_196"].id = "MOD_196"
    item_registry["MOD_196"].name = "Survey Scanner Module"
    item_registry["MOD_196"].category = ItemCategory.MODULE
    item_registry["MOD_196"].tier = 2
    item_registry["MOD_196"].base_price = 24000
    item_registry["MOD_196"].volume = 4.2
    item_registry["MOD_196"].mass = 420
    item_registry["MOD_196"].description = "Enhances mining operations"

    # MOD_197 - Ore Compression Module
    item_registry["MOD_197"] = ItemData.new()
    item_registry["MOD_197"].id = "MOD_197"
    item_registry["MOD_197"].name = "Ore Compression Module"
    item_registry["MOD_197"].category = ItemCategory.MODULE
    item_registry["MOD_197"].tier = 3
    item_registry["MOD_197"].base_price = 100000
    item_registry["MOD_197"].volume = 14.0
    item_registry["MOD_197"].mass = 1400
    item_registry["MOD_197"].description = "Enhances mining operations"

    # MOD_198 - Mining Foreman Link
    item_registry["MOD_198"] = ItemData.new()
    item_registry["MOD_198"].id = "MOD_198"
    item_registry["MOD_198"].name = "Mining Foreman Link"
    item_registry["MOD_198"].category = ItemCategory.MODULE
    item_registry["MOD_198"].tier = 4
    item_registry["MOD_198"].base_price = 305000
    item_registry["MOD_198"].volume = 39.0
    item_registry["MOD_198"].mass = 3900
    item_registry["MOD_198"].description = "Enhances mining operations"

    # MOD_199 - Industrial Core
    item_registry["MOD_199"] = ItemData.new()
    item_registry["MOD_199"].id = "MOD_199"
    item_registry["MOD_199"].name = "Industrial Core"
    item_registry["MOD_199"].category = ItemCategory.MODULE
    item_registry["MOD_199"].tier = 4
    item_registry["MOD_199"].base_price = 375000
    item_registry["MOD_199"].volume = 54.0
    item_registry["MOD_199"].mass = 5400
    item_registry["MOD_199"].description = "Enhances mining operations"

    # MOD_200 - Mining Command Burst
    item_registry["MOD_200"] = ItemData.new()
    item_registry["MOD_200"].id = "MOD_200"
    item_registry["MOD_200"].name = "Mining Command Burst"
    item_registry["MOD_200"].category = ItemCategory.MODULE
    item_registry["MOD_200"].tier = 5
    item_registry["MOD_200"].base_price = 2000000
    item_registry["MOD_200"].volume = 190.0
    item_registry["MOD_200"].mass = 19000
    item_registry["MOD_200"].description = "Enhances mining operations"

    # MOD_201 - Basic Command Center
    item_registry["MOD_201"] = ItemData.new()
    item_registry["MOD_201"].id = "MOD_201"
    item_registry["MOD_201"].name = "Basic Command Center"
    item_registry["MOD_201"].category = ItemCategory.MODULE
    item_registry["MOD_201"].tier = 2
    item_registry["MOD_201"].base_price = 32000
    item_registry["MOD_201"].volume = 5.5
    item_registry["MOD_201"].mass = 550
    item_registry["MOD_201"].description = "Fleet command and coordination"

    # MOD_202 - Standard Fleet Link
    item_registry["MOD_202"] = ItemData.new()
    item_registry["MOD_202"].id = "MOD_202"
    item_registry["MOD_202"].name = "Standard Fleet Link"
    item_registry["MOD_202"].category = ItemCategory.MODULE
    item_registry["MOD_202"].tier = 2
    item_registry["MOD_202"].base_price = 28000
    item_registry["MOD_202"].volume = 5.0
    item_registry["MOD_202"].mass = 500
    item_registry["MOD_202"].description = "Boosts nearby friendly ships"

    # MOD_203 - Small Command Burst
    item_registry["MOD_203"] = ItemData.new()
    item_registry["MOD_203"].id = "MOD_203"
    item_registry["MOD_203"].name = "Small Command Burst"
    item_registry["MOD_203"].category = ItemCategory.MODULE
    item_registry["MOD_203"].tier = 2
    item_registry["MOD_203"].base_price = 22000
    item_registry["MOD_203"].volume = 3.8
    item_registry["MOD_203"].mass = 380
    item_registry["MOD_203"].description = "Provides temporary fleet bonuses"

    # MOD_204 - Light Wing Commander
    item_registry["MOD_204"] = ItemData.new()
    item_registry["MOD_204"].id = "MOD_204"
    item_registry["MOD_204"].name = "Light Wing Commander"
    item_registry["MOD_204"].category = ItemCategory.MODULE
    item_registry["MOD_204"].tier = 2
    item_registry["MOD_204"].base_price = 30000
    item_registry["MOD_204"].volume = 5.2
    item_registry["MOD_204"].mass = 520
    item_registry["MOD_204"].description = "Fleet command and coordination"

    # MOD_205 - Basic Tactical Link
    item_registry["MOD_205"] = ItemData.new()
    item_registry["MOD_205"].id = "MOD_205"
    item_registry["MOD_205"].name = "Basic Tactical Link"
    item_registry["MOD_205"].category = ItemCategory.MODULE
    item_registry["MOD_205"].tier = 2
    item_registry["MOD_205"].base_price = 26000
    item_registry["MOD_205"].volume = 4.8
    item_registry["MOD_205"].mass = 480
    item_registry["MOD_205"].description = "Boosts nearby friendly ships"

    # MOD_206 - Improved Command Center
    item_registry["MOD_206"] = ItemData.new()
    item_registry["MOD_206"].id = "MOD_206"
    item_registry["MOD_206"].name = "Improved Command Center"
    item_registry["MOD_206"].category = ItemCategory.MODULE
    item_registry["MOD_206"].tier = 3
    item_registry["MOD_206"].base_price = 95000
    item_registry["MOD_206"].volume = 13.5
    item_registry["MOD_206"].mass = 1350
    item_registry["MOD_206"].description = "Fleet command and coordination"

    # MOD_207 - Enhanced Fleet Link
    item_registry["MOD_207"] = ItemData.new()
    item_registry["MOD_207"].id = "MOD_207"
    item_registry["MOD_207"].name = "Enhanced Fleet Link"
    item_registry["MOD_207"].category = ItemCategory.MODULE
    item_registry["MOD_207"].tier = 3
    item_registry["MOD_207"].base_price = 88000
    item_registry["MOD_207"].volume = 12.0
    item_registry["MOD_207"].mass = 1200
    item_registry["MOD_207"].description = "Boosts nearby friendly ships"

    # MOD_208 - Medium Command Burst
    item_registry["MOD_208"] = ItemData.new()
    item_registry["MOD_208"].id = "MOD_208"
    item_registry["MOD_208"].name = "Medium Command Burst"
    item_registry["MOD_208"].category = ItemCategory.MODULE
    item_registry["MOD_208"].tier = 3
    item_registry["MOD_208"].base_price = 82000
    item_registry["MOD_208"].volume = 11.0
    item_registry["MOD_208"].mass = 1100
    item_registry["MOD_208"].description = "Provides temporary fleet bonuses"

    # MOD_209 - Heavy Wing Commander
    item_registry["MOD_209"] = ItemData.new()
    item_registry["MOD_209"].id = "MOD_209"
    item_registry["MOD_209"].name = "Heavy Wing Commander"
    item_registry["MOD_209"].category = ItemCategory.MODULE
    item_registry["MOD_209"].tier = 3
    item_registry["MOD_209"].base_price = 98000
    item_registry["MOD_209"].volume = 14.0
    item_registry["MOD_209"].mass = 1400
    item_registry["MOD_209"].description = "Fleet command and coordination"

    # MOD_210 - Elite Tactical Link
    item_registry["MOD_210"] = ItemData.new()
    item_registry["MOD_210"].id = "MOD_210"
    item_registry["MOD_210"].name = "Elite Tactical Link"
    item_registry["MOD_210"].category = ItemCategory.MODULE
    item_registry["MOD_210"].tier = 3
    item_registry["MOD_210"].base_price = 90000
    item_registry["MOD_210"].volume = 12.5
    item_registry["MOD_210"].mass = 1250
    item_registry["MOD_210"].description = "Boosts nearby friendly ships"

    # MOD_211 - Fleet Command Module
    item_registry["MOD_211"] = ItemData.new()
    item_registry["MOD_211"].id = "MOD_211"
    item_registry["MOD_211"].name = "Fleet Command Module"
    item_registry["MOD_211"].category = ItemCategory.MODULE
    item_registry["MOD_211"].tier = 3
    item_registry["MOD_211"].base_price = 105000
    item_registry["MOD_211"].volume = 15.0
    item_registry["MOD_211"].mass = 1500
    item_registry["MOD_211"].description = "Fleet command and coordination"

    # MOD_212 - Squadron Leader Module
    item_registry["MOD_212"] = ItemData.new()
    item_registry["MOD_212"].id = "MOD_212"
    item_registry["MOD_212"].name = "Squadron Leader Module"
    item_registry["MOD_212"].category = ItemCategory.MODULE
    item_registry["MOD_212"].tier = 3
    item_registry["MOD_212"].base_price = 92000
    item_registry["MOD_212"].volume = 13.0
    item_registry["MOD_212"].mass = 1300
    item_registry["MOD_212"].description = "Fleet command and coordination"

    # MOD_213 - Quantum Command Center
    item_registry["MOD_213"] = ItemData.new()
    item_registry["MOD_213"].id = "MOD_213"
    item_registry["MOD_213"].name = "Quantum Command Center"
    item_registry["MOD_213"].category = ItemCategory.MODULE
    item_registry["MOD_213"].tier = 4
    item_registry["MOD_213"].base_price = 360000
    item_registry["MOD_213"].volume = 50.0
    item_registry["MOD_213"].mass = 5000
    item_registry["MOD_213"].description = "Fleet command and coordination"

    # MOD_214 - Capital Fleet Link
    item_registry["MOD_214"] = ItemData.new()
    item_registry["MOD_214"].id = "MOD_214"
    item_registry["MOD_214"].name = "Capital Fleet Link"
    item_registry["MOD_214"].category = ItemCategory.MODULE
    item_registry["MOD_214"].tier = 4
    item_registry["MOD_214"].base_price = 330000
    item_registry["MOD_214"].volume = 45.0
    item_registry["MOD_214"].mass = 4500
    item_registry["MOD_214"].description = "Boosts nearby friendly ships"

    # MOD_215 - Siege Command Burst
    item_registry["MOD_215"] = ItemData.new()
    item_registry["MOD_215"].id = "MOD_215"
    item_registry["MOD_215"].name = "Siege Command Burst"
    item_registry["MOD_215"].category = ItemCategory.MODULE
    item_registry["MOD_215"].tier = 4
    item_registry["MOD_215"].base_price = 310000
    item_registry["MOD_215"].volume = 42.0
    item_registry["MOD_215"].mass = 4200
    item_registry["MOD_215"].description = "Provides temporary fleet bonuses"

    # MOD_216 - Capital Wing Commander
    item_registry["MOD_216"] = ItemData.new()
    item_registry["MOD_216"].id = "MOD_216"
    item_registry["MOD_216"].name = "Capital Wing Commander"
    item_registry["MOD_216"].category = ItemCategory.MODULE
    item_registry["MOD_216"].tier = 4
    item_registry["MOD_216"].base_price = 370000
    item_registry["MOD_216"].volume = 52.0
    item_registry["MOD_216"].mass = 5200
    item_registry["MOD_216"].description = "Fleet command and coordination"

    # MOD_217 - Quantum Tactical Link
    item_registry["MOD_217"] = ItemData.new()
    item_registry["MOD_217"].id = "MOD_217"
    item_registry["MOD_217"].name = "Quantum Tactical Link"
    item_registry["MOD_217"].category = ItemCategory.MODULE
    item_registry["MOD_217"].tier = 4
    item_registry["MOD_217"].base_price = 345000
    item_registry["MOD_217"].volume = 48.0
    item_registry["MOD_217"].mass = 4800
    item_registry["MOD_217"].description = "Boosts nearby friendly ships"

    # MOD_218 - Titan Command Center
    item_registry["MOD_218"] = ItemData.new()
    item_registry["MOD_218"].id = "MOD_218"
    item_registry["MOD_218"].name = "Titan Command Center"
    item_registry["MOD_218"].category = ItemCategory.MODULE
    item_registry["MOD_218"].tier = 5
    item_registry["MOD_218"].base_price = 2100000
    item_registry["MOD_218"].volume = 200.0
    item_registry["MOD_218"].mass = 20000
    item_registry["MOD_218"].description = "Fleet command and coordination"

    # MOD_219 - Mega Fleet Link
    item_registry["MOD_219"] = ItemData.new()
    item_registry["MOD_219"].id = "MOD_219"
    item_registry["MOD_219"].name = "Mega Fleet Link"
    item_registry["MOD_219"].category = ItemCategory.MODULE
    item_registry["MOD_219"].tier = 5
    item_registry["MOD_219"].base_price = 1900000
    item_registry["MOD_219"].volume = 180.0
    item_registry["MOD_219"].mass = 18000
    item_registry["MOD_219"].description = "Boosts nearby friendly ships"

    # MOD_220 - Ultimate Command Burst
    item_registry["MOD_220"] = ItemData.new()
    item_registry["MOD_220"].id = "MOD_220"
    item_registry["MOD_220"].name = "Ultimate Command Burst"
    item_registry["MOD_220"].category = ItemCategory.MODULE
    item_registry["MOD_220"].tier = 5
    item_registry["MOD_220"].base_price = 2400000
    item_registry["MOD_220"].volume = 220.0
    item_registry["MOD_220"].mass = 22000
    item_registry["MOD_220"].description = "Provides temporary fleet bonuses"

    # MOD_221 - Strategic Command Suite
    item_registry["MOD_221"] = ItemData.new()
    item_registry["MOD_221"].id = "MOD_221"
    item_registry["MOD_221"].name = "Strategic Command Suite"
    item_registry["MOD_221"].category = ItemCategory.MODULE
    item_registry["MOD_221"].tier = 5
    item_registry["MOD_221"].base_price = 2600000
    item_registry["MOD_221"].volume = 240.0
    item_registry["MOD_221"].mass = 24000
    item_registry["MOD_221"].description = "Fleet command and coordination"

    # MOD_222 - Armada Controller
    item_registry["MOD_222"] = ItemData.new()
    item_registry["MOD_222"].id = "MOD_222"
    item_registry["MOD_222"].name = "Armada Controller"
    item_registry["MOD_222"].category = ItemCategory.MODULE
    item_registry["MOD_222"].tier = 5
    item_registry["MOD_222"].base_price = 2300000
    item_registry["MOD_222"].volume = 210.0
    item_registry["MOD_222"].mass = 21000
    item_registry["MOD_222"].description = "Fleet command and coordination"

    # MOD_223 - Basic Medical Bay
    item_registry["MOD_223"] = ItemData.new()
    item_registry["MOD_223"].id = "MOD_223"
    item_registry["MOD_223"].name = "Basic Medical Bay"
    item_registry["MOD_223"].category = ItemCategory.MODULE
    item_registry["MOD_223"].tier = 1
    item_registry["MOD_223"].base_price = 5500
    item_registry["MOD_223"].volume = 2.0
    item_registry["MOD_223"].mass = 200
    item_registry["MOD_223"].description = "Treats crew injuries and illness"

    # MOD_224 - Standard Infirmary
    item_registry["MOD_224"] = ItemData.new()
    item_registry["MOD_224"].id = "MOD_224"
    item_registry["MOD_224"].name = "Standard Infirmary"
    item_registry["MOD_224"].category = ItemCategory.MODULE
    item_registry["MOD_224"].tier = 1
    item_registry["MOD_224"].base_price = 12000
    item_registry["MOD_224"].volume = 4.2
    item_registry["MOD_224"].mass = 420
    item_registry["MOD_224"].description = "Provides medical support"

    # MOD_225 - Small Clone Bay
    item_registry["MOD_225"] = ItemData.new()
    item_registry["MOD_225"].id = "MOD_225"
    item_registry["MOD_225"].name = "Small Clone Bay"
    item_registry["MOD_225"].category = ItemCategory.MODULE
    item_registry["MOD_225"].tier = 2
    item_registry["MOD_225"].base_price = 28000
    item_registry["MOD_225"].volume = 6.5
    item_registry["MOD_225"].mass = 650
    item_registry["MOD_225"].description = "Treats crew injuries and illness"

    # MOD_226 - Light Life Support
    item_registry["MOD_226"] = ItemData.new()
    item_registry["MOD_226"].id = "MOD_226"
    item_registry["MOD_226"].name = "Light Life Support"
    item_registry["MOD_226"].category = ItemCategory.MODULE
    item_registry["MOD_226"].tier = 1
    item_registry["MOD_226"].base_price = 5000
    item_registry["MOD_226"].volume = 1.8
    item_registry["MOD_226"].mass = 180
    item_registry["MOD_226"].description = "Provides medical support"

    # MOD_227 - Basic Crew Quarters
    item_registry["MOD_227"] = ItemData.new()
    item_registry["MOD_227"].id = "MOD_227"
    item_registry["MOD_227"].name = "Basic Crew Quarters"
    item_registry["MOD_227"].category = ItemCategory.MODULE
    item_registry["MOD_227"].tier = 1
    item_registry["MOD_227"].base_price = 10000
    item_registry["MOD_227"].volume = 3.5
    item_registry["MOD_227"].mass = 350
    item_registry["MOD_227"].description = "Provides medical support"

    # MOD_228 - Improved Medical Bay
    item_registry["MOD_228"] = ItemData.new()
    item_registry["MOD_228"].id = "MOD_228"
    item_registry["MOD_228"].name = "Improved Medical Bay"
    item_registry["MOD_228"].category = ItemCategory.MODULE
    item_registry["MOD_228"].tier = 2
    item_registry["MOD_228"].base_price = 35000
    item_registry["MOD_228"].volume = 7.2
    item_registry["MOD_228"].mass = 720
    item_registry["MOD_228"].description = "Treats crew injuries and illness"

    # MOD_229 - Enhanced Infirmary
    item_registry["MOD_229"] = ItemData.new()
    item_registry["MOD_229"].id = "MOD_229"
    item_registry["MOD_229"].name = "Enhanced Infirmary"
    item_registry["MOD_229"].category = ItemCategory.MODULE
    item_registry["MOD_229"].tier = 2
    item_registry["MOD_229"].base_price = 40000
    item_registry["MOD_229"].volume = 8.0
    item_registry["MOD_229"].mass = 800
    item_registry["MOD_229"].description = "Provides medical support"

    # MOD_230 - Medium Clone Bay
    item_registry["MOD_230"] = ItemData.new()
    item_registry["MOD_230"].id = "MOD_230"
    item_registry["MOD_230"].name = "Medium Clone Bay"
    item_registry["MOD_230"].category = ItemCategory.MODULE
    item_registry["MOD_230"].tier = 2
    item_registry["MOD_230"].base_price = 55000
    item_registry["MOD_230"].volume = 11.0
    item_registry["MOD_230"].mass = 1100
    item_registry["MOD_230"].description = "Treats crew injuries and illness"

    # MOD_231 - Improved Life Support
    item_registry["MOD_231"] = ItemData.new()
    item_registry["MOD_231"].id = "MOD_231"
    item_registry["MOD_231"].name = "Improved Life Support"
    item_registry["MOD_231"].category = ItemCategory.MODULE
    item_registry["MOD_231"].tier = 2
    item_registry["MOD_231"].base_price = 32000
    item_registry["MOD_231"].volume = 6.8
    item_registry["MOD_231"].mass = 680
    item_registry["MOD_231"].description = "Provides medical support"

    # MOD_232 - Enhanced Crew Quarters
    item_registry["MOD_232"] = ItemData.new()
    item_registry["MOD_232"].id = "MOD_232"
    item_registry["MOD_232"].name = "Enhanced Crew Quarters"
    item_registry["MOD_232"].category = ItemCategory.MODULE
    item_registry["MOD_232"].tier = 2
    item_registry["MOD_232"].base_price = 38000
    item_registry["MOD_232"].volume = 7.5
    item_registry["MOD_232"].mass = 750
    item_registry["MOD_232"].description = "Provides medical support"

    # MOD_233 - Elite Medical Bay
    item_registry["MOD_233"] = ItemData.new()
    item_registry["MOD_233"].id = "MOD_233"
    item_registry["MOD_233"].name = "Elite Medical Bay"
    item_registry["MOD_233"].category = ItemCategory.MODULE
    item_registry["MOD_233"].tier = 3
    item_registry["MOD_233"].base_price = 105000
    item_registry["MOD_233"].volume = 15.0
    item_registry["MOD_233"].mass = 1500
    item_registry["MOD_233"].description = "Treats crew injuries and illness"

    # MOD_234 - Combat Infirmary
    item_registry["MOD_234"] = ItemData.new()
    item_registry["MOD_234"].id = "MOD_234"
    item_registry["MOD_234"].name = "Combat Infirmary"
    item_registry["MOD_234"].category = ItemCategory.MODULE
    item_registry["MOD_234"].tier = 3
    item_registry["MOD_234"].base_price = 95000
    item_registry["MOD_234"].volume = 13.5
    item_registry["MOD_234"].mass = 1350
    item_registry["MOD_234"].description = "Provides medical support"

    # MOD_235 - Large Clone Bay
    item_registry["MOD_235"] = ItemData.new()
    item_registry["MOD_235"].id = "MOD_235"
    item_registry["MOD_235"].name = "Large Clone Bay"
    item_registry["MOD_235"].category = ItemCategory.MODULE
    item_registry["MOD_235"].tier = 3
    item_registry["MOD_235"].base_price = 125000
    item_registry["MOD_235"].volume = 18.0
    item_registry["MOD_235"].mass = 1800
    item_registry["MOD_235"].description = "Treats crew injuries and illness"

    # MOD_236 - Heavy Life Support
    item_registry["MOD_236"] = ItemData.new()
    item_registry["MOD_236"].id = "MOD_236"
    item_registry["MOD_236"].name = "Heavy Life Support"
    item_registry["MOD_236"].category = ItemCategory.MODULE
    item_registry["MOD_236"].tier = 3
    item_registry["MOD_236"].base_price = 98000
    item_registry["MOD_236"].volume = 14.0
    item_registry["MOD_236"].mass = 1400
    item_registry["MOD_236"].description = "Provides medical support"

    # MOD_237 - Elite Crew Quarters
    item_registry["MOD_237"] = ItemData.new()
    item_registry["MOD_237"].id = "MOD_237"
    item_registry["MOD_237"].name = "Elite Crew Quarters"
    item_registry["MOD_237"].category = ItemCategory.MODULE
    item_registry["MOD_237"].tier = 3
    item_registry["MOD_237"].base_price = 110000
    item_registry["MOD_237"].volume = 16.0
    item_registry["MOD_237"].mass = 1600
    item_registry["MOD_237"].description = "Provides medical support"

    # MOD_238 - Quantum Medical Bay
    item_registry["MOD_238"] = ItemData.new()
    item_registry["MOD_238"].id = "MOD_238"
    item_registry["MOD_238"].name = "Quantum Medical Bay"
    item_registry["MOD_238"].category = ItemCategory.MODULE
    item_registry["MOD_238"].tier = 4
    item_registry["MOD_238"].base_price = 380000
    item_registry["MOD_238"].volume = 55.0
    item_registry["MOD_238"].mass = 5500
    item_registry["MOD_238"].description = "Treats crew injuries and illness"

    # MOD_239 - Capital Clone Bay
    item_registry["MOD_239"] = ItemData.new()
    item_registry["MOD_239"].id = "MOD_239"
    item_registry["MOD_239"].name = "Capital Clone Bay"
    item_registry["MOD_239"].category = ItemCategory.MODULE
    item_registry["MOD_239"].tier = 4
    item_registry["MOD_239"].base_price = 425000
    item_registry["MOD_239"].volume = 62.0
    item_registry["MOD_239"].mass = 6200
    item_registry["MOD_239"].description = "Treats crew injuries and illness"

    # MOD_240 - Siege Life Support
    item_registry["MOD_240"] = ItemData.new()
    item_registry["MOD_240"].id = "MOD_240"
    item_registry["MOD_240"].name = "Siege Life Support"
    item_registry["MOD_240"].category = ItemCategory.MODULE
    item_registry["MOD_240"].tier = 4
    item_registry["MOD_240"].base_price = 360000
    item_registry["MOD_240"].volume = 50.0
    item_registry["MOD_240"].mass = 5000
    item_registry["MOD_240"].description = "Provides medical support"

    # MOD_241 - Capital Crew Quarters
    item_registry["MOD_241"] = ItemData.new()
    item_registry["MOD_241"].id = "MOD_241"
    item_registry["MOD_241"].name = "Capital Crew Quarters"
    item_registry["MOD_241"].category = ItemCategory.MODULE
    item_registry["MOD_241"].tier = 4
    item_registry["MOD_241"].base_price = 405000
    item_registry["MOD_241"].volume = 58.0
    item_registry["MOD_241"].mass = 5800
    item_registry["MOD_241"].description = "Provides medical support"

    # MOD_242 - Titan Medical Complex
    item_registry["MOD_242"] = ItemData.new()
    item_registry["MOD_242"].id = "MOD_242"
    item_registry["MOD_242"].name = "Titan Medical Complex"
    item_registry["MOD_242"].category = ItemCategory.MODULE
    item_registry["MOD_242"].tier = 5
    item_registry["MOD_242"].base_price = 2400000
    item_registry["MOD_242"].volume = 220.0
    item_registry["MOD_242"].mass = 22000
    item_registry["MOD_242"].description = "Provides medical support"

    # MOD_243 - Mega Clone Facility
    item_registry["MOD_243"] = ItemData.new()
    item_registry["MOD_243"].id = "MOD_243"
    item_registry["MOD_243"].name = "Mega Clone Facility"
    item_registry["MOD_243"].category = ItemCategory.MODULE
    item_registry["MOD_243"].tier = 5
    item_registry["MOD_243"].base_price = 2700000
    item_registry["MOD_243"].volume = 250.0
    item_registry["MOD_243"].mass = 25000
    item_registry["MOD_243"].description = "Stores crew clone backups"

    # MOD_244 - Ultimate Life Support
    item_registry["MOD_244"] = ItemData.new()
    item_registry["MOD_244"].id = "MOD_244"
    item_registry["MOD_244"].name = "Ultimate Life Support"
    item_registry["MOD_244"].category = ItemCategory.MODULE
    item_registry["MOD_244"].tier = 5
    item_registry["MOD_244"].base_price = 2500000
    item_registry["MOD_244"].volume = 230.0
    item_registry["MOD_244"].mass = 23000
    item_registry["MOD_244"].description = "Provides medical support"

    # MOD_245 - Mega Crew Complex
    item_registry["MOD_245"] = ItemData.new()
    item_registry["MOD_245"].id = "MOD_245"
    item_registry["MOD_245"].name = "Mega Crew Complex"
    item_registry["MOD_245"].category = ItemCategory.MODULE
    item_registry["MOD_245"].tier = 5
    item_registry["MOD_245"].base_price = 2600000
    item_registry["MOD_245"].volume = 240.0
    item_registry["MOD_245"].mass = 24000
    item_registry["MOD_245"].description = "Provides medical support"

    # MOD_246 - Research Laboratory
    item_registry["MOD_246"] = ItemData.new()
    item_registry["MOD_246"].id = "MOD_246"
    item_registry["MOD_246"].name = "Research Laboratory"
    item_registry["MOD_246"].category = ItemCategory.MODULE
    item_registry["MOD_246"].tier = 3
    item_registry["MOD_246"].base_price = 120000
    item_registry["MOD_246"].volume = 17.0
    item_registry["MOD_246"].mass = 1700
    item_registry["MOD_246"].description = "Provides medical support"

    # MOD_247 - Cryogenic Storage
    item_registry["MOD_247"] = ItemData.new()
    item_registry["MOD_247"].id = "MOD_247"
    item_registry["MOD_247"].name = "Cryogenic Storage"
    item_registry["MOD_247"].category = ItemCategory.MODULE
    item_registry["MOD_247"].tier = 3
    item_registry["MOD_247"].base_price = 88000
    item_registry["MOD_247"].volume = 12.5
    item_registry["MOD_247"].mass = 1250
    item_registry["MOD_247"].description = "Provides medical support"

    # MOD_248 - Emergency Medical System
    item_registry["MOD_248"] = ItemData.new()
    item_registry["MOD_248"].id = "MOD_248"
    item_registry["MOD_248"].name = "Emergency Medical System"
    item_registry["MOD_248"].category = ItemCategory.MODULE
    item_registry["MOD_248"].tier = 2
    item_registry["MOD_248"].base_price = 30000
    item_registry["MOD_248"].volume = 5.8
    item_registry["MOD_248"].mass = 580
    item_registry["MOD_248"].description = "Provides medical support"

    # MOD_249 - Genetic Modifier Bay
    item_registry["MOD_249"] = ItemData.new()
    item_registry["MOD_249"].id = "MOD_249"
    item_registry["MOD_249"].name = "Genetic Modifier Bay"
    item_registry["MOD_249"].category = ItemCategory.MODULE
    item_registry["MOD_249"].tier = 4
    item_registry["MOD_249"].base_price = 335000
    item_registry["MOD_249"].volume = 46.0
    item_registry["MOD_249"].mass = 4600
    item_registry["MOD_249"].description = "Treats crew injuries and illness"

    # MOD_250 - Neural Interface Center
    item_registry["MOD_250"] = ItemData.new()
    item_registry["MOD_250"].id = "MOD_250"
    item_registry["MOD_250"].name = "Neural Interface Center"
    item_registry["MOD_250"].category = ItemCategory.MODULE
    item_registry["MOD_250"].tier = 5
    item_registry["MOD_250"].base_price = 2200000
    item_registry["MOD_250"].volume = 200.0
    item_registry["MOD_250"].mass = 20000
    item_registry["MOD_250"].description = "Provides medical support"

    # MOD_251 - Basic Repair Module
    item_registry["MOD_251"] = ItemData.new()
    item_registry["MOD_251"].id = "MOD_251"
    item_registry["MOD_251"].name = "Basic Repair Module"
    item_registry["MOD_251"].category = ItemCategory.MODULE
    item_registry["MOD_251"].tier = 2
    item_registry["MOD_251"].base_price = 26000
    item_registry["MOD_251"].volume = 4.8
    item_registry["MOD_251"].mass = 480
    item_registry["MOD_251"].description = "Utility module"

    # MOD_252 - Standard Tractor Beam
    item_registry["MOD_252"] = ItemData.new()
    item_registry["MOD_252"].id = "MOD_252"
    item_registry["MOD_252"].name = "Standard Tractor Beam"
    item_registry["MOD_252"].category = ItemCategory.MODULE
    item_registry["MOD_252"].tier = 2
    item_registry["MOD_252"].base_price = 18000
    item_registry["MOD_252"].volume = 3.2
    item_registry["MOD_252"].mass = 320
    item_registry["MOD_252"].description = "Utility module"

    # MOD_253 - Small Salvager
    item_registry["MOD_253"] = ItemData.new()
    item_registry["MOD_253"].id = "MOD_253"
    item_registry["MOD_253"].name = "Small Salvager"
    item_registry["MOD_253"].category = ItemCategory.MODULE
    item_registry["MOD_253"].tier = 2
    item_registry["MOD_253"].base_price = 24000
    item_registry["MOD_253"].volume = 4.2
    item_registry["MOD_253"].mass = 420
    item_registry["MOD_253"].description = "Utility module"

    # MOD_254 - Light Probe Launcher
    item_registry["MOD_254"] = ItemData.new()
    item_registry["MOD_254"].id = "MOD_254"
    item_registry["MOD_254"].name = "Light Probe Launcher"
    item_registry["MOD_254"].category = ItemCategory.MODULE
    item_registry["MOD_254"].tier = 2
    item_registry["MOD_254"].base_price = 15000
    item_registry["MOD_254"].volume = 2.8
    item_registry["MOD_254"].mass = 280
    item_registry["MOD_254"].description = "Utility module"

    # MOD_255 - Basic Remote Repairer
    item_registry["MOD_255"] = ItemData.new()
    item_registry["MOD_255"].id = "MOD_255"
    item_registry["MOD_255"].name = "Basic Remote Repairer"
    item_registry["MOD_255"].category = ItemCategory.MODULE
    item_registry["MOD_255"].tier = 2
    item_registry["MOD_255"].base_price = 25000
    item_registry["MOD_255"].volume = 4.5
    item_registry["MOD_255"].mass = 450
    item_registry["MOD_255"].description = "Utility module"

    # MOD_256 - Improved Repair Module
    item_registry["MOD_256"] = ItemData.new()
    item_registry["MOD_256"].id = "MOD_256"
    item_registry["MOD_256"].name = "Improved Repair Module"
    item_registry["MOD_256"].category = ItemCategory.MODULE
    item_registry["MOD_256"].tier = 3
    item_registry["MOD_256"].base_price = 88000
    item_registry["MOD_256"].volume = 12.5
    item_registry["MOD_256"].mass = 1250
    item_registry["MOD_256"].description = "Utility module"

    # MOD_257 - Enhanced Tractor Beam
    item_registry["MOD_257"] = ItemData.new()
    item_registry["MOD_257"].id = "MOD_257"
    item_registry["MOD_257"].name = "Enhanced Tractor Beam"
    item_registry["MOD_257"].category = ItemCategory.MODULE
    item_registry["MOD_257"].tier = 3
    item_registry["MOD_257"].base_price = 72000
    item_registry["MOD_257"].volume = 9.5
    item_registry["MOD_257"].mass = 950
    item_registry["MOD_257"].description = "Utility module"

    # MOD_258 - Medium Salvager
    item_registry["MOD_258"] = ItemData.new()
    item_registry["MOD_258"].id = "MOD_258"
    item_registry["MOD_258"].name = "Medium Salvager"
    item_registry["MOD_258"].category = ItemCategory.MODULE
    item_registry["MOD_258"].tier = 3
    item_registry["MOD_258"].base_price = 95000
    item_registry["MOD_258"].volume = 13.5
    item_registry["MOD_258"].mass = 1350
    item_registry["MOD_258"].description = "Utility module"

    # MOD_259 - Heavy Probe Launcher
    item_registry["MOD_259"] = ItemData.new()
    item_registry["MOD_259"].id = "MOD_259"
    item_registry["MOD_259"].name = "Heavy Probe Launcher"
    item_registry["MOD_259"].category = ItemCategory.MODULE
    item_registry["MOD_259"].tier = 3
    item_registry["MOD_259"].base_price = 78000
    item_registry["MOD_259"].volume = 10.5
    item_registry["MOD_259"].mass = 1050
    item_registry["MOD_259"].description = "Utility module"

    # MOD_260 - Elite Remote Repairer
    item_registry["MOD_260"] = ItemData.new()
    item_registry["MOD_260"].id = "MOD_260"
    item_registry["MOD_260"].name = "Elite Remote Repairer"
    item_registry["MOD_260"].category = ItemCategory.MODULE
    item_registry["MOD_260"].tier = 3
    item_registry["MOD_260"].base_price = 98000
    item_registry["MOD_260"].volume = 14.0
    item_registry["MOD_260"].mass = 1400
    item_registry["MOD_260"].description = "Utility module"

    # MOD_261 - Energy Neutralizer
    item_registry["MOD_261"] = ItemData.new()
    item_registry["MOD_261"].id = "MOD_261"
    item_registry["MOD_261"].name = "Energy Neutralizer"
    item_registry["MOD_261"].category = ItemCategory.MODULE
    item_registry["MOD_261"].tier = 3
    item_registry["MOD_261"].base_price = 82000
    item_registry["MOD_261"].volume = 11.0
    item_registry["MOD_261"].mass = 1100
    item_registry["MOD_261"].description = "Utility module"

    # MOD_262 - Energy Vampire
    item_registry["MOD_262"] = ItemData.new()
    item_registry["MOD_262"].id = "MOD_262"
    item_registry["MOD_262"].name = "Energy Vampire"
    item_registry["MOD_262"].category = ItemCategory.MODULE
    item_registry["MOD_262"].tier = 3
    item_registry["MOD_262"].base_price = 88000
    item_registry["MOD_262"].volume = 12.0
    item_registry["MOD_262"].mass = 1200
    item_registry["MOD_262"].description = "Utility module"

    # MOD_263 - Quantum Repair Module
    item_registry["MOD_263"] = ItemData.new()
    item_registry["MOD_263"].id = "MOD_263"
    item_registry["MOD_263"].name = "Quantum Repair Module"
    item_registry["MOD_263"].category = ItemCategory.MODULE
    item_registry["MOD_263"].tier = 4
    item_registry["MOD_263"].base_price = 340000
    item_registry["MOD_263"].volume = 48.0
    item_registry["MOD_263"].mass = 4800
    item_registry["MOD_263"].description = "Utility module"

    # MOD_264 - Capital Tractor Beam
    item_registry["MOD_264"] = ItemData.new()
    item_registry["MOD_264"].id = "MOD_264"
    item_registry["MOD_264"].name = "Capital Tractor Beam"
    item_registry["MOD_264"].category = ItemCategory.MODULE
    item_registry["MOD_264"].tier = 4
    item_registry["MOD_264"].base_price = 280000
    item_registry["MOD_264"].volume = 38.0
    item_registry["MOD_264"].mass = 3800
    item_registry["MOD_264"].description = "Utility module"

    # MOD_265 - Siege Salvager
    item_registry["MOD_265"] = ItemData.new()
    item_registry["MOD_265"].id = "MOD_265"
    item_registry["MOD_265"].name = "Siege Salvager"
    item_registry["MOD_265"].category = ItemCategory.MODULE
    item_registry["MOD_265"].tier = 4
    item_registry["MOD_265"].base_price = 365000
    item_registry["MOD_265"].volume = 52.0
    item_registry["MOD_265"].mass = 5200
    item_registry["MOD_265"].description = "Utility module"

    # MOD_266 - Capital Remote Repairer
    item_registry["MOD_266"] = ItemData.new()
    item_registry["MOD_266"].id = "MOD_266"
    item_registry["MOD_266"].name = "Capital Remote Repairer"
    item_registry["MOD_266"].category = ItemCategory.MODULE
    item_registry["MOD_266"].tier = 4
    item_registry["MOD_266"].base_price = 355000
    item_registry["MOD_266"].volume = 50.0
    item_registry["MOD_266"].mass = 5000
    item_registry["MOD_266"].description = "Utility module"

    # MOD_267 - Quantum Neutralizer
    item_registry["MOD_267"] = ItemData.new()
    item_registry["MOD_267"].id = "MOD_267"
    item_registry["MOD_267"].name = "Quantum Neutralizer"
    item_registry["MOD_267"].category = ItemCategory.MODULE
    item_registry["MOD_267"].tier = 4
    item_registry["MOD_267"].base_price = 330000
    item_registry["MOD_267"].volume = 45.0
    item_registry["MOD_267"].mass = 4500
    item_registry["MOD_267"].description = "Utility module"

    # MOD_268 - Titan Repair Module
    item_registry["MOD_268"] = ItemData.new()
    item_registry["MOD_268"].id = "MOD_268"
    item_registry["MOD_268"].name = "Titan Repair Module"
    item_registry["MOD_268"].category = ItemCategory.MODULE
    item_registry["MOD_268"].tier = 5
    item_registry["MOD_268"].base_price = 2200000
    item_registry["MOD_268"].volume = 200.0
    item_registry["MOD_268"].mass = 20000
    item_registry["MOD_268"].description = "Utility module"

    # MOD_269 - Mega Tractor Beam
    item_registry["MOD_269"] = ItemData.new()
    item_registry["MOD_269"].id = "MOD_269"
    item_registry["MOD_269"].name = "Mega Tractor Beam"
    item_registry["MOD_269"].category = ItemCategory.MODULE
    item_registry["MOD_269"].tier = 5
    item_registry["MOD_269"].base_price = 2000000
    item_registry["MOD_269"].volume = 180.0
    item_registry["MOD_269"].mass = 18000
    item_registry["MOD_269"].description = "Utility module"

    # MOD_270 - Ultimate Salvager
    item_registry["MOD_270"] = ItemData.new()
    item_registry["MOD_270"].id = "MOD_270"
    item_registry["MOD_270"].name = "Ultimate Salvager"
    item_registry["MOD_270"].category = ItemCategory.MODULE
    item_registry["MOD_270"].tier = 5
    item_registry["MOD_270"].base_price = 2400000
    item_registry["MOD_270"].volume = 220.0
    item_registry["MOD_270"].mass = 22000
    item_registry["MOD_270"].description = "Utility module"

    # MOD_271 - Mega Remote Repairer
    item_registry["MOD_271"] = ItemData.new()
    item_registry["MOD_271"].id = "MOD_271"
    item_registry["MOD_271"].name = "Mega Remote Repairer"
    item_registry["MOD_271"].category = ItemCategory.MODULE
    item_registry["MOD_271"].tier = 5
    item_registry["MOD_271"].base_price = 2300000
    item_registry["MOD_271"].volume = 210.0
    item_registry["MOD_271"].mass = 21000
    item_registry["MOD_271"].description = "Utility module"

    # MOD_272 - Corporate Hangar Array
    item_registry["MOD_272"] = ItemData.new()
    item_registry["MOD_272"].id = "MOD_272"
    item_registry["MOD_272"].name = "Corporate Hangar Array"
    item_registry["MOD_272"].category = ItemCategory.MODULE
    item_registry["MOD_272"].tier = 3
    item_registry["MOD_272"].base_price = 150000
    item_registry["MOD_272"].volume = 22.0
    item_registry["MOD_272"].mass = 2200
    item_registry["MOD_272"].description = "Station module"

    # MOD_273 - Manufacturing Array
    item_registry["MOD_273"] = ItemData.new()
    item_registry["MOD_273"].id = "MOD_273"
    item_registry["MOD_273"].name = "Manufacturing Array"
    item_registry["MOD_273"].category = ItemCategory.MODULE
    item_registry["MOD_273"].tier = 3
    item_registry["MOD_273"].base_price = 165000
    item_registry["MOD_273"].volume = 24.0
    item_registry["MOD_273"].mass = 2400
    item_registry["MOD_273"].description = "Station module"

    # MOD_274 - Research Laboratory
    item_registry["MOD_274"] = ItemData.new()
    item_registry["MOD_274"].id = "MOD_274"
    item_registry["MOD_274"].name = "Research Laboratory"
    item_registry["MOD_274"].category = ItemCategory.MODULE
    item_registry["MOD_274"].tier = 3
    item_registry["MOD_274"].base_price = 145000
    item_registry["MOD_274"].volume = 21.0
    item_registry["MOD_274"].mass = 2100
    item_registry["MOD_274"].description = "Station module"

    # MOD_275 - Refinery Complex
    item_registry["MOD_275"] = ItemData.new()
    item_registry["MOD_275"].id = "MOD_275"
    item_registry["MOD_275"].name = "Refinery Complex"
    item_registry["MOD_275"].category = ItemCategory.MODULE
    item_registry["MOD_275"].tier = 3
    item_registry["MOD_275"].base_price = 170000
    item_registry["MOD_275"].volume = 25.0
    item_registry["MOD_275"].mass = 2500
    item_registry["MOD_275"].description = "Station module"

    # MOD_276 - Market Hub
    item_registry["MOD_276"] = ItemData.new()
    item_registry["MOD_276"].id = "MOD_276"
    item_registry["MOD_276"].name = "Market Hub"
    item_registry["MOD_276"].category = ItemCategory.MODULE
    item_registry["MOD_276"].tier = 4
    item_registry["MOD_276"].base_price = 520000
    item_registry["MOD_276"].volume = 75.0
    item_registry["MOD_276"].mass = 7500
    item_registry["MOD_276"].description = "Station module"

    # MOD_277 - Defense Battery
    item_registry["MOD_277"] = ItemData.new()
    item_registry["MOD_277"].id = "MOD_277"
    item_registry["MOD_277"].name = "Defense Battery"
    item_registry["MOD_277"].category = ItemCategory.MODULE
    item_registry["MOD_277"].tier = 4
    item_registry["MOD_277"].base_price = 570000
    item_registry["MOD_277"].volume = 82.0
    item_registry["MOD_277"].mass = 8200
    item_registry["MOD_277"].description = "Station module"

    # MOD_278 - Docking Bay
    item_registry["MOD_278"] = ItemData.new()
    item_registry["MOD_278"].id = "MOD_278"
    item_registry["MOD_278"].name = "Docking Bay"
    item_registry["MOD_278"].category = ItemCategory.MODULE
    item_registry["MOD_278"].tier = 4
    item_registry["MOD_278"].base_price = 540000
    item_registry["MOD_278"].volume = 78.0
    item_registry["MOD_278"].mass = 7800
    item_registry["MOD_278"].description = "Station module"

    # MOD_279 - Cloning Facility
    item_registry["MOD_279"] = ItemData.new()
    item_registry["MOD_279"].id = "MOD_279"
    item_registry["MOD_279"].name = "Cloning Facility"
    item_registry["MOD_279"].category = ItemCategory.MODULE
    item_registry["MOD_279"].tier = 4
    item_registry["MOD_279"].base_price = 475000
    item_registry["MOD_279"].volume = 68.0
    item_registry["MOD_279"].mass = 6800
    item_registry["MOD_279"].description = "Station module"

    # MOD_280 - Mega Manufacturing Complex
    item_registry["MOD_280"] = ItemData.new()
    item_registry["MOD_280"].id = "MOD_280"
    item_registry["MOD_280"].name = "Mega Manufacturing Complex"
    item_registry["MOD_280"].category = ItemCategory.MODULE
    item_registry["MOD_280"].tier = 5
    item_registry["MOD_280"].base_price = 3500000
    item_registry["MOD_280"].volume = 320.0
    item_registry["MOD_280"].mass = 32000
    item_registry["MOD_280"].description = "Station module"

    # MOD_281 - Titan Research Facility
    item_registry["MOD_281"] = ItemData.new()
    item_registry["MOD_281"].id = "MOD_281"
    item_registry["MOD_281"].name = "Titan Research Facility"
    item_registry["MOD_281"].category = ItemCategory.MODULE
    item_registry["MOD_281"].tier = 5
    item_registry["MOD_281"].base_price = 3300000
    item_registry["MOD_281"].volume = 300.0
    item_registry["MOD_281"].mass = 30000
    item_registry["MOD_281"].description = "Station module"

    # MOD_282 - Ultimate Refinery
    item_registry["MOD_282"] = ItemData.new()
    item_registry["MOD_282"].id = "MOD_282"
    item_registry["MOD_282"].name = "Ultimate Refinery"
    item_registry["MOD_282"].category = ItemCategory.MODULE
    item_registry["MOD_282"].tier = 5
    item_registry["MOD_282"].base_price = 3700000
    item_registry["MOD_282"].volume = 340.0
    item_registry["MOD_282"].mass = 34000
    item_registry["MOD_282"].description = "Station module"

    # MOD_283 - Mega Market Hub
    item_registry["MOD_283"] = ItemData.new()
    item_registry["MOD_283"].id = "MOD_283"
    item_registry["MOD_283"].name = "Mega Market Hub"
    item_registry["MOD_283"].category = ItemCategory.MODULE
    item_registry["MOD_283"].tier = 5
    item_registry["MOD_283"].base_price = 3100000
    item_registry["MOD_283"].volume = 280.0
    item_registry["MOD_283"].mass = 28000
    item_registry["MOD_283"].description = "Station module"

    # MOD_284 - Fortress Defense Grid
    item_registry["MOD_284"] = ItemData.new()
    item_registry["MOD_284"].id = "MOD_284"
    item_registry["MOD_284"].name = "Fortress Defense Grid"
    item_registry["MOD_284"].category = ItemCategory.MODULE
    item_registry["MOD_284"].tier = 5
    item_registry["MOD_284"].base_price = 4000000
    item_registry["MOD_284"].volume = 360.0
    item_registry["MOD_284"].mass = 36000
    item_registry["MOD_284"].description = "Station module"

    # MOD_285 - Capital Shipyard
    item_registry["MOD_285"] = ItemData.new()
    item_registry["MOD_285"].id = "MOD_285"
    item_registry["MOD_285"].name = "Capital Shipyard"
    item_registry["MOD_285"].category = ItemCategory.MODULE
    item_registry["MOD_285"].tier = 5
    item_registry["MOD_285"].base_price = 4200000
    item_registry["MOD_285"].volume = 380.0
    item_registry["MOD_285"].mass = 38000
    item_registry["MOD_285"].description = "Station module"

    # MOD_286 - Banking Vault
    item_registry["MOD_286"] = ItemData.new()
    item_registry["MOD_286"].id = "MOD_286"
    item_registry["MOD_286"].name = "Banking Vault"
    item_registry["MOD_286"].category = ItemCategory.MODULE
    item_registry["MOD_286"].tier = 4
    item_registry["MOD_286"].base_price = 455000
    item_registry["MOD_286"].volume = 65.0
    item_registry["MOD_286"].mass = 6500
    item_registry["MOD_286"].description = "Station module"

    # MOD_287 - Station Jump Gate
    item_registry["MOD_287"] = ItemData.new()
    item_registry["MOD_287"].id = "MOD_287"
    item_registry["MOD_287"].name = "Station Jump Gate"
    item_registry["MOD_287"].category = ItemCategory.MODULE
    item_registry["MOD_287"].tier = 5
    item_registry["MOD_287"].base_price = 4500000
    item_registry["MOD_287"].volume = 400.0
    item_registry["MOD_287"].mass = 40000
    item_registry["MOD_287"].description = "Station module"

    # MOD_288 - Cynosural Field Gen
    item_registry["MOD_288"] = ItemData.new()
    item_registry["MOD_288"].id = "MOD_288"
    item_registry["MOD_288"].name = "Cynosural Field Gen"
    item_registry["MOD_288"].category = ItemCategory.MODULE
    item_registry["MOD_288"].tier = 3
    item_registry["MOD_288"].base_price = 85000
    item_registry["MOD_288"].volume = 11.5
    item_registry["MOD_288"].mass = 1150
    item_registry["MOD_288"].description = "Utility module"

    # MOD_289 - Jump Drive
    item_registry["MOD_289"] = ItemData.new()
    item_registry["MOD_289"].id = "MOD_289"
    item_registry["MOD_289"].name = "Jump Drive"
    item_registry["MOD_289"].category = ItemCategory.MODULE
    item_registry["MOD_289"].tier = 4
    item_registry["MOD_289"].base_price = 385000
    item_registry["MOD_289"].volume = 55.0
    item_registry["MOD_289"].mass = 5500
    item_registry["MOD_289"].description = "Utility module"

    # MOD_290 - Stasis Webifier
    item_registry["MOD_290"] = ItemData.new()
    item_registry["MOD_290"].id = "MOD_290"
    item_registry["MOD_290"].name = "Stasis Webifier"
    item_registry["MOD_290"].category = ItemCategory.MODULE
    item_registry["MOD_290"].tier = 2
    item_registry["MOD_290"].base_price = 19000
    item_registry["MOD_290"].volume = 3.4
    item_registry["MOD_290"].mass = 340
    item_registry["MOD_290"].description = "Utility module"

    # MOD_291 - Warp Scrambler
    item_registry["MOD_291"] = ItemData.new()
    item_registry["MOD_291"].id = "MOD_291"
    item_registry["MOD_291"].name = "Warp Scrambler"
    item_registry["MOD_291"].category = ItemCategory.MODULE
    item_registry["MOD_291"].tier = 3
    item_registry["MOD_291"].base_price = 75000
    item_registry["MOD_291"].volume = 10.0
    item_registry["MOD_291"].mass = 1000
    item_registry["MOD_291"].description = "Utility module"

    # MOD_292 - Siege Module
    item_registry["MOD_292"] = ItemData.new()
    item_registry["MOD_292"].id = "MOD_292"
    item_registry["MOD_292"].name = "Siege Module"
    item_registry["MOD_292"].category = ItemCategory.MODULE
    item_registry["MOD_292"].tier = 4
    item_registry["MOD_292"].base_price = 420000
    item_registry["MOD_292"].volume = 60.0
    item_registry["MOD_292"].mass = 6000
    item_registry["MOD_292"].description = "Utility module"

    # MOD_293 - Triage Module
    item_registry["MOD_293"] = ItemData.new()
    item_registry["MOD_293"].id = "MOD_293"
    item_registry["MOD_293"].name = "Triage Module"
    item_registry["MOD_293"].category = ItemCategory.MODULE
    item_registry["MOD_293"].tier = 4
    item_registry["MOD_293"].base_price = 390000
    item_registry["MOD_293"].volume = 55.0
    item_registry["MOD_293"].mass = 5500
    item_registry["MOD_293"].description = "Utility module"

    # MOD_294 - Burst Projector
    item_registry["MOD_294"] = ItemData.new()
    item_registry["MOD_294"].id = "MOD_294"
    item_registry["MOD_294"].name = "Burst Projector"
    item_registry["MOD_294"].category = ItemCategory.MODULE
    item_registry["MOD_294"].tier = 3
    item_registry["MOD_294"].base_price = 82000
    item_registry["MOD_294"].volume = 11.0
    item_registry["MOD_294"].mass = 1100
    item_registry["MOD_294"].description = "Utility module"

    # MOD_295 - Bomb Launcher
    item_registry["MOD_295"] = ItemData.new()
    item_registry["MOD_295"].id = "MOD_295"
    item_registry["MOD_295"].name = "Bomb Launcher"
    item_registry["MOD_295"].category = ItemCategory.MODULE
    item_registry["MOD_295"].tier = 3
    item_registry["MOD_295"].base_price = 88000
    item_registry["MOD_295"].volume = 12.0
    item_registry["MOD_295"].mass = 1200
    item_registry["MOD_295"].description = "Utility module"

    # MOD_296 - Micro Jump Drive
    item_registry["MOD_296"] = ItemData.new()
    item_registry["MOD_296"].id = "MOD_296"
    item_registry["MOD_296"].name = "Micro Jump Drive"
    item_registry["MOD_296"].category = ItemCategory.MODULE
    item_registry["MOD_296"].tier = 3
    item_registry["MOD_296"].base_price = 78000
    item_registry["MOD_296"].volume = 10.5
    item_registry["MOD_296"].mass = 1050
    item_registry["MOD_296"].description = "Utility module"

    # MOD_297 - Command Processor
    item_registry["MOD_297"] = ItemData.new()
    item_registry["MOD_297"].id = "MOD_297"
    item_registry["MOD_297"].name = "Command Processor"
    item_registry["MOD_297"].category = ItemCategory.MODULE
    item_registry["MOD_297"].tier = 4
    item_registry["MOD_297"].base_price = 340000
    item_registry["MOD_297"].volume = 47.0
    item_registry["MOD_297"].mass = 4700
    item_registry["MOD_297"].description = "Utility module"

    # MOD_298 - Entosis Link
    item_registry["MOD_298"] = ItemData.new()
    item_registry["MOD_298"].id = "MOD_298"
    item_registry["MOD_298"].name = "Entosis Link"
    item_registry["MOD_298"].category = ItemCategory.MODULE
    item_registry["MOD_298"].tier = 3
    item_registry["MOD_298"].base_price = 72000
    item_registry["MOD_298"].volume = 9.8
    item_registry["MOD_298"].mass = 980
    item_registry["MOD_298"].description = "Utility module"

    # MOD_299 - Drone Link Augmentor
    item_registry["MOD_299"] = ItemData.new()
    item_registry["MOD_299"].id = "MOD_299"
    item_registry["MOD_299"].name = "Drone Link Augmentor"
    item_registry["MOD_299"].category = ItemCategory.MODULE
    item_registry["MOD_299"].tier = 2
    item_registry["MOD_299"].base_price = 21000
    item_registry["MOD_299"].volume = 3.8
    item_registry["MOD_299"].mass = 380
    item_registry["MOD_299"].description = "Utility module"

    # MOD_300 - Ultimate Utility Core
    item_registry["MOD_300"] = ItemData.new()
    item_registry["MOD_300"].id = "MOD_300"
    item_registry["MOD_300"].name = "Ultimate Utility Core"
    item_registry["MOD_300"].category = ItemCategory.MODULE
    item_registry["MOD_300"].tier = 5
    item_registry["MOD_300"].base_price = 3800000
    item_registry["MOD_300"].volume = 350.0
    item_registry["MOD_300"].mass = 35000
    item_registry["MOD_300"].description = "Utility module"

    # SHIP_001 - Sparrow Scout
    item_registry["SHIP_001"] = ItemData.new()
    item_registry["SHIP_001"].id = "SHIP_001"
    item_registry["SHIP_001"].name = "Sparrow Scout"
    item_registry["SHIP_001"].category = ItemCategory.SHIP
    item_registry["SHIP_001"].tier = 1
    item_registry["SHIP_001"].base_price = 50000
    item_registry["SHIP_001"].volume = 500
    item_registry["SHIP_001"].mass = 5000
    item_registry["SHIP_001"].description = "Fast, versatile small combat ship"

    # SHIP_002 - Falcon Interceptor
    item_registry["SHIP_002"] = ItemData.new()
    item_registry["SHIP_002"].id = "SHIP_002"
    item_registry["SHIP_002"].name = "Falcon Interceptor"
    item_registry["SHIP_002"].category = ItemCategory.SHIP
    item_registry["SHIP_002"].tier = 1
    item_registry["SHIP_002"].base_price = 55000
    item_registry["SHIP_002"].volume = 520
    item_registry["SHIP_002"].mass = 5200
    item_registry["SHIP_002"].description = "Fast, versatile small combat ship"

    # SHIP_003 - Hawk Combat
    item_registry["SHIP_003"] = ItemData.new()
    item_registry["SHIP_003"].id = "SHIP_003"
    item_registry["SHIP_003"].name = "Hawk Combat"
    item_registry["SHIP_003"].category = ItemCategory.SHIP
    item_registry["SHIP_003"].tier = 1
    item_registry["SHIP_003"].base_price = 60000
    item_registry["SHIP_003"].volume = 550
    item_registry["SHIP_003"].mass = 5500
    item_registry["SHIP_003"].description = "Fast, versatile small combat ship"

    # SHIP_004 - Eagle Assault
    item_registry["SHIP_004"] = ItemData.new()
    item_registry["SHIP_004"].id = "SHIP_004"
    item_registry["SHIP_004"].name = "Eagle Assault"
    item_registry["SHIP_004"].category = ItemCategory.SHIP
    item_registry["SHIP_004"].tier = 2
    item_registry["SHIP_004"].base_price = 75000
    item_registry["SHIP_004"].volume = 600
    item_registry["SHIP_004"].mass = 6000
    item_registry["SHIP_004"].description = "Fast, versatile small combat ship"

    # SHIP_005 - Cruise Stealth
    item_registry["SHIP_005"] = ItemData.new()
    item_registry["SHIP_005"].id = "SHIP_005"
    item_registry["SHIP_005"].name = "Cruise Stealth"
    item_registry["SHIP_005"].category = ItemCategory.SHIP
    item_registry["SHIP_005"].tier = 2
    item_registry["SHIP_005"].base_price = 72000
    item_registry["SHIP_005"].volume = 580
    item_registry["SHIP_005"].mass = 5800
    item_registry["SHIP_005"].description = "Fast, versatile small combat ship"

    # SHIP_006 - Condor Electronic
    item_registry["SHIP_006"] = ItemData.new()
    item_registry["SHIP_006"].id = "SHIP_006"
    item_registry["SHIP_006"].name = "Condor Electronic"
    item_registry["SHIP_006"].category = ItemCategory.SHIP
    item_registry["SHIP_006"].tier = 2
    item_registry["SHIP_006"].base_price = 68000
    item_registry["SHIP_006"].volume = 560
    item_registry["SHIP_006"].mass = 5600
    item_registry["SHIP_006"].description = "Fast, versatile small combat ship"

    # SHIP_007 - Viper Logistics
    item_registry["SHIP_007"] = ItemData.new()
    item_registry["SHIP_007"].id = "SHIP_007"
    item_registry["SHIP_007"].name = "Viper Logistics"
    item_registry["SHIP_007"].category = ItemCategory.SHIP
    item_registry["SHIP_007"].tier = 2
    item_registry["SHIP_007"].base_price = 73000
    item_registry["SHIP_007"].volume = 590
    item_registry["SHIP_007"].mass = 5900
    item_registry["SHIP_007"].description = "Fast, versatile small combat ship"

    # SHIP_008 - Merlin Tackle
    item_registry["SHIP_008"] = ItemData.new()
    item_registry["SHIP_008"].id = "SHIP_008"
    item_registry["SHIP_008"].name = "Merlin Tackle"
    item_registry["SHIP_008"].category = ItemCategory.SHIP
    item_registry["SHIP_008"].tier = 1
    item_registry["SHIP_008"].base_price = 57000
    item_registry["SHIP_008"].volume = 530
    item_registry["SHIP_008"].mass = 5300
    item_registry["SHIP_008"].description = "Fast, versatile small combat ship"

    # SHIP_009 - Kestrel Missile
    item_registry["SHIP_009"] = ItemData.new()
    item_registry["SHIP_009"].id = "SHIP_009"
    item_registry["SHIP_009"].name = "Kestrel Missile"
    item_registry["SHIP_009"].category = ItemCategory.SHIP
    item_registry["SHIP_009"].tier = 2
    item_registry["SHIP_009"].base_price = 77000
    item_registry["SHIP_009"].volume = 610
    item_registry["SHIP_009"].mass = 6100
    item_registry["SHIP_009"].description = "Fast, versatile small combat ship"

    # SHIP_010 - Missile Dreadnought Mining
    item_registry["SHIP_010"] = ItemData.new()
    item_registry["SHIP_010"].id = "SHIP_010"
    item_registry["SHIP_010"].name = "Missile Dreadnought Mining"
    item_registry["SHIP_010"].category = ItemCategory.SHIP
    item_registry["SHIP_010"].tier = 1
    item_registry["SHIP_010"].base_price = 58000
    item_registry["SHIP_010"].volume = 540
    item_registry["SHIP_010"].mass = 5400
    item_registry["SHIP_010"].description = "Fast, versatile small combat ship"

    # SHIP_011 - Osprey Hauler
    item_registry["SHIP_011"] = ItemData.new()
    item_registry["SHIP_011"].id = "SHIP_011"
    item_registry["SHIP_011"].name = "Osprey Hauler"
    item_registry["SHIP_011"].category = ItemCategory.SHIP
    item_registry["SHIP_011"].tier = 1
    item_registry["SHIP_011"].base_price = 62000
    item_registry["SHIP_011"].volume = 570
    item_registry["SHIP_011"].mass = 5700
    item_registry["SHIP_011"].description = "Fast, versatile small combat ship"

    # SHIP_012 - Swift Runner
    item_registry["SHIP_012"] = ItemData.new()
    item_registry["SHIP_012"].id = "SHIP_012"
    item_registry["SHIP_012"].name = "Swift Runner"
    item_registry["SHIP_012"].category = ItemCategory.SHIP
    item_registry["SHIP_012"].tier = 3
    item_registry["SHIP_012"].base_price = 95000
    item_registry["SHIP_012"].volume = 650
    item_registry["SHIP_012"].mass = 6500
    item_registry["SHIP_012"].description = "Fast, versatile small combat ship"

    # SHIP_013 - Razor Interceptor
    item_registry["SHIP_013"] = ItemData.new()
    item_registry["SHIP_013"].id = "SHIP_013"
    item_registry["SHIP_013"].name = "Razor Interceptor"
    item_registry["SHIP_013"].category = ItemCategory.SHIP
    item_registry["SHIP_013"].tier = 3
    item_registry["SHIP_013"].base_price = 92000
    item_registry["SHIP_013"].volume = 640
    item_registry["SHIP_013"].mass = 6400
    item_registry["SHIP_013"].description = "Fast, versatile small combat ship"

    # SHIP_014 - Talon Assault
    item_registry["SHIP_014"] = ItemData.new()
    item_registry["SHIP_014"].id = "SHIP_014"
    item_registry["SHIP_014"].name = "Talon Assault"
    item_registry["SHIP_014"].category = ItemCategory.SHIP
    item_registry["SHIP_014"].tier = 3
    item_registry["SHIP_014"].base_price = 102000
    item_registry["SHIP_014"].volume = 680
    item_registry["SHIP_014"].mass = 6800
    item_registry["SHIP_014"].description = "Fast, versatile small combat ship"

    # SHIP_015 - Ghost Stealth
    item_registry["SHIP_015"] = ItemData.new()
    item_registry["SHIP_015"].id = "SHIP_015"
    item_registry["SHIP_015"].name = "Ghost Stealth"
    item_registry["SHIP_015"].category = ItemCategory.SHIP
    item_registry["SHIP_015"].tier = 4
    item_registry["SHIP_015"].base_price = 135000
    item_registry["SHIP_015"].volume = 720
    item_registry["SHIP_015"].mass = 7200
    item_registry["SHIP_015"].description = "Fast, versatile small combat ship"

    # SHIP_016 - Phantom Scout
    item_registry["SHIP_016"] = ItemData.new()
    item_registry["SHIP_016"].id = "SHIP_016"
    item_registry["SHIP_016"].name = "Phantom Scout"
    item_registry["SHIP_016"].category = ItemCategory.SHIP
    item_registry["SHIP_016"].tier = 4
    item_registry["SHIP_016"].base_price = 128000
    item_registry["SHIP_016"].volume = 700
    item_registry["SHIP_016"].mass = 7000
    item_registry["SHIP_016"].description = "Fast, versatile small combat ship"

    # SHIP_017 - Wraith Electronic
    item_registry["SHIP_017"] = ItemData.new()
    item_registry["SHIP_017"].id = "SHIP_017"
    item_registry["SHIP_017"].name = "Wraith Electronic"
    item_registry["SHIP_017"].category = ItemCategory.SHIP
    item_registry["SHIP_017"].tier = 4
    item_registry["SHIP_017"].base_price = 132000
    item_registry["SHIP_017"].volume = 710
    item_registry["SHIP_017"].mass = 7100
    item_registry["SHIP_017"].description = "Fast, versatile small combat ship"

    # SHIP_018 - Spectre Logistics
    item_registry["SHIP_018"] = ItemData.new()
    item_registry["SHIP_018"].id = "SHIP_018"
    item_registry["SHIP_018"].name = "Spectre Logistics"
    item_registry["SHIP_018"].category = ItemCategory.SHIP
    item_registry["SHIP_018"].tier = 3
    item_registry["SHIP_018"].base_price = 98000
    item_registry["SHIP_018"].volume = 660
    item_registry["SHIP_018"].mass = 6600
    item_registry["SHIP_018"].description = "Fast, versatile small combat ship"

    # SHIP_019 - Banshee Command
    item_registry["SHIP_019"] = ItemData.new()
    item_registry["SHIP_019"].id = "SHIP_019"
    item_registry["SHIP_019"].name = "Banshee Command"
    item_registry["SHIP_019"].category = ItemCategory.SHIP
    item_registry["SHIP_019"].tier = 4
    item_registry["SHIP_019"].base_price = 138000
    item_registry["SHIP_019"].volume = 730
    item_registry["SHIP_019"].mass = 7300
    item_registry["SHIP_019"].description = "Fast, versatile small combat ship"

    # SHIP_020 - Nova Interceptor
    item_registry["SHIP_020"] = ItemData.new()
    item_registry["SHIP_020"].id = "SHIP_020"
    item_registry["SHIP_020"].name = "Nova Interceptor"
    item_registry["SHIP_020"].category = ItemCategory.SHIP
    item_registry["SHIP_020"].tier = 5
    item_registry["SHIP_020"].base_price = 225000
    item_registry["SHIP_020"].volume = 800
    item_registry["SHIP_020"].mass = 8000
    item_registry["SHIP_020"].description = "Fast, versatile small combat ship"

    # SHIP_021 - Sentinel Guardian
    item_registry["SHIP_021"] = ItemData.new()
    item_registry["SHIP_021"].id = "SHIP_021"
    item_registry["SHIP_021"].name = "Sentinel Guardian"
    item_registry["SHIP_021"].category = ItemCategory.SHIP
    item_registry["SHIP_021"].tier = 1
    item_registry["SHIP_021"].base_price = 150000
    item_registry["SHIP_021"].volume = 1200
    item_registry["SHIP_021"].mass = 12000
    item_registry["SHIP_021"].description = "Spaceship hull"

    # SHIP_022 - Guardian Defender
    item_registry["SHIP_022"] = ItemData.new()
    item_registry["SHIP_022"].id = "SHIP_022"
    item_registry["SHIP_022"].name = "Guardian Defender"
    item_registry["SHIP_022"].category = ItemCategory.SHIP
    item_registry["SHIP_022"].tier = 1
    item_registry["SHIP_022"].base_price = 160000
    item_registry["SHIP_022"].volume = 1250
    item_registry["SHIP_022"].mass = 12500
    item_registry["SHIP_022"].description = "Spaceship hull"

    # SHIP_023 - Warden Patrol
    item_registry["SHIP_023"] = ItemData.new()
    item_registry["SHIP_023"].id = "SHIP_023"
    item_registry["SHIP_023"].name = "Warden Patrol"
    item_registry["SHIP_023"].category = ItemCategory.SHIP
    item_registry["SHIP_023"].tier = 2
    item_registry["SHIP_023"].base_price = 180000
    item_registry["SHIP_023"].volume = 1300
    item_registry["SHIP_023"].mass = 13000
    item_registry["SHIP_023"].description = "Spaceship hull"

    # SHIP_024 - Lancer Strike
    item_registry["SHIP_024"] = ItemData.new()
    item_registry["SHIP_024"].id = "SHIP_024"
    item_registry["SHIP_024"].name = "Lancer Strike"
    item_registry["SHIP_024"].category = ItemCategory.SHIP
    item_registry["SHIP_024"].tier = 2
    item_registry["SHIP_024"].base_price = 195000
    item_registry["SHIP_024"].volume = 1350
    item_registry["SHIP_024"].mass = 13500
    item_registry["SHIP_024"].description = "Spaceship hull"

    # SHIP_025 - Claymore Heavy
    item_registry["SHIP_025"] = ItemData.new()
    item_registry["SHIP_025"].id = "SHIP_025"
    item_registry["SHIP_025"].name = "Claymore Heavy"
    item_registry["SHIP_025"].category = ItemCategory.SHIP
    item_registry["SHIP_025"].tier = 2
    item_registry["SHIP_025"].base_price = 210000
    item_registry["SHIP_025"].volume = 1400
    item_registry["SHIP_025"].mass = 14000
    item_registry["SHIP_025"].description = "Spaceship hull"

    # SHIP_026 - Rapier Interdictor
    item_registry["SHIP_026"] = ItemData.new()
    item_registry["SHIP_026"].id = "SHIP_026"
    item_registry["SHIP_026"].name = "Rapier Interdictor"
    item_registry["SHIP_026"].category = ItemCategory.SHIP
    item_registry["SHIP_026"].tier = 2
    item_registry["SHIP_026"].base_price = 185000
    item_registry["SHIP_026"].volume = 1320
    item_registry["SHIP_026"].mass = 13200
    item_registry["SHIP_026"].description = "Spaceship hull"

    # SHIP_027 - Scimitar Logistics
    item_registry["SHIP_027"] = ItemData.new()
    item_registry["SHIP_027"].id = "SHIP_027"
    item_registry["SHIP_027"].name = "Scimitar Logistics"
    item_registry["SHIP_027"].category = ItemCategory.SHIP
    item_registry["SHIP_027"].tier = 2
    item_registry["SHIP_027"].base_price = 190000
    item_registry["SHIP_027"].volume = 1340
    item_registry["SHIP_027"].mass = 13400
    item_registry["SHIP_027"].description = "Spaceship hull"

    # SHIP_028 - Broadsword Command
    item_registry["SHIP_028"] = ItemData.new()
    item_registry["SHIP_028"].id = "SHIP_028"
    item_registry["SHIP_028"].name = "Broadsword Command"
    item_registry["SHIP_028"].category = ItemCategory.SHIP
    item_registry["SHIP_028"].tier = 3
    item_registry["SHIP_028"].base_price = 230000
    item_registry["SHIP_028"].volume = 1450
    item_registry["SHIP_028"].mass = 14500
    item_registry["SHIP_028"].description = "Spaceship hull"

    # SHIP_029 - Halberd Assault
    item_registry["SHIP_029"] = ItemData.new()
    item_registry["SHIP_029"].id = "SHIP_029"
    item_registry["SHIP_029"].name = "Halberd Assault"
    item_registry["SHIP_029"].category = ItemCategory.SHIP
    item_registry["SHIP_029"].tier = 3
    item_registry["SHIP_029"].base_price = 245000
    item_registry["SHIP_029"].volume = 1500
    item_registry["SHIP_029"].mass = 15000
    item_registry["SHIP_029"].description = "Spaceship hull"

    # SHIP_030 - Javelin Missile
    item_registry["SHIP_030"] = ItemData.new()
    item_registry["SHIP_030"].id = "SHIP_030"
    item_registry["SHIP_030"].name = "Javelin Missile"
    item_registry["SHIP_030"].category = ItemCategory.SHIP
    item_registry["SHIP_030"].tier = 3
    item_registry["SHIP_030"].base_price = 240000
    item_registry["SHIP_030"].volume = 1480
    item_registry["SHIP_030"].mass = 14800
    item_registry["SHIP_030"].description = "Spaceship hull"

    # SHIP_031 - Corsair Pirate
    item_registry["SHIP_031"] = ItemData.new()
    item_registry["SHIP_031"].id = "SHIP_031"
    item_registry["SHIP_031"].name = "Corsair Pirate"
    item_registry["SHIP_031"].category = ItemCategory.SHIP
    item_registry["SHIP_031"].tier = 3
    item_registry["SHIP_031"].base_price = 220000
    item_registry["SHIP_031"].volume = 1420
    item_registry["SHIP_031"].mass = 14200
    item_registry["SHIP_031"].description = "Spaceship hull"

    # SHIP_032 - Phantom Stealth
    item_registry["SHIP_032"] = ItemData.new()
    item_registry["SHIP_032"].id = "SHIP_032"
    item_registry["SHIP_032"].name = "Phantom Stealth"
    item_registry["SHIP_032"].category = ItemCategory.SHIP
    item_registry["SHIP_032"].tier = 3
    item_registry["SHIP_032"].base_price = 235000
    item_registry["SHIP_032"].volume = 1460
    item_registry["SHIP_032"].mass = 14600
    item_registry["SHIP_032"].description = "Spaceship hull"

    # SHIP_033 - Laser Marauder Defense
    item_registry["SHIP_033"] = ItemData.new()
    item_registry["SHIP_033"].id = "SHIP_033"
    item_registry["SHIP_033"].name = "Laser Marauder Defense"
    item_registry["SHIP_033"].category = ItemCategory.SHIP
    item_registry["SHIP_033"].tier = 4
    item_registry["SHIP_033"].base_price = 285000
    item_registry["SHIP_033"].volume = 1550
    item_registry["SHIP_033"].mass = 15500
    item_registry["SHIP_033"].description = "Spaceship hull"

    # SHIP_034 - Champion Combat
    item_registry["SHIP_034"] = ItemData.new()
    item_registry["SHIP_034"].id = "SHIP_034"
    item_registry["SHIP_034"].name = "Champion Combat"
    item_registry["SHIP_034"].category = ItemCategory.SHIP
    item_registry["SHIP_034"].tier = 4
    item_registry["SHIP_034"].base_price = 300000
    item_registry["SHIP_034"].volume = 1600
    item_registry["SHIP_034"].mass = 16000
    item_registry["SHIP_034"].description = "Spaceship hull"

    # SHIP_035 - Crusader Strike
    item_registry["SHIP_035"] = ItemData.new()
    item_registry["SHIP_035"].id = "SHIP_035"
    item_registry["SHIP_035"].name = "Crusader Strike"
    item_registry["SHIP_035"].category = ItemCategory.SHIP
    item_registry["SHIP_035"].tier = 4
    item_registry["SHIP_035"].base_price = 295000
    item_registry["SHIP_035"].volume = 1580
    item_registry["SHIP_035"].mass = 15800
    item_registry["SHIP_035"].description = "Spaceship hull"

    # SHIP_036 - Templar Assault
    item_registry["SHIP_036"] = ItemData.new()
    item_registry["SHIP_036"].id = "SHIP_036"
    item_registry["SHIP_036"].name = "Templar Assault"
    item_registry["SHIP_036"].category = ItemCategory.SHIP
    item_registry["SHIP_036"].tier = 4
    item_registry["SHIP_036"].base_price = 310000
    item_registry["SHIP_036"].volume = 1620
    item_registry["SHIP_036"].mass = 16200
    item_registry["SHIP_036"].description = "Spaceship hull"

    # SHIP_037 - Executioner Electronic
    item_registry["SHIP_037"] = ItemData.new()
    item_registry["SHIP_037"].id = "SHIP_037"
    item_registry["SHIP_037"].name = "Executioner Electronic"
    item_registry["SHIP_037"].category = ItemCategory.SHIP
    item_registry["SHIP_037"].tier = 4
    item_registry["SHIP_037"].base_price = 290000
    item_registry["SHIP_037"].volume = 1560
    item_registry["SHIP_037"].mass = 15600
    item_registry["SHIP_037"].description = "Spaceship hull"

    # SHIP_038 - Rookie-C Interdictor
    item_registry["SHIP_038"] = ItemData.new()
    item_registry["SHIP_038"].id = "SHIP_038"
    item_registry["SHIP_038"].name = "Rookie-C Interdictor"
    item_registry["SHIP_038"].category = ItemCategory.SHIP
    item_registry["SHIP_038"].tier = 4
    item_registry["SHIP_038"].base_price = 298000
    item_registry["SHIP_038"].volume = 1590
    item_registry["SHIP_038"].mass = 15900
    item_registry["SHIP_038"].description = "Spaceship hull"

    # SHIP_039 - Angel Logistics
    item_registry["SHIP_039"] = ItemData.new()
    item_registry["SHIP_039"].id = "SHIP_039"
    item_registry["SHIP_039"].name = "Angel Logistics"
    item_registry["SHIP_039"].category = ItemCategory.SHIP
    item_registry["SHIP_039"].tier = 3
    item_registry["SHIP_039"].base_price = 225000
    item_registry["SHIP_039"].volume = 1440
    item_registry["SHIP_039"].mass = 14400
    item_registry["SHIP_039"].description = "Spaceship hull"

    # SHIP_040 - Titan Destroyer
    item_registry["SHIP_040"] = ItemData.new()
    item_registry["SHIP_040"].id = "SHIP_040"
    item_registry["SHIP_040"].name = "Titan Destroyer"
    item_registry["SHIP_040"].category = ItemCategory.SHIP
    item_registry["SHIP_040"].tier = 5
    item_registry["SHIP_040"].base_price = 420000
    item_registry["SHIP_040"].volume = 1800
    item_registry["SHIP_040"].mass = 18000
    item_registry["SHIP_040"].description = "Anti-frigate combat specialist"

    # SHIP_041 - Voyager Explorer
    item_registry["SHIP_041"] = ItemData.new()
    item_registry["SHIP_041"].id = "SHIP_041"
    item_registry["SHIP_041"].name = "Voyager Explorer"
    item_registry["SHIP_041"].category = ItemCategory.SHIP
    item_registry["SHIP_041"].tier = 2
    item_registry["SHIP_041"].base_price = 200000
    item_registry["SHIP_041"].volume = 1800
    item_registry["SHIP_041"].mass = 18000
    item_registry["SHIP_041"].description = "Spaceship hull"

    # SHIP_042 - Pathfinder Scout
    item_registry["SHIP_042"] = ItemData.new()
    item_registry["SHIP_042"].id = "SHIP_042"
    item_registry["SHIP_042"].name = "Pathfinder Scout"
    item_registry["SHIP_042"].category = ItemCategory.SHIP
    item_registry["SHIP_042"].tier = 2
    item_registry["SHIP_042"].base_price = 215000
    item_registry["SHIP_042"].volume = 1850
    item_registry["SHIP_042"].mass = 18500
    item_registry["SHIP_042"].description = "Spaceship hull"

    # SHIP_043 - Pioneer Mining
    item_registry["SHIP_043"] = ItemData.new()
    item_registry["SHIP_043"].id = "SHIP_043"
    item_registry["SHIP_043"].name = "Pioneer Mining"
    item_registry["SHIP_043"].category = ItemCategory.SHIP
    item_registry["SHIP_043"].tier = 2
    item_registry["SHIP_043"].base_price = 230000
    item_registry["SHIP_043"].volume = 1900
    item_registry["SHIP_043"].mass = 19000
    item_registry["SHIP_043"].description = "Asteroid mining specialist ship"

    # SHIP_044 - Crusader Combat
    item_registry["SHIP_044"] = ItemData.new()
    item_registry["SHIP_044"].id = "SHIP_044"
    item_registry["SHIP_044"].name = "Crusader Combat"
    item_registry["SHIP_044"].category = ItemCategory.SHIP
    item_registry["SHIP_044"].tier = 2
    item_registry["SHIP_044"].base_price = 245000
    item_registry["SHIP_044"].volume = 1950
    item_registry["SHIP_044"].mass = 19500
    item_registry["SHIP_044"].description = "Spaceship hull"

    # SHIP_045 - Templar Assault
    item_registry["SHIP_045"] = ItemData.new()
    item_registry["SHIP_045"].id = "SHIP_045"
    item_registry["SHIP_045"].name = "Templar Assault"
    item_registry["SHIP_045"].category = ItemCategory.SHIP
    item_registry["SHIP_045"].tier = 3
    item_registry["SHIP_045"].base_price = 320000
    item_registry["SHIP_045"].volume = 2200
    item_registry["SHIP_045"].mass = 22000
    item_registry["SHIP_045"].description = "Spaceship hull"

    # SHIP_046 - Centurion Heavy
    item_registry["SHIP_046"] = ItemData.new()
    item_registry["SHIP_046"].id = "SHIP_046"
    item_registry["SHIP_046"].name = "Centurion Heavy"
    item_registry["SHIP_046"].category = ItemCategory.SHIP
    item_registry["SHIP_046"].tier = 3
    item_registry["SHIP_046"].base_price = 350000
    item_registry["SHIP_046"].volume = 2300
    item_registry["SHIP_046"].mass = 23000
    item_registry["SHIP_046"].description = "Spaceship hull"

    # SHIP_047 - Gladiator Combat
    item_registry["SHIP_047"] = ItemData.new()
    item_registry["SHIP_047"].id = "SHIP_047"
    item_registry["SHIP_047"].name = "Gladiator Combat"
    item_registry["SHIP_047"].category = ItemCategory.SHIP
    item_registry["SHIP_047"].tier = 3
    item_registry["SHIP_047"].base_price = 305000
    item_registry["SHIP_047"].volume = 2100
    item_registry["SHIP_047"].mass = 21000
    item_registry["SHIP_047"].description = "Spaceship hull"

    # SHIP_048 - Praetorian Defense
    item_registry["SHIP_048"] = ItemData.new()
    item_registry["SHIP_048"].id = "SHIP_048"
    item_registry["SHIP_048"].name = "Praetorian Defense"
    item_registry["SHIP_048"].category = ItemCategory.SHIP
    item_registry["SHIP_048"].tier = 3
    item_registry["SHIP_048"].base_price = 335000
    item_registry["SHIP_048"].volume = 2250
    item_registry["SHIP_048"].mass = 22500
    item_registry["SHIP_048"].description = "Spaceship hull"

    # SHIP_049 - Recon Stealth
    item_registry["SHIP_049"] = ItemData.new()
    item_registry["SHIP_049"].id = "SHIP_049"
    item_registry["SHIP_049"].name = "Recon Stealth"
    item_registry["SHIP_049"].category = ItemCategory.SHIP
    item_registry["SHIP_049"].tier = 3
    item_registry["SHIP_049"].base_price = 295000
    item_registry["SHIP_049"].volume = 2050
    item_registry["SHIP_049"].mass = 20500
    item_registry["SHIP_049"].description = "Spaceship hull"

    # SHIP_050 - Force Recon
    item_registry["SHIP_050"] = ItemData.new()
    item_registry["SHIP_050"].id = "SHIP_050"
    item_registry["SHIP_050"].name = "Force Recon"
    item_registry["SHIP_050"].category = ItemCategory.SHIP
    item_registry["SHIP_050"].tier = 3
    item_registry["SHIP_050"].base_price = 315000
    item_registry["SHIP_050"].volume = 2150
    item_registry["SHIP_050"].mass = 21500
    item_registry["SHIP_050"].description = "Spaceship hull"

    # SHIP_051 - Beam BC Missile
    item_registry["SHIP_051"] = ItemData.new()
    item_registry["SHIP_051"].id = "SHIP_051"
    item_registry["SHIP_051"].name = "Beam BC Missile"
    item_registry["SHIP_051"].category = ItemCategory.SHIP
    item_registry["SHIP_051"].tier = 3
    item_registry["SHIP_051"].base_price = 365000
    item_registry["SHIP_051"].volume = 2350
    item_registry["SHIP_051"].mass = 23500
    item_registry["SHIP_051"].description = "Spaceship hull"

    # SHIP_052 - Laser Elite BC Artillery
    item_registry["SHIP_052"] = ItemData.new()
    item_registry["SHIP_052"].id = "SHIP_052"
    item_registry["SHIP_052"].name = "Laser Elite BC Artillery"
    item_registry["SHIP_052"].category = ItemCategory.SHIP
    item_registry["SHIP_052"].tier = 3
    item_registry["SHIP_052"].base_price = 380000
    item_registry["SHIP_052"].volume = 2400
    item_registry["SHIP_052"].mass = 24000
    item_registry["SHIP_052"].description = "Spaceship hull"

    # SHIP_053 - Guardian Logistics
    item_registry["SHIP_053"] = ItemData.new()
    item_registry["SHIP_053"].id = "SHIP_053"
    item_registry["SHIP_053"].name = "Guardian Logistics"
    item_registry["SHIP_053"].category = ItemCategory.SHIP
    item_registry["SHIP_053"].tier = 2
    item_registry["SHIP_053"].base_price = 240000
    item_registry["SHIP_053"].volume = 1920
    item_registry["SHIP_053"].mass = 19200
    item_registry["SHIP_053"].description = "Spaceship hull"

    # SHIP_054 - Shield Logi Remote Repair
    item_registry["SHIP_054"] = ItemData.new()
    item_registry["SHIP_054"].id = "SHIP_054"
    item_registry["SHIP_054"].name = "Shield Logi Remote Repair"
    item_registry["SHIP_054"].category = ItemCategory.SHIP
    item_registry["SHIP_054"].tier = 3
    item_registry["SHIP_054"].base_price = 300000
    item_registry["SHIP_054"].volume = 2080
    item_registry["SHIP_054"].mass = 20800
    item_registry["SHIP_054"].description = "Spaceship hull"

    # SHIP_055 - Armor Logi Logistics
    item_registry["SHIP_055"] = ItemData.new()
    item_registry["SHIP_055"].id = "SHIP_055"
    item_registry["SHIP_055"].name = "Armor Logi Logistics"
    item_registry["SHIP_055"].category = ItemCategory.SHIP
    item_registry["SHIP_055"].tier = 3
    item_registry["SHIP_055"].base_price = 310000
    item_registry["SHIP_055"].volume = 2120
    item_registry["SHIP_055"].mass = 21200
    item_registry["SHIP_055"].description = "Spaceship hull"

    # SHIP_056 - Fast Logi Fleet
    item_registry["SHIP_056"] = ItemData.new()
    item_registry["SHIP_056"].id = "SHIP_056"
    item_registry["SHIP_056"].name = "Fast Logi Fleet"
    item_registry["SHIP_056"].category = ItemCategory.SHIP
    item_registry["SHIP_056"].tier = 2
    item_registry["SHIP_056"].base_price = 225000
    item_registry["SHIP_056"].volume = 1880
    item_registry["SHIP_056"].mass = 18800
    item_registry["SHIP_056"].description = "Spaceship hull"

    # SHIP_057 - Energy Heavy
    item_registry["SHIP_057"] = ItemData.new()
    item_registry["SHIP_057"].id = "SHIP_057"
    item_registry["SHIP_057"].name = "Energy Heavy"
    item_registry["SHIP_057"].category = ItemCategory.SHIP
    item_registry["SHIP_057"].tier = 4
    item_registry["SHIP_057"].base_price = 480000
    item_registry["SHIP_057"].volume = 2500
    item_registry["SHIP_057"].mass = 25000
    item_registry["SHIP_057"].description = "Spaceship hull"

    # SHIP_058 - Laser Combat
    item_registry["SHIP_058"] = ItemData.new()
    item_registry["SHIP_058"].id = "SHIP_058"
    item_registry["SHIP_058"].name = "Laser Combat"
    item_registry["SHIP_058"].category = ItemCategory.SHIP
    item_registry["SHIP_058"].tier = 4
    item_registry["SHIP_058"].base_price = 465000
    item_registry["SHIP_058"].volume = 2450
    item_registry["SHIP_058"].mass = 24500
    item_registry["SHIP_058"].description = "Spaceship hull"

    # SHIP_059 - Artillery Assault
    item_registry["SHIP_059"] = ItemData.new()
    item_registry["SHIP_059"].id = "SHIP_059"
    item_registry["SHIP_059"].name = "Artillery Assault"
    item_registry["SHIP_059"].category = ItemCategory.SHIP
    item_registry["SHIP_059"].tier = 4
    item_registry["SHIP_059"].base_price = 495000
    item_registry["SHIP_059"].volume = 2550
    item_registry["SHIP_059"].mass = 25500
    item_registry["SHIP_059"].description = "Spaceship hull"

    # SHIP_060 - Laser Faction Faction
    item_registry["SHIP_060"] = ItemData.new()
    item_registry["SHIP_060"].id = "SHIP_060"
    item_registry["SHIP_060"].name = "Laser Faction Faction"
    item_registry["SHIP_060"].category = ItemCategory.SHIP
    item_registry["SHIP_060"].tier = 4
    item_registry["SHIP_060"].base_price = 520000
    item_registry["SHIP_060"].volume = 2600
    item_registry["SHIP_060"].mass = 26000
    item_registry["SHIP_060"].description = "Spaceship hull"

    # SHIP_061 - Sentinel Battlecruiser
    item_registry["SHIP_061"] = ItemData.new()
    item_registry["SHIP_061"].id = "SHIP_061"
    item_registry["SHIP_061"].name = "Sentinel Battlecruiser"
    item_registry["SHIP_061"].category = ItemCategory.SHIP
    item_registry["SHIP_061"].tier = 4
    item_registry["SHIP_061"].base_price = 650000
    item_registry["SHIP_061"].volume = 3500
    item_registry["SHIP_061"].mass = 35000
    item_registry["SHIP_061"].description = "Heavy firepower fast attack ship"

    # SHIP_062 - Missile BC Combat
    item_registry["SHIP_062"] = ItemData.new()
    item_registry["SHIP_062"].id = "SHIP_062"
    item_registry["SHIP_062"].name = "Missile BC Combat"
    item_registry["SHIP_062"].category = ItemCategory.SHIP
    item_registry["SHIP_062"].tier = 4
    item_registry["SHIP_062"].base_price = 680000
    item_registry["SHIP_062"].volume = 3600
    item_registry["SHIP_062"].mass = 36000
    item_registry["SHIP_062"].description = "Spaceship hull"

    # SHIP_063 - Railgun BC Artillery
    item_registry["SHIP_063"] = ItemData.new()
    item_registry["SHIP_063"].id = "SHIP_063"
    item_registry["SHIP_063"].name = "Railgun BC Artillery"
    item_registry["SHIP_063"].category = ItemCategory.SHIP
    item_registry["SHIP_063"].tier = 4
    item_registry["SHIP_063"].base_price = 665000
    item_registry["SHIP_063"].volume = 3550
    item_registry["SHIP_063"].mass = 35500
    item_registry["SHIP_063"].description = "Spaceship hull"

    # SHIP_064 - Projectile BC Projectile
    item_registry["SHIP_064"] = ItemData.new()
    item_registry["SHIP_064"].id = "SHIP_064"
    item_registry["SHIP_064"].name = "Projectile BC Projectile"
    item_registry["SHIP_064"].category = ItemCategory.SHIP
    item_registry["SHIP_064"].tier = 4
    item_registry["SHIP_064"].base_price = 695000
    item_registry["SHIP_064"].volume = 3650
    item_registry["SHIP_064"].mass = 36500
    item_registry["SHIP_064"].description = "Spaceship hull"

    # SHIP_065 - Laser BC Attack
    item_registry["SHIP_065"] = ItemData.new()
    item_registry["SHIP_065"].id = "SHIP_065"
    item_registry["SHIP_065"].name = "Laser BC Attack"
    item_registry["SHIP_065"].category = ItemCategory.SHIP
    item_registry["SHIP_065"].tier = 4
    item_registry["SHIP_065"].base_price = 710000
    item_registry["SHIP_065"].volume = 3700
    item_registry["SHIP_065"].mass = 37000
    item_registry["SHIP_065"].description = "Spaceship hull"

    # SHIP_066 - Beam BC Assault
    item_registry["SHIP_066"] = ItemData.new()
    item_registry["SHIP_066"].id = "SHIP_066"
    item_registry["SHIP_066"].name = "Beam BC Assault"
    item_registry["SHIP_066"].category = ItemCategory.SHIP
    item_registry["SHIP_066"].tier = 4
    item_registry["SHIP_066"].base_price = 725000
    item_registry["SHIP_066"].volume = 3750
    item_registry["SHIP_066"].mass = 37500
    item_registry["SHIP_066"].description = "Spaceship hull"

    # SHIP_067 - Drone BC Heavy
    item_registry["SHIP_067"] = ItemData.new()
    item_registry["SHIP_067"].id = "SHIP_067"
    item_registry["SHIP_067"].name = "Drone BC Heavy"
    item_registry["SHIP_067"].category = ItemCategory.SHIP
    item_registry["SHIP_067"].tier = 4
    item_registry["SHIP_067"].base_price = 740000
    item_registry["SHIP_067"].volume = 3800
    item_registry["SHIP_067"].mass = 38000
    item_registry["SHIP_067"].description = "Spaceship hull"

    # SHIP_068 - Blaster BC Blaster
    item_registry["SHIP_068"] = ItemData.new()
    item_registry["SHIP_068"].id = "SHIP_068"
    item_registry["SHIP_068"].name = "Blaster BC Blaster"
    item_registry["SHIP_068"].category = ItemCategory.SHIP
    item_registry["SHIP_068"].tier = 4
    item_registry["SHIP_068"].base_price = 755000
    item_registry["SHIP_068"].volume = 3850
    item_registry["SHIP_068"].mass = 38500
    item_registry["SHIP_068"].description = "Spaceship hull"

    # SHIP_069 - Heavy Missile BC Missile
    item_registry["SHIP_069"] = ItemData.new()
    item_registry["SHIP_069"].id = "SHIP_069"
    item_registry["SHIP_069"].name = "Heavy Missile BC Missile"
    item_registry["SHIP_069"].category = ItemCategory.SHIP
    item_registry["SHIP_069"].tier = 5
    item_registry["SHIP_069"].base_price = 850000
    item_registry["SHIP_069"].volume = 4000
    item_registry["SHIP_069"].mass = 40000
    item_registry["SHIP_069"].description = "Spaceship hull"

    # SHIP_070 - Artillery BC Artillery
    item_registry["SHIP_070"] = ItemData.new()
    item_registry["SHIP_070"].id = "SHIP_070"
    item_registry["SHIP_070"].name = "Artillery BC Artillery"
    item_registry["SHIP_070"].category = ItemCategory.SHIP
    item_registry["SHIP_070"].tier = 5
    item_registry["SHIP_070"].base_price = 835000
    item_registry["SHIP_070"].volume = 3950
    item_registry["SHIP_070"].mass = 39500
    item_registry["SHIP_070"].description = "Spaceship hull"

    # SHIP_071 - Railgun Elite BC Railgun
    item_registry["SHIP_071"] = ItemData.new()
    item_registry["SHIP_071"].id = "SHIP_071"
    item_registry["SHIP_071"].name = "Railgun Elite BC Railgun"
    item_registry["SHIP_071"].category = ItemCategory.SHIP
    item_registry["SHIP_071"].tier = 5
    item_registry["SHIP_071"].base_price = 865000
    item_registry["SHIP_071"].volume = 4050
    item_registry["SHIP_071"].mass = 40500
    item_registry["SHIP_071"].description = "Spaceship hull"

    # SHIP_072 - Laser Elite BC Laser
    item_registry["SHIP_072"] = ItemData.new()
    item_registry["SHIP_072"].id = "SHIP_072"
    item_registry["SHIP_072"].name = "Laser Elite BC Laser"
    item_registry["SHIP_072"].category = ItemCategory.SHIP
    item_registry["SHIP_072"].tier = 5
    item_registry["SHIP_072"].base_price = 880000
    item_registry["SHIP_072"].volume = 4100
    item_registry["SHIP_072"].mass = 41000
    item_registry["SHIP_072"].description = "Spaceship hull"

    # SHIP_073 - Command Battlecruiser
    item_registry["SHIP_073"] = ItemData.new()
    item_registry["SHIP_073"].id = "SHIP_073"
    item_registry["SHIP_073"].name = "Command Battlecruiser"
    item_registry["SHIP_073"].category = ItemCategory.SHIP
    item_registry["SHIP_073"].tier = 5
    item_registry["SHIP_073"].base_price = 920000
    item_registry["SHIP_073"].volume = 4200
    item_registry["SHIP_073"].mass = 42000
    item_registry["SHIP_073"].description = "Heavy firepower fast attack ship"

    # SHIP_074 - Siege Battlecruiser
    item_registry["SHIP_074"] = ItemData.new()
    item_registry["SHIP_074"].id = "SHIP_074"
    item_registry["SHIP_074"].name = "Siege Battlecruiser"
    item_registry["SHIP_074"].category = ItemCategory.SHIP
    item_registry["SHIP_074"].tier = 5
    item_registry["SHIP_074"].base_price = 965000
    item_registry["SHIP_074"].volume = 4300
    item_registry["SHIP_074"].mass = 43000
    item_registry["SHIP_074"].description = "Heavy firepower fast attack ship"

    # SHIP_075 - Elite Battlecruiser
    item_registry["SHIP_075"] = ItemData.new()
    item_registry["SHIP_075"].id = "SHIP_075"
    item_registry["SHIP_075"].name = "Elite Battlecruiser"
    item_registry["SHIP_075"].category = ItemCategory.SHIP
    item_registry["SHIP_075"].tier = 5
    item_registry["SHIP_075"].base_price = 1000000
    item_registry["SHIP_075"].volume = 4400
    item_registry["SHIP_075"].mass = 44000
    item_registry["SHIP_075"].description = "Heavy firepower fast attack ship"

    # SHIP_076 - Sentinel Battleship
    item_registry["SHIP_076"] = ItemData.new()
    item_registry["SHIP_076"].id = "SHIP_076"
    item_registry["SHIP_076"].name = "Sentinel Battleship"
    item_registry["SHIP_076"].category = ItemCategory.SHIP
    item_registry["SHIP_076"].tier = 5
    item_registry["SHIP_076"].base_price = 1200000
    item_registry["SHIP_076"].volume = 5500
    item_registry["SHIP_076"].mass = 55000
    item_registry["SHIP_076"].description = "Heavily armored large combat ship"

    # SHIP_077 - Titan Heavy
    item_registry["SHIP_077"] = ItemData.new()
    item_registry["SHIP_077"].id = "SHIP_077"
    item_registry["SHIP_077"].name = "Titan Heavy"
    item_registry["SHIP_077"].category = ItemCategory.SHIP
    item_registry["SHIP_077"].tier = 5
    item_registry["SHIP_077"].base_price = 1250000
    item_registry["SHIP_077"].volume = 5600
    item_registry["SHIP_077"].mass = 56000
    item_registry["SHIP_077"].description = "Spaceship hull"

    # SHIP_078 - Assault Assault
    item_registry["SHIP_078"] = ItemData.new()
    item_registry["SHIP_078"].id = "SHIP_078"
    item_registry["SHIP_078"].name = "Assault Assault"
    item_registry["SHIP_078"].category = ItemCategory.SHIP
    item_registry["SHIP_078"].tier = 5
    item_registry["SHIP_078"].base_price = 1300000
    item_registry["SHIP_078"].volume = 5700
    item_registry["SHIP_078"].mass = 57000
    item_registry["SHIP_078"].description = "Spaceship hull"

    # SHIP_079 - Laser Laser
    item_registry["SHIP_079"] = ItemData.new()
    item_registry["SHIP_079"].id = "SHIP_079"
    item_registry["SHIP_079"].name = "Laser Laser"
    item_registry["SHIP_079"].category = ItemCategory.SHIP
    item_registry["SHIP_079"].tier = 5
    item_registry["SHIP_079"].base_price = 1400000
    item_registry["SHIP_079"].volume = 6000
    item_registry["SHIP_079"].mass = 60000
    item_registry["SHIP_079"].description = "Spaceship hull"

    # SHIP_080 - Energy Energy
    item_registry["SHIP_080"] = ItemData.new()
    item_registry["SHIP_080"].id = "SHIP_080"
    item_registry["SHIP_080"].name = "Energy Energy"
    item_registry["SHIP_080"].category = ItemCategory.SHIP
    item_registry["SHIP_080"].tier = 5
    item_registry["SHIP_080"].base_price = 1450000
    item_registry["SHIP_080"].volume = 6100
    item_registry["SHIP_080"].mass = 61000
    item_registry["SHIP_080"].description = "Spaceship hull"

    # SHIP_081 - Artillery Artillery
    item_registry["SHIP_081"] = ItemData.new()
    item_registry["SHIP_081"].id = "SHIP_081"
    item_registry["SHIP_081"].name = "Artillery Artillery"
    item_registry["SHIP_081"].category = ItemCategory.SHIP
    item_registry["SHIP_081"].tier = 5
    item_registry["SHIP_081"].base_price = 1500000
    item_registry["SHIP_081"].volume = 6200
    item_registry["SHIP_081"].mass = 62000
    item_registry["SHIP_081"].description = "Spaceship hull"

    # SHIP_082 - Storm Projectile
    item_registry["SHIP_082"] = ItemData.new()
    item_registry["SHIP_082"].id = "SHIP_082"
    item_registry["SHIP_082"].name = "Storm Projectile"
    item_registry["SHIP_082"].category = ItemCategory.SHIP
    item_registry["SHIP_082"].tier = 5
    item_registry["SHIP_082"].base_price = 1350000
    item_registry["SHIP_082"].volume = 5800
    item_registry["SHIP_082"].mass = 58000
    item_registry["SHIP_082"].description = "Spaceship hull"

    # SHIP_083 - Heavy Artillery Artillery
    item_registry["SHIP_083"] = ItemData.new()
    item_registry["SHIP_083"].id = "SHIP_083"
    item_registry["SHIP_083"].name = "Heavy Artillery Artillery"
    item_registry["SHIP_083"].category = ItemCategory.SHIP
    item_registry["SHIP_083"].tier = 5
    item_registry["SHIP_083"].base_price = 1550000
    item_registry["SHIP_083"].volume = 6300
    item_registry["SHIP_083"].mass = 63000
    item_registry["SHIP_083"].description = "Spaceship hull"

    # SHIP_084 - Heavy Missile BC Missile
    item_registry["SHIP_084"] = ItemData.new()
    item_registry["SHIP_084"].id = "SHIP_084"
    item_registry["SHIP_084"].name = "Heavy Missile BC Missile"
    item_registry["SHIP_084"].category = ItemCategory.SHIP
    item_registry["SHIP_084"].tier = 5
    item_registry["SHIP_084"].base_price = 1600000
    item_registry["SHIP_084"].volume = 6400
    item_registry["SHIP_084"].mass = 64000
    item_registry["SHIP_084"].description = "Spaceship hull"

    # SHIP_085 - Cruise Cruise Missile
    item_registry["SHIP_085"] = ItemData.new()
    item_registry["SHIP_085"].id = "SHIP_085"
    item_registry["SHIP_085"].name = "Cruise Cruise Missile"
    item_registry["SHIP_085"].category = ItemCategory.SHIP
    item_registry["SHIP_085"].tier = 5
    item_registry["SHIP_085"].base_price = 1650000
    item_registry["SHIP_085"].volume = 6500
    item_registry["SHIP_085"].mass = 65000
    item_registry["SHIP_085"].description = "Spaceship hull"

    # SHIP_086 - ECM ECM
    item_registry["SHIP_086"] = ItemData.new()
    item_registry["SHIP_086"].id = "SHIP_086"
    item_registry["SHIP_086"].name = "ECM ECM"
    item_registry["SHIP_086"].category = ItemCategory.SHIP
    item_registry["SHIP_086"].tier = 5
    item_registry["SHIP_086"].base_price = 1700000
    item_registry["SHIP_086"].volume = 6600
    item_registry["SHIP_086"].mass = 66000
    item_registry["SHIP_086"].description = "Spaceship hull"

    # SHIP_087 - Railgun Railgun
    item_registry["SHIP_087"] = ItemData.new()
    item_registry["SHIP_087"].id = "SHIP_087"
    item_registry["SHIP_087"].name = "Railgun Railgun"
    item_registry["SHIP_087"].category = ItemCategory.SHIP
    item_registry["SHIP_087"].tier = 5
    item_registry["SHIP_087"].base_price = 1625000
    item_registry["SHIP_087"].volume = 6450
    item_registry["SHIP_087"].mass = 64500
    item_registry["SHIP_087"].description = "Spaceship hull"

    # SHIP_088 - Assault Blaster
    item_registry["SHIP_088"] = ItemData.new()
    item_registry["SHIP_088"].id = "SHIP_088"
    item_registry["SHIP_088"].name = "Assault Blaster"
    item_registry["SHIP_088"].category = ItemCategory.SHIP
    item_registry["SHIP_088"].tier = 5
    item_registry["SHIP_088"].base_price = 1375000
    item_registry["SHIP_088"].volume = 5900
    item_registry["SHIP_088"].mass = 59000
    item_registry["SHIP_088"].description = "Spaceship hull"

    # SHIP_089 - Blaster Marauder Marauder
    item_registry["SHIP_089"] = ItemData.new()
    item_registry["SHIP_089"].id = "SHIP_089"
    item_registry["SHIP_089"].name = "Blaster Marauder Marauder"
    item_registry["SHIP_089"].category = ItemCategory.SHIP
    item_registry["SHIP_089"].tier = 5
    item_registry["SHIP_089"].base_price = 1900000
    item_registry["SHIP_089"].volume = 6800
    item_registry["SHIP_089"].mass = 68000
    item_registry["SHIP_089"].description = "Spaceship hull"

    # SHIP_090 - Laser Marauder Marauder
    item_registry["SHIP_090"] = ItemData.new()
    item_registry["SHIP_090"].id = "SHIP_090"
    item_registry["SHIP_090"].name = "Laser Marauder Marauder"
    item_registry["SHIP_090"].category = ItemCategory.SHIP
    item_registry["SHIP_090"].tier = 5
    item_registry["SHIP_090"].base_price = 1875000
    item_registry["SHIP_090"].volume = 6750
    item_registry["SHIP_090"].mass = 67500
    item_registry["SHIP_090"].description = "Spaceship hull"

    # SHIP_091 - Projectile Marauder Marauder
    item_registry["SHIP_091"] = ItemData.new()
    item_registry["SHIP_091"].id = "SHIP_091"
    item_registry["SHIP_091"].name = "Projectile Marauder Marauder"
    item_registry["SHIP_091"].category = ItemCategory.SHIP
    item_registry["SHIP_091"].tier = 5
    item_registry["SHIP_091"].base_price = 1925000
    item_registry["SHIP_091"].volume = 6850
    item_registry["SHIP_091"].mass = 68500
    item_registry["SHIP_091"].description = "Spaceship hull"

    # SHIP_092 - Missile Marauder Marauder
    item_registry["SHIP_092"] = ItemData.new()
    item_registry["SHIP_092"].id = "SHIP_092"
    item_registry["SHIP_092"].name = "Missile Marauder Marauder"
    item_registry["SHIP_092"].category = ItemCategory.SHIP
    item_registry["SHIP_092"].tier = 5
    item_registry["SHIP_092"].base_price = 1950000
    item_registry["SHIP_092"].volume = 6900
    item_registry["SHIP_092"].mass = 69000
    item_registry["SHIP_092"].description = "Spaceship hull"

    # SHIP_093 - Laser Faction Faction
    item_registry["SHIP_093"] = ItemData.new()
    item_registry["SHIP_093"].id = "SHIP_093"
    item_registry["SHIP_093"].name = "Laser Faction Faction"
    item_registry["SHIP_093"].category = ItemCategory.SHIP
    item_registry["SHIP_093"].tier = 5
    item_registry["SHIP_093"].base_price = 2100000
    item_registry["SHIP_093"].volume = 7000
    item_registry["SHIP_093"].mass = 70000
    item_registry["SHIP_093"].description = "Spaceship hull"

    # SHIP_094 - Blaster Faction Faction
    item_registry["SHIP_094"] = ItemData.new()
    item_registry["SHIP_094"].id = "SHIP_094"
    item_registry["SHIP_094"].name = "Blaster Faction Faction"
    item_registry["SHIP_094"].category = ItemCategory.SHIP
    item_registry["SHIP_094"].tier = 5
    item_registry["SHIP_094"].base_price = 2150000
    item_registry["SHIP_094"].volume = 7050
    item_registry["SHIP_094"].mass = 70500
    item_registry["SHIP_094"].description = "Spaceship hull"

    # SHIP_095 - Projectile Faction Faction
    item_registry["SHIP_095"] = ItemData.new()
    item_registry["SHIP_095"].id = "SHIP_095"
    item_registry["SHIP_095"].name = "Projectile Faction Faction"
    item_registry["SHIP_095"].category = ItemCategory.SHIP
    item_registry["SHIP_095"].tier = 5
    item_registry["SHIP_095"].base_price = 2200000
    item_registry["SHIP_095"].volume = 7100
    item_registry["SHIP_095"].mass = 71000
    item_registry["SHIP_095"].description = "Spaceship hull"

    # SHIP_096 - Drone Carrier Carrier
    item_registry["SHIP_096"] = ItemData.new()
    item_registry["SHIP_096"].id = "SHIP_096"
    item_registry["SHIP_096"].name = "Drone Carrier Carrier"
    item_registry["SHIP_096"].category = ItemCategory.SHIP
    item_registry["SHIP_096"].tier = 4
    item_registry["SHIP_096"].base_price = 2000000
    item_registry["SHIP_096"].volume = 7000
    item_registry["SHIP_096"].mass = 70000
    item_registry["SHIP_096"].description = "Fighter/bomber deployment platform"

    # SHIP_097 - Armor Carrier Carrier
    item_registry["SHIP_097"] = ItemData.new()
    item_registry["SHIP_097"].id = "SHIP_097"
    item_registry["SHIP_097"].name = "Armor Carrier Carrier"
    item_registry["SHIP_097"].category = ItemCategory.SHIP
    item_registry["SHIP_097"].tier = 4
    item_registry["SHIP_097"].base_price = 2100000
    item_registry["SHIP_097"].volume = 7200
    item_registry["SHIP_097"].mass = 72000
    item_registry["SHIP_097"].description = "Fighter/bomber deployment platform"

    # SHIP_098 - Shield Carrier Carrier
    item_registry["SHIP_098"] = ItemData.new()
    item_registry["SHIP_098"].id = "SHIP_098"
    item_registry["SHIP_098"].name = "Shield Carrier Carrier"
    item_registry["SHIP_098"].category = ItemCategory.SHIP
    item_registry["SHIP_098"].tier = 4
    item_registry["SHIP_098"].base_price = 2050000
    item_registry["SHIP_098"].volume = 7100
    item_registry["SHIP_098"].mass = 71000
    item_registry["SHIP_098"].description = "Fighter/bomber deployment platform"

    # SHIP_099 - Projectile Carrier Carrier
    item_registry["SHIP_099"] = ItemData.new()
    item_registry["SHIP_099"].id = "SHIP_099"
    item_registry["SHIP_099"].name = "Projectile Carrier Carrier"
    item_registry["SHIP_099"].category = ItemCategory.SHIP
    item_registry["SHIP_099"].tier = 5
    item_registry["SHIP_099"].base_price = 2300000
    item_registry["SHIP_099"].volume = 7400
    item_registry["SHIP_099"].mass = 74000
    item_registry["SHIP_099"].description = "Fighter/bomber deployment platform"

    # SHIP_100 - Laser Supercarrier Supercarrier
    item_registry["SHIP_100"] = ItemData.new()
    item_registry["SHIP_100"].id = "SHIP_100"
    item_registry["SHIP_100"].name = "Laser Supercarrier Supercarrier"
    item_registry["SHIP_100"].category = ItemCategory.SHIP
    item_registry["SHIP_100"].tier = 5
    item_registry["SHIP_100"].base_price = 2800000
    item_registry["SHIP_100"].volume = 7800
    item_registry["SHIP_100"].mass = 78000
    item_registry["SHIP_100"].description = "Spaceship hull"

    # SHIP_101 - Projectile Supercarrier Supercarrier
    item_registry["SHIP_101"] = ItemData.new()
    item_registry["SHIP_101"].id = "SHIP_101"
    item_registry["SHIP_101"].name = "Projectile Supercarrier Supercarrier"
    item_registry["SHIP_101"].category = ItemCategory.SHIP
    item_registry["SHIP_101"].tier = 5
    item_registry["SHIP_101"].base_price = 2900000
    item_registry["SHIP_101"].volume = 7900
    item_registry["SHIP_101"].mass = 79000
    item_registry["SHIP_101"].description = "Spaceship hull"

    # SHIP_102 - Hybrid Supercarrier Supercarrier
    item_registry["SHIP_102"] = ItemData.new()
    item_registry["SHIP_102"].id = "SHIP_102"
    item_registry["SHIP_102"].name = "Hybrid Supercarrier Supercarrier"
    item_registry["SHIP_102"].category = ItemCategory.SHIP
    item_registry["SHIP_102"].tier = 5
    item_registry["SHIP_102"].base_price = 3000000
    item_registry["SHIP_102"].volume = 8000
    item_registry["SHIP_102"].mass = 80000
    item_registry["SHIP_102"].description = "Spaceship hull"

    # SHIP_103 - Missile Dreadnought Dreadnought
    item_registry["SHIP_103"] = ItemData.new()
    item_registry["SHIP_103"].id = "SHIP_103"
    item_registry["SHIP_103"].name = "Missile Dreadnought Dreadnought"
    item_registry["SHIP_103"].category = ItemCategory.SHIP
    item_registry["SHIP_103"].tier = 5
    item_registry["SHIP_103"].base_price = 4000000
    item_registry["SHIP_103"].volume = 9000
    item_registry["SHIP_103"].mass = 90000
    item_registry["SHIP_103"].description = "Massive capital ship with siege weapons"

    # SHIP_104 - Blaster Dreadnought Dreadnought
    item_registry["SHIP_104"] = ItemData.new()
    item_registry["SHIP_104"].id = "SHIP_104"
    item_registry["SHIP_104"].name = "Blaster Dreadnought Dreadnought"
    item_registry["SHIP_104"].category = ItemCategory.SHIP
    item_registry["SHIP_104"].tier = 5
    item_registry["SHIP_104"].base_price = 4100000
    item_registry["SHIP_104"].volume = 9100
    item_registry["SHIP_104"].mass = 91000
    item_registry["SHIP_104"].description = "Massive capital ship with siege weapons"

    # SHIP_105 - Laser Dreadnought Dreadnought
    item_registry["SHIP_105"] = ItemData.new()
    item_registry["SHIP_105"].id = "SHIP_105"
    item_registry["SHIP_105"].name = "Laser Dreadnought Dreadnought"
    item_registry["SHIP_105"].category = ItemCategory.SHIP
    item_registry["SHIP_105"].tier = 5
    item_registry["SHIP_105"].base_price = 4200000
    item_registry["SHIP_105"].volume = 9200
    item_registry["SHIP_105"].mass = 92000
    item_registry["SHIP_105"].description = "Massive capital ship with siege weapons"

    # SHIP_106 - Projectile Dreadnought Dreadnought
    item_registry["SHIP_106"] = ItemData.new()
    item_registry["SHIP_106"].id = "SHIP_106"
    item_registry["SHIP_106"].name = "Projectile Dreadnought Dreadnought"
    item_registry["SHIP_106"].category = ItemCategory.SHIP
    item_registry["SHIP_106"].tier = 5
    item_registry["SHIP_106"].base_price = 4300000
    item_registry["SHIP_106"].volume = 9300
    item_registry["SHIP_106"].mass = 93000
    item_registry["SHIP_106"].description = "Massive capital ship with siege weapons"

    # SHIP_107 - Pirate DN-A Dreadnought
    item_registry["SHIP_107"] = ItemData.new()
    item_registry["SHIP_107"].id = "SHIP_107"
    item_registry["SHIP_107"].name = "Pirate DN-A Dreadnought"
    item_registry["SHIP_107"].category = ItemCategory.SHIP
    item_registry["SHIP_107"].tier = 5
    item_registry["SHIP_107"].base_price = 4600000
    item_registry["SHIP_107"].volume = 9500
    item_registry["SHIP_107"].mass = 95000
    item_registry["SHIP_107"].description = "Massive capital ship with siege weapons"

    # SHIP_108 - Pirate DN-B Dreadnought
    item_registry["SHIP_108"] = ItemData.new()
    item_registry["SHIP_108"].id = "SHIP_108"
    item_registry["SHIP_108"].name = "Pirate DN-B Dreadnought"
    item_registry["SHIP_108"].category = ItemCategory.SHIP
    item_registry["SHIP_108"].tier = 5
    item_registry["SHIP_108"].base_price = 4500000
    item_registry["SHIP_108"].volume = 9400
    item_registry["SHIP_108"].mass = 94000
    item_registry["SHIP_108"].description = "Massive capital ship with siege weapons"

    # SHIP_109 - Faction DN Dreadnought
    item_registry["SHIP_109"] = ItemData.new()
    item_registry["SHIP_109"].id = "SHIP_109"
    item_registry["SHIP_109"].name = "Faction DN Dreadnought"
    item_registry["SHIP_109"].category = ItemCategory.SHIP
    item_registry["SHIP_109"].tier = 5
    item_registry["SHIP_109"].base_price = 4800000
    item_registry["SHIP_109"].volume = 9600
    item_registry["SHIP_109"].mass = 96000
    item_registry["SHIP_109"].description = "Massive capital ship with siege weapons"

    # SHIP_110 - Pirate DN-C Dreadnought
    item_registry["SHIP_110"] = ItemData.new()
    item_registry["SHIP_110"].id = "SHIP_110"
    item_registry["SHIP_110"].name = "Pirate DN-C Dreadnought"
    item_registry["SHIP_110"].category = ItemCategory.SHIP
    item_registry["SHIP_110"].tier = 5
    item_registry["SHIP_110"].base_price = 4900000
    item_registry["SHIP_110"].volume = 9700
    item_registry["SHIP_110"].mass = 97000
    item_registry["SHIP_110"].description = "Massive capital ship with siege weapons"

    # SHIP_111 - Pirate DN-D Dreadnought
    item_registry["SHIP_111"] = ItemData.new()
    item_registry["SHIP_111"].id = "SHIP_111"
    item_registry["SHIP_111"].name = "Pirate DN-D Dreadnought"
    item_registry["SHIP_111"].category = ItemCategory.SHIP
    item_registry["SHIP_111"].tier = 5
    item_registry["SHIP_111"].base_price = 5000000
    item_registry["SHIP_111"].volume = 9800
    item_registry["SHIP_111"].mass = 98000
    item_registry["SHIP_111"].description = "Massive capital ship with siege weapons"

    # SHIP_112 - Faction DN Elite Dreadnought
    item_registry["SHIP_112"] = ItemData.new()
    item_registry["SHIP_112"].id = "SHIP_112"
    item_registry["SHIP_112"].name = "Faction DN Elite Dreadnought"
    item_registry["SHIP_112"].category = ItemCategory.SHIP
    item_registry["SHIP_112"].tier = 5
    item_registry["SHIP_112"].base_price = 5100000
    item_registry["SHIP_112"].volume = 9900
    item_registry["SHIP_112"].mass = 99000
    item_registry["SHIP_112"].description = "Massive capital ship with siege weapons"

    # SHIP_113 - Laser Titan Titan
    item_registry["SHIP_113"] = ItemData.new()
    item_registry["SHIP_113"].id = "SHIP_113"
    item_registry["SHIP_113"].name = "Laser Titan Titan"
    item_registry["SHIP_113"].category = ItemCategory.SHIP
    item_registry["SHIP_113"].tier = 5
    item_registry["SHIP_113"].base_price = 10000000
    item_registry["SHIP_113"].volume = 15000
    item_registry["SHIP_113"].mass = 150000
    item_registry["SHIP_113"].description = "Flagship supercarrier command ship"

    # SHIP_114 - Hybrid Titan Titan
    item_registry["SHIP_114"] = ItemData.new()
    item_registry["SHIP_114"].id = "SHIP_114"
    item_registry["SHIP_114"].name = "Hybrid Titan Titan"
    item_registry["SHIP_114"].category = ItemCategory.SHIP
    item_registry["SHIP_114"].tier = 5
    item_registry["SHIP_114"].base_price = 10500000
    item_registry["SHIP_114"].volume = 15200
    item_registry["SHIP_114"].mass = 152000
    item_registry["SHIP_114"].description = "Flagship supercarrier command ship"

    # SHIP_115 - Missile Titan Titan
    item_registry["SHIP_115"] = ItemData.new()
    item_registry["SHIP_115"].id = "SHIP_115"
    item_registry["SHIP_115"].name = "Missile Titan Titan"
    item_registry["SHIP_115"].category = ItemCategory.SHIP
    item_registry["SHIP_115"].tier = 5
    item_registry["SHIP_115"].base_price = 11000000
    item_registry["SHIP_115"].volume = 15400
    item_registry["SHIP_115"].mass = 154000
    item_registry["SHIP_115"].description = "Flagship supercarrier command ship"

    # SHIP_116 - Projectile Titan Titan
    item_registry["SHIP_116"] = ItemData.new()
    item_registry["SHIP_116"].id = "SHIP_116"
    item_registry["SHIP_116"].name = "Projectile Titan Titan"
    item_registry["SHIP_116"].category = ItemCategory.SHIP
    item_registry["SHIP_116"].tier = 5
    item_registry["SHIP_116"].base_price = 11500000
    item_registry["SHIP_116"].volume = 15600
    item_registry["SHIP_116"].mass = 156000
    item_registry["SHIP_116"].description = "Flagship supercarrier command ship"

    # SHIP_117 - Faction Titan-A Titan
    item_registry["SHIP_117"] = ItemData.new()
    item_registry["SHIP_117"].id = "SHIP_117"
    item_registry["SHIP_117"].name = "Faction Titan-A Titan"
    item_registry["SHIP_117"].category = ItemCategory.SHIP
    item_registry["SHIP_117"].tier = 5
    item_registry["SHIP_117"].base_price = 12500000
    item_registry["SHIP_117"].volume = 16000
    item_registry["SHIP_117"].mass = 160000
    item_registry["SHIP_117"].description = "Flagship supercarrier command ship"

    # SHIP_118 - Faction Titan-B Titan
    item_registry["SHIP_118"] = ItemData.new()
    item_registry["SHIP_118"].id = "SHIP_118"
    item_registry["SHIP_118"].name = "Faction Titan-B Titan"
    item_registry["SHIP_118"].category = ItemCategory.SHIP
    item_registry["SHIP_118"].tier = 5
    item_registry["SHIP_118"].base_price = 13000000
    item_registry["SHIP_118"].volume = 16200
    item_registry["SHIP_118"].mass = 162000
    item_registry["SHIP_118"].description = "Flagship supercarrier command ship"

    # SHIP_119 - Pirate DN-D Titan
    item_registry["SHIP_119"] = ItemData.new()
    item_registry["SHIP_119"].id = "SHIP_119"
    item_registry["SHIP_119"].name = "Pirate DN-D Titan"
    item_registry["SHIP_119"].category = ItemCategory.SHIP
    item_registry["SHIP_119"].tier = 5
    item_registry["SHIP_119"].base_price = 13500000
    item_registry["SHIP_119"].volume = 16400
    item_registry["SHIP_119"].mass = 164000
    item_registry["SHIP_119"].description = "Flagship supercarrier command ship"

    # SHIP_120 - Faction DN Elite Titan
    item_registry["SHIP_120"] = ItemData.new()
    item_registry["SHIP_120"].id = "SHIP_120"
    item_registry["SHIP_120"].name = "Faction DN Elite Titan"
    item_registry["SHIP_120"].category = ItemCategory.SHIP
    item_registry["SHIP_120"].tier = 5
    item_registry["SHIP_120"].base_price = 14000000
    item_registry["SHIP_120"].volume = 16500
    item_registry["SHIP_120"].mass = 165000
    item_registry["SHIP_120"].description = "Flagship supercarrier command ship"

    # SHIP_121 - Mining Frigate Mining Frigate
    item_registry["SHIP_121"] = ItemData.new()
    item_registry["SHIP_121"].id = "SHIP_121"
    item_registry["SHIP_121"].name = "Mining Frigate Mining Frigate"
    item_registry["SHIP_121"].category = ItemCategory.SHIP
    item_registry["SHIP_121"].tier = 2
    item_registry["SHIP_121"].base_price = 80000
    item_registry["SHIP_121"].volume = 650
    item_registry["SHIP_121"].mass = 6500
    item_registry["SHIP_121"].description = "Fast, versatile small combat ship"

    # SHIP_122 - Expedition Frigate Expedition
    item_registry["SHIP_122"] = ItemData.new()
    item_registry["SHIP_122"].id = "SHIP_122"
    item_registry["SHIP_122"].name = "Expedition Frigate Expedition"
    item_registry["SHIP_122"].category = ItemCategory.SHIP
    item_registry["SHIP_122"].tier = 3
    item_registry["SHIP_122"].base_price = 120000
    item_registry["SHIP_122"].volume = 750
    item_registry["SHIP_122"].mass = 7500
    item_registry["SHIP_122"].description = "Spaceship hull"

    # SHIP_123 - Tanked Barge Mining Barge
    item_registry["SHIP_123"] = ItemData.new()
    item_registry["SHIP_123"].id = "SHIP_123"
    item_registry["SHIP_123"].name = "Tanked Barge Mining Barge"
    item_registry["SHIP_123"].category = ItemCategory.SHIP
    item_registry["SHIP_123"].tier = 3
    item_registry["SHIP_123"].base_price = 280000
    item_registry["SHIP_123"].volume = 1800
    item_registry["SHIP_123"].mass = 18000
    item_registry["SHIP_123"].description = "Asteroid mining specialist ship"

    # SHIP_124 - Standard Barge Mining Barge
    item_registry["SHIP_124"] = ItemData.new()
    item_registry["SHIP_124"].id = "SHIP_124"
    item_registry["SHIP_124"].name = "Standard Barge Mining Barge"
    item_registry["SHIP_124"].category = ItemCategory.SHIP
    item_registry["SHIP_124"].tier = 3
    item_registry["SHIP_124"].base_price = 300000
    item_registry["SHIP_124"].volume = 1900
    item_registry["SHIP_124"].mass = 19000
    item_registry["SHIP_124"].description = "Asteroid mining specialist ship"

    # SHIP_125 - Yield Barge Mining Barge
    item_registry["SHIP_125"] = ItemData.new()
    item_registry["SHIP_125"].id = "SHIP_125"
    item_registry["SHIP_125"].name = "Yield Barge Mining Barge"
    item_registry["SHIP_125"].category = ItemCategory.SHIP
    item_registry["SHIP_125"].tier = 3
    item_registry["SHIP_125"].base_price = 270000
    item_registry["SHIP_125"].volume = 1750
    item_registry["SHIP_125"].mass = 17500
    item_registry["SHIP_125"].description = "Asteroid mining specialist ship"

    # SHIP_126 - Tanked Exhumer Exhumer
    item_registry["SHIP_126"] = ItemData.new()
    item_registry["SHIP_126"].id = "SHIP_126"
    item_registry["SHIP_126"].name = "Tanked Exhumer Exhumer"
    item_registry["SHIP_126"].category = ItemCategory.SHIP
    item_registry["SHIP_126"].tier = 4
    item_registry["SHIP_126"].base_price = 450000
    item_registry["SHIP_126"].volume = 2200
    item_registry["SHIP_126"].mass = 22000
    item_registry["SHIP_126"].description = "Spaceship hull"

    # SHIP_127 - Standard Exhumer Exhumer
    item_registry["SHIP_127"] = ItemData.new()
    item_registry["SHIP_127"].id = "SHIP_127"
    item_registry["SHIP_127"].name = "Standard Exhumer Exhumer"
    item_registry["SHIP_127"].category = ItemCategory.SHIP
    item_registry["SHIP_127"].tier = 4
    item_registry["SHIP_127"].base_price = 480000
    item_registry["SHIP_127"].volume = 2300
    item_registry["SHIP_127"].mass = 23000
    item_registry["SHIP_127"].description = "Spaceship hull"

    # SHIP_128 - Yield Exhumer Exhumer
    item_registry["SHIP_128"] = ItemData.new()
    item_registry["SHIP_128"].id = "SHIP_128"
    item_registry["SHIP_128"].name = "Yield Exhumer Exhumer"
    item_registry["SHIP_128"].category = ItemCategory.SHIP
    item_registry["SHIP_128"].tier = 4
    item_registry["SHIP_128"].base_price = 510000
    item_registry["SHIP_128"].volume = 2400
    item_registry["SHIP_128"].mass = 24000
    item_registry["SHIP_128"].description = "Spaceship hull"

    # SHIP_129 - Industrial Command Industrial Command
    item_registry["SHIP_129"] = ItemData.new()
    item_registry["SHIP_129"].id = "SHIP_129"
    item_registry["SHIP_129"].name = "Industrial Command Industrial Command"
    item_registry["SHIP_129"].category = ItemCategory.SHIP
    item_registry["SHIP_129"].tier = 4
    item_registry["SHIP_129"].base_price = 1800000
    item_registry["SHIP_129"].volume = 6500
    item_registry["SHIP_129"].mass = 65000
    item_registry["SHIP_129"].description = "Industrial operations support ship"

    # SHIP_130 - Capital Industrial Capital Industrial
    item_registry["SHIP_130"] = ItemData.new()
    item_registry["SHIP_130"].id = "SHIP_130"
    item_registry["SHIP_130"].name = "Capital Industrial Capital Industrial"
    item_registry["SHIP_130"].category = ItemCategory.SHIP
    item_registry["SHIP_130"].tier = 5
    item_registry["SHIP_130"].base_price = 3500000
    item_registry["SHIP_130"].volume = 8500
    item_registry["SHIP_130"].mass = 85000
    item_registry["SHIP_130"].description = "Industrial operations support ship"

    # SHIP_131 - Fast Hauler Hauler
    item_registry["SHIP_131"] = ItemData.new()
    item_registry["SHIP_131"].id = "SHIP_131"
    item_registry["SHIP_131"].name = "Fast Hauler Hauler"
    item_registry["SHIP_131"].category = ItemCategory.SHIP
    item_registry["SHIP_131"].tier = 2
    item_registry["SHIP_131"].base_price = 160000
    item_registry["SHIP_131"].volume = 1500
    item_registry["SHIP_131"].mass = 15000
    item_registry["SHIP_131"].description = "Large cargo transport vessel"

    # SHIP_132 - Medium Hauler Hauler
    item_registry["SHIP_132"] = ItemData.new()
    item_registry["SHIP_132"].id = "SHIP_132"
    item_registry["SHIP_132"].name = "Medium Hauler Hauler"
    item_registry["SHIP_132"].category = ItemCategory.SHIP
    item_registry["SHIP_132"].tier = 2
    item_registry["SHIP_132"].base_price = 180000
    item_registry["SHIP_132"].volume = 1600
    item_registry["SHIP_132"].mass = 16000
    item_registry["SHIP_132"].description = "Large cargo transport vessel"

    # SHIP_133 - Standard Hauler Hauler
    item_registry["SHIP_133"] = ItemData.new()
    item_registry["SHIP_133"].id = "SHIP_133"
    item_registry["SHIP_133"].name = "Standard Hauler Hauler"
    item_registry["SHIP_133"].category = ItemCategory.SHIP
    item_registry["SHIP_133"].tier = 2
    item_registry["SHIP_133"].base_price = 170000
    item_registry["SHIP_133"].volume = 1550
    item_registry["SHIP_133"].mass = 15500
    item_registry["SHIP_133"].description = "Large cargo transport vessel"

    # SHIP_134 - Large Hauler V Hauler
    item_registry["SHIP_134"] = ItemData.new()
    item_registry["SHIP_134"].id = "SHIP_134"
    item_registry["SHIP_134"].name = "Large Hauler V Hauler"
    item_registry["SHIP_134"].category = ItemCategory.SHIP
    item_registry["SHIP_134"].tier = 3
    item_registry["SHIP_134"].base_price = 250000
    item_registry["SHIP_134"].volume = 1950
    item_registry["SHIP_134"].mass = 19500
    item_registry["SHIP_134"].description = "Large cargo transport vessel"

    # SHIP_135 - Heavy Hauler Hauler
    item_registry["SHIP_135"] = ItemData.new()
    item_registry["SHIP_135"].id = "SHIP_135"
    item_registry["SHIP_135"].name = "Heavy Hauler Hauler"
    item_registry["SHIP_135"].category = ItemCategory.SHIP
    item_registry["SHIP_135"].tier = 3
    item_registry["SHIP_135"].base_price = 265000
    item_registry["SHIP_135"].volume = 2000
    item_registry["SHIP_135"].mass = 20000
    item_registry["SHIP_135"].description = "Large cargo transport vessel"

    # SHIP_136 - Specialist Hauler Specialist
    item_registry["SHIP_136"] = ItemData.new()
    item_registry["SHIP_136"].id = "SHIP_136"
    item_registry["SHIP_136"].name = "Specialist Hauler Specialist"
    item_registry["SHIP_136"].category = ItemCategory.SHIP
    item_registry["SHIP_136"].tier = 3
    item_registry["SHIP_136"].base_price = 235000
    item_registry["SHIP_136"].volume = 1850
    item_registry["SHIP_136"].mass = 18500
    item_registry["SHIP_136"].description = "Spaceship hull"

    # SHIP_137 - Ore Hauler Ore Hauler
    item_registry["SHIP_137"] = ItemData.new()
    item_registry["SHIP_137"].id = "SHIP_137"
    item_registry["SHIP_137"].name = "Ore Hauler Ore Hauler"
    item_registry["SHIP_137"].category = ItemCategory.SHIP
    item_registry["SHIP_137"].tier = 3
    item_registry["SHIP_137"].base_price = 245000
    item_registry["SHIP_137"].volume = 1900
    item_registry["SHIP_137"].mass = 19000
    item_registry["SHIP_137"].description = "Large cargo transport vessel"

    # SHIP_138 - Gas Hauler Gas Hauler
    item_registry["SHIP_138"] = ItemData.new()
    item_registry["SHIP_138"].id = "SHIP_138"
    item_registry["SHIP_138"].name = "Gas Hauler Gas Hauler"
    item_registry["SHIP_138"].category = ItemCategory.SHIP
    item_registry["SHIP_138"].tier = 3
    item_registry["SHIP_138"].base_price = 240000
    item_registry["SHIP_138"].volume = 1880
    item_registry["SHIP_138"].mass = 18800
    item_registry["SHIP_138"].description = "Large cargo transport vessel"

    # SHIP_139 - Planetary Hauler Planetary
    item_registry["SHIP_139"] = ItemData.new()
    item_registry["SHIP_139"].id = "SHIP_139"
    item_registry["SHIP_139"].name = "Planetary Hauler Planetary"
    item_registry["SHIP_139"].category = ItemCategory.SHIP
    item_registry["SHIP_139"].tier = 3
    item_registry["SHIP_139"].base_price = 230000
    item_registry["SHIP_139"].volume = 1820
    item_registry["SHIP_139"].mass = 18200
    item_registry["SHIP_139"].description = "Spaceship hull"

    # SHIP_140 - Quick Hauler Quick
    item_registry["SHIP_140"] = ItemData.new()
    item_registry["SHIP_140"].id = "SHIP_140"
    item_registry["SHIP_140"].name = "Quick Hauler Quick"
    item_registry["SHIP_140"].category = ItemCategory.SHIP
    item_registry["SHIP_140"].tier = 2
    item_registry["SHIP_140"].base_price = 150000
    item_registry["SHIP_140"].volume = 1450
    item_registry["SHIP_140"].mass = 14500
    item_registry["SHIP_140"].description = "Spaceship hull"

    # SHIP_141 - DST-A Deep Space
    item_registry["SHIP_141"] = ItemData.new()
    item_registry["SHIP_141"].id = "SHIP_141"
    item_registry["SHIP_141"].name = "DST-A Deep Space"
    item_registry["SHIP_141"].category = ItemCategory.SHIP
    item_registry["SHIP_141"].tier = 4
    item_registry["SHIP_141"].base_price = 620000
    item_registry["SHIP_141"].volume = 3200
    item_registry["SHIP_141"].mass = 32000
    item_registry["SHIP_141"].description = "Spaceship hull"

    # SHIP_142 - DST-B Deep Space
    item_registry["SHIP_142"] = ItemData.new()
    item_registry["SHIP_142"].id = "SHIP_142"
    item_registry["SHIP_142"].name = "DST-B Deep Space"
    item_registry["SHIP_142"].category = ItemCategory.SHIP
    item_registry["SHIP_142"].tier = 4
    item_registry["SHIP_142"].base_price = 650000
    item_registry["SHIP_142"].volume = 3300
    item_registry["SHIP_142"].mass = 33000
    item_registry["SHIP_142"].description = "Spaceship hull"

    # SHIP_143 - BR-A Blockade Runner
    item_registry["SHIP_143"] = ItemData.new()
    item_registry["SHIP_143"].id = "SHIP_143"
    item_registry["SHIP_143"].name = "BR-A Blockade Runner"
    item_registry["SHIP_143"].category = ItemCategory.SHIP
    item_registry["SHIP_143"].tier = 4
    item_registry["SHIP_143"].base_price = 480000
    item_registry["SHIP_143"].volume = 2500
    item_registry["SHIP_143"].mass = 25000
    item_registry["SHIP_143"].description = "Spaceship hull"

    # SHIP_144 - BR-B Blockade Runner
    item_registry["SHIP_144"] = ItemData.new()
    item_registry["SHIP_144"].id = "SHIP_144"
    item_registry["SHIP_144"].name = "BR-B Blockade Runner"
    item_registry["SHIP_144"].category = ItemCategory.SHIP
    item_registry["SHIP_144"].tier = 4
    item_registry["SHIP_144"].base_price = 470000
    item_registry["SHIP_144"].volume = 2450
    item_registry["SHIP_144"].mass = 24500
    item_registry["SHIP_144"].description = "Spaceship hull"

    # SHIP_145 - Standard Freighter Freighter
    item_registry["SHIP_145"] = ItemData.new()
    item_registry["SHIP_145"].id = "SHIP_145"
    item_registry["SHIP_145"].name = "Standard Freighter Freighter"
    item_registry["SHIP_145"].category = ItemCategory.SHIP
    item_registry["SHIP_145"].tier = 5
    item_registry["SHIP_145"].base_price = 6000000
    item_registry["SHIP_145"].volume = 12000
    item_registry["SHIP_145"].mass = 120000
    item_registry["SHIP_145"].description = "Large cargo transport vessel"

    # SHIP_146 - Heavy Freighter Freighter
    item_registry["SHIP_146"] = ItemData.new()
    item_registry["SHIP_146"].id = "SHIP_146"
    item_registry["SHIP_146"].name = "Heavy Freighter Freighter"
    item_registry["SHIP_146"].category = ItemCategory.SHIP
    item_registry["SHIP_146"].tier = 5
    item_registry["SHIP_146"].base_price = 6500000
    item_registry["SHIP_146"].volume = 12500
    item_registry["SHIP_146"].mass = 125000
    item_registry["SHIP_146"].description = "Large cargo transport vessel"

    # SHIP_147 - Fast Freighter Freighter
    item_registry["SHIP_147"] = ItemData.new()
    item_registry["SHIP_147"].id = "SHIP_147"
    item_registry["SHIP_147"].name = "Fast Freighter Freighter"
    item_registry["SHIP_147"].category = ItemCategory.SHIP
    item_registry["SHIP_147"].tier = 5
    item_registry["SHIP_147"].base_price = 6200000
    item_registry["SHIP_147"].volume = 12200
    item_registry["SHIP_147"].mass = 122000
    item_registry["SHIP_147"].description = "Large cargo transport vessel"

    # SHIP_148 - Covert Ops Covert Ops
    item_registry["SHIP_148"] = ItemData.new()
    item_registry["SHIP_148"].id = "SHIP_148"
    item_registry["SHIP_148"].name = "Covert Ops Covert Ops"
    item_registry["SHIP_148"].category = ItemCategory.SHIP
    item_registry["SHIP_148"].tier = 3
    item_registry["SHIP_148"].base_price = 115000
    item_registry["SHIP_148"].volume = 720
    item_registry["SHIP_148"].mass = 7200
    item_registry["SHIP_148"].description = "Spaceship hull"

    # SHIP_149 - Interceptor Interceptor
    item_registry["SHIP_149"] = ItemData.new()
    item_registry["SHIP_149"].id = "SHIP_149"
    item_registry["SHIP_149"].name = "Interceptor Interceptor"
    item_registry["SHIP_149"].category = ItemCategory.SHIP
    item_registry["SHIP_149"].tier = 3
    item_registry["SHIP_149"].base_price = 110000
    item_registry["SHIP_149"].volume = 700
    item_registry["SHIP_149"].mass = 7000
    item_registry["SHIP_149"].description = "Spaceship hull"

    # SHIP_150 - Bomber Bomber
    item_registry["SHIP_150"] = ItemData.new()
    item_registry["SHIP_150"].id = "SHIP_150"
    item_registry["SHIP_150"].name = "Bomber Bomber"
    item_registry["SHIP_150"].category = ItemCategory.SHIP
    item_registry["SHIP_150"].tier = 3
    item_registry["SHIP_150"].base_price = 120000
    item_registry["SHIP_150"].volume = 740
    item_registry["SHIP_150"].mass = 7400
    item_registry["SHIP_150"].description = "Spaceship hull"

    # SHIP_151 - Rookie-A Rookie
    item_registry["SHIP_151"] = ItemData.new()
    item_registry["SHIP_151"].id = "SHIP_151"
    item_registry["SHIP_151"].name = "Rookie-A Rookie"
    item_registry["SHIP_151"].category = ItemCategory.SHIP
    item_registry["SHIP_151"].tier = 1
    item_registry["SHIP_151"].base_price = 5000
    item_registry["SHIP_151"].volume = 450
    item_registry["SHIP_151"].mass = 4500
    item_registry["SHIP_151"].description = "Spaceship hull"

    # SHIP_152 - Rookie-B Rookie
    item_registry["SHIP_152"] = ItemData.new()
    item_registry["SHIP_152"].id = "SHIP_152"
    item_registry["SHIP_152"].name = "Rookie-B Rookie"
    item_registry["SHIP_152"].category = ItemCategory.SHIP
    item_registry["SHIP_152"].tier = 1
    item_registry["SHIP_152"].base_price = 5200
    item_registry["SHIP_152"].volume = 460
    item_registry["SHIP_152"].mass = 4600
    item_registry["SHIP_152"].description = "Spaceship hull"

    # SHIP_153 - Rookie-C Rookie
    item_registry["SHIP_153"] = ItemData.new()
    item_registry["SHIP_153"].id = "SHIP_153"
    item_registry["SHIP_153"].name = "Rookie-C Rookie"
    item_registry["SHIP_153"].category = ItemCategory.SHIP
    item_registry["SHIP_153"].tier = 1
    item_registry["SHIP_153"].base_price = 5100
    item_registry["SHIP_153"].volume = 455
    item_registry["SHIP_153"].mass = 4550
    item_registry["SHIP_153"].description = "Spaceship hull"

    # SHIP_154 - Rookie-D Rookie
    item_registry["SHIP_154"] = ItemData.new()
    item_registry["SHIP_154"].id = "SHIP_154"
    item_registry["SHIP_154"].name = "Rookie-D Rookie"
    item_registry["SHIP_154"].category = ItemCategory.SHIP
    item_registry["SHIP_154"].tier = 1
    item_registry["SHIP_154"].base_price = 5300
    item_registry["SHIP_154"].volume = 465
    item_registry["SHIP_154"].mass = 4650
    item_registry["SHIP_154"].description = "Spaceship hull"

    # SHIP_155 - Shuttle Capsule
    item_registry["SHIP_155"] = ItemData.new()
    item_registry["SHIP_155"].id = "SHIP_155"
    item_registry["SHIP_155"].name = "Shuttle Capsule"
    item_registry["SHIP_155"].category = ItemCategory.SHIP
    item_registry["SHIP_155"].tier = 1
    item_registry["SHIP_155"].base_price = 1000
    item_registry["SHIP_155"].volume = 100
    item_registry["SHIP_155"].mass = 1000
    item_registry["SHIP_155"].description = "Spaceship hull"

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
