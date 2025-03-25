#!/usr/bin/env bash

set -efu -o pipefail

function main {
    cd ~/m
    source ~/.bash_profile
    
    (
        for a in $(env | grep ^CODER_ | cut -d= -f1); do printf 'export %s=%q\n\n' "$a" "$(echo "${!a}")"; done
    ) > svc.d/coder/.env

    (
        for a in $(env | grep ^CODER_ | cut -d= -f1); do printf 'export %s=%q\n\n' "$a" "$(echo "${!a}")"; done
        for a in $(env | grep ^GIT_ | cut -d= -f1); do printf 'export %s=%q\n\n' "$a" "$(echo "${!a}")"; done
        for a in $(env | grep ^VSCODE_ | cut -d= -f1); do printf 'export %s=%q\n\n' "$a" "$(echo "${!a}")"; done
    ) > svc.d/code-server/.env

    ln -nfs ../svc.d/coder svc/
    ln -nfs ../svc.d/code-server svc/

    exec /bin/s6-svscan /home/ubuntu/m/svc
}

main "$@"