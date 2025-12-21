/*
Blurmap Gallery Generator
========================

This program generates responsive HTML image galleries with blurhash placeholders
for fast loading. It processes images to create blur previews, manages caching,
and outputs paginated HTML galleries with responsive layouts.

Key Features:
- Parallel blurhash generation for image placeholders
- Intelligent caching system for performance optimization
- Responsive HTML gallery generation with pagination
- Integration with JavaScript frontend for dynamic loading
- Support for different select modes (interactive vs read-only)

Architecture:
- Worker pool pattern for concurrent image processing
- SHA256-based cache keys for reliable cache invalidation
- Template-based HTML generation with embedded JavaScript
- Chunked output for handling large image collections

Usage:
  go run blurmap.go -i images.input -o gallery/ -d img/ -c cache/

Input Format:
  Text file with one image identifier per line (without extension)

Output:
  - Paginated HTML files (1.html, 2.html, etc.)
  - Embedded JavaScript with image metadata and blurhash data
  - CSS and JavaScript integration for responsive gallery display

Dependencies:
  - Standard Go libraries only
  - Image processing for PNG/JPEG formats
  - No external dependencies required
*/
package main

import (
	"bufio"
	"crypto/sha256"
	"flag"
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

// Command-line configuration variables
// These control the behavior and paths used by the gallery generator
var (
	allInputFile string // Path to input file containing image identifiers
	outputDir    string // Directory where HTML gallery pages will be written
	cacheDir     string // Directory for caching blurhash and dimension data
	imageDir     string // Source directory containing the actual image files
	selectMode   string // Gallery interaction mode ("yes" for selection, "no" for read-only)
)

// galleryTemplate defines the HTML structure for gallery pages
// This template is populated with image data and blurhash information
// Uses the new modular ES6 gallery system with window.galleryConfig
const galleryTemplate = `<!doctype html>
<html>
  <head>
    <link rel="stylesheet" href="/gallery/gallery.css" />
    <meta name="total-chunks" content="%d">
    <meta name="current-chunk" content="%s">
  </head>
  <body style="background-color: black">
    <script>
      // INSERT

      window.galleryConfig = {
        images: { thumbPath: '/%s' },
        click: {
          mode: '%s',
          navigateUrlPattern: '../../../W/{uuid}.html?page={page}#{filename}'
        },
        modal: { enabled: true }
      };
    </script>
    <table><tbody id="table-body"></tbody></table>
    <div id="overlay"></div>
    <script type="module" src="/gallery/index.js"></script>
  </body>
</html>`

// ImageInfo represents metadata for a single image in the gallery
// Contains both source information and processed blurhash data
type ImageInfo struct {
	Filename string // Base filename without extension
	Width    int    // Image width in pixels
	Height   int    // Image height in pixels
	Blurmap  string // Generated blurhash string for placeholder
}

// Result represents the outcome of processing a single image
// Used to communicate between worker goroutines and main thread
type Result struct {
	Filename  string // Image filename that was processed
	Blurmap   string // Generated or cached blurhash string
	Width     int    // Image width (from file or cache)
	Height    int    // Image height (from file or cache)
	Error     error  // Any error encountered during processing
	Cached    bool   // Whether blurhash was loaded from cache
	DimCached bool   // Whether dimensions were loaded from cache
}

// GalleryData contains the processed data ready for template injection
// Represents the final output data structure for HTML generation
type GalleryData struct {
	Images      string // JavaScript array of image objects with metadata
	BlurhashMap string // JavaScript object mapping filenames to blurhash data
}

// Configuration constants for gallery generation
const (
	chunkSize = 500 // Number of images per HTML page (pagination size)
)

// timestampCache provides cache-busting functionality for browser assets
// Set once at startup to ensure consistent cache invalidation across all pages
var timestampCache int64

// main orchestrates the entire gallery generation process
// When run without arguments: processes all w-* directories (batch mode)
// When run with arguments: processes a single directory (single mode)
func main() {
	// Configure command-line flags with both long and short forms
	// Input/output configuration
	flag.StringVar(&allInputFile, "input", "", "Input file containing image identifiers")
	flag.StringVar(&allInputFile, "i", "", "Input file containing image identifiers (shorthand)")
	flag.StringVar(&outputDir, "output", "", "Output directory for HTML gallery pages")
	flag.StringVar(&outputDir, "o", "", "Output directory for HTML gallery pages (shorthand)")

	// Cache and source configuration
	flag.StringVar(&cacheDir, "cache", "", "Cache directory for blurhash data")
	flag.StringVar(&cacheDir, "c", "", "Cache directory for blurhash data (shorthand)")
	flag.StringVar(&imageDir, "imagedir", "", "Source image directory")
	flag.StringVar(&imageDir, "d", "", "Source image directory (shorthand)")

	// Gallery behavior configuration
	flag.StringVar(&selectMode, "selectmode", "", "Select mode for image interaction (default: no)")
	flag.StringVar(&selectMode, "s", "", "Select mode for image interaction (shorthand)")

	// Help flags
	showHelp := flag.Bool("help", false, "Show help message")
	showHelpShort := flag.Bool("h", false, "Show help message (shorthand)")
	flag.Parse()

	// Display help information if requested
	if *showHelp || *showHelpShort {
		fmt.Fprintf(os.Stderr, "Usage: %s [options]\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "\nBatch mode (no arguments): Process all w-* galleries\n")
		fmt.Fprintf(os.Stderr, "Single mode (with arguments): Process one directory\n")
		fmt.Fprintf(os.Stderr, "\nOptions:\n")
		flag.PrintDefaults()
		os.Exit(0)
	}

	// Initialize cache-busting timestamp (consistent across all generated pages)
	timestampCache = time.Now().Unix()

	// Determine mode: batch (no arguments) or single (with arguments)
	if allInputFile == "" && outputDir == "" && imageDir == "" {
		// Batch mode: process all w-* directories
		batchProcessAllGalleries()
	} else {
		// Single mode: process one directory
		// Set defaults for single mode
		if allInputFile == "" {
			allInputFile = "all.input"
		}
		if outputDir == "" {
			outputDir = "g"
		}
		if cacheDir == "" {
			cacheDir = "blur"
		}
		if imageDir == "" {
			imageDir = "replicate/t2"
		}
		if selectMode == "" {
			selectMode = "no"
		}

		// Ensure cache directory exists for storing blurhash and dimension data
		if err := ensureCacheDir(); err != nil {
			fmt.Fprintf(os.Stderr, "Error creating cache directory: %v\n", err)
			os.Exit(1)
		}

		// Load and parse the input file containing image identifiers
		imageInfos, err := parseInputFile(allInputFile)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error parsing input file: %v\n", err)
			os.Exit(1)
		}

		fmt.Fprintf(os.Stderr, "Found %d images to process\n", len(imageInfos))
		processSingleGallery(imageInfos)
	}
}

// batchProcessAllGalleries processes all w-* directories in pub/fm/ and generates galleries
// This is equivalent to the 'just w-html' command
func batchProcessAllGalleries() {
	fmt.Fprintf(os.Stderr, "Batch mode: Processing all w-* galleries\n")

	// Set defaults for batch mode
	cacheDir = "tmp/blur"
	selectMode = "navigate" // All galleries use navigate mode

	// Ensure cache directory exists
	if err := os.MkdirAll(cacheDir, 0755); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating cache directory: %v\n", err)
		os.Exit(1)
	}

	// Find all w-?? and w-??? directories in pub/fm/
	sourceBase := "pub/fm"
	entries, err := ioutil.ReadDir(sourceBase)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading %s: %v\n", sourceBase, err)
		os.Exit(1)
	}

	var wDirs []string
	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}
		name := entry.Name()
		// Match w-?? or w-???
		if (len(name) == 4 && strings.HasPrefix(name, "w-")) ||
			(len(name) == 5 && strings.HasPrefix(name, "w-")) {
			wDirs = append(wDirs, name)
		}
	}

	sort.Strings(wDirs)
	fmt.Fprintf(os.Stderr, "Found %d w-* directories to process\n", len(wDirs))

	// Process w-* directories in parallel with worker pool
	numWorkers := 8
	jobs := make(chan string, len(wDirs))
	var wg sync.WaitGroup

	// Launch per-W gallery processing in parallel
	wg.Add(1)
	go func() {
		defer wg.Done()
		generatePerWGalleries(sourceBase)
	}()

	// Launch master gallery processing in parallel
	wg.Add(1)
	go func() {
		defer wg.Done()
		fmt.Fprintf(os.Stderr, "\n[Master] === Generating master gallery at pub/w/g/ ===\n")

		// Collect all PNG files from all w-* directories
		var allImages []ImageInfo
		for _, wDir := range wDirs {
			wPath := filepath.Join(sourceBase, wDir)
			pngFiles, err := filepath.Glob(filepath.Join(wPath, "*.png"))
			if err != nil {
				continue
			}
			for _, pngPath := range pngFiles {
				// Store as relative path from sourceBase: w-01/filename.png
				relPath, _ := filepath.Rel(sourceBase, pngPath)
				allImages = append(allImages, ImageInfo{
					Filename: relPath,
				})
			}
		}

		// Shuffle the images
		for i := len(allImages) - 1; i > 0; i-- {
			j := int(time.Now().UnixNano()) % (i + 1)
			allImages[i], allImages[j] = allImages[j], allImages[i]
		}

		fmt.Fprintf(os.Stderr, "[Master] Found %d total images for master gallery\n", len(allImages))

		if len(allImages) > 0 {
			processGalleryWithPaths(allImages, sourceBase, "pub/w/g")
		}
	}()

	// Launch workers for w-* directories
	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			for wDir := range jobs {
				fmt.Fprintf(os.Stderr, "\n[Worker %d] === Processing %s ===\n", workerID, wDir)

				imgDir := filepath.Join(sourceBase, wDir)
				outDir := filepath.Join("pub/w", wDir)

				// Get list of PNG files in this directory
				pngFiles, err := filepath.Glob(filepath.Join(imgDir, "*.png"))
				if err != nil {
					fmt.Fprintf(os.Stderr, "[Worker %d] Error listing PNG files in %s: %v\n", workerID, wDir, err)
					continue
				}

				// Extract basenames
				var imageInfos []ImageInfo
				for _, pngPath := range pngFiles {
					basename := filepath.Base(pngPath)
					imageInfos = append(imageInfos, ImageInfo{
						Filename: basename,
					})
				}

				// Sort by filename
				sort.Slice(imageInfos, func(i, j int) bool {
					return imageInfos[i].Filename < imageInfos[j].Filename
				})

				fmt.Fprintf(os.Stderr, "[Worker %d] Found %d images in %s\n", workerID, len(imageInfos), wDir)

				if len(imageInfos) > 0 {
					// Process this gallery with its own imageDir/outputDir
					processGalleryWithPaths(imageInfos, imgDir, outDir)
				}
			}
		}(w)
	}

	// Send all w-* directories to workers
	for _, wDir := range wDirs {
		jobs <- wDir
	}
	close(jobs)

	// Wait for all workers (including master gallery) to finish
	wg.Wait()

	fmt.Fprintf(os.Stderr, "\n=== All galleries generated successfully! ===\n")
}

