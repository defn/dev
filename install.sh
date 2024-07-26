#!/usr/bin/env bash

function once {
	sudo apt update
	sudo apt install -y direnv make
	mv dev/.git .
	git reset --hard
  curl -fsSL https://tailscale.com/install.sh | sh
  sudo tailscale up --ssh
}

function main {
	source .bashrc
  make vpn-install
  make no-gpg
  make nix
  scp macmini:m/.bazelrc.user m/
  make install
}

main "$@"

