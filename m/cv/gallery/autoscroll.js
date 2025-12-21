/**
 * Autoscroll Controller
 * Manages automatic scrolling with countdown display and page navigation
 */

import { state } from "./state.js";
import {
  countVisibleImages,
  areAllViewportImagesLoaded,
  isAtPageBottom,
} from "./visibility.js";

/**
 * AutoscrollController manages the autoscroll functionality
 */
export class AutoscrollController {
  constructor(options = {}) {
    this.minWait = options.minWait || 3000;
    this.maxWait = options.maxWait || 6000;
    this.secondsPerImage = options.secondsPerImage || 0.8;

    this.onNavigate = options.onNavigate || null;
    this.onCountdownUpdate = options.onCountdownUpdate || null;
    this.onStateChange = options.onStateChange || null;

    this.interval = null;
    this.countdownTimer = null;
    this.imageLoadingChecker = null;
    this.secondsLeft = 0;
    this.countdownActive = false;
    this.singleColumnDelayInProgress = false;
  }

  /**
   * Check if autoscroll is currently running
   * @returns {boolean}
   */
  isRunning() {
    return this.interval !== null;
  }

  /**
   * Start autoscrolling
   */
  start() {
    if (this.interval) return;

    this.countdownActive = false;

    this.interval = setInterval(() => {
      if (areAllViewportImagesLoaded() && !this.countdownActive) {
        this.countdownActive = true;
        this.resetTimer();
      }
    }, 500);

    sessionStorage.setItem("autoscrollEnabled", "true");
    state.autoscrollEnabled = true;

    if (this.onStateChange) this.onStateChange(true);
  }

  /**
   * Stop autoscrolling
   */
  stop() {
    if (this.interval) {
      clearInterval(this.interval);
      this.interval = null;
    }

    if (this.countdownTimer) {
      clearInterval(this.countdownTimer);
      this.countdownTimer = null;
    }

    if (this.imageLoadingChecker) {
      clearInterval(this.imageLoadingChecker);
      this.imageLoadingChecker = null;
    }

    state.countdownValue = null;
    state.autoscrollEnabled = false;
    this.countdownActive = false;

    sessionStorage.setItem("autoscrollEnabled", "false");

    if (this.onStateChange) this.onStateChange(false);
    if (this.onCountdownUpdate) this.onCountdownUpdate(null);
  }

  /**
   * Toggle autoscroll on/off
   * @returns {boolean} New state
   */
  toggle() {
    if (this.isRunning()) {
      this.stop();
      return false;
    } else {
      this.start();
      return true;
    }
  }

  /**
   * Calculate wait time based on visible images
   * @returns {number} Wait time in milliseconds
   */
  calculateWaitTime() {
    const visibleImages = countVisibleImages();
    const imagesPerColumn = Math.ceil(visibleImages / state.numColumns);

    let waitTime = Math.round(imagesPerColumn * this.secondsPerImage * 1000);

    // Clamp to min/max
    if (waitTime < this.minWait) waitTime = this.minWait;
    if (waitTime > this.maxWait) waitTime = this.maxWait;

    return waitTime;
  }

  /**
   * Reset the autoscroll timer
   */
  resetTimer() {
    if (!this.interval) return;

    const waitTime = this.calculateWaitTime();
    this.secondsLeft = waitTime / 1000;

    if (this.countdownTimer) clearInterval(this.countdownTimer);

    const updateCountdown = () => {
      state.countdownValue = Math.ceil(this.secondsLeft);
      if (this.onCountdownUpdate) {
        this.onCountdownUpdate(state.countdownValue);
      }

      this.secondsLeft -= 1;

      if (this.secondsLeft <= 0) {
        clearInterval(this.countdownTimer);
        this.countdownTimer = null;

        const success = this.performScroll();

        if (success) {
          setTimeout(() => {
            if (this.interval) {
              this.countdownActive = false;
            }
          }, 1000);
        }
      }
    };

    updateCountdown();
    this.countdownTimer = setInterval(updateCountdown, 1000);

    // Clear and reset main interval
    clearInterval(this.interval);
    this.interval = setInterval(() => {
      if (areAllViewportImagesLoaded() && !this.countdownActive) {
        this.countdownActive = true;
        this.resetTimer();
      }
    }, 500);

    // Image loading checker
    if (this.imageLoadingChecker) clearInterval(this.imageLoadingChecker);
    this.imageLoadingChecker = setInterval(() => {
      areAllViewportImagesLoaded();
    }, 1000);
  }

  /**
   * Create a countdown display for delays
   * @param {number} seconds - Countdown duration
   * @param {string} prefix - Prefix for display (e.g., '+')
   * @param {Function} onComplete - Callback when complete
   */
  createCountdown(seconds, prefix, onComplete) {
    let remaining = seconds;
    const originalValue = state.countdownValue;

    const tick = () => {
      state.countdownValue = `${prefix}${remaining}s`;
      if (this.onCountdownUpdate) {
        this.onCountdownUpdate(state.countdownValue);
      }

      remaining--;

      if (remaining >= 0) {
        setTimeout(tick, 1000);
      } else {
        state.countdownValue = originalValue;
        if (this.onCountdownUpdate) {
          this.onCountdownUpdate(state.countdownValue);
        }
        if (onComplete) onComplete();
      }
    };

    tick();
  }

  /**
   * Perform the scroll action
   * @returns {boolean} True if scroll was performed
   */
  performScroll() {
    // Check if images are loaded
    if (!areAllViewportImagesLoaded()) {
      return false;
    }

    // Handle single column delay
    if (state.numColumns === 1 && !this.singleColumnDelayInProgress) {
      this.singleColumnDelayInProgress = true;

      this.createCountdown(5, "+", () => {
        this.singleColumnDelayInProgress = false;
        this.performScroll();
      });

      return false;
    }

    this.singleColumnDelayInProgress = false;

    // Check if at bottom
    if (isAtPageBottom()) {
      if (state.currentPage < state.totalPages) {
        sessionStorage.setItem("autoscrollEnabled", "true");
        if (this.onNavigate) {
          this.onNavigate(`../${state.currentPage + 1}/`);
        }
        return true;
      } else {
        sessionStorage.setItem("autoscrollEnabled", "true");
        if (this.onNavigate) {
          this.onNavigate("../1/");
        }
        return true;
      }
    }

    // Perform scroll
    const scrollAmount = window.innerHeight * 0.9;
    window.scrollBy({
      top: scrollAmount,
      behavior: "smooth",
    });

    return true;
  }

  /**
   * Check if should auto-enable based on session storage
   * @returns {boolean}
   */
  static shouldAutoEnable() {
    return sessionStorage.getItem("autoscrollEnabled") === "true";
  }
}
