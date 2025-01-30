#!/usr/bin/env bash
# sudo cp coder-sync.service /etc/systemd/system/coder-sync.service
# sudo systemctl daemon-reload
# sudo systemctl enable coder-sync.service
# sudo systemctl start coder-sync.service

cd
source .bash_profile
while true; do
    (cd ~/m/i && make sync)
    (cd ~/m/cache/docker && make clean)
    sleep 30
done

