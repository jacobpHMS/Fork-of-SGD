// ============================================================================
// PROJECTILES.JS - Procedural Projectile & Weapon Generator
// SpaceGameDev - Procedural Pixel Art Asset Generator
// ============================================================================

/**
 * Generate animated projectile/weapon
 * @param {Object} options - Generation parameters
 * @returns {Array} - Array of frames (each frame is pixel data array)
 */
function generateProjectile(options) {
    const {
        size = 16,
        type = 'laser',
        color = '#00D9FF',
        animated = true,
        frameCount = 4,
        random = Math.random,
        palette = ['#00D9FF', '#FFFFFF', '#0080FF', '#004080']
    } = options;

    const frames = [];

    switch (type) {
        case 'laser':
            return generateLaser(size, color, animated, frameCount, palette);
        case 'missile':
            return generateMissile(size, color, animated, frameCount, palette, random);
        case 'plasma':
            return generatePlasma(size, color, animated, frameCount, palette);
        case 'beam':
            return generateBeam(size, color, animated, frameCount, palette);
        case 'torpedo':
            return generateTorpedo(size, color, animated, frameCount, palette, random);
        default:
            return generateLaser(size, color, animated, frameCount, palette);
    }
}

/**
 * Generate laser projectile (fast, thin beam)
 */
function generateLaser(size, color, animated, frameCount, palette) {
    const frames = [];
    const [baseColor, brightColor, midColor, darkColor] = palette;

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const centerY = Math.floor(size / 2);

        // Pulsing effect
        const pulse = Math.sin((frame / frameCount) * Math.PI * 2);
        const thickness = animated ? Math.floor(1 + pulse * 0.5) : 1;

        // Draw horizontal laser beam
        for (let x = 0; x < size; x++) {
            for (let dy = -thickness; dy <= thickness; dy++) {
                const y = centerY + dy;
                if (y >= 0 && y < size) {
                    if (dy === 0) {
                        pixels[y * size + x] = brightColor;
                    } else {
                        pixels[y * size + x] = baseColor;
                    }
                }
            }
        }

        // Add glow effect
        if (animated) {
            const glowIntensity = 0.5 + pulse * 0.3;
            for (let x = 0; x < size; x++) {
                for (let dy = -2; dy <= 2; dy++) {
                    const y = centerY + dy;
                    if (y >= 0 && y < size && !pixels[y * size + x]) {
                        if (Math.abs(dy) > thickness) {
                            pixels[y * size + x] = midColor;
                        }
                    }
                }
            }
        }

        frames.push(pixels);
    }

    return frames;
}

/**
 * Generate missile projectile (rotating, with thrust)
 */
function generateMissile(size, color, animated, frameCount, palette, random) {
    const frames = [];
    const [baseColor, brightColor, midColor, darkColor] = palette;

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const centerX = Math.floor(size / 2);
        const centerY = Math.floor(size / 2);

        // Missile body
        const bodyLength = Math.floor(size * 0.6);
        const bodyWidth = Math.floor(size * 0.3);

        // Draw missile body (horizontal)
        for (let x = 0; x < bodyLength; x++) {
            for (let y = -Math.floor(bodyWidth / 2); y <= Math.floor(bodyWidth / 2); y++) {
                const px = centerX - bodyLength / 2 + x;
                const py = centerY + y;
                if (px >= 0 && px < size && py >= 0 && py < size) {
                    if (Math.abs(y) === Math.floor(bodyWidth / 2)) {
                        pixels[Math.floor(py) * size + Math.floor(px)] = darkColor;
                    } else {
                        pixels[Math.floor(py) * size + Math.floor(px)] = baseColor;
                    }
                }
            }
        }

        // Add nose cone
        const noseX = centerX + bodyLength / 2;
        for (let i = 0; i < 3; i++) {
            const px = Math.floor(noseX + i);
            const py = centerY;
            if (px >= 0 && px < size && py >= 0 && py < size) {
                pixels[Math.floor(py) * size + Math.floor(px)] = brightColor;
            }
        }

        // Animated thrust
        if (animated) {
            const thrustLength = frame % 2 === 0 ? 3 : 2;
            const thrustX = centerX - bodyLength / 2 - thrustLength;

            for (let i = 0; i < thrustLength; i++) {
                for (let dy = -1; dy <= 1; dy++) {
                    const px = Math.floor(thrustX + i);
                    const py = Math.floor(centerY + dy);
                    if (px >= 0 && px < size && py >= 0 && py < size) {
                        pixels[py * size + px] = '#FF6600';
                    }
                }
            }
        }

        frames.push(pixels);
    }

    return frames;
}

/**
 * Generate plasma ball (pulsing energy ball)
 */
