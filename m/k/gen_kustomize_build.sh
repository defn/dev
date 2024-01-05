#!/usr/bin/env bash

function main {
	local app="${in[app]}"

	kustomize build --load-restrictor LoadRestrictionsNone --enable-helm "${app}" >"${out}"

}

source b/lib/lib.sh
