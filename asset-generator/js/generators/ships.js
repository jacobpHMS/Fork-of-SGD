// ============================================================================
// SHIPS.JS - Procedural Spaceship Generator
// SpaceGameDev - Procedural Pixel Art Asset Generator
// ============================================================================

/**
 * Generate a procedural spaceship
 * @param {Object} options - Generation parameters
 * @returns {Array} - Pixel data array (size x size)
 */
function generateShip(options) {
    const {
        size = 32,
        complexity = 5,
        faction = 'angular',
        symmetry = 'vertical',
        weapons = true,
        engines = true,
        random = Math.random,
        palette = ['#001F3F', '#0074D9', '#00D9FF', '#FFFFFF']
    } = options;

    // Create empty pixel grid
    const pixels = new Array(size * size).fill(null);

    // Helper to set pixel
    const setPixel = (x, y, color) => {
        if (x >= 0 && x < size && y >= 0 && y < size) {
            pixels[y * size + x] = color;
        }
    };

    // Helper to get pixel
    const getPixel = (x, y) => {
        if (x >= 0 && x < size && y >= 0 && y < size) {
            return pixels[y * size + x];
        }
        return null;
    };

    // Color assignment
    const hullColor = palette[1] || '#0074D9';
    const accentColor = palette[2] || '#00D9FF';
    const darkColor = palette[0] || '#001F3F';
    const brightColor = palette[3] || '#FFFFFF';
    const engineColor = palette[4] || '#FF6600';

    // Generate half ship (will be mirrored)
    const halfWidth = Math.floor(size / 2);
    const centerX = Math.floor(size / 2);

    // Ship body generation based on faction
    if (faction === 'angular') {
        // Angular military style
        generateAngularShip(pixels, size, halfWidth, complexity, random, hullColor, accentColor, darkColor);
    } else if (faction === 'organic') {
        // Organic alien style
        generateOrganicShip(pixels, size, halfWidth, complexity, random, hullColor, accentColor, darkColor);
    } else {
        // Hybrid style
        generateHybridShip(pixels, size, halfWidth, complexity, random, hullColor, accentColor, darkColor);
    }

    // Add cockpit/bridge
    const cockpitY = Math.floor(size * 0.25);
    const cockpitSize = Math.max(1, Math.floor(size / 16));
    for (let dy = 0; dy < cockpitSize; dy++) {
        for (let dx = -cockpitSize; dx <= cockpitSize; dx++) {
            if (Math.abs(dx) + Math.abs(dy) <= cockpitSize) {
                setPixel(centerX + dx, cockpitY + dy, brightColor);
            }
        }
    }

    // Add weapons
    if (weapons) {
        const weaponColor = accentColor;
        const weaponY = Math.floor(size * 0.4);
        const weaponOffset = Math.floor(size / 6);

        // Left weapon
        for (let i = 0; i < Math.max(1, complexity / 3); i++) {
            setPixel(centerX - weaponOffset, weaponY + i, weaponColor);
        }
    }

    // Add engines
    if (engines) {
        const engineY = size - Math.max(2, Math.floor(size / 8));
        const engineSize = Math.max(1, Math.floor(size / 12));
        const engineOffset = Math.floor(size / 8);

        // Left engine
        for (let dy = 0; dy < engineSize; dy++) {
            for (let dx = 0; dx < engineSize; dx++) {
                setPixel(centerX - engineOffset + dx, engineY + dy, engineColor || accentColor);
            }
        }
    }

    // Apply symmetry
    if (symmetry === 'vertical' || symmetry === 'both') {
        applyVerticalSymmetry(pixels, size);
    }

    if (symmetry === 'horizontal' || symmetry === 'both') {
        applyHorizontalSymmetry(pixels, size);
    }

    if (symmetry === 'radial') {
        applyRadialSymmetry(pixels, size);
    }

    // Add outline for definition
    addOutline(pixels, size, darkColor);

    return pixels;
}

function generateAngularShip(pixels, size, halfWidth, complexity, random, hullColor, accentColor, darkColor) {
    const setPixel = (x, y, color) => {
        if (x >= 0 && x < size && y >= 0 && y < size) {
            pixels[y * size + x] = color;
        }
    };

    const centerX = Math.floor(size / 2);

    // Create angular hull shape
    for (let y = 0; y < size; y++) {
        for (let x = 0; x < halfWidth; x++) {
            const normalizedY = y / size;
            const normalizedX = x / halfWidth;

            // Triangular/diamond shape
            let threshold = 0.5;

            if (normalizedY < 0.3) {
                // Front (nose) - narrow
                threshold = normalizedY * 1.5;
            } else if (normalizedY < 0.7) {
                // Middle - widest
                threshold = 0.5;
            } else {
                // Back - narrowing
                threshold = (1 - normalizedY) * 1.5;
            }

            if (normalizedX < threshold) {
                const useAccent = random() < 0.2;
                setPixel(centerX - x - 1, y, useAccent ? accentColor : hullColor);
            }
        }
    }

    // Add angular details
    for (let i = 0; i < complexity; i++) {
        const detailY = Math.floor(random() * size * 0.6) + Math.floor(size * 0.2);
        const detailX = Math.floor(random() * halfWidth * 0.8);
        const detailSize = Math.floor(random() * 2) + 1;

        for (let dy = 0; dy < detailSize; dy++) {
            for (let dx = 0; dx < detailSize; dx++) {
                setPixel(centerX - detailX - dx - 1, detailY + dy, accentColor);
            }
        }
    }
}

