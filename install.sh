#!/usr/bin/env bash

set -efu -o pipefail

function main {
    sudo apt update
    # sync with m/Dockerfile
    sudo apt install -y  make direnv curl xz-utils dirmngr gpg rsync build-essential sudo locales git rsync tini iproute2 iptables
    source .bash_profile
    make install
    make sync
    make install
}

main "$@"