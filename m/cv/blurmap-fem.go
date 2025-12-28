package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"image"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"sync"
)

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
