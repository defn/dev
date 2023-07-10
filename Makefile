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

MARK = $(shell which mark || echo echo)

update:
	cd m/pkg && $(MAKE) update
	cd m/pkg && n upgrade && n all update pkg deps
	cd m/pkg && n upgrade && n all update pkg deps || true
	$(MAKE) install

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

home:
	$(MARK) home
	(. ~/.nix-profile/etc/profile.d/nix.sh && cd m/aws && ~/bin/b build)
	(. ~/.nix-profile/etc/profile.d/nix.sh && cd m/pkg/home && ~/bin/b build flake_path && ~/bin/b out flake_path) >bin/nix/.path
	(for a in $$(cat bin/nix/.path | tr : "\n" | perl -e 'print reverse <>'); do for b in $$a/*; do if test -x "$$b"; then if [[ "$$(readlink "bin/nix/$$b{##*/}" || true)" != "$$b" ]]; then ln -nfs "$$b" bin/nix/; fi; fi; done; done)
	rm -f bin/nix/{gcc,cc,ld}
	if test -x /opt/homebrew/opt/util-linux/bin/flock; then ln -nfs /opt/homebrew/opt/util-linux/bin/flock bin/nix/; fi

dotfiles:
	$(MARK) dotfiles
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		if ! test -d ~/.dotfiles/.git/.; then \
			git clone https://github.com/$${GIT_AUTHOR_NAME}/dotfiles ~/.dotfiles; \
		fi; \
		mkdir -p ~/.dotfiles; \
		mkdir -p ~/.config/coderv2/dotfiles; \
		mkdir -p ~//work/.codespaces/.persistedshare; \
		rm -rf ~/work/.codespaces/.persistedshare/dotfiles; \
		rm -rf ~/.config/coderv2/dotfiles; \
		ln -nfs ~/.dotfiles ~/work/.codespaces/.persistedshare/dotfiles; \
		ln -nfs ~/.dotfiles ~/.config/coderv2/dotfiles; \
		(cd ~/.dotfiles && ./bootstrap); \
	fi

password-store:
	$(MARK) configure password-store
	mkdir -p ~/work/password-store
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		if ! test -d ~/work/password-store/.git/.; then \
			git clone https://github.com/$${GIT_AUTHOR_NAME}/password-store ~/work/password-store; \
		fi; \
	fi

gpg:
	$(MARK) configure gpg
	if test -d ~/.password-store/config/gnupg-config/.; then rsync -ia ~/.password-store/config/gnupg-config/. ~/.gnupg/.; fi
	$(MAKE) perms
	if [[ "$(shell uname -s)" == "Darwin" ]]; then $(MAKE) macos; fi
	if test -d /run/user; then \
		rm -rf /run/user/1000/gnupg; \
		ln -nfs ~/.gnupg /run/user/1000/gnupg; \
		fi
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
	bash -x bin/persist-cache
	echo "token_helper=\"$(which vault-token-helper)\"" > ~/.vault

perms:
	$(MARK) configure permissions
	if [[ "Linux" == "$(shell uname -s)" ]]; then if test -S /var/run/docker.sock; then sudo chgrp ubuntu /var/run/docker.sock; sudo chmod 770 /var/run/docker.sock; fi; fi
	if test -S /run/containerd/containerd.sock; then sudo chgrp ubuntu /run/containerd/containerd.sock; sudo chmod 770 /run/containerd/containerd.sock; fi
	-chmod 0700 ~/.gnupg/. ~/.gnupg2/.
	-if ! test -f ~/.kube/config; then touch ~/.kube/config; fi
	-chmod 0600 ~/.kube/config

ci dev:
	cd m && b server defn-defn-sso env FLY_API_TOKEN=$$(pass FLY_API_TOKEN) bash -c 'cd; cd m; $(MAKE) $@'

install:
	$(MAKE) nix
	$(MAKE) install-inner

install-inner:
	$(MAKE) symlinks
	$(MAKE) perms
	$(MAKE) home
	$(MAKE) trunk

	. ~/.bash_profile && . ~/.envrc && $(MAKE) install-innermost

install-innermost:
	git config lfs.https://github.com/defn/dev.git/info/lfs.locksverify false
	$(MAKE) dotfiles
	$(MAKE) password-store
	$(MAKE) gpg

nix-Darwin-upgrade:
	sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'

nix:
	(. ~/.nix-profile/etc/profile.d/nix.sh && which nix) || $(MAKE) nix-$(shell uname -s)
	. ~/.nix-profile/etc/profile.d/nix.sh && (which nix && (which cachix || nix profile install nixpkgs#cachix))
	. ~/.nix-profile/etc/profile.d/nix.sh && (which nix && (test -f "$$HOME/.nix-profile/share/nix-direnv/direnvrc" || nix profile install nixpkgs#nix-direnv))

nix-clean:
	rm -rf .nix-profile .local/state/nix/profiles/profile

nix-Linux:
	export LC_ALL=C.UTF-8 && if ! type -P nix; then $(MAKE) nix-Linux-bootstrap; fi

nix-Darwin:
	#nix profile install github:NixOS/nixpkgs\#nix
	true

nix-Linux-bootstrap:
	sh <(curl -L https://releases.nixos.org/nix/nix-2.16.0/install) --no-daemon
	git checkout .bash_profile

nix-Darwin-bootstrap:
	sh <(curl -L https://releases.nixos.org/nix/nix-2.16.0/install) --darwin-use-unencrypted-nix-store-volume --daemon
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