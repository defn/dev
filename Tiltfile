analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

if "-darwin" in os.getenv("system"):
    # Starts Vault on macOS
    local_resource("vault",
        serve_cmd=[
            "bash", "-c",
            """
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
else:
    # Starts Tailscale on Linux
    local_resource("tailscale",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                direnv allow
                _direnv_hook
                exec sudo "$(which tailscaled)" "$@"
            """
        ]
    )