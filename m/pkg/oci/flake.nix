{
  inputs = {
    pkg.url = github:defn/m/pkg-pkg-0.0.6?dir=pkg/pkg;
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
