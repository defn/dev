analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

if "-darwin" in os.getenv("system"):
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
                cd work/lib/w/k3d
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
                exec sudo "$(which tailscaled)" "$@"
            """
        ]
    )

    # Starts Tailscale on Linux
    local_resource("buildkite",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                direnv allow
                _direnv_hook
                exec this-ci
            """
        ]
    )
