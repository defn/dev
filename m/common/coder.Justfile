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

	remote="ssh $(id -un)@$(echo $name | cut -d- -f1)"

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

	sudo=sudo

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

	export STARSHIP_NO=1 LOCAL_ARCHIVE=/usr/lib/locale/locale-archive

	cd
	source ~/.bash_profile

	cd ~/m
	exec 1>/dev/null
	exec 2>/dev/null

	if [[ -n "${CODER_INIT_SCRIPT_BASE64:-}" ]]; then
		echo ${CODER_INIT_SCRIPT_BASE64} | base64 -d \
			| sed 's#agent$#agent '"${CODER_NAME}"'#; s#^while.*#while ! test -x ${BINARY_NAME}; do#; s#^BINARY_NAME.*#BINARY_NAME='"$HOME"'/bin/nix/coder#; s#exec ./#exec #; s#exit 1#echo exit 1#; s#output=$(./#output=$(#' \
			> /tmp/coder-init-script-${CODER_NAME}-$$
		exec bash -x /tmp/coder-init-script-${CODER_NAME}-$$
	else
		exec coder agent
	fi

# Run code-server in s6
[no-cd, private]
code-server *host:
  #!/usr/bin/env bash
  cd ~/m
  source ~/.bash_profile
  set -x
  exec 2>&1
  mise run serve
  for a in $(env | grep ^CODER_ | cut -d= -f1); do printf 'export %s=%q\n\n' "$a" "$(echo "${!a}")"; done > svc.d/code-server/.env
  for a in $(env | grep ^GIT_ | cut -d= -f1); do printf 'export %s=%q\n\n' "$a" "$(echo "${!a}")"; done >> svc.d/code-server/.env
  for a in $(env | grep ^VSCODE_ | cut -d= -f1); do printf 'export %s=%q\n\n' "$a" "$(echo "${!a}")"; done >> svc.d/code-server/.env
  ln -nfs ../svc.d/code-server svc/
  s6-svscanctl -a svc
  s6-svc -r svc/code-server

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
