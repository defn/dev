 port ?= 1959

default: dest/prod/index.html
	$(MAKE) -j 2 backend open

backend:
	echo http://127.0.0.1:$(port)
	cd dest/prod && python -m http.server --bind 127.0.0.1 $(port)

open:
	while true; do if curl -s -o /dev/null 127.0.0.1:$(port); then break; fi; sleep 1; done
	open http://localhost:$(port)

build: ./node_modules/.bin/grunt
	./node_modules/.bin/grunt

./node_modules/.bin/grunt:
	npm install grunt-cli

dest/prod/index.html:
	$(MAKE) build
