#!/usr/bin/env bash

set -e

p="$1"; shift

source .bash_profile
runmany "$p" '(cd ${1} && nix build && attic push hello result);' m/pkg/*/
