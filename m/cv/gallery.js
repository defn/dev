function set_body_margin_to_zero() {
  document.body.style.margin = "0";
}

// function to get blurhash from index by filename
function get_blurhash_by_filename(filename) {
  // first check if the filename exists in the index, try both full path and basename
  const entry =
    window.blurhash_index[filename] ||
    window.blurhash_index[filename.split("/").pop()];

  // return the blurhash if entry exists, otherwise return null
  return entry ? entry.blurhash : null;
}

// function to render a 4x4 blurhash grid on a canvas
function render_blurhash_grid(image, blurhash) {
  // create a canvas element for the blurhash grid
  const canvas = document.createElement("canvas");

  // get the aspect ratio from the image object or find it in the blurhash index
  let aspect_ratio = 1;

  if (image.dataset && image.dataset.filename) {
    const filename = image.dataset.filename;
    const img_data =
      window.blurhash_index[filename] ||
      window.blurhash_index[filename.split("/").pop()];

    if (img_data && img_data.width && img_data.height) {
      aspect_ratio = img_data.width / img_data.height;
    }
  }

  // set the canvas dimensions
  const width = image.width || 300;
  const height = width / aspect_ratio;
  canvas.width = width;
  canvas.height = height;

  // position the canvas absolutely over the image
  canvas.style.position = "absolute";
  canvas.style.top = "0";
  canvas.style.left = "0";
  canvas.style.width = "100%";
  canvas.style.height = "100%";
  canvas.style.aspectRatio = `${aspect_ratio}`; // use correct aspect ratio
  canvas.style.objectFit = "contain"; // show full image without cropping
  canvas.style.zIndex = "1"; // below the image (image will have z-index 2)

  // get the drawing context
  const ctx = canvas.getContext("2d");

  // if no valid blurhash, fill with default orange
  if (!blurhash || blurhash.length !== 600) {
    console.warn(
      `invalid blurhash (length: ${
        blurhash ? blurhash.length : 0
      }), expected 600 chars. using orange fallback`
    );
    ctx.fillStyle = "#FF8C00";
    ctx.fillRect(0, 0, width, width);
    return canvas;
  }

  // draw the 10x10 grid from the blurhash
  // create a higher-resolution canvas for better blurring
  const offscreen_canvas = document.createElement("canvas");
  const scale = 3; // higher resolution for smoother blur
  offscreen_canvas.width = width * scale;
  offscreen_canvas.height = height * scale;
  const off_ctx = offscreen_canvas.getContext("2d");

  // extract RGB colors from the blurhash
  const colors = [];
  for (let i = 0; i < 100; i++) {
    const start_index = i * 6;
    if (start_index + 6 <= blurhash.length) {
      // extract RRGGBB hex color
      const hex_color = blurhash.substring(start_index, start_index + 6);

      // parse RGB components
      const r = parseInt(hex_color.substring(0, 2), 16);
      const g = parseInt(hex_color.substring(2, 4), 16);
      const b = parseInt(hex_color.substring(4, 6), 16);

      // validate values
      const valid_r = isNaN(r) ? 128 : r;
      const valid_g = isNaN(g) ? 128 : g;
      const valid_b = isNaN(b) ? 128 : b;

      colors.push({ r: valid_r, g: valid_g, b: valid_b });
    } else {
      colors.push({ r: 128, g: 128, b: 128 }); // fallback gray
    }
  }

  // generate smooth gradient canvas
  const cell_width = (width * scale) / 10;
  const cell_height = (height * scale) / 10;

  // first draw the base grid with rectangles
  for (let y = 0; y < 10; y++) {
    for (let x = 0; x < 10; x++) {
      const index = y * 10 + x;
      const color = colors[index];

      // draw the rectangle with RGB value
      off_ctx.fillStyle = `rgb(${color.r}, ${color.g}, ${color.b})`;
      off_ctx.fillRect(
        x * cell_width,
        y * cell_height,
        cell_width,
        cell_height
      );
    }
  }

  // calculate blur sizes relative to image dimensions
  const smallest_dim = Math.min(
    offscreen_canvas.width,
    offscreen_canvas.height
  );
  const base_blur = Math.max(4, Math.round(smallest_dim / 50)); // scales with image size

  // apply multiple blur passes with different radii for a much smoother result
  // first blur pass - medium blur (scaled to image size)
  off_ctx.filter = `blur(${base_blur * 1.5}px)`;
  off_ctx.globalAlpha = 0.9;
  off_ctx.drawImage(offscreen_canvas, 0, 0);

  // second blur pass - larger blur
  off_ctx.filter = `blur(${base_blur * 2.5}px)`;
  off_ctx.globalAlpha = 0.7;
  off_ctx.drawImage(offscreen_canvas, 0, 0);

  // third blur pass - fine detail blur
  off_ctx.filter = `blur(${base_blur * 0.5}px)`;
  off_ctx.globalAlpha = 0.4;
  off_ctx.drawImage(offscreen_canvas, 0, 0);

  // reset alpha
  off_ctx.globalAlpha = 1.0;

  // normalize and enhance contrast
  // tint with a slight color to make it look nicer than pure grayscale
  const enhanced_canvas = document.createElement("canvas");
  enhanced_canvas.width = width;
  enhanced_canvas.height = height;
  const enh_ctx = enhanced_canvas.getContext("2d");

  // draw the blurred image at regular size
  enh_ctx.drawImage(offscreen_canvas, 0, 0, width, height);

  // apply slight enhancement for better visual appearance
  const image_data = enh_ctx.getImageData(0, 0, width, height);
  const data = image_data.data;

  // calculate average brightness
  let total_brightness = 0;
  for (let i = 0; i < colors.length; i++) {
    const color = colors[i];
    total_brightness += (color.r + color.g + color.b) / 3;
  }
  const avg_brightness = total_brightness / colors.length;

  // apply adaptive enhancement based on image brightness
  // analyze brightness to determine appropriate enhancement values
  let brightness_class = "medium";
  if (avg_brightness < 80) brightness_class = "dark";
  if (avg_brightness > 170) brightness_class = "light";

  // set enhancement parameters based on brightness class
  let contrast, saturation, vibrance;
  switch (brightness_class) {
    case "dark":
      contrast = 1.2; // higher contrast for dark images
      saturation = 1.3; // higher saturation for dark images
      vibrance = 1.15; // boost vibrance for dark images
      break;
    case "light":
      contrast = 1.05; // lower contrast for light images
      saturation = 1.1; // lower saturation for light images
      vibrance = 1.05; // lower vibrance for light images
      break;
    default: // medium
      contrast = 1.15; // medium contrast
      saturation = 1.25; // medium saturation
      vibrance = 1.1; // medium vibrance
  }

  // process each pixel with adaptive enhancements
  for (let i = 0; i < data.length; i += 4) {
    // get RGB values
    let r = data[i];
    let g = data[i + 1];
    let b = data[i + 2];

    // apply adaptive contrast - move values away from middle gray (128)
    r = 128 + (r - 128) * contrast;
    g = 128 + (g - 128) * contrast;
    b = 128 + (b - 128) * contrast;

    // calculate luminance-preserving grayscale
    const gray = r * 0.299 + g * 0.587 + b * 0.114;

    // apply vibrance (boosts saturation more for less saturated colors)
    const max_channel = Math.max(r, g, b);
    const min_channel = Math.min(r, g, b);
    const saturation_amount = (max_channel - min_channel) / 255;
    const dynamic_sat_factor = saturation * (1 - saturation_amount * vibrance);

    // apply adaptive saturation with vibrance
    r = gray + (r - gray) * dynamic_sat_factor;
    g = gray + (g - gray) * dynamic_sat_factor;
    b = gray + (b - gray) * dynamic_sat_factor;

    // clamp values
    data[i] = Math.min(255, Math.max(0, r));
    data[i + 1] = Math.min(255, Math.max(0, g));
    data[i + 2] = Math.min(255, Math.max(0, b));
  }

  enh_ctx.putImageData(image_data, 0, 0);

  // final draw to the main canvas
  ctx.drawImage(enhanced_canvas, 0, 0);

  return canvas;
}

