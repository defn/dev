#!/usr/bin/env bash

set -e

if [[ -z ${1-} ]]; then
	p="$(echo "$(nproc) / 4" | bc)"
else
	p="$1"
	shift
fi

source .bash_profile
runmany "$p" '(cd ${1} && nix build && attic push hello result);' m/pkg/*/
