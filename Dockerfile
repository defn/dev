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
    make docker.io \
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

RUN curl -sSL -o docker-pass.tar.gz https://github.com/docker/docker-credential-helpers/releases/download/v0.6.4/docker-credential-pass-v0.6.4-amd64.tar.gz \
        && tar xvfz docker-pass.tar.gz && rm -f docker-pass.tar.gz && chmod 755 docker-credential-pass && mv docker-credential-pass /usr/local/bin/

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

RUN ssh -o StrictHostKeyChecking=no git@github.com true || true

COPY --chown=ubuntu:ubuntu .tool-versions .
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add cue'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add shellcheck'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf install'

RUN pip install --user pipx
RUN /home/ubuntu/.local/bin/pipx install pre-commit

COPY --chown=ubuntu:ubuntu .git .git
COPY --chown=ubuntu:ubuntu .pre-commit-config.yaml .
RUN /home/ubuntu/.local/bin/pre-commit install

COPY --chown=ubuntu:ubuntu .vim .vim
COPY --chown=ubuntu:ubuntu .vimrc .
RUN echo yes | vim +PlugInstall +qall

COPY --chown=ubuntu:ubuntu . .
RUN chmod 0700 .gnupg
RUN git remote rm origin && git remote add origin https://github.com/defn/dev && git fetch && git branch -u origin/main

RUN mkdir -p ~/.docker && echo '{"credsStore": "pass"}' > ~/.docker/config.json

USER root