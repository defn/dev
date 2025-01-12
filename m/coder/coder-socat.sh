#!/usr/bin/env bash
# sudo cp coder-socat.service /etc/systemd/system/coder-socat.service
# sudo systemctl daemon-reload
# sudo systemctl enable coder-socat.service
# sudo systemctl start coder-socat.service

cd
source .bash_profile
exec socat TCP-LISTEN:3000,bind=169.254.32.1,fork TCP:127.0.0.1:3000
