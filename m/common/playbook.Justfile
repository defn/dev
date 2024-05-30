# Run a playbook
playbook pb *lim:
	#!/usr/bin/env bash

	cd ~/m/pb
	just pb {{pb}} {{lim}}

# Run a playbook on penguin
penguin pb:
	#!/usr/bin/env bash

	cd ~/m/pb
	just pg {{pb}}

command pattern *args:
	#!/usr/bin/env bash

	cd ~/m/pb
	ansible {{pattern}} -a "{{args}}"
