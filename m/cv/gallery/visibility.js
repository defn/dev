/**
 * Visibility Utilities
 * Consolidated viewport and image visibility detection functions
 * Eliminates duplicate implementations scattered throughout the codebase
 */

/**
 * Check if an element is fully visible within the viewport
 * @param {HTMLElement} element - Element to check
 * @returns {boolean} True if completely within viewport
 */
export function isFullyVisible(element) {
  const rect = element.getBoundingClientRect();
  return (
    rect.top >= 0 &&
    rect.left >= 0 &&
    rect.bottom <= window.innerHeight &&
    rect.right <= window.innerWidth
  );
}

/**
 * Check if an element is at least partially visible in the viewport
 * @param {HTMLElement} element - Element to check
 * @returns {boolean} True if any part is visible
 */
export function isVisible(element) {
  const rect = element.getBoundingClientRect();
  return rect.top < window.innerHeight && rect.bottom > 0;
}

/**
 * Check if an element is partially visible with top showing but bottom cut off
 * @param {HTMLElement} element - Element to check
 * @returns {boolean} True if partially visible at bottom of viewport
 */
export function isPartiallyVisibleAtBottom(element) {
  const rect = element.getBoundingClientRect();
  return (
    rect.top > 0 &&
    rect.top < window.innerHeight &&
    rect.bottom > window.innerHeight
  );
}

/**
 * Check if page has scrolled to the bottom
 * @param {number} tolerance - Pixel tolerance for bottom detection
 * @returns {boolean} True if at or near page bottom
 */
export function isAtPageBottom(tolerance = 5) {
  const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
  const scrollHeight = document.documentElement.scrollHeight;
  return scrollTop + window.innerHeight >= scrollHeight - tolerance;
}

/**
 * Get all images that are currently visible in the viewport
 * @returns {HTMLImageElement[]} Array of visible images
 */
export function getVisibleImages() {
  const images = Array.from(document.querySelectorAll("img"));
  return images.filter((img) => isVisible(img));
}

/**
 * Get all images that are fully visible in the viewport
 * @returns {HTMLImageElement[]} Array of fully visible images
 */
export function getFullyVisibleImages() {
  const images = Array.from(document.querySelectorAll("img"));
  return images.filter((img) => isFullyVisible(img));
}

/**
 * Count visible images excluding failed ones
 * @returns {number} Count of visible, non-failed images
 */
export function countVisibleImages() {
  const images = document.querySelectorAll("img");
  let visibleCount = 0;
  let failedCount = 0;
  const viewportTop = window.pageYOffset;
  const viewportBottom = viewportTop + window.innerHeight;

  images.forEach((img) => {
    const rect = img.getBoundingClientRect();
    const imgTop = rect.top + window.pageYOffset;
    const imgBottom = imgTop + rect.height;

    if (imgBottom > viewportTop && imgTop < viewportBottom) {
      if (img.classList.contains("load-failed")) {
        failedCount++;
      } else {
        visibleCount++;
      }
    }
  });

  return visibleCount;
}

/**
 * Check if all images in viewport are loaded
 * @returns {boolean} True if all viewport images are loaded
 */
export function areAllViewportImagesLoaded() {
  const images = document.querySelectorAll("img");
  let allLoaded = true;
  let loadingCount = 0;

  images.forEach((img) => {
    if (isFullyVisible(img)) {
      if (img.classList.contains("load-failed")) {
        return; // Skip failed images
      }
      if (!img.complete || img.naturalHeight === 0) {
        allLoaded = false;
        loadingCount++;
      }
    }
  });

  return allLoaded;
}

/**
 * Get scroll percentage through the document
 * @returns {number} Percentage scrolled (0-1)
 */
export function getScrollPercentage() {
  const scrollPosition = window.pageYOffset;
  const documentHeight = Math.max(
    document.body.scrollHeight,
    document.documentElement.scrollHeight,
  );
  const viewportHeight = window.innerHeight;
  return scrollPosition / (documentHeight - viewportHeight);
}

/**
 * Find image closest to a given viewport position
 * @param {string} position - 'top' or 'bottom'
 * @returns {HTMLImageElement|null} Closest image or null
 */
export function findClosestImageTo(position = "bottom") {
  const images = Array.from(document.querySelectorAll("img"));
  const viewportHeight = window.innerHeight;
  let closestImage = null;
  let minDistance = Infinity;

  images.forEach((img) => {
    const rect = img.getBoundingClientRect();
    if (rect.top >= 0 && rect.top <= viewportHeight) {
      const distance =
        position === "bottom"
          ? Math.abs(viewportHeight - rect.top)
          : Math.abs(rect.top);

      if (distance < minDistance) {
        minDistance = distance;
        closestImage = img;
      }
    }
  });

  return closestImage;
}
