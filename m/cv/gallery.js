function setBodyMarginToZero() {
  document.body.style.margin = "0";
}

// Function to get blurhash from hashImages array by filename
function getBlurhashByFilename(filename) {
  // Quick check if we have what we need
  if (!window.hashImages || !filename) {
    console.warn(
      `Cannot get blurhash for ${filename} - hashImages not available or filename missing`
    );
    return null;
  }

  // Log what we're looking for
  console.log(`Searching for blurhash for ${filename}`);

  // Try to find the image in the hashImages array
  for (let i = 0; i < window.hashImages.length; i++) {
    const img = window.hashImages[i];

    // Skip if missing filename or blurhash
    if (!img || !img.filename || !img.blurhash) continue;

    // Check if this is the image we're looking for
    if (img.filename === filename) {
      console.log(
        `Found blurhash for ${filename}: ${img.blurhash.substring(0, 20)}...`
      );

      // Validate the blurhash - should be 600 characters (6 bytes per 100 colors in 10x10 grid)
      if (img.blurhash.length !== 600) {
        console.warn(
          `Blurhash for ${filename} has unexpected length: ${img.blurhash.length} chars, expected 600 chars`
        );
        // Continue anyway, don't return null
      }

      return img.blurhash;
    }
  }

  // Try one more time with just the filename (no path)
  // This handles cases where the path in hashImages doesn't match the path in the image
  const basename = filename.split("/").pop();
  if (basename !== filename) {
    console.log(`Trying again with basename: ${basename}`);

    for (let i = 0; i < window.hashImages.length; i++) {
      const img = window.hashImages[i];

      // Skip if missing filename or blurhash
      if (!img || !img.filename || !img.blurhash) continue;

      // Compare basenames
      const imgBasename = img.filename.split("/").pop();

      if (imgBasename === basename) {
        console.log(
          `Found blurhash for ${basename}: ${img.blurhash.substring(0, 20)}...`
        );

        // Validate the blurhash - should be 600 characters (6 bytes per 100 colors in 10x10 grid)
        if (img.blurhash.length !== 600) {
          console.warn(
            `Blurhash for ${basename} has unexpected length: ${img.blurhash.length} chars, expected 600 chars`
          );
          // Continue anyway, don't return null
        }

        return img.blurhash;
      }
    }
  }

  console.warn(
    `No blurhash found for ${filename} after checking ${window.hashImages.length} images`
  );
  return null;
}

