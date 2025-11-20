// ============================================================================
// EFFECTS.JS - Procedural VFX & Animation Generator
// SpaceGameDev - Procedural Pixel Art Asset Generator
// ============================================================================

/**
 * Generate animated effect
 * @param {Object} options - Generation parameters
 * @returns {Array} - Array of frames
 */
function generateEffect(options) {
    const {
        size = 64,
        type = 'explosion',
        intensity = 5,
        frameCount = 16,
        random = Math.random,
        palette = ['#FF6600', '#FF9900', '#FFCC00', '#FFFFFF']
    } = options;

    switch (type) {
        case 'explosion':
            return generateExplosion(size, intensity, frameCount, palette, random);
        case 'shield_hit':
            return generateShieldHit(size, intensity, frameCount, palette);
        case 'shield_ambient':
            return generateShieldAmbient(size, frameCount, palette);
        case 'hull_damage':
            return generateHullDamage(size, intensity, frameCount, palette, random);
        case 'warp_jump':
            return generateWarpJump(size, frameCount, palette);
        case 'teleport':
            return generateTeleport(size, frameCount, palette, random);
        case 'emp_burst':
            return generateEMPBurst(size, frameCount, palette);
        default:
            return generateExplosion(size, intensity, frameCount, palette, random);
    }
}

/**
 * Generate explosion animation (expanding fireball)
 */
