package main

import (
	"bufio"
	"crypto/sha256"
	"fmt"
	"image"
	_ "image/jpeg" // Register JPEG format
	_ "image/png"  // Register PNG format
	"io/ioutil"
	"os"
	"path/filepath"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"
)

const (
	cacheDir     = "blur"
	imageDir     = "replicate/t2"
	allInputFile = "all.input"
	outputDir    = "g" // Base directory for chunked output
)

// galleryTemplate is the HTML template for the gallery pages, moved from external gallery.html
const galleryTemplate = `<!doctype html>
<html>
  <head>
    <link rel="stylesheet" href="/gallery.css" />
    <meta name="total-chunks" content="%d">
    <meta name="current-chunk" content="%s">
  </head>
  <body style="background-color: black">
    <script src="/gallery.js?cache=%d"></script>
    <table>
      <tbody id="table-body">
        <tr>
          <script>
            // INSERT

            const basePath = "/replicate/t2";
            const selectMode = "no";

            generateGrid();
          </script>
        </tr>
      </tbody>
    </table>
    <div id="overlay" />
    <br />
  </body>
</html>`

// ImageInfo holds information about an image file
type ImageInfo struct {
	Filename string
	Width    int
	Height   int
	Blurmap  string
}

// Result holds the result of processing an image
type Result struct {
	Filename  string
	Blurmap   string
	Width     int
	Height    int
	Error     error
	Cached    bool
	DimCached bool // Whether dimensions were from cache
}

// GalleryData holds data to be injected into the template
type GalleryData struct {
	Images      string
	BlurhashMap string
}

const (
	chunkSize = 500 // Number of images per chunk
)

// timestampCache holds the current timestamp used for cache busting
var timestampCache int64

func main() {
	// Create a single timestamp for cache busting
	timestampCache = time.Now().Unix()

	// Create cache directory if it doesn't exist
	if err := ensureCacheDir(); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating cache directory: %v\n", err)
		os.Exit(1)
	}

	// Process the identifiers from all.input
	imageInfos, err := parseInputFile(allInputFile)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing input file: %v\n", err)
		os.Exit(1)
	}

	fmt.Fprintf(os.Stderr, "Found %d images to process\n", len(imageInfos))

	// Use all available CPU cores
	numWorkers := runtime.NumCPU()
	runtime.GOMAXPROCS(numWorkers)

	// Create channels for distributing work and collecting results
	jobs := make(chan ImageInfo, len(imageInfos))
	results := make(chan Result, len(imageInfos))

	// Create wait group to wait for all goroutines to finish
	var wg sync.WaitGroup

	// Start worker goroutines
	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go worker(jobs, results, &wg)
	}

	// Send jobs to the workers
	for _, imageInfo := range imageInfos {
		jobs <- imageInfo
	}
	close(jobs)

	// Wait for all workers to finish and close results channel
	go func() {
		wg.Wait()
		close(results)
	}()

	// Store results for generating the gallery
	imageInfoMap := make(map[string]*ImageInfo)

	// Create a map for quick lookup
	for i := range imageInfos {
		imageInfoMap[imageInfos[i].Filename] = &imageInfos[i]
	}

	// Process results
	processed := 0
	cachedBlur := 0
	cachedDim := 0
	errors := 0

	for result := range results {
		if result.Error != nil {
			fmt.Fprintf(os.Stderr, "Error processing %s: %v\n", result.Filename, result.Error)
			errors++
			continue
		}

		// Update the ImageInfo object directly
		if info, found := imageInfoMap[result.Filename]; found {
			info.Blurmap = result.Blurmap
			info.Width = result.Width
			info.Height = result.Height
		}

		processed++
		if result.Cached {
			cachedBlur++
		}
		if result.DimCached {
			cachedDim++
		}

		// Output processing status every 1000 images
		if processed%1000 == 0 {
			fmt.Fprintf(os.Stderr, "Processed %d images, %d errors\n", processed, errors)
		}
	}

	fmt.Fprintf(os.Stderr, "Completed blur processing. Total: %d images processed, %d errors\n", processed, errors)
	fmt.Fprintf(os.Stderr, "Cache stats: %d/%d blurhashes cached, %d/%d dimensions cached\n",
		cachedBlur, processed, cachedDim, processed)
	fmt.Fprintf(os.Stderr, "The blurmaps and dimensions have been saved to the %s directory\n", cacheDir)

	// Create a valid list of ImageInfo - only those with blurmap
	var validImages []ImageInfo
	for _, info := range imageInfos {
		if info.Blurmap != "" {
			validImages = append(validImages, info)
		}
	}

	// Sort images by filename
	sort.Slice(validImages, func(i, j int) bool {
		return validImages[i].Filename < validImages[j].Filename
	})

	// Calculate number of chunks needed
	totalImages := len(validImages)
	numChunks := (totalImages + chunkSize - 1) / chunkSize // Ceiling division

	fmt.Fprintf(os.Stderr, "Generating %d chunks with %d images per chunk (total: %d images)\n",
		numChunks, chunkSize, totalImages)

	// Create the output directory structure
	err = os.MkdirAll(outputDir, 0755)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating output directory: %v\n", err)
		os.Exit(1)
	}

	// Generate chunked HTML files
	for chunkNum := 1; chunkNum <= numChunks; chunkNum++ {
		start := (chunkNum - 1) * chunkSize
		end := start + chunkSize
		if end > totalImages {
			end = totalImages
		}

		// Create directory for this chunk
		chunkDir := filepath.Join(outputDir, strconv.Itoa(chunkNum))
		err = os.MkdirAll(chunkDir, 0755)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error creating chunk directory %s: %v\n", chunkDir, err)
			continue
		}

		// Generate HTML for this chunk
		chunkImages := validImages[start:end]
		outputPath := fmt.Sprintf("%s/index.html", chunkDir)

		fmt.Fprintf(os.Stderr, "Generating chunk %d (%d images) to %s...\n",
			chunkNum, len(chunkImages), outputPath)

		err = generateChunkHTML(chunkImages, outputPath, numChunks)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error generating HTML for chunk %d: %v\n", chunkNum, err)
		}
	}

	// Create an index.html in the g directory that links to all chunks
	fmt.Fprintf(os.Stderr, "Creating main index.html...\n")
	err = generateMainIndex(numChunks, totalImages)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error generating main index: %v\n", err)
	}

	fmt.Fprintf(os.Stderr, "All chunks generated successfully!\n")
}

