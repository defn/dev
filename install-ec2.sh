#!/bin/bash

set -x

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-dfd.conf
echo 'fs.inotify.max_user_instances = 10000' | sudo tee -a /etc/sysctl.d/99-dfd.conf
echo 'fs.inotify.max_user_watches = 524288' | sudo tee -a /etc/sysctl.d/99-dfd.conf
sudo sysctl -p /etc/sysctl.d/99-dfd.conf

if ! tailscale ip -4 | grep ^100; then
  sudo tailscale up --accept-dns --accept-routes --authkey="${coder.tsauthkey}" --operator=ubuntu --ssh --timeout 60s
fi

root_disk=
zfs_disk=
if [[ "$(lsblk /dev/nvme0n1p1 | tail -1 | awk '{print $NF}')" == "/" ]]; then
  root_disk=nvme0n1
  zfs_disk=nvme1n1
else
  root_disk=nvme1n1
  zfs_disk=nvme0n1
fi

systemctl stop docker.socket || true
systemctl stop docker || true

zpool create defn "/dev/$zfs_disk"

for z in nix work docker; do
  if [[ "$z" == "docker" ]]; then
    zfs create -s -V 100G defn/docker
  else
    zfs create defn/$z
  fi
  zfs set atime=off defn/$z
  zfs set compression=off defn/$z
  zfs set dedup=on defn/$z
done

zfs set mountpoint=/nix defn/nix
zfs set mountpoint=/home/ubuntu defn/work
mkfs.ext4 /dev/zvol/defn/docker

pushd ~
touch mise.toml
if [[ ! -x ~/.local/bin/mise ]]; then curl -sSL https://mise.run | bash; fi
~/.local/bin/mise use ubi:peak/s5cmd

~/.local/bin/mise exec -- s5cmd cat s3://dfn-defn-global-defn-org/zfs/docker.zfs | pv | zfs receive -F defn/docker &
~/.local/bin/mise exec -- s5cmd cat s3://dfn-defn-global-defn-org/zfs/nix.zfs | pv | zfs receive -F defn/nix &
(
  ~/.local/bin/mise exec -- s5cmd cat s3://dfn-defn-global-defn-org/zfs/work.zfs | pv | zfs receive -F defn/work
  ~/.local/bin/mise exec -- s5cmd cat s3://dfn-defn-global-defn-org/zfs/nix.tar.gz | pv | (cd ~ubuntu && tar xvfz -)
) &
wait
popd

# for a in nix work docker; do sudo zfs send defn/$a@latest | pv | s5cmd pipe s3://dfn-defn-global-defn-org/zfs/$a.zfs; done
# tar cvfz - .nix* .local/state/nix | pv | s5cmd pipe s3://dfn-defn-global-defn-org/zfs/nix.tar.gz 

mount /dev/zvol/defn/docker /var/lib/docker

systemctl start docker.socket || true
systemctl start docker || true

install -d -m 0755 -o ubuntu -g ubuntu /home/ubuntu /run/user/1000 /run/user/1000/gnupg
install -d -m 0755 -o ubuntu -g ubuntu /nix /nix
install -d -m 1777 -o ubuntu -g ubuntu /tmp/uscreens

cd /home/ubuntu
if ! test -d .git; then
  git clone https://github.com/defn/dev
  mv dev/.git .
  rm -rf dev
  chown -R ubuntu:ubuntu .git
fi

nohup sudo -H -u ${coder_username} env \
  CODER_INIT_SCRIPT_BASE64="${CODER_INIT_SCRIPT_BASE64}" \
  CODER_AGENT_URL="${CODER_AGENT_URL}" \
  CODER_NAME="${CODER_NAME}" \
    bash -c 'cd && git reset --hard && git pull && source .bash_profile && set -x && ./install.sh && cd m && exec mise exec -- just coder::coder-agent' >>/tmp/user-data.log 2>&1 &
    # (s5cmd cat s3://dfn-defn-global-defn-org/zfs/nix.tar.gz | tar xfz -) && (cd m/cache/docker && make init)
disown
