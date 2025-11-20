// ============================================================================
// AUDIO EXPORT SYSTEM
// ============================================================================
// Export AudioBuffer to WAV format for Godot integration

class AudioExporter {
    constructor() {
        this.sampleRate = 44100;
    }

    // ========================================================================
    // WAV EXPORT
    // ========================================================================

    exportToWAV(audioBuffer, filename = 'sound') {
        const wav = this.audioBufferToWav(audioBuffer);
        const blob = new Blob([wav], { type: 'audio/wav' });
        this.downloadBlob(blob, `${filename}.wav`);
    }

    audioBufferToWav(buffer) {
        const numberOfChannels = buffer.numberOfChannels;
        const length = buffer.length * numberOfChannels * 2; // 16-bit samples
        const sampleRate = buffer.sampleRate;

        const arrayBuffer = new ArrayBuffer(44 + length);
        const view = new DataView(arrayBuffer);

        // RIFF header
        this.writeString(view, 0, 'RIFF');
        view.setUint32(4, 36 + length, true);
        this.writeString(view, 8, 'WAVE');

        // fmt chunk
        this.writeString(view, 12, 'fmt ');
        view.setUint32(16, 16, true); // Subchunk1Size (PCM)
        view.setUint16(20, 1, true);  // AudioFormat (1 = PCM)
        view.setUint16(22, numberOfChannels, true);
        view.setUint32(24, sampleRate, true);
        view.setUint32(28, sampleRate * numberOfChannels * 2, true); // ByteRate
        view.setUint16(32, numberOfChannels * 2, true); // BlockAlign
        view.setUint16(34, 16, true); // BitsPerSample

        // data chunk
        this.writeString(view, 36, 'data');
        view.setUint32(40, length, true);

        // Write PCM samples
        const channels = [];
        for (let i = 0; i < numberOfChannels; i++) {
            channels.push(buffer.getChannelData(i));
        }

        let offset = 44;
        for (let i = 0; i < buffer.length; i++) {
            for (let channel = 0; channel < numberOfChannels; channel++) {
                const sample = Math.max(-1, Math.min(1, channels[channel][i]));
                const int16 = sample < 0 ? sample * 0x8000 : sample * 0x7FFF;
                view.setInt16(offset, int16, true);
                offset += 2;
            }
        }

        return arrayBuffer;
    }

    // ========================================================================
    // OGG EXPORT (requires external library)
    // ========================================================================

    async exportToOGG(audioBuffer, filename = 'sound') {
        // Note: OGG encoding requires external library (e.g., ogg-vorbis-encoder-js)
        // For now, fallback to WAV
        console.warn('OGG export not yet implemented, exporting as WAV instead');
        this.exportToWAV(audioBuffer, filename);
    }

    // ========================================================================
    // BATCH EXPORT
    // ========================================================================

    async exportBatch(audioBuffers, baseFilename = 'sound') {
        const zip = new JSZip();

        for (let i = 0; i < audioBuffers.length; i++) {
            const wav = this.audioBufferToWav(audioBuffers[i]);
            const filename = `${baseFilename}_${String(i + 1).padStart(3, '0')}.wav`;
            zip.file(filename, wav);
        }

        const blob = await zip.generateAsync({ type: 'blob' });
        this.downloadBlob(blob, `${baseFilename}_batch.zip`);
    }

    // ========================================================================
    // METADATA EXPORT (JSON)
    // ========================================================================

    exportMetadata(soundData, filename = 'sound_metadata') {
        const metadata = {
            name: soundData.name || 'Untitled',
            type: soundData.type || 'sfx',
            duration: soundData.duration || 0,
            sampleRate: soundData.sampleRate || 44100,
            channels: soundData.channels || 1,
            parameters: soundData.parameters || {},
            generatedAt: new Date().toISOString(),
            generator: 'SpaceGameDev Asset Generator',
            version: '1.0'
        };

        const json = JSON.stringify(metadata, null, 2);
        const blob = new Blob([json], { type: 'application/json' });
        this.downloadBlob(blob, `${filename}.json`);
    }

    // ========================================================================
    // UTILITIES
    // ========================================================================

    writeString(view, offset, string) {
        for (let i = 0; i < string.length; i++) {
            view.setUint8(offset + i, string.charCodeAt(i));
        }
    }

