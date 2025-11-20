// ============================================================================
// SAMPLE PROCESSOR - External Audio Processing
// ============================================================================
// Load, slice, manipulate, and "verwursteln" external audio samples
// Granular synthesis, pitch-shifting, time-stretching, filtering

class SampleProcessor {
    constructor(audioContext) {
        this.audioContext = audioContext;
        this.loadedSamples = new Map(); // filename -> AudioBuffer
        this.sampleRate = audioContext.sampleRate;
    }

    // ========================================================================
    // LOADING & DECODING
    // ========================================================================

    async loadSampleFromFile(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();

            reader.onload = async (e) => {
                try {
                    const arrayBuffer = e.target.result;
                    const audioBuffer = await this.audioContext.decodeAudioData(arrayBuffer);

                    this.loadedSamples.set(file.name, audioBuffer);
                    resolve({
                        name: file.name,
                        buffer: audioBuffer,
                        duration: audioBuffer.duration,
                        channels: audioBuffer.numberOfChannels,
                        sampleRate: audioBuffer.sampleRate
                    });
                } catch (error) {
                    reject(new Error(`Failed to decode audio: ${error.message}`));
                }
            };

            reader.onerror = () => reject(new Error('Failed to read file'));
            reader.readAsArrayBuffer(file);
        });
    }

    getSample(name) {
        return this.loadedSamples.get(name);
    }

    getAllSamples() {
        return Array.from(this.loadedSamples.entries()).map(([name, buffer]) => ({
            name,
            duration: buffer.duration,
            channels: buffer.numberOfChannels
        }));
    }

    // ========================================================================
    // GRANULAR SYNTHESIS
    // ========================================================================
    // Slice sample into tiny grains and reassemble with variations

    generateGranular(params) {
        const {
            sampleName,
            grainSize = 0.05,        // Grain duration in seconds
            grainDensity = 30,        // Grains per second
            duration = 2.0,           // Total output duration
            pitchVariation = 0.2,     // Random pitch shift (±semitones)
            panVariation = 0.5,       // Random stereo position
            startPosition = 0.0,      // Start reading from (0.0-1.0)
            playbackRate = 1.0        // Overall speed
        } = params;

        const sample = this.getSample(sampleName);
        if (!sample) {
            console.error('Sample not loaded:', sampleName);
            return null;
        }

        const now = this.audioContext.currentTime;
        const totalGrains = Math.floor(grainDensity * duration);
        const sampleDuration = sample.duration;

        for (let i = 0; i < totalGrains; i++) {
            const grainStart = now + (i / grainDensity);

            // Create grain source
            const grain = this.audioContext.createBufferSource();
            grain.buffer = sample;

            // Random pitch variation
            const pitchShift = (Math.random() * 2 - 1) * pitchVariation;
            grain.playbackRate.value = playbackRate * Math.pow(2, pitchShift / 12);

            // Grain envelope
            const grainGain = this.audioContext.createGain();
            grainGain.gain.setValueAtTime(0, grainStart);
            grainGain.gain.linearRampToValueAtTime(0.3, grainStart + grainSize * 0.3);
            grainGain.gain.linearRampToValueAtTime(0, grainStart + grainSize);

            // Random panning
            const panner = this.audioContext.createStereoPanner();
            panner.pan.value = (Math.random() * 2 - 1) * panVariation;

            // Connect
            grain.connect(grainGain);
            grainGain.connect(panner);
            panner.connect(this.audioContext.destination);

            // Start from random position within sample
            const readPosition = startPosition + (Math.random() * 0.1);
            const offset = Math.min(readPosition * sampleDuration, sampleDuration - grainSize);

            grain.start(grainStart, offset, grainSize);
        }

        return { duration };
    }

    // ========================================================================
    // PITCH SHIFTING
    // ========================================================================

    pitchShift(params) {
        const {
            sampleName,
            semitones = 0,           // Pitch shift in semitones (-12 to +12)
            duration = null,          // Output duration (null = original)
            startTime = 0,            // Start playback at (seconds)
            envelope = null           // Optional ADSR envelope
        } = params;

        const sample = this.getSample(sampleName);
        if (!sample) {
            console.error('Sample not loaded:', sampleName);
            return null;
        }

        const now = this.audioContext.currentTime;
        const source = this.audioContext.createBufferSource();
        source.buffer = sample;

        // Pitch shift via playback rate
        source.playbackRate.value = Math.pow(2, semitones / 12);

        // Gain node
        const gain = this.audioContext.createGain();

        // Apply envelope if provided
        if (envelope) {
            const { attack, decay, sustain, release } = envelope;
            const totalDuration = duration || sample.duration;

            gain.gain.setValueAtTime(0, now);
            gain.gain.linearRampToValueAtTime(1.0, now + attack);
            gain.gain.linearRampToValueAtTime(sustain, now + attack + decay);
            gain.gain.setValueAtTime(sustain, now + totalDuration - release);
            gain.gain.linearRampToValueAtTime(0, now + totalDuration);
        } else {
            gain.gain.value = 1.0;
        }

        source.connect(gain);
        gain.connect(this.audioContext.destination);

        source.start(now, startTime, duration);

        return {
            duration: duration || sample.duration,
            source
        };
    }

    // ========================================================================
    // REVERSE
    // ========================================================================

    reverse(sampleName) {
        const sample = this.getSample(sampleName);
        if (!sample) {
            console.error('Sample not loaded:', sampleName);
            return null;
        }

        // Create reversed buffer
        const reversedBuffer = this.audioContext.createBuffer(
            sample.numberOfChannels,
            sample.length,
            sample.sampleRate
        );

        for (let channel = 0; channel < sample.numberOfChannels; channel++) {
            const inputData = sample.getChannelData(channel);
            const outputData = reversedBuffer.getChannelData(channel);

            for (let i = 0; i < sample.length; i++) {
                outputData[i] = inputData[sample.length - 1 - i];
            }
        }

        // Store reversed sample
        this.loadedSamples.set(`${sampleName}_reversed`, reversedBuffer);

        return reversedBuffer;
    }

    // ========================================================================
    // SLICING
    // ========================================================================

    slice(params) {
        const {
            sampleName,
            sliceCount = 8,          // Number of slices
            sliceIndex = 0,          // Which slice to play (0-based)
            randomOrder = false,     // Randomize slice order
            gap = 0.05               // Gap between slices (seconds)
        } = params;

        const sample = this.getSample(sampleName);
        if (!sample) {
            console.error('Sample not loaded:', sampleName);
            return null;
        }

        const sliceDuration = sample.duration / sliceCount;
        const now = this.audioContext.currentTime;

        if (randomOrder) {
            // Play all slices in random order
            const indices = Array.from({ length: sliceCount }, (_, i) => i);
            this.shuffleArray(indices);

            indices.forEach((idx, playOrder) => {
                const source = this.audioContext.createBufferSource();
                source.buffer = sample;

                const startOffset = idx * sliceDuration;
                const playTime = now + playOrder * (sliceDuration + gap);

                source.connect(this.audioContext.destination);
                source.start(playTime, startOffset, sliceDuration);
            });

            return { duration: sliceCount * (sliceDuration + gap) };
        } else {
            // Play single slice
            const source = this.audioContext.createBufferSource();
            source.buffer = sample;

            const startOffset = sliceIndex * sliceDuration;

            source.connect(this.audioContext.destination);
            source.start(now, startOffset, sliceDuration);

            return { duration: sliceDuration, source };
        }
    }

    // ========================================================================
    // FILTERING & EFFECTS
    // ========================================================================

    applyFilter(params) {
        const {
            sampleName,
            filterType = 'lowpass',   // lowpass, highpass, bandpass
            cutoffFreq = 1000,        // Hz
            resonance = 1,            // Q factor
            cutoffSweep = null,       // { start, end }
            duration = null
        } = params;

        const sample = this.getSample(sampleName);
        if (!sample) {
            console.error('Sample not loaded:', sampleName);
            return null;
        }

        const now = this.audioContext.currentTime;
        const source = this.audioContext.createBufferSource();
        source.buffer = sample;

        // Filter
        const filter = this.audioContext.createBiquadFilter();
        filter.type = filterType;
        filter.Q.value = resonance;

        if (cutoffSweep) {
            filter.frequency.setValueAtTime(cutoffSweep.start, now);
            filter.frequency.exponentialRampToValueAtTime(
                cutoffSweep.end,
                now + (duration || sample.duration)
            );
        } else {
            filter.frequency.value = cutoffFreq;
        }

        source.connect(filter);
        filter.connect(this.audioContext.destination);

        source.start(now, 0, duration);

        return {
            duration: duration || sample.duration,
            source
        };
    }

    applyDistortion(params) {
        const {
            sampleName,
            amount = 50,              // Distortion amount (0-100)
            duration = null
        } = params;

        const sample = this.getSample(sampleName);
        if (!sample) {
            console.error('Sample not loaded:', sampleName);
            return null;
        }

        const now = this.audioContext.currentTime;
        const source = this.audioContext.createBufferSource();
        source.buffer = sample;

        // Waveshaper distortion
        const distortion = this.audioContext.createWaveShaper();
        distortion.curve = this.makeDistortionCurve(amount);
        distortion.oversample = '4x';

        source.connect(distortion);
        distortion.connect(this.audioContext.destination);

        source.start(now, 0, duration);

        return {
            duration: duration || sample.duration,
            source
        };
    }

    // ========================================================================
    // BITCRUSHER (8-bit/16-bit effect)
    // ========================================================================

    applyBitcrusher(params) {
        const {
            sampleName,
            bitDepth = 4,             // Bit depth (1-16)
            sampleRateReduction = 4,  // Divide sample rate by this
            duration = null
        } = params;

        const sample = this.getSample(sampleName);
        if (!sample) {
            console.error('Sample not loaded:', sampleName);
            return null;
        }

        // Create bitcrushed buffer
        const crushedBuffer = this.audioContext.createBuffer(
            sample.numberOfChannels,
            sample.length,
            sample.sampleRate
        );

        const step = Math.pow(0.5, bitDepth);

        for (let channel = 0; channel < sample.numberOfChannels; channel++) {
            const inputData = sample.getChannelData(channel);
            const outputData = crushedBuffer.getChannelData(channel);

            let lastSample = 0;
            for (let i = 0; i < sample.length; i++) {
                if (i % sampleRateReduction === 0) {
                    lastSample = Math.round(inputData[i] / step) * step;
                }
                outputData[i] = lastSample;
            }
        }

        // Play crushed buffer
        const now = this.audioContext.currentTime;
        const source = this.audioContext.createBufferSource();
        source.buffer = crushedBuffer;

        source.connect(this.audioContext.destination);
        source.start(now, 0, duration);

        return {
            duration: duration || crushedBuffer.duration,
            source
        };
    }

    // ========================================================================
    // UTILITIES
    // ========================================================================

    makeDistortionCurve(amount) {
        const samples = 44100;
        const curve = new Float32Array(samples);
        const deg = Math.PI / 180;
        const k = amount;

        for (let i = 0; i < samples; i++) {
            const x = (i * 2) / samples - 1;
            curve[i] = ((3 + k) * x * 20 * deg) / (Math.PI + k * Math.abs(x));
        }

        return curve;
    }

    shuffleArray(array) {
        for (let i = array.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [array[i], array[j]] = [array[j], array[i]];
        }
    }

    // ========================================================================
    // OFFLINE RENDERING (for export)
    // ========================================================================

    async renderToBuffer(processorFunc, params) {
        const sampleDuration = params.duration || 1.0;
        const offlineContext = new OfflineAudioContext(
            1, // mono
            this.sampleRate * sampleDuration,
            this.sampleRate
        );

        // Copy sample to offline context
        const sample = this.getSample(params.sampleName);
        if (!sample) {
            throw new Error('Sample not loaded');
        }

        // Temporarily switch context
        const originalContext = this.audioContext;
        this.audioContext = offlineContext;

        // Process (this is tricky, need to handle differently per method)
        // For now, simple playback
        const source = offlineContext.createBufferSource();
        source.buffer = sample;
        source.connect(offlineContext.destination);
        source.start(0);

        // Restore
        this.audioContext = originalContext;

        // Render
        const buffer = await offlineContext.startRendering();
        return buffer;
    }
}

// Export
if (typeof module !== 'undefined' && module.exports) {
    module.exports = SampleProcessor;
}
