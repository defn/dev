export USER=ubuntu
export LOCAL_ARCHIVE=/usr/lib/locale/locale-archive
export LC_ALL=C.UTF-8
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
	if [[ -n "${VSCODE_IPC_HOOK_CLI:-}" ]]; then
		if [[ ! -f "${1:-}" ]]; then
			echo "ERROR: file $1 not found" 1>&2
			return 1
		fi

		if type -P code >/dev/null; then
			command code "$@"
		else
			command code-server "$@"
		fi
	else
		command vi "$@"
	fi
}

function pca {
	pc run --all "$@"
}

# python
if [[ -z "${IN_NIX_SHELL:-}" ]]; then PATH="$HOME/.local/bin:$PATH"; fi
export PYTHONPATH
export PIP_DISABLE_PIP_VERSION_CHECK=1

# nodejs
if [[ -z "${IN_NIX_SHELL:-}" ]]; then PATH="$HOME/node_modules/.bin:$PATH"; fi

# cue
if [[ -z "${IN_NIX_SHELL:-}" ]]; then PATH="$HOME/bin/$(uname -s):$HOME/bin:$PATH"; fi

# linkerd
if [[ -z "${IN_NIX_SHELL:-}" ]]; then PATH="$HOME/.linkerd2/bin:$PATH"; fi

# terraform
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export DISABLE_VERSION_CHECK=1

# nextjs
export NEXT_TELEMETRY_DISABLED=1

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
export EDITOR=vim
if [[ -n "${VSCODE_IPC_HOOK_CLI:-}" ]]; then
	export BROWSER="$(set +f; ls -d /home/ubuntu/.local/lib/code-server-*/lib/vscode/bin/helpers/browser.sh)"

	if [[ ! -S "${SSH_AUTH_SOCK:-}" ]]; then
		export SSH_AUTH_SOCK="$(ls -td /tmp/vscode-ssh-auth-sock-* 2>/dev/null | head -1)"
	fi
fi

# vault
export VAULT_ADDR="${VAULT_ADDR:-unix:///work/vault-agent/vault-agent.sock}"

# aws-vault
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault

if tty >/dev/null; then
  if type -P powerline-go >/dev/null; then
	function render_ps1 {
		powerline-go --colorize-hostname -mode flat -newline \
			-modules host,ssh,cwd,perms,gitlite,load,exit,venv,kube
	}

	function update_ps1 {
		ls -td /tmp/vscode-ssh-auth-sock* 2>/dev/null | tail -n +2 | xargs rm -f /tmp/meh;
		if [[ ! -S "${SSH_AUTH_SOCK:-}" ]]; then
			export SSH_AUTH_SOCK="$(ls -td /tmp/vscode-ssh-auth-sock-* 2>/dev/null | head -1)"
		fi
		PS1="$(render_ps1)"
	}

    PROMPT_COMMAND="update_ps1"
  fi
fi

if [[ -n "${VSCODE_IPC_HOOK_CLI:-}" ]]; then
  export VSCODE_GIT_IPC_HANDLE="$(ls -thd ${TMPDIR}/vscode-git-*.sock 2>/dev/null | head -1)"
	if ! [[ -f ~/.home.done ]]; then
		if flock -n ~/.home.lock -c 'cd && ~/bin/e make install'; then
			touch ~/.home.done
		fi
	fi
fi

PATH="/bin:$PATH"

if test -s ~/.nix-profile/bin/direnv; then eval "$(~/.nix-profile/bin/direnv hook bash)"; fi
export DIRENV_LOG_FORMAT=
