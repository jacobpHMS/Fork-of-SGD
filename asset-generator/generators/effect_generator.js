/* ============================================================
   EFFECT GENERATOR
   Generates explosions, shields, impacts, and other VFX
   ============================================================ */

class EffectGenerator {
    constructor() {
        this.params = {
            effect_type: 'explosion',
            size: 128,
            expansion: 0.5,
            particle_count: 30,
            intensity: 1,
            ring_count: 2,
            distortion: 0.3,
            glow_radius: 1.5,
            add_flash: true,
            add_shockwave: true,
            animated: true
        };

        this.canvasManager = null;
        this.previewManager = null;
        this.colorPalette = null;
        this.currentImageData = null;
        this.animationTime = 0;
    }

    init() {
        this.canvasManager = new CanvasManager('main-canvas');
        this.previewManager = new PreviewCanvasManager('preview-canvas');
        this.colorPalette = new ColorPaletteManager();

        this.canvasManager.setRenderCallback(() => this.render());
        this.colorPalette.initEventListeners(() => this.generate());
        this.colorPalette.applyPalette('mining_orange');

        this.initParameterListeners();
        this.initExportButton();
        this.updateDatabaseFields();
        this.generate();

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
                        if (value < 1) {
                            valueSpan.textContent = value.toFixed(2);
                        } else {
                            valueSpan.textContent = Math.round(value);
                        }
                    }
                }

                clearTimeout(this.regenTimeout);
                this.regenTimeout = setTimeout(() => {
                    this.generate();
                    this.updateDatabaseFields();
                }, 50);
            });
        });

        document.getElementById('generate-btn').addEventListener('click', () => {
            this.generate();
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
                this.animationTime += 0.03;
                if (this.animationTime > 1) this.animationTime = 0;
                this.generate();
            }
            requestAnimationFrame(animate);
        };
        animate();
    }

    generate() {
        const size = parseInt(this.params.size);
        const colors = this.colorPalette.getColors();

        this.currentImageData = this.generateEffect(size, this.params, colors);

        this.render();
        this.previewManager.updatePreview(this.currentImageData, size);
    }

    render() {
        if (!this.currentImageData) return;

        this.canvasManager.clear();
        this.canvasManager.drawBackground();
        this.canvasManager.drawImageData(this.currentImageData, parseInt(this.params.size));
        this.canvasManager.drawGrid();
    }

    generateEffect(size, params, colors) {
        const imageData = this.canvasManager.ctx.createImageData(size, size);
        const data = imageData.data;

        const centerX = size / 2;
        const centerY = size / 2;

        const primaryRGB = this.colorPalette.hexToRgb(colors.primary);
        const secondaryRGB = this.colorPalette.hexToRgb(colors.secondary);
        const accentRGB = this.colorPalette.hexToRgb(colors.accent);

        switch (params.effect_type) {
            case 'explosion':
                this.drawExplosion(data, size, centerX, centerY, params, primaryRGB, secondaryRGB, accentRGB);
                break;
            case 'shield':
                this.drawShield(data, size, centerX, centerY, params, primaryRGB, accentRGB);
                break;
            case 'impact':
                this.drawImpact(data, size, centerX, centerY, params, primaryRGB, accentRGB);
                break;
            case 'warp':
                this.drawWarp(data, size, centerX, centerY, params, primaryRGB, accentRGB);
                break;
            case 'teleport':
                this.drawTeleport(data, size, centerX, centerY, params, primaryRGB, secondaryRGB, accentRGB);
                break;
        }

        return imageData;
    }

    drawExplosion(data, size, cx, cy, params, color1, color2, color3) {
        const expansionPhase = this.animationTime;
        const maxRadius = size * 0.4 * params.expansion;

        // Particles
        for (let p = 0; p < params.particle_count; p++) {
            const angle = (p / params.particle_count) * Math.PI * 2;
            const noise = this.noise1D(p * 12.34);
            const particleRadius = maxRadius * expansionPhase * (0.8 + noise * 0.4);
            const px = cx + Math.cos(angle) * particleRadius;
            const py = cy + Math.sin(angle) * particleRadius;
            const particleSize = 3 + noise * 2;

            const fadeOut = 1 - expansionPhase;
            this.drawParticle(data, size, px, py, particleSize, color1, fadeOut * params.intensity);
        }

        // Rings
        for (let ring = 0; ring < params.ring_count; ring++) {
            const ringPhase = (expansionPhase + ring * 0.3) % 1;
            const ringRadius = maxRadius * ringPhase * 1.5;
            const ringAlpha = (1 - ringPhase) * 0.6;

            for (let y = 0; y < size; y++) {
                for (let x = 0; x < size; x++) {
                    const dx = x - cx;
                    const dy = y - cy;
                    const dist = Math.sqrt(dx * dx + dy * dy);

                    if (Math.abs(dist - ringRadius) < 3) {
                        const i = (y * size + x) * 4;
                        const intensity = (1 - Math.abs(dist - ringRadius) / 3) * ringAlpha;

                        data[i] = Math.max(data[i], Math.round(color2.r * intensity));
                        data[i + 1] = Math.max(data[i + 1], Math.round(color2.g * intensity));
                        data[i + 2] = Math.max(data[i + 2], Math.round(color2.b * intensity));
                        data[i + 3] = Math.max(data[i + 3], Math.round(intensity * 255));
                    }
                }
            }
        }

        // Center flash
        if (params.add_flash) {
            const flashRadius = maxRadius * 0.3 * (1 - expansionPhase);
            const flashIntensity = (1 - expansionPhase) * params.intensity;

            for (let y = 0; y < size; y++) {
                for (let x = 0; x < size; x++) {
                    const dx = x - cx;
                    const dy = y - cy;
                    const dist = Math.sqrt(dx * dx + dy * dy);

                    if (dist < flashRadius) {
                        const i = (y * size + x) * 4;
                        const intensity = (1 - dist / flashRadius) * flashIntensity;

                        data[i] = Math.max(data[i], Math.round(color3.r * intensity));
                        data[i + 1] = Math.max(data[i + 1], Math.round(color3.g * intensity));
                        data[i + 2] = Math.max(data[i + 2], Math.round(color3.b * intensity));
                        data[i + 3] = Math.max(data[i + 3], Math.round(intensity * 255));
                    }
                }
            }
        }

        // Shockwave
        if (params.add_shockwave) {
            const shockRadius = maxRadius * expansionPhase * 2;
            const shockIntensity = (1 - expansionPhase) * 0.8;

            for (let y = 0; y < size; y++) {
                for (let x = 0; x < size; x++) {
                    const dx = x - cx;
                    const dy = y - cy;
                    const dist = Math.sqrt(dx * dx + dy * dy);

                    if (Math.abs(dist - shockRadius) < 2) {
                        const i = (y * size + x) * 4;
                        const intensity = (1 - Math.abs(dist - shockRadius) / 2) * shockIntensity;

                        data[i] = Math.max(data[i], Math.round(color3.r * intensity));
                        data[i + 1] = Math.max(data[i + 1], Math.round(color3.g * intensity));
                        data[i + 2] = Math.max(data[i + 2], Math.round(color3.b * intensity));
                        data[i + 3] = Math.max(data[i + 3], Math.round(intensity * 200));
                    }
                }
            }
        }
    }

    drawShield(data, size, cx, cy, params, color1, color2) {
        const radius = size * 0.4;
        const hitAngle = this.animationTime * Math.PI * 2;
        const hitX = cx + Math.cos(hitAngle) * radius;
        const hitY = cy + Math.sin(hitAngle) * radius;

        // Shield bubble
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const dx = x - cx;
                const dy = y - cy;
                const dist = Math.sqrt(dx * dx + dy * dy);

                if (Math.abs(dist - radius) < 3) {
                    const i = (y * size + x) * 4;
                    const hexPattern = this.noise2D(x * 0.2, y * 0.2);
                    const intensity = (1 - Math.abs(dist - radius) / 3) * 0.4 * (0.5 + hexPattern * 0.5);

                    data[i] = Math.round(color1.r * intensity);
                    data[i + 1] = Math.round(color1.g * intensity);
                    data[i + 2] = Math.round(color1.b * intensity);
                    data[i + 3] = Math.round(intensity * 200);
                }
            }
        }

        // Impact point
        const impactRadius = 15;
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const dx = x - hitX;
                const dy = y - hitY;
                const dist = Math.sqrt(dx * dx + dy * dy);

                if (dist < impactRadius) {
                    const i = (y * size + x) * 4;
                    const intensity = (1 - dist / impactRadius) * params.intensity;

                    data[i] = Math.max(data[i], Math.round(color2.r * intensity));
                    data[i + 1] = Math.max(data[i + 1], Math.round(color2.g * intensity));
                    data[i + 2] = Math.max(data[i + 2], Math.round(color2.b * intensity));
                    data[i + 3] = Math.max(data[i + 3], Math.round(intensity * 255));
                }
            }
        }
    }

    drawImpact(data, size, cx, cy, params, color1, color2) {
        const flashPhase = Math.sin(this.animationTime * Math.PI);
        const flashRadius = size * 0.2 * params.expansion;

        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const dx = x - cx;
                const dy = y - cy;
                const dist = Math.sqrt(dx * dx + dy * dy);

                if (dist < flashRadius) {
                    const i = (y * size + x) * 4;
                    const intensity = (1 - dist / flashRadius) * flashPhase * params.intensity;

                    data[i] = Math.round(color2.r * intensity);
                    data[i + 1] = Math.round(color2.g * intensity);
                    data[i + 2] = Math.round(color2.b * intensity);
                    data[i + 3] = Math.round(intensity * 255);
                }
            }
        }
    }

    drawWarp(data, size, cx, cy, params, color1, color2) {
        const warpPhase = this.animationTime;

        // Spiral lines
        for (let line = 0; line < 8; line++) {
            const baseAngle = (line / 8) * Math.PI * 2;

            for (let r = 0; r < size / 2; r++) {
                const angle = baseAngle + (r * 0.1) + (warpPhase * Math.PI * 2);
                const x = cx + Math.cos(angle) * r;
                const y = cy + Math.sin(angle) * r;

                if (x >= 0 && x < size && y >= 0 && y < size) {
                    const i = (Math.floor(y) * size + Math.floor(x)) * 4;
                    const intensity = (1 - r / (size / 2)) * 0.6;

                    data[i] = Math.max(data[i], Math.round(color1.r * intensity));
                    data[i + 1] = Math.max(data[i + 1], Math.round(color1.g * intensity));
                    data[i + 2] = Math.max(data[i + 2], Math.round(color1.b * intensity));
                    data[i + 3] = Math.max(data[i + 3], Math.round(intensity * 255));
                }
            }
        }
    }

    drawTeleport(data, size, cx, cy, params, color1, color2, color3) {
        const phase = this.animationTime;

        // Rising particles
        for (let p = 0; p < params.particle_count; p++) {
            const particlePhase = (phase + p / params.particle_count) % 1;
            const angle = (p / params.particle_count) * Math.PI * 2;
            const radius = size * 0.3 * (1 - particlePhase);
            const height = particlePhase * size * 0.5;

            const px = cx + Math.cos(angle) * radius;
            const py = cy - height;

            this.drawParticle(data, size, px, py, 2, color3, 1 - particlePhase);
        }
    }

    drawParticle(data, size, px, py, radius, color, alpha) {
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const dx = x - px;
                const dy = y - py;
                const dist = Math.sqrt(dx * dx + dy * dy);

                if (dist < radius) {
                    const i = (y * size + x) * 4;
                    const intensity = (1 - dist / radius) * alpha;

                    data[i] = Math.max(data[i], Math.round(color.r * intensity));
                    data[i + 1] = Math.max(data[i + 1], Math.round(color.g * intensity));
                    data[i + 2] = Math.max(data[i + 2], Math.round(color.b * intensity));
                    data[i + 3] = Math.max(data[i + 3], Math.round(intensity * 255));
                }
            }
        }
    }

    noise1D(x) {
        const n = Math.sin(x * 12.9898) * 43758.5453;
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

        const filename = `${assetType}_${material}_${sizeCategory}_${state}_01`;
        document.getElementById('auto-filename').value = filename;
    }

    exportAsset() {
        if (!this.currentImageData) {
            alert('Bitte generiere zuerst einen Effekt!');
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
            effectType: document.getElementById('material').value,
            size: size,
            sizeClass: document.getElementById('size-category').value,
            state: document.getElementById('state').value,
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

window.EffectGenerator = EffectGenerator;
