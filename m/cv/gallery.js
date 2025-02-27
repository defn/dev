function setBodyMarginToZero() {
  document.body.style.margin = "0";
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
      userAgent.toLowerCase(),
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

  setBodyMarginToZero();

  if ("IntersectionObserver" in window) {
    const lazyloadImages = document.querySelectorAll(".lazyload");

    let lazyImageObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          let lazyImage = entry.target;
          lazyImage.removeAttribute("height");
          lazyImage.src = lazyImage.dataset.src;
          lazyImage.classList.remove("lazyload");
          lazyImageObserver.unobserve(lazyImage);
        }
      });
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

      document.dispatchEvent(event);
    }, 30000);
  }
});
