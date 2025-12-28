package main

import (
	"database/sql"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"sync"

	_ "github.com/mattn/go-sqlite3"
)

func importMode() {
	dbPath := "cv.db"

	// Open database
	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error opening database: %v\n", err)
		os.Exit(1)
	}
	defer db.Close()

	// Create base table
	schema := `
CREATE TABLE IF NOT EXISTS images (
    id TEXT PRIMARY KEY,
    state TEXT CHECK(state IN ('yes', 'no') OR state IS NULL),
    img_path TEXT,
    thumb_path TEXT,
    upres_img_path TEXT,
    upres_thumb_path TEXT
);
`

	if _, err := db.Exec(schema); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating schema: %v\n", err)
		os.Exit(1)
	}

	// Migrate existing database - add columns if they don't exist (silently ignore errors if columns exist)
	db.Exec("ALTER TABLE images ADD COLUMN width INTEGER")
	db.Exec("ALTER TABLE images ADD COLUMN height INTEGER")
	db.Exec("ALTER TABLE images ADD COLUMN weird TEXT")

	// Create indexes after columns exist
	indexes := `
CREATE INDEX IF NOT EXISTS idx_images_state ON images(state);
CREATE INDEX IF NOT EXISTS idx_images_thumb ON images(thumb_path) WHERE thumb_path IS NULL;
CREATE INDEX IF NOT EXISTS idx_images_weird ON images(weird) WHERE weird IS NOT NULL;
`
	if _, err := db.Exec(indexes); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating indexes: %v\n", err)
		os.Exit(1)
	}

	// Clear weird column at start of import run
	fmt.Fprintf(os.Stderr, "Clearing weird column for fresh import...\n")
	if _, err := db.Exec("UPDATE images SET weird = NULL WHERE weird IS NOT NULL"); err != nil {
		fmt.Fprintf(os.Stderr, "Error clearing weird column: %v\n", err)
		os.Exit(1)
	}

	// Run parallel import for yes/, no/, img/, thumbs/
	fmt.Fprintf(os.Stderr, "Starting parallel import of yes/, no/, img/, thumbs/...\n")
	if err := parallelImport(db); err != nil {
		fmt.Fprintf(os.Stderr, "Error during parallel import: %v\n", err)
		os.Exit(1)
	}

	fmt.Fprintf(os.Stderr, "Importing upres thumbnails from replicate/t2/ directory...\n")
	if err := importUpresPath(db, "replicate/t2", "upres_thumb_path"); err != nil {
		fmt.Fprintf(os.Stderr, "Error importing replicate/t2/: %v\n", err)
		os.Exit(1)
	}

	fmt.Fprintf(os.Stderr, "Importing upres images from replicate/img/ directory...\n")
	if err := importUpresPath(db, "replicate/img", "upres_img_path"); err != nil {
		fmt.Fprintf(os.Stderr, "Error importing replicate/img/: %v\n", err)
		os.Exit(1)
	}

	// Report statistics
	var yesCount, noCount, todoCount, thumbCount, upresThumbCount, upresImgCount int
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='yes'").Scan(&yesCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='no'").Scan(&noCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state IS NULL").Scan(&todoCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE thumb_path IS NOT NULL").Scan(&thumbCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_thumb_path IS NOT NULL").Scan(&upresThumbCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_img_path IS NOT NULL").Scan(&upresImgCount)

	fmt.Fprintf(os.Stderr, "\nImport complete:\n")
	fmt.Fprintf(os.Stderr, "  Approved (yes): %d\n", yesCount)
	fmt.Fprintf(os.Stderr, "  Rejected (no): %d\n", noCount)
	fmt.Fprintf(os.Stderr, "  Todo (null): %d\n", todoCount)
	fmt.Fprintf(os.Stderr, "  With thumbnails: %d\n", thumbCount)
	fmt.Fprintf(os.Stderr, "  With upres thumbnails: %d\n", upresThumbCount)
	fmt.Fprintf(os.Stderr, "  With upres images: %d\n", upresImgCount)

	// Report weird images
	var weirdCount int
	db.QueryRow("SELECT COUNT(*) FROM images WHERE weird IS NOT NULL").Scan(&weirdCount)
	if weirdCount > 0 {
		fmt.Fprintf(os.Stderr, "\nWeird images: %d (query: SELECT id, weird FROM images WHERE weird IS NOT NULL)\n", weirdCount)
	}

	// Report incomplete combinations
	fmt.Fprintf(os.Stderr, "\nIncomplete combinations (yes/todo only):\n")

	// 1. yes/todo without dimensions
	var noDimsCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE (state='yes' OR state IS NULL)
		AND (width IS NULL OR height IS NULL)`).Scan(&noDimsCount)
	if noDimsCount > 0 {
		fmt.Fprintf(os.Stderr, "  Yes/todo without dimensions: %d\n", noDimsCount)
	}

	// 2. yes/todo without img_path
	var noImgCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE (state='yes' OR state IS NULL)
		AND img_path IS NULL`).Scan(&noImgCount)
	if noImgCount > 0 {
		fmt.Fprintf(os.Stderr, "  Yes/todo without img_path: %d\n", noImgCount)
	}

	// 3. yes/todo without thumb_path
	var noThumbCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE (state='yes' OR state IS NULL)
		AND thumb_path IS NULL`).Scan(&noThumbCount)
	if noThumbCount > 0 {
		fmt.Fprintf(os.Stderr, "  Yes/todo without thumb_path: %d\n", noThumbCount)
	}

	// 4. yes/todo without both img and thumb
	var noBothCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE (state='yes' OR state IS NULL)
		AND img_path IS NULL AND thumb_path IS NULL`).Scan(&noBothCount)
	if noBothCount > 0 {
		fmt.Fprintf(os.Stderr, "  Yes/todo without img AND thumb (orphaned): %d\n", noBothCount)
	}

	// 5. upres_img_path without base img_path
	var upresImgOrphanCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE upres_img_path IS NOT NULL
		AND img_path IS NULL`).Scan(&upresImgOrphanCount)
	if upresImgOrphanCount > 0 {
		fmt.Fprintf(os.Stderr, "  Upres img without base img: %d\n", upresImgOrphanCount)
	}

	// 6. upres_thumb_path without base thumb_path
	var upresThumbOrphanCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE upres_thumb_path IS NOT NULL
		AND thumb_path IS NULL`).Scan(&upresThumbOrphanCount)
	if upresThumbOrphanCount > 0 {
		fmt.Fprintf(os.Stderr, "  Upres thumb without base thumb: %d\n", upresThumbOrphanCount)
	}

	// 7. Orphaned thumbnails (thumb only, no state, no img)
	var orphanedThumbCount int
	db.QueryRow(`SELECT COUNT(*) FROM images
		WHERE thumb_path IS NOT NULL
		AND state IS NULL
		AND img_path IS NULL`).Scan(&orphanedThumbCount)
	if orphanedThumbCount > 0 {
		fmt.Fprintf(os.Stderr, "  Orphaned thumbnails (thumb only, no img, no yes/no): %d\n", orphanedThumbCount)
	}

	// Summary
	totalIncomplete := noDimsCount + noImgCount + noThumbCount + upresImgOrphanCount + upresThumbOrphanCount
	if totalIncomplete == 0 {
		fmt.Fprintf(os.Stderr, "  None - all yes/todo images complete!\n")
	}

	// Validate file system consistency
	fmt.Fprintf(os.Stderr, "\nValidating file system consistency...\n")
	validateFileSystem(db)
}

