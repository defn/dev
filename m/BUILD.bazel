load("@bazel_gazelle//:def.bzl", "gazelle", "gazelle_binary")

gazelle_binary(
    name = "gazelle-buf-binary",
    languages = [
        "@bazel_gazelle//language/proto",
        "@rules_buf//gazelle/buf:buf",
    ],
    visibility = ["//visibility:public"],
)

# gazelle:prefix github.com/defn/dev/m
gazelle(name = "gazelle")

gazelle(
    name = "gazelle-buf",
    gazelle = ":gazelle-buf-binary",
)

gazelle(
    name = "gazelle-buf-update-repos",
    args = [
        "--from_file=buf.work.yaml",
        "-to_macro=buf_deps.bzl%buf_deps",
        "-prune",
    ],
    command = "update-repos",
    gazelle = ":gazelle-buf-binary",
)

gazelle(
    name = "gazelle-update-repos",
    args = [
        "--from_file=go.mod",
        "-to_macro=go_deps.bzl%go_deps",
        "-prune",
    ],
    command = "update-repos",
    gazelle = ":gazelle",
)
