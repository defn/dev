SHELL := /bin/bash

name ?= local
domain ?= defn.run

dummy_ip ?= 169.254.32.1

first = $(word 1, $(subst -, ,$@))
second = $(word 2, $(subst -, ,$@))
first_ = $(word 1, $(subst _, ,$@))
second_ = $(word 2, $(subst _, ,$@))

MARK = $(shell which mark || echo echo)

# Disable and restart GPG agent services
# Dependencies: systemd user services, running GPG agent processes
# Outputs: Enabled GPG agent systemd sockets and services, killed existing GPG agent processes
no-gpg:
	systemctl --user enable gpg-agent-browser.socket --now || true
	systemctl --user enable gpg-agent-extra.socket --now || true
	systemctl --user enable gpg-agent-ssh.socket --now || true
	systemctl --user enable gpg-agent.socket --now || true
	systemctl --user enable gpg-agent --now || true
	pkill -9 gpg-agent || true

# Set up GPG for Chrome development environment
# Dependencies: systemd services (pcscd.service, pcscd.socket, polkit.service), pinentry binary, pass command, password store with 'hello' entry
# Outputs: Restarted system services, configured GPG agent daemon, verified password store access
chrome-dev-gpg:
	sudo systemctl restart pcscd.service pcscd.socket polkit.service
	$(MAKE) no-gpg
	gpg-agent --daemon --pinentry-program $$(which pinentry)
	while [[ "$$(pass hello)" != "world" ]]; do sleep 1; done

# Configure Cloudflare DNS for Chrome development
# Dependencies: ~/.config directory, cloudflare-ddns binary, eth0 network interface, pass command, cloudflare_$(domain) password entry
# Outputs: ~/.config/cloudflare-ddns.toml file, updated Cloudflare DNS records for *.$(name).$(domain)
chrome-dev-dns:
	touch ~/.config/cloudflare-ddns.toml
	cloudflare-ddns --domain $(domain) --record '*.$(name).$(domain)' --ip "$$(ip addr show eth0 | grep 'inet ' | awk '{print $$2}' | cut -d/ -f1)" --token "$$(pass cloudflare_$(domain))" --config ~/.config/cloudflare-ddns.toml

# Reinstall macOS Command Line Tools by removing and reinstalling them
# Dependencies: /Library/Developer/CommandLineTools directory, /usr/bin/xcode-select binary, macOS system
# Outputs: Removed /Library/Developer/CommandLineTools directory, triggered Command Line Tools installation dialog
macos-reinstall:
	sudo rm -rf /Library/Developer/CommandLineTools
	/usr/bin/xcode-select --install

# Configure macOS settings including loopback interface aliases and keyboard behavior
# Dependencies: mark binary, ifconfig command, defaults command, macOS system, lo0 interface
# Outputs: Mark log entry, configured loopback interface aliases for $(dummy_ip), displayed lo0 interface config, disabled press-and-hold for accented characters
macos:
	$(MARK) macos
	for ip in $(dummy_ip); do if ! ifconfig lo0 | grep "inet $$ip"; then sudo ifconfig lo0 alias "$$ip" netmask 255.255.255.255; fi; done;
	ifconfig lo0
	defaults write -g ApplePressAndHoldEnabled -bool false

dummy:
	$(MARK) dummy
	sudo ip addr add 169.254.32.1/32 dev lo || true
	ip addr show dev lo

# Clone and bootstrap user dotfiles from GitHub repository
# Dependencies: mark binary, GIT_AUTHOR_NAME environment variable, git command, t binary, internet connection
# Outputs: Mark log entry, removed ~/.dotfiles directory, created ~/dotfiles directory, cloned/updated dotfiles repository, executed bootstrap script
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

# Clone user's password-store repository from GitHub
# Dependencies: mark binary, GIT_AUTHOR_NAME environment variable, git command, t binary, ~/work directory, internet connection
# Outputs: Mark log entry, created ~/work/password-store directory, cloned password-store repository
password-store:
	$(MARK) configure password-store
	if test -n "$${GIT_AUTHOR_NAME:-}"; then \
		if ! test -d ~/work/password-store/.git/.; then \
			rm -rf ~/work/pssword-store; \
			mkdir -p ~/work/password-store; \
			t git_clone_password_store git clone https://github.com/$${GIT_AUTHOR_NAME}/password-store ~/work/password-store; \
		fi; \
	fi

# Configure GPG agent and daemon services
# Dependencies: mark binary, dirmngr binary, gpg-agent binary, pinentry-mac binary (on macOS)
# Outputs: Mark log entry, shutdown and restarted dirmngr daemon, started GPG agent daemon on macOS
gpg:
	$(MARK) configure gpg
	dirmngr --shutdown || true
	dirmngr --daemon
	if [[ "$(shell uname -s)" == "Darwin" ]]; then $(shell which gpg-agent) --daemon --pinentry-program $$(which pinentry-mac); fi

# Install or update Trunk.io code quality tool
# Dependencies: mark binary, curl command, trunk binary, git command, .local/share/code-server/User/settings.json file
# Outputs: Mark log entry, trunk binary installed in $HOME/bin/$(uname -s), removed /usr/local/bin/trunk, restored code-server settings.json
trunk:
	@$(MARK) trunk
	@if ! type -P trunk >/dev/null; then curl https://get.trunk.io -fsSL | sed 's#/usr/local/bin#$$HOME/bin/$$(uname -s)#' | bash; fi
	@trunk version || true
	@sudo rm -f /usr/local/bin/trunk
	@git checkout .local/share/code-server/User/settings.json

