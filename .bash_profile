#!/usr/bin/env bash

. ~/.bashrc_path
BASE_PATH="${PATH}"
PATH="${BASE_PATH}:${HOME}/bin/blackhole"

if [[ -r /etc/profile.d/bash_completion.sh ]]; then
	source /etc/profile.d/bash_completion.sh
elif [[ -r /usr/local/etc/profile.d/bash_completion.sh ]]; then
	source /usr/local/etc/profile.d/bash_completion.sh
elif [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
	source /opt/homebrew/etc/profile.d/bash_completion.sh
fi

. ~/.bashrc_path
source ~/.bashrc
if [[ -f ~/.dotfiles/dot/bashrc ]]; then source ~/.dotfiles/dot/bashrc; fi

eval "$(direnv hook bash)"
_direnv_hook
