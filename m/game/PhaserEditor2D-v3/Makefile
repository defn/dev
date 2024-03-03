port ?= 1959

default:
	$(MAKE) -j 3 backend game=$(game) port=$(port) frontend open

backend:
	cd source/editor && npx phasereditor2d-launcher --editor . --dev --disable-plugins phasereditor2d.code --disable-open-browser --port $(port) --project $(game) --public

frontend:
	tailscale serve --https 1960 $(port)

open:
	sleep 1
	open https://$$(tailscale cert 2>&1 | grep 'For domain'  | cut -d '"' -f2):1960/editor/