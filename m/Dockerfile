FROM ubuntu:24.04

ARG GITHUB_TOKEN

ENV DEBIAN_FRONTEND=noninteractive

# sync with install.sh
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y \
    make direnv curl xz-utils dirmngr gpg rsync build-essential sudo ca-certificates tzdata locales git tini iproute2 iptables bc pv socat

RUN locale-gen C.UTF-8 && update-locale LANG=C.UTF-8

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN if [ "$(id -u ubuntu)" != 1000 ]; then groupadd -r --gid 1000 ubuntu && useradd -m -s /bin/bash -g ubuntu --uid 1000 ubuntu; fi

USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /home/ubuntu

RUN git clone https://github.com/defn/dev dev && \
    mv dev/.git . && \
    git reset --hard && \
    rm -rf dev
RUN	bash -c "source .bash_profile && make nix sync"
