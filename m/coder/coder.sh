#!/usr/bin/env bash
# sudo cp coder.service /etc/systemd/system/coder.service
# sudo systemctl daemon-reload
# sudo systemctl enable coder.service
# sudo systemctl start coder.service

cd
source .bash_profile
source .envrc
exec make chrome-dev-coder name=${CODER_SERVER}
