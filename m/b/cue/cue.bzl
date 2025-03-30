"""
"""

def _cue_export_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)

    cue_inputs = [c.path for c in ctx.files.cues]

    cue_bin = "cue"

    ctx.actions.run(
        arguments = ["-c", "export XDG_CACHE_HOME=/tmp HOME=/home/ubuntu; find . -name '*.cue' | while read -r a; do rsync -iaL $a $a.tmp; rm -f $a; mv $a.tmp $a; done; {} export --out={} {} {} > {}".format(
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
