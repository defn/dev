#!/usr/bin/env bash

case "$(uname -s)" in
Darwin)
	export LC_ALL=C
	export LANG=C
	;;
esac

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

# nodejs
export NO_UPDATE_NOTIFIER=1

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
export GOTOOLCHAIN=local

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
if ! test -e "${KUBECONFIG-}"; then
	if test -e "$HOME/.kube/config"; then
		export KUBECONFIG="$HOME/.kube/config"
	else
		true
		# export KUBECONFIG="$HOME/.kube/config-in-cluster"
	fi
fi

# cilium
export CILIUM_CLI_MODE=classic

# editor
export CODER_TELEMETRY=false
export EDITOR=vim

# ssh-agent
case "$(uname -s)" in
Darwin)
	export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
	;;
Linux)
	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
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
if test -z "${STARSHIP_NO-}"; then
	if type -P starship >/dev/null; then
		# starship
		eval "$(starship init bash)"
	fi
fi

# aliases
function m {
	if [[ "$#" -gt 0 ]]; then
		mise run "$@"
	else
		mise task ls
	fi
}

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
		command code "$@"
	fi
}

function gs {
	git status -sb "$@"
}

function w {
	cd "${workdir}"
}

# vscode browser
export BROWSER="$(type -P browser || true)"

unset MAKEFLAGS

if test -r ~/.ssh-agent-rc; then source ~/.ssh-agent-rc >/dev/null; fi

# mise
if type -P mise >/dev/null; then
	eval "$(mise activate bash)"
fi
