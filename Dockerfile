# syntax=docker/dockerfile:1

# nix
FROM ubuntu:22.04 AS nix

ARG arch

USER root
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV container=docker

# packages
RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        apt-transport-https software-properties-common curl git make xz-utils wget \
        tzdata locales \
        sudo tini \
    && apt purge -y nano
    # oathtool libusb-1.0-0 libolm-dev

# tailscale
ARG TAILSCALE
RUN echo ${TAILSCALE} \
    && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null \
    && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list \
    && apt-get update \
    && apt-get install -y tailscale

# ubuntu
RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu \
    && echo '%ubuntu ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu \
    && install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu

# kuma
RUN groupadd -g 1001 kuma && useradd -u 1001 -d /home/kuma -s /bin/bash -g kuma -M kuma \
    && install -d -m 0700 -o kuma -g kuma /home/kuma

# utc, utf-8
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && locale-gen en_US.UTF-8 \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# misc
RUN rm -f /usr/bin/gs \
    && ln -nfs /usr/bin/git-crypt /usr/local/bin/ \
    && mkdir /run/sshd \
    && install -d -m 0755 -o root -g root /run/user \
    && install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 \
    && install -d -m 0700 -o kuma -g kuma /run/user/1001 \
    && chmod u+s /usr/bin/sudo

USER ubuntu
WORKDIR /home/ubuntu
ENV HOME=/home/ubuntu

# nix
RUN curl -L https://nixos.org/nix/install > nix-install.sh && sh nix-install.sh --no-daemon --no-modify-profile && rm -f nix-install.sh && chmod 0755 /nix && sudo rm -f /bin/man

FROM nix as dev

ARG arch

# code-server
#COPY --chown=ubuntu:ubuntu --symlink-no-follow --dir (+coderServer/* --arch=${arch}) ./

# coredns
#COPY --chown=ubuntu:ubuntu (+coredns/* --arch=${arch}) /usr/local/bin/

# kuma
#COPY --chown=ubuntu:ubuntu (+kuma/* --arch=${arch}) /usr/local/bin/

# caddy
#COPY --chown=ubuntu:ubuntu (+caddy/* --arch=${arch}) /usr/local/bin/

# cloudflared
#COPY --chown=ubuntu:ubuntu (+cloudflared/* --arch=${arch}) /usr/local/bin/

# weird configs
RUN mkdir -p .kube .docker

COPY --chown=ubuntu:ubuntu etc/config.json .docker/config.json

# defn/dev
COPY --chown=ubuntu:ubuntu . .
RUN (git clean -nfd || true) \
    && (set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd)

ENTRYPOINT ["/usr/bin/tini", "--"]

# code server
FROM nix as codeServer

ARG arch
ARG CODESERVER

RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --method standalone --prefix=/home/ubuntu/.local --version=${CODESERVER}
RUN mkdir -p .config/code-server && touch .config/code-server/config.yaml

# caddy
FROM nix as caddy

ARG arch
ARG CADDY

RUN curl -sSL https://github.com/caddyserver/caddy/releases/download/v${CADDY}/caddy_${CADDY}_linux_${arch}.tar.gz | tar xvfz -

# coredns
FROM nix as coredns

ARG arch
ARG COREDNS

RUN curl -sSL https://github.com/coredns/coredns/releases/download/v${COREDNS}/coredns_${COREDNS}_linux_${arch}.tgz | tar xvfz -

# kuma
FROM nix as kuma

ARG arch
ARG KUMA

RUN mkdir meh && cd meh && curl -sSL https://download.konghq.com/mesh-alpine/kuma-${KUMA}-ubuntu-${arch}.tar.gz | tar xvfz -

# tailscale
FROM nix as tailscale

ARG arch
ARG TAILSCALE

RUN wget -O- https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE}_${arch}.tgz | tar xvfz -

# k3d
FROM rancher/k3s:v1.23.13-k3s1 as k3d

ARG arch

RUN echo root:x:0:0:root:/root:/bin/sh >> /etc/passwd
RUN echo root:x:0: >> /etc/group
RUN install -d -m 0700 -o root -g root /root

RUN mv /bin/k3s /bin/k3s-real

RUN for a in /bin/kubectl /bin/k3s-server /bin/k3s-secrets-encrypt /bin/k3s-etcd-snapshot /bin/k3s-completion /bin/k3s-certificate /bin/k3s-agent /bin/crictl /bin/ctr; do ln -nfs k3s-real $a; done

RUN mkdir -p /var/lib/rancher/k3s/agent/etc/containerd
COPY etc/k3d-config.toml var/lib/rancher/k3s/agent/etc/containerd/config.toml

COPY etc/k3s-wrapper.sh /bin/k3s

COPY --from=tailscale /tailscale* /
