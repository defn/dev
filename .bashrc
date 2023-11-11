if [[ -n "${VSCODE_RESOLVING_ENVIRONMENT:-}" ]]; then
	return
fi

# vscode terminal init
if [[ -z "${WORKDIR:-}" ]]; then
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

# fake xdisply
#export DISPLAY=1

# kubectl
if [[ -z "${KUBECONFIG:-}" ]]; then export KUBECONFIG="$HOME/.kube/config"; fi

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
else
	# powerline-go
	function render_ps1 {
		if type -P powerline-go >/dev/null; then
			powerline-go --colorize-hostname -mode flat -newline \
				-modules host,ssh,cwd,perms,gitlite,load,exit,venv,kube,shell-var \
				-shell-var EXTRA
		else
			echo '$ '
		fi
	}

	function update_ps1 {
		ls -td /tmp/vscode-ssh-auth-sock* 2>/dev/null | tail -n +2 | xargs rm -f /tmp/.meh;
		EXTRA=""

		local slug=
		if [[ -f flake.json ]]; then
			slug="$(jq -r '.slug' flake.json)"
			if [[ "$slug" == "null" ]]; then slug=""; fi
		fi

		local vendor=
		if [[ -f flake.json ]]; then
			vendor="$(jq -r '.vendor' flake.json)"
			if [[ "$vendor" == "null" ]]; then vendor=""; fi
		fi

		local revision=
		if [[ -f flake.json ]]; then
			revision="$(jq -r '.revision' flake.json)"
			if [[ "$revision" == "null" ]]; then revision=""; fi
		fi

		local version=
		if [[ -f flake.json ]]; then
			version="$(jq -r '.version' flake.json)"
			if [[ "$version" == "null" ]]; then version=""; fi
		fi

		if [[ -n "${version:-}" ]]; then
			EXTRA="${version:-}"
		else
			EXTRA="${slug:-}${vendor:-}${revision:+${vendor:+-}${revision}}"
		fi
		EXTRA="${EXTRA:- }"
		PS1="$(render_ps1)"
	}

	export EXTRA="${EXTRA:- }"
	if tty >/dev/null; then
		PROMPT_COMMAND="_direnv_hook;update_ps1"
	fi
fi

# aliases
function vi {
	if [[ -n "${VSCODE_GIT_ASKPASS_MAIN:-}" ]]; then
		local code

    code="${VSCODE_GIT_ASKPASS_MAIN%/extensions/*}/bin/remote-cli/code-linux.sh"
    if [[ ! -x "$code" ]]; then
      code="${VSCODE_GIT_ASKPASS_MAIN%/extensions/*}/bin/remote-cli/code"
    fi

    if [[ ! -x "$code" ]]; then
      code="$(type -P code || true)"
    fi

    if [[ ! -x "$code" ]]; then
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
