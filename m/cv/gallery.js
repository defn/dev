function setBodyMarginToZero() {
  document.body.style.margin = "0";
}

// Function to get blurhash from index by filename
function getBlurhashByFilename(filename) {
  // First check if the filename exists in the index, try both full path and basename
  const entry =
    window.blurhashIndex[filename] ||
    window.blurhashIndex[filename.split("/").pop()];

  // Return the blurhash if entry exists, otherwise return null
  return entry ? entry.blurhash : null;
}

// Function to render a blurhash grid on a canvas
function renderBlurhashGrid(image, blurhash, dim = 20) {
  // Create a canvas element for the blurhash grid
  const canvas = document.createElement("canvas");

  // Get the aspect ratio from the image object or find it in the blurhash index
  let aspectRatio = 1;

  if (image.dataset && image.dataset.filename) {
    const filename = image.dataset.filename;
    const imgData =
      window.blurhashIndex[filename] ||
      window.blurhashIndex[filename.split("/").pop()];

    if (imgData && imgData.width && imgData.height) {
      aspectRatio = imgData.width / imgData.height;
    }
  }

  // Set the canvas dimensions
  const width = image.width || 300;
  const height = width / aspectRatio;
  canvas.width = width;
  canvas.height = height;

  // Position the canvas absolutely over the image
  canvas.style.position = "absolute";
  canvas.style.top = "0";
  canvas.style.left = "0";
  canvas.style.width = "100%";
  canvas.style.height = "100%";
  canvas.style.aspectRatio = `${aspectRatio}`; // Use correct aspect ratio
  canvas.style.objectFit = "contain"; // Show full image without cropping
  canvas.style.zIndex = "1"; // Below the image (image will have z-index 2)

  // Get the drawing context
  const ctx = canvas.getContext("2d");

  // Calculate expected blurhash length based on dimension: dim * dim * 3 * 2
  // For 20x20 grid: 20 * 20 * 3 * 2 = 2400 bytes (800 hex triplets)
  const expectedLength = dim * dim * 3 * 2;

  // If no valid blurhash, fill with default orange
  if (!blurhash || blurhash.length !== expectedLength) {
    console.warn(
      `Invalid blurhash (length: ${
        blurhash ? blurhash.length : 0
      }), expected ${expectedLength} chars. Using orange fallback`,
    );
    ctx.fillStyle = "#FF8C00";
    ctx.fillRect(0, 0, width, width);
    return canvas;
  }

  // Draw the dim x dim grid from the blurhash
  // Create a higher-resolution canvas for better blurring
  const offscreenCanvas = document.createElement("canvas");
  const scale = 3; // Higher resolution for smoother blur
  offscreenCanvas.width = width * scale;
  offscreenCanvas.height = height * scale;
  const offCtx = offscreenCanvas.getContext("2d");

  // Extract RGB colors from the blurhash
  const colors = [];
  for (let i = 0; i < dim * dim; i++) {
    const startIndex = i * 6;
    if (startIndex + 6 <= blurhash.length) {
      // Extract RRGGBB hex color
      const hexColor = blurhash.substring(startIndex, startIndex + 6);

      // Parse RGB components
      const r = parseInt(hexColor.substring(0, 2), 16);
      const g = parseInt(hexColor.substring(2, 4), 16);
      const b = parseInt(hexColor.substring(4, 6), 16);

      // Validate values
      const validR = isNaN(r) ? 128 : r;
      const validG = isNaN(g) ? 128 : g;
      const validB = isNaN(b) ? 128 : b;

      colors.push({ r: validR, g: validG, b: validB });
    } else {
      colors.push({ r: 128, g: 128, b: 128 }); // Fallback gray
    }
  }

  // Generate smooth gradient canvas
  const cellWidth = (width * scale) / dim;
  const cellHeight = (height * scale) / dim;

  // First pass: Draw solid circles with soft edges using globalCompositeOperation
  offCtx.globalCompositeOperation = "lighter"; // Additive blending to avoid dark shadows

  for (let y = 0; y < dim; y++) {
    for (let x = 0; x < dim; x++) {
      const index = y * dim + x;
      const color = colors[index];

      // Calculate center position and radius
      const centerX = x * cellWidth + cellWidth / 2;
      const centerY = y * cellHeight + cellHeight / 2;
      const radius = Math.max(cellWidth, cellHeight) * 0.85; // Increased radius for better overlap

      // Create softer radial gradient
      const gradient = offCtx.createRadialGradient(
        centerX,
        centerY,
        0,
        centerX,
        centerY,
        radius,
      );
      gradient.addColorStop(0, `rgba(${color.r}, ${color.g}, ${color.b}, 0.8)`); // Reduced opacity
      gradient.addColorStop(
        0.5,
        `rgba(${color.r}, ${color.g}, ${color.b}, 0.4)`,
      );
      gradient.addColorStop(1, `rgba(${color.r}, ${color.g}, ${color.b}, 0)`);

      // Draw circle with gradient
      offCtx.fillStyle = gradient;
      offCtx.beginPath();
      offCtx.arc(centerX, centerY, radius, 0, Math.PI * 2);
      offCtx.fill();
    }
  }

  // Reset composite operation
  offCtx.globalCompositeOperation = "source-over";

  // Calculate blur sizes relative to image dimensions
  const smallestDim = Math.min(offscreenCanvas.width, offscreenCanvas.height);
  const baseBlur = Math.max(4, Math.round(smallestDim / 50)); // Scales with image size

  // Apply multiple blur passes with different radii for a much smoother result
  // First blur pass - medium blur (scaled to image size)
  offCtx.filter = `blur(${baseBlur * 1.5}px)`;
  offCtx.globalAlpha = 0.9;
  offCtx.drawImage(offscreenCanvas, 0, 0);

  // Second blur pass - larger blur
  offCtx.filter = `blur(${baseBlur * 3.5}px)`;
  offCtx.globalAlpha = 0.7;
  offCtx.drawImage(offscreenCanvas, 0, 0);

  // Third blur pass - fine detail blur
  offCtx.filter = `blur(${baseBlur * 0.5}px)`;
  offCtx.globalAlpha = 0.4;
  offCtx.drawImage(offscreenCanvas, 0, 0);

  // Reset alpha
  offCtx.globalAlpha = 1.0;

  // Normalize and enhance contrast
  // Tint with a slight color to make it look nicer than pure grayscale
  const enhancedCanvas = document.createElement("canvas");
  enhancedCanvas.width = width;
  enhancedCanvas.height = height;
  const enhCtx = enhancedCanvas.getContext("2d");

  // Draw the blurred image at regular size
  enhCtx.drawImage(offscreenCanvas, 0, 0, width, height);

  // Apply slight enhancement for better visual appearance
  const imageData = enhCtx.getImageData(0, 0, width, height);
  const data = imageData.data;

  // Calculate average brightness
  let totalBrightness = 0;
  for (let i = 0; i < colors.length; i++) {
    const color = colors[i];
    totalBrightness += (color.r + color.g + color.b) / 3;
  }
  const avgBrightness = totalBrightness / colors.length;

  // Apply adaptive enhancement based on image brightness
  // Analyze brightness to determine appropriate enhancement values
  let brightnessClass = "medium";
  if (avgBrightness < 80) brightnessClass = "dark";
  if (avgBrightness > 170) brightnessClass = "light";

  // Set enhancement parameters based on brightness class
  let contrast, saturation, vibrance;
  switch (brightnessClass) {
    case "dark":
      contrast = 1.2; // Higher contrast for dark images
      saturation = 1.3; // Higher saturation for dark images
      vibrance = 1.15; // Boost vibrance for dark images
      break;
    case "light":
      contrast = 1.05; // Lower contrast for light images
      saturation = 1.1; // Lower saturation for light images
      vibrance = 1.05; // Lower vibrance for light images
      break;
    default: // medium
      contrast = 1.15; // Medium contrast
      saturation = 1.25; // Medium saturation
      vibrance = 1.1; // Medium vibrance
  }

  // Process each pixel with adaptive enhancements
  for (let i = 0; i < data.length; i += 4) {
    // Get RGB values
    let r = data[i];
    let g = data[i + 1];
    let b = data[i + 2];

    // Apply adaptive contrast - move values away from middle gray (128)
    r = 128 + (r - 128) * contrast;
    g = 128 + (g - 128) * contrast;
    b = 128 + (b - 128) * contrast;

    // Calculate luminance-preserving grayscale
    const gray = r * 0.299 + g * 0.587 + b * 0.114;

    // Apply vibrance (boosts saturation more for less saturated colors)
    const maxChannel = Math.max(r, g, b);
    const minChannel = Math.min(r, g, b);
    const saturationAmount = (maxChannel - minChannel) / 255;
    const dynamicSatFactor = saturation * (1 - saturationAmount * vibrance);

    // Apply adaptive saturation with vibrance
    r = gray + (r - gray) * dynamicSatFactor;
    g = gray + (g - gray) * dynamicSatFactor;
    b = gray + (b - gray) * dynamicSatFactor;

    // Clamp values
    data[i] = Math.min(255, Math.max(0, r));
    data[i + 1] = Math.min(255, Math.max(0, g));
    data[i + 2] = Math.min(255, Math.max(0, b));
  }

  enhCtx.putImageData(imageData, 0, 0);

  // Final draw to the main canvas
  ctx.drawImage(enhancedCanvas, 0, 0);

  return canvas;
}

