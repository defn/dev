IN_NIX_SHELL=

PATH="${PATH}:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

if [[ -r /etc/profile.d/bash_completion.sh ]]; then
    source /etc/profile.d/bash_completion.sh
elif [[ -r /usr/local/etc/profile.d/bash_completion.sh ]]; then
    source /usr/local/etc/profile.d/bash_completion.sh;
elif [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]]; then
    source /opt/homebrew/etc/profile.d/bash_completion.sh
fi

source ~/.bashrc
