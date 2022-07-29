#!/bin/sh

set -exfu

./tailscaled --state=tailscaled.state &

ip link add dummy0 type dummy; ip addr add 169.254.32.1/32 dev dummy0; ip link set dev dummy0 up

container_ip=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | cut -d' ' -f1`

while true; do
  ts_ip=`./tailscale ip -4`
  if test -n "${ts_ip}"; then break; fi
  sleep 1
done

exec /bin/k3s-real "$@" --advertise-address "${container_ip}" --node-external-ip "${ts_ip}"
