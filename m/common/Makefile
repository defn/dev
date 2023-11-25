SHELL := /bin/bash

chart ?=

domain ?= defn.run
registry ?= cache.$(domain):5000

build:
	cue export --out json -e app.output | jq -r 'to_entries[] | "\(.key) \(.value | @base64)"' | while read -r f b; do base64 -d <<<"$$b" >"$$f"; done
	rm -f *.tgz gen/*.tgz
	cd gen && helm package ../chart

push:
	helm push --insecure-skip-tls-verify *.tgz oci://$(registry)/library/helm

image:
	docker build -t $$EXPECTED_REF . && docker push $$EXPECTED_REF

post-bazel:
	if test -f $(build); then install -m 0755 -o ubuntu -g ubuntu $(build) $(release); fi

watch:
	b watch

bump:
	echo $$(( $$(cat version) + 1 )) > version.tmp
	mv version.tmp version
	(echo package dev; echo "app: chart: version: \"0.0.$$(cat version)\"") > version.cue
	cue fmt .

deploy:
	kubectl apply -f gen/app.yaml

repo:
	argocd --core repo add $(registry) --type helm --name cache --enable-oci --insecure-skip-server-verification

init:
	mkdir -p chart/templates gen
	$(MAKE) bump build

all:
	$(MAKE) bump build deploy