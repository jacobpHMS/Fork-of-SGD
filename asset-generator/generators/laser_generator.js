/* ============================================================
   LASER GENERATOR
   Generates various laser beam types
   ============================================================ */

class LaserGenerator {
    constructor() {
        this.params = {
            laser_type: 'mining',
            size: 128,
            beam_length: 0.8,
            beam_width: 4,
            core_intensity: 1.5,
            glow_radius: 1.5,
            pulse_speed: 3,
            distortion: 0.1,
            particle_count: 15,
            beam_angle: 0,
            add_core_flash: true,
            add_electricity: false,
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
        this.colorPalette.applyPalette('energy');

        this.initParameterListeners();
        this.initExportButton();
        this.updateDatabaseFields();
        this.generate();

        // Start animation loop
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
                        if (id === 'beam_angle') {
                            valueSpan.textContent = `${Math.round(value)}°`;
                        } else if (value < 1) {
                            valueSpan.textContent = value.toFixed(2);
                        } else {
                            valueSpan.textContent = value.toFixed(1);
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
                this.animationTime += 0.1;
                this.generate();
            }
            requestAnimationFrame(animate);
        };
        animate();
    }

    generate() {
        const size = parseInt(this.params.size);
        const colors = this.colorPalette.getColors();

        this.currentImageData = this.generateLaser(size, this.params, colors);

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

    generateLaser(size, params, colors) {
        const imageData = this.canvasManager.ctx.createImageData(size, size);
        const data = imageData.data;

        const centerX = size / 2;
        const centerY = size / 2;

        const primaryRGB = this.colorPalette.hexToRgb(colors.primary);
        const secondaryRGB = this.colorPalette.hexToRgb(colors.secondary);
        const accentRGB = this.colorPalette.hexToRgb(colors.accent);

        // Calculate beam parameters
        const beamLength = size * params.beam_length;
        const beamWidth = params.beam_width;
        const angle = (params.beam_angle * Math.PI) / 180;

        // Pulse animation
        const pulsePhase = this.animationTime * params.pulse_speed;
        const pulseValue = Math.sin(pulsePhase) * 0.5 + 0.5;

        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const i = (y * size + x) * 4;

                // Rotate coordinates
                const dx = x - centerX;
                const dy = y - centerY;
                const rx = dx * Math.cos(angle) - dy * Math.sin(angle);
                const ry = dx * Math.sin(angle) + dy * Math.cos(angle);

                // Check if in beam area
                const distanceAlongBeam = rx + beamLength / 2;
                const distanceFromBeam = Math.abs(ry);

                if (distanceAlongBeam >= 0 && distanceAlongBeam <= beamLength) {
                    // Add distortion
                    const distortedDist = distanceFromBeam +
                        this.noise2D(distanceAlongBeam * 0.1, this.animationTime * 0.5) * params.distortion * beamWidth;

                    // Core beam
                    if (distortedDist < beamWidth / 2) {
                        const coreIntensity = (1 - (distortedDist / (beamWidth / 2))) * params.core_intensity;
                        const pulseEffect = params.animated ? (0.7 + pulseValue * 0.3) : 1.0;

                        data[i] = Math.min(255, Math.round(accentRGB.r * coreIntensity * pulseEffect));
                        data[i + 1] = Math.min(255, Math.round(accentRGB.g * coreIntensity * pulseEffect));
                        data[i + 2] = Math.min(255, Math.round(accentRGB.b * coreIntensity * pulseEffect));
                        data[i + 3] = 255;
                    }
                    // Glow
                    else if (distortedDist < beamWidth * params.glow_radius) {
                        const glowIntensity = 1 - ((distortedDist - beamWidth / 2) / (beamWidth * params.glow_radius - beamWidth / 2));
                        const colorMix = glowIntensity;

                        data[i] = Math.round((primaryRGB.r * (1 - colorMix) + secondaryRGB.r * colorMix) * glowIntensity);
                        data[i + 1] = Math.round((primaryRGB.g * (1 - colorMix) + secondaryRGB.g * colorMix) * glowIntensity);
                        data[i + 2] = Math.round((primaryRGB.b * (1 - colorMix) + secondaryRGB.b * colorMix) * glowIntensity);
                        data[i + 3] = Math.round(glowIntensity * 200);
                    }
                }

                // Energy particles
                if (params.particle_count > 0) {
                    for (let p = 0; p < params.particle_count; p++) {
                        const particlePhase = (this.animationTime * params.pulse_speed + p * 0.5) % 1;
                        const particleX = centerX + (particlePhase - 0.5) * beamLength * Math.cos(angle);
                        const particleY = centerY + (particlePhase - 0.5) * beamLength * Math.sin(angle);
                        const particleDist = Math.sqrt(Math.pow(x - particleX, 2) + Math.pow(y - particleY, 2));

                        if (particleDist < 2) {
                            const particleIntensity = 1 - (particleDist / 2);
                            data[i] = Math.max(data[i], Math.round(accentRGB.r * particleIntensity));
                            data[i + 1] = Math.max(data[i + 1], Math.round(accentRGB.g * particleIntensity));
                            data[i + 2] = Math.max(data[i + 2], Math.round(accentRGB.b * particleIntensity));
                            data[i + 3] = Math.max(data[i + 3], Math.round(particleIntensity * 255));
                        }
                    }
                }
            }
        }

        // Core flash at origin
        if (params.add_core_flash) {
            const flashRadius = beamWidth * 2;
            for (let y = 0; y < size; y++) {
                for (let x = 0; x < size; x++) {
                    const i = (y * size + x) * 4;
                    const dx = x - centerX;
                    const dy = y - centerY;
                    const dist = Math.sqrt(dx * dx + dy * dy);

                    if (dist < flashRadius) {
                        const flashIntensity = (1 - dist / flashRadius) * (0.8 + pulseValue * 0.2);
                        data[i] = Math.max(data[i], Math.round(accentRGB.r * flashIntensity));
                        data[i + 1] = Math.max(data[i + 1], Math.round(accentRGB.g * flashIntensity));
                        data[i + 2] = Math.max(data[i + 2], Math.round(accentRGB.b * flashIntensity));
                        data[i + 3] = Math.max(data[i + 3], Math.round(flashIntensity * 255));
                    }
                }
            }
        }

        return imageData;
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
            alert('Bitte generiere zuerst einen Laser!');
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
            beamType: document.getElementById('material').value,
            size: size,
            powerClass: document.getElementById('size-category').value,
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

window.LaserGenerator = LaserGenerator;
