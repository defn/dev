FROM quay.io/defn/dev:base

ARG GITHUB_TOKEN

RUN sudo apt update \
	&& sudo apt install -y pipx pigz \
	&& sudo apt install -y pcscd scdaemon gpg-agent wireguard-tools qemu-system libvirt-clients libvirt-daemon-system openvpn easy-rsa expect tpm2-tools \
	&& sudo apt install -y git-lfs \
	&& sudo apt install -y zfsutils-linux ubuntu-drivers-common \
	&& sudo apt install -y docker.io 
	
RUN usermod -aG docker ubuntu

RUN git reset --hard && git pull

RUN mkdir -p .config/nix
COPY nix.conf .config/nix/nix.conf
COPY --chown=ubuntu:ubuntu bazelrc.user m/.bazelrc.user

RUN bash -c 'source .bash_profile && bin/persist-cache && make install sync'
RUN bash -c 'source .bash_profile && for a in vscodevim.vim cuelang.cue kokakiwi.vscode-just svelte.svelte-vscode astro-build.astro-vscode unifiedjs.vscode-mdx betterthantomorrow.joyride; do code-server serve-local --force --install-extension "$a"; done'
