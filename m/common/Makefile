SHELL := /bin/bash

build:
	rm -f chart/templates/*.yaml	
	cue eval >/dev/null
	cue export --out json -e app.output | jq -r 'to_entries[] | "\(.key) \(.value | @base64)"' | while read -r f b; do base64 -d <<<"$$b" >"$$f"; done
	rm -f *.tgz gen/*.tgz
	cd gen && helm package ../chart
	git add chart/Chart.yaml gen version*
	git commit --allow-empty -m "update"

push:
	helm push --insecure-skip-tls-verify gen/*.tgz oci://$(DFD_REGISTRY)/library/helm

argocd:
	kubectl apply -f gen/argocd.yaml

image:
	docker build -t $$EXPECTED_REF . && docker push $$EXPECTED_REF

post-bazel:
	if test -f $(build); then install -v -m 0755 -o ubuntu -g ubuntu $(build) $(release);  mkdir -p store; rsync -ia $$(ldd $(release) | grep /nix/store | awk '{print $$3}' | cut -d/ -f1-4 | sort -u) store/; fi

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
	cd ../../ && $(MAKE) vc dev
# TODO why doesnt ArgoCD create this namespace?
	kubectl create ns kyverno || true
	mkdir -p chart/templates gen
	b build
	tilt up --port=$$(comm -23 <(seq 10350 10399 | sort -n) <(netstat -antu | awk '{print $$4}' | grep -oP '\d+$$' | sort -n) 2>/dev/null | head -n 1)
