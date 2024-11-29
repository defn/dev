"""
"""

def _tutorial_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)

    cue_inputs = [c.path for c in ctx.files.srcs] + [c.path for c in ctx.files.deps]

    cue_bin = ctx.files.cue_bin[0].path

    ctx.actions.run(
        arguments = ["-c", "export XDG_CACHE_HOME=/tmp HOME=/home/ubuntu; find . -name '*.cue' | while read -r a; do rsync -iaL $a $a.tmp; rm -f $a; mv $a.tmp $a; done; {} eval --out json -e html {} | jq -r . > {}".format(
            cue_bin,
            " ".join(cue_inputs),
            out.path,
        )],
        executable = ctx.attr.shell,
        inputs = ctx.files.cue_bin + ctx.files.srcs + ctx.files.deps,
        outputs = [out],
    )

    return [DefaultInfo(files = depset([out]))]

tutorial = rule(
    implementation = _tutorial_impl,
    attrs = {
        "cue_bin": attr.label_list(default = ["//pkg/cue:flake_cue"]),
        "deps": attr.label_list(default = ["//:tutorial_cue"]),
        "shell": attr.string(default = "/bin/bash"),
        "srcs": attr.label_list(allow_files = [".cue"]),
    },
)
