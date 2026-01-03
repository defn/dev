package main

import (
	"database/sql"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"sync/atomic"

	_ "modernc.org/sqlite"
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
	db.Exec("ALTER TABLE images ADD COLUMN url TEXT")

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

	// Generate report
	generateReport(db)
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

// inMemoryRecord represents a database record in memory with modification tracking
type inMemoryRecord struct {
	id             string
	state          sql.NullString
	imgPath        sql.NullString
	thumbPath      sql.NullString
	width          sql.NullInt64
	height         sql.NullInt64
	weird          sql.NullString
	url            sql.NullString
	upresImgPath   sql.NullString
	upresThumbPath sql.NullString
	modified       bool // Track if record needs to be written back
}

// shardedMutex provides fine-grained locking based on image ID
type shardedMutex struct {
	mutexes []sync.Mutex
	count   int
}

func newShardedMutex(count int) *shardedMutex {
	return &shardedMutex{
		mutexes: make([]sync.Mutex, count),
		count:   count,
	}
}

func (sm *shardedMutex) lock(id string) {
	idx := sm.hashID(id)
	sm.mutexes[idx].Lock()
}

func (sm *shardedMutex) unlock(id string) {
	idx := sm.hashID(id)
	sm.mutexes[idx].Unlock()
}

func (sm *shardedMutex) hashID(id string) int {
	// Simple hash function - sum of bytes modulo shard count
	h := 0
	for i := 0; i < len(id); i++ {
		h = (h*31 + int(id[i])) % sm.count
	}
	return h
}

// importStats tracks statistics during import
type importStats struct {
	processed   atomic.Int64
	yesToNo     atomic.Int64
	noToYes     atomic.Int64
	created     atomic.Int64
	transitions atomic.Int64
}

// loadDatabaseIntoMemory loads all records from database into memory
func loadDatabaseIntoMemory(db *sql.DB) (map[string]*inMemoryRecord, error) {
	fmt.Fprintf(os.Stderr, "Loading database into memory...\n")

	records := make(map[string]*inMemoryRecord)

	rows, err := db.Query(`
		SELECT id, state, img_path, thumb_path, width, height, weird, url, upres_img_path, upres_thumb_path
		FROM images
	`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	count := 0
	for rows.Next() {
		rec := &inMemoryRecord{}
		if err := rows.Scan(&rec.id, &rec.state, &rec.imgPath, &rec.thumbPath,
			&rec.width, &rec.height, &rec.weird, &rec.url, &rec.upresImgPath, &rec.upresThumbPath); err != nil {
			return nil, err
		}
		records[rec.id] = rec
		count++

		if count%500000 == 0 {
			fmt.Fprintf(os.Stderr, "  Loaded %d records...\n", count)
		}
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	fmt.Fprintf(os.Stderr, "  Loaded %d total records into memory\n", count)
	return records, nil
}

// parallelImport imports yes/, no/, img/, thumbs/ in parallel
func parallelImport(db *sql.DB) error {
	// Load database into memory
	memDB, err := loadDatabaseIntoMemory(db)
	if err != nil {
		return fmt.Errorf("failed to load database into memory: %w", err)
	}

	fmt.Fprintf(os.Stderr, "Starting parallel filesystem scan with concurrent updates...\n")

	// Create sharded mutex for fine-grained locking (1024 shards)
	shardedMutex := newShardedMutex(1024)

	// Import statistics
	stats := &importStats{}

	// Error channel
	errChan := make(chan error, 4)

	// WaitGroup for scanner goroutines
	var scanWg sync.WaitGroup

	// Start scanner goroutines - they update memDB directly with sharded locking
	scanWg.Add(4)

	// yes/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanYesDirectory(db, memDB, shardedMutex, stats); err != nil {
			errChan <- fmt.Errorf("yes/ scanner: %w", err)
		}
	}()

	// no/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanNoDirectory(memDB, shardedMutex, stats); err != nil {
			errChan <- fmt.Errorf("no/ scanner: %w", err)
		}
	}()

	// img/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanImgDirectory(db, memDB, shardedMutex, stats); err != nil {
			errChan <- fmt.Errorf("img/ scanner: %w", err)
		}
	}()

	// thumbs/ scanner
	go func() {
		defer scanWg.Done()
		if err := scanThumbsDirectory(db, memDB, shardedMutex, stats); err != nil {
			errChan <- fmt.Errorf("thumbs/ scanner: %w", err)
		}
	}()

	// Wait for all scanners to finish
	scanWg.Wait()

	// Check for scanner errors
	select {
	case err := <-errChan:
		return err
	default:
	}

	// Report statistics
	fmt.Fprintf(os.Stderr, "  Total records processed: %d\n", stats.processed.Load())
	if stats.yesToNo.Load() > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: %d attempts to downgrade from yes to no (blocked)\n", stats.yesToNo.Load())
	}
	if stats.noToYes.Load() > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: %d images upgraded from no to yes\n", stats.noToYes.Load())
	}
	if stats.created.Load() > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: %d new records created\n", stats.created.Load())
	}

	// Flush modified records back to database
	fmt.Fprintf(os.Stderr, "Flushing changes to database...\n")
	if err := flushMemoryToDatabase(db, memDB); err != nil {
		return fmt.Errorf("failed to flush memory to database: %w", err)
	}

	return nil
}

