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
    name="shell-operator",
    serve_cmd="""
        sudo install -d -m 0700 -o ubuntu -g ubuntu /var/run/shell-operator /tmp/shell-operator
        exec /shell-operator start --listen-port=9116
    """,
    allow_parallel=True,
    deps=["hooks"],
    labels=["automation"],
)

local_resource(
    name="make updates",
    serve_cmd="""
        git push
        cd work/dev && make updates
    """,
    allow_parallel=True,
    labels=["automation"],
)

local_resource(
    "dev",
    cmd="if argocd --kube-context argocd app diff dev --local k/dev; then echo No difference; fi",
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
    "argocd",
    cmd="if argocd --kube-context argocd app diff argocd --local k/argocd; then echo No difference; fi",
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
    cmd="if argocd --kube-context argocd app diff traefik --local k/traefik; then echo No difference; fi",
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
    cmd="if argocd --kube-context argocd app diff loft --local k/loft; then echo No difference; fi",
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

local_resource(
    "vc",
    cmd="if argocd --kube-context argocd app diff vc --local k/vc; then loft login https://loft.loft.svc.cluster.local --insecure --access-key admin; echo No difference; fi",
    deps=["k/vc"],
    allow_parallel=True,
    labels=["deploy"],
)

cmd_button(
    name="sync vc",
    resource="vc",
    argv=[
        "bash",
        "-c",
        "argocd --kube-context argocd app sync vc --local k/vc --assumeYes --prune; touch k/vc/main.yaml",
    ],
    icon_name="build",
)

for vid in [1, 2, 3]:
    vname = "vc" + str(vid)
    local_resource(
        vname,
        cmd="if argocd --kube-context argocd app diff {vname} --local k/{vname}; then echo No difference; fi".format(
            vname=vname
        ),
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
            """.format(
                vname=vname
            ),
        ],
        icon_name="build",
    )

for a, dest in [
    ("kuma-demo-global", "vc1"),
    ("kuma-demo-vc2", "vc2"),
    ("kuma-demo-vc3", "vc3"),
]:
    local_resource(
        a,
        cmd="if argocd --kube-context argocd app diff {a} --local k/{a}; then echo No difference; fi".format(
            a=a
        ),
        deps=["k/" + a],
        allow_parallel=True,
        labels=["deploy"],
    )

    cmd_button(
        name="sync " + a,
        resource=a,
        argv=[
            "bash",
            "-c",
            """
                set -x;
                argocd --kube-context argocd app create {a} --repo https://github.com/defn/dev --path k/{a} --dest-namespace default --dest-name {dest} --directory-recurse --validate=false;
                argocd --kube-context argocd app sync {a} --local k/{a} --assumeYes --prune; touch k/{a}/main.yaml
            """.format(
                a=a, dest=dest
            ),
        ],
        icon_name="build",
    )
