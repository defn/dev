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
	"flag"
	"fmt"
	"os"
	"time"
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
	commitWrite     bool   // Whether to write no/ files in commit mode (default: false = dry-run)
)

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

	// Commit mode specific flags
	flag.BoolVar(&commitWrite, "commit", false, "Actually write no/ files in commit mode (default: false = dry-run)")

	// Mode configuration
	var modeValue string
	flag.StringVar(&modeValue, "mode", "", "Operating mode: gallery, html, batch, fem, user, download, todo, fixup, import, report, or commit")
	flag.StringVar(&modeValue, "m", "", "Operating mode (shorthand): gallery, html, batch, fem, user, download, todo, fixup, import, report, or commit")
	mode := &modeValue

	// Help flags
	showHelp := flag.Bool("help", false, "Show help message")
	showHelpShort := flag.Bool("h", false, "Show help message (shorthand)")
	flag.Parse()

	// Display help information if requested
	if *showHelp || *showHelpShort {
		fmt.Fprintf(os.Stderr, "Usage: %s -mode <gallery|html|batch|fem|user|download|todo|fixup|import|report|commit> [options]\n", os.Args[0])
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
		fmt.Fprintf(os.Stderr, "  commit   - Process curated galleries from LAST file and mark images as yes/no\n")
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

	case "commit":
		// Commit mode: process curated galleries and mark images
		commitMode()

	default:
		fmt.Fprintf(os.Stderr, "Error: -mode must be specified as 'gallery', 'html', 'batch', 'fem', 'user', 'download', 'todo', 'fixup', 'import', 'report', or 'commit'\n")
		fmt.Fprintf(os.Stderr, "Run with -help for usage information\n")
		os.Exit(1)
	}
}