// Simple function for backwards compatibility or fallback
function blurhashToColor(hash) {
  if (!hash || hash.length < 6) return "#FF8C00"; // Default orange

  // Get first color in the hash to use as placeholder
  const r = parseInt(hash.substring(0, 2), 16);
  const g = parseInt(hash.substring(2, 4), 16);
  const b = parseInt(hash.substring(4, 6), 16);

  if (isNaN(r) || isNaN(g) || isNaN(b)) return "#FF8C00";
  return `rgb(${r}, ${g}, ${b})`;
}

// Export generateGrid to global scope for HTML templates to access
window.generateGrid = generateGrid;

function generateGrid() {
  // Reference to the table body
  const tableBody = document.getElementById("table-body");

  // Use the shuffled images array that's already prepared
  const selectedImages = window.images || [];

  const userAgent = navigator.userAgent || navigator.vendor || window.opera;
  const isMobile =
    /android|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(
      userAgent.toLowerCase(),
    );

  if (isMobile) {
    window.numColumns = Math.floor(window.innerWidth / 490);
  } else {
    window.numColumns = Math.floor(window.innerWidth / 300);
  }

  // Make sure we have at least 1 column
  if (window.numColumns < 1) window.numColumns = 1;

  // Initialize an array to hold columns and their heights
  const columns = Array.from({ length: window.numColumns }, () => {
    const td = document.createElement("td");
    td.setAttribute("valign", "top");
    td.style.textAlign = "center";
    const div = document.createElement("div");
    div.className = "image-container";
    td.appendChild(div);
    return {
      element: td,
      totalHeight: 0, // Track the total height of images in this column
    };
  });

  // Calculate the standard image width
  const standardWidth = Math.floor(window.innerWidth / window.numColumns) - 5;

  // First pass: Distribute images to columns using the greedy algorithm
  // Keep track of images placed in each column
  const columnImages = Array.from({ length: window.numColumns }, () => []);

  selectedImages.forEach((image, index) => {
    const img = document.createElement("img");
    img.id = `img-${index}`;
    img.className = "lazyload";
    img.width = standardWidth;

    // Choose image path based on column count: use 'replicate/img' when only 1 column, otherwise use default path
    const imagePath = window.numColumns === 1 ? "/replicate/img" : basePath;
    img.dataset.src = `${imagePath}/${image.filename}`;
    img.dataset.filename = image.filename;
    img.style.border = "none";
    img.style.outline = "none";

    // Determine image height based on aspect ratio
    let aspectRatio = 1; // Default square aspect ratio
    let imgHeight = standardWidth; // Default height equal to width

    // First try to get dimensions from the image object which now includes width and height
    if (image.width && image.height) {
      aspectRatio = image.width / image.height;
    }
    // Then try blurhashIndex if needed
    else {
      const imgData =
        window.blurhashIndex[image.filename] ||
        window.blurhashIndex[image.filename.split("/").pop()];

      if (imgData && imgData.width && imgData.height) {
        aspectRatio = imgData.width / imgData.height;
      }
    }

    // Set the image height based on aspect ratio
    imgHeight = Math.floor(standardWidth / aspectRatio);
    img.style.aspectRatio = `${aspectRatio}`;
    img.height = imgHeight;

    img.onclick = (event) => {
      // Stop event propagation to make sure our handler gets priority
      event.stopPropagation();

      // Add custom event to stop autoscrolling - this will be handled at the document level
      const stopScrollEvent = new CustomEvent("stopAutoscroll", {
        bubbles: true,
        detail: { source: "imageClick" },
      });
      document.dispatchEvent(stopScrollEvent);

      // Then perform the original toggleVisibility action
      toggleVisibility(img);
    };

    // Store the calculated height
    const imgInfo = {
      element: img,
      height: imgHeight,
      aspectRatio: aspectRatio,
    };

    // Find the column with the smallest total height
    let shortestColumn = 0;
    let shortestHeight = columns[0].totalHeight;
    for (let i = 1; i < columns.length; i++) {
      if (columns[i].totalHeight < shortestHeight) {
        shortestColumn = i;
        shortestHeight = columns[i].totalHeight;
      }
    }

    // Add image to the column tracking array
    columnImages[shortestColumn].push(imgInfo);

    // Update the column's total height
    columns[shortestColumn].totalHeight += imgHeight + 5; // 5px for spacing
  });

  // Find the tallest column height for reference
  const tallestColumnHeight = Math.max(
    ...columns.map((col) => col.totalHeight),
  );
  console.log("Tallest column height:", tallestColumnHeight);

  // Calculate the content height of each column based on images
  columns.forEach((column, colIndex) => {
    const imagesInColumn = columnImages[colIndex] || [];
    // Calculate height from images and line breaks
    let totalContentHeight = 0;

    // Sum up actual image heights
    imagesInColumn.forEach((img) => {
      if (img && img.height) {
        totalContentHeight += img.height;
      }
    });

    // Add line break heights (only count breaks if we have images)
    if (imagesInColumn.length > 0) {
      totalContentHeight += imagesInColumn.length * 5; // 5px per line break
    }

    // Store the actual content height
    column.contentHeight = totalContentHeight;
  });

  // Find the tallest column content height
  const tallestContentHeight = Math.max(
    ...columns.map((col) => col.contentHeight || 0),
  );
  console.log("Tallest content height:", tallestContentHeight);

  // Second pass: Add content to the DOM with pixel-by-pixel distribution after each image
  columns.forEach((column, colIndex) => {
    const images = columnImages[colIndex] || [];
    if (images.length === 0) return; // Skip empty columns

    // Calculate the height gap needed for this column
    const heightGap = Math.max(0, tallestContentHeight - column.contentHeight);
    console.log(
      `Column ${colIndex}: gap to fill: ${heightGap}px, images: ${images.length}`,
    );

    if (heightGap <= 0) {
      // This is already the tallest column, no spacing needed
      images.forEach((imgInfo) => {
        column.element.appendChild(imgInfo.element);
        column.element.appendChild(document.createElement("br"));
      });
    } else if (images.length === 1) {
      // For a single image, we have no choice but to add spacing at the bottom
      column.element.appendChild(images[0].element);
      column.element.appendChild(document.createElement("br"));

      // Add the gap at the bottom
      const spacer = document.createElement("div");
      spacer.style.height = `${heightGap}px`;
      column.element.appendChild(spacer);
    } else {
      // For multiple images, we'll distribute the gap incrementally after each image

      // Calculate how much spacing to add after each image
      // We have (images.length - 1) positions to add spacing after
      const pixelsPerImage = Math.floor(heightGap / (images.length - 1));
      let remainingPixels = heightGap - pixelsPerImage * (images.length - 1);

      // Add images with incremental spacing
      images.forEach((imgInfo, imgIndex) => {
        // Add the image
        column.element.appendChild(imgInfo.element);
        column.element.appendChild(document.createElement("br"));

        // Add spacing after each image except the last one
        if (imgIndex < images.length - 1) {
          let thisSpacing = pixelsPerImage;

          // Distribute remaining pixels one by one
          if (remainingPixels > 0) {
            thisSpacing++;
            remainingPixels--;
          }

          // Add a spacer with the calculated height
          if (thisSpacing > 0) {
            const spacer = document.createElement("div");
            spacer.style.height = `${thisSpacing}px`;
            column.element.appendChild(spacer);
          }
        }
      });
    }
  });

  // Create a row and append the columns to it
  const row = document.createElement("tr");
  columns.forEach((column) => row.appendChild(column.element));
  tableBody.appendChild(row);

  // Log the adjusted column heights
  console.log(
    "Final column heights after gap distribution:",
    columns.map((col) => col.totalHeight),
  );
}

