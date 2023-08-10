  #!/usr/bin/env bash

  set -ex

  exec >>/tmp/dfd-startup.log 2>&1

  tail -f /tmp/dfd-startup.log &

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
  uptime
  
  (exec >>/tmp/dfd-tilt.log 2>&1 && cd m && setsid ~/bin/nix/tilt up &) &

  # TODO add swap when /mnt is local ssd
  #sudo dd if=/dev/zero of=/mnt/swap bs=1M count=4096
  #sudo chmod 0600 /mnt/swap
  #sudo mkswap /mnt/swap
  #sudo swapon /mnt/swap || true

  exit 0