function generatePlasma(size, color, animated, frameCount, palette) {
    const frames = [];
    const [baseColor, brightColor, midColor, darkColor] = palette;

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const centerX = Math.floor(size / 2);
        const centerY = Math.floor(size / 2);

        // Pulsing radius
        const basePulse = Math.sin((frame / frameCount) * Math.PI * 2);
        const radius = Math.floor(size * 0.3) + basePulse * 2;

        // Draw plasma core
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const dx = x - centerX;
                const dy = y - centerY;
                const dist = Math.sqrt(dx * dx + dy * dy);

                if (dist < radius * 0.5) {
                    pixels[y * size + x] = brightColor;
                } else if (dist < radius * 0.75) {
                    pixels[y * size + x] = baseColor;
                } else if (dist < radius) {
                    pixels[y * size + x] = midColor;
                } else if (dist < radius * 1.3) {
                    // Outer glow
                    pixels[y * size + x] = darkColor;
                }
            }
        }

        // Add electric arcs
        if (animated && frame % 2 === 0) {
            for (let i = 0; i < 3; i++) {
                const angle = (i / 3) * Math.PI * 2 + (frame / frameCount) * Math.PI;
                const arcLength = radius * 1.5;
                const arcX = Math.floor(centerX + Math.cos(angle) * arcLength);
                const arcY = Math.floor(centerY + Math.sin(angle) * arcLength);

                if (arcX >= 0 && arcX < size && arcY >= 0 && arcY < size) {
                    pixels[arcY * size + arcX] = brightColor;
                }
            }
        }

        frames.push(pixels);
    }

    return frames;
}

/**
 * Generate continuous beam weapon
 */
function generateBeam(size, color, animated, frameCount, palette) {
    const frames = [];
    const [baseColor, brightColor, midColor, darkColor] = palette;

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const centerY = Math.floor(size / 2);

        // Flickering effect
        const flicker = animated ? (frame % 2 === 0 ? 1 : 0.8) : 1;

        // Core beam
        for (let x = 0; x < size; x++) {
            pixels[centerY * size + x] = brightColor;
        }

        // Outer layers with varying thickness
        const thickness = Math.floor(2 + Math.sin((frame / frameCount) * Math.PI * 2));

        for (let dy = 1; dy <= thickness; dy++) {
            for (let x = 0; x < size; x++) {
                const y1 = centerY + dy;
                const y2 = centerY - dy;

                if (y1 >= 0 && y1 < size) {
                    pixels[y1 * size + x] = dy === 1 ? baseColor : midColor;
                }
                if (y2 >= 0 && y2 < size) {
                    pixels[y2 * size + x] = dy === 1 ? baseColor : midColor;
                }
            }
        }

        frames.push(pixels);
    }

    return frames;
}

/**
 * Generate torpedo (heavy missile with glow)
 */
function generateTorpedo(size, color, animated, frameCount, palette, random) {
    const frames = [];
    const [baseColor, brightColor, midColor, darkColor] = palette;

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const centerX = Math.floor(size / 2);
        const centerY = Math.floor(size / 2);

        // Larger body
        const bodyLength = Math.floor(size * 0.7);
        const bodyWidth = Math.floor(size * 0.4);

        // Draw torpedo body
        for (let x = 0; x < bodyLength; x++) {
            for (let y = -Math.floor(bodyWidth / 2); y <= Math.floor(bodyWidth / 2); y++) {
                const px = centerX - bodyLength / 2 + x;
                const py = centerY + y;
                if (px >= 0 && px < size && py >= 0 && py < size) {
                    pixels[Math.floor(py) * size + Math.floor(px)] = baseColor;
                }
            }
        }

        // Warhead glow
        const glowPulse = Math.sin((frame / frameCount) * Math.PI * 2);
        const noseX = centerX + bodyLength / 2;

        for (let i = 0; i < 4; i++) {
            const px = Math.floor(noseX + i);
            if (px >= 0 && px < size) {
                for (let dy = -1; dy <= 1; dy++) {
                    const py = centerY + dy;
                    if (py >= 0 && py < size) {
                        pixels[Math.floor(py) * size + px] = i < 2 ? brightColor : midColor;
                    }
                }
            }
        }

        // Thrust plume
        if (animated) {
            const thrustLength = 4 + Math.floor(glowPulse * 2);
            const thrustX = centerX - bodyLength / 2;

            for (let i = 0; i < thrustLength; i++) {
                for (let dy = -2; dy <= 2; dy++) {
                    const px = Math.floor(thrustX - i);
                    const py = Math.floor(centerY + dy + (random() - 0.5) * 2);
                    if (px >= 0 && px < size && py >= 0 && py < size) {
                        const thrustColor = i < 2 ? '#FFFF00' : '#FF6600';
                        pixels[py * size + px] = thrustColor;
                    }
                }
            }
        }

        frames.push(pixels);
    }

    return frames;
}
