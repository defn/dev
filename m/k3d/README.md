## Prerequisites

The k3d registry uses an insecure HTTP connection. Configure Docker on the host to allow it by adding to `~/.docker/daemon.json`:

```json
{
  "insecure-registries": ["defn.xxx:5000"]
}
```

Then restart Docker.

## Usage

```
m update
m setup
m argocd
m headlamp
```
