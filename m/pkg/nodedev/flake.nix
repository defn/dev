{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/commits/release-22.11
    latest.url = github:NixOS/nixpkgs?rev=ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          bashInteractive
          nodejs-18_x
        ];
    };
  };
}