// validateFileSystem checks for weird combinations in the database
func validateFileSystem(db *sql.DB) {
	// Check for zero-length img/ files without valid upres
	rows, err := db.Query(`SELECT id, img_path, upres_img_path FROM images WHERE img_path IS NOT NULL`)
	if err != nil {
		fmt.Fprintf(os.Stderr, "  ERROR: Failed to query images: %v\n", err)
		return
	}
	defer rows.Close()

	zeroLengthNoUpres := 0
	zeroLengthWithUpres := 0
	missingImgFile := 0
	missingUpresFile := 0

	for rows.Next() {
		var id, imgPath string
		var upresImgPath sql.NullString
		if err := rows.Scan(&id, &imgPath, &upresImgPath); err != nil {
			continue
		}

		// Check if img_path file exists and get size
		imgInfo, err := os.Stat(imgPath)
		if err != nil {
			missingImgFile++
			continue
		}

		// If img is zero-length, check for upres
		if imgInfo.Size() == 0 {
			hasValidUpres := false
			if upresImgPath.Valid && upresImgPath.String != "" {
				if upresInfo, err := os.Stat(upresImgPath.String); err == nil && upresInfo.Size() > 0 {
					hasValidUpres = true
					zeroLengthWithUpres++
				} else {
					missingUpresFile++
				}
			}

			if !hasValidUpres {
				zeroLengthNoUpres++
			}
		}
	}

	// Report findings
	if zeroLengthNoUpres > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: %d images have zero-length img_path without valid upres_img_path\n", zeroLengthNoUpres)
	}
	if zeroLengthWithUpres > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: %d images have zero-length img_path with valid upres_img_path (OK)\n", zeroLengthWithUpres)
	}
	if missingImgFile > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: %d images have missing img_path files\n", missingImgFile)
	}
	if missingUpresFile > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: %d images have missing upres_img_path files\n", missingUpresFile)
	}

	if zeroLengthNoUpres == 0 && missingImgFile == 0 && missingUpresFile == 0 {
		fmt.Fprintf(os.Stderr, "  OK: All images have valid file backing\n")
	}
}

// imageRecord represents a single image record from any import source
type imageRecord struct {
	id        string
	state     string // "yes", "no", or "" for NULL/todo
	imgPath   string
	thumbPath string
	width     int
	height    int
	sourceDir string // for logging
	weird     string // anomaly description, NULL if normal
}

