template := $(shell basename $(shell pwd))

push:
	set -x; cd .. && tar --dereference -cf - "$(template)" mod | coder template push -y --create -d "$(template)" "$(template)"
