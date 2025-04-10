#!/usr/bin/env bash

set -efu -o pipefail

function main {
	export DEBIAN_FRONTEND=noninteractive

	if [[ "$(whoami || true)" == "ubuntu" ]]; then
		sudo "$0" "$@"

		cd /home/ubuntu

		git clone https://github.com/defn/dev
		mv dev/.git .
		rm -rf dev
		git reset --hard

		make sync

		return $?
	fi

	# bootstrap
	# ca-certificates for docker repo
	# python3.12-venv for mise python tooling
	apt update && apt upgrade -y && apt install -y make curl rsync sudo ca-certificates tzdata locales git python3.12-venv

	# extra for servers
	apt install -y \
		wireguard-tools qemu-system libvirt-clients libvirt-daemon-system \
		openvpn easy-rsa expect tpm2-tools zfsutils-linux ubuntu-drivers-common

	# install docker
	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	chmod a+r /etc/apt/keyrings/docker.asc \
		&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable" | tee /etc/apt/sources.list.d/docker.list \
		&& apt update -y \
		&& apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	# install tailscale
	curl -fsSL https://tailscale.com/install.sh | bash

	# authorize sudo usage
	echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

	# misc configurations
	ln -sf /usr/share/zoneinfo/UTC /etc/localtime
	dpkg-reconfigure -f noninteractive tzdata

	tee /etc/apt/apt.conf.d/local <<EOF
DPkg::Lock::Timeout "-1";
Dpkg::Options {
   "--force-confdef";
   "--force-confold";
};
EOF

	tee /etc/apt/apt.conf.d/99-Phased-Updates <<EOF
Update-Manager::Never-Include-Phased-Updates;
APT::Get::Never-Include-Phased-Updates: True;
EOF

	tee /etc/sysctl.d/99-dfd.conf <<EOF
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
fs.inotify.max_user_instances=10000
fs.inotify.max_user_watches=524288
EOF

	mkdir -p /etc/systemd/network

	tee /etc/systemd/network/dummy1.netdev <<EOF
[NetDev]
Name=dummy1
Kind=dummy
EOF

	tee /etc/systemd/network/dummy1.network <<EOF
[Match]
Name=dummy1

[Network]
Address=169.254.32.1/32
EOF
}

main "$@"
