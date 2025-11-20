/* ============================================================
   SCANNER GENERATOR
   Generates radar/scanner sweep animations
   ============================================================ */

class ScannerGenerator {
    constructor() {
        this.params = {
            scanner_type: 'sweep',
            size: 128,
            scan_radius: 0.8,
            arc_width: 45,
            rotation_speed: 1,
            line_thickness: 2,
            glow_intensity: 1,
            fade_length: 0.5,
            ring_count: 3,
            show_grid: true,
            show_blips: false,
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
        this.colorPalette.applyPalette('cyber_blue');

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
                        if (id === 'arc_width') {
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
                this.animationTime += 0.02 * this.params.rotation_speed;
                this.generate();
            }
            requestAnimationFrame(animate);
        };
        animate();
    }

    generate() {
        const size = parseInt(this.params.size);
        const colors = this.colorPalette.getColors();

        this.currentImageData = this.generateScanner(size, this.params, colors);

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

    generateScanner(size, params, colors) {
        const imageData = this.canvasManager.ctx.createImageData(size, size);
        const data = imageData.data;

        const centerX = size / 2;
        const centerY = size / 2;
        const maxRadius = size * params.scan_radius / 2;

        const primaryRGB = this.colorPalette.hexToRgb(colors.primary);
        const secondaryRGB = this.colorPalette.hexToRgb(colors.secondary);
        const accentRGB = this.colorPalette.hexToRgb(colors.accent);

        // Current rotation angle
        const currentAngle = this.animationTime * Math.PI * 2;

        // Draw radar grid
        if (params.show_grid) {
            this.drawRadarGrid(data, size, centerX, centerY, maxRadius, primaryRGB);
        }

        // Draw range rings
        for (let ring = 1; ring <= params.ring_count; ring++) {
            const ringRadius = (maxRadius / params.ring_count) * ring;
            this.drawCircle(data, size, centerX, centerY, ringRadius, params.line_thickness, primaryRGB, 0.3);
        }

        // Draw sweep/ping based on type
        switch (params.scanner_type) {
            case 'sweep':
                this.drawSweep(data, size, centerX, centerY, maxRadius, currentAngle, params, accentRGB, primaryRGB);
                break;
            case 'ping':
                this.drawPing(data, size, centerX, centerY, maxRadius, params, accentRGB);
                break;
            case 'radar':
                this.drawRadar(data, size, centerX, centerY, maxRadius, currentAngle, params, accentRGB, secondaryRGB);
                break;
            case 'sonar':
                this.drawSonar(data, size, centerX, centerY, maxRadius, params, accentRGB);
                break;
        }

        // Draw target blips
        if (params.show_blips) {
            this.drawBlips(data, size, centerX, centerY, maxRadius, secondaryRGB);
        }

        // Center dot
        this.drawCircle(data, size, centerX, centerY, 3, 1, accentRGB, 1.0);

        return imageData;
    }

    drawRadarGrid(data, size, cx, cy, maxRadius, color) {
        // Draw crosshair lines
        for (let angle = 0; angle < Math.PI * 2; angle += Math.PI / 4) {
            const endX = cx + Math.cos(angle) * maxRadius;
            const endY = cy + Math.sin(angle) * maxRadius;
            this.drawLine(data, size, cx, cy, endX, endY, color, 0.2);
        }
    }

    drawSweep(data, size, cx, cy, maxRadius, angle, params, sweepColor, fadeColor) {
        const arcWidthRad = (params.arc_width * Math.PI) / 180;

        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const dx = x - cx;
                const dy = y - cy;
                const dist = Math.sqrt(dx * dx + dy * dy);
                const pixelAngle = Math.atan2(dy, dx);

                if (dist < maxRadius) {
                    // Calculate angular difference
                    let angleDiff = pixelAngle - angle;
                    while (angleDiff < -Math.PI) angleDiff += Math.PI * 2;
                    while (angleDiff > Math.PI) angleDiff -= Math.PI * 2;

                    if (angleDiff >= 0 && angleDiff <= arcWidthRad) {
                        const i = (y * size + x) * 4;
                        const fadeIntensity = (1 - (angleDiff / arcWidthRad)) * params.fade_length;
                        const glowEffect = params.glow_intensity * fadeIntensity;

                        data[i] = Math.max(data[i], Math.round(sweepColor.r * glowEffect));
                        data[i + 1] = Math.max(data[i + 1], Math.round(sweepColor.g * glowEffect));
                        data[i + 2] = Math.max(data[i + 2], Math.round(sweepColor.b * glowEffect));
                        data[i + 3] = Math.max(data[i + 3], Math.round(glowEffect * 150));
                    }
                }
            }
        }
    }

    drawPing(data, size, cx, cy, maxRadius, params, color) {
        const pingPhase = (this.animationTime * 2) % 1;
        const pingRadius = pingPhase * maxRadius;
        const pingWidth = maxRadius * 0.1;

        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const dx = x - cx;
                const dy = y - cy;
                const dist = Math.sqrt(dx * dx + dy * dy);

                if (Math.abs(dist - pingRadius) < pingWidth) {
                    const i = (y * size + x) * 4;
                    const intensity = (1 - Math.abs(dist - pingRadius) / pingWidth) * (1 - pingPhase) * params.glow_intensity;

                    data[i] = Math.max(data[i], Math.round(color.r * intensity));
                    data[i + 1] = Math.max(data[i + 1], Math.round(color.g * intensity));
                    data[i + 2] = Math.max(data[i + 2], Math.round(color.b * intensity));
                    data[i + 3] = Math.max(data[i + 3], Math.round(intensity * 200));
                }
            }
        }
    }

    drawRadar(data, size, cx, cy, maxRadius, angle, params, color1, color2) {
        // Combination of sweep and ping
        this.drawSweep(data, size, cx, cy, maxRadius, angle, params, color1, color2);

        const pingPhase = (this.animationTime * 3) % 1;
        const pingRadius = pingPhase * maxRadius;
        this.drawCircle(data, size, cx, cy, pingRadius, 2, color2, (1 - pingPhase) * 0.8);
    }

    drawSonar(data, size, cx, cy, maxRadius, params, color) {
        // Multiple concentric pulses
        for (let pulse = 0; pulse < 3; pulse++) {
            const pulsePhase = ((this.animationTime * 1.5 + pulse * 0.33) % 1);
            const pulseRadius = pulsePhase * maxRadius;
            const pulseIntensity = (1 - pulsePhase) * params.glow_intensity;

            this.drawCircle(data, size, cx, cy, pulseRadius, 3, color, pulseIntensity * 0.6);
        }
    }

    drawBlips(data, size, cx, cy, maxRadius, color) {
        // Draw some random target blips
        const blips = [
            { x: 0.3, y: 0.4 },
            { x: -0.5, y: 0.2 },
            { x: 0.2, y: -0.6 },
            { x: -0.3, y: -0.4 }
        ];

        blips.forEach(blip => {
            const blipX = cx + blip.x * maxRadius;
            const blipY = cy + blip.y * maxRadius;
            const blinkPhase = Math.sin(this.animationTime * 5) * 0.5 + 0.5;

            this.drawCircle(data, size, blipX, blipY, 3, 1, color, 0.5 + blinkPhase * 0.5);
        });
    }

    drawCircle(data, size, cx, cy, radius, thickness, color, alpha = 1.0) {
        for (let y = 0; y < size; y++) {
            for (let x = 0; x < size; x++) {
                const dx = x - cx;
                const dy = y - cy;
                const dist = Math.sqrt(dx * dx + dy * dy);

                if (Math.abs(dist - radius) < thickness) {
                    const i = (y * size + x) * 4;
                    const intensity = (1 - Math.abs(dist - radius) / thickness) * alpha;

                    data[i] = Math.max(data[i], Math.round(color.r * intensity));
                    data[i + 1] = Math.max(data[i + 1], Math.round(color.g * intensity));
                    data[i + 2] = Math.max(data[i + 2], Math.round(color.b * intensity));
                    data[i + 3] = Math.max(data[i + 3], Math.round(intensity * 255));
                }
            }
        }
    }

    drawLine(data, size, x1, y1, x2, y2, color, alpha = 1.0) {
        const dx = x2 - x1;
        const dy = y2 - y1;
        const steps = Math.max(Math.abs(dx), Math.abs(dy));

        for (let i = 0; i <= steps; i++) {
            const t = i / steps;
            const x = Math.round(x1 + dx * t);
            const y = Math.round(y1 + dy * t);

            if (x >= 0 && x < size && y >= 0 && y < size) {
                const idx = (y * size + x) * 4;
                data[idx] = Math.max(data[idx], Math.round(color.r * alpha));
                data[idx + 1] = Math.max(data[idx + 1], Math.round(color.g * alpha));
                data[idx + 2] = Math.max(data[idx + 2], Math.round(color.b * alpha));
                data[idx + 3] = Math.max(data[idx + 3], Math.round(alpha * 255));
            }
        }
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
            alert('Bitte generiere zuerst einen Scanner!');
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
            scannerType: document.getElementById('material').value,
            size: size,
            rangeClass: document.getElementById('size-category').value,
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

window.ScannerGenerator = ScannerGenerator;
