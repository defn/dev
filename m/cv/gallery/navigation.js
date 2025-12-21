/**
 * Navigation Controller
 * Manages navigation UI, page transitions, and blurhash toggle functionality
 */

import { state } from "./state.js";
import { isVisible, getScrollPercentage } from "./visibility.js";
import {
  getBlurhashByFilename,
  renderBlurhashGrid,
  styleCanvasOverlay,
  ensureRelativeWrapper,
} from "./blurhash.js";

/**
 * NavigationController manages the navigation overlay and page transitions
 */
export class NavigationController {
  constructor(container) {
    this.container = container;
    this.element = null;
    this.modalOverlay = null;
    this.modalEscapeHandler = null;

    this.createNavigationElement();
  }

  /**
   * Create the navigation overlay element
   */
  createNavigationElement() {
    this.element = document.createElement("div");
    this.element.id = "navigation-control";
    this.element.style.position = "fixed";
    this.element.style.bottom = "10px";
    this.element.style.right = "10px";
    this.element.style.backgroundColor = "rgba(139, 0, 0, 0.7)";
    this.element.style.color = "white";
    this.element.style.padding = "5px 10px";
    this.element.style.borderRadius = "4px";
    this.element.style.fontSize = "16px";
    this.element.style.zIndex = "1002";
    this.element.style.fontFamily = "'Courier New', Courier, monospace";
    this.element.style.display = "flex";
    this.element.style.alignItems = "center";
    this.element.style.lineHeight = "24px";
    this.element.style.transition = "opacity 0.3s ease-in-out";

    this.container.appendChild(this.element);
  }

  /**
   * Update navigation display
   * @param {number|string|null} countdownValue - Countdown value to display
   */
  updateDisplay(countdownValue = null) {
    state.countdownValue = countdownValue;

    // Update relative page based on scroll
    const scrollPercentage = getScrollPercentage();
    if (state.totalPages > 0) {
      state.relativePage = Math.min(
        Math.max(1, Math.ceil(scrollPercentage * state.totalPages)),
        state.totalPages,
      );
    }

    this.updateContent();
  }

  /**
   * Update the navigation content
   */
  updateContent() {
    // Clear existing content
    while (this.element.firstChild) {
      this.element.removeChild(this.element.firstChild);
    }

    // Prev button
    const prevButton = document.createElement("span");
    prevButton.textContent = "< ";
    prevButton.style.cursor = "pointer";
    prevButton.style.fontWeight = "bold";
    prevButton.style.fontSize = "24px";
    prevButton.style.marginRight = "5px";

    if (state.currentPage > 1) {
      prevButton.onclick = () => {
        this.navigateTo(`../${state.currentPage - 1}/`);
      };
    } else {
      prevButton.style.opacity = "0.5";
    }
    this.element.appendChild(prevButton);

    // Main content
    const mainContent = document.createElement("span");
    mainContent.style.margin = "0 5px";
    mainContent.style.minWidth = "80px";
    mainContent.style.textAlign = "center";
    mainContent.style.display = "inline-block";
    mainContent.style.verticalAlign = "middle";

    mainContent.textContent = `${state.currentPage} : ${state.relativePage}/${state.totalPages}`;

    if (state.countdownValue !== null) {
      if (
        typeof state.countdownValue === "string" &&
        state.countdownValue.includes("s")
      ) {
        mainContent.textContent += ` ${state.countdownValue}`;
      } else {
        mainContent.textContent += ` ${state.countdownValue}s`;
      }
    }

    this.element.appendChild(mainContent);

    // Next button
    const nextButton = document.createElement("span");
    nextButton.textContent = " >";
    nextButton.style.cursor = "pointer";
    nextButton.style.fontWeight = "bold";
    nextButton.style.fontSize = "24px";
    nextButton.style.marginLeft = "5px";

    if (state.currentPage < state.totalPages) {
      nextButton.onclick = () => {
        this.navigateTo(`../${state.currentPage + 1}/`);
      };
    } else {
      nextButton.onclick = () => {
        this.navigateTo("../1/");
      };
    }
    this.element.appendChild(nextButton);
  }

  /**
   * Set autoscroll state for styling
   * @param {boolean} enabled - Whether autoscroll is enabled
   */
  setAutoscrollState(enabled) {
    if (enabled) {
      this.element.style.backgroundColor = "rgba(0, 0, 0, 0.7)";
    } else {
      this.element.style.backgroundColor = "rgba(139, 0, 0, 0.7)";
    }
  }

  /**
   * Navigate to a URL with blackout transition
   * @param {string} url - URL to navigate to
   */
  navigateTo(url) {
    this.blackOutVisibleImages();

    setTimeout(() => {
      window.location.href = url;
    }, 300);
  }

  /**
   * Black out all visible images before navigation
   */
  blackOutVisibleImages() {
    const images = document.querySelectorAll("img");

    images.forEach((img) => {
      if (isVisible(img)) {
        this.toggleImageBlurhash(img);
      }
    });
  }

