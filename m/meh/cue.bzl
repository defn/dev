"""
"""

def _cue_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)

    cue_inputs = [c.path for c in ctx.files.cues]

    cue_bin = ctx.files.srcs[0].path

    ctx.actions.run(
        arguments = ["-c", "{} export --out=json {} {} > {}".format(
            cue_bin,
            ctx.attr.expr,
            " ".join(cue_inputs),
            out.path,
        )],
        executable = "/bin/bash",
        inputs = ctx.files.srcs + ctx.files.cues,
        outputs = [out],
    )

    return [DefaultInfo(files = depset([out]))]

cue = rule(
    implementation = _cue_impl,
    attrs = {
        "cues": attr.label_list(allow_files = [".cue"]),
        "expr": attr.string(default = ""),
        "srcs": attr.label_list(),
    },
)
