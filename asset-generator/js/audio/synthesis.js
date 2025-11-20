// ============================================================================
// AUDIO SYNTHESIS ENGINE - Web Audio API
// ============================================================================
// Procedural sound generation using multiple synthesis methods
// 8-bit/16-bit retro game sounds for SpaceGameDev

class AudioSynthesisEngine {
    constructor() {
        this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
        this.masterGain = this.audioContext.createGain();
        this.masterGain.gain.value = 0.5;
        this.masterGain.connect(this.audioContext.destination);

        this.currentSource = null;
        this.sampleRate = 44100;
    }

    // ========================================================================
    // SYNTHESIS METHOD 1: ADDITIVE SYNTHESIS
    // ========================================================================
    // Combines multiple sine waves (harmonics)
    // Best for: Laser beams, engines, tonal sounds

    generateAdditive(params) {
        const {
            frequency = 440,
            duration = 0.5,
            harmonics = [1, 2, 3],
            harmonicAmplitudes = [0.6, 0.3, 0.1],
            envelope = { attack: 0.01, decay: 0.1, sustain: 0.5, release: 0.1 }
        } = params;

        const now = this.audioContext.currentTime;
        const oscillators = [];
        const gains = [];

        // Create oscillators for each harmonic
        harmonics.forEach((harmonic, i) => {
            const osc = this.audioContext.createOscillator();
            osc.type = 'sine';
            osc.frequency.value = frequency * harmonic;

            const gain = this.audioContext.createGain();
            gain.gain.value = harmonicAmplitudes[i] || 0.1;

            osc.connect(gain);
            oscillators.push(osc);
            gains.push(gain);
        });

        // ADSR Envelope
        const envelopeGain = this.audioContext.createGain();
        gains.forEach(g => g.connect(envelopeGain));

        const attackTime = envelope.attack;
        const decayTime = envelope.decay;
        const sustainLevel = envelope.sustain;
        const releaseTime = envelope.release;

        envelopeGain.gain.setValueAtTime(0, now);
        envelopeGain.gain.linearRampToValueAtTime(1.0, now + attackTime);
        envelopeGain.gain.linearRampToValueAtTime(sustainLevel, now + attackTime + decayTime);
        envelopeGain.gain.setValueAtTime(sustainLevel, now + duration - releaseTime);
        envelopeGain.gain.linearRampToValueAtTime(0, now + duration);

        envelopeGain.connect(this.masterGain);

        // Start oscillators
        oscillators.forEach(osc => {
            osc.start(now);
            osc.stop(now + duration);
        });

        this.currentSource = oscillators[0];
        return { duration, context: this.audioContext };
    }

    // ========================================================================
    // SYNTHESIS METHOD 2: SUBTRACTIVE SYNTHESIS
    // ========================================================================
    // White/Pink noise filtered through resonant filter
    // Best for: Explosions, wind, impact sounds

    generateSubtractive(params) {
        const {
            duration = 1.0,
            noiseType = 'white', // 'white' or 'pink'
            filterType = 'lowpass',
            filterCutoffStart = 8000,
            filterCutoffEnd = 200,
            filterResonance = 10,
            envelope = { attack: 0.01, decay: 0.8 }
        } = params;

        const now = this.audioContext.currentTime;

        // Generate noise buffer
        const bufferSize = this.audioContext.sampleRate * duration;
        const buffer = this.audioContext.createBuffer(1, bufferSize, this.audioContext.sampleRate);
        const data = buffer.getChannelData(0);

        if (noiseType === 'white') {
            for (let i = 0; i < bufferSize; i++) {
                data[i] = Math.random() * 2 - 1;
            }
        } else if (noiseType === 'pink') {
            let b0 = 0, b1 = 0, b2 = 0, b3 = 0, b4 = 0, b5 = 0, b6 = 0;
            for (let i = 0; i < bufferSize; i++) {
                const white = Math.random() * 2 - 1;
                b0 = 0.99886 * b0 + white * 0.0555179;
                b1 = 0.99332 * b1 + white * 0.0750759;
                b2 = 0.96900 * b2 + white * 0.1538520;
                b3 = 0.86650 * b3 + white * 0.3104856;
                b4 = 0.55000 * b4 + white * 0.5329522;
                b5 = -0.7616 * b5 - white * 0.0168980;
                data[i] = b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362;
                data[i] *= 0.11;
                b6 = white * 0.115926;
            }
        }

        const noise = this.audioContext.createBufferSource();
        noise.buffer = buffer;

        // Filter
        const filter = this.audioContext.createBiquadFilter();
        filter.type = filterType;
        filter.Q.value = filterResonance;
        filter.frequency.setValueAtTime(filterCutoffStart, now);
        filter.frequency.exponentialRampToValueAtTime(
            Math.max(filterCutoffEnd, 20),
            now + duration * 0.7
        );

        // Envelope
        const envelopeGain = this.audioContext.createGain();
        envelopeGain.gain.setValueAtTime(0, now);
        envelopeGain.gain.linearRampToValueAtTime(1.0, now + envelope.attack);
        envelopeGain.gain.exponentialRampToValueAtTime(0.01, now + duration);

        // Connect
        noise.connect(filter);
        filter.connect(envelopeGain);
        envelopeGain.connect(this.masterGain);

        noise.start(now);
        this.currentSource = noise;
        return { duration, context: this.audioContext };
    }

