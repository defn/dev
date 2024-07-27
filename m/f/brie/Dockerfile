FROM ubuntu:24.04 AS nix

RUN apt-get update && apt-get install -y xz-utils curl sudo git make direnv gpg rsync

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN rm -rf /home/ubuntu && install -d -o ubuntu -g ubuntu -m 0755 /home/ubuntu

USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C
WORKDIR /home/ubuntu

RUN git clone https://github.com/defn/dev /home/ubuntu
RUN mkdir -p .config/nix
COPY nix.conf .config/nix/nix.conf
RUN bash -c 'source .bash_profile && make nix'
RUN sudo apt install -y rsync
RUN bash -c 'source .bash_profile && bin/persist-cache && cd m/pkg/attic && nix build'
RUN bash -c 'source .bash_profile && make install'

RUN rm -rf .git work
RUN bash -c 'source .bash_profile && bin/persist-cache && cd m && b clean'

FROM ghcr.io/coder/coder:latest

COPY --from=nix /nix /nix
COPY --from=nix /home/ubuntu /home/ubuntu