    downloadBlob(blob, filename) {
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.download = filename;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
    }

    // ========================================================================
    // WAVEFORM VISUALIZATION
    // ========================================================================

    drawWaveform(audioBuffer, canvas, color = '#00d9ff') {
        const ctx = canvas.getContext('2d');
        const width = canvas.width;
        const height = canvas.height;

        // Clear
        ctx.fillStyle = '#0a0e1a';
        ctx.fillRect(0, 0, width, height);

        // Get channel data
        const data = audioBuffer.getChannelData(0);
        const step = Math.ceil(data.length / width);
        const amp = height / 2;

        // Draw waveform
        ctx.strokeStyle = color;
        ctx.lineWidth = 2;
        ctx.beginPath();

        for (let i = 0; i < width; i++) {
            let min = 1.0;
            let max = -1.0;

            for (let j = 0; j < step; j++) {
                const datum = data[i * step + j];
                if (datum < min) min = datum;
                if (datum > max) max = datum;
            }

            ctx.moveTo(i, (1 + min) * amp);
            ctx.lineTo(i, (1 + max) * amp);
        }

        ctx.stroke();

        // Center line
        ctx.strokeStyle = 'rgba(255, 255, 255, 0.2)';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(0, height / 2);
        ctx.lineTo(width, height / 2);
        ctx.stroke();
    }

    // ========================================================================
    // SPECTROGRAM VISUALIZATION
    // ========================================================================