// Removed printWithBlurhash function as per requirements

// worker processes images concurrently
func worker(jobs <-chan ImageInfo, results chan<- Result, wg *sync.WaitGroup) {
	defer wg.Done()

	for imageInfo := range jobs {
		// Construct the full image path
		imagePath := filepath.Join(imageDir, imageInfo.Filename)

		// Generate cache filenames
		cacheFile := getCacheFilename(imagePath)
		dimCacheFile := getDimensionsCacheFilename(imagePath)

		// Variables to store results
		var blurmap string
		var width, height int
		var blurCached, dimCached bool

		// Try to get blurhash from cache
		blurmap, err := readFromCache(cacheFile)
		if err == nil {
			blurCached = true
		} else {
			blurCached = false
		}

		// Try to get dimensions from cache
		dimData, err := readFromCache(dimCacheFile)
		if err == nil {
			// Parse dimensions from cache
			_, err = fmt.Sscanf(dimData, "%d,%d", &width, &height)
			if err == nil {
				dimCached = true
			}
		}

		// If either blurhash or dimensions weren't in cache, process the image
		if !blurCached || !dimCached {
			var processErr error

			if !blurCached {
				// Generate new blurhash and get dimensions
				blurmap, width, height, processErr = generateBlurmap(imagePath)
				if processErr != nil {
					results <- Result{
						Filename:  imageInfo.Filename,
						Error:     processErr,
						Cached:    false,
						DimCached: false,
					}
					continue
				}

				// Save blurhash to cache
				if err := writeToCache(cacheFile, blurmap); err != nil {
					fmt.Fprintf(os.Stderr, "Warning: Failed to write blurhash to cache for %s: %v\n", imageInfo.Filename, err)
				}
			}

			if !dimCached {
				// If we didn't get dimensions from blurhash generation, read them now
				if !blurCached {
					// Already got dimensions from generateBlurmap
					dimCached = false
				} else {
					// Need to get dimensions separately
					var dimErr error
					width, height, dimErr = getImageDimensions(imagePath)
					if dimErr != nil {
						fmt.Fprintf(os.Stderr, "Warning: Failed to get dimensions for %s: %v\n", imageInfo.Filename, dimErr)
						width, height = 0, 0
					}
				}

				// Save dimensions to cache
				dimData := fmt.Sprintf("%d,%d", width, height)
				if err := writeToCache(dimCacheFile, dimData); err != nil {
					fmt.Fprintf(os.Stderr, "Warning: Failed to write dimensions to cache for %s: %v\n", imageInfo.Filename, err)
				}
			}
		}

		// Send result with all data
		results <- Result{
			Filename:  imageInfo.Filename,
			Blurmap:   blurmap,
			Width:     width,
			Height:    height,
			Cached:    blurCached,
			DimCached: dimCached,
		}
	}
}

// parseInputFile parses the all.input file containing image identifiers
// Each line contains an identifier that maps to a filename in the imageDir
func parseInputFile(filePath string) ([]ImageInfo, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var imageInfos []ImageInfo
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		// Get the identifier from each line
		identifier := strings.TrimSpace(scanner.Text())

		// Skip empty lines
		if identifier == "" {
			continue
		}

		// Create image info object with the identifier as the base filename
		// and construct the full filename with .png extension
		imageInfo := ImageInfo{
			Filename: identifier + ".png",
			Width:    0, // We'll read these from the actual image later
			Height:   0,
		}

		imageInfos = append(imageInfos, imageInfo)
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return imageInfos, nil
}