// parallelImport imports yes/, no/, img/, thumbs/ in parallel
func parallelImport(db *sql.DB) error {
	// Channel for all import records
	recordChan := make(chan imageRecord, 100000)

	// Error channel
	errChan := make(chan error, 4)

	// WaitGroup for scanner goroutines
	var scanWg sync.WaitGroup

	// Start scanner goroutines
	scanWg.Add(4)

	// yes/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanYesDirectory(db, recordChan); err != nil {
			errChan <- fmt.Errorf("yes/ scanner: %w", err)
		}
	}()

	// no/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanNoDirectory(recordChan); err != nil {
			errChan <- fmt.Errorf("no/ scanner: %w", err)
		}
	}()

	// img/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanImgDirectory(db, recordChan); err != nil {
			errChan <- fmt.Errorf("img/ scanner: %w", err)
		}
	}()

	// thumbs/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanThumbsDirectory(db, recordChan); err != nil {
			errChan <- fmt.Errorf("thumbs/ scanner: %w", err)
		}
	}()

	// Close recordChan when all scanners finish
	go func() {
		scanWg.Wait()
		close(recordChan)
	}()

	// Database writer - single goroutine to avoid lock contention
	writerErr := databaseWriter(db, recordChan)

	// Check for scanner errors
	select {
	case err := <-errChan:
		return err
	default:
	}

	return writerErr
}

