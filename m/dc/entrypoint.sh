#!/usr/bin/env bash

sudo chown ubuntu:ubuntu ~/.config/coderv2

(
	sleep 5
	sudo tailscale up --ssh --hostname "$(hostname | cut -d . -f1)-dev"
	tailscale ip
) &

exec /bin/s6-svscan /home/ubuntu/m/svc
