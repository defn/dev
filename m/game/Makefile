port ?= 1963
game ?= ~/work/sunny
web ?= 443

default:
	$(MAKE) -j 3 sound pixel level game=$(game) port=$(port)

level:
	cd PhaserEditor2D-v3 && $(MAKE) game=$(game) port=$(port) web=$(web)

sound:
	cd jsfxr && $(MAKE)

pixel:
	cd piskel && $(MAKE)
