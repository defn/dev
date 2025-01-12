mod github 'm/common/github.Justfile'
mod playbook 'm/common/playbook.Justfile'
mod gpg 'm/common/gpg.Justfile'
mod lib 'm/common/lib.Justfile'

chromebook-coder:
  make chrome-dev-gpg
  screen -dmS coder make chrome-dev-coder 
  screen -dmS socat make chrome-dev-socat

chromebook-openvpn:
  screen -dmS openvpn make vpn

create-coder-agent:
	#!/usr/bin/env bash

	cd m
	just coder::coder-agent "${CODER_NAME}" 2>/dev/null 1>/dev/null &

create-coder-agent-sync workdir:
	#!/usr/bin/env bash

	(
		cd ~/m
		setsid j coder::code-server "${CODER_NAME}" >>/tmp/code-server.log 2>&1 &
	) &

	(
		cd "{{workdir}}"
		mise trust -a
		sleep 10
		mise install
		setsid screen -dmS up bash -c "cd; source .bash_profile; cd \"{{workdir}}\"; m up; sleep infinity"
	) &

	cd m
	exec just coder::coder-agent "${CODER_NAME}"

destroy-coder-agent:
	#!/usr/bin/env bash

	for p in $(pgrep -f "just.coder::code.serve[r].${CODER_NAME}"'$'); do
	  ps x -o ppid,pgid | tail -n +2 | sed 's#^  *##g' | grep "^$p " | awk '{print $2}' | while read -r g; do 
	    kill -9 -$g
	  done
	done

dyff *args:
	@just github::dyff {{args}}

play pb *lim:
	#!/usr/bin/env bash

	if ! test -x ~/.local/bin/ansible-playbook; then
		pipx install --force --include-deps ansible 
	fi
	just playbook::playbook {{pb}} {{lim}}

command pattern *args:
	just playbook::command {{pattern}} {{args}}

upgrade *args:
	just play upgrade {{ args }}

cache *args="cache:!pc":
	just play cache {{ args }}

home *args="all:!kinko":
	just play home {{ args }}

all *args="all":
	just cache cache
	just home cache
	just home "{{ args }}:!cache"
