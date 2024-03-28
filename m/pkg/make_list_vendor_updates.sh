#!/usr/bin/env bash

set -eufo pipefail

function main {
	set +f
	for a in */; do
		if grep ghrepo "${a}/flake.json" >/dev/null 2>/dev/null; then
			(
				cd "${a}"
				echo "${a} $(jq -r '.vendor' <flake.json || true) $(../az/bin/n-latest || true)" | while read -r slug current latest real_tag; do
					echo "${slug} ${current} ${latest} https://github.com/$(jq -r .ghrepo <flake.json || true)/releases/tag/${real_tag}"
				done
			)
		fi
	done | while read -r slug current latest real_tag; do
		if [[ ${current} != "${latest}" ]]; then
			echo "${slug} ${current} ${latest} ${real_tag}"
		fi
	done | (grep -E -v 'ibazel/ 0.25.0 V0.25.1|argocd/ 2.10.[0-9]+ 2.[89]|coder-compat/|argoworkflows/ 3.5.[0-9]+ 3.4|crossplane/ 1.15.[0-9]+ 1.1[34]|coredns/ 1.11.2 1.11.1' || true)
}

main "$@"