function generate_grid() {
  // reference to the table body
  const table_body = document.getElementById("table-body");

  // randomly select images for the gallery
  const selected_images =
    select_mode == "yes"
      ? images
      : Array.from({ length: images.length }, () => {
          return images[Math.floor(Math.random() * images.length)];
        });

  const user_agent = navigator.userAgent || navigator.vendor || window.opera;
  const is_mobile =
    /android|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(
      user_agent.toLowerCase()
    );

  if (base_path == "replicate/img") {
    num_columns = 1;
  } else {
    if (is_mobile) {
      num_columns = Math.floor(window.innerWidth / 490);
    } else {
      num_columns = Math.floor(window.innerWidth / 300);
    }
  }

  // initialize an array to hold columns
  const columns = Array.from({ length: num_columns }, () => {
    const td = document.createElement("td");
    td.setAttribute("valign", "top");
    td.style.textAlign = "center";
    const div = document.createElement("div");
    div.className = "image-container";
    td.appendChild(div);
    return td;
  });

  // distribute selected images round-robin across the columns
  selected_images.forEach((image, index) => {
    const img = document.createElement("img");
    img.id = `img-${index}`;
    img.className = "lazyload";
    img.width = Math.floor(window.innerWidth / num_columns) - 5;
    img.dataset.src = `${base_path}/${image.filename}`;
    img.dataset.filename = image.filename;

    // first try to get dimensions from blurhash_index, then fall back to image object
    const img_data =
      window.blurhash_index[image.filename] ||
      window.blurhash_index[image.filename.split("/").pop()];

    if (img_data && img_data.width && img_data.height) {
      // use dimensions from blurhash_index
      const aspect_ratio = img_data.width / img_data.height;
      img.style.aspectRatio = `${aspect_ratio}`;
      img.height = Math.floor(img.width / aspect_ratio);
    } else if (image.width && image.height) {
      // fall back to dimensions from the image object if available
      const aspect_ratio = image.width / image.height;
      img.style.aspectRatio = `${aspect_ratio}`;
      img.height = Math.floor(img.width / aspect_ratio);
    } else {
      img.height = "auto";
    }
    img.onclick = () => toggle_visibility(img);

    // append the image to the appropriate column
    columns[index % num_columns].appendChild(img);

    // add a line break after each image
    columns[index % num_columns].appendChild(document.createElement("br"));
  });

  // create a row and append the columns to it
  const row = document.createElement("tr");
  columns.forEach((column) => row.appendChild(column));
  table_body.appendChild(row);
}

