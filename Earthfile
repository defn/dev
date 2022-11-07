VERSION --shell-out-anywhere --use-chmod --use-host-command --earthly-version-arg --use-copy-link --use-registry-for-with-docker 0.6

build-dev:
    ARG image
    BUILD +build-amd-dev --image=${image}
    BUILD +build-arm-dev --image=${image}

build-amd-dev:
    ARG image
    FROM --platform=linux/amd64 +dev --arch=amd64
    IF [ "$image" != "" ]
        SAVE IMAGE --push ${image}
    END

build-arm-dev:
    ARG image
    FROM --platform=linux/arm64 +dev --arch=arm64
    IF [ "$image" != "" ]
        SAVE IMAGE --push ${image}
    END

build-k3d:
    ARG image
    BUILD +build-amd-k3d --image=${image}
    BUILD +build-arm-k3d --image=${image}

build-amd-k3d:
    ARG image
    FROM --platform=linux/amd64 +k3d --arch=amd64
    IF [ "$image" != "" ]
        SAVE IMAGE --push ${image}
    END

build-arm-k3d:
    ARG image
    FROM --platform=linux/arm64 +k3d --arch=arm64
    IF [ "$image" != "" ]
        SAVE IMAGE --push ${image}
    END

build-caddy:
    ARG image
    BUILD --platform=linux/amd64 +nix-single --image=${image} --arch=amd64 --dir=caddy
    BUILD --platform=linux/arm64 +nix-single --image=${image} --arch=arm64 --dir=caddy

dev:
    ARG arch

    FROM +nix --arch=${arch}

    ENTRYPOINT ["/usr/bin/tini", "--"]

    # code-server
    COPY --chown=ubuntu:ubuntu --symlink-no-follow --dir (+coder-server/* --arch=${arch}) ./

    # coredns
    COPY --chown=ubuntu:ubuntu (+coredns/* --arch=${arch}) /usr/local/bin/

    # caddy
    COPY --chown=ubuntu:ubuntu (+caddy/* --arch=${arch}) /usr/local/bin/

    # cloudflared
    COPY --chown=ubuntu:ubuntu (+cloudflared/* --arch=${arch}) /usr/local/bin/

    # weird configs
    RUN mkdir -p .kube .docker

    COPY --chown=ubuntu:ubuntu etc/config.json .docker/config.json

    # defn/dev
    COPY --dir --chown=ubuntu:ubuntu . .
    RUN (git clean -nfd || true) \
        && (set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd)

cloudflared:
    ARG arch
    ARG CLOUDFLARED
    FROM +root --arch=${arch}
    RUN curl -sSL https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED}/cloudflared-linux-${arch} > cloudflared && chmod 755 cloudflared
    SAVE ARTIFACT cloudflared

caddy:
    ARG arch
    ARG CADDY
    FROM +root --arch=${arch}
    RUN curl -sSL https://github.com/caddyserver/caddy/releases/download/v${CADDY}/caddy_${CADDY}_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT caddy

coredns:
    ARG arch
    ARG COREDNS
    FROM +root --arch=${arch}
    RUN curl -sSL https://github.com/coredns/coredns/releases/download/v${COREDNS}/coredns_${COREDNS}_linux_${arch}.tgz | tar xvfz -
    SAVE ARTIFACT coredns

coder-server:
    ARG arch
    ARG CODESERVER
    ARG CODESERVER_BUMP

    FROM +root --arch=${arch}

    RUN echo ${CODESERVER_BUMP}
    RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --method standalone --prefix=/home/ubuntu/.local --version=${CODESERVER}
    RUN mkdir -p .config/code-server && touch .config/code-server/config.yaml
    SAVE ARTIFACT .local

k3d:
    ARG K3S

    ARG arch

    FROM rancher/k3s:v${K3S}

    RUN echo root:x:0:0:root:/root:/bin/sh >> /etc/passwd
    RUN echo root:x:0: >> /etc/group
    RUN install -d -m 0700 -o root -g root /root

    RUN mv /bin/k3s /bin/k3s-real

    RUN for a in /bin/kubectl /bin/k3s-server /bin/k3s-secrets-encrypt /bin/k3s-etcd-snapshot /bin/k3s-completion /bin/k3s-certificate /bin/k3s-agent /bin/crictl /bin/ctr; do ln -nfs k3s-real $a; done

    RUN mkdir -p /var/lib/rancher/k3s/agent/etc/containerd
    COPY etc/k3d-config.toml var/lib/rancher/k3s/agent/etc/containerd/config.toml

    COPY etc/k3s-wrapper.sh /bin/k3s

    COPY (+root/tailscale --arch=${arch}) /
    COPY (+root/tailscaled --arch=${arch}) /

ubuntu:
    ARG arch
    ARG UBUNTU

    FROM ${UBUNTU}

    SAVE IMAGE --cache-hint

root:
    ARG arch
    ARG TAILSCALE
    ARG DOCKER
    ARG BUMP

    FROM +ubuntu --arch=${arch}

    USER root
    ENTRYPOINT ["tail", "-f", "/dev/null"]

    ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    ENV LANG en_US.UTF-8
    ENV LANGUAGE en_US:en
    ENV LC_ALL en_US.UTF-8

    ENV DEBIAN_FRONTEND=noninteractive
    ENV container=docker

    RUN echo ${BUMP}

    # oathtool libusb-1.0-0 libolm-dev
    RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm \
        && apt-get update \
        && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends \
            apt-transport-https software-properties-common curl git make xz-utils wget \
            tzdata locales iproute2 net-tools \
            sudo tini \
        && apt purge -y nano

    RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu \
        && echo '%ubuntu ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu \
        && install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu

    RUN groupadd -g 1001 kuma && useradd -u 1001 -d /home/kuma -s /bin/bash -g kuma -M kuma \
        && install -d -m 0700 -o kuma -g kuma /home/kuma

    RUN apt update && apt upgrade -y
    RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
        && dpkg-reconfigure -f noninteractive tzdata \
        && locale-gen en_US.UTF-8 \
        && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

    RUN rm -f /usr/bin/gs \
        && ln -nfs /usr/bin/git-crypt /usr/local/bin/ \
        && mkdir /run/sshd \
        && install -d -m 0755 -o root -g root /run/user \
        && install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 \
        && install -d -m 0700 -o kuma -g kuma /run/user/1001

    RUN chown -R ubuntu:ubuntu /home/ubuntu \
        && chmod u+s /usr/bin/sudo

    RUN echo ${TAILSCALE} \
        && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null \
        && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list \
        && apt-get update \
        && apt install -y tailscale

    USER ubuntu
    WORKDIR /home/ubuntu

    ENV HOME=/home/ubuntu

    SAVE ARTIFACT /bin/tailscale
    SAVE ARTIFACT /usr/sbin/tailscaled

nix:
    ARG arch

    FROM +root --arch=${arch}

    # nix
    RUN curl -L https://nixos.org/nix/install > nix-install.sh && sh nix-install.sh --no-daemon --no-modify-profile && rm -f nix-install.sh && chmod 0755 /nix && sudo rm -f /bin/man

nix-single
    ARG image
    ARG arch
    ARG dir

    FROM +nix --arch=${arch}

    RUN . .nix-profile/etc/profile.d/nix.sh && nix --extra-experimental-features nix-command --extra-experimental-features flakes \
        profile install github:defn/pkg?dir=${dir}

    IF [ "$image" != "" ]
        SAVE IMAGE --push ${image}
    END
