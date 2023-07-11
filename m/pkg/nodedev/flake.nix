{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.10?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/commits/release-23.05
    latest.url = github:NixOS/nixpkgs?rev=5c9ddb86679c400d6b7360797b8a22167c2053f8;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = ./.;

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          nodejs-18_x
        ];
    };
  };
}
