SHELL := /bin/bash

NIX_VERSION := 2.19.2

flakes ?= home oci nix secrets utils vpn acme godev nodedev localdev development cloud kubernetes remotedev shell

build:
	cd m/toc & $(MAKE) build

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
	set -xeo pipefail; for n in $(flakes); do \
		mark $$n; \
		(cd m/pkg/$$n && ~/bin/b build && nix build && n cache defn); \
		done

home:
	$(MARK) home
	if [[ "$$(git log m/pkg | head -1 | awk '{print $$2}')" != "$$(cat bin/nix/.head)" ]]; then \
		set -xeo pipefail; for n in $(flakes); do \
			mark $$n; \
			(cd m/pkg/$$n && ~/bin/b build && nix build); \
			(cd m/pkg/$$n && ~/bin/b out flake_path) | (cd ~/bin/nix && tar xfz -); \
			done; \
	fi
	rm -f bin/nix/{gcc,cc,ld,clang}
	sudo -A ln -nfs ~/bin/nix/go /usr/local/bin/
	sudo -A ln -nfs /home/ubuntu/.nix-profile/bin/nix-instantiate /usr/local/bin/
	if test -x /opt/homebrew/opt/util-linux/bin/flock; then ln -nfs /opt/homebrew/opt/util-linux/bin/flock bin/nix/; fi
	ln -nfs ~/.nix-profile/bin/nix bin/nix/nix

dotfiles:
	$(MARK) configure dotfiles
	mkdir -p ~/work/dotfiles
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		if ! test -d ~/work/dotfiles/.git/.; then \
			git clone git@github.com:$${GIT_AUTHOR_NAME}/dotfiles ~/work/dotfiles; \
		fi; \
		mkdir -p ~//work/.codespaces/.persistedshare; \
		mkdir -p ~/.config/coderv2; \
		rm -rf ~/work/.codespaces/.persistedshare/dotfiles; \
		rm -rf ~/.config/coderv2/dotfiles; \
		rm -rf ~/.dotfiles; \
		ln -nfs ~/work/dotfiles ~/work/.codespaces/.persistedshare/dotfiles; \
		ln -nfs ~/work/dotfiles ~/.config/coderv2/dotfiles; \
		ln -nfs ~/work/dotfiles ~/.dotfiles; \
		(./.dotfiles/bootstrap); \
	fi

password-store:
	$(MARK) configure password-store
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		if ! test -d ~/work/password-store/.git/.; then \
			rm -rf ~/work/pssword-store; \
			mkdir -p ~/work/password-store; \
			git clone git@github.com:$${GIT_AUTHOR_NAME}/password-store ~/work/password-store; \
		fi; \
	fi

gpg:
	$(MARK) configure gpg
	if test -d ~/.password-store/config/gnupg-config/.; then rsync -ia ~/.password-store/config/gnupg-config/. ~/.gnupg/.; fi
	$(MAKE) perms
	if [[ "$(shell uname -s)" == "Darwin" ]]; then $(MAKE) macos; fi
	if test -d /run/user; then \
		sudo rm -rf /run/user/1000/gnupg; \
		sudo install -d -m 0700 -o $$(id -un) -g $$(id -gn) /run/user/1000; \
		ln -nfs ~/.gnupg /run/user/1000/gnupg; \
		fi
	pkill dirmngr 2>/dev/null || true
	dirmngr --daemon || true

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
	bin/persist-cache

perms:
	$(MARK) configure permissions
	if [[ "Linux" == "$(shell uname -s)" ]]; then if test -S /var/run/docker.sock; then sudo chgrp ubuntu /var/run/docker.sock; sudo chmod 770 /var/run/docker.sock; fi; fi
	if test -S /run/containerd/containerd.sock; then sudo chgrp ubuntu /run/containerd/containerd.sock; sudo chmod 770 /run/containerd/containerd.sock; fi
	-chmod 0700 ~/.gnupg/. ~/.gnupg2/.
	-if ! test -f ~/.kube/config; then mkdir -p ~/.kube; touch ~/.kube/config; fi
	-chmod 0600 ~/.kube/config

reinstall:
	rm -f bin/nix/.head
	cd m && b clean
	this-nix-gc
	$(MAKE) install

install:
	$(MAKE) nix
	$(MAKE) install-inner
	git log m/pkg | head -1 | awk '{print $$2}' > bin/nix/.head
	@mark finished

install-inner:
	$(MAKE) symlinks
	$(MAKE) perms
	. ~/.bash_profile && $(MAKE) install-innermost
	$(MAKE) home

install-innermost:
	git config lfs.https://github.com/defn/dev.git/info/lfs.locksverify false
	git config diff.lfs.textconv cat
	if [[ "$$(git log m/pkg | head -1 | awk '{print $$2}')" != "$$(cat bin/nix/.head)" ]]; then $(MAKE) dotfiles; fi
	$(MAKE) password-store
	$(MAKE) gpg

nix-Darwin-upgrade:
	sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'

nix:
	(. ~/.nix-profile/etc/profile.d/nix.sh && which nix) || $(MAKE) nix-$(shell uname -s)
	. ~/.nix-profile/etc/profile.d/nix.sh && (which cachix || nix profile install nixpkgs#cachix)
	. ~/.nix-profile/etc/profile.d/nix.sh && (test -f "$$HOME/.nix-profile/share/nix-direnv/direnvrc" || nix profile install nixpkgs#nix-direnv)

nix-reinstall:
	rm -rf .nix-* .local/state/nix
	$(MAKE) nix

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
	export LC_ALL=C.UTF-8 && if ! type -P nix; then $(MAKE) nix-Linux-bootstrap; fi

nix-Darwin:
	if ! type -P nix; then $(MAKE) nix-Darwin-bootstrap; fi
	sudo ln -nfs /nix/var/nix/profiles/default/etc ~/.nix-profile/etc
	sudo launchctl stop org.nixos.nix-daemon
	sudo cp .config/nix/nix.conf /etc/nix/
	sudo launchctl start org.nixos.nix-daemon

# https://github.com/NixOS/nixpkgs/blob/9f0d9ad45c4bd998c46ba1cbe0eb0dd28c6288a5/pkgs/tools/package-management/nix/default.nix
# look for the stable version
# nix profile install nixpkgs/9f0d9ad45c4bd998c46ba1cbe0eb0dd28c6288a5#nix
nix-Linux-bootstrap:
	sh <(curl -L https://releases.nixos.org/nix/nix-$(NIX_VERSION)/install) --no-daemon
	git checkout .bash_profile

nix-Darwin-bootstrap:
	sh <(curl -L https://releases.nixos.org/nix/nix-$(NIX_VERSION)/install) --darwin-use-unencrypted-nix-store-volume --daemon
	git checkout .bash_profile

build-site-default:

install-site-default:

init-gpg-default:

login-site-default:

manage-site-default:

%: %-default
	@true

-include ~/.password-store/Makefile
