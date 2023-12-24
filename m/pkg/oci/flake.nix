{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.14?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with ctx.pkgs; [
        docker
        docker-credential-helpers
        skopeo
        dive
      ];
    };
  };
}
