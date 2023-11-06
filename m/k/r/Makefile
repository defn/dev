chart ?= $(shell basename $(shell pwd))
version ?= $(shell cat VERSION)

build:
	@rm -rf chart
	@mkdir chart
	@echo "apiVersion: v2" > chart/Chart.yaml.tmp
	@echo "type: application" >> chart/Chart.yaml.tmp
	@echo "name: $(chart)" >> chart/Chart.yaml.tmp
	@echo "appVersion: \"$(version)\"" >> chart/Chart.yaml.tmp
	@echo "version: \"$(version)\"" >> chart/Chart.yaml.tmp
	@mv -f chart/Chart.yaml.tmp chart/Chart.yaml
	@cp -f main.yaml chart/
	helm package chart

login:
	helm registry login -u 'robot$$meh' harbor.district.amanibhavam.defn.run

push:
	helm push $(chart)-$(version).tgz oci://harbor.district.amanibhavam.defn.run/library/helm

template:
	helm template $(chart) oci://harbor.district.amanibhavam.defn.run/library/helm/$(chart) --version $(version)
