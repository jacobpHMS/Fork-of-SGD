/* ============================================================
   BACKGROUND GENERATOR
   Generates space backgrounds with stars, nebulae, shooting stars, etc.
   ============================================================ */

class BackgroundGenerator {
    constructor() {
        this.params = {
            bg_type: 'starfield',
            size: 512,
            // Stars
            star_density: 200,
            star_size_min: 1,
            star_size_max: 3,
            star_brightness: 1,
            star_twinkling: true,
            // Sparkles
            sparkle_count: 10,
            sparkle_size: 5,
            sparkle_intensity: 1.2,
            // Shooting stars
            shooting_star_count: 3,
            shooting_star_length: 40,
            shooting_star_speed: 1,
            // Nebula
            nebula_density: 0.3,
            nebula_scale: 0.1,
            nebula_layers: 3,
            // Dust
            dust_density: 50,
            dust_size: 1,
            // Animation
            animated: true,
            tileable: false
        };

        this.canvasManager = null;
        this.previewManager = null;
        this.colorPalette = null;
        this.currentImageData = null;
        this.animationTime = 0;

        // Pre-generated star positions for consistency
        this.stars = [];
        this.sparkles = [];
        this.shootingStars = [];
        this.dustParticles = [];
    }

    init() {
        this.canvasManager = new CanvasManager('main-canvas');
        this.previewManager = new PreviewCanvasManager('preview-canvas');
        this.colorPalette = new ColorPaletteManager();

        // Set initial zoom to 1x for backgrounds
        this.canvasManager.zoom = 1;
        const zoomDisplay = document.getElementById('zoom-level');
        if (zoomDisplay) zoomDisplay.textContent = '1x';

        this.canvasManager.setRenderCallback(() => this.render());
        this.colorPalette.initEventListeners(() => this.regeneratePositions());
        this.colorPalette.applyPalette('cyber_blue');

        this.initParameterListeners();
        this.initExportButton();
        this.updateDatabaseFields();
        this.regeneratePositions();

        this.startAnimation();
    }

    initParameterListeners() {
        const parameterInputs = document.querySelectorAll('.parameters input, .parameters select');

        parameterInputs.forEach(input => {
            const eventType = input.type === 'checkbox' ? 'change' : 'input';

            input.addEventListener(eventType, (e) => {
                const id = e.target.id;
                let value;

                if (e.target.type === 'checkbox') {
                    value = e.target.checked;
                } else if (e.target.type === 'range' || e.target.type === 'number') {
                    value = parseFloat(e.target.value);
                } else {
                    value = e.target.value;
                }

                this.params[id] = value;

                if (e.target.type === 'range') {
                    const valueSpan = e.target.nextElementSibling;
                    if (valueSpan && valueSpan.classList.contains('value')) {
                        if (value < 1 && value > 0) {
                            valueSpan.textContent = value.toFixed(2);
                        } else {
                            valueSpan.textContent = Math.round(value);
                        }
                    }
                }

                // Regenerate positions if density/count changed
                if (id.includes('density') || id.includes('count') || id === 'size') {
                    clearTimeout(this.regenTimeout);
                    this.regenTimeout = setTimeout(() => {
                        this.regeneratePositions();
                        this.updateDatabaseFields();
                    }, 100);
                } else {
                    clearTimeout(this.regenTimeout);
                    this.regenTimeout = setTimeout(() => {
                        this.generate();
                        this.updateDatabaseFields();
                    }, 50);
                }
            });
        });

        document.getElementById('generate-btn').addEventListener('click', () => {
            this.regeneratePositions();
        });
    }

    initExportButton() {
        document.getElementById('export-btn').addEventListener('click', () => {
            this.exportAsset();
        });

        ['asset-type', 'material', 'size-category', 'state'].forEach(id => {
            const element = document.getElementById(id);
            if (element) {
                element.addEventListener('change', () => this.updateDatabaseFields());
                element.addEventListener('input', () => this.updateDatabaseFields());
            }
        });
    }

    startAnimation() {
        const animate = () => {
            if (this.params.animated) {
                this.animationTime += 0.02 * this.params.shooting_star_speed;
                this.generate();
            }
            requestAnimationFrame(animate);
        };
        animate();
    }

