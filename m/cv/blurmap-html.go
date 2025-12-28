package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"
)

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