    // ========================================================================
    // SYNTHESIS METHOD 3: FM SYNTHESIS
    // ========================================================================
    // Frequency modulation for metallic, bell-like sounds
    // Best for: UI clicks, impacts, bell tones

    generateFM(params) {
        const {
            carrierFreq = 1000,
            modulatorFreq = 300,
            modulationIndex = 2.0,
            duration = 0.1,
            envelope = { attack: 0.005, decay: 0.095 }
        } = params;

        const now = this.audioContext.currentTime;

        // Carrier oscillator
        const carrier = this.audioContext.createOscillator();
        carrier.type = 'sine';
        carrier.frequency.value = carrierFreq;

        // Modulator oscillator
        const modulator = this.audioContext.createOscillator();
        modulator.type = 'sine';
        modulator.frequency.value = modulatorFreq;

        // Modulation gain (depth)
        const modulationGain = this.audioContext.createGain();
        modulationGain.gain.value = modulatorFreq * modulationIndex;

        // Envelope
        const envelopeGain = this.audioContext.createGain();
        envelopeGain.gain.setValueAtTime(0, now);
        envelopeGain.gain.linearRampToValueAtTime(0.5, now + envelope.attack);
        envelopeGain.gain.exponentialRampToValueAtTime(0.01, now + duration);

        // Connect FM
        modulator.connect(modulationGain);
        modulationGain.connect(carrier.frequency);

        carrier.connect(envelopeGain);
        envelopeGain.connect(this.masterGain);

        carrier.start(now);
        modulator.start(now);
        carrier.stop(now + duration);
        modulator.stop(now + duration);

        this.currentSource = carrier;
        return { duration, context: this.audioContext };
    }

    // ========================================================================
    // SYNTHESIS METHOD 4: PULSE WAVE (8-bit/16-bit style)
    // ========================================================================
    // Square/pulse waves for retro game sounds
    // Best for: Retro lasers, bleeps, bloops

    generatePulseWave(params) {
        const {
            frequency = 440,
            duration = 0.3,
            pulseWidth = 0.5, // Duty cycle (0.5 = square wave)
            pitchSweep = null, // { startFreq, endFreq }
            envelope = { attack: 0.01, decay: 0.1, sustain: 0.5, release: 0.1 }
        } = params;

        const now = this.audioContext.currentTime;

        // Use PeriodicWave for pulse width control
        const real = new Float32Array(2);
        const imag = new Float32Array(2);
        real[0] = 0;
        imag[0] = 0;
        real[1] = 2 / Math.PI * Math.sin(Math.PI * pulseWidth);
        imag[1] = 2 / Math.PI * (1 - Math.cos(Math.PI * pulseWidth));

        const wave = this.audioContext.createPeriodicWave(real, imag);

        const osc = this.audioContext.createOscillator();
        osc.setPeriodicWave(wave);

        if (pitchSweep) {
            osc.frequency.setValueAtTime(pitchSweep.startFreq, now);
            osc.frequency.exponentialRampToValueAtTime(pitchSweep.endFreq, now + duration);
        } else {
            osc.frequency.value = frequency;
        }

        // ADSR Envelope
        const envelopeGain = this.audioContext.createGain();
        const attackTime = envelope.attack;
        const decayTime = envelope.decay;
        const sustainLevel = envelope.sustain;
        const releaseTime = envelope.release;

        envelopeGain.gain.setValueAtTime(0, now);
        envelopeGain.gain.linearRampToValueAtTime(1.0, now + attackTime);
        envelopeGain.gain.linearRampToValueAtTime(sustainLevel, now + attackTime + decayTime);
        envelopeGain.gain.setValueAtTime(sustainLevel, now + duration - releaseTime);
        envelopeGain.gain.linearRampToValueAtTime(0, now + duration);

        osc.connect(envelopeGain);
        envelopeGain.connect(this.masterGain);

        osc.start(now);
        osc.stop(now + duration);

        this.currentSource = osc;
        return { duration, context: this.audioContext };
    }

