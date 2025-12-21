/**
 * Blurhash Rendering System
 * Handles creation of blurred placeholder images from encoded color data
 */

import { state } from "./state.js";

/**
 * Get aspect ratio from blurhash index for a filename
 * @param {string} filename - Image filename
 * @param {number} defaultRatio - Default aspect ratio if not found
 * @returns {number} Aspect ratio (width/height)
 */
export function getAspectRatioFromIndex(filename, defaultRatio = 1) {
  const imgData =
    state.blurhashIndex[filename] ||
    state.blurhashIndex[filename.split("/").pop()];

  if (imgData && imgData.width && imgData.height) {
    return imgData.width / imgData.height;
  }
  return defaultRatio;
}

/**
 * Get blurhash string for a filename from the index
 * @param {string} filename - Image filename to look up
 * @returns {string|null} Blurhash string or null if not found
 */
export function getBlurhashByFilename(filename) {
  const entry =
    state.blurhashIndex[filename] ||
    state.blurhashIndex[filename.split("/").pop()];
  return entry ? entry.blurhash : null;
}

/**
 * Convert blurhash to a simple color (first color in hash)
 * @param {string} hash - Blurhash string
 * @returns {string} CSS color string
 */
export function blurhashToColor(hash) {
  if (!hash || hash.length < 6) return "#FF8C00";

  const r = parseInt(hash.substring(0, 2), 16);
  const g = parseInt(hash.substring(2, 4), 16);
  const b = parseInt(hash.substring(4, 6), 16);

  if (isNaN(r) || isNaN(g) || isNaN(b)) return "#FF8C00";
  return `rgb(${r}, ${g}, ${b})`;
}

/**
 * Parse blurhash string into color array
 * @param {string} blurhash - Blurhash string
 * @param {number} dim - Grid dimension
 * @returns {Array<{r: number, g: number, b: number}>} Array of RGB colors
 */
function parseBlurhashColors(blurhash, dim) {
  const colors = [];
  for (let i = 0; i < dim * dim; i++) {
    const startIndex = i * 6;
    if (startIndex + 6 <= blurhash.length) {
      const hexColor = blurhash.substring(startIndex, startIndex + 6);
      const r = parseInt(hexColor.substring(0, 2), 16);
      const g = parseInt(hexColor.substring(2, 4), 16);
      const b = parseInt(hexColor.substring(4, 6), 16);

      colors.push({
        r: isNaN(r) ? 128 : r,
        g: isNaN(g) ? 128 : g,
        b: isNaN(b) ? 128 : b,
      });
    } else {
      colors.push({ r: 128, g: 128, b: 128 });
    }
  }
  return colors;
}

/**
 * Apply multiple blur passes for smooth effect
 * @param {CanvasRenderingContext2D} ctx - Canvas context
 * @param {HTMLCanvasElement} canvas - Canvas element
 * @param {number} baseBlur - Base blur radius
 */
function applyMultipleBlurPasses(ctx, canvas, baseBlur) {
  ctx.filter = `blur(${baseBlur * 1.5}px)`;
  ctx.globalAlpha = 0.9;
  ctx.drawImage(canvas, 0, 0);

  ctx.filter = `blur(${baseBlur * 3.5}px)`;
  ctx.globalAlpha = 0.7;
  ctx.drawImage(canvas, 0, 0);

  ctx.filter = `blur(${baseBlur * 0.5}px)`;
  ctx.globalAlpha = 0.4;
  ctx.drawImage(canvas, 0, 0);

  ctx.globalAlpha = 1.0;
}

/**
 * Apply adaptive image enhancements based on brightness
 * @param {ImageData} imageData - Canvas image data
 * @param {Array} colors - Original blurhash colors
 */
function applyEnhancements(imageData, colors) {
  const data = imageData.data;

  // Calculate average brightness
  let totalBrightness = 0;
  for (let i = 0; i < colors.length; i++) {
    const color = colors[i];
    totalBrightness += (color.r + color.g + color.b) / 3;
  }
  const avgBrightness = totalBrightness / colors.length;

  // Determine enhancement parameters based on brightness
  let contrast, saturation, vibrance;
  if (avgBrightness < 80) {
    // Dark
    contrast = 1.2;
    saturation = 1.3;
    vibrance = 1.15;
  } else if (avgBrightness > 170) {
    // Light
    contrast = 1.05;
    saturation = 1.1;
    vibrance = 1.05;
  } else {
    // Medium
    contrast = 1.15;
    saturation = 1.25;
    vibrance = 1.1;
  }

  // Process each pixel
  for (let i = 0; i < data.length; i += 4) {
    let r = data[i];
    let g = data[i + 1];
    let b = data[i + 2];

    // Apply contrast
    r = 128 + (r - 128) * contrast;
    g = 128 + (g - 128) * contrast;
    b = 128 + (b - 128) * contrast;

    // Calculate luminance
    const gray = r * 0.299 + g * 0.587 + b * 0.114;

    // Apply vibrance
    const maxChannel = Math.max(r, g, b);
    const minChannel = Math.min(r, g, b);
    const saturationAmount = (maxChannel - minChannel) / 255;
    const dynamicSatFactor = saturation * (1 - saturationAmount * vibrance);

    // Apply saturation
    r = gray + (r - gray) * dynamicSatFactor;
    g = gray + (g - gray) * dynamicSatFactor;
    b = gray + (b - gray) * dynamicSatFactor;

    // Clamp values
    data[i] = Math.min(255, Math.max(0, r));
    data[i + 1] = Math.min(255, Math.max(0, g));
    data[i + 2] = Math.min(255, Math.max(0, b));
  }
}

