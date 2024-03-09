SHELL := /bin/bash


# https://nixos.org/download
NIX_VERSION := 2.20.5

flakes ?= az home nix secrets utils development cloud kubernetes remotedev localdev godev jsdev pydev rustdev shell

build:
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
	for ip in $(dummy_ip); do if ! ifconfig lo0 | grep "inet $$ip"; then sudo -A ifconfig lo0 alias "$$ip" netmask 255.255.255.255; fi; done;
	ifconfig lo0
	defaults write -g ApplePressAndHoldEnabled -bool false
#	sudo -A ln -nfs ~/.docker/run/docker.sock /var/run/docker.sock
#	while true; do if docker ps; then break; fi; sleep 5; done
#	-docker context create host --docker host=unix:///var/run/docker.sock
#	-docker network create dev
#	docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock ubuntu chown 1000:1000 /var/run/docker.sock

cache:
	$(MARK) cache
	set -eo pipefail; for n in $(flakes); do \
		mark $$n; \
		(cd m/pkg/$$n && nix build && n cache && b build); \
		done

rehome:
	this-nix-gc
	rm -f bin/nix/.head-*
	$(MAKE) home

home:
	t make_home_inner env NIX_CONFIG="access-tokens = github.com=$$(b github)" $(MAKE) home_inner

home_inner:
	$(MARK) home
	for n in $(flakes); do \
		if [[ "$$(git log -1 --format=%H -- m/pkg/$$n)" != "$$(cat ~/bin/nix/.head-$$n 2>/dev/null || true)" ]]; then \
			git log -1 --format=%H -- m/pkg/$$n; \
			cat ~/bin/nix/.head-$$n || true; \
			rm -rf ~/bin/nix.tmp; \
			mkdir -p ~/bin/nix.tmp ~/bin/nix; \
			set -eo pipefail; for n in $(flakes); do \
				export n; \
				t install_flake_$$n $(MAKE) install_flake; \
				done; \
			ln -nfs bazelisk ~/bin/nix.tmp/bazel; \
			rsync -ia --delete ~/bin/nix.tmp/. ~/bin/nix/.; \
			rm -rf ~/bin/nix.tmp; \
			break; \
		fi; \
		done

install_flake:
	mark $$n
	(cd m/pkg/$$n && ~/bin/b build flake_path)
	(cd m/pkg/$$n && ~/bin/b out flake_path) | (cd ~/bin/nix.tmp && tar xfz -)
	for a in ~/bin/nix.tmp/*; do if ! test -e $$a; then mark not found $$a; (set -x; cd m/pkg/$$n && ~/bin/b build flake_store && (~/bin/b out flake_store | (cd / && sudo tar xfz - --skip-old-files))); break; fi; done
	git log -1 --format=%H -- m/pkg/$$n > ~/bin/nix.tmp/.head-$$n

dotfiles:
	$(MARK) configure dotfiles
	mkdir -p ~/work/dotfiles
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		if ! test -d ~/work/dotfiles/.git/.; then \
			t git_clone_dotfiles git clone git@github.com:$${GIT_AUTHOR_NAME}/dotfiles ~/work/dotfiles; \
		fi; \
		mkdir -p ~//work/.codespaces/.persistedshare; \
		mkdir -p ~/.config/coderv2; \
		rm -rf ~/work/.codespaces/.persistedshare/dotfiles; \
		rm -rf ~/.config/coderv2/dotfiles; \
		rm -rf ~/.dotfiles; \
		ln -nfs ~/work/dotfiles ~/work/.codespaces/.persistedshare/dotfiles; \
		ln -nfs ~/work/dotfiles ~/.config/coderv2/dotfiles; \
		ln -nfs ~/work/dotfiles ~/.dotfiles; \
		t dofiles_bootstrap ./.dotfiles/bootstrap; \
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
	t make_perms $(MAKE) perms
	if [[ "$(shell uname -s)" == "Darwin" ]]; then t make_macos $(MAKE) macos; fi

docker:
	$(MARK) docker
	docker context create pod --docker host=tcp://localhost:2375 || true \
		&& docker context create host --docker host=unix:///var/run/docker.sock || true \
		&& docker context use host

trunk:
	$(MARK) trunk
	trunk install
	git checkout .local/share/code-server/User/settings.json

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
	cd .dotfiles && git pull
	cd .password-store && git pull

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
	cd m/pb && $(MAKE) base_ubuntu opt="-i inventory/packer.ini -e ansible_connection=local"

upgrade:
	cd m/pb && $(MAKE) upgrade opt="-i inventory/packer.ini -e ansible_connection=local"

install:
	t make_install $(MAKE) install_t

install_t: m/.bazelrc.user
	sudo true
	t make_nix $(MAKE) nix
	t install_inner $(MAKE) install-inner
	@mark finished

m/.bazelrc.user:
	t default_bazelrc_user cp m/.example.bazelrc.user m/.bazelrc.user

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
# TODO macOS nix profile install nixpkgs#nix
	(. ~/.nix-profile/etc/profile.d/nix.sh && which nix) || t make_nix_platform $(MAKE) nix-$(shell uname -s)
	. ~/.nix-profile/etc/profile.d/nix.sh && (test -f "$$HOME/.nix-profile/share/nix-direnv/direnvrc" || t nix_profile_direnv nix profile install nixpkgs#nix-direnv)

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
	true

# https://github.com/NixOS/nixpkgs/blob/9f0d9ad45c4bd998c46ba1cbe0eb0dd28c6288a5/pkgs/tools/package-management/nix/default.nix
# look for the stable version
nix-Linux-bootstrap:
	t curl_bash_nix_install sh <(curl -L https://releases.nixos.org/nix/nix-$(NIX_VERSION)/install) --no-daemon
	git checkout .bash_profile

nix-Darwin-bootstrap:
	ln -nfs  /nix/var/nix/profiles/default ~/.nix-profile

build-site-default:

install-site-default:

init-gpg-default:

login-site-default:

manage-site-default:

%: %-default
	@true

-include ~/.password-store/Makefile
