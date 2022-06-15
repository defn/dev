analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

allow_k8s_contexts("pod")

local_resource(
    "argocd",
    cmd='echo; argocd app sync argocd --local k/argocd --preview-changes --dry-run --assumeYes 2>/dev/null | awk "/Previewing/ {flag=1;next} /^TIMESTAMP/ {flag=0} flag"; echo',
    deps=["k/argocd"],
)

local_resource(
    name="argocd port-forward",
    serve_cmd="kubectl -n argocd port-forward svc/argocd-server -n argocd 8881:443",
)

local_resource(
    name="registry tunnel",
    serve_cmd="socat TCP-LISTEN:5555,fork TCP:k3d-registry:5555",
)

local_resource(
    name="docker tunnel",
    serve_cmd="bash -c 'while true; do rm -f /home/ubuntu/.local/docker.sock; ssh -L /home/ubuntu/.local/docker.sock:/var/run/docker.sock super tail -f /dev/null; sleep 1; done'",
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
        "echo password: $(kubectl -n argocd get -o json secret argocd-initial-admin-secret | jq -r '.data.password | @base64d'); xdg-open http://localhost:8881"
    ],
    icon_name="web",
)

local_resource(
    "dev",
    cmd='echo; argocd app sync dev --local k/dev --preview-changes --dry-run --assumeYes 2>/dev/null | awk "/Previewing/ {flag=1;next} /^TIMESTAMP/ {flag=0} flag"; echo',
    deps=["k/dev"],
)

cmd_button(
    name="sync dev",
    resource="dev",
    argv=[
        "bash",
        "-c",
        "argocd app sync dev --local k/dev --assumeYes --prune",
    ],
    icon_name="build",
)

local_resource(
    "wip",
    cmd='echo; argocd app sync wip --local k/wip --preview-changes --dry-run --assumeYes 2>/dev/null | awk "/Previewing/ {flag=1;next} /^TIMESTAMP/ {flag=0} flag"; echo',
    deps=["k/wip"],
)

cmd_button(
    name="sync wip",
    resource="wip",
    argv=[
        "bash",
        "-c",
        "argocd app sync wip --local k/wip --assumeYes --prune",
    ],
    icon_name="build",
)
