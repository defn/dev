package main

import (
	"database/sql"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	_ "github.com/mattn/go-sqlite3"
)

func reportMode() {
	dbPath := "cv.db"

	// Open database
	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error opening database: %v\n", err)
		os.Exit(1)
	}
	defer db.Close()

	generateReport(db)
}

// generateReport generates and prints comprehensive database and filesystem statistics
func generateReport(db *sql.DB) {
	fmt.Fprintf(os.Stderr, "\n========================================\n")
	fmt.Fprintf(os.Stderr, "IMAGE DATABASE CONSISTENCY REPORT\n")
	fmt.Fprintf(os.Stderr, "========================================\n")

	// Initialize filesystem cache for fast repeated access
	fmt.Fprintf(os.Stderr, "\nInitializing filesystem cache...\n")
	cache := newFSCache()

	// Preload common directories
	dirs := []string{"yes", "no", "img", "thumbs", "replicate/img", "replicate/t2"}
	for _, dir := range dirs {
		if err := cache.loadDirectory(dir); err != nil {
			// Directory doesn't exist, skip
			continue
		}
	}
	fmt.Fprintf(os.Stderr, "Filesystem cache ready\n")

	// 1. Database Statistics
	reportDatabaseStats(db)

	// 2. Filesystem → Database Sync
	reportFilesystemSync(db, cache)

	// 3. Database → Filesystem References
	reportDatabaseReferences(db, cache)

	// 4. Data Quality Issues
	reportDataQuality(db, cache)

	// 5. Action Recommendations
	reportActionRecommendations(db)

	fmt.Fprintf(os.Stderr, "\n========================================\n")
}

// reportDatabaseStats shows basic database statistics
func reportDatabaseStats(db *sql.DB) {
	fmt.Fprintf(os.Stderr, "\n[1] DATABASE STATISTICS\n")
	fmt.Fprintf(os.Stderr, "───────────────────────\n")

	var totalCount, yesCount, noCount, todoCount int
	var imgPathCount, thumbCount, upresImgCount, upresThumbCount int
	var urlNotDownloaded, weirdCount int

	db.QueryRow("SELECT COUNT(*) FROM images").Scan(&totalCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='yes'").Scan(&yesCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='no'").Scan(&noCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state IS NULL").Scan(&todoCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE img_path IS NOT NULL").Scan(&imgPathCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE thumb_path IS NOT NULL").Scan(&thumbCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_img_path IS NOT NULL").Scan(&upresImgCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_thumb_path IS NOT NULL").Scan(&upresThumbCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE url IS NOT NULL AND (img_path IS NULL OR img_path = '')").Scan(&urlNotDownloaded)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE weird IS NOT NULL").Scan(&weirdCount)

	fmt.Fprintf(os.Stderr, "Total records:         %7d\n", totalCount)
	fmt.Fprintf(os.Stderr, "\nCuration state:\n")
	fmt.Fprintf(os.Stderr, "  Approved (yes):      %7d  (%.1f%%)\n", yesCount, percent(yesCount, totalCount))
	fmt.Fprintf(os.Stderr, "  Rejected (no):       %7d  (%.1f%%)\n", noCount, percent(noCount, totalCount))
	fmt.Fprintf(os.Stderr, "  Todo (uncurated):    %7d  (%.1f%%)\n", todoCount, percent(todoCount, totalCount))

	fmt.Fprintf(os.Stderr, "\nFile tracking:\n")
	fmt.Fprintf(os.Stderr, "  With img_path:       %7d  (%.1f%%)\n", imgPathCount, percent(imgPathCount, totalCount))
	fmt.Fprintf(os.Stderr, "  With thumb_path:     %7d  (%.1f%%)\n", thumbCount, percent(thumbCount, totalCount))
	fmt.Fprintf(os.Stderr, "  Not downloaded:      %7d  (%.1f%%)  (have URL, no img_path)\n", urlNotDownloaded, percent(urlNotDownloaded, totalCount))
	fmt.Fprintf(os.Stderr, "  With upres images:   %7d  (%.1f%%)\n", upresImgCount, percent(upresImgCount, totalCount))
	fmt.Fprintf(os.Stderr, "  With upres thumbs:   %7d  (%.1f%%)\n", upresThumbCount, percent(upresThumbCount, totalCount))

	if weirdCount > 0 {
		fmt.Fprintf(os.Stderr, "\n  ⚠ Weird/anomalous:    %7d  (query: SELECT id, weird FROM images WHERE weird IS NOT NULL)\n", weirdCount)
	}

	// State verification
	stateSum := yesCount + noCount + todoCount
	if stateSum == totalCount {
		fmt.Fprintf(os.Stderr, "\n✓ State verification: %d + %d + %d = %d (OK)\n", yesCount, noCount, todoCount, totalCount)
	} else {
		fmt.Fprintf(os.Stderr, "\n✗ State verification: %d + %d + %d = %d (expected %d) - DATA CORRUPTION!\n",
			yesCount, noCount, todoCount, stateSum, totalCount)
	}
}

