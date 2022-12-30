VERSION --shell-out-anywhere --use-chmod --use-host-command --earthly-version-arg --use-copy-link --use-registry-for-with-docker --ci-arg 0.6

IMPORT github.com/defn/pkg:0.0.118

build-nix-root:
    ARG image=ghcr.io/defn/dev:latest-nix-root
    BUILD --platform=linux/amd64 +image-nix-root --image=${image} --arch=amd64
    BUILD --platform=linux/arm64 +image-nix-root --image=${image} --arch=arm64

build-nix-installed:
    ARG image=ghcr.io/defn/dev:latest-nix-installed
    BUILD --platform=linux/amd64 +image-nix-installed --image=${image}
    BUILD --platform=linux/arm64 +image-nix-installed --image=${image}

build-nix-install:
    ARG image=ghcr.io/defn/dev:latest-nix-install
    BUILD --platform=linux/amd64 +image-nix-install --image=${image}
    BUILD --platform=linux/arm64 +image-nix-install --image=${image}

build-flake-root:
    ARG image=ghcr.io/defn/dev:latest-flake-root
    BUILD --platform=linux/amd64 +image-flake-root --image=${image}
    BUILD --platform=linux/arm64 +image-flake-root --image=${image}

build-devcontainer:
    ARG image=ghcr.io/defn/dev:latest-devcontainer
    BUILD --platform=linux/amd64 +image-devcontainer --image=${image}
    BUILD --platform=linux/arm64 +image-devcontainer --image=${image}

build-fly:
    ARG image=ghcr.io/defn/dev:latest-fly
    BUILD --platform=linux/amd64 +image-fly --image=${image}

image-nix-root:
    ARG arch
    ARG image
    FROM +nix-root --arch=${arch}
    SAVE IMAGE --push ${image}

image-nix-installed:
    ARG image
    FROM +nix-installed
    SAVE IMAGE --push ${image}

image-nix-install:
    ARG image
    FROM +nix-install
    SAVE IMAGE --push ${image}

image-flake-root:
    ARG arch
    ARG image
    FROM +flake-root --arch=${arch}
    SAVE IMAGE --push ${image}

image-devcontainer:
    ARG image
    FROM +devcontainer
    SAVE IMAGE --push ${image}

image-fly:
    ARG image
    FROM +fly
    SAVE IMAGE --push ${image}

###############################################
nix-root:
    ARG arch
    FROM pkg+root --arch=${arch}

    # nix config
    RUN sudo install -d -m 0755 -o ubuntu -g ubuntu /nix
    RUN mkdir -p /home/ubuntu/.config/nix
    COPY --chown=ubuntu:ubuntu .config/nix/nix-flake.conf /home/ubuntu/.config/nix/nix.conf
    COPY --chown=ubuntu:ubuntu .direnvrc /home/ubuntu/.direnvrc

# nix applications where /nix is not a data volume
nix-installed:
    FROM ghcr.io/defn/dev:latest-nix-root
    WORKDIR /app

    # nix
    RUN bash -c 'sh <(curl -L https://nixos.org/nix/install) --no-daemon'

    # nix config
    RUN echo 'use flake' > .envrc

# nix applications where /nix is a data volume
nix-install:
    FROM ghcr.io/defn/dev:latest-nix-root
    WORKDIR /app

    # nix (moved to /nix-install)
    RUN sudo install -d -m 0755 -o ubuntu -g ubuntu /nix-install
    RUN bash -c 'sh <(curl -L https://nixos.org/nix/install) --no-daemon' && mv /nix/var /nix/store /nix-install/

    # nix config
    RUN echo 'use flake' > .envrc

# for building flakes and saving thier nix artifacts
flake-root:
    FROM ghcr.io/defn/dev:latest-nix-installed
    WORKDIR /app

    # build prep
    RUN mkdir build && cd build && git init

    # store
    RUN mkdir store

# testing defn/dev build
dev:
    FROM ghcr.io/defn/dev:latest-nix-installed
    WORKDIR /home/ubuntu

    # work
    COPY bin/persist-cache /tmp/
    RUN sudo install -d -m 0755 -o ubuntu -g ubuntu /work && ln -nfs /work .
    RUN /tmp/persist-cache && rm -f /tmp/persist-cache

    # defn/dev
    COPY --chown=ubuntu:ubuntu --dir . .
    COPY --chown=ubuntu:ubuntu .config/nix/nix-earthly.conf /home/ubuntu/.config/nix/nix.conf
    RUN ~/.nix-profile/bin/nix build

# coder workspace container
devcontainer:
    FROM ghcr.io/defn/dev:latest-nix-installed
    WORKDIR /home/ubuntu

    # nix profile
    COPY .config/nix/nix-earthly.conf /home/ubuntu/.config/nix/nix.conf
    RUN ~/.nix-profile/bin/nix profile install nixpkgs#nix-direnv nixpkgs#direnv nixpkgs#pinentry nixpkgs#nixpkgs-fmt

    # defn/dev
    COPY --chown=ubuntu:ubuntu --dir . .
    RUN (git clean -nfd || true) \
        && (set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd)

# fly workspace container
fly:
    FROM ghcr.io/defn/dev:latest-nix-installed
    WORKDIR /home/ubuntu

    # defn/dev
    COPY --chown=ubuntu:ubuntu --dir . .
    RUN (git clean -nfd || true) \
        && (set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd)
