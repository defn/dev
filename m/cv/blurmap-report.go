package main

import (
	"database/sql"
	"fmt"
	"os"

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

// generateReport generates and prints database statistics
func generateReport(db *sql.DB) {
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
