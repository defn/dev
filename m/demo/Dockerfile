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
RUN echo 'source ~/.bashrc' >> ~/.bash_profile
RUN echo 'PATH=$PATH:$HOME/.local/bin' >> ~/.bash_profile
RUN echo ". /home/ubuntu/.nix-profile/etc/profile.d/nix.sh" >> ~/.bash_profile
RUN echo 'eval "$(direnv hook bash)"' >> ~/.bash_profile
RUN echo 'eval "$(starship init bash)"' >> ~/.bash_profile
RUN echo 'export DIRENV_LOG_FORMAT="' >> ~/.bash_profile
RUN echo 'alias gs="git status -sb"' >> ~/.bash_profile
COPY flake.json flake.nix /home/ubuntu/
RUN bash -c 'cd ~ && source ~/.bash_profile && nix develop --command true'
RUN bash -c 'cd ~ && source ~/.bash_profile && nix profile install nixpkgs#starship'
RUN bash -c 'cd ~ && source ~/.bash_profile && nix profile install nixpkgs#nix-direnv'
RUN bash -c 'cd ~ && rm -f flake.nix flake.json'
