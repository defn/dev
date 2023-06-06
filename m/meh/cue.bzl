"""
"""

def _cue_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)
    input_paths = [c.path for c in ctx.files.srcs]

    ctx.actions.run(
        arguments = ["-c", "{} export --out=json -e {} {} > {}".format(
            "/nix/store/b9k9jniljz0ifn5l3nfs5cz6vlh96i43-pkg-cue-0.5.0-7/bin/cue",
            ctx.attr.expr,
            " ".join(input_paths),
            out.path,
        )],
        executable = "/bin/bash",
        inputs = ctx.files.srcs,
        outputs = [out],
    )

    return [DefaultInfo(files = depset([out]))]

cue = rule(
    implementation = _cue_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".cue"]),
        "expr": attr.string(default = ""),
    },
)
