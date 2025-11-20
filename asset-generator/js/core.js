// ============================================================================
// CORE.JS - Canvas Engine & Main Application Logic
// SpaceGameDev - Procedural Pixel Art Asset Generator
// ============================================================================

class PixelArtGenerator {
    constructor() {
        this.canvas = document.getElementById('main-canvas');
        this.ctx = this.canvas.getContext('2d', { alpha: true });
        this.gridCanvas = document.getElementById('grid-canvas');
        this.gridCtx = this.gridCanvas.getContext('2d', { alpha: true });
        this.previewCanvas = document.getElementById('preview-canvas');
        this.previewCtx = this.previewCanvas.getContext('2d', { alpha: true });

        // Canvas state
        this.zoom = 8;
        this.panX = 0;
        this.panY = 0;
        this.gridSize = 32;
        this.showGrid = true;
        this.showBackground = false;

        // Pixel data
        this.pixelData = [];
        this.currentGenerator = 'ship';

        // Animation
        this.isAnimating = false;
        this.animationFrame = 0;
        this.animationFrameCount = 1;

        this.init();
    }

    init() {
        this.setupCanvas();
        this.setupEventListeners();
        this.loadSettings();
        this.render();

        console.log('✅ Pixel Art Generator initialized');
    }

    setupCanvas() {
        const wrapper = document.getElementById('canvas-wrapper');
        const rect = wrapper.getBoundingClientRect();

        this.canvas.width = rect.width;
        this.canvas.height = rect.height;
        this.gridCanvas.width = rect.width;
        this.gridCanvas.height = rect.height;

        // Set crisp pixel rendering
        this.ctx.imageSmoothingEnabled = false;
        this.gridCtx.imageSmoothingEnabled = false;
        this.previewCtx.imageSmoothingEnabled = false;

        this.centerView();
    }

