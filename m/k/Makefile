login:
	helm registry login -u 'robot$$meh' $(registry)

template:
	helm template --insecure-skip-tls-verify $(chart) oci://$(registry)/library/helm/$(chart) --version $(version)
