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
find fm/W -type f | cut -d/ -f3 | sort | while read -r a; do
  # Log current file being processed to stderr
  echo $a 1>&2

  # Generate master index entry: clickable thumbnail linking to detail page
  echo "<a href=\"W/$a.html\"><img src=\"fm/W/$a\"></a>"

  # Find all variant images in w-* directories that match this filename
  # Create individual detail page showing main image and all variants
  # pub/W/UUID.html -> ../w/w-02/2/#w-02-UUID
  (
    cat <<'EOF'
<!DOCTYPE html>
  <html>
  <head>
    <title>Gallery</title>
  </head>
  <body>
    <div id="gallery-container"></div> 
    <script>
    function generateGalleryImageTag(imageSrc) {
      try {
        // Always use current page URL
        const urlObj = new URL(window.location.href);

        // Extract page number from query parameters
        const pageParam = urlObj.searchParams.get('page');
        if (!pageParam) {
          throw new Error('Missing page parameter');
        }

        // Extract anchor/fragment (remove the # if present)
        const anchor = urlObj.hash.replace('#', '');
        if (!anchor) {
          throw new Error('Missing anchor fragment');
        }

        // Extract w-NN prefix from anchor
        const wPrefixMatch = anchor.match(/^(w-\d+)-/);
        if (!wPrefixMatch) {
          throw new Error('Invalid anchor format - missing w-NN prefix');
        }
        const wPrefix = wPrefixMatch[1]; // e.g., "w-02"

        // Extract UUID by removing w-NN- prefix and .png extension
        const uuid = anchor.replace(/^w-\d+-/, '').replace('.png', '');

        // Generate the gallery path with ../w/ prefix
        const galleryPath = `../w/${wPrefix}/${pageParam}/#${wPrefix}-${uuid}`;

        // Generate the HTML with img tag wrapped in a tag
        return `<a href="${galleryPath}"><img src="${imageSrc}"></a>`;

      } catch (error) {
        console.error('Error generating gallery image tag:', error.message);
        // Fallback: return img tag without link
        return `<img src="${imageSrc}">`;
      }
    }
EOF

    ls fm/w-*/*-$a | sort | while read -r b; do
      echo "document.getElementById('gallery-container').innerHTML += generateGalleryImageTag('../$b');"
    done

  cat <<'EOF'
    </script>
  </body>
  </html>
EOF
  ) > W/$a.html
done > W.html

