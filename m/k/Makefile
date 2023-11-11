SHELL := /bin/bash

chart ?=
revision ?= $(shell cat ../h/$(chart)-version)
version ?= 0.0.$(revision)

all-init:
	ls -d */ | grep \\- | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) init chart=$$1 revision=$(revision)'

all-sha1:
	ls -d */ | grep \\- | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) sha1 chart=$$1'''

all-build:
	ls -d */ | grep \\- | grep -v \\-env/ | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) build chart=$$1; (echo package c; echo "teacher: bootstrap: \"$$(echo $$1 | cut -d- -f5-)\": app_version: \"0.0.$$(cat ../h/$$1-version)\"" ) > ../c/$$(echo $$1 | cut -d- -f1-3)/$$1-version.cue'
	ls -d */ | grep \\- | grep \\-env/ | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) build chart=$$1; (echo package c; echo "teacher: bootstrap: \"$$1\": app_version: \"0.0.$$(cat ../h/$$1-version)\"" ) > ../c/$$(echo $$1 | cut -d- -f1-3)/$$1-version.cue'

all-push:
	ls -d */ | grep \\- | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) push chart=$$1'

init:
	echo -n $(revision) > ../h/$(chart)-version

login:
	helm registry login -u 'robot$$meh' harbor.district.amanibhavam.defn.run

bump:
	echo $$(( $$(cat ../h/$(chart)-version) + 1)) > ../h/$(chart)-version.tmp
	mv -f ../h/$(chart)-version.tmp ../h/$(chart)-version

sha1:
	find ../h/$(chart)/templates -name '*.yaml' | sort | xargs sha1sum > ../h/$(chart)-sha1

build:
	@rm -rf ../h/$(chart)
	@mkdir -p ../h/$(chart)/templates

	@cp -f r/$(chart)/*.yaml ../h/$(chart)/templates/
	if [[ "$$(cat ../h/$(chart)-sha1 2>/dev/null)" != "$$(find ../$h/$(chart)/templates -name '*.yaml' | sort | xargs sha1sum)" ]]; then $(MAKE) sha1 bump chart=$(chart); fi

	@echo "apiVersion: v2" > ../h/$(chart)/Chart.yaml.tmp
	@echo "type: application" >> ../h/$(chart)/Chart.yaml.tmp
	@echo "name: $(chart)" >> ../h/$(chart)/Chart.yaml.tmp
	@echo "appVersion: \"$(version)\"" >> ../h/$(chart)/Chart.yaml.tmp
	@echo "version: \"$(version)\"" >> ../h/$(chart)/Chart.yaml.tmp
	@mv -f ../h/$(chart)/Chart.yaml.tmp ../h/$(chart)/Chart.yaml

	cd ../h/ && helm package $(chart)

push:
	helm push ../h/$(chart)-$(version).tgz oci://harbor.district.amanibhavam.defn.run/library/helm

template:
	helm template $(chart) oci://harbor.district.amanibhavam.defn.run/library/helm/$(chart) --version $(version)
