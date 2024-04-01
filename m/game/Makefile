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
	pkill trunk || true
	$(MAKE) -j 2 tilt code-server

tilt:
	export STARSHIP_NO= && while true; do source ~/.bash_profile; tilt up; sleep 5; done

code-server:
	export STARSHIP_NO= && while true; do source ~/.bash_profile; code-server --auth none; sleep 5; done
