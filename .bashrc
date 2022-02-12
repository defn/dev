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

# vscode
if [[ -n "${VSCODE_GIT_IPC_HANDLE=:-}" ]]; then
	export VISUAL="code --wait"
fi