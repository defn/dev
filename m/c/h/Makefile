build:
	helm package .

login:
	helm registry logun -u 'robot$$meh' harbor.district.amanibhavam.defn.run

push:
	helm push $(chart) oci://harbor.district.amanibhavam.defn.run/library/helm

# template: helm template meh oci://harbor.district.amanibhavam.defn.run/library/helm/hello-world --version 0.1.1