// updateMemoryRecord updates an in-memory record with proper locking and validation
func updateMemoryRecord(memDB map[string]*inMemoryRecord, shardedMutex *shardedMutex, stats *importStats, rec imageRecord) {
	// Lock on this specific ID
	shardedMutex.lock(rec.id)
	defer shardedMutex.unlock(rec.id)

	// Get or create in-memory record
	memRec, exists := memDB[rec.id]
	if !exists {
		memRec = &inMemoryRecord{id: rec.id}
		memDB[rec.id] = memRec
		stats.created.Add(1)
	}

	// Store current state for transition logging
	var currentStateStr, newStateStr string
	if !exists {
		currentStateStr = "NEW"
	} else {
		if memRec.state.Valid {
			currentStateStr = memRec.state.String
		} else {
			currentStateStr = "NULL"
		}
	}
	if rec.state == "" {
		newStateStr = "NULL"
	} else {
		newStateStr = rec.state
	}

	weird := rec.weird

	// Prevent yes -> no transition (yes cannot be downgraded)
	if exists && memRec.state.Valid && memRec.state.String == "yes" && rec.state == "no" {
		stats.yesToNo.Add(1)
		fmt.Fprintf(os.Stderr, "  WARNING: Image %s blocked downgrade %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)

		// If this conflict is from a no/ file, delete it
		if rec.sourceDir == "no/" {
			if removeErr := os.Remove(rec.imgPath); removeErr == nil {
				fmt.Fprintf(os.Stderr, "  INFO: Deleted conflicting no/ file: %s\n", rec.imgPath)
			} else {
				fmt.Fprintf(os.Stderr, "  ERROR: Failed to delete %s: %v\n", rec.imgPath, removeErr)
			}
		}

		return // Skip this update
	}

	// Check for no -> yes transition
	if exists && memRec.state.Valid && memRec.state.String == "no" && rec.state == "yes" {
		stats.noToYes.Add(1)
		weirdMsg := fmt.Sprintf("no->yes transition from %s", rec.sourceDir)
		fmt.Fprintf(os.Stderr, "  WARNING: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
		if weird != "" {
			weird = weird + "; " + weirdMsg
		} else {
			weird = weirdMsg
		}
	}

	// Log other state transitions (NULL->no, NULL->yes, yes->NULL, no->NULL)
	if exists {
		if !memRec.state.Valid && rec.state == "no" {
			fmt.Fprintf(os.Stderr, "  INFO: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
			stats.transitions.Add(1)
		} else if !memRec.state.Valid && rec.state == "yes" {
			fmt.Fprintf(os.Stderr, "  INFO: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
			stats.transitions.Add(1)
		} else if memRec.state.Valid && rec.state == "" {
			fmt.Fprintf(os.Stderr, "  INFO: Image %s transition %s->%s (from %s)\n", rec.id, currentStateStr, newStateStr, rec.sourceDir)
			stats.transitions.Add(1)
		}
	} else {
		// New record
		if rec.state != "" {
			fmt.Fprintf(os.Stderr, "  INFO: Image %s created with state %s (from %s)\n", rec.id, newStateStr, rec.sourceDir)
		}
	}

	// Update in-memory record using COALESCE logic
	// state: only update if new state is 'yes' or 'no', otherwise preserve existing
	if rec.state == "yes" || rec.state == "no" {
		memRec.state = sql.NullString{String: rec.state, Valid: true}
		memRec.modified = true
	} else if rec.state == "" && !memRec.state.Valid {
		// Only set to NULL if not already set
		memRec.state = sql.NullString{Valid: false}
		memRec.modified = true
	}

	// img_path: update if not empty, preserve existing otherwise
	if rec.imgPath != "" {
		memRec.imgPath = sql.NullString{String: rec.imgPath, Valid: true}
		memRec.modified = true
	}

	// thumb_path: update if not empty, preserve existing otherwise
	if rec.thumbPath != "" {
		memRec.thumbPath = sql.NullString{String: rec.thumbPath, Valid: true}
		memRec.modified = true
	}

	// width: update if not zero, preserve existing otherwise
	if rec.width != 0 {
		memRec.width = sql.NullInt64{Int64: int64(rec.width), Valid: true}
		memRec.modified = true
	}

	// height: update if not zero, preserve existing otherwise
	if rec.height != 0 {
		memRec.height = sql.NullInt64{Int64: int64(rec.height), Valid: true}
		memRec.modified = true
	}

	// weird: update if not empty, preserve existing otherwise
	if weird != "" {
		memRec.weird = sql.NullString{String: weird, Valid: true}
		memRec.modified = true
	}

	stats.processed.Add(1)
}

// flushMemoryToDatabase writes all modified records back to database
func flushMemoryToDatabase(db *sql.DB, memDB map[string]*inMemoryRecord) error {
	// Collect modified records
	var modified []*inMemoryRecord
	for _, rec := range memDB {
		if rec.modified {
			modified = append(modified, rec)
		}
	}

	fmt.Fprintf(os.Stderr, "  Found %d modified records to flush\n", len(modified))

	if len(modified) == 0 {
		return nil
	}

	// Flush in batches
	batchSize := 50000
	for i := 0; i < len(modified); i += batchSize {
		end := i + batchSize
		if end > len(modified) {
			end = len(modified)
		}
		batch := modified[i:end]

		tx, err := db.Begin()
		if err != nil {
			return err
		}
		defer tx.Rollback()

		stmt, err := tx.Prepare(`
			INSERT INTO images (id, state, img_path, thumb_path, width, height, weird, url, upres_img_path, upres_thumb_path)
			VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
			ON CONFLICT(id) DO UPDATE SET
				state = excluded.state,
				img_path = excluded.img_path,
				thumb_path = excluded.thumb_path,
				width = excluded.width,
				height = excluded.height,
				weird = excluded.weird,
				url = excluded.url,
				upres_img_path = excluded.upres_img_path,
				upres_thumb_path = excluded.upres_thumb_path
		`)
		if err != nil {
			return err
		}
		defer stmt.Close()

		for _, rec := range batch {
			// Convert sql.Null* to interface{} for Exec
			var state, imgPath, thumbPath, weird, url, upresImgPath, upresThumbPath interface{}
			var width, height interface{}

			if rec.state.Valid {
				state = rec.state.String
			}
			if rec.imgPath.Valid {
				imgPath = rec.imgPath.String
			}
			if rec.thumbPath.Valid {
				thumbPath = rec.thumbPath.String
			}
			if rec.width.Valid {
				width = rec.width.Int64
			}
			if rec.height.Valid {
				height = rec.height.Int64
			}
			if rec.weird.Valid {
				weird = rec.weird.String
			}
			if rec.url.Valid {
				url = rec.url.String
			}
			if rec.upresImgPath.Valid {
				upresImgPath = rec.upresImgPath.String
			}
			if rec.upresThumbPath.Valid {
				upresThumbPath = rec.upresThumbPath.String
			}

			if _, err := stmt.Exec(rec.id, state, imgPath, thumbPath, width, height, weird, url, upresImgPath, upresThumbPath); err != nil {
				return err
			}
		}

		if err := tx.Commit(); err != nil {
			return err
		}

		fmt.Fprintf(os.Stderr, "  Flushed %d records...\n", end)
	}

	fmt.Fprintf(os.Stderr, "  Flush complete: %d records written to database\n", len(modified))
	return nil
}

// scanYesDirectory scans yes/ and sends records to channel
func scanYesDirectory(db *sql.DB, memDB map[string]*inMemoryRecord, shardedMutex *shardedMutex, stats *importStats) error {
	realDir, err := filepath.EvalSymlinks("yes")
	if err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Starting parallel scan of yes/ with 8 workers...\n")

	// Open directory
	dir, err := os.Open(realDir)
	if err != nil {
		return err
	}
	defer dir.Close()

	// Worker pool
	numWorkers := 8
	workChan := make(chan []string, 100)
	var wg sync.WaitGroup
	var processedCount atomic.Int64

	// Start workers
	for i := 0; i < numWorkers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for batch := range workChan {
				for _, filename := range batch {
					// Skip temporary files
					if strings.HasPrefix(filename, ".") {
						continue
					}

					path := filepath.Join(realDir, filename)
					ext := filepath.Ext(filename)
					id := strings.TrimSuffix(filename, ext)

					// Check if dimensions already exist in memory DB
					var width, height int
					if memRec, exists := memDB[id]; exists && memRec.width.Valid && memRec.height.Valid && memRec.width.Int64 > 0 && memRec.height.Int64 > 0 {
						// Use existing dimensions
						width = int(memRec.width.Int64)
						height = int(memRec.height.Int64)
					} else {
						// Extract dimensions - missing or zero
						w, h, err := getImageDimensions(path)
						if err == nil {
							width, height = w, h
						}
					}

					updateMemoryRecord(memDB, shardedMutex, stats, imageRecord{
						id:        id,
						state:     "yes",
						imgPath:   path,
						width:     width,
						height:    height,
						sourceDir: "yes/",
					})

					count := processedCount.Add(1)
					if count%10000 == 0 {
						fmt.Fprintf(os.Stderr, "  Scanned %d images from yes/\n", count)
					}
				}
			}
		}()
	}

	// Read directory entries in batches
	batchSize := 10000
	for {
		names, err := dir.Readdirnames(batchSize)
		if err != nil && len(names) == 0 {
			break
		}
		if len(names) > 0 {
			workChan <- names
		}
		if err != nil {
			break
		}
	}

	close(workChan)
	wg.Wait()

	fmt.Fprintf(os.Stderr, "  Finished scanning yes/: %d images\n", processedCount.Load())
	return nil
}

// scanNoDirectory scans no/ and updates memory database
func scanNoDirectory(memDB map[string]*inMemoryRecord, shardedMutex *shardedMutex, stats *importStats) error {
	fmt.Fprintf(os.Stderr, "  Starting parallel scan of no/ with 8 workers...\n")
	realDir, err := filepath.EvalSymlinks("no")
	if err != nil {
		return err
	}
	fmt.Fprintf(os.Stderr, "  Resolved no/ symlink to: %s\n", realDir)

	// Open directory
	dir, err := os.Open(realDir)
	if err != nil {
		return err
	}
	defer dir.Close()

	// Worker pool
	numWorkers := 8
	workChan := make(chan []string, 100)
	var wg sync.WaitGroup
	var processedCount, skippedDueToYes, checkedForYes atomic.Int64

	// Start workers
	for i := 0; i < numWorkers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for batch := range workChan {
				for _, filename := range batch {
					// Skip temporary files
					if strings.HasPrefix(filename, ".") {
						continue
					}

					path := filepath.Join(realDir, filename)
					ext := filepath.Ext(filename)
					id := strings.TrimSuffix(filename, ext)

					// Skip if there's a yes/ file for this ID (yes takes precedence)
					checked := checkedForYes.Add(1)
					yesPath := filepath.Join("yes", id+".png")
					if _, statErr := os.Stat(yesPath); statErr == nil {
						// Delete the conflicting no/ file
						if removeErr := os.Remove(path); removeErr == nil {
							skipped := skippedDueToYes.Add(1)
							if skipped == 1 || skipped%1000 == 0 {
								fmt.Fprintf(os.Stderr, "  INFO: Deleted %d of %d conflicting no/ files (yes/ file exists)\n", skipped, checked)
							}
						} else {
							fmt.Fprintf(os.Stderr, "  ERROR: Failed to delete conflicting no/ file %s: %v\n", path, removeErr)
						}
						continue
					}

					// Check file size for zero-length files
					if info, err := os.Stat(path); err == nil && info.Size() == 0 {
						// Check if replicate/img/ has a non-zero file
						replicateImgPath := filepath.Join("replicate", "img", id+".png")
						if fi, err := os.Stat(replicateImgPath); err == nil && fi.Size() > 0 {
							// This is an upres'd image, skip it in no/ directory
							continue
						}
					}

					updateMemoryRecord(memDB, shardedMutex, stats, imageRecord{
						id:        id,
						state:     "no",
						imgPath:   path,
						sourceDir: "no/",
					})

					count := processedCount.Add(1)
					if count%10000 == 0 {
						fmt.Fprintf(os.Stderr, "  Scanned %d images from no/\n", count)
					}
				}
			}
		}()
	}

	// Read directory entries in batches
	batchSize := 10000
	for {
		names, err := dir.Readdirnames(batchSize)
		if err != nil && len(names) == 0 {
			break
		}
		if len(names) > 0 {
			workChan <- names
		}
		if err != nil {
			break
		}
	}

	close(workChan)
	wg.Wait()

	fmt.Fprintf(os.Stderr, "  Finished scanning no/: %d images (checked %d for yes/ conflicts)\n", processedCount.Load(), checkedForYes.Load())
	if skippedDueToYes.Load() > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: Deleted %d of %d conflicting no/ files (yes/ file exists)\n", skippedDueToYes.Load(), checkedForYes.Load())
	} else if checkedForYes.Load() > 0 {
		fmt.Fprintf(os.Stderr, "  INFO: No yes/ conflicts found in %d no/ files checked\n", checkedForYes.Load())
	}

	return nil
}