// databaseWriter processes records from channel and writes to database in batches
func databaseWriter(db *sql.DB, recordChan <-chan imageRecord) error {
	batch := make([]imageRecord, 0, 10000)
	count := 0
	yesToNoCount := 0
	noToYesCount := 0

	flushBatch := func() error {
		if len(batch) == 0 {
			return nil
		}

		tx, err := db.Begin()
		if err != nil {
			return err
		}
		defer tx.Rollback()

		// Check current state
		checkStmt, err := tx.Prepare("SELECT state FROM images WHERE id = ?")
		if err != nil {
			return err
		}
		defer checkStmt.Close()

		// Upsert statement
		upsertStmt, err := tx.Prepare(`
			INSERT INTO images (id, state, img_path, thumb_path, width, height, weird)
			VALUES (?, ?, ?, ?, ?, ?, ?)
			ON CONFLICT(id) DO UPDATE SET
				state = CASE
					WHEN excluded.state = 'yes' THEN 'yes'
					WHEN excluded.state = 'no' THEN 'no'
					WHEN excluded.state IS NULL THEN COALESCE(images.state, NULL)
					ELSE images.state
				END,
				img_path = COALESCE(excluded.img_path, images.img_path),
				thumb_path = COALESCE(excluded.thumb_path, images.thumb_path),
				width = COALESCE(NULLIF(excluded.width, 0), images.width),
				height = COALESCE(NULLIF(excluded.height, 0), images.height),
				weird = COALESCE(excluded.weird, images.weird)
		`)
		if err != nil {
			return err
		}
		defer upsertStmt.Close()

		for _, rec := range batch {
			// Check current state for transition logging
			var currentState sql.NullString
			err := checkStmt.QueryRow(rec.id).Scan(&currentState)

			weird := rec.weird

			// Log current and new state for debugging
			var currentStateStr, newStateStr string
			if err == sql.ErrNoRows {
				currentStateStr = "NEW"
			} else if err == nil {
				if currentState.Valid {
					currentStateStr = currentState.String
				} else {
					currentStateStr = "NULL"
				}
			}
			if rec.state == "" {
				newStateStr = "NULL"
			} else {
				newStateStr = rec.state
			}

			// Prevent yes -> no transition (yes cannot be downgraded)
			if err == nil && currentState.Valid && currentState.String == "yes" && rec.state == "no" {
				yesToNoCount++
				fmt.Fprintf(os.Stderr, "  WARNING: Image %s blocked downgrade %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)

				// If this conflict is from a no/ file, delete it
				if rec.sourceDir == "no/" {
					if removeErr := os.Remove(rec.imgPath); removeErr == nil {
						fmt.Fprintf(os.Stderr, "  INFO: Deleted conflicting no/ file: %s\n", rec.imgPath)
					} else {
						fmt.Fprintf(os.Stderr, "  ERROR: Failed to delete %s: %v\n", rec.imgPath, removeErr)
					}
				}

				continue // Skip this update
			}

			// Check for no -> yes transition
			if err == nil && currentState.Valid && currentState.String == "no" && rec.state == "yes" {
				noToYesCount++
				weirdMsg := fmt.Sprintf("no->yes transition from %s", rec.sourceDir)
				fmt.Fprintf(os.Stderr, "  WARNING: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
				if weird != "" {
					weird = weird + "; " + weirdMsg
				} else {
					weird = weirdMsg
				}
			}

			// Log other state transitions (NULL->no, NULL->yes, yes->NULL, no->NULL)
			if err == nil {
				if !currentState.Valid && rec.state == "no" {
					fmt.Fprintf(os.Stderr, "  INFO: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
				} else if !currentState.Valid && rec.state == "yes" {
					fmt.Fprintf(os.Stderr, "  INFO: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
				} else if currentState.Valid && rec.state == "" {
					fmt.Fprintf(os.Stderr, "  INFO: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
				}
			} else if err == sql.ErrNoRows {
				// New record
				if rec.state != "" {
					fmt.Fprintf(os.Stderr, "  INFO: Image %s created with state %s (from %s)\n", rec.id, newStateStr, rec.sourceDir)
				}
			}

			// Convert empty state to NULL
			var state interface{}
			if rec.state == "" {
				state = nil
			} else {
				state = rec.state
			}

			// Convert empty weird to NULL
			var weirdVal interface{}
			if weird != "" {
				weirdVal = weird
			} else {
				weirdVal = nil
			}

			// Execute upsert
			if _, err := upsertStmt.Exec(rec.id, state, rec.imgPath, rec.thumbPath, rec.width, rec.height, weirdVal); err != nil {
				return err
			}
		}

		if err := tx.Commit(); err != nil {
			return err
		}

		count += len(batch)
		if count%50000 == 0 {
			fmt.Fprintf(os.Stderr, "  Processed %d records...\n", count)
		}
		batch = batch[:0]
		return nil
	}

	// Process records from channel
	for rec := range recordChan {
		batch = append(batch, rec)

		if len(batch) >= 10000 {
			if err := flushBatch(); err != nil {
				return err
			}
		}
	}

	// Flush remaining
	if err := flushBatch(); err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Total records processed: %d\n", count)
	if yesToNoCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: %d attempts to downgrade from yes to no (blocked)\n", yesToNoCount)
	}
	if noToYesCount > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: %d images upgraded from no to yes\n", noToYesCount)
	}

	return nil
}

// scanYesDirectory scans yes/ and sends records to channel
func scanYesDirectory(db *sql.DB, recordChan chan<- imageRecord) error {
	realDir, err := filepath.EvalSymlinks("yes")
	if err != nil {
		return err
	}

	count := 0

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return err
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		ext := filepath.Ext(path)
		id := strings.TrimSuffix(basename, ext)

		// Check if dimensions already exist in DB
		var width, height int
		var existingWidth, existingHeight sql.NullInt64
		err = db.QueryRow("SELECT width, height FROM images WHERE id = ?", id).Scan(&existingWidth, &existingHeight)

		if err == sql.ErrNoRows || !existingWidth.Valid || !existingHeight.Valid || existingWidth.Int64 == 0 || existingHeight.Int64 == 0 {
			// Extract dimensions - missing or zero
			w, h, err := getImageDimensions(path)
			if err == nil {
				width, height = w, h
			}
		} else {
			// Use existing dimensions
			width = int(existingWidth.Int64)
			height = int(existingHeight.Int64)
		}

		recordChan <- imageRecord{
			id:        id,
			state:     "yes",
			imgPath:   path,
			width:     width,
			height:    height,
			sourceDir: "yes/",
		}

		count++
		if count%10000 == 0 {
			fmt.Fprintf(os.Stderr, "  Scanned %d images from yes/\n", count)
		}

		return nil
	})

	fmt.Fprintf(os.Stderr, "  Finished scanning yes/: %d images\n", count)

	return err
}

// scanNoDirectory scans no/ and sends records to channel
func scanNoDirectory(recordChan chan<- imageRecord) error {
	fmt.Fprintf(os.Stderr, "  Starting scan of no/ directory...\n")
	realDir, err := filepath.EvalSymlinks("no")
	if err != nil {
		return err
	}
	fmt.Fprintf(os.Stderr, "  Resolved no/ symlink to: %s\n", realDir)

	count := 0
	skippedDueToYes := 0
	checkedForYes := 0

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return err
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		ext := filepath.Ext(path)
		id := strings.TrimSuffix(basename, ext)

		// Skip if there's a yes/ file for this ID (yes takes precedence)
		checkedForYes++
		yesPath := filepath.Join("yes", id+".png")
		if _, statErr := os.Stat(yesPath); statErr == nil {
			// Delete the conflicting no/ file
			if removeErr := os.Remove(path); removeErr == nil {
				skippedDueToYes++
				if skippedDueToYes == 1 || skippedDueToYes%1000 == 0 {
					fmt.Fprintf(os.Stderr, "  INFO: Deleted %d of %d conflicting no/ files (yes/ file exists)\n", skippedDueToYes, checkedForYes)
				}
			} else {
				fmt.Fprintf(os.Stderr, "  ERROR: Failed to delete conflicting no/ file %s: %v\n", path, removeErr)
			}
			return nil
		}

		// If file is zero-length, check if there's a valid upres version
		if info.Size() == 0 {
			// Check if replicate/img/ has a non-zero file
			replicateImgPath := filepath.Join("replicate", "img", id+".png")
			if fi, err := os.Stat(replicateImgPath); err == nil && fi.Size() > 0 {
				// This is an upres'd image, skip it in no/ directory
				return nil
			}
		}

		recordChan <- imageRecord{
			id:        id,
			state:     "no",
			imgPath:   path,
			sourceDir: "no/",
		}

		count++
		if count%10000 == 0 {
			fmt.Fprintf(os.Stderr, "  Scanned %d images from no/\n", count)
		}

		return nil
	})

	fmt.Fprintf(os.Stderr, "  Finished scanning no/: %d images (checked %d for yes/ conflicts)\n", count, checkedForYes)
	if skippedDueToYes > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: Deleted %d of %d conflicting no/ files (yes/ file exists)\n", skippedDueToYes, checkedForYes)
	} else if checkedForYes > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: No yes/ conflicts found in %d no/ files checked\n", checkedForYes)
	}

	return err
}

