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
	"regexp"
	"runtime"
	"strconv"
	"strings"
	"sync"
)

const (
	cacheDir = "blur"
	imageDir = "replicate/t2"
)

// ImageInfo holds information about an image file
type ImageInfo struct {
	Filename string
	Width    int
	Height   int
	Blurmap  string
}

// Result holds the result of processing an image
type Result struct {
	Filename string
	Blurmap  string
	Width    int
	Height   int
	Error    error
	Cached   bool
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run blurmap.go <image_list_file> [js_output_file]")
		os.Exit(1)
	}

	imageListFile := os.Args[1]
	var jsOutputFile string
	if len(os.Args) > 2 {
		jsOutputFile = os.Args[2]
	}

	// Create cache directory if it doesn't exist
	if err := ensureCacheDir(); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating cache directory: %v\n", err)
		os.Exit(1)
	}

	// Process the images first to get the hashes
	imageInfos, err := parseImageListFile(imageListFile)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing image list file: %v\n", err)
		os.Exit(1)
	}

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

	// Update imageInfos with blurhash data directly
	resultMap := make(map[string]string)
	imageInfoMap := make(map[string]*ImageInfo)

	// First create a map for quick lookup
	for i := range imageInfos {
		imageInfoMap[imageInfos[i].Filename] = &imageInfos[i]
	}

	// Process results and update ImageInfo objects
	for result := range results {
		if result.Error != nil {
			fmt.Fprintf(os.Stderr, "Error processing %s: %v\n", result.Filename, result.Error)
			continue
		}

		// Store the blurhash for each filename
		resultMap[result.Filename] = result.Blurmap

		// Update the ImageInfo object directly
		if info, found := imageInfoMap[result.Filename]; found {
			info.Blurmap = result.Blurmap
			// Update width and height from image processing if they were 0
			if info.Width == 0 || info.Height == 0 {
				info.Width = result.Width
				info.Height = result.Height
			}
		}
	}

	// Generate the JavaScript file with image data and full RGB blurhashes
	outputFile := "blurhash.js"
	if jsOutputFile != "" {
		outputFile = jsOutputFile
	}

	// Generate the JavaScript file with blurhashes directly from memory
	if err := generateJavaScriptFile(imageInfos, outputFile); err != nil {
		fmt.Fprintf(os.Stderr, "Error generating JavaScript file: %v\n", err)
	} else {
		fmt.Printf("Generated JavaScript file with full RGB blurhashes: %s\n", outputFile)
	}

	// Also output the first 2 blurhashes for verification
	count := 0
	for filename, blurhash := range resultMap {
		if len(blurhash) > 0 {
			// Safely display a substring
			displayLen := 20
			if len(blurhash) < displayLen {
				displayLen = len(blurhash)
			}

			fmt.Printf("Sample blurhash for %s: '%s' (length: %d)\n",
				filename, blurhash[:displayLen]+"...", len(blurhash))
			count++
			if count >= 2 {
				break
			}
		}
	}
}