function toggle_visibility(element) {
  toggle_hidden(element);
  fetch(
    `select-${select_mode}?filename=${element.getAttribute("data-filename")}`,
    {
      mode: "no-cors",
    }
  )
    .then((response) => response.text())
    .then((data) => console.log(data))
    .catch((error) => console.error("error:", error));
}

function toggle_hidden(element) {
  const placeholder =
    "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/wcAAgAB/PrlqscAAAAASUVORK5CYII=";

  element.src = placeholder;
}

// function to process the next image in the queue if under the cap
function process_image_load_queue(
  inflight_requests,
  max_inflight_requests,
  image_load_queue
) {
  // if we're under the cap and have images to load, load the next one
  if (
    inflight_requests < max_inflight_requests &&
    image_load_queue.length > 0
  ) {
    // sort the queue to prioritize visible images first
    image_load_queue.sort((a, b) => {
      const rect_a = a.getBoundingClientRect();
      const rect_b = b.getBoundingClientRect();

      // is image a visible in viewport?
      const is_a_visible = rect_a.top < window.innerHeight && rect_a.bottom > 0;

      // is image b visible in viewport?
      const is_b_visible = rect_b.top < window.innerHeight && rect_b.bottom > 0;

      if (is_a_visible && !is_b_visible) return -1; // a is visible, b is not
      if (!is_a_visible && is_b_visible) return 1; // b is visible, a is not

      // if both visible or both not visible, prioritize by distance to viewport
      return Math.abs(rect_a.top) - Math.abs(rect_b.top);
    });

    const next_image_to_load = image_load_queue.shift();
    return next_image_to_load;
  }
  return null;
}

