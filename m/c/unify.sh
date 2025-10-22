#!/usr/bin/env bash

# unify.sh - Unify data from multiple sources into CUE format
# Part of ACUTE: Agent, Config, Unify, Transform, Execute

function main {
	(cd definition && ./ingest-repo.sh)
	(cd execution && ./ingest-kustomize.sh)
	(cd application && ./ingest-github-repo.sh)
	if cue eval -c >/dev/null; then
		cue export --out yaml | yq 'del(.config.repo.[].updatedAt)' >main.yaml
		git difftool --no-prompt --extcmd='dyff between' main.yaml
	fi
}

main "$@"
