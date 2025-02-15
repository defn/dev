FROM quay.io/defn/dev:base

ARG GITHUB_TOKEN

RUN sudo apt update && sudo apt upgrade -y 

#	&& sudo apt install -y pipx pigz \
#	&& sudo apt install -y wireguard-tools qemu-system libvirt-clients libvirt-daemon-system openvpn easy-rsa expect tpm2-tools \
#	&& sudo apt install -y zfsutils-linux ubuntu-drivers-common \
	
RUN git reset --hard && git pull

RUN mkdir -p .config/nix
COPY nix.conf .config/nix/nix.conf
COPY --chown=ubuntu:ubuntu bazelrc.user m/.bazelrc.user

RUN bash -c 'source .bash_profile && bin/persist-cache && make install sync && cd m && b clean'