// generateChunkHTML creates an HTML file for a chunk of images
// It now uses the inline galleryTemplate instead of an external file
func generateChunkHTML(imageInfos []ImageInfo, outputPath string, totalChunks int) error {
	// Extract chunk number from path
	chunkNum := strings.Split(outputPath, "/")[1]

	// Format the template with proper values
	templateStr := fmt.Sprintf(galleryTemplate, totalChunks, chunkNum, timestampCache)

	// Generate the blurhashIndex map
	var blurhashMap strings.Builder

	// First sort the imageInfos to ensure consistent order
	sortedInfos := make([]ImageInfo, 0, len(imageInfos))
	for _, info := range imageInfos {
		if info.Blurmap != "" {
			sortedInfos = append(sortedInfos, info)
		}
	}

	// Sort by filename to ensure blurhashIndex keys are in order
	sort.Slice(sortedInfos, func(i, j int) bool {
		return sortedInfos[i].Filename < sortedInfos[j].Filename
	})

	// Now collect entries with valid blurmaps in sorted order
	var validEntries []string
	for _, info := range sortedInfos {
		// Format: "filename.png": { width: 512, height: 512, blurhash: "..." }
		// No need for filename inside as the key already has it
		entry := fmt.Sprintf("  \"%s\": { width: %d, height: %d, blurhash: \"%s\" }",
			info.Filename, info.Width, info.Height, info.Blurmap)
		validEntries = append(validEntries, entry)
	}

	// Write the header
	blurhashMap.WriteString("// Generated blurhash index object\n")
	blurhashMap.WriteString("window.blurhashIndex = {\n")

	// Join all entries with commas and write them
	if len(validEntries) > 0 {
		blurhashMap.WriteString(strings.Join(validEntries, ",\n"))
		blurhashMap.WriteString("\n")
	}

	blurhashMap.WriteString("};\n")

	// Combine the JavaScript content with global variable definitions to fix errors
	var jsContent strings.Builder

	// Define required global variables to avoid "is not defined" errors
	jsContent.WriteString("// Define global variables for gallery.js\n")
	jsContent.WriteString("window.numColumns = Math.floor(window.innerWidth / 300);\n")
	jsContent.WriteString("window.images = [];\n\n")

	// Add the blurhash index
	jsContent.WriteString(blurhashMap.String())

	// Generate the images array from the blurhashIndex keys
	jsContent.WriteString("\n// Generate images array from blurhashIndex\n")
	jsContent.WriteString("window.images = Object.keys(window.blurhashIndex)\n")
	jsContent.WriteString("  .map(filename => ({\n")
	jsContent.WriteString("    filename, \n")
	jsContent.WriteString("    width: window.blurhashIndex[filename].width,\n")
	jsContent.WriteString("    height: window.blurhashIndex[filename].height\n")
	jsContent.WriteString("  }));\n\n")

	// Add proper Fisher-Yates shuffle for randomization
	jsContent.WriteString("// Randomize array with Fisher-Yates shuffle\n")
	jsContent.WriteString("for (let i = window.images.length - 1; i > 0; i--) {\n")
	jsContent.WriteString("  const j = Math.floor(Math.random() * (i + 1));\n")
	jsContent.WriteString("  [window.images[i], window.images[j]] = [window.images[j], window.images[i]];\n")
	jsContent.WriteString("}\n\n")

	// Parse chunk numbers
	chunkNumInt, _ := strconv.Atoi(chunkNum)
	prevChunk := chunkNumInt - 1
	nextChunk := chunkNumInt + 1

	// Add navigation between chunks with image position tracking
	jsContent.WriteString("// Function to track image positions and visibility\n")
	jsContent.WriteString("let imagePositions = [];\n")
	jsContent.WriteString("let currentVisibleImageIndex = 0;\n")

	// Track image positions
	jsContent.WriteString("function calculateImagePositions() {\n")
	jsContent.WriteString("  const allImages = Array.from(document.querySelectorAll('img'));\n")
	jsContent.WriteString("  \n")
	jsContent.WriteString("  // Sort images by their vertical position\n")
	jsContent.WriteString("  imagePositions = allImages.map((img, originalIndex) => {\n")
	jsContent.WriteString("    const rect = img.getBoundingClientRect();\n")
	jsContent.WriteString("    const absoluteTop = rect.top + window.pageYOffset;\n")
	jsContent.WriteString("    return {\n")
	jsContent.WriteString("      element: img,\n")
	jsContent.WriteString("      originalIndex,\n")
	jsContent.WriteString("      top: absoluteTop,\n")
	jsContent.WriteString("      bottom: absoluteTop + rect.height,\n")
	jsContent.WriteString("      filename: img.dataset.filename || ''\n")
	jsContent.WriteString("    };\n")
	jsContent.WriteString("  });\n")

	jsContent.WriteString("  // Sort by vertical position (top to bottom)\n")
	jsContent.WriteString("  imagePositions.sort((a, b) => a.top - b.top);\n")

	jsContent.WriteString("  // Assign sequential position numbers\n")
	jsContent.WriteString("  imagePositions.forEach((img, index) => { img.positionIndex = index + 1; });\n")
	jsContent.WriteString("  \n")
	jsContent.WriteString("  console.log(`Calculated positions for ${imagePositions.length} images`);\n")
	jsContent.WriteString("  return imagePositions;\n")
	jsContent.WriteString("}\n")

	// Track fully visible images
	jsContent.WriteString("function updateVisibleImageIndex() {\n")
	jsContent.WriteString("  if (!imagePositions.length) calculateImagePositions();\n")

	jsContent.WriteString("  // Find highest number fully visible image\n")
	jsContent.WriteString("  let highestVisibleIndex = 0;\n")
	jsContent.WriteString("  const viewportTop = window.pageYOffset;\n")
	jsContent.WriteString("  const viewportBottom = viewportTop + window.innerHeight;\n")

	jsContent.WriteString("  // Check each image position\n")
	jsContent.WriteString("  imagePositions.forEach(img => {\n")
	jsContent.WriteString("    // Check if fully visible (image top and bottom are within viewport)\n")
	jsContent.WriteString("    if (img.top >= viewportTop && img.bottom <= viewportBottom) {\n")
	jsContent.WriteString("      highestVisibleIndex = Math.max(highestVisibleIndex, img.positionIndex);\n")
	jsContent.WriteString("    }\n")
	jsContent.WriteString("  });\n")

	jsContent.WriteString("  // Update the current image index if changed\n")
	jsContent.WriteString("  if (highestVisibleIndex !== currentVisibleImageIndex) {\n")
	jsContent.WriteString("    currentVisibleImageIndex = highestVisibleIndex;\n")
	jsContent.WriteString("    updateNavigationDisplay();\n")
	jsContent.WriteString("  }\n")
	jsContent.WriteString("}\n")

	// Update the navigation display
	jsContent.WriteString("function updateNavigationDisplay() {\n")
	jsContent.WriteString("  const imageInfoDisplay = document.getElementById('current-image-info');\n")
	jsContent.WriteString("  if (!imageInfoDisplay) return;\n")

	jsContent.WriteString("  if (currentVisibleImageIndex > 0 && currentVisibleImageIndex <= imagePositions.length) {\n")
	jsContent.WriteString("    const currentImage = imagePositions[currentVisibleImageIndex - 1];\n")
	jsContent.WriteString("    imageInfoDisplay.textContent = `${currentVisibleImageIndex}/${imagePositions.length}`;\n")
	jsContent.WriteString("    imageInfoDisplay.title = currentImage.filename || '';\n")
	jsContent.WriteString("  } else {\n")
	jsContent.WriteString("    imageInfoDisplay.textContent = `-/${imagePositions.length || 0}`;\n")
	jsContent.WriteString("  }\n")
	jsContent.WriteString("}\n")

	// Add navigation links
	jsContent.WriteString("document.addEventListener('DOMContentLoaded', () => {\n")
	jsContent.WriteString("  // Create the navigation container\n")
	jsContent.WriteString("  const nav = document.createElement('div');\n")
	jsContent.WriteString("  nav.className = 'chunk-nav';\n")
	jsContent.WriteString("  nav.style.cssText = 'position:fixed;bottom:10px;right:10px;background:rgba(0,0,0,0.7);color:white;padding:10px;border-radius:5px;z-index:1000;display:flex;gap:10px;align-items:center;';\n")

	// Add prev link if not the first chunk
	if chunkNumInt > 1 {
		jsContent.WriteString("  const prevLink = document.createElement('a');\n")
		jsContent.WriteString("  prevLink.href = '../" + strconv.Itoa(prevChunk) + "/';\n")
		jsContent.WriteString("  prevLink.style.cssText = 'color:white;text-decoration:none;font-weight:bold;font-size:24px;';\n")
		jsContent.WriteString("  prevLink.textContent = '<';\n")
		jsContent.WriteString("  nav.appendChild(prevLink);\n")
	} else {
		// Add disabled prev link
		jsContent.WriteString("  const prevLink = document.createElement('span');\n")
		jsContent.WriteString("  prevLink.style.cssText = 'color:#555;font-weight:bold;font-size:24px;';\n")
		jsContent.WriteString("  prevLink.textContent = '<';\n")
		jsContent.WriteString("  nav.appendChild(prevLink);\n")
	}

	// Add chunk indicator - just the number
	jsContent.WriteString("  const chunkIndicator = document.createElement('span');\n")
	jsContent.WriteString("  chunkIndicator.textContent = '" + chunkNum + "';\n")
	jsContent.WriteString("  chunkIndicator.style.margin = '0 5px';\n")
	jsContent.WriteString("  nav.appendChild(chunkIndicator);\n")

	// Add next link if not the last chunk
	if chunkNumInt < totalChunks {
		jsContent.WriteString("  const nextLink = document.createElement('a');\n")
		jsContent.WriteString("  nextLink.href = '../" + strconv.Itoa(nextChunk) + "/';\n")
		jsContent.WriteString("  nextLink.style.cssText = 'color:white;text-decoration:none;font-weight:bold;font-size:24px;';\n")
		jsContent.WriteString("  nextLink.textContent = '>';\n")
		jsContent.WriteString("  nav.appendChild(nextLink);\n")
	} else {
		// Add disabled next link
		jsContent.WriteString("  const nextLink = document.createElement('span');\n")
		jsContent.WriteString("  nextLink.style.cssText = 'color:#555;font-weight:bold;font-size:24px;';\n")
		jsContent.WriteString("  nextLink.textContent = '>';\n")
		jsContent.WriteString("  nav.appendChild(nextLink);\n")
	}

	// Add current image position display
	jsContent.WriteString("  // Add image position indicator\n")
	jsContent.WriteString("  const imageInfoDisplay = document.createElement('span');\n")
	jsContent.WriteString("  imageInfoDisplay.id = 'current-image-info';\n")
	jsContent.WriteString("  imageInfoDisplay.style.cssText = 'margin-left:15px;font-size:14px;background:rgba(0,0,0,0.5);padding:2px 6px;border-radius:3px;';\n")
	jsContent.WriteString("  imageInfoDisplay.textContent = '-/-';\n")
	jsContent.WriteString("  nav.appendChild(imageInfoDisplay);\n")

	jsContent.WriteString("  document.body.appendChild(nav);\n")

	// Calculate initial positions and set up scroll listener
	jsContent.WriteString("  // Calculate image positions after all images are loaded\n")
	jsContent.WriteString("  window.addEventListener('load', () => {\n")
	jsContent.WriteString("    setTimeout(() => { // Small delay to ensure all images have rendered\n")
	jsContent.WriteString("      calculateImagePositions();\n")
	jsContent.WriteString("      updateVisibleImageIndex();\n")
	jsContent.WriteString("    }, 500);\n")
	jsContent.WriteString("  });\n")

	// Update position on scroll
	jsContent.WriteString("  // Update the visible image index on scroll\n")
	jsContent.WriteString("  window.addEventListener('scroll', () => {\n")
	jsContent.WriteString("    requestAnimationFrame(updateVisibleImageIndex);\n")
	jsContent.WriteString("  });\n")

	// Recalculate on window resize
	jsContent.WriteString("  // Recalculate positions on window resize\n")
	jsContent.WriteString("  let resizeTimer;\n")
	jsContent.WriteString("  window.addEventListener('resize', () => {\n")
	jsContent.WriteString("    clearTimeout(resizeTimer);\n")
	jsContent.WriteString("    resizeTimer = setTimeout(() => {\n")
	jsContent.WriteString("      calculateImagePositions();\n")
	jsContent.WriteString("      updateVisibleImageIndex();\n")
	jsContent.WriteString("    }, 300);\n")
	jsContent.WriteString("  });\n")

	// Add keyboard navigation
	jsContent.WriteString("\n  // Add keyboard navigation\n")
	jsContent.WriteString("  document.addEventListener('keydown', (e) => {\n")

	// Left arrow
	jsContent.WriteString("    if (e.key === 'ArrowLeft' || e.key === 'a' || e.key === 'A') {\n")
	if chunkNumInt > 1 {
		jsContent.WriteString("      window.location.href = '../" + strconv.Itoa(prevChunk) + "/';\n")
	} else {
		jsContent.WriteString("      console.log('At first chunk');\n")
	}
	jsContent.WriteString("    }\n")

	// Right arrow
	jsContent.WriteString("    if (e.key === 'ArrowRight' || e.key === 'd' || e.key === 'D') {\n")
	if chunkNumInt < totalChunks {
		jsContent.WriteString("      window.location.href = '../" + strconv.Itoa(nextChunk) + "/';\n")
	} else {
		jsContent.WriteString("      console.log('At last chunk');\n")
	}
	jsContent.WriteString("    }\n")

	jsContent.WriteString("  });\n")

	// Add scroll detection to go to next chunk when reaching bottom of page
	if chunkNumInt < totalChunks {
		jsContent.WriteString("\n  // Go to next chunk when scrolling to bottom of page\n")
		jsContent.WriteString("  let scrollTimer = null;\n")
		jsContent.WriteString("  let isAtBottom = false;\n")
		jsContent.WriteString("  let allImagesLoaded = false;\n")

		// Helper function to check if all visible images are loaded
		// Add image retry and failure tracking before the checkAllImagesLoaded function
		jsContent.WriteString("  // Track image load status and retries\n")
		jsContent.WriteString("  const imageRetries = new Map();\n")
		jsContent.WriteString("  const failedImages = new Set();\n")
		jsContent.WriteString("  let imageErrorTimeout = null;\n")

		// Handle image load errors and retries
		jsContent.WriteString("  // Handle image load errors\n")
		jsContent.WriteString("  function handleImageError(img) {\n")
		jsContent.WriteString("    const src = img.src || img.dataset.src;\n")
		jsContent.WriteString("    if (!src) return false;\n")

		jsContent.WriteString("    // Check if this image has been retried already\n")
		jsContent.WriteString("    const retryCount = imageRetries.get(src) || 0;\n")

		jsContent.WriteString("    if (retryCount === 0) {\n")
		jsContent.WriteString("      // First failure - retry once\n")
		jsContent.WriteString("      console.log(`Image load failed, retrying: ${src}`);\n")
		jsContent.WriteString("      imageRetries.set(src, 1);\n")

		jsContent.WriteString("      // Add a cache-busting parameter and retry\n")
		jsContent.WriteString("      const newSrc = src.includes('?') \n")
		jsContent.WriteString("        ? `${src}&retry=${Date.now()}` \n")
		jsContent.WriteString("        : `${src}?retry=${Date.now()}`;\n")

		jsContent.WriteString("      img.src = newSrc;\n")
		jsContent.WriteString("      return false; // Not resolved yet\n")
		jsContent.WriteString("    } else {\n")
		jsContent.WriteString("      // Already retried - mark as permanently failed\n")
		jsContent.WriteString("      console.log(`Image permanently failed after retry: ${src}`);\n")
		jsContent.WriteString("      failedImages.add(src);\n")

		jsContent.WriteString("      // Set a timeout to allow navigation after 5 seconds regardless of failed images\n")
		jsContent.WriteString("      if (!imageErrorTimeout) {\n")
		jsContent.WriteString("        imageErrorTimeout = setTimeout(() => {\n")
		jsContent.WriteString("          console.log('Timeout reached for failed images, allowing navigation');\n")
		jsContent.WriteString("          // Force allImagesLoaded to true after timeout\n")
		jsContent.WriteString("          allImagesLoaded = true;\n")
		jsContent.WriteString("        }, 5000);\n")
		jsContent.WriteString("      }\n")

		jsContent.WriteString("      return true; // Resolved (as failed)\n")
		jsContent.WriteString("    }\n")
		jsContent.WriteString("  }\n")

		// Setup global image error handler
		jsContent.WriteString("  // Set up global error handler for all images\n")
		jsContent.WriteString("  document.addEventListener('error', (e) => {\n")
		jsContent.WriteString("    if (e.target.tagName === 'IMG') {\n")
		jsContent.WriteString("      handleImageError(e.target);\n")
		jsContent.WriteString("    }\n")
		jsContent.WriteString("  }, true); // Capture phase to catch all image errors\n")

		// Enhanced version of checkAllImagesLoaded
		jsContent.WriteString("  function checkAllImagesLoaded() {\n")
		jsContent.WriteString("    // If the error timeout has fired, consider all images loaded\n")
		jsContent.WriteString("    if (imageErrorTimeout && Date.now() > imageErrorTimeout._idleStart + 5000) {\n")
		jsContent.WriteString("      return true;\n")
		jsContent.WriteString("    }\n")

		jsContent.WriteString("    const visibleImages = Array.from(document.querySelectorAll('img')).filter(img => {\n")
		jsContent.WriteString("      const rect = img.getBoundingClientRect();\n")
		jsContent.WriteString("      return rect.top < window.innerHeight && rect.bottom > 0; // Visible in viewport\n")
		jsContent.WriteString("    });\n")
		jsContent.WriteString("    \n")
		jsContent.WriteString("    if (visibleImages.length === 0) return true;\n")

		jsContent.WriteString("    // Check if all visible images are either fully loaded or permanently failed\n")
		jsContent.WriteString("    return visibleImages.every(img => {\n")
		jsContent.WriteString("      // Image is loaded successfully\n")
		jsContent.WriteString("      if (img.complete && img.naturalHeight > 0) return true;\n")

		jsContent.WriteString("      // Image permanently failed (after retry)\n")
		jsContent.WriteString("      if (failedImages.has(img.src) || failedImages.has(img.dataset.src)) return true;\n")

		jsContent.WriteString("      // Handle error if image has failed but not been processed\n")
		jsContent.WriteString("      if (img.complete && img.naturalHeight === 0) {\n")
		jsContent.WriteString("        return handleImageError(img);\n")
		jsContent.WriteString("      }\n")

		jsContent.WriteString("      // Otherwise still loading\n")
		jsContent.WriteString("      return false;\n")
		jsContent.WriteString("    });\n")
		jsContent.WriteString("  }\n")

		// Setup a MutationObserver to detect when images finish loading
		jsContent.WriteString("  const imagesLoadedObserver = new MutationObserver(() => {\n")
		jsContent.WriteString("    allImagesLoaded = checkAllImagesLoaded();\n")
		jsContent.WriteString("    if (allImagesLoaded && scrollTimer) {\n")
		jsContent.WriteString("      console.log('All visible images loaded or handled as failed, navigation timer active');\n")
		jsContent.WriteString("    }\n")
		jsContent.WriteString("  });\n")
		jsContent.WriteString("  imagesLoadedObserver.observe(document.body, { subtree: true, attributes: true, attributeFilter: ['src', 'complete', 'naturalHeight'] });\n")

		// Setup scroll event listener
		jsContent.WriteString("  window.addEventListener('scroll', () => {\n")
		jsContent.WriteString("    const scrollPosition = window.scrollY + window.innerHeight;\n")
		jsContent.WriteString("    const scrollHeight = document.documentElement.scrollHeight;\n")
		jsContent.WriteString("    const bottomThreshold = scrollHeight - 10; // 10px from bottom\n")
		jsContent.WriteString("    const wasAtBottom = isAtBottom;\n")
		jsContent.WriteString("    isAtBottom = scrollPosition >= bottomThreshold;\n")

		// Check if all images are loaded whenever we're at the bottom
		jsContent.WriteString("    if (isAtBottom) {\n")
		jsContent.WriteString("      allImagesLoaded = checkAllImagesLoaded();\n")
		jsContent.WriteString("    }\n")

		// Only navigate if we just reached the bottom (not if we were already there)
		jsContent.WriteString("    if (isAtBottom && !wasAtBottom) {\n")
		jsContent.WriteString("      // Clear any existing timer\n")
		jsContent.WriteString("      if (scrollTimer) clearTimeout(scrollTimer);\n")

		// Setup navigation countdown with status indicator
		jsContent.WriteString("      // Create countdown indicator\n")
		jsContent.WriteString("      const countdownIndicator = document.createElement('div');\n")
		jsContent.WriteString("      countdownIndicator.id = 'navigation-countdown';\n")
		jsContent.WriteString("      countdownIndicator.style.cssText = 'position:fixed;bottom:50px;right:10px;background:rgba(0,0,0,0.8);color:white;padding:8px;border-radius:4px;font-size:14px;z-index:9999;';\n")
		jsContent.WriteString("      document.body.appendChild(countdownIndicator);\n")

		jsContent.WriteString("      // Set up reliable navigation with 10 second countdown\n")
		jsContent.WriteString("      let navigationStarted = false;\n")
		jsContent.WriteString("      let countdownFinished = false;\n")
		jsContent.WriteString("      let secondsLeft = 10;\n")
		jsContent.WriteString("      countdownIndicator.textContent = `Next page in ${secondsLeft}s (waiting for images...)`;\n")

		// Navigation function to ensure proper navigation after countdown
		jsContent.WriteString("      // Function to handle the actual navigation\n")
		jsContent.WriteString("      function navigateToNextPage() {\n")
		jsContent.WriteString("        // Only navigate once\n")
		jsContent.WriteString("        if (navigationStarted) return;\n")
		jsContent.WriteString("        navigationStarted = true;\n")
		jsContent.WriteString("        \n")
		jsContent.WriteString("        // Double check images are loaded\n")
		jsContent.WriteString("        const finalCheck = checkAllImagesLoaded();\n")
		jsContent.WriteString("        if (!isAtBottom) {\n")
		jsContent.WriteString("          // User scrolled away while waiting\n")
		jsContent.WriteString("          if (document.body.contains(countdownIndicator)) {\n")
		jsContent.WriteString("            document.body.removeChild(countdownIndicator);\n")
		jsContent.WriteString("          }\n")
		jsContent.WriteString("          return;\n")
		jsContent.WriteString("        }\n")
		jsContent.WriteString("        \n")
		jsContent.WriteString("        if (finalCheck) {\n")
		jsContent.WriteString("          // All images loaded, proceed to next page\n")
		jsContent.WriteString("          countdownIndicator.textContent = 'Going to next page...';\n")
		jsContent.WriteString("          // Short timeout to ensure UI updates before navigation\n")
		jsContent.WriteString("          setTimeout(() => {\n")
		jsContent.WriteString("            window.location.href = '../" + strconv.Itoa(nextChunk) + "/';\n")
		jsContent.WriteString("          }, 100);\n")
		jsContent.WriteString("        } else {\n")
		jsContent.WriteString("          // Some images still loading, wait longer\n")
		jsContent.WriteString("          countdownIndicator.textContent = 'Waiting for images to load (5s)...';\n")
		jsContent.WriteString("          setTimeout(() => {\n")
		jsContent.WriteString("            countdownIndicator.textContent = 'Going to next page...';\n")
		jsContent.WriteString("            window.location.href = '../" + strconv.Itoa(nextChunk) + "/';\n")
		jsContent.WriteString("          }, 5000);\n")
		jsContent.WriteString("        }\n")
		jsContent.WriteString("      }\n")

		jsContent.WriteString("      // Use a precise timer for countdown\n")
		jsContent.WriteString("      let startTime = Date.now();\n")
		jsContent.WriteString("      const updateInterval = setInterval(() => {\n")
		jsContent.WriteString("        // Calculate seconds based on elapsed time for accuracy\n")
		jsContent.WriteString("        const elapsed = Math.floor((Date.now() - startTime) / 1000);\n")
		jsContent.WriteString("        secondsLeft = Math.max(0, 10 - elapsed);\n")
		jsContent.WriteString("        \n")
		jsContent.WriteString("        if (secondsLeft <= 0) {\n")
		jsContent.WriteString("          // Time's up - clear interval and navigate\n")
		jsContent.WriteString("          clearInterval(updateInterval);\n")
		jsContent.WriteString("          countdownFinished = true;\n")
		jsContent.WriteString("          \n")
		jsContent.WriteString("          // Only navigate if not already started\n")
		jsContent.WriteString("          if (!navigationStarted) {\n")
		jsContent.WriteString("            navigateToNextPage();\n")
		jsContent.WriteString("          }\n")
		jsContent.WriteString("        } else {\n")
		jsContent.WriteString("          // Update display with current time\n")
		jsContent.WriteString("          countdownIndicator.textContent = allImagesLoaded\n")
		jsContent.WriteString("            ? `Next page in ${secondsLeft}s`\n")
		jsContent.WriteString("            : `Next page in ${secondsLeft}s (waiting for images...)`;\n")
		jsContent.WriteString("        }\n")
		jsContent.WriteString("      }, 200); // Check more frequently for smoother countdown\n")

		// Monitor scroll position for cancellation
		jsContent.WriteString("      // Monitor scroll position to cancel if user scrolls away\n")
		jsContent.WriteString("      const scrollMonitor = setInterval(() => {\n")
		jsContent.WriteString("        if (!isAtBottom && !navigationStarted) {\n")
		jsContent.WriteString("          // User scrolled away - cancel navigation\n")
		jsContent.WriteString("          clearInterval(updateInterval);\n")
		jsContent.WriteString("          clearInterval(scrollMonitor);\n")
		jsContent.WriteString("          \n")
		jsContent.WriteString("          // Remove countdown indicator\n")
		jsContent.WriteString("          if (document.body.contains(countdownIndicator)) {\n")
		jsContent.WriteString("            document.body.removeChild(countdownIndicator);\n")
		jsContent.WriteString("          }\n")
		jsContent.WriteString("        }\n")
		jsContent.WriteString("      }, 200);\n")

		// Store reference for cleanup
		jsContent.WriteString("      // Store monitor reference for cleanup\n")
		jsContent.WriteString("      scrollTimer = scrollMonitor;\n")
		jsContent.WriteString("    } else if (!isAtBottom) {\n")
		jsContent.WriteString("      // If we're not at the bottom anymore, clear all timers\n")
		jsContent.WriteString("      if (scrollTimer) {\n")
		jsContent.WriteString("        // Handle both interval and timeout cleanly\n")
		jsContent.WriteString("        clearInterval(scrollTimer);\n")
		jsContent.WriteString("        clearTimeout(scrollTimer);\n")
		jsContent.WriteString("        scrollTimer = null;\n")
		jsContent.WriteString("        \n")
		jsContent.WriteString("        // Clear any other intervals that might be running\n")
		jsContent.WriteString("        try {\n")
		jsContent.WriteString("          for (let i = 1; i < 1000; i++) {\n")
		jsContent.WriteString("            window.clearInterval(i);\n")
		jsContent.WriteString("          }\n")
		jsContent.WriteString("        } catch (e) {}\n")
		jsContent.WriteString("        \n")
		jsContent.WriteString("        // Remove countdown indicator if it exists\n")
		jsContent.WriteString("        const indicator = document.getElementById('navigation-countdown');\n")
		jsContent.WriteString("        if (indicator && indicator.parentNode) indicator.parentNode.removeChild(indicator);\n")
		jsContent.WriteString("      }\n")
		jsContent.WriteString("    }\n")
		jsContent.WriteString("  });\n")
	}
	jsContent.WriteString("});\n")

	// Replace the appropriate part in the HTML template
	var modifiedTemplate string

	// Simply replace the INSERT placeholder with our JavaScript content
	modifiedTemplate = strings.Replace(templateStr, "// INSERT", jsContent.String(), 1)

	// Write the complete HTML to the output file
	err := ioutil.WriteFile(outputPath, []byte(modifiedTemplate), 0644)
	if err != nil {
		return fmt.Errorf("failed to write HTML output to file %s: %w", outputPath, err)
	}

	return nil
}

