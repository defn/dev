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

	// 1. Database Statistics
	reportDatabaseStats(db)

	// 2. Filesystem → Database Sync
	reportFilesystemSync(db)

	// 3. Database → Filesystem References
	reportDatabaseReferences(db)

	// 4. Data Quality Issues
	reportDataQuality(db)

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
	var urlCount, weirdCount int

	db.QueryRow("SELECT COUNT(*) FROM images").Scan(&totalCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='yes'").Scan(&yesCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state='no'").Scan(&noCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE state IS NULL").Scan(&todoCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE img_path IS NOT NULL").Scan(&imgPathCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE thumb_path IS NOT NULL").Scan(&thumbCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_img_path IS NOT NULL").Scan(&upresImgCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_thumb_path IS NOT NULL").Scan(&upresThumbCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE url IS NOT NULL").Scan(&urlCount)
	db.QueryRow("SELECT COUNT(*) FROM images WHERE weird IS NOT NULL").Scan(&weirdCount)

	fmt.Fprintf(os.Stderr, "Total records:         %7d\n", totalCount)
	fmt.Fprintf(os.Stderr, "\nCuration state:\n")
	fmt.Fprintf(os.Stderr, "  Approved (yes):      %7d  (%.1f%%)\n", yesCount, percent(yesCount, totalCount))
	fmt.Fprintf(os.Stderr, "  Rejected (no):       %7d  (%.1f%%)\n", noCount, percent(noCount, totalCount))
	fmt.Fprintf(os.Stderr, "  Todo (uncurated):    %7d  (%.1f%%)\n", todoCount, percent(todoCount, totalCount))

	fmt.Fprintf(os.Stderr, "\nFile tracking:\n")
	fmt.Fprintf(os.Stderr, "  With img_path:       %7d  (%.1f%%)\n", imgPathCount, percent(imgPathCount, totalCount))
	fmt.Fprintf(os.Stderr, "  With thumb_path:     %7d  (%.1f%%)\n", thumbCount, percent(thumbCount, totalCount))
	fmt.Fprintf(os.Stderr, "  With upres images:   %7d  (%.1f%%)\n", upresImgCount, percent(upresImgCount, totalCount))
	fmt.Fprintf(os.Stderr, "  With upres thumbs:   %7d  (%.1f%%)\n", upresThumbCount, percent(upresThumbCount, totalCount))
	fmt.Fprintf(os.Stderr, "  With source URL:     %7d  (%.1f%%)\n", urlCount, percent(urlCount, totalCount))

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
func reportFilesystemSync(db *sql.DB) {
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

		// Count files in filesystem
		fsIDs := make(map[string]bool)
		realDir, err := filepath.EvalSymlinks(check.dir)
		if err != nil {
			fmt.Fprintf(os.Stderr, "%-18s SKIP (not found)\n", check.dir+":")
			continue
		}

		filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
			if err != nil || info.IsDir() {
				return nil
			}
			basename := filepath.Base(path)
			if strings.HasPrefix(basename, ".") {
				return nil // Skip hidden files
			}
			ext := filepath.Ext(basename)
			id := strings.TrimSuffix(basename, ext)
			fsIDs[id] = true
			return nil
		})
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
func reportDatabaseReferences(db *sql.DB) {
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

			info, err := os.Stat(path)
			if err != nil {
				check.missing++
				allGood = false
			} else if info.Size() == 0 {
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
func reportDataQuality(db *sql.DB) {
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
		{query: "SELECT COUNT(*) FROM images WHERE state='no' AND img_path IS NOT NULL AND img_path LIKE 'yes/%'", action: "Clean up: move rejected images out of yes/ directory"},
		{query: "SELECT COUNT(*) FROM images WHERE state='yes' AND img_path IS NOT NULL AND img_path LIKE 'no/%'", action: "Clean up: move approved images out of no/ directory"},
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
