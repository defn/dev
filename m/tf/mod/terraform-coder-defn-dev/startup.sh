#!/usr/bin/env bash

set -ex

exec 3>&1
tail -f /tmp/dfd-startup.log 1>&3 &
exec >>/tmp/dfd-startup.log 2>&1

# TODO add swap when /mnt is local ssd
#sudo dd if=/dev/zero of=/mnt/swap bs=1M count=4096
#sudo chmod 0600 /mnt/swap
#sudo mkswap /mnt/swap
#sudo swapon /mnt/swap || true

function main {
	sudo mkdir -p /etc/systemd/network
	pushd /etc/systemd/network
	for a in 1; do
		(
			echo [NetDev]
			echo Name=dummy$a
			echo Kind=dummy
		) | sudo tee dummy$a.netdev
		(
			echo [Match]
			echo Name=dummy$a
			echo
			echo [Network]
			echo Address=169.254.32.$a/32
		) | sudo tee dummy$a.network
	done
	sudo systemctl restart systemd-networkd

	sudo install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg
	sudo install -d -m 0700 -o ubuntu -g ubuntu /nix /nix

	if [[ ! -d "/nix/home/.git/." ]]; then
		ssh -o StrictHostKeyChecking=no git@github.com true || true
		git clone http://github.com/defn/dev /nix/home
		pushd /nix/home
		git reset --hard
		popd
	else
		pushd /nix/home
		git pull
		popd
	fi

	sudo rm -rf "$HOME"
	sudo ln -nfs /nix/home "$HOME"
	ssh -o StrictHostKeyChecking=no git@github.com true || true

	# persist daemon data
	for d in docker tailscale; do
		if test -d "/nix/${d}"; then
			sudo rm -rf "/var/lib/${d}"
		elif test -d "/var/lib/${d}"; then
			sudo mv "/var/lib/${d}" "/nix/${d}"
		else
			sudo install -d -m 0700 "/nix/${d}"
		fi
		sudo ln -nfs "/nix/${d}" "/var/lib/${d}"
	done

	cd
	source .bash_profile
	make install
}

time main "$@"
uptime

cd ~/m
~/bin/nix/tilt up &
bin/make-k3d || true