// scanImgDirectory scans img/ and sends records to channel
func scanImgDirectory(db *sql.DB, recordChan chan<- imageRecord) error {
	realDir, err := filepath.EvalSymlinks("img")
	if err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Starting img/ scan with 8 workers...\n")

	// Process in chunks with worker pool
	chunkSize := 1000
	numWorkers := 8

	// Create work channel for chunks
	workChan := make(chan []string, numWorkers*2)

	// Counters (needs mutex for concurrent access)
	var mu sync.Mutex
	count := 0
	mp4Count := 0
	invalidCount := 0
	walkCount := 0

	// Start workers
	var wg sync.WaitGroup
	for i := 0; i < numWorkers; i++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			processImgChunk(db, workChan, recordChan, &mu, &count, &mp4Count, &invalidCount)
		}(i)
	}

	// Walk directory and send chunks to workers as we discover files
	var chunk []string
	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return err
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		walkCount++
		chunk = append(chunk, path)

		// Send chunk when it reaches size limit
		if len(chunk) >= chunkSize {
			workChan <- chunk
			chunk = make([]string, 0, chunkSize)

			if walkCount%10000 == 0 {
				fmt.Fprintf(os.Stderr, "  Walked %d files in img/\n", walkCount)
			}
		}

		return nil
	})

	// Send remaining files
	if len(chunk) > 0 {
		workChan <- chunk
	}

	close(workChan)
	wg.Wait()

	if err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Finished scanning img/: %d images\n", count)
	if mp4Count > 0 {
		fmt.Fprintf(os.Stderr, "  Auto-rejected %d .mp4 files\n", mp4Count)
	}
	if invalidCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Skipped %d files with invalid extensions\n", invalidCount)
	}

	return nil
}

// processImgChunk processes a chunk of img/ files
func processImgChunk(db *sql.DB, workChan <-chan []string, recordChan chan<- imageRecord, mu *sync.Mutex, count *int, mp4Count *int, invalidCount *int) {
	localCount := 0

	for chunk := range workChan {
		for _, path := range chunk {
			basename := filepath.Base(path)
			ext := strings.ToLower(filepath.Ext(path))
			id := strings.TrimSuffix(basename, filepath.Ext(path))

			switch ext {
			case ".jpeg", ".jpg", ".png":
				// Valid image - preserve existing state if yes/no, otherwise NULL
				var width, height int
				var existingState sql.NullString
				var existingWidth, existingHeight sql.NullInt64
				err := db.QueryRow("SELECT state, width, height FROM images WHERE id = ?", id).Scan(&existingState, &existingWidth, &existingHeight)

				// Preserve yes/no state, default to NULL for new or NULL records
				state := ""
				if err == nil && existingState.Valid && (existingState.String == "yes" || existingState.String == "no") {
					state = existingState.String
				}

				if err == sql.ErrNoRows || !existingWidth.Valid || !existingHeight.Valid || existingWidth.Int64 == 0 || existingHeight.Int64 == 0 {
					// Extract dimensions - missing or zero
					w, h, err := getImageDimensions(path)
					if err == nil {
						width, height = w, h
					}
				} else {
					// Use existing dimensions
					width = int(existingWidth.Int64)
					height = int(existingHeight.Int64)
				}

				recordChan <- imageRecord{
					id:        id,
					state:     state,
					imgPath:   path,
					width:     width,
					height:    height,
					sourceDir: "img/",
				}
				localCount++

			case ".mp4":
				// Auto-reject
				mu.Lock()
				(*mp4Count)++
				mu.Unlock()

				recordChan <- imageRecord{
					id:        id,
					state:     "no",
					imgPath:   path,
					sourceDir: "img/",
				}
				localCount++

			default:
				mu.Lock()
				(*invalidCount)++
				mu.Unlock()
				fmt.Fprintf(os.Stderr, "  WARNING: Invalid extension in img/: %s\n", basename)
			}
		}
	}

	// Update global counter
	mu.Lock()
	*count += localCount
	if *count%10000 < localCount {
		fmt.Fprintf(os.Stderr, "  Processed %d images from img/\n", *count)
	}
	mu.Unlock()
}

