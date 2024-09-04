{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/tree/master/pkgs/development/web/nodejs
    latest.url = github:NixOS/nixpkgs?rev=24536bf02cd9b199fdca550ba7e4f53b9a94119a;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-jsdev"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          # ghost doesn't support 20
          nodejs_20
        ];
    };
  };
}
