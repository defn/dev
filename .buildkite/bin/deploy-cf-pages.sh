#!/usr/bin/env bash

set -efu -o pipefail

website="$1"
shift

docker run --rm \
	-v $(pwd)/.git:/home/ubuntu/.git \
	-v bazel-cache-1:/home/ubuntu/work/bazel \
	--entrypoint bash 169.254.32.1:5000/defn/dev -c \
	"git reset --hard && source .bash_profile && cd ${website} && m install && m package"
