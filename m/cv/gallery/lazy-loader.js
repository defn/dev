/**
 * Lazy Loading System
 * Manages IntersectionObserver-based image loading with blurhash placeholders
 */

import { state } from "./state.js";
import {
  getBlurhashByFilename,
  renderBlurhashGrid,
  getAspectRatioFromIndex,
  styleCanvasOverlay,
} from "./blurhash.js";
import { isVisible } from "./visibility.js";

/**
 * LazyLoader class manages image loading with prioritization and throttling
 */
export class LazyLoader {
  constructor(options = {}) {
    this.maxConcurrent = options.maxConcurrent || 9;
    this.onImageLoad = options.onImageLoad || null;
    this.onImageError = options.onImageError || null;

    this.inflightRequests = 0;
    this.queue = [];
    this.blurRendered = new Set();

    // Observers
    this.visibleBlurObserver = null;
    this.nearViewportBlurObserver = null;
    this.visibleLoadObserver = null;
    this.upcomingLoadObserver = null;
  }

  /**
   * Start observing images for lazy loading
   * @param {NodeList|Array} images - Images to observe
   */
  observe(images) {
    this.createObservers();

    images.forEach((img) => {
      this.visibleBlurObserver.observe(img);
      this.nearViewportBlurObserver.observe(img);
      this.visibleLoadObserver.observe(img);
      this.upcomingLoadObserver.observe(img);
    });
  }

