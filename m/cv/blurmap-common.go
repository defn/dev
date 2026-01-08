package main

import (
	"crypto/sha256"
	"fmt"
	"image"
	_ "image/jpeg"
	_ "image/png"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"sync"
)

// Shared types
type ImageInfo struct {
	Filename string
	Width    int
	Height   int
	Blurmap  string
}

type Result struct {
	Filename  string
	Blurmap   string
	Width     int
	Height    int
	Error     error
	Cached    bool
	DimCached bool
}

type GalleryData struct {
	Images      string
	BlurhashMap string
}

type AverageColor struct {
	R, G, B uint8
}

// Shared constants
const chunkSize = 500

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

var timestampCache int64

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
func processSingleGallery(imageInfos []ImageInfo) {
	processGalleryWithPaths(imageInfos, imageDir, outputDir)
}
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
