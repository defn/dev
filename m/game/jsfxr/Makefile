port ?= 1961

# Start local development server and open browser
default:
	$(MAKE) -j 2 backend open

# Start HTTP server for jsfxr sound editor
backend:
	echo http://127.0.0.1:$(port)
	python -m http.server --bind 127.0.0.1 $(port)

# Wait for server to be ready and open browser
open:
	while true; do if curl -s -o /dev/null 127.0.0.1:$(port); then break; fi; sleep 1; done
	open http://localhost:$(port)
