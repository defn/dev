#!/usr/bin/env bash

# Extracts and displays bundle information
function main {
    local bundle="${in[bundle]}"
    local out="${shome}/${out}"

    {
        echo "=== Bundle Information ==="
        echo "Size: $(stat -c%s "${bundle}") bytes"
        echo ""
        echo "=== Manifest ==="
        tar xzf "${bundle}" -O ./manifest.txt
        echo ""
        echo "=== File List ==="
        tar tzf "${bundle}"
    } > "${out}"
}

source b/lib/lib.sh
