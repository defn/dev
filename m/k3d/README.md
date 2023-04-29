```
curl -sSL -O https://raw.githubusercontent.com/tailscale/tailscale/main/cmd/k8s-operator/manifests/operator.yaml

vcluster connect vcluster -n global-vc0 --server=global-vc0-vcluster-tailscale.tail3884f.ts.net --insecure --update-current=false
kubectl --kubeconfig ./kubeconfig.yaml get ns
```
