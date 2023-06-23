{
  inputs = {
    cue.url = github:defn/dev/pkg-cue-0.5.0-7?dir=m/pkg/cue;
    awscli.url = github:defn/dev/pkg-awscli-2.12.2-1?dir=m/pkg/awscli;
  };

  outputs = inputs: inputs.cue.inputs.pkg.main rec {
    src = ./.;

    packages = ctx: rec {
      devShell = ctx: ctx.wrap.devShell {
        devInputs = [
          inputs.cue.defaultPackage.${ctx.system}
          (defaultPackage ctx)
        ];
      };
    };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = [
        inputs.awscli.defaultPackage.${ctx.system}
      ];
    };
  };
}