// reportFilesystemSync checks if filesystem matches database
func reportFilesystemSync(db *sql.DB, cache *fsCache) {
	fmt.Fprintf(os.Stderr, "\n[2] FILESYSTEM → DATABASE SYNC\n")
	fmt.Fprintf(os.Stderr, "──────────────────────────────\n")
	fmt.Fprintf(os.Stderr, "Checking if all files in directories are tracked in database...\n\n")

	type dirCheck struct {
		dir      string
		fsCount  int
		dbCount  int
		orphaned []string // Files in filesystem but not in database
	}

	checks := []dirCheck{
		{dir: "yes"},
		{dir: "no"},
		{dir: "img"},
		{dir: "thumbs"},
		{dir: "replicate/img"},
		{dir: "replicate/t2"},
	}

	allGood := true

	for i := range checks {
		check := &checks[i]

		// Get files from cache (fast, no Walk)
		fsIDs := cache.getDirectoryIDs(check.dir)
		if len(fsIDs) == 0 {
			// Check if directory exists
			if _, err := filepath.EvalSymlinks(check.dir); err != nil {
				fmt.Fprintf(os.Stderr, "%-18s SKIP (not found)\n", check.dir+":")
				continue
			}
		}
		check.fsCount = len(fsIDs)

		// Count in database and find orphans
		var query string
		switch check.dir {
		case "yes":
			query = "SELECT id FROM images WHERE state='yes'"
		case "no":
			query = "SELECT id FROM images WHERE state='no'"
		case "img":
			query = "SELECT id FROM images WHERE img_path IS NOT NULL AND img_path != ''"
		case "thumbs":
			query = "SELECT id FROM images WHERE thumb_path IS NOT NULL AND thumb_path != ''"
		case "replicate/img":
			query = "SELECT id FROM images WHERE upres_img_path IS NOT NULL AND upres_img_path != ''"
		case "replicate/t2":
			query = "SELECT id FROM images WHERE upres_thumb_path IS NOT NULL AND upres_thumb_path != ''"
		}

		rows, err := db.Query(query)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%-18s ERROR: %v\n", check.dir+":", err)
			continue
		}

		dbIDs := make(map[string]bool)
		for rows.Next() {
			var id string
			if rows.Scan(&id) == nil {
				dbIDs[id] = true
			}
		}
		rows.Close()
		check.dbCount = len(dbIDs)

		// Find orphaned files (in filesystem but not in database)
		for id := range fsIDs {
			if !dbIDs[id] {
				check.orphaned = append(check.orphaned, id)
				if len(check.orphaned) <= 5 { // Limit examples
					allGood = false
				}
			}
		}

		// Report
		status := "✓"
		if check.fsCount != check.dbCount || len(check.orphaned) > 0 {
			status = "✗"
			allGood = false
		}

		fmt.Fprintf(os.Stderr, "%-18s %s  FS: %7d  DB: %7d", check.dir+":", status, check.fsCount, check.dbCount)

		if len(check.orphaned) > 0 {
			fmt.Fprintf(os.Stderr, "  ⚠ %d orphaned", len(check.orphaned))
			if len(check.orphaned) <= 5 {
				fmt.Fprintf(os.Stderr, " (e.g., %s)", strings.Join(check.orphaned[:min(3, len(check.orphaned))], ", "))
			}
		}
		fmt.Fprintf(os.Stderr, "\n")
	}

	if allGood {
		fmt.Fprintf(os.Stderr, "\n✓ All filesystem files are tracked in database (import complete)\n")
	} else {
		fmt.Fprintf(os.Stderr, "\n✗ Some filesystem files are NOT in database (re-run import mode)\n")
	}
}

