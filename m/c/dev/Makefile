SHELL := /bin/bash

chart ?=

domain ?= defn.run
registry ?= cache.$(domain):5000

build:
	rm -f *.tgz
	helm package .
	helm push --insecure-skip-tls-verify *.tgz oci://$(registry)/library/helm

delpoy:
	kubectl apply -f app.yaml

init:
	argocd --core repo add $(registry) --type helm --name cache --enable-oci --insecure-skip-server-verification
