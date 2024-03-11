FROM ubuntu:22.04

RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y vim-nox direnv curl xz-utils sudo locales git build-essential
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN groupadd -r ubuntu && useradd -m -s /bin/bash -g ubuntu ubuntu

USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C
WORKDIR /home/ubuntu

RUN mkdir -p ~/.config/nix
RUN echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
RUN bash -c 'sh <(curl -L https://nixos.org/nix/install) --no-daemon'
RUN echo 'PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
RUN echo ". /home/ubuntu/.nix-profile/etc/profile.d/nix.sh" > ~/.bashrc
RUN echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc
COPY flake.json flake.nix /home/ubuntu/
RUN bash -c 'cd ~ && source ~/.bashrc && nix develop --command true'