// reportDatabaseReferences validates all database file references
func reportDatabaseReferences(db *sql.DB, cache *fsCache) {
	fmt.Fprintf(os.Stderr, "\n[3] DATABASE → FILESYSTEM REFERENCES\n")
	fmt.Fprintf(os.Stderr, "────────────────────────────────────\n")
	fmt.Fprintf(os.Stderr, "Checking if all database file paths point to existing files...\n\n")

	type refCheck struct {
		column      string
		missing     int
		zeroLength  int
		total       int
	}

	checks := []refCheck{
		{column: "img_path"},
		{column: "thumb_path"},
		{column: "upres_img_path"},
		{column: "upres_thumb_path"},
	}

	allGood := true

	for i := range checks {
		check := &checks[i]

		query := fmt.Sprintf("SELECT %s FROM images WHERE %s IS NOT NULL AND %s != ''", check.column, check.column, check.column)
		rows, err := db.Query(query)
		if err != nil {
			continue
		}

		for rows.Next() {
			var path string
			if rows.Scan(&path) != nil {
				continue
			}
			check.total++

			// Use cached stat
			info := cache.getFileStat(path)
			if !info.exists {
				check.missing++
				allGood = false
			} else if info.size == 0 {
				check.zeroLength++
			}
		}
		rows.Close()

		status := "✓"
		if check.missing > 0 || check.zeroLength > 0 {
			status = "✗"
			if check.missing > 0 {
				allGood = false
			}
		}

		fmt.Fprintf(os.Stderr, "%-18s %s  Total: %7d", check.column+":", status, check.total)
		if check.missing > 0 {
			fmt.Fprintf(os.Stderr, "  ⚠ %d missing", check.missing)
		}
		if check.zeroLength > 0 {
			fmt.Fprintf(os.Stderr, "  ℹ %d zero-byte", check.zeroLength)
		}
		fmt.Fprintf(os.Stderr, "\n")
	}

	if allGood {
		fmt.Fprintf(os.Stderr, "\n✓ All database file references are valid\n")
	} else {
		fmt.Fprintf(os.Stderr, "\n✗ Some database file references are broken (files deleted?)\n")
	}
}

