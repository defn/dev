#!/usr/bin/env bash

set -e

function main {
	sudo install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg
	sudo install -d -m 0700 -o ubuntu -g ubuntu /nix /nix
	sudo install -d -m 1777 -o ubuntu -g ubuntu /tmp/uscreens

	local root_disk
	local zfs_disk
	if [[ "$(lsblk /dev/nvme0n1p1 | tail -1 | awk '{print $NF}')" == "/" ]]; then
		root_disk=nvme0n1
		zfs_disk=nvme1n1
	else
		root_disk=nvme1n1
		zfs_disk=nvme0n1
	fi

	sudo systemctl stop docker || true

	sudo zpool create nix "/dev/${zfs_disk}"
	sudo zfs set mountpoint=/nix nix
	sudo zfs set atime=off nix
	sudo zfs set compression=on nix

	cat /zfs/nix.zfs | pigz -d | sudo zfd receive -F nix

	sudo zfs create nix/work
	sudo zfs set mountpoint=/home/ubuntu/work nix/work
	sudo zfs set atime=off nix/work
	sudo zfs set compression=on nix/work

	cat /zfs/work.zfs | pigz -d | sudo zfd receive -F nix/work

	sudo rm -rf /var/lib/docker
	sudo zfs create nix/docker
	sudo zfs set mountpoint=/var/lib/docker nix/docker
	sudo zfs set atime=off nix/docker
	sudo zfs set compression=on nix/docker

	while true; do
		if sudo systemctl start docker; then
			echo Docker running
			break
		fi
		sleep 10
	done

	cd
	source .bash_profile
	bin/persist-cache

	cd m
	nohup bin/user-data.sh ${1} ${2} >>/tmp/user-data.log 2>&1 &
	disown
}

time main "$@"
