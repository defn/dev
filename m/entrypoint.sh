#!/usr/bin/env bash

set -efu -o pipefail

function main {
    cd
    source ~/.bash_profile

    sudo install -d -m 0700 -o ubuntu -g ubuntu dotfiles .local/share/code-server/extensions
    
    cd ~/m

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

    case "${1:-}" in
      setup)
          m start || true
          m activate || true
          m restart coder || true
          m restart code-server || true
          ;;
      *)
          exec /bin/s6-svscan /home/ubuntu/m/svc
    esac
}

main "$@"
