package main

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

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

		// Preserve actual file extension and subdirectory structure
		imageInfo := ImageInfo{
			Filename: relPath,
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