# Main installation target that orchestrates the full setup process
# Dependencies: t binary, make command
# Outputs: Executes install_t target with timing/logging wrapper
install:
	t make_install $(MAKE) install_t

# Run installation steps including mise, trunk, and inner install targets
# Dependencies: t binary, make command, mark binary
# Outputs: Executed mise, trunk, and install-inner targets with timing/logging, mark finished log entry
install_t:
	t make_mise $(MAKE) mise
	t make_trunk $(MAKE) trunk || true # sudo
	t install_inner $(MAKE) install-inner
	@mark finished

# Execute innermost installation with bash profile loaded
# Dependencies: t binary, bash command, ~/.bash_profile file, make command
# Outputs: Executed install-innermost target with loaded bash profile and timing/logging
install-inner:
	t make_install_innermost bash -c '. ~/.bash_profile && $(MAKE) install-innermost'

# Configure git settings and run dotfiles and GPG setup
# Dependencies: git command, t binary, make command
# Outputs: Configured git LFS settings, executed dotfiles and gpg targets with timing/logging
install-innermost:
	git config lfs.https://github.com/defn/dev.git/info/lfs.locksverify false
	git config diff.lfs.textconv cat
	t make_dotfiles $(MAKE) dotfiles
	t make_gpg $(MAKE) gpg

# Install mise runtime manager and trust/install configured tools
# Dependencies: curl command, internet connection, mise.toml files in current directory
# Outputs: Installed ~/.local/bin/mise binary, trusted mise configuration, installed all configured tools
mise:
	if [[ ! -x ~/.local/bin/mise ]]; then curl -sSL https://mise.run | bash; fi
	~/.local/bin/mise trust
	~/.local/bin/mise install

# Manage ZFS snapshots and backups for nix, work, and docker volumes
# Dependencies: sudo privileges, zfs command, ~/m directory with b binary, tar command, pv binary, s5cmd binary, systemctl command, mkfs.ext4 command, mount command, m/cache/docker/Makefile, k3d command, S3 bucket access, ZFS pools defn/nix, defn/work, defn/docker
# Outputs: Destroyed old ZFS snapshots, cleaned ~/m directory, created new ZFS snapshots, uploaded tar.gz and ZFS streams to S3, recreated Docker ZFS volume, restarted Docker services, initialized Docker cache, started k3s-default cluster
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

# Pull latest changes and run full sync including system updates
# Dependencies: git command, ~/bin/with-env script, make command
# Outputs: Updated git repository, executed sync_inner target with environment wrapper
sync:
	git pull
	~/bin/with-env $(MAKE) sync_inner

# Pull latest changes and run fast sync (mise updates only)
# Dependencies: git command, ~/bin/with-env script, make command
# Outputs: Updated git repository, executed fast_inner target with environment wrapper
fast:
	git pull
	~/bin/with-env $(MAKE) fast_inner

# Update mise and install tools from all mise.toml files
# Dependencies: ~/.local/bin/mise binary, git command, ~/bin/runmany script, mise.toml files in repository, m directory with mise.toml
# Outputs: Updated mise binary, trusted all mise.toml files in repository, installed tools from mise configurations
fast_inner:
	~/.local/bin/mise self-update --yes || true
	git ls-files | grep 'mise.toml$$' | ~/bin/runmany '~/.local/bin/mise trust $$1'
	~/.local/bin/mise install
	(cd m && ~/.local/bin/mise install)

# Run system upgrades and updates on Linux, then perform fast sync
# Dependencies: uname command, t binary, ~/.local/bin/mise binary, mise.toml files with local tasks (upgrade, ubuntu, fixup, macos), make command
# Outputs: Executed Linux system upgrade/ubuntu/fixup tasks via mise, performed fast_inner sync
sync_inner:
	~/.local/bin/mise trust
	~/.local/bin/mise install node python pipx ansible
	if [[ "$(shell uname -s)" == "Linux" ]]; then t play-upgrade ~/.local/bin/mise run local upgrade; fi
	if [[ "$(shell uname -s)" == "Linux" ]]; then t play-ubuntu ~/.local/bin/mise run local ubuntu; fi
	$(MAKE) fast_inner
	if [[ "$(shell uname -s)" == "Linux" ]]; then t play-fixup ~/.local/bin/mise run local fixup; fi
	if [[ "$(shell uname -s)" == "Darwin" ]]; then t play-macos ~/.local/bin/mise run local macos; fi

# List available mise tool updates across all mise.toml files in the repository
# Dependencies: git command, runmany script, perl command, mise binary, mise.toml files in repository
# Outputs: List of available mise tool updates formatted as commands to upgrade each tool
mise-list:
	@(echo .; git grep [t]ools | grep [m]ise.toml: | cut -d: -f1 | perl -pe 's{/mise.toml}{}') | runmany 'cd $$1 && pwd && mise upgrade --bump --dry-run' | grep 'Would bump' | while read -r a b tool c mfile; do echo mise use --cd "$$(dirname $$mfile)" $$tool; done | sort -u | sed 's# --cd ~/.config/mise##' | grep -v "mise use python@3.14" || true

