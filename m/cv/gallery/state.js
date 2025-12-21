/**
 * Gallery State Management
 * Centralized state for the gallery system
 *
 * MIGRATION FROM LEGACY:
 * Old style used separate globals:
 *   window.basePath = "replicate/t2";
 *   window.selectMode = "no";
 *
 * New style uses galleryConfig object:
 *   window.galleryConfig = {
 *     images: { thumbPath: 'replicate/t2' },
 *     click: { mode: 'toggle' },  // was selectMode: 'no' -> 'toggle', 'yes' -> 'select', 'W-gallery' -> 'navigate'
 *   };
 */

import { createConfig } from "./config.js";

/**
 * Gallery runtime state
 */
export const state = {
  // Configuration (merged from defaults + overrides)
  config: null,

  // Image data
  images: [],
  blurhashIndex: {},

  // Grid state
  numColumns: 1,
  standardWidth: 300,

  // Navigation state
  currentPage: 1,
  relativePage: 1,
  totalPages: 0,

  // Autoscroll state
  autoscrollEnabled: false,
  countdownValue: null,
  countdownActive: false,
  singleColumnDelayInProgress: false,

  // Image position tracking
  imagePositionMap: new Map(),
  totalImages: 0,
};

/**
 * Initialize state from page configuration
 * @param {Object} pageConfig - Configuration from HTML page
 * @param {Array} pageConfig.images - Array of image objects
 * @param {Object} pageConfig.blurhashIndex - Blurhash lookup table
 * @param {Object} pageConfig.galleryConfig - Gallery configuration object
 */
export function initState(pageConfig) {
  // Create config from provided galleryConfig or use defaults
  state.config = createConfig(pageConfig.galleryConfig || {});

  // Store image data
  state.images = pageConfig.images || [];
  state.blurhashIndex = pageConfig.blurhashIndex || {};

  // Calculate initial column count based on layout config
  const layout = state.config.layout;
  state.numColumns = Math.max(
    layout.minColumns,
    Math.floor(window.innerWidth / layout.columnWidth),
  );
  if (layout.maxColumns > 0) {
    state.numColumns = Math.min(state.numColumns, layout.maxColumns);
  }
  state.standardWidth =
    Math.floor(window.innerWidth / state.numColumns) - layout.imageGap;

  // Extract page number from URL
  state.currentPage = getPageNumberFromURL();
}

/**
 * Extract page number from current URL path
 * @returns {number} Page number (defaults to 1)
 */
function getPageNumberFromURL() {
  try {
    const pathParts = window.location.pathname
      .split("/")
      .filter((p) => p.length > 0);
    for (let i = 0; i < pathParts.length; i++) {
      const num = parseInt(pathParts[i]);
      if (!isNaN(num)) {
        return num;
      }
    }
  } catch (e) {
    console.error("Error parsing URL for page number:", e);
  }
  return 1;
}

/**
 * Get total pages from meta tag or default
 * @returns {number} Total page count
 */
export function getTotalPagesFromMeta() {
  const metaTotalChunks = document.querySelector('meta[name="total-chunks"]');
  if (metaTotalChunks && metaTotalChunks.content) {
    return parseInt(metaTotalChunks.content) || 100;
  }
  return 100;
}

/**
 * Get the image base path based on current column count
 * Uses fullPath for single column (high-res), thumbPath otherwise
 * @returns {string} Image base path
 */
export function getImageBasePath() {
  if (state.numColumns === 1) {
    return state.config.images.fullPath;
  }
  return state.config.images.thumbPath;
}
