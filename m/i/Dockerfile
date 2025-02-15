FROM quay.io/defn/dev:base

ARG GITHUB_TOKEN

RUN sudo apt update \
	&& sudo apt install -y pipx pigz \
	&& sudo apt install -y pcscd scdaemon gpg-agent wireguard-tools qemu-system libvirt-clients libvirt-daemon-system openvpn easy-rsa expect tpm2-tools \
	&& sudo apt install -y git-lfs \
	&& sudo apt install -y zfsutils-linux ubuntu-drivers-common \
	&& sudo apt install -y docker.io 
	
RUN usermod -aG docker ubuntu

RUN rm -rf /home/ubuntu && install -d -o ubuntu -g ubuntu -m 0755 /home/ubuntu

RUN git clone https://github.com/defn/dev /home/ubuntu
RUN git pull

RUN mkdir -p .config/nix
COPY nix.conf .config/nix/nix.conf
COPY --chown=ubuntu:ubuntu bazelrc.user m/.bazelrc.user

RUN bash -c 'source .bash_profile && git reset --hard && git pull'
RUN bash -c 'source .bash_profile && bin/persist-cache && make nix'
RUN bash -c 'source .bash_profile && bin/persist-cache && make install'

RUN sudo apt-get update && sudo apt-get install -y tini

RUN bash -c 'git pull && source .bash_profile && make install sync'

RUN bash -c 'source .bash_profile && for a in vscodevim.vim cuelang.cue kokakiwi.vscode-just svelte.svelte-vscode astro-build.astro-vscode unifiedjs.vscode-mdx betterthantomorrow.joyride; do code-server serve-local --force --install-extension "$a"; done'

ENTRYPOINT [ "/bin/tini", "bash", "--", "-c" ]
CMD [ "git reset --hard && git pull && exec sleep infinity" ]