func ensureCacheDir() error {
	if _, err := os.Stat(cacheDir); os.IsNotExist(err) {
		return os.Mkdir(cacheDir, 0755)
	}
	return nil
}

func getCacheFilename(imagePath string) string {
	return getHashedCacheFilename(imagePath, ".blur")
}

func getDimensionsCacheFilename(imagePath string) string {
	return getHashedCacheFilename(imagePath, ".dim")
}

func getHashedCacheFilename(imagePath string, suffix string) string {
	// Create a hash of the absolute path to use as the cache filename
	absPath, err := filepath.Abs(imagePath)
	if err != nil {
		absPath = imagePath // Fallback to original path if absolute path fails
	}

	hash := fmt.Sprintf("%x", sha256.Sum256([]byte(absPath)))
	return filepath.Join(cacheDir, hash+suffix)
}

func readFromCache(cacheFile string) (string, error) {
	data, err := ioutil.ReadFile(cacheFile)
	if err != nil {
		return "", err
	}
	return string(data), nil
}

func writeToCache(cacheFile string, blurmap string) error {
	return ioutil.WriteFile(cacheFile, []byte(blurmap), 0644)
}

// generateMainIndex creates a main index.html file that links to all chunks
func generateMainIndex(numChunks int, totalImages int) error {
	// Create HTML content with links to all chunks
	var content strings.Builder

	content.WriteString("<!DOCTYPE html>\n")
	content.WriteString("<html>\n")
	content.WriteString("<head>\n")
	content.WriteString("  <title>Gallery Index</title>\n")
	content.WriteString(fmt.Sprintf("  <script src=\"/gallery.js?cache=%d\"></script>\n", timestampCache))
	content.WriteString("  <style>\n")
	content.WriteString("    body { font-family: Arial, sans-serif; margin: 20px; background-color: #111; color: #eee; }\n")
	content.WriteString("    h1 { color: #ddd; }\n")
	content.WriteString("    .chunks { display: flex; flex-wrap: wrap; gap: 10px; }\n")
	content.WriteString("    .chunk-link { display: block; padding: 15px; background-color: #333; color: white; text-decoration: none; border-radius: 5px; }\n")
	content.WriteString("    .chunk-link:hover { background-color: #555; }\n")
	content.WriteString("  </style>\n")
	content.WriteString("</head>\n")
	content.WriteString("<body>\n")
	content.WriteString("  <h1>Gallery Chunks</h1>\n")
	content.WriteString("  <p>Total chunks: " + strconv.Itoa(numChunks) + "</p>\n")
	content.WriteString("  <p>Total images: " + strconv.Itoa(totalImages) + " (approximately " + strconv.Itoa(chunkSize) + " images per chunk)</p>\n")
	content.WriteString("  <div class=\"chunks\">\n")

	// Add links to each chunk
	for i := 1; i <= numChunks; i++ {
		content.WriteString("    <a href=\"" + strconv.Itoa(i) + "/index.html\" class=\"chunk-link\">Chunk " + strconv.Itoa(i) + "</a>\n")
	}

	content.WriteString("  </div>\n")
	content.WriteString("</body>\n")
	content.WriteString("</html>\n")

	// Write the index file
	indexPath := filepath.Join(outputDir, "index.html")
	return ioutil.WriteFile(indexPath, []byte(content.String()), 0644)
}

