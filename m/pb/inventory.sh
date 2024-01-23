#!/usr/bin/env bash

function main {
    cue export --out=json -e inventory
}

main "$@"
