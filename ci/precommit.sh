#!/usr/bin/env bash

function main {
    set -efu

    ./bin/e pre-commit run -a
}

main "$@"