function generateExplosion(size, intensity, frameCount, palette, random) {
    const frames = [];
    const [orange, yellow, white, black] = palette;

    const centerX = Math.floor(size / 2);
    const centerY = Math.floor(size / 2);
    const maxRadius = size * 0.45;

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const progress = frame / frameCount;

        // Expansion phase (0-0.6), then dissipation (0.6-1.0)
        let radius;
        if (progress < 0.6) {
            radius = (progress / 0.6) * maxRadius;
        } else {
            radius = maxRadius * (1 - (progress - 0.6) / 0.4 * 0.3);
        }

        // Draw explosion particles
        const particleCount = Math.floor(intensity * 20);
        for (let i = 0; i < particleCount; i++) {
            const angle = (i / particleCount) * Math.PI * 2 + random() * 0.5;
            const dist = radius * (0.5 + random() * 0.5);
            const px = Math.floor(centerX + Math.cos(angle) * dist);
            const py = Math.floor(centerY + Math.sin(angle) * dist);

            if (px >= 0 && px < size && py >= 0 && py < size) {
                // Color based on distance and frame
                let color;
                if (progress < 0.3) {
                    color = white; // Flash
                } else if (dist < radius * 0.3) {
                    color = yellow;
                } else if (dist < radius * 0.7) {
                    color = orange;
                } else {
                    color = progress > 0.7 ? black : orange;
                }

                pixels[py * size + px] = color;

                // Fill around particle
                for (let dy = -1; dy <= 1; dy++) {
                    for (let dx = -1; dx <= 1; dx++) {
                        const nx = px + dx;
                        const ny = py + dy;
                        if (nx >= 0 && nx < size && ny >= 0 && ny < size) {
                            if (!pixels[ny * size + nx]) {
                                pixels[ny * size + nx] = color;
                            }
                        }
                    }
                }
            }
        }

        // Central core (bright in early frames)
        if (progress < 0.5) {
            const coreRadius = Math.floor(radius * 0.3);
            for (let dy = -coreRadius; dy <= coreRadius; dy++) {
                for (let dx = -coreRadius; dx <= coreRadius; dx++) {
                    if (dx * dx + dy * dy < coreRadius * coreRadius) {
                        const px = centerX + dx;
                        const py = centerY + dy;
                        if (px >= 0 && px < size && py >= 0 && py < size) {
                            pixels[py * size + px] = white;
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
 * Generate shield hit effect (hexagon ripple)
 */
function generateShieldHit(size, intensity, frameCount, palette) {
    const frames = [];
    const [cyan, blue, white, dark] = palette;

    const impactX = Math.floor(size * 0.6);
    const impactY = Math.floor(size * 0.4);

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const progress = frame / frameCount;

        // Expanding ripple
        const rippleRadius = progress * size * 0.7;

        // Draw hexagonal shield pattern
        const hexSize = 4;
        for (let y = 0; y < size; y += hexSize) {
            for (let x = 0; x < size; x += hexSize) {
                const dx = x - impactX;
                const dy = y - impactY;
                const dist = Math.sqrt(dx * dx + dy * dy);

                // Ripple effect
                if (Math.abs(dist - rippleRadius) < 3) {
                    // Draw hexagon
                    for (let hy = 0; hy < hexSize; hy++) {
                        for (let hx = 0; hx < hexSize; hx++) {
                            const px = x + hx;
                            const py = y + hy;
                            if (px < size && py < size) {
                                // Hexagon shape check (simplified)
                                if ((hx === 0 || hx === hexSize - 1) ||
                                    (hy === 0 || hy === hexSize - 1)) {
                                    const alpha = 1 - progress;
                                    pixels[py * size + px] = progress < 0.3 ? white : cyan;
                                }
                            }
                        }
                    }
                }
            }
        }

        // Impact flash
        if (progress < 0.2) {
            const flashRadius = Math.floor(8 * (1 - progress / 0.2));
            for (let dy = -flashRadius; dy <= flashRadius; dy++) {
                for (let dx = -flashRadius; dx <= flashRadius; dx++) {
                    if (dx * dx + dy * dy < flashRadius * flashRadius) {
                        const px = impactX + dx;
                        const py = impactY + dy;
                        if (px >= 0 && px < size && py >= 0 && py < size) {
                            pixels[py * size + px] = white;
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
 * Generate ambient shield animation (subtle glow)
 */
function generateShieldAmbient(size, frameCount, palette) {
    const frames = [];
    const [cyan, blue, white, dark] = palette;

    const centerX = Math.floor(size / 2);
    const centerY = Math.floor(size / 2);
    const radius = size * 0.45;

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const progress = frame / frameCount;

        // Pulsing effect
        const pulse = Math.sin(progress * Math.PI * 2);
        const currentRadius = radius + pulse * 2;

        // Draw shield bubble
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const dx = x - centerX;
                const dy = y - centerY;
                const dist = Math.sqrt(dx * dx + dy * dy);

                // Edge glow
                if (Math.abs(dist - currentRadius) < 2) {
                    pixels[y * size + x] = pulse > 0 ? cyan : blue;
                } else if (dist < currentRadius && dist > currentRadius - 3) {
                    pixels[y * size + x] = dark;
                }
            }
        }

        // Hexagon pattern (faint)
        const hexSize = 6;
        for (let y = 0; y < size; y += hexSize) {
            for (let x = 0; x < size; x += hexSize) {
                const dx = x - centerX;
                const dy = y - centerY;
                const dist = Math.sqrt(dx * dx + dy * dy);

                if (dist < currentRadius) {
                    // Draw hex border
                    if (frame % 4 === 0) {
                        pixels[y * size + x] = dark;
                    }
                }
            }
        }

        frames.push(pixels);
    }

    return frames;
}

/**
 * Generate hull damage effect (sparks, scorch marks)
 */
function generateHullDamage(size, intensity, frameCount, palette, random) {
    const frames = [];
    const [orange, yellow, black, gray] = palette;

    const impactX = Math.floor(size / 2);
    const impactY = Math.floor(size / 2);

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const progress = frame / frameCount;

        // Scorch mark (permanent)
        const scorchRadius = Math.floor(size * 0.2);
        for (let dy = -scorchRadius; dy <= scorchRadius; dy++) {
            for (let dx = -scorchRadius; dx <= scorchRadius; dx++) {
                if (dx * dx + dy * dy < scorchRadius * scorchRadius) {
                    const px = impactX + dx;
                    const py = impactY + dy;
                    if (px >= 0 && px < size && py >= 0 && py < size) {
                        pixels[py * size + px] = black;
                    }
                }
            }
        }

        // Sparks (first half of animation)
        if (progress < 0.5) {
            const sparkCount = Math.floor(intensity * 5);
            for (let i = 0; i < sparkCount; i++) {
                const angle = random() * Math.PI * 2;
                const dist = random() * size * 0.4 * (progress / 0.5);
                const px = Math.floor(impactX + Math.cos(angle) * dist);
                const py = Math.floor(impactY + Math.sin(angle) * dist);

                if (px >= 0 && px < size && py >= 0 && py < size) {
                    pixels[py * size + px] = random() > 0.5 ? yellow : orange;
                }
            }
        }

        // Smoke (second half)
        if (progress > 0.3) {
            const smokeCount = 10;
            for (let i = 0; i < smokeCount; i++) {
                const angle = -Math.PI / 2 + (random() - 0.5) * 0.5;
                const dist = (progress - 0.3) * size * 0.3;
                const px = Math.floor(impactX + Math.cos(angle) * dist * (random() + 0.5));
                const py = Math.floor(impactY + Math.sin(angle) * dist);

                if (px >= 0 && px < size && py >= 0 && py < size) {
                    pixels[py * size + px] = gray;
                }
            }
        }

        frames.push(pixels);
    }

    return frames;
}

/**
 * Generate warp jump effect (ship disappearing into warp)
 */
function generateWarpJump(size, frameCount, palette) {
    const frames = [];
    const [purple, blue, white, cyan] = palette;

    const centerX = Math.floor(size / 2);
    const centerY = Math.floor(size / 2);

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const progress = frame / frameCount;

        // Collapsing warp tunnel
        const tunnelLength = size * (1 - progress);

        for (let i = 0; i < tunnelLength; i++) {
            const rings = 5;
            for (let r = 0; r < rings; r++) {
                const radius = (r + 1) * 3 * (1 + progress);
                const angleOffset = (i / tunnelLength) * Math.PI * 2 + progress * Math.PI * 4;

                for (let a = 0; a < 16; a++) {
                    const angle = (a / 16) * Math.PI * 2 + angleOffset;
                    const px = Math.floor(centerX + Math.cos(angle) * radius);
                    const py = Math.floor(centerY + Math.sin(angle) * radius);

                    if (px >= 0 && px < size && py >= 0 && py < size) {
                        const color = r === 0 ? white : (r < 2 ? cyan : purple);
                        pixels[py * size + px] = color;
                    }
                }
            }
        }

        // Central flash
        if (progress > 0.8) {
            const flashIntensity = (progress - 0.8) / 0.2;
            const flashRadius = Math.floor(size * 0.3 * flashIntensity);

            for (let dy = -flashRadius; dy <= flashRadius; dy++) {
                for (let dx = -flashRadius; dx <= flashRadius; dx++) {
                    if (dx * dx + dy * dy < flashRadius * flashRadius) {
                        const px = centerX + dx;
                        const py = centerY + dy;
                        if (px >= 0 && px < size && py >= 0 && py < size) {
                            pixels[py * size + px] = white;
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
 * Generate teleport effect (particle materialization)
 */
function generateTeleport(size, frameCount, palette, random) {
    const frames = [];
    const [cyan, blue, white, dark] = palette;

    const centerX = Math.floor(size / 2);
    const centerY = Math.floor(size / 2);

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const progress = frame / frameCount;

        // Particles converging to center
        const particleCount = 50;
        for (let i = 0; i < particleCount; i++) {
            const angle = (i / particleCount) * Math.PI * 2;
            const startDist = size * 0.5;
            const dist = startDist * (1 - progress);

            const px = Math.floor(centerX + Math.cos(angle) * dist);
            const py = Math.floor(centerY + Math.sin(angle) * dist);

            if (px >= 0 && px < size && py >= 0 && py < size) {
                pixels[py * size + px] = progress < 0.5 ? cyan : white;
            }
        }

        // Central energy buildup
        if (progress > 0.5) {
            const buildupRadius = Math.floor((progress - 0.5) * 2 * size * 0.3);
            for (let dy = -buildupRadius; dy <= buildupRadius; dy++) {
                for (let dx = -buildupRadius; dx <= buildupRadius; dx++) {
                    if (dx * dx + dy * dy < buildupRadius * buildupRadius) {
                        const px = centerX + dx;
                        const py = centerY + dy;
                        if (px >= 0 && px < size && py >= 0 && py < size) {
                            pixels[py * size + px] = white;
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
 * Generate EMP burst effect (electric shockwave)
 */
function generateEMPBurst(size, frameCount, palette) {
    const frames = [];
    const [yellow, white, cyan, blue] = palette;

    const centerX = Math.floor(size / 2);
    const centerY = Math.floor(size / 2);

    for (let frame = 0; frame < frameCount; frame++) {
        const pixels = new Array(size * size).fill(null);
        const progress = frame / frameCount;

        // Expanding ring
        const radius = progress * size * 0.5;

        // Electric arcs
        const arcCount = 12;
        for (let i = 0; i < arcCount; i++) {
            const angle = (i / arcCount) * Math.PI * 2 + progress * Math.PI;
            const arcLength = radius + Math.sin(progress * Math.PI * 8) * 5;

            const px = Math.floor(centerX + Math.cos(angle) * arcLength);
            const py = Math.floor(centerY + Math.sin(angle) * arcLength);

            if (px >= 0 && px < size && py >= 0 && py < size) {
                pixels[py * size + px] = i % 2 === 0 ? yellow : white;

                // Arc trail
                for (let j = 0; j < arcLength; j++) {
                    const tx = Math.floor(centerX + Math.cos(angle) * j);
                    const ty = Math.floor(centerY + Math.sin(angle) * j);
                    if (tx >= 0 && tx < size && ty >= 0 && ty < size) {
                        if (j % 3 === 0) {
                            pixels[ty * size + tx] = cyan;
                        }
                    }
                }
            }
        }

        // Central flash
        if (progress < 0.2) {
            const flashRadius = Math.floor(10 * (1 - progress / 0.2));
            for (let dy = -flashRadius; dy <= flashRadius; dy++) {
                for (let dx = -flashRadius; dx <= flashRadius; dx++) {
                    if (dx * dx + dy * dy < flashRadius * flashRadius) {
                        const px = centerX + dx;
                        const py = centerY + dy;
                        if (px >= 0 && px < size && py >= 0 && py < size) {
                            pixels[py * size + px] = white;
                        }
                    }
                }
            }
        }

        frames.push(pixels);
    }

    return frames;
}
