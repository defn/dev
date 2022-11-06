#!/usr/bin/env bash

set -exu

name="$1"; shift

mkdir -p nix/store
time for a in $(nix-store -qR ./result); do rsync -ia $a nix/store/; done
(echo '# syntax=docker/dockerfile:1'; echo FROM alpine; for a in nix/store/*/; do echo COPY --link $a /$a/; done; echo ENTRYPOINT [ '"/bin/sh"' ]) > Dockerfile
echo "ENV PATH $(for a in nix/store/*/; do echo -n "/$a/bin:"; done)/bin" >> Dockerfile
time env DOCKER_BUILDKIT=1 docker build -t "${name}" .
docker image list | grep "^${name}"
