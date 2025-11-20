/* ============================================================
   ASTEROID GENERATOR
   Procedural asteroid generation with full parameter control
   ============================================================ */

class AsteroidGenerator {
    constructor() {
        this.params = {
            size: 64,
            complexity: 5,
            roughness: 0.5,
            elongation_x: 1.0,
            elongation_y: 1.0,
            rotation: 0,
            crater_count: 3,
            crater_depth: 0.5,
            edge_sharpness: 0.7,
            noise_scale: 0.1,
            brightness: 1.0,
            contrast: 1.0,
            add_glow: true,
            metallic: false
        };

        this.canvasManager = null;
        this.previewManager = null;
        this.colorPalette = null;
        this.currentImageData = null;
    }

    init() {
        // Initialize canvas managers
        this.canvasManager = new CanvasManager('main-canvas');
        this.previewManager = new PreviewCanvasManager('preview-canvas');
        this.colorPalette = new ColorPaletteManager();

        // Set up render callback
        this.canvasManager.setRenderCallback(() => this.render());

        // Initialize color palette
        this.colorPalette.initEventListeners(() => this.generate());
        this.colorPalette.applyPalette('cyber_blue');

        // Initialize parameter listeners
        this.initParameterListeners();

        // Initialize export button
        this.initExportButton();

        // Update database fields
        this.updateDatabaseFields();

        // Generate initial asteroid
        this.generate();
    }

    initParameterListeners() {
        // Get all inputs and selects
        const parameterInputs = document.querySelectorAll('.parameters input, .parameters select');

        parameterInputs.forEach(input => {
            const eventType = input.type === 'checkbox' ? 'change' : 'input';

            input.addEventListener(eventType, (e) => {
                const id = e.target.id;
                let value;

                if (e.target.type === 'checkbox') {
                    value = e.target.checked;
                } else if (e.target.type === 'range') {
                    value = parseFloat(e.target.value);
                } else if (e.target.type === 'number') {
                    value = parseFloat(e.target.value);
                } else if (e.target.tagName === 'SELECT') {
                    value = e.target.value === 'true' ? true :
                            e.target.value === 'false' ? false :
                            isNaN(e.target.value) ? e.target.value : parseFloat(e.target.value);
                } else {
                    value = e.target.value;
                }

                // Update parameter
                this.params[id] = value;

                // Update value display for range inputs
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

                // Debounced regeneration
                clearTimeout(this.regenTimeout);
                this.regenTimeout = setTimeout(() => {
                    this.generate();
                    this.updateDatabaseFields();
                }, 50);
            });
        });

        // Generate button
        document.getElementById('generate-btn').addEventListener('click', () => {
            this.generate();
        });
    }

    initExportButton() {
        document.getElementById('export-btn').addEventListener('click', () => {
            this.exportAsset();
        });

        // Update database fields on relevant changes
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

        // Generate asteroid
        this.currentImageData = this.generateAsteroid(size, this.params, colors);

        // Render to canvas
        this.render();

        // Update preview
        this.previewManager.updatePreview(this.currentImageData, size);
    }

    render() {
        if (!this.currentImageData) return;

        const size = parseInt(this.params.size);

        // Clear canvas
        this.canvasManager.clear();

        // Draw background
        this.canvasManager.drawBackground();

        // Draw asteroid
        this.canvasManager.drawImageData(this.currentImageData, size);

        // Draw grid overlay
        this.canvasManager.drawGrid();
    }

