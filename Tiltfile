include("Tiltfile.common")

load("Tiltfile.common", "dummy_ip", "dummy_host")

load("ext://uibutton", "cmd_button", "location")

# defn/dev
local_resource(
    name="make updates",
    cmd="""
        set -x; cd;
        rsync -ia etc/post-commit .git/hooks/;
        make updates;
    """,
    allow_parallel=True,
    labels=["automation"],
    deps=[".commit"],
    trigger_mode=TRIGGER_MODE_MANUAL,
)

cmd_button(
    name="push updates",
    resource="make updates",
    argv=[
        "bash",
        "-c",
        """
            set -x; cd;
            git push;
            cd work/dev && git pull && exec make updates repo= repo_from=localhost:5000/ cache=localhost:5000/;
        """,
    ],
    icon_name="build",
)

cmd_button(
    name="yolo",
    resource="make updates",
    argv=[
        "bash",
        "-c",
        """
            set -x; cd;
            make updates;
            kubectl --context pod delete pod/dev-0;
        """,
    ],
    icon_name="build",
)
