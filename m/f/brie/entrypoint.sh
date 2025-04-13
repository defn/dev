#!/usr/bin/env bash

set -xefu

sudo install -d -m 0700 -o ubuntu -g ubuntu /data /data/coder /data/tailscale /data/extensions

cd
source .bash_profile

cd m
mise run start
mise run status

(while true; do
	if sudo tailscale up --ssh; then
		break
	fi
	sleep 1
done) &

exec mise run log coder-server
