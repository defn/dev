port ?= 1961

default:
	$(MAKE) -j 2 backend open

backend:
	echo http://127.0.0.1:$(port)
	python -m http.server --bind 127.0.0.1 $(port)

open:
	while true; do if curl -s -o /dev/null 127.0.0.1:$(port); then break; fi; sleep 1; done
	open http://localhost:$(port)
