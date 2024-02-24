#!/usr/bin/env bash

if [[ -n ${VSCODE_RESOLVING_ENVIRONMENT-} ]]; then
	return
fi

# vscode terminal init
if [[ -z ${WORKDIR-} ]]; then
	source ~/.bash_entrypoint
	return
fi

# tmp
export TMPDIR="${TMPDIR:-/tmp}"
export TEMPDIR="${TEMPDIR:-/tmp}"

# python
export PYTHONPATH
export PIP_DISABLE_PIP_VERSION_CHECK=1

# bash
export BASH_SILENCE_DEPRECATION_WARNING=1

# sudo
export SUDO_ASKPASS="$HOME/bin/askpass"

# terraform
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export DISABLE_VERSION_CHECK=1

# cloud-nuke
export DISABLE_TELEMETRY=1

# nextjs
export NEXT_TELEMETRY_DISABLED=1

# go
export GOCACHE="$HOME/.cache/go-build"
export GOMODCACHE="$HOME/.cache/go-mod"

# earthly
#export EARTHLY_BUILDKIT_HOST="${EARTHLY_BUILDKIT_HOST:-tcp://$(uname -n):8372}"
unset EARTHLY_BUILDKIT_HOST
export DOCKER_BUILDKIT="${DOCKER_BUILDKIT:-1}"

# gcloud
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# hof
export HOF_TELEMETRY_DISABLED=1

# fake xdisplay
#export DISPLAY=1

# kubectl
if ! test -e "${KUBECONFIG:-}"; then 
	if test -e "$HOME/.kube/config"; then
		export KUBECONFIG="$HOME/.kube/config"
	else
		export KUBECONFIG="$HOME/.kube/config-in-cluster"
	fi
fi

# cilium
export CILIUM_CLI_MODE=classic

# editor
export CODER_TELEMETRY=false
export EDITOR=vim

# ssh-agent
unset SSH_AUTH_SOCK
case "$(uname -s)" in
Darwin)
	export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
	;;
esac

# aws-vault
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault

# nix
if [[ "Linux" == "$(uname -s)" ]]; then
	export USER=ubuntu
	export LOCAL_ARCHIVE=/usr/lib/locale/locale-archive
	export LC_ALL=C.UTF-8
fi

# storybook
export STORYBOOK_DISABLE_TELEMETRY=1

# direnv
export DIRENV_LOG_FORMAT=

# precommit
export PRE_COMMIT_ALLOW_NO_CONFIG=1

# prompt
if type -P starship >/dev/null; then
	# starship
	eval "$(starship init bash)"
fi

# aliases
function vi {
	if [[ -n ${VSCODE_GIT_ASKPASS_MAIN-} ]]; then
		local code

		code="${VSCODE_GIT_ASKPASS_MAIN%/extensions/*}/bin/remote-cli/code-linux.sh"
		if [[ ! -x $code ]]; then
			code="${VSCODE_GIT_ASKPASS_MAIN%/extensions/*}/bin/remote-cli/code"
		fi

		if [[ ! -x $code ]]; then
			code="$(type -P code || true)"
		fi

		if [[ ! -x $code ]]; then
			command vi "$@"
		else
			"$code" "$@"
		fi
	else
		command vi "$@"
	fi
}

function gs {
	git status -sb "$@"
}

# vscode browser
export BROWSER="$(type -P browser || true)"

# until ec2 env is updated
export DFD_PREFIX="${DFD_PREFIX:-$(echo "${DFD_WORKSPACE_NAME-}" | cut -d- -f1)}"
export DFD_OWNER="${DFD_OWNER:-$(echo "${DFD_WORKSPACE_NAME-}" | cut -d- -f2)}"
export DFD_NAME="${DFD_NAME:-$(echo "${DFD_WORKSPACE_NAME-}" | cut -d- -f3-)}"
