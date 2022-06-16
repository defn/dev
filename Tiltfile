analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

allow_k8s_contexts("pod")

local_resource(
    name="registry tunnel",
    serve_cmd="exec socat TCP-LISTEN:5555,fork TCP:k3d-registry:5555",
)

local_resource(
    name="argocd port-forward",
    serve_cmd="exec kubectl -n argocd port-forward svc/argocd-server -n argocd 8881:443",
)

local_resource(
    "argocd",
    cmd='if argocd app diff argocd --local k/argocd; then echo No difference; fi',
    deps=["k/argocd"],
)

cmd_button(
    name="sync argocd",
    resource="argocd",
    argv=[
        "bash",
        "-c",
        "argocd app sync argocd --local k/argocd --assumeYes --prune; touch k/argocd/main.yaml",
    ],
    icon_name="build",
)

cmd_button(
    name="ui",
    resource="argocd",
    argv=[
        "bash",
        "-c",
        "kubectl -n argocd get -o json secret argocd-initial-admin-secret | jq -r '.data.password | @base64d' | ssh super pbcopy; xdg-open http://localhost:8881"
    ],
    icon_name="web",
)

local_resource(
    "dev",
    cmd='if argocd app diff dev --local k/dev; then echo No difference; fi',
    deps=["k/dev"],
)

cmd_button(
    name="sync dev",
    resource="dev",
    argv=[
        "bash",
        "-c",
        "argocd app sync dev --local k/dev --assumeYes --prune; touch k/dev/main.yaml",
    ],
    icon_name="build",
)

local_resource(
    "wip",
    cmd='if argocd app diff wip --local k/wip; then echo No difference; fi',
    deps=["k/wip"],
)

cmd_button(
    name="sync wip",
    resource="wip",
    argv=[
        "bash",
        "-c",
        "argocd app sync wip --local k/wip --assumeYes --prune; touch k/wip/main.yaml",
    ],
    icon_name="build",
)
