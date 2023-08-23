#!/bin/sh

set -exu

tailscaled --statedir=/var/lib/tailscale &

container_ip=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | cut -d' ' -f1)

tailscale up --authkey="${TSKEY}"

while true; do
	ts_ip=$(tailscale ip -4 || true)
	if test -n "${ts_ip}"; then break; fi
	sleep 1
done

exec /bin/k3s "$@" --node-ip "${ts_ip}" --node-external-ip "${ts_ip}" --flannel-iface=tailscale0
