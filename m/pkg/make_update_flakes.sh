#!/usr/bin/env bash

set -eufo pipefail

function main {
	./make_list_vendor_updates.sh | while read -r slug current latest; do
		(
			mark "${slug}"
			cd "${slug}"
			../az/bin/n-bump "$$latest"
			../az/bin/n-release "${slug} ${current} -> ${latest}"
		)
	done
}

main "$@"
