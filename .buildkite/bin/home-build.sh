#!/usr/bin/env bash

set -efu -o pipefail

source .bash_profile

case "${BUILDKITE_BRANCH:-}" in
  main)
    cd m
    source ~/work/.buildkite/.env
    j base
    ;;
esac
