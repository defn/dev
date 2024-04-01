port ?= 1963

default:
	$(MAKE) -j 2 backend open game=$(game) port=$(port)

backend:
	cd source/editor && npx phasereditor2d-launcher --editor . --dev --disable-plugins phasereditor2d.code --port $(port) --project $(game) --public

open:
	while true; do if curl -s -o /dev/null 127.0.0.1:$(port); then break; fi; sleep 1; done
	open http://127.0.0.1:$(port)/editor/
