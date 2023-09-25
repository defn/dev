#!/usr/bin/env bash

set -efu

function ctx_index  {
  cat $BINDING_CONTEXT_PATH | jq -r 'keys[]' | xargs
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

function ctx_watch_event {
  i="$1"; shift
  cat $BINDING_CONTEXT_PATH | jq -r --arg i "$i" '.[$i | tonumber] | .watchEvent'
}

function hook {
  for i in $(ctx_index); do
    echo "====[ $i / $(ctx_index) ]======================================================"
    echo "Binding : $(ctx_binding "$i")"
    case "$(ctx_binding "$i")" in
      onStartup)
        echo "Starting..."
        ;;
      ConfigMap|Pod)
        echo "Type: $(ctx_type "$i")"
        case "$(ctx_type "$i")" in
          Synchronization)
            cat $BINDING_CONTEXT_PATH | jq -cr --arg i "$i" '.[$i | tonumber] | .objects | map(.object.kind)'
            ;;
          Event)
            echo "WatchEvent: $(ctx_watch_event "$i")"
            case "$(ctx_watch_event "$i")" in
              Added)
                cat $BINDING_CONTEXT_PATH | jq -r --arg i "$i" '.[$i | tonumber] | .object | del(.metadata.managedFields) | .metadata'
                ;;
              Modified)
                cat $BINDING_CONTEXT_PATH | jq -r --arg i "$i" '.[$i | tonumber] | .object | del(.metadata.managedFields) | .metadata'
                echo $KUBERNETES_PATCH_PATH
                ;;
              Deleted)
                cat $BINDING_CONTEXT_PATH | jq -r --arg i "$i" '.[$i | tonumber] | .object | del(.metadata.managedFields) | .metadata'
                ;;
              *)
                echo "Unknown watch event: $(ctx_watch_event "$i")"
                ;;
            esac
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
    echo "================================================================"
  done
}

function main {
  case "${1:-}" in
    --config) cat hook.json ;;
    *) hook ;;
  esac
}

main "$@"
