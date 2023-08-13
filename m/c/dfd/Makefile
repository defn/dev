SHELL := /bin/bash

PRIV_KEY := sa-signer.key
PUB_KEY := sa-signer.key.pub
PKCS_KEY := sa-signer-pkcs8.pub

k3s_url := $(shell cat ~/.kube/config | grep server: | awk '{print $$NF}')

list:
	true

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

secrets:
	$(MAKE) clean
	$(MAKE) jwks.json
	$(MAKE) k3d-secrets

clean:
	rm -rf amazon-eks-pod-identity-webhook
	rm -f sa-signer-pkcs8.pub sa-signer.key sa-signer.key.pub
	rm -f jwks.json
	rm -rf openid system.admin.key system.admin.pem system.ca.pem

openid: openid/.well-known/openid-configuration
	@true

openid/.well-known/openid-configuration:
	docker exec k3d-dfd-server-0 cat /etc/rancher/k3s/k3s.yaml | awk -F': ' '/client-certificate-data/ {print $$2}' | base64 -d > system.admin.pem && chmod 600 system.admin.pem
	docker exec k3d-dfd-server-0 cat /etc/rancher/k3s/k3s.yaml | awk -F': ' '/client-key-data/ {print $$2}' | base64 -d > system.admin.key && chmod 600 system.admin.key
	docker exec k3d-dfd-server-0 cat /etc/rancher/k3s/k3s.yaml  |awk -F': ' '/certificate-authority-data/ {print $$2}' | base64 -d > system.ca.pem && chmod 600 system.ca.pem
	mkdir -p openid/.well-known openid/v1
	openssl x509 -in system.ca.pem -fingerprint -noout | awk -F'=' 'gsub(/:/,"",$$0) { print $$2 }' > openid/thumbprint && chmod 600 openid/thumbprint
	curl -sSL --cert system.admin.pem --key system.admin.key --cacert system.ca.pem -k ${k3s_url}/openid/v1/jwks | jq . > openid/v1/jwks
#	curl -sSL --cert system.admin.pem --key system.admin.key --cacert system.ca.pem -k ${k3s_url}/.well-known/openid-configuration | jq . > openid/.well-known/openid-configuration
	(echo package c; echo 'discovery_url: "https://raw.githubusercontent.com/amanibhavam/amanibhavam.github.io/master/v8"') > discovery_url.cue
	cue export -e discovery --out=json | jq . > openid/.well-known/openid-configuration
	rm -vf system.*

k3d-secrets: ca.key ca.crt openid/.well-known/openid-configuration
	kubectl --context k3d-dfd create namespace cert-manager
	kubectl --context k3d-dfd create secret generic -n kube-system cilium-ca --from-file=ca.key --from-file=ca.crt
	kubectl --context k3d-dfd create secret generic -n cert-manager cilium-ca --from-file=tls.key=ca.key --from-file=tls.crt=ca.crt
	kubectl --context k3d-dfd create namespace tailscale
	kubectl --context k3d-dfd create secret -n tailscale generic operator-oauth-custom --from-literal=client_id=$$(pass OAUTH_CLIENT_ID) --from-literal=client_secret=$$(pass OAUTH_CLIENT_SECRET)

ca.key ca.crt:
	step certificate create cilium-ca ca.crt ca.key --profile root-ca --not-after 8760h --no-password --insecure --kty RSA --size 4096 --force

jwks.json:
	ssh-keygen -N "" -t rsa -b 2048 -f $(PRIV_KEY) -m pem
	ssh-keygen -e -m PKCS8 -f $(PUB_KEY) > $(PKCS_KEY)
	git clone https://github.com/aws/amazon-eks-pod-identity-webhook
	(cd amazon-eks-pod-identity-webhook && go run ./hack/self-hosted/main.go -key ../$(PKCS_KEY)) | jq '.keys += [.keys[0]] | .keys[1].kid = ""' > jwks.json
