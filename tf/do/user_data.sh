#!/usr/bin/env bash

function main {
    set -exfu

    cd /
    echo "${archive}" | base64 -d | tar xvfz -)

    install -o ubuntu -g ubuntu ~/.ssh/authorized_keys ~ubuntu/.ssh/ 

    cd ~ubuntu
    sudo -u ubuntu -H git fetch
    sudo -u ubuntu -H git reset --hard origin/main
    sudo -u ubuntu -H env DEFN_DEV_HOST=${host} DEFN_DEV_IP=${ip} make provision-digital-ocean
}

main "$@"