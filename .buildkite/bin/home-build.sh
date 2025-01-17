#!/usr/bin/env bash

set -e

source .bash_profile
cd m/i
export GITHUB_TOKEN="$(buildkite-agent secret get GITHUB_TOKEN)"
make latest
