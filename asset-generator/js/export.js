// ============================================================================
// EXPORT.JS - Asset Export System
// SpaceGameDev - Procedural Pixel Art Asset Generator
// ============================================================================

class ExportManager {
    constructor() {
        // Export formats
        this.formats = {
            PNG: 'png',
            SPRITESHEET: 'spritesheet',
            ZIP: 'zip'
        };
    }

    /**
     * Export pixel data as PNG
     * @param {Array} pixelData - Pixel color array
     * @param {number} size - Canvas size
     * @param {string} filename - Output filename
     */
    exportPNG(pixelData, size, filename = 'asset') {
        // Create temporary canvas
        const canvas = document.createElement('canvas');
        canvas.width = size;
        canvas.height = size;
        const ctx = canvas.getContext('2d', { alpha: true });

        // Disable smoothing for pixel-perfect export
        ctx.imageSmoothingEnabled = false;

        // Draw pixels
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const idx = y * size + x;
                const color = pixelData[idx];

                if (color) {
                    ctx.fillStyle = color;
                    ctx.fillRect(x, y, 1, 1);
                }
            }
        }

        // Convert to blob and download
        canvas.toBlob((blob) => {
            this.downloadBlob(blob, `${filename}.png`);
        }, 'image/png');

        console.log(`✅ Exported ${filename}.png (${size}x${size})`);
    }

    /**
     * Export as sprite sheet (multiple frames)
     * @param {Array} frames - Array of pixel data arrays
     * @param {number} size - Individual frame size
     * @param {string} filename - Output filename
     * @param {Object} options - Grid layout options
     */
    exportSpriteSheet(frames, size, filename = 'spritesheet', options = {}) {
        const {
            columns = 4,
            padding = 0,
            backgroundColor = null
        } = options;

        const frameCount = frames.length;
        const rows = Math.ceil(frameCount / columns);

        const sheetWidth = columns * size + (columns - 1) * padding;
        const sheetHeight = rows * size + (rows - 1) * padding;

        // Create canvas
        const canvas = document.createElement('canvas');
        canvas.width = sheetWidth;
        canvas.height = sheetHeight;
        const ctx = canvas.getContext('2d', { alpha: true });
        ctx.imageSmoothingEnabled = false;

        // Fill background if specified
        if (backgroundColor) {
            ctx.fillStyle = backgroundColor;
            ctx.fillRect(0, 0, sheetWidth, sheetHeight);
        }

        // Draw each frame
        frames.forEach((pixelData, frameIndex) => {
            const col = frameIndex % columns;
            const row = Math.floor(frameIndex / columns);

            const offsetX = col * (size + padding);
            const offsetY = row * (size + padding);

            for (let y = 0; y < size; y++) {
                for (let x = 0; x < size; x++) {
                    const idx = y * size + x;
                    const color = pixelData[idx];

                    if (color) {
                        ctx.fillStyle = color;
                        ctx.fillRect(offsetX + x, offsetY + y, 1, 1);
                    }
                }
            }
        });

        // Export metadata
        const metadata = {
            frameCount: frameCount,
            frameSize: size,
            columns: columns,
            rows: rows,
            sheetSize: { width: sheetWidth, height: sheetHeight },
            padding: padding
        };

        // Download sprite sheet
        canvas.toBlob((blob) => {
            this.downloadBlob(blob, `${filename}.png`);
        }, 'image/png');

        // Download metadata JSON
        const metadataBlob = new Blob([JSON.stringify(metadata, null, 2)], {
            type: 'application/json'
        });
        this.downloadBlob(metadataBlob, `${filename}.json`);

        console.log(`✅ Exported sprite sheet: ${filename}.png (${sheetWidth}x${sheetHeight})`);
    }

    /**
     * Export multiple assets as ZIP
     * @param {Array} assets - Array of {pixelData, size, filename}
     * @param {string} zipFilename - Output ZIP filename
     */
    async exportZIP(assets, zipFilename = 'assets') {
        // Note: For ZIP export, we'd need a library like JSZip
        // For now, export each asset individually
        console.log('⚠️ ZIP export not yet implemented - exporting individually');

        assets.forEach((asset, index) => {
            const name = asset.filename || `asset_${index}`;
            this.exportPNG(asset.pixelData, asset.size, name);
        });
    }

    /**
     * Download a blob as a file
     * @param {Blob} blob - Data blob
     * @param {string} filename - Download filename
     */
    downloadBlob(blob, filename) {
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.download = filename;
        link.style.display = 'none';

        document.body.appendChild(link);
        link.click();

        // Cleanup
        setTimeout(() => {
            document.body.removeChild(link);
            URL.revokeObjectURL(url);
        }, 100);
    }

    /**
     * Copy pixel data to clipboard as data URL
     * @param {Array} pixelData - Pixel color array
     * @param {number} size - Canvas size
     */
    async copyToClipboard(pixelData, size) {
        const canvas = document.createElement('canvas');
        canvas.width = size;
        canvas.height = size;
        const ctx = canvas.getContext('2d', { alpha: true });
        ctx.imageSmoothingEnabled = false;

        // Draw pixels
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const idx = y * size + x;
                const color = pixelData[idx];

                if (color) {
                    ctx.fillStyle = color;
                    ctx.fillRect(x, y, 1, 1);
                }
            }
        }

        // Convert to blob
        canvas.toBlob(async (blob) => {
            try {
                await navigator.clipboard.write([
                    new ClipboardItem({ 'image/png': blob })
                ]);
                console.log('✅ Copied to clipboard');
                alert('Image copied to clipboard!');
            } catch (err) {
                console.error('Failed to copy:', err);
                alert('Failed to copy to clipboard');
            }
        }, 'image/png');
    }

    /**
     * Generate metadata JSON for asset
     * @param {Object} assetInfo - Asset information
     * @returns {string} JSON string
     */
    generateMetadata(assetInfo) {
        const metadata = {
            version: '1.0',
            generator: 'SpaceGameDev Procedural Asset Generator',
            timestamp: new Date().toISOString(),
            asset: {
                type: assetInfo.type || 'ship',
                size: assetInfo.size || 32,
                palette: assetInfo.palette || [],
                settings: assetInfo.settings || {},
                pixelCount: assetInfo.pixelCount || 0,
                colorCount: assetInfo.colorCount || 0
            }
        };

        return JSON.stringify(metadata, null, 2);
    }

    /**
     * Export with metadata
     * @param {Array} pixelData - Pixel data
     * @param {number} size - Size
     * @param {string} filename - Filename
     * @param {Object} metadata - Metadata object
     */
    exportWithMetadata(pixelData, size, filename, metadata) {
        // Export PNG
        this.exportPNG(pixelData, size, filename);

        // Export metadata JSON
        const metadataJSON = this.generateMetadata(metadata);
        const blob = new Blob([metadataJSON], { type: 'application/json' });
        this.downloadBlob(blob, `${filename}_metadata.json`);
    }
}

// Initialize export manager
let exportManager;
document.addEventListener('DOMContentLoaded', () => {
    exportManager = new ExportManager();
});
