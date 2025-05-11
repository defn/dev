// Default blurhash colors (4x4 grid) in hexadecimal format
// Creates a more visually interesting pattern with orange gradient
// that resembles a flame or abstract shape
const defaultBlurhash =
  "F7941DEA8219D5651CE38A26" + // Row 1: Top gradient (lighter oranges)
  "CB5719E07B20F0AD38BC6C18" + // Row 2: Upper middle (brighter oranges)
  "A33A09D55216F29C41892C05" + // Row 3: Lower middle (darker oranges)
  "7D2806B14A12E88B3D6B1E02"; // Row 4: Bottom gradient (deepest oranges)

function setBodyMarginToZero() {
  document.body.style.margin = "0";
}

// Calculate the number of columns based on screen size and device
function calculateColumns() {
  const userAgent = navigator.userAgent || navigator.vendor || window.opera;
  const isMobile =
    /android|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(
      userAgent.toLowerCase(),
    );

  if (basePath == "replicate/img") {
    return 1;
  } else {
    if (isMobile) {
      return Math.floor(window.innerWidth / 490);
    } else {
      return Math.floor(window.innerWidth / 300);
    }
  }
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

  // Calculate number of columns
  numColumns = calculateColumns();

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
    // Set dark orange background for loading state
    img.style.backgroundColor = "#FF8C00";
    if (image.width != 400 && image.height != 400) {
      const aspectRatio = image.width / image.height;
      img.height = width / aspectRatio;
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

// Convert hex string to RGB array
function hexToRgb(hex) {
  const r = parseInt(hex.substring(0, 2), 16);
  const g = parseInt(hex.substring(2, 4), 16);
  const b = parseInt(hex.substring(4, 6), 16);
  return [r, g, b];
}

// Get blurhash from image tag attribute or use default
function generateBlurHash(image) {
  // Check if image has a blurhash attribute
  if (image && image.dataset && image.dataset.blurhash) {
    // Return the blurhash string directly - always a hex string
    return image.dataset.blurhash;
  }

  // If no hash in data attribute, return default
  return defaultBlurhash;
}

// Helper function to convert HSL to RGB
function hslToRgb(h, s, l) {
  s /= 100;
  l /= 100;

  const c = (1 - Math.abs(2 * l - 1)) * s;
  const x = c * (1 - Math.abs(((h / 60) % 2) - 1));
  const m = l - c / 2;

  let r, g, b;

  if (0 <= h && h < 60) {
    [r, g, b] = [c, x, 0];
  } else if (60 <= h && h < 120) {
    [r, g, b] = [x, c, 0];
  } else if (120 <= h && h < 180) {
    [r, g, b] = [0, c, x];
  } else if (180 <= h && h < 240) {
    [r, g, b] = [0, x, c];
  } else if (240 <= h && h < 300) {
    [r, g, b] = [x, 0, c];
  } else {
    [r, g, b] = [c, 0, x];
  }

  return [
    Math.round((r + m) * 255),
    Math.round((g + m) * 255),
    Math.round((b + m) * 255)
  ];
}

// Render blurhash to canvas with a 4x4 grid pattern
function renderBlurHash(hash, canvas, width, height) {
  const ctx = canvas.getContext('2d');

  // Clear canvas first
  ctx.clearRect(0, 0, width, height);

  // Choose a pattern type (more complex shapes)
  const patternType = Math.floor(Math.random() * 4);

  // No need to check for old format - always expect a hex string

  // Extract the 16 colors from the hash string (each color is 6 hex chars)
  const colors = [];
  for (let i = 0; i < 16; i++) {
    const startIdx = i * 6;
    const colorHex = hash.substring(startIdx, startIdx + 6);
    colors.push(hexToRgb(colorHex));
  }

  // Cell size for 4x4 grid
  const cellWidth = width / 4;
  const cellHeight = height / 4;

  if (patternType === 0) {
    // Pattern 1: Simple 4x4 grid with blurred edges
    for (let y = 0; y < 4; y++) {
      for (let x = 0; x < 4; x++) {
        const color = colors[y * 4 + x];
        ctx.fillStyle = `rgb(${color[0]}, ${color[1]}, ${color[2]})`;
        ctx.fillRect(x * cellWidth, y * cellHeight, cellWidth, cellHeight);
      }
    }
  }
  else if (patternType === 1) {
    // Pattern 2: Overlapping circles
    for (let y = 0; y < 4; y++) {
      for (let x = 0; x < 4; x++) {
        const color = colors[y * 4 + x];
        const centerX = (x + 0.5) * cellWidth;
        const centerY = (y + 0.5) * cellHeight;
        const radius = Math.max(cellWidth, cellHeight) * 0.7;

        const gradient = ctx.createRadialGradient(
          centerX, centerY, 0,
          centerX, centerY, radius
        );

        gradient.addColorStop(0, `rgba(${color[0]}, ${color[1]}, ${color[2]}, 0.8)`);
        gradient.addColorStop(1, `rgba(${color[0]}, ${color[1]}, ${color[2]}, 0)`);

        ctx.fillStyle = gradient;
        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, 0, Math.PI * 2);
        ctx.fill();
      }
    }
  }
  else if (patternType === 2) {
    // Pattern 3: Diagonal stripes
    for (let i = 0; i < 8; i++) {
      // Use different colors for different stripes
      const colorIdx = i % 4 + Math.floor(i / 4) * 4; // Distribute colors across the grid
      const color = colors[colorIdx];

      const startX = i < 4 ? 0 : (i - 4) * width / 4;
      const startY = i < 4 ? i * height / 4 : 0;
      const endX = i < 4 ? width : width;
      const endY = i < 4 ? height : (i - 4) * height / 4;

      const gradient = ctx.createLinearGradient(startX, startY, endX, endY);
      gradient.addColorStop(0, `rgba(${color[0]}, ${color[1]}, ${color[2]}, 0.8)`);
      gradient.addColorStop(1, `rgba(${color[0]}, ${color[1]}, ${color[2]}, 0.2)`);

      ctx.fillStyle = gradient;
      ctx.beginPath();
      ctx.moveTo(startX, startY);
      ctx.lineTo(endX, endY);
      ctx.lineTo(i < 4 ? 0 : endX, i < 4 ? endY : height);
      ctx.lineTo(i < 4 ? startX : 0, i < 4 ? 0 : startY);
      ctx.closePath();
      ctx.fill();
    }
  }
  else {
    // Pattern 4: Voronoi-like pattern with more efficient drawing
    const points = [];

    // Create center points for each cell in the 4x4 grid
    for (let y = 0; y < 4; y++) {
      for (let x = 0; x < 4; x++) {
        // Add some randomness to point positions for more organic look
        const offsetX = (Math.random() - 0.5) * cellWidth * 0.5;
        const offsetY = (Math.random() - 0.5) * cellHeight * 0.5;

        points.push({
          x: (x + 0.5) * cellWidth + offsetX,
          y: (y + 0.5) * cellHeight + offsetY,
          color: colors[y * 4 + x]
        });
      }
    }

    // Use an offscreen canvas for more efficient drawing
    const cellSize = 10; // Draw in larger cells for efficiency
    const numCellsX = Math.ceil(width / cellSize);
    const numCellsY = Math.ceil(height / cellSize);

    // Draw using larger cells instead of pixel by pixel for better performance
    for (let cy = 0; cy < numCellsY; cy++) {
      for (let cx = 0; cx < numCellsX; cx++) {
        const x = cx * cellSize + cellSize / 2;
        const y = cy * cellSize + cellSize / 2;

        // Find the closest point
        let minDist = Infinity;
        let closestPoint = null;

        for (const point of points) {
          const dx = x - point.x;
          const dy = y - point.y;
          const dist = dx * dx + dy * dy;

          if (dist < minDist) {
            minDist = dist;
            closestPoint = point;
          }
        }

        // Draw a cell with the color of the closest point
        if (closestPoint) {
          const color = closestPoint.color;
          ctx.fillStyle = `rgb(${color[0]}, ${color[1]}, ${color[2]})`;
          ctx.fillRect(cx * cellSize, cy * cellSize, cellSize, cellSize);
        }
      }
    }

    // Add some gradient overlays for more interesting patterns
    const overlayGradient = ctx.createLinearGradient(0, 0, width, height);
    const randomPoint1 = points[Math.floor(Math.random() * points.length)];
    const randomPoint2 = points[Math.floor(Math.random() * points.length)];
    const randomPoint3 = points[Math.floor(Math.random() * points.length)];

    overlayGradient.addColorStop(0, `rgba(${randomPoint1.color[0]}, ${randomPoint1.color[1]}, ${randomPoint1.color[2]}, 0.3)`);
    overlayGradient.addColorStop(0.5, `rgba(${randomPoint2.color[0]}, ${randomPoint2.color[1]}, ${randomPoint2.color[2]}, 0.1)`);
    overlayGradient.addColorStop(1, `rgba(${randomPoint3.color[0]}, ${randomPoint3.color[1]}, ${randomPoint3.color[2]}, 0.3)`);

    ctx.fillStyle = overlayGradient;
    ctx.fillRect(0, 0, width, height);
  }

  // Apply blur for a smoother appearance
  ctx.filter = 'blur(8px)';
  ctx.drawImage(canvas, 0, 0, width, height);
  ctx.filter = 'none';
}

// Create blurhash canvas for an image
function createBlurCanvas(image, width, height) {
  const canvas = document.createElement('canvas');
  canvas.width = width;
  canvas.height = height;
  canvas.className = 'blurhash-canvas';
  canvas.style.position = 'absolute';
  canvas.style.top = '0';
  canvas.style.left = '0';
  canvas.style.width = '100%';
  canvas.style.height = '100%';

  // Generate and render blurhash using the image's data attribute if available
  const hash = generateBlurHash(image);
  renderBlurHash(hash, canvas, width, height);

  return canvas;
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
  // Queue management for limiting concurrent downloads
  const downloadQueue = [];
  const activeDownloads = new Set();
  // Set download limit to 2x number of columns
  const columnCount = calculateColumns();
  const MAX_CONCURRENT_DOWNLOADS = columnCount * 2;


  setBodyMarginToZero();

  if ("IntersectionObserver" in window) {
    const lazyloadImages = document.querySelectorAll(".lazyload");

    // Function to sort images by distance from top of page
    const sortImagesByPosition = () => {
      return Array.from(downloadQueue).sort((a, b) => {
        return a.getBoundingClientRect().top - b.getBoundingClientRect().top;
      });
    };

    // Function to process the download queue
    const processDownloadQueue = () => {
      // Sort the queue by position from top
      const sortedQueue = sortImagesByPosition();

      // Process up to MAX_CONCURRENT_DOWNLOADS
      while (activeDownloads.size < MAX_CONCURRENT_DOWNLOADS && sortedQueue.length > 0) {
        const nextImage = sortedQueue.shift();
        if (!activeDownloads.has(nextImage) && nextImage.classList.contains('lazyload')) {
          startImageDownload(nextImage);
        }
      }
    };

    // Function to start downloading an image
    const startImageDownload = (lazyImage) => {
      activeDownloads.add(lazyImage);
      lazyImage.removeAttribute("height");

      // Create a wrapper div for positioning
      const wrapper = document.createElement('div');
      wrapper.style.position = 'relative';
      wrapper.style.display = 'inline-block';
      wrapper.style.width = '100%';

      // Get column width for the square dimensions
      const columnWidth = Math.floor(window.innerWidth / columnCount) - 5;
      const width = columnWidth;
      const height = columnWidth; // Make it square

      // Create and add the blurmap canvas
      const blurCanvas = createBlurCanvas(lazyImage, width, height);

      // Set the canvas to take the full width of the container
      blurCanvas.style.width = '100%';
      blurCanvas.style.height = 'auto';
      blurCanvas.style.aspectRatio = '1/1';

      // Replace the image with the wrapper containing both canvas and image
      lazyImage.parentNode.insertBefore(wrapper, lazyImage);
      wrapper.appendChild(blurCanvas);
      wrapper.appendChild(lazyImage);

      // Position the image on top of the canvas
      lazyImage.style.position = 'relative';
      lazyImage.style.zIndex = '2';
      lazyImage.style.width = '100%';

      lazyImage.onload = () => {
        // Remove background color once image is loaded
        lazyImage.style.backgroundColor = "transparent";

        // Fade out the blur canvas
        const fadeOut = () => {
          if (blurCanvas.style.opacity > 0) {
            blurCanvas.style.opacity -= 0.1;
            setTimeout(fadeOut, 30);
          } else {
            blurCanvas.remove();
          }
        };

        blurCanvas.style.opacity = 1;
        setTimeout(fadeOut, 0);

        activeDownloads.delete(lazyImage);
        // Remove from queue if it's still there
        const queueIndex = downloadQueue.indexOf(lazyImage);
        if (queueIndex > -1) {
          downloadQueue.splice(queueIndex, 1);
        }
        // Process next images in queue
        setTimeout(processDownloadQueue, 0);
      };

      lazyImage.onerror = () => {
        // Keep orange background for error state as a visual indicator
        activeDownloads.delete(lazyImage);
        // Process next images in queue
        setTimeout(processDownloadQueue, 0);
      };

      // Load the image after a 100ms delay
      setTimeout(() => {
        lazyImage.src = lazyImage.dataset.src;
        lazyImage.classList.remove("lazyload");
      }, 100);
    };

    let lazyImageObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          let lazyImage = entry.target;
          // Add to download queue if not already loading
          if (!activeDownloads.has(lazyImage) && !downloadQueue.includes(lazyImage)) {
            downloadQueue.push(lazyImage);
            lazyImageObserver.unobserve(lazyImage);
          }
        }
      });
      // Process queue after detecting visible images
      processDownloadQueue();
    },
    {
    rootMargin: "0px", // No margin, only load when fully inside viewport
    threshold: 0.25, // 100% of the image must be visible
  });

    lazyloadImages.forEach((lazyImage) => {
      lazyImageObserver.observe(lazyImage);
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
      setTimeout(autoScroll, 2000);
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
        setTimeout(autoScroll, 5000);
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

      // document.dispatchEvent(event);
    }, 30000);
  }
});
