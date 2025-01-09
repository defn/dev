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
RUN git pull && echo 20250108

RUN mkdir -p .config/nix
COPY nix.conf .config/nix/nix.conf
COPY --chown=ubuntu:ubuntu bazelrc.user m/.bazelrc.user

RUN bash -c 'source .bash_profile && git reset --hard && git pull'
RUN bash -c 'source .bash_profile && bin/persist-cache && make nix'
RUN bash -c 'source .bash_profile && bin/persist-cache && make install'

RUN sudo apt-get update && sudo apt-get install -y xz-utils curl sudo git make direnv gpg rsync ca-certificates bc
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

ENTRYPOINT [ "bash", "-c" ]
CMD [ "git reset --hard && git pull && source .bash_profile && bin/persist-cache && mise trust; exec sleep infinity" ]
