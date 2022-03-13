FROM ubuntu:20.04

USER root

ARG DEBIAN_FRONTEND=noninteractive

ENV container docker

RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    wget apt-transport-https software-properties-common \
    openssh-client tzdata locales iputils-ping iproute2 net-tools dnsutils curl wget unzip jq xz-utils rsync \
    sudo git vim less \
    make docker.io tini \
    python3-pip python3-venv python-is-python3 \
    gpg pass pass-extension-otp git-crypt oathtool libusb-1.0-0

RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu
RUN echo '%ubuntu ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu
RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu

RUN curl -sSL -o docker-pass.tar.gz https://github.com/docker/docker-credential-helpers/releases/download/v0.6.4/docker-credential-pass-v0.6.4-amd64.tar.gz \
        && tar xvfz docker-pass.tar.gz && rm -f docker-pass.tar.gz && chmod 755 docker-credential-pass && mv docker-credential-pass /usr/local/bin/

RUN echo 20220213 && apt update && apt upgrade -y

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && locale-gen en_US.UTF-8 \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN rm -f /usr/bin/gs \
    && ln -nfs /usr/bin/git-crypt /usr/local/bin/

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
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add shellcheck'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add cue'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add kubectl'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add krew'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add k9s'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add kustomize'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add helm'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add k3d'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf install'

RUN sudo curl -sSL -o /usr/local/bin/hof https://github.com/hofstadter-io/hof/releases/download/v0.6.1/hof_0.6.1_Linux_x86_64 && sudo chmod 755 /usr/local/bin/hof
RUN sudo curl -sSL -o /usr/local/bin/powerline https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-amd64 && sudo chmod 755 /usr/local/bin/powerline

RUN pip install --user pipx
RUN /home/ubuntu/.local/bin/pipx install pre-commit

COPY --chown=ubuntu:ubuntu .vim .vim
COPY --chown=ubuntu:ubuntu .vimrc .
RUN echo yes | vim +PlugInstall +qall

COPY --chown=ubuntu:ubuntu .git .git
COPY --chown=ubuntu:ubuntu .pre-commit-config.yaml .
RUN /home/ubuntu/.local/bin/pre-commit install

COPY --chown=ubuntu:ubuntu . .
RUN git remote rm origin && git remote add origin https://github.com/defn/dev && git fetch && git branch -u origin/main

RUN mkdir -p ~/.docker && echo '{"credsStore": "pass"}' > ~/.docker/config.json

COPY etc/c /usr/local/bin/c

RUN cd && etc/env.sh pre-commit run --all

RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf plugin-add tilt'
RUN bash -c 'source $HOME/.asdf/asdf.sh && asdf install'
