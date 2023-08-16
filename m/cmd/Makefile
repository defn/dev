build:
	b build

image:
	skopeo copy docker://ubuntu docker://$(tag) --multi-arch all --dest-tls-verify=false --insecure-policy
	docker pull $(tag)

manifest:
	@cat cli.yaml	