/* ============================================================
   PROJECTILE GENERATOR
   Generates various projectile types (bullets, missiles, plasma, etc.)
   ============================================================ */

class ProjectileGenerator {
    constructor() {
        this.params = {
            projectile_type: 'bullet',
            size: 32,
            speed_blur: 0.3,
            trail_length: 5,
            glow_intensity: 1.0,
            core_size: 0.5,
            particle_count: 5,
            rotation: 0,
            animated: true
        };

        this.canvasManager = null;
        this.previewManager = null;
        this.colorPalette = null;
        this.currentImageData = null;
    }

    init() {
        this.canvasManager = new CanvasManager('main-canvas');
        this.previewManager = new PreviewCanvasManager('preview-canvas');
        this.colorPalette = new ColorPaletteManager();

        this.canvasManager.setRenderCallback(() => this.render());
        this.colorPalette.initEventListeners(() => this.generate());
        this.colorPalette.applyPalette('pirate_red');

        this.initParameterListeners();
        this.initExportButton();
        this.updateDatabaseFields();
        this.generate();
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
                        if (id === 'rotation') {
                            valueSpan.textContent = `${Math.round(value)}°`;
                        } else if (value < 1) {
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

    generate() {
        const size = parseInt(this.params.size);
        const colors = this.colorPalette.getColors();

        this.currentImageData = this.generateProjectile(size, this.params, colors);

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

    generateProjectile(size, params, colors) {
        const imageData = this.canvasManager.ctx.createImageData(size, size);
        const data = imageData.data;

        const centerX = size / 2;
        const centerY = size / 2;

        const primaryRGB = this.colorPalette.hexToRgb(colors.primary);
        const accentRGB = this.colorPalette.hexToRgb(colors.accent);

        // Draw projectile based on type
        switch (params.projectile_type) {
            case 'bullet':
                this.drawBullet(data, size, centerX, centerY, params, primaryRGB, accentRGB);
                break;
            case 'missile':
                this.drawMissile(data, size, centerX, centerY, params, primaryRGB, accentRGB);
                break;
            case 'plasma':
                this.drawPlasma(data, size, centerX, centerY, params, primaryRGB, accentRGB);
                break;
            case 'laser_bolt':
                this.drawLaserBolt(data, size, centerX, centerY, params, primaryRGB, accentRGB);
                break;
            case 'rocket':
                this.drawRocket(data, size, centerX, centerY, params, primaryRGB, accentRGB);
                break;
        }

        return imageData;
    }

    drawBullet(data, size, cx, cy, params, primaryRGB, accentRGB) {
        const coreRadius = size * 0.15 * params.core_size;

        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const i = (y * size + x) * 4;
                const dx = x - cx;
                const dy = y - cy;
                const dist = Math.sqrt(dx * dx + dy * dy);

                if (dist < coreRadius) {
                    const intensity = 1 - (dist / coreRadius);
                    data[i] = Math.round(primaryRGB.r * intensity);
                    data[i + 1] = Math.round(primaryRGB.g * intensity);
                    data[i + 2] = Math.round(primaryRGB.b * intensity);
                    data[i + 3] = 255;
                } else if (dist < coreRadius * 1.5 * params.glow_intensity) {
                    const glowFactor = 1 - ((dist - coreRadius) / (coreRadius * 0.5 * params.glow_intensity));
                    data[i] = Math.round(accentRGB.r * glowFactor);
                    data[i + 1] = Math.round(accentRGB.g * glowFactor);
                    data[i + 2] = Math.round(accentRGB.b * glowFactor);
                    data[i + 3] = Math.round(glowFactor * 200);
                }
            }
        }
    }

    drawPlasma(data, size, cx, cy, params, primaryRGB, accentRGB) {
        const coreRadius = size * 0.25 * params.core_size;

        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const i = (y * size + x) * 4;
                const dx = x - cx;
                const dy = y - cy;
                const dist = Math.sqrt(dx * dx + dy * dy);

                // Plasma core with noise
                const noise = this.noise2D(x * 0.2, y * 0.2);

                if (dist < coreRadius * (1 + noise * 0.2)) {
                    const intensity = 1 - (dist / coreRadius);
                    data[i] = Math.round((primaryRGB.r + accentRGB.r) / 2 * intensity);
                    data[i + 1] = Math.round((primaryRGB.g + accentRGB.g) / 2 * intensity);
                    data[i + 2] = Math.round((primaryRGB.b + accentRGB.b) / 2 * intensity);
                    data[i + 3] = 255;
                } else if (dist < coreRadius * 2 * params.glow_intensity) {
                    const glowFactor = (1 - ((dist - coreRadius) / coreRadius)) * (1 + noise * 0.3);
                    if (glowFactor > 0) {
                        data[i] = Math.round(accentRGB.r * glowFactor);
                        data[i + 1] = Math.round(accentRGB.g * glowFactor);
                        data[i + 2] = Math.round(accentRGB.b * glowFactor);
                        data[i + 3] = Math.round(glowFactor * 150);
                    }
                }
            }
        }
    }

    drawMissile(data, size, cx, cy, params, primaryRGB, accentRGB) {
        const length = size * 0.6;
        const width = size * 0.2;

        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const i = (y * size + x) * 4;
                const dx = x - cx;
                const dy = y - cy;

                // Missile body (horizontal)
                if (Math.abs(dy) < width / 2 && dx > -length / 2 && dx < length / 2) {
                    const bodyPos = (dx + length / 2) / length;
                    data[i] = Math.round(primaryRGB.r * (1 - bodyPos * 0.3));
                    data[i + 1] = Math.round(primaryRGB.g * (1 - bodyPos * 0.3));
                    data[i + 2] = Math.round(primaryRGB.b * (1 - bodyPos * 0.3));
                    data[i + 3] = 255;
                }

                // Trail
                if (dx < -length / 2 && Math.abs(dy) < width) {
                    const trailDist = Math.abs(dx + length / 2);
                    if (trailDist < params.trail_length) {
                        const trailIntensity = 1 - (trailDist / params.trail_length);
                        data[i] = Math.round(accentRGB.r * trailIntensity);
                        data[i + 1] = Math.round(accentRGB.g * trailIntensity);
                        data[i + 2] = Math.round(accentRGB.b * trailIntensity);
                        data[i + 3] = Math.round(trailIntensity * 200);
                    }
                }
            }
        }
    }

    drawLaserBolt(data, size, cx, cy, params, primaryRGB, accentRGB) {
        const length = size * 0.5;
        const coreWidth = 2;

        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const i = (y * size + x) * 4;
                const dx = x - cx;
                const dy = y - cy;

                // Laser core (horizontal line)
                if (Math.abs(dy) < coreWidth && Math.abs(dx) < length / 2) {
                    data[i] = accentRGB.r;
                    data[i + 1] = accentRGB.g;
                    data[i + 2] = accentRGB.b;
                    data[i + 3] = 255;
                }

                // Glow around laser
                const distToLine = Math.abs(dy);
                if (distToLine < coreWidth * 3 * params.glow_intensity && Math.abs(dx) < length / 2) {
                    const glowFactor = 1 - (distToLine / (coreWidth * 3 * params.glow_intensity));
                    data[i] = Math.round(primaryRGB.r * glowFactor);
                    data[i + 1] = Math.round(primaryRGB.g * glowFactor);
                    data[i + 2] = Math.round(primaryRGB.b * glowFactor);
                    data[i + 3] = Math.round(glowFactor * 180);
                }
            }
        }
    }

    drawRocket(data, size, cx, cy, params, primaryRGB, accentRGB) {
        this.drawMissile(data, size, cx, cy, params, primaryRGB, accentRGB);
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
            alert('Bitte generiere zuerst ein Projektil!');
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
            weaponType: document.getElementById('material').value,
            size: size,
            damageClass: document.getElementById('size-category').value,
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

window.ProjectileGenerator = ProjectileGenerator;
