if [[ "Linux" == "$(uname -s)" ]]; then
	export USER=ubuntu
	export LOCAL_ARCHIVE=/usr/lib/locale/locale-archive
	export LC_ALL=C.UTF-8
fi

export TMPDIR="${TMPDIR:-/tmp}"
export TEMPDIR="${TEMPDIR:-/tmp}"

if [[ -z "${IN_NIX_SHELL:-}" ]]; then
	if [ -e /home/ubuntu/.nix-profile/etc/profile.d/nix.sh ]; then
		. /home/ubuntu/.nix-profile/etc/profile.d/nix.sh
	fi
fi

function gs {
	git status -sb "$@"
}

function vi {
	if [[ -n "${VSCODE_GIT_ASKPASS_NODE:-}" ]]; then
		if [[ ! -f "${1:-}" ]]; then
			echo "ERROR: file $1 not found" 1>&2
			return 1
		fi

    case "${VSCODE_GIT_ASKPASS_NODE}" in
      */code-server*)
			  command code-server "$@"
        ;;
      *)
			  command code "$@"
        ;;
    esac
	else
		command vi "$@"
	fi
}

function pc {
	pre-commit "$@"
}

function pca {
	pc run --all "$@"
}

# python
if [[ -z "${IN_NIX_SHELL:-}" ]]; then PATH="$HOME/.local/bin:$PATH"; fi
export PYTHONPATH
export PIP_DISABLE_PIP_VERSION_CHECK=1

# gpg-agent ssh socket
# TODO how does this get set in Linux
SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh; export SSH_AUTH_SOCK

# homebrew
PATH="$PATH:/opt/homebrew/bin"

# home
PATH="$PATH:$HOME/bin"

# bash
export BASH_SILENCE_DEPRECATION_WARNING=1

# nodejs
if [[ -z "${IN_NIX_SHELL:-}" ]]; then PATH="$HOME/node_modules/.bin:$PATH"; fi

# cue
if [[ -z "${IN_NIX_SHELL:-}" ]]; then PATH="$HOME/bin/$(uname -s):$HOME/bin:$PATH"; fi

# terraform
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export DISABLE_VERSION_CHECK=1

# nextjs
export NEXT_TELEMETRY_DISABLED=1

# go
export GOCACHE="$HOME/.cache/go-build"
export GOMODCACHE="$HOME/.cache/go-mod"

# awscli
if [[ -z "${IN_NIX_SHELL:-}" ]]; then PATH="$PATH:/usr/local/aws-cli/bin"; fi

# earthly
#export EARTHLY_BUILDKIT_HOST="${EARTHLY_BUILDKIT_HOST:-tcp://$(uname -n):8372}"
unset EARTHLY_BUILDKIT_HOST
export DOCKER_BUILDKIT="${DOCKER_BUILDKIT:-1}"
if [[ -z "${IN_NIX_SHELL:-}" ]]; then PATH="$PATH:/usr/local/gcloud/google-cloud-sdk/bin"; fi
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# hof
export HOF_TELEMETRY_DISABLED=1

# fake xdisply
#export DISPLAY=1

# kubectl
export KUBECONFIG_ALL="$HOME/.kube/config"

# vscode
export CODER_TELEMETRY=false
export EDITOR=vim
if [[ -n "${VSCODE_IPC_HOOK_CLI:-}" ]]; then
	export BROWSER="$(which browser.sh)"

	if [[ ! -S "${SSH_AUTH_SOCK:-}" ]]; then
		export SSH_AUTH_SOCK="$(ls -td /tmp/vscode-ssh-auth-sock-* 2>/dev/null | head -1)"
	fi
fi

# vault
export VAULT_ADDR="${VAULT_ADDR:-unix:///work/vault-agent/vault-agent.sock}"

# aws-vault
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault

# direnv
export DIRENV_LOG_FORMAT=

if type -P direnv >/dev/null; then
	eval "$(direnv hook bash)"
	_direnv_hook
	unset DIRENV_DIFF DIRENV_WATCHES
fi

# powerline-go
export EXTRA="${EXTRA:- }"
if tty >/dev/null; then
  if type -P powerline-go >/dev/null; then
	function render_ps1 {
		powerline-go --colorize-hostname -mode flat -newline \
			-modules host,ssh,cwd,perms,gitlite,load,exit,venv,kube,shell-var \
			-shell-var EXTRA
	}

	function update_ps1 {
		ls -td /tmp/vscode-ssh-auth-sock* 2>/dev/null | tail -n +2 | xargs rm -f /tmp/meh;
		if [[ ! -S "${SSH_AUTH_SOCK:-}" ]]; then
			export SSH_AUTH_SOCK="$(ls -td /tmp/vscode-ssh-auth-sock-* 2>/dev/null | head -1)"
		fi
		EXTRA=""
		if [[ -f VERSION ]]; then
			if [[ -f VENDOR ]]; then
				local vendor="$(cat VENDOR)"
				EXTRA="/ ${vendor}"
			fi

			local version="$(cat VERSION)"
			EXTRA="${version}${EXTRA:+ ${EXTRA}}"

			local tag="$(git describe --tags --abbrev=0 $(git log . | head -1 | awk '{print $2}'))"
			if [[ "${tag}" != "${version}" ]]; then
				EXTRA="!${EXTRA}"
			fi
		fi
		EXTRA="${EXTRA:- }"
		PS1="$(render_ps1)"
	}

    PROMPT_COMMAND="update_ps1"
  fi
fi

if type -P direnv >/dev/null; then
	eval "$(direnv hook bash)"
fi

# install
if [[ -n "${VSCODE_IPC_HOOK_CLI:-}" ]]; then
  	export VSCODE_GIT_IPC_HANDLE="$(ls -thd ${TMPDIR}/vscode-git-*.sock 2>/dev/null | head -1)"
	if [[ "Linux" == "$(uname -s)" ]]; then
		if ! [[ -f ~/.home.done ]]; then
			if flock -n ~/.home.lock -c 'cd && ~/bin/e make install'; then
				touch ~/.home.done
			fi
		fi
	fi
fi
