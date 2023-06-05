filegroup(
    name = "aws_orgs",
    srcs = ["aws_orgs.txt"],
)

filegroup(
    name = "aws_accounts",
    srcs = ["aws_accounts.txt"],
)

filegroup(
    name = "template_org",
    srcs = ["template_org.txt"],
)

filegroup(
    name = "template_account",
    srcs = ["template_account.txt"],
)

filegroup(
    name = "aws_config_script",
    srcs = ["aws_config.sh"],
)

filegroup(
    name = "input_script",
    srcs = ["input.sh"],
)

genrule(
    name = "aws_config",
    srcs = [
        "aws_orgs",
        "aws_accounts",
        "template_org",
        "template_account",
    ],
    outs = ["aws_config.txt"],
    cmd = "$(location aws_config_script) $(location aws_orgs) $(location aws_accounts) $(location template_org) $(location template_account) $@",
    tools = ["aws_config_script"],
)
