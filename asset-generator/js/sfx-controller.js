// ============================================================================
// SFX-CONTROLLER.JS - Complete SFX Generator Controller
// SpaceGameDev - Separate SFX Page with Advanced Features
// ============================================================================

class SFXController {
    constructor() {
        this.synthesisEngine = new AudioSynthesisEngine();
        this.sampleProcessor = new SampleProcessor(this.synthesisEngine.audioContext);
        this.audioExporter = new AudioExporter();

        this.currentBuffer = null;
        this.currentAudioSource = null;
        this.isPlaying = false;
        this.loopEnabled = false;

        // Mixer state
        this.mixerSamples = {
            1: null,
            2: null,
            3: null,
            4: null
        };

        // Current parameters
        this.currentParams = {
            frequency: 440,
            duration: 0.5,
            attack: 0.01,
            decay: 0.1,
            sustain: 0.5,
            release: 0.2,
            pitchSweep: 0,
            distortion: 0
        };

        // Database counter
        this.dbCounters = {
            SFX_WEAPON: 1,
            SFX_ENGINE: 1,
            SFX_UI: 1,
            SFX_IMPACT: 1,
            SFX_AMBIENT: 1
        };

        this.initEventListeners();
        this.initPresetLibrary();
        this.updateSoundTypeOptions();
    }

    initEventListeners() {
        // Mode switcher
        document.getElementById('sfx-mode').addEventListener('change', (e) => {
            this.switchMode(e.target.value);
        });

        // Category switcher
        document.getElementById('sfx-category').addEventListener('change', () => {
            this.updateSoundTypeOptions();
        });

        // Generate sound
        document.getElementById('generate-sound-btn').addEventListener('click', () => {
            this.generatePresetSound();
        });

        document.getElementById('randomize-sound-btn').addEventListener('click', () => {
            this.randomizeSound();
        });

        // Parameter sliders - real-time update
        this.setupParameterSlider('frequency', (val) => `${val} Hz`);
        this.setupParameterSlider('duration', (val) => `${val}s`);
        this.setupParameterSlider('attack', (val) => `${val}s`);
        this.setupParameterSlider('decay', (val) => `${val}s`);
        this.setupParameterSlider('sustain', (val) => val);
        this.setupParameterSlider('release', (val) => `${val}s`);
        this.setupParameterSlider('pitch-sweep', (val) => `${val > 0 ? '+' : ''}${val} cents`);
        this.setupParameterSlider('distortion', (val) => `${val}%`);

        // Apply parameters
        document.getElementById('apply-params-btn').addEventListener('click', () => {
            this.applyParameters();
        });

        // Playback controls
        document.getElementById('play-btn').addEventListener('click', () => {
            this.playSound();
        });

        document.getElementById('stop-btn').addEventListener('click', () => {
            this.stopSound();
        });

        document.getElementById('loop-playback').addEventListener('change', (e) => {
            this.loopEnabled = e.target.checked;
        });

        document.getElementById('master-volume').addEventListener('input', (e) => {
            const volume = parseInt(e.target.value) / 100;
            this.synthesisEngine.masterGain.gain.value = volume;
            document.getElementById('master-volume-value').textContent = `${e.target.value}%`;
        });

        // Sample processing
        document.getElementById('sfx-sample-upload').addEventListener('change', (e) => {
            this.handleSampleUpload(e);
        });

        document.getElementById('process-sample-btn').addEventListener('click', () => {
            this.processSample();
        });

        document.getElementById('effect-amount').addEventListener('input', (e) => {
            document.getElementById('effect-amount-value').textContent = `${e.target.value}%`;
        });

        // Mixer
        this.setupMixer();

        document.getElementById('mix-samples-btn').addEventListener('click', () => {
            this.mixSamples();
        });

        // Variations
        document.getElementById('random-variation-btn').addEventListener('click', () => {
            this.createVariation(1.0);
        });

        document.getElementById('subtle-variation-btn').addEventListener('click', () => {
            this.createVariation(0.2);
        });

        document.getElementById('extreme-variation-btn').addEventListener('click', () => {
            this.createVariation(2.0);
        });

        // Export
        document.getElementById('export-btn').addEventListener('click', () => {
            this.exportSound();
        });

        document.getElementById('export-json-btn').addEventListener('click', () => {
            this.exportJSON();
        });

        // Database integration
        document.getElementById('db-category').addEventListener('change', () => {
            this.updateDatabaseID();
        });

        document.getElementById('db-tier').addEventListener('change', () => {
            this.updateDatabaseID();
        });

        document.getElementById('save-to-db-btn').addEventListener('click', () => {
            this.saveToDB();
        });

        // Auto-update asset name based on sound type
        document.getElementById('sfx-type').addEventListener('change', () => {
            this.updateAssetName();
            this.updateDatabaseID();
        });
    }

