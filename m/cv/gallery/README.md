# Modular Gallery System

A refactored, modular image gallery with configurable behaviors, lazy loading, and autoscroll.

## Quick Start

```html
<!doctype html>
<html>
  <head>
    <link rel="stylesheet" href="/gallery/gallery.css" />
  </head>
  <body style="background-color: black">
    <script src="/blurmap.js"></script>

    <script>
      window.images = [
        { filename: "image1.jpg", width: 400, height: 300 },
        { filename: "image2.jpg", width: 400, height: 400 },
      ];

      window.galleryConfig = {
        images: { thumbPath: "path/to/thumbs" },
        click: { mode: "toggle" },
      };
    </script>

    <table>
      <tbody id="table-body"></tbody>
    </table>
    <div id="overlay"></div>

    <script type="module" src="/gallery/index.js"></script>
  </body>
</html>
```

## Migration from Legacy gallery.js/gallery.css

### File Changes

| Old            | New                             |
| -------------- | ------------------------------- |
| `/gallery.css` | `/gallery/gallery.css`          |
| `/gallery.js`  | `/gallery/index.js` (ES module) |

### Script Tag Change

```html
<!-- OLD -->
<link rel="stylesheet" href="/gallery.css" />
<script src="/gallery.js"></script>

<!-- NEW -->
<link rel="stylesheet" href="/gallery/gallery.css" />
<script type="module" src="/gallery/index.js"></script>
```

### Configuration Migration

#### Old Style (remove this)

```javascript
const basePath = "replicate/t2";
const selectMode = "no";
const thumbsDir = "thumbs";
const thumbsExt = "png";
const images = [...];
generateGrid();
```

#### New Style (use this)

```javascript
window.images = [...];

window.galleryConfig = {
  images: {
    thumbPath: 'replicate/t2',
    fullPath: '/replicate/img',
  },
  click: {
    mode: 'toggle',
  },
};
// No need to call generateGrid() - it auto-initializes
```

### selectMode Migration

| Old selectMode | New click.mode | Additional Config                              |
| -------------- | -------------- | ---------------------------------------------- |
| `"no"`         | `"toggle"`     | -                                              |
| `"yes"`        | `"select"`     | `autoscroll.autoEnableWhenNotSelecting: false` |
| `"W-gallery"`  | `"navigate"`   | `modal.enabled: true`                          |

#### Example: selectMode = "no" (Browse Mode)

```javascript
// OLD
const selectMode = "no";

// NEW
window.galleryConfig = {
  click: { mode: "toggle" },
  autoscroll: { autoEnableWhenNotSelecting: true },
};
```

#### Example: selectMode = "yes" (Selection Mode)

```javascript
// OLD
const selectMode = "yes";

// NEW
window.galleryConfig = {
  click: {
    mode: "select",
    selectEndpoint: "/select-yes",
  },
  autoscroll: { autoEnableWhenNotSelecting: false },
};
```

#### Example: selectMode = "W-gallery" (Navigate Mode)

```javascript
// OLD
const selectMode = "W-gallery";

// NEW
window.galleryConfig = {
  click: {
    mode: "navigate",
    navigateUrlPattern: "../../../W/{uuid}.html?page={page}#{filename}",
  },
  modal: { enabled: true },
  autoscroll: { autoEnableWhenNotSelecting: false },
};
```

### HTML Structure

The HTML structure remains the same:

```html
<table>
  <tbody id="table-body"></tbody>
</table>
<div id="overlay"></div>
```

**Remove** the inline `<script>` that calls `generateGrid()` - the new module auto-initializes.

## Full Configuration Reference

