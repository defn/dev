function gs {
	git status -sb "$@"
}

function vi {
	if [[ -n "${VSCODE_GIT_IPC_HANDLE:-}" ]]; then
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

# asdf
. $HOME/.asdf/asdf.sh

# python
PATH="$HOME/.local/bin:$PATH"
export PYTHONPATH
export PIP_DISABLE_PIP_VERSION_CHECK=1

# cue
PATH="$HOME/bin:$PATH"

# linkerd
PATH="$HOME/.linkerd2/bin:$PATH"

# terraform
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# awscli
export PATH="$PATH:/usr/local/aws-cli/bin"

# earthly
export EARTHLY_BUILDKIT_HOST="${EARTHLY_BUILDKIT_HOST:-tcp://$(uname -n):8372}"
export DOCKER_BUILDKIT="${DOCKER_BUILDKIT:-1}"
if [[ -z "${DOCKER_HOST:-}" ]]; then
	if test -S /var/run/docker.sock; then
		:
	else
		# export DOCKER_HOST="tcp://localhost:2375"
		true
	fi
fi

export PATH="$PATH:/usr/local/gcloud/google-cloud-sdk/bin"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# hof
export HOF_TELEMETRY_DISABLED=1

# fake xdisply
export DISPLAY=1

# kubectl
export KUBECONFIG_ALL="$HOME/.kube/config:$HOME/.kube/vc0.conf:$HOME/.kube/config:$HOME/.kube/vc1.conf:$HOME/.kube/vc2.conf:$HOME/.kube/vc3.conf:$HOME/.kube/vc4.conf:$HOME/.kube/vc5.conf:$HOME/.kube/config"

# vscode
if [[ -n "${VSCODE_GIT_IPC_HANDLE:-}" ]]; then
	#export VISUAL="code --wait"

	if [[ ! -S "${SSH_AUTH_SOCK:-}" ]]; then
		export SSH_AUTH_SOCK="$(ls -td /tmp/vscode-ssh-auth-sock-* 2>/dev/null | head -1)"
	fi
fi

# aws-vault
export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault

if tty >/dev/null; then
  if type -P powerline >/dev/null; then
	function render_ps1 {
		echo
		powerline --colorize-hostname -mode flat -newline \
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

if [[ -f ~/app/.bashrc ]]; then source ~/app/.bashrc; fi

if [[ -n "${VSCODE_GIT_IPC_HANDLE:-}" ]]; then
	if ! [[ -f ~/.home.done ]]; then
		if flock -n ~/.home.lock -c 'cd && ~/bin/e make install'; then
			touch ~/.home.done
		fi
	fi
fi
