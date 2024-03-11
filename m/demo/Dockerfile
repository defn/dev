FROM ubuntu:22.04

RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y vim-nox direnv curl

RUN groupadd -r ubuntu && useradd -m -s /bin/bash -g ubuntu ubuntu

USER ubuntu

