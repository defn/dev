package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	urlpkg "net/url"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	_ "github.com/mattn/go-sqlite3"
)

func downloadMode() {
	fmt.Fprintf(os.Stderr, "Download mode: Downloading images and generating thumbnails\n")

	// Open database
	dbPath := "cv.db"
	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error opening database: %v\n", err)
		os.Exit(1)
	}
	defer db.Close()

	// Ensure url column exists (will be added by import mode, but check here too)
	db.Exec("ALTER TABLE images ADD COLUMN url TEXT")

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

	// Process JSON files in parallel
	numWorkers := runtime.NumCPU()
	fmt.Fprintf(os.Stderr, "Processing JSON files with %d workers...\n", numWorkers)

	jobs := make(chan string, len(matches))
	type urlResult struct {
		imageID string
		url     string
	}
	results := make(chan urlResult, 1000000) // Large buffer for results
	var wg sync.WaitGroup
	var processedFiles atomic.Int32

	// Launch workers
	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for jsonFile := range jobs {
				urls, err := extractURLsFromFile(jsonFile)
				if err != nil {
					fmt.Fprintf(os.Stderr, "Error extracting URLs from %s: %v\n", jsonFile, err)
					processedFiles.Add(1)
					continue
				}

				for _, url := range urls {
					// Extract image ID from URL filename
					parts := strings.Split(url, "/")
					if len(parts) < 2 {
						continue
					}
					filename := parts[len(parts)-1]
					// Remove file extension to get image ID
					imageID := filename
					if idx := strings.LastIndex(imageID, "."); idx != -1 {
						imageID = imageID[:idx]
					}

					results <- urlResult{imageID: imageID, url: url}
				}

				// Report progress every 1000 files
				processed := processedFiles.Add(1)
				if processed%1000 == 0 {
					fmt.Fprintf(os.Stderr, "Processed %d/%d JSON files...\n", processed, len(matches))
				}
			}
		}()
	}

	// Send JSON files to workers
	for _, jsonFile := range matches {
		jobs <- jsonFile
	}
	close(jobs)

	// Start consuming results immediately to avoid blocking workers
	insertedCount := 0
	urlCount := 0
	resultsDone := make(chan bool)

	go func() {
		batch := make([]urlResult, 0, 50000)

		for result := range results {
			urlCount++

			// Report URL processing progress
			if urlCount%50000 == 0 {
				fmt.Fprintf(os.Stderr, "Processed %d URLs from workers...\n", urlCount)
			}

			batch = append(batch, result)

			// Insert batch when it reaches 50000
			if len(batch) >= 50000 {
				tx, err := db.Begin()
				if err != nil {
					fmt.Fprintf(os.Stderr, "Warning: Failed to begin transaction: %v\n", err)
					continue
				}

				stmt, err := tx.Prepare(`INSERT INTO images (id, url) VALUES (?, ?) ON CONFLICT(id) DO UPDATE SET url = excluded.url`)
				if err != nil {
					fmt.Fprintf(os.Stderr, "Warning: Failed to prepare statement: %v\n", err)
					tx.Rollback()
					continue
				}

				for _, r := range batch {
					if _, err := stmt.Exec(r.imageID, r.url); err != nil {
						fmt.Fprintf(os.Stderr, "Warning: Failed to insert URL for %s: %v\n", r.imageID, err)
					}
				}
				stmt.Close()

				if err := tx.Commit(); err != nil {
					fmt.Fprintf(os.Stderr, "Warning: Failed to commit transaction: %v\n", err)
					tx.Rollback()
				} else {
					insertedCount += len(batch)
					if insertedCount%500000 == 0 {
						fmt.Fprintf(os.Stderr, "Inserted %d URLs...\n", insertedCount)
					}
				}

				batch = batch[:0] // Clear batch
			}
		}

		// Insert remaining batch
		if len(batch) > 0 {
			tx, err := db.Begin()
			if err == nil {
				stmt, err := tx.Prepare(`INSERT INTO images (id, url) VALUES (?, ?) ON CONFLICT(id) DO UPDATE SET url = excluded.url`)
				if err == nil {
					for _, r := range batch {
						stmt.Exec(r.imageID, r.url)
					}
					stmt.Close()
					tx.Commit()
					insertedCount += len(batch)
				} else {
					tx.Rollback()
				}
			}
		}

		resultsDone <- true
	}()

	// Wait for workers to finish processing all JSON files
	wg.Wait()
	fmt.Fprintf(os.Stderr, "Processed %d/%d JSON files - Complete\n", len(matches), len(matches))
	close(results)

	// Wait for all results to be inserted
	<-resultsDone
	fmt.Fprintf(os.Stderr, "Processed %d total URLs, inserted/updated %d unique URLs in database\n", urlCount, insertedCount)

	// Generate downloads.txt from database: images with url set but no img_path (not downloaded yet)
	rows, err := db.Query(`
		SELECT url FROM images
		WHERE url IS NOT NULL
		AND (img_path IS NULL OR img_path = '')
		ORDER BY url
	`)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error querying database for downloads: %v\n", err)
		os.Exit(1)
	}
	defer rows.Close()

	var urlsToDownload []string
	for rows.Next() {
		var url string
		if err := rows.Scan(&url); err != nil {
			fmt.Fprintf(os.Stderr, "Error scanning row: %v\n", err)
			continue
		}
		urlsToDownload = append(urlsToDownload, url)
	}

	fmt.Fprintf(os.Stderr, "Found %d images to download (have URL but no img_path)\n", len(urlsToDownload))

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

	// Extract domain from URL for Referer header
	parsedURL, err := urlpkg.Parse(url)
	referer := url // fallback to full URL
	if err == nil && parsedURL.Scheme != "" && parsedURL.Host != "" {
		referer = parsedURL.Scheme + "://" + parsedURL.Host + "/"
	}

	// Use curl to download with browser-like headers
	cmd := exec.Command("curl",
		"-s",                 // silent
		"-L",                 // follow redirects
		"-w", "%{http_code}", // write HTTP status code
		"-o", tmpPath, // output to temp file
		"-A", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
		"-H", "Accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
		"-H", "Accept-Language: en-US,en;q=0.9",
		"-H", "Referer: "+referer,
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
