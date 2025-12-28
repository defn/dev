package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
	"sync"
	"time"
)

func batchProcessAllGalleries() {
	fmt.Fprintf(os.Stderr, "Batch mode: Processing all w-* galleries\n")

	// Set defaults for batch mode
	cacheDir = "tmp/blur"
	selectMode = "navigate" // All galleries use navigate mode

	// Ensure cache directory exists
	if err := os.MkdirAll(cacheDir, 0755); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating cache directory: %v\n", err)
		os.Exit(1)
	}

	// Find all w-?? and w-??? directories in pub/fm/
	sourceBase := "pub/fm"
	entries, err := ioutil.ReadDir(sourceBase)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading %s: %v\n", sourceBase, err)
		os.Exit(1)
	}

	var wDirs []string
	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}
		name := entry.Name()
		// Match w-?? or w-???
		if (len(name) == 4 && strings.HasPrefix(name, "w-")) ||
			(len(name) == 5 && strings.HasPrefix(name, "w-")) {
			wDirs = append(wDirs, name)
		}
	}

	sort.Strings(wDirs)
	fmt.Fprintf(os.Stderr, "Found %d w-* directories to process\n", len(wDirs))

	// Process w-* directories in parallel with worker pool
	numWorkers := 8
	jobs := make(chan string, len(wDirs))
	var wg sync.WaitGroup

	// Track completion status for debugging
	type WorkerStatus struct {
		sync.Mutex
		perWComplete   bool
		masterComplete bool
		fmHtmlComplete bool
		wWorkersActive int
		wWorkersTotal  int
	}
	status := &WorkerStatus{wWorkersTotal: numWorkers}

	// Launch per-W gallery processing in parallel
	wg.Add(1)
	go func() {
		defer wg.Done()
		defer func() {
			status.Lock()
			status.perWComplete = true
			fmt.Fprintf(os.Stderr, "[Per-W] Worker completed\n")
			status.Unlock()
		}()
		generatePerWGalleries(sourceBase)
	}()

	// Launch fm.html generation in parallel
	wg.Add(1)
	go func() {
		defer wg.Done()
		defer func() {
			status.Lock()
			status.fmHtmlComplete = true
			fmt.Fprintf(os.Stderr, "[FM-HTML] Worker completed\n")
			status.Unlock()
		}()
		generateGalleryIndex()
	}()

	// Launch master gallery processing in parallel
	wg.Add(1)
	go func() {
		defer wg.Done()
		defer func() {
			status.Lock()
			status.masterComplete = true
			fmt.Fprintf(os.Stderr, "[Master] Worker completed\n")
			status.Unlock()
		}()
		fmt.Fprintf(os.Stderr, "\n[Master] === Generating master gallery at pub/w/g/ ===\n")

		// Parallelize image collection from all w-* directories
		collectionJobs := make(chan string, len(wDirs))
		collectionResults := make(chan []ImageInfo, len(wDirs))
		var collectionWg sync.WaitGroup

		// Launch 8 workers to collect images in parallel
		var collectedCount int
		var collectedMutex sync.Mutex
		for w := 0; w < 8; w++ {
			collectionWg.Add(1)
			go func(workerID int) {
				defer collectionWg.Done()
				for wDir := range collectionJobs {
					wPath := filepath.Join(sourceBase, wDir)
					pngFiles, err := filepath.Glob(filepath.Join(wPath, "*.png"))
					if err != nil {
						continue
					}
					var dirImages []ImageInfo
					for _, pngPath := range pngFiles {
						relPath, _ := filepath.Rel(sourceBase, pngPath)
						dirImages = append(dirImages, ImageInfo{
							Filename: relPath,
						})
					}
					if len(dirImages) > 0 {
						collectionResults <- dirImages
					}

					// Report progress every 100 directories
					collectedMutex.Lock()
					collectedCount++
					if collectedCount%100 == 0 || collectedCount == len(wDirs) {
						fmt.Fprintf(os.Stderr, "[Master] Collected from %d/%d directories\n", collectedCount, len(wDirs))
					}
					collectedMutex.Unlock()
				}
			}(w)
		}

		// Send all w-* directories to collection workers
		for _, wDir := range wDirs {
			collectionJobs <- wDir
		}
		close(collectionJobs)

		// Wait for collection to finish and close results
		go func() {
			collectionWg.Wait()
			close(collectionResults)
		}()

		// Merge all collected images
		var allImages []ImageInfo
		for dirImages := range collectionResults {
			allImages = append(allImages, dirImages...)
		}

		fmt.Fprintf(os.Stderr, "[Master] Collected %d images from %d directories\n", len(allImages), len(wDirs))

		// Shuffle the images
		for i := len(allImages) - 1; i > 0; i-- {
			j := int(time.Now().UnixNano()) % (i + 1)
			allImages[i], allImages[j] = allImages[j], allImages[i]
		}

		fmt.Fprintf(os.Stderr, "[Master] Found %d total images for master gallery\n", len(allImages))

		if len(allImages) > 0 {
			processGalleryWithPathsLabeled(allImages, sourceBase, "pub/w/g", "[Master]")
		}
	}()

	// Launch workers for w-* directories
	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			defer func() {
				status.Lock()
				status.wWorkersActive--
				fmt.Fprintf(os.Stderr, "[Worker %d] Completed all jobs\n", workerID)
				status.Unlock()
			}()

			status.Lock()
			status.wWorkersActive++
			status.Unlock()

			for wDir := range jobs {
				fmt.Fprintf(os.Stderr, "\n[Worker %d] === Processing %s ===\n", workerID, wDir)

				imgDir := filepath.Join(sourceBase, wDir)
				outDir := filepath.Join("pub/w", wDir)

				// Get list of PNG files in this directory
				pngFiles, err := filepath.Glob(filepath.Join(imgDir, "*.png"))
				if err != nil {
					fmt.Fprintf(os.Stderr, "[Worker %d] Error listing PNG files in %s: %v\n", workerID, wDir, err)
					continue
				}

				// Extract basenames
				var imageInfos []ImageInfo
				for _, pngPath := range pngFiles {
					basename := filepath.Base(pngPath)
					imageInfos = append(imageInfos, ImageInfo{
						Filename: basename,
					})
				}

				// Sort by filename
				sort.Slice(imageInfos, func(i, j int) bool {
					return imageInfos[i].Filename < imageInfos[j].Filename
				})

				fmt.Fprintf(os.Stderr, "[Worker %d] Found %d images in %s\n", workerID, len(imageInfos), wDir)

				if len(imageInfos) > 0 {
					// Process this gallery with its own imageDir/outputDir
					processGalleryWithPaths(imageInfos, imgDir, outDir)
				}
			}
		}(w)
	}

	// Send all w-* directories to workers
	for _, wDir := range wDirs {
		jobs <- wDir
	}
	close(jobs)

	// Launch watchdog to monitor goroutine count
	done := make(chan bool)
	go func() {
		ticker := time.NewTicker(5 * time.Second)
		defer ticker.Stop()

		lastCount := runtime.NumGoroutine()
		sameCountIterations := 0

		for {
			select {
			case <-done:
				return
			case <-ticker.C:
				currentCount := runtime.NumGoroutine()

				// Get current worker status
				status.Lock()
				perWDone := status.perWComplete
				masterDone := status.masterComplete
				fmHtmlDone := status.fmHtmlComplete
				wActive := status.wWorkersActive
				wTotal := status.wWorkersTotal
				status.Unlock()

				// Print detailed status
				fmt.Fprintf(os.Stderr, "[Watchdog] Goroutines: %d | Per-W: %v | Master: %v | FM-HTML: %v | W-Workers: %d/%d active\n",
					currentCount, perWDone, masterDone, fmHtmlDone, wActive, wTotal)

				// If count hasn't changed, increment counter
				if currentCount == lastCount {
					sameCountIterations++
				} else {
					sameCountIterations = 0
				}
				lastCount = currentCount

				// If only 2 goroutines remain (main + watchdog) for 10 seconds, exit
				if currentCount <= 2 && sameCountIterations >= 2 {
					fmt.Fprintf(os.Stderr, "[Watchdog] Only monitoring goroutine remains, exiting.\n")
					os.Exit(0)
				}

				// If stuck at same count for 30 seconds (6 iterations), warn
				if sameCountIterations >= 6 {
					fmt.Fprintf(os.Stderr, "[Watchdog] WARNING: Goroutine count stuck at %d for %d seconds\n",
						currentCount, sameCountIterations*5)
					fmt.Fprintf(os.Stderr, "[Watchdog] Status: Per-W=%v, Master=%v, FM-HTML=%v, W-Workers=%d/%d\n",
						perWDone, masterDone, fmHtmlDone, wActive, wTotal)
				}
			}
		}
	}()

	// Wait for all workers (including master gallery and per-W) to finish
	fmt.Fprintf(os.Stderr, "\n=== Waiting for all workers to complete... ===\n")
	wg.Wait()

	// Signal watchdog to stop
	close(done)

	fmt.Fprintf(os.Stderr, "\n=== All galleries generated successfully! ===\n")
	fmt.Fprintf(os.Stderr, "Processed %d w-* directories, master gallery, and per-template galleries\n", len(wDirs))
}
func generatePerWGalleries(sourceBase string) {
	fmt.Fprintf(os.Stderr, "\n[Per-W] === Generating per-template galleries ===\n")

	// Find all template files in pub/fm/W/
	wDir := filepath.Join(sourceBase, "W")
	fmt.Fprintf(os.Stderr, "[Per-W] Reading directory %s...\n", wDir)
	files, err := ioutil.ReadDir(wDir)
	if err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error reading %s: %v\n", wDir, err)
		return
	}

	var templateFiles []string
	for _, file := range files {
		if !file.IsDir() {
			templateFiles = append(templateFiles, file.Name())
		}
	}

	sort.Strings(templateFiles)
	fmt.Fprintf(os.Stderr, "[Per-W] Found %d template files\n", len(templateFiles))

	// Build an index of all variants to avoid expensive Glob operations
	fmt.Fprintf(os.Stderr, "[Per-W] Building variant index from w-* directories...\n")

	// Find all w-* entries and filter to only directories
	wMatches, err := filepath.Glob(filepath.Join(sourceBase, "w-*"))
	if err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error finding w-* entries: %v\n", err)
		return
	}

	var wDirs []string
	for _, match := range wMatches {
		info, err := os.Stat(match)
		if err == nil && info.IsDir() {
			wDirs = append(wDirs, match)
		}
	}
	fmt.Fprintf(os.Stderr, "[Per-W] Found %d w-* directories to scan\n", len(wDirs))

	// Build index in parallel with 8 workers
	type indexEntry struct {
		template string
		variant  string
	}
	indexJobs := make(chan string, len(wDirs))
	indexResults := make(chan indexEntry, 100000) // Buffer for results
	var indexWg sync.WaitGroup

	scannedCount := 0
	var scannedMutex sync.Mutex

	// Launch workers to scan directories
	for w := 0; w < 8; w++ {
		indexWg.Add(1)
		go func(workerID int) {
			defer indexWg.Done()
			for wDir := range indexJobs {
				files, err := ioutil.ReadDir(wDir)
				if err != nil {
					continue
				}
				for _, file := range files {
					if file.IsDir() {
						continue
					}
					filename := file.Name()
					lastDash := strings.LastIndex(filename, "-")
					if lastDash > 0 && lastDash < len(filename)-1 {
						templateName := filename[lastDash+1:]
						variantPath := filepath.Join(wDir, filename)
						indexResults <- indexEntry{template: templateName, variant: variantPath}
					}
				}

				scannedMutex.Lock()
				scannedCount++
				if scannedCount%100 == 0 || scannedCount == len(wDirs) {
					fmt.Fprintf(os.Stderr, "[Per-W] Scanned %d/%d directories\n", scannedCount, len(wDirs))
				}
				scannedMutex.Unlock()
			}
		}(w)
	}

	// Send directories to workers
	for _, wDir := range wDirs {
		indexJobs <- wDir
	}
	close(indexJobs)

	// Close results channel when all workers are done
	go func() {
		indexWg.Wait()
		close(indexResults)
	}()

	// Collect results into index
	variantIndex := make(map[string][]string)
	for entry := range indexResults {
		variantIndex[entry.template] = append(variantIndex[entry.template], entry.variant)
	}

	fmt.Fprintf(os.Stderr, "[Per-W] Built index with %d templates having variants\n", len(variantIndex))

	// Create output directory
	fmt.Fprintf(os.Stderr, "[Per-W] Creating output directory pub/W...\n")
	if err := os.MkdirAll("pub/W", 0755); err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error creating pub/W: %v\n", err)
		return
	}

	// Process templates in parallel (8 workers)
	numWorkers := 8
	jobs := make(chan string, len(templateFiles))
	thumbnails := make(chan string, len(templateFiles))
	var wg sync.WaitGroup

	// Launch workers
	fmt.Fprintf(os.Stderr, "[Per-W] Launching %d workers...\n", numWorkers)
	processedCount := 0
	var countMutex sync.Mutex
	for w := 0; w < numWorkers; w++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			fmt.Fprintf(os.Stderr, "[Per-W Worker %d] Started\n", workerID)
			jobCount := 0
			for templateFile := range jobs {
				jobCount++
				if jobCount == 1 || jobCount%100 == 0 {
					fmt.Fprintf(os.Stderr, "[Per-W Worker %d] Processing job %d: %s\n", workerID, jobCount, templateFile)
				}
				thumbnail := generatePerWPageWithIndex(sourceBase, templateFile, variantIndex)
				thumbnails <- thumbnail

				// Report progress every 1000 files
				countMutex.Lock()
				processedCount++
				if processedCount%1000 == 0 || processedCount == len(templateFiles) {
					fmt.Fprintf(os.Stderr, "[Per-W] Processed %d/%d templates\n", processedCount, len(templateFiles))
				}
				countMutex.Unlock()
			}
			fmt.Fprintf(os.Stderr, "[Per-W Worker %d] Finished processing %d jobs\n", workerID, jobCount)
		}(w)
	}

	// Send all template files to workers
	fmt.Fprintf(os.Stderr, "[Per-W] Sending %d template files to job queue...\n", len(templateFiles))
	for i, templateFile := range templateFiles {
		if i == 0 || i%1000 == 0 || i == len(templateFiles)-1 {
			fmt.Fprintf(os.Stderr, "[Per-W] Queued %d/%d files\n", i+1, len(templateFiles))
		}
		jobs <- templateFile
	}
	close(jobs)
	fmt.Fprintf(os.Stderr, "[Per-W] All template files queued, jobs channel closed\n")

	// Wait for all workers to finish
	fmt.Fprintf(os.Stderr, "[Per-W] Launching goroutine to wait for workers and close thumbnails channel...\n")
	go func() {
		fmt.Fprintf(os.Stderr, "[Per-W Closer] Waiting for workers to finish...\n")
		wg.Wait()
		fmt.Fprintf(os.Stderr, "[Per-W Closer] All workers done, closing thumbnails channel\n")
		close(thumbnails)
	}()

	// Collect thumbnails for master index
	fmt.Fprintf(os.Stderr, "[Per-W] Collecting thumbnails for master index...\n")
	var masterIndex strings.Builder
	collectedThumbnails := 0
	for thumbnail := range thumbnails {
		masterIndex.WriteString(thumbnail)
		masterIndex.WriteString("\n")
		collectedThumbnails++
		if collectedThumbnails%1000 == 0 {
			fmt.Fprintf(os.Stderr, "[Per-W] Collected %d/%d thumbnails\n", collectedThumbnails, len(templateFiles))
		}
	}
	fmt.Fprintf(os.Stderr, "[Per-W] Finished collecting %d thumbnails\n", collectedThumbnails)

	// Write master index file
	fmt.Fprintf(os.Stderr, "[Per-W] Writing pub/W.html with %d thumbnails...\n", collectedThumbnails)
	if err := ioutil.WriteFile("pub/W.html", []byte(masterIndex.String()), 0644); err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error writing pub/W.html: %v\n", err)
		return
	}

	fmt.Fprintf(os.Stderr, "[Per-W] Completed! Generated pub/W.html and %d detail pages\n", len(templateFiles))
}

