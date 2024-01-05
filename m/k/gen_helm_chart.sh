#!/usr/bin/env bash

function main {
	local app="${in[app]}"

	mkdir -p chart/templates
	cat "${app}" | sed 's/{{/{{ "{{" }}/g' > chart/templates/main.yaml
	(
		echo "apiVersion: v2"
		echo "type: application"
		echo 'appVersion: "0.0.1"'
		echo 'version: "0.0.1"'
		echo "name: $(basename ${app} .yaml)"
	 ) > chart/Chart.yaml

	helm package chart
	
	set +f
	cp *.tgz "${out}"
}

source b/lib/lib.sh