    regeneratePositions() {
        const size = parseInt(this.params.size);

        // Generate stars
        this.stars = [];
        for (let i = 0; i < this.params.star_density; i++) {
            this.stars.push({
                x: this.random(i * 1.1) * size,
                y: this.random(i * 2.3) * size,
                size: this.params.star_size_min + this.random(i * 3.7) * (this.params.star_size_max - this.params.star_size_min),
                brightness: 0.5 + this.random(i * 4.9) * 0.5,
                twinklePhase: this.random(i * 5.1) * Math.PI * 2,
                twinkleSpeed: 0.5 + this.random(i * 6.3) * 1.5
            });
        }

        // Generate sparkles
        this.sparkles = [];
        for (let i = 0; i < this.params.sparkle_count; i++) {
            this.sparkles.push({
                x: this.random(i * 10.1) * size,
                y: this.random(i * 11.3) * size,
                rotationPhase: this.random(i * 12.7) * Math.PI * 2,
                rotationSpeed: 0.5 + this.random(i * 13.9) * 2,
                pulsePhase: this.random(i * 14.1) * Math.PI * 2,
                pulseSpeed: 1 + this.random(i * 15.3) * 2
            });
        }

        // Generate shooting stars
        this.shootingStars = [];
        for (let i = 0; i < this.params.shooting_star_count; i++) {
            const angle = -Math.PI / 4 + this.random(i * 20.1) * Math.PI / 6;
            this.shootingStars.push({
                startX: this.random(i * 21.3) * size * 1.5 - size * 0.25,
                startY: this.random(i * 22.7) * size * 1.5 - size * 0.25,
                angle: angle,
                speed: 0.5 + this.random(i * 23.9) * 1.5,
                phaseOffset: this.random(i * 24.1)
            });
        }

        // Generate dust particles
        this.dustParticles = [];
        for (let i = 0; i < this.params.dust_density; i++) {
            this.dustParticles.push({
                x: this.random(i * 30.1) * size,
                y: this.random(i * 31.3) * size,
                vx: (this.random(i * 32.7) - 0.5) * 0.2,
                vy: (this.random(i * 33.9) - 0.5) * 0.2
            });
        }

        this.generate();
    }

    generate() {
        const size = parseInt(this.params.size);
        const colors = this.colorPalette.getColors();

        this.currentImageData = this.generateBackground(size, this.params, colors);

        this.render();
        this.previewManager.updatePreview(this.currentImageData, size);
    }

    render() {
        if (!this.currentImageData) return;

        this.canvasManager.clear();
        this.canvasManager.drawImageData(this.currentImageData, parseInt(this.params.size));
        // Don't draw grid for backgrounds by default
    }

    generateBackground(size, params, colors) {
        const imageData = this.canvasManager.ctx.createImageData(size, size);
        const data = imageData.data;

        const primaryRGB = this.colorPalette.hexToRgb(colors.primary);
        const secondaryRGB = this.colorPalette.hexToRgb(colors.secondary);
        const accentRGB = this.colorPalette.hexToRgb(colors.accent);
        const darkRGB = this.colorPalette.hexToRgb(colors.dark);

        // Fill with dark background
        for (let i = 0; i < data.length; i += 4) {
            data[i] = darkRGB.r;
            data[i + 1] = darkRGB.g;
            data[i + 2] = darkRGB.b;
            data[i + 3] = 255;
        }

        // Draw nebula
        if (params.nebula_density > 0) {
            this.drawNebula(data, size, params, primaryRGB, secondaryRGB, accentRGB);
        }

        // Draw dust particles
        if (params.dust_density > 0) {
            this.drawDustParticles(data, size, params, primaryRGB);
        }

        // Draw stars
        this.drawStars(data, size, params, accentRGB);

        // Draw sparkles
        this.drawSparkles(data, size, params, accentRGB);

        // Draw shooting stars
        this.drawShootingStars(data, size, params, accentRGB);

        return imageData;
    }

    drawStars(data, size, params, color) {
        this.stars.forEach(star => {
            // Twinkling effect
            let brightness = star.brightness * params.star_brightness;
            if (params.star_twinkling) {
                const twinkle = Math.sin(this.animationTime * star.twinkleSpeed + star.twinklePhase);
                brightness *= 0.7 + twinkle * 0.3;
            }

            this.drawStar(data, size, star.x, star.y, star.size, color, brightness);
        });
    }

    drawStar(data, size, x, y, starSize, color, brightness) {
        const cx = Math.round(x);
        const cy = Math.round(y);

        for (let dy = -starSize; dy <= starSize; dy++) {
            for (let dx = -starSize; dx <= starSize; dx++) {
                const px = cx + dx;
                const py = cy + dy;

                if (px >= 0 && px < size && py >= 0 && py < size) {
                    const dist = Math.sqrt(dx * dx + dy * dy);
                    if (dist <= starSize) {
                        const i = (py * size + px) * 4;
                        const intensity = (1 - dist / starSize) * brightness;

                        data[i] = Math.max(data[i], Math.round(color.r * intensity));
                        data[i + 1] = Math.max(data[i + 1], Math.round(color.g * intensity));
                        data[i + 2] = Math.max(data[i + 2], Math.round(color.b * intensity));
                    }
                }
            }
        }
    }

