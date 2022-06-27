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
    name="hubble port-forward",
    serve_cmd="exec kubectl --context pod -n kube-system port-forward svc/hubble-ui 12000:80",
    allow_parallel=True,
    labels=["tunnels"],
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
    name="argocd port-forward",
    serve_cmd="exec kubectl --context pod -n argocd port-forward svc/argocd-server 8881:443",
    allow_parallel=True,
    labels=["tunnels"],
)

cmd_button(
    name="ui argocd",
    resource="argocd port-forward",
    argv=[
        "bash",
        "-c",
        "kubectl --context pod -n argocd get -o json secret argocd-initial-admin-secret | jq -r '.data.password | @base64d' | ssh super pbcopy; xdg-open http://localhost:8881"
    ],
    icon_name="web",
)

local_resource(
    name="traefik port-forward",
    serve_cmd="""
        exec kubectl --context pod -n traefik port-forward $(kubectl --context pod -n traefik get pod -l app.kubernetes.io/instance=traefik -o name | head -n 1) 9000:9000
    """,
    deps=["k/traefik", "/tmp/restart.txt"],
    allow_parallel=True,
    labels=["tunnels"],
)

cmd_button(
    name="ui traefik",
    resource="traefik port-forward",
    argv=[
        "bash",
        "-c",
        "xdg-open http://localhost:9000/dashboard/",
    ],
    icon_name="web",
)

local_resource(
    name="loft port-forward",
    serve_cmd="exec kubectl --context pod -n loft port-forward svc/loft 8882:443",
    allow_parallel=True,
    labels=["tunnels"],
)

cmd_button(
    name="ui loft",
    resource="loft port-forward",
    argv=[
        "bash",
        "-c",
        "xdg-open https://localhost:8882/vclusters",
    ],
    icon_name="web",
)

local_resource(
    name="tailscale cert",
    serve_cmd="""
        set -x;
        d=$(docker exec tailscale_docker-extension-desktop-extension-service /app/tailscale cert 2>&1 | grep For.domain | cut -d'\"' -f2);
        while true; do
            docker exec tailscale_docker-extension-desktop-extension-service /app/tailscale cert $d;
            docker exec tailscale_docker-extension-desktop-extension-service tar cvfz - $d.crt $d.key > /tmp/$d.tar.gz;
            kubectl --context pod -n traefik delete secret default-certificate;
            bash -c "kubectl --context pod create -n traefik secret generic default-certificate --from-file tls.crt=<(tar xfz /tmp/$d.tar.gz -O $d.crt) --from-file tls.key=<(tar xfz /tmp/$d.tar.gz -O $d.key)";
            touch /tmp/restart.txt;
            date;
            echo http://$d;
            sleep 36000;
        done
    """,
    allow_parallel=True,
    labels=["secrets"],
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
    cmd='if argocd --kube-context argocd app diff loft --local k/loft; then echo No difference; fi',
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
        "kubectl --context pod create ns loft || true; argocd --kube-context argocd app sync loft --local k/loft --assumeYes --prune; touch k/loft/main.yaml",
    ],
    icon_name="build",
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
    "vc",
    cmd="""
        if argocd --kube-context argocd app diff vc --local k/vc; then
            loft login https://loft.loft.svc.cluster.local --insecure --access-key admin;
            echo No difference;
        fi
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
            argocd --kube-context argocd app sync vc --local k/vc --assumeYes --prune;
            loft login https://loft.loft.svc.cluster.local --insecure --access-key admin;
            touch k/vc/main.yaml
        """,
    ],
    icon_name="build",
)

local_resource(
    "shell-operator",
    cmd="""
        for a in hooks/*; do
            echo "$a"
            vc1 cp -c shell-operator "./$a" vc1-0:/hooks/
        done
        vc1 exec vc1-0 -c shell-operator -- /restart.sh 
    """,
    deps=["hooks/"],
    allow_parallel=True,
    labels=["deploy"],
)

for vid in [1,2,3,4,5]:
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
