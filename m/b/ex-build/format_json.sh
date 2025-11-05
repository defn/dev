#!/usr/bin/env bash

# Formats JSON with optional indentation
function main {
    local input="${in[input]}"
    local indent="${in[indent]:-2}"
    local out="${shome}/${out}"

    jq --indent "${indent}" . < "${input}" > "${out}"
}

source b/lib/lib.sh
