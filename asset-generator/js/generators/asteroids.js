// ============================================================================
// ASTEROIDS.JS - Procedural Asteroid Generator
// SpaceGameDev - Procedural Pixel Art Asset Generator
// ============================================================================

/**
 * Generate a procedural asteroid
 * @param {Object} options - Generation parameters
 * @returns {Array} - Pixel data array
 */
function generateAsteroid(options) {
    const {
        size = 32,
        complexity = 5,
        oreType = 'iron',
        roughness = 0.5,
        craters = true,
        rotation = 0,
        random = Math.random,
        palette = ['#4A4A4A', '#6B6B6B', '#8C8C8C', '#A0A0A0']
    } = options;

    const pixels = new Array(size * size).fill(null);

    // Ore colors
    const oreColors = {
        iron: ['#4A4A4A', '#6B6B6B', '#8C8C8C', '#FF6B35'],
        copper: ['#B87333', '#CD7F32', '#E6A85C', '#FFA500'],
        gold: ['#D4AF37', '#FFD700', '#FFA500', '#FFDF00'],
        titanium: ['#2F4F4F', '#708090', '#A9A9A9', '#00CED1'],
        uranium: ['#2E8B57', '#3CB371', '#00FF7F', '#00FF00'],
        platinum: ['#C0C0C0', '#E5E4E2', '#FFFFFF', '#B9F2FF'],
        crystal: ['#4169E1', '#6495ED', '#00BFFF', '#87CEEB']
    };

    const colors = oreColors[oreType] || palette;
    const baseColor = colors[0];
    const highlightColor = colors[1];
    const brightColor = colors[2];
    const oreVeinColor = colors[3];

    const centerX = size / 2;
    const centerY = size / 2;
    const baseRadius = size * 0.35;

    // Generate noise-based shape
    const noiseScale = 0.15;
    const noiseStrength = roughness;

    for (let y = 0; y < size; y++) {
        for (let x = 0; x < size; x++) {
            const dx = x - centerX;
            const dy = y - centerY;
            const dist = Math.sqrt(dx * dx + dy * dy);
            const angle = Math.atan2(dy, dx);

            // Perlin-like noise for irregular edge
            const noise = simpleNoise(
                x * noiseScale,
                y * noiseScale,
                random
            );

            const irregularRadius = baseRadius + noise * baseRadius * noiseStrength;

            if (dist < irregularRadius) {
                // Determine color based on depth/lighting
                let color;
                const normalizedDist = dist / irregularRadius;

                // Lighting simulation (top-left light source)
                const lightAngle = Math.atan2(-dy, -dx);
                const lightDiff = Math.abs(lightAngle - (-Math.PI * 0.75));
                const lightFactor = 1 - (lightDiff / Math.PI);

                if (lightFactor > 0.7) {
                    color = brightColor;
                } else if (lightFactor > 0.4) {
                    color = highlightColor;
                } else {
                    color = baseColor;
                }

                // Add ore veins
                if (random() < 0.1 * complexity / 10) {
                    color = oreVeinColor;
                }

                pixels[y * size + x] = color;
            }
        }
    }

    // Add craters
    if (craters) {
        const craterCount = Math.floor(complexity / 2);
        for (let i = 0; i < craterCount; i++) {
            const craterX = Math.floor(centerX + (random() - 0.5) * size * 0.6);
            const craterY = Math.floor(centerY + (random() - 0.5) * size * 0.6);
            const craterRadius = Math.floor(random() * size * 0.15) + 2;

            for (let cy = -craterRadius; cy <= craterRadius; cy++) {
                for (let cx = -craterRadius; cx <= craterRadius; cx++) {
                    const cdist = Math.sqrt(cx * cx + cy * cy);
                    if (cdist < craterRadius) {
                        const px = craterX + cx;
                        const py = craterY + cy;
                        if (px >= 0 && px < size && py >= 0 && py < size) {
                            const idx = py * size + px;
                            if (pixels[idx]) {
                                // Darken for crater
                                pixels[idx] = baseColor;
                            }
                        }
                    }
                }
            }
        }
    }

    // Add surface detail
    for (let i = 0; i < complexity * 3; i++) {
        const detailX = Math.floor(random() * size);
        const detailY = Math.floor(random() * size);
        const idx = detailY * size + detailX;

        if (pixels[idx]) {
            pixels[idx] = random() > 0.5 ? highlightColor : baseColor;
        }
    }

    // Add outline for definition
    addAsteroidOutline(pixels, size, '#1a1a1a');

    return pixels;
}

/**
 * Simple Perlin-like noise function
 */
function simpleNoise(x, y, random) {
    const xi = Math.floor(x);
    const yi = Math.floor(y);
    const xf = x - xi;
    const yf = y - yi;

    // Pseudo-random gradients
    const hash = (i, j) => {
        const h = (i * 374761393 + j * 668265263) % 1000000;
        return (Math.sin(h) + 1) / 2;
    };

    const aa = hash(xi, yi);
    const ab = hash(xi, yi + 1);
    const ba = hash(xi + 1, yi);
    const bb = hash(xi + 1, yi + 1);

    // Bilinear interpolation
    const x1 = aa * (1 - xf) + ba * xf;
    const x2 = ab * (1 - xf) + bb * xf;

    return x1 * (1 - yf) + x2 * yf - 0.5;
}

function addAsteroidOutline(pixels, size, outlineColor) {
    const hasNeighbor = (x, y) => {
        for (let dy = -1; dy <= 1; dy++) {
            for (let dx = -1; dx <= 1; dx++) {
                if (dx === 0 && dy === 0) continue;
                const nx = x + dx;
                const ny = y + dy;
                if (nx >= 0 && nx < size && ny >= 0 && ny < size) {
                    if (pixels[ny * size + nx]) return true;
                }
            }
        }
        return false;
    };

    const outline = [];
    for (let y = 0; y < size; y++) {
        for (let x = 0; x < size; x++) {
            const idx = y * size + x;
            if (!pixels[idx] && hasNeighbor(x, y)) {
                outline.push({ x, y });
            }
        }
    }

    outline.forEach(({ x, y }) => {
        pixels[y * size + x] = outlineColor;
    });
}

/**
 * Generate asteroid with damage states
 */
function generateAsteroidDamaged(baseAsteroid, size, damageLevel = 0.25) {
    const damaged = [...baseAsteroid];
    const crackCount = Math.floor(damageLevel * 10);

    for (let i = 0; i < crackCount; i++) {
        const x = Math.floor(Math.random() * size);
        const y = Math.floor(Math.random() * size);
        const length = Math.floor(Math.random() * size * 0.3) + 3;
        const angle = Math.random() * Math.PI * 2;

        // Draw crack
        for (let j = 0; j < length; j++) {
            const cx = Math.floor(x + Math.cos(angle) * j);
            const cy = Math.floor(y + Math.sin(angle) * j);
            if (cx >= 0 && cx < size && cy >= 0 && cy < size) {
                damaged[cy * size + cx] = '#000000';
            }
        }
    }

    return damaged;
}
