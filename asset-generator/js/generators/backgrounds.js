// ============================================================================
// BACKGROUNDS.JS - Procedural Background Generator
// SpaceGameDev - Procedural Pixel Art Asset Generator
// ============================================================================

/**
 * Generate procedural background
 * @param {Object} options - Generation parameters
 * @returns {Array} - Pixel data array (or array of layers)
 */
function generateBackground(options) {
    const {
        width = 1920,
        height = 1080,
        type = 'starfield',
        complexity = 5,
        colors = ['#000011', '#001133', '#002255'],
        random = Math.random
    } = options;

    switch (type) {
        case 'starfield':
            return generateStarfield(width, height, complexity, random);
        case 'nebula':
            return generateNebula(width, height, complexity, colors, random);
        case 'planet':
            return generatePlanet(Math.min(width, height), complexity, colors, random);
        case 'parallax':
            return generateParallaxLayers(width, height, complexity, random);
        default:
            return generateStarfield(width, height, complexity, random);
    }
}

/**
 * Generate starfield background
 */
function generateStarfield(width, height, density, random) {
    const pixels = new Array(width * height).fill(null);
    const starCount = Math.floor(density * 100);

    // Background gradient (deep space)
    for (let y = 0; y < height; y++) {
        const gradient = y / height;
        const r = Math.floor(0 + gradient * 5);
        const g = Math.floor(0 + gradient * 10);
        const b = Math.floor(17 + gradient * 20);
        const bgColor = `rgb(${r},${g},${b})`;

        for (let x = 0; x < width; x++) {
            pixels[y * width + x] = bgColor;
        }
    }

    // Add stars
    for (let i = 0; i < starCount; i++) {
        const x = Math.floor(random() * width);
        const y = Math.floor(random() * height);
        const brightness = random();

        let starColor;
        if (brightness > 0.95) {
            starColor = '#FFFFFF'; // Bright white
        } else if (brightness > 0.8) {
            starColor = '#FFDDAA'; // Yellow
        } else if (brightness > 0.6) {
            starColor = '#AADDFF'; // Blue
        } else {
            starColor = '#CCCCCC'; // Dim white
        }

        pixels[y * width + x] = starColor;

        // Add larger stars
        if (brightness > 0.9) {
            // 2x2 star
            if (x + 1 < width) pixels[y * width + x + 1] = starColor;
            if (y + 1 < height) pixels[(y + 1) * width + x] = starColor;
        }
    }

    return pixels;
}

/**
 * Generate nebula background
 */
function generateNebula(width, height, complexity, colors, random) {
    const pixels = new Array(width * height).fill(null);

    const [baseColor, midColor, brightColor] = colors.length >= 3 ?
        colors : ['#220033', '#440066', '#8800FF'];

    // Generate nebula using layered noise
    for (let y = 0; y < height; y++) {
        for (let x = 0; x < width; x++) {
            const idx = y * width + x;

            // Multi-octave noise
            let noiseValue = 0;
            let amplitude = 1;
            let frequency = 0.002;

            for (let octave = 0; octave < complexity; octave++) {
                noiseValue += simpleNoise2D(
                    x * frequency,
                    y * frequency,
                    random
                ) * amplitude;

                amplitude *= 0.5;
                frequency *= 2;
            }

            // Normalize noise to 0-1
            noiseValue = (noiseValue + 1) / 2;

            // Map to colors
            let color;
            if (noiseValue > 0.7) {
                color = brightColor;
            } else if (noiseValue > 0.4) {
                color = midColor;
            } else if (noiseValue > 0.2) {
                color = baseColor;
            } else {
                color = '#000011'; // Deep space
            }

            pixels[idx] = color;
        }
    }

    // Add stars on top
    const starCount = Math.floor(complexity * 50);
    for (let i = 0; i < starCount; i++) {
        const x = Math.floor(random() * width);
        const y = Math.floor(random() * height);
        pixels[y * width + x] = '#FFFFFF';
    }

    return pixels;
}

/**
 * Generate planet
 */
function generatePlanet(size, complexity, colors, random) {
    const pixels = new Array(size * size).fill(null);

    const centerX = size / 2;
    const centerY = size / 2;
    const radius = size * 0.45;

    const [surfaceColor1, surfaceColor2, surfaceColor3, atmosphereColor] = colors.length >= 4 ?
        colors : ['#3366AA', '#4488CC', '#66AAEE', '#88CCFF'];

    // Draw planet sphere
    for (let y = 0; y < size; y++) {
        for (let x = 0; x < size; x++) {
            const dx = x - centerX;
            const dy = y - centerY;
            const dist = Math.sqrt(dx * dx + dy * dy);

            if (dist < radius) {
                // Inside planet
                const angle = Math.atan2(dy, dx);
                const normalizedDist = dist / radius;

                // Surface patterns using noise
                const noiseX = x * 0.05 + Math.cos(angle) * radius * 0.02;
                const noiseY = y * 0.05 + Math.sin(angle) * radius * 0.02;
                const noise = simpleNoise2D(noiseX, noiseY, random);

                // Lighting (top-left light source)
                const lightAngle = Math.atan2(-dy, -dx);
                const lightDiff = Math.abs(lightAngle - (-Math.PI * 0.75));
                const lightFactor = 1 - (lightDiff / Math.PI);

                // Combine lighting and surface features
                let color;
                if (noise > 0.3 && lightFactor > 0.6) {
                    color = surfaceColor3; // Bright land
                } else if (noise > 0 && lightFactor > 0.4) {
                    color = surfaceColor2; // Ocean/mid
                } else if (lightFactor > 0.2) {
                    color = surfaceColor1; // Dark side
                } else {
                    color = surfaceColor1; // Shadow
                }

                pixels[y * size + x] = color;
            } else if (dist < radius * 1.1) {
                // Atmosphere glow
                pixels[y * size + x] = atmosphereColor;
            }
        }
    }

    // Add cloud layer (optional)
    if (complexity > 5) {
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const dx = x - centerX;
                const dy = y - centerY;
                const dist = Math.sqrt(dx * dx + dy * dy);

                if (dist < radius * 0.95) {
                    const cloudNoise = simpleNoise2D(x * 0.1, y * 0.1, random);
                    if (cloudNoise > 0.6) {
                        pixels[y * size + x] = '#FFFFFF';
                    }
                }
            }
        }
    }

    return pixels;
}

