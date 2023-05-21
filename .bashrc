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
if [[ -z "${IN_NIX_SHELL:-}" ]]; then PATH="$HOME/.local/bin:$PATH"; fi
export PYTHONPATH
export PIP_DISABLE_PIP_VERSION_CHECK=1

# homebrew
PATH="$PATH:/opt/homebrew/bin"

# home
PATH="$PATH:$HOME/bin"

# bash
export BASH_SILENCE_DEPRECATION_WARNING=1

# sudo
export SUDO_ASKPASS="$HOME/bin/askpass"

# nodejs
if [[ -z "${IN_NIX_SHELL:-}" ]]; then PATH="$HOME/node_modules/.bin:$PATH"; fi

# cueimports
PATH="$PATH:$HOME/.bin"

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
export KUBECONFIG_ALL="$HOME/.kube/config"

# editor
export CODER_TELEMETRY=false
export EDITOR=vim
if [[ -n "${VSCODE_GIT_ASKPASS_MAIN:-}" ]]; then
	case "${VSCODE_GIT_ASKPASS_MAIN}" in
		/vscode/*)
			export BROWSER=browser.sh
			;;
		*/code-server*)
			export BROWSER=browser.sh
			;;
		*)
			export BROWSER="open"
			;;
	esac
fi

# ssh-agent
case "$(uname -s)" in
	Darwin)
		export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
		;;
	Linux)
		if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
			export SSH_AUTH_SOCK=$HOME/.ssh/S.ssh-agent
		fi
		;;
esac

# aws-vault
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault

# vault
case "$(uname -s)" in
  Darwin)
    export VAULT_ADDR="http://localhost:8200"
    ;;
  *)
    export VAULT_ADDR="http://host.docker.internal:8200"
    ;;
esac

# nix
if [[ "Linux" == "$(uname -s)" ]]; then
	export USER=ubuntu
	export LOCAL_ARCHIVE=/usr/lib/locale/locale-archive
	export LC_ALL=C.UTF-8
fi

if [[ -e ~/.nix-profile/etc/profile.d/nix.sh ]]; then
	. ~/.nix-profile/etc/profile.d/nix.sh
fi

# direnv
export DIRENV_LOG_FORMAT=

if type -P direnv >/dev/null; then
	eval "$(direnv hook bash)"
	_direnv_hook
else
	function _direnv_hook {
		true
	}
fi

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
	if [[ -f SLUG ]]; then
		slub="$(cat SLUG)"
	fi

	local vendor=
	if [[ -f VENDOR ]]; then
		vendor="$(cat VENDOR)"
	fi

	local revision=
	if [[ -f REVISION ]]; then
		revision="$(cat REVISION)"
	fi

	local version=
	if [[ -f VERSION ]]; then
		version="$(cat VERSION)"
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

# aliases
function vi {
	if [[ -n "${VSCODE_GIT_ASKPASS_MAIN:-}" ]]; then
		local code

    code="${VSCODE_GIT_ASKPASS_MAIN%/extensions/*}/bin/remote-cli/code-linux.sh" 
    if [[ ! -x "$code" ]]; then
      code="${VSCODE_GIT_ASKPASS_MAIN%/extensions/*}/bin/remote-cli/code" 
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

function d {
	ionice -c 3 nice nix develop --command bash -c "touch flake.nix; direnv allow"
}

function gs {
	git status -sb "$@"
}

function pc {
	pre-commit "$@"
}

function pca {
	pc run --all "$@"
}

# dotfiles
export GIT_AUTHOR_EMAIL
export GIT_COMMITTER_EMAIL
export GIT_AUTHOR_NAME
export GIT_COMMITTER_NAME

if [[ -f ~/.dotfiles/dot/bashrc ]]; then source ~/.dotfiles/dot/bashrc; fi

unset DIRENV_DIFF DIRENV_WATCHES
