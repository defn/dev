dummy_host = "crouching.tiger-mamba.ts.net"
dummy_ip = "169.254.32.1"

analytics_settings(False)

include("ext://cancel")
load("ext://uibutton", "cmd_button", "location")

allow_k8s_contexts("pod")

update_settings(max_parallel_updates=20)

cmd_button(
    name="ui argocd",
    text="argocd",
    icon_name="stream",
    resource="argocd",
    argv=[
        "bash",
        "-c",
        """
            kubectl -n argocd get -o json secret argocd-initial-admin-secret | jq -r '.data.password | @base64d' | ssh super pbcopy;
            xdg-open https://{dummy_host}:603;
        """.format(
            domain=dummy_host
        ),
    ],
    location="nav",
)

cmd_button(
    name="ui traefik",
    text="traefik",
    icon_name="traffic",
    resource="traefik",
    argv=[
        "bash",
        "-c",
        """
            xdg-open https://{domain}:605;
        """.format(
            domain=dummy_host
        ),
    ],
    location="nav",
)

cmd_button(
    name="ui vc kuma",
    text="kuma",
    icon_name="rss_feed",
    resource="kuma",
    argv=[
        "bash",
        "-c",
        """
            xdg-open https://{domain}:606/gui;
        """.format(
            domain=dummy_host
        ),
    ],
    location="nav",
)

cmd_button(
    name="ui vc2",
    text="vc2",
    icon_name="signal_cellular_alt_2_bar",
    resource="vc2",
    argv=[
        "bash",
        "-c",
        """
            xdg-open https://{domain}:607;
        """.format(
            domain=dummy_host
        ),
    ],
    location="nav",
)

cmd_button(
    name="ui vc3",
    text="vc3",
    icon_name="signal_cellular_alt",
    resource="vc3",
    argv=[
        "bash",
        "-c",
        """
            xdg-open https://{domain}:608;
        """.format(
            domain=dummy_host
        ),
    ],
    location="nav",
)

cmd_button(
    name="ui loft",
    text="loft",
    resource="loft",
    argv=[
        "bash",
        "-c",
        """
            xdg-open https://{domain}:602;
        """.format(
            domain=dummy_host
        ),
    ],
    location="nav",
)

local_resource(
    name="registry pod",
    serve_cmd="exec socat TCP-LISTEN:5000,fork,reuseaddr TCP:{ip}:5000".format(ip=dummy_ip),
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
        exec docker exec earthly-buildkitd socat TCP-LISTEN:5000,fork,reuseaddr TCP:${ip}:5000;
    """.format(ip=dummy_ip),
    allow_parallel=True,
    deps=["/home/ubuntu/.registry.txt"],
    labels=["tunnels"],
)

local_resource(
    name="shell-operator",
    serve_cmd="""
        sudo install -d -m 0700 -o ubuntu -g ubuntu /var/run/shell-operator /tmp/shell-operator;
        exec /shell-operator start --listen-port=9116;
    """,
    allow_parallel=True,
    deps=["hooks"],
    labels=["automation"],
)

local_resource(
    name="make updates",
    cmd="""
        cd;
        git push;
        cd work/dev && exec make updates;
    """,
    allow_parallel=True,
    labels=["automation"],
    trigger_mode=TRIGGER_MODE_MANUAL,
)

cmd_button(
    name="make images",
    resource="make updates",
    argv=[
        "bash",
        "-c",
        """
            cd;
            git push;
            cd work/dev && exec make images;
        """,
    ],
    icon_name="build",
)

cmd_button(
    name="push images",
    resource="make updates",
    argv=[
        "bash",
        "-c",
        """
            cd;
            git push;
            cd work/dev && exec make images repo= cache=localhost:5000/;
        """,
    ],
    icon_name="build",
)

cmd_button(
    name="push updates",
    resource="make updates",
    argv=[
        "bash",
        "-c",
        """
            cd;
            git push;
            cd work/dev && exec make updates repo= repo_from=localhost:5000/ cache=localhost:5000/;
        """,
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
        """
            argocd --kube-context argocd app sync argocd --local k/argocd --assumeYes --prune; 
            argocd --kube-context argocd app wait argocd;
            touch k/argocd/main.yaml
        """,
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
        """
            argocd --kube-context argocd app sync traefik --local k/traefik --assumeYes --prune; 
            argocd --kube-context argocd app wait traefik;
            touch k/traefik/main.yaml;
        """,
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
        """
            argocd --kube-context argocd app sync loft --local k/loft --assumeYes --prune; 
            argocd --kube-context argocd app wait loft;
            touch k/loft/main.yaml;
        """,
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
        """
            set -x;
            argocd --kube-context argocd app create vc --repo https://github.com/defn/dev --path k/vc --dest-namespace default --dest-name in-cluster --directory-recurse --validate=false;
            argocd --kube-context argocd app sync vc --local k/vc --assumeYes --prune; 
            argocd --kube-context argocd app wait vc;
            touch k/vc/main.yaml;
        """,
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
                argocd --kube-context argocd app sync {vname} --local k/{vname} --assumeYes --prune; 
                argocd --kube-context argocd app wait {vname};
                touch k/{vname}/main.yaml;
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
                argocd --kube-context argocd app sync {a} --local k/{a} --assumeYes --prune;
                argocd --kube-context argocd app wait {a};
                touch k/{a}/main.yaml 
            """.format(
                a=a, dest=dest
            ),
        ],
        icon_name="build",
    )