// processGalleryWithPaths processes a list of images with explicit paths (for parallel processing)
func processGalleryWithPaths(imageInfos []ImageInfo, imgDir, outDir string) {
	var err error

	// Configure worker pool for parallel image processing
	// Use all available CPU cores for optimal performance
	numWorkers := runtime.NumCPU()
	runtime.GOMAXPROCS(numWorkers)

	// Set up channels for distributing work and collecting results
	jobs := make(chan ImageInfo, len(imageInfos))
	results := make(chan Result, len(imageInfos))

	// Synchronization primitive to wait for all workers to complete
	var wg sync.WaitGroup

	// Launch worker goroutines for parallel processing
	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for imageInfo := range jobs {
				// Construct the full image path using imgDir
				imagePath := filepath.Join(imgDir, imageInfo.Filename)

				// Generate cache filenames
				cacheFile := getHashedCacheFilename(imagePath, ".blur")
				dimCacheFile := getHashedCacheFilename(imagePath, ".dim")

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
					_, err = fmt.Sscanf(dimData, "%d,%d", &width, &height)
					if err == nil {
						dimCached = true
					}
				}

				// If either blurhash or dimensions weren't in cache, process the image
				if !blurCached || !dimCached {
					var processErr error

					if !blurCached {
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

						if err := writeToCache(cacheFile, blurmap); err != nil {
							fmt.Fprintf(os.Stderr, "Warning: Failed to write blurhash to cache for %s: %v\n", imageInfo.Filename, err)
						}
					}

					if !dimCached {
						if !blurCached {
							dimCached = false
						} else {
							var dimErr error
							width, height, dimErr = getImageDimensions(imagePath)
							if dimErr != nil {
								fmt.Fprintf(os.Stderr, "Warning: Failed to get dimensions for %s: %v\n", imageInfo.Filename, dimErr)
								width, height = 0, 0
							}
						}

						dimData := fmt.Sprintf("%d,%d", width, height)
						if err := writeToCache(dimCacheFile, dimData); err != nil {
							fmt.Fprintf(os.Stderr, "Warning: Failed to write dimensions to cache for %s: %v\n", imageInfo.Filename, err)
						}
					}
				}

				results <- Result{
					Filename:  imageInfo.Filename,
					Blurmap:   blurmap,
					Width:     width,
					Height:    height,
					Cached:    blurCached,
					DimCached: dimCached,
				}
			}
		}()
	}

	// Distribute all image processing jobs to workers
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

		if processed%1000 == 0 {
			fmt.Fprintf(os.Stderr, "Processed %d images, %d errors\n", processed, errors)
		}
	}

	fmt.Fprintf(os.Stderr, "Completed blur processing. Total: %d images processed, %d errors\n", processed, errors)
	fmt.Fprintf(os.Stderr, "Cache stats: %d/%d blurhashes cached, %d/%d dimensions cached\n",
		cachedBlur, processed, cachedDim, processed)

	// Create a valid list of ImageInfo - only those with blurmap
	var validImages []ImageInfo
	for _, info := range imageInfos {
		if info.Blurmap != "" {
			validImages = append(validImages, info)
		}
	}

	// Calculate number of chunks needed
	totalImages := len(validImages)
	numChunks := (totalImages + chunkSize - 1) / chunkSize

	fmt.Fprintf(os.Stderr, "Generating %d chunks with %d images per chunk (total: %d images)\n",
		numChunks, chunkSize, totalImages)

	// Create the output directory structure
	err = os.MkdirAll(outDir, 0755)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating output directory: %v\n", err)
		return
	}

	// Generate chunked HTML files
	for chunkNum := 1; chunkNum <= numChunks; chunkNum++ {
		start := (chunkNum - 1) * chunkSize
		end := start + chunkSize
		if end > totalImages {
			end = totalImages
		}

		chunkDir := filepath.Join(outDir, strconv.Itoa(chunkNum))
		err = os.MkdirAll(chunkDir, 0755)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error creating chunk directory %s: %v\n", chunkDir, err)
			continue
		}

		chunkImages := validImages[start:end]
		outputPath := fmt.Sprintf("%s/index.html", chunkDir)

		fmt.Fprintf(os.Stderr, "Generating chunk %d (%d images) to %s...\n",
			chunkNum, len(chunkImages), outputPath)

		err = generateChunkHTMLWithPaths(chunkImages, outputPath, numChunks, imgDir)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error generating HTML for chunk %d: %v\n", chunkNum, err)
		}
	}

	// Create main index.html
	fmt.Fprintf(os.Stderr, "Creating main index.html...\n")
	err = generateMainIndex(numChunks, totalImages, outDir)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error generating main index: %v\n", err)
	}

	fmt.Fprintf(os.Stderr, "All chunks generated successfully!\n")
}

