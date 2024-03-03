default:
	$(MAKE) -j 2 backend open

backend:
	python -m http.server 1961

open:
	sleep 1
	open http://localhost:1961
