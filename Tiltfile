analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

local_resource("coder",
    serve_cmd=[
        "bash", "-c",
        """
            this-coder-server-kill
            this-coder-init
        """
    ]
)
