mod github 'm/common/github.Justfile'
mod playbook 'm/common/playbook.Justfile'
mod gpg 'm/common/gpg.Justfile'
mod lib 'm/common/lib.Justfile'

dyff *args:
	@just github::dyff {{args}}

play pb *lim:
	#!/usr/bin/env bash

	just playbook::playbook {{pb}} {{lim}}

command pattern *args:
	just playbook::command {{pattern}} {{args}}

upgrade *args="all:!pc:!rpi4d":
	just play upgrade {{ args }}

cache *args="cache":
	just play cache {{ args }}

home *args="all:!rpi":
	just play home {{ args }}