function logFullyVisibleImages() {
  const fullyVisibleImages = [];
  const images = document.querySelectorAll("img");
  images.forEach((img) => {
    const rect = img.getBoundingClientRect();
    if (
      rect.top >= 0 &&
      rect.left >= 0 &&
      rect.bottom <=
        (window.innerHeight || document.documentElement.clientHeight) &&
      rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    ) {
      fullyVisibleImages.push(img);
    }
  });

  fullyVisibleImages.forEach((img) => {
    console.log(`Image with src ${img.getAttribute("src")} is fully visible`);
    img.remove();
  });

  scrollToClosestImage();
}

function scrollToPartialImage() {
  const images = Array.from(document.querySelectorAll("img"));
  const viewportHeight = window.innerHeight;

  let partiallyVisibleImages = [];
  let visibleImages = [];

  images.forEach((img) => {
    const rect = img.getBoundingClientRect();

    // Check if the image is partially visible with the top visible and not fully in the viewport
    if (
      rect.top > 0 &&
      rect.top < viewportHeight &&
      rect.bottom > viewportHeight
    ) {
      partiallyVisibleImages.push(img);
    }

    // Check if the image is visible (completely or partially)
    if (rect.top < viewportHeight && rect.bottom > 0) {
      visibleImages.push(img);
    }
  });

  // Sort images by rect.top (uniquely, without duplicates)
  partiallyVisibleImages = partiallyVisibleImages.filter(
    (img, index, self) =>
      index ===
      self.findIndex(
        (t) =>
          t.getBoundingClientRect().top === img.getBoundingClientRect().top,
      ),
  );

  // If there are partially visible images, scroll to the first one
  if (partiallyVisibleImages.length > 0) {
    partiallyVisibleImages[0].scrollIntoView({
      behavior: "smooth",
      block: "start",
    });
  } else if (visibleImages.length > 0) {
    // If no partial images, scroll to the bottom of the visible images plus 10px
    const lastVisibleImage = visibleImages[visibleImages.length - 1];
    const rect = lastVisibleImage.getBoundingClientRect();
    window.scrollBy(0, rect.bottom + 10);
  }
}

function toggleVisibility(element) {
  toggleHidden(element);

  // Only send to server when selectMode is "yes"
  if (selectMode === "yes") {
    fetch(
      `select-${selectMode}?filename=${element.getAttribute("data-filename")}`,
      {
        mode: "no-cors",
      },
    )
      .then((response) => response.text())
      .then((data) => console.log(data))
      .catch((error) => console.error("Error:", error));
  }
  // When selectMode is "no", just toggle blurhash locally without server interaction
}