// scanThumbsDirectory scans thumbs/ and sends records to channel
func scanThumbsDirectory(db *sql.DB, recordChan chan<- imageRecord) error {
	realDir, err := filepath.EvalSymlinks("thumbs")
	if err != nil {
		return err
	}

	count := 0
	nonPngCount := 0
	zeroLengthSkipped := 0

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return err
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		ext := filepath.Ext(path)
		var weird string
		if ext != ".png" {
			nonPngCount++
			weird = fmt.Sprintf("non-PNG file in thumbs/: %s", ext)
			fmt.Fprintf(os.Stderr, "  WARNING: Non-PNG file in thumbs/: %s\n", basename)
		}

		id := strings.TrimSuffix(basename, ext)

		// Check for zero-length thumbnails
		if info.Size() == 0 {
			var state sql.NullString
			var imgPath sql.NullString
			err := db.QueryRow("SELECT state, img_path FROM images WHERE id = ?", id).Scan(&state, &imgPath)

			if err == sql.ErrNoRows || !state.Valid {
				// No entry or todo - check img file
				if imgPath.Valid {
					imgInfo, err := os.Stat(imgPath.String)
					if err == nil && imgInfo.Size() == 0 {
						// img is zero-length too -> mark as 'no'
						weirdMsg := "zero-length thumbnail and img"
						if weird != "" {
							weird = weird + "; " + weirdMsg
						} else {
							weird = weirdMsg
						}
						recordChan <- imageRecord{
							id:        id,
							state:     "no",
							thumbPath: path,
							sourceDir: "thumbs/",
							weird:     weird,
						}
						count++
					} else {
						// Skip - needs regeneration
						zeroLengthSkipped++
						fmt.Fprintf(os.Stderr, "  WARNING: Zero-length thumbnail (needs regeneration): %s\n", basename)
					}
				} else {
					zeroLengthSkipped++
					fmt.Fprintf(os.Stderr, "  WARNING: Zero-length thumbnail (no img): %s\n", basename)
				}
				return nil
			}
		}

		// Normal thumbnail - preserve existing yes/no state
		var existingState sql.NullString
		dbErr := db.QueryRow("SELECT state FROM images WHERE id = ?", id).Scan(&existingState)

		state := ""
		if dbErr == nil && existingState.Valid && (existingState.String == "yes" || existingState.String == "no") {
			state = existingState.String
		}

		recordChan <- imageRecord{
			id:        id,
			state:     state,
			thumbPath: path,
			sourceDir: "thumbs/",
			weird:     weird,
		}
		count++

		if count%10000 == 0 {
			fmt.Fprintf(os.Stderr, "  Scanned %d thumbnails from thumbs/\n", count)
		}

		return nil
	})

	fmt.Fprintf(os.Stderr, "  Finished scanning thumbs/: %d thumbnails\n", count)
	if nonPngCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Found %d non-PNG files in thumbs/\n", nonPngCount)
	}
	if zeroLengthSkipped > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Skipped %d zero-length thumbnails (need regeneration)\n", zeroLengthSkipped)
	}

	return err
}

// importDirectory scans a directory and imports images with the given state
func importDirectory(db *sql.DB, dir string, state string) error {
	// Resolve symlinks
	realDir, err := filepath.EvalSymlinks(dir)
	if err != nil {
		return fmt.Errorf("failed to resolve symlink for %s: %w", dir, err)
	}

	type imageRecord struct {
		id     string
		path   string
		width  int
		height int
	}

	batch := make([]imageRecord, 0, 10000)
	count := 0
	nonPngCount := 0

	flushBatch := func() error {
		if len(batch) == 0 {
			return nil
		}

		tx, err := db.Begin()
		if err != nil {
			return err
		}
		defer tx.Rollback()

		stmt, err := tx.Prepare(`
			INSERT INTO images (id, state, img_path, width, height)
			VALUES (?, ?, ?, ?, ?)
			ON CONFLICT(id) DO UPDATE SET
				state=excluded.state,
				img_path=excluded.img_path,
				width=excluded.width,
				height=excluded.height
		`)
		if err != nil {
			return err
		}
		defer stmt.Close()

		for _, rec := range batch {
			if _, err := stmt.Exec(rec.id, state, rec.path, rec.width, rec.height); err != nil {
				return err
			}
		}

		if err := tx.Commit(); err != nil {
			return err
		}

		count += len(batch)
		fmt.Fprintf(os.Stderr, "  Imported %d images from %s/\n", count, dir)
		batch = batch[:0]
		return nil
	}

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		// Check extension - yes/no should all be .png
		ext := filepath.Ext(path)
		if ext != ".png" {
			nonPngCount++
			fmt.Fprintf(os.Stderr, "  WARNING: Non-PNG file in %s/: %s\n", dir, basename)
		}

		// Extract ID (filename without extension)
		id := strings.TrimSuffix(basename, ext)

		// Get dimensions for 'yes' state only (skip 'no')
		var width, height int
		if state == "yes" {
			w, h, err := getImageDimensions(path)
			if err == nil {
				width, height = w, h
			}
			// Silently ignore dimension extraction errors
		}

		batch = append(batch, imageRecord{id: id, path: path, width: width, height: height})

		if len(batch) >= 10000 {
			return flushBatch()
		}

		return nil
	})

	if err != nil {
		return err
	}

	// Flush remaining
	if err := flushBatch(); err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Imported %d total images from %s/\n", count, dir)
	if nonPngCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Found %d non-PNG files in %s/\n", nonPngCount, dir)
	}
	return nil
}

