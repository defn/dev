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
RUN git pull && echo 20240728
RUN mkdir -p .config/nix
COPY nix.conf .config/nix/nix.conf

RUN bash -c 'source .bash_profile && bin/persist-cache && make nix'
RUN bash -c 'source .bash_profile && make home home=f/home flakes="cue gum dyff az home secrets acme tailscale utils just buildifier bazelisk ibazel oci development terraform terraformdocs step awscli chamber cloud coder codeserver tilt gh ghapps earthly flyctl oras regctl regbot regsync buildkite buildevents honeyvent honeymarker honeytail hugo shell"'

RUN rm -rf .cache work
RUN bash -c 'source .bash_profile && bin/persist-cache && cd m && b clean'

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y xz-utils curl sudo git make direnv gpg rsync ca-certificates

COPY --from=nix /home/ubuntu /home/ubuntu
COPY --from=nix /nix /nix

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ubuntu
ENV USER=ubuntu
ENV HOME=/home/ubuntu
ENV LANG=C
WORKDIR /home/ubuntu
ENTRYPOINT [ "bash", "-c" ]
CMD [ "git reset --hard; git pull; source .bash_profile; bin/persist-cache; exec /home/ubuntu//bin/nix/coder server" ]
