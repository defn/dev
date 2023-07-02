#!/usr/bin/env bash

#set -x
#exec 2>>/tmp/env.log
#exec 1>&2

# shellcheck disable=SC1090
source ~/.bash_profile
exec "$@"
