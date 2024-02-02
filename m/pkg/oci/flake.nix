{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-oci"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs = with ctx.pkgs; [
        docker
        docker-compose
        docker-credential-helpers
        skopeo
        dive
      ];
    };
  };
}
