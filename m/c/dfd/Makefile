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

k3s-oidc:
	awk -F': ' '/client-certificate-data/ {print $$2}' /etc/rancher/k3s/k3s.yaml | base64 -d > system.admin.pem && chmod 600 system.admin.pem
	awk -F': ' '/client-key-data/ {print $$2}' /etc/rancher/k3s/k3s.yaml | base64 -d > system.admin.key && chmod 600 system.admin.key
	awk -F': ' '/certificate-authority-data/ {print $$2}' /etc/rancher/k3s/k3s.yaml | base64 -d > system.ca.pem && chmod 600 system.ca.pem
	mkdir -p oidc/.well-known oidc/v1
	openssl x509 -in system.ca.pem -fingerprint -noout | awk -F'=' 'gsub(/:/,"",$$0) { print $$2 }' > oidc/thumbprint && chmod 600 oidc/thumbprint
	curl -sSL --cert system.admin.pem --key system.admin.key --cacert system.ca.pem https://localhost:6443/.well-known/openid-configuration > oidc/.well-known/openid-configuration
	curl -sSL --cert system.admin.pem --key system.admin.key --cacert system.ca.pem https://localhost:6443/openid/v1/jwks > oidc/v1/jwks

k3d-update:
	curl -sSL -o k3d-tailscale-operator.yaml https://raw.githubusercontent.com/tailscale/tailscale/main/cmd/k8s-operator/manifests/operator.yaml
	trunk fmt k3d-tailscale-operator.yaml

k3d-ca:
	step certificate create cilium-ca ca.crt ca.key --profile root-ca --not-after 8760h --no-password --insecure --kty RSA --size 4096 --force

ca.key ca.crt:
	$(MAKE) k3d-ca

k3d-secrets: ca.key ca.crt
	kubectl --context k3d-dfd create namespace cert-manager
	kubectl --context k3d-dfd create secret generic -n kube-system cilium-ca --from-file=ca.key --from-file=ca.crt
	kubectl --context k3d-dfd create secret generic -n cert-manager cilium-ca --from-file=tls.key=ca.key --from-file=tls.crt=ca.crt
	kubectl --context k3d-dfd create namespace tailscale
	kubectl --context k3d-dfd create secret -n tailscale generic operator-oauth --from-literal=client_id=$$(pass OAUTH_CLIENT_ID) --from-literal=client_secret=$$(pass OAUTH_CLIENT_SECRET)