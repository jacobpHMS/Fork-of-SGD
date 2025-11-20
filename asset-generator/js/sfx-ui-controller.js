// ============================================================================
// SFX UI CONTROLLER
// ============================================================================
// Handles all UI interactions for the SFX generator

class SFXUIController {
    constructor() {
        this.synthesisEngine = new AudioSynthesisEngine();
        this.sampleProcessor = new SampleProcessor(this.synthesisEngine.audioContext);
        this.audioExporter = new AudioExporter();

        this.currentBuffer = null;
        this.currentSampleName = null;

        this.initEventListeners();
    }

    initEventListeners() {
        // Mode switcher
        const modeSelect = document.getElementById('sfx-mode');
        modeSelect?.addEventListener('change', () => this.handleModeChange());

        // Preset mode buttons
        document.getElementById('sfx-generate-btn')?.addEventListener('click', () => this.generatePresetSound());
        document.getElementById('sfx-play-btn')?.addEventListener('click', () => this.playPresetSound());
        document.getElementById('sfx-stop-btn')?.addEventListener('click', () => this.stopSound());

        // Sample mode buttons
        document.getElementById('sfx-sample-upload')?.addEventListener('change', (e) => this.handleSampleUpload(e));
        document.getElementById('sfx-process-sample-btn')?.addEventListener('click', () => this.processSample());
        document.getElementById('sfx-play-sample-btn')?.addEventListener('click', () => this.playSample());

        // Sample effect type change
        document.getElementById('sfx-sample-effect')?.addEventListener('change', () => this.handleEffectTypeChange());

        // Range inputs - update value displays
        this.setupRangeInputs();

        // Volume control
        document.getElementById('sfx-volume')?.addEventListener('input', (e) => {
            this.synthesisEngine.setMasterVolume(parseFloat(e.target.value));
            document.getElementById('sfx-volume-value').textContent = e.target.value;
        });

        // Export button (integrate with main export button when SFX is active)
        const exportBtn = document.getElementById('export-btn');
        if (exportBtn) {
            exportBtn.addEventListener('click', () => {
                const generatorType = document.querySelector('[data-generator].active')?.dataset.generator;
                if (generatorType === 'sfx') {
                    this.exportSound();
                }
            });
        }
    }

    setupRangeInputs() {
        const rangeInputs = [
            'sfx-variation',
            'sfx-grain-size',
            'sfx-grain-density',
            'sfx-pitch-var',
            'sfx-pitch-semitones',
            'sfx-bit-depth',
            'sfx-sample-reduction'
        ];

        rangeInputs.forEach(id => {
            const input = document.getElementById(id);
            const valueSpan = document.getElementById(`${id}-value`);
            if (input && valueSpan) {
                input.addEventListener('input', (e) => {
                    valueSpan.textContent = e.target.value;
                });
            }
        });
    }

    handleModeChange() {
        const mode = document.getElementById('sfx-mode').value;
        const presetControls = document.getElementById('sfx-preset-controls');
        const sampleControls = document.getElementById('sfx-sample-controls');

        if (mode === 'preset') {
            presetControls.style.display = 'block';
            sampleControls.style.display = 'none';
        } else {
            presetControls.style.display = 'none';
            sampleControls.style.display = 'block';
        }
    }

    handleEffectTypeChange() {
        const effectType = document.getElementById('sfx-sample-effect').value;

        // Hide all effect params
        document.querySelectorAll('.effect-params').forEach(el => {
            el.style.display = 'none';
        });

        // Show relevant params
        const paramsMap = {
            'granular': 'sfx-granular-params',
            'pitch': 'sfx-pitch-params',
            'bitcrush': 'sfx-bitcrush-params'
        };

        const targetParams = document.getElementById(paramsMap[effectType]);
        if (targetParams) {
            targetParams.style.display = 'block';
        }
    }

    // ========================================================================
    // PRESET MODE
    // ========================================================================

    async generatePresetSound() {
        const soundType = document.getElementById('sfx-type').value;
        const variation = parseFloat(document.getElementById('sfx-variation').value);

        try {
            // Generate sound using variation
            const result = generateSFXVariation(soundType, variation, this.synthesisEngine);

            if (!result) {
                console.error('Failed to generate sound');
                return;
            }

            // Render to buffer for visualization and export
            const preset = SFX_PRESETS[soundType];
            const params = JSON.parse(JSON.stringify(preset.params));

            // Apply variation to params
            if (params.frequency) {
                params.frequency *= (1 + (Math.random() * 2 - 1) * variation);
            }

            this.currentBuffer = await this.synthesisEngine.renderToBuffer(
                this.synthesisEngine[`generate${this.capitalizeFirst(preset.method)}`],
                params
            );

            // Visualize
            this.visualizeAudio(this.currentBuffer);

            document.getElementById('canvas-info-text').textContent = `Generated: ${preset.name}`;

        } catch (error) {
            console.error('Error generating sound:', error);
            document.getElementById('canvas-info-text').textContent = `Error: ${error.message}`;
        }
    }

    playPresetSound() {
        const soundType = document.getElementById('sfx-type').value;
        const variation = parseFloat(document.getElementById('sfx-variation').value);

        generateSFXVariation(soundType, variation, this.synthesisEngine);
    }

    stopSound() {
        this.synthesisEngine.stop();
    }

    // ========================================================================
    // SAMPLE MODE
    // ========================================================================

