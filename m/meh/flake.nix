{
  inputs = {
    cue.url = github:defn/dev/pkg-cue-0.5.0-7?dir=m/pkg/cue;
    awscli.url = github:defn/dev/pkg-awscli-2.11.27-1?dir=m/pkg/awscli;
    earthly.url = github:defn/dev/pkg-earthly-0.7.8-1?dir=m/pkg/earthly;
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
        inputs.awscli.defaultPackage.${ctx.system}
        inputs.earthly.defaultPackage.${ctx.system}
      ];
    };
  };
}
