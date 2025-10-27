#!/usr/bin/env bash

function main {
	rm -rf docs/src/content/aws
	mkdir -p docs/src/content/aws
	for org in $(cat main.yaml | yq '.config.aws.org | keys[]'); do
		for acc in $(cat main.yaml | yq '.config.aws.org["'"$org"'"].account | keys[]'); do
			mkdir -p docs/src/content/aws/$org
			cat main.yaml | yq '.config.aws.org["'"$org"'"].account["'"$acc"'"]' >docs/src/content/aws/$org/$acc.yaml
		done
	done
}

main "$@"
