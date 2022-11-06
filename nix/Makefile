$(shell basename $(shell pwd)):
	$(MAKE) all name=$@

all:
	$(MAKE) compile name=$(name)
	$(MAKE) build
	$(MAKE) image name=$(name)

compile:
	if test -f go.mod; then $(MAKE) compile-go name=$(name); fi

compile-go:
	n develop --command go build -o dist/cmd.$(name)/bin cmd/$(name)/$(name).go
	git add --intent-to-add dist/cmd.$(name)/bin
	git update-index --assume-unchanged dist/cmd.$(name)/bin

build:
	n build

image:
	pass hello
	../image.sh "$(name)"

develop:
	n develop

run:
	n run

clean:
	rm -rf dist
	rm -rf nix
