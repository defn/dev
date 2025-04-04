#!/usr/bin/env bash

function main {
	local app="${in[app]}"
	local bundle="${in[bundle]}"

	tar xfz "${bundle}"
	kustomize build --load-restrictor LoadRestrictionsNone --enable-helm "k/${app}" >"${out}"
}

source b/lib/lib.sh
