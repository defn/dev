package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

func downloadUsersMode() {
	fmt.Fprintf(os.Stderr, "User mode: Downloading user data\n")

	// Load API URL from .env if not provided
	if apiURL == "" {
		var err error
		apiURL, err = loadAPIURLFromEnv()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error loading API URL from .env: %v\n", err)
			os.Exit(1)
		}
	}
	fmt.Fprintf(os.Stderr, "Using API URL: %s\n", apiURL)

	// Parse refresh users from command-line arguments
	refreshUsers := parseRefreshUsersFromArgs(flag.Args())

	var usernames []string
	var err error

	if len(refreshUsers) > 0 {
		// If refresh directories are provided, use those usernames
		fmt.Fprintf(os.Stderr, "Found %d users to refresh from command-line arguments\n", len(refreshUsers))
		for username := range refreshUsers {
			usernames = append(usernames, username)
		}
	} else {
		// Otherwise, read usernames from file
		if usersFile == "" {
			fmt.Fprintf(os.Stderr, "Error: -users-file required when no refresh directories are provided\n")
			os.Exit(1)
		}
		usernames, err = readUsernamesFromFile(usersFile)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error reading usernames file: %v\n", err)
			os.Exit(1)
		}
	}

	fmt.Fprintf(os.Stderr, "Found %d usernames to process\n", len(usernames))

	// Process each username
	skipped := 0
	processed := 0
	refreshed := 0
	for i, username := range usernames {
		// Check if user directory already exists
		prefix := "username-" + username
		userDir := filepath.Join("js-username", prefix)

		// Check if this user should be refreshed (forced re-download)
		// This is only true for users specified via CLI arguments, not from file
		shouldRefresh := refreshUsers[username]

		if _, err := os.Stat(userDir); err == nil && !shouldRefresh {
			fmt.Fprintf(os.Stderr, "\n[%d/%d] Skipping user: %s (already exists in js-username)\n", i+1, len(usernames), username)
			skipped++
			continue
		}

		if shouldRefresh {
			fmt.Fprintf(os.Stderr, "\n[%d/%d] Refreshing user: %s\n", i+1, len(usernames), username)
			refreshed++
		} else {
			fmt.Fprintf(os.Stderr, "\n[%d/%d] Processing user: %s\n", i+1, len(usernames), username)
		}

		if err := downloadUser(username); err != nil {
			fmt.Fprintf(os.Stderr, "Error downloading user %s: %v\n", username, err)
			continue
		}
		processed++
	}

	fmt.Fprintf(os.Stderr, "\nProcessed %d users (%d refreshed), skipped %d existing users\n", processed, refreshed, skipped)
}

// loadAPIURLFromEnv reads the url variable from .env file
func loadAPIURLFromEnv() (string, error) {
	envPath := ".env"
	file, err := os.Open(envPath)
	if err != nil {
		return "", fmt.Errorf("failed to open .env file: %w", err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if strings.HasPrefix(line, "url=") {
			return strings.TrimPrefix(line, "url="), nil
		}
	}

	if err := scanner.Err(); err != nil {
		return "", fmt.Errorf("error reading .env file: %w", err)
	}

	return "", fmt.Errorf("url not found in .env file")
}

// readUsernamesFromFile reads a list of usernames from a text file (one per line)
func readUsernamesFromFile(filename string) ([]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to open usernames file: %w", err)
	}
	defer file.Close()

	var usernames []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line != "" && !strings.HasPrefix(line, "#") {
			usernames = append(usernames, line)
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, fmt.Errorf("error reading usernames file: %w", err)
	}

	return usernames, nil
}

// parseRefreshUsersFromArgs parses command-line arguments as user directories
// Expects paths in the form: js-username/username-{username}
func parseRefreshUsersFromArgs(args []string) map[string]bool {
	refreshUsers := make(map[string]bool)

	for _, arg := range args {
		// Remove trailing slash if present
		arg = strings.TrimSuffix(arg, "/")

		// Get the directory name (last part of path)
		dirName := filepath.Base(arg)

		// Extract username from "username-{username}" format
		if strings.HasPrefix(dirName, "username-") {
			username := strings.TrimPrefix(dirName, "username-")
			refreshUsers[username] = true
		}
	}

	return refreshUsers
}

