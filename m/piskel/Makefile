default: dest/prod/index.html
	$(MAKE) -j 2 backend open

backend:
	cd dest/prod && python -m http.server 1959

open:
	sleep 1
	open http://localhost:1959

build: ./node_modules/.bin/grunt
	./node_modules/.bin/grunt

./node_modules/.bin/grunt:
	npm install grunt-cli

dest/prod/index.html:
	$(MAKE) build
