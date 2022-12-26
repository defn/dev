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