func generateBlurmap(imagePath string) (string, int, int, error) {
	// Open the image file
	file, err := os.Open(imagePath)
	if err != nil {
		return "", 0, 0, fmt.Errorf("failed to open image file: %w", err)
	}
	defer file.Close()

	// Decode the image
	img, _, err := image.Decode(file)
	if err != nil {
		return "", 0, 0, fmt.Errorf("failed to decode image: %w", err)
	}

	// Get image bounds
	bounds := img.Bounds()
	width := bounds.Max.X - bounds.Min.X
	height := bounds.Max.Y - bounds.Min.Y

	// Calculate cell dimensions - use the full image dimensions
	// Divide the width and height equally into 20 segments each
	cellWidth := width / 20
	cellHeight := height / 20

	// Ensure minimum size of 1 pixel
	if cellWidth < 1 {
		cellWidth = 1
	}
	if cellHeight < 1 {
		cellHeight = 1
	}

	var blurValues []string

	// Process each of the 20x20 cells over the entire image (not just square portion)
	for y := 0; y < 20; y++ {
		for x := 0; x < 20; x++ {
			// Calculate cell boundaries
			startX := bounds.Min.X + x*cellWidth
			startY := bounds.Min.Y + y*cellHeight
			endX := startX + cellWidth
			endY := startY + cellHeight

			// Make sure we don't exceed the image bounds
			if endX > bounds.Max.X {
				endX = bounds.Max.X
			}
			if endY > bounds.Max.Y {
				endY = bounds.Max.Y
			}

			// Calculate average color for the cell
			avgColor := calculateAverageColor(img, startX, startY, endX, endY)

			// Convert each RGB component to a hex value (RRGGBB)
			hexValue := fmt.Sprintf("%02x%02x%02x", avgColor.R, avgColor.G, avgColor.B)
			blurValues = append(blurValues, hexValue)
		}
	}

	// Join all hex values into a single string
	// Make sure we have exactly 400 values (20x20 grid)
	if len(blurValues) != 400 {
		// Pad or truncate as needed
		for len(blurValues) < 400 {
			blurValues = append(blurValues, "000000") // Black
		}
		if len(blurValues) > 400 {
			blurValues = blurValues[:400]
		}
	}

	return strings.Join(blurValues, ""), width, height, nil
}