// reportDataQuality checks for data inconsistencies
func reportDataQuality(db *sql.DB, cache *fsCache) {
	fmt.Fprintf(os.Stderr, "\n[4] DATA QUALITY ISSUES\n")
	fmt.Fprintf(os.Stderr, "───────────────────────\n")

	issues := 0

	// Missing critical data for approved/todo images
	var yesMissingImg, yesMissingThumb, yesMissingDims int
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='yes' AND (img_path IS NULL OR img_path = '')").Scan(&yesMissingImg)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='yes' AND (thumb_path IS NULL OR thumb_path = '')").Scan(&yesMissingThumb)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='yes' AND (width IS NULL OR height IS NULL OR width = 0 OR height = 0)").Scan(&yesMissingDims)

	if yesMissingImg > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d approved images missing img_path (files deleted?)\n", yesMissingImg)
		issues += yesMissingImg
	}
	if yesMissingThumb > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d approved images missing thumb_path (need thumbnail generation)\n", yesMissingThumb)
		issues += yesMissingThumb
	}
	if yesMissingDims > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d approved images missing dimensions (need extraction)\n", yesMissingDims)
		issues += yesMissingDims
	}

	// Orphaned data
	var upresImgOrphan, upresThumbOrphan int
	db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_img_path IS NOT NULL AND (img_path IS NULL OR img_path = '')").Scan(&upresImgOrphan)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_thumb_path IS NOT NULL AND (thumb_path IS NULL OR thumb_path = '')").Scan(&upresThumbOrphan)

	if upresImgOrphan > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d upres images without base img_path (orphaned)\n", upresImgOrphan)
		issues += upresImgOrphan
	}
	if upresThumbOrphan > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d upres thumbs without base thumb_path (orphaned)\n", upresThumbOrphan)
		issues += upresThumbOrphan
	}

	// Download tracking
	var urlButNoImg, imgButNoUrl int
	db.QueryRow("SELECT COUNT(*) FROM images WHERE url IS NOT NULL AND url != '' AND (img_path IS NULL OR img_path = '')").Scan(&urlButNoImg)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE (img_path IS NOT NULL AND img_path != '') AND (url IS NULL OR url = '')").Scan(&imgButNoUrl)

	if urlButNoImg > 0 {
		fmt.Fprintf(os.Stderr, "ℹ %7d images with URL but no img_path (pending download)\n", urlButNoImg)
	}
	if imgButNoUrl > 0 {
		fmt.Fprintf(os.Stderr, "ℹ %7d images with img_path but no URL (manually added)\n", imgButNoUrl)
	}

	// Orphaned thumbnails
	var orphanedThumbs int
	db.QueryRow("SELECT COUNT(*) FROM images WHERE thumb_path IS NOT NULL AND state IS NULL AND (img_path IS NULL OR img_path = '')").Scan(&orphanedThumbs)
	if orphanedThumbs > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d orphaned thumbnails (thumb only, no img, no state)\n", orphanedThumbs)
		issues += orphanedThumbs
	}

	// Zero-length file consistency checks
	var noNonZeroImg, noNonZeroThumb int
	var yesZeroImg, yesZeroThumb, todoZeroImg, todoZeroThumb int

	// Check rejected images (state='no') - should have zero-length files
	rows, err := db.Query("SELECT img_path, thumb_path FROM images WHERE state='no' AND (img_path IS NOT NULL OR thumb_path IS NOT NULL)")
	if err == nil {
		for rows.Next() {
			var imgPath, thumbPath sql.NullString
			if rows.Scan(&imgPath, &thumbPath) != nil {
				continue
			}

			if imgPath.Valid && imgPath.String != "" {
				info := cache.getFileStat(imgPath.String)
				if info.exists && info.size > 0 {
					noNonZeroImg++
				}
			}

			if thumbPath.Valid && thumbPath.String != "" {
				info := cache.getFileStat(thumbPath.String)
				if info.exists && info.size > 0 {
					noNonZeroThumb++
				}
			}
		}
		rows.Close()
	}

	// Check approved images (state='yes') - should NOT have zero-length files
	rows, err = db.Query("SELECT img_path, thumb_path FROM images WHERE state='yes' AND (img_path IS NOT NULL OR thumb_path IS NOT NULL)")
	if err == nil {
		for rows.Next() {
			var imgPath, thumbPath sql.NullString
			if rows.Scan(&imgPath, &thumbPath) != nil {
				continue
			}

			if imgPath.Valid && imgPath.String != "" {
				info := cache.getFileStat(imgPath.String)
				if info.exists && info.size == 0 {
					yesZeroImg++
				}
			}

			if thumbPath.Valid && thumbPath.String != "" {
				info := cache.getFileStat(thumbPath.String)
				if info.exists && info.size == 0 {
					yesZeroThumb++
				}
			}
		}
		rows.Close()
	}

	// Check todo images (state IS NULL) - should NOT have zero-length files
	rows, err = db.Query("SELECT img_path, thumb_path FROM images WHERE state IS NULL AND (img_path IS NOT NULL OR thumb_path IS NOT NULL)")
	if err == nil {
		for rows.Next() {
			var imgPath, thumbPath sql.NullString
			if rows.Scan(&imgPath, &thumbPath) != nil {
				continue
			}

			if imgPath.Valid && imgPath.String != "" {
				info := cache.getFileStat(imgPath.String)
				if info.exists && info.size == 0 {
					todoZeroImg++
				}
			}

			if thumbPath.Valid && thumbPath.String != "" {
				info := cache.getFileStat(thumbPath.String)
				if info.exists && info.size == 0 {
					todoZeroThumb++
				}
			}
		}
		rows.Close()
	}

	// Report zero-length file issues
	if noNonZeroImg > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d rejected images with non-zero img_path (should be zero-length markers)\n", noNonZeroImg)
		issues += noNonZeroImg
	}
	if noNonZeroThumb > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d rejected images with non-zero thumb_path (should be zero-length markers)\n", noNonZeroThumb)
		issues += noNonZeroThumb
	}
	if yesZeroImg > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d approved images with zero-length img_path (should have real files)\n", yesZeroImg)
		issues += yesZeroImg
	}
	if yesZeroThumb > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d approved images with zero-length thumb_path (should have real files)\n", yesZeroThumb)
		issues += yesZeroThumb
	}
	if todoZeroImg > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d todo images with zero-length img_path (should have real files)\n", todoZeroImg)
		issues += todoZeroImg
	}
	if todoZeroThumb > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d todo images with zero-length thumb_path (should have real files)\n", todoZeroThumb)
		issues += todoZeroThumb
	}

	// Upres file consistency checks
	var noWithUpresImg, noWithUpresThumb, todoWithUpresImg, todoWithUpresThumb int
	var yesMissingUpresImg, yesMissingUpresThumb int
	var upresZeroImg, upresZeroThumb int
	var upresWithNonZeroBaseImg, upresWithNonZeroBaseThumb int

	// Check non-approved images (state='no' or NULL) - should NOT have upres files
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='no' AND upres_img_path IS NOT NULL AND upres_img_path != ''").Scan(&noWithUpresImg)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='no' AND upres_thumb_path IS NOT NULL AND upres_thumb_path != ''").Scan(&noWithUpresThumb)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state IS NULL AND upres_img_path IS NOT NULL AND upres_img_path != ''").Scan(&todoWithUpresImg)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state IS NULL AND upres_thumb_path IS NOT NULL AND upres_thumb_path != ''").Scan(&todoWithUpresThumb)

	// Check approved images - should have upres files
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='yes' AND (upres_img_path IS NULL OR upres_img_path = '')").Scan(&yesMissingUpresImg)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='yes' AND (upres_thumb_path IS NULL OR upres_thumb_path = '')").Scan(&yesMissingUpresThumb)

	// Check upres files that are zero-length (should be real files)
	rows, err = db.Query("SELECT upres_img_path FROM images WHERE upres_img_path IS NOT NULL AND upres_img_path != ''")
	if err == nil {
		for rows.Next() {
			var path string
			if rows.Scan(&path) != nil {
				continue
			}
			info := cache.getFileStat(path)
			if info.exists && info.size == 0 {
				upresZeroImg++
			}
		}
		rows.Close()
	}

	rows, err = db.Query("SELECT upres_thumb_path FROM images WHERE upres_thumb_path IS NOT NULL AND upres_thumb_path != ''")
	if err == nil {
		for rows.Next() {
			var path string
			if rows.Scan(&path) != nil {
				continue
			}
			info := cache.getFileStat(path)
			if info.exists && info.size == 0 {
				upresZeroThumb++
			}
		}
		rows.Close()
	}

	// Check images with upres - base files should be zero-length
	rows, err = db.Query("SELECT img_path, upres_img_path FROM images WHERE upres_img_path IS NOT NULL AND upres_img_path != '' AND img_path IS NOT NULL AND img_path != ''")
	if err == nil {
		for rows.Next() {
			var imgPath, upresPath string
			if rows.Scan(&imgPath, &upresPath) != nil {
				continue
			}
			// Check if upres exists and is non-zero
			upresInfo := cache.getFileStat(upresPath)
			if upresInfo.exists && upresInfo.size > 0 {
				// Base img should be zero-length
				imgInfo := cache.getFileStat(imgPath)
				if imgInfo.exists && imgInfo.size > 0 {
					upresWithNonZeroBaseImg++
				}
			}
		}
		rows.Close()
	}

	rows, err = db.Query("SELECT thumb_path, upres_thumb_path FROM images WHERE upres_thumb_path IS NOT NULL AND upres_thumb_path != '' AND thumb_path IS NOT NULL AND thumb_path != ''")
	if err == nil {
		for rows.Next() {
			var thumbPath, upresPath string
			if rows.Scan(&thumbPath, &upresPath) != nil {
				continue
			}
			// Check if upres exists and is non-zero
			upresInfo := cache.getFileStat(upresPath)
			if upresInfo.exists && upresInfo.size > 0 {
				// Base thumb should be zero-length
				thumbInfo := cache.getFileStat(thumbPath)
				if thumbInfo.exists && thumbInfo.size > 0 {
					upresWithNonZeroBaseThumb++
				}
			}
		}
		rows.Close()
	}

	// Report upres issues
	if noWithUpresImg > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d rejected images with upres_img_path (should not have upres)\n", noWithUpresImg)
		issues += noWithUpresImg
	}
	if noWithUpresThumb > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d rejected images with upres_thumb_path (should not have upres)\n", noWithUpresThumb)
		issues += noWithUpresThumb
	}
	if todoWithUpresImg > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d todo images with upres_img_path (should not have upres)\n", todoWithUpresImg)
		issues += todoWithUpresImg
	}
	if todoWithUpresThumb > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d todo images with upres_thumb_path (should not have upres)\n", todoWithUpresThumb)
		issues += todoWithUpresThumb
	}
	if yesMissingUpresImg > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d approved images missing upres_img_path (need upscaling)\n", yesMissingUpresImg)
		issues += yesMissingUpresImg
	}
	if yesMissingUpresThumb > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d approved images missing upres_thumb_path (need upscaling)\n", yesMissingUpresThumb)
		issues += yesMissingUpresThumb
	}
	if upresZeroImg > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d upres images are zero-length (should be real files)\n", upresZeroImg)
		issues += upresZeroImg
	}
	if upresZeroThumb > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d upres thumbs are zero-length (should be real files)\n", upresZeroThumb)
		issues += upresZeroThumb
	}
	if upresWithNonZeroBaseImg > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d images with upres have non-zero base img_path (base should be zero-length)\n", upresWithNonZeroBaseImg)
		issues += upresWithNonZeroBaseImg
	}
	if upresWithNonZeroBaseThumb > 0 {
		fmt.Fprintf(os.Stderr, "⚠ %7d images with upres have non-zero base thumb_path (base should be zero-length)\n", upresWithNonZeroBaseThumb)
		issues += upresWithNonZeroBaseThumb
	}

	if issues == 0 && urlButNoImg == 0 && imgButNoUrl == 0 {
		fmt.Fprintf(os.Stderr, "✓ No data quality issues found\n")
	}
}

