package main

import (
	"database/sql"
	"fmt"
	"os"
	"path/filepath"
	"sync"

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

	// Query statistics
	var totalCount, todoCount, yesCount, noCount, yesUpresImgCount, yesUpresThumbCount int

	// Total count
	if err := db.QueryRow("SELECT COUNT(*) FROM images").Scan(&totalCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying total count: %v\n", err)
		os.Exit(1)
	}

	// Todo (NULL state)
	if err := db.QueryRow("SELECT COUNT(*) FROM images WHERE state IS NULL").Scan(&todoCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying todo count: %v\n", err)
		os.Exit(1)
	}

	// Yes (approved)
	if err := db.QueryRow("SELECT COUNT(*) FROM images WHERE state='yes'").Scan(&yesCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying yes count: %v\n", err)
		os.Exit(1)
	}

	// No (rejected)
	if err := db.QueryRow("SELECT COUNT(*) FROM images WHERE state='no'").Scan(&noCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying no count: %v\n", err)
		os.Exit(1)
	}

	// Yes with upres images
	if err := db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_img_path IS NOT NULL").Scan(&yesUpresImgCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying upres img count: %v\n", err)
		os.Exit(1)
	}

	// Yes with upres thumbnails
	if err := db.QueryRow("SELECT COUNT(*) FROM images WHERE upres_thumb_path IS NOT NULL").Scan(&yesUpresThumbCount); err != nil {
		fmt.Fprintf(os.Stderr, "Error querying upres thumb count: %v\n", err)
		os.Exit(1)
	}

	// Count files in directories (in parallel)
	type dirCount struct {
		dir   string
		count int
	}

	countFiles := func(dir string) int {
		// Resolve symlinks
		realDir, err := filepath.EvalSymlinks(dir)
		if err != nil {
			return 0 // Directory doesn't exist or can't be resolved
		}

		count := 0
		filepath.Walk(realDir, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return nil // Skip errors
			}
			if !info.IsDir() {
				count++
			}
			return nil
		})
		return count
	}

	// Parallel counting
	dirs := []string{"yes", "no", "img", "replicate/img", "replicate/t2"}
	results := make(chan dirCount, len(dirs))
	var wg sync.WaitGroup

	for _, dir := range dirs {
		wg.Add(1)
		go func(d string) {
			defer wg.Done()
			results <- dirCount{dir: d, count: countFiles(d)}
		}(dir)
	}

	wg.Wait()
	close(results)

	// Collect results
	counts := make(map[string]int)
	for r := range results {
		counts[r.dir] = r.count
	}

	fsYesCount := counts["yes"]
	fsNoCount := counts["no"]
	fsImgCount := counts["img"]
	fsUpresImgCount := counts["replicate/img"]
	fsUpresThumbCount := counts["replicate/t2"]

	// Display report
	fmt.Fprintf(os.Stderr, "\nImage Database Report:\n")
	fmt.Fprintf(os.Stderr, "=====================\n\n")

	fmt.Fprintf(os.Stderr, "Database Counts:\n")
	fmt.Fprintf(os.Stderr, "  Total images:       %d\n", totalCount)
	fmt.Fprintf(os.Stderr, "  Todo:               %d\n", todoCount)
	fmt.Fprintf(os.Stderr, "  Yes (approved):     %d\n", yesCount)
	fmt.Fprintf(os.Stderr, "  No (rejected):      %d\n", noCount)
	fmt.Fprintf(os.Stderr, "  Upres images:       %d\n", yesUpresImgCount)
	fmt.Fprintf(os.Stderr, "  Upres thumbnails:   %d\n", yesUpresThumbCount)

	fmt.Fprintf(os.Stderr, "\nFilesystem Counts:\n")
	fmt.Fprintf(os.Stderr, "  img/:               %d", fsImgCount)
	if fsImgCount == totalCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		diff := fsImgCount - totalCount
		if diff > 0 {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: +%d)\n", totalCount, diff)
		} else {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: %d)\n", totalCount, diff)
		}
	}

	fmt.Fprintf(os.Stderr, "  yes/:               %d", fsYesCount)
	if fsYesCount == yesCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		diff := fsYesCount - yesCount
		if diff > 0 {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: +%d)\n", yesCount, diff)
		} else {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: %d)\n", yesCount, diff)
		}
	}

	fmt.Fprintf(os.Stderr, "  no/:                %d", fsNoCount)
	if fsNoCount == noCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		diff := fsNoCount - noCount
		if diff > 0 {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: +%d)\n", noCount, diff)
		} else {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: %d)\n", noCount, diff)
		}
	}

	fmt.Fprintf(os.Stderr, "  replicate/img/:     %d", fsUpresImgCount)
	if fsUpresImgCount == yesUpresImgCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		diff := fsUpresImgCount - yesUpresImgCount
		if diff > 0 {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: +%d)\n", yesUpresImgCount, diff)
		} else {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: %d)\n", yesUpresImgCount, diff)
		}
	}

	fmt.Fprintf(os.Stderr, "  replicate/t2/:      %d", fsUpresThumbCount)
	if fsUpresThumbCount == yesUpresThumbCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		diff := fsUpresThumbCount - yesUpresThumbCount
		if diff > 0 {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: +%d)\n", yesUpresThumbCount, diff)
		} else {
			fmt.Fprintf(os.Stderr, " ✗ (DB: %d, diff: %d)\n", yesUpresThumbCount, diff)
		}
	}

	fmt.Fprintf(os.Stderr, "\nState Verification:\n")
	fmt.Fprintf(os.Stderr, "  %d + %d + %d = %d", todoCount, yesCount, noCount, todoCount+yesCount+noCount)
	if todoCount+yesCount+noCount == totalCount {
		fmt.Fprintf(os.Stderr, " ✓\n")
	} else {
		fmt.Fprintf(os.Stderr, " ✗ (expected %d)\n", totalCount)
	}
}
