#!/usr/bin/env bash

function main {
	local app="${in[app]}"
	local name="${in[name]}"
	local registry="${in[registry]}"

	mkdir chart
	tar xfz "${app}" -C chart

	local bumped_version
	bumped_version=
	(
		set +f
		cd chart/*/
		local version="$(helm show chart --insecure-skip-tls-verify "oci://${registry}/${name}" 2>/dev/null | grep ^version: | awk '{print $2}')"
		bumped_version="${version%.*}.$(( ${version##*.} + 1))"

		sed "s#^version: .*#version: ${bumped_version}#" -i Chart.yaml
		sed "s#^appVersion: .*#version: ${bumped_version}#" -i Chart.yaml
	)

	local chart="${name}-${bumped_version}.tgz"

	(
		set +f
		tar cfz "${chart}" -C chart/*/ .
	)

	helm push --insecure-skip-tls-verify "${chart}" "oci://${registry}"

	cp "${chart}" "${out}"
}

source b/lib/lib.sh
