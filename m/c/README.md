# TODO

```
cd ~/m/c
~/.dotfiles/bootstrap
~/m/bin/make-k3s init
# make coder-amanibhavam-district configs:
# m/c/HOSTNAME
make once
# make sure there's no other tailscale node named
make up
env KUBECONFIG=$HOME/.kube/config.argocd argocd cluster add $(uname -n) --yes --core --kube-context $(uname -n)-argocd --name $(uname -n)-cluster --upsert --in-cluster
k apply -f ../e/HOSTNAME-cluster.yaml
?? app sync /cluster
?? delete external-secrets-operator pod for irsa - detect when irsa pods haven't been mutated by irsa controller
?? delete karpenter pod for irsa - detect when irsa pods haven't been mutated by irsa controller
?? make identity provider - this should be automated
?? argocd password is not set, patched
make last
```