    generateAsteroid(size, params, colors) {
        const imageData = this.canvasManager.ctx.createImageData(size, size);
        const data = imageData.data;

        const centerX = size / 2;
        const centerY = size / 2;
        const baseRadius = size / 2 * 0.85;

        // Get color components
        const primaryRGB = this.colorPalette.hexToRgb(colors.primary);
        const secondaryRGB = this.colorPalette.hexToRgb(colors.secondary);
        const accentRGB = this.colorPalette.hexToRgb(colors.accent);
        const darkRGB = this.colorPalette.hexToRgb(colors.dark);

        // Generate craters
        const craters = [];
        for (let i = 0; i < params.crater_count; i++) {
            craters.push({
                x: (this.noise1D(i * 123.45) * 0.6 + 0.2) * size,
                y: (this.noise1D(i * 678.90) * 0.6 + 0.2) * size,
                radius: baseRadius * 0.2 * (0.5 + this.noise1D(i * 234.56) * 0.5),
                depth: params.crater_depth
            });
        }

        // Generate pixels
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const i = (y * size + x) * 4;

                // Apply rotation
                const angle = (params.rotation * Math.PI) / 180;
                const cosA = Math.cos(angle);
                const sinA = Math.sin(angle);
                const dx = x - centerX;
                const dy = y - centerY;
                const rx = dx * cosA - dy * sinA;
                const ry = dx * sinA + dy * cosA;

                // Apply elongation
                const ex = rx / params.elongation_x;
                const ey = ry / params.elongation_y;

                // Distance from center
                const dist = Math.sqrt(ex * ex + ey * ey);

                // Apply noise for roughness
                const noiseValue = this.noise2D(
                    x * params.noise_scale,
                    y * params.noise_scale
                );
                const roughnessOffset = noiseValue * params.roughness * baseRadius * 0.3;

                // Calculate effective distance with edge sharpness
                const threshold = baseRadius + roughnessOffset;
                const edgeDist = dist - threshold;
                const alpha = params.edge_sharpness > 0 ?
                    1 / (1 + Math.exp(edgeDist * params.edge_sharpness * 10)) :
                    edgeDist < 0 ? 1 : 0;

                if (alpha < 0.01) {
                    data[i] = 0;
                    data[i + 1] = 0;
                    data[i + 2] = 0;
                    data[i + 3] = 0;
                    continue;
                }

                // Calculate base color based on distance and noise
                const normalizedDist = dist / baseRadius;
                const detailNoise = this.noise2D(x * 0.05, y * 0.05);

                // Check if in crater
                let craterFactor = 0;
                for (let crater of craters) {
                    const craterDist = Math.sqrt(
                        Math.pow(x - crater.x, 2) + Math.pow(y - crater.y, 2)
                    );
                    if (craterDist < crater.radius) {
                        const craterDepth = (1 - craterDist / crater.radius) * crater.depth;
                        craterFactor = Math.max(craterFactor, craterDepth);
                    }
                }

                // Color mixing
                let r, g, b;
                if (craterFactor > 0) {
                    // Crater areas are darker
                    r = darkRGB.r + (primaryRGB.r - darkRGB.r) * (1 - craterFactor);
                    g = darkRGB.g + (primaryRGB.g - darkRGB.g) * (1 - craterFactor);
                    b = darkRGB.b + (primaryRGB.b - darkRGB.b) * (1 - craterFactor);
                } else {
                    // Normal surface
                    const colorMix = (normalizedDist + detailNoise * 0.3) * 0.5;

                    if (colorMix < 0.33) {
                        r = primaryRGB.r + (secondaryRGB.r - primaryRGB.r) * (colorMix * 3);
                        g = primaryRGB.g + (secondaryRGB.g - primaryRGB.g) * (colorMix * 3);
                        b = primaryRGB.b + (secondaryRGB.b - primaryRGB.b) * (colorMix * 3);
                    } else if (colorMix < 0.66) {
                        const t = (colorMix - 0.33) * 3;
                        r = secondaryRGB.r + (accentRGB.r - secondaryRGB.r) * t;
                        g = secondaryRGB.g + (accentRGB.g - secondaryRGB.g) * t;
                        b = secondaryRGB.b + (accentRGB.b - secondaryRGB.b) * t;
                    } else {
                        const t = (colorMix - 0.66) * 3;
                        r = accentRGB.r + (darkRGB.r - accentRGB.r) * t;
                        g = accentRGB.g + (darkRGB.g - accentRGB.g) * t;
                        b = accentRGB.b + (darkRGB.b - accentRGB.b) * t;
                    }
                }

                // Apply brightness and contrast
                r = ((r / 255 - 0.5) * params.contrast + 0.5) * params.brightness * 255;
                g = ((g / 255 - 0.5) * params.contrast + 0.5) * params.brightness * 255;
                b = ((b / 255 - 0.5) * params.contrast + 0.5) * params.brightness * 255;

                // Metallic effect
                if (params.metallic) {
                    const metallic = Math.abs(noiseValue) * 0.3;
                    r += metallic * 100;
                    g += metallic * 100;
                    b += metallic * 100;
                }

                // Clamp values
                r = Math.max(0, Math.min(255, r));
                g = Math.max(0, Math.min(255, g));
                b = Math.max(0, Math.min(255, b));

                data[i] = r;
                data[i + 1] = g;
                data[i + 2] = b;
                data[i + 3] = Math.round(alpha * 255);
            }
        }

        return imageData;
    }

    // Simple noise functions
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
            alert('Bitte generiere zuerst einen Asteroiden!');
            return;
        }

        const filename = document.getElementById('auto-filename').value;
        const itemId = document.getElementById('item-id').value;
        const size = parseInt(this.params.size);

        // Export PNG
        this.canvasManager.exportToPNG(this.currentImageData, size, `${filename}.png`);

        // Export JSON metadata
        const metadata = {
            itemId: itemId,
            filename: filename,
            type: document.getElementById('asset-type').value,
            material: document.getElementById('material').value,
            size: size,
            sizeCategory: document.getElementById('size-category').value,
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

// Make available globally
window.AsteroidGenerator = AsteroidGenerator;
