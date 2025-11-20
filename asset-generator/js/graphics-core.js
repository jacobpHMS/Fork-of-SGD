// ============================================================================
// GRAPHICS-CORE.JS - Main Graphics Generator Controller
// SpaceGameDev - Complete Graphics Generation System
// ============================================================================

class GraphicsController {
    constructor() {
        this.canvas = document.getElementById('main-canvas');
        this.ctx = this.canvas.getContext('2d', { willReadFrequently: true });
        this.gridCanvas = document.getElementById('grid-canvas');
        this.gridCtx = this.gridCanvas.getContext('2d');
        this.previewCanvas = document.getElementById('preview-canvas');
        this.previewCtx = this.previewCanvas.getContext('2d');

        this.currentGenerator = 'ship';
        this.currentPixelData = null;
        this.currentSize = 32;
        this.zoomLevel = 8;
        this.panOffset = { x: 0, y: 0 };
        this.isPanning = false;
        this.panStart = { x: 0, y: 0 };
        this.showGlow = false;
        this.generatedCount = 0;

        // Batch storage
        this.batchAssets = [];

        // Database counters
        this.dbCounters = {
            SHIP: 1,
            ASTEROID: 1,
            PROJECTILE: 1,
            EFFECT: 1,
            ICON: 1,
            UI: 1
        };

        // Color picker
        this.colorPicker = null;

        this.init();
    }

    init() {
        this.setupCanvas();
        this.setupEventListeners();
        this.setupColorPicker();
        this.initializePalette();
        this.drawGrid();
    }

    setupCanvas() {
        this.canvas.width = 800;
        this.canvas.height = 600;
        this.gridCanvas.width = 800;
        this.gridCanvas.height = 600;
        this.previewCanvas.width = 128;
        this.previewCanvas.height = 128;

        // Enable smooth scaling
        this.ctx.imageSmoothingEnabled = false;
        this.previewCtx.imageSmoothingEnabled = false;
    }

