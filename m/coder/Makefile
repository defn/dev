template := $(shell basename $(shell pwd))

push:
	tf fmt
	tf docs
	ls -d mod/*/ | runmany 'cd $$1 && tf fmt && tf docs'
	tar -cvh --exclude .terraform . | coder templates push -y --create -d - "$(template)"

build:
	env -u SSH_AUTH_SOCK earthly --push --no-output +build