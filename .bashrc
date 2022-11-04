export USER=ubuntu
export LOCAL_ARCHIVE=/usr/lib/locale/locale-archive
export LC_ALL=C.UTF-8

if [[ -z "${IN_NIX_SHELL:-}" ]]; then
	if [ -e /home/ubuntu/.nix-profile/etc/profile.d/nix.sh ]; then
		. /home/ubuntu/.nix-profile/etc/profile.d/nix.sh
	fi
fi

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
if [[ -z "${IN_NIX_SHELL:-}" ]]; then . $HOME/.asdf/asdf.sh; fi

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
export EARTHLY_BUILDKIT_HOST="${EARTHLY_BUILDKIT_HOST:-tcp://$(uname -n):8372}"
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
if [[ -n "${VSCODE_GIT_IPC_HANDLE:-}" ]]; then
	export BROWSER="$(set +f; ls -d /home/ubuntu/.local/lib/code-server-*/lib/vscode/bin/helpers/browser.sh)"
	#export VISUAL="code --wait"

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
			-modules host,ssh,cwd,perms,gitlite,load,exit,venv,kube,nix-shell
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

	if [[ -n "${VSCODE_PROXY_URI:-}" ]]; then
		if [[ -f .todo ]]; then
			if [[ "./.todo" == "$(find . -mindepth 1 -maxdepth 1)" ]]; then
				rm -f .todo
				git clone "https://$(echo $VSCODE_PROXY_URI | cut -d/ -f5- | perl -pe 's{/proxy/..port..}{}')" .
			fi
		fi
	fi
fi

PATH="/bin:$PATH"