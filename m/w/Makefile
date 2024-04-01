SHELL ?= bash

default:
	$(MAKE) build

build:
	npx pnpm build

dev:
	npx pnpm dev

install:
	cd .. && npm install
	npx pnpm install
	echo packages/ui apps/story apps/docs apps/web | runmany 'cd $$1 && npx svelte-kit sync'

list:
	cd .. && npm outdated
	npx pnpm outdated
	for a in story docs web; do (cd apps/$$a && npx pnpm outdated); done

upgrade:
	cd .. && npm upgrade
	npx pnpm upgrade
	for a in story docs web; do (cd apps/$$a && npx pnpm upgrade); done

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