// generatePerWPageWithIndex creates a detail page using pre-built variant index
// Returns the thumbnail HTML for the master index
func generatePerWPageWithIndex(sourceBase, templateFile string, variantIndex map[string][]string) string {
	// Look up variants from index instead of expensive Glob
	variants, ok := variantIndex[templateFile]
	if !ok || len(variants) == 0 {
		// No variants found for this template
		return ""
	}

	// Variants are already collected, just need to sort
	sortedVariants := make([]string, len(variants))
	copy(sortedVariants, variants)
	sort.Strings(sortedVariants)

	// Use sorted variants
	variants = sortedVariants

	// Generate detail page HTML
	var detailPage strings.Builder
	detailPage.WriteString(`<!DOCTYPE html>
  <html>
  <head>
    <title>Gallery</title>
  </head>
  <body>
    <div id="gallery-container"></div>
    <script>
    function generateGalleryImageTag(imageSrc) {
      try {
        const urlObj = new URL(window.location.href);
        const pageParam = urlObj.searchParams.get('page');
        if (!pageParam) {
          throw new Error('Missing page parameter');
        }
        const anchor = urlObj.hash.replace('#', '');
        if (!anchor) {
          throw new Error('Missing anchor fragment');
        }
        const imageSrcMatch = imageSrc.match(/\/w-(\d+)\//);
        if (!imageSrcMatch) {
          throw new Error('Invalid imageSrc format - missing w-NN directory');
        }
        const wPrefix = ` + "`w-${imageSrcMatch[1]}`" + `;
        const uuid = anchor.replace(/^w-\d+-/, '');
        const galleryPath = ` + "`../w/${wPrefix}/${pageParam}/#${wPrefix}-${uuid}`" + `;
        return ` + "`<a href=\"${galleryPath}\"><img src=\"${imageSrc}\"></a>`" + `;
      } catch (error) {
        console.error('Error generating gallery image tag:', error.message);
        return ` + "`<img src=\"${imageSrc}\">`" + `;
      }
    }
`)

	// Add JavaScript lines to populate gallery
	for _, variant := range variants {
		// Convert absolute path to relative path from pub/W/
		relPath, _ := filepath.Rel("pub", variant)
		detailPage.WriteString(fmt.Sprintf("    document.getElementById('gallery-container').innerHTML += generateGalleryImageTag('../%s');\n", relPath))
	}

	detailPage.WriteString(`    </script>
  </body>
  </html>
`)

	// Write detail page
	detailPath := filepath.Join("pub/W", templateFile+".html")
	if err := ioutil.WriteFile(detailPath, []byte(detailPage.String()), 0644); err != nil {
		fmt.Fprintf(os.Stderr, "[Per-W] Error writing %s: %v\n", detailPath, err)
	}

	// Return thumbnail HTML for master index
	return fmt.Sprintf("<a href=\"W/%s.html\"><img src=\"fm/W/%s\"></a>", templateFile, templateFile)
}
func generateGalleryIndex() {
	fmt.Fprintf(os.Stderr, "Generating gallery index...\n")

	// Read w-??.png and w-???.png files from pub/fm directory
	pattern1 := filepath.Join("pub/fm", "w-??.png")
	pattern2 := filepath.Join("pub/fm", "w-???.png")

	matches1, _ := filepath.Glob(pattern1)
	matches2, _ := filepath.Glob(pattern2)

	allMatches := append(matches1, matches2...)

	// Sort by modification time
	type fileWithTime struct {
		path    string
		modTime time.Time
	}

	var files []fileWithTime
	for _, match := range allMatches {
		info, err := os.Stat(match)
		if err != nil {
			continue
		}
		files = append(files, fileWithTime{match, info.ModTime()})
	}

	// Sort by modification time (oldest first, like ls -trh)
	sort.Slice(files, func(i, j int) bool {
		return files[i].modTime.Before(files[j].modTime)
	})

	// Generate HTML content
	var html strings.Builder
	for _, f := range files {
		basename := filepath.Base(f.path)
		nameWithoutExt := strings.TrimSuffix(basename, ".png")

		html.WriteString(`<span style="white-space: nowrap;">`)
		html.WriteString("\n")

		// Generate links to 4 variants
		for i := 0; i < 4; i++ {
			variantFile := fmt.Sprintf("%s/%s-%08d-%04d-%04d-%04d-%012d.png",
				nameWithoutExt, nameWithoutExt, 0, 0, 0, 0, i)
			html.WriteString(fmt.Sprintf(`<a href="/pub/w/%s/"><img style="vertical-align: top;" src="%s"></a>`,
				nameWithoutExt, variantFile))
			html.WriteString("\n")
		}

		// Link to the main reference image
		html.WriteString(fmt.Sprintf(`<a href="/pub/w/%s/"><img style="vertical-align: top;" src="%s" width=300></a>`,
			nameWithoutExt, basename))
		html.WriteString("\n")
		html.WriteString(`</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`)
		html.WriteString("\n")
	}

	// Create fm directory if it doesn't exist
	os.MkdirAll("pub/fm", 0755)

	// Write HTML to pub/fm/fm.html
	err := ioutil.WriteFile("pub/fm/fm.html", []byte(html.String()), 0644)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error writing gallery index: %v\n", err)
		return
	}

	fmt.Fprintf(os.Stderr, "Gallery index generated at pub/fm/fm.html\n")
}