// findHighestPage finds the highest existing page number for a given nsfw value
func findHighestPage(jsDir, prefix, nsfw string) int {
	highestPage := -1

	// Scan directory for existing pages
	files, err := ioutil.ReadDir(jsDir)
	if err != nil {
		return -1
	}

	// Pattern: {prefix}-{nsfw}-{page}.json
	for _, file := range files {
		name := file.Name()
		expectedPrefix := fmt.Sprintf("%s-%s-", prefix, nsfw)

		if strings.HasPrefix(name, expectedPrefix) && strings.HasSuffix(name, ".json") {
			// Extract page number
			pageStr := strings.TrimPrefix(name, expectedPrefix)
			pageStr = strings.TrimSuffix(pageStr, ".json")

			var pageNum int
			if _, err := fmt.Sscanf(pageStr, "%d", &pageNum); err == nil {
				if pageNum > highestPage {
					highestPage = pageNum
				}
			}
		}
	}

	return highestPage
}

// loadCachedPages loads all cached pages into allItems map
func loadCachedPages(jsDir, prefix, nsfw string, highestPage int, allItems map[string]interface{}) error {
	fmt.Fprintf(os.Stderr, "    Loading %d cached pages...\n", highestPage+1)

	for page := 0; page <= highestPage; page++ {
		outputFile := filepath.Join(jsDir, fmt.Sprintf("%s-%s-%d.json", prefix, nsfw, page))

		data, err := ioutil.ReadFile(outputFile)
		if err != nil {
			return fmt.Errorf("failed to read cached page %d: %w", page, err)
		}

		var pageData map[string]interface{}
		if err := json.Unmarshal(data, &pageData); err != nil {
			return fmt.Errorf("failed to parse cached page %d: %w", page, err)
		}

		// Collect items from this page
		if items, ok := pageData["items"].([]interface{}); ok {
			for _, item := range items {
				if itemMap, ok := item.(map[string]interface{}); ok {
					if id, ok := itemMap["id"]; ok {
						allItems[fmt.Sprintf("%v", id)] = item
					}
				}
			}
		}
	}

	return nil
}

