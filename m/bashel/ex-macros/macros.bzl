"""Example macros that wrap bash scripts using lib.sh"""

def archive_directory(name, dir, prefix = None, visibility = None):
    """Creates a tarball from a directory.

    Args:
        name: Name of the output archive target
        dir: Directory to archive (filegroup or genrule)
        prefix: Prefix for files in archive (default: archive)
        visibility: Target visibility
    """
    script = Label("//bashel/ex-macros:create_archive_sh")

    prefix_arg = "prefix={}".format(prefix) if prefix else "prefix=archive"

    native.genrule(
        name = name,
        tools = [
            script,
            "//b/lib:lib_sh",
        ],
        srcs = [dir],
        outs = ["{}.tar.gz".format(name)],
        cmd = "$(location {}) {} $@ $(locations {})".format(
            script,
            prefix_arg,
            dir,
        ),
        visibility = visibility,
    )

def archive_info(name, archive, visibility = None):
    """Generates metadata about a tarball.

    Args:
        name: Name of the output info target
        archive: Archive file to inspect
        visibility: Target visibility
    """
    script = Label("//bashel/ex-macros:list_archive_sh")

    native.genrule(
        name = name,
        tools = [
            script,
            "//b/lib:lib_sh",
        ],
        srcs = [archive],
        outs = ["{}.txt".format(name)],
        cmd = "$(location {}) archive=$(location {}) $@".format(
            script,
            archive,
        ),
        visibility = visibility,
    )
