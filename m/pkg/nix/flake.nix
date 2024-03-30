{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.16?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/package-management/nix/default.nix
    latest.url = github:NixOS/nixpkgs?rev=d2657c4a3dfc42c13e13243161b31e6bbdfac36e;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-nix"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          direnv
          nixUnstable
          nix-direnv
          nixpkgs-fmt
        ];
    };
  };
}
