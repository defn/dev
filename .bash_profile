#!/usr/bin/env bash

export PROMPT_COMMAND="${PROMPT_COMMAND:-}"

. ~/.bashrc_path
BASE_PATH="${PATH}"
export PATH="${BASE_PATH}:${HOME}/bin/blackhole"

if [[ -r /etc/profile.d/bash_completion.sh ]]; then
	source /etc/profile.d/bash_completion.sh
elif [[ -r /usr/local/etc/profile.d/bash_completion.sh ]]; then
	source /usr/local/etc/profile.d/bash_completion.sh
elif [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
	source /opt/homebrew/etc/profile.d/bash_completion.sh
fi

. ~/.bashrc_path
source ~/.bashrc

if [[ -x /usr/local/bin/brew ]]; then
  PATH="$(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin:${PATH}"
fi
if [[ -x /opt/homebrew/bin/brew ]]; then
  PATH="$(/opt/homebrew/bin/brew --prefix coreutils)/libexec/gnubin:${PATH}"
fi

if [[ -f ~/dotfiles/dot/bashrc ]]; then source ~/dotfiles/dot/bashrc; fi