// processSingleGallery processes a list of images and generates the gallery HTML (uses global vars)
func processSingleGallery(imageInfos []ImageInfo) {
	processGalleryWithPaths(imageInfos, imageDir, outputDir)
}

// generatePerWGalleries creates per-template galleries (equivalent to per-W.sh)
// For each template in pub/fm/W/, creates pub/W/UUID.html showing all variants
// Also creates pub/W.html master index with clickable thumbnails
func generatePerWGalleries(sourceBase string) {
	fmt.Fprintf(os.Stderr, "\n[Per-W] === Generating per-template galleries ===\n")

	// Find all template files in pub/fm/W/
	wDir := filepath.Join(sourceBase, "W")
	files, err := ioutil.ReadDir(wDir)
	if err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error reading %s: %v\n", wDir, err)
		return
	}

	var templateFiles []string
	for _, file := range files {
		if !file.IsDir() {
			templateFiles = append(templateFiles, file.Name())
		}
	}

	sort.Strings(templateFiles)
	fmt.Fprintf(os.Stderr, "[Per-W] Found %d template files\n", len(templateFiles))

	// Create output directory
	if err := os.MkdirAll("pub/W", 0755); err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error creating pub/W: %v\n", err)
		return
	}

	// Process templates in parallel (8 workers)
	numWorkers := 8
	jobs := make(chan string, len(templateFiles))
	thumbnails := make(chan string, len(templateFiles))
	var wg sync.WaitGroup

	// Launch workers
	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			for templateFile := range jobs {
				thumbnail := generatePerWPage(sourceBase, templateFile)
				thumbnails <- thumbnail
			}
		}(w)
	}

	// Send all template files to workers
	for _, templateFile := range templateFiles {
		jobs <- templateFile
	}
	close(jobs)

	// Wait for all workers to finish
	go func() {
		wg.Wait()
		close(thumbnails)
	}()

	// Collect thumbnails for master index
	var masterIndex strings.Builder
	for thumbnail := range thumbnails {
		masterIndex.WriteString(thumbnail)
		masterIndex.WriteString("\n")
	}

	// Write master index file
	if err := ioutil.WriteFile("pub/W.html", []byte(masterIndex.String()), 0644); err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error writing pub/W.html: %v\n", err)
	}

	fmt.Fprintf(os.Stderr, "[Per-W] Generated pub/W.html and %d detail pages\n", len(templateFiles))
}

