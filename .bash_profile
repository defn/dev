IN_NIX_SHELL=

PATH="$(echo $PATH | tr ':' "\n" | grep -v /nix/store | xargs | sed 's# #:#')"


PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

source ~/.bashrc