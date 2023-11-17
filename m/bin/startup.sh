#!/usr/bin/env bash

set -ex

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

  if ! test -f /mnt/docker/swap; then
    sudo dd if=/dev/zero of=/mnt/docker/swap bs=1M count=8192
    sudo chmod 0600 /mnt/docker/swap
    sudo mkswap /mnt/docker/swap
    sudo swapon /mnt/docker/swap
  fi &

	cd
	git branch --set-upstream-to=origin/main main
	source .bash_profile
	make install
}

time main "$@"
uptime

wait
(cd ~/m && exec setsid ~/bin/nix/tilt up >/dev/null 2>&1 &) &
