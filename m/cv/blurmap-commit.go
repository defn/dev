package main

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"sync"
)

// galleryResult holds the processing results for a single gallery
type galleryResult struct {
	galleryNum     int
	totalImages    int
	yesCount       int
	alreadyNoCount int
	toMarkNoCount  int
	writtenCount   int
	deletedNoCount int
	imageIDs       []string
	err            error
}

// commitMode processes curated galleries from LAST file and reports yes/no counts
// Reads LAST to determine how many galleries to process (tmp/g/1/, tmp/g/2/, etc.)
// For each gallery, extracts image IDs and stats individual files to check yes/no status
// Reports counts without modifying the filesystem
func commitMode() {
	fmt.Fprintf(os.Stderr, "Commit mode: Processing curated galleries\n")

	// Read LAST file to get the number of galleries to process
	lastFile := "LAST"
	lastData, err := os.ReadFile(lastFile)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading %s: %v\n", lastFile, err)
		fmt.Fprintf(os.Stderr, "Make sure LAST file exists with the gallery count\n")
		os.Exit(1)
	}

	lastStr := strings.TrimSpace(string(lastData))
	nextGallery, err := strconv.Atoi(lastStr)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing LAST value '%s': %v\n", lastStr, err)
		os.Exit(1)
	}

	// LAST contains the next gallery to be rated, so process 1 to LAST-1
	galleriesCount := nextGallery - 1
	if galleriesCount <= 0 {
		fmt.Fprintf(os.Stderr, "No galleries to process (LAST=%d)\n", nextGallery)
		os.Exit(0)
	}

	fmt.Fprintf(os.Stderr, "Processing galleries 1-%d (LAST=%d is next to curate)\n", galleriesCount, nextGallery)

	// Resolve symlinks for yes/ and no/ directories
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

	// Check if we're in dry-run or commit mode
	if commitWrite {
		fmt.Fprintf(os.Stderr, "Commit mode: Will write no/ files\n")
	} else {
		fmt.Fprintf(os.Stderr, "Dry-run mode: No files will be written (use -commit to write)\n")
	}

	// Process galleries in parallel
	numWorkers := runtime.NumCPU()
	jobs := make(chan int, galleriesCount)
	results := make(chan galleryResult, galleriesCount)
	var wg sync.WaitGroup

	// Launch workers
	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for galleryNum := range jobs {
				result := processGallery(galleryNum, yesDir, noDir, commitWrite)
				results <- result
			}
		}()
	}

	// Send gallery numbers to workers
	for galleryNum := 1; galleryNum <= galleriesCount; galleryNum++ {
		jobs <- galleryNum
	}
	close(jobs)

	// Wait for all workers to finish
	go func() {
		wg.Wait()
		close(results)
	}()

	// Collect and sort results
	var allResults []galleryResult
	for result := range results {
		allResults = append(allResults, result)
	}
	sort.Slice(allResults, func(i, j int) bool {
		return allResults[i].galleryNum < allResults[j].galleryNum
	})

	// Print results in column-aligned format
	fmt.Fprintf(os.Stderr, "\n")
	for _, result := range allResults {
		if result.err != nil {
			fmt.Fprintf(os.Stderr, "Gallery %3d: ERROR: %v\n", result.galleryNum, result.err)
			continue
		}

		yesPercentage := 0.0
		if result.totalImages > 0 {
			yesPercentage = float64(result.yesCount) / float64(result.totalImages) * 100.0
		}

		if commitWrite {
			if result.deletedNoCount > 0 {
				fmt.Fprintf(os.Stderr, "Gallery %3d: %4d images | Yes: %4d (%5.1f%%) | No: %4d | Wrote: %4d | Deleted: %4d\n",
					result.galleryNum, result.totalImages, result.yesCount, yesPercentage,
					result.alreadyNoCount, result.writtenCount, result.deletedNoCount)
			} else {
				fmt.Fprintf(os.Stderr, "Gallery %3d: %4d images | Yes: %4d (%5.1f%%) | No: %4d | Wrote: %4d\n",
					result.galleryNum, result.totalImages, result.yesCount, yesPercentage,
					result.alreadyNoCount, result.writtenCount)
			}
		} else {
			if result.deletedNoCount > 0 {
				fmt.Fprintf(os.Stderr, "Gallery %3d: %4d images | Yes: %4d (%5.1f%%) | No: %4d | To mark: %4d | Would delete: %4d\n",
					result.galleryNum, result.totalImages, result.yesCount, yesPercentage,
					result.alreadyNoCount, result.toMarkNoCount, result.deletedNoCount)
			} else {
				fmt.Fprintf(os.Stderr, "Gallery %3d: %4d images | Yes: %4d (%5.1f%%) | No: %4d | To mark: %4d\n",
					result.galleryNum, result.totalImages, result.yesCount, yesPercentage,
					result.alreadyNoCount, result.toMarkNoCount)
			}
		}
	}

	// Calculate totals
	totalYes := 0
	totalAlreadyNo := 0
	totalToMarkNo := 0
	totalWritten := 0
	totalDeleted := 0
	for _, result := range allResults {
		if result.err == nil {
			totalYes += result.yesCount
			totalAlreadyNo += result.alreadyNoCount
			totalToMarkNo += result.toMarkNoCount
			totalWritten += result.writtenCount
			totalDeleted += result.deletedNoCount
		}
	}

	// Summary
	totalImages := totalYes + totalAlreadyNo + totalToMarkNo
	yesPercentage := 0.0
	if totalImages > 0 {
		yesPercentage = float64(totalYes) / float64(totalImages) * 100.0
	}

	fmt.Fprintf(os.Stderr, "\n=== Summary ===\n")
	fmt.Fprintf(os.Stderr, "Total galleries processed: %d\n", galleriesCount)
	fmt.Fprintf(os.Stderr, "Already marked yes: %d images (%.1f%%)\n", totalYes, yesPercentage)
	fmt.Fprintf(os.Stderr, "Already marked no:  %d images\n", totalAlreadyNo)
	if commitWrite {
		fmt.Fprintf(os.Stderr, "Wrote no/ files:    %d images\n", totalWritten)
		if totalDeleted > 0 {
			fmt.Fprintf(os.Stderr, "Deleted no/ files:  %d images (re-curated as yes)\n", totalDeleted)
		}
	} else {
		fmt.Fprintf(os.Stderr, "To mark as no:      %d images\n", totalToMarkNo)
		if totalDeleted > 0 {
			fmt.Fprintf(os.Stderr, "Would delete no/:   %d images (re-curated as yes)\n", totalDeleted)
		}
	}
	fmt.Fprintf(os.Stderr, "Total images:       %d\n", totalImages)

	if !commitWrite {
		fmt.Fprintf(os.Stderr, "\n⚠️  Dry-run mode: No files were written\n")
		fmt.Fprintf(os.Stderr, "Use -commit flag to actually write no/ files\n")
	} else {
		fmt.Fprintf(os.Stderr, "\n✓ Commit complete: Wrote %d no/ files", totalWritten)
		if totalDeleted > 0 {
			fmt.Fprintf(os.Stderr, ", deleted %d no/ files", totalDeleted)
		}
		fmt.Fprintf(os.Stderr, "\n")
	}

	// Collect all image IDs from all galleries
	var allImageIDs []string
	for _, result := range allResults {
		if result.err == nil {
			allImageIDs = append(allImageIDs, result.imageIDs...)
		}
	}

	// Sort image IDs
	sort.Strings(allImageIDs)

	// Write to tmp/g/index.txt
	indexPath := "tmp/g/index.txt"
	indexFile, err := os.Create(indexPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Warning: Failed to create %s: %v\n", indexPath, err)
		return
	}
	defer indexFile.Close()

	for _, imageID := range allImageIDs {
		fmt.Fprintf(indexFile, "%s\n", imageID)
	}

	fmt.Fprintf(os.Stderr, "Generated %s with %d image IDs\n", indexPath, len(allImageIDs))
}