    setupParameterSlider(paramName, formatFn) {
        const slider = document.getElementById(`param-${paramName}`);
        const valueSpan = document.getElementById(`param-${paramName}-value`);

        slider.addEventListener('input', (e) => {
            const value = parseFloat(e.target.value);
            valueSpan.textContent = formatFn(value);

            // Store in current params
            const key = paramName.replace(/-([a-z])/g, (g) => g[1].toUpperCase());
            this.currentParams[key] = value;
        });
    }

    setupMixer() {
        const slots = document.querySelectorAll('.mixer-slot');

        slots.forEach((slot, index) => {
            const slotNum = index + 1;
            const fileInput = slot.querySelector('.mixer-file-input');
            const volumeSlider = slot.querySelector('.mixer-volume');
            const volumeValue = slot.querySelector('.mixer-volume-value');
            const panSlider = slot.querySelector('.mixer-pan');
            const panValue = slot.querySelector('.mixer-pan-value');

            fileInput.addEventListener('change', async (e) => {
                const file = e.target.files[0];
                if (file) {
                    const arrayBuffer = await file.arrayBuffer();
                    const audioBuffer = await this.synthesisEngine.audioContext.decodeAudioData(arrayBuffer);
                    this.mixerSamples[slotNum] = {
                        buffer: audioBuffer,
                        volume: 1.0,
                        pan: 0,
                        name: file.name
                    };
                    slot.classList.add('active');
                }
            });

            volumeSlider.addEventListener('input', (e) => {
                const value = parseInt(e.target.value);
                volumeValue.textContent = `${value}%`;
                if (this.mixerSamples[slotNum]) {
                    this.mixerSamples[slotNum].volume = value / 100;
                }
            });

            panSlider.addEventListener('input', (e) => {
                const value = parseInt(e.target.value);
                panValue.textContent = value === 0 ? 'Center' :
                                      value < 0 ? `L${Math.abs(value)}` : `R${value}`;
                if (this.mixerSamples[slotNum]) {
                    this.mixerSamples[slotNum].pan = value / 100;
                }
            });
        });
    }

    switchMode(mode) {
        // Hide all panels
        document.getElementById('preset-panel').style.display = 'none';
        document.getElementById('params-panel').style.display = 'none';
        document.getElementById('sample-panel').style.display = 'none';
        document.getElementById('mixer-panel').style.display = 'none';

        // Show relevant panels
        if (mode === 'preset') {
            document.getElementById('preset-panel').style.display = 'block';
            document.getElementById('params-panel').style.display = 'block';
        } else if (mode === 'sample') {
            document.getElementById('sample-panel').style.display = 'block';
        } else if (mode === 'mixer') {
            document.getElementById('mixer-panel').style.display = 'block';
        }
    }

    updateSoundTypeOptions() {
        const category = document.getElementById('sfx-category').value;
        const typeSelect = document.getElementById('sfx-type');

        typeSelect.innerHTML = '';

        // Get presets for category
        const categoryPresets = this.getPresetsForCategory(category);

        categoryPresets.forEach(preset => {
            const option = document.createElement('option');
            option.value = preset.id;
            option.textContent = preset.name;
            typeSelect.appendChild(option);
        });

        this.updateAssetName();
    }