// reportActionRecommendations suggests next steps
func reportActionRecommendations(db *sql.DB) {
	fmt.Fprintf(os.Stderr, "\n[5] ACTION RECOMMENDATIONS\n")
	fmt.Fprintf(os.Stderr, "──────────────────────────\n")

	actions := []struct {
		count  int
		query  string
		action string
	}{
		{query: "SELECT COUNT(*) FROM images WHERE url IS NOT NULL AND (img_path IS NULL OR img_path = '')", action: "Run download mode to fetch pending images"},
		{query: "SELECT COUNT(*) FROM images WHERE state IS NULL AND img_path IS NOT NULL AND img_path != '' AND (weird IS NULL OR weird = '')", action: "Run todo mode to generate curation list"},
		{query: "SELECT COUNT(*) FROM images WHERE state='yes' AND (thumb_path IS NULL OR thumb_path = '')", action: "Generate thumbnails for approved images"},
		{query: "SELECT COUNT(*) FROM images WHERE state='yes' AND (width IS NULL OR height IS NULL OR width = 0 OR height = 0)", action: "Extract dimensions for approved images"},
		{query: "SELECT COUNT(*) FROM images WHERE state='yes' AND (upres_img_path IS NULL OR upres_img_path = '')", action: "Upscale approved images (create upres_img_path)"},
		{query: "SELECT COUNT(*) FROM images WHERE state='yes' AND (upres_thumb_path IS NULL OR upres_thumb_path = '')", action: "Upscale approved thumbnails (create upres_thumb_path)"},
		{query: "SELECT COUNT(*) FROM images WHERE state='no' AND img_path IS NOT NULL AND img_path LIKE 'yes/%'", action: "Clean up: move rejected images out of yes/ directory"},
		{query: "SELECT COUNT(*) FROM images WHERE state='yes' AND img_path IS NOT NULL AND img_path LIKE 'no/%'", action: "Clean up: move approved images out of no/ directory"},
		{query: "SELECT COUNT(*) FROM images WHERE (state='no' OR state IS NULL) AND (upres_img_path IS NOT NULL OR upres_thumb_path IS NOT NULL)", action: "Clean up: delete upres files for non-approved images"},
	}

	hasActions := false
	for i := range actions {
		db.QueryRow(actions[i].query).Scan(&actions[i].count)
		if actions[i].count > 0 {
			hasActions = true
			fmt.Fprintf(os.Stderr, "→ %7d  %s\n", actions[i].count, actions[i].action)
		}
	}

	if !hasActions {
		fmt.Fprintf(os.Stderr, "✓ No pending actions - system is consistent\n")
	}
}

