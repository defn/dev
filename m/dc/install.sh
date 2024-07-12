#!/use/bin/env bash

function main {
    cd

    git clone https://github.com/defn/dev .
    mv dev/.git .
    rm -rf dev
    git reset --hard

    mv /tmp/.env .
    direnv allow

    sudo chown ubuntu:ubuntu /nix
    make nix

    echo "build --remote_cache=grpc://100.116.216.28:9092" > m/.bazelrc.user
    make install
}

main "$@"