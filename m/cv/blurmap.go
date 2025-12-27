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

	go run blurmap.go -mode gallery -scan-dir img/
	go run blurmap.go -mode html -json users.json -o gallery/
	go run blurmap.go -mode batch

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
	"bytes"
	"crypto/sha256"
	"database/sql"
	"encoding/base64"
	"encoding/json"
	"flag"
	"fmt"
	"image"
	_ "image/jpeg" // Register JPEG format
	_ "image/png"  // Register PNG format
	"io/ioutil"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	_ "github.com/mattn/go-sqlite3"
)

// Command-line configuration variables
// These control the behavior and paths used by the gallery generator
var (
	outputDir       string // Directory where HTML gallery pages will be written
	cacheDir        string // Directory for caching blurhash and dimension data
	imageDir        string // Source directory containing the actual image files
	selectMode      string // Gallery interaction mode ("yes" for selection, "no" for read-only)
	scanDir         string // Directory to scan for images (gallery mode)
	fileListPath    string // File containing list of image IDs (gallery mode alternative to scanDir)
	jsonFile        string // JSON file for filtering (html mode)
	stage1Dir       string // First stage directory for filtering (html mode)
	stage2Dir       string // Second stage directory for filtering (html mode)
	thumbsDir       string // Thumbnails directory for filtering (html mode)
	generateIndex   string // Path to generate index file (html mode)
	usersFile       string // File containing list of usernames (user mode)
	apiURL          string // API base URL for downloading user data (user mode)
	startPage       int    // Starting page number for user downloads (user mode)
	pageLimit       int    // Maximum number of pages to download per user (user mode)
	downloadWorkers int    // Number of parallel download workers (download mode)
	downloadBatch   int    // URLs per batch for downloads (download mode)
	thumbWorkers    int    // Number of parallel thumbnail workers (download mode)
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
        images: { thumbPath: '%s' },
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

	// Gallery mode specific flags
	flag.StringVar(&scanDir, "scan-dir", "", "Directory to scan for images (gallery mode)")
	flag.StringVar(&fileListPath, "file-list", "", "File containing list of image IDs (gallery mode, alternative to -scan-dir)")

	// HTML mode specific flags
	flag.StringVar(&jsonFile, "json-file", "", "JSON file containing image metadata (html mode)")
	flag.StringVar(&jsonFile, "json", "", "JSON file containing image metadata (shorthand)")
	flag.StringVar(&stage1Dir, "stage1", "yes", "First stage directory for filtering (html mode)")
	flag.StringVar(&stage2Dir, "stage2", "no", "Second stage directory for filtering (html mode)")
	flag.StringVar(&thumbsDir, "thumbs-dir", "thumbs", "Thumbnails directory for filtering (html mode)")
	flag.StringVar(&generateIndex, "generate-index", "", "Generate index file with links to all galleries")

	// User mode specific flags
	flag.StringVar(&usersFile, "users-file", "", "File containing list of usernames to download (user mode)")
	flag.StringVar(&usersFile, "users", "", "File containing list of usernames (shorthand)")
	flag.StringVar(&apiURL, "api-url", "", "API base URL for downloading (user mode, defaults to .env)")
	flag.IntVar(&startPage, "start-page", 1, "Starting page number for downloads (user mode)")
	flag.IntVar(&pageLimit, "page-limit", 500, "Maximum pages to download per user (user mode)")

	// Download mode specific flags
	flag.IntVar(&downloadWorkers, "download-workers", 8, "Number of parallel download workers (download mode)")
	flag.IntVar(&downloadBatch, "download-batch", 20, "URLs per batch for downloads (download mode)")
	flag.IntVar(&thumbWorkers, "thumb-workers", 32, "Number of parallel thumbnail workers (download mode)")

	// Mode configuration
	var modeValue string
	flag.StringVar(&modeValue, "mode", "", "Operating mode: gallery, html, batch, fem, user, download, todo, fixup, import, or report")
	flag.StringVar(&modeValue, "m", "", "Operating mode (shorthand): gallery, html, batch, fem, user, download, todo, fixup, import, or report")
	mode := &modeValue

	// Help flags
	showHelp := flag.Bool("help", false, "Show help message")
	showHelpShort := flag.Bool("h", false, "Show help message (shorthand)")
	flag.Parse()

	// Display help information if requested
	if *showHelp || *showHelpShort {
		fmt.Fprintf(os.Stderr, "Usage: %s -mode <gallery|html|batch|fem|user|download|todo|fixup|import|report> [options]\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "\nModes:\n")
		fmt.Fprintf(os.Stderr, "  gallery  - Scan directory and generate main gallery\n")
		fmt.Fprintf(os.Stderr, "  html     - Process JSON file and generate per-user gallery with filtering\n")
		fmt.Fprintf(os.Stderr, "  batch    - Process all w-* galleries in batch\n")
		fmt.Fprintf(os.Stderr, "  fem      - Face manipulation gallery generator using ML model server\n")
		fmt.Fprintf(os.Stderr, "  todo     - Generate list of uncurated images (not in yes/ or no/)\n")
		fmt.Fprintf(os.Stderr, "  fixup    - Create no/ entries for all zero-length files in img/\n")
		fmt.Fprintf(os.Stderr, "  user     - Download user data from API (reads usernames from file)\n")
		fmt.Fprintf(os.Stderr, "  download - Download images and generate thumbnails from user data\n")
		fmt.Fprintf(os.Stderr, "  import   - Import image data from filesystem into SQLite database\n")
		fmt.Fprintf(os.Stderr, "  report   - Display statistics about images in database\n")
		fmt.Fprintf(os.Stderr, "\nOptions:\n")
		flag.PrintDefaults()
		os.Exit(0)
	}

	// Initialize cache-busting timestamp (consistent across all generated pages)
	timestampCache = time.Now().Unix()

	// Process based on explicit mode
	switch *mode {
	case "batch":
		// Batch mode: process all w-* galleries
		batchProcessAllGalleries()

	case "gallery":
		// Gallery mode: main gallery from directory scan or file list
		if scanDir == "" && fileListPath == "" {
			fmt.Fprintf(os.Stderr, "Error: Either -scan-dir or -file-list required for gallery mode\n")
			os.Exit(1)
		}
		if scanDir != "" && fileListPath != "" {
			fmt.Fprintf(os.Stderr, "Error: Cannot use both -scan-dir and -file-list\n")
			os.Exit(1)
		}

		// Set defaults based on mode
		if fileListPath != "" {
			// File list mode (curation)
			if outputDir == "" {
				outputDir = "tmp/g"
			}
			if cacheDir == "" {
				cacheDir = "tmp/blur"
			}
			if imageDir == "" {
				imageDir = "thumbs"
			}
			if selectMode == "" {
				selectMode = "yes" // Curation mode defaults to selection
			}
		} else {
			// Directory scan mode
			if outputDir == "" {
				outputDir = "g"
			}
			if cacheDir == "" {
				cacheDir = "blur"
			}
			if imageDir == "" {
				imageDir = scanDir // Use scan directory as image directory
			}
			if selectMode == "" {
				selectMode = "no"
			}
		}

		// Ensure cache directory exists for storing blurhash and dimension data
		if err := ensureCacheDir(); err != nil {
			fmt.Fprintf(os.Stderr, "Error creating cache directory: %v\n", err)
			os.Exit(1)
		}

		var imageInfos []ImageInfo
		var err error

		if fileListPath != "" {
			// Read image IDs from file
			fmt.Fprintf(os.Stderr, "Reading image IDs from: %s\n", fileListPath)
			imageInfos, err = readImageIDsFromFile(fileListPath, imageDir)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Error reading file list: %v\n", err)
				os.Exit(1)
			}
		} else {
			// Scan directory for images
			fmt.Fprintf(os.Stderr, "Scanning directory: %s\n", scanDir)
			imageInfos, err = scanDirectoryForImages(scanDir)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Error scanning directory: %v\n", err)
				os.Exit(1)
			}
		}

		fmt.Fprintf(os.Stderr, "Found %d images to process\n", len(imageInfos))
		processSingleGallery(imageInfos)

	case "html":
		// HTML mode: per-user galleries with JSON input and filtering
		if jsonFile == "" {
			fmt.Fprintf(os.Stderr, "Error: -json-file required for html mode\n")
			os.Exit(1)
		}
		if outputDir == "" {
			fmt.Fprintf(os.Stderr, "Error: -output required for html mode\n")
			os.Exit(1)
		}
		if cacheDir == "" {
			cacheDir = "tmp/blur"
		}
		if imageDir == "" {
			imageDir = "thumbs"
		}
		if selectMode == "" {
			selectMode = "yes"
		}

		// Check if JSON file exists before processing
		if _, err := os.Stat(jsonFile); os.IsNotExist(err) {
			// Silently skip missing files (they may not have been downloaded yet)
			os.Exit(0)
		}

		// Ensure cache directory exists for storing blurhash and dimension data
		if err := ensureCacheDir(); err != nil {
			fmt.Fprintf(os.Stderr, "Error creating cache directory: %v\n", err)
			os.Exit(1)
		}

		// Process JSON file and filter images
		fmt.Fprintf(os.Stderr, "Processing JSON file: %s\n", jsonFile)
		imageInfos, err := processJSONWithFiltering(jsonFile, stage1Dir, stage2Dir, thumbsDir)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error processing JSON: %v\n", err)
			os.Exit(1)
		}

		fmt.Fprintf(os.Stderr, "Found %d images to process\n", len(imageInfos))
		processSingleGallery(imageInfos)

		// Generate index file if requested
		if generateIndex != "" {
			fmt.Fprintf(os.Stderr, "Generating index file: %s\n", generateIndex)
			if err := generateIndexFile(generateIndex); err != nil {
				fmt.Fprintf(os.Stderr, "Error generating index: %v\n", err)
				os.Exit(1)
			}
		}

	case "fem":
		// FEM mode: face manipulation gallery generator
		fmt.Fprintf(os.Stderr, "FEM mode: Generating face-swapped galleries\n")
		runFemMode()

	case "user":
		// User mode: download user data from API
		downloadUsersMode()

	case "download":
		// Download mode: download images and generate thumbnails
		downloadMode()

	case "todo":
		// Todo mode: generate list of uncurated images
		todoMode()

	case "fixup":
		// Fixup mode: create no/ entries for zero-length files in img/
		fixupMode()

	case "import":
		// Import mode: populate database from existing directories
		importMode()

	case "report":
		// Report mode: display statistics about images in database
		reportMode()

	default:
		fmt.Fprintf(os.Stderr, "Error: -mode must be specified as 'gallery', 'html', 'batch', 'fem', 'user', 'download', 'todo', 'fixup', 'import', or 'report'\n")
		fmt.Fprintf(os.Stderr, "Run with -help for usage information\n")
		os.Exit(1)
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

	// Track completion status for debugging
	type WorkerStatus struct {
		sync.Mutex
		perWComplete   bool
		masterComplete bool
		fmHtmlComplete bool
		wWorkersActive int
		wWorkersTotal  int
	}
	status := &WorkerStatus{wWorkersTotal: numWorkers}

	// Launch per-W gallery processing in parallel
	wg.Add(1)
	go func() {
		defer wg.Done()
		defer func() {
			status.Lock()
			status.perWComplete = true
			fmt.Fprintf(os.Stderr, "[Per-W] Worker completed\n")
			status.Unlock()
		}()
		generatePerWGalleries(sourceBase)
	}()

	// Launch fm.html generation in parallel
	wg.Add(1)
	go func() {
		defer wg.Done()
		defer func() {
			status.Lock()
			status.fmHtmlComplete = true
			fmt.Fprintf(os.Stderr, "[FM-HTML] Worker completed\n")
			status.Unlock()
		}()
		generateGalleryIndex()
	}()

	// Launch master gallery processing in parallel
	wg.Add(1)
	go func() {
		defer wg.Done()
		defer func() {
			status.Lock()
			status.masterComplete = true
			fmt.Fprintf(os.Stderr, "[Master] Worker completed\n")
			status.Unlock()
		}()
		fmt.Fprintf(os.Stderr, "\n[Master] === Generating master gallery at pub/w/g/ ===\n")

		// Parallelize image collection from all w-* directories
		collectionJobs := make(chan string, len(wDirs))
		collectionResults := make(chan []ImageInfo, len(wDirs))
		var collectionWg sync.WaitGroup

		// Launch 8 workers to collect images in parallel
		var collectedCount int
		var collectedMutex sync.Mutex
		for w := 0; w < 8; w++ {
			collectionWg.Add(1)
			go func(workerID int) {
				defer collectionWg.Done()
				for wDir := range collectionJobs {
					wPath := filepath.Join(sourceBase, wDir)
					pngFiles, err := filepath.Glob(filepath.Join(wPath, "*.png"))
					if err != nil {
						continue
					}
					var dirImages []ImageInfo
					for _, pngPath := range pngFiles {
						relPath, _ := filepath.Rel(sourceBase, pngPath)
						dirImages = append(dirImages, ImageInfo{
							Filename: relPath,
						})
					}
					if len(dirImages) > 0 {
						collectionResults <- dirImages
					}

					// Report progress every 100 directories
					collectedMutex.Lock()
					collectedCount++
					if collectedCount%100 == 0 || collectedCount == len(wDirs) {
						fmt.Fprintf(os.Stderr, "[Master] Collected from %d/%d directories\n", collectedCount, len(wDirs))
					}
					collectedMutex.Unlock()
				}
			}(w)
		}

		// Send all w-* directories to collection workers
		for _, wDir := range wDirs {
			collectionJobs <- wDir
		}
		close(collectionJobs)

		// Wait for collection to finish and close results
		go func() {
			collectionWg.Wait()
			close(collectionResults)
		}()

		// Merge all collected images
		var allImages []ImageInfo
		for dirImages := range collectionResults {
			allImages = append(allImages, dirImages...)
		}

		fmt.Fprintf(os.Stderr, "[Master] Collected %d images from %d directories\n", len(allImages), len(wDirs))

		// Shuffle the images
		for i := len(allImages) - 1; i > 0; i-- {
			j := int(time.Now().UnixNano()) % (i + 1)
			allImages[i], allImages[j] = allImages[j], allImages[i]
		}

		fmt.Fprintf(os.Stderr, "[Master] Found %d total images for master gallery\n", len(allImages))

		if len(allImages) > 0 {
			processGalleryWithPathsLabeled(allImages, sourceBase, "pub/w/g", "[Master]")
		}
	}()

	// Launch workers for w-* directories
	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			defer func() {
				status.Lock()
				status.wWorkersActive--
				fmt.Fprintf(os.Stderr, "[Worker %d] Completed all jobs\n", workerID)
				status.Unlock()
			}()

			status.Lock()
			status.wWorkersActive++
			status.Unlock()

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

	// Launch watchdog to monitor goroutine count
	done := make(chan bool)
	go func() {
		ticker := time.NewTicker(5 * time.Second)
		defer ticker.Stop()

		lastCount := runtime.NumGoroutine()
		sameCountIterations := 0

		for {
			select {
			case <-done:
				return
			case <-ticker.C:
				currentCount := runtime.NumGoroutine()

				// Get current worker status
				status.Lock()
				perWDone := status.perWComplete
				masterDone := status.masterComplete
				fmHtmlDone := status.fmHtmlComplete
				wActive := status.wWorkersActive
				wTotal := status.wWorkersTotal
				status.Unlock()

				// Print detailed status
				fmt.Fprintf(os.Stderr, "[Watchdog] Goroutines: %d | Per-W: %v | Master: %v | FM-HTML: %v | W-Workers: %d/%d active\n",
					currentCount, perWDone, masterDone, fmHtmlDone, wActive, wTotal)

				// If count hasn't changed, increment counter
				if currentCount == lastCount {
					sameCountIterations++
				} else {
					sameCountIterations = 0
				}
				lastCount = currentCount

				// If only 2 goroutines remain (main + watchdog) for 10 seconds, exit
				if currentCount <= 2 && sameCountIterations >= 2 {
					fmt.Fprintf(os.Stderr, "[Watchdog] Only monitoring goroutine remains, exiting.\n")
					os.Exit(0)
				}

				// If stuck at same count for 30 seconds (6 iterations), warn
				if sameCountIterations >= 6 {
					fmt.Fprintf(os.Stderr, "[Watchdog] WARNING: Goroutine count stuck at %d for %d seconds\n",
						currentCount, sameCountIterations*5)
					fmt.Fprintf(os.Stderr, "[Watchdog] Status: Per-W=%v, Master=%v, FM-HTML=%v, W-Workers=%d/%d\n",
						perWDone, masterDone, fmHtmlDone, wActive, wTotal)
				}
			}
		}
	}()

	// Wait for all workers (including master gallery and per-W) to finish
	fmt.Fprintf(os.Stderr, "\n=== Waiting for all workers to complete... ===\n")
	wg.Wait()

	// Signal watchdog to stop
	close(done)

	fmt.Fprintf(os.Stderr, "\n=== All galleries generated successfully! ===\n")
	fmt.Fprintf(os.Stderr, "Processed %d w-* directories, master gallery, and per-template galleries\n", len(wDirs))
}

