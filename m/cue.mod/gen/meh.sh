#!/usr/bin/env bash

function main {
    exec 1>"${out}"

    echo "${in[app]}"
    echo "${in[jq]}"
    echo "$@"
}

source b/lib/lib.sh
