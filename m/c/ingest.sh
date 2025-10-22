#!/usr/bin/env bash

function main {
	(cd definition && ./ingest-repo.sh)
	(cd execution && ./ingest-kustomize.sh)
	(cd application && ./ingest-github-repo.sh)
	cue eval >/dev/null
	cue export --out yaml >main.yaml
	git difftool --no-prompt --extcmd='dyff between' main.yaml
}

main "$@"
