/**
 * Gallery Configuration
 * Parameterized configuration struct for gallery modes and behaviors
 *
 * MIGRATION FROM LEGACY:
 * ----------------------
 * Old: selectMode = "no"      -> New: click.mode = "toggle"
 * Old: selectMode = "yes"     -> New: click.mode = "select"
 * Old: selectMode = "W-gallery" -> New: click.mode = "navigate", modal.enabled = true
 * Old: basePath = "replicate/t2" -> New: images.thumbPath = "replicate/t2"
 */

/**
 * Default gallery configuration
 * @type {GalleryConfig}
 */
export const DEFAULT_CONFIG = {
  // ===== IMAGE SOURCES =====
  images: {
    /** Base path for thumbnail images */
    thumbPath: "replicate/t2",
    /** Base path for full-size images (used in single column mode) */
    fullPath: "/replicate/img",
  },

  // ===== GRID LAYOUT =====
  layout: {
    /** Target width per column in pixels */
    columnWidth: 330,
    /** Minimum number of columns */
    minColumns: 1,
    /** Maximum number of columns (0 = unlimited) */
    maxColumns: 0,
    /** Gap between images in pixels */
    imageGap: 5,
    /** Whether to equalize column heights */
    equalizeHeights: true,
  },

  // ===== CLICK BEHAVIOR =====
  click: {
    /**
     * Click mode determines what happens when an image is clicked
     * - 'toggle': Toggle blurhash overlay on/off
     * - 'select': Toggle selection and send to server
     * - 'navigate': Navigate to image detail page
     * - 'custom': Call custom onClick handler
     */
    mode: "toggle",
    /** URL pattern for 'navigate' mode (use {filename}, {uuid}, {page} placeholders) */
    navigateUrlPattern: "../../../W/{uuid}.html?page={page}#{filename}",
    /** Server endpoint for 'select' mode */
    selectEndpoint: "/select-yes",
    /** Custom click handler function (for 'custom' mode) */
    customHandler: null,
  },

  // ===== AUTOSCROLL =====
  autoscroll: {
    /** Whether autoscroll is enabled by default */
    enabled: false,
    /** Auto-enable when click mode is not 'select' */
    autoEnableWhenNotSelecting: true,
    /** Seconds to wait per visible image */
    secondsPerImage: 0.8,
    /** Minimum wait time in milliseconds */
    minWaitMs: 3000,
    /** Maximum wait time in milliseconds */
    maxWaitMs: 6000,
    /** Additional delay for single column mode in seconds */
    singleColumnDelaySec: 5,
    /** Whether to loop back to first page at end */
    loopToStart: true,
    /** Persist autoscroll state in session storage */
    persistState: true,
  },

  // ===== LAZY LOADING =====
  lazyLoad: {
    /** Maximum concurrent image loads (multiplied by column count) */
    maxConcurrentMultiplier: 3,
    /** Number of retry attempts for failed images */
    retryAttempts: 3,
    /** Delay between retries in milliseconds */
    retryDelayMs: 500,
  },

  // ===== NAVIGATION UI =====
  navigation: {
    /** Show navigation overlay */
    showOverlay: true,
    /** Position of navigation overlay */
    position: "bottom-right",
    /** Show countdown timer */
    showCountdown: true,
    /** Show page numbers */
    showPageNumbers: true,
    /** Enable keyboard navigation */
    enableKeyboard: true,
    /** Enable wheel scroll prevention while loading */
    preventScrollWhileLoading: true,
  },

  // ===== VISUAL STYLE =====
  style: {
    /** Background color */
    backgroundColor: "black",
    /** Fallback color when blurhash unavailable */
    fallbackColor: "#FF8C00",
    /** Image fade-in duration in milliseconds */
    fadeInDuration: 500,
    /** Border between columns */
    columnBorder: "1px solid #000",
  },

  // ===== BLURHASH =====
  blurhash: {
    /** Enable blurhash placeholders */
    enabled: true,
    /** Blurhash grid dimension (20 = 20x20 grid) */
    gridDimension: 20,
    /** Apply contrast/saturation enhancements */
    applyEnhancements: true,
  },

  // ===== MODAL (for navigate mode) =====
  modal: {
    /** Enable modal image view */
    enabled: false,
    /** Modal image URL pattern */
    imageUrlPattern: "../../../fm/{prefix}.png",
    /** Keyboard shortcut to open modal */
    shortcutKey: "x",
  },
};

/**
 * Preset configurations for common gallery modes
 */
export const PRESETS = {
  /**
   * Standard browsing mode - toggle blurhash on click, autoscroll available
   */
  browse: {
    click: { mode: "toggle" },
    autoscroll: { enabled: false, autoEnableWhenNotSelecting: true },
    modal: { enabled: false },
  },

  /**
   * Selection mode - click to select images, send to server
   */
  select: {
    click: { mode: "select" },
    autoscroll: { enabled: false, autoEnableWhenNotSelecting: false },
    modal: { enabled: false },
  },

  /**
   * Navigate mode - click navigates to detail page, modal available
   */
  navigate: {
    click: { mode: "navigate" },
    autoscroll: { enabled: false, autoEnableWhenNotSelecting: false },
    modal: { enabled: true },
  },

  /**
   * Kiosk mode - autoscroll always on, minimal interaction
   */
  kiosk: {
    click: { mode: "toggle" },
    autoscroll: { enabled: true, autoEnableWhenNotSelecting: true },
    navigation: { enableKeyboard: false },
  },

  /**
   * Single column mode - optimized for mobile/narrow screens
   */
  singleColumn: {
    layout: { maxColumns: 1 },
  },
};

/**
 * Create a gallery configuration by merging defaults with overrides
 * @param {Partial<GalleryConfig>} overrides - Configuration overrides
 * @param {string[]} presets - Array of preset names to apply
 * @returns {GalleryConfig} Complete configuration
 */
export function createConfig(overrides = {}, presets = []) {
  // Start with defaults
  let config = deepClone(DEFAULT_CONFIG);

  // Apply presets in order
  for (const presetName of presets) {
    const preset = PRESETS[presetName];
    if (preset) {
      config = deepMerge(config, preset);
    }
  }

  // Apply overrides
  config = deepMerge(config, overrides);

  return config;
}

/**
 * Deep clone an object
 * @param {Object} obj - Object to clone
 * @returns {Object} Cloned object
 */
function deepClone(obj) {
  return JSON.parse(JSON.stringify(obj));
}

/**
 * Deep merge two objects
 * @param {Object} target - Target object
 * @param {Object} source - Source object
 * @returns {Object} Merged object
 */
function deepMerge(target, source) {
  const result = { ...target };

  for (const key in source) {
    if (Object.prototype.hasOwnProperty.call(source, key)) {
      if (
        source[key] &&
        typeof source[key] === "object" &&
        !Array.isArray(source[key]) &&
        source[key] !== null
      ) {
        result[key] = deepMerge(target[key] || {}, source[key]);
      } else {
        result[key] = source[key];
      }
    }
  }

  return result;
}

/**
 * @typedef {Object} GalleryConfig
 * @property {ImageConfig} images - Image source configuration
 * @property {LayoutConfig} layout - Grid layout configuration
 * @property {ClickConfig} click - Click behavior configuration
 * @property {AutoscrollConfig} autoscroll - Autoscroll configuration
 * @property {LazyLoadConfig} lazyLoad - Lazy loading configuration
 * @property {NavigationConfig} navigation - Navigation UI configuration
 * @property {StyleConfig} style - Visual style configuration
 * @property {BlurhashConfig} blurhash - Blurhash configuration
 * @property {ModalConfig} modal - Modal configuration
 */
