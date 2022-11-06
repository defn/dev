build:
	n build

develop:
	n develop

image:
	pass hello
	../build.sh

run:
	n run

%:
	go build -o dist/cmd.$@/bin cmd/$@/$@.go
	git add --intent-to-add dist/cmd.$@/bin
	git update-index --assume-unchanged dist/cmd.$@/bin
	$(MAKE) image