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

function k {
	kubectl "$@"
}

function pc {
	pre-commit "$@"
}

function pca {
	pre-commit run --all "$@"
}

# asdf
. $HOME/.asdf/asdf.sh

# pipx
PATH="$HOME/.local/bin:$PATH"

# cue
PATH="$HOME/bin:$PATH"

# linkerd
PATH="$HOME/.linkerd2/bin:$PATH"

# vscode
if [[ -n "${VSCODE_GIT_IPC_HANDLE=:-}" ]]; then
	export VISUAL="code --wait"

	if [[ ! -S "${SSH_AUTH_SOCK:-}" ]]; then
		export SSH_AUTH_SOCK="$(ls -td /tmp/vscode-ssh-auth-sock-* 2>/dev/null | head -1)"
	fi
fi

# docker
if [[ -z "${DOCKER_HOST:-}" ]]; then
	export DOCKER_HOST=localhost:2375
fi

if tty >/dev/null; then
  if type -P powerline >/dev/null; then
	function render_ps1 {
		echo
		powerline --colorize-hostname -mode flat -newline \
			-priority root,cwd,user,host,ssh,perms,git-branch,exit,cwd-path,git-status \
			-modules host,ssh,cwd,perms,gitlite,load,exit,venv \
			-path-aliases /home/boot=\~,\~/work=work
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
