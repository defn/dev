#!/usr/bin/env bash

# nix-prefetch-url https://github.com/tilt-dev/tilt/releases/download/v0.30.10/tilt.0.30.10.linux.x86_64.tar.gz
# nix-build simple.nix --no-out-link

function main {
    set -exfu

    declare -xp

    PATH="$PATH:${gzip}/bin"
    ${gnutar}/bin/tar xvfz "${download}"

    ${coreutils}/bin/mkdir -p "${out}/bin"
    ${findutils}/bin/find . -ls
    ${coreutils}/bin/cp tilt "${out}/bin/"
}

main "$@"
