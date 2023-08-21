#!/usr/bin/env bash

set -ex

exec 3>&1
tail -f /tmp/dfd-startup.log 1>&3 &
exec >>/tmp/dfd-startup.log 2>&1

function main {
	curl -fsSL https://code-server.dev/install.sh | sh -s -- --method=standalone --prefix=/tmp/code-server --version 4.16.1
	/tmp/code-server/bin/code-server --auth none --port 13337 >/tmp/code-server.log 2>&1 &

	sudo chmod g-s /home/ubuntu

	sudo install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg
	sudo install -d -m 0700 -o ubuntu -g ubuntu /nix /nix

	ssh -o StrictHostKeyChecking=no git@github.com true || true
	git pull

	cd
	source .bash_profile
	make install
}

main "$@"
