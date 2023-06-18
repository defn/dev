SHELL := /bin/bash

build:
	true

update:
	curl -sSL -o operator.yaml https://raw.githubusercontent.com/tailscale/tailscale/main/cmd/k8s-operator/manifests/operator.yaml
	trunk fmt operator.yaml

import:
	b build k3d_earthly_build
	b out k3d_earthly_build | docker load

make_%:
	./$@.sh