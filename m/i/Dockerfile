# syntax=docker/dockerfile:1.4

FROM ubuntu:noble-20250127

ENV DEBIAN_FRONTEND=noninteractive

# sync with install.sh, m/i/script/001-install-base
RUN apt update \
    && apt upgrade -y \
    && apt install -y \
        make direnv curl xz-utils dirmngr gpg pcscd scdaemon gpg-agent rsync \
        build-essential sudo ca-certificates tzdata locales git git-lfs tini \
        iproute2 iptables bc pv socat s6 cpu-checker bind9-dnsutils \
        pass

RUN curl -fsSL https://tailscale.com/install.sh | sh

RUN if [ "$(id -u ubuntu)" != 1000 ]; then groupadd -r --gid 1000 ubuntu && useradd -m -s /bin/bash -g ubuntu --uid 1000 ubuntu; fi

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN install -d -m 0755 -o ubuntu -g ubuntu /nix
RUN install -d -m 0755 -o ubuntu -g ubuntu /usr/local/bin/nix

USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /home/ubuntu

# bump to rebuild defn/dev from scratch
RUN echo 3

# initial clone and build
RUN git clone https://github.com/defn/dev dev && \
    mv dev/.git . && \
    git reset --hard && \
    rm -rf dev
RUN	bash -c "git pull && source .bash_profile && ./install.sh && ./install.sh"

# sudo doesnt work with qemu arm64 emulation
USER root
RUN apt update && sudo apt upgrade -y
RUN ./fixup.sh
USER ubuntu

# release rebuild on top of an old defn/dev
ARG RELEASE

RUN echo "$RELEASE"
RUN	bash -c "git pull && source .bash_profile && ./install.sh"

# sudo doesnt work with qemu arm64 emulation
USER root
RUN apt update && sudo apt upgrade -y
RUN ./fixup.sh
USER ubuntu

# nix has mount issues in a restricted container
# nix should be updated via the image
USER root
RUN rm -rf /usr/local/bin/nix/nix /home/ubuntu/.nix-profile/bin/nix \
    .nix-channels .nix-defexpr .nix-profile \
    .local/state/nix
USER ubuntu

RUN ln -nfs ../svc.d/tailscaled m/svc/

ENTRYPOINT [ "/bin/s6-svscan" ]
CMD [ "/home/ubuntu/m/svc" ]

