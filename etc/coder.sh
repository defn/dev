#!/usr/bin/env bash
# /etc/systemd/system/coder.service
# sudo systemctl daemon-reload
# sudo systemctl enable coder.service
# sudo systemctl start coder.service

cd
source .bash_profile
exec make chrome-dev-coder name=${CODER_SERVER}
