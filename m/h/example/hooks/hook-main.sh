#!/usr/bin/env bash

set -efu

function main {
  case "${1:-}" in
    --config) cat hook.json ;;
    *) bash hook.sh ;;
  esac
}

main "$@"
