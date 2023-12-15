SHELL := /bin/bash

chart ?=
revision ?= $(shell cat ../h/$(chart)-version)
version ?= 0.0.$(revision)

domain ?= defn.run
registry ?= cache.$(domain):5000

source ?= r

delivery:
	$(MAKE) all-build

all-init:
	ls -d */ | grep \\- | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) init chart=$$1 revision=$(revision)'

all-sha1:
	ls -d */ | grep \\- | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) sha1 chart=$$1'

all-package:
	ls -d */ | grep \\- | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) package chart=$$1'

all-build:
	ls -d */ | grep \\- | grep -v \\-env/ | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) build chart=$$1; (echo package c; echo; echo "teacher: bootstrap: \"$$(echo $$1 | cut -d- -f5-)\": app_version: \"0.0.$$(cat ../h/$$1-version)\"" ) > ../c/$$(echo $$1 | cut -d- -f1-3)/$$1-version.cue'
	ls -d */ | grep \\- | grep \\-env/ | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) build chart=$$1; (echo package c; echo; echo "teacher: bootstrap: \"$$1\": app_version: \"0.0.$$(cat ../h/$$1-version)\"" ) > ../c/$$(echo $$1 | cut -d- -f1-3)/$$1-version.cue'

all:
	ls -d */ | grep \\- | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) package-always chart=$$1'
	$(MAKE) all-push

all-push:
	ls -d */ | grep \\- | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) push chart=$$1'

init:
	echo -n $(revision) > ../h/$(chart)-version

login:
	helm registry login -u 'robot$$meh' $(registry)

bump:
	echo $$(( $$(cat ../h/$(chart)-version) + 1)) > ../h/$(chart)-version.tmp
	mv -f ../h/$(chart)-version.tmp ../h/$(chart)-version

sha1:
	find $(source)/$(chart) -name '*.yaml' | sort | xargs sha1sum > ../h/$(chart)-sha1

build:
	@if [[ "$$(cat ../h/$(chart)-sha1 2>/dev/null)" != "$$(find $(source)/$(chart) -name '*.yaml' | sort | xargs sha1sum)" ]]; then \
		diff <(cat ../h/$(chart)-sha1 2>/dev/null) <(find $(source)/$(chart) -name '*.yaml' | sort | xargs sha1sum); \
		$(MAKE) sha1 bump chart=$(chart); \
		$(MAKE) build-inner; \
	fi

build-if-missing:
	@if ! test -f ../h/$(chart)-$(version).tgz; then $(MAKE) build-inner; fi

build-always:
	$(MAKE) build-inner

build-inner:
	rm -rf ../h/$(chart)
	mkdir -p ../h/$(chart)/templates
	cp -f $(source)/$(chart)/*.yaml ../h/$(chart)/templates/
	echo "apiVersion: v2" > ../h/$(chart)/Chart.yaml.tmp
	echo "type: application" >> ../h/$(chart)/Chart.yaml.tmp
	echo "name: $(chart)" >> ../h/$(chart)/Chart.yaml.tmp
	echo "appVersion: \"$(version)\"" >> ../h/$(chart)/Chart.yaml.tmp
	echo "version: \"$(version)\"" >> ../h/$(chart)/Chart.yaml.tmp
	mv -f ../h/$(chart)/Chart.yaml.tmp ../h/$(chart)/Chart.yaml
	$(MAKE) package-always push chart=$(chart)

package-always:
	cd ../h && cat $(chart)/Chart.yaml && helm package $(chart); \

package:
	@if [[ "$$(cat ../h/$(chart)-sha1 2>/dev/null)" != "$$(find $(source)/$(chart) -name '*.yaml' | sort | xargs sha1sum)" ]]; then \
		cd ../h && cat $(chart)/Chart.yaml && helm package $(chart); \
	fi

update-env:
	cd ../c && $(MAKE) update-env

push:
	if ! test -f ../h/$(chart)-$(version).tgz; then $(MAKE) package chart=$(chart); fi
	helm push --insecure-skip-tls-verify ../h/$(chart)-$(version).tgz oci://$(registry)/library/helm

template:
	helm template --insecure-skip-tls-verify $(chart) oci://$(registry)/library/helm/$(chart) --version $(version)
