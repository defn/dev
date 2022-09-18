#!/bin/sh

set -exfu

/tailscaled --statedir=/var/lib/tailscale &

container_ip=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | cut -d' ' -f1`

while true; do
  ts_ip=`/tailscale ip -4 || true`
  if test -n "${ts_ip}"; then break; fi
  sleep 1
done

domain=
while test -z "${domain}"; do
domain=`/tailscale cert 2>&1 | grep ' use ' | cut -d'"' -f2`
sleep 1
done

/tailscale up --ssh --accept-dns=true --hostname `echo ${domain} | cut -d. -f1`

exec /bin/k3s-real "$@" --node-ip "${ts_ip}" --node-external-ip "${ts_ip}"
