// ============================================================================
// SFX GENERATOR - Procedural Game Sound Effects
// ============================================================================
// Preset sound types for SpaceGameDev: Lasers, Explosions, UI, Engines, etc.

// Sound type presets
const SFX_PRESETS = {
    // ========================================================================
    // WEAPONS
    // ========================================================================

    laser_basic: {
        method: 'pulseWave',
        name: 'Laser (Basic)',
        params: {
            frequency: 440,
            duration: 0.3,
            pulseWidth: 0.5,
            pitchSweep: { startFreq: 800, endFreq: 200 },
            envelope: { attack: 0.001, decay: 0.05, sustain: 0.3, release: 0.1 }
        }
    },

    laser_charged: {
        method: 'additive',
        name: 'Laser (Charged)',
        params: {
            frequency: 220,
            duration: 0.8,
            harmonics: [1, 2, 3, 4],
            harmonicAmplitudes: [0.5, 0.3, 0.2, 0.1],
            envelope: { attack: 0.2, decay: 0.1, sustain: 0.6, release: 0.1 }
        }
    },

    missile_launch: {
        method: 'subtractive',
        name: 'Missile Launch',
        params: {
            duration: 0.5,
            noiseType: 'pink',
            filterType: 'lowpass',
            filterCutoffStart: 4000,
            filterCutoffEnd: 800,
            filterResonance: 5,
            envelope: { attack: 0.01, decay: 0.49 }
        }
    },

    cannon_fire: {
        method: 'physical',
        name: 'Cannon Fire',
        params: {
            force: 1.2,
            material: 'metal',
            duration: 0.3
        }
    },

    plasma_shot: {
        method: 'fm',
        name: 'Plasma Shot',
        params: {
            carrierFreq: 600,
            modulatorFreq: 150,
            modulationIndex: 3.0,
            duration: 0.4,
            envelope: { attack: 0.01, decay: 0.39 }
        }
    },

    // ========================================================================
    // IMPACTS
    // ========================================================================

    explosion_small: {
        method: 'subtractive',
        name: 'Explosion (Small)',
        params: {
            duration: 0.8,
            noiseType: 'white',
            filterType: 'lowpass',
            filterCutoffStart: 8000,
            filterCutoffEnd: 200,
            filterResonance: 8,
            envelope: { attack: 0.01, decay: 0.79 }
        }
    },

    explosion_large: {
        method: 'subtractive',
        name: 'Explosion (Large)',
        params: {
            duration: 1.5,
            noiseType: 'white',
            filterType: 'lowpass',
            filterCutoffStart: 10000,
            filterCutoffEnd: 50,
            filterResonance: 15,
            envelope: { attack: 0.02, decay: 1.48 }
        }
    },

    hull_hit: {
        method: 'physical',
        name: 'Hull Impact',
        params: {
            force: 0.8,
            material: 'metal',
            duration: 0.4
        }
    },

    shield_hit: {
        method: 'fm',
        name: 'Shield Hit',
        params: {
            carrierFreq: 1200,
            modulatorFreq: 400,
            modulationIndex: 2.5,
            duration: 0.3,
            envelope: { attack: 0.005, decay: 0.295 }
        }
    },

    // ========================================================================
    // UI SOUNDS
    // ========================================================================

    ui_click: {
        method: 'fm',
        name: 'UI Click',
        params: {
            carrierFreq: 1000,
            modulatorFreq: 300,
            modulationIndex: 2.0,
            duration: 0.05,
            envelope: { attack: 0.005, decay: 0.045 }
        }
    },

    ui_hover: {
        method: 'pulseWave',
        name: 'UI Hover',
        params: {
            frequency: 800,
            duration: 0.08,
            pulseWidth: 0.3,
            envelope: { attack: 0.01, decay: 0.02, sustain: 0.3, release: 0.04 }
        }
    },

    ui_confirm: {
        method: 'additive',
        name: 'UI Confirm',
        params: {
            frequency: 523, // C5
            duration: 0.2,
            harmonics: [1, 2],
            harmonicAmplitudes: [0.7, 0.3],
            envelope: { attack: 0.01, decay: 0.05, sustain: 0.5, release: 0.1 }
        }
    },

    ui_cancel: {
        method: 'pulseWave',
        name: 'UI Cancel',
        params: {
            frequency: 200,
            duration: 0.15,
            pulseWidth: 0.5,
            envelope: { attack: 0.01, decay: 0.05, sustain: 0.3, release: 0.08 }
        }
    },

    ui_error: {
        method: 'pulseWave',
        name: 'UI Error',
        params: {
            frequency: 150,
            duration: 0.3,
            pulseWidth: 0.5,
            pitchSweep: { startFreq: 200, endFreq: 100 },
            envelope: { attack: 0.01, decay: 0.1, sustain: 0.4, release: 0.1 }
        }
    },

    // ========================================================================
    // ENGINES
    // ========================================================================

    engine_idle: {
        method: 'subtractive',
        name: 'Engine Idle',
        params: {
            duration: 2.0,
            noiseType: 'pink',
            filterType: 'bandpass',
            filterCutoffStart: 150,
            filterCutoffEnd: 180,
            filterResonance: 20,
            envelope: { attack: 0.3, decay: 1.7 }
        }
    },

    engine_thrust: {
        method: 'subtractive',
        name: 'Engine Thrust',
        params: {
            duration: 1.5,
            noiseType: 'white',
            filterType: 'lowpass',
            filterCutoffStart: 2000,
            filterCutoffEnd: 5000,
            filterResonance: 5,
            envelope: { attack: 0.1, decay: 1.4 }
        }
    },

    warp_jump: {
        method: 'pulseWave',
        name: 'Warp Jump',
        params: {
            frequency: 100,
            duration: 2.0,
            pulseWidth: 0.5,
            pitchSweep: { startFreq: 100, endFreq: 2000 },
            envelope: { attack: 0.5, decay: 0.5, sustain: 0.6, release: 0.5 }
        }
    },

    // ========================================================================
    // AMBIENT & MISC
    // ========================================================================

    cargo_pickup: {
        method: 'additive',
        name: 'Cargo Pickup',
        params: {
            frequency: 659, // E5
            duration: 0.25,
            harmonics: [1, 2, 3],
            harmonicAmplitudes: [0.6, 0.3, 0.1],
            envelope: { attack: 0.02, decay: 0.08, sustain: 0.4, release: 0.1 }
        }
    },

    cargo_eject: {
        method: 'pulseWave',
        name: 'Cargo Eject',
        params: {
            frequency: 400,
            duration: 0.3,
            pulseWidth: 0.5,
            pitchSweep: { startFreq: 400, endFreq: 200 },
            envelope: { attack: 0.01, decay: 0.1, sustain: 0.3, release: 0.1 }
        }
    },

    mining_laser: {
        method: 'additive',
        name: 'Mining Laser',
        params: {
            frequency: 320,
            duration: 1.5,
            harmonics: [1, 2, 3, 4, 5],
            harmonicAmplitudes: [0.5, 0.25, 0.15, 0.08, 0.02],
            envelope: { attack: 0.05, decay: 0.2, sustain: 0.7, release: 0.3 }
        }
    },

    ore_depleted: {
        method: 'fm',
        name: 'Ore Depleted',
        params: {
            carrierFreq: 300,
            modulatorFreq: 100,
            modulationIndex: 1.5,
            duration: 0.5,
            envelope: { attack: 0.05, decay: 0.45 }
        }
    },

    autopilot_engage: {
        method: 'additive',
        name: 'Autopilot Engage',
        params: {
            frequency: 440,
            duration: 0.4,
            harmonics: [1, 2],
            harmonicAmplitudes: [0.6, 0.4],
            envelope: { attack: 0.05, decay: 0.1, sustain: 0.5, release: 0.15 }
        }
    },

    alarm_critical: {
        method: 'pulseWave',
        name: 'Alarm (Critical)',
        params: {
            frequency: 800,
            duration: 0.5,
            pulseWidth: 0.5,
            envelope: { attack: 0.01, decay: 0.1, sustain: 0.6, release: 0.1 }
        }
    },

    // ========================================================================
    // 8-BIT RETRO
    // ========================================================================

    retro_jump: {
        method: 'pulseWave',
        name: '8-bit Jump',
        params: {
            frequency: 400,
            duration: 0.3,
            pulseWidth: 0.25,
            pitchSweep: { startFreq: 400, endFreq: 800 },
            envelope: { attack: 0.01, decay: 0.1, sustain: 0.3, release: 0.1 }
        }
    },

    retro_coin: {
        method: 'pulseWave',
        name: '8-bit Coin',
        params: {
            frequency: 988, // B5
            duration: 0.2,
            pulseWidth: 0.125,
            envelope: { attack: 0.01, decay: 0.05, sustain: 0.4, release: 0.1 }
        }
    },

    retro_powerup: {
        method: 'pulseWave',
        name: '8-bit Powerup',
        params: {
            frequency: 523, // C5
            duration: 0.4,
            pulseWidth: 0.25,
            pitchSweep: { startFreq: 523, endFreq: 1047 },
            envelope: { attack: 0.02, decay: 0.1, sustain: 0.5, release: 0.15 }
        }
    }
};

