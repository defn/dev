SHELL := /bin/bash

build: # Generate cue schemas for k8s libraries
	b out app_config | jq -r '.k8s.apis[]' | runmany 'mark $$1; go get $$1; cue get go $$1'