#!/usr/bin/env bash

set -efu -o pipefail

website="$1"

env | grep BUILDKITE | sort

shome="$(pwd)"
source ~/.bash_profile

cd "${website}"
$shome/bin/invoke m install
$shome/bin/invoke m package
