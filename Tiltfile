analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

# Starts Coder on macOS
local_resource("coder",
    serve_cmd=[
        "bash", "-c",
        """
            if [[ "Darwin" == "$(uname -s)" ]]; then
                eval "$(direnv hook bash)"
                direnv reload
                _direnv_hook
                this-coder-server-kill
                this-coder-init
            else
                sleep infinity
            fi
        """
    ]
)

# Starts Tailscale on Linux
local_resource("tailscale",
    serve_cmd=[
        "bash", "-c",
        """
            if [[ "Linux" == "$(uname -s)" ]]; then
                cd w/tailscale
                eval "$(direnv hook bash)"
                direnv reload
                _direnv_hook
                this-tailscale-start
            else
                sleep infinity
            fi
        """
    ]
)

# Starts Vault on Linux
local_resource("vault",
    serve_cmd=[
        "bash", "-c",
        """
            if [[ "Linux" == "$(uname -s)" ]]; then
                cd w/vault
                eval "$(direnv hook bash)"
                direnv reload
                _direnv_hook
                this-vault-start
            else
                sleep infinity
            fi
        """
    ]
)

# Starts gh webhook forward on Linux
local_resource("gh-webhook-forward",
    serve_cmd=[
        "bash", "-c",
        """
            if [[ "Linux" == "$(uname -s)" ]]; then
                eval "$(direnv hook bash)"
                direnv reload
                _direnv_hook
                gh webhook forward --repo defn/dev --events=push --url=http://localhost://localhost:9000 --secret "$(pass WH_SECRET)"
            else
                sleep infinity
            fi
        """
    ]
)

local_resource("webhook-cli",
    serve_cmd=[
        "bash", "-c",
        """
            if [[ "Linux" == "$(uname -s)" ]]; then
                eval "$(direnv hook bash)"
                direnv reload
                _direnv_hook
                export WH_SECRET="$(pass WH_SECRET)"
                touch /tmp/cache-priv-key.pem
                chmod 600 /tmp/cache-priv-key.pem
                pass nix-serve-cache-priv-key.pem > /tmp/cache-priv-key.pem
                webhook --hooks gh.json --template --verbose
            else
                sleep infinity
            fi
        """
    ]
)

# Starts the docker builder, proxies at localhost:2375.  Configures docker
# client with creds to publish to fly registry.
local_resource("proxy-docker",
    serve_cmd=[
        "bash", "-c",
        """
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
            exec flyctl machine api-proxy
        """
    ],
)
