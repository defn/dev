#!/usr/bin/env bash

set -efu

function ctx_index  {
  cat $BINDING_CONTEXT_PATH | jq -r 'keys[]'
}

function ctx_binding {
  local i
  i="$1"; shift
  cat $BINDING_CONTEXT_PATH | jq -r --arg i "$i" '.[$i | tonumber] | .binding'
}

function ctx_type {
  i="$1"; shift
  cat $BINDING_CONTEXT_PATH | jq -r --arg i "$i" '.[$i | tonumber] | .type'
}

function hook {
  for i in $(ctx_index); do
    echo "====[ $i ]======================================================"
    case "$(ctx_binding "$i")" in
      onStartup)
        echo "Starting..."
        ;;
      kubernetes)
        case "$(ctx_type "$i")" in
          Synchronization)
            cat $BINDING_CONTEXT_PATH | jq -cr '.[] | "objects: \(.objects//[] | .[].object.metadata | "\(.namespace) \(.name)")"'
            echo $KUBERNETES_PATCH_PATH
            ;;
          *)
            echo "Unknown type: $(ctx_type "$i")"
            ;;
        esac
        ;;
      *)
        echo "Unknown binding: $(ctx_binding "$i")"
        ;;
    esac
    echo "====[ $i ]======================================================"
  done
}

function main {
  case "${1:-}" in
    --config) cat hook.json ;;
    *) hook ;;
  esac
}

main "$@"
