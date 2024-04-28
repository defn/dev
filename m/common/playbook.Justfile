# Run a playbook
playbook pb *lim:
	#!/usr/bin/env bash

	cd ~/m/pb
	just playbook {{pb}} {{lim}}