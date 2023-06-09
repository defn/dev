#!/usr/bin/env bash

function main {
	set -eu

	if [[ $# == 0 ]]; then
		set -- ./ ./*/
	fi

	echo "steps:"

	for D in "$@"; do
		case "$D" in
		*/all/)
			true
			;;
		*)
			if test -d "$D/.buildkite"; then
				echo -e "  - agents:\n      queue: $GIT_AUTHOR_NAME\n    command: \"cat $D/.buildkite/pipeline.yml | sed 's#command: .#agents:\\\\\\\n      queue: $GIT_AUTHOR_NAME\\\\\\\n    command: \\\"cd $D; #' | buildkite-agent pipeline upload\""
			fi
			;;
		esac
	done
}

main "$@"
