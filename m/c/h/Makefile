chart ?= $(shell basename $(shell pwd))
version ?= $(shell cat VERSION)

build:
	@echo "apiVersion: v2" > Chart.yaml.tmp
	@echo "type: application" >> Chart.yaml.tmp
	@echo "name: $(chart)" >> Chart.yaml.tmp
	@echo "appVersion: \"$(version)\"" >> Chart.yaml.tmp
	@echo "version: \"$(version)\"" >> Chart.yaml.tmp
	@mv -f Chart.yaml.tmp Chart.yaml
	helm package .

login:
	helm registry login -u 'robot$$meh' harbor.district.amanibhavam.defn.run

push:
	helm push $(chart)-$(version).tgz oci://harbor.district.amanibhavam.defn.run/library/helm

template:
	helm template $(chart) oci://harbor.district.amanibhavam.defn.run/library/helm/$(chart) --version $(version)
