#!/usr/bin/env bash

set -exu pipefail

env | grep BUILDKITE | sort

shome="$(pwd)"
source ~/.bash_profile
$shome/bin/invoke m install
$shome/bin/invoke m package
