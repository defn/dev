port ?= 1961

default:
	$(MAKE) -j 2 backend

backend:
	python -m http.server $(port)

open:
	while true; do if curl -s -o /dev/null 127.0.0.1:$(port); then break; fi; sleep 1; done
	open http://localhost:$(port)