// importThumbnails scans the thumbs directory and updates thumbnail paths
func importThumbnails(db *sql.DB, dir string) error {
	// Resolve symlinks
	realDir, err := filepath.EvalSymlinks(dir)
	if err != nil {
		return fmt.Errorf("failed to resolve symlink for %s: %w", dir, err)
	}

	type thumbRecord struct {
		id   string
		path string
	}

	batch := make([]thumbRecord, 0, 10000)
	count := 0
	nonPngCount := 0
	zeroLengthSkipped := 0

	flushBatch := func() error {
		if len(batch) == 0 {
			return nil
		}

		tx, err := db.Begin()
		if err != nil {
			return err
		}
		defer tx.Rollback()

		stmt, err := tx.Prepare(`
			INSERT INTO images (id, thumb_path)
			VALUES (?, ?)
			ON CONFLICT(id) DO UPDATE SET
				thumb_path=excluded.thumb_path
		`)
		if err != nil {
			return err
		}
		defer stmt.Close()

		for _, rec := range batch {
			if _, err := stmt.Exec(rec.id, rec.path); err != nil {
				return err
			}
		}

		if err := tx.Commit(); err != nil {
			return err
		}

		count += len(batch)
		fmt.Fprintf(os.Stderr, "  Imported %d thumbnails from %s/\n", count, dir)
		batch = batch[:0]
		return nil
	}

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		// Check extension - thumbs should all be .png
		ext := filepath.Ext(path)
		if ext != ".png" {
			nonPngCount++
			fmt.Fprintf(os.Stderr, "  WARNING: Non-PNG file in %s/: %s\n", dir, basename)
		}

		// Extract ID (filename without extension)
		id := strings.TrimSuffix(basename, ext)

		// Check for zero-length thumbnails
		if info.Size() == 0 {
			// Query database to check if this image has a state
			var state sql.NullString
			var imgPath sql.NullString
			err := db.QueryRow("SELECT state, img_path FROM images WHERE id = ?", id).Scan(&state, &imgPath)

			if err == sql.ErrNoRows || !state.Valid {
				// No entry in yes/no (state is NULL or doesn't exist)
				// Check if img/ file is also zero-length
				if imgPath.Valid {
					imgInfo, err := os.Stat(imgPath.String)
					if err == nil && imgInfo.Size() == 0 {
						// img is zero-length too -> mark as 'no' and import thumbnail
						db.Exec("UPDATE images SET state='no' WHERE id = ?", id)
						batch = append(batch, thumbRecord{id: id, path: path})
					} else {
						// img is not zero-length or doesn't exist -> skip, needs regeneration
						zeroLengthSkipped++
						fmt.Fprintf(os.Stderr, "  WARNING: Zero-length thumbnail (needs regeneration): %s\n", filepath.Base(path))
						return nil
					}
				} else {
					// No img_path -> skip thumbnail
					zeroLengthSkipped++
					fmt.Fprintf(os.Stderr, "  WARNING: Zero-length thumbnail (no img): %s\n", filepath.Base(path))
					return nil
				}
			} else {
				// Has state from yes/no -> import normally
				batch = append(batch, thumbRecord{id: id, path: path})
			}
		} else {
			// Normal thumbnail -> import
			batch = append(batch, thumbRecord{id: id, path: path})
		}

		if len(batch) >= 10000 {
			return flushBatch()
		}

		return nil
	})

	if err != nil {
		return err
	}

	// Flush remaining
	if err := flushBatch(); err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Imported %d total thumbnails from %s/\n", count, dir)
	if nonPngCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Found %d non-PNG files in %s/\n", nonPngCount, dir)
	}
	if zeroLengthSkipped > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Skipped %d zero-length thumbnails (need regeneration)\n", zeroLengthSkipped)
	}
	return nil
}

