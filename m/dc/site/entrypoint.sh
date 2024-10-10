#!/usr/bin/env bash

cd /site

if [[ -x "entrypoint.site" ]]; then
    exec ./entrypoint.site "$@"
else
    exec sleep infinity
fi
