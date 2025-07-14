# Lock gpg-agent
# Description: Reloads gpg-agent, effectively locking it and clearing cached passphrases
# Dependencies: gpg-connect-agent
# Outputs: Clears gpg-agent cache
[no-cd]
lock:
	@gpg-connect-agent reloadagent /bye

# Reverse-proxy gpg-agent from home
# Description: Sets up GPG agent forwarding from home machine via SSH tunnel
# Dependencies: ssh, coder (if in Coder env), pass, gpg, dirmngr
# Outputs: Establishes GPG agent socket forwarding and validates with pass hello
[no-cd]
agent *args:
	#!/usr/bin/env bash
	set -efuo pipefail

	if ! test -d ~/.password-store/.; then (cd && make password-store); fi
	if ! test -d ~/dotfiles/.; then (cd && make dotfiles); fi
	if test -d /run/user; then
		sudo rm -rf /run/user/1000/gnupg
		sudo install -d -m 0700 -o $(id -un) -g $(id -gn) /run/user/1000
		ln -nfs ~/.gnupg /run/user/1000/gnupg
	fi
	chmod 0700 ~/.gnupg/. ~/.gnupg2/. ~/.ssh
	chmod 0600 ~/.ssh/config
	(
		set +f
		if test -d ~/dotfiles/.gnupg; then
			rsync -ia ~/dotfiles/.gnupg/* ~/.gnupg/
		fi
	)
	(
		set +f
		rm -rf ~/.gnupg/S.*agent*
	)
	if ! pgrep dirmngr >/dev/null; then dirmngr --daemon >/dev/null || true; fi
	set +u
	if [[ -n ${CODER-} ]]; then
		setsid coder gitssh -- home -o LocalForward="$HOME/.gnupg/S.gpg-agent /home/ubuntu/.gnupg/S.gpg-agent.extra" sleep infinity 1>/dev/null 2>&1 &
		bg_pid=$!
	else
		setsid ssh home -o LocalForward="$HOME/.gnupg/S.gpg-agent /home/ubuntu/.gnupg/S.gpg-agent.extra" sleep infinity 1>/dev/null 2>&1 &
		bg_pid=$!
	fi
	trap 'kill -SIGTERM -${bg_pid}' EXIT

	while [[ "$(pass hello 2>/dev/null || true)" != "world" ]]; do sleep 5; done

	if test -n "{{args}}"; then
		true
		{{args}}
	else
		pass hello	
		sleep infinity
	fi

# Forward gpg-agent socket to remote host
# Description: Forwards local GPG agent socket to a remote host via SSH
# Dependencies: ssh, gpg-agent running locally
# Outputs: Creates GPG agent socket on remote host at /tmp/S.gpg-agent.{timestamp}
forward remote *args:
	#!/usr/bin/env bash
	set -exfuo pipefail

	a=$(date +%s)
	ssh "{{remote}}" ln -nfs "/tmp/S.gpg-agent.${a}" /home/ubuntu/.gnupg/S.gpg-agent
	ssh -v "{{remote}}" -N -o ServerAliveInterval=30 -o RemoteForward="/tmp/S.gpg-agent.${a} ${HOME}/.gnupg/S.gpg-agent.extra" {{args}}
