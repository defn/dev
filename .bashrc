function gs {
	git status -sb "$@"
}

function vi {
	if [[ -n "${VSCODE_GIT_IPC_HANDLE=:-}" ]]; then
		command code "$@"
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

export PIP_DISABLE_PIP_VERSION_CHECK=1
# cue
PATH="$HOME/bin:$PATH"

# linkerd
PATH="$HOME/.linkerd2/bin:$PATH"

# terraform
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# awscli
export PATH="$PATH:/usr/local/aws-cli/bin"

# gcloud
export PATH="$PATH:/usr/local/gcloud/google-cloud-sdk/bin"

# kubectl
export KUBECONFIG_ALL="$HOME/.kube/config:$HOME/.kube/vc1.conf:$HOME/.kube/vc2.conf:$HOME/.kube/vc3.conf:$HOME/.kube/vc4.conf:$HOME/.kube/vc5.conf:$HOME/.kube/config"

# vscode
if [[ -n "${VSCODE_GIT_IPC_HANDLE=:-}" ]]; then
	export VISUAL="code --wait"

	if [[ ! -S "${SSH_AUTH_SOCK:-}" ]]; then
		export SSH_AUTH_SOCK="$(ls -td /tmp/vscode-ssh-auth-sock-* 2>/dev/null | head -1)"
	fi
fi

# docker
if [[ ! -S /var/run/docker.sock ]]; then
	if [[ -z "${DOCKER_HOST:-}" ]]; then
		export DOCKER_HOST="unix://$HOME/.local/docker.sock"
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
			-priority root,cwd,user,host,ssh,perms,git-branch,exit,cwd-path,git-status \
			-modules host,ssh,cwd,perms,gitlite,load,exit,venv
	}

	function update_ps1 {
		ls -td /tmp/vscode-ssh-auth-sock* 2>/dev/null | tail -n +2 | xargs rm -f /tmp/meh;
		if [[ ! -S "${SSH_AUTH_SOCK:-}" ]]; then
			export SSH_AUTH_SOCK="$(ls -td /tmp/vscode-ssh-auth-sock-* 2>/dev/null | head -1)"
		fi
		touch ~/.alive
		PS1="$(render_ps1)"
	}

    PROMPT_COMMAND="update_ps1"
  fi
fi
