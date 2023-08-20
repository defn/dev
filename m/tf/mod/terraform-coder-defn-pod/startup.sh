#!/usr/bin/env bash

set -ex

exec 3>&1
tail -f /tmp/dfd-startup.log 1>&3 &
exec >>/tmp/dfd-startup.log 2>&1

function main {
	set -e

	curl -fsSL https://code-server.dev/install.sh | sh -s -- --method=standalone --prefix=/tmp/code-server --version 4.16.1
	/tmp/code-server/bin/code-server --auth none --port 13337 >/tmp/code-server.log 2>&1 &

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
}

main "$@"
