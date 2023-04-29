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

#    env:
#    - name: AWS_DEFAULT_REGION
#      value: us-west-2
#    - name: AWS_REGION
#      value: us-west-2
#    - name: AWS_ROLE_ARN
#      value: "arn:aws:iam::111122223333:role/s3-reader"
#    - name: AWS_WEB_IDENTITY_TOKEN_FILE
#      value: "/var/run/secrets/eks.amazonaws.com/serviceaccount/token"
#    - name: AWS_STS_REGIONAL_ENDPOINTS
#      value: "regional"
#    volumeMounts:
#    - mountPath: "/var/run/secrets/eks.amazonaws.com/serviceaccount/"
#      name: aws-token
#  volumes:
#  - name: aws-token
#    projected:
#      sources:
#      - serviceAccountToken:
#          audience: "sts.amazonaws.com"
#          expirationSeconds: 86400
#          path: token