    drawSparkles(data, size, params, color) {
        this.sparkles.forEach(sparkle => {
            const rotation = this.animationTime * sparkle.rotationSpeed + sparkle.rotationPhase;
            const pulse = Math.sin(this.animationTime * sparkle.pulseSpeed + sparkle.pulsePhase) * 0.5 + 0.5;
            const intensity = pulse * params.sparkle_intensity;

            this.drawSparkle(data, size, sparkle.x, sparkle.y, params.sparkle_size, rotation, color, intensity);
        });
    }

    drawSparkle(data, size, x, y, sparkleSize, rotation, color, intensity) {
        const cx = Math.round(x);
        const cy = Math.round(y);

        // Draw 4-point star
        for (let angle = 0; angle < Math.PI * 2; angle += Math.PI / 2) {
            const finalAngle = angle + rotation;

            for (let r = 0; r < sparkleSize; r++) {
                const px = Math.round(cx + Math.cos(finalAngle) * r);
                const py = Math.round(cy + Math.sin(finalAngle) * r);

                if (px >= 0 && px < size && py >= 0 && py < size) {
                    const i = (py * size + px) * 4;
                    const rayIntensity = (1 - r / sparkleSize) * intensity;

                    data[i] = Math.max(data[i], Math.round(color.r * rayIntensity));
                    data[i + 1] = Math.max(data[i + 1], Math.round(color.g * rayIntensity));
                    data[i + 2] = Math.max(data[i + 2], Math.round(color.b * rayIntensity));
                }
            }
        }

        // Bright center
        const coreSize = 2;
        for (let dy = -coreSize; dy <= coreSize; dy++) {
            for (let dx = -coreSize; dx <= coreSize; dx++) {
                const px = cx + dx;
                const py = cy + dy;

                if (px >= 0 && px < size && py >= 0 && py < size) {
                    const dist = Math.sqrt(dx * dx + dy * dy);
                    if (dist <= coreSize) {
                        const i = (py * size + px) * 4;
                        const coreIntensity = (1 - dist / coreSize) * intensity;

                        data[i] = Math.max(data[i], Math.round(color.r * coreIntensity));
                        data[i + 1] = Math.max(data[i + 1], Math.round(color.g * coreIntensity));
                        data[i + 2] = Math.max(data[i + 2], Math.round(color.b * coreIntensity));
                    }
                }
            }
        }
    }

    drawShootingStars(data, size, params, color) {
        this.shootingStars.forEach(star => {
            const phase = (this.animationTime * star.speed + star.phaseOffset) % 2;
            if (phase > 1) return; // Only visible for half the cycle

            const traveled = phase * size * 1.5;
            const x = star.startX + Math.cos(star.angle) * traveled;
            const y = star.startY + Math.sin(star.angle) * traveled;

            this.drawShootingStar(data, size, x, y, star.angle, params.shooting_star_length, color, 1 - phase);
        });
    }

    drawShootingStar(data, size, x, y, angle, length, color, intensity) {
        // Draw trail
        for (let l = 0; l < length; l++) {
            const px = Math.round(x - Math.cos(angle) * l);
            const py = Math.round(y - Math.sin(angle) * l);

            if (px >= 0 && px < size && py >= 0 && py < size) {
                const i = (py * size + px) * 4;
                const trailIntensity = (1 - l / length) * intensity;

                data[i] = Math.max(data[i], Math.round(color.r * trailIntensity));
                data[i + 1] = Math.max(data[i + 1], Math.round(color.g * trailIntensity));
                data[i + 2] = Math.max(data[i + 2], Math.round(color.b * trailIntensity));
            }
        }

        // Bright head
        const headSize = 2;
        const cx = Math.round(x);
        const cy = Math.round(y);

        for (let dy = -headSize; dy <= headSize; dy++) {
            for (let dx = -headSize; dx <= headSize; dx++) {
                const px = cx + dx;
                const py = cy + dy;

                if (px >= 0 && px < size && py >= 0 && py < size) {
                    const dist = Math.sqrt(dx * dx + dy * dy);
                    if (dist <= headSize) {
                        const i = (py * size + px) * 4;
                        const headIntensity = (1 - dist / headSize) * intensity * 1.5;

                        data[i] = Math.max(data[i], Math.round(color.r * headIntensity));
                        data[i + 1] = Math.max(data[i + 1], Math.round(color.g * headIntensity));
                        data[i + 2] = Math.max(data[i + 2], Math.round(color.b * headIntensity));
                    }
                }
            }
        }
    }

