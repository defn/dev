#!/usr/bin/env bash

set -exfu

if [[ "${1:-}" == "--config" ]] ; then
  jq -n '{configVersion: "v1", onStartup: 1}'
else
  echo "OnStartup shell hook"
fi