// processGalleryWithPaths processes a list of images with explicit paths (for parallel processing)
func processGalleryWithPaths(imageInfos []ImageInfo, imgDir, outDir string) {
	processGalleryWithPathsLabeled(imageInfos, imgDir, outDir, "")
}

// processGalleryWithPathsLabeled is the internal version with optional label for logging
func processGalleryWithPathsLabeled(imageInfos []ImageInfo, imgDir, outDir, label string) {
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

	prefix := label
	if prefix != "" {
		prefix = prefix + " "
	}

	fmt.Fprintf(os.Stderr, "%sCompleted blur processing. Total: %d images processed, %d errors\n", prefix, processed, errors)
	fmt.Fprintf(os.Stderr, "%sCache stats: %d/%d blurhashes cached, %d/%d dimensions cached\n", prefix,
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

	fmt.Fprintf(os.Stderr, "%sGenerating %d chunks with %d images per chunk (total: %d images)\n", prefix,
		numChunks, chunkSize, totalImages)

	// Create the output directory structure
	err = os.MkdirAll(outDir, 0755)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating output directory: %v\n", err)
		return
	}

	// Generate chunked HTML files in parallel
	type chunkJob struct {
		chunkNum int
		start    int
		end      int
	}

	chunkJobs := make(chan chunkJob, numChunks)
	var chunkWg sync.WaitGroup

	// Launch 8 workers for chunk generation
	chunkWorkers := 8
	var chunkCount int
	var chunkMutex sync.Mutex
	for w := 0; w < chunkWorkers; w++ {
		chunkWg.Add(1)
		go func(workerID int) {
			defer chunkWg.Done()
			for job := range chunkJobs {
				chunkDir := filepath.Join(outDir, strconv.Itoa(job.chunkNum))
				err := os.MkdirAll(chunkDir, 0755)
				if err != nil {
					fmt.Fprintf(os.Stderr, "Error creating chunk directory %s: %v\n", chunkDir, err)
					continue
				}

				chunkImages := validImages[job.start:job.end]
				outputPath := fmt.Sprintf("%s/index.html", chunkDir)

				err = generateChunkHTMLWithPaths(chunkImages, outputPath, numChunks, imgDir)
				if err != nil {
					fmt.Fprintf(os.Stderr, "Error generating HTML for chunk %d: %v\n", job.chunkNum, err)
				}

				// Report progress every 100 chunks
				chunkMutex.Lock()
				chunkCount++
				if chunkCount%100 == 0 || chunkCount == numChunks {
					fmt.Fprintf(os.Stderr, "%sGenerated %d/%d chunks\n", prefix, chunkCount, numChunks)
				}
				chunkMutex.Unlock()
			}
		}(w)
	}

	// Send all chunk jobs to workers
	for chunkNum := 1; chunkNum <= numChunks; chunkNum++ {
		start := (chunkNum - 1) * chunkSize
		end := start + chunkSize
		if end > totalImages {
			end = totalImages
		}
		chunkJobs <- chunkJob{chunkNum: chunkNum, start: start, end: end}
	}
	close(chunkJobs)

	// Wait for all chunks to be generated
	chunkWg.Wait()

	// Create main index.html
	fmt.Fprintf(os.Stderr, "%sCreating main index.html...\n", prefix)
	err = generateMainIndex(numChunks, totalImages, outDir)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sError generating main index: %v\n", prefix, err)
	}

	fmt.Fprintf(os.Stderr, "%sAll chunks generated successfully!\n", prefix)
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
	fmt.Fprintf(os.Stderr, "[Per-W] Reading directory %s...\n", wDir)
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

	// Build an index of all variants to avoid expensive Glob operations
	fmt.Fprintf(os.Stderr, "[Per-W] Building variant index from w-* directories...\n")

	// Find all w-* entries and filter to only directories
	wMatches, err := filepath.Glob(filepath.Join(sourceBase, "w-*"))
	if err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error finding w-* entries: %v\n", err)
		return
	}

	var wDirs []string
	for _, match := range wMatches {
		info, err := os.Stat(match)
		if err == nil && info.IsDir() {
			wDirs = append(wDirs, match)
		}
	}
	fmt.Fprintf(os.Stderr, "[Per-W] Found %d w-* directories to scan\n", len(wDirs))

	// Build index in parallel with 8 workers
	type indexEntry struct {
		template string
		variant  string
	}
	indexJobs := make(chan string, len(wDirs))
	indexResults := make(chan indexEntry, 100000) // Buffer for results
	var indexWg sync.WaitGroup

	scannedCount := 0
	var scannedMutex sync.Mutex

	// Launch workers to scan directories
	for w := 0; w < 8; w++ {
		indexWg.Add(1)
		go func(workerID int) {
			defer indexWg.Done()
			for wDir := range indexJobs {
				files, err := ioutil.ReadDir(wDir)
				if err != nil {
					continue
				}
				for _, file := range files {
					if file.IsDir() {
						continue
					}
					filename := file.Name()
					lastDash := strings.LastIndex(filename, "-")
					if lastDash > 0 && lastDash < len(filename)-1 {
						templateName := filename[lastDash+1:]
						variantPath := filepath.Join(wDir, filename)
						indexResults <- indexEntry{template: templateName, variant: variantPath}
					}
				}

				scannedMutex.Lock()
				scannedCount++
				if scannedCount%100 == 0 || scannedCount == len(wDirs) {
					fmt.Fprintf(os.Stderr, "[Per-W] Scanned %d/%d directories\n", scannedCount, len(wDirs))
				}
				scannedMutex.Unlock()
			}
		}(w)
	}

	// Send directories to workers
	for _, wDir := range wDirs {
		indexJobs <- wDir
	}
	close(indexJobs)

	// Close results channel when all workers are done
	go func() {
		indexWg.Wait()
		close(indexResults)
	}()

	// Collect results into index
	variantIndex := make(map[string][]string)
	for entry := range indexResults {
		variantIndex[entry.template] = append(variantIndex[entry.template], entry.variant)
	}

	fmt.Fprintf(os.Stderr, "[Per-W] Built index with %d templates having variants\n", len(variantIndex))

	// Create output directory
	fmt.Fprintf(os.Stderr, "[Per-W] Creating output directory pub/W...\n")
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
	fmt.Fprintf(os.Stderr, "[Per-W] Launching %d workers...\n", numWorkers)
	processedCount := 0
	var countMutex sync.Mutex
	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			fmt.Fprintf(os.Stderr, "[Per-W Worker %d] Started\n", workerID)
			jobCount := 0
			for templateFile := range jobs {
				jobCount++
				if jobCount == 1 || jobCount%100 == 0 {
					fmt.Fprintf(os.Stderr, "[Per-W Worker %d] Processing job %d: %s\n", workerID, jobCount, templateFile)
				}
				thumbnail := generatePerWPageWithIndex(sourceBase, templateFile, variantIndex)
				thumbnails <- thumbnail

				// Report progress every 1000 files
				countMutex.Lock()
				processedCount++
				if processedCount%1000 == 0 || processedCount == len(templateFiles) {
					fmt.Fprintf(os.Stderr, "[Per-W] Processed %d/%d templates\n", processedCount, len(templateFiles))
				}
				countMutex.Unlock()
			}
			fmt.Fprintf(os.Stderr, "[Per-W Worker %d] Finished processing %d jobs\n", workerID, jobCount)
		}(w)
	}

	// Send all template files to workers
	fmt.Fprintf(os.Stderr, "[Per-W] Sending %d template files to job queue...\n", len(templateFiles))
	for i, templateFile := range templateFiles {
		if i == 0 || i%1000 == 0 || i == len(templateFiles)-1 {
			fmt.Fprintf(os.Stderr, "[Per-W] Queued %d/%d files\n", i+1, len(templateFiles))
		}
		jobs <- templateFile
	}
	close(jobs)
	fmt.Fprintf(os.Stderr, "[Per-W] All template files queued, jobs channel closed\n")

	// Wait for all workers to finish
	fmt.Fprintf(os.Stderr, "[Per-W] Launching goroutine to wait for workers and close thumbnails channel...\n")
	go func() {
		fmt.Fprintf(os.Stderr, "[Per-W Closer] Waiting for workers to finish...\n")
		wg.Wait()
		fmt.Fprintf(os.Stderr, "[Per-W Closer] All workers done, closing thumbnails channel\n")
		close(thumbnails)
	}()

	// Collect thumbnails for master index
	fmt.Fprintf(os.Stderr, "[Per-W] Collecting thumbnails for master index...\n")
	var masterIndex strings.Builder
	collectedThumbnails := 0
	for thumbnail := range thumbnails {
		masterIndex.WriteString(thumbnail)
		masterIndex.WriteString("\n")
		collectedThumbnails++
		if collectedThumbnails%1000 == 0 {
			fmt.Fprintf(os.Stderr, "[Per-W] Collected %d/%d thumbnails\n", collectedThumbnails, len(templateFiles))
		}
	}
	fmt.Fprintf(os.Stderr, "[Per-W] Finished collecting %d thumbnails\n", collectedThumbnails)

	// Write master index file
	fmt.Fprintf(os.Stderr, "[Per-W] Writing pub/W.html with %d thumbnails...\n", collectedThumbnails)
	if err := ioutil.WriteFile("pub/W.html", []byte(masterIndex.String()), 0644); err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error writing pub/W.html: %v\n", err)
		return
	}

	fmt.Fprintf(os.Stderr, "[Per-W] Completed! Generated pub/W.html and %d detail pages\n", len(templateFiles))
}

// generatePerWPageWithIndex creates a detail page using pre-built variant index
// Returns the thumbnail HTML for the master index
func generatePerWPageWithIndex(sourceBase, templateFile string, variantIndex map[string][]string) string {
	// Look up variants from index instead of expensive Glob
	variants, ok := variantIndex[templateFile]
	if !ok || len(variants) == 0 {
		// No variants found for this template
		return ""
	}

	// Variants are already collected, just need to sort
	sortedVariants := make([]string, len(variants))
	copy(sortedVariants, variants)
	sort.Strings(sortedVariants)

	// Use sorted variants
	variants = sortedVariants

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

// scanDirectoryForImages scans a directory and returns a list of image files
// Supports PNG and JPEG files, extracts base filename without extension
func scanDirectoryForImages(dirPath string) ([]ImageInfo, error) {
	var imageInfos []ImageInfo

	err := filepath.Walk(dirPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Skip directories
		if info.IsDir() {
			return nil
		}

		// Check if file is an image (png, jpg, jpeg)
		ext := strings.ToLower(filepath.Ext(path))
		if ext != ".png" && ext != ".jpg" && ext != ".jpeg" {
			return nil
		}

		// Get relative path from dirPath
		relPath, err := filepath.Rel(dirPath, path)
		if err != nil {
			return err
		}

		// Extract base name without extension
		baseName := filepath.Base(relPath)
		baseName = strings.TrimSuffix(baseName, filepath.Ext(baseName))

		imageInfo := ImageInfo{
			Filename: baseName + ".png", // Normalize to .png extension
			Width:    0,
			Height:   0,
		}

		imageInfos = append(imageInfos, imageInfo)
		return nil
	})

	if err != nil {
		return nil, err
	}

	// Sort by filename for consistent ordering
	sort.Slice(imageInfos, func(i, j int) bool {
		return imageInfos[i].Filename < imageInfos[j].Filename
	})

	return imageInfos, nil
}

// processJSONWithFiltering reads a JSON file, extracts URLs, and filters images
// based on stage directories and thumbnail existence
func processJSONWithFiltering(jsonPath, stage1Dir, stage2Dir, thumbsDir string) ([]ImageInfo, error) {
	// Read JSON file
	data, err := ioutil.ReadFile(jsonPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read JSON file: %v", err)
	}

	// Parse JSON - expecting either array of objects or single object with .url field
	var jsonData interface{}
	if err := json.Unmarshal(data, &jsonData); err != nil {
		return nil, fmt.Errorf("failed to parse JSON: %v", err)
	}

	// Extract URLs from JSON
	urls := extractURLsFromJSON(jsonData)
	if len(urls) == 0 {
		return nil, fmt.Errorf("no URLs found in JSON file")
	}

	fmt.Fprintf(os.Stderr, "Extracted %d URLs from JSON\n", len(urls))

	// Extract image IDs from URLs (assuming format: .../image_id.ext)
	var allIDs []string
	for _, url := range urls {
		// Extract filename from URL path
		parts := strings.Split(url, "/")
		if len(parts) < 7 {
			continue
		}
		filename := parts[6] // Based on Justfile: cut -d/ -f7
		// Remove extension
		id := strings.TrimSuffix(filename, filepath.Ext(filename))
		if id != "" {
			allIDs = append(allIDs, id)
		}
	}

	// Remove duplicates and sort
	idMap := make(map[string]bool)
	for _, id := range allIDs {
		idMap[id] = true
	}
	allIDs = make([]string, 0, len(idMap))
	for id := range idMap {
		allIDs = append(allIDs, id)
	}
	sort.Strings(allIDs)

	fmt.Fprintf(os.Stderr, "Found %d unique image IDs\n", len(allIDs))

	// Filter images based on criteria:
	// - Must have thumbnail in thumbsDir
	// - Must NOT be in stage1Dir
	// - Must NOT be in stage2Dir
	var filtered []string
	for _, id := range allIDs {
		thumbPath := filepath.Join(thumbsDir, id+".png")
		stage1Path := filepath.Join(stage1Dir, id+".jpeg")
		stage2Path := filepath.Join(stage2Dir, id+".jpeg")

		// Check if thumbnail exists and has content
		if info, err := os.Stat(thumbPath); err != nil || info.Size() == 0 {
			continue
		}

		// Check if NOT in stage1
		if _, err := os.Stat(stage1Path); err == nil {
			continue
		}

		// Check if NOT in stage2
		if _, err := os.Stat(stage2Path); err == nil {
			continue
		}

		filtered = append(filtered, id)
	}

	fmt.Fprintf(os.Stderr, "Filtered to %d images (pending review)\n", len(filtered))

	// Convert to ImageInfo list
	var imageInfos []ImageInfo
	for _, id := range filtered {
		imageInfos = append(imageInfos, ImageInfo{
			Filename: id + ".png",
			Width:    0,
			Height:   0,
		})
	}

	return imageInfos, nil
}

// extractURLsFromJSON recursively extracts URLs from JSON data
func extractURLsFromJSON(data interface{}) []string {
	var urls []string

	switch v := data.(type) {
	case map[string]interface{}:
		// Check if this object has a "url" field
		if url, ok := v["url"].(string); ok {
			urls = append(urls, url)
		}
		// Recursively process all values
		for _, value := range v {
			urls = append(urls, extractURLsFromJSON(value)...)
		}
	case []interface{}:
		// Process each element in array
		for _, elem := range v {
			urls = append(urls, extractURLsFromJSON(elem)...)
		}
	}

	return urls
}

