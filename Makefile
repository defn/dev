SHELL := /bin/bash

# https://nixos.org/download
NIX_VERSION := 2.24.5

flakes ?= attic cue cuetsy gum vhs glow dyff az home secrets tailscale vpn utils just buildifier bazelisk ibazel oci development step awscli chamber cloud terraform kubectl k3d k9s helm kustomize stern kubeseal argocd vcluster coder codeserver tilt gh earthly flyctl oras regctl regbot regsync buildkite buildevents honeyvent honeymarker honeytail godev jsdev pydev rustdev shell
home ?= home

name ?= local
domain ?= defn.run

latest:
	git pull
	$(MAKE) update
	$(MAKE) install

rpi:
	$(MAKE) no-gpg
	$(MAKE) rpi-install

cb:
	$(MAKE) no-gpg
	$(MAKE) cb-install

rpi-install:
	sudo apt update
	sudo apt install -y git direnv make rsync bc pipx

chrome-coder:
	$(MAKE) -j 2 chrome-dev-socat chrome-dev-coder

vpn:
	cd m/openvpn && ./service server

vpn-install:
	sudo apt update
	sudo apt install -y git direnv make rsync bc pipx
	sudo apt install -y socat pcscd wireguard-tools qemu-system libvirt-clients libvirt-daemon-system openvpn easy-rsa expect tpm2-tools

no-gpg:
	systemctl --user disable gpg-agent-browser.socket --now || true
	systemctl --user disable gpg-agent-extra.socket --now || true
	systemctl --user disable gpg-agent-ssh.socket --now || true
	systemctl --user disable gpg-agent.socket --now || true
	systemctl --user disable gpg-agent --now || true
	pkill -9 gpg-agent || true

chrome-dev-gpg:
	sudo systemctl restart pcscd
	$(MAKE) no-gpg
	gpg-agent --daemon --pinentry-program $$(which pinentry)
	while [[ "$$(pass hello)" != "world" ]]; do sleep 1; done

chrome-dev-socat:
	while true; do sudo pkill -9 socat || true; sudo socat TCP-LISTEN:443,fork TCP:localhost:3443; done

chrome-dev-coder:
	while true; do (cd m && $(MAKE) teacher domain=$(domain) name=$(name)); done

chrome-dev-cert-issue:
	this-acme-issue '*.$(name).$(domain)'

chrome-dev-cert-renew:
	this-acme-renew '*.$(name).$(domain)'

chrome-dev-dns:
	touch ~/.config/cloudflare-ddns.toml 
	cloudflare-ddns --domain $(domain) --record '*.$(name).$(domain)' --ip "$$(ip addr show eth0 | grep 'inet ' | awk '{print $$2}' | cut -d/ -f1)" --token "$$(pass cloudflare_$(domain))" --config ~/.config/cloudflare-ddns.toml 

chrome-minikube:
	minikube start --driver=kvm2 --auto-update-drivers=false --insecure-registry=cache.$(domain):4999

build:
	bazel --version
	$(MAKE) home

ci:
	@echo "+++ Results"
	@echo
	@ps axf; echo
	@pwd; echo
	@id -a; echo
	@cd m && $(MAKE) build

menu: # This menu
	@perl -ne 'printf("%20s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' $(shell ls -d Makefile2>/dev/null)

dummy_ip ?= 169.254.32.1

first = $(word 1, $(subst -, ,$@))
second = $(word 2, $(subst -, ,$@))
first_ = $(word 1, $(subst _, ,$@))
second_ = $(word 2, $(subst _, ,$@))

MARK = $(shell which mark || echo echo)

macos-reinstall:
	sudo rm -rf /Library/Developer/CommandLineTools
	/usr/bin/xcode-select --install

macos:
	$(MARK) macos
	-$(shell which gpg-agent) --daemon --pinentry-program $$(which pinentry-mac)
	for ip in $(dummy_ip); do if ! ifconfig lo0 | grep "inet $$ip"; then sudo ifconfig lo0 alias "$$ip" netmask 255.255.255.255; fi; done;
	ifconfig lo0
	defaults write -g ApplePressAndHoldEnabled -bool false
#	sudo -A ln -nfs ~/.docker/run/docker.sock /var/run/docker.sock
#	while true; do if docker ps; then break; fi; sleep 5; done
#	-docker context create host --docker host=unix:///var/run/docker.sock
#	-docker network create dev
#	docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock ubuntu chown 1000:1000 /var/run/docker.sock

rehome:
	this-nix-gc
	rm -rf bin/nix/.head-* bin/nix.tmp*
	$(MAKE) install

