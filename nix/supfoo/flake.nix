{
  description = "using sup, foo";

  inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs";
     flake-utils.url = "github:numtide/flake-utils";
     fooPkg.url = "path:../foo";
     supPkg.url = "path:../sup";
  };

  outputs = { self, nixpkgs, fooPkg, supPkg, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let pkgs = nixpkgs.legacyPackages.${system};
          foo = fooPkg.defaultPackage.${system};
          sup = supPkg.defaultPackage.${system};
          lib = nixpkgs.lib;

      in {
        devShell = pkgs.mkShell rec {
          buildInputs = [
            foo
            sup
          ];
        };
      });
}
