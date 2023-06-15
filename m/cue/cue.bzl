"""
"""

def _cue_export_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)

    cue_inputs = [c.path for c in ctx.files.cues]

    cue_bin = ctx.files.srcs[0].path

    ctx.actions.run(
        arguments = ["-c", "{} export --out={} {} {} > {}".format(
            cue_bin,
            ctx.attr.format,
            ctx.attr.expr,
            " ".join(cue_inputs),
            out.path,
        )],
        executable = ctx.attr.shell,
        inputs = ctx.files.srcs + ctx.files.cues,
        outputs = [out],
    )

    return [DefaultInfo(files = depset([out]))]

cue_export = rule(
    implementation = _cue_export_impl,
    attrs = {
        "cues": attr.label_list(allow_files = [".cue"]),
        "expr": attr.string(default = ""),
        "format": attr.string(default = "json"),
        "shell": attr.string(default = "/bin/bash"),
        "srcs": attr.label_list(),
    },
)
