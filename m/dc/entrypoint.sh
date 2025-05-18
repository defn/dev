#!/usr/bin/env bash

sudo chown -R ubuntu:ubuntu ~/.config/coderv2 ~/.local/share/code-server/extensions ~/.config ~/.local
sudo chgrp docker /var/run/docker.sock

ln -nfs ../svc.d/tailscaled ~/m/svc/

(
	while true; do
		if tailscale ip; then
			break
		fi
		if sudo tailscale up --ssh; then
			break
		fi
		sleep 1
	done
) &

exec /bin/s6-svscan /home/ubuntu/m/svc