    async drawSpectrogram(audioBuffer, canvas) {
        const ctx = canvas.getContext('2d');
        const width = canvas.width;
        const height = canvas.height;

        // Clear
        ctx.fillStyle = '#0a0e1a';
        ctx.fillRect(0, 0, width, height);

        // Manual STFT (Short-Time Fourier Transform) implementation
        const channelData = audioBuffer.getChannelData(0);
        const fftSize = 2048;
        const hopSize = fftSize / 4; // 75% overlap
        const numFrames = Math.floor((channelData.length - fftSize) / hopSize);

        if (numFrames <= 0) {
            console.warn('Audio buffer too short for spectrogram');
            return;
        }

        const freqBins = fftSize / 2;
        const spectrogramData = new Array(numFrames);

        // Hanning window
        const window = new Float32Array(fftSize);
        for (let i = 0; i < fftSize; i++) {
            window[i] = 0.5 * (1 - Math.cos((2 * Math.PI * i) / (fftSize - 1)));
        }

        // Compute FFT for each frame
        for (let frame = 0; frame < numFrames; frame++) {
            const frameStart = frame * hopSize;
            const frameData = new Float32Array(fftSize);

            // Apply window
            for (let i = 0; i < fftSize; i++) {
                frameData[i] = channelData[frameStart + i] * window[i];
            }

            // Simple DFT (for production, use FFT library)
            const magnitudes = new Float32Array(freqBins);
            for (let k = 0; k < freqBins; k++) {
                let real = 0, imag = 0;
                for (let n = 0; n < fftSize; n++) {
                    const angle = (-2 * Math.PI * k * n) / fftSize;
                    real += frameData[n] * Math.cos(angle);
                    imag += frameData[n] * Math.sin(angle);
                }
                magnitudes[k] = Math.sqrt(real * real + imag * imag);
            }

            spectrogramData[frame] = magnitudes;
        }

        // Find max magnitude for normalization
        let maxMag = 0;
        for (let frame = 0; frame < numFrames; frame++) {
            for (let bin = 0; bin < freqBins; bin++) {
                if (spectrogramData[frame][bin] > maxMag) {
                    maxMag = spectrogramData[frame][bin];
                }
            }
        }

        // Draw spectrogram
        const timeStep = width / numFrames;
        const freqStep = height / freqBins;

        for (let frame = 0; frame < numFrames; frame++) {
            for (let bin = 0; bin < freqBins; bin++) {
                const magnitude = spectrogramData[frame][bin];
                const normalized = maxMag > 0 ? magnitude / maxMag : 0;

                // Apply logarithmic scaling for better visualization
                const dbValue = normalized > 0 ? 20 * Math.log10(normalized + 1e-10) : -100;
                const intensity = Math.max(0, Math.min(1, (dbValue + 60) / 60)); // -60dB to 0dB range

                // Color mapping: blue (low) -> cyan -> green -> yellow -> red (high)
                let r, g, b;
                if (intensity < 0.25) {
                    const t = intensity * 4;
                    r = 0;
                    g = Math.floor(t * 128);
                    b = Math.floor(128 + t * 127);
                } else if (intensity < 0.5) {
                    const t = (intensity - 0.25) * 4;
                    r = 0;
                    g = Math.floor(128 + t * 127);
                    b = Math.floor(255 - t * 127);
                } else if (intensity < 0.75) {
                    const t = (intensity - 0.5) * 4;
                    r = Math.floor(t * 255);
                    g = 255;
                    b = 0;
                } else {
                    const t = (intensity - 0.75) * 4;
                    r = 255;
                    g = Math.floor(255 - t * 128);
                    b = 0;
                }

                ctx.fillStyle = `rgb(${r}, ${g}, ${b})`;
                ctx.fillRect(
                    frame * timeStep,
                    height - (bin + 1) * freqStep,
                    Math.ceil(timeStep) + 1,
                    Math.ceil(freqStep) + 1
                );
            }
        }

        // Add frequency labels
        ctx.fillStyle = 'rgba(255, 255, 255, 0.5)';
        ctx.font = '10px monospace';
        ctx.textAlign = 'right';

        const sampleRate = audioBuffer.sampleRate;
        const labelFreqs = [0, 1000, 2000, 5000, 10000, 20000];
        labelFreqs.forEach(freq => {
            if (freq <= sampleRate / 2) {
                const y = height - (freq / (sampleRate / 2)) * height;
                ctx.fillText(`${freq / 1000}kHz`, width - 5, y);
            }
        });
    }
}

    // ========================================================================
    // LIVE VISUALIZATION (Real-time during playback)
    // ========================================================================

    startLiveVisualization(audioContext, canvas, analyserNode = null) {
        if (!analyserNode) {
            console.error('AnalyserNode required for live visualization');
            return null;
        }

        const ctx = canvas.getContext('2d');
        const width = canvas.width;
        const height = canvas.height;

        const bufferLength = analyserNode.frequencyBinCount;
        const dataArray = new Uint8Array(bufferLength);

        const draw = () => {
            const animationId = requestAnimationFrame(draw);

            analyserNode.getByteFrequencyData(dataArray);

            // Clear
            ctx.fillStyle = '#0a0e1a';
            ctx.fillRect(0, 0, width, height);

            // Draw bars
            const barWidth = (width / bufferLength) * 2.5;
            let barHeight;
            let x = 0;

            for (let i = 0; i < bufferLength; i++) {
                barHeight = (dataArray[i] / 255) * height * 0.8;

                // Color gradient based on frequency
                const hue = (i / bufferLength) * 360;
                ctx.fillStyle = `hsl(${hue}, 100%, 50%)`;

                ctx.fillRect(x, height - barHeight, barWidth, barHeight);
                x += barWidth + 1;
            }

            return animationId;
        };

        return draw();
    }

    stopLiveVisualization(animationId) {
        if (animationId) {
            cancelAnimationFrame(animationId);
        }
    }

    // ========================================================================
    // WAVEFORM PLAYBACK POSITION INDICATOR
    // ========================================================================

    drawWaveformWithPlayhead(audioBuffer, canvas, playbackPosition = 0, color = '#00d9ff') {
        this.drawWaveform(audioBuffer, canvas, color);

        const ctx = canvas.getContext('2d');
        const width = canvas.width;
        const height = canvas.height;

        // Draw playhead
        const x = (playbackPosition / audioBuffer.duration) * width;
        ctx.strokeStyle = '#ff0080';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(x, 0);
        ctx.lineTo(x, height);
        ctx.stroke();

        // Draw time markers
        ctx.fillStyle = 'rgba(255, 255, 255, 0.5)';
        ctx.font = '10px monospace';
        ctx.textAlign = 'center';

        const duration = audioBuffer.duration;
        const markerInterval = duration > 2 ? 0.5 : 0.1;

        for (let t = 0; t <= duration; t += markerInterval) {
            const markerX = (t / duration) * width;
            ctx.fillText(`${t.toFixed(1)}s`, markerX, height - 5);
        }
    }
}

// Export
if (typeof module !== 'undefined' && module.exports) {
    module.exports = AudioExporter;
}
