SHELL := /bin/bash

name ?= local
domain ?= defn.run

dummy_ip ?= 169.254.32.1

first = $(word 1, $(subst -, ,$@))
second = $(word 2, $(subst -, ,$@))
first_ = $(word 1, $(subst _, ,$@))
second_ = $(word 2, $(subst _, ,$@))

MARK = $(shell which mark || echo echo)

no-gpg:
	systemctl --user enable gpg-agent-browser.socket --now || true
	systemctl --user enable gpg-agent-extra.socket --now || true
	systemctl --user enable gpg-agent-ssh.socket --now || true
	systemctl --user enable gpg-agent.socket --now || true
	systemctl --user enable gpg-agent --now || true
	pkill -9 gpg-agent || true

chrome-dev-gpg:
	sudo systemctl restart pcscd.service pcscd.socket polkit.service
	$(MAKE) no-gpg
	gpg-agent --daemon --pinentry-program $$(which pinentry)
	while [[ "$$(pass hello)" != "world" ]]; do sleep 1; done

chrome-dev-dns:
	touch ~/.config/cloudflare-ddns.toml 
	cloudflare-ddns --domain $(domain) --record '*.$(name).$(domain)' --ip "$$(ip addr show eth0 | grep 'inet ' | awk '{print $$2}' | cut -d/ -f1)" --token "$$(pass cloudflare_$(domain))" --config ~/.config/cloudflare-ddns.toml 

macos-reinstall:
	sudo rm -rf /Library/Developer/CommandLineTools
	/usr/bin/xcode-select --install

macos:
	$(MARK) macos
	for ip in $(dummy_ip); do if ! ifconfig lo0 | grep "inet $$ip"; then sudo ifconfig lo0 alias "$$ip" netmask 255.255.255.255; fi; done;
	ifconfig lo0
	defaults write -g ApplePressAndHoldEnabled -bool false

.PHONY: dotfiles
dotfiles:
	$(MARK) configure dotfiles
	rm -rf ~/.dotfiles
	mkdir -p ~/dotfiles
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		if ! test -d ~/dotfiles/.git/.; then \
			rm -rf ~/dotfiles; \
			t git_clone_dotfiles git clone https://github.com/$${GIT_AUTHOR_NAME}/dotfiles ~/dotfiles; \
		else \
			(cd dotfiles && git pull); \
		fi; \
		t dotfiles_bootstrap ./dotfiles/bootstrap; \
	fi

password-store:
	$(MARK) configure password-store
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		if ! test -d ~/work/password-store/.git/.; then \
			rm -rf ~/work/pssword-store; \
			mkdir -p ~/work/password-store; \
			t git_clone_password_store git clone https://github.com/$${GIT_AUTHOR_NAME}/password-store ~/work/password-store; \
		fi; \
	fi

gpg:
	$(MARK) configure gpg
	dirmngr --shutdown || true
	dirmngr --daemon
	if [[ "$(shell uname -s)" == "Darwin" ]]; then $(shell which gpg-agent) --daemon --pinentry-program $$(which pinentry-mac); fi

trunk:
	@$(MARK) trunk
	@if ! type -P trunk >/dev/null; then curl https://get.trunk.io -fsSL | sed 's#/usr/local/bin#$$HOME/bin/$$(uname -s)#' | bash; fi
	@trunk version || true
	@sudo rm -f /usr/local/bin/trunk
	@git checkout .local/share/code-server/User/settings.json

install:
	t make_install $(MAKE) install_t

install_t:
	t make_mise $(MAKE) mise
	t make_trunk $(MAKE) trunk || true # sudo
	t install_inner $(MAKE) install-inner
	@mark finished

install-inner:
	t make_install_innermost bash -c '. ~/.bash_profile && $(MAKE) install-innermost'

install-innermost:
	git config lfs.https://github.com/defn/dev.git/info/lfs.locksverify false
	git config diff.lfs.textconv cat
	t make_dotfiles $(MAKE) dotfiles
	t make_gpg $(MAKE) gpg

mise:
	if [[ ! -x ~/.local/bin/mise ]]; then curl -sSL https://mise.run | bash; fi
	~/.local/bin/mise trust
	~/.local/bin/mise install

zfs:
	sudo zfs destroy defn/nix@latest || true
	sudo zfs destroy defn/work@latest || true
	sudo zfs destroy defn/docker@latest || true

	(cd ~/m && b clean)

	sudo zfs snapshot defn/nix@latest
	sudo zfs snapshot defn/work@latest

	tar cfz - bin/nix .nix* .local/state/nix | pv | s5cmd pipe s3://dfn-defn-global-defn-org/zfs/nix.tar.gz
	sudo zfs send defn/nix@latest | pv | s5cmd pipe s3://dfn-defn-global-defn-org/zfs/nix.zfs
	sudo zfs send defn/work@latest | pv | s5cmd pipe s3://dfn-defn-global-defn-org/zfs/work.zfs

	sudo systemctl daemon-reload

	sudo systemctl stop docker.socket
	sudo systemctl stop docker
	sudo umount /var/lib/docker

	sudo zfs destroy defn/docker@latest || true
	sudo zfs destroy defn/docker || true

	sudo zfs create -s -V 100G defn/docker
	sudo mkfs.ext4 /dev/zvol/defn/docker
	sudo mount /dev/zvol/defn/docker /var/lib/docker

	sudo systemctl start docker.socket
	sudo systemctl start docker
	cd m/cache/docker && $(MAKE) init registry k3d
	sudo systemctl stop docker.socket
	sudo systemctl stop docker

	sudo zfs snapshot defn/docker@latest
	sudo zfs send defn/docker@latest | pv | s5cmd pipe s3://dfn-defn-global-defn-org/zfs/docker.zfs

	sudo systemctl start docker.socket
	sudo systemctl start docker
	k3d cluster start k3s-default

sync:
	git pull
	~/bin/with-env $(MAKE) sync_inner

fast:
	git pull
	~/bin/with-env $(MAKE) fast_inner

fast_inner:
	~/.local/bin/mise self-update --yes || true
	git ls-files | grep 'mise.toml$$' | ~/bin/runmany '~/.local/bin/mise trust $$1'
	~/.local/bin/mise install
	(cd m && ~/.local/bin/mise install)

sync_inner:
	if [[ "$(shell uname -s)" == "Linux" ]]; then t play-upgrade ~/.local/bin/mise run local upgrade; fi
	if [[ "$(shell uname -s)" == "Linux" ]]; then t play-ubuntu ~/.local/bin/mise run local ubuntu; fi
	$(MAKE) fast_inner
	if [[ "$(shell uname -s)" == "Linux" ]]; then t play-fixup ~/.local/bin/mise run local fixup; fi

mise-list:
	@(echo .; git grep [t]ools | grep [m]ise.toml | cut -d: -f1 | perl -pe 's{/mise.toml}{}') | runmany 'cd $$1 && pwd && mise upgrade --bump --dry-run' ; echo
	@(echo .; git grep [t]ools | grep [m]ise.toml | cut -d: -f1 | perl -pe 's{/mise.toml}{}') | runmany 'cd $$1 && pwd && mise upgrade --bump --dry-run' | grep -v ansible | grep 'Would bump' | while read -r a b tool c mfile; do echo mise use --cd "$$(dirname $$mfile)" $$tool; done | sort -u