    setupEventListeners() {
        // Generator type buttons
        document.querySelectorAll('[data-generator]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                document.querySelectorAll('[data-generator]').forEach(b => b.classList.remove('active'));
                e.target.classList.add('active');
                this.currentGenerator = e.target.dataset.generator;
                this.switchGenerator(e.target.dataset.generator);
            });
        });

        // Generate button
        document.getElementById('generate-btn').addEventListener('click', () => {
            this.generate();
        });

        // Randomize button
        document.getElementById('randomize-btn').addEventListener('click', () => {
            this.randomizeSettings();
            this.generate();
        });

        // Zoom controls
        document.getElementById('zoom-in').addEventListener('click', () => {
            this.zoom = Math.min(32, this.zoom * 2);
            this.updateZoomLevel();
            this.render();
        });

        document.getElementById('zoom-out').addEventListener('click', () => {
            this.zoom = Math.max(1, this.zoom / 2);
            this.updateZoomLevel();
            this.render();
        });

        // Grid toggle
        document.getElementById('toggle-grid').addEventListener('click', () => {
            this.showGrid = !this.showGrid;
            this.render();
        });

        // Center view
        document.getElementById('center-view').addEventListener('click', () => {
            this.centerView();
            this.render();
        });

        // Background toggle
        document.getElementById('show-background').addEventListener('change', (e) => {
            this.showBackground = e.target.checked;
            this.render();
        });

        // Canvas panning (mouse drag)
        let isPanning = false;
        let startX, startY;

        this.canvas.addEventListener('mousedown', (e) => {
            if (e.button === 0 && e.shiftKey) {
                isPanning = true;
                startX = e.clientX - this.panX;
                startY = e.clientY - this.panY;
                this.canvas.style.cursor = 'grabbing';
            }
        });

        window.addEventListener('mousemove', (e) => {
            if (isPanning) {
                this.panX = e.clientX - startX;
                this.panY = e.clientY - startY;
                this.render();
            }
        });

        window.addEventListener('mouseup', () => {
            if (isPanning) {
                isPanning = false;
                this.canvas.style.cursor = 'default';
            }
        });

        // Mouse wheel zoom
        this.canvas.addEventListener('wheel', (e) => {
            e.preventDefault();
            if (e.deltaY < 0) {
                this.zoom = Math.min(32, this.zoom * 1.2);
            } else {
                this.zoom = Math.max(1, this.zoom / 1.2);
            }
            this.updateZoomLevel();
            this.render();
        });

        // Range slider updates
        document.getElementById('ship-complexity').addEventListener('input', (e) => {
            document.getElementById('ship-complexity-value').textContent = e.target.value;
        });

        // Window resize
        window.addEventListener('resize', () => {
            this.setupCanvas();
            this.render();
        });

        // Export button
        document.getElementById('export-btn').addEventListener('click', () => {
            this.export();
        });

        // Preview animation
        document.getElementById('preview-animate').addEventListener('change', (e) => {
            this.isAnimating = e.target.checked;
            if (this.isAnimating) {
                this.startAnimation();
            }
        });

        // Preset management
        document.getElementById('save-preset-btn').addEventListener('click', () => {
            this.savePreset();
        });

        document.getElementById('load-preset-btn').addEventListener('click', () => {
            this.loadPresetsUI();
        });
    }

    updateZoomLevel() {
        document.getElementById('zoom-level').textContent = Math.round(this.zoom) + 'x';
    }

    centerView() {
        const centerX = (this.canvas.width - this.gridSize * this.zoom) / 2;
        const centerY = (this.canvas.height - this.gridSize * this.zoom) / 2;
        this.panX = centerX;
        this.panY = centerY;
    }

    generate() {
        const size = parseInt(document.getElementById('ship-size').value);
        this.gridSize = size;

        // Clear previous data
        this.pixelData = [];

        // Get seed if specified
        const seedInput = document.getElementById('random-seed').value;
        const seed = seedInput ? this.hashCode(seedInput) : Math.random() * 1000000;

        // Set random seed
        this.seededRandom = this.createSeededRandom(seed);

        // Call appropriate generator
        if (this.currentGenerator === 'ship') {
            const complexity = parseInt(document.getElementById('ship-complexity').value);
            const faction = document.getElementById('ship-faction').value;
            const symmetry = document.getElementById('ship-symmetry').value;
            const weapons = document.getElementById('ship-weapons').checked;
            const engines = document.getElementById('ship-engines').checked;

            this.pixelData = generateShip({
                size: size,
                complexity: complexity,
                faction: faction,
                symmetry: symmetry,
                weapons: weapons,
                engines: engines,
                random: this.seededRandom,
                palette: colorPalette.getCurrentPalette()
            });
        }

        this.updateStats();
        this.centerView();
        this.render();
        this.updatePreview();

        document.getElementById('canvas-info-text').textContent = `Generated ${size}x${size} ${this.currentGenerator}`;
    }

    randomizeSettings() {
        // Randomize ship settings
        const sizes = [16, 32, 64, 128];
        document.getElementById('ship-size').value = sizes[Math.floor(Math.random() * sizes.length)];
        document.getElementById('ship-complexity').value = Math.floor(Math.random() * 10) + 1;
        document.getElementById('ship-complexity-value').textContent = document.getElementById('ship-complexity').value;

        const factions = ['angular', 'organic', 'hybrid'];
        document.getElementById('ship-faction').value = factions[Math.floor(Math.random() * factions.length)];

        const symmetries = ['vertical', 'horizontal', 'both', 'radial'];
        document.getElementById('ship-symmetry').value = symmetries[Math.floor(Math.random() * symmetries.length)];

        document.getElementById('ship-weapons').checked = Math.random() > 0.3;
        document.getElementById('ship-engines').checked = Math.random() > 0.2;

        // Clear seed for true randomization
        document.getElementById('random-seed').value = '';
    }

    render() {
        // Clear canvases
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        this.gridCtx.clearRect(0, 0, this.gridCanvas.width, this.gridCanvas.height);

        // Draw background if enabled
        if (this.showBackground) {
            this.drawBackground();
        }

        // Draw pixel data
        if (this.pixelData && this.pixelData.length > 0) {
            this.drawPixels();
        }

        // Draw grid
        if (this.showGrid) {
            this.drawGrid();
        }
    }

    drawBackground() {
        // Simple checkerboard pattern
        const cellSize = this.zoom * 2;
        for (let y = 0; y < this.canvas.height; y += cellSize) {
            for (let x = 0; x < this.canvas.width; x += cellSize) {
                if ((Math.floor(x / cellSize) + Math.floor(y / cellSize)) % 2 === 0) {
                    this.ctx.fillStyle = '#0f1320';
                } else {
                    this.ctx.fillStyle = '#0a0e1a';
                }
                this.ctx.fillRect(x, y, cellSize, cellSize);
            }
        }
    }

    drawPixels() {
        for (let y = 0; y < this.gridSize; y++) {
            for (let x = 0; x < this.gridSize; x++) {
                const idx = y * this.gridSize + x;
                if (this.pixelData[idx]) {
                    const color = this.pixelData[idx];
                    this.ctx.fillStyle = color;
                    this.ctx.fillRect(
                        this.panX + x * this.zoom,
                        this.panY + y * this.zoom,
                        this.zoom,
                        this.zoom
                    );
                }
            }
        }
    }

    drawGrid() {
        this.gridCtx.strokeStyle = 'rgba(0, 217, 255, 0.2)';
        this.gridCtx.lineWidth = 1;

        // Vertical lines
        for (let x = 0; x <= this.gridSize; x++) {
            this.gridCtx.beginPath();
            this.gridCtx.moveTo(this.panX + x * this.zoom, this.panY);
            this.gridCtx.lineTo(this.panX + x * this.zoom, this.panY + this.gridSize * this.zoom);
            this.gridCtx.stroke();
        }

        // Horizontal lines
        for (let y = 0; y <= this.gridSize; y++) {
            this.gridCtx.beginPath();
            this.gridCtx.moveTo(this.panX, this.panY + y * this.zoom);
            this.gridCtx.lineTo(this.panX + this.gridSize * this.zoom, this.panY + y * this.zoom);
            this.gridCtx.stroke();
        }
    }

    updatePreview() {
        if (!this.pixelData || this.pixelData.length === 0) return;

        const size = this.gridSize;
        this.previewCanvas.width = size;
        this.previewCanvas.height = size;

        // Draw at 1:1 scale
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const idx = y * size + x;
                if (this.pixelData[idx]) {
                    this.previewCtx.fillStyle = this.pixelData[idx];
                    this.previewCtx.fillRect(x, y, 1, 1);
                }
            }
        }
    }

    startAnimation() {
        const animate = () => {
            if (!this.isAnimating) return;

            this.animationFrame = (this.animationFrame + 1) % this.animationFrameCount;
            this.updatePreview();

            setTimeout(() => requestAnimationFrame(animate), 100);
        };
        animate();
    }

    updateStats() {
        const size = this.gridSize;
        const pixelCount = this.pixelData.filter(p => p).length;
        const colorCount = new Set(this.pixelData.filter(p => p)).size;

        document.getElementById('stat-size').textContent = `${size}x${size}`;
        document.getElementById('stat-pixels').textContent = pixelCount;
        document.getElementById('stat-colors').textContent = colorCount;
    }

    export() {
        if (!this.pixelData || this.pixelData.length === 0) {
            alert('Please generate an asset first!');
            return;
        }

        const filename = document.getElementById('export-filename').value || 'asset';
        exportManager.exportPNG(this.pixelData, this.gridSize, filename);
    }

    savePreset() {
        const name = document.getElementById('preset-name').value;
        if (!name) {
            alert('Please enter a preset name');
            return;
        }

        const preset = {
            type: this.currentGenerator,
            settings: {
                size: parseInt(document.getElementById('ship-size').value),
                complexity: parseInt(document.getElementById('ship-complexity').value),
                faction: document.getElementById('ship-faction').value,
                symmetry: document.getElementById('ship-symmetry').value,
                weapons: document.getElementById('ship-weapons').checked,
                engines: document.getElementById('ship-engines').checked
            },
            palette: colorPalette.getCurrentPalette(),
            timestamp: Date.now()
        };

        const presets = this.loadPresets();
        presets[name] = preset;
        localStorage.setItem('pixel-art-presets', JSON.stringify(presets));

        document.getElementById('preset-name').value = '';
        this.loadPresetsUI();
        alert(`Preset "${name}" saved!`);
    }

    loadPresets() {
        const stored = localStorage.getItem('pixel-art-presets');
        return stored ? JSON.parse(stored) : {};
    }

    loadPresetsUI() {
        const presets = this.loadPresets();
        const list = document.getElementById('preset-list');
        list.innerHTML = '';

        Object.keys(presets).forEach(name => {
            const item = document.createElement('div');
            item.className = 'preset-item';
            item.innerHTML = `
                <span class="preset-name">${name}</span>
                <div class="preset-actions">
                    <button class="btn btn-small" onclick="app.applyPreset('${name}')">Load</button>
                    <button class="btn btn-small" onclick="app.deletePreset('${name}')">×</button>
                </div>
            `;
            list.appendChild(item);
        });
    }

    applyPreset(name) {
        const presets = this.loadPresets();
        const preset = presets[name];
        if (!preset) return;

        // Apply settings
        document.getElementById('ship-size').value = preset.settings.size;
        document.getElementById('ship-complexity').value = preset.settings.complexity;
        document.getElementById('ship-complexity-value').textContent = preset.settings.complexity;
        document.getElementById('ship-faction').value = preset.settings.faction;
        document.getElementById('ship-symmetry').value = preset.settings.symmetry;
        document.getElementById('ship-weapons').checked = preset.settings.weapons;
        document.getElementById('ship-engines').checked = preset.settings.engines;

        // Apply palette
        if (preset.palette) {
            colorPalette.setPalette(preset.palette);
        }

        alert(`Preset "${name}" loaded!`);
    }

    deletePreset(name) {
        if (!confirm(`Delete preset "${name}"?`)) return;

        const presets = this.loadPreets();
        delete presets[name];
        localStorage.setItem('pixel-art-presets', JSON.stringify(presets));
        this.loadPresetsUI();
    }

    loadSettings() {
        // Load from localStorage
        const settings = localStorage.getItem('pixel-art-settings');
        if (settings) {
            try {
                const data = JSON.parse(settings);
                this.zoom = data.zoom || 8;
                this.showGrid = data.showGrid !== false;
                this.updateZoomLevel();
            } catch (e) {
                console.error('Failed to load settings:', e);
            }
        }
    }

    saveSettings() {
        const settings = {
            zoom: this.zoom,
            showGrid: this.showGrid
        };
        localStorage.setItem('pixel-art-settings', JSON.stringify(settings));
    }

    // Utility: Seeded random number generator
    createSeededRandom(seed) {
        let state = seed;
        return function() {
            state = (state * 9301 + 49297) % 233280;
            return state / 233280;
        };
    }

    // Utility: Hash string to number
    hashCode(str) {
        let hash = 0;
        for (let i = 0; i < str.length; i++) {
            const char = str.charCodeAt(i);
            hash = ((hash << 5) - hash) + char;
            hash = hash & hash;
        }
        return Math.abs(hash);
    }

    switchGenerator(type) {
        // Hide all generator controls
        document.querySelectorAll('.generator-controls').forEach(el => {
            el.style.display = 'none';
        });

        // Hide/show canvas or audio visualization
        const canvasWrapper = document.getElementById('canvas-wrapper');
        const audioViz = document.getElementById('audio-visualization');

        if (type === 'sfx') {
            // SFX mode: hide canvas, show audio visualization
            if (canvasWrapper) canvasWrapper.style.display = 'none';
            if (audioViz) audioViz.style.display = 'block';

            // Show SFX controls
            const sfxControls = document.getElementById('sfx-controls');
            if (sfxControls) sfxControls.style.display = 'block';

        } else {
            // Visual modes: show canvas, hide audio
            if (canvasWrapper) canvasWrapper.style.display = 'block';
            if (audioViz) audioViz.style.display = 'none';

            // Show respective controls
            const controlsId = `${type}-controls`;
            const controls = document.getElementById(controlsId);
            if (controls) controls.style.display = 'block';
        }
    }
}

// Initialize app when DOM is ready
let app;
document.addEventListener('DOMContentLoaded', () => {
    app = new PixelArtGenerator();

    // Save settings before page unload
    window.addEventListener('beforeunload', () => {
        app.saveSettings();
    });
});
