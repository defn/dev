{
  inputs = {
    pkg.url = github:defn/dev/pkg-pkg-0.0.17?dir=m/pkg/pkg;
    # https://github.com/NixOS/nixpkgs/tree/24.05-pre/pkgs/development/compilers/rust
    # https://github.com/NixOS/nixpkgs/blob/24.05-pre/pkgs/top-level/aliases.nix
    latest.url = github:NixOS/nixpkgs?rev=87cc06983c14876bb56a6a84935d1a3968f35999;
  };

  outputs = inputs: inputs.pkg.main rec {
    src = builtins.path { path = ./.; name = "pkg-rustdev"; };

    defaultPackage = ctx: ctx.wrap.nullBuilder {
      propagatedBuildInputs =
        with (import inputs.latest { system = ctx.system; }); [
          rustc
          cargo
        ];
    };
  };
}
