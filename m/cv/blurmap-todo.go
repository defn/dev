package main

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/mattn/go-sqlite3"
)

func todoMode() {
	fmt.Fprintf(os.Stderr, "Todo mode: Finding uncurated images from database\n")

	// Open database
	dbPath := "cv.db"
	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error opening database: %v\n", err)
		os.Exit(1)
	}
	defer db.Close()

	// Create state directory
	if err := os.MkdirAll("state", 0755); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating state directory: %v\n", err)
		os.Exit(1)
	}

	// Query for uncurated images from database
	// Images that have img_path (downloaded) but no state (not curated) and not weird (not zero-byte)
	fmt.Fprintf(os.Stderr, "Querying database for uncurated images...\n")
	rows, err := db.Query(`
		SELECT id FROM images
		WHERE img_path IS NOT NULL
		AND img_path != ''
		AND (state IS NULL OR state = '')
		AND (weird IS NULL OR weird = '')
		ORDER BY id
	`)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error querying database: %v\n", err)
		os.Exit(1)
	}
	defer rows.Close()

	var uncurated []string
	for rows.Next() {
		var id string
		if err := rows.Scan(&id); err != nil {
			fmt.Fprintf(os.Stderr, "Error scanning row: %v\n", err)
			continue
		}
		uncurated = append(uncurated, id)
	}

	if err := rows.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "Error iterating rows: %v\n", err)
		os.Exit(1)
	}

	fmt.Fprintf(os.Stderr, "Found %d uncurated images\n", len(uncurated))

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
