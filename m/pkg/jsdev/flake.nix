{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.15?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/tree/24.05-pre/pkgs/development/web/nodejs
    # https://github.com/NixOS/nixpkgs/blob/24.05-pre/pkgs/top-level/aliases.nix
    latest.url = github:NixOS/nixpkgs?rev=b013b3ee50cace81104bc29b8fc4496a3093b5cd;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-jsdev"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          nodejs_20
        ];
    };
  };
}
