// This script is designed to work with gallery.js and enhances it with blurhash functionality
// It should be included before gallery.js in your HTML

(function () {
  // Store the original DOMContentLoaded listener
  const originalAddEventListener = document.addEventListener;

  // Override the addEventListener method
  document.addEventListener = function (type, listener, options) {
    if (type === "DOMContentLoaded") {
      // Wrap the original listener to inject our blurhash functionality
      const enhancedListener = function (event) {
        // Log that our enhancer is running
        console.log("Blurhash enhancer activated");

        // Set up blurhash functionality
        setupBlurhash();

        // Call the original listener
        listener(event);
      };

      // Call the original addEventListener with our enhanced listener
      originalAddEventListener.call(this, type, enhancedListener, options);
    } else {
      // For all other event types, use the original behavior
      originalAddEventListener.call(this, type, listener, options);
    }
  };

  function setupBlurhash() {
    // Check if window.hashImages is already available
    if (!window.hashImages) {
      console.warn(
        "hashImages array not found. Make sure blurhash.js is loaded."
      );
      return;
    }

    // Create a mapping from filename to blurhash for quick lookup
    const blurhashMap = {};
    window.hashImages.forEach((img) => {
      if (img.filename && img.blurhash) {
        blurhashMap[img.filename] = img.blurhash;
      }
    });

    // Store the original IntersectionObserver setup from gallery.js
    const originalIntersectionObserver = window.IntersectionObserver;

    // Override IntersectionObserver to inject our blurhash functionality
    window.IntersectionObserver = function (callback, options) {
      // Enhance the callback to apply blurhash before loading
      const enhancedCallback = function (entries, observer) {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            // Apply blurhash placeholder before loading
            const lazyImage = entry.target;
            const filename = lazyImage.dataset.filename;

            if (filename && blurhashMap[filename]) {
              // Apply styling for blurhash placeholder
              applyBlurhashPlaceholder(lazyImage, blurhashMap[filename]);
            }
          }
        });

        // Call the original callback
        callback(entries, observer);
      };

      // Create the original observer with our enhanced callback
      return new originalIntersectionObserver(enhancedCallback, options);
    };
  }

  function applyBlurhashPlaceholder(img, blurhash) {
    // Log that we're applying a blurhash
    console.log(
      `Applying blurhash for ${img.dataset.filename}:`,
      blurhash.substring(0, 20) + "..."
    );

    // Create a placeholder color from the blurhash
    // This is a simplified version that just uses the average color
    // A full implementation would render the actual blurhash pattern
    const hexColor = getColorFromBlurhash(blurhash);

    // Apply the color as background
    img.style.backgroundColor = hexColor;
  }

  function getColorFromBlurhash(blurhash) {
    // A very simple function to extract a color from blurhash
    // For a real implementation, you'd want to use a proper blurhash decoder
    // This just uses the first hex color pair in the string as an approximate color
    if (blurhash && blurhash.length >= 6) {
      const r = parseInt(blurhash.substring(0, 2), 16);
      const g = parseInt(blurhash.substring(2, 4), 16);
      const b = parseInt(blurhash.substring(4, 6), 16);

      if (!isNaN(r) && !isNaN(g) && !isNaN(b)) {
        return `#${blurhash.substring(0, 6)}`;
      }
    }

    // Default color if parsing fails
    return "#FF8C00"; // Original default orange
  }
})();