    async handleSampleUpload(event) {
        const file = event.target.files[0];
        if (!file) return;

        try {
            const sampleData = await this.sampleProcessor.loadSampleFromFile(file);
            this.currentSampleName = sampleData.name;

            document.getElementById('canvas-info-text').textContent =
                `Loaded: ${sampleData.name} (${sampleData.duration.toFixed(2)}s, ${sampleData.channels}ch)`;

        } catch (error) {
            console.error('Error loading sample:', error);
            document.getElementById('canvas-info-text').textContent = `Error: ${error.message}`;
        }
    }

    processSample() {
        if (!this.currentSampleName) {
            alert('Please upload an audio file first');
            return;
        }

        const effectType = document.getElementById('sfx-sample-effect').value;

        try {
            switch (effectType) {
                case 'granular':
                    this.applyGranular();
                    break;
                case 'pitch':
                    this.applyPitchShift();
                    break;
                case 'reverse':
                    this.applyReverse();
                    break;
                case 'slice':
                    this.applySlice();
                    break;
                case 'filter':
                    this.applyFilter();
                    break;
                case 'distortion':
                    this.applyDistortion();
                    break;
                case 'bitcrush':
                    this.applyBitcrush();
                    break;
            }
        } catch (error) {
            console.error('Error processing sample:', error);
            document.getElementById('canvas-info-text').textContent = `Error: ${error.message}`;
        }
    }

    applyGranular() {
        const grainSize = parseInt(document.getElementById('sfx-grain-size').value) / 1000;
        const grainDensity = parseInt(document.getElementById('sfx-grain-density').value);
        const pitchVariation = parseInt(document.getElementById('sfx-pitch-var').value);

        this.sampleProcessor.generateGranular({
            sampleName: this.currentSampleName,
            grainSize,
            grainDensity,
            duration: 2.0,
            pitchVariation: pitchVariation / 12
        });

        document.getElementById('canvas-info-text').textContent =
            `Granular processing applied (${grainDensity} grains/sec)`;
    }

    applyPitchShift() {
        const semitones = parseInt(document.getElementById('sfx-pitch-semitones').value);

        this.sampleProcessor.pitchShift({
            sampleName: this.currentSampleName,
            semitones
        });

        document.getElementById('canvas-info-text').textContent =
            `Pitch shifted ${semitones > 0 ? '+' : ''}${semitones} semitones`;
    }

    applyReverse() {
        const reversedBuffer = this.sampleProcessor.reverse(this.currentSampleName);
        this.currentBuffer = reversedBuffer;
        this.visualizeAudio(reversedBuffer);

        document.getElementById('canvas-info-text').textContent = 'Reversed audio';
    }

    applySlice() {
        this.sampleProcessor.slice({
            sampleName: this.currentSampleName,
            sliceCount: 8,
            randomOrder: true
        });

        document.getElementById('canvas-info-text').textContent = 'Randomized slices';
    }

    applyFilter() {
        this.sampleProcessor.applyFilter({
            sampleName: this.currentSampleName,
            filterType: 'lowpass',
            cutoffSweep: { start: 8000, end: 200 }
        });

        document.getElementById('canvas-info-text').textContent = 'Filter sweep applied';
    }

    applyDistortion() {
        this.sampleProcessor.applyDistortion({
            sampleName: this.currentSampleName,
            amount: 50
        });

        document.getElementById('canvas-info-text').textContent = 'Distortion applied';
    }

    applyBitcrush() {
        const bitDepth = parseInt(document.getElementById('sfx-bit-depth').value);
        const sampleReduction = parseInt(document.getElementById('sfx-sample-reduction').value);

        this.sampleProcessor.applyBitcrusher({
            sampleName: this.currentSampleName,
            bitDepth,
            sampleRateReduction: sampleReduction
        });

        document.getElementById('canvas-info-text').textContent =
            `Bitcrushed to ${bitDepth}-bit`;
    }

    playSample() {
        if (!this.currentSampleName) {
            alert('No sample loaded');
            return;
        }

        const sample = this.sampleProcessor.getSample(this.currentSampleName);
        if (!sample) return;

        const source = this.synthesisEngine.audioContext.createBufferSource();
        source.buffer = sample;
        source.connect(this.synthesisEngine.masterGain);
        source.start();
    }

    // ========================================================================
    // VISUALIZATION
    // ========================================================================

    visualizeAudio(audioBuffer) {
        if (!audioBuffer) return;

        const waveformCanvas = document.getElementById('waveform-canvas');
        const spectrogramCanvas = document.getElementById('spectrogram-canvas');

        if (waveformCanvas) {
            this.audioExporter.drawWaveform(audioBuffer, waveformCanvas);
        }

        if (spectrogramCanvas) {
            this.audioExporter.drawSpectrogram(audioBuffer, spectrogramCanvas);
        }
    }

    // ========================================================================
    // EXPORT
    // ========================================================================

    exportSound() {
        if (!this.currentBuffer) {
            alert('Please generate or process a sound first');
            return;
        }

        const soundType = document.getElementById('sfx-type').value;
        const filename = document.getElementById('export-filename').value || soundType || 'sound';

        this.audioExporter.exportToWAV(this.currentBuffer, filename);

        // Also export metadata
        const preset = SFX_PRESETS[soundType];
        if (preset) {
            this.audioExporter.exportMetadata({
                name: filename,
                type: 'sfx',
                duration: this.currentBuffer.duration,
                sampleRate: this.currentBuffer.sampleRate,
                channels: this.currentBuffer.numberOfChannels,
                parameters: preset.params
            }, filename);
        }
    }

    // ========================================================================
    // UTILITIES
    // ========================================================================

    capitalizeFirst(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }
}

// Initialize when DOM is ready
let sfxController;
document.addEventListener('DOMContentLoaded', () => {
    sfxController = new SFXUIController();
});
