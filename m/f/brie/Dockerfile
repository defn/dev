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
RUN git pull && echo 20240921

RUN bash -c 'source .bash_profile && bin/persist-cache && make nix'
RUN bash -c 'source .bash_profile && git reset --hard && git pull'
RUN mkdir -p .config/nix
COPY nix.conf .config/nix/nix.conf
RUN bash -c 'source .bash_profile && bin/persist-cache && make home home=f/home flakes="coder codeserver shell" && rm -rf .cache work && cd m && b clean'

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y xz-utils curl sudo git make direnv gpg rsync ca-certificates

COPY --from=nix /home/ubuntu /home/ubuntu
COPY --from=nix /nix /nix.dist

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN curl -fsSL https://tailscale.com/install.sh | sh

USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C
WORKDIR /home/ubuntu
ENTRYPOINT [ "bash", "-c" ]
CMD [ "set -x; git reset --hard && git pull && source .bash_profile && rm -rf work /var/lib/tailscale && mkdir -p /nix/work /nix/tailscale && ln -nfs /nix/work ~/ && ln -nfs /nix/tailscale /var/lib/tailscale && bin/persist-cache; if ! test -x /home/ubuntu/bin/nix/coder; then rsync -ia /nix.dist/. /nix/.; fi; sudo /usr/sbin/tailscaled & exec /home/ubuntu/bin/nix/coder server" ]
