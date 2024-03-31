{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/web/nodejs
    latest.url = github:NixOS/nixpkgs?rev=b5e930a583294d194f3ba807283552b25f8a2888;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-jsdev"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          # ghost doesn't support 20
          nodejs_18
        ];
    };
  };
}
