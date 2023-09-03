#!/bin/bash

#mount bpffs -t bpf /sys/fs/bpf
#mount --make-shared /sys/fs/bpf
#mkdir -p /run/cilium/cgroupv2
#mount -t cgroup2 none /run/cilium/cgroupv2
#mount --make-shared /run/cilium/cgroupv2

set -eu

case "${1-}" in
  server|agent)
    true
    ;;
  *)
    exec /bin/k3s-real "$@"
    exit $?
    ;;
esac

tailscaled --statedir=/var/lib/tailscale &

container_ip=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | cut -d' ' -f1)

tsauthkey="$*"
tsauthkey="${tsauthkey##*TAILSCALE_AUTHKEY=}"
tsauthkey="${tsauthkey%%=TAILSCALE_AUTHKEY*}"
tailscale up --authkey="${tsauthkey}"

while true; do
  ts_ip=$(tailscale ip -4 || true)
  if test -n "${ts_ip}"; then break; fi
  sleep 1
done

# strip out tsauthkey
k3sargs="$*"
k3sargs="${k3sargs/TAILSCALE_AUTHKEY=*=TAILSCALE_AUTHKEY}"
/bin/k3s-real $k3sargs --node-ip "${ts_ip}" --node-external-ip "${ts_ip}" --flannel-iface=tailscale0
