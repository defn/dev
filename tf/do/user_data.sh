#!/usr/bin/env bash

function main {
    set -exfu

    cd /
    install -o ubuntu -g ubuntu ~/.ssh/authorized_keys ~ubuntu/.ssh/

    cd ~ubuntu
    sudo -u ubuntu -H git fetch
    sudo -u ubuntu -H git reset --hard origin/main
    sudo -u ubuntu -H bin/e env DEFN_DEV_HOST=${host}.${domain} DEFN_DEV_HOST_API=${host}.${domain} DEFN_DEV_ARCHIVE=${archive} make provision-digital-ocean
}

main "$@"
