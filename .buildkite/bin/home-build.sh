#!/usr/bin/env bash

set -efu -o pipefail

source .bash_profile

case "${BUILDKITE_BRANCH-}" in
main)
	cd m/i
	source ~/work/.buildkite/.env
	j latest
	;;
esac