// generatePerWPage creates a detail page for a single template file
// Returns the thumbnail HTML for the master index
func generatePerWPage(sourceBase, templateFile string) string {
	// Find all variant images across w-* directories
	pattern := filepath.Join(sourceBase, "w-*", "*-"+templateFile)
	variants, err := filepath.Glob(pattern)
	if err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error finding variants for %s: %v\n", templateFile, err)
		return ""
	}

	sort.Strings(variants)

	// Generate detail page HTML
	var detailPage strings.Builder
	detailPage.WriteString(`<!DOCTYPE html>
  <html>
  <head>
    <title>Gallery</title>
  </head>
  <body>
    <div id="gallery-container"></div>
    <script>
    function generateGalleryImageTag(imageSrc) {
      try {
        const urlObj = new URL(window.location.href);
        const pageParam = urlObj.searchParams.get('page');
        if (!pageParam) {
          throw new Error('Missing page parameter');
        }
        const anchor = urlObj.hash.replace('#', '');
        if (!anchor) {
          throw new Error('Missing anchor fragment');
        }
        const imageSrcMatch = imageSrc.match(/\/w-(\d+)\//);
        if (!imageSrcMatch) {
          throw new Error('Invalid imageSrc format - missing w-NN directory');
        }
        const wPrefix = ` + "`w-${imageSrcMatch[1]}`" + `;
        const uuid = anchor.replace(/^w-\d+-/, '');
        const galleryPath = ` + "`../w/${wPrefix}/${pageParam}/#${wPrefix}-${uuid}`" + `;
        return ` + "`<a href=\"${galleryPath}\"><img src=\"${imageSrc}\"></a>`" + `;
      } catch (error) {
        console.error('Error generating gallery image tag:', error.message);
        return ` + "`<img src=\"${imageSrc}\">`" + `;
      }
    }
`)

	// Add JavaScript lines to populate gallery
	for _, variant := range variants {
		// Convert absolute path to relative path from pub/W/
		relPath, _ := filepath.Rel("pub", variant)
		detailPage.WriteString(fmt.Sprintf("    document.getElementById('gallery-container').innerHTML += generateGalleryImageTag('../%s');\n", relPath))
	}

	detailPage.WriteString(`    </script>
  </body>
  </html>
`)

	// Write detail page
	detailPath := filepath.Join("pub/W", templateFile+".html")
	if err := ioutil.WriteFile(detailPath, []byte(detailPage.String()), 0644); err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error writing %s: %v\n", detailPath, err)
	}

	// Return thumbnail HTML for master index
	return fmt.Sprintf("<a href=\"W/%s.html\"><img src=\"fm/W/%s\"></a>", templateFile, templateFile)
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

