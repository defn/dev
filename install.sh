#!/usr/bin/env bash

set -efu -o pipefail

function main {
    sudo apt update
    sudo apt install -y make direnv
    make install
}

main "$@"