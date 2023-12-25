init:
	install -d -D -m 0750 -o ubuntu -g ubuntu ~/work/registry/certs
	install -d -D -m 0750 -o ubuntu -g ubuntu ~/work/bazel-cache
	cd ~/work/registry/certs && step certificate create --subtle --insecure --no-password --force --profile self-signed $(shell uname -n) registry.crt registry.key

up:
	docker-compose up -d
