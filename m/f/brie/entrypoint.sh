#!/usr/bin/env ba

set -efu

sudo install -d -m 0700 -o ubuntu -g ubuntu /data/coder /data/tailscale

(sudo tailscale up --ssh || true) &

cd

source .bash_profile

cd m
mise run start

exec /bin/sleep infinity
