#!/usr/bin/env bash

#
# Face/Image Manipulation (FaceSwap) Gallery Generator
# ===================================================
#
# This script generates face-swapped or style-transferred images using a local
# ML model server. It processes images from a source directory and creates
# variations by applying different reference images or styles.
#
# Requirements:
# - Local ML model server running on localhost:5000
# - Server must accept POST requests with base64-encoded images
# - ImageMagick for file type detection
# - jq for JSON processing
#
# Directory Structure:
#   pub/W/           - Source images to be processed
#   pub/w-*/         - Reference/style directories (e.g., w-01/, w-02/)
#   pub/w-*/*.png    - Reference images for each style
#   pub/w-*/w-*-*    - Generated output images
#
# Usage:
#   ./fem.sh [model_name]
#   
# Parameters:
#   model_name    - Optional model identifier (default: "meh")
#
# Process:
# 1. For each source image in pub/W/
# 2. For each reference style directory w-*
# 3. Generate face-swapped/style-transferred versions
# 4. Retry up to 3 times if generation fails
# 5. Validate output as JPEG before accepting
#

# Set default model if none provided
if [[ -z ${1-} ]]; then
	set -- meh
fi

export model="$1"
shift

# Core function to call the ML model API with two images
# Encodes both images as base64 and sends them to the prediction endpoint
# Parameters:
#   $1 - Input image file path (source image)
#   $2 - Reference/swap image file path (target style/face)
# Returns: JSON response from the ML model
function fm {
	(
		# Build JSON payload with base64-encoded images
		echo '{ "input": {'

		# Encode input image as base64 data URI
		echo '"input_image": "data:image/jpeg;base64,'$(cat $1 | base64 -w 0)'",'
		# Encode reference/swap image as base64 data URI
		echo '"swap_image": "data:image/jpeg;base64,'$(cat $2 | base64 -w 0)'"'

		echo '} }'
	) | curl -s -X POST -H "Content-Type: application/json" -d @- http://localhost:5000/predictions
}

# Wrapper function that calls fm() and processes the response
# Extracts base64 image from JSON response, decodes it, and validates the result
# Parameters:
#   $1 - Input image file path
#   $2 - Reference image file path  
#   $3 - Output file path
# Process:
#   1. Calls fm() to get JSON response
#   2. Extracts base64 data from .output field
#   3. Decodes base64 to binary image data
#   4. Validates result is a valid JPEG
#   5. Only saves file if validation passes
function fmpost {
	# Call ML model and extract base64 image data
	fm "$1" "$2" | jq -r .output | cut -d, -f2- | base64 -d >"$3.tmp"
	# Validate the output is a valid JPEG before accepting it
	if file "$3.tmp" | grep -q "JPEG image data"; then
		mv -v "$3.tmp" "$3"
	fi
}

export -f fm
export -f fmpost

# Main processing function that generates all missing gallery images
# Processes each source image against each reference style with retry logic
function main {
	# Generate gallery images if missing
	# Find all source images in pub/W directory
	find pub/W -maxdepth 1 -type f -name '*.png' | xargs -n1 basename | sort | while read -r a; do
		echo "W = $a" 1>&2
		export a
		# For each source image, process against all style directories
		# Use runmany for parallel processing (5 concurrent jobs)
		find pub/ -maxdepth 1 -type d -name 'w-*' | cut -d/ -f2 | sort | runmany 5 '
      b="${1%%/}"  # Remove trailing slash from directory name
      # Retry up to 3 times for each image generation
      for n in 1 2 3; do
        # Only generate if output file doesnt already exist
        if ! test -f pub/$b/$b-$a; then
          echo "Processing: $b style + $a source -> $b-$a"
          echo "$b $a $(fmpost pub/W/$a pub/$b.png pub/$b/$b-$a)"
        fi
      done
    '
	done
}

main "$@"
