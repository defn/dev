#!/usr/bin/env bash

set -euf -o pipefail

declare -A in

args=()

process_in=true

out=

shome="$(pwd)"

function parse_args {
	# Loop through each argument
	for arg in "$@"; do
		# Check if we should still process key-value pairs
		if [ "$process_in" = true ]; then
			# Check if the argument is in the form of key=value
			if [[ $arg == *=* ]]; then
				# Split the argument into key and value
				IFS='=' read -r -a parts <<<"$arg"

				# Extract key and value
				key="${parts[0]}"
				value="${parts[1]}"

				# Map key to value in the 'in' map
				in["$key"]="$value"
			else
				# If the argument is not in the form of key=value, stop processing in
				process_in=false
				# Add the non-key-value argument to the 'args' array
				args+=("$arg")
			fi
		else
			# If we're no longer processing key-value pairs, add the argument to the 'args' array
			args+=("$arg")
		fi
	done
}

function lib_main {
	parse_args "$@"
	out="${args[0]}"
	args=("${args[@]:1}")
	main "${args[@]}"
}

lib_main "$@"