function toggleHidden(element) {
  // Check if blurmap is already displayed
  const wrapper = element.parentNode;
  let blurCanvas = wrapper.querySelector("canvas.toggle-blur");

  if (blurCanvas) {
    // Remove the blur canvas and restore image visibility
    blurCanvas.remove();
    element.style.opacity = "1";
  } else {
    // Get blurhash for this image
    const filename = element.dataset.filename;
    const blurhash = getBlurhashByFilename(filename);

    if (blurhash) {
      // Create and render the blurhash canvas
      const canvas = renderBlurhashGrid(element, blurhash, 20);
      canvas.classList.add("toggle-blur");

      // Position canvas over the image
      canvas.style.position = "absolute";
      canvas.style.top = "0";
      canvas.style.left = "0";
      canvas.style.width = "100%";
      canvas.style.height = "100%";
      canvas.style.zIndex = "3"; // Above the image
      canvas.style.cursor = "pointer"; // Show pointer cursor

      // Add click handler to canvas to toggle back and stop autoscroll
      canvas.onclick = () => {
        // Stop autoscrolling if active
        if (autoscrollInterval) {
          toggleAutoscroll();
        }

        // Then toggle visibility
        toggleVisibility(element);
      };

      // Add canvas to wrapper or create wrapper if it doesn't exist
      if (wrapper && wrapper.style.position === "relative") {
        wrapper.appendChild(canvas);
      } else {
        const newWrapper = document.createElement("div");
        newWrapper.style.position = "relative";
        newWrapper.style.display = "inline-block";
        newWrapper.style.width = "100%";
        element.parentNode.insertBefore(newWrapper, element);
        newWrapper.appendChild(element);
        newWrapper.appendChild(canvas);
      }

      // Make image invisible but keep its space
      element.style.opacity = "0";
    } else {
      // Fallback when no blurhash is available - create dark shadow with saturated highlights
      if (element.style.filter) {
        // Remove the filter effects to restore original image
        element.style.filter = "";
        element.style.opacity = "1";
      } else {
        // Apply darkening with saturated highlights and sepia/aged effect
        element.style.filter =
          "brightness(0.4) contrast(1.5) saturate(1.5) sepia(0.4) grayscale(0.2)";
        element.style.opacity = "0.8";
      }
    }
  }
}

function areVisibleImagesLoaded() {
  const images = document.querySelectorAll("img");
  let allLoaded = true;

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        const img = entry.target;
        if (!img.complete || img.naturalHeight === 0) {
          allLoaded = false;
        }
      }
    });
  });

  images.forEach((img) => {
    observer.observe(img);
  });

  // Disconnect the observer once done
  observer.disconnect();

  return allLoaded;
}

function scrollToClosestImage() {
  const images = Array.from(document.querySelectorAll("img"));
  const viewportHeight = window.innerHeight;

  let closestImage = null;
  let minDistance = Infinity;

  images.forEach((img) => {
    const rect = img.getBoundingClientRect();

    // Check if the top of the image is already visible
    if (rect.top >= 0 && rect.top <= viewportHeight) {
      const distanceToBottom = Math.abs(viewportHeight - rect.top);

      // Find the image closest to the bottom of the screen
      if (distanceToBottom < minDistance) {
        minDistance = distanceToBottom;
        closestImage = img;
      }
    }
  });

  // Scroll to the closest image if found
  if (closestImage) {
    closestImage.scrollIntoView({ behavior: "smooth", block: "start" });
    return;
  }
}

// JavaScript to adjust heights of containers
window.addEventListener("load", () => {
  const containers = document.querySelectorAll(".image-container");
  let maxHeight = 0;

  // Find the maximum height of all containers
  containers.forEach((container) => {
    const containerHeight = container.offsetHeight;
    if (containerHeight > maxHeight) {
      maxHeight = containerHeight;
    }
  });

  // Set all containers to the maximum height
  containers.forEach((container) => {
    // container.style.height = `${maxHeight}px`;
  });
});

// Create a global function to stop autoscrolling - this will be accessible from anywhere
window.stopAutoscroll = function () {
  // Only proceed if we're in a document with autoscrolling
  if (typeof window.autoscrollInterval === "undefined") {
    console.log("[Autoscroll] autoscrollInterval not found in this scope");
    return;
  }

  console.log("[Autoscroll] Stopping autoscroll");

  // Clear the main autoscroll interval
  if (window.autoscrollInterval) {
    clearInterval(window.autoscrollInterval);
    window.autoscrollInterval = null;
  }

  // Also clear any countdown timers
  if (window.countdownTimer) {
    clearInterval(window.countdownTimer);
    window.countdownTimer = null;
  }

  // Clear all intervals with reasonable IDs to be thorough
  for (var i = 1; i < 1000; i++) {
    clearInterval(i);
  }

  // Update navigation control to show paused state
  if (window.navigationControl) {
    window.navigationControl.style.backgroundColor = "rgba(139, 0, 0, 0.7)"; // Dark red when paused
  }

  // Clear countdown
  if (typeof window.countdownValue !== "undefined") {
    window.countdownValue = null;
  }

  // Update display
  if (typeof window.updateNavigationDisplay === "function") {
    window.updateNavigationDisplay();
  }

  console.log("[Autoscroll] Autoscroll stopped");
};

// Global document click handler to stop autoscrolling when clicking on images
document.addEventListener("click", function (event) {
  // Check if click is on an image, canvas, or in an image container
  const isImageClick =
    event.target.tagName === "IMG" ||
    event.target.tagName === "CANVAS" ||
    event.target.closest(".image-container") !== null;

  // If it's an image click, stop autoscrolling
  if (isImageClick) {
    console.log("[Autoscroll] Image clicked, calling stopAutoscroll");
    window.stopAutoscroll();
  }
});

// Listen for the custom stopAutoscroll event
document.addEventListener("stopAutoscroll", function (event) {
  console.log(
    "[Autoscroll] Received stopAutoscroll event from:",
    event.detail?.source,
  );
  window.stopAutoscroll();
});

