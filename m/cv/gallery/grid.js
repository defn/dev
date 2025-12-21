/**
 * Grid Layout System
 * Handles masonry-style column layout with balanced distribution
 */

import { state, getImageBasePath } from "./state.js";
import { getAspectRatioFromIndex } from "./blurhash.js";

/**
 * Calculate optimal column count based on viewport width
 * @param {number} viewportWidth - Window width in pixels
 * @param {number} columnWidth - Target column width (default 330)
 * @returns {number} Number of columns (minimum 1)
 */
export function calculateColumnCount(viewportWidth, columnWidth = 330) {
  return Math.max(1, Math.floor(viewportWidth / columnWidth));
}

/**
 * Find the index of the shortest column
 * @param {Array<{totalHeight: number}>} columns - Array of column objects
 * @returns {number} Index of shortest column
 */
export function findShortestColumn(columns) {
  let shortestIndex = 0;
  let shortestHeight = columns[0].totalHeight;

  for (let i = 1; i < columns.length; i++) {
    if (columns[i].totalHeight < shortestHeight) {
      shortestIndex = i;
      shortestHeight = columns[i].totalHeight;
    }
  }

  return shortestIndex;
}

/**
 * Create column DOM structure
 * @param {number} numColumns - Number of columns to create
 * @returns {Array} Array of column objects with element and height tracking
 */
export function createColumnStructure(numColumns) {
  return Array.from({ length: numColumns }, () => {
    const td = document.createElement("td");
    td.setAttribute("valign", "top");
    td.style.textAlign = "center";

    const div = document.createElement("div");
    div.className = "image-container";
    td.appendChild(div);

    return {
      element: td,
      totalHeight: 0,
      contentHeight: 0,
      heightGap: 0,
    };
  });
}

/**
 * Create an image element for the grid
 * @param {Object} image - Image data object
 * @param {number} index - Image index
 * @param {number} standardWidth - Standard image width
 * @param {Function} onClick - Click handler
 * @returns {{element: HTMLAnchorElement, height: number, aspectRatio: number}}
 */
export function createImageElement(image, index, standardWidth, onClick) {
  const img = document.createElement("img");
  img.id = `img-${index}`;
  img.className = "lazyload";
  img.width = standardWidth;

  // Choose image path based on column count
  const imagePath = getImageBasePath();
  img.dataset.src = `${imagePath}/${image.filename}`;
  img.dataset.filename = image.filename;
  img.style.border = "none";
  img.style.outline = "none";

  // Get aspect ratio
  let aspectRatio = 1;
  if (image.width && image.height) {
    aspectRatio = image.width / image.height;
  } else {
    aspectRatio = getAspectRatioFromIndex(image.filename, 1);
  }

  const imgHeight = Math.floor(standardWidth / aspectRatio);
  img.style.aspectRatio = `${aspectRatio}`;
  img.height = imgHeight;

  // Add click handler
  img.onclick = (event) => {
    event.stopPropagation();
    if (onClick) onClick(img, event);
  };

  // Create anchor wrapper
  const anchor = document.createElement("a");
  anchor.id = image.filename;
  anchor.name = image.filename;
  anchor.style.display = "inline-block";
  anchor.style.width = "100%";
  anchor.style.textDecoration = "none";
  anchor.appendChild(img);

  return {
    element: anchor,
    height: imgHeight,
    aspectRatio: aspectRatio,
  };
}

/**
 * Distribute images to columns using greedy algorithm
 * @param {Array} images - Array of image data
 * @param {Array} columns - Array of column objects
 * @param {number} standardWidth - Standard image width
 * @param {Function} onClick - Click handler for images
 * @returns {Array<Array>} Array of image info arrays per column
 */
export function distributeImagesToColumns(
  images,
  columns,
  standardWidth,
  onClick,
) {
  const columnImages = Array.from({ length: columns.length }, () => []);

  images.forEach((image, index) => {
    const imgInfo = createImageElement(image, index, standardWidth, onClick);

    // Find shortest column
    const shortestColumn = findShortestColumn(columns);

    // Add to column
    columnImages[shortestColumn].push(imgInfo);
    columns[shortestColumn].totalHeight += imgInfo.height;
  });

  return columnImages;
}

/**
 * Add images to columns with height equalization
 * @param {Array} columns - Column objects
 * @param {Array<Array>} columnImages - Images per column
 * @param {number} tallestHeight - Height of tallest column
 */