// scanImgDirectory scans img/ and updates memory database
func scanImgDirectory(db *sql.DB, memDB map[string]*inMemoryRecord, shardedMutex *shardedMutex, stats *importStats) error {
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
			processImgChunk(db, workChan, memDB, shardedMutex, stats, &mu, &count, &mp4Count, &invalidCount)
		}(i)
	}

	// Read directory entries in batches and send to workers
	dir, err := os.Open(realDir)
	if err != nil {
		return err
	}
	defer dir.Close()

	batchSize := 10000
	var chunk []string
	for {
		names, err := dir.Readdirnames(batchSize)
		if err != nil && len(names) == 0 {
			break
		}

		// Filter and build paths
		for _, filename := range names {
			// Skip temporary files
			if strings.HasPrefix(filename, ".") {
				continue
			}

			path := filepath.Join(realDir, filename)
			chunk = append(chunk, path)
			walkCount++

			// Send chunk when it reaches size limit
			if len(chunk) >= chunkSize {
				workChan <- chunk
				chunk = make([]string, 0, chunkSize)

				if walkCount%10000 == 0 {
					fmt.Fprintf(os.Stderr, "  Scanned %d files in img/\n", walkCount)
				}
			}
		}

		if err != nil {
			break
		}
	}

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
func processImgChunk(db *sql.DB, workChan <-chan []string, memDB map[string]*inMemoryRecord, shardedMutex *shardedMutex, stats *importStats, mu *sync.Mutex, count *int, mp4Count *int, invalidCount *int) {
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

				updateMemoryRecord(memDB, shardedMutex, stats, imageRecord{
					id:        id,
					state:     state,
					imgPath:   path,
					width:     width,
					height:    height,
					sourceDir: "img/",
				})
				localCount++

			case ".mp4":
				// Auto-reject
				mu.Lock()
				(*mp4Count)++
				mu.Unlock()

				updateMemoryRecord(memDB, shardedMutex, stats, imageRecord{
					id:        id,
					state:     "no",
					imgPath:   path,
					sourceDir: "img/",
				})
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

// scanThumbsDirectory scans thumbs/ and updates memory database with parallel workers
func scanThumbsDirectory(db *sql.DB, memDB map[string]*inMemoryRecord, shardedMutex *shardedMutex, stats *importStats) error {
	realDir, err := filepath.EvalSymlinks("thumbs")
	if err != nil {
		return err
	}

	fmt.Fprintf(os.Stderr, "  Starting parallel scan of thumbs/ with 8 workers...\n")

	// Open directory
	dir, err := os.Open(realDir)
	if err != nil {
		return err
	}
	defer dir.Close()

	// Worker pool
	numWorkers := 8
	workChan := make(chan []string, 100)
	var wg sync.WaitGroup
	var processedCount, nonPngCount, zeroLengthSkipped atomic.Int64

	// Start workers
	for i := 0; i < numWorkers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for batch := range workChan {
				for _, filename := range batch {
					// Skip temporary files
					if strings.HasPrefix(filename, ".") {
						continue
					}

					path := filepath.Join(realDir, filename)
					ext := filepath.Ext(filename)
					id := strings.TrimSuffix(filename, ext)

					var weird string
					if ext != ".png" {
						nonPngCount.Add(1)
						weird = fmt.Sprintf("non-PNG file in thumbs/: %s", ext)
						fmt.Fprintf(os.Stderr, "  WARNING: Non-PNG file in thumbs/: %s\n", filename)
					}

					// Check for zero-length thumbnails
					if info, err := os.Stat(path); err == nil && info.Size() == 0 {
						// Check memDB for state and img_path
						memRec, exists := memDB[id]
						hasState := exists && memRec.state.Valid

						if !hasState {
							// No entry or todo - check img file
							if exists && memRec.imgPath.Valid {
								if imgInfo, err := os.Stat(memRec.imgPath.String); err == nil && imgInfo.Size() == 0 {
									// img is zero-length too -> mark as 'no'
									weirdMsg := "zero-length thumbnail and img"
									if weird != "" {
										weird = weird + "; " + weirdMsg
									} else {
										weird = weirdMsg
									}
									updateMemoryRecord(memDB, shardedMutex, stats, imageRecord{
										id:        id,
										state:     "no",
										thumbPath: path,
										sourceDir: "thumbs/",
										weird:     weird,
									})
									processedCount.Add(1)
								} else {
									// Skip - needs regeneration
									zeroLengthSkipped.Add(1)
									fmt.Fprintf(os.Stderr, "  WARNING: Zero-length thumbnail (needs regeneration): %s\n", filename)
								}
							} else {
								zeroLengthSkipped.Add(1)
								fmt.Fprintf(os.Stderr, "  WARNING: Zero-length thumbnail (no img): %s\n", filename)
							}
							continue
						}
					}

					// Normal thumbnail - preserve existing yes/no state from memDB
					state := ""
					if memRec, exists := memDB[id]; exists && memRec.state.Valid && (memRec.state.String == "yes" || memRec.state.String == "no") {
						state = memRec.state.String
					}

					updateMemoryRecord(memDB, shardedMutex, stats, imageRecord{
						id:        id,
						state:     state,
						thumbPath: path,
						sourceDir: "thumbs/",
						weird:     weird,
					})

					count := processedCount.Add(1)
					if count%10000 == 0 {
						fmt.Fprintf(os.Stderr, "  Scanned %d thumbnails from thumbs/\n", count)
					}
				}
			}
		}()
	}

	// Read directory entries in batches
	batchSize := 10000
	for {
		names, err := dir.Readdirnames(batchSize)
		if err != nil && len(names) == 0 {
			break
		}
		if len(names) > 0 {
			workChan <- names
		}
		if err != nil {
			break
		}
	}

	close(workChan)
	wg.Wait()

	fmt.Fprintf(os.Stderr, "  Finished scanning thumbs/: %d thumbnails\n", processedCount.Load())
	if nonPngCount.Load() > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Found %d non-PNG files in thumbs/\n", nonPngCount.Load())
	}
	if zeroLengthSkipped.Load() > 0 {
		fmt.Fprintf(os.Stderr, "  WARNING: Skipped %d zero-length thumbnails (need regeneration)\n", zeroLengthSkipped.Load())
	}

	return nil
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
