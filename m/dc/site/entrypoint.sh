#!/usr/bin/env bash

cd

source .bash_profile

cd /site

if [[ -x "entrypoint.site" ]]; then
    exec ./entrypoint.site "$@"
else
    exec code-server --bind-addr 0.0.0.0:8080 --auth none
fi
