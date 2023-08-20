template := $(shell basename $(shell pwd))

push:
	tf fmt
	tf docs
	tar -cvh --exclude .terraform . | coder templates push -y --create -d - "$(template)"
