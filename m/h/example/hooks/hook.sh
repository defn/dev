#!/usr/bin/env bash

set -efu

function context {
  local i
  i="$1"; shift
  cat $BINDING_CONTEXT_PATH | jq --arg i "$i" '.[$i | tonumber]'
}

function index  {
  cat $BINDING_CONTEXT_PATH | jq -r 'keys[]' | xargs
}

function objects {
  local i
  i="$1"; shift
  context "$i" | jq '.objects'
}

function obj {
  context "$i" | jq '.object | del(.metadata.managedFields)'
}

function ctx_binding {
  local i
  i="$1"; shift
  context "$i" | jq -r '.binding'
}

function ctx_type {
  local i
  i="$1"; shift
  context "$i" | jq -r '.type'
}

function ctx_watch_event {
  local i
  i="$1"; shift
  context "$i" | jq -r '.watchEvent'
}

function ctx_filter_result {
  local i
  i="$1"; shift
  context "$i" | jq '.filterResult'
}

function hook {
  for i in $(index); do
    echo "====[ $i / $(index) ]======================================================"
    case "$(ctx_type "$i")" in
      null)
        echo "Binding : $(ctx_binding "$i")"
        ;;
      Synchronization)
        echo "Binding : $(ctx_binding "$i"), Type: $(ctx_type "$i")"
        objects "$i" | jq -c 'map(.object.kind)'
        ;;
      Event)
        echo "Binding : $(ctx_binding "$i"), Type: $(ctx_type "$i"), WatchEvent: $(ctx_watch_event "$i")"
        echo "FilterResult: $(ctx_filter_result "$i")"
        case "$(ctx_watch_event "$i")" in
          Added)
            obj "$i" | jq -c '.metadata'
            ;;
          Modified)
            obj "$i" | jq -c '.metadata'
            ;;
          Deleted)
            obj "$i" | jq -c '.metadata'
            ;;
          *)
            echo "Unknown watch event: $(ctx_watch_event "$i")"
            objects "$i" | jq -cr .
            ;;
        esac
        ;;
      Group*)
        objects "$i" | jq -cr .
        ;;
      Schedule)
        objects "$i" | jq -cr .
        ;;
      *)
        echo "Unknown type: $(ctx_type "$i")"
        objects "$i" | jq -cr .
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