    // ========================================================================
    // SYNTHESIS METHOD 5: PHYSICAL MODELING
    // ========================================================================
    // Simulate real-world impacts using modal synthesis
    // Best for: Collisions, metal impacts, hull damage

    generatePhysicalModel(params) {
        const {
            force = 1.0,
            material = 'metal', // 'metal', 'wood', 'glass'
            duration = 0.5
        } = params;

        const now = this.audioContext.currentTime;

        // Material-specific resonance modes
        const materialModes = {
            metal: [
                { freq: 200, decay: 0.5, amp: 0.4 },
                { freq: 450, decay: 0.3, amp: 0.3 },
                { freq: 890, decay: 0.2, amp: 0.2 }
            ],
            wood: [
                { freq: 120, decay: 0.4, amp: 0.5 },
                { freq: 280, decay: 0.3, amp: 0.3 },
                { freq: 520, decay: 0.2, amp: 0.2 }
            ],
            glass: [
                { freq: 800, decay: 0.6, amp: 0.4 },
                { freq: 1600, decay: 0.4, amp: 0.3 },
                { freq: 2400, decay: 0.2, amp: 0.2 }
            ]
        };

        const modes = materialModes[material] || materialModes.metal;

        // Impact noise (impulse)
        const noise = this.createNoiseBuffer(0.01);
        const impactSource = this.audioContext.createBufferSource();
        impactSource.buffer = noise;

        const impactGain = this.audioContext.createGain();
        impactGain.gain.setValueAtTime(force, now);
        impactGain.gain.exponentialRampToValueAtTime(0.01, now + 0.05);

        impactSource.connect(impactGain);
        impactGain.connect(this.masterGain);

        // Resonance modes
        modes.forEach(mode => {
            const osc = this.audioContext.createOscillator();
            osc.frequency.value = mode.freq * force;

            const gain = this.audioContext.createGain();
            gain.gain.setValueAtTime(mode.amp * force, now);
            gain.gain.exponentialRampToValueAtTime(0.01, now + mode.decay);

            osc.connect(gain);
            gain.connect(this.masterGain);

            osc.start(now);
            osc.stop(now + mode.decay);
        });

        impactSource.start(now);
        this.currentSource = impactSource;
        return { duration: Math.max(duration, 0.5), context: this.audioContext };
    }

    // ========================================================================
    // UTILITY METHODS
    // ========================================================================

    createNoiseBuffer(duration) {
        const bufferSize = this.audioContext.sampleRate * duration;
        const buffer = this.audioContext.createBuffer(1, bufferSize, this.audioContext.sampleRate);
        const data = buffer.getChannelData(0);

        for (let i = 0; i < bufferSize; i++) {
            data[i] = Math.random() * 2 - 1;
        }

        return buffer;
    }

    stop() {
        if (this.currentSource) {
            try {
                this.currentSource.stop();
            } catch (e) {
                // Already stopped
            }
            this.currentSource = null;
        }
    }

    setMasterVolume(volume) {
        this.masterGain.gain.value = Math.max(0, Math.min(1, volume));
    }

    // ========================================================================
    // OFFLINE RENDERING (for export)
    // ========================================================================

    async renderToBuffer(generatorFunc, params) {
        const offlineContext = new OfflineAudioContext(
            1, // mono
            this.sampleRate * (params.duration || 1),
            this.sampleRate
        );

        // Temporarily switch context
        const originalContext = this.audioContext;
        const originalGain = this.masterGain;

        this.audioContext = offlineContext;
        this.masterGain = offlineContext.createGain();
        this.masterGain.gain.value = 0.8;
        this.masterGain.connect(offlineContext.destination);

        // Generate sound
        generatorFunc.call(this, params);

        // Restore context
        this.audioContext = originalContext;
        this.masterGain = originalGain;

        // Render
        const buffer = await offlineContext.startRendering();
        return buffer;
    }
}

// Export
if (typeof module !== 'undefined' && module.exports) {
    module.exports = AudioSynthesisEngine;
}
