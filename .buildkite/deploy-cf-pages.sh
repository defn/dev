#!/usr/bin/env bash

set -efu -o pipefail

website="$1"; shift

docker run --rm \
    -v $(pwd):/home/ubuntu \
    -v bazel-cache-1:/home/ubuntu/work/bazel \
    --entrypoint bash 169.254.32.1:5000/defn/dev -c \
    "sudo chown ubuntu:ubuntu work/bazel; source .bash_profile && cd ${website} && m install && m package"
