 port ?= 1959

# Build Piskel and start development server
default: dest/prod/index.html
	$(MAKE) -j 2 backend open

# Start HTTP server for Piskel pixel art editor
backend:
	echo http://127.0.0.1:$(port)
	cd dest/prod && python -m http.server --bind 127.0.0.1 $(port)

# Wait for server to be ready and open browser
open:
	while true; do if curl -s -o /dev/null 127.0.0.1:$(port); then break; fi; sleep 1; done
	open http://localhost:$(port)

# Build Piskel using Grunt
build: ./node_modules/.bin/grunt
	./node_modules/.bin/grunt

# Install Grunt CLI
./node_modules/.bin/grunt:
	npm install grunt-cli

# Ensure Piskel is built
dest/prod/index.html:
	$(MAKE) build