// function to load an image
function load_image(
  lazy_image,
  inflight_requests,
  blur_rendered_images,
  max_inflight_requests,
  image_load_queue
) {
  inflight_requests++;
  console.log(
    `loading image: ${lazy_image.dataset.filename} (${inflight_requests} in flight)`
  );

  // add onload handler to fade in the image
  lazy_image.onload = function () {
    // get the filename from the data attribute
    const filename = lazy_image.dataset.filename;

    // get the actual image dimensions
    const actual_width = lazy_image.naturalWidth;
    const actual_height = lazy_image.naturalHeight;
    const actual_aspect_ratio = actual_width / actual_height;

    console.log(
      `actual image dimensions: ${actual_width}x${actual_height}, aspect ratio: ${actual_aspect_ratio}`
    );

    // check if we had the correct aspect ratio from metadata
    const img_data =
      window.blurhash_index[filename] ||
      window.blurhash_index[filename.split("/").pop()];

    const metadata_aspect_ratio =
      img_data && img_data.width && img_data.height
        ? img_data.width / img_data.height
        : null;

    // update the wrapper to use the actual aspect ratio
    if (lazy_image.parentNode) {
      lazy_image.parentNode.style.aspectRatio = `${actual_aspect_ratio}`;
    }

    // update the image to use its natural aspect ratio
    lazy_image.style.aspectRatio = `${actual_aspect_ratio}`;
    lazy_image.style.objectFit = "contain"; // show full image without cropping

    // fade in the image with a transition
    lazy_image.style.transition = "opacity 0.5s ease-in-out";
    lazy_image.style.opacity = "1";

    // fade out the canvas if it exists (parent of the image is the wrapper)
    if (
      lazy_image.parentNode &&
      lazy_image.parentNode.querySelector("canvas")
    ) {
      const canvas = lazy_image.parentNode.querySelector("canvas");
      canvas.style.transition = "opacity 0.5s ease-in-out";
      canvas.style.opacity = "0";

      // remove the canvas after transition
      setTimeout(function () {
        if (canvas.parentNode) {
          canvas.parentNode.removeChild(canvas);
        }
      }, 500);
    }

    // reduce the in-flight counter and process the next image
    inflight_requests--;
    const next_image = process_image_load_queue(
      inflight_requests,
      max_inflight_requests,
      image_load_queue
    );
    if (next_image) {
      load_image(
        next_image,
        inflight_requests,
        blur_rendered_images,
        max_inflight_requests,
        image_load_queue
      );
    }
  };

  // handle image loading errors
  lazy_image.onerror = function () {
    console.error(`failed to load image: ${lazy_image.dataset.filename}`);
    inflight_requests--;
    const next_image = process_image_load_queue(
      inflight_requests,
      max_inflight_requests,
      image_load_queue
    );
    if (next_image) {
      load_image(
        next_image,
        inflight_requests,
        blur_rendered_images,
        max_inflight_requests,
        image_load_queue
      );
    }
  };

  // start loading the image
  lazy_image.src = lazy_image.dataset.src;
  lazy_image.classList.remove("lazyload");
}

