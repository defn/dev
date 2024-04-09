# Lock gpg-agent
[no-cd]
lock:
	@gpg-connect-agent reloadagent /bye

# Reverse-proxy gpg-agent from home
[no-cd]
agent +args:
	#!/usr/bin/env bash
	set -exfuo pipefail

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
		rm -f ~/.gnupg/S.*agent*
	)
	if ! pgrep dirmngr >/dev/null; then dirmngr --daemon >/dev/null || true; fi
	set +u
	if [[ -n ${CODER-} ]]; then
		setsid coder gitssh -- home -o LocalForward="$HOME/.gnupg/S.gpg-agent /home/ubuntu/.gnupg/S.gpg-agent.extra" 1>/dev/null 2>&1 &
		bg_pid=$!
	else
		setsid ssh home -o LocalForward="$HOME/.gnupg/S.gpg-agent /home/ubuntu/.gnupg/S.gpg-agent.extra" 1>/dev/null 2>&1 &
		bg_pid=$!
	fi
	trap 'kill -SIGTERM -${bg_pid}' EXIT

	while [[ "$(pass hello 2>/dev/null || true)" != "world" ]]; do sleep 1; done

	{{args}}

# Forward gpg-agent socket to remote host
forward remote *args:
	#!/usr/bin/env bash
	set -exfuo pipefail

	a=$(date +%s)
	ssh "{{remote}}" ln -nfs "/tmp/S.gpg-agent.${a}" /home/ubuntu/.gnupg/S.gpg-agent
	ssh -v "{{remote}}" -N -o ServerAliveInterval=30 -o RemoteForward="/tmp/S.gpg-agent.${a} ${HOME}/.gnupg/S.gpg-agent.extra" {{args}}
