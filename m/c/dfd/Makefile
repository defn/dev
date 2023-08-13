SHELL := /bin/bash

PRIV_KEY := sa-signer.key
PUB_KEY := sa-signer.key.pub
PKCS_KEY := sa-signer-pkcs8.pub

k3s_url := $(shell cat ~/.kube/config | grep server: | awk '{print $$NF}')

build:
# remove everything
	rm -rf ../../k/*/
	rm -rf ../../e/*.yaml
# helm generates ./k/karpenter/karpenter.yaml
#	b run outputs_karpenter__update
# cue ./c/ generates kustomize ./k/
	b run outputs_kustomize__update
# kustomize ./k/ generates ./k/r/ release yaml
	(cd ../../k && b run outputs_release__update)
# add generated to git
	../make_add_generated.sh

list:
	true

secrets:
	$(MAKE) clean
	$(MAKE) k3d-secrets

clean:
	rm -f system.admin.key system.admin.pem system.ca.pem
	rm -f openid/.well-known/openid-configuration

openid: openid/.well-known/openid-configuration
	@true

openid/.well-known/openid-configuration:
	docker exec k3d-dfd-server-0 cat /etc/rancher/k3s/k3s.yaml | awk -F': ' '/client-certificate-data/ {print $$2}' | base64 -d > system.admin.pem && chmod 600 system.admin.pem
	docker exec k3d-dfd-server-0 cat /etc/rancher/k3s/k3s.yaml | awk -F': ' '/client-key-data/ {print $$2}' | base64 -d > system.admin.key && chmod 600 system.admin.key
	docker exec k3d-dfd-server-0 cat /etc/rancher/k3s/k3s.yaml  |awk -F': ' '/certificate-authority-data/ {print $$2}' | base64 -d > system.ca.pem && chmod 600 system.ca.pem
	mkdir -p openid/v1
	curl -sSL --cert system.admin.pem --key system.admin.key --cacert system.ca.pem ${k3s_url}/openid/v1/jwks | jq . > openid/v1/jwks
	rm -vf system.*
	mkdir -p openid/.well-known
	cue export -e discovery --out=json | jq . > openid/.well-known/openid-configuration
	git add openid
	git commit -m "update oidc provider"
	git push

k3d-secrets: ca.key ca.crt openid/.well-known/openid-configuration
	kubectl --context k3d-dfd create namespace cert-manager
	kubectl --context k3d-dfd create secret generic -n kube-system cilium-ca --from-file=ca.key --from-file=ca.crt
	kubectl --context k3d-dfd create secret generic -n cert-manager cilium-ca --from-file=tls.key=ca.key --from-file=tls.crt=ca.crt
	kubectl --context k3d-dfd create namespace tailscale
	kubectl --context k3d-dfd create secret -n tailscale generic operator-oauth-custom --from-literal=client_id=$$(pass OAUTH_CLIENT_ID) --from-literal=client_secret=$$(pass OAUTH_CLIENT_SECRET)

ca.key ca.crt:
	step certificate create cilium-ca ca.crt ca.key --profile root-ca --not-after 8760h --no-password --insecure --kty RSA --size 4096 --force
