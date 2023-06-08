SHELL := /bin/bash

nix-ignore:
	@true

menu: # This menu
	@perl -ne 'printf("%20s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' $(shell ls -d Makefile2>/dev/null)

dummy_ip ?= 169.254.32.1

first = $(word 1, $(subst -, ,$@))
second = $(word 2, $(subst -, ,$@))
first_ = $(word 1, $(subst _, ,$@))
second_ = $(word 2, $(subst _, ,$@))

upgrade:
	cd m/pkg && $(MAKE) upgrade
	cd m/pkg && n upgrade && n all update pkg deps
	cd m && n upgrade && n release update m deps && n cache
	n upgrade && n release update home deps && n cache

macos:
	@mark macos
	-$(shell which gpg-agent) --daemon --pinentry-program $$(which pinentry-mac)
	for ip in $(dummy_ip); do if ! ifconfig lo0 | grep "inet $$ip"; then sudo -A ifconfig lo0 alias "$$ip" netmask 255.255.255.255; fi; done;
	ifconfig lo0
	defaults write -g ApplePressAndHoldEnabled -bool false
	sudo -A ln -nfs ~/.docker/run/docker.sock /var/run/docker.sock
	while true; do if docker ps; then break; fi; sleep 5; done
	-docker context create host --docker host=unix:///var/run/docker.sock
	-docker network create dev
	docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock ubuntu chown 1000:1000 /var/run/docker.sock

symlinks:
	@mark configure symlinks
	bash -x bin/persist-cache
	echo "token_helper=\"$(which vault-token-helper)\"" > ~/.vault

perms:
	@mark configure permissions
	if [[ "Linux" == "$(shell uname -s)" ]]; then if test -S /var/run/docker.sock; then sudo chgrp ubuntu /var/run/docker.sock; sudo chmod 770 /var/run/docker.sock; fi; fi
	if test -S /run/containerd/containerd.sock; then sudo chgrp ubuntu /run/containerd/containerd.sock; sudo chmod 770 /run/containerd/containerd.sock; fi
	-chmod 0700 ~/.gnupg/. ~/.gnupg2/.
	-if ! test -f ~/.kube/config; then touch ~/.kube/config; fi
	-chmod 0600 ~/.kube/config

install:
	$(MAKE) nix
	. ~/.nix-profile/etc/profile.d/nix.sh && bin/withde ~ env VAULT_TOKEN="$$(pass Initial_Root_Token 2>&- || true)" $(MAKE) install-inner

install-inner:
	$(MAKE) symlinks
	$(MAKE) perms

	@mark configure password-store
	mkdir -p ~/work/password-store
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		if ! test -d ~/work/password-store/.git/.; then \
			git clone https://github.com/$${GIT_AUTHOR_NAME}/password-store ~/work/password-store; \
		fi; \
	fi

	@mark configure gpg
	if test -d ~/.password-store/config/gnupg-config/.; then rsync -ia ~/.password-store/config/gnupg-config/. ~/.gnupg/.; fi
	$(MAKE) perms
	if [[ "$(shell uname -s)" == "Darwin" ]]; then $(MAKE) macos; fi
	dirmngr --daemon || true

	@mark dotfiles
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		mkdir -p ~/.dotfiles; \
		mkdir -p ~/.config/coderv2/dotfiles; \
		mkdir -p ~//work/.codespaces/.persistedshare; \
		rm -rf ~/work/.codespaces/.persistedshare/dotfiles; \
		rm -rf ~/.config/coderv2/dotfiles; \
		ln -nfs ~/.dotfiles ~/work/.codespaces/.persistedshare/dotfiles; \
		ln -nfs ~/.dotfiles ~/.config/coderv2/dotfiles; \
		(cd ~/.dotfiles && ./bootstrap); \
	fi

	@mark docker
	docker context create pod --docker host=tcp://localhost:2375 || true \
		&& docker context create host --docker host=unix:///var/run/docker.sock || true \
        && docker context use host

	@mark godev
	if echo "$${VSCODE_GIT_ASKPASS_NODE:-}" | grep ^/vscode; then \
		nix develop github:defn/dev/pkg-godev-0.0.80?dir=m/pkg/godev --command bash -c 'sudo ln -nfs "$$(which go)" "$${VSCODE_GIT_ASKPASS_NODE%/node}/bin/"'; \
		fi

	@mark doctor
	pass hello; echo; echo
	ssh-add -L; echo; echo

	@mark up
	this-up
	while true; do vault status; if [[ "$$?" == 1 ]]; then sleep 5; continue; fi; break; done
	this-login

nix-Darwin-upgrade:
	sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'

nix:
	. ~/.nix-profile/etc/profile.d/nix.sh && (which nix || $(MAKE) nix-$(shell uname -s))
	. ~/.nix-profile/etc/profile.d/nix.sh && (which nix && (which cachix || nix profile install nixpkgs#cachix))
	. ~/.nix-profile/etc/profile.d/nix.sh && (which cachix && cachix use defn)
	. ~/.nix-profile/etc/profile.d/nix.sh && (which nix && (test -f "$$HOME/.nix-profile/share/nix-direnv/direnvrc" || nix profile install nixpkgs#nix-direnv))

nix-Linux:
	export LC_ALL=C.UTF-8 && if ! type -P nix; then $(MAKE) nix-Linux-bootstrap; fi

nix-Darwin:
	#nix profile install github:NixOS/nixpkgs\#nix
	true

nix-Linux-bootstrap:
	sh <(curl -L https://releases.nixos.org/nix/nix-2.15.0/install) --no-daemon
	git checkout .bash_profile

nix-Darwin-bootstrap:
	sh <(curl -L https://releases.nixos.org/nix/nix-2.15.0/install) --darwin-use-unencrypted-nix-store-volume --daemon
	git checkout .bash_profile

nix-reinstall:
	nix profile list | tail -n +2 | awk '{print $$NF}' | xargs nix profile remove
	$(MAKE) nix

build-site-default:

install-site-default:

init-gpg-default:

login-site-default:

manage-site-default:

%: %-default
	@true

-include ~/.password-store/Makefile
