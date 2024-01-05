#!/usr/bin/env bash

function main {
	local app="${in[app]}"

	touch "${out}"

	if test -e "k/${app}/kustomization.yaml"; then
		rm -rf "k/${app}/chart"
		kustomize build --load-restrictor LoadRestrictionsNone --enable-helm "k/${app}" >"${out}"
	fi
}

source b/lib/lib.sh