// generateIndexFile creates an HTML index file with links to all generated galleries
func generateIndexFile(indexPath string) error {
	// Find all generated gallery index.html files
	pattern := "tmp/g/js-username-*/*/index.html"
	matches, err := filepath.Glob(pattern)
	if err != nil {
		return fmt.Errorf("failed to glob galleries: %v", err)
	}

	if len(matches) == 0 {
		fmt.Fprintf(os.Stderr, "Warning: no galleries found matching %s\n", pattern)
		return nil
	}

	// Sort by modification time (most recent first)
	type fileWithTime struct {
		path    string
		modTime time.Time
	}
	var files []fileWithTime
	for _, match := range matches {
		info, err := os.Stat(match)
		if err != nil {
			continue
		}
		files = append(files, fileWithTime{match, info.ModTime()})
	}
	sort.Slice(files, func(i, j int) bool {
		return files[i].modTime.Before(files[j].modTime)
	})

	// Generate HTML content
	var content strings.Builder
	for _, f := range files {
		content.WriteString(fmt.Sprintf("<a href=\"%s\">%s</a><br>\n", f.path, f.path))
	}

	// Write to temporary file first, then rename (atomic)
	tmpPath := indexPath + ".tmp"
	if err := ioutil.WriteFile(tmpPath, []byte(content.String()), 0644); err != nil {
		return fmt.Errorf("failed to write index file: %v", err)
	}

	if err := os.Rename(tmpPath, indexPath); err != nil {
		os.Remove(tmpPath)
		return fmt.Errorf("failed to rename index file: %v", err)
	}

	fmt.Fprintf(os.Stderr, "Generated index with %d galleries\n", len(files))
	return nil
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

	// Convert imgDir to web-root-relative path (relative to /remote/cv/)
	// Since nginx serves from /remote/cv/, paths like "pub/fm/w-00" become "/pub/fm/w-00"
	webRootPath := imgDir
	if !strings.HasPrefix(webRootPath, "/") {
		webRootPath = "/" + webRootPath
	}

	// Format the template with proper values (no timestampCache)
	templateStr := fmt.Sprintf(galleryTemplate, totalChunks, chunkNum, webRootPath, clickMode)

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

// User download mode implementation
// ==================================

// downloadUsersMode reads a list of usernames and downloads their data from the API
func downloadUsersMode() {
	fmt.Fprintf(os.Stderr, "User mode: Downloading user data\n")

	// Load API URL from .env if not provided
	if apiURL == "" {
		var err error
		apiURL, err = loadAPIURLFromEnv()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error loading API URL from .env: %v\n", err)
			os.Exit(1)
		}
	}
	fmt.Fprintf(os.Stderr, "Using API URL: %s\n", apiURL)

	// Parse refresh users from command-line arguments
	refreshUsers := parseRefreshUsersFromArgs(flag.Args())

	var usernames []string
	var err error

	if len(refreshUsers) > 0 {
		// If refresh directories are provided, use those usernames
		fmt.Fprintf(os.Stderr, "Found %d users to refresh from command-line arguments\n", len(refreshUsers))
		for username := range refreshUsers {
			usernames = append(usernames, username)
		}
	} else {
		// Otherwise, read usernames from file
		if usersFile == "" {
			fmt.Fprintf(os.Stderr, "Error: -users-file required when no refresh directories are provided\n")
			os.Exit(1)
		}
		usernames, err = readUsernamesFromFile(usersFile)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error reading usernames file: %v\n", err)
			os.Exit(1)
		}
	}

	fmt.Fprintf(os.Stderr, "Found %d usernames to process\n", len(usernames))

	// Process each username
	skipped := 0
	processed := 0
	refreshed := 0
	for i, username := range usernames {
		// Check if user directory already exists
		prefix := "username-" + username
		userDir := filepath.Join("js-username", prefix)

		// Check if this user should be refreshed (forced re-download)
		// This is only true for users specified via CLI arguments, not from file
		shouldRefresh := refreshUsers[username]

		if _, err := os.Stat(userDir); err == nil && !shouldRefresh {
			fmt.Fprintf(os.Stderr, "\n[%d/%d] Skipping user: %s (already exists in js-username)\n", i+1, len(usernames), username)
			skipped++
			continue
		}

		if shouldRefresh {
			fmt.Fprintf(os.Stderr, "\n[%d/%d] Refreshing user: %s\n", i+1, len(usernames), username)
			refreshed++
		} else {
			fmt.Fprintf(os.Stderr, "\n[%d/%d] Processing user: %s\n", i+1, len(usernames), username)
		}

		if err := downloadUser(username); err != nil {
			fmt.Fprintf(os.Stderr, "Error downloading user %s: %v\n", username, err)
			continue
		}
		processed++
	}

	fmt.Fprintf(os.Stderr, "\nProcessed %d users (%d refreshed), skipped %d existing users\n", processed, refreshed, skipped)
}

// loadAPIURLFromEnv reads the url variable from .env file
func loadAPIURLFromEnv() (string, error) {
	envPath := ".env"
	file, err := os.Open(envPath)
	if err != nil {
		return "", fmt.Errorf("failed to open .env file: %w", err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if strings.HasPrefix(line, "url=") {
			return strings.TrimPrefix(line, "url="), nil
		}
	}

	if err := scanner.Err(); err != nil {
		return "", fmt.Errorf("error reading .env file: %w", err)
	}

	return "", fmt.Errorf("url not found in .env file")
}

// readUsernamesFromFile reads a list of usernames from a text file (one per line)
func readUsernamesFromFile(filename string) ([]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to open usernames file: %w", err)
	}
	defer file.Close()

	var usernames []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line != "" && !strings.HasPrefix(line, "#") {
			usernames = append(usernames, line)
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("error reading usernames file: %w", err)
	}

	return usernames, nil
}

// readImageIDsFromFile reads a list of image IDs from a text file (one per line)
// Image IDs are appended with .png extension to create paths in thumbs/ directory
func readImageIDsFromFile(filename string, thumbsDir string) ([]ImageInfo, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to open image IDs file: %w", err)
	}
	defer file.Close()

	var imageInfos []ImageInfo
	var missingThumbs []string
	totalIDs := 0

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line != "" && !strings.HasPrefix(line, "#") {
			totalIDs++
			// Convert image ID to filename with .png extension
			imageFilename := line + ".png"

			// Check if thumbnail exists
			thumbPath := filepath.Join(thumbsDir, imageFilename)
			if _, err := os.Stat(thumbPath); os.IsNotExist(err) {
				missingThumbs = append(missingThumbs, line)
				continue
			}

			imageInfos = append(imageInfos, ImageInfo{
				Filename: imageFilename,
			})
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("error reading image IDs file: %w", err)
	}

	// Report missing thumbnails
	if len(missingThumbs) > 0 {
		fmt.Fprintf(os.Stderr, "Warning: %d of %d thumbnails missing in %s/\n", len(missingThumbs), totalIDs, thumbsDir)
		if len(missingThumbs) <= 10 {
			fmt.Fprintf(os.Stderr, "Missing thumbnails:\n")
			for _, id := range missingThumbs {
				fmt.Fprintf(os.Stderr, "  %s.png\n", id)
			}
		} else {
			fmt.Fprintf(os.Stderr, "First 10 missing thumbnails:\n")
			for i := 0; i < 10; i++ {
				fmt.Fprintf(os.Stderr, "  %s.png\n", missingThumbs[i])
			}
		}
	}

	return imageInfos, nil
}

// parseRefreshUsersFromArgs parses command-line arguments as user directories
// Expects paths in the form: js-username/username-{username}
func parseRefreshUsersFromArgs(args []string) map[string]bool {
	refreshUsers := make(map[string]bool)

	for _, arg := range args {
		// Remove trailing slash if present
		arg = strings.TrimSuffix(arg, "/")

		// Get the directory name (last part of path)
		dirName := filepath.Base(arg)

		// Extract username from "username-{username}" format
		if strings.HasPrefix(dirName, "username-") {
			username := strings.TrimPrefix(dirName, "username-")
			refreshUsers[username] = true
		}
	}

	return refreshUsers
}

// downloadUser downloads all data for a single user from the API
func downloadUser(username string) error {
	prefix := "username-" + username
	userDir := filepath.Join("js-username", prefix)
	jsDir := filepath.Join(userDir, "js")

	// Create directory structure
	if err := os.MkdirAll(jsDir, 0755); err != nil {
		return fmt.Errorf("failed to create directory %s: %w", jsDir, err)
	}

	// Download for both NSFW true and false
	nsfwValues := []string{"true", "false"}
	allItems := make(map[string]interface{})

	for _, nsfw := range nsfwValues {
		fmt.Fprintf(os.Stderr, "  Downloading with nsfw=%s...\n", nsfw)

		page := startPage
		for page <= pageLimit {
			outputFile := filepath.Join(jsDir, fmt.Sprintf("%s-%s-%d.json", prefix, nsfw, page-1))

			// Check if file already exists
			if _, err := os.Stat(outputFile); err == nil {
				fmt.Fprintf(os.Stderr, "    Page %d already exists, loading from cache\n", page-1)
				data, err := ioutil.ReadFile(outputFile)
				if err != nil {
					return fmt.Errorf("failed to read cached file: %w", err)
				}

				var pageData map[string]interface{}
				if err := json.Unmarshal(data, &pageData); err != nil {
					return fmt.Errorf("failed to parse cached JSON: %w", err)
				}

				// Collect items from this page
				if items, ok := pageData["items"].([]interface{}); ok {
					for _, item := range items {
						if itemMap, ok := item.(map[string]interface{}); ok {
							if id, ok := itemMap["id"]; ok {
								allItems[fmt.Sprintf("%v", id)] = item
							}
						}
					}
				}

				// Check for next page
				metadata, ok := pageData["metadata"].(map[string]interface{})
				if !ok {
					break
				}
				nextPage, ok := metadata["nextPage"].(string)
				if !ok || nextPage == "" || nextPage == "null" {
					break
				}

				page++
				continue
			}

			// Download the page
			var url string
			if page == startPage {
				url = fmt.Sprintf("%s/api/v1/images?nsfw=%s&username=%s", apiURL, nsfw, username)
			} else {
				// Need to construct URL from previous page's nextPage
				prevFile := filepath.Join(jsDir, fmt.Sprintf("%s-%s-%d.json", prefix, nsfw, page-2))
				data, err := ioutil.ReadFile(prevFile)
				if err != nil {
					return fmt.Errorf("failed to read previous page: %w", err)
				}

				var prevData map[string]interface{}
				if err := json.Unmarshal(data, &prevData); err != nil {
					return fmt.Errorf("failed to parse previous JSON: %w", err)
				}

				metadata, ok := prevData["metadata"].(map[string]interface{})
				if !ok {
					break
				}
				nextPage, ok := metadata["nextPage"].(string)
				if !ok || nextPage == "" || nextPage == "null" {
					break
				}
				url = nextPage
			}

			fmt.Fprintf(os.Stderr, "    Downloading page %d...\n", page-1)
			resp, err := http.Get(url)
			if err != nil {
				return fmt.Errorf("failed to download page %d: %w", page-1, err)
			}
			defer resp.Body.Close()

			body, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				return fmt.Errorf("failed to read response: %w", err)
			}

			// Save raw response
			if err := ioutil.WriteFile(outputFile, body, 0644); err != nil {
				return fmt.Errorf("failed to write output file: %w", err)
			}

			// Parse the response
			var pageData map[string]interface{}
			if err := json.Unmarshal(body, &pageData); err != nil {
				return fmt.Errorf("failed to parse JSON: %w", err)
			}

			// Collect items from this page
			if items, ok := pageData["items"].([]interface{}); ok {
				for _, item := range items {
					if itemMap, ok := item.(map[string]interface{}); ok {
						if id, ok := itemMap["id"]; ok {
							allItems[fmt.Sprintf("%v", id)] = item
						}
					}
				}
			}

			// Check if there's a next page
			metadata, ok := pageData["metadata"].(map[string]interface{})
			if !ok {
				break
			}
			nextPage, ok := metadata["nextPage"].(string)
			if !ok || nextPage == "" || nextPage == "null" {
				break
			}

			page++
		}
	}

	// Create aggregated output
	aggregatedFile := filepath.Join(userDir, fmt.Sprintf("js-%s.json", prefix))
	aggregatedData, err := json.MarshalIndent(allItems, "", "  ")
	if err != nil {
		return fmt.Errorf("failed to marshal aggregated data: %w", err)
	}

	if err := ioutil.WriteFile(aggregatedFile, aggregatedData, 0644); err != nil {
		return fmt.Errorf("failed to write aggregated file: %w", err)
	}

	// Create .js.json file (array of items)
	jsFile := filepath.Join(userDir, fmt.Sprintf("js-%s.json.js.json", prefix))
	var itemsArray []interface{}
	for _, item := range allItems {
		itemsArray = append(itemsArray, item)
	}

	jsData, err := json.MarshalIndent(itemsArray, "", "  ")
	if err != nil {
		return fmt.Errorf("failed to marshal js data: %w", err)
	}

	if err := ioutil.WriteFile(jsFile, jsData, 0644); err != nil {
		return fmt.Errorf("failed to write js file: %w", err)
	}

	fmt.Fprintf(os.Stderr, "  Downloaded %d unique items for user %s\n", len(allItems), username)
	return nil
}

// Download mode implementation
// =============================

// downloadMode downloads images and generates thumbnails from aggregated user data
func downloadMode() {
	fmt.Fprintf(os.Stderr, "Download mode: Downloading images and generating thumbnails\n")

	// Find all aggregated user JSON files
	pattern := "js-username/username-*/js-username-*.json.js.json"
	matches, err := filepath.Glob(pattern)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error finding user JSON files: %v\n", err)
		os.Exit(1)
	}

	if len(matches) == 0 {
		fmt.Fprintf(os.Stderr, "No user JSON files found matching pattern: %s\n", pattern)
		os.Exit(0)
	}

	fmt.Fprintf(os.Stderr, "Found %d user JSON files to process\n", len(matches))

	// Collect all URLs from all user files
	urlSet := make(map[string]bool)
	for _, jsonFile := range matches {
		urls, err := extractURLsFromFile(jsonFile)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error extracting URLs from %s: %v\n", jsonFile, err)
			continue
		}
		for _, url := range urls {
			urlSet[url] = true
		}
	}

	// Convert to sorted slice
	var urls []string
	for url := range urlSet {
		urls = append(urls, url)
	}
	sort.Strings(urls)

	fmt.Fprintf(os.Stderr, "Found %d unique URLs to download\n", len(urls))

	// Create img directory to check for existing files
	if err := os.MkdirAll("img", 0755); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating img directory: %v\n", err)
		os.Exit(1)
	}

	// Filter out URLs that already have files (including 0-byte marker files)
	var urlsToDownload []string
	alreadyDownloaded := 0
	for _, url := range urls {
		// Extract filename from URL
		parts := strings.Split(url, "/")
		if len(parts) < 2 {
			continue
		}
		filename := parts[len(parts)-1]
		outputPath := filepath.Join("img", filename)

		// Check if file exists (any size, including 0-byte markers)
		if _, err := os.Stat(outputPath); err == nil {
			alreadyDownloaded++
			continue
		}

		// Need to download this URL
		urlsToDownload = append(urlsToDownload, url)
	}

	fmt.Fprintf(os.Stderr, "Already downloaded: %d files\n", alreadyDownloaded)
	fmt.Fprintf(os.Stderr, "Need to download: %d files\n", len(urlsToDownload))

	// Create state directory
	if err := os.MkdirAll("state", 0755); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating state directory: %v\n", err)
		os.Exit(1)
	}

	// Write URLs to state/downloads.txt
	outputFile := "state/downloads.txt"
	f, err := os.Create(outputFile)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating %s: %v\n", outputFile, err)
		os.Exit(1)
	}
	defer f.Close()

	for _, url := range urlsToDownload {
		fmt.Fprintf(f, "%s\n", url)
	}

	fmt.Fprintf(os.Stderr, "Wrote %d URLs to %s\n", len(urlsToDownload), outputFile)
	fmt.Fprintf(os.Stderr, "Download mode complete - URLs written, no downloads performed\n")
}

