set shell := ["/usr/bin/env", "bash", "-c"]

[no-cd]
default:
	@while true; do just coder::code-server; sleep 5; done

[no-cd]
code-server:
	@pkill -9 trunk || true
	@export STARSHIP_NO= && while true; do source ~/.bash_profile; code-server --auth none; sleep 5; done

[no-cd]
up *name:
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

	if [[ -n ${1-} ]]; then
		remote=$1
		shift
	else
		remote=""
	fi

	command="make coder-ssh-envbuilder"
	arch=amd64
	os=linux
	template=coder-defn-ssh-template

	sudo chown $(id -un) /var/run/docker.sock
	just coder::down || true

	while true; do
		coder delete ${name} --yes 1>/dev/null 2>/dev/null || true
		if coder create ${name} --template ${template} --parameter "arch=${arch},os=${os},homedir=${homedir},remote=${remote},command=${command}" --yes; then 
			break
		fi
		sleep 5
	done

	while true; do
		if curl -sSL $(cat $HOME/.config/coderv2/url)/api/v2/users/$(coder list | tail -1 | awk '{print $1}' | cut -d/ -f1)/workspace/${name} -H "Coder-Session-Token: $(cat $HOME/.config/coderv2/session)" | jq -r '(.latest_build.resources[].agents//[])[].apps[] | select(.display_name == "code-server") | .health' | grep -q ^healthy; then 
			break
		fi
		date
		sleep 5
	done
	just coder::open "${name}"

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
