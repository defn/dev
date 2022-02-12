FROM ubuntu:20.04

USER root

ARG DEBIAN_FRONTEND=noninteractive

ENV container docker

RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    wget apt-transport-https software-properties-common \
    openssh-server tzdata locales iputils-ping iproute2 net-tools dnsutils curl wget unzip jq xz-utils \
    sudo git vim less \
    python3-pip python3-venv python-is-python3 \
    gpg gpg-agent dirmngr scdaemon pass pass-extension-otp git-crypt oathtool libusb-1.0-0 \
    && rm -f /usr/bin/gs

RUN echo GatewayPorts clientspecified >> /etc/ssh/sshd_config
RUN echo StreamLocalBindUnlink yes >> /etc/ssh/sshd_config
RUN mkdir /run/sshd

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && locale-gen en_US.UTF-8 \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu
RUN echo '%ubuntu ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu
RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu

USER ubuntu
WORKDIR /home/ubuntu
ENV HOME=/home/ubuntu

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY --chown=ubuntu:ubuntu . .

RUN if ! test -d .git; then git clone https://github.com/defn/dev dev; mv dev/.git .; rm -rf dev; fi

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0
RUN etc/env.sh asdf plugin-add cue
RUN etc/env.sh asdf plugin-add shellcheck
RUN etc/env.sh asdf install

RUN pip install --user pipx
RUN etc/env.sh pipx install pre-commit
RUN etc/env.sh pre-commit install
RUN etc/env.sh pre-commit run --all

USER root