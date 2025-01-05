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

	sudo zpool create nix "/dev/${zfs_disk}"
	sudo zfs set mountpoint=/nix nix
	sudo zfs set atime=off nix
	sudo zfs set compression=on nix

	cat /zfs/nix.zfs | pigz -d | sudo zfs receive -F nix

	sudo zfs create nix/work
	sudo zfs set mountpoint=/home/ubuntu/work nix/work
	sudo zfs set atime=off nix/work
	sudo zfs set compression=on nix/work

	sudo zfs create nix/docker
	sudo zfs set mountpoint=/var/lib/docker nix/docker
	sudo zfs set atime=off nix/docker
	sudo zfs set compression=on nix/docker

	sudo apt install docker.io

	cd
	source .bash_profile
	bin/persist-cache

	export CODER_AGENT_URL="$1"
	shift

	export CODER_NAME="$1"
	shift

	git config lfs.https://github.com/defn/dev.git/info/lfs.locksverify false

	case "$(git remote get-url origin)" in
	http*)
		git remote rm origin
		git remote add origin https://github.com/defn/dev
		git fetch origin
		git branch --set-upstream-to=origin/main main
		git reset --hard origin/main
		;;
	esac

	(
		set +x
		cd m
		while true; do
			cd
			source .bash_profile
			cd ~/m
			j coder::code-server "${CODER_NAME}" || true &
			j coder::coder-agent "${CODER_NAME}" || true
			sleep 5
		done >>/tmp/coder-agent.log 2>&1
	) &
	disown
}

time main "$@"
