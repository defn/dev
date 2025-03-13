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
  cd ~/m
  source ~/.bash_profile
  mise run serve
  for a in $(env | grep ^CODER_ | cut -d= -f1); do printf 'export %s=%q\n\n' "$a" "$(echo "${!a}")"; done > svc.d/coder/.env
  ln -nfs ../svc.d/coder svc/
  s6-svscanctl -a svc
  s6-svc -r svc/coder
  rm -f svc.d/coder/down

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

create-coder-agent-sidecar:
	#!/usr/bin/env bash

	cd m
	exec just coder::coder-agent "${CODER_NAME}"

create-code-server-sidecar tutorial="":
	#!/usr/bin/env bash

	(
		cd "${CODER_HOMEDIR}"
		truncate -s 0 .app_up
		echo -n "{{tutorial}}" > .app_tutorial
		mise trust -a
		sleep 10
		mise install
		setsid screen -dmS up bash -c "cd; source .bash_profile; cd \"${CODER_HOMEDIR}\"; m up; sleep infinity"
	) &

	cd ~/m
	exec j coder::code-server "${CODER_NAME}"

destroy-coder-agent:
  true

dyff *args:
	@just github::dyff {{args}}

play pb *lim:
	#!/usr/bin/env bash

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
