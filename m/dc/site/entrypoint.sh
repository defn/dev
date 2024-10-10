#!/usr/bin/env bash

cd /site

if [[ -x "entrypoint.site" ]]; then
    exec ./entrypoint.sh "$@"
else
    exec sleep infinity
fi
