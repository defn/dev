#!/usr/bin/env bash

set -efu -o pipefail

function main {
    sudo apt update
    sudo apt install -y make direnv curl xz-utils dirmngr gpg rsync
    source .bash_profile
    make install
    make sync
    make install
}

main "$@"