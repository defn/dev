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
            set -x; cd;
            xdg-open https://{domain}:9607;
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
            set -x; cd;
            xdg-open https://{domain}:9608;
        """.format(
            domain=dummy_host
        ),
    ],
    location="nav",
)

local_resource(
    name="make updates",
    cmd="""
        set -x; cd;
        git push;
        cd work/dev && git pull && exec make updates;
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
            set -x; cd;
            git push;
            cd work/dev && git pull && exec make images;
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
            set -x; cd;
            git push;
            cd work/dev && git pull && exec make images repo= cache=localhost:5000/;
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
            set -x; cd;
            git push;
            (cd work/dev && git pull && exec make images);
            (cd work/dev && git pull && exec make updates);
        """,
    ],
    icon_name="build",
)

cmd_button(
    name="yolo",
    resource="make updates",
    argv=[
        "bash",
        "-c",
        """
            set -x; cd;
            git push;
            cd work/dev && git pull && exec make updates repo= repo_from=localhost:5000/ cache=localhost:5000/;
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
            set -x; cd;
            kubectl --context argocd apply -f k/site-application.yaml;
            argocd --kube-context argocd app sync site --local k/site --assumeYes --prune;
            argocd --kube-context argocd app wait site;
            touch k/site/main.yaml;
        """,
    ],
    icon_name="build",
)

# Setup kuma
for kname, vname in [
    ("vc0-kuma-global", "vc0"),
    ("vc1-kuma-remote", "vc1"),
    ("vc2-kuma-remote", "vc2"),
    ("vc3-kuma-remote", "vc3"),
]:
    local_resource(
        kname,
        cmd="""
            set -x; cd;
            if argocd --kube-context argocd app diff {kname} --local k/{kname}; then echo No difference; fi
        """.format(
            vname=vname, kname=kname
        ),
        deps=["k/" + kname],
        allow_parallel=True,
        labels=[vname],
    )

    cmd_button(
        name="sync " + kname,
        resource=kname,
        argv=[
            "bash",
            "-c",
            """
                set -x; cd;
                {vname} get ns;
                ~/bin/e env KUBECONFIG=$KUBECONFIG_ALL argocd cluster add loft-vcluster_{vname}_{vname}_loft-cluster --name {vname} --yes;
                kubectl --context argocd apply -f k/{kname}-application.yaml;
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
        name="delete " + kname,
        resource=kname,
        argv=[
            "bash",
            "-c",
            """
                set -x; cd;
                argocd --kube-context argocd app delete --yes {kname};
            """.format(
                vname=vname, kname=kname
            ),
        ],
        icon_name="build",
    )

for kname, vname in [
    ("vc1-kuma-demo", "vc1"),
    ("vc2-kuma-demo", "vc2"),
    ("vc3-kuma-demo", "vc3"),
]:
    local_resource(
        kname,
        cmd="""
            set -x; cd;
            if argocd --kube-context argocd app diff {kname} --local k/{kname}; then echo No difference; fi;
        """.format(
            vname=vname, kname=kname
        ),
        deps=["k/" + kname],
        allow_parallel=True,
        labels=[vname],
    )

    cmd_button(
        name="sync " + kname,
        resource=kname,
        argv=[
            "bash",
            "-c",
            """
                set -x; cd;
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
                set -x; cd;
                argocd --kube-context argocd app delete --yes {kname};
            """.format(
                vname=vname, kname=kname
            ),
        ],
        icon_name="build",
    )

# Setup applications for demo
for kname, vname in [
    ("vc1-kong", "vc1"),
    ("vc1-vault", "vc1"),
]:
    local_resource(
        kname,
        cmd="""
            set -x; cd;
            if argocd --kube-context argocd app diff {kname} --local k/{kname}; then echo No difference; fi;
        """.format(
            vname=vname, kname=kname
        ),
        deps=["k/" + kname],
        allow_parallel=True,
        labels=[vname],
    )

    cmd_button(
        name="sync " + kname,
        resource=kname,
        argv=[
            "bash",
            "-c",
            """
                set -x; cd;
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
                set -x; cd;
                argocd --kube-context argocd app delete --yes {kname};
            """.format(
                vname=vname, kname=kname
            ),
        ],
        icon_name="build",
    )
