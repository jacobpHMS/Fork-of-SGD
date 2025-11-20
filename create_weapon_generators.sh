#!/bin/bash

# Template is weapon-flak.html
TEMPLATE="asset-generator/generators/weapon-flak.html"

# Plasma Weapon Generator
sed -e 's/Flak\/Scatter Weapon/Plasma Weapon/g' \
    -e 's/36 Parameters - Multi-Projectile Area Denial System/42 Parameters - Energy-Based Plasma Projectiles/g' \
    -e 's/WEAPON_FLAK_001/WEAPON_PLASMA_001/g' \
    -e 's/weapon_flak_params\.json/weapon_plasma_params.json/g' \
    -e 's/230, 126, 34/155, 89, 182/g' \
    -e 's/#e67e22/#9b59b6/g' \
    -e 's/💥/⚡/g' \
    -e 's/Generate Weapon Effect/Generate Plasma Effect/g' \
    "$TEMPLATE" > asset-generator/generators/weapon-plasma.html

# Beam/Laser Weapon Generator
sed -e 's/Flak\/Scatter Weapon/Beam\/Laser Weapon/g' \
    -e 's/36 Parameters - Multi-Projectile Area Denial System/47 Parameters - Continuous Energy Beam System/g' \
    -e 's/WEAPON_FLAK_001/WEAPON_BEAM_001/g' \
    -e 's/weapon_flak_params\.json/weapon_beam_params.json/g' \
    -e 's/230, 126, 34/231, 76, 60/g' \
    -e 's/#e67e22/#e74c3c/g' \
    -e 's/💥/🔴/g' \
    -e 's/Generate Weapon Effect/Generate Beam Effect/g' \
    "$TEMPLATE" > asset-generator/generators/weapon-beam.html

# Kinetic Weapon Generator
sed -e 's/Flak\/Scatter Weapon/Kinetic Weapon/g' \
    -e 's/36 Parameters - Multi-Projectile Area Denial System/32 Parameters - Ballistic Projectile System/g' \
    -e 's/WEAPON_FLAK_001/WEAPON_KINETIC_001/g' \
    -e 's/weapon_flak_params\.json/weapon_kinetic_params.json/g' \
    -e 's/230, 126, 34/149, 165, 166/g' \
    -e 's/#e67e22/#95a5a6/g' \
    -e 's/💥/🔫/g' \
    -e 's/Generate Weapon Effect/Generate Kinetic Effect/g' \
    "$TEMPLATE" > asset-generator/generators/weapon-kinetic.html

# Capital Ship Weapon Generator
sed -e 's/Flak\/Scatter Weapon/Capital Ship Weapon/g' \
    -e 's/36 Parameters - Multi-Projectile Area Denial System/36 Parameters - Heavy Capital-Class Weapons/g' \
    -e 's/WEAPON_FLAK_001/WEAPON_CAPITAL_001/g' \
    -e 's/weapon_flak_params\.json/weapon_capital_params.json/g' \
    -e 's/230, 126, 34/241, 196, 15/g' \
    -e 's/#e67e22/#f1c40f/g' \
    -e 's/💥/🚀/g' \
    -e 's/Generate Weapon Effect/Generate Capital Weapon/g' \
    "$TEMPLATE" > asset-generator/generators/weapon-capital.html

echo "Created 4 weapon generators:"
ls -lh asset-generator/generators/weapon-*.html