    getPresetsForCategory(category) {
        const presets = {
            weapons: [
                { id: 'laser_basic', name: 'Laser (Basic)' },
                { id: 'laser_charged', name: 'Laser (Charged)' },
                { id: 'missile_launch', name: 'Missile Launch' },
                { id: 'cannon_fire', name: 'Cannon Fire' },
                { id: 'plasma_shot', name: 'Plasma Shot' }
            ],
            impacts: [
                { id: 'explosion_small', name: 'Explosion (Small)' },
                { id: 'explosion_large', name: 'Explosion (Large)' },
                { id: 'hull_hit', name: 'Hull Hit' },
                { id: 'shield_hit', name: 'Shield Hit' }
            ],
            ui: [
                { id: 'ui_click', name: 'Click' },
                { id: 'ui_hover', name: 'Hover' },
                { id: 'ui_confirm', name: 'Confirm' },
                { id: 'ui_cancel', name: 'Cancel' },
                { id: 'ui_error', name: 'Error' }
            ],
            engines: [
                { id: 'engine_idle', name: 'Engine Idle' },
                { id: 'engine_thrust', name: 'Engine Thrust' },
                { id: 'warp_jump', name: 'Warp Jump' }
            ],
            retro: [
                { id: 'retro_jump', name: '8-bit Jump' },
                { id: 'retro_coin', name: '8-bit Coin' },
                { id: 'retro_powerup', name: '8-bit Powerup' },
                { id: 'retro_hit', name: '8-bit Hit' },
                { id: 'retro_death', name: '8-bit Death' }
            ],
            misc: [
                { id: 'cargo_pickup', name: 'Cargo Pickup' },
                { id: 'cargo_eject', name: 'Cargo Eject' },
                { id: 'mining_laser', name: 'Mining Laser' },
                { id: 'ore_depleted', name: 'Ore Depleted' },
                { id: 'autopilot_engage', name: 'Autopilot Engage' },
                { id: 'alarm_critical', name: 'Alarm (Critical)' }
            ]
        };

        return presets[category] || [];
    }

    async generatePresetSound() {
        const soundType = document.getElementById('sfx-type').value;

        if (!SFX_PRESETS[soundType]) {
            alert('Preset nicht gefunden!');
            return;
        }

        // Generate sound
        const result = generateSFX(soundType, this.synthesisEngine);

        // Render to buffer
        this.currentBuffer = await this.synthesisEngine.renderToBuffer(
            result.method,
            result.params
        );

        // Visualize
        this.visualizeAudio(this.currentBuffer);

        // Update UI
        this.updateSoundInfo(soundType, this.currentBuffer);
        this.enablePlaybackButtons();
        this.updateAssetName();
    }

    async applyParameters() {
        if (!this.currentBuffer) {
            alert('Erst Sound generieren!');
            return;
        }

        // Get current sound type
        const soundType = document.getElementById('sfx-type').value;
        const preset = SFX_PRESETS[soundType];

        if (!preset) return;

        // Merge preset params with current params
        const mergedParams = { ...preset.params, ...this.currentParams };

        // Regenerate with new params
        this.currentBuffer = await this.synthesisEngine.renderToBuffer(
            preset.method,
            mergedParams
        );

        // Visualize
        this.visualizeAudio(this.currentBuffer);
        this.updateSoundInfo(soundType, this.currentBuffer);
    }

    randomizeSound() {
        const category = document.getElementById('sfx-category').value;
        const presets = this.getPresetsForCategory(category);

        if (presets.length > 0) {
            const randomPreset = presets[Math.floor(Math.random() * presets.length)];
            document.getElementById('sfx-type').value = randomPreset.id;

            // Randomize parameters slightly
            this.randomizeParameters(0.3);

            this.generatePresetSound();
        }
    }

