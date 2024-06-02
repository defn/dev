set shell := ["/usr/bin/env", "bash", "-c"]

# Re-creates an envbuilder Coder workspace
[no-cd]
up *name:
	#!/usr/bin/env bash
	set -efuo pipefail

	name={{name}}

	if [[ -z "${name}" ]]; then
		if [[ -n "${CODER_NAME:-}" ]]; then
			case "${CODER_NAME}" in
				coder-*)
					name="$(echo "${CODER_NAME-}" | cut -d- -f3)-$(basename $(pwd))"
					;;
				*)
					name="$(echo "${CODER_NAME-}" | cut -d- -f1)-$(basename $(pwd))"
					;;
			esac
		else
			name="$(uname -n)-$(basename $(pwd))"
		fi
	fi

	homedir=$(pwd)
	# rewrite macOS to /home/ubuntu
	case "${homedir}" in 
		/Users/*)
			homedir="/home/ubuntu/$(echo ${homedir} | cut -d/ -f4-)"
			;;
	esac

	case "${name}" in
		penguin*)
			remote=
			;;
		immanent*)
			remote="ssh $(id -un)@$(echo $name | cut -d- -f1)"
			;;
		*)
			remote="ssh $(id -un)@$(echo $name | cut -d- -f1)"
			;;
	esac

	os=linux
	case "$(uname -m)" in
		aarch64)
			arch=arm64
			;;
		*)
			arch=amd64
			;;
	esac
	command="make coder-ssh-envbuilder"
	template=coder-defn-ssh-template

	case "$(uname -s)" in
		Darwin)
			export SUDO_ASKPASS=$HOME/bin/askpass
			sudo="sudo -A"
			;;
		*)
			sudo=sudo
			;;
	esac

	$sudo ln -nfs ubuntu /home/dev
	$sudo chown $(id -un) /var/run/docker.sock 2>/dev/null || true
	$sudo touch ~/.gnupg/S.gpg-agent.extra
	just coder::down ${name} || true

	coder delete ${name} --yes 1>/dev/null 2>/dev/null || true
	coder create ${name} --template ${template} --parameter "arch=${arch},os=${os},homedir=${homedir},remote=${remote},command=${command}" --yes

	while true; do
		if curl -sSL $(cat $HOME/.config/coderv2/url)/api/v2/users/$(coder list | tail -1 | awk '{print $1}' | cut -d/ -f1)/workspace/${name} -H "Coder-Session-Token: $(cat $HOME/.config/coderv2/session)" | jq -r '(.latest_build.resources[].agents//[])[].apps[] | select(.display_name == "code-server") | .health' | grep -q ^healthy; then 
			break
		fi
		date
		sleep 5
	done

	just coder::open "${name}"

# Deletes Coder workspace
[no-cd]
down *name:
	#!/usr/bin/env bash
	set -efuo pipefail

	name={{name}}

	if [[ -z "${name}" ]]; then
		if [[ -n "${CODER_NAME:-}" ]]; then
			case "${CODER_NAME}" in
				coder-*)
					name="$(echo "${CODER_NAME-}" | cut -d- -f3)-$(basename $(pwd))"
					;;
				*)
					name="$(echo "${CODER_NAME-}" | cut -d- -f1)-$(basename $(pwd))"
					;;
			esac
		else
			name="$(uname -n)"
		fi
	fi

	homedir=$(pwd)

	docker ps -q -a --filter label=devcontainer.local_folder=${homedir} | runmany 'docker rm -f $1 2>/dev/null' || true
	docker rm -f "${name}" 2>/dev/null || true
	coder delete ${name} --yes 1>/dev/null 2>/dev/null || true

# Opens Coder workspace in browser. Creates workspace if necessary
[no-cd]
use *name:
	#!/usr/bin/env bash
	set -efuo pipefail

	name={{name}}

	if [[ -z "${name}" ]]; then
		if [[ -n "${CODER_NAME:-}" ]]; then
			case "${CODER_NAME}" in
				coder-*)
					name="$(echo "${CODER_NAME-}" | cut -d- -f3)-$(basename $(pwd))"
					;;
				*)
					name="$(echo "${CODER_NAME-}" | cut -d- -f1)-$(basename $(pwd))"
					;;
			esac
		else
			name="$(uname -n)"
		fi
	fi

	if curl -sSL $(cat $HOME/.config/coderv2/url)/api/v2/users/$(coder list | tail -1 | awk '{print $1}' | cut -d/ -f1)/workspace/${name} -H "Coder-Session-Token: $(cat $HOME/.config/coderv2/session)" | jq -r '(.latest_build.resources[].agents//[])[].apps[] | select(.display_name == "code-server") | .health' | grep -q ^healthy; then 
		just coder::open "${name}"
	else
		just coder::up "${name}"
	fi

# Opens Coder workspace in browser
[no-cd]
open*name:
	#!/usr/bin/env bash
	set -efuo pipefail

	name={{name}}

	if [[ -z "${name}" ]]; then
		if [[ -n "${CODER_NAME:-}" ]]; then
			case "${CODER_NAME}" in
				coder-*)
					name="$(echo "${CODER_NAME-}" | cut -d- -f3)-$(basename $(pwd))"
					;;
				*)
					name="$(echo "${CODER_NAME-}" | cut -d- -f1)-$(basename $(pwd))"
					;;
			esac
		else
			name="$(uname -n)"
		fi
	fi

	homedir=$(pwd)

	open "$(curl -sSL $(cat $HOME/.config/coderv2/url)/api/v2/debug/health -H "Coder-Session-Token: $(cat $HOME/.config/coderv2/session)" | jq -r '.access_url.access_url')/@$(coder list | tail -1 | awk '{print $1}' | cut -d/ -f1)/${name}.main/apps/cs/?folder=$(echo ${homedir} | sed "s#${HOME}#/home/ubuntu#")"

# Run coder agent
[private]
coder-agent *host:
	#!/usr/bin/env bash


	case "$(uname -s)" in
		Darwin) export LC_ALL=C LANG=C ;;
	esac

	export STARSHIP_NO=1 LOCAL_ARCHIVE=/usr/lib/locale/locale-archive
	source ~/.bash_profile
	cd ${CODER_HOMEDIR}
	echo ${CODER_INIT_SCRIPT_BASE64} | base64 -d \
		| sed 's#agent$#agent '"${CODER_NAME}"'#; s#^while.*#while ! test -x '"${BINARY_NAME}"'; do#; s#^BINARY_NAME.*#BINARY_NAME='"$HOME"'/bin/nix/coder#; s#exec ./#exec #; s#exit 1#echo exit 1#' \
		> /tmp/coder-agent-${CODER_NAME}-$$
	exec bash -x /tmp/coder-agent-${CODER_NAME}-$$

# Run code-server in a loop
[no-cd, private]
code-server *host:
	#!/usr/bin/env bash

	case "$(uname -s)" in
		Darwin) export LC_ALL=C LANG=C ;;
	esac

	pkill -9 trunk || true
	export STARSHIP_NO=
	source ~/.bash_profile

	while true; do 
		case "$(uname -s)" in
			Linux)
				exec code-server --auth none
				;;
			*)
				code-server --auth none || true
				;;
		esac
	done

# update all Coder workspace templates
[no-cd, private]
update-all:
	coder list | grep 'true *$'  | awk '{print $1}' | runmany 'echo coder update $1'

# restart all Coder workspaces
[no-cd, private]
restart-all:
	coder list | grep 'Started *false' | awk '{print $1}' | runmany 'coder restart --yes $1'

# watch Coder workspace status
[no-cd, private]
status:
	watch -n 5 -d 'coder list | sort -k3,4'
