chart ?=
revision ?= $(cat $(chart).version)
version ?= 0.0.$(revision)

build:
	@rm -rf $(chart)/chart
	@mkdir -p $(chart)/chart/templates
	@echo "apiVersion: v2" > $(chart)/chart/Chart.yaml.tmp
	@echo "type: application" >> $(chart)/chart/Chart.yaml.tmp
	@echo "name: $(chart)" >> $(chart)/chart/Chart.yaml.tmp
	@echo "appVersion: \"$(version)\"" >> $(chart)/chart/Chart.yaml.tmp
	@echo "version: \"$(version)\"" >> $(chart)/chart/Chart.yaml.tmp
	@mv -f $(chart)/chart/Chart.yaml.tmp $(chart)/chart/Chart.yaml
	@cp -f $(chart)/*.yaml $(chart)/chart/templates/
	@rm -f $(chart)/chart/templates/Chart.yaml
	helm package $(chart)/chart

all-init:
	ls -d */ | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) -f Makefile init chart=$$1 revision=$(revision)'

all-build:
	ls -d */ | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) -f Makefile build chart=$$1'

all-push:
	ls -d */ | sed 's#/$$##' | runmany $(shell nproc) '$(MAKE) -f Makefile push chart=$$1'

init:
	echo -n $(revision) > $(chart).version

login:
	helm registry login -u 'robot$$meh' harbor.district.amanibhavam.defn.run

push:
	helm push $(chart)-$(version).tgz oci://harbor.district.amanibhavam.defn.run/library/helm

template:
	helm template $(chart) oci://harbor.district.amanibhavam.defn.run/library/helm/$(chart) --version $(version)
