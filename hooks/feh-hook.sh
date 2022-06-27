#!/usr/bin/env bash

if [[ $1 == "--config" ]] ; then
  cat <<EOF
configVersion: v1
kubernetes:
- apiVersion: v1
  kind: Namespace
  executeHookOnEvent: ["Added"]
EOF
else
  nsName=$(jq -r .[0].object.metadata.name $BINDING_CONTEXT_PATH)
  echo "Namespace '${nsName}' added"
fi
