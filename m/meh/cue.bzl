"""
"""

def _cue_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(
        output = out,
        content = "Hello\n",
    )
    return [DefaultInfo(files = depset([out]))]

_cue = rule(
    implementation = _cue_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".cue"]),
    },
)

def cue(name, srcs = [], **kwargs):
    _cue(name = name, srcs = srcs, **kwargs)
