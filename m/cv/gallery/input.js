/**
 * Input Handlers
 * Manages keyboard and mouse/wheel event handling
 */

import { state } from "./state.js";
import { areAllViewportImagesLoaded } from "./visibility.js";

/**
 * Setup keyboard event handlers
 * @param {Object} handlers - Handler callbacks
 * @param {Function} handlers.onToggleAutoscroll - Toggle autoscroll
 * @param {Function} handlers.onPrevPage - Navigate to previous page
 * @param {Function} handlers.onNextPage - Navigate to next page
 * @param {Function} handlers.onShowModal - Show modal (W-gallery mode)
 * @param {Function} handlers.onSpaceScroll - Handle space key scroll
 */
export function setupKeyboardHandlers(handlers) {
  let manualSpaceDelay = false;

  document.addEventListener("keydown", (event) => {
    // 's' key - toggle autoscroll
    if (event.key === "s" || event.key === "S") {
      event.preventDefault();
      if (handlers.onToggleAutoscroll) handlers.onToggleAutoscroll();
      return;
    }

    // 'x' key - show modal image for W-gallery mode
    if (event.key === "x" || event.key === "X") {
      if (state.selectMode === "W-gallery" && handlers.onShowModal) {
        event.preventDefault();
        handlers.onShowModal();
        return;
      }
    }

    // Left arrow or 'a' - previous page
    if (event.key === "ArrowLeft" || event.key === "a" || event.key === "A") {
      if (state.currentPage > 1 && handlers.onPrevPage) {
        handlers.onPrevPage();
      }
      return;
    }

    // Right arrow or 'd' - next page
    if (event.key === "ArrowRight" || event.key === "d" || event.key === "D") {
      if (handlers.onNextPage) {
        handlers.onNextPage();
      }
      return;
    }

    // Space key - scroll with loading check
    if (event.key === " " || event.keyCode === 32) {
      if (!areAllViewportImagesLoaded()) {
        event.preventDefault();
        return;
      }

      // Single column delay
      if (state.numColumns === 1 && !manualSpaceDelay) {
        event.preventDefault();
        manualSpaceDelay = true;

        createDelayCountdown(5, "+", handlers.onCountdownUpdate, () => {
          manualSpaceDelay = false;
        });
        return;
      }

      manualSpaceDelay = false;

      if (handlers.onSpaceScroll) {
        handlers.onSpaceScroll();
      }
    }
  });
}

/**
 * Setup wheel event handler
 * @param {Object} handlers - Handler callbacks
 * @param {Function} handlers.onCountdownUpdate - Update countdown display
 */
export function setupWheelHandler(handlers) {
  let wheelScrollDelay = false;

  document.addEventListener(
    "wheel",
    (event) => {
      // Prevent scrolling if images are still loading
      if (!areAllViewportImagesLoaded()) {
        event.preventDefault();
        return;
      }

      // Add delay for single column mode
      if (state.numColumns === 1 && !wheelScrollDelay) {
        event.preventDefault();
        wheelScrollDelay = true;

        createDelayCountdown(5, "+", handlers.onCountdownUpdate, () => {
          wheelScrollDelay = false;
        });
      }
    },
    { passive: false },
  );
}

/**
 * Create a delay countdown display
 * @param {number} seconds - Countdown duration
 * @param {string} prefix - Display prefix
 * @param {Function} onUpdate - Callback on each tick
 * @param {Function} onComplete - Callback when complete
 */
function createDelayCountdown(seconds, prefix, onUpdate, onComplete) {
  let remaining = seconds;
  const originalValue = state.countdownValue;

  const tick = () => {
    state.countdownValue = `${prefix}${remaining}s`;
    if (onUpdate) onUpdate(state.countdownValue);

    remaining--;

    if (remaining >= 0) {
      setTimeout(tick, 1000);
    } else {
      state.countdownValue = originalValue;
      if (onUpdate) onUpdate(state.countdownValue);
      if (onComplete) onComplete();
    }
  };

  tick();
}

/**
 * Setup scroll handler for navigation updates
 * @param {Function} onScroll - Callback on scroll
 */
export function setupScrollHandler(onScroll) {
  window.addEventListener("scroll", () => {
    if (onScroll) onScroll();
  });
}

/**
 * Setup resize handler for column recalculation
 * @param {Function} onResize - Callback on resize (debounced)
 */
export function setupResizeHandler(onResize) {
  let resizeTimeout = null;

  window.addEventListener("resize", () => {
    if (resizeTimeout) {
      clearTimeout(resizeTimeout);
    }

    resizeTimeout = setTimeout(() => {
      if (onResize) onResize();
    }, 250);
  });
}