    randomizeParameters(amount = 0.5) {
        const randomize = (base, variation) => {
            return base * (1 + (Math.random() - 0.5) * variation * amount);
        };

        this.currentParams.frequency = randomize(440, 2);
        this.currentParams.duration = randomize(0.5, 1);
        this.currentParams.attack = randomize(0.01, 2);
        this.currentParams.decay = randomize(0.1, 2);
        this.currentParams.sustain = Math.random();
        this.currentParams.release = randomize(0.2, 2);
        this.currentParams.pitchSweep = (Math.random() - 0.5) * 2400 * amount;
        this.currentParams.distortion = Math.random() * 100 * amount;

        // Update sliders
        document.getElementById('param-frequency').value = this.currentParams.frequency;
        document.getElementById('param-duration').value = this.currentParams.duration;
        document.getElementById('param-attack').value = this.currentParams.attack;
        document.getElementById('param-decay').value = this.currentParams.decay;
        document.getElementById('param-sustain').value = this.currentParams.sustain;
        document.getElementById('param-release').value = this.currentParams.release;
        document.getElementById('param-pitch-sweep').value = this.currentParams.pitchSweep;
        document.getElementById('param-distortion').value = this.currentParams.distortion;

        // Trigger updates
        document.getElementById('param-frequency').dispatchEvent(new Event('input'));
        document.getElementById('param-duration').dispatchEvent(new Event('input'));
        document.getElementById('param-attack').dispatchEvent(new Event('input'));
        document.getElementById('param-decay').dispatchEvent(new Event('input'));
        document.getElementById('param-sustain').dispatchEvent(new Event('input'));
        document.getElementById('param-release').dispatchEvent(new Event('input'));
        document.getElementById('param-pitch-sweep').dispatchEvent(new Event('input'));
        document.getElementById('param-distortion').dispatchEvent(new Event('input'));
    }

    async createVariation(amount) {
        if (!this.currentBuffer) {
            alert('Erst Sound generieren!');
            return;
        }

        this.randomizeParameters(amount);
        await this.applyParameters();
    }

    async handleSampleUpload(event) {
        const file = event.target.files[0];
        if (!file) return;

        try {
            const sampleData = await this.sampleProcessor.loadSampleFromFile(file);
            alert(`Sample "${sampleData.name}" geladen (${sampleData.duration.toFixed(2)}s)`);
        } catch (error) {
            alert('Fehler beim Laden: ' + error.message);
        }
    }

    async processSample() {
        const effect = document.getElementById('sfx-sample-effect').value;
        const amount = parseInt(document.getElementById('effect-amount').value) / 100;

        try {
            let buffer;

            if (effect === 'granular') {
                buffer = await this.sampleProcessor.generateGranular({
                    sampleName: this.sampleProcessor.loadedSamples.keys().next().value,
                    grainSize: 0.05,
                    grainDensity: Math.floor(30 * amount),
                    pitchVariation: 2 * amount
                });
            } else if (effect === 'bitcrush') {
                buffer = await this.sampleProcessor.applyBitcrusher({
                    sampleName: this.sampleProcessor.loadedSamples.keys().next().value,
                    bitDepth: Math.floor(16 - (15 * amount)),
                    sampleRateReduction: Math.floor(16 * amount)
                });
            } else if (effect === 'pitch') {
                buffer = await this.sampleProcessor.pitchShift({
                    sampleName: this.sampleProcessor.loadedSamples.keys().next().value,
                    semitones: (amount - 0.5) * 24
                });
            } else if (effect === 'reverse') {
                buffer = await this.sampleProcessor.reverse(
                    this.sampleProcessor.loadedSamples.keys().next().value
                );
            }

            if (buffer) {
                this.currentBuffer = buffer;
                this.visualizeAudio(buffer);
                this.updateSoundInfo('processed_sample', buffer);
                this.enablePlaybackButtons();
            }
        } catch (error) {
            alert('Fehler beim Processing: ' + error.message);
        }
    }

