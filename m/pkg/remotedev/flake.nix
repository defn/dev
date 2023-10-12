{
  inputs = {
    coder.url = github:defn/dev/pkg-coder-2.3.0-1?dir=m/pkg/coder;
    codeserver.url = github:defn/dev/pkg-codeserver-4.17.1-1?dir=m/pkg/codeserver;
  };

  outputs = inputs: inputs.coder.inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        let
          flakeInputs = with ctx.pkgs; [
            inputs.coder.defaultPackage.${ctx.system}
            inputs.codeserver.defaultPackage.${ctx.system}
          ];
        in
        flakeInputs;
    };
  };
}
