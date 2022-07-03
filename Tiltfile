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

# Set up site specific configuration after loft is available
local_resource(
    "site",
    cmd="""
        cd;
        if argocd --kube-context argocd app diff site --local k/site; then loft login https://loft.loft.svc.cluster.local --insecure --access-key admin;
        echo No difference; fi
    """,
    deps=["k/site"],
    allow_parallel=True,
    labels=["deploy"],
)

cmd_button(
    name="sync site",
    resource="site",
    argv=[
        "bash",
        "-c",
        """
            cd;
            argocd --kube-context argocd app create site --repo https://github.com/defn/dev --path k/site --dest-namespace default --dest-name in-cluster --directory-recurse --validate=false;
            argocd --kube-context argocd app sync site --local k/site --assumeYes --prune;
            argocd --kube-context argocd app wait site;
            touch k/site/main.yaml;
        """,
    ],
    icon_name="build",
)

for vname in ["vc1", "vc2", "vc3"]:
    cmd_button(
        name="sleep " + vname,
        resource="site",
        argv=[
            "bash",
            "-c",
            """
                cd;
                loft sleep --prevent-wakeup 0 {vname}
            """.format(
                vname=vname
            ),
        ],
        icon_name="build",
    )
    cmd_button(
        name="wakeup " + vname,
        resource="site",
        argv=[
            "bash",
            "-c",
            """
                cd;
                loft wakeup {vname}
            """.format(
                vname=vname
            ),
        ],
        icon_name="build",
    )

# Setup kuma
for kname, vname in [
    ("vc1-kuma-global", "vc1"),
    ("vc2-kuma-remote", "vc2"),
    ("vc3-kuma-remote", "vc3"),
]:
    local_resource(
        kname,
        cmd="""
            cd;
            if argocd --kube-context argocd app diff {kname} --local k/{kname}; then echo No difference; fi
        """.format(
            vname=vname, kname=kname
        ),
        deps=["k/" + kname],
        allow_parallel=True,
        labels=["deploy"],
    )

    cmd_button(
        name="sync " + kname,
        resource=kname,
        argv=[
            "bash",
            "-c",
            """
                cd;
                {vname} get ns;
                ~/bin/e env KUBECONFIG=$KUBECONFIG_ALL argocd cluster add loft-vcluster_{vname}_{vname}_loft-cluster --name {vname} --yes;
                argocd --kube-context argocd app create {kname} --repo https://github.com/defn/dev --path k/{kname} --dest-namespace default --dest-name {vname} --directory-recurse --validate=false;
                argocd --kube-context argocd app sync {kname} --local k/{kname} --assumeYes --prune;
                argocd --kube-context argocd app wait {kname};
                touch k/{kname}/main.yaml;
            """.format(
                vname=vname, kname=kname
            ),
        ],
        icon_name="build",
    )
    cmd_button(
        name="delete" + kname,
        resource=kname,
        argv=[
            "bash",
            "-c",
            """
                cd;
                argocd --kube-context argocd app delete --yes {kname};
            """.format(
                vname=vname, kname=kname
            ),
        ],
        icon_name="build",
    )

# Setup applications
for kname, vname in [
    ("vc1-vault", "vc1"),
]:
    local_resource(
        kname,
        cmd="""
            cd;
            if argocd --kube-context argocd app diff {kname} --local k/{kname}; then echo No difference; fi;
        """.format(
            vname=vname, kname=kname
        ),
        deps=["k/" + kname],
        allow_parallel=True,
        labels=["deploy"],
    )

    cmd_button(
        name="sync " + kname,
        resource=kname,
        argv=[
            "bash",
            "-c",
            """
                cd;
                kubectl --context argocd apply -f k/{kname}-application.yaml;
                argocd --kube-context argocd app sync {kname} --local k/{kname} --assumeYes --prune;
                argocd --kube-context argocd app wait {kname};
                touch k/{kname}/main.yaml ;
            """.format(
                vname=vname, kname=kname
            ),
        ],
        icon_name="build",
    )

    cmd_button(
        name="delete " + kname,
        resource=kname,
        argv=[
            "bash",
            "-c",
            """
                cd;
                argocd --kube-context argocd app delete --yes {kname};
            """.format(
                vname=vname, kname=kname
            ),
        ],
        icon_name="build",
    )

for kname, vname in [
    ("vc1-kuma-demo-global", "vc1"),
    ("vc2-kuma-demo-app", "vc2"),
    ("vc3-kuma-demo-app", "vc3"),
]:
    local_resource(
        kname,
        cmd="""
            cd;
            if argocd --kube-context argocd app diff {kname} --local k/{kname}; then echo No difference; fi;
        """.format(
            vname=vname, kname=kname
        ),
        deps=["k/" + kname],
        allow_parallel=True,
        labels=["deploy"],
    )

    cmd_button(
        name="sync " + kname,
        resource=kname,
        argv=[
            "bash",
            "-c",
            """
                cd;
                argocd --kube-context argocd app create {kname} --repo https://github.com/defn/dev --path k/{kname} --dest-namespace default --dest-name {vname} --directory-recurse --validate=false;
                argocd --kube-context argocd app sync {kname} --local k/{kname} --assumeYes --prune;
                argocd --kube-context argocd app wait {kname};
                touch k/{kname}/main.yaml ;
            """.format(
                vname=vname, kname=kname
            ),
        ],
        icon_name="build",
    )

    cmd_button(
        name="delete " + kname,
        resource=kname,
        argv=[
            "bash",
            "-c",
            """
                cd;
                argocd --kube-context argocd app delete --yes {kname};
            """.format(
                vname=vname, kname=kname
            ),
        ],
        icon_name="build",
    )
