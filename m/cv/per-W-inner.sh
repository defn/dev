#!/usr/bin/env bash

a=$1; shift

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

        // Extract w-NN prefix from imageSrc path
        const imageSrcMatch = imageSrc.match(/\/w-(\d+)\//);
        if (!imageSrcMatch) {
          throw new Error('Invalid imageSrc format - missing w-NN directory');
        }
        const wPrefix = `w-${imageSrcMatch[1]}`; // e.g., "w-02"

        // Extract UUID by removing w-NN- prefix and .png extension
        const uuid = anchor.replace(/^w-\d+-/, '');

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

