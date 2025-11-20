// ============================================================================
// PARAMETER MANAGER - Central Parameter Control System
// ============================================================================
// Manages all 220+ procedural generation parameters with variance support

class ParameterManager {
    constructor(parameterDefinitions) {
        this.definitions = parameterDefinitions;
        this.currentValues = {};
        this.varianceRanges = {};
        this.listeners = [];

        this.initializeDefaults();
    }

    // ========================================================================
    // INITIALIZATION
    // ========================================================================

    initializeDefaults() {
        // Flatten nested parameter structure
        for (const [categoryName, category] of Object.entries(this.definitions.categories || {})) {
            for (const [paramKey, paramDef] of Object.entries(category.parameters)) {
                this.currentValues[paramKey] = paramDef.default;
                this.varianceRanges[paramKey] = {
                    min: paramDef.variance_min || 0,
                    max: paramDef.variance_max || 0
                };
            }
        }
    }

    // ========================================================================
    // PARAMETER ACCESS
    // ========================================================================

    /**
     * Get parameter definition
     * @param {string} key - Parameter key
     * @returns {object} Parameter definition
     */
    getDefinition(key) {
        for (const category of Object.values(this.definitions.categories || {})) {
            if (category.parameters[key]) {
                return category.parameters[key];
            }
        }
        return null;
    }

    /**
     * Get current parameter value
     * @param {string} key - Parameter key
     * @returns {*} Parameter value
     */
    getValue(key) {
        return this.currentValues[key];
    }

    /**
     * Set parameter value
     * @param {string} key - Parameter key
     * @param {*} value - New value
     * @param {boolean} notify - Trigger listeners
     */
    setValue(key, value, notify = true) {
        const def = this.getDefinition(key);
        if (!def) {
            console.warn(`Unknown parameter: ${key}`);
            return;
        }

        // Type validation and clamping
        let validatedValue = value;

        if (def.type === 'float' || def.type === 'int') {
            validatedValue = Math.max(def.min, Math.min(def.max, value));
            if (def.type === 'int') {
                validatedValue = Math.round(validatedValue);
            }
        } else if (def.type === 'enum') {
            if (!def.values.includes(value)) {
                console.warn(`Invalid enum value for ${key}: ${value}`);
                return;
            }
        } else if (def.type === 'bool') {
            validatedValue = Boolean(value);
        }

        this.currentValues[key] = validatedValue;

        if (notify) {
            this.notifyListeners(key, validatedValue);
        }
    }

    /**
     * Set multiple parameters at once
     * @param {object} values - Key-value pairs
     */
    setMultiple(values) {
        for (const [key, value] of Object.entries(values)) {
            this.setValue(key, value, false);
        }
        this.notifyListeners('*', values);
    }

    /**
     * Get randomized value with variance
     * @param {string} key - Parameter key
     * @param {SeededRandom} rng - Random number generator
     * @returns {*} Randomized value
     */
    getRandomizedValue(key, rng) {
        const baseValue = this.currentValues[key];
        const def = this.getDefinition(key);
        const variance = this.varianceRanges[key];

        if (!def || !variance) return baseValue;

        // Skip randomization for enums and bools
        if (def.type === 'enum' || def.type === 'bool') {
            return baseValue;
        }

        // Apply variance
        const varianceAmount = rng.nextFloat(variance.min, variance.max);
        let result = baseValue + varianceAmount;

        // Clamp to parameter bounds
        result = Math.max(def.min, Math.min(def.max, result));

        // Round for integers
        if (def.type === 'int') {
            result = Math.round(result);
        }

        return result;
    }

    /**
     * Get all randomized values
     * @param {SeededRandom} rng - Random number generator
     * @returns {object} All parameter values with variance applied
     */
    getAllRandomized(rng) {
        const result = {};
        for (const key of Object.keys(this.currentValues)) {
            result[key] = this.getRandomizedValue(key, rng);
        }
        return result;
    }

    // ========================================================================
    // VARIANCE MANAGEMENT
    // ========================================================================

    /**
     * Get variance range for parameter
     * @param {string} key - Parameter key
     * @returns {object} {min, max} variance range
     */
    getVarianceRange(key) {
        return this.varianceRanges[key];
    }

    /**
     * Set variance range for parameter
     * @param {string} key - Parameter key
     * @param {number} min - Minimum variance
     * @param {number} max - Maximum variance
     */
    setVarianceRange(key, min, max) {
        this.varianceRanges[key] = { min, max };
        this.notifyListeners(`variance:${key}`, { min, max });
    }

    // ========================================================================
    // PRESETS
    // ========================================================================

    /**
     * Load preset configuration
     * @param {string} presetName - Name of preset in definitions
     */
    loadPreset(presetName) {
        const preset = this.definitions.tier_presets?.[presetName];
        if (!preset) {
            console.error(`Preset not found: ${presetName}`);
            return;
        }

        // Flatten preset structure
        const flatValues = {};
        for (const [categoryName, categoryValues] of Object.entries(preset)) {
            Object.assign(flatValues, categoryValues);
        }

        this.setMultiple(flatValues);
    }