// processGallery processes a single gallery and returns the results
func processGallery(galleryNum int, yesDir, noDir string, commitWrite bool) galleryResult {
	result := galleryResult{
		galleryNum: galleryNum,
	}

	galleryPath := fmt.Sprintf("tmp/g/%d/index.html", galleryNum)

	// Check if gallery exists
	if _, err := os.Stat(galleryPath); os.IsNotExist(err) {
		result.err = fmt.Errorf("gallery not found at %s", galleryPath)
		return result
	}

	// Extract image IDs from gallery HTML
	imageIDs, err := extractImageIDsFromGallery(galleryPath)
	if err != nil {
		result.err = fmt.Errorf("failed to extract images: %w", err)
		return result
	}

	result.totalImages = len(imageIDs)
	result.imageIDs = imageIDs

	// For each image, stat yes/ and no/ files to determine status
	for _, imageID := range imageIDs {
		yesPath := filepath.Join(yesDir, imageID+".png")
		noPath := filepath.Join(noDir, imageID+".png")

		// Check if marked as yes
		if _, err := os.Stat(yesPath); err == nil {
			result.yesCount++

			// If there's also a no/ file, delete it (gallery was re-curated)
			if _, err := os.Stat(noPath); err == nil {
				if commitWrite {
					if err := os.Remove(noPath); err == nil {
						result.deletedNoCount++
					}
				} else {
					// In dry-run mode, just count what would be deleted
					result.deletedNoCount++
				}
			}
			continue
		}

		// Check if already marked as no
		if _, err := os.Stat(noPath); err == nil {
			result.alreadyNoCount++
			continue
		}

		// Not marked as either - needs to be marked as no
		result.toMarkNoCount++

		// Write no/ file if in commit mode
		if commitWrite {
			noFilePath := filepath.Join(noDir, imageID+".png")
			f, err := os.Create(noFilePath)
			if err != nil {
				// Don't fail the whole gallery for one file error
				continue
			}
			f.Close()
			result.writtenCount++
		}
	}

	return result
}

