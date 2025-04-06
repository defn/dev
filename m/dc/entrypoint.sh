#!/usr/bin/env bash

sudo chown ubuntu:ubuntu ~/.config/coderv2

exec /bin/s6-svscan /home/ubuntu/m/svc
