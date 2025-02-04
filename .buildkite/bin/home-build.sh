#!/usr/bin/env bash

set -efu -o pipefail

source .bash_profile

pushd m/i
source ~/work/.buildkite/.env
make latest
popd

exit 0

mkdir -p /home/ubuntu/work/bazel
docker run --rm \
	-v $(pwd)/.git:/home/ubuntu/.git \
	-v /home/ubuntu/work/.buildkite:/.buildkite \
	-v bazel-cache-1:/home/ubuntu/work/bazel \
	--entrypoint bash 169.254.32.1:5000/defn/dev -c \
	"sudo chown ubuntu:ubuntu work/bazel; source /.buildkite/.env; git reset --hard && source .bash_profile && cd m && b build"
