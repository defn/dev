{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
    cue.url = github:defn/dev/pkg-cue-0.7.1-1?dir=m/pkg/cue;
    terraform.url = github:defn/dev/pkg-terraform-1.7.4-1?dir=m/pkg/terraform;
    awscli.url = github:defn/dev/pkg-awscli-2.15.27-1?dir=m/pkg/awscli;
    latest.url = github:NixOS/nixpkgs?rev=87cc06983c14876bb56a6a84935d1a3968f35999;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-demo"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          direnv
          git
          gnumake
          aws-vault

          perl
          go
          nodejs_20

          inputs.cue.defaultPackage.${ctx.system}
          inputs.terraform.defaultPackage.${ctx.system}
          inputs.awscli.defaultPackage.${ctx.system}

          bashInteractive
        ];
    };
  };
}
