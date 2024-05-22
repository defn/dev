mod github 'm/common/github.Justfile'
mod playbook 'm/common/playbook.Justfile'
mod gpg 'm/common/gpg.Justfile'

create-coder-agent:
	#!/usr/bin/env bash

	cd m
	just coder::coder-agent "${CODER_NAME}" 2>/dev/null 1>/dev/null &

destroy-coder-agent:
	#!/usr/bin/env bash

	for p in $(pgrep -f "just.coder::code.serve[r].${CODER_NAME}"'$') $(pgrep -f "just.coder::coder.agen[t].${CODER_NAME}"'$' --older 30); do
	  ps x -o ppid,pgid | tail -n +2 | sed 's#^  *##g' | grep "^$p " | awk '{print $2}' | while read -r g; do 
	    kill -9 -$g
	  done
	done

dyff *args:
	@just github::dyff {{args}}

play pb *lim:
	just playbook::playbook {{pb}} {{lim}}

penguin pb:
	just playbook::penguin {{pb}}

upgrade:
	just play upgrade

cache:
	just play cache

home *args:
	just play home {{ args }}

all:
	just upgrade
	just home
