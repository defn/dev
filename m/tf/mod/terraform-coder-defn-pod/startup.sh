#!/usr/bin/env bash

function main {
	source .bash_profile

	set -ex

	sudo chmod g-s /home/ubuntu

	sudo install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg
	sudo install -d -m 0700 -o ubuntu -g ubuntu /nix /nix

	ssh -o StrictHostKeyChecking=no git@github.com true || true
	git pull

	setsid code-server --auth none --port 13337 &
}

time main "$@"
uptime
