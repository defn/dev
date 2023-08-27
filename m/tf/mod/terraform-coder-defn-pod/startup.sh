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

	case "$(git remote get-url origin)" in
	http*)
		git remote rm origin
		git remote add origin git@github.com:defn/dev
		git fetch origin
		git branch --set-upstream-to=origin/main main
		;;
	esac

	local workdir
	local source_rev

	case "$#" in
		1)
			workdir="$1"
			shift
			;;
		2)
			workdir="$1"
			shift
			source_rev="$1"
			shift
			;;
		0)
			workdir=
			source_rev=
			;;
		*)
			workdir=
			source_rev=
			;;
	esac

	if [[ -n "${source_rev}" ]]; then
		git checkout "${source_rev}"
	fi

	git pull

	if [[ -n "${workdir}" ]]; then
		cd "${workdir}"
	fi

	date
}

time main "$@"