  /**
   * Toggle blurhash overlay on an image
   * @param {HTMLElement} element - Image element
   * @param {Function} onToggle - Optional callback after toggle
   */
  toggleImageBlurhash(element, onToggle) {
    const wrapper = element.parentNode;
    let blurCanvas = wrapper
      ? wrapper.querySelector("canvas.toggle-blur")
      : null;

    if (blurCanvas) {
      // Remove blur canvas
      blurCanvas.remove();
      element.style.opacity = "1";
    } else {
      const filename = element.dataset.filename;
      const blurhash = getBlurhashByFilename(filename);

      if (blurhash) {
        const canvas = renderBlurhashGrid(element, blurhash, 20);
        canvas.classList.add("toggle-blur");
        styleCanvasOverlay(canvas, 3, "pointer");

        canvas.onclick = (event) => {
          event.stopPropagation();
          this.handleImageClick(element);
        };

        ensureRelativeWrapper(element, canvas);
        element.style.opacity = "0";
      } else {
        // Fallback filter effect
        if (element.style.filter) {
          element.style.filter = "";
          element.style.opacity = "1";
        } else {
          element.style.filter =
            "brightness(0.4) contrast(1.5) saturate(1.5) sepia(0.4) grayscale(0.2)";
          element.style.opacity = "0.8";
        }
      }
    }

    if (onToggle) onToggle();
  }

  /**
   * Handle image click based on config click mode
   * @param {HTMLElement} img - Image element
   */
  handleImageClick(img) {
    const clickMode = state.config.click.mode;

    switch (clickMode) {
      case "navigate":
        this.navigateToImage(img);
        break;
      case "select":
        this.toggleImageBlurhash(img);
        this.sendSelection(img.dataset.filename);
        break;
      case "custom":
        if (state.config.click.customHandler) {
          state.config.click.customHandler(img);
        }
        break;
      case "toggle":
      default:
        this.toggleImageBlurhash(img);
        break;
    }
  }

  /**
   * Navigate to image detail page
   * @param {HTMLElement} img - Image element
   */
  navigateToImage(img) {
    const filename = img.dataset.filename;
    const basename = filename.split("/").pop();
    const uuid = basename.replace(/^w-\d+-/, "");

    // Use URL pattern from config
    const urlPattern = state.config.click.navigateUrlPattern;
    const url = urlPattern
      .replace("{filename}", filename)
      .replace("{uuid}", uuid)
      .replace("{page}", state.currentPage);

    window.location.href = url;
  }

  /**
   * Send selection to server
   * @param {string} filename - Selected filename
   */
  sendSelection(filename) {
    const endpoint = state.config.click.selectEndpoint;
    fetch(`${endpoint}?filename=${encodeURIComponent(filename)}`, {
      method: "GET",
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.text();
      })
      .catch((error) => {
        console.error("[Selection] Error:", error);
      });
  }

  /**
   * Show modal image (for navigate mode with modal enabled)
   */
  showModalImage() {
    if (this.modalOverlay) {
      this.closeModal();
      return;
    }

    // Extract prefix from URL path for modal image
    const pathMatch = window.location.pathname.match(/\/w-(\d+)\//);
    if (!pathMatch) {
      console.error("Could not extract prefix from URL path");
      return;
    }
    const prefix = `w-${pathMatch[1]}`;

    this.modalOverlay = document.createElement("div");
    this.modalOverlay.style.position = "fixed";
    this.modalOverlay.style.top = "0";
    this.modalOverlay.style.left = "0";
    this.modalOverlay.style.width = "100%";
    this.modalOverlay.style.height = "100%";
    this.modalOverlay.style.backgroundColor = "rgba(0, 0, 0, 0.8)";
    this.modalOverlay.style.zIndex = "9999";
    this.modalOverlay.style.display = "flex";
    this.modalOverlay.style.justifyContent = "center";
    this.modalOverlay.style.alignItems = "center";
    this.modalOverlay.style.cursor = "pointer";

    // Use URL pattern from config
    const urlPattern = state.config.modal.imageUrlPattern;
    const imageUrl = urlPattern.replace("{prefix}", prefix);

    const modalImage = document.createElement("img");
    modalImage.src = imageUrl;
    modalImage.style.maxWidth = "90%";
    modalImage.style.maxHeight = "90%";
    modalImage.style.objectFit = "contain";
    modalImage.style.border = "2px solid white";

    this.modalOverlay.onclick = () => this.closeModal();

    const shortcutKey = state.config.modal.shortcutKey;
    this.modalEscapeHandler = (e) => {
      if (
        e.key === "Escape" ||
        e.key === shortcutKey ||
        e.key === shortcutKey.toUpperCase()
      ) {
        e.preventDefault();
        this.closeModal();
      }
    };
    document.addEventListener("keydown", this.modalEscapeHandler);

    this.modalOverlay.appendChild(modalImage);
    document.body.appendChild(this.modalOverlay);
  }

  /**
   * Close the modal
   */
  closeModal() {
    if (this.modalOverlay) {
      document.body.removeChild(this.modalOverlay);
      this.modalOverlay = null;
    }
    if (this.modalEscapeHandler) {
      document.removeEventListener("keydown", this.modalEscapeHandler);
      this.modalEscapeHandler = null;
    }
  }

  /**
   * Remove external navigation elements (from blurmap.go)
   */
  removeExternalNavigationElements() {
    const chunkNav = document.querySelector(".chunk-nav");
    if (chunkNav) chunkNav.remove();

    const navCountdown = document.getElementById("navigation-countdown");
    if (navCountdown) navCountdown.remove();

    const imageInfo = document.getElementById("current-image-info");
    if (imageInfo) imageInfo.remove();
  }
}
