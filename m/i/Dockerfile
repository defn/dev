# syntax=docker/dockerfile:1.14.0

FROM ubuntu:noble-20250127

ENV DEBIAN_FRONTEND=noninteractive

# sync with install.sh, m/i/script/001-install-base
RUN apt update \
    && apt upgrade -y \
    && apt install -y \
        make curl xz-utils dirmngr gpg pcscd scdaemon gpg-agent rsync \
        build-essential sudo ca-certificates tzdata locales git git-lfs tini \
        iproute2 iptables bc pv socat s6 cpu-checker bind9-dnsutils \
        pass skopeo

RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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

# bump to rebuild defn/dev from scratch
RUN echo 3

# initial clone and build
RUN git clone https://github.com/defn/dev dev && \
    mv dev/.git . && \
    git reset --hard && \
    rm -rf dev
RUN	--mount=type=secret,id=GITHUB_TOKEN,env=GITHUB_TOKEN bash -c "git pull && source .bash_profile && ./install.sh && ./install.sh"

# sudo doesnt work with qemu arm64 emulation
USER root
RUN apt update && sudo apt upgrade -y
RUN ./fixup.sh
USER ubuntu

# release rebuild on top of an old defn/dev
ARG RELEASE

RUN echo "$RELEASE"
RUN	--mount=type=secret,id=GITHUB_TOKEN,env=GITHUB_TOKEN bash -c "git pull && source .bash_profile && ./install.sh"

# sudo doesnt work with qemu arm64 emulation
USER root
RUN apt update && sudo apt upgrade -y
RUN ./fixup.sh
USER ubuntu

RUN ln -nfs ../svc.d/tailscaled m/svc/

ENTRYPOINT [ "/bin/s6-svscan" ]
CMD [ "/home/ubuntu/m/svc" ]

