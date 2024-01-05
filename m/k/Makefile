SHELL := /bin/bash

chart ?=
revision ?= $(shell cat ../h/$(chart)-version)
version ?= 0.0.$(revision)

domain ?= defn.run
registry ?= cache.$(domain):5000

source ?= r

all-build:
	rm -f ../c/*/*-version.cue
	ls -d */ | grep \\- | grep -v \\-env/ | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) build chart=$$1; (echo package c; echo; echo "teacher: bootstrap: \"$$(echo $$1 | cut -d- -f5-)\": app_version: \"0.0.$$(cat ../h/$$1-version)\"" ) > ../c/$$(echo $$1 | cut -d- -f1-3)/$$1-version.cue'
	ls -d */ | grep \\- | grep \\-env/ | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) build chart=$$1; (echo package c; echo; echo "teacher: bootstrap: \"$$1\": app_version: \"0.0.$$(cat ../h/$$1-version)\"" ) > ../c/$$(echo $$1 | cut -d- -f1-3)/$$1-version.cue'

login:
	helm registry login -u 'robot$$meh' $(registry)

push:
	helm push --insecure-skip-tls-verify ../h/$(chart)-$(version).tgz oci://$(registry)/library/helm

template:
	helm template --insecure-skip-tls-verify $(chart) oci://$(registry)/library/helm/$(chart) --version $(version)