// Helper functions
func percent(part, total int) float64 {
	if total == 0 {
		return 0
	}
	return float64(part) * 100.0 / float64(total)
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

// fsCache provides fast cached filesystem access
type fsCache struct {
	dirEntries map[string]map[string]bool // dir -> set of image IDs in that directory
	fileStats  map[string]*fileStatInfo   // absolute path -> stat info
}

type fileStatInfo struct {
	exists bool
	size   int64
	err    error
}

func newFSCache() *fsCache {
	return &fsCache{
		dirEntries: make(map[string]map[string]bool),
		fileStats:  make(map[string]*fileStatInfo),
	}
}

// loadDirectory loads all image IDs from a directory (fast, no Walk)
func (c *fsCache) loadDirectory(dir string) error {
	// Resolve symlinks
	realDir, err := filepath.EvalSymlinks(dir)
	if err != nil {
		return err
	}

	// Open directory
	d, err := os.Open(realDir)
	if err != nil {
		return err
	}
	defer d.Close()

	// Read all entries at once (much faster than Walk)
	entries := make(map[string]bool)
	for {
		names, err := d.Readdirnames(10000) // Read in large batches
		if err != nil && len(names) == 0 {
			break
		}

		for _, name := range names {
			// Skip hidden files
			if strings.HasPrefix(name, ".") {
				continue
			}

			// Extract image ID (filename without extension)
			ext := filepath.Ext(name)
			id := strings.TrimSuffix(name, ext)
			entries[id] = true
		}

		if err != nil {
			break
		}
	}

	c.dirEntries[dir] = entries
	return nil
}

// getDirectoryIDs returns cached image IDs for a directory
func (c *fsCache) getDirectoryIDs(dir string) map[string]bool {
	if ids, ok := c.dirEntries[dir]; ok {
		return ids
	}
	// Try to load if not cached
	if err := c.loadDirectory(dir); err != nil {
		return make(map[string]bool) // Return empty map on error
	}
	return c.dirEntries[dir]
}

// getFileStat returns cached file stat info
func (c *fsCache) getFileStat(path string) *fileStatInfo {
	// Check cache first
	if info, ok := c.fileStats[path]; ok {
		return info
	}

	// Stat the file and cache result
	info := &fileStatInfo{}
	fileInfo, err := os.Stat(path)
	if err != nil {
		info.exists = false
		info.err = err
	} else {
		info.exists = true
		info.size = fileInfo.Size()
	}

	c.fileStats[path] = info
	return info
}
