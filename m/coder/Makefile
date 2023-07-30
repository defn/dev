template := $(shell basename $(shell pwd))

push:
	set -x; cd .. && tar --dereference -cf - mod "$(template)" | coder template push -y -d "$(template)" "$(template)"
