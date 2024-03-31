{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
    cue.url = github:defn/dev/pkg-cue-0.8.0-1?dir=m/pkg/cue;
    cloud.url = github:defn/dev/pkg-cloud-0.0.248?dir=m/pkg/cloud;
    latest.url = github:NixOS/nixpkgs?rev=87cc06983c14876bb56a6a84935d1a3968f35999;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-demo"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          direnv
          git
          git-lfs
          gnumake
          aws-vault
          bat
          jq

          perl
          go
          nodejs_20
          (python3.withPackages (ps: with ps; [ pipx ]))

          inputs.cue.defaultPackage.${ctx.system}
          inputs.cloud.defaultPackage.${ctx.system}

          bashInteractive
        ];
    };
  };
}
