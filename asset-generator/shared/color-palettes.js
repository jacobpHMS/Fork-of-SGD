/* ============================================================
   COLOR PALETTE SYSTEM
   12 Preset Palettes + Custom Color Support
   ============================================================ */

const COLOR_PALETTES = {
    cyber_blue: {
        name: "Cyber Blue",
        primary: "#00F0FF",
        secondary: "#0080FF",
        accent: "#00FFAA",
        dark: "#001020",
        description: "Futuristic cyber aesthetic"
    },

    military_green: {
        name: "Military Green",
        primary: "#4A7C3C",
        secondary: "#2E5A28",
        accent: "#7FA972",
        dark: "#1A2A1A",
        description: "Military and tactical vibes"
    },

    pirate_red: {
        name: "Pirate Red",
        primary: "#C0302C",
        secondary: "#8B1E1E",
        accent: "#FF6B5A",
        dark: "#200808",
        description: "Aggressive pirate faction"
    },

    trader_white: {
        name: "Trader White",
        primary: "#E8E8E8",
        secondary: "#B0B0B0",
        accent: "#FFFFFF",
        dark: "#2A2A2A",
        description: "Clean trader vessels"
    },

    alien_purple: {
        name: "Alien Purple",
        primary: "#9B59B6",
        secondary: "#6A3A7C",
        accent: "#D291FF",
        dark: "#1A0A2A",
        description: "Mysterious alien technology"
    },

    mining_orange: {
        name: "Mining Orange",
        primary: "#E67E22",
        secondary: "#D35400",
        accent: "#FFA94D",
        dark: "#2A1A0A",
        description: "Industrial mining equipment"
    },

    police_black: {
        name: "Police Black",
        primary: "#2C3E50",
        secondary: "#1A252F",
        accent: "#3498DB",
        dark: "#0A0F14",
        description: "Law enforcement fleet"
    },

    medical_white: {
        name: "Medical White",
        primary: "#ECF0F1",
        secondary: "#BDC3C7",
        accent: "#E74C3C",
        dark: "#2C3E50",
        description: "Medical and rescue ships"
    },

    fire: {
        name: "Fire",
        primary: "#FF4500",
        secondary: "#FF8C00",
        accent: "#FFD700",
        dark: "#1A0A00",
        description: "Hot plasma and fire effects"
    },

    ice: {
        name: "Ice",
        primary: "#7FDBFF",
        secondary: "#39CCCC",
        accent: "#B3FFFF",
        dark: "#001A1A",
        description: "Frozen and cryo effects"
    },

    toxic: {
        name: "Toxic",
        primary: "#7FFF00",
        secondary: "#9ACD32",
        accent: "#ADFF2F",
        dark: "#1A2A0A",
        description: "Toxic and biological hazards"
    },

    energy: {
        name: "Energy",
        primary: "#FFD700",
        secondary: "#FFA500",
        accent: "#FFFF00",
        dark: "#2A2000",
        description: "Pure energy manifestation"
    }
};

/* ============================================================
   COLOR PALETTE MANAGER CLASS
   ============================================================ */

class ColorPaletteManager {
    constructor() {
        this.currentPalette = null;
        this.customColors = {
            primary: "#00F0FF",
            secondary: "#0080FF",
            accent: "#00FFAA",
            dark: "#001020"
        };
    }

    /**
     * Apply a preset palette by name
     */
    applyPalette(paletteName) {
        if (!COLOR_PALETTES[paletteName]) {
            console.error(`Palette "${paletteName}" not found`);
            return;
        }

        this.currentPalette = paletteName;
        const palette = COLOR_PALETTES[paletteName];

        // Update custom color pickers
        document.getElementById('color-primary').value = palette.primary;
        document.getElementById('color-secondary').value = palette.secondary;
        document.getElementById('color-accent').value = palette.accent;
        document.getElementById('color-dark').value = palette.dark;

        // Store current colors
        this.customColors = {
            primary: palette.primary,
            secondary: palette.secondary,
            accent: palette.accent,
            dark: palette.dark
        };

        // Update active button state
        this.updateActiveButton(paletteName);

        // Trigger regeneration callback
        if (this.onPaletteChange) {
            this.onPaletteChange(this.getColors());
        }
    }

    /**
     * Apply custom colors from color pickers
     */
    applyCustomColors() {
        this.currentPalette = null; // No preset active

        this.customColors = {
            primary: document.getElementById('color-primary').value,
            secondary: document.getElementById('color-secondary').value,
            accent: document.getElementById('color-accent').value,
            dark: document.getElementById('color-dark').value
        };

        // Remove active state from all palette buttons
        this.updateActiveButton(null);

        // Trigger regeneration callback
        if (this.onPaletteChange) {
            this.onPaletteChange(this.getColors());
        }
    }

    /**
     * Get current color palette
     */
    getColors() {
        if (this.currentPalette) {
            return COLOR_PALETTES[this.currentPalette];
        }
        return this.customColors;
    }

    /**
     * Update active button state in UI
     */
    updateActiveButton(paletteName) {
        document.querySelectorAll('.palette-btn').forEach(btn => {
            if (btn.dataset.palette === paletteName) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });
    }

    /**
     * Initialize event listeners
     */
    initEventListeners(onChangeCallback) {
        this.onPaletteChange = onChangeCallback;

        // Palette preset buttons
        document.querySelectorAll('.palette-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const paletteName = e.target.dataset.palette;
                this.applyPalette(paletteName);
            });
        });

        // Custom color pickers
        document.querySelectorAll('.custom-colors input[type="color"]').forEach(picker => {
            picker.addEventListener('input', () => {
                this.applyCustomColors();
            });
        });
    }

    /**
     * Convert hex color to RGB object
     */
    hexToRgb(hex) {
        const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
        return result ? {
            r: parseInt(result[1], 16),
            g: parseInt(result[2], 16),
            b: parseInt(result[3], 16)
        } : { r: 0, g: 0, b: 0 };
    }

    /**
     * Convert RGB to hex color
     */
    rgbToHex(r, g, b) {
        return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
    }

    /**
     * Interpolate between two colors
     */
    interpolateColors(color1, color2, factor) {
        const c1 = this.hexToRgb(color1);
        const c2 = this.hexToRgb(color2);

        const r = Math.round(c1.r + (c2.r - c1.r) * factor);
        const g = Math.round(c1.g + (c2.g - c1.g) * factor);
        const b = Math.round(c1.b + (c2.b - c1.b) * factor);

        return this.rgbToHex(r, g, b);
    }

    /**
     * Get color with brightness adjustment
     */
    adjustBrightness(color, factor) {
        const rgb = this.hexToRgb(color);
        const r = Math.min(255, Math.round(rgb.r * factor));
        const g = Math.min(255, Math.round(rgb.g * factor));
        const b = Math.min(255, Math.round(rgb.b * factor));
        return this.rgbToHex(r, g, b);
    }
}

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { COLOR_PALETTES, ColorPaletteManager };
}
