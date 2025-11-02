#!/usr/bin/env bash

unset LC_ALL

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

# coder
export CODER_TELEMETRY_ENABLE=false

# editor
export EDITOR=vim

# ssh-agent
case "$(uname -s)" in
Darwin)
	true export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
	;;
Linux)
	if type -P gpgconf >/dev/null; then
		true export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	fi
	;;
esac

# aws-vault
#export AWS_VAULT_BACKEND=pass
#export AWS_VAULT_PASS_PREFIX=aws-vault
export AWS_VAULT_BACKEND=file
export AWS_VAULT_FILE_DIR=~/.awsvault/keys
export AWS_VAULT_FILE_PASSPHRASE=""

# nix
if [[ "Linux" == "$(uname -s)" ]]; then
	export USER=ubuntu
	export LOCAL_ARCHIVE=/usr/lib/locale/locale-archive
fi

# storybook
export STORYBOOK_DISABLE_TELEMETRY=1

# direnv
export DIRENV_LOG_FORMAT=

# precommit
export PRE_COMMIT_ALLOW_NO_CONFIG=1

# mise
if type -P mise >/dev/null; then
	eval "$(mise activate bash)"
fi

# prompt
export PROMPT_COMMAND
if test -z "${STARSHIP_NO-}"; then
	if [[ -x "$(which starship)" ]]; then
		# starship
		eval "$(starship init bash)"
	fi
fi

# aliases
function m {
	if [[ $# -gt 0 ]]; then
		mise run "$@"
	else
		mise run default
	fi
}

export MISE_PIN=1

function profile {
	if [[ -n ${1-} ]]; then
		export AWS_PROFILE="$1"
		shift

		export AWS_CONFIG_FILE="$HOME/m/bazel-bin/aws/aws_config.txt"

		region "$@"
	else
		unset AWS_PROFILE
		unset AWS_REGION
		unset AWS_DEFAULT_REGION
		unset AWS_CONFIG_FILE
	fi
}

function region {
	if [[ -n ${1-} ]]; then
		export AWS_REGION="$1"
		unset AWS_DEFAULT_REGION
		shift

		export AWS_CONFIG_FILE="$HOME/m/bazel-bin/aws/aws_config.txt"
	else
		unset AWS_REGION
		unset AWS_DEFAULT_REGION
		unset AWS_CONFIG_FILE
	fi
}

function vi {
	if [[ -n ${VSCODE_GIT_ASKPASS_MAIN-} ]]; then
		local code
		local windsurf

		windsurf="${VSCODE_GIT_ASKPASS_MAIN%/extensions/*}/bin/windsurf"
		if [[ -x $windsurf ]]; then
			"$windsurf" "$@"
			return $?
		fi

		code="${VSCODE_GIT_ASKPASS_MAIN%/extensions/*}/bin/code"
		if [[ -x $code ]]; then
			"$code" "$@"
			return $?
		fi

		code="${VSCODE_GIT_ASKPASS_MAIN%/extensions/*}/bin/remote-cli/code-linux.sh"
		if [[ ! -x $code ]]; then
			code="${VSCODE_GIT_ASKPASS_MAIN%/extensions/*}/bin/remote-cli/code"
		fi

		if [[ ! -x $code ]]; then
			code="$(type -P code || true)"
		fi

		if [[ ! -x $code ]]; then
			command vi "$@"
			return $?
		else
			"$code" "$@"
			return $?
		fi
	else
		command vi "$@"
		return $?
	fi
}

function alogin {
	(
		if [[ -n ${1-} ]]; then
			aprofile "$1"
			shift
		fi
		if [[ -n ${1-} ]]; then
			aregion "$1"
			shift
		fi

		local aws_url="$(aws-vault login ${AWS_PROFILE} -s | sed 's#://#://us-east-1.#')"
		local encoded_url=$(printf "%s" "$aws_url" | python -c 'import sys; from urllib.parse import quote_plus; print(quote_plus(sys.stdin.read().strip()))')
		open "https://signin.aws.amazon.com/oauth?Action=logout&redirect_uri=${encoded_url}"
	)
}

function aprofile {
	unset AWS_DEFAULT_REGION
	unset AWS_REGION

	export AWS_PROFILE="${1}"
	shift

	if [[ -n ${1-} ]]; then
		aregion="$1"
	fi
}

function aregion {
	export AWS_DEFAULT_REGION="${1}"
	export AWS_REGION="${1}"
}

function gs {
	git status -sb "$@"
}

function w {
	cd "${workdir}"
}

function use {
	local selected="$(
		cd
		find m/c m/a m/infra -type d | egrep -v '/(\.terraform|docs|node_modules|\.aws)' | sort | fzf --select-1 --query="$@"
	)"
	if [[ -z ${selected} ]]; then
		return 0
	fi

	cd "$HOME/$selected"
	if [[ -r README.md ]]; then
		cat README.md | grep -v ^auto-generated: | glow --width 0
	fi
}

# coder ssh helper
if [[ -z ${BUILDKITE-} ]]; then
	if [[ -n ${CODER_NAME-} ]]; then
		export GIT_SSH_COMMAND="$(mise exec -- which coder) gitssh --"
	fi

	if [[ -z ${CODER_AGENT_URL-} ]]; then
		if [[ -n ${CODER_NAME-} ]]; then
			CODER_AGENT_PID="$(pgrep -f bin/coder.agent.${CODER_NAME})"
			if [[ -n ${CODER_AGENT_PID} ]]; then
				eval "$(cat /proc/${CODER_AGENT_PID}/environ | tr '\0' '\n' | egrep '^CODER_AGENT_(URL|TOKEN_AUTH)=')"
				export CODER_AGENT_URL
				export CODER_AGENT_TOKEN
				export CODER_AGENT_AUTH
			fi
		fi
	fi
fi

# vscode browser
export BROWSER="$(type -P browser || true)"

unset MAKEFLAGS

if test -r ~/.ssh-agent-rc; then source ~/.ssh-agent-rc >/dev/null; fi

export PATH=/home/ubuntu/.groundcover/bin:${PATH}
