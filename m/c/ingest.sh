#!/usr/bin/env bash

function main {
    (cd definition && ./ingest-repo.sh)
    (cd execution && ./ingest-kustomize.sh)
    (cd application && ./ingest-github-repo.sh)
    cue eval
    cue export -o yaml > main.yaml
}

main "$@"