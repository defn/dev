template := $(shell basename $(shell pwd))

push:
	set -x; tar --dereference -cf - . | coder template push -y -d . "$(template)"