// function to render the blur for an image
function render_blur(lazy_image, blur_rendered_images) {
  const image_id = lazy_image.id;

  // skip if we've already rendered the blur for this image
  if (blur_rendered_images.has(image_id)) {
    return;
  }

  // mark this image as having its blur rendered
  blur_rendered_images.add(image_id);

  lazy_image.removeAttribute("height");

  // look for blurhash in the index
  const filename = lazy_image.dataset.filename;
  const blurhash = get_blurhash_by_filename(filename);

  if (blurhash) {
    console.log(`rendering blurhash grid for ${filename} from blurhash`);

    // create wrapper div for positioning
    // get the aspect ratio from the image data if available
    const img_data =
      window.blurhash_index[filename] ||
      window.blurhash_index[filename.split("/").pop()];
    const aspect_ratio =
      img_data && img_data.width && img_data.height
        ? img_data.width / img_data.height
        : 1;

    const wrapper = document.createElement("div");
    wrapper.style.position = "relative";
    wrapper.style.display = "inline-block";
    wrapper.style.width = "100%";
    wrapper.style.aspectRatio = `${aspect_ratio}`; // use calculated aspect ratio instead of 1:1
    wrapper.style.overflow = "hidden"; // prevent overflow

    // render blurhash canvas
    const canvas = render_blurhash_grid(lazy_image, blurhash);

    // replace the image with the wrapper containing both canvas and image
    lazy_image.parentNode.insertBefore(wrapper, lazy_image);
    wrapper.appendChild(canvas);
    wrapper.appendChild(lazy_image);

    // position the image on top of the canvas
    lazy_image.style.position = "relative";
    lazy_image.style.zIndex = "2";
    lazy_image.style.opacity = "0"; // hide image initially
    lazy_image.style.height = "auto"; // let height adjust based on width while maintaining aspect ratio
    lazy_image.style.width = "100%"; // fill the wrapper width
    lazy_image.style.aspectRatio = `${aspect_ratio}`; // use same aspect ratio as wrapper
    lazy_image.style.objectFit = "contain"; // show entire image without cropping
  } else {
    // use default orange
    console.log(`no blurhash found for ${filename}, using default orange`);
    lazy_image.style.backgroundColor = "#FF8C00";
  }
}

// handle visible images intersection observer
function handle_visible_blur_render(
  entries,
  observer,
  blur_rendered_images,
  near_viewport_blur_render_observer,
  visible_blur_render_observer
) {
  console.log(`visible blur render observe: seen ${entries.length}`);
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      let lazy_image = entry.target;

      // immediately render the blur for visible images
      render_blur(lazy_image, blur_rendered_images);

      // unobserve this image for blur rendering
      visible_blur_render_observer.unobserve(lazy_image);

      // also unobserve in the preload observer
      near_viewport_blur_render_observer.unobserve(lazy_image);
    }
  });
}

// handle near-viewport images intersection observer
function handle_near_viewport_blur_render(
  entries,
  observer,
  blur_rendered_images,
  near_viewport_blur_render_observer
) {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      let lazy_image = entry.target;

      // render blur immediately for images near viewport - no delay
      // only render if it hasn't already been rendered
      if (!blur_rendered_images.has(lazy_image.id)) {
        render_blur(lazy_image, blur_rendered_images);
      }

      // unobserve this image for blur rendering
      near_viewport_blur_render_observer.unobserve(lazy_image);
    }
  });
}

// handle visible images loading observer
function handle_visible_image_load(
  entries,
  observer,
  inflight_requests,
  blur_rendered_images,
  max_inflight_requests,
  image_load_queue,
  visible_image_load_observer,
  upcoming_image_load_observer
) {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      let lazy_image = entry.target;

      // always prioritize loading visible images immediately
      load_image(
        lazy_image,
        inflight_requests,
        blur_rendered_images,
        max_inflight_requests,
        image_load_queue
      );

      // unobserve from both observers
      visible_image_load_observer.unobserve(lazy_image);
      upcoming_image_load_observer.unobserve(lazy_image);
    }
  });
}