// printWithBlurhash reads the input file again and prints each line
// adding blurhash attributes for lines with filenames
func printWithBlurhash(filePath string, blurhashMap map[string]string) error {
	file, err := os.Open(filePath)
	if err != nil {
		return err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	
	// Regular expression to extract image info
	// Example format: { filename: "000040a4-e733-4cec-b744-be1d7ec7de49.png", width: 400, height: 400},
	// Or with blurhash: { filename: "000040a4-e733-4cec-b744-be1d7ec7de49.png", width: 400, height: 400, blurhash: "abc123..."},
	re := regexp.MustCompile(`{\s*filename:\s*"([^"]+)",\s*width:\s*(\d+),\s*height:\s*(\d+)(?:,\s*blurhash:\s*"([^"]*)")?\s*}`)
	
	for scanner.Scan() {
		line := scanner.Text()
		matches := re.FindStringSubmatch(line)
		
		if len(matches) >= 4 {
			// This is a line with a filename
			filename := matches[1]

			// Check if line already has a blurhash attribute
			if len(matches) == 5 && matches[4] != "" {
				// Line already has a blurhash, print as is
				fmt.Println(line)
			} else if hash, ok := blurhashMap[filename]; ok {
				// Add blurhash attribute to the line
				// Insert blurhash before the closing }
				modifiedLine := strings.Replace(line, "}", fmt.Sprintf(", blurhash: \"%s\"}", hash), 1)
				fmt.Println(modifiedLine)
			} else {
				// No hash found, print the original line
				fmt.Println(line)
			}
		} else {
			// Just print the line as is
			fmt.Println(line)
		}
	}
	
	if err := scanner.Err(); err != nil {
		return err
	}
	
	return nil
}

// worker processes images concurrently
func worker(jobs <-chan ImageInfo, results chan<- Result, wg *sync.WaitGroup) {
	defer wg.Done()
	
	for imageInfo := range jobs {
		// Construct the full image path
		imagePath := filepath.Join(imageDir, imageInfo.Filename)
		
		// Generate cache filename
		cacheFile := getCacheFilename(imagePath)
		
		// Try to get from cache
		blurmap, err := readFromCache(cacheFile)
		if err == nil {
			// Cache hit
			results <- Result{Filename: imageInfo.Filename, Blurmap: blurmap, Width: imageInfo.Width, Height: imageInfo.Height, Cached: true}
			continue
		}
		
		// Cache miss - generate the blurmap and get image dimensions
		blurmap, width, height, err := generateBlurmap(imagePath)
		if err != nil {
			results <- Result{Filename: imageInfo.Filename, Error: err, Cached: false}
			continue
		}
		
		// Save to cache
		if err := writeToCache(cacheFile, blurmap); err != nil {
			fmt.Fprintf(os.Stderr, "Warning: Failed to write to cache for %s: %v\n", imageInfo.Filename, err)
		}
		
		// Send result with width and height
		results <- Result{Filename: imageInfo.Filename, Blurmap: blurmap, Width: width, Height: height, Cached: false}
	}
}

// parseImageListFile parses a file containing image information
func parseImageListFile(filePath string) ([]ImageInfo, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var imageInfos []ImageInfo
	scanner := bufio.NewScanner(file)

	// Regular expression to extract image info
	// Now supports the format with just filename: { filename: "image.jpg" }
	// And also the traditional format: { filename: "image.jpg", width: 400, height: 400 }
	// Or with blurhash: { filename: "image.jpg", width: 400, height: 400, blurhash: "abc123..." }
	reWithDimensions := regexp.MustCompile(`{\s*filename:\s*"([^"]+)",\s*width:\s*(\d+),\s*height:\s*(\d+)(?:,\s*blurhash:\s*"([^"]*)")?\s*}`)
	reFileOnly := regexp.MustCompile(`{\s*filename:\s*"([^"]+)"\s*}`)

	for scanner.Scan() {
		line := scanner.Text()

		// First try to match the full pattern with dimensions
		matches := reWithDimensions.FindStringSubmatch(line)

		if len(matches) >= 4 {
			// We have a match with dimensions
			width, _ := strconv.Atoi(matches[2])
			height, _ := strconv.Atoi(matches[3])

			imageInfo := ImageInfo{
				Filename: matches[1],
				Width:    width,
				Height:   height,
			}

			// If there's existing blurhash in the file, store it
			if len(matches) == 5 && matches[4] != "" {
				imageInfo.Blurmap = matches[4]
			}

			imageInfos = append(imageInfos, imageInfo)
		} else {
			// Try to match just filename pattern
			filenameMatches := reFileOnly.FindStringSubmatch(line)
			if len(filenameMatches) >= 2 {
				// We have a match with just filename
				imageInfo := ImageInfo{
					Filename: filenameMatches[1],
					Width:    0,  // We'll read these from the actual image later
					Height:   0,
				}
				imageInfos = append(imageInfos, imageInfo)
			}
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return imageInfos, nil
}

func ensureCacheDir() error {
	if _, err := os.Stat(cacheDir); os.IsNotExist(err) {
		return os.Mkdir(cacheDir, 0755)
	}
	return nil
}

func getCacheFilename(imagePath string) string {
	// Create a hash of the absolute path to use as the cache filename
	absPath, err := filepath.Abs(imagePath)
	if err != nil {
		absPath = imagePath // Fallback to original path if absolute path fails
	}
	
	hash := fmt.Sprintf("%x", sha256.Sum256([]byte(absPath)))
	return filepath.Join(cacheDir, hash)
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

	// Calculate cell dimensions - use the minimum dimension to ensure square cells
	cellSize := width
	if height < width {
		cellSize = height
	}

	cellWidth := cellSize / 10
	cellHeight := cellSize / 10

	var blurValues []string

	// Process each of the 10x10 cells
	for y := 0; y < 10; y++ {
		for x := 0; x < 10; x++ {
			// Calculate cell boundaries
			startX := bounds.Min.X + x*cellWidth
			startY := bounds.Min.Y + y*cellHeight
			endX := startX + cellWidth
			endY := startY + cellHeight
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

	// Join all hex values into a single string (600 bytes total)
	// Make sure we have exactly 100 values (10x10 grid)
	if len(blurValues) != 100 {
		// Pad or truncate as needed
		for len(blurValues) < 100 {
			blurValues = append(blurValues, "000000") // Black
		}
		if len(blurValues) > 100 {
			blurValues = blurValues[:100]
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

// generateJavaScriptFile creates a JavaScript file with the image array including blurhash attributes
// This version uses the in-memory imageInfos array which already contains all the data we need
func generateJavaScriptFile(imageInfos []ImageInfo, outputFile string) error {
	// Create the output file
	out, err := os.Create(outputFile)
	if err != nil {
		return err
	}
	defer out.Close()

	// Write the JS variable declaration
	out.WriteString("// Generated image array with blurhash attributes\n")
	out.WriteString("// This file is auto-generated by blurmap.go with RGB color values\n")
	out.WriteString("window.hashImages = window.hashImages || [];\n")
	out.WriteString("window.hashImages = [\n")

	// Process each image to include width, height, and blurhash
	for _, info := range imageInfos {
		// Always read actual image dimensions from the file, even if we have them in metadata
		imagePath := filepath.Join(imageDir, info.Filename)
		width, height, err := getImageDimensions(imagePath)

		// Use the dimensions we got, or fallback to the ones in the metadata
		if err != nil || width == 0 || height == 0 {
			width = info.Width
			height = info.Height
		}

		if info.Blurmap != "" {
			// If we have a blurhash, include it
			fmt.Fprintf(out, "  { filename: \"%s\", width: %d, height: %d, blurhash: \"%s\" },\n",
				info.Filename, width, height, info.Blurmap)
		} else {
			// If we don't have a blurhash, generate one
			blurmap, _, _, err := generateBlurmap(imagePath)
			if err == nil && blurmap != "" {
				fmt.Fprintf(out, "  { filename: \"%s\", width: %d, height: %d, blurhash: \"%s\" },\n",
					info.Filename, width, height, blurmap)
			} else {
				// Otherwise output without blurhash
				fmt.Fprintf(out, "  { filename: \"%s\", width: %d, height: %d },\n",
					info.Filename, width, height)
			}
		}
	}

	// Close the array
	out.WriteString("];\n")

	return nil
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