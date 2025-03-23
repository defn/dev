#!/usr/bin/env bash

set -efu -o pipefail

source .bash_profile

pushd m
source ~/work/.buildkite/.env
j base
popd

exit 0

mkdir -p /home/ubuntu/work/bazel
docker run --rm \
	-v $(pwd)/.git:/home/ubuntu/.git \
	-v /home/ubuntu/work/.buildkite:/.buildkite \
	-v bazel-cache-1:/home/ubuntu/work/bazel \
	--entrypoint bash quay.io/defnnn/dev:base -c \
	"sudo chown ubuntu:ubuntu work/bazel; source /.buildkite/.env; git reset --hard && source .bash_profile && cd m && b build"