// todoMode generates a list of uncurated images (not in yes/ or no/)
func todoMode() {
	fmt.Fprintf(os.Stderr, "Todo mode: Finding uncurated images\n")

	// Create state directory
	if err := os.MkdirAll("state", 0755); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating state directory: %v\n", err)
		os.Exit(1)
	}

	// Resolve symlinks for directories
	imgDir, err := filepath.EvalSymlinks("img")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error resolving img/ symlink: %v\n", err)
		os.Exit(1)
	}

	yesDir, err := filepath.EvalSymlinks("yes")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error resolving yes/ symlink: %v\n", err)
		os.Exit(1)
	}

	noDir, err := filepath.EvalSymlinks("no")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error resolving no/ symlink: %v\n", err)
		os.Exit(1)
	}

	// Scan all three directories in parallel
	fmt.Fprintf(os.Stderr, "Scanning yes/, no/, and img/ directories in parallel...\n")

	yesFiles := make(map[string]bool)
	noFiles := make(map[string]bool)
	var imgEntries []os.DirEntry

	var wg sync.WaitGroup
	errChan := make(chan error, 3)

	// Scan yes/ directory
	wg.Add(1)
	go func() {
		defer wg.Done()
		count := 0
		entries, err := os.ReadDir(yesDir)
		if err != nil {
			errChan <- fmt.Errorf("yes/ directory: %w", err)
			return
		}
		for _, entry := range entries {
			if !entry.IsDir() {
				// Extract filename without extension
				filename := entry.Name()
				ext := filepath.Ext(filename)
				nameWithoutExt := strings.TrimSuffix(filename, ext)
				yesFiles[nameWithoutExt] = true
				count++
			}
		}
		fmt.Fprintf(os.Stderr, "Found %d files in yes/\n", count)
	}()

	// Scan no/ directory
	wg.Add(1)
	go func() {
		defer wg.Done()
		count := 0
		entries, err := os.ReadDir(noDir)
		if err != nil {
			errChan <- fmt.Errorf("no/ directory: %w", err)
			return
		}
		for _, entry := range entries {
			if !entry.IsDir() {
				// Extract filename without extension
				filename := entry.Name()
				ext := filepath.Ext(filename)
				nameWithoutExt := strings.TrimSuffix(filename, ext)
				noFiles[nameWithoutExt] = true
				count++
			}
		}
		fmt.Fprintf(os.Stderr, "Found %d files in no/\n", count)
	}()

	// Scan img/ directory (just read entries, don't stat yet)
	wg.Add(1)
	go func() {
		defer wg.Done()
		entries, err := os.ReadDir(imgDir)
		if err != nil {
			errChan <- fmt.Errorf("img/ directory: %w", err)
			return
		}
		imgEntries = entries
		fmt.Fprintf(os.Stderr, "Found %d entries in img/\n", len(imgEntries))
	}()

	// Wait for all directories to complete
	wg.Wait()
	close(errChan)

	// Check for errors
	for err := range errChan {
		fmt.Fprintf(os.Stderr, "Error scanning directory: %v\n", err)
		os.Exit(1)
	}

	// Now filter img/ entries and stat only non-curated files
	fmt.Fprintf(os.Stderr, "Filtering and checking img/ files...\n")

	var uncurated []string
	totalFiles := 0
	skippedCurated := 0
	skippedZeroBytes := 0

	for _, entry := range imgEntries {
		if !entry.IsDir() {
			totalFiles++
			// Extract filename without extension
			filename := entry.Name()
			ext := filepath.Ext(filename)
			nameWithoutExt := strings.TrimSuffix(filename, ext)

			// Skip if already in yes/ or no/
			if yesFiles[nameWithoutExt] || noFiles[nameWithoutExt] {
				skippedCurated++
				continue
			}

			// Only stat files that passed the filter
			info, err := entry.Info()
			if err != nil {
				continue
			}

			// Skip 0-byte files (markers for "not valuable")
			if info.Size() == 0 {
				skippedZeroBytes++
				continue
			}

			// This is an uncurated file
			uncurated = append(uncurated, nameWithoutExt)
		}
	}

	fmt.Fprintf(os.Stderr, "Found %d total files in img/\n", totalFiles)
	fmt.Fprintf(os.Stderr, "Skipped %d already curated files\n", skippedCurated)
	fmt.Fprintf(os.Stderr, "Skipped %d zero-byte marker files\n", skippedZeroBytes)
	fmt.Fprintf(os.Stderr, "Found %d uncurated files\n", len(uncurated))

	// Sort the list
	sort.Strings(uncurated)

	// Write to state/todo.txt
	outputFile := "state/todo.txt"
	f, err := os.Create(outputFile)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating %s: %v\n", outputFile, err)
		os.Exit(1)
	}
	defer f.Close()

	for _, name := range uncurated {
		fmt.Fprintf(f, "%s\n", name)
	}

	fmt.Fprintf(os.Stderr, "Wrote %d filenames to %s\n", len(uncurated), outputFile)
	fmt.Fprintf(os.Stderr, "Todo mode complete\n")
}

// fixupMode creates no/ entries for zero-length image files and truncates mp4 files
func fixupMode() {
	fmt.Fprintf(os.Stderr, "Fixup mode: Processing image files in img/\n")

	// Resolve symlinks for directories
	imgDir, err := filepath.EvalSymlinks("img")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error resolving img/ symlink: %v\n", err)
		os.Exit(1)
	}

	noDir, err := filepath.EvalSymlinks("no")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error resolving no/ symlink: %v\n", err)
		os.Exit(1)
	}

	// Run no/ directory scan and find operations in parallel
	fmt.Fprintf(os.Stderr, "Scanning no/ and finding image files in parallel...\n")

	var wg sync.WaitGroup
	noFiles := make(map[string]bool)
	var zeroLengthJpegPaths []string
	var zeroLengthPngPaths []string
	var zeroLengthThumbsPaths []string
	var allMp4Paths []string
	var findJpegErr, findPngErr, findThumbsErr, findMp4Err, noErr error

	// Scan no/ directory
	wg.Add(1)
	go func() {
		defer wg.Done()
		noEntries, err := os.ReadDir(noDir)
		if err != nil {
			noErr = err
			return
		}
		for _, entry := range noEntries {
			if !entry.IsDir() {
				filename := entry.Name()
				ext := filepath.Ext(filename)
				nameWithoutExt := strings.TrimSuffix(filename, ext)
				noFiles[nameWithoutExt] = true
			}
		}
		fmt.Fprintf(os.Stderr, "Found %d existing files in no/\n", len(noFiles))
	}()

	// Find zero-length .jpeg files
	wg.Add(1)
	go func() {
		defer wg.Done()
		cmd := exec.Command("find", "img/", "-name", "*.jpeg", "-size", "0")
		output, err := cmd.Output()
		if err != nil {
			findJpegErr = err
			return
		}
		zeroLengthJpegPaths = strings.Split(strings.TrimSpace(string(output)), "\n")
		if len(zeroLengthJpegPaths) == 1 && zeroLengthJpegPaths[0] == "" {
			zeroLengthJpegPaths = nil
		}
		fmt.Fprintf(os.Stderr, "Found %d zero-length .jpeg files\n", len(zeroLengthJpegPaths))
	}()

	// Find zero-length .png files in img/
	wg.Add(1)
	go func() {
		defer wg.Done()
		cmd := exec.Command("find", "img/", "-name", "*.png", "-size", "0")
		output, err := cmd.Output()
		if err != nil {
			findPngErr = err
			return
		}
		zeroLengthPngPaths = strings.Split(strings.TrimSpace(string(output)), "\n")
		if len(zeroLengthPngPaths) == 1 && zeroLengthPngPaths[0] == "" {
			zeroLengthPngPaths = nil
		}
		fmt.Fprintf(os.Stderr, "Found %d zero-length .png files in img/\n", len(zeroLengthPngPaths))
	}()

	// Find zero-length .png files in thumbs/
	wg.Add(1)
	go func() {
		defer wg.Done()
		cmd := exec.Command("find", "thumbs/", "-name", "*.png", "-size", "0")
		output, err := cmd.Output()
		if err != nil {
			findThumbsErr = err
			return
		}
		zeroLengthThumbsPaths = strings.Split(strings.TrimSpace(string(output)), "\n")
		if len(zeroLengthThumbsPaths) == 1 && zeroLengthThumbsPaths[0] == "" {
			zeroLengthThumbsPaths = nil
		}
		fmt.Fprintf(os.Stderr, "Found %d zero-length .png files in thumbs/\n", len(zeroLengthThumbsPaths))
	}()

	// Find ALL .mp4 files
	wg.Add(1)
	go func() {
		defer wg.Done()
		cmd := exec.Command("find", "img/", "-name", "*.mp4")
		output, err := cmd.Output()
		if err != nil {
			findMp4Err = err
			return
		}
		allMp4Paths = strings.Split(strings.TrimSpace(string(output)), "\n")
		if len(allMp4Paths) == 1 && allMp4Paths[0] == "" {
			allMp4Paths = nil
		}
		fmt.Fprintf(os.Stderr, "Found %d .mp4 files\n", len(allMp4Paths))
	}()

	// Wait for all operations to complete
	wg.Wait()

	// Check for errors
	if noErr != nil {
		fmt.Fprintf(os.Stderr, "Error scanning no/ directory: %v\n", noErr)
		os.Exit(1)
	}
	if findJpegErr != nil {
		fmt.Fprintf(os.Stderr, "Error finding .jpeg files: %v\n", findJpegErr)
		os.Exit(1)
	}
	if findPngErr != nil {
		fmt.Fprintf(os.Stderr, "Error finding .png files in img/: %v\n", findPngErr)
		os.Exit(1)
	}
	if findThumbsErr != nil {
		fmt.Fprintf(os.Stderr, "Error finding .png files in thumbs/: %v\n", findThumbsErr)
		os.Exit(1)
	}
	if findMp4Err != nil {
		fmt.Fprintf(os.Stderr, "Error finding .mp4 files: %v\n", findMp4Err)
		os.Exit(1)
	}

	// Process mp4 files: truncate to zero length if needed
	fmt.Fprintf(os.Stderr, "Processing .mp4 files (truncating to zero length)...\n")
	mp4Truncated := 0
	mp4AlreadyZero := 0

	for _, path := range allMp4Paths {
		if path == "" {
			continue
		}

		// Get file info
		info, err := os.Stat(path)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error stat %s: %v\n", path, err)
			continue
		}

		// Truncate if not already zero length
		if info.Size() > 0 {
			fullPath := filepath.Join(imgDir, filepath.Base(path))
			if err := os.Truncate(fullPath, 0); err != nil {
				fmt.Fprintf(os.Stderr, "Error truncating %s: %v\n", fullPath, err)
				continue
			}
			mp4Truncated++
		} else {
			mp4AlreadyZero++
		}
	}

	fmt.Fprintf(os.Stderr, "Truncated %d .mp4 files, %d already zero-length\n", mp4Truncated, mp4AlreadyZero)

	// Combine all paths that need no/ entries
	var allPaths []string
	allPaths = append(allPaths, zeroLengthJpegPaths...)
	allPaths = append(allPaths, zeroLengthPngPaths...)
	allPaths = append(allPaths, zeroLengthThumbsPaths...)
	allPaths = append(allPaths, allMp4Paths...)

	// Create no/ entries
	fmt.Fprintf(os.Stderr, "Creating no/ entries...\n")
	alreadyExists := 0
	created := 0

	for _, path := range allPaths {
		if path == "" {
			continue
		}

		// Extract filename without extension
		filename := filepath.Base(path)
		ext := filepath.Ext(filename)
		nameWithoutExt := strings.TrimSuffix(filename, ext)

		// Check if already exists in no/
		if noFiles[nameWithoutExt] {
			alreadyExists++
			continue
		}

		// Create corresponding .png file in no/
		noPath := filepath.Join(noDir, nameWithoutExt+".png")
		f, err := os.Create(noPath)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error creating %s: %v\n", noPath, err)
			continue
		}
		f.Close()
		created++

		if created%1000 == 0 {
			fmt.Fprintf(os.Stderr, "Created %d no/ entries...\n", created)
		}
	}

	fmt.Fprintf(os.Stderr, "Skipped %d files (already exist in no/)\n", alreadyExists)
	fmt.Fprintf(os.Stderr, "Created %d new no/ entries\n", created)
	fmt.Fprintf(os.Stderr, "Fixup mode complete\n")
}

// extractURLsFromFile reads a JSON file and extracts all .url fields
func extractURLsFromFile(filename string) ([]string, error) {
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to read file: %w", err)
	}

	// Parse as array of objects
	var items []map[string]interface{}
	if err := json.Unmarshal(data, &items); err != nil {
		return nil, fmt.Errorf("failed to parse JSON: %w", err)
	}

	var urls []string
	for _, item := range items {
		if url, ok := item["url"].(string); ok && url != "" {
			urls = append(urls, url)
		}
	}

	return urls, nil
}

// SelfRateLimiter enforces our own rate limit to avoid hitting server limits
type SelfRateLimiter struct {
	mu             sync.Mutex
	downloadTimes  []time.Time
	maxDownloads   int
	windowDuration time.Duration
}

func newSelfRateLimiter(maxDownloads int, windowSeconds int) *SelfRateLimiter {
	return &SelfRateLimiter{
		downloadTimes:  make([]time.Time, 0, maxDownloads),
		maxDownloads:   maxDownloads,
		windowDuration: time.Duration(windowSeconds) * time.Second,
	}
}

func (srl *SelfRateLimiter) checkAndWait() {
	srl.mu.Lock()
	defer srl.mu.Unlock()

	now := time.Now()

	// Remove download times outside the window
	cutoff := now.Add(-srl.windowDuration)
	validTimes := make([]time.Time, 0, srl.maxDownloads)
	for _, t := range srl.downloadTimes {
		if t.After(cutoff) {
			validTimes = append(validTimes, t)
		}
	}
	srl.downloadTimes = validTimes

	// If we've hit the limit, wait until the oldest download falls outside the window
	if len(srl.downloadTimes) >= srl.maxDownloads {
		oldestTime := srl.downloadTimes[0]
		waitUntil := oldestTime.Add(srl.windowDuration)
		sleepDuration := time.Until(waitUntil)
		if sleepDuration > 0 {
			fmt.Fprintf(os.Stderr, "⏱️  Self rate limit: %d downloads in %s window. Sleeping %s\n",
				len(srl.downloadTimes), srl.windowDuration, sleepDuration.Round(time.Millisecond))
			srl.mu.Unlock()
			time.Sleep(sleepDuration)
			srl.mu.Lock()
			// After sleeping, remove the old download time
			srl.downloadTimes = srl.downloadTimes[1:]
		}
	}
}

func (srl *SelfRateLimiter) recordDownload() {
	srl.mu.Lock()
	defer srl.mu.Unlock()

	srl.downloadTimes = append(srl.downloadTimes, time.Now())
}

// RateLimiter manages adaptive concurrency control for downloads
type RateLimiter struct {
	maxConcurrency   int
	currentSemaphore chan struct{}
	mu               sync.Mutex
	rateLimited      bool
	successCount     int
	lastAdjust       time.Time
	pauseMu          sync.Mutex // Separate mutex for pause state
	paused           bool       // When true, all workers pause
	pauseCond        *sync.Cond // Used to wake workers when unpause
	globalRetries    int        // Global retry counter for exponential backoff
}

func newRateLimiter(maxConcurrency int) *RateLimiter {
	rl := &RateLimiter{
		maxConcurrency:   maxConcurrency,
		currentSemaphore: make(chan struct{}, maxConcurrency),
		lastAdjust:       time.Now(),
		rateLimited:      true, // Start in rate-limited mode
		successCount:     0,
		paused:           false,
	}
	rl.pauseCond = sync.NewCond(&rl.pauseMu)
	// Start with only 1 concurrent download
	rl.currentSemaphore <- struct{}{}
	fmt.Fprintf(os.Stderr, "Starting with 1 concurrent download (will ramp up to %d)\n", maxConcurrency)
	return rl
}

func (rl *RateLimiter) acquire() {
	// Check if paused (wait if so)
	rl.pauseCond.L.Lock()
	for rl.paused {
		rl.pauseCond.Wait()
	}
	rl.pauseCond.L.Unlock()

	<-rl.currentSemaphore
}

func (rl *RateLimiter) release() {
	rl.currentSemaphore <- struct{}{}
}

func (rl *RateLimiter) pauseAll() {
	rl.pauseCond.L.Lock()
	rl.paused = true
	rl.pauseCond.L.Unlock()
}

func (rl *RateLimiter) unpauseAll() {
	rl.pauseCond.L.Lock()
	rl.paused = false
	rl.pauseCond.Broadcast() // Wake all waiting workers
	rl.pauseCond.L.Unlock()
}

func (rl *RateLimiter) handleRateLimit() int {
	rl.mu.Lock()

	// Increment global retry counter
	rl.globalRetries++
	currentRetries := rl.globalRetries

	if !rl.rateLimited {
		rl.rateLimited = true
		rl.successCount = 0

		// Reduce to 1 concurrent download
		currentCap := cap(rl.currentSemaphore)
		newSemaphore := make(chan struct{}, rl.maxConcurrency)

		// Transfer one token to new semaphore
		newSemaphore <- struct{}{}

		rl.currentSemaphore = newSemaphore
		rl.lastAdjust = time.Now()

		fmt.Fprintf(os.Stderr, "\n⚠️  Rate limit detected! Pausing all workers, reducing to 1 concurrent (was %d)\n", currentCap)
	}

	// Calculate exponential backoff based on global retries
	backoffSeconds := 1 << uint(currentRetries-1)
	if backoffSeconds > 180 {
		backoffSeconds = 180
	}

	rl.mu.Unlock()

	// Pause all other workers
	rl.pauseAll()

	// Apply backoff before resuming
	waitTime := time.Duration(backoffSeconds) * time.Second
	fmt.Fprintf(os.Stderr, "⏸️  Backing off for %s before retry (attempt %d)\n", waitTime, currentRetries)
	time.Sleep(waitTime)

	// Unpause workers after backoff
	rl.unpauseAll()

	return currentRetries
}

