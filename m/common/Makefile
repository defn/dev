# TODO remove

deploy:
	$(MAKE) bump build push argocd

push:
	helm push --insecure-skip-tls-verify gen/*.tgz oci://$(DFD_REGISTRY)/library/helm

argocd:
	kubectl apply -f gen/argocd.yaml

bump:
	echo $$(( $$(cat version) + 1 )) > version.tmp
	mv version.tmp version
	(echo package app; echo "app: chart: version: \"0.0.$$(cat version)\"") > version.cue
	cue fmt .

repo:
	argocd --core repo add $(DFD_REGISTRY) --type helm --name cache --enable-oci --insecure-skip-server-verification
