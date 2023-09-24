#!/usr/bin/env bash

set -efu

function config {
  jq -n '{
    configVersion: "v1",
    onStartup: 1,
    kubernetes: [{
      apiVersion: "v1",
      kind: "Pod",
      executeHookOnEvent: [
        "Added"
      ]
    }]
  }'
}

function main {
  echo "=========================================================="
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "objects: \(.objects//[] | .[].object.metadata | "\(.namespace) \(.name)")"'
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "keys: \(keys)"'
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "type: \(.type)"'
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "binding: \(.binding)"'
  echo "=========================================================="
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
