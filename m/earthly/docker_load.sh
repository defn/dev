#!/usr/bin/env bash

set -efuo pipefail

function main {
	local image_save

	docker load --input="${image_save}"
}

main "$@"
