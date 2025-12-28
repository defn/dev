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

		page := startPage
		for page <= pageLimit {
			outputFile := filepath.Join(jsDir, fmt.Sprintf("%s-%s-%d.json", prefix, nsfw, page-1))

			// Check if file already exists
			if _, err := os.Stat(outputFile); err == nil {
				fmt.Fprintf(os.Stderr, "    Page %d already exists, loading from cache\n", page-1)
				data, err := ioutil.ReadFile(outputFile)
				if err != nil {
					return fmt.Errorf("failed to read cached file: %w", err)
				}

				var pageData map[string]interface{}
				if err := json.Unmarshal(data, &pageData); err != nil {
					return fmt.Errorf("failed to parse cached JSON: %w", err)
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

				// Check for next page
				metadata, ok := pageData["metadata"].(map[string]interface{})
				if !ok {
					break
				}
				nextPage, ok := metadata["nextPage"].(string)
				if !ok || nextPage == "" || nextPage == "null" {
					break
				}

				page++
				continue
			}

			// Download the page
			var url string
			if page == startPage {
				url = fmt.Sprintf("%s/api/v1/images?nsfw=%s&username=%s", apiURL, nsfw, username)
			} else {
				// Need to construct URL from previous page's nextPage
				prevFile := filepath.Join(jsDir, fmt.Sprintf("%s-%s-%d.json", prefix, nsfw, page-2))
				data, err := ioutil.ReadFile(prevFile)
				if err != nil {
					return fmt.Errorf("failed to read previous page: %w", err)
				}

				var prevData map[string]interface{}
				if err := json.Unmarshal(data, &prevData); err != nil {
					return fmt.Errorf("failed to parse previous JSON: %w", err)
				}

				metadata, ok := prevData["metadata"].(map[string]interface{})
				if !ok {
					break
				}
				nextPage, ok := metadata["nextPage"].(string)
				if !ok || nextPage == "" || nextPage == "null" {
					break
				}
				url = nextPage
			}

			fmt.Fprintf(os.Stderr, "    Downloading page %d...\n", page-1)
			resp, err := http.Get(url)
			if err != nil {
				return fmt.Errorf("failed to download page %d: %w", page-1, err)
			}
			defer resp.Body.Close()

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
