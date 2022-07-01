include("Tiltfile.common")

load("Tiltfile.common", "dummy_ip", "dummy_host")

load("ext://uibutton", "cmd_button", "location")

cmd_button(
    name="ui vc2",
    text="vc2",
    icon_name="signal_cellular_alt_2_bar",
    resource="vc2",
    argv=[
        "bash",
        "-c",
        """
            cd;
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
            cd;
            xdg-open https://{domain}:608;
        """.format(
            domain=dummy_host
        ),
    ],
    location="nav",
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
    "vc",
    cmd="""
        cd;
        if argocd --kube-context argocd app diff vc --local k/vc; then loft login https://loft.loft.svc.cluster.local --insecure --access-key admin;
        echo No difference; fi
    """,
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
            cd;
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
        cmd="""
            cd;
            if argocd --kube-context argocd app diff {vname} --local k/{vname}; then echo No difference; fi
        """.format(
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
                cd;
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
        cmd="""
            cd;
            if argocd --kube-context argocd app diff {a} --local k/{a}; then echo No difference; fi;
        """.format(
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
                cd;
                argocd --kube-context argocd app create {a} --repo https://github.com/defn/dev --path k/{a} --dest-namespace default --dest-name {dest} --directory-recurse --validate=false;
                argocd --kube-context argocd app sync {a} --local k/{a} --assumeYes --prune;
                argocd --kube-context argocd app wait {a};
                touch k/{a}/main.yaml ;
            """.format(
                a=a, dest=dest
            ),
        ],
        icon_name="build",
    )
