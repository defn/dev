#!/usr/bin/env bash

set -efuo pipefail

function main {
  local image_save

  image_save="$1"
  shift

  docker load --input="${image_save}"
}

main "$@"
