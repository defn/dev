#!/usr/bin/env bash

#
# Per-W HTML Gallery Generator
# ============================
#
# This script generates HTML gallery pages for image collections organized
# in a specific directory structure. It creates both individual image pages
# and a master index page linking to all images.
#
# Directory Structure Expected:
#   fm/W/           - Main images directory
#   fm/w-*/         - Related/variant image directories (e.g., w-01/, w-02/)
#   W/              - Output directory for generated HTML files
#
# Output:
#   W.html          - Master index page with thumbnails linking to detail pages
#   W/*.html        - Individual pages for each image showing variants
#
# Functionality:
# 1. Scans fm/W/ directory for all image files
# 2. For each image, creates a detail page showing the main image plus variants
# 3. Variants are found by matching filenames across w-* subdirectories
# 4. Generates a master index page with clickable thumbnails
#
# Usage:
#   ./per-W.sh
#
# Example Output Structure:
#   W.html contains: <a href="W/image001.png.html"><img src="fm/W/image001.png"></a>
#   W/image001.png.html contains: <img src="../fm/w-01/prefix-image001.png">
#                                 <img src="../fm/w-02/other-image001.png">
#

# Process each file in the main W directory
find fm/W -type f | cut -d/ -f3 | sort | runmany 8 './per-W-inner.sh $1' > W.html

