{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    rustdev.url = github:defn/dev/pkg-rustdev-0.0.4?dir=m/pkg/rustdev;
  };

  outputs = inputs: inputs.pkg.venvMain rec {
    src = builtins.path { path = ./.; name = "prefect"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          inputs.rustdev.defaultPackage.${ctx.system}
        ];
    };
  };
}
