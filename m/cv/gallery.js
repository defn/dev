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
function renderBlurhashGrid(image, blurhash, dim = 10) {
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
  const expectedLength = dim * dim * 3 * 2;

  // If no valid blurhash, fill with default orange
  if (!blurhash || blurhash.length !== expectedLength) {
    console.warn(
      `Invalid blurhash (length: ${
        blurhash ? blurhash.length : 0
      }), expected ${expectedLength} chars. Using orange fallback`
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
        radius
      );
      gradient.addColorStop(0, `rgba(${color.r}, ${color.g}, ${color.b}, 0.8)`); // Reduced opacity
      gradient.addColorStop(
        0.5,
        `rgba(${color.r}, ${color.g}, ${color.b}, 0.4)`
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

function generateGrid() {
  // Reference to the table body
  const tableBody = document.getElementById("table-body");

  // Randomly select images for the gallery
  const selectedImages =
    selectMode == "yes"
      ? images
      : Array.from({ length: images.length }, () => {
          return images[Math.floor(Math.random() * images.length)];
        });

  const userAgent = navigator.userAgent || navigator.vendor || window.opera;
  const isMobile =
    /android|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(
      userAgent.toLowerCase()
    );

  if (basePath == "replicate/img") {
    numColumns = 1;
  } else {
    if (isMobile) {
      numColumns = Math.floor(window.innerWidth / 490);
    } else {
      numColumns = Math.floor(window.innerWidth / 300);
    }
  }

  // Initialize an array to hold columns
  const columns = Array.from({ length: numColumns }, () => {
    const td = document.createElement("td");
    td.setAttribute("valign", "top");
    td.style.textAlign = "center";
    const div = document.createElement("div");
    div.className = "image-container";
    td.appendChild(div);
    return td;
  });

  // Distribute selected images round-robin across the columns
  selectedImages.forEach((image, index) => {
    const img = document.createElement("img");
    img.id = `img-${index}`;
    img.className = "lazyload";
    img.width = Math.floor(window.innerWidth / numColumns) - 5;
    img.dataset.src = `${basePath}/${image.filename}`;
    img.dataset.filename = image.filename;
    img.style.border = "none";
    img.style.outline = "none";

    // First try to get dimensions from blurhashIndex, then fall back to image object
    const imgData =
      window.blurhashIndex[image.filename] ||
      window.blurhashIndex[image.filename.split("/").pop()];

    if (imgData && imgData.width && imgData.height) {
      // Use dimensions from blurhashIndex
      const aspectRatio = imgData.width / imgData.height;
      img.style.aspectRatio = `${aspectRatio}`;
      img.height = Math.floor(img.width / aspectRatio);
    } else if (image.width && image.height) {
      // Fall back to dimensions from the image object if available
      const aspectRatio = image.width / image.height;
      img.style.aspectRatio = `${aspectRatio}`;
      img.height = Math.floor(img.width / aspectRatio);
    } else {
      img.height = "auto";
    }
    img.onclick = () => toggleVisibility(img);

    // Append the image to the appropriate column
    columns[index % numColumns].appendChild(img);

    // Add a line break after each image
    columns[index % numColumns].appendChild(document.createElement("br"));
  });

  // Create a row and append the columns to it
  const row = document.createElement("tr");
  columns.forEach((column) => row.appendChild(column));
  tableBody.appendChild(row);
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
        (t) => t.getBoundingClientRect().top === img.getBoundingClientRect().top
      )
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
  fetch(
    `select-${selectMode}?filename=${element.getAttribute("data-filename")}`,
    {
      mode: "no-cors",
    }
  )
    .then((response) => response.text())
    .then((data) => console.log(data))
    .catch((error) => console.error("Error:", error));
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
      const canvas = renderBlurhashGrid(element, blurhash, 10);
      canvas.classList.add("toggle-blur");

      // Position canvas over the image
      canvas.style.position = "absolute";
      canvas.style.top = "0";
      canvas.style.left = "0";
      canvas.style.width = "100%";
      canvas.style.height = "100%";
      canvas.style.zIndex = "3"; // Above the image

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
      // Fallback to simple opacity change if no blurhash is available
      element.style.opacity = element.style.opacity === "0.3" ? "1" : "0.3";
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

document.addEventListener("DOMContentLoaded", () => {
  const tableBody = document.getElementById("table-body");
  const overlay = document.getElementById("overlay");
  let eop = false;
  let keySequence = "";
  let autos = false;
  let autoscrollInterval = null;
  const IMAGES_PER_SECOND = 7; // Number of images that equals 1 second of wait time

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
        `Loading image: ${lazyImage.dataset.filename} (${inflightRequests} in flight)`
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
          `Actual image dimensions: ${actualWidth}x${actualHeight}, aspect ratio: ${actualAspectRatio}`
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

      // Handle image loading errors
      lazyImage.onerror = () => {
        console.error(`Failed to load image: ${lazyImage.dataset.filename}`);
        inflightRequests--;
        processImageLoadQueue();
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
        const canvas = renderBlurhashGrid(lazyImage, blurhash, 10);

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
      }
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
      }
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
      }
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
      }
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
    const viewportTop = window.pageYOffset;
    const viewportBottom = viewportTop + window.innerHeight;

    images.forEach((img) => {
      const rect = img.getBoundingClientRect();
      const imgTop = rect.top + window.pageYOffset;
      const imgBottom = imgTop + rect.height;

      // Check if image is at least partially visible
      if (imgBottom > viewportTop && imgTop < viewportBottom) {
        visibleCount++;
      }
    });

    console.log(`[Autoscroll] Counted ${visibleCount} visible images`);
    return visibleCount;
  }

  // Function to scroll like space key
  function performSpaceScroll() {
    console.log("[Autoscroll] Performing space-like scroll");

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
  }

  // Function to start/stop autoscroll
  function toggleAutoscroll() {
    if (autoscrollInterval) {
      // Stop autoscroll
      console.log("[Autoscroll] Stopping autoscroll");
      clearInterval(autoscrollInterval);
      autoscrollInterval = null;
      console.log("[Autoscroll] Autoscroll stopped");
    } else {
      // Start autoscroll
      console.log("[Autoscroll] Starting autoscroll");

      // Function to perform scroll and schedule next one
      let lastWaitTime = 1000; // Start with 1 second default

      const scroll = () => {
        console.log("[Autoscroll] Scroll timer fired");

        // Perform space-like scroll
        performSpaceScroll();

        // Count visible images after scroll for next interval
        setTimeout(() => {
          const visibleImages = countVisibleImages();
          const newWaitTime =
            Math.ceil(visibleImages / IMAGES_PER_SECOND) * 1000; // Calculate based on IMAGES_PER_SECOND

          console.log(
            `[Autoscroll] Next wait time: ${newWaitTime}ms (${visibleImages} images / ${IMAGES_PER_SECOND} = ${
              visibleImages / IMAGES_PER_SECOND
            } seconds, rounded up)`
          );

          // Only update interval if wait time has changed significantly
          if (newWaitTime !== lastWaitTime) {
            lastWaitTime = newWaitTime;

            // Clear existing interval and set new one with updated wait time
            if (autoscrollInterval) {
              clearInterval(autoscrollInterval);
              autoscrollInterval = setInterval(scroll, newWaitTime);
              console.log(
                `[Autoscroll] Timer updated with ${newWaitTime}ms interval`
              );
            }
          }
        }, 500); // Wait 500ms for scroll to complete before counting images
      };

      // Calculate initial wait time based on current visible images
      const initialVisibleImages = countVisibleImages();
      const initialWaitTime =
        Math.ceil(initialVisibleImages / IMAGES_PER_SECOND) * 1000;
      lastWaitTime = initialWaitTime;

      console.log(`[Autoscroll] Initial wait time: ${initialWaitTime}ms`);

      // Start with initial scroll immediately
      scroll();

      // Set up the interval
      autoscrollInterval = setInterval(scroll, initialWaitTime);
      console.log("[Autoscroll] Autoscroll started with interval");
    }
  }

  // Add keyboard event listener
  document.addEventListener("keydown", (event) => {
    console.log(
      `[Keyboard] Key pressed: ${event.key} (keyCode: ${event.keyCode})`
    );

    if (event.key === "s" || event.key === "S") {
      console.log("[Keyboard] 's' key detected, toggling autoscroll");
      event.preventDefault();
      toggleAutoscroll();
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
  document.addEventListener("keydown", (event) => {
    if (autoStartTimer) {
      console.log("[Autoscroll] Key pressed, cancelling automatic start");
      clearTimeout(autoStartTimer);
      autoStartTimer = null;
    }
  }, { once: true }); // Remove listener after first key press
});
