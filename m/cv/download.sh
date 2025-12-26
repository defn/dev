#!/bin/bash
set -e # Exit on error

# Ensure we're in the right directory
cd ~/m/cv

# Create img directory if it doesn't exist
mkdir -p img

# generate list of downloads
go run blurmap.go -mode download

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

	# Download with wget into img/ directory
	# -nc prevents clobbering and creating .1, .2 files
	# --timeout=10 sets 10 second timeout
	set +e # Temporarily disable exit on error to capture wget exit code
	wget -nc -nv -P img --timeout=10 \
		--user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
		--header="Accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8" \
		--header="Accept-Language: en-US,en;q=0.9" \
		--header="Referer: https://civitai.com/" \
		"$url"
	wget_exit=$?
	set -e # Re-enable exit on error

	# Check wget exit code
	# Exit code 0 = success
	# Exit code 4 = network failure (timeout)
	# Exit code 8 = server issued error response (HTTP 404, 429, etc.)
	if [ $wget_exit -eq 4 ]; then
		echo "ERROR: wget timeout after 10 seconds for $url"
		echo "Network failure or timeout"
		echo "Stopping download process"
		exit 1
	elif [ $wget_exit -eq 8 ]; then
		echo "ERROR: wget HTTP error (exit code 8) for $url"
		echo "This likely means HTTP error (429 rate limit, 404, etc.)"
		echo "Stopping download process"
		exit 1
	elif [ $wget_exit -ne 0 ]; then
		echo "ERROR: wget failed with exit code $wget_exit for $url"
		echo "Stopping download process"
		exit 1
	fi

	echo "Success: $filename"

done <state/downloads.txt

echo "All downloads completed successfully"
