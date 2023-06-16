{
  inputs = {
    earthly.url = github:defn/dev/pkg-earthly-0.7.8-1?dir=m/pkg/earthly;
  };

  outputs = inputs: inputs.earthly.inputs.pkg.main rec {
    src = ./.;

    packages = ctx: rec {
      devShell = ctx: ctx.wrap.devShell {
        devInputs = [
          (defaultPackage ctx)
        ];
      };
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = [
        inputs.earthly.defaultPackage.${ctx.system}
      ];
    };
  };
}
