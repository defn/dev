#!/usr/bin/env bash

set -exfu

function config {
  jq -n '{configVersion: "v1", onStartup: 1}'
}

function main {
  echo "OnStartup shell hook"
}

function route {
  case "${1:-}" in
    --config)
      config
      ;;
    *)
      main
      ;;
  esac
}

route "$@"
