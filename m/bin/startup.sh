#!/usr/bin/env bash

set -e

exec 3>&1
exec >>/tmp/dfd-startup.log 2>&1
tail -f /tmp/dfd-startup.log 1>&3 &

function main {
	sudo install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg
	sudo install -d -m 0700 -o ubuntu -g ubuntu /nix /nix

	ssh -o StrictHostKeyChecking=no git@github.com true || true

	case "$(git remote get-url origin)" in
	http*)
		git remote rm origin
		git remote add origin git@github.com:defn/dev
		git fetch origin
		git branch --set-upstream-to=origin/main main
		;;
	esac
	git config lfs.https://github.com/defn/dev.git/info/lfs.locksverify false

  if [[ "$(lsblk /dev/nvme0n1p1 | tail -1 | awk '{print $NF}')" == "/" ]]; then
    if sudo growpart /dev/nvme0n1 1; then
      sudo resize2fs /dev/nvme0n1p1 || true
    fi

    # mount ephemeral storage
    if [[ "$(lsblk /dev/nvme1n1 -no fstype)" != "ext4" ]]; then
      yes | sudo mkfs.ext4 /dev/nvme1n1
    fi
  fi

  sudo mkdir -p /mnt/docker
	if [[ "$(df /mnt/docker | tail -1 | awk '{print $NF}')" == / ]]; then
		echo '/dev/nvme1n1 /mnt/docker ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab
		sudo mount /mnt/docker
	fi

  if ! test -f /mnt/docker/swap; then
    sudo dd if=/dev/zero of=/mnt/docker/swap bs=1M count=8192
    sudo chmod 0600 /mnt/docker/swap
    sudo mkswap /mnt/docker/swap
    sudo swapon /mnt/docker/swap
  fi

	sudo systemctl stop docker || true
	sudo rm -rf /var/lib/docker
	sudo ln -nfs /mnt/docker /var/lib/docker
	sudo systemctl start docker

	cd
	git branch --set-upstream-to=origin/main main
	source .bash_profile
	make install
}

time main "$@"
uptime

cd ~/m
exec ~/bin/nix/tilt up