    setupEventListeners() {
        // Generator switcher
        document.querySelectorAll('[data-generator]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.switchGenerator(e.target.dataset.generator);
                document.querySelectorAll('[data-generator]').forEach(b => b.classList.remove('active', 'btn-primary'));
                e.target.classList.add('active', 'btn-primary');
            });
        });

        // Generate buttons
        document.getElementById('ship-generate-btn')?.addEventListener('click', () => this.generateShip());
        document.getElementById('asteroid-generate-btn')?.addEventListener('click', () => this.generateAsteroid());
        document.getElementById('projectile-generate-btn')?.addEventListener('click', () => this.generateProjectile());
        document.getElementById('effect-generate-btn')?.addEventListener('click', () => this.generateEffect());
        document.getElementById('background-generate-btn')?.addEventListener('click', () => this.generateBackground());

        // Zoom controls
        document.getElementById('zoom-in').addEventListener('click', () => this.zoom(1));
        document.getElementById('zoom-out').addEventListener('click', () => this.zoom(-1));
        document.getElementById('center-view').addEventListener('click', () => this.centerView());

        // Pan mode
        const panModeBtn = document.getElementById('pan-mode');
        panModeBtn.addEventListener('click', () => {
            panModeBtn.classList.toggle('active');
        });

        // Canvas pan functionality
        this.canvas.addEventListener('mousedown', (e) => this.startPan(e));
        this.canvas.addEventListener('mousemove', (e) => this.doPan(e));
        this.canvas.addEventListener('mouseup', () => this.endPan());
        this.canvas.addEventListener('mouseleave', () => this.endPan());
        this.canvas.addEventListener('wheel', (e) => this.handleWheel(e));

        // Glow toggle
        document.getElementById('show-glow')?.addEventListener('change', (e) => {
            this.showGlow = e.target.checked;
            this.redraw();
        });

        // Grid toggle
        document.getElementById('toggle-grid').addEventListener('click', () => {
            this.gridCanvas.style.display = this.gridCanvas.style.display === 'none' ? 'block' : 'none';
        });

        // Palette presets
        document.querySelectorAll('[data-palette]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.loadPalettePreset(e.target.dataset.palette);
            });
        });

        document.getElementById('add-color-btn').addEventListener('click', () => {
            if (this.colorPicker) {
                this.colorPicker.show();
            }
        });

        document.getElementById('randomize-palette-btn').addEventListener('click', () => {
            this.randomizePalette();
        });

        // Database integration
        document.getElementById('generate-db-names-btn').addEventListener('click', () => {
            this.generateDatabaseNames();
        });

        // Export
        document.getElementById('export-btn').addEventListener('click', () => {
            this.exportAsset();
        });

        document.getElementById('export-with-meta-btn').addEventListener('click', () => {
            this.exportWithMetadata();
        });

        // Batch generation
        document.getElementById('batch-generate-btn').addEventListener('click', () => {
            this.batchGenerate();
        });

        document.getElementById('batch-export-btn').addEventListener('click', () => {
            this.batchExport();
        });

        // Value displays
        this.setupValueDisplay('ship-complexity');
        this.setupValueDisplay('asteroid-roughness');
        this.setupValueDisplay('effect-frames');
        this.setupValueDisplay('background-density');
        this.setupValueDisplay('batch-variation');

        // Auto-update database names
        ['db-asset-type', 'db-variant', 'db-size-cat', 'db-state'].forEach(id => {
            document.getElementById(id)?.addEventListener('change', () => {
                this.generateDatabaseNames();
            });
            document.getElementById(id)?.addEventListener('input', () => {
                this.generateDatabaseNames();
            });
        });
    }

    setupValueDisplay(id) {
        const slider = document.getElementById(id);
        const valueSpan = document.getElementById(`${id}-value`);
        if (slider && valueSpan) {
            slider.addEventListener('input', (e) => {
                valueSpan.textContent = e.target.value;
            });
        }
    }

    setupColorPicker() {
        const container = document.getElementById('color-picker-container');
        this.colorPicker = Pickr.create({
            el: container,
            theme: 'nano',
            default: '#3498db',
            swatches: [
                '#FF0000', '#00FF00', '#0000FF',
                '#FFFF00', '#FF00FF', '#00FFFF',
                '#FFFFFF', '#000000', '#808080'
            ],
            components: {
                preview: true,
                hue: true,
                interaction: {
                    hex: true,
                    input: true,
                    save: true
                }
            }
        });

        this.colorPicker.on('save', (color) => {
            if (color) {
                this.addColorToPalette(color.toHEXA().toString());
                this.colorPicker.hide();
            }
        });
    }

    initializePalette() {
        this.loadPalettePreset('cyber');
    }

    loadPalettePreset(presetName) {
        const presets = {
            cyber: ['#0D1B2A', '#1B263B', '#415A77', '#778DA9', '#E0E1DD', '#3498db'],
            military: ['#2D4A2B', '#405D3F', '#567D4E', '#6B8F6C', '#9BB89E', '#95C793'],
            pirate: ['#4A0E0E', '#7A1F1F', '#A83232', '#D94545', '#FF6B6B', '#FFB84D'],
            trader: ['#2C3E50', '#34495E', '#7F8C8D', '#BDC3C7', '#ECF0F1', '#FFFFFF'],
            alien: ['#1A0033', '#2D0066', '#4A0099', '#6B00CC', '#8F00FF', '#B84DFF'],
            mining: ['#4A2B0F', '#6B3D15', '#8C4F1B', '#B36B2A', '#FF8C42', '#FFB84D'],
            police: ['#000000', '#1A1A1A', '#333333', '#4D4D4D', '#0066CC', '#3399FF'],
            medical: ['#FFFFFF', '#F2F2F2', '#E6E6E6', '#FF3333', '#CC0000', '#990000'],
            fire: ['#4A0000', '#8C0000', '#CC0000', '#FF3333', '#FF6B4D', '#FFB84D'],
            ice: ['#003D5C', '#006699', '#0099CC', '#33CCFF', '#99EEFF', '#CCFFFF'],
            toxic: ['#1A4D1A', '#2D7A2D', '#40A640', '#66CC66', '#99FF99', '#CCFFCC'],
            energy: ['#330066', '#6600CC', '#9933FF', '#CC66FF', '#FF99FF', '#FFCCFF']
        };

        const colors = presets[presetName] || presets.cyber;
        this.updatePalette(colors);
    }

    updatePalette(colors) {
        const paletteDiv = document.getElementById('color-palette');
        paletteDiv.innerHTML = '';

        colors.forEach((color, index) => {
            const swatch = document.createElement('div');
            swatch.className = 'color-swatch';
            swatch.style.background = color;
            swatch.title = color;
            swatch.dataset.color = color;

            // Click to edit
            swatch.addEventListener('click', () => {
                if (this.colorPicker) {
                    this.colorPicker.setColor(color);
                    this.colorPicker.show();
                }
            });

            paletteDiv.appendChild(swatch);
        });

        // Update stats
        document.getElementById('stat-colors').textContent = colors.length;
    }

    addColorToPalette(color) {
        const paletteDiv = document.getElementById('color-palette');
        const swatch = document.createElement('div');
        swatch.className = 'color-swatch';
        swatch.style.background = color;
        swatch.title = color;
        swatch.dataset.color = color;

        swatch.addEventListener('click', () => {
            if (this.colorPicker) {
                this.colorPicker.setColor(color);
                this.colorPicker.show();
            }
        });

        paletteDiv.appendChild(swatch);

        const colorCount = paletteDiv.children.length;
        document.getElementById('stat-colors').textContent = colorCount;
    }

    randomizePalette() {
        const count = 6;
        const colors = [];

        for (let i = 0; i < count; i++) {
            const h = Math.floor(Math.random() * 360);
            const s = 50 + Math.floor(Math.random() * 50);
            const l = 30 + Math.floor(Math.random() * 40);
            colors.push(`hsl(${h}, ${s}%, ${l}%)`);
        }

        this.updatePalette(colors);
    }

    getCurrentPalette() {
        const swatches = document.querySelectorAll('.color-swatch');
        return Array.from(swatches).map(s => s.dataset.color);
    }

    switchGenerator(type) {
        this.currentGenerator = type;

        // Hide all control panels
        document.querySelectorAll('.generator-controls').forEach(el => {
            el.style.display = 'none';
        });

        // Show selected panel
        const panelId = `${type}-controls`;
        const panel = document.getElementById(panelId);
        if (panel) {
            panel.style.display = 'block';
        }

        // Update database asset type
        const dbTypeSelect = document.getElementById('db-asset-type');
        if (dbTypeSelect) {
            dbTypeSelect.value = type.toUpperCase();
            this.generateDatabaseNames();
        }
    }

    generateShip() {
        const size = parseInt(document.getElementById('ship-size').value);
        const complexity = parseInt(document.getElementById('ship-complexity').value);
        const faction = document.getElementById('ship-faction').value;
        const symmetry = document.getElementById('ship-symmetry').value;
        const weapons = document.getElementById('ship-weapons').checked;
        const engines = document.getElementById('ship-engines').checked;
        const palette = this.getCurrentPalette();

        this.currentSize = size;
        this.currentPixelData = generateShip({
            size,
            complexity,
            faction,
            symmetry,
            weapons,
            engines,
            palette
        });

        this.generatedCount++;
        this.updateStats();
        this.drawPixelData();
        this.drawPreview();
    }

    generateAsteroid() {
        const size = parseInt(document.getElementById('asteroid-size').value);
        const oreType = document.getElementById('asteroid-ore').value;
        const roughness = parseFloat(document.getElementById('asteroid-roughness').value);
        const craters = document.getElementById('asteroid-craters').checked;
        const palette = this.getCurrentPalette();

        this.currentSize = size;
        this.currentPixelData = generateAsteroid({
            size,
            oreType,
            roughness,
            craters,
            palette
        });

        this.generatedCount++;
        this.updateStats();
        this.drawPixelData();
        this.drawPreview();
    }

    generateProjectile() {
        const type = document.getElementById('projectile-type').value;
        const size = parseInt(document.getElementById('projectile-size').value);
        const glow = document.getElementById('projectile-glow').checked;
        const palette = this.getCurrentPalette();

        this.currentSize = size;
        this.currentPixelData = generateProjectile({
            type,
            size,
            glow,
            palette
        });

        this.generatedCount++;
        this.updateStats();
        this.drawPixelData();
        this.drawPreview();
    }

    generateEffect() {
        const type = document.getElementById('effect-type').value;
        const size = parseInt(document.getElementById('effect-size').value);
        const frames = parseInt(document.getElementById('effect-frames').value);
        const palette = this.getCurrentPalette();

        this.currentSize = size;
        this.currentPixelData = generateEffect({
            type,
            size,
            frames,
            palette
        });

        this.generatedCount++;
        this.updateStats();
        this.drawPixelData();
        this.drawPreview();
    }

    generateBackground() {
        const type = document.getElementById('background-type').value;
        const size = parseInt(document.getElementById('background-size').value);
        const density = parseFloat(document.getElementById('background-density').value);
        const palette = this.getCurrentPalette();

        this.currentSize = size;
        this.currentPixelData = generateBackground({
            type,
            size,
            density,
            palette
        });

        this.generatedCount++;
        this.updateStats();
        this.drawPixelData();
        this.drawPreview();
    }

    drawPixelData() {
        if (!this.currentPixelData) return;

        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

        const centerX = this.canvas.width / 2 + this.panOffset.x;
        const centerY = this.canvas.height / 2 + this.panOffset.y;
        const startX = centerX - (this.currentSize * this.zoomLevel) / 2;
        const startY = centerY - (this.currentSize * this.zoomLevel) / 2;

        for (let y = 0; y < this.currentSize; y++) {
            for (let x = 0; x < this.currentSize; x++) {
                const index = y * this.currentSize + x;
                const color = this.currentPixelData[index];

                if (color) {
                    this.ctx.fillStyle = color;
                    this.ctx.fillRect(
                        startX + x * this.zoomLevel,
                        startY + y * this.zoomLevel,
                        this.zoomLevel,
                        this.zoomLevel
                    );

                    // Apply glow if enabled
                    if (this.showGlow && color.includes('ff')) {
                        this.ctx.shadowBlur = 10;
                        this.ctx.shadowColor = color;
                        this.ctx.fillRect(
                            startX + x * this.zoomLevel,
                            startY + y * this.zoomLevel,
                            this.zoomLevel,
                            this.zoomLevel
                        );
                        this.ctx.shadowBlur = 0;
                    }
                }
            }
        }
    }

    drawPreview() {
        if (!this.currentPixelData) return;

        this.previewCtx.clearRect(0, 0, this.previewCanvas.width, this.previewCanvas.height);

        const scale = Math.min(128 / this.currentSize, 128 / this.currentSize);
        const offsetX = (128 - this.currentSize * scale) / 2;
        const offsetY = (128 - this.currentSize * scale) / 2;

        for (let y = 0; y < this.currentSize; y++) {
            for (let x = 0; x < this.currentSize; x++) {
                const index = y * this.currentSize + x;
                const color = this.currentPixelData[index];

                if (color) {
                    this.previewCtx.fillStyle = color;
                    this.previewCtx.fillRect(
                        offsetX + x * scale,
                        offsetY + y * scale,
                        scale,
                        scale
                    );
                }
            }
        }
    }

    drawGrid() {
        this.gridCtx.clearRect(0, 0, this.gridCanvas.width, this.gridCanvas.height);
        this.gridCtx.strokeStyle = '#333';
        this.gridCtx.lineWidth = 1;

        const centerX = this.gridCanvas.width / 2 + this.panOffset.x;
        const centerY = this.gridCanvas.height / 2 + this.panOffset.y;
        const startX = centerX - (this.currentSize * this.zoomLevel) / 2;
        const startY = centerY - (this.currentSize * this.zoomLevel) / 2;

        for (let i = 0; i <= this.currentSize; i++) {
            this.gridCtx.beginPath();
            this.gridCtx.moveTo(startX + i * this.zoomLevel, startY);
            this.gridCtx.lineTo(startX + i * this.zoomLevel, startY + this.currentSize * this.zoomLevel);
            this.gridCtx.stroke();

            this.gridCtx.beginPath();
            this.gridCtx.moveTo(startX, startY + i * this.zoomLevel);
            this.gridCtx.lineTo(startX + this.currentSize * this.zoomLevel, startY + i * this.zoomLevel);
            this.gridCtx.stroke();
        }
    }

    redraw() {
        this.drawPixelData();
        this.drawGrid();
    }

    zoom(direction) {
        const oldZoom = this.zoomLevel;
        this.zoomLevel = Math.max(1, Math.min(32, this.zoomLevel + direction * 2));
        document.getElementById('zoom-level').textContent = `${this.zoomLevel}x`;

        if (oldZoom !== this.zoomLevel) {
            this.redraw();
        }
    }

    handleWheel(e) {
        e.preventDefault();
        this.zoom(e.deltaY > 0 ? -1 : 1);
    }

    centerView() {
        this.panOffset = { x: 0, y: 0 };
        this.redraw();
    }

    startPan(e) {
        const panMode = document.getElementById('pan-mode').classList.contains('active');
        if (panMode || e.button === 1) { // Middle mouse button
            this.isPanning = true;
            this.panStart = { x: e.clientX - this.panOffset.x, y: e.clientY - this.panOffset.y };
            this.canvas.style.cursor = 'grabbing';
        }
    }

    doPan(e) {
        if (this.isPanning) {
            this.panOffset.x = e.clientX - this.panStart.x;
            this.panOffset.y = e.clientY - this.panStart.y;
            this.redraw();
        }
    }

    endPan() {
        if (this.isPanning) {
            this.isPanning = false;
            this.canvas.style.cursor = 'default';
        }
    }

    updateStats() {
        document.getElementById('stat-size').textContent = `${this.currentSize}x${this.currentSize}`;

        if (this.currentPixelData) {
            const pixelCount = this.currentPixelData.filter(p => p !== null).length;
            document.getElementById('stat-pixels').textContent = pixelCount;
        }

        document.getElementById('stat-generated').textContent = this.generatedCount;
    }

    generateDatabaseNames() {
        const assetType = document.getElementById('db-asset-type').value.toLowerCase();
        const variant = document.getElementById('db-variant').value || 'default';
        const sizeCat = document.getElementById('db-size-cat').value;
        const state = document.getElementById('db-state').value;

        // ASSET_MANAGEMENT_SYSTEM.md naming: {type}_{variant}_{size}_{number}
        const counter = this.dbCounters[assetType.toUpperCase()] || 1;
        const paddedCounter = String(counter).padStart(2, '0');

        let filename = '';
        if (assetType === 'ship') {
            filename = `ship_${variant}_${state}`;
        } else if (assetType === 'asteroid') {
            filename = `asteroid_${variant}_${sizeCat}_${paddedCounter}`;
        } else if (assetType === 'projectile') {
            filename = `projectile_${variant}_${paddedCounter}`;
        } else if (assetType === 'effect') {
            filename = `anim_${variant}_spritesheet`;
        } else {
            filename = `${assetType}_${variant}_${sizeCat}_${paddedCounter}`;
        }

        document.getElementById('db-auto-filename').value = filename;
        document.getElementById('export-filename').value = filename;

        // ItemDatabase.gd naming: {CATEGORY}_T{TIER}_{NUMBER}
        const itemCategory = this.getItemCategory(assetType, variant);
        const tier = sizeCat === 'small' ? 1 : sizeCat === 'medium' ? 2 : 3;
        const itemCounter = this.dbCounters[assetType.toUpperCase()] || 1;
        const itemID = `${itemCategory}_T${tier}_${String(itemCounter).padStart(3, '0')}`;

        document.getElementById('db-item-id').value = itemID;
    }

    getItemCategory(assetType, variant) {
        const categoryMap = {
            ship: 'SHIP',
            asteroid: 'ORE',
            projectile: 'AMMO',
            effect: 'VFX',
            icon: 'ICON',
            ui: 'UI'
        };

        return categoryMap[assetType] || 'ITEM';
    }

    exportAsset() {
        if (!this.currentPixelData) {
            alert('Erst Asset generieren!');
            return;
        }

        const filename = document.getElementById('export-filename').value || 'asset';
        const format = document.getElementById('export-format').value;

        if (format === 'png') {
            this.exportPNG(filename);
        } else if (format === 'json') {
            this.exportJSON(filename);
        }

        // Increment counter
        const assetType = document.getElementById('db-asset-type').value;
        this.dbCounters[assetType]++;
        this.generateDatabaseNames();
    }

    exportPNG(filename) {
        // Create temporary canvas with actual size
        const tempCanvas = document.createElement('canvas');
        tempCanvas.width = this.currentSize;
        tempCanvas.height = this.currentSize;
        const tempCtx = tempCanvas.getContext('2d');

        // Draw pixel data
        for (let y = 0; y < this.currentSize; y++) {
            for (let x = 0; x < this.currentSize; x++) {
                const index = y * this.currentSize + x;
                const color = this.currentPixelData[index];

                if (color) {
                    tempCtx.fillStyle = color;
                    tempCtx.fillRect(x, y, 1, 1);
                }
            }
        }

        // Download
        tempCanvas.toBlob(blob => {
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `${filename}.png`;
            a.click();
            URL.revokeObjectURL(url);
        });
    }

    exportJSON(filename) {
        const assetType = document.getElementById('db-asset-type').value;
        const variant = document.getElementById('db-variant').value;
        const sizeCat = document.getElementById('db-size-cat').value;
        const itemID = document.getElementById('db-item-id').value;

        const metadata = {
            id: itemID,
            filename: filename,
            type: assetType,
            variant: variant,
            size: `${this.currentSize}x${this.currentSize}`,
            sizeCategory: sizeCat,
            palette: this.getCurrentPalette(),
            pixelCount: this.currentPixelData.filter(p => p !== null).length,
            timestamp: new Date().toISOString()
        };

        const json = JSON.stringify(metadata, null, 2);
        const blob = new Blob([json], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `${filename}_meta.json`;
        a.click();
        URL.revokeObjectURL(url);
    }

    exportWithMetadata() {
        this.exportPNG(document.getElementById('export-filename').value);
        this.exportJSON(document.getElementById('export-filename').value);
    }

    batchGenerate() {
        const count = parseInt(document.getElementById('batch-count').value);
        const variation = parseFloat(document.getElementById('batch-variation').value);

        this.batchAssets = [];

        for (let i = 0; i < count; i++) {
            // Generate with slight variations
            switch (this.currentGenerator) {
                case 'ship':
                    this.generateShip();
                    break;
                case 'asteroid':
                    this.generateAsteroid();
                    break;
                case 'projectile':
                    this.generateProjectile();
                    break;
                case 'effect':
                    this.generateEffect();
                    break;
                case 'background':
                    this.generateBackground();
                    break;
            }

            // Store
            this.batchAssets.push({
                pixelData: [...this.currentPixelData],
                size: this.currentSize
            });
        }

        alert(`${count} Assets generiert! Nutze "Export All" zum Download.`);
    }

    batchExport() {
        if (this.batchAssets.length === 0) {
            alert('Erst Batch generieren!');
            return;
        }

        this.batchAssets.forEach((asset, index) => {
            this.currentPixelData = asset.pixelData;
            this.currentSize = asset.size;

            const baseFilename = document.getElementById('export-filename').value || 'asset';
            const filename = `${baseFilename}_${String(index + 1).padStart(3, '0')}`;

            this.exportPNG(filename);
        });

        alert(`${this.batchAssets.length} Assets exportiert!`);
        this.batchAssets = [];
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    window.graphicsController = new GraphicsController();
});