func (rl *RateLimiter) recordSuccess() {
	rl.mu.Lock()
	defer rl.mu.Unlock()

	// Reset global retry counter on success
	rl.globalRetries = 0

	// Ensure not paused
	rl.unpauseAll()

	if !rl.rateLimited {
		return
	}

	rl.successCount++

	// After 10 successful downloads, increase concurrency by 1
	if rl.successCount >= 10 && time.Since(rl.lastAdjust) > 5*time.Second {
		currentCap := cap(rl.currentSemaphore)

		if currentCap < rl.maxConcurrency {
			newCap := currentCap + 1
			newSemaphore := make(chan struct{}, rl.maxConcurrency)

			// Transfer tokens to new semaphore
			for i := 0; i < newCap; i++ {
				select {
				case <-rl.currentSemaphore:
					newSemaphore <- struct{}{}
				default:
					newSemaphore <- struct{}{}
				}
			}

			rl.currentSemaphore = newSemaphore
			rl.successCount = 0
			rl.lastAdjust = time.Now()

			fmt.Fprintf(os.Stderr, "✓ Increasing concurrency to %d\n", newCap)

			if newCap >= rl.maxConcurrency {
				rl.rateLimited = false
				fmt.Fprintf(os.Stderr, "✓ Recovered to full speed (%d concurrent)\n", newCap)
			}
		}
	}
}

// URLRetry tracks retry attempts for a URL
type URLRetry struct {
	url     string
	retries int
}

// downloadImages downloads images using Go HTTP client with adaptive rate limiting
func downloadImages(urls []string) {
	var wg sync.WaitGroup
	urlChan := make(chan URLRetry, len(urls)*2) // Buffer for retries
	rateLimiter := newRateLimiter(downloadWorkers)
	selfRateLimiter := newSelfRateLimiter(10, 10) // 10 downloads per 10 seconds

	fmt.Fprintf(os.Stderr, "Self-imposed rate limit: 10 downloads per 10 seconds\n")

	// Track progress with detailed counters
	var downloaded, skipped, rateLimited, errors int
	var processed int // Total processed (not including retries)
	var progressMutex sync.Mutex
	startTime := time.Now()

	// Track pending URLs
	var pending int32
	atomic.StoreInt32(&pending, int32(len(urls)))

	// Create HTTP client with timeout
	client := &http.Client{
		Timeout: 60 * time.Second,
		Transport: &http.Transport{
			MaxIdleConns:        100,
			MaxIdleConnsPerHost: 20,
			IdleConnTimeout:     90 * time.Second,
		},
	}

	// Launch progress reporter
	stopReporter := make(chan bool)
	go func() {
		ticker := time.NewTicker(10 * time.Second)
		defer ticker.Stop()
		for {
			select {
			case <-ticker.C:
				progressMutex.Lock()
				elapsed := time.Since(startTime)
				rate := float64(processed) / elapsed.Seconds()
				fmt.Fprintf(os.Stderr, "[Progress] Total: %d | Downloaded: %d | Already on disk: %d | Rate limited (429): %d | Errors: %d | Rate: %.1f/sec\n",
					processed, downloaded, skipped, rateLimited, errors, rate)
				progressMutex.Unlock()
			case <-stopReporter:
				return
			}
		}
	}()

	// Launch workers
	for w := 0; w < downloadWorkers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			for urlRetry := range urlChan {
				// Keep retrying this URL until success or non-429 error
				for {
					// Acquire semaphore slot
					rateLimiter.acquire()

					// Enforce self-imposed rate limit before download
					selfRateLimiter.checkAndWait()

					// Download this URL
					err := downloadSingleImage(client, urlRetry.url)

					// Release semaphore slot
					rateLimiter.release()

					if err != nil {
						if strings.Contains(err.Error(), "429") || strings.Contains(err.Error(), "rate limit") {
							// Rate limited - retry the same URL with backoff
							// Since rate limit applies to entire host, other URLs will fail too

							progressMutex.Lock()
							rateLimited++
							progressMutex.Unlock()

							// Display URL for manual testing
							fmt.Fprintf(os.Stderr, "[Worker %d] 429 Rate limit on: %s\n", workerID, urlRetry.url)

							// Use global retry counter and handle rate limit
							rateLimiter.handleRateLimit()

							// Continue inner loop to retry the SAME URL
							continue
						} else if strings.Contains(err.Error(), "already exists") {
							progressMutex.Lock()
							skipped++
							processed++
							progressMutex.Unlock()
							break
						} else {
							progressMutex.Lock()
							errors++
							processed++
							if errors <= 10 {
								fmt.Fprintf(os.Stderr, "[Worker %d] Error downloading %s: %v\n", workerID, urlRetry.url, err)
							}
							progressMutex.Unlock()
							break
						}
					} else {
						// Successfully downloaded - record for self rate limiting
						selfRateLimiter.recordDownload()

						rateLimiter.recordSuccess()
						progressMutex.Lock()
						downloaded++
						processed++
						progressMutex.Unlock()
						break
					}
				}

				// Mark this URL as complete (decrement pending)
				remaining := atomic.AddInt32(&pending, -1)
				if remaining == 0 {
					// All URLs processed, close channel
					close(urlChan)
					return
				}
			}
		}(w)
	}

	// Send URLs to workers
	for _, url := range urls {
		urlChan <- URLRetry{url: url, retries: 0}
	}

	wg.Wait()
	close(stopReporter)

	elapsed := time.Since(startTime)
	rate := float64(processed) / elapsed.Seconds()
	fmt.Fprintf(os.Stderr, "\n=== Download Complete ===\n")
	fmt.Fprintf(os.Stderr, "Total URLs processed: %d\n", processed)
	fmt.Fprintf(os.Stderr, "  - Downloaded: %d\n", downloaded)
	fmt.Fprintf(os.Stderr, "  - Already on disk: %d\n", skipped)
	fmt.Fprintf(os.Stderr, "  - Rate limited (429): %d\n", rateLimited)
	fmt.Fprintf(os.Stderr, "  - Errors: %d\n", errors)
	fmt.Fprintf(os.Stderr, "Time: %s | Rate: %.1f images/sec\n", elapsed.Round(time.Second), rate)
}

// downloadSingleImage downloads a single image from URL to img/ directory using curl
func downloadSingleImage(client *http.Client, url string) error {
	// Extract filename from URL
	parts := strings.Split(url, "/")
	if len(parts) < 2 {
		return fmt.Errorf("invalid URL format: %s", url)
	}
	filename := parts[len(parts)-1]
	outputPath := filepath.Join("img", filename)

	// Check if file already exists (including 0-byte marker files)
	if _, err := os.Stat(outputPath); err == nil {
		return fmt.Errorf("file already exists: %s", filename)
	}

	// Create temporary file path
	tmpPath := outputPath + ".tmp"

	// Use curl to download with browser-like headers
	cmd := exec.Command("curl",
		"-s",                 // silent
		"-L",                 // follow redirects
		"-w", "%{http_code}", // write HTTP status code
		"-o", tmpPath, // output to temp file
		"-A", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
		"-H", "Accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
		"-H", "Accept-Language: en-US,en;q=0.9",
		"-H", "Referer: https://civitai.com/",
		url,
	)

	// Capture output (will contain HTTP status code)
	output, err := cmd.Output()
	if err != nil {
		os.Remove(tmpPath)
		// If curl fails, try to get more info from the error
		if exitErr, ok := err.(*exec.ExitError); ok {
			return fmt.Errorf("curl failed: %w (stderr: %s)", err, string(exitErr.Stderr))
		}
		return fmt.Errorf("curl failed: %w", err)
	}

	// Parse HTTP status code from output
	statusCode := strings.TrimSpace(string(output))

	// Debug: log what we got
	if statusCode != "200" {
		fmt.Fprintf(os.Stderr, "[DEBUG] curl returned status: '%s' (len=%d) for %s\n", statusCode, len(statusCode), filename)
	}

	// Check status code
	if statusCode != "200" {
		os.Remove(tmpPath)
		if statusCode == "429" {
			return fmt.Errorf("429 rate limit exceeded")
		}
		return fmt.Errorf("HTTP %s", statusCode)
	}

	// Verify file was downloaded (0-byte files are acceptable markers)
	if _, err := os.Stat(tmpPath); err != nil {
		os.Remove(tmpPath)
		return fmt.Errorf("download failed: file missing")
	}

	// Rename temp file to final path
	if err := os.Rename(tmpPath, outputPath); err != nil {
		os.Remove(tmpPath)
		return fmt.Errorf("failed to rename file: %w", err)
	}

	return nil
}

// generateThumbnails generates thumbnails for images that don't have them
func generateThumbnails() {
	// Find images without thumbnails
	imgFiles, err := filepath.Glob("img/*.jpeg")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error finding images: %v\n", err)
		return
	}

	thumbFiles, err := filepath.Glob("thumbs/*.png")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error finding thumbnails: %v\n", err)
		return
	}

	// Create sets for quick lookup
	imgSet := make(map[string]bool)
	for _, img := range imgFiles {
		basename := filepath.Base(img)
		id := strings.TrimSuffix(basename, ".jpeg")
		imgSet[id] = true
	}

	thumbSet := make(map[string]bool)
	for _, thumb := range thumbFiles {
		basename := filepath.Base(thumb)
		id := strings.TrimSuffix(basename, ".png")
		thumbSet[id] = true
	}

	// Find images without thumbnails
	var needThumbs []string
	for id := range imgSet {
		if !thumbSet[id] {
			needThumbs = append(needThumbs, id)
		}
	}

	sort.Strings(needThumbs)
	fmt.Fprintf(os.Stderr, "Found %d images needing thumbnails\n", len(needThumbs))

	if len(needThumbs) == 0 {
		return
	}

	// Process thumbnails in parallel
	var wg sync.WaitGroup
	jobChan := make(chan string, len(needThumbs))

	var processed int
	var progressMutex sync.Mutex

	// Launch workers
	for w := 0; w < thumbWorkers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			for id := range jobChan {
				if err := generateThumbnail(id); err != nil {
					fmt.Fprintf(os.Stderr, "Error generating thumbnail for %s: %v\n", id, err)
				}

				progressMutex.Lock()
				processed++
				if processed%100 == 0 {
					fmt.Fprintf(os.Stderr, "Generated %d/%d thumbnails\n", processed, len(needThumbs))
				}
				progressMutex.Unlock()
			}
		}(w)
	}

	// Send jobs to workers
	for _, id := range needThumbs {
		jobChan <- id
	}
	close(jobChan)

	wg.Wait()
	fmt.Fprintf(os.Stderr, "Generated %d thumbnails total\n", processed)
}

// generateThumbnail generates a thumbnail for a single image
func generateThumbnail(id string) error {
	imgPath := filepath.Join("img", id+".jpeg")
	thumbPath := filepath.Join("thumbs", id+".png")

	// Check if image exists
	if _, err := os.Stat(imgPath); os.IsNotExist(err) {
		return nil // Skip if image doesn't exist
	}

	// Check frame count using identify
	cmd := fmt.Sprintf("identify -format \"%%n\" %s", imgPath)
	output, err := runCommandOutput("bash", "-c", cmd)
	if err != nil {
		// Not a valid image, mark it
		fmt.Fprintf(os.Stderr, "Not a valid image: %s\n", imgPath)
		touchFile(filepath.Join("no", id+".jpeg"))
		touchFile(thumbPath)
		return nil
	}

	frameCount := strings.TrimSpace(string(output))

	// Check if it's a GIF (multi-frame)
	if frameCount != "1" {
		fmt.Fprintf(os.Stderr, "GIF image: %s\n", imgPath)
		touchFile(filepath.Join("no", id+".jpeg"))
		touchFile(thumbPath)
		return nil
	}

	// Generate thumbnail using mogrify
	cmd = fmt.Sprintf("mogrify -path thumbs -resize 400x -format png %s", imgPath)
	if err := runCommand("bash", "-c", cmd); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to generate thumbnail for %s: %v\n", id, err)
		return err
	}

	return nil
}

// runCommand executes a command and waits for it to complete
func runCommand(name string, args ...string) error {
	cmd := exec.Command(name, args...)
	if output, err := cmd.CombinedOutput(); err != nil {
		return fmt.Errorf("%w: %s", err, string(output))
	}
	return nil
}

// runCommandOutput executes a command and returns its output
func runCommandOutput(name string, args ...string) ([]byte, error) {
	cmd := exec.Command(name, args...)
	return cmd.Output()
}

// touchFile creates an empty file
func touchFile(path string) error {
	file, err := os.OpenFile(path, os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		return err
	}
	return file.Close()
}

// FEM mode implementation - Face/Image Manipulation Gallery Generator
// =====================================================================

// Global counter and mutex for tracking processed images in FEM mode
var (
	femProcessedCount int
	femCountMutex     sync.Mutex
	femLastBatchRun   int
)

// runFemMode orchestrates the face manipulation gallery generation process
func runFemMode() {
	// Initialize counters
	femProcessedCount = 0
	femLastBatchRun = 0

	// Process all source images against all style directories
	processAllImages()

	// Run batch one final time at the end
	fmt.Fprintf(os.Stderr, "\n=== Running final batch processing ===\n")
	batchProcessAllGalleries()
}

// generateGalleryIndex creates fm.html with links to all variants
func generateGalleryIndex() {
	fmt.Fprintf(os.Stderr, "Generating gallery index...\n")

	// Read w-??.png and w-???.png files from pub/fm directory
	pattern1 := filepath.Join("pub/fm", "w-??.png")
	pattern2 := filepath.Join("pub/fm", "w-???.png")

	matches1, _ := filepath.Glob(pattern1)
	matches2, _ := filepath.Glob(pattern2)

	allMatches := append(matches1, matches2...)

	// Sort by modification time
	type fileWithTime struct {
		path    string
		modTime time.Time
	}

	var files []fileWithTime
	for _, match := range allMatches {
		info, err := os.Stat(match)
		if err != nil {
			continue
		}
		files = append(files, fileWithTime{match, info.ModTime()})
	}

	// Sort by modification time (oldest first, like ls -trh)
	sort.Slice(files, func(i, j int) bool {
		return files[i].modTime.Before(files[j].modTime)
	})

	// Generate HTML content
	var html strings.Builder
	for _, f := range files {
		basename := filepath.Base(f.path)
		nameWithoutExt := strings.TrimSuffix(basename, ".png")

		html.WriteString(`<span style="white-space: nowrap;">`)
		html.WriteString("\n")

		// Generate links to 4 variants
		for i := 0; i < 4; i++ {
			variantFile := fmt.Sprintf("%s/%s-%08d-%04d-%04d-%04d-%012d.png",
				nameWithoutExt, nameWithoutExt, 0, 0, 0, 0, i)
			html.WriteString(fmt.Sprintf(`<a href="/pub/w/%s/"><img style="vertical-align: top;" src="%s"></a>`,
				nameWithoutExt, variantFile))
			html.WriteString("\n")
		}

		// Link to the main reference image
		html.WriteString(fmt.Sprintf(`<a href="/pub/w/%s/"><img style="vertical-align: top;" src="%s" width=300></a>`,
			nameWithoutExt, basename))
		html.WriteString("\n")
		html.WriteString(`</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`)
		html.WriteString("\n")
	}

	// Create fm directory if it doesn't exist
	os.MkdirAll("pub/fm", 0755)

	// Write HTML to pub/fm/fm.html
	err := ioutil.WriteFile("pub/fm/fm.html", []byte(html.String()), 0644)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error writing gallery index: %v\n", err)
		return
	}

	fmt.Fprintf(os.Stderr, "Gallery index generated at pub/fm/fm.html\n")
}

// processAllImages processes all source images against all style directories
func processAllImages() {
	fmt.Fprintf(os.Stderr, "Processing images...\n")

	// Find all source images in pub/fm/W directory
	sourcePattern := filepath.Join("pub/fm/W", "*.png")
	sourceImages, err := filepath.Glob(sourcePattern)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error finding source images: %v\n", err)
		return
	}

	// Sort source images
	sort.Strings(sourceImages)

	// Find all w-* style directories
	stylePattern := filepath.Join("pub/fm", "w-*")
	styleMatches, err := filepath.Glob(stylePattern)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error finding style directories: %v\n", err)
		return
	}

	// Filter to only directories
	var styleDirs []string
	for _, match := range styleMatches {
		info, err := os.Stat(match)
		if err == nil && info.IsDir() {
			styleDirs = append(styleDirs, filepath.Base(match))
		}
	}
	sort.Strings(styleDirs)

	fmt.Fprintf(os.Stderr, "Found %d source images and %d style directories\n", len(sourceImages), len(styleDirs))

	// Process each source image
	for _, sourceImage := range sourceImages {
		sourceName := filepath.Base(sourceImage)
		fmt.Fprintf(os.Stderr, "W = %s\n", sourceName)

		// Process against each style directory (with limited concurrency)
		semaphore := make(chan struct{}, 5) // Limit to 5 concurrent jobs
		var wg sync.WaitGroup

		for _, styleDir := range styleDirs {
			wg.Add(1)
			semaphore <- struct{}{} // Acquire semaphore

			go func(style string) {
				defer wg.Done()
				defer func() { <-semaphore }() // Release semaphore

				processImageWithStyle(sourceImage, sourceName, style)
			}(styleDir)
		}

		wg.Wait()
	}

	fmt.Fprintf(os.Stderr, "Image processing complete!\n")
}