/**
 * Render a blurhash visualization on a canvas element
 * @param {HTMLElement} image - Image element for dimensions
 * @param {string} blurhash - Blurhash string
 * @param {number} dim - Grid dimension (default 20x20)
 * @returns {HTMLCanvasElement} Canvas with rendered blurhash
 */
export function renderBlurhashGrid(image, blurhash, dim = 20) {
  const canvas = document.createElement("canvas");

  // Get aspect ratio
  let aspectRatio = 1;
  if (image.dataset && image.dataset.filename) {
    aspectRatio = getAspectRatioFromIndex(image.dataset.filename, 1);
  }

  // Set dimensions
  const width = image.width || 300;
  const height = width / aspectRatio;
  canvas.width = width;
  canvas.height = height;

  // Style canvas
  canvas.style.position = "absolute";
  canvas.style.top = "0";
  canvas.style.left = "0";
  canvas.style.width = "100%";
  canvas.style.height = "100%";
  canvas.style.aspectRatio = `${aspectRatio}`;
  canvas.style.objectFit = "contain";
  canvas.style.zIndex = "1";

  const ctx = canvas.getContext("2d");

  // Validate blurhash
  const expectedLength = dim * dim * 3 * 2;
  if (!blurhash || blurhash.length !== expectedLength) {
    console.warn(
      `Invalid blurhash (length: ${blurhash ? blurhash.length : 0}), expected ${expectedLength}`,
    );
    ctx.fillStyle = "#FF8C00";
    ctx.fillRect(0, 0, width, height);
    return canvas;
  }

  // Create offscreen canvas for blur processing
  const offscreenCanvas = document.createElement("canvas");
  const scale = 3;
  offscreenCanvas.width = width * scale;
  offscreenCanvas.height = height * scale;
  const offCtx = offscreenCanvas.getContext("2d");

  // Parse colors
  const colors = parseBlurhashColors(blurhash, dim);

  // Calculate cell dimensions
  const cellWidth = (width * scale) / dim;
  const cellHeight = (height * scale) / dim;

  // Draw radial gradients
  offCtx.globalCompositeOperation = "lighter";

  for (let y = 0; y < dim; y++) {
    for (let x = 0; x < dim; x++) {
      const index = y * dim + x;
      const color = colors[index];

      const centerX = x * cellWidth + cellWidth / 2;
      const centerY = y * cellHeight + cellHeight / 2;
      const radius = Math.max(cellWidth, cellHeight) * 0.85;

      const gradient = offCtx.createRadialGradient(
        centerX,
        centerY,
        0,
        centerX,
        centerY,
        radius,
      );
      gradient.addColorStop(0, `rgba(${color.r}, ${color.g}, ${color.b}, 0.8)`);
      gradient.addColorStop(
        0.5,
        `rgba(${color.r}, ${color.g}, ${color.b}, 0.4)`,
      );
      gradient.addColorStop(1, `rgba(${color.r}, ${color.g}, ${color.b}, 0)`);

      offCtx.fillStyle = gradient;
      offCtx.beginPath();
      offCtx.arc(centerX, centerY, radius, 0, Math.PI * 2);
      offCtx.fill();
    }
  }

  offCtx.globalCompositeOperation = "source-over";

  // Apply blur passes
  const smallestDim = Math.min(offscreenCanvas.width, offscreenCanvas.height);
  const baseBlur = Math.max(4, Math.round(smallestDim / 50));
  applyMultipleBlurPasses(offCtx, offscreenCanvas, baseBlur);

  // Create enhanced canvas
  const enhancedCanvas = document.createElement("canvas");
  enhancedCanvas.width = width;
  enhancedCanvas.height = height;
  const enhCtx = enhancedCanvas.getContext("2d");

  enhCtx.drawImage(offscreenCanvas, 0, 0, width, height);

  // Apply enhancements
  const imageData = enhCtx.getImageData(0, 0, width, height);
  applyEnhancements(imageData, colors);
  enhCtx.putImageData(imageData, 0, 0);

  // Final draw
  ctx.drawImage(enhancedCanvas, 0, 0);

  return canvas;
}

/**
 * Style a canvas as an overlay
 * @param {HTMLCanvasElement} canvas - Canvas element
 * @param {number} zIndex - Z-index value
 * @param {string} cursor - Cursor style
 */
export function styleCanvasOverlay(canvas, zIndex = 3, cursor = "pointer") {
  canvas.style.position = "absolute";
  canvas.style.top = "0";
  canvas.style.left = "0";
  canvas.style.width = "100%";
  canvas.style.height = "100%";
  canvas.style.zIndex = String(zIndex);
  canvas.style.cursor = cursor;
}

/**
 * Ensure element has a relative wrapper for overlay positioning
 * @param {HTMLElement} element - Element to wrap
 * @param {HTMLElement} overlayElement - Element to append as overlay
 * @returns {HTMLElement} The wrapper element
 */
export function ensureRelativeWrapper(element, overlayElement) {
  let wrapper = element.parentNode;

  if (wrapper && wrapper.style.position === "relative") {
    wrapper.appendChild(overlayElement);
    return wrapper;
  }

  const newWrapper = document.createElement("div");
  newWrapper.style.position = "relative";
  newWrapper.style.display = "inline-block";
  newWrapper.style.width = "100%";
  element.parentNode.insertBefore(newWrapper, element);
  newWrapper.appendChild(element);
  newWrapper.appendChild(overlayElement);
  return newWrapper;
}
