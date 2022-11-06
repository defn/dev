VERSION --shell-out-anywhere --use-chmod --use-host-command --earthly-version-arg --use-copy-link --use-registry-for-with-docker 0.6

IMPORT github.com/defn/cloud/lib:master AS lib

build-amd:
    FROM --platform=linux/amd64 +user --arch=amd64

build-arm:
    FROM --platform=linux/arm64 +user --arch=arm64

build-amd-k3d-base:
    FROM --platform=linux/amd64 +k3d-base --arch=amd64

build-arm-k3d-base:
    FROM --platform=linux/arm64 +k3d-base --arch=arm64

images:
    ARG repo
    ARG tag

    BUILD +image-amd --repo=${repo} --tag=${tag}
    BUILD +image-arm --repo=${repo} --tag=${tag}

imagesK3DBase:
    ARG repo
    ARG tag

    BUILD +image-amd-k3d-base --repo=${repo} --tag=${tag}-k3d-base
    BUILD +image-arm-k3d-base --repo=${repo} --tag=${tag}-k3d-base

image-amd:
    ARG repo
    ARG tag

    FROM --platform=linux/amd64 +user --arch=amd64

    SAVE IMAGE --push ${repo}defn/dev:${tag}

image-arm:
    ARG repo
    ARG tag

    FROM --platform=linux/arm64 +user --arch=arm64

    SAVE IMAGE --push ${repo}defn/dev:${tag}

image-amd-k3d-base:
    ARG repo
    ARG tag

    FROM --platform=linux/amd64 +k3d-base --arch=amd64

    SAVE IMAGE --push ${repo}defn/dev:${tag}

image-arm-k3d-base:
    ARG repo
    ARG tag

    FROM --platform=linux/arm64 +k3d-base --arch=arm64

    SAVE IMAGE --push ${repo}defn/dev:${tag}