document.addEventListener("DOMContentLoaded", () => {
  const tableBody = document.getElementById("table-body");
  const overlay = document.getElementById("overlay");

  // Remove any navigation controls from previous runs or created by blurmap.go
  const oldNav = document.getElementById("navigation-control");
  if (oldNav) oldNav.remove();

  // Function to remove any navigation elements from blurmap.go
  function removeExternalNavigationElements() {
    // Remove chunk-nav elements from blurmap.go
    const chunkNav = document.querySelector(".chunk-nav");
    if (chunkNav) chunkNav.remove();

    // Remove any navigation countdown elements
    const navCountdown = document.getElementById("navigation-countdown");
    if (navCountdown) navCountdown.remove();

    // Remove any current-image-info elements
    const imageInfo = document.getElementById("current-image-info");
    if (imageInfo) imageInfo.remove();
  }

  // Call initially and set up a MutationObserver to keep removing external nav elements
  removeExternalNavigationElements();

  // Setup observer to remove external navigation elements when added to DOM
  const observer = new MutationObserver(() => {
    removeExternalNavigationElements();
  });

  // Start observing the document for added nodes
  observer.observe(document.body, { childList: true, subtree: true });

  // Create our own navigation control with the requested format - make it globally accessible
  window.navigationControl = document.createElement("div");
  window.navigationControl.id = "navigation-control";
  window.navigationControl.style.position = "fixed";
  window.navigationControl.style.bottom = "10px";
  window.navigationControl.style.right = "10px";
  window.navigationControl.style.backgroundColor = "rgba(139, 0, 0, 0.7)"; // Dark red when autoscroll disabled
  window.navigationControl.style.color = "white";
  window.navigationControl.style.padding = "5px 10px";
  window.navigationControl.style.borderRadius = "4px";
  window.navigationControl.style.fontSize = "16px"; // Increased from 14px
  window.navigationControl.style.zIndex = "1002";
  window.navigationControl.style.fontFamily =
    "'Courier New', Courier, monospace";
  window.navigationControl.style.display = "flex";
  window.navigationControl.style.alignItems = "center";
  window.navigationControl.style.lineHeight = "24px"; // Match the increased height of navigation buttons
  document.body.appendChild(window.navigationControl);

  // Track navigation data on window object to make them globally accessible
  window.currentPage = 1;
  window.currentImageNumber = 1;
  window.totalImages = 0; // Will be calculated
  window.countdownValue = null;

  // Function to update the navigation display - make it globally accessible
  window.updateNavigationDisplay = function () {
    // Calculate total images if not done yet
    if (window.totalImages === 0 && window.images) {
      window.totalImages = window.images.length;
    }

    // Clear any existing content in navigation control
    while (window.navigationControl.firstChild) {
      window.navigationControl.removeChild(window.navigationControl.firstChild);
    }

    // Create prev button (<)
    const prevButton = document.createElement("span");
    prevButton.textContent = "< ";
    prevButton.style.cursor = "pointer";
    prevButton.style.fontWeight = "bold";
    prevButton.style.fontSize = "24px";
    prevButton.style.marginRight = "5px";

    // Add click event to navigate to previous page
    if (window.currentPage > 1) {
      prevButton.onclick = () => {
        // Navigate to previous page
        window.location.href = `../${window.currentPage - 1}/`;
      };
    } else {
      // Disabled style for page 1
      prevButton.style.opacity = "0.5";
    }
    window.navigationControl.appendChild(prevButton);

    // Add middle content
    const mainContent = document.createElement("span");
    mainContent.style.margin = "0 5px";
    mainContent.style.minWidth = "70px"; // Ensures consistent width
    mainContent.style.textAlign = "center";
    mainContent.style.display = "inline-block";
    mainContent.style.verticalAlign = "middle"; // Align with the larger buttons

    // Set the text content
    mainContent.textContent = `${window.currentPage} : ${window.currentImageNumber}/${window.totalImages}`;
    if (window.countdownValue !== null) {
      mainContent.textContent += ` ${window.countdownValue}s`;
    }

    window.navigationControl.appendChild(mainContent);

    // Create next button (>)
    const nextButton = document.createElement("span");
    nextButton.textContent = " >";
    nextButton.style.cursor = "pointer";
    nextButton.style.fontWeight = "bold";
    nextButton.style.fontSize = "24px";
    nextButton.style.marginLeft = "5px";

    // Add click event to navigate to next page
    if (window.currentPage < window.totalPages) {
      nextButton.onclick = () => {
        // Navigate to next page
        window.location.href = `../${window.currentPage + 1}/`;
      };
    } else {
      // Disabled style for last page
      nextButton.style.opacity = "0.5";
    }
    window.navigationControl.appendChild(nextButton);
  };

  // Extract page number from URL
  function getPageNumberFromURL() {
    // Try to get page number from meta tag (set by blurmap.go)
    const metaCurrentChunk = document.querySelector(
      'meta[name="current-chunk"]',
    );
    if (metaCurrentChunk && metaCurrentChunk.content) {
      return parseInt(metaCurrentChunk.content) || 1;
    }

    // Fallback: extract from URL path
    try {
      const pathParts = window.location.pathname
        .split("/")
        .filter((p) => p.length > 0);
      // Look for number in URL path segments
      for (let i = 0; i < pathParts.length; i++) {
        const num = parseInt(pathParts[i]);
        if (!isNaN(num)) {
          return num;
        }
      }
    } catch (e) {
      console.error("Error parsing URL for page number:", e);
    }

    return 1; // Default to page 1 if not found
  }

  // Initialize page number from URL
  window.currentPage = getPageNumberFromURL();

  // Get total chunks/pages from meta tag
  const metaTotalChunks = document.querySelector('meta[name="total-chunks"]');
  if (metaTotalChunks && metaTotalChunks.content) {
    window.totalPages = parseInt(metaTotalChunks.content) || 100;
  } else {
    window.totalPages = 100; // Default value
  }

  // Calculate initial image positions
  function calculateImagePositions() {
    const images = Array.from(document.querySelectorAll("img"));
    if (images.length > 0) {
      window.totalImages = images.length;
      window.updateNavigationDisplay();
    }
  }

  // Initialize navigation
  setTimeout(calculateImagePositions, 500);

  // Add scroll listener to update navigation
  window.addEventListener("scroll", () => {
    // Find current visible image - only update image number, not page number
    const images = Array.from(document.querySelectorAll("img"));
    const viewportTop = window.pageYOffset;
    const viewportBottom = viewportTop + window.innerHeight;

    // Find first visible image
    for (let i = 0; i < images.length; i++) {
      const img = images[i];
      const rect = img.getBoundingClientRect();
      if (rect.top >= 0 && rect.top < window.innerHeight) {
        window.currentImageNumber = i + 1;
        break;
      }
    }

    // Page number always stays fixed at URL page number (initialized earlier)
    // window.currentPage = getPageNumberFromURL(); // This happens only once at load

    // Update the display
    window.updateNavigationDisplay();
  });

  // Define variables on the window object to make them globally accessible
  window.eop = false;
  window.keySequence = "";
  window.autos = false;
  window.autoscrollInterval = null;
  window.IMAGES_PER_SECOND = 7; // Number of images that equals 1 second of wait time

  setBodyMarginToZero();

  // Ensure blurhashIndex exists to prevent errors
  if (!window.blurhashIndex) {
    console.warn("blurhashIndex not found, creating empty object");
    window.blurhashIndex = {};
  }

  if ("IntersectionObserver" in window) {
    const lazyloadImages = document.querySelectorAll(".lazyload");

    // Track which images have already had their blur rendered
    const blurRenderedImages = new Set();

    // Track in-flight image loading requests
    let inflightRequests = 0;
    const maxInflightRequests = numColumns * 3;
    const imageLoadQueue = []; // Queue for pending image loads

    // Function to process the next image in the queue if under the cap
    const processImageLoadQueue = () => {
      // If we're under the cap and have images to load, load the next one
      if (inflightRequests < maxInflightRequests && imageLoadQueue.length > 0) {
        // Sort the queue to prioritize visible images first
        imageLoadQueue.sort((a, b) => {
          const rectA = a.getBoundingClientRect();
          const rectB = b.getBoundingClientRect();

          // Is image A visible in viewport?
          const isAVisible = rectA.top < window.innerHeight && rectA.bottom > 0;

          // Is image B visible in viewport?
          const isBVisible = rectB.top < window.innerHeight && rectB.bottom > 0;

          if (isAVisible && !isBVisible) return -1; // A is visible, B is not
          if (!isAVisible && isBVisible) return 1; // B is visible, A is not

          // If both visible or both not visible, prioritize by distance to viewport
          return Math.abs(rectA.top) - Math.abs(rectB.top);
        });

        const nextImageToLoad = imageLoadQueue.shift();
        loadImage(nextImageToLoad);
      }
    };

    // Function to load an image
    const loadImage = (lazyImage) => {
      inflightRequests++;
      console.log(
        `Loading image: ${lazyImage.dataset.filename} (${inflightRequests} in flight)`,
      );

      // Add onload handler to fade in the image
      lazyImage.onload = () => {
        // Get the filename from the data attribute
        const filename = lazyImage.dataset.filename;

        // Get the actual image dimensions
        const actualWidth = lazyImage.naturalWidth;
        const actualHeight = lazyImage.naturalHeight;
        const actualAspectRatio = actualWidth / actualHeight;

        console.log(
          `Actual image dimensions: ${actualWidth}x${actualHeight}, aspect ratio: ${actualAspectRatio}`,
        );

        // Check if we had the correct aspect ratio from metadata
        const imgData =
          window.blurhashIndex[filename] ||
          window.blurhashIndex[filename.split("/").pop()];

        const metadataAspectRatio =
          imgData && imgData.width && imgData.height
            ? imgData.width / imgData.height
            : null;

        // Update the wrapper to use the actual aspect ratio
        if (lazyImage.parentNode) {
          lazyImage.parentNode.style.aspectRatio = `${actualAspectRatio}`;
        }

        // Update the image to use its natural aspect ratio
        lazyImage.style.aspectRatio = `${actualAspectRatio}`;
        lazyImage.style.objectFit = "contain"; // Show full image without cropping

        // Fade in the image with a transition
        lazyImage.style.transition = "opacity 0.5s ease-in-out";
        lazyImage.style.opacity = "1";

        // Fade out the canvas if it exists (parent of the image is the wrapper)
        if (
          lazyImage.parentNode &&
          lazyImage.parentNode.querySelector("canvas")
        ) {
          const canvas = lazyImage.parentNode.querySelector("canvas");
          canvas.style.transition = "opacity 0.5s ease-in-out";
          canvas.style.opacity = "0";

          // Remove the canvas after transition
          setTimeout(() => {
            if (canvas.parentNode) {
              canvas.parentNode.removeChild(canvas);
            }
          }, 500);
        }

        // Reduce the in-flight counter and process the next image
        inflightRequests--;
        processImageLoadQueue();
      };

      // Track retry attempts for each image
      if (!lazyImage.dataset.retryCount) {
        lazyImage.dataset.retryCount = "0";
      }

      // Handle image loading errors
      lazyImage.onerror = () => {
        const retryCount = parseInt(lazyImage.dataset.retryCount);
        console.error(
          `Failed to load image: ${lazyImage.dataset.filename} (attempt ${retryCount + 1})`,
        );

        // Try once more before giving up
        if (retryCount < 1) {
          console.log(`Retrying image: ${lazyImage.dataset.filename}`);
          lazyImage.dataset.retryCount = "1";

          // Add a slight delay before retrying
          setTimeout(() => {
            lazyImage.src = lazyImage.dataset.src + "?retry=1"; // Add query param to avoid cache
          }, 500);
        } else {
          // Mark image as failed after retry
          lazyImage.classList.add("load-failed");
          inflightRequests--;
          processImageLoadQueue();
        }
      };

      // Start loading the image
      lazyImage.src = lazyImage.dataset.src;
      lazyImage.classList.remove("lazyload");
    };

    // Function to render the blur for an image
    const renderBlur = (lazyImage) => {
      const imageId = lazyImage.id;

      // Skip if we've already rendered the blur for this image
      if (blurRenderedImages.has(imageId)) {
        return;
      }

      // Mark this image as having its blur rendered
      blurRenderedImages.add(imageId);

      lazyImage.removeAttribute("height");

      // Look for blurhash in the index
      const filename = lazyImage.dataset.filename;
      const blurhash = getBlurhashByFilename(filename);

      if (blurhash) {
        console.log(`Rendering blurhash grid for ${filename} from blurhash`);

        // Create wrapper div for positioning
        // Get the aspect ratio from the image data if available
        const imgData =
          window.blurhashIndex[filename] ||
          window.blurhashIndex[filename.split("/").pop()];
        const aspectRatio =
          imgData && imgData.width && imgData.height
            ? imgData.width / imgData.height
            : 1;

        const wrapper = document.createElement("div");
        wrapper.style.position = "relative";
        wrapper.style.display = "inline-block";
        wrapper.style.width = "100%";
        wrapper.style.aspectRatio = `${aspectRatio}`; // Use calculated aspect ratio instead of 1:1
        wrapper.style.overflow = "hidden"; // Prevent overflow
        wrapper.style.padding = "0"; // Remove any padding
        wrapper.style.margin = "0"; // Remove any margin
        wrapper.style.lineHeight = "0"; // Remove any line height spacing

        // Render blurhash canvas
        const canvas = renderBlurhashGrid(lazyImage, blurhash, 20);

        // Replace the image with the wrapper containing both canvas and image
        lazyImage.parentNode.insertBefore(wrapper, lazyImage);
        wrapper.appendChild(canvas);
        wrapper.appendChild(lazyImage);

        // Position the image on top of the canvas
        lazyImage.style.position = "relative";
        lazyImage.style.zIndex = "2";
        lazyImage.style.opacity = "0"; // Hide image initially
        lazyImage.style.height = "auto"; // Let height adjust based on width while maintaining aspect ratio
        lazyImage.style.width = "100%"; // Fill the wrapper width
        lazyImage.style.aspectRatio = `${aspectRatio}`; // Use same aspect ratio as wrapper
        lazyImage.style.objectFit = "contain"; // Show entire image without cropping
        lazyImage.style.border = "none"; // Remove border
        lazyImage.style.outline = "none"; // Remove outline
      } else {
        // Use default orange
        console.log(`No blurhash found for ${filename}, using default orange`);
        lazyImage.style.backgroundColor = "#FF8C00";
      }
    };

    // Separate observers for rendering the blur - one for visible images, one for near-viewport images
    // First observer prioritizes currently visible images (no margin)
    let visibleBlurRenderObserver = new IntersectionObserver(
      (entries, observer) => {
        console.log(`Visible blur render observe: seen ${entries.length}`);
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            let lazyImage = entry.target;

            // Immediately render the blur for visible images
            renderBlur(lazyImage);

            // Unobserve this image for blur rendering
            visibleBlurRenderObserver.unobserve(lazyImage);

            // Also unobserve in the preload observer
            nearViewportBlurRenderObserver.unobserve(lazyImage);
          }
        });
      },
      {
        rootMargin: "0px", // Only process currently visible images
        threshold: 0.01, // Trigger when even a small portion (1%) is visible for faster rendering
      },
    );

    // Second observer handles images approaching the viewport (immediately without delay)
    let nearViewportBlurRenderObserver = new IntersectionObserver(
      (entries, observer) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            let lazyImage = entry.target;

            // Render blur immediately for images near viewport - no delay
            // Only render if it hasn't already been rendered
            if (!blurRenderedImages.has(lazyImage.id)) {
              renderBlur(lazyImage);
            }

            // Unobserve this image for blur rendering
            nearViewportBlurRenderObserver.unobserve(lazyImage);
          }
        });
      },
      {
        rootMargin: `${window.innerHeight}px`, // Use full screen height as margin for preloading
        threshold: 0, // Trigger as soon as any part intersects with the expanded margin
      },
    );

    // Create separate observers for immediately visible vs upcoming images
    // High priority observer - loads immediately visible images first
    let visibleImageLoadObserver = new IntersectionObserver(
      (entries, observer) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            let lazyImage = entry.target;

            // Always prioritize loading visible images immediately
            loadImage(lazyImage);

            // Unobserve from both observers
            visibleImageLoadObserver.unobserve(lazyImage);
            upcomingImageLoadObserver.unobserve(lazyImage);
          }
        });
      },
      {
        rootMargin: "0px", // Only currently visible images
        threshold: 0.1, // 10% of the image must be visible - reduced to catch more visible images
      },
    );

    // Lower priority observer - queues images that are approaching the viewport
    let upcomingImageLoadObserver = new IntersectionObserver(
      (entries, observer) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            let lazyImage = entry.target;

            // Check if the image is now in the viewport (if so, let the other observer handle it)
            const rect = lazyImage.getBoundingClientRect();
            const isNowVisible =
              rect.top < window.innerHeight && rect.bottom > 0;

            if (!isNowVisible) {
              // Queue this image for loading or load if under the cap
              if (inflightRequests < maxInflightRequests) {
                loadImage(lazyImage);
              } else {
                console.log(`Queueing image: ${lazyImage.dataset.filename}`);
                imageLoadQueue.push(lazyImage);
              }

              // Unobserve this image
              upcomingImageLoadObserver.unobserve(lazyImage);
            }
          }
        });
      },
      {
        rootMargin: "100px", // Images approaching the viewport
        threshold: 0, // Trigger as soon as any part intersects
      },
    );

    // Observe all lazyload images with all observers
    lazyloadImages.forEach((lazyImage) => {
      // HIGHEST priority: visible blur rendering - do this first
      visibleBlurRenderObserver.observe(lazyImage);

      // HIGH priority: near-viewport blur rendering
      nearViewportBlurRenderObserver.observe(lazyImage);

      // After blur rendering is set up, handle image loading

      // MEDIUM priority: visible images loading
      visibleImageLoadObserver.observe(lazyImage);

      // LOWEST priority: upcoming images loading
      upcomingImageLoadObserver.observe(lazyImage);
    });
  }

  // Autoscroll functionality

  // Function to count visible images
  function countVisibleImages() {
    const images = document.querySelectorAll("img");
    let visibleCount = 0;
    let failedCount = 0;
    const viewportTop = window.pageYOffset;
    const viewportBottom = viewportTop + window.innerHeight;

    images.forEach((img) => {
      const rect = img.getBoundingClientRect();
      const imgTop = rect.top + window.pageYOffset;
      const imgBottom = imgTop + rect.height;

      // Check if image is at least partially visible
      if (imgBottom > viewportTop && imgTop < viewportBottom) {
        // Skip failed images in the count
        if (img.classList.contains("load-failed")) {
          failedCount++;
        } else {
          visibleCount++;
        }
      }
    });

    console.log(
      `[Autoscroll] Counted ${visibleCount} visible images (${failedCount} failed images ignored)`,
    );
    return visibleCount;
  }

  // Function to check if all images in viewport are loaded
  function areAllViewportImagesLoaded() {
    const images = document.querySelectorAll("img");
    let allLoaded = true;
    let loadingCount = 0;
    let fullyVisibleCount = 0;
    let failedCount = 0;

    images.forEach((img) => {
      const rect = img.getBoundingClientRect();
      // Check if image is FULLY visible in viewport
      if (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= window.innerHeight &&
        rect.right <= window.innerWidth
      ) {
        fullyVisibleCount++;

        // Skip images that failed to load after retry
        if (img.classList.contains("load-failed")) {
          failedCount++;
          return; // Skip this image in the loading check
        }

        // Check if image is loaded
        if (!img.complete || img.naturalHeight === 0) {
          allLoaded = false;
          loadingCount++;
        }
      }
    });

    console.log(
      `[Autoscroll] Viewport images check: ${loadingCount} of ${fullyVisibleCount} fully visible images still loading, ${failedCount} failed images ignored`,
    );
    return allLoaded;
  }

  // Function to scroll like space key
  function performSpaceScroll() {
    console.log("[Autoscroll] Performing space-like scroll");

    // First check if all viewport images are loaded
    if (!areAllViewportImagesLoaded()) {
      console.log(
        "[Autoscroll] Waiting for all viewport images to load before scrolling",
      );
      return false; // Return false to indicate scroll was not performed
    }

    // Check if we're at the bottom of the page
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    const scrollHeight = document.documentElement.scrollHeight;
    const clientHeight = window.innerHeight;
    const isAtBottom = scrollTop + clientHeight >= scrollHeight - 5; // 5px tolerance

    if (isAtBottom) {
      // Reset to the top of the page
      console.log("[Autoscroll] At bottom of page, resetting to top");
      window.scrollTo({
        top: 0,
        behavior: "smooth",
      });
    } else {
      // Space key typically scrolls by viewport height minus a small overlap
      const scrollAmount = window.innerHeight * 0.9;
      console.log(`[Autoscroll] Scrolling by ${scrollAmount}px`);

      window.scrollBy({
        top: scrollAmount,
        behavior: "smooth",
      });
    }

    return true; // Return true to indicate scroll was performed
  }

  // Function to start/stop autoscroll
  function toggleAutoscroll() {
    if (autoscrollInterval) {
      // Stop autoscroll
      console.log("[Autoscroll] Stopping autoscroll");
      clearInterval(autoscrollInterval);
      autoscrollInterval = null;
      // Set background to dark red when autoscroll is disabled
      navigationControl.style.backgroundColor = "rgba(139, 0, 0, 0.7)";
      // Clear countdown
      countdownValue = null;
      updateNavigationDisplay();
      console.log("[Autoscroll] Autoscroll stopped");
    } else {
      // Start autoscroll
      console.log("[Autoscroll] Starting autoscroll");
      // Set background to dark when autoscroll is enabled
      navigationControl.style.backgroundColor = "rgba(0, 0, 0, 0.7)";

      // Function to perform scroll and schedule next one
      var lastWaitTime = 1000; // Start with 1 second default
      var countdownTimer = null;

      const scroll = () => {
        console.log("[Autoscroll] Scroll timer fired");

        // Perform space-like scroll
        const scrollPerformed = performSpaceScroll();

        if (!scrollPerformed) {
          // Images are still loading, retry after a short delay
          console.log("[Autoscroll] Retrying scroll in 500ms");
          setTimeout(() => {
            scroll(); // Retry the scroll
          }, 500);
          return; // Exit early
        }

        // Don't update page number during autoscroll
        // Keep currentPage fixed at the URL page number

        // Update image number based on visible images (using the first visible image index)
        const images = Array.from(document.querySelectorAll("img"));
        const viewportTop = window.pageYOffset;
        const viewportBottom = viewportTop + window.innerHeight;
        let totalImages = images.length;

        // Find the first visible image index
        for (let i = 0; i < images.length; i++) {
          const img = images[i];
          const rect = img.getBoundingClientRect();
          const imgTop = rect.top + window.pageYOffset;

          if (imgTop >= viewportTop && imgTop < viewportBottom) {
            // Found first visible image - set current image number
            currentImageNumber = i + 1;
            break;
          }
        }

        // Count visible images after scroll for next interval
        setTimeout(() => {
          const visibleImages = countVisibleImages();
          const newWaitTime =
            Math.ceil(visibleImages / IMAGES_PER_SECOND) * 1000 + 1000; // Calculate based on IMAGES_PER_SECOND and add 1 second

          console.log(
            `[Autoscroll] Next wait time: ${newWaitTime}ms (${visibleImages} images / ${IMAGES_PER_SECOND} = ${
              visibleImages / IMAGES_PER_SECOND
            } seconds, rounded up, plus 1 second)`,
          );

          // Set up countdown display
          if (countdownTimer) clearInterval(countdownTimer);

          const totalSeconds = Math.ceil(newWaitTime / 1000);
          let secondsLeft = totalSeconds;

          // Update countdown display function
          const updateCountdown = () => {
            countdownValue = secondsLeft;
            updateNavigationDisplay();
            secondsLeft--;

            if (secondsLeft < 0) {
              clearInterval(countdownTimer);
            }
          };

          // Initial update
          updateCountdown();

          // Set interval for countdown
          countdownTimer = setInterval(updateCountdown, 1000);

          // Only update interval if wait time has changed significantly
          if (newWaitTime !== lastWaitTime) {
            lastWaitTime = newWaitTime;

            // Clear existing interval and set new one with updated wait time
            if (autoscrollInterval) {
              clearInterval(autoscrollInterval);
              autoscrollInterval = setInterval(scroll, newWaitTime);
              console.log(
                `[Autoscroll] Timer updated with ${newWaitTime}ms interval`,
              );
            }
          }
        }, 500); // Wait 500ms for scroll to complete before counting images
      };

      // Calculate initial wait time based on current visible images
      const initialVisibleImages = countVisibleImages();
      const initialWaitTime =
        Math.ceil(initialVisibleImages / IMAGES_PER_SECOND) * 1000 + 1000;
      lastWaitTime = initialWaitTime;

      // Set up initial countdown display
      if (countdownTimer) clearInterval(countdownTimer);

      const totalSeconds = Math.ceil(initialWaitTime / 1000);
      let secondsLeft = totalSeconds;

      // Update countdown display function
      const updateInitialCountdown = () => {
        countdownValue = secondsLeft;
        updateNavigationDisplay();
        secondsLeft--;

        if (secondsLeft < 0) {
          clearInterval(countdownTimer);
        }
      };

      // Initial update
      updateInitialCountdown();

      // Set interval for countdown
      countdownTimer = setInterval(updateInitialCountdown, 1000);

      console.log(`[Autoscroll] Initial wait time: ${initialWaitTime}ms`);

      // Start with initial scroll immediately
      scroll();

      // Set up the interval
      autoscrollInterval = setInterval(scroll, initialWaitTime);
      console.log("[Autoscroll] Autoscroll started with interval");
    }
  }

  // Only track page and image for internal use (not displayed to user)
  // We're already tracking these variables above, so just use those
  var totalPages = Math.ceil(
    window.images && window.images.length
      ? window.images.length / (window.numColumns * 5)
      : 100,
  ); // Estimate

  // Add keyboard event listener
  document.addEventListener("keydown", (event) => {
    console.log(
      `[Keyboard] Key pressed: ${event.key} (keyCode: ${event.keyCode})`,
    );

    if (event.key === "s" || event.key === "S") {
      console.log("[Keyboard] 's' key detected, toggling autoscroll");
      event.preventDefault();
      toggleAutoscroll();
    }

    // Handle space key to check if images are loaded before scrolling
    if (event.key === " " || event.keyCode === 32) {
      if (!areAllViewportImagesLoaded()) {
        console.log("[Manual Scroll] Preventing scroll - images still loading");
        event.preventDefault();
      }
    }
  });

  // Store the automatic start timer
  let autoStartTimer = null;

  // Automatically start autoscrolling after 5 seconds
  console.log("[Autoscroll] Will start automatically in 5 seconds...");
  autoStartTimer = setTimeout(() => {
    console.log("[Autoscroll] Starting automatic autoscroll");
    toggleAutoscroll();
  }, 5000);

  // Add listener to cancel auto-start on any key press
  document.addEventListener(
    "keydown",
    (event) => {
      if (autoStartTimer) {
        console.log("[Autoscroll] Key pressed, cancelling automatic start");
        clearTimeout(autoStartTimer);
        autoStartTimer = null;
      }
    },
    { once: true },
  ); // Remove listener after first key press

  // Add wheel event listener to prevent scrolling when images are loading
  document.addEventListener(
    "wheel",
    (event) => {
      if (!areAllViewportImagesLoaded()) {
        console.log(
          "[Manual Scroll] Preventing wheel scroll - images still loading",
        );
        event.preventDefault();
      }
    },
    { passive: false },
  );
});