    drawNebula(data, size, params, color1, color2, color3) {
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                let nebulaValue = 0;

                // Multiple noise layers
                for (let layer = 0; layer < params.nebula_layers; layer++) {
                    const scale = params.nebula_scale * (layer + 1);
                    const layerNoise = this.noise2D(x * scale, y * scale);
                    nebulaValue += layerNoise / (layer + 1);
                }

                nebulaValue = nebulaValue / params.nebula_layers;

                if (nebulaValue > (1 - params.nebula_density)) {
                    const i = (y * size + x) * 4;
                    const intensity = (nebulaValue - (1 - params.nebula_density)) / params.nebula_density;

                    // Color gradient based on noise
                    let r, g, b;
                    if (intensity < 0.5) {
                        const t = intensity * 2;
                        r = color1.r * (1 - t) + color2.r * t;
                        g = color1.g * (1 - t) + color2.g * t;
                        b = color1.b * (1 - t) + color2.b * t;
                    } else {
                        const t = (intensity - 0.5) * 2;
                        r = color2.r * (1 - t) + color3.r * t;
                        g = color2.g * (1 - t) + color3.g * t;
                        b = color2.b * (1 - t) + color3.b * t;
                    }

                    // Blend with existing background
                    const alpha = intensity * 0.4;
                    data[i] = Math.round(data[i] * (1 - alpha) + r * alpha);
                    data[i + 1] = Math.round(data[i + 1] * (1 - alpha) + g * alpha);
                    data[i + 2] = Math.round(data[i + 2] * (1 - alpha) + b * alpha);
                }
            }
        }
    }

    drawDustParticles(data, size, params, color) {
        this.dustParticles.forEach(dust => {
            // Update position for animation
            if (params.animated) {
                dust.x += dust.vx;
                dust.y += dust.vy;

                // Wrap around
                if (dust.x < 0) dust.x += size;
                if (dust.x >= size) dust.x -= size;
                if (dust.y < 0) dust.y += size;
                if (dust.y >= size) dust.y -= size;
            }

            const px = Math.round(dust.x);
            const py = Math.round(dust.y);

            if (px >= 0 && px < size && py >= 0 && py < size) {
                const i = (py * size + px) * 4;
                const intensity = 0.3;

                data[i] = Math.max(data[i], Math.round(color.r * intensity));
                data[i + 1] = Math.max(data[i + 1], Math.round(color.g * intensity));
                data[i + 2] = Math.max(data[i + 2], Math.round(color.b * intensity));
            }
        });
    }

    random(seed) {
        const n = Math.sin(seed * 12.9898) * 43758.5453;
        return n - Math.floor(n);
    }

    noise2D(x, y) {
        const n = Math.sin(x * 12.9898 + y * 78.233) * 43758.5453;
        return (n - Math.floor(n)) * 2 - 1;
    }

    updateDatabaseFields() {
        const assetType = document.getElementById('asset-type').value;
        const material = document.getElementById('material').value || 'default';
        const sizeCategory = document.getElementById('size-category').value;
        const state = document.getElementById('state').value;

        const filename = `${assetType}_${material}_${sizeCategory}_${state}`;
        document.getElementById('auto-filename').value = filename;
    }

    exportAsset() {
        if (!this.currentImageData) {
            alert('Bitte generiere zuerst einen Hintergrund!');
            return;
        }

        const filename = document.getElementById('auto-filename').value;
        const itemId = document.getElementById('item-id').value;
        const size = parseInt(this.params.size);

        this.canvasManager.exportToPNG(this.currentImageData, size, `${filename}.png`);

        const metadata = {
            itemId: itemId,
            filename: filename,
            type: document.getElementById('asset-type').value,
            theme: document.getElementById('material').value,
            size: size,
            sizeClass: document.getElementById('size-category').value,
            variant: document.getElementById('state').value,
            parameters: this.params,
            colors: this.colorPalette.getColors(),
            generated: new Date().toISOString()
        };

        const jsonBlob = new Blob([JSON.stringify(metadata, null, 2)], {
            type: 'application/json'
        });
        const jsonUrl = URL.createObjectURL(jsonBlob);
        const jsonLink = document.createElement('a');
        jsonLink.href = jsonUrl;
        jsonLink.download = `${filename}.json`;
        jsonLink.click();
        URL.revokeObjectURL(jsonUrl);

        console.log('✅ Exported:', filename);
    }
}

window.BackgroundGenerator = BackgroundGenerator;
