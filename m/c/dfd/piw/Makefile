PRIV_KEY := sa-signer.key
PUB_KEY := sa-signer.key.pub
PKCS_KEY := sa-signer-pkcs8.pub

build:
	$(MAKE) clean
	ssh-keygen -N "" -t rsa -b 2048 -f $(PRIV_KEY) -m pem
	ssh-keygen -e -m PKCS8 -f $(PUB_KEY) > $(PKCS_KEY)
	$(MAKE) discovery.json keys.json

clean:
	rm -rf amazon-eks-pod-identity-webhook
	rm -f sa-signer-pkcs8.pub sa-signer.key sa-signer.key.pub
	rm -f discovery.json keys.json

# /keys.json
keys.json:
	git clone https://github.com/aws/amazon-eks-pod-identity-webhook
	(cd amazon-eks-pod-identity-webhook && go run ./hack/self-hosted/main.go -key ../$(PKCS_KEY)) | jq '.keys += [.keys[0]] | .keys[1].kid = ""' > keys.json

# /.well-known/openid-configuration
discovery.json:
	cue export --out=json > discovery.json
