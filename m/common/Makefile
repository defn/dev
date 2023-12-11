SHELL := /bin/bash

build:
	rm -f chart/templates/*.yaml	
	cue export --out json -e app.output | jq -r 'to_entries[] | "\(.key) \(.value | @base64)"' | while read -r f b; do base64 -d <<<"$$b" >"$$f"; done
	rm -f *.tgz gen/*.tgz
	cd gen && helm package ../chart

push:
	helm push --insecure-skip-tls-verify gen/*.tgz oci://$(DFD_REGISTRY)/library/helm

argocd:
	kubectl apply -f gen/argocd.yaml

image:
	docker build -t $$EXPECTED_REF . && docker push $$EXPECTED_REF

post-bazel:
	if test -f $(build); then install -m 0755 -o ubuntu -g ubuntu $(build) $(release); fi

watch:
	b build
	b watch

bump:
	echo $$(( $$(cat version) + 1 )) > version.tmp
	mv version.tmp version
	(echo package app; echo "app: chart: version: \"0.0.$$(cat version)\"") > version.cue
	cue fmt .

repo:
	argocd --core repo add $(DFD_REGISTRY) --type helm --name cache --enable-oci --insecure-skip-server-verification

deploy:
	$(MAKE) bump build push argocd

up:
	cd ../../k && $(MAKE) all
	cd ../../ && $(MAKE) vc dev
	mkdir -p chart/templates gen
	tilt up --port=$$(comm -23 <(seq 10350 10399 | sort -n) <(netstat -antu | awk '{print $$4}' | grep -oP '\d+$$' | sort -n) 2>/dev/null | head -n 1)