// handle upcoming images loading observer
function handle_upcoming_image_load(
  entries,
  observer,
  inflight_requests,
  blur_rendered_images,
  max_inflight_requests,
  image_load_queue,
  upcoming_image_load_observer
) {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      let lazy_image = entry.target;

      // check if the image is now in the viewport (if so, let the other observer handle it)
      const rect = lazy_image.getBoundingClientRect();
      const is_now_visible = rect.top < window.innerHeight && rect.bottom > 0;

      if (!is_now_visible) {
        // queue this image for loading or load if under the cap
        if (inflight_requests < max_inflight_requests) {
          load_image(
            lazy_image,
            inflight_requests,
            blur_rendered_images,
            max_inflight_requests,
            image_load_queue
          );
        } else {
          console.log(`queueing image: ${lazy_image.dataset.filename}`);
          image_load_queue.push(lazy_image);
        }

        // unobserve this image
        upcoming_image_load_observer.unobserve(lazy_image);
      }
    }
  });
}

document.addEventListener("DOMContentLoaded", function () {
  const table_body = document.getElementById("table-body");
  const overlay = document.getElementById("overlay");

  set_body_margin_to_zero();

  // ensure blurhash_index exists to prevent errors
  if (!window.blurhash_index) {
    console.warn("blurhash_index not found, creating empty object");
    window.blurhash_index = {};
  }

  if ("IntersectionObserver" in window) {
    const lazyload_images = document.querySelectorAll(".lazyload");

    // track which images have already had their blur rendered
    const blur_rendered_images = new Set();

    // track in-flight image loading requests
    let inflight_requests = 0;
    const max_inflight_requests = num_columns * 3;
    const image_load_queue = []; // queue for pending image loads

    // separate observers for rendering the blur - one for visible images, one for near-viewport images
    // first observer prioritizes currently visible images (no margin)
    let visible_blur_render_observer = new IntersectionObserver(
      function (entries, observer) {
        handle_visible_blur_render(
          entries,
          observer,
          blur_rendered_images,
          near_viewport_blur_render_observer,
          visible_blur_render_observer
        );
      },
      {
        rootMargin: "0px", // only process currently visible images
        threshold: 0.01, // trigger when even a small portion (1%) is visible for faster rendering
      }
    );

    // second observer handles images approaching the viewport (immediately without delay)
    let near_viewport_blur_render_observer = new IntersectionObserver(
      function (entries, observer) {
        handle_near_viewport_blur_render(
          entries,
          observer,
          blur_rendered_images,
          near_viewport_blur_render_observer
        );
      },
      {
        rootMargin: `${window.innerHeight}px`, // use full screen height as margin for preloading
        threshold: 0, // trigger as soon as any part intersects with the expanded margin
      }
    );

    // create separate observers for immediately visible vs upcoming images
    // high priority observer - loads immediately visible images first
    let visible_image_load_observer = new IntersectionObserver(
      function (entries, observer) {
        handle_visible_image_load(
          entries,
          observer,
          inflight_requests,
          blur_rendered_images,
          max_inflight_requests,
          image_load_queue,
          visible_image_load_observer,
          upcoming_image_load_observer
        );
      },
      {
        rootMargin: "0px", // only currently visible images
        threshold: 0.1, // 10% of the image must be visible - reduced to catch more visible images
      }
    );

    // lower priority observer - queues images that are approaching the viewport
    let upcoming_image_load_observer = new IntersectionObserver(
      function (entries, observer) {
        handle_upcoming_image_load(
          entries,
          observer,
          inflight_requests,
          blur_rendered_images,
          max_inflight_requests,
          image_load_queue,
          upcoming_image_load_observer
        );
      },
      {
        rootMargin: "100px", // images approaching the viewport
        threshold: 0, // trigger as soon as any part intersects
      }
    );

    // observe all lazyload images with all observers
    lazyload_images.forEach((lazy_image) => {
      // highest priority: visible blur rendering - do this first
      visible_blur_render_observer.observe(lazy_image);

      // high priority: near-viewport blur rendering
      near_viewport_blur_render_observer.observe(lazy_image);

      // after blur rendering is set up, handle image loading

      // medium priority: visible images loading
      visible_image_load_observer.observe(lazy_image);

      // lowest priority: upcoming images loading
      upcoming_image_load_observer.observe(lazy_image);
    });
  }
});