user:
    ARG arch

    FROM +root --arch=${arch}

    ENTRYPOINT ["/usr/bin/tini", "--"]

    # nix
    RUN curl -L https://nixos.org/nix/install > nix-install.sh && sh nix-install.sh --no-daemon --no-modify-profile && rm -f nix-install.sh && find /nix

    # code-server
    COPY --chown=ubuntu:ubuntu --symlink-no-follow --dir (+coderServer/* --arch=${arch}) ./

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
            apt-transport-https software-properties-common curl git make xz-utils \
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

coderServer:
    ARG arch
    ARG CODESERVER
    ARG CODESERVER_BUMP

    FROM +root --arch=${arch}

    RUN echo ${CODESERVER_BUMP}
    RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --method standalone --prefix=/home/ubuntu/.local --version=${CODESERVER}
    RUN mkdir -p .config/code-server && touch .config/code-server/config.yaml
    SAVE ARTIFACT .local

vscodeServer:
    ARG arch
    ARG CODESERVER

    FROM +root --arch=${arch}

    # vscode-server
    RUN echo ${CODESERVER}
    RUN wget -O- https://aka.ms/install-vscode-server/setup.sh | sudo sh -x
    SAVE ARTIFACT /usr/local/bin/code-server

tools:
    ARG arch

    FROM +ubuntu --arch=${arch}

    ENV DEBIAN_FRONTEND=noninteractive
    ENV container=docker

    RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
            apt-transport-https software-properties-common tzdata locales git unzip xz-utils wget curl

    SAVE IMAGE --cache-hint

asdf:
    ARG arch
    ARG ASDF

    FROM +tools --arch=${arch}

    RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu
    RUN install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu
    USER ubuntu
    WORKDIR /home/ubuntu
    RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${ASDF}
    RUN bash -c 'source ~/.asdf/asdf.sh && asdf reshim'

    SAVE ARTIFACT .asdf
    SAVE IMAGE --cache-hint

jless:
    ARG arch
    ARG arch2
    ARG JLESS
    FROM +tools --arch=${arch}
    RUN --secret JLESS (curl -sSL https://github.com/PaulJuliusMartinez/jless/releases/download/v${JLESS}/jless-v${JLESS}-x86_64-unknown-linux-gnu.zip | gunzip -c - > jless) && chmod 755 jless
    SAVE ARTIFACT jless

oras:
    ARG arch
    ARG ORAS
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/oras-project/oras/releases/download/v${ORAS}/oras_${ORAS}_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT oras

cloudflared:
    ARG arch
    ARG CLOUDFLARED
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED}/cloudflared-linux-${arch} > cloudflared && chmod 755 cloudflared
    SAVE ARTIFACT cloudflared

caddy:
    ARG arch
    ARG CADDY
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/caddyserver/caddy/releases/download/v${CADDY}/caddy_${CADDY}_linux_${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT cloudflared

coredns:
    ARG arch
    ARG COREDNS
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/coredns/coredns/releases/download/v${COREDNS}/coredns_${COREDNS}_linux_${arch}.tgz | tar xvfz -
    SAVE ARTIFACT coredns

nerdctl:
    ARG arch
    ARG NERDCTL
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/containerd/nerdctl/releases/download/v${NERDCTL}/nerdctl-${NERDCTL}-linux-${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT nerdctl

difft:
    ARG arch
    ARG arch2
    ARG DIFFT
    FROM +tools --arch=${arch}
    RUN --secret DIFFT curl -sSL https://github.com/Wilfred/difftastic/releases/download/${DIFFT}/difft-x86_64-unknown-linux-gnu.tar.gz | tar xvfz -
    SAVE ARTIFACT difft

credentialPass:
    ARG arch
    ARG CREDENTIALPASS
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/docker/docker-credential-helpers/releases/download/v${CREDENTIALPASS}/docker-credential-pass-v${CREDENTIALPASS}.linux-${arch} > docker-credential-pass && chmod 755 docker-credential-pass
    SAVE ARTIFACT docker-credential-pass

tctl:
    ARG arch
    ARG TEMPORAL
    FROM --platform=${arch} temporalio/admin-tools:${TEMPORAL}
    SAVE ARTIFACT /usr/local/bin/tctl

cilium:
    ARG arch
    ARG CILIUM
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/cilium/cilium-cli/releases/download/v${CILIUM}/cilium-linux-${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT cilium

hubble:
    ARG arch
    ARG HUBBLE
    FROM +tools --arch=${arch}
    RUN curl -sSL https://github.com/cilium/hubble/releases/download/v${HUBBLE}/hubble-linux-${arch}.tar.gz | tar xzvf -
    SAVE ARTIFACT hubble

linkerd:
    ARG arch
    ARG LINKERD
    FROM +tools --arch=${arch}
    RUN curl -sSL -o linkerd https://github.com/linkerd/linkerd2/releases/download/${LINKERD}/linkerd2-cli-${LINKERD}-linux-${arch} && chmod 755 linkerd
    SAVE ARTIFACT linkerd

loft:
    ARG arch
    ARG LOFT
    FROM +tools --arch=${arch}
    RUN curl -sSL -o loft https://github.com/loft-sh/loft/releases/download/v${OFT}/loft-linux-${arch} && chmod 755 loft
    SAVE ARTIFACT loft

bk:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret BKCLI curl -sSL -o bk https://github.com/buildkite/cli/releases/download/v${BKCLI}/cli-linux-${arch} && chmod 755 bk
    SAVE ARTIFACT bk

litestream:
    ARG arch
    FROM +tools --arch=${arch}
    RUN --secret LITESTREAM curl -sSL https://github.com/benbjohnson/litestream/releases/download/v${LITESTREAM}/litestream-v${LITESTREAM}-linux-${arch}.tar.gz | tar xvfz -
    SAVE ARTIFACT litestream

fulcio:
    ARG arch
    ARG FULCIO
    FROM +tools --arch=${arch}
    RUN curl -sSL -o fulcio https://github.com/sigstore/fulcio/releases/download/v${FULCIO}/fulcio-linux-${arch} && chmod 755 fulcio
    SAVE ARTIFACT fulcio

rekor:
    ARG arch
    ARG REKOR
    FROM +tools --arch=${arch}
    RUN curl -sSL -o rekor https://github.com/sigstore/rekor/releases/download/v${REKOR}/rekor-cli-linux-${arch} && chmod 755 rekor
    SAVE ARTIFACT rekor

cosign:
    ARG arch
    ARG COSIGN
    FROM +tools --arch=${arch}
    RUN curl -sSL -o cosign https://github.com/sigstore/cosign/releases/download/v${COSIGN}/cosign-linux-${arch} && chmod 755 cosign
    SAVE ARTIFACT cosign

shell-operator:
    FROM flant/shell-operator:latest
    WORKDIR /
    RUN tar cvfz sf.tar.gz shell* frameworks
    SAVE ARTIFACT sf.tar.gz

rerun-process-wrapper:
    FROM alpine/git
    RUN git clone https://github.com/tilt-dev/rerun-process-wrapper
    SAVE ARTIFACT rerun-process-wrapper/*.sh

cue-gen:
    ARG arch
    FROM +golang --arch=${arch}
    RUN bash -c 'source ~/.asdf/asdf.sh && go install istio.io/tools/cmd/cue-gen@latest'
    SAVE ARTIFACT ./.asdf/installs/golang/*/packages/bin/cue-gen

tailscale-binaries:
    ARG TAILSCALE

    ARG arch

    FROM +tools --arch=${arch}

	RUN wget -O- https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE}_${arch}.tgz | tar xvfz -

    SAVE ARTIFACT */tailscale
    SAVE ARTIFACT */tailscaled

k3d-base:
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

    COPY (+tailscale-binaries/* --arch=${arch}) /
