#!/usr/bin/env bash

set -ex

function main {
	sudo install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg
	sudo install -d -m 0700 -o ubuntu -g ubuntu /nix /nix

	local root_disk
	local docker_disk
	if [[ "$(lsblk /dev/nvme0n1p1 | tail -1 | awk '{print $NF}')" == "/" ]]; then
		root_disk=nvme0n1
		docker_disk=nvme1n1
	else
		root_disk=nvme1n1
		docker_disk=nvme0n1
	fi

	if sudo growpart /dev/${root_disk} 1; then
		sudo resize2fs /dev/${root_disk}p1 || true
	fi

	# mount ephemeral storage
	if [[ "$(lsblk /dev/${docker_disk} -no fstype)" != "ext4" ]]; then
		yes | sudo mkfs.ext4 /dev/${docker_disk}
	fi

	sudo systemctl stop docker || true

	sudo mkdir -p /mnt/docker
	if [[ "$(df /mnt/docker | tail -1 | awk '{print $NF}')" == / ]]; then
		echo "/dev/${docker_disk} /mnt/docker ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
		sudo mount /mnt/docker || true
	fi
	#sudo rm -rf /var/lib/docker
	#sudo ln -nfs /mnt/docker /var/lib/docker
	sudo mkdir -p /var/lib/docker

	sudo systemctl start docker

	#  if ! test -f /mnt/docker/swap; then
	#    sudo dd if=/dev/zero of=/mnt/docker/swap bs=1M count=8192
	#    sudo chmod 0600 /mnt/docker/swap
	#    sudo mkswap /mnt/docker/swap
	#    sudo swapon /mnt/docker/swap
	#  fi &

	cd
	git fetch
	git branch --set-upstream-to=origin/main main
	set +x
	source .bash_profile
	set -x
	make install
}

time main "$@"
uptime

cd ~/m
nohup ~/bin/nix/tilt up >/tmp/startup.out 2>&1 &
disown
