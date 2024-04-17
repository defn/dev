set shell := ["/usr/bin/env", "bash", "-c"]

# Re-creates an envbuilder Coder workspace
[no-cd]
up *name:
	#!/usr/bin/env bash
	set -exfuo pipefail

	name={{name}}

	if [[ -z "${name}" ]]; then
		if [[ -n "${CODER_NAME:-}" ]]; then
			name="$(echo "${CODER_NAME-}" | cut -d- -f1)-$(basename $(pwd))"
		else
			name="$(uname -n)-$(basename $(pwd))"
		fi
	fi

	homedir=$(pwd)

	case "${name}" in
		penguin*)
			remote=
			;;
		*)
			remote="ssh $(id -un)@$(echo $name | cut -d- -f1)"
			;;
	esac

	os=linux
	arch=amd64
	command="make coder-ssh-envbuilder"
	template=coder-defn-ssh-template

	sudo chown $(id -un) /var/run/docker.sock
	sudo touch ~/.gnupg/S.gpg-agent.extra
	just coder::down ${name} || true

	while true; do
		coder delete ${name} --yes 1>/dev/null 2>/dev/null || true
		if coder create ${name} --template ${template} --parameter "arch=${arch},os=${os},homedir=${homedir},remote=${remote},command=${command}" --yes; then 
			break
		fi
		sleep 5
	done

	set +x
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
	set -exfuo pipefail

	name={{name}}

	if [[ -z "${name}" ]]; then
		if [[ -n "${CODER_NAME:-}" ]]; then
			name="$(echo "${CODER_NAME-}" | cut -d- -f1)-$(basename $(pwd))"
		else
			name="$(uname -n)"
		fi
	fi

	homedir=$(pwd)

	docker ps -q -a --filter label=devcontainer.local_folder=${homedir} | runmany 'docker rm -f $1 2>/dev/null' || true
	docker rm -f "${name}" 2>/dev/null || true
	coder delete ${name} --yes 1>/dev/null 2>/dev/null || true

# Opens Coder workspace in browser
[no-cd]
open *name:
	#!/usr/bin/env bash
	set -exfuo pipefail

	name={{name}}

	if [[ -z "${name}" ]]; then
		if [[ -n "${CODER_NAME:-}" ]]; then
			name="$(echo "${CODER_NAME-}" | cut -d- -f1)-$(basename $(pwd))"
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

	set -x
	case "$(uname -s)" in
	  Darwin) export LC_ALL=C LANG=C ;;
	esac

	export STARSHIP_NO=1 LOCAL_ARCHIVE=/usr/lib/locale/locale-archive
	source ~/.bash_profile
	cd ${CODER_HOMEDIR}
	echo ${CODER_INIT_SCRIPT_BASE64} | base64 -d \
	  | sed 's#agent$#agent '"$(uname -n)"'#; s#^while.*#while ! test -x '"${BINARY_NAME}"'; do#; s#^BINARY_NAME.*#BINARY_NAME='"$HOME"'/bin/nix/coder#; s#exec ./#exec #; s#exit 1#echo exit 1#' \
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
	exec code-server --auth none