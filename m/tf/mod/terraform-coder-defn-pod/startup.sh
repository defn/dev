#!/usr/bin/env bash

function main {
	cd
	source .bash_profile

	set -ex

	setsid code-server --auth none --port 13337 1>>/tmp/stdout.log 2>>/tmp/stderr.log &

	ssh -o StrictHostKeyChecking=no git@github.com true || true &

	sudo chmod g-s /home/ubuntu

	sudo install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg
	sudo install -d -m 0700 -o ubuntu -g ubuntu /nix /nix

	if [[ "$(df -klh /nix | tail -1 | awk '{print $NF}')" == "/" ]]; then
		sudo ln -nfs ~ /nix/home
	fi

	git fetch
	if [[ -n "${source_rev}" ]]; then
		git checkout "${source_rev}"
	fi
	git pull

	case "$(git remote get-url origin)" in
	http*)
		git remote rm origin
		git remote add origin git@github.com:defn/dev
		git fetch origin
		git branch --set-upstream-to=origin/${source_rev} ${source_rev}
		;;
	esac

	if [[ -n "${workdir}" ]]; then
		cd "${workdir}"
		make init
	fi

	date
}

time main "$@"
