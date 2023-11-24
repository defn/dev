SHELL := /bin/bash

chart ?=

domain ?= defn.run
registry ?= cache.$(domain):5000

build:
	cue export --out yaml -e 'output["Chart.yaml"]' > Chart.yaml
	cue export --out yaml -e 'output["app.yaml"]' > app.yaml
	rm -f *.tgz
	helm package .
	helm push --insecure-skip-tls-verify *.tgz oci://$(registry)/library/helm

bump:
	echo $$(( $$(cat version) + 1 )) > version.tmp
	mv version.tmp version
	(echo package dev; echo "version: \"0.0.$$(cat version)\"") > version.cue
	cue fmt .

deploy:
	kubectl apply -f app.yaml

init:
	argocd --core repo add $(registry) --type helm --name cache --enable-oci --insecure-skip-server-verification