    async mixSamples() {
        const activeSamples = Object.values(this.mixerSamples).filter(s => s !== null);

        if (activeSamples.length === 0) {
            alert('Mindestens ein Sample laden!');
            return;
        }

        // Find longest duration
        const maxDuration = Math.max(...activeSamples.map(s => s.buffer.duration));
        const sampleRate = this.synthesisEngine.audioContext.sampleRate;
        const length = maxDuration * sampleRate;

        // Create offline context
        const offlineCtx = new OfflineAudioContext(2, length, sampleRate);

        // Create nodes for each sample
        activeSamples.forEach(sample => {
            const source = offlineCtx.createBufferSource();
            source.buffer = sample.buffer;

            const gainNode = offlineCtx.createGain();
            gainNode.gain.value = sample.volume;

            const panNode = offlineCtx.createStereoPanner();
            panNode.pan.value = sample.pan;

            source.connect(gainNode);
            gainNode.connect(panNode);
            panNode.connect(offlineCtx.destination);

            source.start(0);
        });

        // Render
        this.currentBuffer = await offlineCtx.startRendering();

        // Visualize
        this.visualizeAudio(this.currentBuffer);
        this.updateSoundInfo('mixed_samples', this.currentBuffer);
        this.enablePlaybackButtons();
    }

    playSound() {
        if (!this.currentBuffer) return;

        this.stopSound(); // Stop any playing sound

        // Create analyser for live visualization
        const analyser = this.synthesisEngine.audioContext.createAnalyser();
        analyser.fftSize = 2048;
        analyser.smoothingTimeConstant = 0.8;

        this.currentAudioSource = this.synthesisEngine.audioContext.createBufferSource();
        this.currentAudioSource.buffer = this.currentBuffer;
        this.currentAudioSource.loop = this.loopEnabled;

        // Connect: source -> analyser -> masterGain
        this.currentAudioSource.connect(analyser);
        analyser.connect(this.synthesisEngine.masterGain);

        // Start live visualization
        const spectrogramCanvas = document.getElementById('spectrogram-canvas');
        this.liveAnimationId = this.audioExporter.startLiveVisualization(
            this.synthesisEngine.audioContext,
            spectrogramCanvas,
            analyser
        );

        // Update waveform with playhead
        const waveformCanvas = document.getElementById('waveform-canvas');
        const startTime = this.synthesisEngine.audioContext.currentTime;

        const updatePlayhead = () => {
            if (!this.isPlaying) return;

            const elapsed = this.synthesisEngine.audioContext.currentTime - startTime;
            const position = this.loopEnabled
                ? elapsed % this.currentBuffer.duration
                : Math.min(elapsed, this.currentBuffer.duration);

            this.audioExporter.drawWaveformWithPlayhead(
                this.currentBuffer,
                waveformCanvas,
                position,
                '#3498db'
            );

            if (this.isPlaying) {
                requestAnimationFrame(updatePlayhead);
            }
        };

        this.playheadAnimationId = requestAnimationFrame(updatePlayhead);

        this.currentAudioSource.onended = () => {
            if (!this.loopEnabled) {
                this.isPlaying = false;
                document.getElementById('play-btn').textContent = '▶️ Play';
                this.audioExporter.stopLiveVisualization(this.liveAnimationId);
                if (this.playheadAnimationId) {
                    cancelAnimationFrame(this.playheadAnimationId);
                }
            }
        };

        this.currentAudioSource.start(0);
        this.isPlaying = true;
        document.getElementById('play-btn').textContent = '⏸️ Pause';
    }

    stopSound() {
        if (this.currentAudioSource) {
            try {
                this.currentAudioSource.stop();
            } catch (e) {
                // Already stopped
            }
            this.currentAudioSource = null;
        }

        // Stop live visualizations
        if (this.liveAnimationId) {
            this.audioExporter.stopLiveVisualization(this.liveAnimationId);
            this.liveAnimationId = null;
        }

        if (this.playheadAnimationId) {
            cancelAnimationFrame(this.playheadAnimationId);
            this.playheadAnimationId = null;
        }

        // Redraw static visualization
        if (this.currentBuffer) {
            this.visualizeAudio(this.currentBuffer);
        }

        this.isPlaying = false;
        document.getElementById('play-btn').textContent = '▶️ Play';
    }

    visualizeAudio(buffer) {
        const waveformCanvas = document.getElementById('waveform-canvas');
        const spectrogramCanvas = document.getElementById('spectrogram-canvas');

        this.audioExporter.drawWaveform(buffer, waveformCanvas, '#3498db');
        this.audioExporter.drawSpectrogram(buffer, spectrogramCanvas);
    }

