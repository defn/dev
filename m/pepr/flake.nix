{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    jsdev.url = github:defn/dev/pkg-jsdev-0.0.70?dir=m/pkg/jsdev;
  };

  outputs = inputs: inputs.pkg.venvMain rec {
    src = builtins.path { path = ./.; name = "pepr"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          inputs.jsdev.defaultPackage.${ctx.system}
        ];
    };
  };
}
