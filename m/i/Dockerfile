FROM ubuntu:24.04 AS nix

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt install -y ca-certificates \
	&& apt install -y tzdata locales sudo \
	&& apt install -y git direnv make rsync bc pipx pigz \
	&& apt install -y socat pcscd scdaemon gpg gpg-agent wireguard-tools qemu-system libvirt-clients libvirt-daemon-system openvpn easy-rsa expect tpm2-tools \
	&& apt install -y curl xz-utils git-lfs pv \
	&& apt install -y zfsutils-linux ubuntu-drivers-common \
	&& apt install -y build-essential \
	&& apt install -y docker.io 
	
RUN curl -sSL -O https://github.com/peak/s5cmd/releases/download/v2.3.0/s5cmd_2.3.0_linux_amd64.deb \
	&& dpkg -i s5cmd_2.3.0_linux_amd64.deb \
	&& rm -f s5cmd_2.3.0_linux_amd64.deb

RUN usermod -aG docker ubuntu

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ubuntu

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

RUN sudo apt-get update && sudo apt-get install -y tini

RUN bash -c 'git pull && source .bash_profile && make install sync && rm -f /tmp/.bash_entrypoint*'

ENTRYPOINT [ "/bin/tini", "bash", "--", "-c" ]
CMD [ "git reset --hard && git pull && exec sleep infinity" ]
