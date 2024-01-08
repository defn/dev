#!/usr/bin/env bash

function main {
	echo package c >"${out}"

	for h in "$@"; do
		mkdir chart
		tar xfz "${h}" -C chart
		local cluster=$(set +f; grep ^name: chart/*/Chart.yaml | awk '{print $2}' | cut -d- -f1-3)
		local name=$(set +f; grep ^name: chart/*/Chart.yaml | awk '{print $2}' | cut -d- -f5-)

		local version=$(set +f; grep ^version: chart/*/Chart.yaml | awk '{print $2}')

		if [[ "${name}" != "env" ]]; then
			echo "app_versions: \"${cluster}\": \"${name}\": app_version: \"${version}\"" >>"${out}"
		fi

		rm -rf chart
	done
}

source b/lib/lib.sh
