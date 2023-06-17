#!/usr/bin/env bash

set -eufo pipefail

function main {
	(
		set +f
		rm -f \
			../e/*/*.yaml \
			../k/*/kustomization.yaml ../k/*/resource-*.yaml ../k/*/patch-*.yaml \
			../r/*/main.yaml
	)
}

main "$@"
