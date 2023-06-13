"""
"""

def _cue_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)

    cue_inputs = [c.path for c in ctx.files.srcs]

    cue_bin = "/nix/store/b9k9jniljz0ifn5l3nfs5cz6vlh96i43-pkg-cue-0.5.0-7/bin/cue"

    ctx.actions.run(
        arguments = ["-c", "{} export --out=json {} {} > {}".format(
            cue_bin,
            ctx.attr.expr,
            " ".join(cue_inputs),
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
        "configs": attr.label_list(),
        "expr": attr.string(default = ""),
        "srcs": attr.label_list(allow_files = [".cue"]),
    },
)