// importUpresPath scans a directory and updates the specified upres path column
func importUpresPath(db *sql.DB, dir string, columnName string) error {
	// Resolve symlinks
	realDir, err := filepath.EvalSymlinks(dir)
	if err != nil {
		return fmt.Errorf("failed to resolve symlink for %s: %w", dir, err)
	}

	type upresRecord struct {
		id   string
		path string
	}

	batch := make([]upresRecord, 0, 10000)
	count := 0
	nonPngCount := 0

	flushBatch := func() error {
		if len(batch) == 0 {
			return nil
		}

		tx, err := db.Begin()
		if err != nil {
			return err
		}
		defer tx.Rollback()

		// Build dynamic SQL with column name
		sql := fmt.Sprintf(`
			INSERT INTO images (id, %s)
			VALUES (?, ?)
			ON CONFLICT(id) DO UPDATE SET
				%s=excluded.%s
		`, columnName, columnName, columnName)

		stmt, err := tx.Prepare(sql)
		if err != nil {
			return err
		}
		defer stmt.Close()

		for _, rec := range batch {
			if _, err := stmt.Exec(rec.id, rec.path); err != nil {
				return err
			}
		}

		if err := tx.Commit(); err != nil {
			return err
		}

		count += len(batch)
		fmt.Fprintf(os.Stderr, "  Imported %d upres from %s/\n", count, dir)
		batch = batch[:0]
		return nil
	}

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		// Check extension - upres should all be .png
		ext := filepath.Ext(path)
		if ext != ".png" {
			nonPngCount++
			fmt.Fprintf(os.Stderr, "  WARNING: Non-PNG file in %s/: %s\n", dir, basename)
		}

		// Extract ID (filename without extension)
		id := strings.TrimSuffix(basename, ext)

		batch = append(batch, upresRecord{id: id, path: path})

		if len(batch) >= 10000 {
			return flushBatch()
		}

		return nil
	})

	if err != nil {
		return err
	}

	// Flush remaining
	if err := flushBatch(); err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Imported %d total upres from %s/\n", count, dir)
	if nonPngCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Found %d non-PNG files in %s/\n", nonPngCount, dir)
	}
	return nil
}

// importImgDirectory scans img/ directory with special extension rules
// Valid: .jpeg, .jpg, .png - import with state=NULL (todo)
// Auto-reject: .mp4 - import with state='no'
// Invalid: anything else - flag and skip
func importImgDirectory(db *sql.DB, dir string) error {
	// Resolve symlinks
	realDir, err := filepath.EvalSymlinks(dir)
	if err != nil {
		return fmt.Errorf("failed to resolve symlink for %s: %w", dir, err)
	}

	type imgRecord struct {
		id     string
		path   string
		state  string
		width  int
		height int
	}

	batch := make([]imgRecord, 0, 10000)
	count := 0
	mp4Count := 0
	invalidCount := 0

	flushBatch := func() error {
		if len(batch) == 0 {
			return nil
		}

		tx, err := db.Begin()
		if err != nil {
			return err
		}
		defer tx.Rollback()

		stmt, err := tx.Prepare(`
			INSERT INTO images (id, img_path, state, width, height)
			VALUES (?, ?, ?, ?, ?)
			ON CONFLICT(id) DO UPDATE SET
				img_path=excluded.img_path,
				state=COALESCE(images.state, excluded.state),
				width=excluded.width,
				height=excluded.height
		`)
		if err != nil {
			return err
		}
		defer stmt.Close()

		for _, rec := range batch {
			var state interface{}
			if rec.state == "no" {
				state = "no"
			} else {
				state = nil // NULL for todo
			}

			if _, err := stmt.Exec(rec.id, rec.path, state, rec.width, rec.height); err != nil {
				return err
			}
		}

		if err := tx.Commit(); err != nil {
			return err
		}

		count += len(batch)
		fmt.Fprintf(os.Stderr, "  Imported %d images from %s/\n", count, dir)
		batch = batch[:0]
		return nil
	}

	err = filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}

		// Skip temporary files starting with .
		basename := filepath.Base(path)
		if strings.HasPrefix(basename, ".") {
			return nil
		}

		ext := strings.ToLower(filepath.Ext(path))
		id := strings.TrimSuffix(basename, filepath.Ext(path))

		// Check extension rules
		switch ext {
		case ".jpeg", ".jpg", ".png":
			// Valid image - import as todo (state=NULL), extract dimensions
			var width, height int
			w, h, err := getImageDimensions(path)
			if err == nil {
				width, height = w, h
			}
			// Silently ignore dimension extraction errors
			batch = append(batch, imgRecord{id: id, path: path, state: "todo", width: width, height: height})

		case ".mp4":
			// Auto-reject video - no dimensions needed
			mp4Count++
			batch = append(batch, imgRecord{id: id, path: path, state: "no", width: 0, height: 0})

		default:
			// Invalid extension - flag and skip
			invalidCount++
			fmt.Fprintf(os.Stderr, "  WARNING: Invalid extension in %s/: %s\n", dir, filepath.Base(path))
			return nil
		}

		if len(batch) >= 10000 {
			return flushBatch()
		}

		return nil
	})

	if err != nil {
		return err
	}

	// Flush remaining
	if err := flushBatch(); err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Imported %d total images from %s/\n", count, dir)
	if mp4Count > 0 {
		fmt.Fprintf(os.Stderr, "  Auto-rejected %d .mp4 files\n", mp4Count)
	}
	if invalidCount > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Skipped %d files with invalid extensions\n", invalidCount)
	}
	return nil
}
