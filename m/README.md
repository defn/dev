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

## gvisor

```
(
  set -e
  ARCH=$(uname -m)
  URL=https://storage.googleapis.com/gvisor/releases/release/latest/${ARCH}
  wget ${URL}/runsc ${URL}/runsc.sha512 \
    ${URL}/containerd-shim-runsc-v1 ${URL}/containerd-shim-runsc-v1.sha512
  sha512sum -c runsc.sha512 \
    -c containerd-shim-runsc-v1.sha512
  rm -f *.sha512
  chmod a+rx runsc containerd-shim-runsc-v1
  sudo mv runsc containerd-shim-runsc-v1 /usr/local/bin
)

sudo vi /var/lib/rancher/k3s/agent/etc/containerd/config.toml

[plugins."io.containerd.runtime.v1.linux"]

shim_debug = true

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]

runtime_type = "io.containerd.runc.v2"

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runsc]

runtime_type = "io.containerd.runsc.v1"

sudo systemctl restart k3s

cat<<EOF | kubectl apply -f -
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
    name: gvisor
handler: runsc
EOF
```