// AverageColor holds RGB values for a cell
type AverageColor struct {
	R, G, B uint8
}

func calculateAverageColor(img image.Image, startX, startY, endX, endY int) AverageColor {
	var totalR, totalG, totalB int
	var count int

	for y := startY; y < endY; y++ {
		for x := startX; x < endX; x++ {
			// Get pixel color
			c := img.At(x, y)
			r, g, b, _ := c.RGBA()

			// RGBA values are in range 0-65535, convert to 0-255
			r, g, b = r>>8, g>>8, b>>8

			totalR += int(r)
			totalG += int(g)
			totalB += int(b)
			count++
		}
	}

	// Avoid division by zero
	if count == 0 {
		return AverageColor{0, 0, 0}
	}

	// Return average color as RGB values
	return AverageColor{
		R: uint8(totalR / count),
		G: uint8(totalG / count),
		B: uint8(totalB / count),
	}
}

// getImageDimensions reads an image file and returns its width and height
func getImageDimensions(imagePath string) (int, int, error) {
	file, err := os.Open(imagePath)
	if err != nil {
		return 0, 0, fmt.Errorf("failed to open image file: %w", err)
	}
	defer file.Close()

	// Decode the image
	img, _, err := image.Decode(file)
	if err != nil {
		return 0, 0, fmt.Errorf("failed to decode image: %w", err)
	}

	// Get image dimensions
	bounds := img.Bounds()
	width := bounds.Max.X - bounds.Min.X
	height := bounds.Max.Y - bounds.Min.Y

	return width, height, nil
}
