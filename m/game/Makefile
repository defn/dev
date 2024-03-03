port ?= 1959
game ?= ~/work/sunny

default:
	$(MAKE) -j 3 sound pixel level game=$(game) port=$(port)

level:
	cd PhaserEditor2D-v3 && $(MAKE) game=$(game) port=$(port)

sound:
	cd jsfxr && $(MAKE)

pixel:
	cd piskel && $(MAKE)