// extractImageIDsFromGallery parses an HTML gallery file and extracts image IDs
// Equivalent to: cat tmp/g/N/index.html | grep blurhash: | cut -d'"' -f2 | cut -d. -f1
func extractImageIDsFromGallery(galleryPath string) ([]string, error) {
	file, err := os.Open(galleryPath)
	if err != nil {
		return nil, fmt.Errorf("failed to open gallery: %w", err)
	}
	defer file.Close()

	var imageIDs []string
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()

		// Look for lines containing "blurhash:"
		if strings.Contains(line, "blurhash:") {
			// Find the quoted value after blurhash:
			// Line format is something like: "filename.png": { width: 512, height: 512, blurhash: "..." }
			// We want to extract the key (filename.png) and remove the extension

			// Find the first quote before blurhash:
			beforeBlurhash := strings.Split(line, "blurhash:")[0]

			// Look for the pattern: "something.png":
			if idx := strings.LastIndex(beforeBlurhash, "\""); idx != -1 {
				// Get everything before this quote
				beforeQuote := beforeBlurhash[:idx]
				// Find the opening quote
				if startIdx := strings.LastIndex(beforeQuote, "\""); startIdx != -1 {
					filename := beforeQuote[startIdx+1:]
					// Remove extension
					if dotIdx := strings.LastIndex(filename, "."); dotIdx != -1 {
						imageID := filename[:dotIdx]
						imageIDs = append(imageIDs, imageID)
					}
				}
			}
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("error reading gallery: %w", err)
	}

	return imageIDs, nil
}
