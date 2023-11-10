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

function handler {
  local i
  local event
  i="$1"; shift
  event="$1"; shift
  
  echo "====[ $i / $(index) ]======================================================"
  echo "Event: ${event}"
  case "${event}" in
    Start)
      true
      ;;
    Synchronization*)
      objects "$i" | jq -c 'map(.object.kind)'
      ;;
    Schedule*)
      objects "$i" | jq -c 'map(.object.kind)'
      ;;
    Group*)
      objects "$i" | jq -c 'map(.object.kind)'
      ;;
    Event*)
      echo "FilterResult: $(ctx_filter_result "$i")"
      obj "$i" | jq '"Info: \(.kind) \(.metadata.namespace) \(.metadata.name)"'
      ;;
    *)
      echo "UnknownType: $(ctx_type "$i")"
      objects "$i" | jq -cr .
      ;;
  esac
  echo "================================================================"
}

function hook {
  for i in $(index); do
    case "$(ctx_type "$i")" in
      null)            handler "$i" "Start" ;;
      Synchronization) handler "$i" "$(ctx_type "$i")/$(ctx_binding "$i")" ;;
      Schedule)        handler "$i" "$(ctx_type "$i")/$(ctx_binding "$i")" ;;
      Group*)          handler "$i" "$(ctx_type "$i")/$(ctx_binding "$i")" ;;
      Event)           handler "$i" "$(ctx_type "$i")_$(ctx_watch_event "$i")/$(ctx_binding "$i")" ;;
      *)               handler "$i" "Unknown" ;;
    esac
  done
}

function main {
  case "${1:-}" in
    --config) cat hook.json ;;
    *) hook ;;
  esac
}

main "$@"
