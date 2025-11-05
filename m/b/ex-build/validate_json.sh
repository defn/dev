#!/usr/bin/env bash

# Validates JSON and reports schema info
function main {
    local input="${in[input]}"
    local out="${shome}/${out}"

    {
        if jq empty < "${input}" 2>/dev/null; then
            echo "Valid JSON: ${input}"
            echo "Keys:"
            jq -r 'keys[]' < "${input}" 2>/dev/null || echo "  (not an object)"
        else
            echo "Invalid JSON: ${input}"
        fi
    } > "${out}"
}

source b/lib/lib.sh