// processImageWithStyle processes a single source image with a specific style
func processImageWithStyle(sourcePath, sourceName, styleDir string) {
	outputPath := filepath.Join("pub/fm", styleDir, fmt.Sprintf("%s-%s", styleDir, sourceName))

	// Check if output already exists
	if _, err := os.Stat(outputPath); err == nil {
		return // File already exists, skip (don't count as processed)
	}

	// Retry up to 3 times
	for attempt := 1; attempt <= 3; attempt++ {
		// Call the ML model
		fmt.Fprintf(os.Stderr, "Processing: %s style + %s source -> %s-%s\n",
			styleDir, sourceName, styleDir, sourceName)

		stylePNG := filepath.Join("pub/fm", styleDir+".png")
		err := callMLModelAndSave(sourcePath, stylePNG, outputPath)
		if err == nil {
			// Success! Increment processed counter
			femCountMutex.Lock()
			femProcessedCount++
			currentCount := femProcessedCount
			lastBatch := femLastBatchRun
			femCountMutex.Unlock()

			// Check if we should run batch processing
			// Run every 1000 images (at 1000, 2000, 3000, etc.)
			if currentCount/1000 > lastBatch/1000 {
				femCountMutex.Lock()
				// Double-check to avoid race condition
				if femProcessedCount/1000 > femLastBatchRun/1000 {
					femLastBatchRun = femProcessedCount
					femCountMutex.Unlock()

					fmt.Fprintf(os.Stderr, "\n=== Processed %d images, running batch gallery generation ===\n", currentCount)
					batchProcessAllGalleries()
					fmt.Fprintf(os.Stderr, "=== Batch processing complete, resuming image generation ===\n\n")
				} else {
					femCountMutex.Unlock()
				}
			}

			return // Success
		}

		if attempt < 3 {
			fmt.Fprintf(os.Stderr, "Attempt %d failed: %v, retrying...\n", attempt, err)
		} else {
			fmt.Fprintf(os.Stderr, "Failed after 3 attempts: %v\n", err)
		}
	}
}

// callMLModelAndSave calls the ML model API and saves the result
func callMLModelAndSave(inputImage, swapImage, outputPath string) error {
	// Read and encode input image as base64
	inputData, err := ioutil.ReadFile(inputImage)
	if err != nil {
		return fmt.Errorf("failed to read input image: %w", err)
	}
	inputB64 := base64.StdEncoding.EncodeToString(inputData)

	// Read and encode swap image as base64
	swapData, err := ioutil.ReadFile(swapImage)
	if err != nil {
		return fmt.Errorf("failed to read swap image: %w", err)
	}
	swapB64 := base64.StdEncoding.EncodeToString(swapData)

	// Build JSON payload
	type MLRequest struct {
		Input struct {
			InputImage string `json:"input_image"`
			SwapImage  string `json:"swap_image"`
		} `json:"input"`
	}

	var req MLRequest
	req.Input.InputImage = "data:image/jpeg;base64," + inputB64
	req.Input.SwapImage = "data:image/jpeg;base64," + swapB64

	jsonData, err := json.Marshal(req)
	if err != nil {
		return fmt.Errorf("failed to marshal JSON: %w", err)
	}

	// Call the ML model API
	resp, err := http.Post("http://localhost:5000/predictions",
		"application/json",
		bytes.NewReader(jsonData))
	if err != nil {
		return fmt.Errorf("failed to call ML API: %w", err)
	}
	defer resp.Body.Close()

	// Read response
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return fmt.Errorf("failed to read response: %w", err)
	}

	// Parse JSON response
	var result struct {
		Output string `json:"output"`
	}
	if err := json.Unmarshal(body, &result); err != nil {
		return fmt.Errorf("failed to parse JSON response: %w", err)
	}

	// Extract base64 data (remove "data:image/jpeg;base64," prefix)
	parts := strings.SplitN(result.Output, ",", 2)
	if len(parts) != 2 {
		return fmt.Errorf("invalid output format")
	}

	// Decode base64
	outputData, err := base64.StdEncoding.DecodeString(parts[1])
	if err != nil {
		return fmt.Errorf("failed to decode base64: %w", err)
	}

	// Write to temporary file
	tmpPath := outputPath + ".tmp"
	if err := ioutil.WriteFile(tmpPath, outputData, 0644); err != nil {
		return fmt.Errorf("failed to write output: %w", err)
	}

	// Validate that it's a JPEG
	file, err := os.Open(tmpPath)
	if err != nil {
		os.Remove(tmpPath)
		return fmt.Errorf("failed to open temp file: %w", err)
	}
	defer file.Close()

	// Try to decode as image
	_, format, err := image.DecodeConfig(file)
	if err != nil || format != "jpeg" {
		os.Remove(tmpPath)
		return fmt.Errorf("output is not a valid JPEG (format: %s, err: %v)", format, err)
	}

	// Move temp file to final location
	if err := os.Rename(tmpPath, outputPath); err != nil {
		os.Remove(tmpPath)
		return fmt.Errorf("failed to rename output: %w", err)
	}

	fmt.Fprintf(os.Stderr, "Successfully generated: %s\n", outputPath)
	return nil
}

// reportMode displays statistics about images in the database
func reportMode() {
	dbPath := "cv.db"

	// Open database
	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error opening database: %v\n", err)
		os.Exit(1)
	}
	defer db.Close()

	// Query statistics
	var totalCount, todoCount, yesCount, noCount, yesUpresImgCount, yesUpresThumbCount int

	// Total count
	if err := db.QueryRow("SELECT COUNT(*) FROM images").Scan(&totalCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying total count: %v\n", err)
		os.Exit(1)
	}

	// Todo (NULL state)
	if err := db.QueryRow("SELECT COUNT(*) FROM images WHERE state IS NULL").Scan(&todoCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying todo count: %v\n", err)
		os.Exit(1)
	}

	// Yes (approved)
	if err := db.QueryRow("SELECT COUNT(*) FROM images WHERE state='yes'").Scan(&yesCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying yes count: %v\n", err)
		os.Exit(1)
	}

	// No (rejected)
	if err := db.QueryRow("SELECT COUNT(*) FROM images WHERE state='no'").Scan(&noCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying no count: %v\n", err)
		os.Exit(1)
	}

	// Yes with upres images
	if err := db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_img_path IS NOT NULL").Scan(&yesUpresImgCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying upres img count: %v\n", err)
		os.Exit(1)
	}

	// Yes with upres thumbnails
	if err := db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_thumb_path IS NOT NULL").Scan(&yesUpresThumbCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying upres thumb count: %v\n", err)
		os.Exit(1)
	}

	// Count files in directories (in parallel)
	type dirCount struct {
		dir   string
		count int
	}

	countFiles := func(dir string) int {
		// Resolve symlinks
		realDir, err := filepath.EvalSymlinks(dir)
		if err != nil {
			return 0 // Directory doesn't exist or can't be resolved
		}

		count := 0
		filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return nil // Skip errors
			}
			if !info.IsDir() {
				count++
			}
			return nil
		})
		return count
	}

	// Parallel counting
	dirs := []string{"yes", "no", "img", "replicate/img", "replicate/t2"}
	results := make(chan dirCount, len(dirs))
	var wg sync.WaitGroup

	for _, dir := range dirs {
		wg.Add(1)
		go func(d string) {
			defer wg.Done()
			results <- dirCount{dir: d, count: countFiles(d)}
		}(dir)
	}

	wg.Wait()
	close(results)

	// Collect results
	counts := make(map[string]int)
	for r := range results {
		counts[r.dir] = r.count
	}

	fsYesCount := counts["yes"]
	fsNoCount := counts["no"]
	fsImgCount := counts["img"]
	fsUpresImgCount := counts["replicate/img"]
	fsUpresThumbCount := counts["replicate/t2"]

	// Display report
	fmt.Fprintf(os.Stderr, "\nImage Database Report:\n")
	fmt.Fprintf(os.Stderr, "=====================\n\n")

	fmt.Fprintf(os.Stderr, "Database Counts:\n")
	fmt.Fprintf(os.Stderr, "  Total images:       %d\n", totalCount)
	fmt.Fprintf(os.Stderr, "  Todo:               %d\n", todoCount)
	fmt.Fprintf(os.Stderr, "  Yes (approved):     %d\n", yesCount)
	fmt.Fprintf(os.Stderr, "  No (rejected):      %d\n", noCount)
	fmt.Fprintf(os.Stderr, "  Upres images:       %d\n", yesUpresImgCount)
	fmt.Fprintf(os.Stderr, "  Upres thumbnails:   %d\n", yesUpresThumbCount)

	fmt.Fprintf(os.Stderr, "\nFilesystem Counts:\n")
	fmt.Fprintf(os.Stderr, "  img/:               %d", fsImgCount)
	if fsImgCount == totalCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		diff := fsImgCount - totalCount
		if diff > 0 {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: +%d)\n", totalCount, diff)
		} else {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: %d)\n", totalCount, diff)
		}
	}

	fmt.Fprintf(os.Stderr, "  yes/:               %d", fsYesCount)
	if fsYesCount == yesCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		diff := fsYesCount - yesCount
		if diff > 0 {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: +%d)\n", yesCount, diff)
		} else {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: %d)\n", yesCount, diff)
		}
	}

	fmt.Fprintf(os.Stderr, "  no/:                %d", fsNoCount)
	if fsNoCount == noCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		diff := fsNoCount - noCount
		if diff > 0 {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: +%d)\n", noCount, diff)
		} else {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: %d)\n", noCount, diff)
		}
	}

	fmt.Fprintf(os.Stderr, "  replicate/img/:     %d", fsUpresImgCount)
	if fsUpresImgCount == yesUpresImgCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		diff := fsUpresImgCount - yesUpresImgCount
		if diff > 0 {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: +%d)\n", yesUpresImgCount, diff)
		} else {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: %d)\n", yesUpresImgCount, diff)
		}
	}

	fmt.Fprintf(os.Stderr, "  replicate/t2/:      %d", fsUpresThumbCount)
	if fsUpresThumbCount == yesUpresThumbCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		diff := fsUpresThumbCount - yesUpresThumbCount
		if diff > 0 {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: +%d)\n", yesUpresThumbCount, diff)
		} else {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: %d)\n", yesUpresThumbCount, diff)
		}
	}

	fmt.Fprintf(os.Stderr, "\nState Verification:\n")
	fmt.Fprintf(os.Stderr, "  %d + %d + %d = %d", todoCount, yesCount, noCount, todoCount+yesCount+noCount)
	if todoCount+yesCount+noCount == totalCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		fmt.Fprintf(os.Stderr, " ✗ (expected %d)\n", totalCount)
	}
}