  /**
   * Create all IntersectionObservers
   */
  createObservers() {
    // Visible blur rendering - highest priority
    this.visibleBlurObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            this.renderBlur(entry.target);
            this.visibleBlurObserver.unobserve(entry.target);
            this.nearViewportBlurObserver.unobserve(entry.target);
          }
        });
      },
      { rootMargin: "0px", threshold: 0.01 },
    );

    // Near-viewport blur rendering
    this.nearViewportBlurObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting && !this.blurRendered.has(entry.target.id)) {
            this.renderBlur(entry.target);
            this.nearViewportBlurObserver.unobserve(entry.target);
          }
        });
      },
      { rootMargin: `${window.innerHeight}px`, threshold: 0 },
    );

    // Visible image loading - high priority
    this.visibleLoadObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            this.loadImage(entry.target);
            this.visibleLoadObserver.unobserve(entry.target);
            this.upcomingLoadObserver.unobserve(entry.target);
          }
        });
      },
      { rootMargin: "0px", threshold: 0.1 },
    );

    // Upcoming image loading - queued
    this.upcomingLoadObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const img = entry.target;
            if (!isVisible(img)) {
              if (this.inflightRequests < this.maxConcurrent) {
                this.loadImage(img);
              } else {
                this.queue.push(img);
              }
              this.upcomingLoadObserver.unobserve(img);
            }
          }
        });
      },
      { rootMargin: "100px", threshold: 0 },
    );
  }

  /**
   * Process the next image in the queue
   */
  processQueue() {
    if (this.inflightRequests < this.maxConcurrent && this.queue.length > 0) {
      // Sort queue to prioritize visible images
      this.queue.sort((a, b) => {
        const rectA = a.getBoundingClientRect();
        const rectB = b.getBoundingClientRect();
        const isAVisible = rectA.top < window.innerHeight && rectA.bottom > 0;
        const isBVisible = rectB.top < window.innerHeight && rectB.bottom > 0;

        if (isAVisible && !isBVisible) return -1;
        if (!isAVisible && isBVisible) return 1;
        return Math.abs(rectA.top) - Math.abs(rectB.top);
      });

      const nextImage = this.queue.shift();
      this.loadImage(nextImage);
    }
  }

  /**
   * Render blurhash placeholder for an image
   * @param {HTMLImageElement} img - Image element
   */
  renderBlur(img) {
    if (this.blurRendered.has(img.id)) return;
    this.blurRendered.add(img.id);

    img.removeAttribute("height");

    const filename = img.dataset.filename;
    const blurhash = getBlurhashByFilename(filename);

    if (blurhash) {
      const aspectRatio = getAspectRatioFromIndex(filename, 1);

      const wrapper = document.createElement("div");
      wrapper.style.position = "relative";
      wrapper.style.display = "inline-block";
      wrapper.style.width = "100%";
      wrapper.style.aspectRatio = `${aspectRatio}`;
      wrapper.style.overflow = "hidden";
      wrapper.style.padding = "0";
      wrapper.style.margin = "0";
      wrapper.style.lineHeight = "0";

      const canvas = renderBlurhashGrid(img, blurhash, 20);

      img.parentNode.insertBefore(wrapper, img);
      wrapper.appendChild(canvas);
      wrapper.appendChild(img);

      img.style.position = "relative";
      img.style.zIndex = "2";
      img.style.opacity = "0";
      img.style.height = "auto";
      img.style.width = "100%";
      img.style.aspectRatio = `${aspectRatio}`;
      img.style.objectFit = "contain";
      img.style.border = "none";
      img.style.outline = "none";
    } else {
      img.style.backgroundColor = "#FF8C00";
    }
  }

  /**
   * Load an image
   * @param {HTMLImageElement} img - Image element to load
   */
  loadImage(img) {
    this.inflightRequests++;

    img.onload = () => {
      const filename = img.dataset.filename;
      const actualAspectRatio = img.naturalWidth / img.naturalHeight;

      // Update wrapper and image aspect ratio
      if (img.parentNode) {
        img.parentNode.style.aspectRatio = `${actualAspectRatio}`;
      }
      img.style.aspectRatio = `${actualAspectRatio}`;
      img.style.objectFit = "contain";

      // Fade in image
      img.style.transition = "opacity 0.5s ease-in-out";
      img.style.opacity = "1";

      // Fade out and remove canvas
      if (img.parentNode) {
        const canvas = img.parentNode.querySelector("canvas");
        if (canvas) {
          canvas.style.transition = "opacity 0.5s ease-in-out";
          canvas.style.opacity = "0";
          setTimeout(() => {
            if (canvas.parentNode) canvas.parentNode.removeChild(canvas);
          }, 500);
        }
      }

      this.inflightRequests--;
      this.processQueue();

      if (this.onImageLoad) this.onImageLoad(img);
    };

    // Track retry attempts
    if (!img.dataset.retryCount) {
      img.dataset.retryCount = "0";
    }

    img.onerror = () => {
      const retryCount = parseInt(img.dataset.retryCount || "0");

      if (retryCount < 3) {
        const newRetryCount = retryCount + 1;
        img.dataset.retryCount = newRetryCount.toString();

        setTimeout(() => {
          const cacheBuster = `?retry=${newRetryCount}&t=${Date.now()}`;
          img.src = img.dataset.src + cacheBuster;
        }, 500 * newRetryCount);
      } else {
        img.classList.add("load-failed");
        this.showBlurhashFallback(img);
        this.inflightRequests--;
        this.processQueue();

        if (this.onImageError) this.onImageError(img);
      }
    };

    img.src = img.dataset.src;
    img.classList.remove("lazyload");
  }

  /**
   * Show blurhash fallback for failed images
   * @param {HTMLImageElement} img - Failed image element
   */
  showBlurhashFallback(img) {
    const filename = img.dataset.filename;
    const blurhash = getBlurhashByFilename(filename);

    if (blurhash) {
      let wrapper = img.parentNode;
      if (!wrapper || wrapper.style.position !== "relative") {
        wrapper = document.createElement("div");
        wrapper.style.position = "relative";
        wrapper.style.display = "inline-block";
        wrapper.style.width = "100%";
        if (img.parentNode) {
          img.parentNode.insertBefore(wrapper, img);
          wrapper.appendChild(img);
        }
      }

      const existingCanvas = wrapper.querySelector("canvas");
      if (existingCanvas) existingCanvas.remove();

      const canvas = renderBlurhashGrid(img, blurhash, 20);
      canvas.classList.add("failed-image-blur");
      styleCanvasOverlay(canvas, 3, "default");
      wrapper.appendChild(canvas);
      img.style.opacity = "0";
    } else {
      img.style.display = "none";
      const fallback = document.createElement("div");
      fallback.style.backgroundColor = "#FF8C00";
      fallback.style.width = "100%";
      fallback.style.height = "100%";
      fallback.style.position = "relative";
      fallback.style.minHeight = "200px";

      if (img.parentNode) {
        img.parentNode.insertBefore(fallback, img);
      }
    }
  }

  /**
   * Destroy all observers
   */
  destroy() {
    if (this.visibleBlurObserver) this.visibleBlurObserver.disconnect();
    if (this.nearViewportBlurObserver)
      this.nearViewportBlurObserver.disconnect();
    if (this.visibleLoadObserver) this.visibleLoadObserver.disconnect();
    if (this.upcomingLoadObserver) this.upcomingLoadObserver.disconnect();
  }
}
