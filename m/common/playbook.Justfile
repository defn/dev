# Run a playbook
playbook pb *lim:
	#!/usr/bin/env bash

	cd ~/m/pb
	just pb {{pb}} {{lim}}

command pattern *args:
	#!/usr/bin/env bash

	cd ~/m/pb
	ansible {{pattern}} -a "{{args}}"
