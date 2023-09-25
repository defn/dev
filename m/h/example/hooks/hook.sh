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

function ctx_filter_result {
  i="$1"; shift
  cat $BINDING_CONTEXT_PATH | jq -r --arg i "$i" '.[$i | tonumber] | .filterResult'
}

function hook {
  for i in $(ctx_index); do
    echo "====[ $i / $(ctx_index) ]======================================================"
    case "$(ctx_type "$i")" in
      null)
        echo "Binding : $(ctx_binding "$i")"
        echo "Starting..."
        ;;
      Synchronization)
        echo "Binding : $(ctx_binding "$i")"
        echo "Type: $(ctx_type "$i")"
        cat $BINDING_CONTEXT_PATH | jq -cr --arg i "$i" '.[$i | tonumber] | .objects | map(.object.kind)'
        ;;
      Event)
        echo "Binding : $(ctx_binding "$i")"
        echo "Type: $(ctx_type "$i")"
        echo "WatchEvent: $(ctx_watch_event "$i")"
        echo "FilterResult: $(ctx_filter_result "$i")"
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
            cat $BINDING_CONTEXT_PATH | jq -cr --arg i "$i" '.[$i | tonumber]'
            ;;
        esac
        ;;
      Group*)
        cat $BINDING_CONTEXT_PATH | jq -cr --arg i "$i" '.[$i | tonumber]'
        ;;
      Schedule)
        cat $BINDING_CONTEXT_PATH | jq -cr --arg i "$i" '.[$i | tonumber]'
        ;;
      *)
        echo "Unknown type: $(ctx_type "$i")"
        cat $BINDING_CONTEXT_PATH | jq -cr --arg i "$i" '.[$i | tonumber]'
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
