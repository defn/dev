build:
	npx pnpm build

dev:
	npx pnpm dev

install:
	cd .. && npm install
	npx pnpm install
	echo packages/ui apps/defn apps/docs apps/web | runmany 'cd $$1 && npx svelte-kit sync'

list:
	cd .. && npm outdated
	npx pnpm outdated
	for a in defn docs web; do (cd apps/$$a && npx pnpm outdated); done

upgrade:
	cd .. && npm upgrade
	npx pnpm upgrade
	for a in defn docs web; do (cd apps/$$a && npx pnpm upgrade); done
