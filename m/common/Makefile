# TODO remove

# Deploy the application by building, pushing, and applying ArgoCD configuration
# Dependencies: make command
# Outputs: Executed bump, build, push, and argocd targets sequentially
deploy:
	$(MAKE) bump build push argocd

# Push Helm charts to OCI registry
# Dependencies: helm command, gen/*.tgz files, DFD_REGISTRY variable
# Outputs: Pushed Helm chart packages to OCI registry
push:
	helm push --insecure-skip-tls-verify gen/*.tgz oci://$(DFD_REGISTRY)/library/helm

# Apply ArgoCD configuration to Kubernetes cluster
# Dependencies: kubectl command, gen/argocd.yaml file
# Outputs: Applied ArgoCD configuration to Kubernetes cluster
argocd:
	kubectl apply -f gen/argocd.yaml

# Increment version number and update version files
# Dependencies: version file, echo command, cat command, mv command, cue command
# Outputs: Incremented version number in version file, created version.cue file with new version, formatted CUE files
bump:
	echo $$(( $$(cat version) + 1 )) > version.tmp
	mv version.tmp version
	(echo package app; echo "app: chart: version: \"0.0.$$(cat version)\"") > version.cue
	cue fmt .

# Add Helm repository to ArgoCD
# Dependencies: argocd command, DFD_REGISTRY variable
# Outputs: Added Helm repository to ArgoCD with OCI support
repo:
	argocd --core repo add $(DFD_REGISTRY) --type helm --name cache --enable-oci --insecure-skip-server-verification
