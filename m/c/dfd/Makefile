SHELL := /bin/bash

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

k3s_url := $(shell cat ~/.kube/config | grep server: | awk '{print $$NF}')

system.admin.key system.admin.pem system.ca.pem:
	docker exec k3d-dfd-server-0 cat /etc/rancher/k3s/k3s.yaml | awk -F': ' '/client-certificate-data/ {print $$2}' | base64 -d > system.admin.pem && chmod 600 system.admin.pem
	docker exec k3d-dfd-server-0 cat /etc/rancher/k3s/k3s.yaml | awk -F': ' '/client-key-data/ {print $$2}' | base64 -d > system.admin.key && chmod 600 system.admin.key
	docker exec k3d-dfd-server-0 cat /etc/rancher/k3s/k3s.yaml  |awk -F': ' '/certificate-authority-data/ {print $$2}' | base64 -d > system.ca.pem && chmod 600 system.ca.pem
	mkdir -p oidc/.well-known oidc/v1
	openssl x509 -in system.ca.pem -fingerprint -noout | awk -F'=' 'gsub(/:/,"",$$0) { print $$2 }' > oidc/thumbprint && chmod 600 oidc/thumbprint
	curl -sSL --cert system.admin.pem --key system.admin.key --cacert system.ca.pem -k ${k3s_url}/.well-known/openid-configuration > oidc/.well-known/openid-configuration
	curl -sSL --cert system.admin.pem --key system.admin.key --cacert system.ca.pem -k ${k3s_url}/openid/v1/jwks > oidc/v1/jwks

ca.key ca.crt:
	step certificate create cilium-ca ca.crt ca.key --profile root-ca --not-after 8760h --no-password --insecure --kty RSA --size 4096 --force

k3d-secrets: ca.key ca.crt system.admin.key system.admin.pem system.ca.pem
	kubectl --context k3d-dfd create namespace cert-manager
	kubectl --context k3d-dfd create secret generic -n kube-system cilium-ca --from-file=ca.key --from-file=ca.crt
	kubectl --context k3d-dfd create secret generic -n cert-manager cilium-ca --from-file=tls.key=ca.key --from-file=tls.crt=ca.crt
	kubectl --context k3d-dfd create namespace tailscale
	kubectl --context k3d-dfd create secret -n tailscale generic operator-oauth-custom --from-literal=client_id=$$(pass OAUTH_CLIENT_ID) --from-literal=client_secret=$$(pass OAUTH_CLIENT_SECRET)

secrets:
	rm -rf oidc system.admin.key system.admin.pem system.ca.pem
	$(MAKE) k3d-secrets
