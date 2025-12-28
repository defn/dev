#!/bin/bash
set -e # Exit on error

# Ensure we're in the right directory
cd ~/m/cv

# Create img directory if it doesn't exist
mkdir -p img

# generate list of downloads
# go run blurmap.go -mode download

while IFS= read -r url; do
	# Extract filename from URL
	filename="${url##*/}"

	# Skip if file already exists (even 0-byte files are markers to skip)
	if [ -f "img/$filename" ]; then
		echo "Skip: $filename (already exists)"
		continue
	fi

	# Check if this is an mp4 file - just touch it instead of downloading
	if [[ $filename == *.mp4 ]]; then
		echo "Touching: $filename (mp4 files are zero-length)"
		touch "img/$filename"
		echo "Success: $filename"
		continue
	fi

	echo "Downloading: $filename"

	# Extract domain from URL for Referer header (scheme://host/)
	referer=$(echo "$url" | sed -E 's|(^https?://[^/]+).*|\1/|')

	# Download with wget into img/ directory
	# -nc prevents clobbering and creating .1, .2 files
	# timeout 10 limits total execution time to 10 seconds (exit code 124 if exceeded)
	# No wget timeout so we can distinguish timeout (124) from wget errors (4, 8, etc.)
	set +e # Temporarily disable exit on error to capture wget exit code
	timeout 10 wget -nc -nv -P img \
		--user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
		--header="Accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8" \
		--header="Accept-Language: en-US,en;q=0.9" \
		--header="Referer: $referer" \
		"$url"
	wget_exit=$?
	set -e # Re-enable exit on error

	# Check wget exit code
	# Exit code 0 = success
	# Exit code 4 = network failure
	# Exit code 8 = server issued error response (HTTP 404, 429, etc.)
	# Exit code 124 = timeout command killed process after 10 seconds
	if [ $wget_exit -eq 124 ]; then
		echo "ERROR: timeout killed wget after 10 seconds for $url"
		echo "Process exceeded time limit - skipping"
		continue
	elif [ $wget_exit -eq 4 ]; then
		echo "ERROR: wget network failure for $url"
		echo "Network error - skipping"
		continue
	elif [ $wget_exit -eq 8 ]; then
		echo "ERROR: wget HTTP error (exit code 8) for $url"
		echo "This likely means HTTP error (429 rate limit, 404, etc.) - skipping"
		continue
	elif [ $wget_exit -ne 0 ]; then
		echo "ERROR: wget failed with exit code $wget_exit for $url"
		echo "Skipping this download"
		continue
	fi

	echo "Success: $filename"

done <state/downloads.txt

echo "All downloads completed successfully"