// importMode imports image data from filesystem directories into the SQLite database
func importMode() {
	dbPath := "cv.db"

	// Open database
	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error opening database: %v\n", err)
		os.Exit(1)
	}
	defer db.Close()

	// Create base table
	schema := `
CREATE TABLE IF NOT EXISTS images (
    id TEXT PRIMARY KEY,
    state TEXT CHECK(state IN ('yes', 'no') OR state IS NULL),
    img_path TEXT,
    thumb_path TEXT,
    upres_img_path TEXT,
    upres_thumb_path TEXT
);
`

	if _, err := db.Exec(schema); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating schema: %v\n", err)
		os.Exit(1)
	}

	// Migrate existing database - add columns if they don't exist (silently ignore errors if columns exist)
	db.Exec("ALTER TABLE images ADD COLUMN width INTEGER")
	db.Exec("ALTER TABLE images ADD COLUMN height INTEGER")
	db.Exec("ALTER TABLE images ADD COLUMN weird TEXT")

	// Create indexes after columns exist
	indexes := `
CREATE INDEX IF NOT EXISTS idx_images_state ON images(state);
CREATE INDEX IF NOT EXISTS idx_images_thumb ON images(thumb_path) WHERE thumb_path IS NULL;
CREATE INDEX IF NOT EXISTS idx_images_weird ON images(weird) WHERE weird IS NOT NULL;
`
	if _, err := db.Exec(indexes); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating indexes: %v\n", err)
		os.Exit(1)
	}

	// Clear weird column at start of import run
	fmt.Fprintf(os.Stderr, "Clearing weird column for fresh import...\n")
	if _, err := db.Exec("UPDATE images SET weird = NULL WHERE weird IS NOT NULL"); err != nil {
		fmt.Fprintf(os.Stderr, "Error clearing weird column: %v\n", err)
		os.Exit(1)
	}

	// Run parallel import for yes/, no/, img/, thumbs/
	fmt.Fprintf(os.Stderr, "Starting parallel import of yes/, no/, img/, thumbs/...\n")
	if err := parallelImport(db); err != nil {
		fmt.Fprintf(os.Stderr, "Error during parallel import: %v\n", err)
		os.Exit(1)
	}

	fmt.Fprintf(os.Stderr, "Importing upres thumbnails from replicate/t2/ directory...\n")
	if err := importUpresPath(db, "replicate/t2", "upres_thumb_path"); err != nil {
		fmt.Fprintf(os.Stderr, "Error importing replicate/t2/: %v\n", err)
		os.Exit(1)
	}

	fmt.Fprintf(os.Stderr, "Importing upres images from replicate/img/ directory...\n")
	if err := importUpresPath(db, "replicate/img", "upres_img_path"); err != nil {
		fmt.Fprintf(os.Stderr, "Error importing replicate/img/: %v\n", err)
		os.Exit(1)
	}

	// Report statistics
	var yesCount, noCount, todoCount, thumbCount, upresThumbCount, upresImgCount int
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='yes'").Scan(&yesCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='no'").Scan(&noCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state IS NULL").Scan(&todoCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE thumb_path IS NOT NULL").Scan(&thumbCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_thumb_path IS NOT NULL").Scan(&upresThumbCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_img_path IS NOT NULL").Scan(&upresImgCount)

	fmt.Fprintf(os.Stderr, "\nImport complete:\n")
	fmt.Fprintf(os.Stderr, "  Approved (yes): %d\n", yesCount)
	fmt.Fprintf(os.Stderr, "  Rejected (no): %d\n", noCount)
	fmt.Fprintf(os.Stderr, "  Todo (null): %d\n", todoCount)
	fmt.Fprintf(os.Stderr, "  With thumbnails: %d\n", thumbCount)
	fmt.Fprintf(os.Stderr, "  With upres thumbnails: %d\n", upresThumbCount)
	fmt.Fprintf(os.Stderr, "  With upres images: %d\n", upresImgCount)

	// Report weird images
	var weirdCount int
	db.QueryRow("SELECT COUNT(*) FROM images WHERE weird IS NOT NULL").Scan(&weirdCount)
	if weirdCount > 0 {
		fmt.Fprintf(os.Stderr, "\nWeird images: %d (query: SELECT id, weird FROM images WHERE weird IS NOT NULL)\n", weirdCount)
	}

	// Report incomplete combinations
	fmt.Fprintf(os.Stderr, "\nIncomplete combinations (yes/todo only):\n")

	// 1. yes/todo without dimensions
	var noDimsCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE (state='yes' OR state IS NULL)
		AND (width IS NULL OR height IS NULL)`).Scan(&noDimsCount)
	if noDimsCount > 0 {
		fmt.Fprintf(os.Stderr, "  Yes/todo without dimensions: %d\n", noDimsCount)
	}

	// 2. yes/todo without img_path
	var noImgCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE (state='yes' OR state IS NULL)
		AND img_path IS NULL`).Scan(&noImgCount)
	if noImgCount > 0 {
		fmt.Fprintf(os.Stderr, "  Yes/todo without img_path: %d\n", noImgCount)
	}

	// 3. yes/todo without thumb_path
	var noThumbCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE (state='yes' OR state IS NULL)
		AND thumb_path IS NULL`).Scan(&noThumbCount)
	if noThumbCount > 0 {
		fmt.Fprintf(os.Stderr, "  Yes/todo without thumb_path: %d\n", noThumbCount)
	}

	// 4. yes/todo without both img and thumb
	var noBothCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE (state='yes' OR state IS NULL)
		AND img_path IS NULL AND thumb_path IS NULL`).Scan(&noBothCount)
	if noBothCount > 0 {
		fmt.Fprintf(os.Stderr, "  Yes/todo without img AND thumb (orphaned): %d\n", noBothCount)
	}

	// 5. upres_img_path without base img_path
	var upresImgOrphanCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE upres_img_path IS NOT NULL
		AND img_path IS NULL`).Scan(&upresImgOrphanCount)
	if upresImgOrphanCount > 0 {
		fmt.Fprintf(os.Stderr, "  Upres img without base img: %d\n", upresImgOrphanCount)
	}

	// 6. upres_thumb_path without base thumb_path
	var upresThumbOrphanCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE upres_thumb_path IS NOT NULL
		AND thumb_path IS NULL`).Scan(&upresThumbOrphanCount)
	if upresThumbOrphanCount > 0 {
		fmt.Fprintf(os.Stderr, "  Upres thumb without base thumb: %d\n", upresThumbOrphanCount)
	}

	// 7. Orphaned thumbnails (thumb only, no state, no img)
	var orphanedThumbCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE thumb_path IS NOT NULL
		AND state IS NULL
		AND img_path IS NULL`).Scan(&orphanedThumbCount)
	if orphanedThumbCount > 0 {
		fmt.Fprintf(os.Stderr, "  Orphaned thumbnails (thumb only, no img, no yes/no): %d\n", orphanedThumbCount)
	}

	// Summary
	totalIncomplete := noDimsCount + noImgCount + noThumbCount + upresImgOrphanCount + upresThumbOrphanCount
	if totalIncomplete == 0 {
		fmt.Fprintf(os.Stderr, "  None - all yes/todo images complete!\n")
	}

	// Validate file system consistency
	fmt.Fprintf(os.Stderr, "\nValidating file system consistency...\n")
	validateFileSystem(db)
}

// validateFileSystem checks for weird combinations in the database
func validateFileSystem(db *sql.DB) {
	// Check for zero-length img/ files without valid upres
	rows, err := db.Query(`SELECT id, img_path, upres_img_path FROM images WHERE img_path IS NOT NULL`)
	if err != nil {
		fmt.Fprintf(os.Stderr, "  ERROR: Failed to query images: %v\n", err)
		return
	}
	defer rows.Close()

	zeroLengthNoUpres := 0
	zeroLengthWithUpres := 0
	missingImgFile := 0
	missingUpresFile := 0

	for rows.Next() {
		var id, imgPath string
		var upresImgPath sql.NullString
		if err := rows.Scan(&id, &imgPath, &upresImgPath); err != nil {
			continue
		}

		// Check if img_path file exists and get size
		imgInfo, err := os.Stat(imgPath)
		if err != nil {
			missingImgFile++
			continue
		}

		// If img is zero-length, check for upres
		if imgInfo.Size() == 0 {
			hasValidUpres := false
			if upresImgPath.Valid && upresImgPath.String != "" {
				if upresInfo, err := os.Stat(upresImgPath.String); err == nil && upresInfo.Size() > 0 {
					hasValidUpres = true
					zeroLengthWithUpres++
				} else {
					missingUpresFile++
				}
			}

			if !hasValidUpres {
				zeroLengthNoUpres++
			}
		}
	}

	// Report findings
	if zeroLengthNoUpres > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: %d images have zero-length img_path without valid upres_img_path\n", zeroLengthNoUpres)
	}
	if zeroLengthWithUpres > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: %d images have zero-length img_path with valid upres_img_path (OK)\n", zeroLengthWithUpres)
	}
	if missingImgFile > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: %d images have missing img_path files\n", missingImgFile)
	}
	if missingUpresFile > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: %d images have missing upres_img_path files\n", missingUpresFile)
	}

	if zeroLengthNoUpres == 0 && missingImgFile == 0 && missingUpresFile == 0 {
		fmt.Fprintf(os.Stderr, "  OK: All images have valid file backing\n")
	}
}

// imageRecord represents a single image record from any import source
type imageRecord struct {
	id        string
	state     string // "yes", "no", or "" for NULL/todo
	imgPath   string
	thumbPath string
	width     int
	height    int
	sourceDir string // for logging
	weird     string // anomaly description, NULL if normal
}

// parallelImport imports yes/, no/, img/, thumbs/ in parallel
func parallelImport(db *sql.DB) error {
	// Channel for all import records
	recordChan := make(chan imageRecord, 100000)

	// Error channel
	errChan := make(chan error, 4)

	// WaitGroup for scanner goroutines
	var scanWg sync.WaitGroup

	// Start scanner goroutines
	scanWg.Add(4)

	// yes/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanYesDirectory(db, recordChan); err != nil {
			errChan <- fmt.Errorf("yes/ scanner: %w", err)
		}
	}()

	// no/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanNoDirectory(recordChan); err != nil {
			errChan <- fmt.Errorf("no/ scanner: %w", err)
		}
	}()

	// img/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanImgDirectory(db, recordChan); err != nil {
			errChan <- fmt.Errorf("img/ scanner: %w", err)
		}
	}()

	// thumbs/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanThumbsDirectory(db, recordChan); err != nil {
			errChan <- fmt.Errorf("thumbs/ scanner: %w", err)
		}
	}()

	// Close recordChan when all scanners finish
	go func() {
		scanWg.Wait()
		close(recordChan)
	}()

	// Database writer - single goroutine to avoid lock contention
	writerErr := databaseWriter(db, recordChan)

	// Check for scanner errors
	select {
	case err := <-errChan:
		return err
	default:
	}

	return writerErr
}

// databaseWriter processes records from channel and writes to database in batches
func databaseWriter(db *sql.DB, recordChan <-chan imageRecord) error {
	batch := make([]imageRecord, 0, 10000)
	count := 0
	yesToNoCount := 0
	noToYesCount := 0

	flushBatch := func() error {
		if len(batch) == 0 {
			return nil
		}

		tx, err := db.Begin()
		if err != nil {
			return err
		}
		defer tx.Rollback()

		// Check current state
		checkStmt, err := tx.Prepare("SELECT state FROM images WHERE id = ?")
		if err != nil {
			return err
		}
		defer checkStmt.Close()

		// Upsert statement
		upsertStmt, err := tx.Prepare(`
			INSERT INTO images (id, state, img_path, thumb_path, width, height, weird)
			VALUES (?, ?, ?, ?, ?, ?, ?)
			ON CONFLICT(id) DO UPDATE SET
				state = CASE
					WHEN excluded.state = 'yes' THEN 'yes'
					WHEN excluded.state = 'no' THEN 'no'
					WHEN excluded.state IS NULL THEN COALESCE(images.state, NULL)
					ELSE images.state
				END,
				img_path = COALESCE(excluded.img_path, images.img_path),
				thumb_path = COALESCE(excluded.thumb_path, images.thumb_path),
				width = COALESCE(NULLIF(excluded.width, 0), images.width),
				height = COALESCE(NULLIF(excluded.height, 0), images.height),
				weird = COALESCE(excluded.weird, images.weird)
		`)
		if err != nil {
			return err
		}
		defer upsertStmt.Close()

		for _, rec := range batch {
			// Check current state for transition logging
			var currentState sql.NullString
			err := checkStmt.QueryRow(rec.id).Scan(&currentState)

			weird := rec.weird

			// Log current and new state for debugging
			var currentStateStr, newStateStr string
			if err == sql.ErrNoRows {
				currentStateStr = "NEW"
			} else if err == nil {
				if currentState.Valid {
					currentStateStr = currentState.String
				} else {
					currentStateStr = "NULL"
				}
			}
			if rec.state == "" {
				newStateStr = "NULL"
			} else {
				newStateStr = rec.state
			}

			// Prevent yes -> no transition (yes cannot be downgraded)
			if err == nil && currentState.Valid && currentState.String == "yes" && rec.state == "no" {
				yesToNoCount++
				fmt.Fprintf(os.Stderr, "  WARNING: Image %s blocked downgrade %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)

				// If this conflict is from a no/ file, delete it
				if rec.sourceDir == "no/" {
					if removeErr := os.Remove(rec.imgPath); removeErr == nil {
						fmt.Fprintf(os.Stderr, "  INFO: Deleted conflicting no/ file: %s\n", rec.imgPath)
					} else {
						fmt.Fprintf(os.Stderr, "  ERROR: Failed to delete %s: %v\n", rec.imgPath, removeErr)
					}
				}

				continue // Skip this update
			}

			// Check for no -> yes transition
			if err == nil && currentState.Valid && currentState.String == "no" && rec.state == "yes" {
				noToYesCount++
				weirdMsg := fmt.Sprintf("no->yes transition from %s", rec.sourceDir)
				fmt.Fprintf(os.Stderr, "  WARNING: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
				if weird != "" {
					weird = weird + "; " + weirdMsg
				} else {
					weird = weirdMsg
				}
			}

			// Log other state transitions (NULL->no, NULL->yes, yes->NULL, no->NULL)
			if err == nil {
				if !currentState.Valid && rec.state == "no" {
					fmt.Fprintf(os.Stderr, "  INFO: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
				} else if !currentState.Valid && rec.state == "yes" {
					fmt.Fprintf(os.Stderr, "  INFO: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
				} else if currentState.Valid && rec.state == "" {
					fmt.Fprintf(os.Stderr, "  INFO: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
				}
			} else if err == sql.ErrNoRows {
				// New record
				if rec.state != "" {
					fmt.Fprintf(os.Stderr, "  INFO: Image %s created with state %s (from %s)\n", rec.id, newStateStr, rec.sourceDir)
				}
			}

			// Convert empty state to NULL
			var state interface{}
			if rec.state == "" {
				state = nil
			} else {
				state = rec.state
			}

			// Convert empty weird to NULL
			var weirdVal interface{}
			if weird != "" {
				weirdVal = weird
			} else {
				weirdVal = nil
			}

			// Execute upsert
			if _, err := upsertStmt.Exec(rec.id, state, rec.imgPath, rec.thumbPath, rec.width, rec.height, weirdVal); err != nil {
				return err
			}
		}

		if err := tx.Commit(); err != nil {
			return err
		}

		count += len(batch)
		if count%50000 == 0 {
			fmt.Fprintf(os.Stderr, "  Processed %d records...\n", count)
		}
		batch = batch[:0]
		return nil
	}

	// Process records from channel
	for rec := range recordChan {
		batch = append(batch, rec)

		if len(batch) >= 10000 {
			if err := flushBatch(); err != nil {
				return err
			}
		}
	}

	// Flush remaining
	if err := flushBatch(); err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Total records processed: %d\n", count)
	if yesToNoCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: %d attempts to downgrade from yes to no (blocked)\n", yesToNoCount)
	}
	if noToYesCount > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: %d images upgraded from no to yes\n", noToYesCount)
	}

	return nil
}

// scanYesDirectory scans yes/ and sends records to channel
func scanYesDirectory(db *sql.DB, recordChan chan<- imageRecord) error {
	realDir, err := filepath.EvalSymlinks("yes")
	if err != nil {
		return err
	}

	count := 0

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return err
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		ext := filepath.Ext(path)
		id := strings.TrimSuffix(basename, ext)

		// Check if dimensions already exist in DB
		var width, height int
		var existingWidth, existingHeight sql.NullInt64
		err = db.QueryRow("SELECT width, height FROM images WHERE id = ?", id).Scan(&existingWidth, &existingHeight)

		if err == sql.ErrNoRows || !existingWidth.Valid || !existingHeight.Valid || existingWidth.Int64 == 0 || existingHeight.Int64 == 0 {
			// Extract dimensions - missing or zero
			w, h, err := getImageDimensions(path)
			if err == nil {
				width, height = w, h
			}
		} else {
			// Use existing dimensions
			width = int(existingWidth.Int64)
			height = int(existingHeight.Int64)
		}

		recordChan <- imageRecord{
			id:        id,
			state:     "yes",
			imgPath:   path,
			width:     width,
			height:    height,
			sourceDir: "yes/",
		}

		count++
		if count%10000 == 0 {
			fmt.Fprintf(os.Stderr, "  Scanned %d images from yes/\n", count)
		}

		return nil
	})

	fmt.Fprintf(os.Stderr, "  Finished scanning yes/: %d images\n", count)

	return err
}

// scanNoDirectory scans no/ and sends records to channel
func scanNoDirectory(recordChan chan<- imageRecord) error {
	fmt.Fprintf(os.Stderr, "  Starting scan of no/ directory...\n")
	realDir, err := filepath.EvalSymlinks("no")
	if err != nil {
		return err
	}
	fmt.Fprintf(os.Stderr, "  Resolved no/ symlink to: %s\n", realDir)

	count := 0
	skippedDueToYes := 0
	checkedForYes := 0

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return err
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		ext := filepath.Ext(path)
		id := strings.TrimSuffix(basename, ext)

		// Skip if there's a yes/ file for this ID (yes takes precedence)
		checkedForYes++
		yesPath := filepath.Join("yes", id+".png")
		if _, statErr := os.Stat(yesPath); statErr == nil {
			// Delete the conflicting no/ file
			if removeErr := os.Remove(path); removeErr == nil {
				skippedDueToYes++
				if skippedDueToYes == 1 || skippedDueToYes%1000 == 0 {
					fmt.Fprintf(os.Stderr, "  INFO: Deleted %d of %d conflicting no/ files (yes/ file exists)\n", skippedDueToYes, checkedForYes)
				}
			} else {
				fmt.Fprintf(os.Stderr, "  ERROR: Failed to delete conflicting no/ file %s: %v\n", path, removeErr)
			}
			return nil
		}

		// If file is zero-length, check if there's a valid upres version
		if info.Size() == 0 {
			// Check if replicate/img/ has a non-zero file
			replicateImgPath := filepath.Join("replicate", "img", id+".png")
			if fi, err := os.Stat(replicateImgPath); err == nil && fi.Size() > 0 {
				// This is an upres'd image, skip it in no/ directory
				return nil
			}
		}

		recordChan <- imageRecord{
			id:        id,
			state:     "no",
			imgPath:   path,
			sourceDir: "no/",
		}

		count++
		if count%10000 == 0 {
			fmt.Fprintf(os.Stderr, "  Scanned %d images from no/\n", count)
		}

		return nil
	})

	fmt.Fprintf(os.Stderr, "  Finished scanning no/: %d images (checked %d for yes/ conflicts)\n", count, checkedForYes)
	if skippedDueToYes > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: Deleted %d of %d conflicting no/ files (yes/ file exists)\n", skippedDueToYes, checkedForYes)
	} else if checkedForYes > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: No yes/ conflicts found in %d no/ files checked\n", checkedForYes)
	}

	return err
}

// scanImgDirectory scans img/ and sends records to channel
func scanImgDirectory(db *sql.DB, recordChan chan<- imageRecord) error {
	realDir, err := filepath.EvalSymlinks("img")
	if err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Starting img/ scan with 8 workers...\n")

	// Process in chunks with worker pool
	chunkSize := 1000
	numWorkers := 8

	// Create work channel for chunks
	workChan := make(chan []string, numWorkers*2)

	// Counters (needs mutex for concurrent access)
	var mu sync.Mutex
	count := 0
	mp4Count := 0
	invalidCount := 0
	walkCount := 0

	// Start workers
	var wg sync.WaitGroup
	for i := 0; i < numWorkers; i++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			processImgChunk(db, workChan, recordChan, &mu, &count, &mp4Count, &invalidCount)
		}(i)
	}

	// Walk directory and send chunks to workers as we discover files
	var chunk []string
	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return err
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		walkCount++
		chunk = append(chunk, path)

		// Send chunk when it reaches size limit
		if len(chunk) >= chunkSize {
			workChan <- chunk
			chunk = make([]string, 0, chunkSize)

			if walkCount%10000 == 0 {
				fmt.Fprintf(os.Stderr, "  Walked %d files in img/\n", walkCount)
			}
		}

		return nil
	})

	// Send remaining files
	if len(chunk) > 0 {
		workChan <- chunk
	}

	close(workChan)
	wg.Wait()

	if err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Finished scanning img/: %d images\n", count)
	if mp4Count > 0 {
		fmt.Fprintf(os.Stderr, "  Auto-rejected %d .mp4 files\n", mp4Count)
	}
	if invalidCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Skipped %d files with invalid extensions\n", invalidCount)
	}

	return nil
}

// processImgChunk processes a chunk of img/ files
func processImgChunk(db *sql.DB, workChan <-chan []string, recordChan chan<- imageRecord, mu *sync.Mutex, count *int, mp4Count *int, invalidCount *int) {
	localCount := 0

	for chunk := range workChan {
		for _, path := range chunk {
			basename := filepath.Base(path)
			ext := strings.ToLower(filepath.Ext(path))
			id := strings.TrimSuffix(basename, filepath.Ext(path))

			switch ext {
			case ".jpeg", ".jpg", ".png":
				// Valid image - preserve existing state if yes/no, otherwise NULL
				var width, height int
				var existingState sql.NullString
				var existingWidth, existingHeight sql.NullInt64
				err := db.QueryRow("SELECT state, width, height FROM images WHERE id = ?", id).Scan(&existingState, &existingWidth, &existingHeight)

				// Preserve yes/no state, default to NULL for new or NULL records
				state := ""
				if err == nil && existingState.Valid && (existingState.String == "yes" || existingState.String == "no") {
					state = existingState.String
				}

				if err == sql.ErrNoRows || !existingWidth.Valid || !existingHeight.Valid || existingWidth.Int64 == 0 || existingHeight.Int64 == 0 {
					// Extract dimensions - missing or zero
					w, h, err := getImageDimensions(path)
					if err == nil {
						width, height = w, h
					}
				} else {
					// Use existing dimensions
					width = int(existingWidth.Int64)
					height = int(existingHeight.Int64)
				}

				recordChan <- imageRecord{
					id:        id,
					state:     state,
					imgPath:   path,
					width:     width,
					height:    height,
					sourceDir: "img/",
				}
				localCount++

			case ".mp4":
				// Auto-reject
				mu.Lock()
				(*mp4Count)++
				mu.Unlock()

				recordChan <- imageRecord{
					id:        id,
					state:     "no",
					imgPath:   path,
					sourceDir: "img/",
				}
				localCount++

			default:
				mu.Lock()
				(*invalidCount)++
				mu.Unlock()
				fmt.Fprintf(os.Stderr, "  WARNING: Invalid extension in img/: %s\n", basename)
			}
		}
	}

	// Update global counter
	mu.Lock()
	*count += localCount
	if *count%10000 < localCount {
		fmt.Fprintf(os.Stderr, "  Processed %d images from img/\n", *count)
	}
	mu.Unlock()
}

// scanThumbsDirectory scans thumbs/ and sends records to channel
func scanThumbsDirectory(db *sql.DB, recordChan chan<- imageRecord) error {
	realDir, err := filepath.EvalSymlinks("thumbs")
	if err != nil {
		return err
	}

	count := 0
	nonPngCount := 0
	zeroLengthSkipped := 0

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return err
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		ext := filepath.Ext(path)
		var weird string
		if ext != ".png" {
			nonPngCount++
			weird = fmt.Sprintf("non-PNG file in thumbs/: %s", ext)
			fmt.Fprintf(os.Stderr, "  WARNING: Non-PNG file in thumbs/: %s\n", basename)
		}

		id := strings.TrimSuffix(basename, ext)

		// Check for zero-length thumbnails
		if info.Size() == 0 {
			var state sql.NullString
			var imgPath sql.NullString
			err := db.QueryRow("SELECT state, img_path FROM images WHERE id = ?", id).Scan(&state, &imgPath)

			if err == sql.ErrNoRows || !state.Valid {
				// No entry or todo - check img file
				if imgPath.Valid {
					imgInfo, err := os.Stat(imgPath.String)
					if err == nil && imgInfo.Size() == 0 {
						// img is zero-length too -> mark as 'no'
						weirdMsg := "zero-length thumbnail and img"
						if weird != "" {
							weird = weird + "; " + weirdMsg
						} else {
							weird = weirdMsg
						}
						recordChan <- imageRecord{
							id:        id,
							state:     "no",
							thumbPath: path,
							sourceDir: "thumbs/",
							weird:     weird,
						}
						count++
					} else {
						// Skip - needs regeneration
						zeroLengthSkipped++
						fmt.Fprintf(os.Stderr, "  WARNING: Zero-length thumbnail (needs regeneration): %s\n", basename)
					}
				} else {
					zeroLengthSkipped++
					fmt.Fprintf(os.Stderr, "  WARNING: Zero-length thumbnail (no img): %s\n", basename)
				}
				return nil
			}
		}

		// Normal thumbnail - preserve existing yes/no state
		var existingState sql.NullString
		dbErr := db.QueryRow("SELECT state FROM images WHERE id = ?", id).Scan(&existingState)

		state := ""
		if dbErr == nil && existingState.Valid && (existingState.String == "yes" || existingState.String == "no") {
			state = existingState.String
		}

		recordChan <- imageRecord{
			id:        id,
			state:     state,
			thumbPath: path,
			sourceDir: "thumbs/",
			weird:     weird,
		}
		count++

		if count%10000 == 0 {
			fmt.Fprintf(os.Stderr, "  Scanned %d thumbnails from thumbs/\n", count)
		}

		return nil
	})

	fmt.Fprintf(os.Stderr, "  Finished scanning thumbs/: %d thumbnails\n", count)
	if nonPngCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Found %d non-PNG files in thumbs/\n", nonPngCount)
	}
	if zeroLengthSkipped > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Skipped %d zero-length thumbnails (need regeneration)\n", zeroLengthSkipped)
	}

	return err
}

// importDirectory scans a directory and imports images with the given state
func importDirectory(db *sql.DB, dir string, state string) error {
	// Resolve symlinks
	realDir, err := filepath.EvalSymlinks(dir)
	if err != nil {
		return fmt.Errorf("failed to resolve symlink for %s: %w", dir, err)
	}

	type imageRecord struct {
		id     string
		path   string
		width  int
		height int
	}

	batch := make([]imageRecord, 0, 10000)
	count := 0
	nonPngCount := 0

	flushBatch := func() error {
		if len(batch) == 0 {
			return nil
		}

		tx, err := db.Begin()
		if err != nil {
			return err
		}
		defer tx.Rollback()

		stmt, err := tx.Prepare(`
			INSERT INTO images (id, state, img_path, width, height)
			VALUES (?, ?, ?, ?, ?)
			ON CONFLICT(id) DO UPDATE SET
				state=excluded.state,
				img_path=excluded.img_path,
				width=excluded.width,
				height=excluded.height
		`)
		if err != nil {
			return err
		}
		defer stmt.Close()

		for _, rec := range batch {
			if _, err := stmt.Exec(rec.id, state, rec.path, rec.width, rec.height); err != nil {
				return err
			}
		}

		if err := tx.Commit(); err != nil {
			return err
		}

		count += len(batch)
		fmt.Fprintf(os.Stderr, "  Imported %d images from %s/\n", count, dir)
		batch = batch[:0]
		return nil
	}

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		// Check extension - yes/no should all be .png
		ext := filepath.Ext(path)
		if ext != ".png" {
			nonPngCount++
			fmt.Fprintf(os.Stderr, "  WARNING: Non-PNG file in %s/: %s\n", dir, basename)
		}

		// Extract ID (filename without extension)
		id := strings.TrimSuffix(basename, ext)

		// Get dimensions for 'yes' state only (skip 'no')
		var width, height int
		if state == "yes" {
			w, h, err := getImageDimensions(path)
			if err == nil {
				width, height = w, h
			}
			// Silently ignore dimension extraction errors
		}

		batch = append(batch, imageRecord{id: id, path: path, width: width, height: height})

		if len(batch) >= 10000 {
			return flushBatch()
		}

		return nil
	})

	if err != nil {
		return err
	}

	// Flush remaining
	if err := flushBatch(); err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Imported %d total images from %s/\n", count, dir)
	if nonPngCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Found %d non-PNG files in %s/\n", nonPngCount, dir)
	}
	return nil
}

// importThumbnails scans the thumbs directory and updates thumbnail paths
func importThumbnails(db *sql.DB, dir string) error {
	// Resolve symlinks
	realDir, err := filepath.EvalSymlinks(dir)
	if err != nil {
		return fmt.Errorf("failed to resolve symlink for %s: %w", dir, err)
	}

	type thumbRecord struct {
		id   string
		path string
	}

	batch := make([]thumbRecord, 0, 10000)
	count := 0
	nonPngCount := 0
	zeroLengthSkipped := 0

	flushBatch := func() error {
		if len(batch) == 0 {
			return nil
		}

		tx, err := db.Begin()
		if err != nil {
			return err
		}
		defer tx.Rollback()

		stmt, err := tx.Prepare(`
			INSERT INTO images (id, thumb_path)
			VALUES (?, ?)
			ON CONFLICT(id) DO UPDATE SET
				thumb_path=excluded.thumb_path
		`)
		if err != nil {
			return err
		}
		defer stmt.Close()

		for _, rec := range batch {
			if _, err := stmt.Exec(rec.id, rec.path); err != nil {
				return err
			}
		}

		if err := tx.Commit(); err != nil {
			return err
		}

		count += len(batch)
		fmt.Fprintf(os.Stderr, "  Imported %d thumbnails from %s/\n", count, dir)
		batch = batch[:0]
		return nil
	}

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		// Check extension - thumbs should all be .png
		ext := filepath.Ext(path)
		if ext != ".png" {
			nonPngCount++
			fmt.Fprintf(os.Stderr, "  WARNING: Non-PNG file in %s/: %s\n", dir, basename)
		}

		// Extract ID (filename without extension)
		id := strings.TrimSuffix(basename, ext)

		// Check for zero-length thumbnails
		if info.Size() == 0 {
			// Query database to check if this image has a state
			var state sql.NullString
			var imgPath sql.NullString
			err := db.QueryRow("SELECT state, img_path FROM images WHERE id = ?", id).Scan(&state, &imgPath)

			if err == sql.ErrNoRows || !state.Valid {
				// No entry in yes/no (state is NULL or doesn't exist)
				// Check if img/ file is also zero-length
				if imgPath.Valid {
					imgInfo, err := os.Stat(imgPath.String)
					if err == nil && imgInfo.Size() == 0 {
						// img is zero-length too -> mark as 'no' and import thumbnail
						db.Exec("UPDATE images SET state='no' WHERE id = ?", id)
						batch = append(batch, thumbRecord{id: id, path: path})
					} else {
						// img is not zero-length or doesn't exist -> skip, needs regeneration
						zeroLengthSkipped++
						fmt.Fprintf(os.Stderr, "  WARNING: Zero-length thumbnail (needs regeneration): %s\n", filepath.Base(path))
						return nil
					}
				} else {
					// No img_path -> skip thumbnail
					zeroLengthSkipped++
					fmt.Fprintf(os.Stderr, "  WARNING: Zero-length thumbnail (no img): %s\n", filepath.Base(path))
					return nil
				}
			} else {
				// Has state from yes/no -> import normally
				batch = append(batch, thumbRecord{id: id, path: path})
			}
		} else {
			// Normal thumbnail -> import
			batch = append(batch, thumbRecord{id: id, path: path})
		}

		if len(batch) >= 10000 {
			return flushBatch()
		}

		return nil
	})

	if err != nil {
		return err
	}

	// Flush remaining
	if err := flushBatch(); err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Imported %d total thumbnails from %s/\n", count, dir)
	if nonPngCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Found %d non-PNG files in %s/\n", nonPngCount, dir)
	}
	if zeroLengthSkipped > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Skipped %d zero-length thumbnails (need regeneration)\n", zeroLengthSkipped)
	}
	return nil
}

// importUpresPath scans a directory and updates the specified upres path column
func importUpresPath(db *sql.DB, dir string, columnName string) error {
	// Resolve symlinks
	realDir, err := filepath.EvalSymlinks(dir)
	if err != nil {
		return fmt.Errorf("failed to resolve symlink for %s: %w", dir, err)
	}

	type upresRecord struct {
		id   string
		path string
	}

	batch := make([]upresRecord, 0, 10000)
	count := 0
	nonPngCount := 0

	flushBatch := func() error {
		if len(batch) == 0 {
			return nil
		}

		tx, err := db.Begin()
		if err != nil {
			return err
		}
		defer tx.Rollback()

		// Build dynamic SQL with column name
		sql := fmt.Sprintf(`
			INSERT INTO images (id, %s)
			VALUES (?, ?)
			ON CONFLICT(id) DO UPDATE SET
				%s=excluded.%s
		`, columnName, columnName, columnName)

		stmt, err := tx.Prepare(sql)
		if err != nil {
			return err
		}
		defer stmt.Close()

		for _, rec := range batch {
			if _, err := stmt.Exec(rec.id, rec.path); err != nil {
				return err
			}
		}

		if err := tx.Commit(); err != nil {
			return err
		}

		count += len(batch)
		fmt.Fprintf(os.Stderr, "  Imported %d upres from %s/\n", count, dir)
		batch = batch[:0]
		return nil
	}

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		// Check extension - upres should all be .png
		ext := filepath.Ext(path)
		if ext != ".png" {
			nonPngCount++
			fmt.Fprintf(os.Stderr, "  WARNING: Non-PNG file in %s/: %s\n", dir, basename)
		}

		// Extract ID (filename without extension)
		id := strings.TrimSuffix(basename, ext)

		batch = append(batch, upresRecord{id: id, path: path})

		if len(batch) >= 10000 {
			return flushBatch()
		}

		return nil
	})

	if err != nil {
		return err
	}

	// Flush remaining
	if err := flushBatch(); err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Imported %d total upres from %s/\n", count, dir)
	if nonPngCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Found %d non-PNG files in %s/\n", nonPngCount, dir)
	}
	return nil
}

// importImgDirectory scans img/ directory with special extension rules
// Valid: .jpeg, .jpg, .png - import with state=NULL (todo)
// Auto-reject: .mp4 - import with state='no'
// Invalid: anything else - flag and skip
func importImgDirectory(db *sql.DB, dir string) error {
	// Resolve symlinks
	realDir, err := filepath.EvalSymlinks(dir)
	if err != nil {
		return fmt.Errorf("failed to resolve symlink for %s: %w", dir, err)
	}

	type imgRecord struct {
		id     string
		path   string
		state  string
		width  int
		height int
	}

	batch := make([]imgRecord, 0, 10000)
	count := 0
	mp4Count := 0
	invalidCount := 0

	flushBatch := func() error {
		if len(batch) == 0 {
			return nil
		}

		tx, err := db.Begin()
		if err != nil {
			return err
		}
		defer tx.Rollback()

		stmt, err := tx.Prepare(`
			INSERT INTO images (id, img_path, state, width, height)
			VALUES (?, ?, ?, ?, ?)
			ON CONFLICT(id) DO UPDATE SET
				img_path=excluded.img_path,
				state=COALESCE(images.state, excluded.state),
				width=excluded.width,
				height=excluded.height
		`)
		if err != nil {
			return err
		}
		defer stmt.Close()

		for _, rec := range batch {
			var state interface{}
			if rec.state == "no" {
				state = "no"
			} else {
				state = nil // NULL for todo
			}

			if _, err := stmt.Exec(rec.id, rec.path, state, rec.width, rec.height); err != nil {
				return err
			}
		}

		if err := tx.Commit(); err != nil {
			return err
		}

		count += len(batch)
		fmt.Fprintf(os.Stderr, "  Imported %d images from %s/\n", count, dir)
		batch = batch[:0]
		return nil
	}

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		ext := strings.ToLower(filepath.Ext(path))
		id := strings.TrimSuffix(basename, filepath.Ext(path))

		// Check extension rules
		switch ext {
		case ".jpeg", ".jpg", ".png":
			// Valid image - import as todo (state=NULL), extract dimensions
			var width, height int
			w, h, err := getImageDimensions(path)
			if err == nil {
				width, height = w, h
			}
			// Silently ignore dimension extraction errors
			batch = append(batch, imgRecord{id: id, path: path, state: "todo", width: width, height: height})

		case ".mp4":
			// Auto-reject video - no dimensions needed
			mp4Count++
			batch = append(batch, imgRecord{id: id, path: path, state: "no", width: 0, height: 0})

		default:
			// Invalid extension - flag and skip
			invalidCount++
			fmt.Fprintf(os.Stderr, "  WARNING: Invalid extension in %s/: %s\n", dir, filepath.Base(path))
			return nil
		}

		if len(batch) >= 10000 {
			return flushBatch()
		}

		return nil
	})

	if err != nil {
		return err
	}

	// Flush remaining
	if err := flushBatch(); err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Imported %d total images from %s/\n", count, dir)
	if mp4Count > 0 {
		fmt.Fprintf(os.Stderr, "  Auto-rejected %d .mp4 files\n", mp4Count)
	}
	if invalidCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Skipped %d files with invalid extensions\n", invalidCount)
	}
	return nil
}
