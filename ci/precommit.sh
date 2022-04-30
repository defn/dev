#!/usr/bin/env bash

function main {
    set -efu

    ./bin/e pre-commit run -a
    mkdir -p meh
    touch "meh/meh-$(date +%s)"
    find meh -ls
}

main "$@"
