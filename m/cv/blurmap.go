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

	// Autoscrolling functionality has been removed
	if chunkNumInt < totalChunks {
		jsContent.WriteString("\n  // Autoscrolling functionality has been removed\n")
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
