# syntax=docker.io/docker/dockerfile-upstream:1.19.0
# https://github.com/moby/buildkit/releases

FROM ubuntu:noble-20251001

ARG BASE=7
RUN echo "$BASE"

ENV DEBIAN_FRONTEND=noninteractive

# bootstrap
# ca-certificates for docker repo
# python3.12-venv for mise python tooling
RUN apt update && apt upgrade -y && apt install -y make curl rsync sudo ca-certificates tzdata locales git python3.12-venv libatomic1 groff

# install docker
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o docker.asc
RUN install -m 0755 -d /etc/apt/keyrings
COPY docker.asc /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt update -y \
    && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# install tailscale
RUN curl -fsSL https://tailscale.com/install.sh | bash

# make ubuntu user
RUN if [ "$(id -u ubuntu)" != 1000 ]; then groupadd -r --gid 1000 ubuntu && useradd -m -s /bin/bash -g ubuntu --uid 1000 ubuntu; fi

# authorize sudo usage
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

#
# switch to ubuntu user
#
USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /home/ubuntu
ENTRYPOINT [ "/bin/s6-svscan" ]
CMD [ "/home/ubuntu/m/svc" ]

# install mise
RUN curl -sSL https://mise.run | bash

# initial clone and build, long term caching
RUN --mount=type=secret,id=GITHUB_TOKEN,env=GITHUB_TOKEN git clone https://github.com/defn/dev dev && mv dev/.git . && git reset --hard && rm -rf dev && bin/with-env make sync

# initial trunk install
RUN --mount=type=secret,id=GITHUB_TOKEN,env=GITHUB_TOKEN bin/with-env make trunk
RUN --mount=type=secret,id=GITHUB_TOKEN,env=GITHUB_TOKEN bin/with-env trunk install

# release rebuild, short term caching
ARG RELEASE
RUN echo "$RELEASE"
RUN	--mount=type=secret,id=GITHUB_TOKEN,env=GITHUB_TOKEN bin/with-env make sync
RUN --mount=type=secret,id=GITHUB_TOKEN,env=GITHUB_TOKEN bin/with-env trunk install
