analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

allow_k8s_contexts("pod")

local_resource(
    "argocd",
    cmd='echo; argocd app sync argocd --local k/argocd --preview-changes --dry-run --assumeYes 2>/dev/null | awk "/Previewing/ {flag=1;next} /^TIMESTAMP/ {flag=0} flag"; echo',
    deps=["k/argocd"],
)

cmd_button(
    name="sync",
    resource="argocd",
    argv=[
        "bash",
        "-c",
        "argocd app sync argocd --local k/argocd --assumeYes; touch k/argocd/main.yaml",
    ],
    icon_name="build",
)

local_resource(
    name="ui",
    serve_cmd="kubectl -n argocd port-forward svc/argocd-server -n argocd 8080:443",
)