function generateOrganicShip(pixels, size, halfWidth, complexity, random, hullColor, accentColor, darkColor) {
    const setPixel = (x, y, color) => {
        if (x >= 0 && x < size && y >= 0 && y < size) {
            pixels[y * size + x] = color;
        }
    };

    const centerX = Math.floor(size / 2);

    // Create organic curved shape
    for (let y = 0; y < size; y++) {
        for (let x = 0; x < halfWidth; x++) {
            const normalizedY = y / size;
            const normalizedX = x / halfWidth;

            // Elliptical/organic shape
            const dy = normalizedY - 0.5;
            const dx = normalizedX;
            const dist = Math.sqrt(dx * dx + dy * dy * 4);

            if (dist < 0.5) {
                const useAccent = random() < 0.15;
                setPixel(centerX - x - 1, y, useAccent ? accentColor : hullColor);
            }
        }
    }

    // Add organic details (bumps, ridges)
    for (let i = 0; i < complexity; i++) {
        const detailY = Math.floor(random() * size);
        const detailX = Math.floor(random() * halfWidth * 0.7);
        const detailSize = Math.floor(random() * 3) + 1;

        for (let dy = -detailSize; dy <= detailSize; dy++) {
            for (let dx = -detailSize; dx <= detailSize; dx++) {
                if (dx * dx + dy * dy <= detailSize * detailSize) {
                    setPixel(centerX - detailX - dx - 1, detailY + dy, accentColor);
                }
            }
        }
    }
}

function generateHybridShip(pixels, size, halfWidth, complexity, random, hullColor, accentColor, darkColor) {
    const setPixel = (x, y, color) => {
        if (x >= 0 && x < size && y >= 0 && y < size) {
            pixels[y * size + x] = color;
        }
    };

    const centerX = Math.floor(size / 2);

    // Mix of angular and organic
    for (let y = 0; y < size; y++) {
        for (let x = 0; x < halfWidth; x++) {
            const normalizedY = y / size;
            const normalizedX = x / halfWidth;

            let threshold;
            if (normalizedY < 0.3) {
                // Angular front
                threshold = normalizedY * 1.5;
            } else if (normalizedY < 0.7) {
                // Organic middle
                const dy = normalizedY - 0.5;
                const dx = normalizedX;
                threshold = 0.5 - Math.sqrt(dx * dx + dy * dy * 2);
            } else {
                // Angular back
                threshold = (1 - normalizedY) * 1.5;
            }

            if (normalizedX < threshold * 1.2) {
                const useAccent = random() < 0.18;
                setPixel(centerX - x - 1, y, useAccent ? accentColor : hullColor);
            }
        }
    }

    // Add hybrid details
    for (let i = 0; i < complexity; i++) {
        const detailY = Math.floor(random() * size);
        const detailX = Math.floor(random() * halfWidth * 0.75);

        if (random() < 0.5) {
            // Angular detail
            const detailSize = Math.floor(random() * 2) + 1;
            for (let dy = 0; dy < detailSize; dy++) {
                for (let dx = 0; dx < detailSize; dx++) {
                    setPixel(centerX - detailX - dx - 1, detailY + dy, accentColor);
                }
            }
        } else {
            // Organic detail
            const detailSize = Math.floor(random() * 2) + 1;
            for (let dy = -detailSize; dy <= detailSize; dy++) {
                for (let dx = -detailSize; dx <= detailSize; dx++) {
                    if (dx * dx + dy * dy <= detailSize * detailSize) {
                        setPixel(centerX - detailX - dx - 1, detailY + dy, accentColor);
                    }
                }
            }
        }
    }
}

function applyVerticalSymmetry(pixels, size) {
    const centerX = Math.floor(size / 2);

    for (let y = 0; y < size; y++) {
        for (let x = 0; x < centerX; x++) {
            const leftPixel = pixels[y * size + (centerX - x - 1)];
            if (leftPixel) {
                pixels[y * size + (centerX + x)] = leftPixel;
            }
        }
    }
}

function applyHorizontalSymmetry(pixels, size) {
    const centerY = Math.floor(size / 2);

    for (let y = 0; y < centerY; y++) {
        for (let x = 0; x < size; x++) {
            const topPixel = pixels[y * size + x];
            if (topPixel) {
                pixels[(size - y - 1) * size + x] = topPixel;
            }
        }
    }
}

function applyRadialSymmetry(pixels, size) {
    applyVerticalSymmetry(pixels, size);
    applyHorizontalSymmetry(pixels, size);
}

function addOutline(pixels, size, darkColor) {
    const hasNeighbor = (x, y) => {
        for (let dy = -1; dy <= 1; dy++) {
            for (let dx = -1; dx <= 1; dx++) {
                if (dx === 0 && dy === 0) continue;
                const nx = x + dx;
                const ny = y + dy;
                if (nx >= 0 && nx < size && ny >= 0 && ny < size) {
                    if (pixels[ny * size + nx]) {
                        return true;
                    }
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

    // Apply outline
    outline.forEach(({ x, y }) => {
        pixels[y * size + x] = darkColor;
    });
}
