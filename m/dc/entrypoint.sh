#!/usr/bin/env bash

sudo chown -R ubuntu:ubuntu ~/.config/coderv2 ~/.local/share/code-server/extensions ~/.config ~/.local
sudo chgrp docker /var/run/docker.sock

ln -nfs ../svc.d/tailscaled ~/m/svc/

exec /bin/s6-svscan /home/ubuntu/m/svc
