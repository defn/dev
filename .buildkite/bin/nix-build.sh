#!/usr/bin/env bash

set -e

if [[ -z ${1-} ]]; then
	p="$(echo "$(nproc) / 4" | bc)"
else
	p="$1"
	shift
fi

source .bash_profile
# trunk-ignore(shellcheck/SC2016): ${1} is quoted so it can be evaluated in a runmany sub-shell
runmany "$p" '(cd ${1} && nix build && attic push hello result);' m/pkg/*/
