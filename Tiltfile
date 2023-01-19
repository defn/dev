analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

if "-darwin" in os.getenv("system"):
    # Starts Coder on macOS
    local_resource("coder",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                _direnv_hook
                docker pull ghcr.io/defn/dev:latest-devcontainer
                this-coder-server-kill
                exec this-coder-init orgs-wildcard-tls
            """
        ]
    )

    # Starts code-server on macOS
    local_resource("coder-agent",
        deps=["/tmp/coder-agent-token"],
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                _direnv_hook
                exec env CODER_AGENT_AUTH=token CODER_AGENT_URL="$(pass coder_access_url)" CODER_CONFIG_DIR=$HOME/.config/coderv2 CODER_AGENT_TOKEN="$(cat /tmp/coder-agent-token)" nix run .#coder -- agent
            """
        ]
    )

    # Starts coder port forward on macOS
    local_resource("coder-port-forward",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                _direnv_hook
                while true; do
                    if coder list | grep ^"$(pass coder_docker_workspace)"; then
                        coder port-forward "$(pass coder_docker_workspace)" --tcp 2222:2222
                    fi
                    sleep 5
                done
            """
        ]
    )

    # Starts gpg forward on macOS
    local_resource("gpg-socket-forward",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                _direnv_hook
                while true; do
                    if coder list | grep ^"$(pass coder_docker_workspace)"; then
                        break
                    fi
                    sleep 5
                done
                ssh_host="coder.$(pass coder_docker_workspace | cut -d/ -f2)"
                set -x
                while true; do
                    coder config-ssh --yes
                    ssh-add -L | ssh "$ssh_host" tee .ssh/authorized_keys &
                    (
                        gpg --armor --export | ssh "$ssh_host" gpg --import
                        gpg --export-ownertrust | ssh "$ssh_host" gpg --import-ownertrust
                    ) &
                    wait
                    if ssh -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/nulli ubuntu@127.0.0.1 true; then
                        ssh \
                        -o Port=2222 \
                        -o StrictHostKeyChecking=no \
                        -o UserKnownHostsFile=/dev/null \
                        -o ServerAliveInterval=60 \
                        -o ServerAliveCountMax=5 \
                        -o StreamLocalBindUnlink=yes \
                        -o RemoteForward="/home/ubuntu/.gnupg/S.gpg-agent {home}/.gnupg/S.gpg-agent.extra" \
                        -o RemoteForward="/home/ubuntu/.gnupg/S.gpg-agent.extra {home}/.gnupg/S.gpg-agent.extra" \
                        -A -v ubuntu@127.0.0.1 bash -c '"ln -nfs $SSH_AUTH_SOCK $HOME/.ssh/S.ssh-agent; date; exec sleep infinity"'
                    fi
                    sleep 5
                done
            """.format(home=os.getenv("HOME"))
        ]
    )

    # Starts Vault on macOS
    local_resource("vault",
        serve_cmd=[
            "bash", "-c",
            """
                cd w/vault
                eval "$(direnv hook bash)"
                direnv allow
                _direnv_hook
                exec this-vault-start
            """
        ]
    )

    # Starts nix-cache on macOS
    local_resource("nix-cache",
        serve_cmd=[
            "bash", "-c",
            """
                docker rm -f nix-cache || true
                exec docker run --name nix-cache --rm -v nix-cache:/usr/share/nginx/html:ro -p 5001:80 nginx
            """
        ]
    )

    # Starts registry on macOS
    local_resource("registry",
        serve_cmd=[
            "bash", "-c",
            """
                cd w/k3d
                eval "$(direnv hook bash)"
                direnv allow
                _direnv_hook
                this-k3d-registry || true
                exec docker logs -f k3d-registry
            """
        ]
    )
else:
    # Starts Tailscale on Linux
    local_resource("tailscale",
        serve_cmd=[
            "bash", "-c",
            """
                cd w/tailscale
                eval "$(direnv hook bash)"
                direnv allow
                _direnv_hook
                exec this-tailscale-start
            """
        ]
    )

    # Starts gh webhook forward on Linux
    local_resource("webhook-forward",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                _direnv_hook
                gh extension install cli/gh-webhook || true
                while true; do
                    gh webhook forward --repo "$(git remote get-url origin | perl -pe 's{https://github.com/}{}')" --events=push --url=http://localhost:9000/hooks/gh
                done
            """
        ]
    )

    local_resource("webhook-gh",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                _direnv_hook

                export WH_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
                export WH_SECRET="$(pass WH_SECRET)"
                touch /tmp/cache-priv-key.pem
                chmod 600 /tmp/cache-priv-key.pem
                pass nix-serve-cache-priv-key.pem > /tmp/cache-priv-key.pem
                exec webhook --hooks gh.json --hotreload --template --verbose
            """
        ]
    )

    local_resource("webhook-log",
        serve_cmd=[
            "bash", "-c",
            """
                touch /tmp/wh.log
                exec tail -f /tmp/wh.log
            """
        ]
    )

    # Starts the docker builder, proxies at localhost:2375.  Configures docker
    # client with creds to publish to fly registry.
    local_resource("proxy-docker",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                _direnv_hook
                flyctl auth docker
                flyctl machine start "$(flyctl machine list -a $(flyctl apps list | grep '^fly-builder' | awk '{print $1}') --json | jq -r '.[].id')"
                exec flyctl proxy 2375:2375 -a "$(flyctl apps list | grep 'fly-builder' | awk '{print $1}' | head -1)"
            """
        ],
    )

    # Starts the machine api-proxy.
    local_resource("proxy-machine-api",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                _direnv_hook
                exec flyctl machine api-proxy --org personal
            """
        ],
    )