```javascript
window.galleryConfig = {
  // Image source paths
  images: {
    thumbPath: "replicate/t2", // Thumbnails for multi-column
    fullPath: "/replicate/img", // Full-size for single column
  },

  // Grid layout
  layout: {
    columnWidth: 330, // Target px per column
    minColumns: 1, // Minimum columns
    maxColumns: 0, // Maximum (0 = unlimited)
    imageGap: 5, // Gap between images (px)
    equalizeHeights: true, // Balance column heights
  },

  // Click behavior
  click: {
    mode: "toggle", // 'toggle' | 'select' | 'navigate' | 'custom'
    selectEndpoint: "/select-yes", // Server endpoint for 'select'
    navigateUrlPattern: "...", // URL template for 'navigate'
    customHandler: null, // Function for 'custom'
  },

  // Autoscroll
  autoscroll: {
    enabled: false, // Start with autoscroll on
    autoEnableWhenNotSelecting: true, // Auto-enable if mode != 'select'
    secondsPerImage: 0.8, // Wait time per visible image
    minWaitMs: 3000, // Minimum wait (ms)
    maxWaitMs: 6000, // Maximum wait (ms)
    singleColumnDelaySec: 5, // Extra delay in single column
    loopToStart: true, // Loop to page 1 at end
    persistState: true, // Remember state in sessionStorage
  },

  // Lazy loading
  lazyLoad: {
    maxConcurrentMultiplier: 3, // Max concurrent = columns * this
    retryAttempts: 3, // Retries for failed images
    retryDelayMs: 500, // Delay between retries
  },

  // Navigation UI
  navigation: {
    showOverlay: true, // Show nav overlay
    position: "bottom-right", // Overlay position
    showCountdown: true, // Show countdown timer
    showPageNumbers: true, // Show page numbers
    enableKeyboard: true, // Enable keyboard shortcuts
    preventScrollWhileLoading: true, // Block scroll during load
  },

  // Visual style
  style: {
    backgroundColor: "black",
    fallbackColor: "#FF8C00", // When no blurhash
    fadeInDuration: 500, // Image fade-in (ms)
    columnBorder: "1px solid #000",
  },

  // Blurhash placeholders
  blurhash: {
    enabled: true,
    gridDimension: 20, // 20x20 color grid
    applyEnhancements: true, // Contrast/saturation boost
  },

  // Modal (for navigate mode)
  modal: {
    enabled: false,
    imageUrlPattern: "../../../fm/{prefix}.png",
    shortcutKey: "x",
  },
};
```

## Keyboard Shortcuts

| Key       | Action                                  |
| --------- | --------------------------------------- |
| `s`       | Toggle autoscroll                       |
| `a` / `←` | Previous page                           |
| `d` / `→` | Next page                               |
| `Space`   | Scroll down (waits for images to load)  |
| `x`       | Open modal (when `modal.enabled: true`) |

## Module Structure

```
gallery/
├── index.js        # Main entry point, orchestration
├── config.js       # Configuration struct and presets
├── state.js        # Centralized state management
├── grid.js         # Grid layout algorithm
├── blurhash.js     # Blurhash rendering
├── lazy-loader.js  # IntersectionObserver-based loading
├── autoscroll.js   # Autoscroll controller
├── navigation.js   # Navigation UI
├── visibility.js   # Viewport utilities
├── input.js        # Keyboard/mouse handlers
└── gallery.css     # Styles
```

## Blurhash Data (blurmap.go)

The `blurmap.go` program generates HTML gallery pages with embedded blurhash data. For the new modular gallery:

### How blurmap.go works:

1. Reads image identifiers from `all.input`
2. Generates 20x20 color grid (blurhash) for each image
3. Outputs paginated HTML with embedded `window.blurhashIndex`

### Updating blurmap.go for new gallery:

The `galleryTemplate` in blurmap.go needs to be updated:

```go
// OLD template (lines 72-98)
const galleryTemplate = `<!doctype html>
<html>
  <head>
    <link rel="stylesheet" href="/gallery.css" />
    ...
  </head>
  <body style="background-color: black">
    <script src="/gallery.js?cache=%d"></script>
    ...
    const basePath = "/%s";
    const selectMode = "%s";
    generateGrid();
    ...
</html>`

// NEW template
const galleryTemplate = `<!doctype html>
<html>
  <head>
    <link rel="stylesheet" href="/gallery/gallery.css" />
    <meta name="total-chunks" content="%d">
  </head>
  <body style="background-color: black">
    <script>
      // INSERT (blurhashIndex and images array)

      window.galleryConfig = {
        images: { thumbPath: '%s' },
        click: { mode: '%s' },  // 'toggle', 'select', or 'navigate'
      };
    </script>
    <table><tbody id="table-body"></tbody></table>
    <div id="overlay"></div>
    <script type="module" src="/gallery/index.js"></script>
  </body>
</html>`
```

### selectMode to click.mode mapping in Go:

```go
// In blurmap.go, convert selectMode to new format:
clickMode := "toggle"
if selectMode == "yes" {
    clickMode = "select"
} else if selectMode == "W-gallery" {
    clickMode = "navigate"
}
```

## Migration Checklist

1. [ ] Change CSS link from `/gallery.css` to `/gallery/gallery.css`
2. [ ] Change script from `<script src="/gallery.js">` to `<script type="module" src="/gallery/index.js">`
3. [ ] Convert `basePath` to `galleryConfig.images.thumbPath`
4. [ ] Convert `selectMode` to `galleryConfig.click.mode` (see table above)
5. [ ] Move `images` array to `window.images`
6. [ ] Remove `generateGrid()` call (auto-initializes)
7. [ ] Remove `thumbsDir` and `thumbsExt` (no longer needed)
8. [ ] Keep `window.blurhashIndex` (embedded in HTML by blurmap.go)
9. [ ] Update blurmap.go template to use new gallery format
