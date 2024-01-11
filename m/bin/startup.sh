#!/usr/bin/env bash

set -e

function main {
	sudo install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg
	sudo install -d -m 0700 -o ubuntu -g ubuntu /nix /nix
	sudo install -d -m 1777 -o ubuntu -g ubuntu /tmp/uscreens

	local root_disk
	local mnt_disk
	if [[ "$(lsblk /dev/nvme0n1p1 | tail -1 | awk '{print $NF}')" == "/" ]]; then
		root_disk=nvme0n1
		mnt_disk=nvme1n1
	else
		root_disk=nvme1n1
		mnt_disk=nvme0n1
	fi

	if sudo growpart /dev/${root_disk} 1; then
		sudo resize2fs /dev/${root_disk}p1 || true
	fi

	# mount ephemeral storage
	if [[ "$(lsblk /dev/${mnt_disk} -no fstype)" != "ext4" ]]; then
		yes | sudo mkfs.ext4 /dev/${mnt_disk}
	fi

	sudo systemctl stop docker || true

	sudo install -d -m 0700 -o ubuntu -g ubuntu /mnt
	if [[ "$(df /mnt | tail -1 | awk '{print $NF}')" == / ]]; then
		echo "/dev/${mnt_disk} /mnt ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
		sudo mount /mnt || true
	fi

	sudo chown ubuntu:ubuntu /mnt/*

	sudo install -d -m 0710 -o root -g root /mnt/docker
	sudo rm -rf /var/lib/docker
	sudo mkdir -p /mnt/docker
	sudo ln -nfs /mnt/docker /var/lib/docker

	while true; do
		if sudo systemctl start docker; then break; fi
		sleep 10
	done

	cd
	git fetch
	git branch --set-upstream-to=origin/main main
	git pull

	(cd m/cache && make init up)
}

time main "$@"
uptime

cd
bin/persist-cache

cd ~/m
if kubectl get ns; then
	$(MAKE) ready
fi
nohup ~/bin/nix/tilt up >/tmp/startup.out 2>&1 &
disown
