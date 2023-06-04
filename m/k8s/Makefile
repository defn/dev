SHELL := /bin/bash

gen:
	$(MAKE) get
	$(MAKE) rewrite

get: # Generate cue schemas for k8s libraries
	for a in $$(cue export --out json -e k8s.apis | jq -r '.[]'); do \
		mark $$a; \
		go get -u $$a; \
		cue get go $$a; \
	done
	cd .. && go mod tidy
	rsync -ia ../cue.mod/gen/k8s.io/. ./. && rm -rf ../cue.mod/gen/k8s.io

rewrite: # Rewrite k8s.io module name to this repo
	git grep '"k8s.io/' api apimachinery | cut -d: -f1 | uniq | while read -r f; do perl -pe 's{"k8s.io/}{"github.com/defn/dev/m/k8s/}' -i $$f; done
