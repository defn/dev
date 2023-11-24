SHELL := /bin/bash

chart ?=

domain ?= defn.run
registry ?= cache.$(domain):5000

build:
	for f in $$(cue export --out text -e app.output_filenames); do (cue export --out text -e 'app.output["'"$$f"'"]') > "$$f"; done
	rm -f *.tgz gen/*.tgz
	helm package .
	mv *.tgz gen/
	helm push --insecure-skip-tls-verify gen/*.tgz oci://$(registry)/library/helm

bump:
	echo $$(( $$(cat version) + 1 )) > version.tmp
	mv version.tmp version
	(echo package dev; echo "app: chart: version: \"0.0.$$(cat version)\"") > version.cue
	cue fmt .

deploy:
	kubectl apply -f gen/app.yaml

init:
	argocd --core repo add $(registry) --type helm --name cache --enable-oci --insecure-skip-server-verification

all:
	$(MAKE) bump build deploy