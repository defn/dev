genkey:
	env PRIV_KEY="sa-signer.key" PUB_KEY="sa-signer.key.pub" PKCS_KEY="sa-signer-pkcs8.pub" $(MAKE) genkey-inner

genkey-inner:
	ssh-keygen -t rsa -b 2048 -f $$PRIV_KEY -m pem
	ssh-keygen -e -m PKCS8 -f $$PUB_KEY > $$PKCS_KEY

genkeys.json:
	env PRIV_KEY="sa-signer.key" PUB_KEY="sa-signer.key.pub" PKCS_KEY="sa-signer-pkcs8.pub" $(MAKE) keys.json

# /keys.json
keys.json:
	(cd ./amazon-eks-pod-identity-webhook && go run ./hack/self-hosted/main.go -key ../$$PKCS_KEY) | jq '.keys += [.keys[0]] | .keys[1].kid = ""' > keys.json

# /.well-known/openid-configuration
discovery.json: discovery.cue
	cue export --out=json > discovery.json

json:
	rm discovery.json keys.json
	env PRIV_KEY="sa-signer.key" PUB_KEY="sa-signer.key.pub" PKCS_KEY="sa-signer-pkcs8.pub" $(MAKE) json-inner

json-inner:
	$(MAKE) discovery.json keys.json
