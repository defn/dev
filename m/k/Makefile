chart ?=
revision ?= $(shell cat ../h/$(chart)-version)
version ?= 0.0.$(revision)

build:
	@rm -rf ../h/$(chart)
	@mkdir -p ../h/$(chart)/templates
	@echo "apiVersion: v2" > ../h/$(chart)/Chart.yaml.tmp
	@echo "type: application" >> ../h/$(chart)/Chart.yaml.tmp
	@echo "name: $(chart)" >> ../h/$(chart)/Chart.yaml.tmp
	@echo "appVersion: \"$(version)\"" >> ../h/$(chart)/Chart.yaml.tmp
	@echo "version: \"$(version)\"" >> ../h/$(chart)/Chart.yaml.tmp
	@mv -f ../h/$(chart)/Chart.yaml.tmp ../h/$(chart)/Chart.yaml
	@cp -f r/$(chart)/*.yaml ../h/$(chart)/templates/
	cd ../h/ && helm package $(chart)

all-init:
	ls -d */ | grep \\- | grep -v 'bootstrap/' | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) init chart=$$1 revision=$(revision)'

all-build:
	ls -d */ | grep \\- | grep -v 'env/' | grep -v 'bootstrap/' | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) build chart=$$1; (echo package c; echo "teacher: bootstrap: \"$$(echo $$1 | cut -d- -f5-)\": app_version: \"0.0.$$(cat ../h/$$1-version)\"" ) > ../c/$$(echo $$1 | cut -d- -f1-3)/$$1-version.cue'

all-push:
	ls -d */ | grep \\- | grep -v 'bootstrap/' | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) push chart=$$1'

init:
	echo -n $(revision) > ../h/$(chart)-version

login:
	helm registry login -u 'robot$$meh' harbor.district.amanibhavam.defn.run

push:
	helm push ../h/$(chart)-$(version).tgz oci://harbor.district.amanibhavam.defn.run/library/helm

template:
	helm template $(chart) oci://harbor.district.amanibhavam.defn.run/library/helm/$(chart) --version $(version)
