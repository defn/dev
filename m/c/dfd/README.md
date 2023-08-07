```
vcluster --context k3d-dfd connect vcluster -n vc0 --server=$(kubectl --context k3d-dfd get nodes -o json | jq -r '.items[].metadata.annotations["k3s.io/internal-ip"]'):443 --insecure --update-current=false --kube-config-context-name dfd-vc0 --print > $HOME/.kube/config.vc0
env KUBECONFIG=$HOME/.kube/config:$HOME/.kube/config.vc0 argocd --kube-context k3d-dfd cluster --core add dfd-vc0
```
