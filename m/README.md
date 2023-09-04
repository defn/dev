## Pre-requisites

Install `nix` and finish `direnv` integration. Then `cd cmd/cli`.

## Using the CLI

Run the CLI:

```
go run .
```

Run the TUI:

```
go run . tui
```

Run the GRPC server:

```
go run . server
```

Run the GRPC client:

```
go run . client
```

Run the cdktf generator:

```
go run . infra
```

Load and verify bash completion:

```
go install
source /etc/profile.d/bash_completion.sh
eval "$(cli completion bash)"
complete -p cli
cli <TAB>
```

## Adding sub-commands

Use `cobra-cli` to add a command to the CLI. For example, to add a `start` command:

```
cobra-cli add start
```

## k3s

```
rm -f ~/.kube/config
k3sup install --local --context k3d-dfd --local-path ~/.kube/config --merge --k3s-extra-args "--node-ip 172.31.38.198 --node-external-ip $(tailscale ip -4) --disable-network-policy --disable=traefik --flannel-backend=none --kube-apiserver-arg=--service-account-issuer=https://raw.githubusercontent.com/defn/dev/main/m/c/dfd/openid --kube-apiserver-arg=--api-audiences=https://kubernetes.default.svc.cluster.local,sts.amazonaws.com --tls-san=k3d-dfd" 
```