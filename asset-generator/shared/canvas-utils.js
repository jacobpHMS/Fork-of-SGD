/* ============================================================
   CANVAS UTILITIES
   Pan, Zoom, Grid Overlay, Export Functions
   ============================================================ */

class CanvasManager {
    constructor(canvasId) {
        this.canvas = document.getElementById(canvasId);
        this.ctx = this.canvas.getContext('2d');

        // Pan & Zoom state
        this.zoom = 8;
        this.offsetX = 0;
        this.offsetY = 0;
        this.isDragging = false;
        this.lastX = 0;
        this.lastY = 0;

        // Grid settings
        this.showGrid = true;
        this.gridSize = 8;

        // Background settings
        this.showBackground = true;

        this.initEventListeners();
    }

    initEventListeners() {
        // Mouse drag for panning
        this.canvas.addEventListener('mousedown', (e) => {
            this.isDragging = true;
            this.lastX = e.clientX;
            this.lastY = e.clientY;
        });

        this.canvas.addEventListener('mousemove', (e) => {
            if (this.isDragging) {
                const deltaX = e.clientX - this.lastX;
                const deltaY = e.clientY - this.lastY;

                this.offsetX += deltaX;
                this.offsetY += deltaY;

                this.lastX = e.clientX;
                this.lastY = e.clientY;

                if (this.onPanChange) {
                    this.onPanChange();
                }
            }
        });

        this.canvas.addEventListener('mouseup', () => {
            this.isDragging = false;
        });

        this.canvas.addEventListener('mouseleave', () => {
            this.isDragging = false;
        });

        // Mouse wheel for zooming
        this.canvas.addEventListener('wheel', (e) => {
            e.preventDefault();

            const delta = e.deltaY > 0 ? -1 : 1;
            this.changeZoom(delta);
        });

        // Zoom controls
        const zoomInBtn = document.getElementById('zoom-in');
        const zoomOutBtn = document.getElementById('zoom-out');
        const resetBtn = document.getElementById('reset-view');
        const centerBtn = document.getElementById('center-view');
        const gridToggle = document.getElementById('toggle-grid');

        if (zoomInBtn) {
            zoomInBtn.addEventListener('click', () => this.changeZoom(1));
        }

        if (zoomOutBtn) {
            zoomOutBtn.addEventListener('click', () => this.changeZoom(-1));
        }

        if (resetBtn) {
            resetBtn.addEventListener('click', () => this.resetView());
        }

        if (centerBtn) {
            centerBtn.addEventListener('click', () => this.centerView());
        }

        if (gridToggle) {
            gridToggle.addEventListener('click', () => this.toggleGrid());
        }

        // Background toggle
        const bgToggle = document.getElementById('show-background');
        if (bgToggle) {
            bgToggle.addEventListener('change', (e) => {
                this.showBackground = e.target.checked;
                if (this.onRender) {
                    this.onRender();
                }
            });
        }

        // Glow effect toggle
        const glowToggle = document.getElementById('show-glow');
        if (glowToggle) {
            glowToggle.addEventListener('change', () => {
                if (this.onRender) {
                    this.onRender();
                }
            });
        }
    }

    changeZoom(delta) {
        const zoomLevels = [1, 2, 4, 8, 16, 32];
        let currentIndex = zoomLevels.indexOf(this.zoom);

        currentIndex += delta;
        currentIndex = Math.max(0, Math.min(zoomLevels.length - 1, currentIndex));

        this.zoom = zoomLevels[currentIndex];

        // Update zoom display
        const zoomDisplay = document.getElementById('zoom-level');
        if (zoomDisplay) {
            zoomDisplay.textContent = `${this.zoom}x`;
        }

        if (this.onZoomChange) {
            this.onZoomChange();
        }
    }

    resetView() {
        this.zoom = 8;
        this.offsetX = 0;
        this.offsetY = 0;

        const zoomDisplay = document.getElementById('zoom-level');
        if (zoomDisplay) {
            zoomDisplay.textContent = `${this.zoom}x`;
        }

        if (this.onRender) {
            this.onRender();
        }
    }

    centerView() {
        this.offsetX = 0;
        this.offsetY = 0;

        if (this.onRender) {
            this.onRender();
        }
    }

    toggleGrid() {
        this.showGrid = !this.showGrid;

        if (this.onRender) {
            this.onRender();
        }
    }

    clear() {
        this.ctx.fillStyle = '#000';
        this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
    }

    drawBackground() {
        if (!this.showBackground) {
            this.ctx.fillStyle = '#000';
            this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
            return;
        }

        // Draw starfield background
        this.ctx.fillStyle = '#000';
        this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);

