/**
 * Gallery Main Entry Point
 * Orchestrates all gallery modules and initializes the application
 *
 * USAGE:
 * In your HTML, define window.galleryConfig and window.images before loading this module:
 *
 *   <script>
 *     window.images = [{ filename: "image.jpg", width: 400, height: 300 }, ...];
 *     window.blurhashIndex = { ... };  // Optional
 *     window.galleryConfig = {
 *       images: { thumbPath: 'path/to/thumbs' },
 *       click: { mode: 'toggle' },
 *     };
 *   </script>
 *   <script type="module" src="/gallery/index.js"></script>
 */

import { state, initState, getTotalPagesFromMeta } from "./state.js";
import { generateGrid } from "./grid.js";
import { LazyLoader } from "./lazy-loader.js";
import { AutoscrollController } from "./autoscroll.js";
import { NavigationController } from "./navigation.js";
import {
  setupKeyboardHandlers,
  setupWheelHandler,
  setupScrollHandler,
  setupResizeHandler,
} from "./input.js";
import { getScrollPercentage } from "./visibility.js";

/**
 * Initialize the gallery application
 * @param {Object} config - Configuration from HTML page
 * @param {Array} config.images - Array of image objects
 * @param {Object} config.blurhashIndex - Blurhash lookup table (optional)
 * @param {Object} config.galleryConfig - Gallery configuration object
 */
export function initGallery(config) {
  // Initialize state from config
  initState(config);
  state.totalPages = getTotalPagesFromMeta();

  // Set body margin to zero
  document.body.style.margin = "0";

  // Create controllers
  const navigation = new NavigationController(document.body);
  const autoscroll = new AutoscrollController({
    onNavigate: (url) => navigation.navigateTo(url),
    onCountdownUpdate: (value) => navigation.updateDisplay(value),
    onStateChange: (enabled) => navigation.setAutoscrollState(enabled),
  });

  // Remove external navigation elements (from legacy blurmap.go)
  navigation.removeExternalNavigationElements();

  // Setup MutationObserver to keep removing external nav elements
  const observer = new MutationObserver(() => {
    navigation.removeExternalNavigationElements();
  });
  observer.observe(document.body, { childList: true, subtree: true });

  // Create lazy loader with config-based concurrency
  const loader = new LazyLoader({
    maxConcurrent:
      state.numColumns * state.config.lazyLoad.maxConcurrentMultiplier,
    onImageLoad: () => {
      if (autoscroll.isRunning()) {
        autoscroll.resetTimer();
      }
    },
  });

  // Get table body
  const tableBody = document.getElementById("table-body");

  // Image click handler based on config
  const handleImageClick = (img) => {
    navigation.handleImageClick(img);
  };

  // Generate grid
  generateGrid(tableBody, state.images, handleImageClick, () => {
    navigation.updateDisplay();
  });

  // Start lazy loading after a brief delay
  setTimeout(() => {
    const lazyImages = document.querySelectorAll(".lazyload");
    loader.observe(lazyImages);
  }, 100);

  // Setup input handlers
  if (state.config.navigation.enableKeyboard) {
    setupKeyboardHandlers({
      onToggleAutoscroll: () => {
        const enabled = autoscroll.toggle();
        navigation.setAutoscrollState(enabled);
      },
      onPrevPage: () => {
        if (state.currentPage > 1) {
          navigation.navigateTo(`../${state.currentPage - 1}/`);
        }
      },
      onNextPage: () => {
        if (state.currentPage < state.totalPages) {
          navigation.navigateTo(`../${state.currentPage + 1}/`);
        } else if (state.config.autoscroll.loopToStart) {
          navigation.navigateTo("../1/");
        }
      },
      onShowModal: () => {
        if (state.config.modal.enabled) {
          navigation.showModalImage();
        }
      },
      onCountdownUpdate: (value) => {
        navigation.updateDisplay(value);
      },
    });
  }

  if (state.config.navigation.preventScrollWhileLoading) {
    setupWheelHandler({
      onCountdownUpdate: (value) => {
        navigation.updateDisplay(value);
      },
    });
  }

  setupScrollHandler(() => {
    const scrollPercentage = getScrollPercentage();
    if (state.totalPages > 0) {
      state.relativePage = Math.min(
        Math.max(1, Math.ceil(scrollPercentage * state.totalPages)),
        state.totalPages,
      );
    }
    navigation.updateDisplay();
  });

  setupResizeHandler(() => {
    const documentHeight = Math.max(
      document.body.scrollHeight,
      document.documentElement.scrollHeight,
    );
    const viewportHeight = window.innerHeight;
    state.totalPages = Math.ceil(documentHeight / viewportHeight);

    const scrollPercentage = getScrollPercentage();
    state.relativePage = Math.min(
      Math.max(1, Math.ceil(scrollPercentage * state.totalPages)),
      state.totalPages,
    );

    navigation.updateDisplay();
  });

  // Auto-enable autoscroll based on config
  const shouldEnableAutoscroll =
    state.config.autoscroll.enabled ||
    (state.config.autoscroll.autoEnableWhenNotSelecting &&
      state.config.click.mode !== "select") ||
    (state.config.autoscroll.persistState &&
      sessionStorage.getItem("autoscrollEnabled") === "true");

  if (shouldEnableAutoscroll) {
    setTimeout(() => {
      autoscroll.start();
      navigation.setAutoscrollState(true);
    }, 1500);
  }

  // Return controllers for external access
  return {
    navigation,
    autoscroll,
    loader,
    state,
  };
}

// Auto-initialize when DOM is ready
document.addEventListener("DOMContentLoaded", () => {
  if (window.images && window.galleryConfig) {
    initGallery({
      images: window.images,
      blurhashIndex: window.blurhashIndex || {},
      galleryConfig: window.galleryConfig,
    });
  }
});
