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
	done | (grep -E -v 'kustomize/ 5.0.3 5.1|coder-compat/|tailscale/ 1.46.1 1.48.0|tfo/ 2.0.0-beta2 1.3.0|coder/ 2.1.0 2.1.1|argocd/ 2.8.1 2.7.12|argocd/ 2.8.1 2.6.14' || true)
}

main "$@"
