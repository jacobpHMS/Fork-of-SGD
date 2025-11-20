// ============================================================================
// PALETTE.JS - Color Palette Management System
// SpaceGameDev - Procedural Pixel Art Asset Generator
// ============================================================================

class ColorPaletteManager {
    constructor() {
        this.colors = [];
        this.presets = {
            cyber: ['#001F3F', '#0074D9', '#00D9FF', '#FFFFFF', '#39CCCC', '#001a33'],
            military: ['#1A2910', '#4A5D23', '#7CB342', '#C5E1A5', '#2E3B1F', '#8BC34A'],
            pirate: ['#1A0A0A', '#660000', '#FF3366', '#FFA500', '#330000', '#CC0000'],
            trader: ['#F5F5F5', '#E0E0E0', '#0080FF', '#FFD700', '#BDBDBD', '#FFFFFF']
        };

        this.init();
    }

    init() {
        this.loadPalette('cyber');
        this.setupEventListeners();
        this.renderPalette();
    }

    setupEventListeners() {
        // Preset buttons
        document.querySelectorAll('[data-palette]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const preset = e.target.dataset.palette;
                this.loadPalette(preset);
                this.renderPalette();
            });
        });

        // Add color button
        document.getElementById('add-color-btn').addEventListener('click', () => {
            this.addColor('#FFFFFF');
        });
    }

    loadPalette(presetName) {
        if (this.presets[presetName]) {
            this.colors = [...this.presets[presetName]];
        }
    }

    setPalette(colors) {
        this.colors = [...colors];
        this.renderPalette();
    }

    getCurrentPalette() {
        return [...this.colors];
    }

    addColor(color = '#FFFFFF') {
        this.colors.push(color);
        this.renderPalette();
    }

    removeColor(index) {
        if (this.colors.length > 2) {
            this.colors.splice(index, 1);
            this.renderPalette();
        } else {
            alert('Palette must have at least 2 colors');
        }
    }

    updateColor(index, color) {
        this.colors[index] = color;
        this.renderPalette();
    }

    renderPalette() {
        const container = document.getElementById('color-palette');
        container.innerHTML = '';

        this.colors.forEach((color, index) => {
            const swatch = document.createElement('div');
            swatch.className = 'color-swatch';
            swatch.innerHTML = `
                <div class="color-swatch-inner" style="background-color: ${color}"></div>
                <button class="color-swatch-remove" onclick="colorPalette.removeColor(${index})">×</button>
            `;

            // Click to edit color
            swatch.addEventListener('click', (e) => {
                if (!e.target.classList.contains('color-swatch-remove')) {
                    const newColor = prompt('Enter hex color:', color);
                    if (newColor && /^#[0-9A-F]{6}$/i.test(newColor)) {
                        this.updateColor(index, newColor);
                    }
                }
            });

            container.appendChild(swatch);
        });
    }

    getRandomColor() {
        return this.colors[Math.floor(Math.random() * this.colors.length)];
    }

    getColorByIndex(index) {
        return this.colors[index % this.colors.length];
    }
}

// Initialize color palette manager
let colorPalette;
document.addEventListener('DOMContentLoaded', () => {
    colorPalette = new ColorPaletteManager();
});
