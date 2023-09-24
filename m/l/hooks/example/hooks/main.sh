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
  echo $BINDING_CONTEXT_PATH
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | keys'
  echo "=========================================================="
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "\(.type)"'
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "\(.binding)"'
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "\(.objects//[] | .[].object.metadata | "\(.namespace) \(.name)")"'
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
