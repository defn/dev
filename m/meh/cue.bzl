"""
"""

def _cue_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)
    input_paths = [c.path for c in ctx.files.srcs]

    ctx.actions.run(
        arguments = ["-c", "{} export --out=json {} {} > {}".format(
            ctx.attr.cue,
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
        "configs": attr.label_list(),
        "cue": attr.string(),
        "expr": attr.string(default = ""),
        "srcs": attr.label_list(allow_files = [".cue"]),
    },
)