    updateSoundInfo(name, buffer) {
        document.getElementById('info-name').textContent = name;
        document.getElementById('info-duration').textContent = `${buffer.duration.toFixed(2)}s`;
        document.getElementById('info-samplerate').textContent = `${buffer.sampleRate / 1000} kHz`;
        document.getElementById('info-channels').textContent = buffer.numberOfChannels === 1 ? 'Mono' : 'Stereo';
    }

    enablePlaybackButtons() {
        document.getElementById('play-btn').disabled = false;
        document.getElementById('stop-btn').disabled = false;
        document.getElementById('export-btn').disabled = false;
        document.getElementById('export-json-btn').disabled = false;
        document.getElementById('save-to-db-btn').disabled = false;
    }

    updateAssetName() {
        const soundType = document.getElementById('sfx-type').value;
        const category = document.getElementById('sfx-category').value;

        // Generate filename based on naming convention
        // Format: sfx_{category}_{type}.wav
        const assetName = `sfx_${category}_${soundType}`;
        document.getElementById('asset-name').value = assetName;
    }

    updateDatabaseID() {
        const category = document.getElementById('db-category').value;
        const tier = document.getElementById('db-tier').value;

        // Format: {CATEGORY}_T{TIER}_{NUMBER}
        const counter = this.dbCounters[category];
        const paddedCounter = String(counter).padStart(3, '0');
        const dbID = `${category}_T${tier}_${paddedCounter}`;

        document.getElementById('db-auto-id').value = dbID;
    }

    exportSound() {
        if (!this.currentBuffer) return;

        const filename = document.getElementById('asset-name').value || 'sound';
        const format = document.getElementById('export-format').value;

        if (format === 'wav') {
            this.audioExporter.exportToWAV(this.currentBuffer, filename);
        } else if (format === 'ogg') {
            alert('OGG Export noch nicht implementiert. Verwende WAV und konvertiere mit Audacity.');
        }
    }

    exportJSON() {
        if (!this.currentBuffer) return;

        const soundType = document.getElementById('sfx-type').value;
        const category = document.getElementById('db-category').value;
        const tier = document.getElementById('db-tier').value;
        const dbID = document.getElementById('db-auto-id').value;

        const metadata = {
            id: dbID,
            name: document.getElementById('asset-name').value,
            category: category,
            tier: parseInt(tier),
            duration: this.currentBuffer.duration,
            sampleRate: this.currentBuffer.sampleRate,
            channels: this.currentBuffer.numberOfChannels,
            parameters: this.currentParams,
            preset: soundType,
            timestamp: new Date().toISOString()
        };

        const json = JSON.stringify(metadata, null, 2);
        const blob = new Blob([json], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `${metadata.name}_meta.json`;
        a.click();
        URL.revokeObjectURL(url);
    }

    saveToDB() {
        // This would save to database - for now just export both files
        this.exportSound();
        this.exportJSON();

        // Increment counter
        const category = document.getElementById('db-category').value;
        this.dbCounters[category]++;
        this.updateDatabaseID();

        alert('Sound exportiert! Dateien wurden heruntergeladen.');
    }

    initPresetLibrary() {
        const library = document.getElementById('preset-library');

        Object.keys(SFX_PRESETS).forEach(presetKey => {
            const preset = SFX_PRESETS[presetKey];
            const btn = document.createElement('button');
            btn.className = 'btn btn-small';
            btn.textContent = preset.name;
            btn.style.marginBottom = '4px';
            btn.style.width = '100%';

            btn.addEventListener('click', () => {
                // Find category for this preset
                const categories = ['weapons', 'impacts', 'ui', 'engines', 'retro', 'misc'];
                for (const cat of categories) {
                    const presets = this.getPresetsForCategory(cat);
                    if (presets.find(p => p.id === presetKey)) {
                        document.getElementById('sfx-category').value = cat;
                        this.updateSoundTypeOptions();
                        document.getElementById('sfx-type').value = presetKey;
                        this.generatePresetSound();
                        break;
                    }
                }
            });

            library.appendChild(btn);
        });
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    window.sfxController = new SFXController();
});
