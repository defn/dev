#!/usr/bin/env bash

set -efu

function config {
  cat config.json
}

function hook {
  echo "=========================================================="
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "objects: \(.objects//[] | .[].object.metadata | "\(.namespace) \(.name)")"'
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "keys: \(keys)"'
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "type: \(.type)"'
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "binding: \(.binding)"'
  echo "=========================================================="
}

function main {
  case "${1:-}" in
    --config) config ;;
    *) hook ;;
  esac
}

main "$@"
