package main

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"sync"
)

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
