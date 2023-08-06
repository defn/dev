#!/bin/sh

set -exu

PATH=${PATH}:/home/ubuntu/bin/nix

tailscaled --statedir=/var/lib/tailscale &

container_ip=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | cut -d' ' -f1)

tailscale up --authkey="${DEFN_DEV_TSKEY}" --accept-dns=false --ssh

while true; do
	ts_ip=$(tailscale ip -4 || true)
	if test -n "${ts_ip}"; then break; fi
	sleep 1
done

domain=
while test -z "${domain}"; do
	domain=$(tailscale cert 2>&1 | grep ' use ' | cut -d'"' -f2)
	sleep 1
done

for a in /var/lib/rancher/k3s/server/manifests; do
	mkdir -p "${a}"
	(
		set +f
		cp "${a}-bootstrap"/* "${a}"/
	) || true
done

exec /bin/k3s "$@" --node-ip "${ts_ip}" --node-external-ip "${ts_ip}" --flannel-iface=tailscale0
