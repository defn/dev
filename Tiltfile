include("app/Tiltfile.site")

load("ext://uibutton", "cmd_button", "location")

dummy_host = os.environ.get("DEFN_DEV_HOST")

analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

allow_k8s_contexts("pod")

# deploy
local_resource(
    "deploy",
    cmd="""
        set -x; cd;
        make deploy
    """,
    labels=["deploy"],
)

# argocd
cmd_button(
    name="ui argocd",
    text="argocd",
    icon_name="stream",
    resource="argocd",
    argv=[
        "bash",
        "-c",
        """
            set -x; cd;
            xdg-open https://{domain}:9603;
        """.format(
            domain=dummy_host
        ),
    ],
    location="nav",
)

# traefik
cmd_button(
    name="ui traefik",
    text="traefik",
    icon_name="traffic",
    resource="traefik",
    argv=[
        "bash",
        "-c",
        """
            set -x; cd;
            xdg-open https://{domain}:9605;
        """.format(
            domain=dummy_host
        ),
    ],
    location="nav",
)