// generateChunkHTMLWithPaths creates HTML with explicit imgDir parameter
func generateChunkHTMLWithPaths(imageInfos []ImageInfo, outputPath string, totalChunks int, imgDir string) error {
	// Extract chunk number from path
	chunkNum := strings.Split(outputPath, "/")[len(strings.Split(outputPath, "/"))-2]

	// Convert selectMode to click.mode for new gallery system
	clickMode := "toggle"
	if selectMode == "yes" {
		clickMode = "select"
	} else if selectMode == "W-gallery" || selectMode == "navigate" {
		clickMode = "navigate"
	}

	// Format the template with proper values (no timestampCache)
	templateStr := fmt.Sprintf(galleryTemplate, totalChunks, chunkNum, imgDir, clickMode)

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

	blurhashMap.WriteString("};\n\n")

	// Generate window.images array from blurhashIndex
	blurhashMap.WriteString("window.images = Object.keys(window.blurhashIndex).map(filename => ({\n")
	blurhashMap.WriteString("  filename,\n")
	blurhashMap.WriteString("  width: window.blurhashIndex[filename].width,\n")
	blurhashMap.WriteString("  height: window.blurhashIndex[filename].height\n")
	blurhashMap.WriteString("}));\n")

	modifiedTemplate := strings.Replace(templateStr, "// INSERT", blurhashMap.String(), 1)

	// Write the complete HTML to the output file
	err := ioutil.WriteFile(outputPath, []byte(modifiedTemplate), 0644)
	if err != nil {
		return fmt.Errorf("failed to write HTML output to file %s: %w", outputPath, err)
	}

	return nil
}

