#!/usr/bin/env bash

function main {
    cat "${in[config]}" | "${in[jq]}" > "${out}"
}

source b/lib/lib.sh
