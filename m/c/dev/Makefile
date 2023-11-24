SHELL := /bin/bash

chart ?=

domain ?= defn.run
registry ?= cache.$(domain):5000

build:
	for f in $$(cue export --out text -e output_filenames); do cue export --out text -e 'output["'"$$f"'"]' > "$$f"; done
	rm -f *.tgz
	helm package .
	helm push --insecure-skip-tls-verify *.tgz oci://$(registry)/library/helm

bump:
	echo $$(( $$(cat version) + 1 )) > version.tmp
	mv version.tmp version
	(echo package dev; echo "version: \"0.0.$$(cat version)\"") > version.cue
	cue fmt .

deploy:
	kubectl apply -f gen/app.yaml

init:
	argocd --core repo add $(registry) --type helm --name cache --enable-oci --insecure-skip-server-verification

all:
	$(MAKE) bump build deploy