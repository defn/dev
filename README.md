# defn/dev

Monorepo for cloud integrated development environments.

## Features

- **Bazel**: Monorepo build tool
- **Buildkite**: CI/CD pipeline
- **CUE**: Monorepo configuration
- **Coder**: Coder workspaces in the browser for the IDE
- **Mise**: Tools, environment, and task management

## Machine Setup
This will allow you to create a Linux defn/dev environment. 

After updating the home directory, verify that the container provider is running and accessible. This setups uses Docker and Brew on macOS. 
```
git pull
docker ps
brew upgrade
```

If Docker is not installed, use `brew install --cask docker` to install. Start Docker, then reverify.

Run the linux container in `m/dc`.
```
cd m/dc
j up
```

Get a shell in the container and update.
```
j shell
git pull
```

Activate tailscaled with s6
```
cd m/svc
ln -nfs ../svc.d/tailscaled/ .
s6-svscanctl -a .
```

Then register the linux container as a tailscale node. It is recommended to name the node after your computer 
```
tailscale up --ssh --hostname NAME-dev
```

In the tailscale console, disable the node's key expiry and add `ansible` and `spiral` ASL tags

ssh into `coder-amanibhavam-kowloon` and accept your container's access request. Then ssh back to the container and accept `kowloon` access request, and exit both. Confirm that you have tailscale ip.
```
ssh NAME-dev
ssh coder-amanibhavam-kowloon
exit
exit
tailscale ip
```

Finally, go to coder console and create the ssh workspace as `NAME-dev` with username `ubuntu`. Test that everything works by restarting docker and running `j up`.
```
docker restart
j up
```

## Quickstart

Build the monorepo, change directory to `m/` and run Bazel.

```
cd m
b build
```

The `main` branch build is [![Build status](https://badge.buildkite.com/879feda30e2616b22929338672877e85dfe82f60eb47df2e6a.svg?branch=main)](https://buildkite.com/defn/dev)

## Updates
These methods assume the latest repo is used.

At every start of a session update your tools with `make sync`. This also updates your home directory git repo.

Daily run `make home` to update the base tools. These tools don't change often

If there's been a long period between your last session, do an end-to-end update:
```
git pull
./install.sh
```