export function populateColumnsWithEqualization(
  columns,
  columnImages,
  tallestHeight,
) {
  let globalImageIndex = 0;

  columns.forEach((column, colIndex) => {
    const images = columnImages[colIndex] || [];
    if (images.length === 0) return;

    // Calculate content height
    let totalContentHeight = images.reduce((sum, img) => sum + img.height, 0);
    totalContentHeight += images.length; // Line breaks
    column.contentHeight = totalContentHeight;
    column.heightGap = tallestHeight - column.totalHeight;
  });

  const tallestContentHeight = Math.max(
    ...columns.map((col) => col.contentHeight || 0),
  );

  columns.forEach((column, colIndex) => {
    const images = columnImages[colIndex] || [];
    if (images.length === 0) return;

    const heightGap = Math.max(0, tallestContentHeight - column.contentHeight);

    if (heightGap <= 0) {
      // Tallest column - no spacing needed
      images.forEach((imgInfo, imgIndex) => {
        state.imagePositionMap.set(imgInfo.element.id, {
          columnIndex: colIndex,
          indexInColumn: imgIndex,
          globalIndex: globalImageIndex++,
        });
        column.element.appendChild(imgInfo.element);
        column.element.appendChild(document.createElement("br"));
      });
    } else if (images.length === 1) {
      // Single image - add spacer at bottom
      state.imagePositionMap.set(images[0].element.id, {
        columnIndex: colIndex,
        indexInColumn: 0,
        globalIndex: globalImageIndex++,
      });
      column.element.appendChild(images[0].element);
      column.element.appendChild(document.createElement("br"));

      const spacer = document.createElement("div");
      spacer.style.height = `${heightGap}px`;
      column.element.appendChild(spacer);
    } else {
      // Multiple images - distribute spacing
      const pixelsNeeded = column.heightGap;
      const pixelsPerImage = Math.floor(pixelsNeeded / images.length);
      let remainingPixels = pixelsNeeded - pixelsPerImage * images.length;

      images.forEach((imgInfo, imgIndex) => {
        state.imagePositionMap.set(imgInfo.element.id, {
          columnIndex: colIndex,
          indexInColumn: imgIndex,
          globalIndex: globalImageIndex++,
        });

        column.element.appendChild(imgInfo.element);
        column.element.appendChild(document.createElement("br"));

        // Add spacing
        let pixelsToAdd = pixelsPerImage;
        if (remainingPixels > 0) {
          pixelsToAdd++;
          remainingPixels--;
        }

        for (let i = 0; i < pixelsToAdd; i++) {
          const pixelSpacer = document.createElement("div");
          pixelSpacer.style.height = "1px";
          column.element.appendChild(pixelSpacer);
        }
      });
    }
  });
}

/**
 * Main grid generation function
 * @param {HTMLElement} tableBody - Table body element to populate
 * @param {Array} images - Array of image data
 * @param {Function} onImageClick - Click handler for images
 * @param {Function} onGridComplete - Callback when grid is complete
 */
export function generateGrid(tableBody, images, onImageClick, onGridComplete) {
  // Update state
  state.numColumns = calculateColumnCount(window.innerWidth);
  state.standardWidth = Math.floor(window.innerWidth / state.numColumns) - 5;

  // Create columns
  const columns = createColumnStructure(state.numColumns);

  // Distribute images
  const columnImages = distributeImagesToColumns(
    images,
    columns,
    state.standardWidth,
    onImageClick,
  );

  // Find tallest column
  const tallestColumnHeight = Math.max(
    ...columns.map((col) => col.totalHeight),
  );

  // Populate with equalization
  populateColumnsWithEqualization(columns, columnImages, tallestColumnHeight);

  // Create table row
  const row = document.createElement("tr");
  columns.forEach((column) => row.appendChild(column.element));
  tableBody.appendChild(row);

  // Calculate total pages after layout
  setTimeout(() => {
    let tallestColumnAfterLayout = 0;
    columns.forEach((column) => {
      const columnHeight = column.element.offsetHeight;
      if (columnHeight > tallestColumnAfterLayout) {
        tallestColumnAfterLayout = columnHeight;
      }
    });

    const viewportHeight = window.innerHeight;
    state.totalPages = Math.ceil(tallestColumnAfterLayout / viewportHeight);
    state.totalImages = images.length;

    if (onGridComplete) {
      onGridComplete();
    }
  }, 500);
}