home:
	bin/persist-cache
	cd m && bazel version
	cd m/${home} && b build
	rm -rf /tmp/nix-tmp /tmp/nix-bin
	mkdir -p /tmp/nix-tmp /tmp/nix-bin
	(cd m/${home} && b out something) | (cd /tmp/nix-tmp && tar xfz -)
	cd /tmp/nix-tmp && for a in $(flakes); do (cd $$a && if ! stat -L * 2>/dev/null >/dev/null; then echo $$a; (cd ~/m/pkg/$$a && b build); sudo tar -C / -xf ~/m/$$(cat .bazel-nix-store) || true; fi; rsync -ia . /tmp/nix-bin/. >/dev/null); done
	rm -f /tmp/nix-bin/.bazel-nix-store /tmp/nix-bin/.nix-flake
	mkdir -p bin/nix
	rsync -ia --delete /tmp/nix-bin/. bin/nix/.

.PHONY: dotfiles
dotfiles:
	$(MARK) configure dotfiles
	rm -rf ~/.dotfiles
	mkdir -p ~/dotfiles
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		if ! test -d ~/dotfiles/.git/.; then \
			rm -rf ~/dotfiles; \
			t git_clone_dotfiles git clone git@github.com:$${GIT_AUTHOR_NAME}/dotfiles ~/dotfiles; \
		fi; \
		t dotfiles_bootstrap ./dotfiles/bootstrap; \
	fi

password-store:
	$(MARK) configure password-store
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		if ! test -d ~/work/password-store/.git/.; then \
			rm -rf ~/work/pssword-store; \
			mkdir -p ~/work/password-store; \
			t git_clone_password_store git clone git@github.com:$${GIT_AUTHOR_NAME}/password-store ~/work/password-store; \
		fi; \
	fi

gpg:
	$(MARK) configure gpg
	dirmngr --shutdown || true
	dirmngr --daemon
	t make_perms $(MAKE) perms
	if [[ "$(shell uname -s)" == "Darwin" ]]; then t make_macos $(MAKE) macos; fi

docker:
	$(MARK) docker
	docker context create pod --docker host=tcp://localhost:2375 || true \
		&& docker context create host --docker host=unix:///var/run/docker.sock || true \
		&& docker context use host

trunk:
	@$(MARK) trunk
	@if ! type -P trunk >/dev/null; then curl https://get.trunk.io -fsSL | sed 's#/usr/local/bin#$$HOME/bin/$$(uname -s)#' | bash; fi
	@trunk version || true
	@sudo rm -f /usr/local/bin/trunk
	@git checkout .local/share/code-server/User/settings.json

login:
	if test -f /run/secrets/kubernetes.io/serviceaccount/ca.crt; then mark kubernetes; this-kubeconfig; this-argocd-login || true; fi
	this-github-login

symlinks:
	$(MARK) configure symlinks
	t persist_cache bin/persist-cache

perms:
	$(MARK) configure permissions
	if [[ "Linux" == "$(shell uname -s)" ]]; then if test -S /var/run/docker.sock; then sudo chgrp ubuntu /var/run/docker.sock; sudo chmod 770 /var/run/docker.sock; fi; fi
	if test -S /run/containerd/containerd.sock; then sudo chgrp ubuntu /run/containerd/containerd.sock; sudo chmod 770 /run/containerd/containerd.sock; fi
	-if ! test -f ~/.kube/config; then mkdir -p ~/.kube; touch ~/.kube/config; fi
	-chmod 0600 ~/.kube/config

update:
	git pull
	-cd .password-store && git pull
	-cd dotfiles && git pull && ./bootstrap
	$(MAKE) install

init:
	git branch --set-upstream-to origin/main main
	git fetch origin
	git reset --hard origin/main
	bin/persist-cache
	cp .ssh/config.example .ssh/config
	ssh -o BatchMode=yes -o StrictHostKeyChecking=no home true || true
	cd m/pb && $(MAKE) local || true
	b agent make install

deck-init:
	git branch --set-upstream-to origin/main main
	git fetch origin
	git reset --hard origin/main
	bin/persist-cache
	cp .ssh/config.example .ssh/config
	ssh -o BatchMode=yes -o StrictHostKeyChecking=no home true || true
	make install

play:
	cd m/pb && $(MAKE) ubuntu opt="-i inventory/packer.ini -e ansible_connection=local"

upgrade:
	cd m/pb && $(MAKE) upgrade opt="-i inventory/packer.ini -e ansible_connection=local"

install:
	t make_install $(MAKE) install_t

install_t:
	sudo true
	t make_nix $(MAKE) nix
	t make_trunk $(MAKE) trunk
	t install_inner $(MAKE) install-inner
	@mark finished

install-inner:
	t make_symlinks $(MAKE) symlinks
	t make_perms $(MAKE) perms
	t make_install_innermost bash -c '. ~/.bash_profile && $(MAKE) install-innermost'
	t make_home $(MAKE) home

