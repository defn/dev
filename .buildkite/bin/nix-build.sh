#!/usr/bin/env bash

set -e
source .bash_profile
runmany '(cd ${1} && nix build && attic push hello result);' m/pkg/*/