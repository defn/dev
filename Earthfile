VERSION --shell-out-anywhere --use-chmod --use-host-command --earthly-version-arg --use-copy-link --use-registry-for-with-docker --ci-arg 0.6

IMPORT github.com/defn/pkg:0.0.112

build-devcontainer:
    ARG image
    BUILD --platform=linux/amd64 +devcontainer --image=${image} --arch=amd64
    BUILD --platform=linux/arm64 +devcontainer --image=${image} --arch=arm64

build-fly:
    ARG image
    BUILD --platform=linux/amd64 +fly --image=${image} --arch=amd64

fly:
    ARG image
    ARG arch

    FROM pkg+root --arch=${arch}

    # defn/dev
    COPY --dir --chown=ubuntu:ubuntu . .
    RUN (git clean -nfd || true) \
        && (set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd)

    IF [ "$image" != "" ]
        SAVE IMAGE --push ${image}
    END

devcontainer:
    ARG image
    ARG arch
    ARG GITHUB_TOKEN

    FROM pkg+root --arch=${arch}

    # nix
    RUN bash -c 'sh <(curl -L https://nixos.org/nix/install) --no-daemon --no-modify-profile ' && mkdir -p .config/nix
    COPY .config/nix/nix-earthly.conf .config/nix/nix.conf

    # nix profile
    RUN bash -c '~/.nix-profile/bin/nix profile install nixpkgs#{nix-direnv,direnv,pinentry,nixpkgs-fmt}'

    # defn/dev
    COPY --dir --chown=ubuntu:ubuntu . .
    RUN (git clean -nfdx || true) \
        && (set -e; if test -e work; then false; fi; git clean -nfd; bash -c 'if test -n "$(git clean -nfd)"; then false; fi'; git clean -ffd)

    SAVE ARTIFACT /nix nix

    IF [ "$image" != "" ]
        SAVE IMAGE --push ${image}
    END

dev:
    ARG image
    ARG arch

    FROM pkg+root --arch=${arch}

    # work
    COPY bin/persist-cache /tmp/
    RUN sudo install -d -m 0755 -o ubuntu -g ubuntu /work && ln -nfs /work .
    RUN /tmp/persist-cache

    # nix
    RUN bash -c 'sh <(curl -L https://nixos.org/nix/install) --no-daemon --no-modify-profile' && mkdir -p .config/nix
    COPY .config/nix/nix-earthly.conf .config/nix/nix.conf

    # nix profile
    RUN bash -c '~/.nix-profile/bin/nix profile install nixpkgs#{nix-direnv,direnv,pinentry,nixpkgs-fmt}'

    # defn/dev flake
    COPY flake.* SLUG VERSION .
    RUN ~/.nix-profile/bin/nix build