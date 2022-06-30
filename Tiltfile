analytics_settings(False)

load("ext://uibutton", "cmd_button", "location")

allow_k8s_contexts("pod")

update_settings(max_parallel_updates=20)

local_resource(
    name="registry pod",
    serve_cmd="exec socat TCP-LISTEN:5000,fork,reuseaddr TCP:k3d-registry:5000",
    allow_parallel=True,
    labels=["tunnels"],
)

local_resource(
    name="registry buildkitd",
    serve_cmd="""
        earthly bootstrap;
        docker exec earthly-buildkitd apk add socat || true;
        docker exec earthly-buildkitd pkill socat;
        rm -f /home/ubuntu/.registry.txt;
        ip=`host host.k3d.internal | cut -d\\  -f4`;
        exec docker exec earthly-buildkitd socat TCP-LISTEN:5000,fork,reuseaddr TCP:${ip}:5000
    """,
    allow_parallel=True,
    deps=["/home/ubuntu/.registry.txt"],
    labels=["tunnels"],
)

local_resource(
    "dev",
    cmd='if argocd --kube-context argocd app diff dev --local k/dev; then echo No difference; fi',
    deps=["k/dev"],
    allow_parallel=True,
    labels=["deploy"],
)

cmd_button(
    name="sync dev",
    resource="dev",
    argv=[
        "bash",
        "-c",
        "argocd --kube-context argocd app sync dev --local k/dev --assumeYes --prune; touch k/dev/main.yaml",
    ],
    icon_name="build",
)

local_resource(
    "shell-operator",
    cmd="""
        for a in hooks/*; do
            echo "$a"
            default cp -c shell-operator "./$a" dev-0:/home/ubuntu/hooks/
        done
        default exec dev-0 -c shell-operator -- /restart.sh
        echo restarted shell-operator
    """,
    deps=["hooks/"],
    allow_parallel=True,
    labels=["deploy"],
)


local_resource(
    "argocd",
    cmd='if argocd --kube-context argocd app diff argocd --local k/argocd; then echo No difference; fi',
    deps=["k/argocd"],
    allow_parallel=True,
    labels=["deploy"],
)

cmd_button(
    name="sync argocd",
    resource="argocd",
    argv=[
        "bash",
        "-c",
        "argocd --kube-context argocd app sync argocd --local k/argocd --assumeYes --prune; touch k/argocd/main.yaml",
    ],
    icon_name="build",
)

local_resource(
    "traefik",
    cmd='if argocd --kube-context argocd app diff traefik --local k/traefik; then echo No difference; fi',
    deps=["k/traefik"],
    allow_parallel=True,
    labels=["deploy"],
)

cmd_button(
    name="sync traefik",
    resource="traefik",
    argv=[
        "bash",
        "-c",
        "argocd --kube-context argocd app sync traefik --local k/traefik --assumeYes --prune; touch k/traefik/main.yaml",
    ],
    icon_name="build",
)

local_resource(
    "loft",
    cmd='if argocd --kube-context argocd app diff loft --local k/loft; then loft login https://loft.loft.svc.cluster.local --insecure --access-key admin; echo No difference; fi',
    deps=["k/loft"],
    allow_parallel=True,
    labels=["deploy"],
)

cmd_button(
    name="sync loft",
    resource="loft",
    argv=[
        "bash",
        "-c",
        "argocd --kube-context argocd app sync loft --local k/loft --assumeYes --prune; touch k/loft/main.yaml",
    ],
    icon_name="build",
)

cmd_button(
    name="sync ingress",
    resource="ingress",
    argv=[
        "bash",
        "-c",
        """
            argocd --kube-context argocd app sync ingress --local k/ingress --assumeYes --prune;
            touch k/ingress/main.yaml
        """,
    ],
    icon_name="build",
)

local_resource(
    "ingress",
    cmd="""
        if argocd --kube-context argocd app diff ingress --local k/ingress; then
            echo No difference;
        fi
    """,
    deps=["k/ingress"],
    allow_parallel=True,
    labels=["deploy"],
)

for vid in [1,2,3]:
    vname = 'vc' + str(vid)
    local_resource(
        vname,
        cmd='if argocd --kube-context argocd app diff {vname} --local k/{vname}; then echo No difference; fi'.format(vname=vname),
        deps=["k/" + vname],
        allow_parallel=True,
        labels=["deploy"],
    )

    cmd_button(
        name="sync " + vname,
        resource=vname,
        argv=[
            "bash",
            "-c",
            """
                set -x;
                {vname} get ns;
                ~/bin/e env KUBECONFIG=$KUBECONFIG_ALL argocd cluster add loft-vcluster_{vname}_{vname}_loft-cluster --name {vname} --yes;
                argocd --kube-context argocd app create {vname} --repo https://github.com/defn/dev --path k/{vname} --dest-namespace default --dest-name {vname} --directory-recurse --validate=false;
                argocd --kube-context argocd app sync {vname} --local k/{vname} --assumeYes --prune; touch k/{vname}/main.yaml
            """.format(vname=vname),
        ],
        icon_name="build",
    )
