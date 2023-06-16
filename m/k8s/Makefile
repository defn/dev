SHELL := /bin/bash

build: # Generate cue schemas for k8s libraries
	rm -rf ../cue.mod/gen
	cue export --out json -e k8s.apis | jq -r '.[]' | runmany 'mark $$1; go get $$1; cue get go $$1'