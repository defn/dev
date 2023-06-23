{
  inputs = {
    earthly.url = github:defn/dev/pkg-earthly-0.7.9-1?dir=m/pkg/earthly;
  };

  outputs = inputs: inputs.earthly.inputs.pkg.main rec {
    src = ./.;

    packages = ctx: rec {
      devShell = ctx: ctx.wrap.devShell {
        devInputs = [
          inputs.earthly.defaultPackage.${ctx.system}
          (defaultPackage ctx)
        ];
      };
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = [
      ];
    };
  };
}
