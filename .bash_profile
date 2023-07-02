BASE_PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/homebrew/bin:/nix/var/nix/profiles/default/bin"

PATH="${BASE_PATH}:${HOME}/bin/blackhole"

if [[ -r /etc/profile.d/bash_completion.sh ]]; then
    source /etc/profile.d/bash_completion.sh
elif [[ -r /usr/local/etc/profile.d/bash_completion.sh ]]; then
    source /usr/local/etc/profile.d/bash_completion.sh;
elif [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
    source /opt/homebrew/etc/profile.d/bash_completion.sh
fi

PATH="${BASE_PATH}"

source ~/.bashrc