analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

allow_k8s_contexts("pod")

local_resource(
    name="tailscale cert",
    serve_cmd="d=$(docker exec tailscale_docker-extension-desktop-extension-service /app/tailscale cert 2>&1 | grep For.domain | cut -d'\"' -f2); docker exec tailscale_docker-extension-desktop-extension-service /app/tailscale cert $d",
)

local_resource(
    name="registry pod",
    serve_cmd="exec socat TCP-LISTEN:5555,fork,reuseaddr TCP:k3d-registry:5000",
)

local_resource(
    name="registry buildkitd",
    serve_cmd="exec bash -c 'earthly bootstrap; docker exec earthly-buildkitd apk add socat || true; docker exec earthly-buildkitd pkill socat; exec docker exec earthly-buildkitd socat TCP-LISTEN:5555,fork,reuseaddr TCP:$(host host.k3d.internal | cut -d\\  -f4):5555'",
)

local_resource(
    name="hubble port-forward",
    serve_cmd="exec kubectl port-forward -n kube-system svc/hubble-ui 12000:80",
)

cmd_button(
    name="ui hubble",
    resource="hubble port-forward",
    argv=[
        "bash",
        "-c",
        "xdg-open http://localhost:12000"
    ],
    icon_name="web",
)

local_resource(
    name="kuma port-forward",
    serve_cmd="exec kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681",
 
)

cmd_button(
    name="ui kuma",
    resource="kuma port-forward",
    argv=[
        "bash",
        "-c",
        "xdg-open http://localhost:5681/gui"
    ],
    icon_name="web",
)

local_resource(
    name="argocd port-forward",
    serve_cmd="exec kubectl -n argocd port-forward svc/argocd-server 8881:443",
)

cmd_button(
    name="ui argocd",
    resource="argocd port-forward",
    argv=[
        "bash",
        "-c",
        "kubectl -n argocd get -o json secret argocd-initial-admin-secret | jq -r '.data.password | @base64d' | ssh super pbcopy; xdg-open http://localhost:8881"
    ],
    icon_name="web",
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
