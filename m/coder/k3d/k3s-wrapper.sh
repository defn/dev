#!/bin/bash

if [[ ${1-} == server ]]; then
	set -exu

	tailscaled --statedir=/var/lib/tailscale &

	container_ip=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | cut -d' ' -f1)

	tailscale up

	while true; do
		ts_ip=$(tailscale ip -4 || true)
		if test -n "${ts_ip}"; then break; fi
		sleep 1
	done

	exec /bin/k3s-real "$@" --node-ip "${ts_ip}" --node-external-ip "${ts_ip}" --flannel-iface=tailscale0
else
	exec /bin/k3s-real "$@"
fi
