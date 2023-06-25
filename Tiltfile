analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

if "-darwin" in os.getenv("system"):
    # vault
    local_resource("vault",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                direnv allow
                _direnv_hook
                exec this-vault-start -log-level debug
            """
        ]
    )

    # nix-cache
    local_resource("nix-cache",
        serve_cmd=[
            "bash", "-c",
            """
                docker rm -f nix-cache || true
                exec docker run --name nix-cache --rm -v nix-cache:/usr/share/nginx/html:ro -p 5001:80 nginx
            """
        ]
    )