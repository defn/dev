#!/usr/bin/env bash

function main {
	rm -rf docs/src/content/aws
	mkdir -p docs/src/content/aws
	for org in $(cat main.yaml | yq '.config.aws.org | keys[]'); do
		for acc in $(cat main.yaml | yq '.config.aws.org["'"$org"'"].account | keys[]'); do
			mkdir -p docs/src/content/aws/$org
			cat main.yaml | yq '.config.aws.org["'"$org"'"].account["'"$acc"'"]' >docs/src/content/aws/$org/$acc.yaml

			mkdir -p ../a/$org/$acc/.aws
			cat main.yaml | yq '.config.aws.org["'"$org"'"].account["'"$acc"'"].aws_config' >../a/$org/$acc/.aws/config
			cat main.yaml | yq '.config.aws.org["'"$org"'"].account["'"$acc"'"].mise_config' >../a/$org/$acc/mise.toml
		done
	done
}

main "$@"