/**
 * Generate parallax layers (3 layers)
 */
function generateParallaxLayers(width, height, complexity, random) {
    const layers = [];

    // Layer 1 - Distant stars (slow)
    const layer1 = new Array(width * height).fill('transparent');
    const distantStars = Math.floor(complexity * 20);
    for (let i = 0; i < distantStars; i++) {
        const x = Math.floor(random() * width);
        const y = Math.floor(random() * height);
        layer1[y * width + x] = '#888888';
    }
    layers.push({ pixels: layer1, speed: 0.1 });

    // Layer 2 - Medium stars
    const layer2 = new Array(width * height).fill('transparent');
    const mediumStars = Math.floor(complexity * 40);
    for (let i = 0; i < mediumStars; i++) {
        const x = Math.floor(random() * width);
        const y = Math.floor(random() * height);
        layer2[y * width + x] = '#BBBBBB';

        if (random() > 0.8) {
            // Larger star
            if (x + 1 < width) layer2[y * width + x + 1] = '#BBBBBB';
        }
    }
    layers.push({ pixels: layer2, speed: 0.3 });

    // Layer 3 - Close stars (fast)
    const layer3 = new Array(width * height).fill('transparent');
    const closeStars = Math.floor(complexity * 60);
    for (let i = 0; i < closeStars; i++) {
        const x = Math.floor(random() * width);
        const y = Math.floor(random() * height);
        const brightness = random();

        const color = brightness > 0.7 ? '#FFFFFF' : '#DDDDDD';
        layer3[y * width + x] = color;

        if (brightness > 0.9) {
            // Bright 2x2 star
            if (x + 1 < width) layer3[y * width + x + 1] = color;
            if (y + 1 < height) layer3[(y + 1) * width + x] = color;
            if (x + 1 < width && y + 1 < height) layer3[(y + 1) * width + x + 1] = color;
        }
    }
    layers.push({ pixels: layer3, speed: 0.6 });

    return layers;
}

/**
 * Simple 2D Perlin-like noise
 */
function simpleNoise2D(x, y, random) {
    const xi = Math.floor(x);
    const yi = Math.floor(y);
    const xf = x - xi;
    const yf = y - yi;

    const hash = (i, j) => {
        const h = (i * 374761393 + j * 668265263) % 1000000;
        return (Math.sin(h) + 1) / 2;
    };

    const aa = hash(xi, yi);
    const ab = hash(xi, yi + 1);
    const ba = hash(xi + 1, yi);
    const bb = hash(xi + 1, yi + 1);

    // Smooth interpolation
    const smoothX = xf * xf * (3 - 2 * xf);
    const smoothY = yf * yf * (3 - 2 * yf);

    const x1 = aa * (1 - smoothX) + ba * smoothX;
    const x2 = ab * (1 - smoothX) + bb * smoothX;

    return x1 * (1 - smoothY) + x2 * smoothY - 0.5;
}

/**
 * Generate space station background element
 */
function generateSpaceStation(size, random) {
    const pixels = new Array(size * size).fill(null);

    const centerX = size / 2;
    const centerY = size / 2;

    // Main structure
    const moduleCount = 5 + Math.floor(random() * 5);

    for (let i = 0; i < moduleCount; i++) {
        const angle = (i / moduleCount) * Math.PI * 2;
        const dist = size * 0.2 + random() * size * 0.1;
        const moduleX = Math.floor(centerX + Math.cos(angle) * dist);
        const moduleY = Math.floor(centerY + Math.sin(angle) * dist);
        const moduleSize = Math.floor(random() * 10) + 5;

        // Draw module
        for (let dy = -moduleSize; dy <= moduleSize; dy++) {
            for (let dx = -moduleSize; dx <= moduleSize; dx++) {
                const px = moduleX + dx;
                const py = moduleY + dy;
                if (px >= 0 && px < size && py >= 0 && py < size) {
                    pixels[py * size + px] = '#555555';

                    // Add lights
                    if (random() > 0.9) {
                        pixels[py * size + px] = '#FFFF00';
                    }
                }
            }
        }
    }

    // Central hub
    const hubRadius = Math.floor(size * 0.15);
    for (let dy = -hubRadius; dy <= hubRadius; dy++) {
        for (let dx = -hubRadius; dx <= hubRadius; dx++) {
            if (dx * dx + dy * dy < hubRadius * hubRadius) {
                const px = Math.floor(centerX + dx);
                const py = Math.floor(centerY + dy);
                if (px >= 0 && px < size && py >= 0 && py < size) {
                    pixels[py * size + px] = '#777777';
                }
            }
        }
    }

    return pixels;
}