// downloadUser downloads all data for a single user from the API
func downloadUser(username string) error {
	prefix := "username-" + username
	userDir := filepath.Join("js-username", prefix)
	jsDir := filepath.Join(userDir, "js")

	// Create directory structure
	if err := os.MkdirAll(jsDir, 0755); err != nil {
		return fmt.Errorf("failed to create directory %s: %w", jsDir, err)
	}

	// Download for both NSFW true and false
	nsfwValues := []string{"true", "false"}
	allItems := make(map[string]interface{})

	for _, nsfw := range nsfwValues {
		fmt.Fprintf(os.Stderr, "  Downloading with nsfw=%s...\n", nsfw)

		// Find highest existing page
		highestPage := findHighestPage(jsDir, prefix, nsfw)

		var startURL string
		var startPageNum int

		if highestPage >= 0 {
			// Pages exist - load cached pages and continue from last page
			fmt.Fprintf(os.Stderr, "    Found existing pages 0-%d\n", highestPage)

			// Load all cached pages into allItems
			if err := loadCachedPages(jsDir, prefix, nsfw, highestPage, allItems); err != nil {
				return err
			}

			// Read last page to get nextPage cursor
			lastPageFile := filepath.Join(jsDir, fmt.Sprintf("%s-%s-%d.json", prefix, nsfw, highestPage))
			data, err := ioutil.ReadFile(lastPageFile)
			if err != nil {
				return fmt.Errorf("failed to read last page: %w", err)
			}

			var lastPageData map[string]interface{}
			if err := json.Unmarshal(data, &lastPageData); err != nil {
				return fmt.Errorf("failed to parse last page JSON: %w", err)
			}

			// Get nextPage cursor
			metadata, ok := lastPageData["metadata"].(map[string]interface{})
			if !ok {
				fmt.Fprintf(os.Stderr, "    No more pages (no metadata in last page)\n")
				continue
			}

			nextPage, ok := metadata["nextPage"].(string)
			if !ok || nextPage == "" || nextPage == "null" {
				fmt.Fprintf(os.Stderr, "    No more pages (nextPage is null)\n")
				continue
			}

			startURL = nextPage
			startPageNum = highestPage + 1
			fmt.Fprintf(os.Stderr, "    Continuing from page %d...\n", startPageNum)
		} else {
			// No pages exist - start fresh
			fmt.Fprintf(os.Stderr, "    No existing pages, starting fresh\n")
			startURL = fmt.Sprintf("%s/api/v1/images?nsfw=%s&username=%s", apiURL, nsfw, username)
			startPageNum = 0
		}

		// Download new pages
		page := startPageNum
		currentURL := startURL

		for page <= pageLimit {
			outputFile := filepath.Join(jsDir, fmt.Sprintf("%s-%s-%d.json", prefix, nsfw, page))

			fmt.Fprintf(os.Stderr, "    Downloading page %d...\n", page)
			resp, err := http.Get(currentURL)
			if err != nil {
				// Stale/invalid cursor - treat as finished
				fmt.Fprintf(os.Stderr, "    Failed to download page %d (stale cursor?): %v\n", page, err)
				fmt.Fprintf(os.Stderr, "    Treating as end of pagination\n")
				break
			}
			defer resp.Body.Close()

			// Check for errors in response
			if resp.StatusCode != 200 {
				fmt.Fprintf(os.Stderr, "    Got HTTP %d for page %d (stale cursor?)\n", resp.StatusCode, page)
				fmt.Fprintf(os.Stderr, "    Treating as end of pagination\n")
				break
			}

			body, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				return fmt.Errorf("failed to read response: %w", err)
			}

			// Save raw response
			if err := ioutil.WriteFile(outputFile, body, 0644); err != nil {
				return fmt.Errorf("failed to write output file: %w", err)
			}

			// Parse the response
			var pageData map[string]interface{}
			if err := json.Unmarshal(body, &pageData); err != nil {
				return fmt.Errorf("failed to parse JSON: %w", err)
			}

			// Collect items from this page
			if items, ok := pageData["items"].([]interface{}); ok {
				for _, item := range items {
					if itemMap, ok := item.(map[string]interface{}); ok {
						if id, ok := itemMap["id"]; ok {
							allItems[fmt.Sprintf("%v", id)] = item
						}
					}
				}
			}

			// Check if there's a next page
			metadata, ok := pageData["metadata"].(map[string]interface{})
			if !ok {
				break
			}
			nextPage, ok := metadata["nextPage"].(string)
			if !ok || nextPage == "" || nextPage == "null" {
				break
			}

			currentURL = nextPage
			page++
		}
	}

	// Create aggregated output
	aggregatedFile := filepath.Join(userDir, fmt.Sprintf("js-%s.json", prefix))
	aggregatedData, err := json.MarshalIndent(allItems, "", "  ")
	if err != nil {
		return fmt.Errorf("failed to marshal aggregated data: %w", err)
	}

	if err := ioutil.WriteFile(aggregatedFile, aggregatedData, 0644); err != nil {
		return fmt.Errorf("failed to write aggregated file: %w", err)
	}

	// Create .js.json file (array of items)
	jsFile := filepath.Join(userDir, fmt.Sprintf("js-%s.json.js.json", prefix))
	var itemsArray []interface{}
	for _, item := range allItems {
		itemsArray = append(itemsArray, item)
	}

	jsData, err := json.MarshalIndent(itemsArray, "", "  ")
	if err != nil {
		return fmt.Errorf("failed to marshal js data: %w", err)
	}

	if err := ioutil.WriteFile(jsFile, jsData, 0644); err != nil {
		return fmt.Errorf("failed to write js file: %w", err)
	}

	fmt.Fprintf(os.Stderr, "  Downloaded %d unique items for user %s\n", len(allItems), username)
	return nil
}
