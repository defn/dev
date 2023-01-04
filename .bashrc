# tmp
export TMPDIR="${TMPDIR:-/tmp}"
export TEMPDIR="${TEMPDIR:-/tmp}"

# nix
if [[ "Linux" == "$(uname -s)" ]]; then
	export USER=ubuntu
	export LOCAL_ARCHIVE=/usr/lib/locale/locale-archive
	export LC_ALL=C.UTF-8
fi

if [ -e /home/ubuntu/.nix-profile/etc/profile.d/nix.sh ]; then
	. /home/ubuntu/.nix-profile/etc/profile.d/nix.sh
else
	PATH="/nix/var/nix/profiles/default/bin:$PATH"
fi

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
if [[ -n "${VSCODE_GIT_ASKPASS_NODE:-}" ]]; then
	case "${VSCODE_GIT_ASKPASS_NODE}" in
		/vscode/*)
			export BROWSER=${VSCODE_GIT_ASKPASS_NODE%/node}/bin/helpers/browser.sh
			;;
		*/code-server*)
			export BROWSER=${VSCODE_GIT_ASKPASS_NODE%/node}/vscode/bin/helpers/browser.sh
			;;
		*)
			export BROWSER="open"
			;;
	esac
fi

# aws-vault
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault

# direnv
export DIRENV_LOG_FORMAT=

if type -P direnv >/dev/null; then
	eval "$(direnv hook bash)"
	_direnv_hook
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

	PROMPT_COMMAND="_direnv_hook;update_ps1"
  fi
fi

# install
if [[ -n "${VSCODE_GIT_ASKPASS_NODE:-}" ]]; then
	if [[ "Linux" == "$(uname -s)" ]]; then
		if ! [[ -f ~/.home.done ]]; then
			if flock -n ~/.home.lock -c 'cd && ~/bin/e make install'; then
				touch ~/.home.done
			fi
		fi
	fi
fi

# aliases
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

# dotfiles
if [[ -f ~/.dotfiles/dot/bashrc ]]; then source ~/.dotfiles/dot/bashrc; fi

unset DIRENV_DIFF DIRENV_WATCHES
