VERSION --shell-out-anywhere --use-chmod --use-host-command --earthly-version-arg --use-copy-link --use-registry-for-with-docker --ci-arg 0.6

IMPORT github.com/defn/pkg:0.0.112

build-nix:
    ARG image=ghcr.io/defn/dev:latest-nix
    BUILD --platform=linux/amd64 +image-nix --image=${image} --arch=amd64
    BUILD --platform=linux/arm64 +image-nix --image=${image} --arch=arm64

build-fly:
    ARG image
    BUILD --platform=linux/amd64 +image-fly --image=${image} --arch=amd64

build-devcontainer:
    ARG image
    BUILD --platform=linux/amd64 +image-devcontainer --image=${image} --arch=amd64
    BUILD --platform=linux/arm64 +image-devcontainer --image=${image} --arch=arm64

image-nix:
    ARG arch
    ARG image
    FROM +nix --arch=${arch}
    SAVE IMAGE --push ${image}

image-fly:
    ARG arch
    ARG image
    FROM +fly --arch=${arch}
    SAVE IMAGE --push ${image}

image-devcontainer:
    ARG arch
    ARG image
    FROM +devcontainer --arch=${arch}
    SAVE IMAGE --push ${image}

nix:
    ARG arch
    FROM pkg+root --arch=${arch}

    # nix
    RUN bash -c 'sh <(curl -L https://nixos.org/nix/install) --no-daemon --no-modify-profile' && mkdir -p .config/nix
    COPY .config/nix/nix-earthly.conf .config/nix/nix.conf

    # nix profile
    RUN bash -c '~/.nix-profile/bin/nix profile install nixpkgs#{nix-direnv,direnv,pinentry,nixpkgs-fmt}'

fly:
    ARG arch
    FROM pkg+root --arch=${arch}

    # defn/dev
    COPY --dir --chown=ubuntu:ubuntu . .
    RUN (git clean -nfd || true) \
        && (set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd)

devcontainer:
    ARG arch
    FROM ghcr.io/defn/dev:latest-nix

    # defn/dev
    COPY --dir --chown=ubuntu:ubuntu . .
    RUN (git clean -nfd || true) \
        && (set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd)

    SAVE ARTIFACT /nix nix

dev:
    ARG arch
    FROM ghcr.io/defn/dev:latest-nix

    # work
    COPY bin/persist-cache /tmp/
    RUN sudo install -d -m 0755 -o ubuntu -g ubuntu /work && ln -nfs /work .
    RUN /tmp/persist-cache && rm -f /tmp/persist-cache

    # defn/dev
    COPY --dir --chown=ubuntu:ubuntu . .
    COPY .config/nix/nix-earthly.conf .config/nix/nix.conf
    RUN ~/.nix-profile/bin/nix build
