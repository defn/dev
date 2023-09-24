#!/usr/bin/env bash

function main {
  echo "=========================================================="
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "objects: \(.objects//[] | .[].object.metadata | "\(.namespace) \(.name)")"'
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "keys: \(keys)"'
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "type: \(.type)"'
  cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "binding: \(.binding)"'
  echo "=========================================================="
}

main "$@"