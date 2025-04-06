#!/usr/bin/env bash

set -efu -o pipefail

function main {
	if [[ "$(whoami || true)" == "ubuntu" ]]; then
		sudo "$0" "$@"

		cd /home/ubuntu

		git clone https://github.com/defn/dev
		mv dev/.git .
		rm -rf dev
		git reset --hard
		chown -R ubuntu:ubuntu .

		./install.sh	

		return $?
	fi

	export DEBIAN_FRONTEND=noninteractive

	apt update

	# sync with install.sh, m/i/Dockerfile
	apt install -y \
		make curl xz-utils dirmngr gpg pcscd scdaemon gpg-agent rsync \
		build-essential sudo ca-certificates tzdata locales git git-lfs tini \
		iproute2 iptables bc pv socat s6 cpu-checker bind9-dnsutils \
		pass skopeo

	apt update && apt install -y \
		wireguard-tools qemu-system libvirt-clients libvirt-daemon-system \
		openvpn easy-rsa expect tpm2-tools zfsutils-linux ubuntu-drivers-common

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

	curl -v -fsSL https://tailscale.com/install.sh | bash -x
	rm -rf /var/lib/tailscale

	(
		echo net.ipv4.ip_forward=1
		echo net.ipv6.conf.all.forwarding=1
		echo fs.inotify.max_user_instances=10000
		echo fs.inotify.max_user_watches=524288
	) | tee /etc/sysctl.d/99-dfd.conf

	mkdir -p /etc/systemd/network
	pushd /etc/systemd/network

	local a
	a=1

	(
		echo "[NetDev]"
		echo Name=dummy"$a"
		echo Kind=dummy
	) | sudo tee dummy"$a".netdev

	(
		echo "[Match]"
		echo Name=dummy"$a"
		echo
		echo "[Network]"
		echo Address=169.254.32."$a"/32
	) | sudo tee dummy"$a".network

	popd

	install -m 0755 -d /etc/apt/keyrings &&
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &&
		chmod a+r /etc/apt/keyrings/docker.asc &&
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable" | tee /etc/apt/sources.list.d/docker.list &&
		apt-get update &&
		apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	chown -R ubuntu:ubuntu /home/ubuntu && chmod u+s /usr/bin/sudo
	echo 'ubuntu ALL=(ALL:ALL) NOPASSWD: ALL' >/etc/sudoers.d/ubuntu

	usermod -aG docker ubuntu

	install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu
}

main "$@"