        // Simple stars
        for (let i = 0; i < 100; i++) {
            const x = (i * 73) % this.canvas.width;
            const y = (i * 137) % this.canvas.height;
            const brightness = (i * 57) % 128 + 64;

            this.ctx.fillStyle = `rgb(${brightness}, ${brightness}, ${brightness})`;
            this.ctx.fillRect(x, y, 1, 1);
        }
    }

    drawGrid() {
        if (!this.showGrid) return;

        this.ctx.strokeStyle = 'rgba(0, 212, 255, 0.15)';
        this.ctx.lineWidth = 1;

        const gridSize = this.gridSize * this.zoom;
        const centerX = this.canvas.width / 2 + this.offsetX;
        const centerY = this.canvas.height / 2 + this.offsetY;

        // Vertical lines
        for (let x = centerX % gridSize; x < this.canvas.width; x += gridSize) {
            this.ctx.beginPath();
            this.ctx.moveTo(x, 0);
            this.ctx.lineTo(x, this.canvas.height);
            this.ctx.stroke();
        }

        // Horizontal lines
        for (let y = centerY % gridSize; y < this.canvas.height; y += gridSize) {
            this.ctx.beginPath();
            this.ctx.moveTo(0, y);
            this.ctx.lineTo(this.canvas.width, y);
            this.ctx.stroke();
        }

        // Center crosshair
        this.ctx.strokeStyle = 'rgba(255, 0, 255, 0.5)';
        this.ctx.lineWidth = 2;
        this.ctx.beginPath();
        this.ctx.moveTo(centerX - 10, centerY);
        this.ctx.lineTo(centerX + 10, centerY);
        this.ctx.moveTo(centerX, centerY - 10);
        this.ctx.lineTo(centerX, centerY + 10);
        this.ctx.stroke();
    }

    drawImageData(imageData, size) {
        // Create temporary canvas for the asset
        const tempCanvas = document.createElement('canvas');
        tempCanvas.width = size;
        tempCanvas.height = size;
        const tempCtx = tempCanvas.getContext('2d');
        tempCtx.putImageData(imageData, 0, 0);

        // Calculate position (centered with zoom and offset)
        const scaledSize = size * this.zoom;
        const x = (this.canvas.width - scaledSize) / 2 + this.offsetX;
        const y = (this.canvas.height - scaledSize) / 2 + this.offsetY;

        // Draw with nearest-neighbor scaling
        this.ctx.imageSmoothingEnabled = false;
        this.ctx.drawImage(tempCanvas, x, y, scaledSize, scaledSize);
    }

    exportToPNG(imageData, size, filename = 'asset.png') {
        const exportCanvas = document.createElement('canvas');
        exportCanvas.width = size;
        exportCanvas.height = size;
        const exportCtx = exportCanvas.getContext('2d');

        exportCtx.putImageData(imageData, 0, 0);

        exportCanvas.toBlob((blob) => {
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = filename;
            a.click();
            URL.revokeObjectURL(url);
        });
    }

    setRenderCallback(callback) {
        this.onRender = callback;
        this.onPanChange = callback;
        this.onZoomChange = callback;
    }
}

/* ============================================================
   PREVIEW CANVAS MANAGER
   ============================================================ */

class PreviewCanvasManager {
    constructor(canvasId) {
        this.canvas = document.getElementById(canvasId);
        this.ctx = this.canvas.getContext('2d');
        this.ctx.imageSmoothingEnabled = false;

        this.animating = false;
        this.animationFrame = 0;
        this.animationFrames = [];

        this.initEventListeners();
    }

    initEventListeners() {
        const animateCheckbox = document.getElementById('animate');
        if (animateCheckbox) {
            animateCheckbox.addEventListener('change', (e) => {
                this.animating = e.target.checked;
                if (this.animating) {
                    this.startAnimation();
                } else {
                    this.stopAnimation();
                }
            });
        }
    }

    updatePreview(imageData, size) {
        // Create temporary canvas
        const tempCanvas = document.createElement('canvas');
        tempCanvas.width = size;
        tempCanvas.height = size;
        const tempCtx = tempCanvas.getContext('2d');
        tempCtx.putImageData(imageData, 0, 0);

        // Clear and draw to preview
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        this.ctx.fillStyle = '#000';
        this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);

        this.ctx.imageSmoothingEnabled = false;
        this.ctx.drawImage(tempCanvas, 0, 0, this.canvas.width, this.canvas.height);
    }

    setAnimationFrames(frames) {
        this.animationFrames = frames;
        this.animationFrame = 0;
    }

    startAnimation() {
        if (this.animationFrames.length === 0) return;

        this.animationInterval = setInterval(() => {
            this.animationFrame = (this.animationFrame + 1) % this.animationFrames.length;
            this.updatePreview(this.animationFrames[this.animationFrame].imageData,
                             this.animationFrames[this.animationFrame].size);
        }, 100); // 10 FPS
    }

    stopAnimation() {
        if (this.animationInterval) {
            clearInterval(this.animationInterval);
        }
    }
}

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { CanvasManager, PreviewCanvasManager };
}
