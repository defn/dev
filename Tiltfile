include("Tiltfile.common")

load("Tiltfile.common", "dummy_ip", "dummy_host")

load("ext://uibutton", "cmd_button", "location")

# defn/dev
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
    name="push updates",
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

cmd_button(
    name="yolo",
    resource="make updates",
    argv=[
        "bash",
        "-c",
        """
            set -x; cd;
            git push;
            (cd work/dev && git pull && exec make images);
            (cd work/dev && git pull && exec make updates);
            kubectl --context pod delete pod/dev-0;
        """,
    ],
    icon_name="build",
)

cmd_button(
    name="yolo2",
    resource="make updates",
    argv=[
        "bash",
        "-c",
        """
            set -x; cd;
            git push;
            (cd work/dev && git pull && exec make updates);
            kubectl --context pod delete pod/dev-0;
        """,
    ],
    icon_name="build",
)

# demo
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
                touch k/{kname}/kustomization.yaml ;
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

# kuma apps
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
                touch k/{kname}/kustomization.yaml ;
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
