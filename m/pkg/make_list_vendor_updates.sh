#!/usr/bin/env bash

set -eufo pipefail

function main {
	set +f
	this-github-login 1>&2
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
	done | (grep -E -v 'earthly/ 0.8.0-rc[0-9] 0.7|argocd/ 2.10.0-rc1 2.[89]|coder-compat/|linkerd/ 2.14.[0-9]+ 2.1[23]|linkerd/ 2.14.[0-9]+ 2[34]|argoworkflows/ 3.5.[0-9]+ 3.4|kn/ 1.12.0 1.11' || true)
}

main "$@"
