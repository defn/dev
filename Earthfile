VERSION 0.7

# rsync -ia `/home/ubuntu/.nix-profile/bin/nix-store -qR ~/.nix-profile $(ls -d .direnv/flake-profile-* | grep -v 'rc$')` /store/

build:
    ARG image=quay.io/defn/dev:latest-nix
    BUILD --platform=linux/amd64 +image-nix --image=${image}
    BUILD --platform=linux/arm64 +image-nix --image=${image}

image-nix:
    ARG image
    FROM +nix
    SAVE IMAGE --push ${image}

###############################################
ubuntu-bare:
    ARG UBUNTU=ubuntu:jammy-20221130

    FROM ${UBUNTU}

    SAVE IMAGE --cache-hint

root:
    FROM +ubuntu-bare

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
        && apt-get install -y --no-install-recommends lsb-release tzdata locales ca-certificates wget curl xz-utils rsync make git direnv bash-completion less pass \
            sudo tini procps iptables net-tools iputils-ping iproute2 dnsutils gnupg \
            openssh-client fzf build-essential \
        && apt-get clean && apt purge -y nano \
        && rm -f /usr/bin/gs \
        && curl -sSL -o /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.17.0/bazelisk-linux-amd64 \
        &&  sudo chmod 755 /usr/local/bin/bazel

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
        && install -d -m 0700 -o ubuntu -g ubuntu /run/user/1000 /run/user/1000/gnupg \
        && install -d -m 0700 -o ubuntu -g ubuntu /app /cache

    RUN chown -R ubuntu:ubuntu /home/ubuntu && chmod u+s /usr/bin/sudo

    ENTRYPOINT []
    CMD []

    USER ubuntu
    ENV USER=ubuntu
    ENV HOME=/home/ubuntu
    ENV LOCAL_ARCHIVE=/usr/lib/locale/locale-archive
    ENV LC_ALL=C.UTF-8

    WORKDIR /home/ubuntu

nix:
    FROM +root