// Function to render a 4x4 blurhash grid on a canvas
function renderBlurhashGrid(image, blurhash) {
  console.log(
    `Rendering blurhash grid with hash: ${
      blurhash ? blurhash.substring(0, 20) + "..." : "null"
    }`
  );
  console.log(`Image dimensions: ${image.width}x${image.height}`);

  // Create a canvas element for the blurhash grid
  const canvas = document.createElement("canvas");

  // Get the aspect ratio from the image object or find it in hashImages
  let aspectRatio = 1;

  if (image.dataset && image.dataset.filename) {
    const filename = image.dataset.filename;
    const imgData = window.hashImages.find(
      (img) =>
        img.filename === filename ||
        img.filename.split("/").pop() === filename.split("/").pop()
    );

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

  // If no valid blurhash, fill with default orange
  if (!blurhash || blurhash.length !== 600) {
    console.warn(
      `Invalid blurhash (length: ${
        blurhash ? blurhash.length : 0
      }), expected 600 chars. Using orange fallback`
    );
    ctx.fillStyle = "#FF8C00";
    ctx.fillRect(0, 0, width, width);
    return canvas;
  }

  console.log(
    `Valid blurhash found (length: ${blurhash.length}), rendering 10x10 grid`
  );

  // Draw the 10x10 grid from the blurhash
  try {
    // Create a higher-resolution canvas for better blurring
    const offscreenCanvas = document.createElement("canvas");
    const scale = 3; // Higher resolution for smoother blur
    offscreenCanvas.width = width * scale;
    offscreenCanvas.height = height * scale;
    const offCtx = offscreenCanvas.getContext("2d");

    // Extract RGB colors from the blurhash
    const colors = [];
    for (let i = 0; i < 100; i++) {
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

    console.log(`Parsed ${colors.length} RGB colors from blurhash`);

    // Generate smooth gradient canvas
    const cellWidth = (width * scale) / 10;
    const cellHeight = (height * scale) / 10;

    // First draw the base grid with rectangles
    for (let y = 0; y < 10; y++) {
      for (let x = 0; x < 10; x++) {
        const index = y * 10 + x;
        const color = colors[index];

        // Draw the rectangle with RGB value
        offCtx.fillStyle = `rgb(${color.r}, ${color.g}, ${color.b})`;
        offCtx.fillRect(x * cellWidth, y * cellHeight, cellWidth, cellHeight);
      }
    }

    // Calculate blur sizes relative to image dimensions
    const smallestDim = Math.min(offscreenCanvas.width, offscreenCanvas.height);
    const baseBlur = Math.max(4, Math.round(smallestDim / 50)); // Scales with image size

    // Apply multiple blur passes with different radii for a much smoother result
    // First blur pass - medium blur (scaled to image size)
    offCtx.filter = `blur(${baseBlur * 1.5}px)`;
    offCtx.globalAlpha = 0.9;
    offCtx.drawImage(offscreenCanvas, 0, 0);

    // Second blur pass - larger blur
    offCtx.filter = `blur(${baseBlur * 2.5}px)`;
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

    console.log(
      `Blurhash rendered with full RGB colors and visual enhancements`
    );
  } catch (mainError) {
    console.warn("Failed to apply enhanced blur:", mainError);

    try {
      // Fall back to simple rendering if enhanced version fails
      const cellWidth = width / 10;
      const cellHeight = height / 10;
      for (let y = 0; y < 10; y++) {
        for (let x = 0; x < 10; x++) {
          const index = y * 10 + x;
          const startIndex = index * 6;
          if (startIndex + 6 <= blurhash.length) {
            const hexColor = blurhash.substring(startIndex, startIndex + 6);
            const r = parseInt(hexColor.substring(0, 2), 16);
            const g = parseInt(hexColor.substring(2, 4), 16);
            const b = parseInt(hexColor.substring(4, 6), 16);

            if (!isNaN(r) && !isNaN(g) && !isNaN(b)) {
              ctx.fillStyle = `rgb(${r}, ${g}, ${b})`;
              ctx.fillRect(
                x * cellWidth,
                y * cellHeight,
                cellWidth,
                cellHeight
              );
            }
          }
        }
      }

      // Add scaled blur if possible
      try {
        // Calculate blur size based on image dimensions
        const smallestDim = Math.min(canvas.width, canvas.height);
        const baseBlur = Math.max(3, Math.round(smallestDim / 40)); // Scale blur with image

        ctx.filter = `blur(${baseBlur}px)`;
        ctx.drawImage(canvas, 0, 0);

        // Second pass with lighter blur
        ctx.filter = `blur(${baseBlur * 0.7}px)`;
        ctx.globalAlpha = 0.5;
        ctx.drawImage(canvas, 0, 0);
        ctx.globalAlpha = 1.0;
      } catch (blurError) {
        // Ignore if blur fails
        console.warn("Basic blur failed, continuing without blur:", blurError);
      }
    } catch (fallbackError) {
      console.error("Even fallback rendering failed:", fallbackError);
      // Last resort - orange fallback
      ctx.fillStyle = "#FF8C00";
      ctx.fillRect(0, 0, width, width);
    }
  }

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

    // Always calculate aspect ratio from image dimensions
    if (image.width && image.height) {
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
  const placeholder =
    "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/wcAAgAB/PrlqscAAAAASUVORK5CYII=";

  element.src = placeholder;
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

function scrollToRandomImage(className) {
  // Get all elements with the specified class
  const images = document.querySelectorAll(`.${className}`);

  if (images.length === 0) {
    console.log("No images found with the given class.");
    return;
  }

  // Select a random image from the list
  const randomIndex = Math.floor(Math.random() * images.length - 1000);
  const randomImage = images[randomIndex];

  // Scroll to the random image
  randomImage.scrollIntoView({ behavior: "auto", block: "center" });
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

  // Check if hashImages is available from blurhash.js
  if (typeof window.hashImages !== "undefined") {
    console.log(
      `Found hashImages array with ${window.hashImages.length} images`
    );

    // Log the first few entries for debugging
    if (window.hashImages.length > 0) {
      console.log(
        "First few entries:",
        window.hashImages.slice(0, 2).map((img) => ({
          filename: img.filename,
          blurhash: img.blurhash
            ? img.blurhash.length > 20
              ? img.blurhash.substring(0, 20) + "..."
              : img.blurhash
            : "none",
        }))
      );
    }
  } else {
    console.warn(
      "hashImages not found - blurhash.js must be included before gallery.js"
    );
  }

  setBodyMarginToZero();

  if ("IntersectionObserver" in window) {
    const lazyloadImages = document.querySelectorAll(".lazyload");

    // Track which images have already had their blur rendered
    const blurRenderedImages = new Set();

    // Track in-flight image loading requests
    let inflightRequests = 0;
    const maxInflightRequests = numColumns + 3 || 6; // Column count plus 3 additional concurrent loads
    const imageLoadQueue = []; // Queue for pending image loads

    // Function to process the next image in the queue if under the cap
    const processImageLoadQueue = () => {
      // If we're under the cap and have images to load, load the next one
      if (inflightRequests < maxInflightRequests && imageLoadQueue.length > 0) {
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
        console.log(`Image loaded: ${filename}`);

        // Get the actual image dimensions
        const actualWidth = lazyImage.naturalWidth;
        const actualHeight = lazyImage.naturalHeight;
        const actualAspectRatio = actualWidth / actualHeight;

        console.log(
          `Actual image dimensions: ${actualWidth}x${actualHeight}, aspect ratio: ${actualAspectRatio}`
        );

        // Check if we had the correct aspect ratio from metadata
        const imgData = window.hashImages.find(
          (img) =>
            img.filename === filename ||
            img.filename.split("/").pop() === filename.split("/").pop()
        );

        const metadataAspectRatio =
          imgData && imgData.width && imgData.height
            ? imgData.width / imgData.height
            : null;

        // Log if aspect ratio from metadata doesn't match actual
        if (
          metadataAspectRatio &&
          Math.abs(metadataAspectRatio - actualAspectRatio) > 0.01
        ) {
          console.warn(
            `Aspect ratio mismatch: metadata=${metadataAspectRatio.toFixed(
              3
            )}, actual=${actualAspectRatio.toFixed(3)}`
          );
        }

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

      // Look for blurhash in hashImages array
      const filename = lazyImage.dataset.filename;
      const blurhash = getBlurhashByFilename(filename);

      if (blurhash) {
        console.log(`Rendering blurhash grid for ${filename} from blurhash`);

        // Create wrapper div for positioning
        // Get the aspect ratio from the image data if available
        const img = window.hashImages.find(
          (img) =>
            img.filename === filename ||
            img.filename.split("/").pop() === filename.split("/").pop()
        );
        const aspectRatio =
          img && img.width && img.height ? img.width / img.height : 1;

        const wrapper = document.createElement("div");
        wrapper.style.position = "relative";
        wrapper.style.display = "inline-block";
        wrapper.style.width = "100%";
        wrapper.style.aspectRatio = `${aspectRatio}`; // Use calculated aspect ratio instead of 1:1
        wrapper.style.overflow = "hidden"; // Prevent overflow

        // Render blurhash canvas
        const canvas = renderBlurhashGrid(lazyImage, blurhash);

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
      } else {
        // Use default orange
        console.log(`No blurhash found for ${filename}, using default orange`);
        lazyImage.style.backgroundColor = "#FF8C00";
      }
    };

    // Separate observer for rendering the blur - renders blur when element is approaching viewport
    let blurRenderObserver = new IntersectionObserver(
      (entries, observer) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            let lazyImage = entry.target;

            // Immediately render the blur
            renderBlur(lazyImage);

            // Unobserve this image for blur rendering
            blurRenderObserver.unobserve(lazyImage);
          }
        });
      },
      {
        rootMargin: "300px", // Start checking when within 300px of viewport
        threshold: 0, // Trigger as soon as any part intersects with the expanded margin
      }
    );

    // Image loading observer - queues images for loading when they're visible
    let imageLoadObserver = new IntersectionObserver(
      (entries, observer) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            let lazyImage = entry.target;

            // Queue this image for loading or load immediately if under the cap
            if (inflightRequests < maxInflightRequests) {
              loadImage(lazyImage);
            } else {
              console.log(`Queueing image: ${lazyImage.dataset.filename}`);
              imageLoadQueue.push(lazyImage);
            }

            // Unobserve this image for loading
            imageLoadObserver.unobserve(lazyImage);
          }
        });
      },
      {
        rootMargin: "0px", // No margin
        threshold: 0.25, // 25% of the image must be visible
      }
    );

    // Observe all lazyload images with both observers
    lazyloadImages.forEach((lazyImage) => {
      blurRenderObserver.observe(lazyImage);
      imageLoadObserver.observe(lazyImage);
    });
  }

  const moveFirstImageToEnd = (cell) => {
    const images = cell.getElementsByTagName("img");
    if (images.length > 5) {
      const firstImage = images[0];

      cell.appendChild(images[0]);
      cell.appendChild(images[1]);
      cell.appendChild(images[2]);
      cell.appendChild(images[3]);
      cell.appendChild(images[4]);
    }
  };

  const processTable = () => {
    for (let row of tableBody.rows) {
      for (let cell of row.cells) {
        // moveFirstImageToEnd(cell);
      }
    }
  };

  const moveFirstTdToEnd = () => {
    for (let row of tableBody.rows) {
      if (row.cells.length > 0) {
        const firstTd = row.cells[0];
        row.appendChild(firstTd); // Move the first TD to the end of the row
      }
    }
  };

  const autoScroll = () => {
    if (autos == true) {
      if (areVisibleImagesLoaded() == true) {
        processTable();
        //moveFirstTdToEnd();
        //window.scrollBy(0, window.innerHeight);
        scrollToPartialImage();
      }
      //setTimeout(autoScroll, 2000);
    }
  };

  // Event listener for keydown event to check for 'v' key
  document.addEventListener("keydown", (event) => {
    if (event.key === "v") {
      logFullyVisibleImages();
      console.log(`v key found ${event.key}`);
    } else if (event.key === "f") {
    } else if (event.key === "s") {
      autos = !autos;
      if (autos == true) {
        autoScroll();
        console.log(`started autoscrolling ${event.key}`);
      } else {
        console.log(`stopped autoscrolling ${event.key}`);
      }
    } else if (event.key >= "a" && event.key <= "z") {
      console.log(`other key found ${event.key} ${keySequence}`);
      keySequence += event.key;
      if (keySequence.endsWith("qwertz")) {
        console.log(`restoring display: key ${event.key}`);
        keySequence = "";
        overlay.style.width = "0";
        overlay.style.height = "0";
      } else {
        console.log(`hiding display: key ${event.key}`);
        autos = false;
        overlay.style.width = "100%";
        overlay.style.height = "100%";
      }
    }
  });

  window.addEventListener("scroll", () => {
    if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 2) {
      if (eop == false) {
        eop = true;
        //setTimeout(autoScroll, 5000);
      }
    }
  });

  if (selectMode == "no") {
    setTimeout(function () {
      const event = new KeyboardEvent("keydown", {
        key: "s",
        keyCode: 115,
        code: "KeyS",
        which: 115,
        shiftKey: false,
        ctrlKey: false,
        metaKey: false,
      });

      document.dispatchEvent(event);
    }, 30000);
  }
});
