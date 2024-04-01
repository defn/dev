SHELL := /bin/bash

port ?= 1963
game ?= ~/work/sunny
web ?= 443

default:
	$(MAKE) build

level:
	cd PhaserEditor2D-v3 && $(MAKE) game=$(game) port=$(port)

sound:
	cd jsfxr && $(MAKE)

pixel:
	cd piskel && $(MAKE)

coder:
	while true; do $(MAKE) coder-inner; sleep 5; done
	
coder-inner:
	pkill trunk || true
	$(MAKE) -j 2 code-server

tilt:
	$(MAKE) -j 2 tilt-run tilt-open

tilt-run:
	tilt up --stream

tilt-open:
	while true; do if curl -s -o /dev/null 127.0.0.1:10350; then break; fi; sleep 1; done
	open http://127.0.0.1:10350

code-server:
	export STARSHIP_NO= && while true; do source ~/.bash_profile; code-server --auth none; sleep 5; done