// generateChunkHTML creates HTML using global imageDir variable (for backward compatibility)
func generateChunkHTML(imageInfos []ImageInfo, outputPath string, totalChunks int) error {
	return generateChunkHTMLWithPaths(imageInfos, outputPath, totalChunks, imageDir)
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

// generateMainIndex creates a main index.html file that randomly redirects to one of the galleries
func generateMainIndex(numChunks int, totalImages int, outDir string) error {
	// Create HTML content that randomly redirects to one of the galleries
	var content strings.Builder

	content.WriteString("<!DOCTYPE html>\n")
	content.WriteString("<html>\n")
	content.WriteString("<head>\n")
	content.WriteString("  <title>Gallery - Redirecting...</title>\n")
	content.WriteString("  <style>\n")
	content.WriteString("    body { font-family: Arial, sans-serif; margin: 0; background-color: #111; color: #eee; height: 100vh; display: flex; justify-content: center; align-items: center; }\n")
	content.WriteString("    .loading { text-align: center; }\n")
	content.WriteString("    h1 { color: #ddd; font-size: 2em; margin-bottom: 20px; }\n")
	content.WriteString("    p { color: #999; font-size: 1.2em; }\n")
	content.WriteString("  </style>\n")
	content.WriteString("  <script>\n")
	content.WriteString("    // Randomly select a gallery between 1 and " + strconv.Itoa(numChunks) + "\n")
	content.WriteString("    const totalGalleries = " + strconv.Itoa(numChunks) + ";\n")
	content.WriteString("    const randomGallery = Math.floor(Math.random() * totalGalleries) + 1;\n")
	content.WriteString("    \n")
	content.WriteString("    // Redirect to the randomly selected gallery with trailing slash\n")
	content.WriteString("    window.location.href = randomGallery + '/';\n")
	content.WriteString("  </script>\n")
	content.WriteString("</head>\n")
	content.WriteString("<body>\n")
	content.WriteString("  <div class=\"loading\">\n")
	content.WriteString("    <h1>Gallery</h1>\n")
	content.WriteString("    <p>Redirecting to a random gallery...</p>\n")
	content.WriteString("  </div>\n")
	content.WriteString("</body>\n")
	content.WriteString("</html>\n")

	// Write the index file
	indexPath := filepath.Join(outDir, "index.html")
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
