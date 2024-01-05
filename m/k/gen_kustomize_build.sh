#!/usr/bin/env bash

function main {
	local app="${in[app]}"
	local bundle="${in[bundle]}"

	tar xvfz "${bundle}"
	kustomize build --load-restrictor LoadRestrictionsNone --enable-helm "k/${app}" >"${out}"
}

source b/lib/lib.sh
