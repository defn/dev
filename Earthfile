VERSION --shell-out-anywhere --use-chmod --use-host-command --earthly-version-arg --use-copy-link --use-registry-for-with-docker 0.6

IMPORT github.com/defn/pkg

build-dev:
    ARG image
    BUILD --platform=linux/amd64 +dev --image=${image} --arch=amd64
    BUILD --platform=linux/arm64 +dev --image=${image} --arch=arm64

build-k3d:
    ARG image
    BUILD --platform=linux/amd64 +k3d --image=${image} --arch=amd64
    BUILD --platform=linux/arm64 +k3d --image=${image} --arch=arm64

build-caddy:
    ARG image
    BUILD --platform=linux/amd64 pkg+alpine-nix-dir --image=${image} --arch=amd64 --dir=caddy
    BUILD --platform=linux/arm64 pkg+alpine-nix-dir --image=${image} --arch=arm64 --dir=caddy

build-cloudflared:
    ARG image
    BUILD --platform=linux/amd64 pkg+alpine-nix-dir --image=${image} --arch=amd64 --dir=cloudflared
    BUILD --platform=linux/arm64 pkg+alpine-nix-dir --image=${image} --arch=arm64 --dir=cloudflared

build-coredns:
    ARG image
    BUILD --platform=linux/amd64 pkg+alpine-nix-dir --image=${image} --arch=amd64 --dir=coredns
    BUILD --platform=linux/arm64 pkg+alpine-nix-dir --image=${image} --arch=arm64 --dir=coredns

build-vault:
    ARG image
    BUILD --platform=linux/amd64 pkg+alpine-nix-pkg --image=${image} --arch=amd64 --pkg=vault
    BUILD --platform=linux/arm64 pkg+alpine-nix-pkg --image=${image} --arch=arm64 --pkg=vault

coder-server:
    ARG arch
    ARG CODESERVER
    ARG CODESERVER_BUMP

    FROM pkg+root --arch=${arch}

    RUN echo ${CODESERVER_BUMP}
    RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --method standalone --prefix=/home/ubuntu/.local --version=${CODESERVER}
    RUN mkdir -p .config/code-server && touch .config/code-server/config.yaml
    SAVE ARTIFACT .local

k3d:
    ARG K3S

    ARG image
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

    COPY (pkg+root/tailscale --arch=${arch}) /
    COPY (pkg+root/tailscaled --arch=${arch}) /

    IF [ "$image" != "" ]
        SAVE IMAGE --push ${image}
    END

dev:
    ARG image
    ARG arch

    FROM pkg+nix --arch=${arch}

    ENTRYPOINT ["/usr/bin/tini", "--"]

    # code-server
    COPY --chown=ubuntu:ubuntu --symlink-no-follow --dir (+coder-server/* --arch=${arch}) ./

    # coredns
    RUN . ~/.nix-profile/etc/profile.d/nix.sh \
            && ~/.nix-profile/bin/nix --extra-experimental-features nix-command --extra-experimental-features flakes \
                profile install github:defn/pkg?dir=coredns

    # caddy
    RUN . ~/.nix-profile/etc/profile.d/nix.sh \
            && ~/.nix-profile/bin/nix --extra-experimental-features nix-command --extra-experimental-features flakes \
                profile install github:defn/pkg?dir=caddy

    # cloudflared
    RUN . ~/.nix-profile/etc/profile.d/nix.sh \
            && ~/.nix-profile/bin/nix --extra-experimental-features nix-command --extra-experimental-features flakes \
                profile install github:defn/pkg?dir=cloudflared

    # vault
    RUN . ~/.nix-profile/etc/profile.d/nix.sh \
            && ~/.nix-profile/bin/nix --extra-experimental-features nix-command --extra-experimental-features flakes \
                profile install "nixpkgs#vault"

    # weird configs
    RUN mkdir -p .kube .docker

    COPY --chown=ubuntu:ubuntu etc/config.json .docker/config.json

    # defn/dev
    COPY --dir --chown=ubuntu:ubuntu . .
    RUN (git clean -nfd || true) \
        && (set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd)

    IF [ "$image" != "" ]
        SAVE IMAGE --push ${image}
    END
