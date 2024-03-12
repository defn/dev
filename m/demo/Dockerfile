FROM ubuntu:22.04

RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y direnv curl xz-utils sudo locales git build-essential rsync
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN groupadd -r ubuntu && useradd -m -s /bin/bash -g ubuntu ubuntu

USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C
WORKDIR /home/ubuntu

RUN bash -c 'cd ~ && git clone https://github.com/defn/dev dev && mv dev/.git . && rm -rf dev && git reset --hard'
RUN bash -c 'cd ~ && source ~/.bash_profile && ~/bin/persist-cache'
RUN rm -rf ~/local/state/nix

RUN bash -c 'cd ~ && source ~/.bash_profile && make nix'
RUN bash -c 'cd ~ && source ~/.bash_profile && nix profile install nixpkgs#starship'
RUN bash -c 'cd ~ && source ~/.bash_profile && nix profile install nixpkgs#nix-direnv'
RUN bash -c 'cd ~ && source ~/.bash_profile && cd m/demo/nix && nix develop --command true'

COPY --chown=ubuntu:ubuntu . /home/ubuntu/m/demo
RUN bash -c 'cd ~ && source ~/.bash_profile && git fetch && git reset --hard origin/main'
COPY --chown=ubuntu:ubuntu . /home/ubuntu/m/demo
RUN bash -c 'cd ~ && source ~/.bash_profile && cd m/demo && direnv allow && git add . && cd nix && nix develop --command true'

