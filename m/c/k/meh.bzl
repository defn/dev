"""
"""

def meh(name, cluster_bundles, by_cluster):
    return [
        [
            native.genrule(
                name = "kustomize_bundle_tgz_{}".format(k),
                srcs = [
                    "//c/{}:config".format(c),
                ],
                outs = ["kustomize_bundle.tgz_{}".format(k)],
                cmd = "$(location //c:gen_kustomize_bundle_sh) config=$(location //c/{}:config) decode=$(location //c:decode_base64_py) prefix={}/ $@".format(
                    c,
                    k,
                ),
                tools = [
                    "//b/lib:lib_sh",
                    "//c:decode_base64_py",
                    "//c:gen_kustomize_bundle_sh",
                ],
                visibility = ["//visibility:public"],
            ),
        ]
        for k, _ in cluster_bundles
        for c in ["-".join(k.split("-")[:3])]
    ] + [
        [
            native.genrule(
                name = "kustomize_build_{}".format(k),
                srcs = app_bundle + [
                    ":kustomize_bundle_tgz_{}".format(k),
                ],
                outs = ["{}-kustomized-build.yaml".format(k)],
                cmd = "$(location //c/k:gen_kustomize_build_sh) app={} bundle=$(location :kustomize_bundle_tgz_{}) kustomize=$(location //pkg/kustomize:flake_kustomize) $@".format(
                    k,
                    k,
                ),
                tools = [
                    "//c/k:gen_kustomize_build_sh",
                    "//b/lib:lib_sh",
                    "//pkg/kustomize:flake_kustomize",
                ],
            ),
            native.genrule(
                name = "cue_import_{}".format(k),
                srcs = [":kustomize_build_{}".format(k)],
                outs = ["{}.cue".format(k)],
                cmd = "$(location //c/k:gen_cue_import_sh) app=$(location :kustomize_build_{}) $@".format(k),
                tools = [
                    "//c/k:gen_cue_import_sh",
                    "//b/lib:lib_sh",
                ],
            ),
            native.genrule(
                name = "image_digest_{}".format(k),
                srcs = [
                    ":cue_import_{}".format(k),
                    ":deploy_cue",
                ],
                outs = ["image_digest_{}.cue".format(k)],
                cmd = "$(location //c/k:gen_image_digest_sh) app=$(location :cue_import_{}) cue=$(location //pkg/cue:flake_cue) $@".format(k),
                tools = [
                    "//c/k:gen_image_digest_sh",
                    "//b/lib:lib_sh",
                    "//pkg/cue:flake_cue",
                ],
            ),
            native.genrule(
                name = "deploy_yaml_{}".format(k),
                srcs = [
                    ":cue_import_{}".format(k),
                    ":image_digest_{}".format(k),
                    ":deploy_cue",
                ] + [
                    "push_helm_chart_{}".format(k)
                    for k in by_cluster[c]
                    if not k.endswith("-env")
                ],
                outs = ["{}.yaml".format(k)],
                cmd = "$(location //c/k:gen_env_yaml_sh) cue=$(location //pkg/cue:flake_cue) _ $(location :cue_import_{}) $(location :image_digest_{}) $@ {}".format(
                    k,
                    k,
                    " ".join([
                        "$(location push_helm_chart_{})".format(k)
                        for k in by_cluster[c]
                        if not k.endswith("-env")
                    ]),
                ),
                tools = [
                    "//c/k:gen_env_yaml_sh",
                    "//b/lib:lib_sh",
                    "//pkg/cue:flake_cue",
                ],
            ) if k.endswith("-env") else native.genrule(
                name = "deploy_yaml_{}".format(k),
                srcs = [
                    ":cue_import_{}".format(k),
                    ":image_digest_{}".format(k),
                    ":deploy_cue",
                ],
                outs = ["{}.yaml".format(k)],
                cmd = "$(location //c/k:gen_deploy_yaml_sh) cue=$(location //pkg/cue:flake_cue) registry=cache.defn.run:4999 _ $(location :cue_import_{}) $(location :image_digest_{}) $@".format(k, k),
                tools = [
                    "//c/k:gen_deploy_yaml_sh",
                    "//b/lib:lib_sh",
                    "//pkg/cue:flake_cue",
                ],
            ),
            native.genrule(
                name = "helm_chart_{}".format(k),
                srcs = [
                    ":deploy_yaml_{}".format(k),
                ],
                outs = ["{}-chart.tgz".format(k)],
                cmd = "$(location //c/k:gen_helm_chart_sh) app=$(location :deploy_yaml_{}) $@".format(k),
                tools = [
                    "//c/k:gen_helm_chart_sh",
                    "//b/lib:lib_sh",
                ],
            ),
            native.genrule(
                name = "push_helm_chart_{}".format(k),
                srcs = [
                    ":helm_chart_{}".format(k),
                ],
                outs = ["{}-deploy-chart.tgz".format(k)],
                cmd = "$(location //c/k:gen_push_helm_chart_sh) app=$(location :helm_chart_{}) registry=cache.defn.run:4999/library/helm name={} $@".format(k, k),
                tools = [
                    "//c/k:gen_push_helm_chart_sh",
                    "//b/lib:lib_sh",
                ],
            ),
        ]
        for k, app_bundle in cluster_bundles
        for c in ["-".join(k.split("-")[:3])]
    ] + [
        [
            native.genrule(
                name = "deploy_crd_{}".format(c),
                srcs = [
                    "deploy_cue",
                ] + [
                    "cue_import_{}".format(k)
                    for k, _ in cluster_bundles
                    if k.startswith("{}-".format(c))
                ],
                outs = ["{}-crd.yaml".format(c)],
                cmd = "$(location //c/k:gen_deploy_crd_sh) $@ {}".format(
                    " ".join([
                        "$(location cue_import_{})".format(k)
                        for k, _ in cluster_bundles
                        if k.startswith("{}-".format(c))
                    ]),
                ),
                tools = [
                    "//c/k:gen_deploy_crd_sh",
                    "//b/lib:lib_sh",
                ],
            ),
            native.filegroup(
                name = c,
                srcs = [
                    "push_helm_chart_{}".format(k)
                    for k, _ in cluster_bundles
                    if k.startswith("{}-".format(c))
                ],
                visibility = ["//visibility:public"],
            ),
        ]
        for c in list(by_cluster.keys())
    ]
