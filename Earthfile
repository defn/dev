VERSION --shell-out-anywhere --use-chmod --use-host-command --earthly-version-arg --use-copy-link --use-registry-for-with-docker --ci-arg 0.6

IMPORT github.com/defn/pkg:0.0.112

build-root:
    ARG image=ghcr.io/defn/dev:latest-root
    BUILD --platform=linux/amd64 +image-root --image=${image} --arch=amd64
    BUILD --platform=linux/arm64 +image-root --image=${image} --arch=arm64

build-nix-root:
    ARG image=ghcr.io/defn/dev:latest-nix-root
    BUILD --platform=linux/amd64 +image-nix-root --image=${image} --arch=amd64
    BUILD --platform=linux/arm64 +image-nix-root --image=${image} --arch=arm64

build-nix:
    ARG image=ghcr.io/defn/dev:latest-nix
    BUILD --platform=linux/amd64 +image-nix --image=${image}
    BUILD --platform=linux/arm64 +image-nix --image=${image}

build-nix-install:
    ARG image=ghcr.io/defn/dev:latest-nix-install
    BUILD --platform=linux/amd64 +image-nix-install --image=${image}
    BUILD --platform=linux/arm64 +image-nix-install --image=${image}

build-fly:
    ARG image=ghcr.io/defn/dev:latest-fly
    BUILD --platform=linux/amd64 +image-fly --image=${image}

build-devcontainer:
    ARG image=ghcr.io/defn/dev:latest-devcontainer
    BUILD --platform=linux/amd64 +image-devcontainer --image=${image}
    BUILD --platform=linux/arm64 +image-devcontainer --image=${image}

image-root:
    ARG arch
    ARG image
    FROM +root --arch=${arch}
    SAVE IMAGE --push ${image}

image-nix-root:
    ARG arch
    ARG image
    FROM +nix-ubuntu --arch=${arch}
    SAVE IMAGE --push ${image}

image-nix:
    ARG image
    FROM +nix
    SAVE IMAGE --push ${image}

image-nix-install:
    ARG image
    FROM +nix-install
    SAVE IMAGE --push ${image}

image-fly:
    ARG image
    FROM +fly
    SAVE IMAGE --push ${image}

image-devcontainer:
    ARG image
    FROM +devcontainer
    SAVE IMAGE --push ${image}

root:
    ARG arch
    FROM pkg+root --arch=${arch}

nix-root:
    ARG arch
    FROM pkg+nix-ubuntu --arch=${arch}

fly:
    FROM ghcr.io/defn/dev:latest-root

    # defn/dev
    COPY --dir --chown=ubuntu:ubuntu . .
    RUN (git clean -nfd || true) \
        && (set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd)

nix:
    FROM ghcr.io/defn/dev:latest-root

    # nix
    RUN bash -c 'sh <(curl -L https://nixos.org/nix/install) --no-daemon --no-modify-profile' && mkdir -p .config/nix
    COPY .config/nix/nix-earthly.conf .config/nix/nix.conf

    # nix profile
    RUN bash -c '~/.nix-profile/bin/nix profile install nixpkgs#{nix-direnv,direnv,pinentry,nixpkgs-fmt}'

nix-install:
    FROM ghcr.io/defn/dev:latest-nix

    # /nix-install
    USER root
    RUN install -d -m 0755 -o ubuntu -g ubuntu /nix && install -d -m 0755 -o ubuntu -g ubuntu /nix-install

    # nix
    USER ubuntu
    RUN bash -c 'sh <(curl -L https://nixos.org/nix/install) --no-daemon' && mv /nix/var /nix/store /nix-install/

devcontainer:
    FROM ghcr.io/defn/dev:latest-nix

    # defn/dev
    COPY --dir --chown=ubuntu:ubuntu . .
    RUN (git clean -nfd || true) \
        && (set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd)

    SAVE ARTIFACT /nix nix

dev:
    FROM ghcr.io/defn/dev:latest-nix

    # work
    COPY bin/persist-cache /tmp/
    RUN sudo install -d -m 0755 -o ubuntu -g ubuntu /work && ln -nfs /work .
    RUN /tmp/persist-cache && rm -f /tmp/persist-cache

    # defn/dev
    COPY --dir --chown=ubuntu:ubuntu . .
    COPY .config/nix/nix-earthly.conf .config/nix/nix.conf
    RUN ~/.nix-profile/bin/nix build
