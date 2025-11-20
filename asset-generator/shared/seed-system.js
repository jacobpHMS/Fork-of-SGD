// ============================================================================
// SEED SYSTEM - Deterministic Random Number Generation
// ============================================================================
// Ensures reproducible asset generation across sessions
// Uses CRC32 for seed generation from asset identifiers

class SeedSystem {
    constructor() {
        this.crc32Table = this.makeCRC32Table();
    }

    // ========================================================================
    // CRC32 HASH GENERATION
    // ========================================================================

    makeCRC32Table() {
        let c;
        const crcTable = [];

        for (let n = 0; n < 256; n++) {
            c = n;
            for (let k = 0; k < 8; k++) {
                c = ((c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1));
            }
            crcTable[n] = c;
        }
        return crcTable;
    }

    crc32(str) {
        let crc = 0 ^ (-1);

        for (let i = 0; i < str.length; i++) {
            crc = (crc >>> 8) ^ this.crc32Table[(crc ^ str.charCodeAt(i)) & 0xFF];
        }

        return (crc ^ (-1)) >>> 0;
    }

    // ========================================================================
    // SEED GENERATION
    // ========================================================================

    /**
     * Generate deterministic seed from asset identifiers
     * @param {string} assetType - Type of asset (asteroid, projectile, etc.)
     * @param {string} itemID - Database item ID (ORE_T1_001, etc.)
     * @param {string} variant - Variant name (iron, titanium, etc.)
     * @param {number} frame - Frame number for animations (0-7)
     * @returns {number} 32-bit seed value
     */
    generateSeed(assetType, itemID, variant = 'default', frame = 0) {
        const seedString = `${assetType}_${itemID}_${variant}_${frame}`;
        return this.crc32(seedString);
    }

    /**
     * Generate seed from custom string
     * @param {string} customString - Any string to hash
     * @returns {number} 32-bit seed value
     */
    generateFromString(customString) {
        return this.crc32(customString);
    }

    // ========================================================================
    // SEEDED RANDOM NUMBER GENERATOR
    // ========================================================================

    /**
     * Create a seeded random number generator
     * @param {number} seed - Seed value
     * @returns {SeededRandom} Generator instance
     */
    createRNG(seed) {
        return new SeededRandom(seed);
    }
}

// ============================================================================
// SEEDED RANDOM NUMBER GENERATOR
// ============================================================================
// Linear Congruential Generator (LCG) with good distribution

class SeededRandom {
    constructor(seed) {
        this.seed = seed;
        this.state = seed;
    }

    /**
     * Generate next random float in range [0, 1)
     * @returns {number} Random float
     */
    next() {
        // LCG parameters (Numerical Recipes)
        const a = 1664525;
        const c = 1013904223;
        const m = 0x100000000; // 2^32

        this.state = (a * this.state + c) % m;
        return this.state / m;
    }

    /**
     * Random integer in range [min, max]
     * @param {number} min - Minimum value (inclusive)
     * @param {number} max - Maximum value (inclusive)
     * @returns {number} Random integer
     */
    nextInt(min, max) {
        return Math.floor(this.next() * (max - min + 1)) + min;
    }

    /**
     * Random float in range [min, max]
     * @param {number} min - Minimum value
     * @param {number} max - Maximum value
     * @returns {number} Random float
     */
    nextFloat(min, max) {
        return this.next() * (max - min) + min;
    }

    /**
     * Random boolean with given probability
     * @param {number} probability - Probability of true (0.0-1.0)
     * @returns {boolean} Random boolean
     */
    nextBool(probability = 0.5) {
        return this.next() < probability;
    }

    /**
     * Random choice from array
     * @param {Array} array - Array to choose from
     * @returns {*} Random element
     */
    choice(array) {
        return array[this.nextInt(0, array.length - 1)];
    }

    /**
     * Shuffle array in-place (Fisher-Yates)
     * @param {Array} array - Array to shuffle
     * @returns {Array} Shuffled array
     */
    shuffle(array) {
        for (let i = array.length - 1; i > 0; i--) {
            const j = this.nextInt(0, i);
            [array[i], array[j]] = [array[j], array[i]];
        }
        return array;
    }

    /**
     * Gaussian (normal) distribution using Box-Muller transform
     * @param {number} mean - Mean value
     * @param {number} stdDev - Standard deviation
     * @returns {number} Normally distributed value
     */
    nextGaussian(mean = 0, stdDev = 1) {
        const u1 = this.next();
        const u2 = this.next();
        const z0 = Math.sqrt(-2.0 * Math.log(u1)) * Math.cos(2.0 * Math.PI * u2);
        return z0 * stdDev + mean;
    }
}

// ============================================================================
// GLOBAL INSTANCE
// ============================================================================

const GlobalSeedSystem = new SeedSystem();

// ============================================================================
// EXPORTS
// ============================================================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = { SeedSystem, SeededRandom, GlobalSeedSystem };
}
