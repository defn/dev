{
  inputs = {
    cue.url = github:defn/dev/pkg-cue-0.5.0-7?dir=m/pkg/cue;
  };

  outputs = inputs: inputs.cue.inputs.pkg.main rec {
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
        inputs.cue.defaultPackage.${ctx.system}
      ];
    };
  };
}