    /**
     * Get all available presets
     * @returns {Array<string>} Preset names
     */
    getPresetNames() {
        return Object.keys(this.definitions.tier_presets || {});
    }

    // ========================================================================
    // EXPORT/IMPORT
    // ========================================================================

    /**
     * Export current configuration to JSON
     * @returns {string} JSON string
     */
    exportJSON() {
        return JSON.stringify({
            values: this.currentValues,
            variance: this.varianceRanges
        }, null, 2);
    }

    /**
     * Import configuration from JSON
     * @param {string} jsonString - JSON configuration
     */
    importJSON(jsonString) {
        try {
            const data = JSON.parse(jsonString);
            if (data.values) {
                this.setMultiple(data.values);
            }
            if (data.variance) {
                this.varianceRanges = data.variance;
            }
        } catch (error) {
            console.error('Failed to import JSON:', error);
        }
    }

    // ========================================================================
    // CHANGE LISTENERS
    // ========================================================================

    /**
     * Register change listener
     * @param {function} callback - Function to call on changes
     */
    addListener(callback) {
        this.listeners.push(callback);
    }

    /**
     * Remove change listener
     * @param {function} callback - Callback to remove
     */
    removeListener(callback) {
        const index = this.listeners.indexOf(callback);
        if (index > -1) {
            this.listeners.splice(index, 1);
        }
    }

    /**
     * Notify all listeners of changes
     * @param {string} key - Changed parameter key (* for multiple)
     * @param {*} value - New value
     */
    notifyListeners(key, value) {
        for (const listener of this.listeners) {
            listener(key, value);
        }
    }

    // ========================================================================
    // UI GENERATION
    // ========================================================================

    /**
     * Generate HTML for parameter controls
     * @param {HTMLElement} container - Container element
     */
    generateUI(container) {
        container.innerHTML = '';

        for (const [categoryName, category] of Object.entries(this.definitions.categories)) {
            const categoryDiv = this.createCategoryUI(categoryName, category);
            container.appendChild(categoryDiv);
        }
    }

    createCategoryUI(categoryName, category) {
        const div = document.createElement('div');
        div.className = 'param-category';
        div.dataset.category = categoryName;

        const header = document.createElement('h3');
        header.className = 'category-header';
        const paramCount = Object.keys(category.parameters).length;
        header.innerHTML = `${category.description || categoryName} (${paramCount} Parameters) <span class="toggle">▼</span>`;

        header.addEventListener('click', () => {
            paramGroup.style.display = paramGroup.style.display === 'none' ? 'block' : 'none';
            header.querySelector('.toggle').textContent = paramGroup.style.display === 'none' ? '▶' : '▼';
        });

        const paramGroup = document.createElement('div');
        paramGroup.className = 'param-group';

        for (const [key, def] of Object.entries(category.parameters)) {
            const control = this.createParameterControl(key, def);
            paramGroup.appendChild(control);
        }

        div.appendChild(header);
        div.appendChild(paramGroup);

        return div;
    }

    createParameterControl(key, def) {
        const row = document.createElement('div');
        row.className = 'param-row';

        const label = document.createElement('label');
        label.textContent = def.description || key;

        let input;

        if (def.type === 'enum') {
            input = document.createElement('select');
            input.id = key;
            def.values.forEach(val => {
                const option = document.createElement('option');
                option.value = val;
                option.textContent = val;
                option.selected = val === def.default;
                input.appendChild(option);
            });
        } else if (def.type === 'bool') {
            input = document.createElement('input');
            input.type = 'checkbox';
            input.id = key;
            input.checked = def.default;
        } else {
            const sliderGroup = document.createElement('div');
            sliderGroup.className = 'slider-group';

            input = document.createElement('input');
            input.type = 'range';
            input.id = key;
            input.min = def.min;
            input.max = def.max;
            input.step = def.type === 'int' ? 1 : 0.01;
            input.value = def.default;

            const valueSpan = document.createElement('span');
            valueSpan.className = 'value';
            valueSpan.id = `${key}_value`;
            valueSpan.textContent = def.default;

            const varianceBtn = document.createElement('button');
            varianceBtn.className = 'variance-toggle';
            varianceBtn.textContent = '±';
            varianceBtn.dataset.param = key;

            sliderGroup.appendChild(input);
            sliderGroup.appendChild(valueSpan);
            sliderGroup.appendChild(varianceBtn);

            row.appendChild(label);
            row.appendChild(sliderGroup);

            // Event listeners
            input.addEventListener('input', (e) => {
                const value = def.type === 'int' ? parseInt(e.target.value) : parseFloat(e.target.value);
                this.setValue(key, value);
                valueSpan.textContent = value;
            });

            return row;
        }

        input.addEventListener('change', (e) => {
            const value = def.type === 'bool' ? e.target.checked : e.target.value;
            this.setValue(key, value);
        });

        row.appendChild(label);
        row.appendChild(input);

        return row;
    }
}

// ============================================================================
// EXPORTS
// ============================================================================

if (typeof module !== 'undefined' && module.exports) {
    module.exports = ParameterManager;
}
