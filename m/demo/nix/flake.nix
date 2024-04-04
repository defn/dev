{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
    cue.url = github:defn/dev/pkg-cue-0.8.1-1?dir=m/pkg/cue;
    cloud.url = github:defn/dev/pkg-cloud-0.0.248?dir=m/pkg/cloud;
    godev.url = github:defn/dev/pkg-godev-0.0.138?dir=m/pkg/godev;
    jsdev.url = github:defn/dev/pkg-jsdev-0.0.68?dir=m/pkg/jsdev;
    pydev.url = github:defn/dev/pkg-pydev-0.0.128?dir=m/pkg/pydev;
    secrets.url = github:defn/dev/pkg-secrets-0.0.81?dir=m/pkg/secrets;
    shell.url = github:defn/dev/pkg-shell-0.0.68?dir=m/pkg/shell;
    latest.url = github:NixOS/nixpkgs?rev=87cc06983c14876bb56a6a84935d1a3968f35999;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-demo"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          inputs.cue.defaultPackage.${ctx.system}
          inputs.cloud.defaultPackage.${ctx.system}
          inputs.godev.defaultPackage.${ctx.system}
          inputs.jsdev.defaultPackage.${ctx.system}
          inputs.pydev.defaultPackage.${ctx.system}
          inputs.secrets.defaultPackage.${ctx.system}
          inputs.shell.defaultPackage.${ctx.system}
        ];
    };
  };
}
