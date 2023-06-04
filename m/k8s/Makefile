SHELL := /bin/bash

gen: # Generate cue schemas for k8s libraries
	rm -rf ../cue.mod/gen
	find . -name '*_gen.cue' | xargs rm -fv
	for a in $$(cue export --out json -e k8s.apis | jq -r '.[]'); do \
		mark $$a; \
		go get -u $$a; \
		cue get go $$a; \
		rsync -ia ../cue.mod/gen/k8s.io/. ./. && rm -rf ../cue.mod/gen; \
		git grep '"k8s.io/' */ | cut -d: -f1 | uniq | while read -r f; do perl -pe 's{"k8s.io/}{"github.com/defn/dev/m/k8s/}' -i $$f; done; \
	done
