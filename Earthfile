VERSION --use-registry-for-with-docker --ci-arg 0.7

build-nix-root:
    ARG image=quay.io/defn/dev:latest-nix-root
    BUILD --platform=linux/amd64 +image-nix-root --image=${image} --arch=amd64
    BUILD --platform=linux/arm64 +image-nix-root --image=${image} --arch=arm64

build-nix-empty:
    ARG image=quay.io/defn/dev:latest-nix-empty
    BUILD --platform=linux/amd64 +image-nix-empty --image=${image}
    BUILD --platform=linux/arm64 +image-nix-empty --image=${image}

build-nix-installed:
    ARG image=quay.io/defn/dev:latest-nix-installed
    BUILD --platform=linux/amd64 +image-nix-installed --image=${image}
    BUILD --platform=linux/arm64 +image-nix-installed --image=${image}

build-flake-root:
    ARG image=quay.io/defn/dev:latest-flake-root
    BUILD --platform=linux/amd64 +image-flake-root --image=${image}
    BUILD --platform=linux/arm64 +image-flake-root --image=${image}

build-devcontainer:
    ARG image=quay.io/defn/dev:latest-devcontainer
    BUILD --platform=linux/amd64 +image-devcontainer --image=${image}
    BUILD --platform=linux/arm64 +image-devcontainer --image=${image}

image-nix-root:
    ARG arch
    ARG image
    FROM +nix-root --arch=${arch}
    SAVE IMAGE --push ${image}

image-nix-empty:
    ARG image
    FROM +nix-empty
    SAVE IMAGE --push ${image}

image-nix-installed:
    ARG image
    FROM +nix-installed
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

###############################################
ubuntu-bare:
    ARG arch
    ARG UBUNTU=ubuntu:jammy-20221130

    FROM ${UBUNTU}

    SAVE IMAGE --cache-hint

root:
    ARG arch

    FROM +ubuntu-bare --arch=${arch}

    USER root

    ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    ENV LANG en_US.UTF-8
    ENV LANGUAGE en_US:en
    ENV LC_ALL en_US.UTF-8

    ENV DEBIAN_FRONTEND=noninteractive
    ENV container=docker

    RUN  (echo "Update-Manager::Never-Include-Phased-Updates;"; echo "APT::Get::Never-Include-Phased-Updates: True;") > /etc/apt/apt.conf.d/99-Phased-Updates

    RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm \
        && apt-get update && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends lsb-release tzdata locales ca-certificates wget curl xz-utils rsync make git direnv bash-completion less \
            sudo tini procps iptables net-tools iputils-ping iproute2 dnsutils gnupg \
        && apt-get clean && apt purge -y nano \
        && rm -f /usr/bin/gs

    RUN apt update && apt upgrade -y

    RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
        && dpkg-reconfigure -f noninteractive tzdata \
        && locale-gen en_US.UTF-8 \
        && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

    RUN groupadd -g 1000 ubuntu && useradd -u 1000 -d /home/ubuntu -s /bin/bash -g ubuntu -M ubuntu \
        && echo '%ubuntu ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu \
        && install -d -m 0700 -o ubuntu -g ubuntu /home/ubuntu

    RUN install -d -m 0755 -o root -g root /run/user \
        && install -d -m 0700 -o root -g root /run/sshd \
        && install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 \
        && install -d -m 0700 -o ubuntu -g ubuntu /app \
        && install -d -m 0700 -o ubuntu -g ubuntu /cache

    RUN chown -R ubuntu:ubuntu /home/ubuntu && chmod u+s /usr/bin/sudo

    COPY entrypoint /entrypoint
    ENTRYPOINT ["/entrypoint"]
    CMD []

    USER ubuntu
    ENV USER=ubuntu
    ENV HOME=/home/ubuntu
    ENV LOCAL_ARCHIVE=/usr/lib/locale/locale-archive
    ENV LC_ALL=C.UTF-8

    WORKDIR /home/ubuntu

###############################################
nix-root:
    ARG arch
    FROM +root --arch=${arch}

    # nix config
    RUN sudo install -d -m 0755 -o ubuntu -g ubuntu /nix && mkdir -p /home/ubuntu/.config/nix
    COPY --chown=ubuntu:ubuntu .config/nix/nix-flake.conf /home/ubuntu/.config/nix/nix.conf

# nix applications where /nix is not a data volume
nix-installed:
    FROM quay.io/defn/dev:latest-nix-root
    WORKDIR /app

    # nix
    RUN bash -c 'sh <(curl -L https://releases.nixos.org/nix/nix-2.15.0/install) --no-daemon' \
        && echo . ~/.bashrc > ~/.bash_profile \
        && echo . ~/.nix-profile/etc/profile.d/nix.sh > ~/.bashrc \
        && echo 'eval "$(direnv hook bash)"' >> ~/.bashrc \
        && . ~/.nix-profile/etc/profile.d/nix.sh \
        && nix profile install nixpkgs#nix-direnv nixpkgs#direnv \
        && echo 'use flake' > .envrc \
        && nix profile wipe-history \
        && nix-store --gc

    COPY --chown=ubuntu:ubuntu .direnvrc /home/ubuntu/.direnvrc

# nix applications where /nix/store is emptied
nix-empty-installed:
    FROM quay.io/defn/dev:latest-nix-installed

    RUN sudo install -d -o ubuntu -g ubuntu /store
    SAVE ARTIFACT /nix/var var

nix-empty:
    FROM quay.io/defn/dev:latest-nix-root
    WORKDIR /app

    # nix
    COPY --chown=ubuntu:ubuntu +nix-empty-installed/var /nix/var
    COPY --chown=ubuntu:ubuntu .direnvrc /home/ubuntu/.direnvrc
    RUN echo . ~/.bashrc > ~/.bash_profile \
        && echo . ~/.nix-profile/etc/profile.d/nix.sh > ~/.bashrc \
        && echo 'eval "$(direnv hook bash)"' >> ~/.bashrc \
        && echo 'use flake' > .envrc

# for building flakes and saving thier nix artifacts
flake-root:
    FROM quay.io/defn/dev:latest-nix-installed
    WORKDIR /app

    # build prep
    RUN mkdir build && cd build && git init

NIX_DIRENV:
    COMMAND

    FROM quay.io/defn/dev:latest-nix-installed
    COPY --chown=ubuntu:ubuntu --dir . .
    RUN if git clean | grep -i would.remove; then false; fi
    RUN bash -c '. /home/ubuntu/.nix-profile/etc/profile.d/nix.sh; eval "$(direnv hook bash)"; direnv allow; _direnv_hook; nix profile wipe-history; nix-store --gc'
    RUN sudo install -d -o ubuntu -g ubuntu /store
    RUN rsync -ia `/home/ubuntu/.nix-profile/bin/nix-store -qR ~/.nix-profile $(ls -d .direnv/flake-profile-* | grep -v 'rc$')` /store/

# coder workspace container
devcontainer:
    FROM quay.io/defn/dev:latest-nix-root
    WORKDIR /home/ubuntu

    # run dir
    RUN sudo install -d -m 0755 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg

    # defn/dev
    COPY --chown=ubuntu:ubuntu --dir .git .git
    RUN git reset --hard