install-innermost:
	git config lfs.https://github.com/defn/dev.git/info/lfs.locksverify false
	git config diff.lfs.textconv cat
	t make_dotfiles $(MAKE) dotfiles
	t make_password_store $(MAKE) password-store
	t make_gpg $(MAKE) gpg

nix:
	(. ~/.nix-profile/etc/profile.d/nix.sh && which nix) || t make_nix_platform $(MAKE) nix-$(shell uname -s)
	if [[ "$$(id -un)" == "deck" ]]; then t make_nix_deck $(MAKE) nix-deck; fi
	. ~/.nix-profile/etc/profile.d/nix.sh && (test -f "$$HOME/.nix-profile/share/nix-direnv/direnvrc" || t nix_profile_direnv nix profile install nixpkgs#nix-direnv)
	. ~/.nix-profile/etc/profile.d/nix.sh && (test -f "$$HOME/.nix-profile/bin/bazelisk" || t nix_profile_bazelisk nix profile install nixpkgs#bazelisk)
	. ~/.nix-profile/etc/profile.d/nix.sh && (test -f "$$HOME/.nix-profile/bin/nixpkgs-fmt" || t nix_profile_bazelisk nix profile install nixpkgs#nixpkgs-fmt)
	ln -nfs $$(which bazelisk) $$HOME/bin/$$(uname -s)/bazel
	sudo rm -f /usr/local/bin/bazel /usr/local/bin/bazelisk

nix-reset:
	sudo rm -rf /nix/new /nix/old
	docker run --rm -ti -v /home/ubuntu:/home/ubuntu -v /nix/new:/nix --workdir /home/ubuntu --user root ubuntu:24.04 ./bin/reset-nix
	sudo rm -rf /nix/old
	mkdir -p /nix/old
	mv -v /nix/var /nix/store /nix/old/
	sudo /bin/mv -v /nix/new/var /nix/new/store /nix/
	sudo rm -rf /nix/new

nix-reset-inner:
	. .bash_profile && $(MAKE) nix-reset-inner-inner

nix-reset-inner-inner:
	sudo apt update
	sudo apt install -y curl xz-utils git git-lfs rsync
	sudo chown ubuntu:ubuntu /nix
	$(MAKE) nix-reinstall
	$(MAKE) install

nix-reinstall:
	rm -rf .nix-* .local/state/nix
	t make_nix $(MAKE) nix

nix-uninstall:
	-sudo mv /etc/zshrc.backup-before-nix /etc/zshrc
	-sudo mv /etc/bashrc.backup-before-nix /etc/bashrc
	-sudo rm -f /etc/bash.bashrc.backup-before-nix
	-sudo launchctl unload /Library/LaunchDaemon/org.nixos.nix-daemon.plist
	-sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
	-sudo launchctl unload /Library/LaunchDaemons/org.nixos.activate-system.plist
	-sudo rm /Library/LaunchDaemons/org.nixos.activate-system.plist
	-sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels
	-sudo dscl . delete /Groups/nixbld
	-for i in $$(seq 1 32); do sudo dscl . -delete /Users/_nixbld$$i; done
	-sudo diskutil apfs deleteVolume /nix
	-sudo rm -rf /nix/

nix-clean:
	rm -rf .nix-profile .local/state/nix/profiles/profile

nix-Linux:
	export LC_ALL=C.UTF-8 && if ! type -P nix; then t make_nix_linux_bootstrap $(MAKE) nix-Linux-bootstrap; fi

nix-Darwin:
	runmany 'nix profile install nixpkgs#$$1' nix

nix-deck:
	runmany 'nix profile install nixpkgs#$$1' gnumake screen pipx gnupg vim cue

# https://github.com/NixOS/nixpkgs/blob/9f0d9ad45c4bd998c46ba1cbe0eb0dd28c6288a5/pkgs/tools/package-management/nix/default.nix
# look for the stable version
nix-Linux-bootstrap:
	t curl_bash_nix_install sh <(curl -L https://releases.nixos.org/nix/nix-$(NIX_VERSION)/install) --no-daemon
	git checkout .bash_profile

nix-Darwin-bootstrap:
	ln -nfs /nix/var/nix/profiles/default ~/.nix-profile

coder-ssh-linux:
	export STARSHIP_NO=1 LOCAL_ARCHIVE=/usr/lib/locale/locale-archive && source ~/.bash_profile && cd $(CODER_HOMEDIR) \
		&& (echo set -x; echo "exec 1>>/tmp/coder-agent-stdout.log 2>>/tmp/coder-agent-stderr.log"; echo $(CODER_INIT_SCRIPT_BASE64) | base64 -d) | (sed 's#agent$$#agent $${CODER_NAME}#; s#^while.*#while ! test -x $${BINARY_NAME}; do#; s#^BINARY_NAME.*#BINARY_NAME=$$HOME/bin/nix/coder#; s#exec ./#exec #; s#exit 1#echo exit 1#' ) > /tmp/coder-agent-$(CODER_NAME)-$$$$ && exec bash -x /tmp/coder-agent-$(CODER_NAME)-$$$$ >>/tmp/coder-agent-startup-$$$$.log 2>&1

coder-ssh-envbuilder:
	docker rm -f "$(CODER_NAME)" || true
	docker run --rm -d --sysctl net.ipv6.conf.all.disable_ipv6=1 \
		--name "$(CODER_NAME)" \
		--privileged \
		--dns 1.1.1.1 \
		-v envbuilder-image:/image-cache:ro \
		-v envbuilder-layer:/layer-cache \
		-v /nix:/nix \
		-v /dev/net/tun:/dev/net/tun \
		-v $(shell if test $$(uname -s) == Darwin; then echo $$HOME/.docker/run/docker.sock; else echo /var/run/docker.sock; fi):/var/run/docker.sock \
		-v $(shell ls -d ~ | cut -d/ -f1-2):/workspaces \
		-v $(shell ls -d ~ | cut -d/ -f1-2):/home \
		-e LAYER_CACHE_DIR=/layer-cache \
		-e BASE_IMAGE_CACHE_DIR=/image-cache \
		-e GIT_URL=https://$(domain)/defn/dev \
		-e DOCKERFILE_PATH=$(shell echo "$(CODER_HOMEDIR)" | sed 's#/home/ubuntu/##')/Dockerfile \
		-e CODER_NAME=$(CODER_NAME) \
		-e CODER_HOMEDIR=$(CODER_HOMEDIR) \
		-e ALT_CODER_AGENT_URL=$(ALT_CODER_AGENT_URL) \
		-e CODER_AGENT_URL=$(CODER_AGENT_URL) \
		-e CODER_AGENT_TOKEN=$(CODER_AGENT_TOKEN) \
		-e CODER_INIT_SCRIPT_BASE64=$(CODER_INIT_SCRIPT_BASE64) \
		-e TS_AUTH_KEY=$(TS_AUTH_KEY) \
		-e INIT_COMMAND="/bin/bash" \
		-e INIT_SCRIPT="source ~/.bash_profile && screen -dmS tailscale sudo $$(which tailscaled) && while true; do if sudo $$(which tailscale) up --auth-key $${TS_AUTH_KEY} --hostname $${CODER_NAME} --reset --ssh --advertise-tags tag:junkernetes --accept-routes; then break; fi; sleep 1; done && cd ~/m && source ~/.bash_profile && exec tini ~/bin/j coder::coder-agent" \
		ghcr.io/coder/envbuilder:0.2.9

coder-ssh-devcontainer:
	source ~/.bash_profile && cd m && npm install
	-source ~/.bash_profile && cd $(CODER_HOMEDIR) && docker ps -q -a --filter label=devcontainer.local_folder=$$(pwd) | runmany 'docker rm -f $$1 2>/dev/null'
	source ~/.bash_profile && cd $(CODER_HOMEDIR) && devcontainer build --workspace-folder . --config ~/m/.devcontainer/devcontainer.json
	source ~/.bash_profile && cd $(CODER_HOMEDIR) && devcontainer up --workspace-folder . --config ~/m/.devcontainer/devcontainer.json
	source ~/.bash_profile && cd $(CODER_HOMEDIR) && devcontainer exec --workspace-folder . --config ~/m/.devcontainer/devcontainer.json \
		env \
			CODER_NAME=$(CODER_NAME) \
			CODER_HOMEDIR=$(CODER_HOMEDIR) \
			CODER_AGENT_URL=$(CODER_AGENT_URL) \
			CODER_AGENT_TOKEN=$(CODER_AGENT_TOKEN) \
			CODER_INIT_SCRIPT_BASE64=$(CODER_INIT_SCRIPT_BASE64) \
			http_proxy=http://169.254.32.1:3128 \
			https_proxy=http://169.254.32.1:3128 \
			bash -c "cd ~/m && exec j coder::coder-agent $(CODER_NAME)" &

coder-ssh-darwin:
	@pkill -9 -f coder.agen[t] || true
	@pkill -9 -f code-serve[r] || true
	@export STARSHIP_NO=1 && source ~/.bash_profile && echo $(CODER_INIT_SCRIPT_BASE64) | base64 -d | exec bash -x -

coder-ssh-chromebook:
	@pkill -9 -f coder.agen[t] || true
	@pkill -9 -f code-serve[r] || true
	@export STARSHIP_NO=1 && source ~/.bash_profile && echo $(CODER_INIT_SCRIPT_BASE64) | base64 -d | exec bash -x -

build-site-default:

install-site-default:

init-gpg-default:

login-site-default:

manage-site-default:

%: %-default
	@true

-include ~/.password-store/Makefile
	
