FROM ubuntu:noble-20250127

ARG GITHUB_TOKEN
ARG NIX_CONFIG

ENV DEBIAN_FRONTEND=noninteractive

# sync with install.sh, m/i/script/001-install-base
RUN apt update && apt install -y \
    make direnv curl xz-utils dirmngr gpg pcscd scdaemon gpg-agent rsync \
    build-essential sudo ca-certificates tzdata locales git git-lfs tini \
    iproute2 iptables bc pv socat docker.io s6 cpu-checker bind9-dnsutils \
    pass

RUN curl -fsSL https://tailscale.com/install.sh | sh

RUN if [ "$(id -u ubuntu)" != 1000 ]; then groupadd -r --gid 1000 ubuntu && useradd -m -s /bin/bash -g ubuntu --uid 1000 ubuntu; fi
RUN usermod -aG docker ubuntu

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /home/ubuntu

RUN git clone https://github.com/defn/dev dev && \
    mv dev/.git . && \
    git reset --hard && \
    rm -rf dev
RUN	bash -c "source .bash_profile && ./install.sh && ./install.sh"

# nix has mount issues in a restricted container
# nix should be updated via the image
RUN sudo rm -rf /usr/local/bin/nix/nix /home/ubuntu/.nix-profile/bin/nix \
    .nix-channels .nix-defexpr .nix-profile \
    .local/state/nix

RUN ln -nfs ../svc.d/tailscaled m/svc/

ENTRYPOINT [ "/bin/s6-svscan" ]
CMD [ "/home/ubuntu/m/svc" ]
