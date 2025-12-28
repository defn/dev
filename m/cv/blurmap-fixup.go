package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
)

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