// ============================================================================
// SFX GENERATOR FUNCTION
// ============================================================================

function generateSFX(presetName, synthesisEngine) {
    const preset = SFX_PRESETS[presetName];
    if (!preset) {
        console.error('Unknown SFX preset:', presetName);
        return null;
    }

    // Call appropriate synthesis method
    switch (preset.method) {
        case 'additive':
            return synthesisEngine.generateAdditive(preset.params);
        case 'subtractive':
            return synthesisEngine.generateSubtractive(preset.params);
        case 'fm':
            return synthesisEngine.generateFM(preset.params);
        case 'pulseWave':
            return synthesisEngine.generatePulseWave(preset.params);
        case 'physical':
            return synthesisEngine.generatePhysicalModel(preset.params);
        default:
            console.error('Unknown synthesis method:', preset.method);
            return null;
    }
}

// ============================================================================
// VARIATION GENERATOR
// ============================================================================

function generateSFXVariation(presetName, variationAmount = 0.1, synthesisEngine) {
    const preset = SFX_PRESETS[presetName];
    if (!preset) {
        console.error('Unknown SFX preset:', presetName);
        return null;
    }

    // Clone params
    const variedParams = JSON.parse(JSON.stringify(preset.params));

    // Apply random variations
    if (variedParams.frequency) {
        variedParams.frequency *= (1 + (Math.random() * 2 - 1) * variationAmount);
    }

    if (variedParams.duration) {
        variedParams.duration *= (1 + (Math.random() * 2 - 1) * variationAmount * 0.5);
    }

    if (variedParams.pitchSweep) {
        variedParams.pitchSweep.startFreq *= (1 + (Math.random() * 2 - 1) * variationAmount);
        variedParams.pitchSweep.endFreq *= (1 + (Math.random() * 2 - 1) * variationAmount);
    }

    // Call synthesis method
    switch (preset.method) {
        case 'additive':
            return synthesisEngine.generateAdditive(variedParams);
        case 'subtractive':
            return synthesisEngine.generateSubtractive(variedParams);
        case 'fm':
            return synthesisEngine.generateFM(variedParams);
        case 'pulseWave':
            return synthesisEngine.generatePulseWave(variedParams);
        case 'physical':
            return synthesisEngine.generatePhysicalModel(variedParams);
        default:
            return null;
    }
}

// ============================================================================
// EXPORTS
// ============================================================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        SFX_PRESETS,
        generateSFX,
        generateSFXVariation
    };
}
