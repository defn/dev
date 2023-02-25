analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

if "-darwin" in os.getenv("system"):
    cmd_button("coder",
                argv=['bash', '-c', 'open "$(pass coder_access_url)"'],
                icon_name='cloud_download',
                location=location.NAV,
                text='Coder'
    )

    # Starts openvpn on macOS
    local_resource("openvpn",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                _direnv_hook
                sudo -A pkill -f bin/openvp[n] || true
                sleep 2; sudo -A pkill -9 -f bin/openvp[n] || true
                exec sudo -A $(which openvpn) etc/openvpn/server.conf
            """
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
    # Starts openvpn on Linux
    local_resource("openvpn",
        serve_cmd=[
            "bash", "-c",
            """
                eval "$(direnv hook bash)"
                _direnv_hook
                sudo pkill -f bin/openvp[n] || true
                sleep 2; sudo pkill -9 -f bin/openvp[n] || true
                exec sudo -A $(which openvpn) etc/openvpn/client.conf
            """
        ]
    )
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
