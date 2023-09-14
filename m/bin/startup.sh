#!/usr/bin/env bash

set -e

exec 3>&1
tail -f /tmp/dfd-startup.log 1>&3 &
exec >>/tmp/dfd-startup.log 2>&1

sudo sysctl -w fs.inotify.max_user_instances=10000
sudo sysctl -w fs.inotify.max_user_watches=524288

sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1

#sudo mount bpffs -t bpf /sys/fs/bpf
#sudo mount --make-shared /sys/fs/bpf

if [[ "$(lsblk /dev/nvme0n1p1 | tail -1 | awk '{print $NF}')" == 1 ]]; then
	sudo growpart /dev/nvme0n1 1
	sudo resize2fs /dev/nvme0n1p1
fi

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

	# mount ephemeral storage
	if [[ "$(lsblk /dev/nvme1n1 -no fstype)" != "ext4" ]]; then
		yes | sudo mkfs.ext4 /dev/nvme1n1
	fi

	if [[ "$(df /mnt/docker | tail -1 | awk '{print $NF}')" == / ]]; then
		echo '/dev/nvme1n1 /mnt/docker ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab
		sudo mount /mnt/docker
	fi

  if ! test -f /mnt/docker/swap; then
    sudo dd if=/dev/zero of=/mnt/docker/swap bs=1M count=4096
    sudo chmod 0600 /mnt/docker/swap
    sudo mkswap /mnt/docker/swap
    sudo swapon /mnt/docker/swap
  fi

	sudo systemctl stop docker || true
	sudo rm -rf /var/lib/docker
	sudo ln -nfs /mnt/docker /var/lib/docker
	sudo systemctl start docker

	cd
	source .bash_profile
	make install
}

time main "$@"
uptime

cd ~/m
~/bin/nix/tilt up &

exit 0
