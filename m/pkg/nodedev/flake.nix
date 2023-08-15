{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.12?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/commits/release-23.05
    latest.url = github:NixOS/nixpkgs?rev=3fe694c4156b84dac12627685c7ae592a71e2206;
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
