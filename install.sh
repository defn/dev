#!/usr/bin/env bash

set -efu -o pipefail

function main {
    sudo apt update
    sudo apt install -y make direnv
    source .bash_profile
    make install
}

main "$@"